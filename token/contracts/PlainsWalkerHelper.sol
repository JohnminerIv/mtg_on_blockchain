pragma solidity ^0.7.0;

import "./LandFactory.sol";
import "./PlainsWalkerFactory.sol";

contract PlainsWalkerHelper is PlainsWalkerFactory, LandFactory  {

    uint plainsWalkerFee = 0.02 ether;

    modifier ownerOf(uint _plainsWalkerId) {
        require(msg.sender == plainsWalkerToOwner[_plainsWalkerId]);
        _;
    }

    function setPlainsWalkerFee(uint _fee) external onlyOwner {
        plainsWalkerFee = _fee;
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

    }

}