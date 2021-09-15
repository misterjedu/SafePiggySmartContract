// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SafePiggyToken is ERC20 {
    
      constructor() ERC20("Safe Piggy Token", "SPT") {
        
        _mint(msg.sender, 1000000 * 10 ** 18);
        
    }
    
    
      /*
        While the transfer(from) from the ERC20 implementation works well, when called from an outside function, 
        the msg.sender from the outside function returns another address different from the msg.sender in the inner function.
        Therefore extra functions are created to pass the actual "from" address
    
    */
    
     function transferFromAddress(
        address from,
        address sender,
        address recipient,
        uint256 amount
    ) public  returns (bool) {
        
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = allowance(sender, from);
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, from, currentAllowance - amount);
        }

        return true;
    }
    
    
    function transferAddress(address from, address recipient, uint256 amount) public returns (bool) {
        _transfer(from, recipient, amount);
        return true;
    }
    
    
   function approveAddress(address from,address spender, uint256 amount) public returns (bool) {
        _approve(from, spender, amount);
        return true;
    }
 
    
}