// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./UnderlyingToken.sol";
import "./GovernanceToken.sol";
import "./LpToken.sol";

contract LiquidityPool is LpToken {
  mapping(address => uint) public checkpoints;

  UnderlyingToken public underlyingToken;
  GovernanceToken public governanceToken;

  uint constant public REWARD_PER_BLOCK = 1;

  constructor(address _underlyingToken, address _governanceToken) {
    underlyingToken = UnderlyingToken(_underlyingToken);
    governanceToken = GovernanceToken(_governanceToken);
  }

  function deposit(uint _amount) external {
    if (checkpoints[msg.sender] == 0) {
      checkpoints[msg.sender] = block.number;
    }
    _distributeRewards(msg.sender);
    underlyingToken.transferFrom(msg.sender, address(this), _amount);
    _mint(msg.sender, _amount);
  }

  function withdraw(uint _amount) external {
    require(balanceOf(msg.sender) > _amount, "You do not own enough LP tokens");
    _distributeRewards(msg.sender);
    underlyingToken.transfer(msg.sender, _amount);
    _burn(msg.sender, _amount);
  }

  function _distributeRewards(address _beneficiary) private {
    uint checkpoint = checkpoints[_beneficiary];
    if (block.number - checkpoint > 0) {
      uint distributionAmount = balanceOf(_beneficiary) * (block.number - checkpoint) * REWARD_PER_BLOCK;
      checkpoints[_beneficiary] = block.number;
      governanceToken.mint(_beneficiary, distributionAmount);
    }
  }
}