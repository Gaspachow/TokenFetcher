// SPDX-License-Identifier: Whatevs
// This simple contract is brought to you by gaspacho.eth / @gaspacho_eth !

pragma solidity ^0.8;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract GaspachoTokenFetcher {

  function ERC20BalanceOfBatch(address[] memory _accounts, address[] memory _tokens) view public returns(uint256[] memory) {
    uint256 i = 0;
    uint256 len = _accounts.length;
    uint256[] memory balanceArray = new uint256[](len);

    while (i < len) {
      balanceArray[i] = IERC20(_tokens[i]).balanceOf(_accounts[i]);
      ++i;
    }

    return balanceArray;
  }

  function ERC721EnumGetAllTokensForUser(address _user, address _tokenAddress, uint256 _startIndex, uint256 _maxLen) view public returns(uint256[] memory) {
    uint256 userBalance = IERC721Enumerable(_tokenAddress).balanceOf(_user);
    if (userBalance == 0 || _startIndex >= userBalance) {
      return (new uint256[](0));
    }

    uint256 maxEndIndex = userBalance;
    uint256 desiredEndIndex = _startIndex + _maxLen;
    uint256 endIndex = maxEndIndex < desiredEndIndex ? maxEndIndex : desiredEndIndex;

    uint256[] memory tokenIdsArray = new uint256[](endIndex - _startIndex);
    uint256 i = _startIndex;
    uint256 j = 0;
    while (i < endIndex) {
      tokenIdsArray[j] = (IERC721Enumerable(_tokenAddress).tokenOfOwnerByIndex(_user, i));
      ++i;
      ++j;
    }
  
    return tokenIdsArray;
  }

  function ERC721GetAllTokensForUser(address _user, address _tokenAddress, uint256 _startId, uint256 _maxLen, uint256 _maxId) view public returns(uint256[] memory) {
    uint256 userBalance = IERC721(_tokenAddress).balanceOf(_user);
    if (userBalance == 0 || _startId > _maxId) {
      return (new uint256[](0));
    }

    uint256 maxEndIndex = _maxId + 1;
    uint256 desiredEndIndex = _startId + _maxLen;
    uint256 endIndex = maxEndIndex < desiredEndIndex ? maxEndIndex : desiredEndIndex;

    uint256[] memory tokenIdsMaxArray = new uint256[](endIndex - _startId);
    uint256 i = _startId;
    uint256 j = 0;
    while (i < endIndex) {

      try IERC721(_tokenAddress).ownerOf(i) returns (address v) {
        if (v == _user) {
          tokenIdsMaxArray[j] = i;
          ++j;
        }
      } catch Error(string memory) {}

      ++i;
    }

    // Shorten array to only IDs found
    i = 0;
    uint256[] memory tokenIdsArray = new uint256[](j);
    while ( i < j) {
      tokenIdsArray[i] = tokenIdsMaxArray[i];
      ++i;
    }
  
    return tokenIdsArray;
  }

}