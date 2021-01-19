// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "./SafeMath.sol";
import "./FlightSuretyData.sol";

/************************************************** */
/* FlightSurety Smart Contract                      */
/************************************************** */
contract FlightSuretyApp {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;

    uint8 private constant CONSENSUS_THRESHOLD = 4;
    uint8 private constant VOTE_SUCCESS_THRESHOLD = 2;

    uint256 public constant MAX_INSURANCE_AMOUNT = 1 ether;
    uint256 public constant MIN_AIRLINE_FUNDING = 10 ether;

    address public contractOwner; // Account used to deploy contract
    address payable public  dataContractAddress;

    FlightSuretyData private flightData;

    /********************************************************************************************/
    /*                                       CONSTRUCTOR                                        */
    /********************************************************************************************/

    constructor(address payable dataContract) {
        contractOwner = msg.sender;
        dataContractAddress = dataContract;
        flightData = FlightSuretyData(dataContract);
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    modifier requireIsOperational() {
        // Modify to call data contract's status
        require(
            flightData.isOperational() == true,
            "Contract is currently not operational"
        );
        _; // All modifiers require an "_" which indicates where the function body will be added
    }

    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireRegisteredAirlineCaller() {
        require(
            flightData.isAirlineRegistered(msg.sender) == true,
            "Only an existing airline may register an airline or participate in consensus"
        );
        _;
    }

    modifier requireFundedAirlineCaller() {
        require(
            flightData.isAirlineFunded(msg.sender) == true,
            "Only a funded airline may register an airline or participate in consensus"
        );
        _;
    }

    modifier requireNominated(address airlineAddress) {
        require(
            flightData.isAirlineNominated(airlineAddress) == true,
            "Airline cannot be registered"
        );
        _;
    }

    modifier requireNotRegistered(address airlineAddress) {
        require(
            flightData.isAirlineRegistered(airlineAddress) != true,
            "Airline is already registered"
        );
        _;
    }

    modifier requireNotFunded(address airlineAddress) {
        require(
            flightData.isAirlineFunded(airlineAddress) != true,
            "Airline is already funded"
        );
        _;
    }

    modifier requireFlightRegistered(
        address airline,
        string memory flight,
        uint256 departureTime
    ) {
        require(
            isFlightRegistered(airline, flight, departureTime) == true,
            "Flight must be registered"
        );
        _;
    }

    modifier rejectOverpayment() {
        require(
            msg.value <= MAX_INSURANCE_AMOUNT,
            "A maximum of 1 ether may be sent to purchase insurance"
        );
        _;
    }

    modifier requireSufficientReserves(
        address airlineAddress,
        uint256 insuranceAmount
    ) {
        uint256 grossExposure =
            flightData
                .totalUnderwritten(airlineAddress)
                .add(insuranceAmount)
                .mul(3)
                .div(2);
        require(
            grossExposure <= flightData.amountAirlineFunds(airlineAddress),
            "Airline has insufficient reserves to underwrite flight insurance"
        );
        _;
    }

    modifier requireRegisteredOracle(address oracleAddress) {
        require(
            oracles[oracleAddress].isRegistered == true,
            "Oracle must be registered to submit responses"
        );
        _;
    }

    /********************************************************************************************/
    /*                                       EVENTS                                             */
    /********************************************************************************************/

    event AirlineNominated(address indexed airlineAddress);

    event AirlineRegistered(address indexed airlineAddress);

    event AirlineFunded(
        address indexed airlineAddress,
        uint256 amount
    );

    event FlightRegistered(
        address indexed airlineAddress,
        string flight
    );

    event InsurancePurchased(address indexed passengerAddress, uint256 amount);

    event InsurancePayout(address indexed airlineAddress, string flight);

    event InsuranceWithdrawal(address indexed passengerAddress, uint256 amount);

    event FlightStatusInfo(
        address airline,
        string flight,
        uint256 departureTime,
        uint8 status
    );

    event OracleRequest(
        uint8 index,
        address airline,
        string flight,
        uint256 departureTime
    );

    event OracleReport(
        address airline,
        string flight,
        uint256 departureTime,
        uint8 status
    );

    event OracleRegistered(address indexed oracleAddress, uint8[3] indexes);

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() external view returns (bool) {
        return flightData.isOperational(); // Modify to call data contract's status
    }

    function setOperationalStatus(bool mode)
        external
        requireContractOwner
        returns (bool)
    {
        return flightData.setOperationalStatus(mode);
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function isAirlineNominated(address airlineAddress)
        external
        view
        requireIsOperational
        returns (bool)
    {
        return flightData.isAirlineNominated(airlineAddress);
    }

    function isAirlineRegistered(address airlineAddress)
        external
        view
        requireIsOperational
        returns (bool)
    {
        return flightData.isAirlineRegistered(airlineAddress);
    }

    function isAirlineFunded(address airlineAddress)
        external
        view
        requireIsOperational
        returns (bool)
    {
        return flightData.isAirlineFunded(airlineAddress);
    }
    
    function airlineMembership(address airlineAddress)
        external
        view
        requireIsOperational
        returns (uint)
    {
        return flightData.airlineMembership(airlineAddress);
    }

    function nominateAirline(address airlineAddress)
        external
        requireIsOperational
    {
        flightData.nominateAirline(airlineAddress);
        emit AirlineNominated(airlineAddress);
    }

    function registerAirline(address airlineAddress)
        external
        requireIsOperational
        requireFundedAirlineCaller
        requireNotFunded(airlineAddress)
        requireNotRegistered(airlineAddress)
        requireNominated(airlineAddress)
        returns (bool success)
    {
        uint256 votes = flightData.voteAirline(airlineAddress, msg.sender);
        if (flightData.registeredAirlineCount() >= CONSENSUS_THRESHOLD) {
            if (votes >= flightData.registeredAirlineCount().div(VOTE_SUCCESS_THRESHOLD)) {
                success = flightData.registerAirline(airlineAddress);
                emit AirlineRegistered(airlineAddress);
            } else {
                success = false; // not enough votes
            }
        } else {
            // no conensus required
            success = flightData.registerAirline(airlineAddress);
            emit AirlineRegistered(airlineAddress);
        }
        return success; // cannot have votes if just registered
    }

    function numberAirlineVotes(address airlineAddress)
        external
        view
        requireIsOperational
        returns (uint256 votes)
    {
        return flightData.numberAirlineVotes(airlineAddress);
    }

    function fundAirline()
        external
        payable
        requireIsOperational
        requireRegisteredAirlineCaller
    {
        require(
            msg.value >= MIN_AIRLINE_FUNDING,
            "Airline funding requires at least 10 Ether"
        );
        dataContractAddress.transfer(msg.value);
        flightData.fundAirline(msg.sender, msg.value);
        emit AirlineFunded(msg.sender, msg.value);
    }

    function amountAirlineFunds(address airlineAddress)
        external
        view
        requireIsOperational
        returns (uint256)
    {
        return flightData.amountAirlineFunds(airlineAddress);
    }

    function isFlightRegistered(
        address airline,
        string memory flight,
        uint256 departureTime
    ) public view requireIsOperational returns (bool) {
        bytes32 flightKey = getFlightKey(airline, flight, departureTime);
        return flightData.isFlightRegistered(flightKey);
    }

    function registerFlight(
        string memory flight,
        uint256 departureTime // this was a hard bug to fix, args needs to be held in memory
    ) external requireIsOperational requireFundedAirlineCaller {
        flightData.registerFlight(
            msg.sender,
            flight,
            departureTime,
            STATUS_CODE_UNKNOWN
        );
        emit FlightRegistered(msg.sender, flight);
    }

    function officialFlightStatus(
        address airline,
        string memory flightName,
        uint256 departureTime
    ) external view requireIsOperational returns (uint8) {
        bytes32 flightKey = getFlightKey(airline, flightName, departureTime);
        return flightData.getFlightStatus(flightKey);
    }

    function buyFlightInsurance(
        address airline,
        string memory flight,
        uint256 departureTime
    )
        external
        payable
        requireIsOperational
        rejectOverpayment
        requireSufficientReserves(airline, msg.value)
    {
        bytes32 key = getFlightKey(airline, flight, departureTime);
        flightData.buyInsurance(msg.sender, msg.value, key, airline);
        dataContractAddress.transfer(msg.value);
        emit InsurancePurchased(msg.sender, msg.value);
    }

    function isPassengerInsured(
        address passenger,
        address airline,
        string memory flight,
        uint256 departureTime
    ) external view requireIsOperational returns (bool) {
        bytes32 key = getFlightKey(airline, flight, departureTime);
        return flightData.isPassengerInsured(passenger, key);
    }

    function isPaidOut(
        address airline,
        string memory flight,
        uint256 departureTime
    ) external view requireIsOperational returns (bool) {
        bytes32 key = getFlightKey(airline, flight, departureTime);
        return flightData.isPaidOut(key);
    }

    function passengerBalance(address passengerAddress)
        external
        view
        requireIsOperational
        returns (uint256)
    {
        return flightData.currentPassengerBalance(passengerAddress);
    }

    function withdrawBalance(uint256 withdrawalAmount)
        external
        requireIsOperational
    {
        flightData.payPassenger(msg.sender, withdrawalAmount);
        emit InsuranceWithdrawal(msg.sender, withdrawalAmount);
    }

    /********************************************************************************************/
    /*                                       ORACLES                                            */
    /********************************************************************************************/

    uint8 private nonce = 0;
    uint256 public constant REGISTRATION_FEE = 1 ether;
    uint256 private constant MIN_RESPONSES = 3;

    struct Oracle {
        bool isRegistered;
        uint8[3] indexes;
    }

    mapping(address => Oracle) private oracles;

    function isOracleRegistered(address oracleAddress)
        public
        view
        requireIsOperational
        returns (bool)
    {
        return oracles[oracleAddress].isRegistered;
    }

    function registerOracle() external payable requireIsOperational {
        require(msg.value >= REGISTRATION_FEE, "Registration fee is required");
        uint8[3] memory indexes = generateIndexes(msg.sender);
        Oracle storage oracle = oracles[msg.sender];
        oracle.isRegistered = true;
        oracle.indexes = indexes;
        dataContractAddress.transfer(msg.value);
        emit OracleRegistered(msg.sender, indexes);
    }

    function getMyIndexes() external view returns (uint8[3] memory) {
        require(
            oracles[msg.sender].isRegistered,
            "Not registered as an oracle"
        );
        return oracles[msg.sender].indexes;
    }

    function fetchFlightStatus
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp                            
                        )
                        external
    {
        uint8 index = getRandomIndex(msg.sender);
        openOracleResponse(index, airline, flight, timestamp);
    }

    struct ResponseInfo {
        address requester;
        bool isOpen;
        mapping(uint8 => address[]) responses;
    }
    

    mapping(bytes32 => ResponseInfo) private oracleResponses;
    
     modifier validateOracle(uint8 index) {
        require((oracles[msg.sender].indexes[0] == index) || (oracles[msg.sender].indexes[1] == index) || (oracles[msg.sender].indexes[2] == index), "Index does not match oracle request");
        _;
    }

    function openOracleResponse(
                            uint8 index,
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        ) internal 
    {
        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp));
        
        ResponseInfo storage response = oracleResponses[key];
        response.requester = msg.sender;
        response.isOpen = true;
        
        emit OracleRequest(index, airline, flight, timestamp);
    }

    function submitOracleResponse
                        (
                            uint8 index,
                            address airline,
                            string memory flight,
                            uint256 departureTime,
                            uint8 statusCode
                        )
                        external
                        validateOracle(index)
    {
        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, departureTime));
        require(oracleResponses[key].isOpen == true, "Key does not match oracle request");
        oracleResponses[key].responses[statusCode].push(msg.sender);
        emit OracleReport(airline, flight, departureTime, statusCode);
        if (oracleResponses[key].responses[statusCode].length >= MIN_RESPONSES) {
            emit FlightStatusInfo(airline, flight, departureTime, statusCode);
            processFlightStatus(airline, flight, departureTime, statusCode);
        }
    }
    

    function processFlightStatus(
        address airline,
        string memory flight,
        uint256 departureTime,
        uint8 statusCode
    ) internal {
        bytes32 flightKey = getFlightKey(airline, flight, departureTime);
        flightData.updateFlightStatus(statusCode, flightKey);
        if (statusCode == STATUS_CODE_LATE_AIRLINE) {
            flightData.creditInsurees(flightKey, airline);
            emit InsurancePayout(airline, flight);
        }
    }

    function getFlightKey(
        address airline,
        string memory flight,
        uint256 departureTime
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(airline, flight, departureTime));
    }

    function generateIndexes(address account) internal returns (uint8[3] memory) {
        uint8[3] memory indexes;
        indexes[0] = getRandomIndex(account);

        indexes[1] = indexes[0];
        while (indexes[1] == indexes[0]) {
            indexes[1] = getRandomIndex(account);
        }

        indexes[2] = indexes[1];
        while ((indexes[2] == indexes[0]) || (indexes[2] == indexes[1])) {
            indexes[2] = getRandomIndex(account);
        }

        return indexes;
    }

    function getRandomIndex(address account)
        internal
        returns (uint8)
    {
        uint8 maxValue = 10;
        // Pseudo random number...the incrementing nonce adds variation
        uint8 random =
            uint8(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            blockhash(block.number - nonce++),
                            account
                        )
                    )
                ) % maxValue
            );

        if (nonce > 250) {
            nonce = 0; // Can only fetch blockhashes for last 256 blocks so we adapt
        }
        return random;
    }
}
