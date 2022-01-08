pragma solidity >=0.4.21 <0.6.0;

import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UnlimitedAllowanceToken is IERC20 {
  using SafeMath for uint256;

  /* ============ State variables ============ */

  uint256 public totalSupply;
  mapping (address => uint256) public  balances;
  mapping (address => mapping (address => uint256)) public allowed;

  /* ============ Events ============ */

  event Approval(address indexed src, address indexed spender, uint256 amount);
  event Transfer(address indexed src, address indexed dest, uint256 amount);

  /* ============ Constructor ============ */

  constructor () public { }

  /* ============ Public functions ============ */

  function approve(address _spender, uint256 _amount) public returns (bool) {
    allowed[msg.sender][_spender] = _amount;
    emit Approval(msg.sender, _spender, _amount);
    return true;
  }

  function transfer(address _dest, uint256 _amount) public returns (bool) {
    return transferFrom(msg.sender, _dest, _amount);
  }

  function transferFrom(address _src, address _dest, uint256 _amount) public returns (bool) {
    require(balances[_src] >= _amount, "Insufficient user balance");

    if (_src != msg.sender && allowance(_src, msg.sender) != uint256(-1)) {
      require(allowance(_src, msg.sender) >= _amount, "Insufficient user allowance");
      allowed[_src][msg.sender] = allowed[_src][msg.sender].sub(_amount);
    }

    balances[_src] = balances[_src].sub(_amount);
    balances[_dest] = balances[_dest].add(_amount);

    emit Transfer(_src, _dest, _amount);

    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }
}