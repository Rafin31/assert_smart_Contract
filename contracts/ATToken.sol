// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ATToken is ERC20, Ownable {
    uint256 public constant MAX_MINT_AMOUNT = 10_000 * 10**18; // Max mint per transaction

    // Events for  tracking
    event TokensMinted(address indexed to, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);

    constructor() ERC20("ASSERT Token", "AT") Ownable(msg.sender) {
        _mint(msg.sender, 100_000 * 10**decimals()); // Initial supply of 100,000 AT tokens
        emit TokensMinted(msg.sender, 100_000 * 10**decimals());
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(amount <= MAX_MINT_AMOUNT, "Mint amount exceeds limit");
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function transferMintedTokens(address recipient, uint256 amount) external onlyOwner {
        uint256 amountWithDecimals = amount * 10**decimals(); // Convert to 18 decimals
        require(balanceOf(owner()) >= amountWithDecimals, "Not enough minted tokens");
        _transfer(owner(), recipient, amountWithDecimals);
        emit TokensTransferred(owner(), recipient, amountWithDecimals);
    }
}
