pragma solidity ^0.4.25;

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
// Data contract import
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

    uint8 private constant CONSENSUS_THRESHOLD = 4; // consensus active when at least four airlines registered
    uint8 private constant VOTE_SUCCESS_THRESHOLD = 2; // i.e. votes / 2

    address private contractOwner; // Account used to deploy contract
    FlightSuretyData flightData;

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
     * @dev Modifier that requires the "operational" boolean variable to be "true"
     *      This is used on all state changing functions to pause the contract in
     *      the event there is an issue that needs to be fixed
     */
    modifier requireIsOperational() {
        // Modify to call data contract's status
        require(true, "Contract is currently not operational");
        _; // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
     * @dev Modifier that requires the "ContractOwner" account to be the function caller
     */
    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    /********************************************************************************************/
    /*                                       CONSTRUCTOR                                        */
    /********************************************************************************************/

    /**
     * @dev Contract constructor
     *
     */
    constructor(address dataContract) public {
        contractOwner = msg.sender;
        flightData = FlightSuretyData(dataContract);
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() public view returns (bool) {
        return flightData.isOperational(); // Modify to call data contract's status
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    // Airlines
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

    event AirlineNominated(address indexed airlineAddress);
    event AirlineRegistered(address indexed airlineAddress);
    event AirlineFunded(address indexed airlineAddress, uint256 amount);

    function isAirlineRegistered(address airlineAddress)
        public
        view
        returns (bool)
    {
        return flightData.isAirlineRegistered(airlineAddress);
    }

    function registerAirline(address airlineAddress)
        external
        requireFundedAirlineCaller
        requireNotRegistered(airlineAddress)
        requireNotFunded(airlineAddress)
        returns (bool success, uint256 votes)
    {
        if (!flightData.isAirlineNominated(airlineAddress)) {
            // airline has not been nominated
            flightData.nominateAirline(airlineAddress);
            emit AirlineNominated(airlineAddress);
        }

        if (flightData.registeredAirlineCount() >= CONSENSUS_THRESHOLD) {
            // require consensus
            votes = flightData.voteAirline(airlineAddress, msg.sender);
            if (
                votes >=
                flightData.registeredAirlineCount().div(VOTE_SUCCESS_THRESHOLD)
            ) {
                success = flightData.registerAirline(airlineAddress);
                emit AirlineRegistered(airlineAddress);
            } else {
                success = false; // not enough votes
            }
        } else {
            // no conensus required
            success = flightData.registerAirline(airlineAddress);
            votes = 1; // one vote enough
            emit AirlineRegistered(airlineAddress);
        }
        return (success, votes); // cannot have votes if just registered
    }

    function fundAirline() external payable requireRegisteredAirlineCaller {
        flightData.fundAirline(msg.sender, msg.value);
        emit AirlineFunded(msg.sender, msg.value);
    }

    // Flights
    modifier requireFlightRegistered(address airline, string flight, uint256 departureTime) {
        require(this.isFlightRegistered(airline, flight, departureTime) == true, "Flight must be registered");
        _;
    }

    event FlightRegistered(
        address indexed airlineAddress, 
        string flight, 
        uint256 departureTime
    );

    event InsurancePurchased(
        address indexed passengerAddress, 
        uint256 amount
    );

    event InsurancePayout(
        address indexed airlineAddress, 
        string flight, 
        uint256 departureTime
    );

    function isFlightRegistered(address airline, string flight, uint256 departureTime) external view returns (bool) {
        bytes32 flightKey = getFlightKey(airline, flight, departureTime);
        return flightData.isFlightRegistered(flightKey);
    }

    function registerFlight(string flight, uint256 departureTime)
        public // this was a hard bug to fix, args needs to be held in memory
        requireFundedAirlineCaller
    {
        flightData.registerFlight(
            msg.sender,
            flight,
            departureTime,
            STATUS_CODE_UNKNOWN
        );
        emit FlightRegistered(msg.sender, flight, departureTime);
    }

    function processFlightStatus(
        address airline,
        string flight,
        uint256 departureTime,
        uint8 statusCode
    ) internal requireFlightRegistered(airline, flight, departureTime) {
        bytes32 flightKey = getFlightKey(airline, flight, departureTime);
        flightData.updateFlightStatus(statusCode, flightKey);
        if (statusCode == STATUS_CODE_LATE_AIRLINE) {
            flightData.creditInsurees(flightKey);
            emit InsurancePayout(airline, flight, departureTime);
        }
    }

    // Insurance
    modifier rejectOverpayment() {
        require(msg.value <= 1 ether, "A maximum of 1 ether may be sent to purchase insurance");
        _;
    }

    function buyFlightInsurance(
        address airline,
        string flight,
        uint256 departureTime) public payable rejectOverpayment {
        bytes32 key = getFlightKey(airline, flight, departureTime);
        flightData.buyInsurance(msg.sender, msg.value, key);
        emit InsurancePurchased(msg.sender, msg.value);
    }

    // Generate a request for oracles to fetch flight information
    function fetchFlightStatus(
        address airline,
        string flight,
        uint256 departureTime
    ) external requireFlightRegistered(airline, flight, departureTime) {
        uint8 index = getRandomIndex(msg.sender);

        // Generate a unique key for storing the request
        bytes32 key = keccak256(
            abi.encodePacked(index, airline, flight, departureTime)
        );
        oracleResponses[key] = ResponseInfo({
            requester: msg.sender,
            isOpen: true
        });

        emit OracleRequest(index, airline, flight, departureTime);
    }

    // region ORACLE MANAGEMENT

    // Incremented to add pseudo-randomness at various points
    uint8 private nonce = 0;

    // Fee to be paid when registering oracle
    uint256 public constant REGISTRATION_FEE = 1 ether;

    // Number of oracles that must respond for valid status
    uint256 private constant MIN_RESPONSES = 3;

    struct Oracle {
        bool isRegistered;
        uint8[3] indexes;
    }

    // Track all registered oracles
    mapping(address => Oracle) private oracles;

    // Model for responses from oracles
    struct ResponseInfo {
        address requester; // Account that requested status
        bool isOpen; // If open, oracle responses are accepted
        mapping(uint8 => address[]) responses; // Mapping key is the status code reported
        // This lets us group responses and identify
        // the response that majority of the oracles
    }

    // Track all oracle responses
    // Key = hash(index, flight, departureTime)
    mapping(bytes32 => ResponseInfo) private oracleResponses;

    // Event fired each time an oracle submits a response
    event FlightStatusInfo(
        address airline,
        string flight,
        uint256 departureTime,
        uint8 status
    );

    event OracleReport(
        address airline,
        string flight,
        uint256 departureTime,
        uint8 status
    );

    // Event fired when flight status request is submitted
    // Oracles track this and if they have a matching index
    // they fetch data and submit a response
    event OracleRequest(
        uint8 index,
        address airline,
        string flight,
        uint256 departureTime
    );

    // Register an oracle with the contract
    function registerOracle() external payable {
        // Require registration fee
        require(msg.value >= REGISTRATION_FEE, "Registration fee is required");

        uint8[3] memory indexes = generateIndexes(msg.sender);

        oracles[msg.sender] = Oracle({isRegistered: true, indexes: indexes});
    }

    function getMyIndexes() external view returns (uint8[3]) {
        require(
            oracles[msg.sender].isRegistered,
            "Not registered as an oracle"
        );

        return oracles[msg.sender].indexes;
    }

    // Called by oracle when a response is available to an outstanding request
    // For the response to be accepted, there must be a pending request that is open
    // and matches one of the three Indexes randomly assigned to the oracle at the
    // time of registration (i.e. uninvited oracles are not welcome)
    function submitOracleResponse(
        uint8 index,
        address airline,
        string flight,
        uint256 departureTime,
        uint8 statusCode
    ) external {
        require(
            (oracles[msg.sender].indexes[0] == index) ||
                (oracles[msg.sender].indexes[1] == index) ||
                (oracles[msg.sender].indexes[2] == index),
            "Index does not match oracle request"
        );

        bytes32 key = keccak256(
            abi.encodePacked(index, airline, flight, departureTime)
        );
        require(
            oracleResponses[key].isOpen,
            "Flight or departureTime do not match oracle request"
        );

        oracleResponses[key].responses[statusCode].push(msg.sender);

        // Information isn't considered verified until at least MIN_RESPONSES
        // oracles respond with the *** same *** information
        emit OracleReport(airline, flight, departureTime, statusCode);
        if (
            oracleResponses[key].responses[statusCode].length >= MIN_RESPONSES
        ) {
            emit FlightStatusInfo(airline, flight, departureTime, statusCode);

            // Handle flight status as appropriate
            processFlightStatus(airline, flight, departureTime, statusCode);
        }
    }

    function getFlightKey(
        address airline,
        string flight,
        uint256 departureTime
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(airline, flight, departureTime));
    }

    // Returns array of three non-duplicating integers from 0-9
    function generateIndexes(address account) internal returns (uint8[3]) {
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

    // Returns array of three non-duplicating integers from 0-9
    function getRandomIndex(address account) internal returns (uint8) {
        uint8 maxValue = 10;

        // Pseudo random number...the incrementing nonce adds variation
        uint8 random = uint8(
            uint256(
                keccak256(
                    abi.encodePacked(blockhash(block.number - nonce++), account)
                )
            ) % maxValue
        );

        if (nonce > 250) {
            nonce = 0; // Can only fetch blockhashes for last 256 blocks so we adapt
        }

        return random;
    }

    // endregion
}
