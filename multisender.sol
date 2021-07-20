// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract multisender{
    
    address owner;
    uint256 charges = 0.0001 ether;
    constructor(){
        owner = msg.sender;
        
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, 'This functionality is restricted to only the owner');
        _;
    }
    

    IERC20 tokenInstance;
    uint256 tokenDecimal;
    event MultiSend(address indexed _token, address indexed recipient, uint256 amount);
    
    function _setToken(address _tokenAddress, uint256  _tokenDecimal) internal {
        tokenInstance = IERC20(_tokenAddress);
        tokenDecimal = _tokenDecimal;
    }
    
    //0xd92e713d051c37ebb2561803a3b5fbabc4962431 usdt on rinkeby
    // ["0xdAF27B1c21123715b2A192fB30aE7ED4Ae7D0fB2","0x9EBc73B1702B5894e4571c207b25208db881bb7e"]
    
    function multiSend(address _tokenAddress, uint256 _decimal, address[]memory _recipients, uint256[]memory _amounts) public payable returns(bool){
        require(_recipients.length == _amounts.length, "No of addresses is not matching number of amounts");
        require(msg.value == charges, string(abi.encodePacked("charges cannot be less or more than", charges)));
        _setToken(_tokenAddress, _decimal);
        
        for(uint256 i=0; i<_recipients.length; i++){
            //front-end dev should call transfer function in token contract
                tokenInstance.transferFrom(msg.sender,_recipients[i], _amounts[i]*10**tokenDecimal);
                emit MultiSend(_tokenAddress, _recipients[i], _amounts[i]);
            
        }
        
        
        return true;
    }
    
    
    
    function withdraw(uint256 _amount, address payable _walletAdress) public onlyOwner {
        require(_amount <= address(this).balance, 'insufficient funds');
        _walletAdress.transfer(_amount);
        
    }
    
    
    function checkContractBalance()public view returns(uint256){
        return address(this).balance;
    }
    
    function setCharges(uint256 _newCharge) public onlyOwner{
        charges = _newCharge;
        
    }
    
    function viewCharges() public view returns(uint256){
        return charges;
    }
    
  
    
    fallback () external payable {
    }

    
}