// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ATToken is ERC20, Ownable {
    constructor() ERC20("ASSERT Token", "AT") Ownable(msg.sender) {
        _mint(msg.sender, 1000 * 10**decimals()); // Initial supply with 18 decimal point
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferToken(address recipient, uint256 amount)
        public
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function checkBalance(address account) public view returns (uint256) { // this is to check balance 
        return balanceOf(account);
    }

    function transferMintedTokens(address recipient, uint256 amount)
        external
        onlyOwner
    {
        uint256 amountWithDecimals = amount * 10**decimals(); // Convert to 18 decimals
        require(
            balanceOf(owner()) >= amountWithDecimals,
            "Not enough minted tokens"
        );
        _transfer(owner(), recipient, amountWithDecimals);
    }
}
