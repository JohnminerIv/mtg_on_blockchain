pragma solidity >=0.4.22 <0.7.0;

import "./PlainsWalkerFactory.sol";

contract PlainsWalkerHelper is PlainsWalkerFactory{

    uint plainsWalkerFee = 0.02 ether;

    modifier ownerOfPlainsWalker(uint _plainsWalkerId) {
        require(msg.sender == plainsWalkerToOwner[_plainsWalkerId]);
        _;
    }

    function setPlainsWalkerFee(uint _fee) external onlyOwner {
        plainsWalkerFee = _fee;
    }
    
    function getPlainsWalkerFee() external view returns(uint){
        return plainsWalkerFee;
    }

    function getPlainsWalkersByOwner(address _owner) public view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerPlainsWalkerCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < plainsWalkers.length; i++) {
            if (plainsWalkerToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function purchasePlainsWalker(string memory _name) external payable {
        require(msg.value == plainsWalkerFee);
        uint64 randDna = uint64(_generateRandomDna(_name, msg.sender));
        _createPlainswalker(_name, randDna, 100);
    }
    function getPlainswalkerInfoById(uint _id) external view returns(string memory name, uint16 health, uint[] memory creatures){
        return (plainsWalkers[_id].name, plainsWalkers[_id].health, plainsWalkers[_id].creatures);
    }
}