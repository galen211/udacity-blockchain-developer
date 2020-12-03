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
    mapping(address => Airline) private airlines;
    uint256 private registeredAirlines = 0;

    struct Airline {
        AirlineStatus status;
        address[] votes;
        uint256 funds;
    }

    enum AirlineStatus {Nominated, Registered, Funded}

    function registeredAirlineCount()
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (uint256)
    {
        return registeredAirlines;
    }

    function numberAirlineVotes(address airlineAddress)
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (uint256)
    {
        return airlines[airlineAddress].votes.length;
    }

    function amountAirlineFunds(address airlineAddress)
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (uint256)
    {
        return airlines[airlineAddress].funds;
    }

    function isAirlineNominated(address airlineAddress)
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (bool)
    {
        return airlines[airlineAddress].status == AirlineStatus.Nominated;
    }

    function isAirlineRegistered(address airlineAddress)
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (bool)
    {
        return airlines[airlineAddress].status == AirlineStatus.Registered;
    }

    function isAirlineFunded(address airlineAddress)
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (bool)
    {
        return airlines[airlineAddress].status == AirlineStatus.Funded;
    }

    function nominateAirline(address airlineAddress)
        external
        requireIsOperational
        requireCallerAuthorized
    {
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

    // Flights
    struct Flight {
        bool isRegistered;
        address airline;
        string flight;
        uint256 departureTime;
        uint8 statusCode;
        address[] insurees;
    }

    mapping(bytes32 => Flight) private flights;

    function registerFlight(address airline,
        string flight,
        uint256 departureTime,
        uint8 statusCode
    ) external requireIsOperational requireCallerAuthorized {
        bytes32 key = getFlightKey(airline, flight, departureTime);
        Flight memory newFlight;
        newFlight.isRegistered = true;
        newFlight.airline = airline;
        newFlight.flight = flight;
        newFlight.departureTime = departureTime;
        newFlight.statusCode = statusCode;
        flights[key] = newFlight;
    }

    function updateFlightStatus(
        uint8 statusCode,
        bytes32 flightKey
    ) external requireIsOperational requireCallerAuthorized {
        flights[flightKey].statusCode = statusCode;
    }

    function isFlightRegistered(
        bytes32 flightKey
    ) external view requireIsOperational requireCallerAuthorized returns (bool) {
        return flights[flightKey].isRegistered;
    }

    // Insurance contract
    struct Insurance {
        uint256 funds;
        bool withdrawable;
    }

    mapping(address => Insurance) private insurance;

    function buyInsurance(address passengerAddress, uint256 insuranceAmount, bytes32 flightKey) external
        requireIsOperational
        requireCallerAuthorized
    {
        flights[flightKey].insurees.push(passengerAddress);
        Insurance memory newInsurance;
        newInsurance.funds = insuranceAmount;
        newInsurance.withdrawable = false;
        insurance[passengerAddress] = newInsurance;     
    }

    /**
     *  @dev Credits payouts to insurees
     */
    function creditInsurees(bytes32 flightKey) external 
        requireIsOperational
        requireCallerAuthorized
    {
        for(uint8 i = 0; i <= flights[flightKey].insurees.length; i++) {
            address passengerAddress = flights[flightKey].insurees[i];
            // insurance[passengerAddress].funds *= 1.5; <- need to figure out requirement
            insurance[passengerAddress].withdrawable = true;
        }
    }

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
        uint256 departureTime
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(airline, flight, departureTime));
    }

    /**
     * @dev Fallback function for funding smart contract.
     *
     */
    function() external payable {
        fund();
    }
}
