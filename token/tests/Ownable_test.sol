pragma solidity >=0.4.22 <0.7.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../Ownable.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite is Ownable{
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    
    address acc0;
    address acc1;

    function beforeAll() public{
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
    }
    
    function ownerAssignedCorrectly() public{ 
        Assert.equal(owner(), acc0, 'Owener = address(0)');
    }
    
    /// #sender: account-0 (sender is account at index '0')
    function testTransferOwnership() public{
        transferOwnership(acc1);
        Assert.equal(owner(), acc1,  'Ownership transfered acc0->acc1');
    }

    /// #sender: account-1 (sender is account at index '1')
    function testIsOwner() public{
        Assert.equal(isOwner(), true,  'acc1 is acc1 true');
    }

    /// #sender: account-0 (sender is account at index '0')
    function testIsNotOwner() public{
        Assert.equal(isOwner(), false,  'acc0 != acc1 false');
    }

    /// #sender: account-1 (sender is account at index '1')
    function testrRenounceOwner() public{
        renounceOwnership();
        Assert.equal(owner(), address(0),  'Ownership renounced');
    }
    
}