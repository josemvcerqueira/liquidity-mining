// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LpToken is ERC20 {
  constructor() ERC20("LpToken", "LTK") {}

  function faucet(address _to, uint _amount) external {
    _mint(_to, _amount);
  }
}