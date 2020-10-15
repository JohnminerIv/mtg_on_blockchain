pragma solidity >=0.4.22 <0.7.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../PlainsWalkerHelper.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite is PlainsWalkerHelper{
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    address acc0;
    address acc1;
    PlainsWalkerHelper h;
    
    /// #sender: account-0
    function beforeAll() public{
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
        h = new PlainsWalkerHelper();
    }

/// CreatureFactory

    function testCreateCreature() public {
        uint[5] memory mana = [uint(1), 3, 1, 0,1];
        Creature memory creature = createCreature(mana);
        Assert.equal(creature.id, uint(0), 'Creature generated with id 0');
    }

    function testDefendBoolFalse() public {
        uint[5] memory mana = [uint(1), 3, 1, 0,1];
        Assert.equal(createCreature(mana).isDefending, false, 'Creatures must be set to defending');
    }

/// plainsWalkerFactory

    /// #sender: account-0
    function createFirstFreePlainsWalker() public {
        h.createRandomPlainsWalker('John');
        string memory name;
        (name,,) = h.getPlainswalkerInfoById(0);
        Assert.equal(name, 'John', 'Created a plainsWalker named John');
    }

    /// #sender: account-0
    function createSecondFreePlainsWalker() public {
        h.createRandomPlainsWalker('Zoe');
        string memory name;
        (name,,) = h.getPlainswalkerInfoById(1);
        Assert.equal(name, 'Zoe', 'Created a plainsWalker named Zoe, but this will revert because you can\'t have 2 free plainswalkers');
    }

    /// #sender: account-1
    function createFirstFreePlainsWalkerSecondAccount() public {
        h.createRandomPlainsWalker('Zoe');
        string memory name;
        (name,,) = h.getPlainswalkerInfoById(1);
        Assert.equal(name, 'Zoe', 'This one should work.');
    }
    
    /// #sender: account-1
    function renamePlainswalkerFail() public {
        h.changeName(uint(0), "John sucks at solidity");
        string memory name;
        (name,,) = h.getPlainswalkerInfoById(1);
        Assert.equal(name, 'John', 'Function should revert as acc1 is not owner of plainsWalkers[0]');
    }

    /// #sender: account-1
    function renamePlainswalkerSuccess() public {
        h.changeName(uint(1), "Zoe Is Amazing");
        Assert.equal(plainsWalkers[1].name, "Zoe Is Amazing", 'Function should pass and change name because acc-1 owns plainsWalkers[1]');
    }

/// plainsWalkerHelper
    
    /// #sender: account-0 (sender is account at index '0')
    function testSetPlainsWalkerFee() public {
        h.setPlainsWalkerFee(0.5 ether);
        Assert.equal(h.getPlainsWalkerFee(), 0.5 ether, 'I want all the money and acc0 should own so this should pass');
    }
    
    /// #sender: account-1 (sender is account at index '1')
    function testFailSetPlainsWalkerFee() public {
        h.setPlainsWalkerFee(0.1 ether);
        Assert.equal(h.getPlainsWalkerFee(), 0.1 ether, 'acc1 does not own so this should pass');
    }
    
    /// #sender: account-0 (sender is account at index '0')
    function testGetPlainsWalkerByOwner() public {
        uint[] memory idList = getPlainsWalkersByOwner(acc0);
        Assert.equal(idList[0], uint(0), 'Hopefully it returns the one plainswalker acc0 owns');
    }
    
    /// #value: 0.02
    /// #sender: account-0 (sender is account at index '0')
    function testBuyPlainsWalker() public {
        h.purchasePlainsWalker{value: 0.02 ether}('John2');
        uint[] memory idList = getPlainsWalkersByOwner(acc0);
        Assert.equal(idList[2], uint(0), 'Hopefully it returns the two plainswalker acc0 owns');
    }
}