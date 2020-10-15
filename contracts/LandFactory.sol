pragma solidity >=0.4.22 <0.7.0;

import "./Ownable.sol";
import "./SafeMath.sol";
/**
 * @dev A contract that keeps track of lands. Lands generate mana that is harvested and used by plainsWalkers.
 */
contract LandFactory is Ownable{

    using SafeMath for uint256;
    
    /**
     * @dev A struct for lands
     */
    struct Land {
        // What type of mana it generates.
        string landType;
        // When you can harvest this land again.
        uint32 readyTime;
    }

    // Maps lands to owners.
    mapping (uint => address) public landToOwner;
    // Keeps count of how many lands each owner has.
    mapping (address => uint) public landOwnerCount;
    // A list of the land names to simplify som code.
    string[5] public landNames = ['Red', 'Green', 'Blue', 'Black', 'White'];
    // The list of all lands.
    Land[] lands;

    /**
     * @dev This function generates a land of a random type
     */
    function generateRandomLand() external payable {
        // require that they send some ether or that they have no lands.
        require(msg.value >= 0.005 ether || landOwnerCount[msg.sender] == 0);
        // generate random number
        uint rand = uint(keccak256(abi.encodePacked(lands.length, msg.sender, block.timestamp)));
        // mod it by five to get a land type
        rand = rand % 5;

        // add land to our list
        lands.push(Land(landNames[rand], uint32(block.timestamp)));

        // associate it with our sender
        uint id = lands.length -1;
        landToOwner[id] = msg.sender;
        landOwnerCount[msg.sender]++;
        landOwnerCount[msg.sender] ++;
    }

    /**
     * @dev Allows the owner of LandFactory to withdraw ether spent on lands
     */
    function withdraw() external onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    /**
     * @dev This funtion returns the indexes of the lands that the address owns
     */
    function getLandByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](landOwnerCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < lands.length; i++) {
            if (landToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    
    /**
     * @dev Requires you to be the owner of a land
     */
    modifier ownerOfLand(uint _landId) {
        require(msg.sender == landToOwner[_landId]);
        _;
    }
    
    /**
     * @dev this function collects mana from one land based on its id and returns the array of that mana
     */
    function _collectManaFromLand(address _owner, uint _landId) external returns(uint16[5] memory) {
        require(landToOwner[_landId] == _owner);
        uint16[5] memory result;
        for (uint j = 0; j < landNames.length; j++){
            if (keccak256(abi.encodePacked(landNames[j])) == keccak256(abi.encodePacked(lands[_landId].landType)) && lands[_landId].readyTime <= block.timestamp){
                result[j]++;
                lands[_landId].readyTime = uint32(block.timestamp + 6 hours);
                }
            }
        return result;
    }
    
    function getWhatTypeIsLand(uint _id) external view returns(string memory landtype){
        return lands[_id].landType;
    }
}

