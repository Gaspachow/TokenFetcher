
# TokenFetcher

A view-only smart contract allowing more optimised on-chain data fetching for ERC20 and ERC721

## Current View Functions List

**ERC20BalanceOfBatch**
```js
ERC20BalanceOfBatch(
			address[] memory  _accounts,
			address[] memory  _tokenAddress
			) view  public  returns(uint256[] memory)
```
This function works very much like [BalanceOfBatch](https://docs.openzeppelin.com/contracts/3.x/api/token/erc1155#IERC1155-balanceOfBatch-address---uint256---) on an ERC1155.
It takes an array of **Accounts** and an array of **ERC20 Contract Addresses**.
It returns an array of balances. (balance of accounts[i] for tokenAddress[i])

---

**ERC721EnumGetBatchTokensForUser**
```js
ERC721EnumGetBatchTokensForUser(
			address  _user,
			address  _tokenAddress,
			uint256  _startIndex,
			uint256  _maxLen
			) view  public  returns(uint256[] memory)
```
This function works with any ERC721Enum contract and allows you to collect a user's owned token IDs in batches. 
The function will resize the returned array if maxLen is too big. This means you can call it in a loop increasing the startIndex by maxLen until the returned array length is smaller than maxLen.

---

**ERC721GetBatchTokensForUser**
```js
ERC721GetBatchTokensForUser(
			address  _user,
			address  _tokenAddress,
			uint256  _startId,
			uint256  _maxLen,
			uint256  _maxId
			) view  public  returns(uint256[] memory)
```
This function is the equivalent of **ERC721EnumGetBatchTokensForUser** but for any ERC721 contract. A base ERC721 doesn't have a **totalSupply()** function, so you'll have to provide the **maxId** of the collection.
It is slower than its ERC721Enum counterpart as it will require to parse through the whole collection to find the owned IDs.

**This function is compatible with any ERC721, including non-sequential collections**

Recommended use of this function is to:
- Get the Balance of the user
- Loop the **ERC721GetBatchTokensForUser** and concat the responses until the balance is met
