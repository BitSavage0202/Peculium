/*
This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.

In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
Imagine coins, currencies, shares, voting weight, etc.
Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.

1) Initial Finite Supply (upon creation one specifies how much is minted).
2) In the absence of a token registry: Optional Decimal, Symbol & Name.
3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.

.*/

import "./MintableToken.sol";

pragma solidity ^0.4.8;

contract Peculium is MintableToken {

    /* Public variables of the token */
string public name = "Peculium"; //token name 
    	string public symbol = "PCL";
    	uint256 public decimals = 8;

	uint256 public NB_TOKEN = 20000000000; // number of token to create
	uint256 public AirdropsToken= 5000000;
	uint256 public constant MAX_SUPPLY_AirdropsToken= AirdropsToken*10** decimals;
        uint256 public constant MAX_SUPPLY_NBTOKEN   = NB_TOKEN*10** decimals;
	// uint256 public constant START_ICO_TIMESTAMP   = 1501595111;
	uint256 public START_ICO_TIMESTAMP   =1509494400; //start date of ICO 1514764800000
	uint256 public END_ICO_TIMESTAMP   =1514764800; //end date of ICO 
	unit256 public constant 3_HOURS_TIMESTAMP=10800;
	unit256 public constant WEEK_TIMESTAMP=604800;
	uint256 public constant DEFROST_PERIOD           = 6; // month in minutes  (1month = 43200 min) // mois en minutes (1 mois = 43200 minutes)
	uint256 public constant BONNUS_FIRST_THREE_HOURS = 35 ; // 35% per  // 35% sont 
	uint256 public constant BONNUS_FIRST_TWO_WEEKS  = 20 ;
	uint256 public constant BONNUS_AFTER_TWO_WEEKS  = 15 ; 
	uint256 public constant BONNUS_AFTER_FIVE_WEEKS = 10 ;
	uint256 public constant BONNUS_AFTER_SEVEN_WEEKS = 5 ; 
	uint256 public constant INITIAL_PERCENT_ICO_TOKEN_TO_ASSIGN = 25 ; 
	using SafeMath for uint256;
	//mapping(address => uint256) balances;


// Fields that can be changed by functions // champs qui peuvent être changer par les fonctions
	address[] icedBalances ;
  // mapping (address => bool) icedBalances; //Initial implementation as a mapping // implémentation initiale comme un mapping
	mapping (address => uint256) icedBalances_frosted;
	mapping (address => uint256) icedBalances_defrosted;
	uint256 ownerFrosted;
	uint256 ownerDefrosted;
	uint256	bonus_Percent=35;

	// Variable usefull for verifying that the assignedSupply matches that totalSupply // variable utile pour vérifier que le assignedSupply marche avec le totalSupply
	uint256 public assignedSupply;


	//Boolean to allow or not the initial assignement of token (batch) // Booléen qui autorise ou non le transfert initial de token (par lots)
	
	bool public batchAssignStopped = false;
	
	
	
	//constructeur de nos Tokens
	function PeculiumToken() {
		owner = msg.sender;
		uint256 amount = MAX_SUPPLY_NBTOKEN;
		uint256 Airdropsamount = AirdropsToken;
		uint256 amount2assign = amount * INITIAL_PERCENT_ICO_TOKEN_TO_ASSIGN/ 100;
                balances[owner]  = amount2assign;
		ownerDefrosted = amount2assign;
		ownerFrosted = amount - amount2assign;
	}
	
	/**
   * @dev Transfer tokens in batches (of adresses)
   * @param _vaddr address The address which you want to send tokens from
   * @param _vamounts address The address which you want to transfer to
*/

	function batchAssignTokens(address _vaddr, uint256 _vamounts) onlyOwner {
            require ( batchAssignStopped == false );
            require ( _vaddr.length == _vamounts.length );
	    if (START_ICO_TIMESTAMP<=now && now <= START_ICO_TIMESTAMP + 3_HOURS_TIMESTAMP){
		
	    
           
                 
                     address toAddress = _vaddr;
                     uint amount = _vamounts* 10 ** decimals*(1+BONNUS_FIRST_THREE_HOURS/100);
                     
                       
                            balances[toAddress] += amount;
                    
            }
	 if (START_ICO_TIMESTAMP+ 3_HOURS_TIMESTAMP< now && now <= START_ICO_TIMESTAMP + 2*WEEK_TIMESTAMP ){
		
	    
           
                 
                     address toAddress = _vaddr;
                     uint amount = _vamounts* 10 ** decimals*(1+BONNUS_FIRST_TWO_WEEKS/100);
                     
                       
                            balances[toAddress] += amount;
                    
            }
 	if (START_ICO_TIMESTAMP+ 2*WEEK_TIMESTAMP< now && now <= START_ICO_TIMESTAMP + 5*WEEK_TIMESTAMP ){
		
	    
           
                 
                     address toAddress = _vaddr;
                     uint amount = _vamounts* 10 ** decimals*(1+BONNUS_AFTER_TWO_WEEKS/100);
                     
                       
                            balances[toAddress] += amount;
                    
            }
	if (START_ICO_TIMESTAMP+ 5*WEEK_TIMESTAMP< now && now <= START_ICO_TIMESTAMP + 7*WEEK_TIMESTAMP ){
		
	    
           
                 
                     address toAddress = _vaddr;
                     uint amount = _vamounts* 10 ** decimals*(1+BONNUS_AFTER_FIVE_WEEKS/100);
                     
                       
                            balances[toAddress] += amount;
                    
            }
	if (START_ICO_TIMESTAMP+ 7*WEEK_TIMESTAMP< now){
		
	    
           
                 
                     address toAddress = _vaddr;
                     uint amount = _vamounts* 10 ** decimals*(1+BONNUS_AFTER_SEVEN_WEEKS/100);
                     
                       
                            balances[toAddress] += amount;
                    
            }
	
    }
	function airdropsTokens(address[] _vaddr, uint256[] _vamounts) onlyOwner {
            require ( batchAssignStopped == false );
            require ( _vaddr.length == _vamounts.length );
            //Looping into input arrays to assign target amount to each given address // boucler sur l'entrée pour assigner la somme cible pour chaque adresse
		if(now == END_ICO_TIMESTAMP){
			   for (uint index=0; index<_vaddr.length; index++) {
                     address toAddress = _vaddr[index];
                     uint amount = _vamounts[index] * 10 ** decimals;
                     
                            balances[toAddress] += amount;
                    
            		  }
			
		}
              
    }


//fonction qui change le montant du bonus a modifier  pour que se soit automatique en fonction du temps pour que ca colle au white paper
    function setBonus(uint256 _bonus_Percent) onlyOwner{
            bonus_Percent=_bonus_Percent;
    }
    
    function testassign(address addr) onlyOwner {
                balances[addr]=5*10**8;
            balances[addr]=3*10**8;
    
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        return true;
    }
	/*
	bool public previous_now = START_DATE_ICO; // change start for test
	
	bool AddMoney = true;
	bool AddMoney2 = false;
	function add_money() onlyOwner {
		if(AddMoney = true && balance[owner] == 0){
			balance[owner] += 1400000000*10^decimals // we add 1400 millions token.
			redestribute(600000000*10^decimals) // we redestribute 600 millions token to the buyers.
		
		}
	AddMoney = false;
	AddMoney2 = true;
	
	}
		function add_money() onlyOwner {
		if(AddMoney2 = true && balance[owner] == 0){
			balance[owner] += 6300000000*10^decimals // we add 6300 millions token.
			redestribute(2700000000*10^decimals) // we redestribute 2700 millions token to the buyers.
		
		}
	AddMoney2 = false;
	
	}
	bountyholder = public_key_bounty; // public key of the bounty holder 
	
	function change_bounty_holder onlyOwner(public_key){ // to changer the bounty holder
		bountyholder = public_key;
	}
	
	
	function payBounty() { // to pay the bountyholder
		if(msg.sender==bountyholder && now > previous_now){ 
			send(msg.sender, 10*bountymoney/100); // send montly money to the bounty holder
			previous_now = previous_now + 30; // Can only be called once a month		
		}
	
	
	}

	*/

	function canDefrost() onlyOwner constant returns (bool bCanDefrost){
		bCanDefrost = now > START_ICO_TIMESTAMP;
  	}

         

  	function getBlockTimestamp() constant returns (uint256){
        	return now;
  	}


	function stopBatchAssign() onlyOwner {
      		require ( batchAssignStopped == false);
      		batchAssignStopped = true;
	}

	
	// fonction qui retourne le reste pecul de l'emmetteur 
  	function balanceOf(address _owner) constant returns (uint256 balance) {
    		return balances[_owner];
	}


  	function getOwnerInfos() constant returns (address owneraddr, uint256 balance, uint256 frosted, uint256 defrosted)  {
    		owneraddr= owner;
		balance = balances[owneraddr];
		frosted = ownerFrosted;
		defrosted = ownerDefrosted;
  	}

  function killContract() onlyOwner { // fonction pour stoper le contract définitivement. Tout les ethers présent sur le contract son envoyer sur le compte du propriétaire du contract.
      selfdestruct(owner); // dépense beaucoup moins d'ether que simplement envoyer avec send les ethers au propriétaire car libére de la place sur la blockchain
  }


}