# Create Your Own Private Blockchain
<img src="../assets/undraw/project1.svg" width="200"/>

## Purpose
The purpose of this project is to develop familiarity with the following concepts:

- Block
- Blockchain
- Wallet
- Blockchain Identity
- Proof of Existence
- Digital Assets

## Testing The App
The project is build as an `express.js` app with endpoints that are defined in `BlockchainController.js`.  To start the server, simply build and and then run the `Dockerfile`.

###  Step 1: `getBlockByHeight`
Run the curl command below to test that the genesis block has been created:
```curl
curl --location --request GET 'http://localhost:80/blocks/height/0'
```

The response will show that there is no previous block at height 0 and establish a genesis block hash that will be used in the generation of the subsequent block's hash.
```json
{
    "hash": "141efe7e8e71d076995cc4a528c134cbb422dbc292ba75e7ab0a06952b901318",
    "height": 0,
    "body": "7b2264617461223a2247656e6573697320426c6f636b227d",
    "time": "1599401141",
    "previousBlockHash": null
}
```

### Step 2: `requestOwnership`
This endpoint allows a user to generate a message to be signed with an Electrum wallet.  The message follows the format `<WALLET_ADDRESS>:<TIME>:starRegistry`.  The Electrum wallet address is the required input.  This address is required to perform subsequent steps.

```curl
curl --location --request POST 'http://localhost:80/requestValidation' \
--header 'Content-Type: application/json' \
--data-raw '{
    "address" : "1KMqKbWvnqmPivChWJx46szERVB6BwwWdN"
}'
```

Sample response:
`"1KMqKbWvnqmPivChWJx46szERVB6BwwWdN:1599403427:starRegistry"`

### Step 3: **submitStar**

In this step, we submit a message signed by the Electrum wallet and put it on the private blockchain.  Since the digital signature proves owership of the wallet address, this message is guaranteed to have been signed by the owner of the wallet.  The content in "star" can be anything, but once added to the Blockchain it cannot be changed.  If an attempt were made to change any data in this block, subsequent blocks would not validate.  To submit a star, the following command can be used as a model (**note** this signature while valid will not work because our blockchain will reject a message that is more than 5 minutes behind current time).
```curl
curl --location --request POST 'http://localhost:80/submitstar' \
--header 'Content-Type: application/json' \
--data-raw '{
    "address" : "1KMqKbWvnqmPivChWJx46szERVB6BwwWdN",
    "signature" : "Hx1Gmkh3Iq/ZdU/cfgL9+5MnKTKxZHy4zqcQsnslyZ1qVJByRbrxlbwBVwHjtKw2ppd2TZoZtBcBsbY/kFb0rGc=",
    "message" : "1KMqKbWvnqmPivChWJx46szERVB6BwwWdN:1599404288:starRegistry",
    "star" : {
        "dec" : "68 52 56.9",
        "ra" : "16h 29m 1.0s",
        "story" : "Testing submitStar 4"
    }
}'
```

A successful submission will return a block object with an encoded body.
```json
{
    "hash": "44632040fa895f67b1c6340c1c534d9f8aba7c2ea3bb77ae4b97162a1dd8c3b3",
    "height": 9,
    "body": "7b2261646472657373223a22314b4d714b6257766e716d5069764368574a783436737a455256423642777757644e222c226d657373616765223a22314b4d714b6257766e716d5069764368574a783436737a455256423642777757644e3a313539393430343238383a737461725265676973747279222c227369676e6174757265223a22487831476d6b683349712f5a64552f6366674c392b354d6e4b544b785a4879347a716351736e736c795a3171564a4279526272786c6277425677486a744b773270706432545a6f5a744263427362592f6b4662307247633d222c2273746172223a7b22646563223a2236382035322035362e39222c227261223a223136682032396d20312e3073222c2273746f7279223a2254657374696e67207375626d6974537461722034227d7d",
    "time": "1599404317"
}
```

### Step 4: `getBlockByHash`
In this step we retrieve a block that exists on our blockchain.  We can use the hash of the block generated in Step 3 as a parameter to our `GET` request:
```curl
curl --location --request GET 'http://localhost:80/blocks/hash/44632040fa895f67b1c6340c1c534d9f8aba7c2ea3bb77ae4b97162a1dd8c3b3' \
--data-raw ''
```

The method will simply return the same block object as in Step 3 when we originally created the block.
```json
{
    "hash": "44632040fa895f67b1c6340c1c534d9f8aba7c2ea3bb77ae4b97162a1dd8c3b3",
    "height": 9,
    "body": "7b2261646472657373223a22314b4d714b6257766e716d5069764368574a783436737a455256423642777757644e222c226d657373616765223a22314b4d714b6257766e716d5069764368574a783436737a455256423642777757644e3a313539393430343238383a737461725265676973747279222c227369676e6174757265223a22487831476d6b683349712f5a64552f6366674c392b354d6e4b544b785a4879347a716351736e736c795a3171564a4279526272786c6277425677486a744b773270706432545a6f5a744263427362592f6b4662307247633d222c2273746172223a7b22646563223a2236382035322035362e39222c227261223a223136682032396d20312e3073222c2273746f7279223a2254657374696e67207375626d6974537461722034227d7d",
    "time": "1599404317"
}
```

### Step 5: `getStarsByWalletAddress`
Next, we show that blocks can also be filtered by the wallet address that signed the block.  To do this, we need to decode the encoded body of each block and check whether the address submitted in the endpoint request is a match:
```curl
curl --location --request GET 'http://localhost:80/blocks/address/1KMqKbWvnqmPivChWJx46szERVB6BwwWdN' \
--data-raw ''
```

The code to retrieve blocks by address wraps an async function that decodes each block and checks the address in a promise that is resolved with the blocks that match the provided address.
```js
getStarsByWalletAddress(address) {
        let self = this;
        let results = [];
        return new Promise((resolve, reject) => {            
            self.chain.forEach(async(b) => {
                let blockData = await b.getBData();
                if (blockData.address === address) results.push(blockData);
            });
            resolve(results);
        });
    }
```

The response output is a list of blocks:
```json
[
    {
        "address": "1KMqKbWvnqmPivChWJx46szERVB6BwwWdN",
        "message": "1KMqKbWvnqmPivChWJx46szERVB6BwwWdN:1599403427:starRegistry",
        "signature": "IDo1b+1bqifFFUnNVD5tDyE6aTcRfjm0MBfnRUGSoZh9SUqCdBcXrOsr5IA1Kcb+fjuk9JbFEPDS6Mry4TzD9kI=",
        "star": {
            "dec": "68 52 56.9",
            "ra": "16h 29m 1.0s",
            "story": "Testing submitStar 1"
        }
    },
    // list of blocks with the address 1KMqKbWvnqmPivChWJx46szERVB6BwwWdN
]
```