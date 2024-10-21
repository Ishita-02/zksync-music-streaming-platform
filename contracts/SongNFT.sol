// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SongNFT is ERC721URIStorage, Ownable {
    uint256 private _currentTokenId;
    uint256 public nftPrice;
    address public artist;
    string public audioURI;
    uint256 public royaltyBalance;
    string public coverURI;

    struct NFTInfo {
        uint256 nftPrice;
        address artist;
        string audioURI;
        string coverURI;
        uint256 royaltyBalance;
        uint256 currentTokenId;
    }

    uint256 public constant ROYALTY_PERCENTAGE = 30;

    event NFTMinted(uint256 indexed tokenId, address indexed buyer, uint256 price);
    event RoyaltyCollected(uint256 indexed tokenId, uint256 amount);
    event RoyaltyPaid(address indexed artist, uint256 amount);

    modifier onlyMintedUser(address user) {
        require(balanceOf(user) > 0, "Don't own the NFT");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint256 _nftPrice, 
                string memory _audioURI, address _artist, string memory _coverURI) 
                ERC721(_name, _symbol) Ownable(msg.sender) {
        nftPrice = _nftPrice; 
        audioURI = _audioURI; 
        coverURI = _coverURI; 
        artist = _artist;
        _currentTokenId = 0;
    }

    function mintNFT(address _to) external payable returns (uint256) {
        require(msg.value >= nftPrice, "Insufficient payment"); 
        _currentTokenId++;
        uint256 newTokenId = _currentTokenId;

        uint256 royaltyAmount = msg.value * ROYALTY_PERCENTAGE / 100;
        royaltyBalance += royaltyAmount;

        _safeMint(_to, newTokenId);
        _setTokenURI(newTokenId, audioURI);

        emit RoyaltyCollected(newTokenId, royaltyAmount);
        emit NFTMinted(newTokenId, _to, msg.value);

        return newTokenId;
    }

    function payRoyalties() external {
        uint256 amount = royaltyBalance;
        royaltyBalance = 0;

        (bool success, ) = payable(artist).call{value: amount}("");
        require(success, "Royalty payout failed");

        emit RoyaltyPaid(artist, amount);
    }

    function getInfo(address user) external view onlyMintedUser(user) returns (NFTInfo memory)  {
        return NFTInfo({
            nftPrice: nftPrice, 
            artist: artist,
            audioURI: audioURI,
            coverURI: coverURI, 
            royaltyBalance: royaltyBalance,
            currentTokenId: _currentTokenId 
        });
    }
}
