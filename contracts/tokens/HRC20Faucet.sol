pragma solidity >=0.4.21 <0.6.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HRC20Faucet is Ownable {
  IERC20 public token;

  uint256 public amount;
  uint256 public frequency;
	mapping(address => uint256) private lastBlock;

  event funded(uint256 _amount);

  constructor(address _token, uint256 _amount, uint256 _frequency) public {
    require(_token != address(0), "HRC20Faucet: can't set the token address to the zero address");
    token = IERC20(_token);
    amount = _amount;
    frequency = _frequency;
  }

  function fund(address _to) public {
    uint256 currentBlock = block.number;
    require(lastBlock[_to] == 0 || currentBlock - lastBlock[_to] >= frequency, "Address has been funded within the last hour");
    require(balance() > amount, "Not enough token funds in the faucet");
    lastBlock[_to] = currentBlock;
    token.transfer(address(uint160(_to)), amount);
    emit funded(amount);
  }

  function balance() public view returns (uint256) {
    return token.balanceOf(address(this));
  }

  function setAmount(uint256 _amount) public onlyOwner {
    amount = _amount;
  }

  function setFrequency(uint256 _frequency) public onlyOwner {
    frequency = _frequency;
  }
  
}
