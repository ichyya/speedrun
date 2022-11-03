pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 numberTokensBought = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, numberTokensBought);
    emit BuyTokens(msg.sender, msg.value, numberTokensBought);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    (bool result,) = msg.sender.call{value: address(this).balance}("");
    require(result, "Failed to send ETH");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    yourToken.transferFrom(msg.sender, address(this), _amount);
    uint256 ethToTransfer = _amount / tokensPerEth;
    (bool result,) = msg.sender.call{value: ethToTransfer}("");
    require(result, "Failed to send ETH");
    emit SellTokens(msg.sender, ethToTransfer, _amount);
  }

}
