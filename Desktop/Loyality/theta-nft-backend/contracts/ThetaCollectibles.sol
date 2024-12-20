// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";  // Strings kütüphanesini import ettik

contract ThetaCollectibles is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    uint256 public transactionThreshold;
    mapping(address => uint256) public userTransactionCount;
    mapping(address => bool) public hasReceivedNFT;

    event NFTMinted(address indexed user, uint256 tokenId);
    event TransactionThresholdUpdated(uint256 newThreshold);

    constructor() ERC721("ThetaCollectibles", "THETA") {
        nextTokenId = 1;
        transactionThreshold = 10; // Default threshold
    }

    function recordTransaction(address user) external onlyOwner {
        require(user != address(0), "Invalid user address");
        userTransactionCount[user]++;

        if (userTransactionCount[user] >= transactionThreshold && !hasReceivedNFT[user]) {
            _mintNFT(user);
        }
    }

    function _mintNFT(address to) internal {
        require(to != address(0), "Invalid address to mint NFT");

        uint256 tokenId = nextTokenId;
        string memory tokenURI = _generateTokenURI(tokenId);
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        hasReceivedNFT[to] = true;

        emit NFTMinted(to, tokenId);
        nextTokenId++;
    }

    function _generateTokenURI(uint256 tokenId) internal pure returns (string memory) {
        return string(abi.encodePacked("https://metadata.theta.com/token/", Strings.toString(tokenId)));
    }

    function updateTransactionThreshold(uint256 newThreshold) external onlyOwner {
        require(newThreshold > 0, "Threshold must be greater than 0");
        transactionThreshold = newThreshold;

        emit TransactionThresholdUpdated(newThreshold);
    }

    function getUserNFTDetails(address user) external view returns (uint256[] memory) {
        require(user != address(0), "Invalid user address");

        uint256 count = balanceOf(user);
        uint256[] memory tokenIds = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(user, i);
        }

        return tokenIds;
    }
}
