pragma soidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./IUniswapV2Pair.sol";
import "./BonusToken.sol";

contract LiquidityMigrator {
    // variables
    IUniswapV2Router02 public router;
    IUniswapV2Pair public pair;
    IUniswapV2Router02 public routerFork;
    IUniswapV2Pair public pairFork;
    BonusToken public bonusToken;
    address public admin;
    bool public migrationDone;

    // mapping to keep track of investor balance
    mapping(address => uint) public investorUnclaimedBalances;

    constructor(address _router, address _pair, address _routerFork, address _pairFork, address _bonusToken) {
        router = _router;
        pair = _pair;
        routerFork = _routerFork;
        pairFork = _pairFork;
        bonusToken = _bonusToken;
        admin = msg.sender;
    }


    function deposit(uint amount) public {
        require(migrationDone == false, "migration already done");

        // approve uniswap pair to spend your Lptokens and then transfer them to this contract
        pair.transferFrom(msg.sender, address(this), amount);
        bonusToken.mint(msg.sender, amount);
        investorUnclaimedBalances[msg.sender] = amount;
    }

    function migrate() external {
        require(msg.sender == admin, "Only admin can call");
        require(migrationDone == false, "Migration already done");

        // get the token addressess to be migrated from the uniswap pair contract
        IERC20 token0 = IERC20(pair.token0());
        IERC20 token1 = IERC20(pair.token1());

        uint totalBalance = pair.balanceOf(address(this));
        router.removeLiquidity(address(token0), address(token1), totalBalance, 0, 0, address(this), block.timestamp);

        uint token0Balance = token0.balanceOf(address(this));
        uint token1Balance = token1.balanceOf(address(this));
        token0.approve(address(routerFork), token0Balance);
        token1.approve(address(routerFork), token1Balance);

        routerFork.addLiquidity(address(token0), address(token1), token0Balance, token1Balance,  token0Balance, token1Balance, address(this), block.timestamp);

        migrationDone = true;

    }

    function claimLpTokens() public {
        require(investorUnclaimedBalances[msg.sender] > 0, "insufficient balance");
        require(migrationDone == true, "migration not done");

        uint amountToSend = investorUnclaimedBalances[msg.sender];
        investorUnclaimedBalances[msg.sender] = 0;
        pairFork.transfer(msg.sender, amountToSend);
    }
}