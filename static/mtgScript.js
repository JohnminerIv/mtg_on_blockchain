var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

const ethEnabled = () => {
  if (window.ethereum) {
    window.web3 = new Web3(window.ethereum);
    window.ethereum.enable();
    return true;
  }
  return false;
}

if (!ethEnabled()) {
    alert("Please install an Ethereum-compatible browser or extension like MetaMask to use this dApp!");
  }

function getAccounts(callback) {
    web3.eth.getAccounts((error,result) => {
        if (error) {
            console.log(error);
        } else {
            callback(result);
        }
    });
}

var LandContract = new web3.eth.Contract([
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "_owner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "_approved",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "Approval",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "_from",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "_to",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "Transfer",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_owner",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "_landId",
          "type": "uint256"
        }
      ],
      "name": "_collectManaFromLand",
      "outputs": [
        {
          "internalType": "uint16[5]",
          "name": "",
          "type": "uint16[5]"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "generateRandomLand",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_owner",
          "type": "address"
        }
      ],
      "name": "getLandByOwner",
      "outputs": [
        {
          "internalType": "uint256[]",
          "name": "",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_id",
          "type": "uint256"
        }
      ],
      "name": "getWhatTypeIsLand",
      "outputs": [
        {
          "internalType": "string",
          "name": "landtype",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "isOwner",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "landNames",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "landOwnerCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "landToOwner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "renounceOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "withdraw",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_owner",
          "type": "address"
        }
      ],
      "name": "balanceOf",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "ownerOf",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_from",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_to",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "safeTransferFrom",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_approved",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "approve",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    }
  ], '0xDEBAdF6f1D16a782D10D6026f444510468E8E788', {
    from: '0x1234567890123456789012345678901234567891', // default from address
    gasPrice: '20000000000' // default gas price in wei, 20 gwei in this case
});

var GameLogic = new web3.eth.Contract([
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "_owner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "_approved",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "Approval",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "PlainsWalkerId",
          "type": "uint256"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "name",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "dna",
          "type": "uint256"
        }
      ],
      "name": "NewPlainswalker",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "_from",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "_to",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "Transfer",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_plainsWalkerId",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_creatureIndex",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_targetPlainsWalkerId",
          "type": "uint256"
        }
      ],
      "name": "attackWithCreature",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_plainsWalkerId",
          "type": "uint256"
        },
        {
          "internalType": "string",
          "name": "_newName",
          "type": "string"
        }
      ],
      "name": "changeName",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_plainsWalkerId",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_landId",
          "type": "uint256"
        }
      ],
      "name": "collectManaFromLands",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_name",
          "type": "string"
        }
      ],
      "name": "createRandomPlainsWalker",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_id",
          "type": "uint256"
        }
      ],
      "name": "getCreatureInfoByIndex",
      "outputs": [
        {
          "internalType": "uint16",
          "name": "attack",
          "type": "uint16"
        },
        {
          "internalType": "uint16",
          "name": "defence",
          "type": "uint16"
        },
        {
          "internalType": "uint32",
          "name": "readyTime",
          "type": "uint32"
        },
        {
          "internalType": "bool",
          "name": "isDefending",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "getPlainsWalkerFee",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_owner",
          "type": "address"
        }
      ],
      "name": "getPlainsWalkersByOwner",
      "outputs": [
        {
          "internalType": "uint256[]",
          "name": "",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_id",
          "type": "uint256"
        }
      ],
      "name": "getPlainswalkerInfoById",
      "outputs": [
        {
          "internalType": "string",
          "name": "name",
          "type": "string"
        },
        {
          "internalType": "bool",
          "name": "isActive",
          "type": "bool"
        },
        {
          "internalType": "uint16",
          "name": "health",
          "type": "uint16"
        },
        {
          "internalType": "uint16[5]",
          "name": "mana",
          "type": "uint16[5]"
        },
        {
          "internalType": "uint256[]",
          "name": "creatureIndex",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "isOwner",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "ownerPlainsWalkerCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "plainsWalkerToOwner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_name",
          "type": "string"
        }
      ],
      "name": "purchasePlainsWalker",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    },
    {
      "inputs": [],
      "name": "renounceOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_plainsWalkerId",
          "type": "uint256"
        }
      ],
      "name": "revivePlainsWalker",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_plainsWalkerId",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_creatureIndex",
          "type": "uint256"
        }
      ],
      "name": "setCreatureToAttack",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_plainsWalkerId",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "_creatureIndex",
          "type": "uint256"
        }
      ],
      "name": "setCreatureToDefend",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_address",
          "type": "address"
        }
      ],
      "name": "setLandContractAddress",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_fee",
          "type": "uint256"
        }
      ],
      "name": "setPlainsWalkerFee",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_plainsWalkerId",
          "type": "uint256"
        },
        {
          "internalType": "uint16",
          "name": "red",
          "type": "uint16"
        },
        {
          "internalType": "uint16",
          "name": "green",
          "type": "uint16"
        },
        {
          "internalType": "uint16",
          "name": "blue",
          "type": "uint16"
        },
        {
          "internalType": "uint16",
          "name": "black",
          "type": "uint16"
        },
        {
          "internalType": "uint16",
          "name": "white",
          "type": "uint16"
        }
      ],
      "name": "summonCreature",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_owner",
          "type": "address"
        }
      ],
      "name": "balanceOf",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "ownerOf",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_from",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_to",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "safeTransferFrom",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_approved",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "_tokenId",
          "type": "uint256"
        }
      ],
      "name": "approve",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    }
  ], '0xDcEBd41Ae1B5Ee53eB0eC1Ee4cfD39Cc9DfEb24b', {
    from: '0x1234567890123456789012345678901234567891', // default from address
    gasPrice: '20000000000' // default gas price in wei, 20 gwei in this case
});

// LandContract.methods.landNames([0])


LandContract.methods.landNames(0).call({from: getAccounts(function(result) { return String(result[0]);})}).then(function(result){
    console.log(result)
});;

function createRandomPlainsWalker(){
    getAccounts(function(result){
        var nameText = document.getElementById('plainsWalkerName');
        GameLogic.methods.createRandomPlainsWalker(nameText.value).send({from: String(result[0])}).then(function(result){
            console.log(result)
        });
        nameText.value = 'Name'
    })
}

function returnLandNameRed(){
    getAccounts(function(result){
        LandContract.methods.landNames(0).call({from: String(result[0])}).then(function(result){
            document.getElementById("landList").remove()
            var node = document.createElement("UL")
            node.setAttribute('id', "landList")
            document.getElementById('lands').appendChild(node)
            var node = document.createElement("LI");
            var textnode = document.createTextNode(result);
            node.appendChild(textnode);
            document.getElementById("landList").appendChild(node);
            console.log(result)
        });
    });
}

function displayCreatures() {
    getAccounts(function(result){
    });

}
function summonCreature() {

}
function displayLands() {
    getAccounts(function(resultAcc){
        LandContract.methods.getLandByOwner(String(resultAcc[0])).call({from: String(resultAcc[0])}).then(function(result){
            document.getElementById("landList").remove()
            var node = document.createElement("UL")
            node.setAttribute('id', "landList")
            document.getElementById('lands').appendChild(node)
            for (let i = 0; i < result.length; i++) {
                var node = document.createElement("LI");
                node.setAttribute('id', 'land'+String(i))
                var textnode = document.createTextNode('Id = ' + result[i]);
                node.appendChild(textnode);
                var btn = document.createElement('BUTTON')
                btn.setAttribute('onclick', 'collectMana(' + String(result[i]) + ')')
                btn.textContent = 'Collect mana'

                document.getElementById("landList").appendChild(node);
                document.getElementById("landList").appendChild(btn);
                console.log(result[i])
            }
            for (let i = 0; i < result.length; i++) {
                LandContract.methods.getWhatTypeIsLand(result[i]).call({from: String(resultAcc[0])}).then(function(resultInner){
                    var textnode = document.createTextNode(' Land type = ' + resultInner);
                    var node = document.getElementById('land'+String(i))
                    node.appendChild(textnode);
                    console.log(resultInner)
                });
            }
        });
    });
}
function displayPlainsWalkers() {
    getAccounts(function(resultAcc){
        GameLogic.methods.getPlainsWalkersByOwner(String(resultAcc[0])).call({from: String(resultAcc[0])}).then(function(result){
            document.getElementById("PlainswalkerList").remove()
            var node = document.createElement("UL")
            node.setAttribute('id', "PlainswalkerList")
            document.getElementById('Plainswalkers').appendChild(node)
            for (let i = 0; i < result.length; i++) {
                var node = document.createElement("LI");
                node.setAttribute('id', 'plainW'+String(i))
                document.getElementById("PlainswalkerList").appendChild(node);
                console.log(result)
            }
            for (let i = 0; i < result.length; i++) {
                GameLogic.methods.getPlainswalkerInfoById(result[i]).call({from: String(resultAcc[0])}).then(function(resultInner){
                    var textnode = document.createTextNode(' Plainwalker Info = ' + String(resultInner));
                    var node = document.getElementById('plainW'+String(i));
                    var textnode = document.createTextNode('Name = ' + resultInner[0]);
                    node.appendChild(textnode);
                    var textnode = document.createTextNode(' isActive = ' + String(resultInner.isActive));
                    node.appendChild(textnode);
                    var textnode = document.createTextNode(' health = ' + String(resultInner.health));
                    node.appendChild(textnode);
                    var textnode = document.createTextNode(' mana = ' + String(resultInner.mana));
                    node.appendChild(textnode);
                    var textnode = document.createTextNode(' creatureIndex = ' + String(resultInner.creatureIndex));
                    node.appendChild(textnode);
                    console.log(resultInner);
                });
                
            }
            var node = document.createElement("LI");
            var textnode = document.createTextNode(result);
            node.appendChild(textnode);
            document.getElementById("landList").appendChild(node);
            console.log(result)
        });
    });
}
function collectMana(landId) {
    getAccounts(function(result){
        LandContract.methods.generateRandomLand().send({from: String(result[0]), value:web3.utils.toWei('0.005', "ether")}).then(function(result){
            console.log(result)
        });
    });
}
function purchaseLand() {
    getAccounts(function(result){
        LandContract.methods.generateRandomLand().send({from: String(result[0]), value:web3.utils.toWei('0.005', "ether")}).then(function(result){
            console.log(result)
        });
    });
}
console.log('Beep')

