pragma soidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract BonusToken is ERC20 {
    address public adimn;
    address public liquidator;

    constructor() ERC20("BonusToken", "BTK") public {
        admin = msg.sender;
    }

    function setLiquidator(address _liquidator) external {
        require(msg.sender == admin, "Only admin can call");
        liquidator = _liquidator;

    }

    function mint(address _to, uint amount) external {
        require(msg.sender == liquidator, "Only liquidator can call");
        _mint(_to, amount);
    }
}