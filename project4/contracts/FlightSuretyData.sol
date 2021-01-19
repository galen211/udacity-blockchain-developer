// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "./SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       CONTROL VARIABLES                                  */
    /********************************************************************************************/

    address private contractOwner; // Account used to deploy contract
    bool private operational = true; // Blocks all state changes throughout the contract if false

    mapping(address => bool) private authorizedCaller;

    constructor() {
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
    
    modifier requireSufficientBalance(address account, uint256 amount) {
        require(amount<=passengerBalance[account], "Withdrawal exceeds account balance");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() external view returns (bool) {
        return operational;
    }

    function setOperationalStatus(bool mode) external requireCallerAuthorized returns(bool) {
        operational = mode;
        return operational;
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
    /*                                     SMART CONTRACT VARIABLES                             */
    /********************************************************************************************/
    
    // Mappings
    mapping(address => Airline) private airlines;
    mapping(bytes32 => Flight) private flights;
    mapping(bytes32 => FlightInsurance) private flightInsurance;
    mapping(address => uint256) private passengerBalance;

    // Structs
    struct Airline {
        AirlineStatus status;
        address[] votes;
        uint256 funds;
        uint256 underwrittenAmount;
    }
    
    struct FlightInsurance {
        mapping(address => uint256) purchasedAmount;
        address[] passengers;
        bool isPaidOut;
    }
    
    struct Flight {
        bool isRegistered;
        address airline;
        string flight;
        uint256 departureTime;
        uint8 statusCode;
    }
    
    // State Variables
    uint256 public registeredAirlineCount = 0;

    // Enums
    enum AirlineStatus {Nonmember, Nominated, Registered, Funded}
    
    AirlineStatus constant defaultStatus = AirlineStatus.Nonmember;

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

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
        return airlines[airlineAddress].status == AirlineStatus.Nominated || airlines[airlineAddress].status == AirlineStatus.Registered || airlines[airlineAddress].status == AirlineStatus.Funded;
    }

    function isAirlineRegistered(address airlineAddress)
        external
        view
        requireIsOperational
        requireCallerAuthorized
        returns (bool)
    {
        return airlines[airlineAddress].status == AirlineStatus.Registered || airlines[airlineAddress].status == AirlineStatus.Funded;
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
    
    function airlineMembership(address airlineAddress)
    external
        view
        requireIsOperational
        returns (uint)
    {
        return uint(airlines[airlineAddress].status);
    }

    function nominateAirline(address airlineAddress)
        external
        requireIsOperational
        requireCallerAuthorized
    {
        airlines[airlineAddress] = Airline(
            AirlineStatus.Nominated, 
            new address[](0), // no votes
            0, // default no funding
            0 // no insurance underwritten 
        );
    }

    function registerAirline(address airlineAddress)
        external
        requireIsOperational
        requireCallerAuthorized
        returns (bool)
    {
        airlines[airlineAddress].status = AirlineStatus.Registered;
        registeredAirlineCount++;
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
        airlines[airlineAddress].funds = airlines[airlineAddress].funds.add(fundingAmount);
        airlines[airlineAddress].status = AirlineStatus.Funded;
        return airlines[airlineAddress].funds;
    }

    function registerFlight(
        address airline,
        string memory flight,
        uint256 departureTime,
        uint8 statusCode
    ) external requireIsOperational requireCallerAuthorized returns(bool) {
        bytes32 key = getFlightKey(airline, flight, departureTime);
        flights[key] = Flight({
           isRegistered: true,
           airline: airline,
           flight: flight,
           departureTime: departureTime,
           statusCode: statusCode
        });
        return flights[key].isRegistered;
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

    function getFlightStatus(
        bytes32 flightKey
    ) external view requireIsOperational requireCallerAuthorized returns (uint8) {
        return flights[flightKey].statusCode;
    }

    function totalUnderwritten(address airlineAddress) external view requireIsOperational requireCallerAuthorized 
        returns(uint256)
    {
        return airlines[airlineAddress].underwrittenAmount;
    }


    function buyInsurance(address passengerAddress, uint256 insuranceAmount, bytes32 flightKey, address airlineAddress) external
        requireIsOperational
        requireCallerAuthorized
    {
        airlines[airlineAddress].underwrittenAmount.add(insuranceAmount);
        flightInsurance[flightKey].purchasedAmount[passengerAddress] = insuranceAmount;
        flightInsurance[flightKey].passengers.push(passengerAddress);
    }
    
    function isPassengerInsured(address passengerAddress, bytes32 flightKey) 
        external view 
        requireIsOperational
        requireCallerAuthorized
        returns(bool)
    {
        return flightInsurance[flightKey].purchasedAmount[passengerAddress] > 0;
    }
    
    function isPaidOut(bytes32 flightKey) external view
        requireIsOperational
        requireCallerAuthorized
        returns(bool)
    {
        return flightInsurance[flightKey].isPaidOut;
    }
    
    function currentPassengerBalance(address passengerAddress) external view
        requireIsOperational
        requireCallerAuthorized
        returns(uint256)
    {
        return passengerBalance[passengerAddress];
    }

    function creditInsurees(bytes32 flightKey, address airlineAddress) external 
        requireIsOperational
        requireCallerAuthorized
    {
        require(!flightInsurance[flightKey].isPaidOut,"Flight insurance already paid out");
        for(uint i = 0; i < flightInsurance[flightKey].passengers.length; i++) {
            address passengerAddress = flightInsurance[flightKey].passengers[i];
            uint256 purchasedAmount = flightInsurance[flightKey].purchasedAmount[passengerAddress];
            uint256 payoutAmount = purchasedAmount.mul(3).div(2);
            passengerBalance[passengerAddress] = passengerBalance[passengerAddress].add(payoutAmount);
            airlines[airlineAddress].funds.sub(payoutAmount);
        }
        flightInsurance[flightKey].isPaidOut = true;
    }

    function payPassenger(address payable insured, uint256 amount) external         
        requireIsOperational
        requireCallerAuthorized
        requireSufficientBalance(insured, amount) // this is business logic, but makes sense to hard code in the data contract
    {
         passengerBalance[insured] = passengerBalance[insured].sub(amount);
         insured.transfer(amount);
    }


    function getFlightKey(
        address airline,
        string memory flight,
        uint256 departureTime
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(airline, flight, departureTime));
    }

    fallback()  external payable requireCallerAuthorized {
        // funds the contract
    }
    
    receive() external payable {
        // custom function code
    }
}
