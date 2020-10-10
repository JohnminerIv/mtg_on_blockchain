pragma solidity >=0.4.22 <0.7.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../GameLogic.sol";
import "../LandFactory.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite is LandFactory, GameLogic{
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    address acc0;
    address acc1;
    LandFactory l;
    GameLogic g;
    
    /// #sender: account-0
    function beforeAll() public{
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
        l = new LandFactory();
        g = new GameLogic();
    }

/// CreatureFactory ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function testCreateCreature() public {
        uint[5] memory mana = [uint(1), 3, 1, 0,1];
        Creature memory creature = createCreature(mana);
        Assert.equal(creature.id, uint(0), 'Creature generated with id 0');
    }

    function testDefendBoolFalse() public {
        uint[5] memory mana = [uint(1), 3, 1, 0,1];
        Assert.equal(createCreature(mana).isDefending, false, 'Creatures must be set to defending');
    }

/// plainsWalkerFactory ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /// #sender: account-0
    function createFirstFreePlainsWalker() public {
        g.createRandomPlainsWalker('John');
        string memory name;
        (name,,) = g.getPlainswalkerInfoById(0);
        Assert.equal(name, 'John', 'Created a plainsWalker named John');
    }

    /// #sender: account-0
    function createSecondFreePlainsWalker() public {
        g.createRandomPlainsWalker('Zoe');
        string memory name;
        (name,,) = g.getPlainswalkerInfoById(1);
        Assert.equal(name, 'Zoe', 'Created a plainsWalker named Zoe, but this will revert because you can\'t have 2 free plainswalkers');
    }

    /// #sender: account-1
    function createFirstFreePlainsWalkerSecondAccount() public {
        g.createRandomPlainsWalker('Zoe');
        string memory name;
        (name,,) = g.getPlainswalkerInfoById(1);
        Assert.equal(name, 'Zoe', 'This one should work.');
    }
    
    /// #sender: account-1
    function renamePlainswalkerFail() public {
        g.changeName(uint(0), "John sucks at solidity");
        string memory name;
        (name,,) = g.getPlainswalkerInfoById(1);
        Assert.equal(name, 'John', 'Function should revert as acc1 is not owner of plainsWalkers[0]');
    }

    /// #sender: account-1
    function renamePlainswalkerSuccess() public {
        g.changeName(uint(1), "Zoe Is Amazing");
        Assert.equal(plainsWalkers[1].name, "Zoe Is Amazing", 'Function should pass and change name because acc-1 owns plainsWalkers[1]');
    }


/// plainsWalkerHelper ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// #sender: account-0 (sender is account at index '0')
    function testSetPlainsWalkerFee() public {
        g.setPlainsWalkerFee(0.5 ether);
        Assert.equal(g.getPlainsWalkerFee(), 0.5 ether, 'I want all the money and acc0 should own so this should pass');
    }
    
    /// #sender: account-1 (sender is account at index '1')
    function testFailSetPlainsWalkerFee() public {
        g.setPlainsWalkerFee(0.1 ether);
        Assert.equal(g.getPlainsWalkerFee(), 0.1 ether, 'acc1 does not own so this should pass');
    }
    
    /// #sender: account-0 (sender is account at index '0')
    function testGetPlainsWalkerByOwner() public {
        uint[] memory idList = getPlainsWalkersByOwner(acc0);
        Assert.equal(idList[0], uint(0), 'Hopefully it returns the one plainswalker acc0 owns');
    }
    
    /// #value: 0.02
    /// #sender: account-0 (sender is account at index '0')
    function testBuyPlainsWalker() public {
        g.purchasePlainsWalker('John2');
        uint[] memory idList = getPlainsWalkersByOwner(acc0);
        Assert.equal(idList[2], uint(0), 'Hopefully it returns the two plainswalker acc0 owns');
    }


/// LandFactory ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /// #sender: account-0
    function testRandomLand() public{
        l.generateRandomLand();
        Assert.equal(l.landToOwner[0], acc0, 'The first land should map to the first msg.sender');
    }

    /// #sender: account-0
    function testRandomLandMoreThanOneFail() public{
        l.generateRandomLand();
        Assert.equal(l.landToOwner[1], acc0, 'The first land should map to the first msg.sender');
    }
    
    
    /// #value: 99999999999999
    /// #sender: account-0
    function testRandomLandMoreThanOneSuccess() public payable{
        
        l.generateRandomLand();
        Assert.equal(l.landToOwner[1], acc0, 'The first land should map to the first msg.sender');
    }

/// GameLogic /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /*
    I can't actually test GameLogic at all, it costs too much gas to deploy because the files are too large.
    */
}