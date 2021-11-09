// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";


contract nft_market is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  event NewEpicNFTMinted(address sender, uint256 tokenId);


  constructor() ERC721 ("KittyNFT", "ME0W") {
    // console.log("This is my NFT contract");
    _tokenIds.increment();
    _tokenIds.increment();
  }
  // uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    string memory currentId = string(abi.encodePacked(Strings.toString(_tokenIds.current())));
    uint256 newItemId = _tokenIds.current();
       // Get all the JSON metadata in place and base64 encode it.

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "KittyNFT#',
                    currentId,
                    '", "description": "A highly acclaimed collection of kitties.", "image": "https://robohash.org/',
                    currentId,
                    ".png?set=set4",
                    '"}'
                )
            )
        )
    );

        // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    // console.log("\n--------------------");
    // console.log(finalTokenUri);
    // console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    // We'll be setting the tokenURI later!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    // console.log("An NFT Kitty w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}