pragma solidity >=0.4.22 <0.7.0;

import "./SafeMath.sol";

/**
 * @dev Creatures are one of the main spells that a plainswalker can cast.
 * Right now I want each creature to be connected to the plainswalker that summoned it.
 * Not a tradeable asset (it stays with the plainswalker it it is traded though).
 */
contract CreatureFactory{
    
    using SafeMath for uint256;
    using SafeMath for uint16;
    
    // Struct for the creature.
    struct Creature{
        // attack calculated based on spent Mana.
        uint16 attack;
        // defence calculated based on spent Mana.
        uint16 defence;
        // readyTime is set for 6 hours after creation and 6 hours after each attack
        uint32 readyTime;
        // Bool to tell if the creature is defending its plainswalker. If it is it can't attack.
        bool isDefending;
    }
    
    // The next id is used if there are no ids in deletedCreatureIds.
    uint nextId = 0;
    // Keep track of ids that have died in order to reduce the the amount of complex array manipulations required.
    uint[] deletedCreatureIds;
    // An array of Creatures.
    Creature[] creatures;
    
    /**
     * @dev Constructs a creature based on an array of mana. It creates the features of
     * the creature based on the types of mana used.
     */
    function createCreature(uint16[5] memory _mana) internal returns (uint creatureId) {
        // mana should be in this order ['Red', 'Green', 'Blue', 'Black', 'White'].
        uint totalCost;
        
        for (uint i = 0; i < _mana.length; i++) {
            totalCost += _mana[i];
        }
        
        require(totalCost > 0);
        uint attack = totalCost.div(2);
        uint defence = attack;
        
        // Red adds to attack
        attack = attack.add(_mana[0].div(2));
        // Green adds to attack and defence
        attack = attack.add(_mana[1].div(3));
        defence = defence.add(_mana[1].div(3));
        // Blue adds to defence
        defence = defence.add(_mana[2].div(2));
        // Black adds to attack and defence
        attack = attack.add(_mana[3].div(2));
        defence = defence.add(_mana[3].div(4));
        // White adds to defence
        defence += defence.add(_mana[4].div(2));
        
        // If somehow a creature (pure red 1 cost maybe...) ends up with 0 defence add 1
        if (defence == 0){
            defence ++;
        }

        // Find an open id or add a new one.
        uint id;
        if (deletedCreatureIds.length == 0){
            id = nextId;
            // Place creature into array at an open position.
            uint32 readyTime = uint32(block.timestamp + 6 hours);
            
            creatures.push(Creature(uint16(attack), uint16(defence), readyTime, false));
            nextId ++;
        } else {
            id = deletedCreatureIds[deletedCreatureIds.length - 1];
            // Place creature into array at an open position.
            uint32 readyTime = uint32(block.timestamp + 6 hours);
            
            creatures[id] = Creature(uint16(attack), uint16(defence), readyTime, false);
            deletedCreatureIds.pop();
        }
        // Return the new creatureId to be kept track of by a plainswalker.
        return id;
    }

    /**
     * @dev A getter function for creature info.
     */
    function getCreatureInfoByIndex(uint _id) public view returns (uint16 attack, uint16 defence, uint32 readyTime, bool isDefending){
        return (creatures[_id].attack, creatures[_id].defence, creatures[_id].readyTime, creatures[_id].isDefending);
    }
}
