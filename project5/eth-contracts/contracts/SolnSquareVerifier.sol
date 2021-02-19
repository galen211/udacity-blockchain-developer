pragma solidity >0.4.24;

import "./ERC721MintableComplete.sol";

// 2. TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721MintableComplete {
    Verifier private verifierContract;

    // 3. TODO define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 solutionIndex;
        address solutionAddress;
        bool minted; //flag to indicate if this solution has been used in token minting
    }

    // 4. TODO define an array of the above struct
    //Solution[] private solutions;
    uint256 numberOfSolutions = 0;

    // 5. TODO define a mapping to store unique solutions submitted
    mapping (bytes32 => Solution) solutions;

    // 6. TODO Create an event to emit when a solution is added
    event SolutionAdded(uint256 solutionIndex, address indexed solutionAddress);

    constructor(address verifierAddress, string memory name, string memory symbol) 
        ERC721MintableComplete(name, symbol) 
        public 
    {
        verifierContract = Verifier(verifierAddress);
    }

    // 7. TODO Create a function to add the solutions to the array and emit the event
    function addSolution(
        uint[2] memory A,
        uint[2] memory A_p,
        uint[2][2] memory B,
        uint[2] memory B_p,
        uint[2] memory C,
        uint[2] memory C_p,
        uint[2] memory H,
        uint[2] memory K,
        uint[2] memory input
    ) 
        public 
    {
        bytes32 solutionHash = keccak256(abi.encodePacked(input[0], input[1]));
        require(solutions[solutionHash].solutionAddress == address(0), "Solution exists already");
        
        bool verified = verifierContract.verifyTx(A, A_p, B, B_p, C, C_p, H, K, input);
        require(verified, "Solution could not be verified");

        solutions[solutionHash] = Solution(numberOfSolutions, msg.sender, false);
        //solutions.push(solution);
        emit SolutionAdded(numberOfSolutions, msg.sender);
        numberOfSolutions++;
    }

    // 8. TODO Create a function to mint new NFT only after the solution has been verified
    //      - make sure the solution is unique (has not been used before)
    //      - make sure you handle metadata as well as tokenSuplly
    function mintNewNFT(uint a, uint b, address to) public
    {
        bytes32 solutionHash = keccak256(abi.encodePacked(a, b));
        require(solutions[solutionHash].solutionAddress != address(0), "Solution does not exist");
        require(solutions[solutionHash].minted == false, "Token already minted for this solution");
        require(solutions[solutionHash].solutionAddress == msg.sender, "Only solution address can use it to mint a token");
        super.mint(to, solutions[solutionHash].solutionIndex);
        solutions[solutionHash].minted = true;
    }
}

// 1. TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
contract Verifier {
    function verifyTx(
        uint[2] memory A,
        uint[2] memory A_p,
        uint[2][2] memory B,
        uint[2] memory B_p,
        uint[2] memory C,
        uint[2] memory C_p,
        uint[2] memory H,
        uint[2] memory K,
        uint[2] memory input
    )
    public
    returns
    (bool r);
}


























