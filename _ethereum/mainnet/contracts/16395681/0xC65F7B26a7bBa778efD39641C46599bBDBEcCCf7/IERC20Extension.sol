import "./IERC20.sol";

interface IERC20Extension is IERC20 {
    function decimals() external view returns (uint8);
}
