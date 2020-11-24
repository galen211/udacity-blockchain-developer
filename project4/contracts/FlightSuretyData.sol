pragma solidity ^0.4.25;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner; // Account used to deploy contract
    bool private operational = true; // Blocks all state changes throughout the contract if false

    mapping(address => bool) private authorizedCaller;

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    /**
     * @dev Constructor
     *      The deploying account becomes contractOwner
     */
    constructor() public {
        contractOwner = msg.sender;
        authorizedCaller[contractOwner] = true; // add contractOwner as an authorized caller
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    modifier requireIsOperational() {
        require(operational, "Contract is currently not operational");
        _; // All modifiers require an "_" which indicates where the function body will be added
    }

    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireCallerAuthorized() {
        require(
            authorizedCaller[msg.sender] == true,
            "Caller is not authorized"
        );
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() public view returns (bool) {
        return operational;
    }

    function setOperatingStatus(bool mode) external requireContractOwner {
        operational = mode;
    }

    function authorizeCaller(address _address)
        external
        requireIsOperational
        requireContractOwner
    {
        authorizedCaller[_address] = true;
    }

    function deauthorizeCaller(address _address)
        external
        requireIsOperational
        requireContractOwner
    {
        delete authorizedCaller[_address];
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    // Airlines
    mapping (address => Airline) private airlines;
    uint private registeredAirlines = 0;

    struct Airline {
        AirlineStatus status;
        address[] votes;
        uint funds;
    }

    enum AirlineStatus {
        Nominated,
        Registered,
        Funded
    }

    function registeredAirlineCount()
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (uint256)
    {
        return registeredAirlines;
    }

    function isAirlineNominated(address airlineAddress) external view 
        requireIsOperational
        requireCallerAuthorized
        returns (bool) {
        return airlines[airlineAddress].status == AirlineStatus.Nominated;
    }

    function isAirlineRegistered(address airlineAddress) external view 
        requireIsOperational
        requireCallerAuthorized
        returns (bool) 
    {
        return airlines[airlineAddress].status == AirlineStatus.Registered;
    }

    function isAirlineFunded(address airlineAddress) external view 
        requireIsOperational
        requireCallerAuthorized
        returns (bool) 
    {
        return airlines[airlineAddress].status == AirlineStatus.Funded;
    }

    function nominateAirline(address airlineAddress) external
        requireIsOperational
        requireCallerAuthorized {
        airlines[airlineAddress] = Airline(
            AirlineStatus.Nominated, // default Nominated
            new address[](0), // no votes
            0 // default no funding
        );
    }

    function registerAirline(address airlineAddress)
        external
        requireIsOperational
        requireCallerAuthorized
        returns (bool)
    {
        airlines[airlineAddress].status = AirlineStatus.Registered;
        registeredAirlines++;
        return airlines[airlineAddress].status == AirlineStatus.Registered;
    }

    function voteAirline(address airlineAddress, address voterAddress)
        external
        requireIsOperational
        requireCallerAuthorized
        returns (uint256)
    {
        airlines[airlineAddress].votes.push(voterAddress);
        return airlines[airlineAddress].votes.length;
    }

    function fundAirline(address airlineAddress, uint256 fundingAmount)
        external
        requireIsOperational
        requireCallerAuthorized
        returns (uint256)
    {
        airlines[airlineAddress].funds += fundingAmount;
        airlines[airlineAddress].status = AirlineStatus.Funded;
        return airlines[airlineAddress].funds;
    }

    // Passengers
    /**
     * @dev Buy insurance for a flight
     *
     */

    function buy() external payable {}

    /**
     *  @dev Credits payouts to insurees
     */
    function creditInsurees() external pure {}

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
     */
    function pay() external pure {}

    /**
     * @dev Initial funding for the insurance. Unless there are too many delayed flights
     *      resulting in insurance payouts, the contract should be self-sustaining
     *
     */

    function fund() public payable {}

    // Flights
    function getFlightKey(
        address airline,
        string memory flight,
        uint256 timestamp
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
     * @dev Fallback function for funding smart contract.
     *
     */
    function() external payable {
        fund();
    }
}
