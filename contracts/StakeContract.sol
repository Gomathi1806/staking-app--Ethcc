pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/* @title Mock Staking Contract for testing Staking Pool Contract */
contract StakeContract {
    using SafeMath for uint256;

    /** @dev creates contract
     */
    constructor() public {}

    /** @dev trigger notification of withdrawal
     */
    event NotifyWithdrawalSC(
        address sender,
        uint256 startBal,
        uint256 finalBal,
        uint256 request
    );

    /** @dev withdrawal funds out of pool
     * @param wdValue amount to withdraw
     * not payable, not receiving funds
     */
    function withdraw(uint256 wdValue) public {
        uint256 startBalance = address(this).balance;
        uint256 finalBalance = address(this).balance.sub(wdValue);

        // transfer & send will hit payee fallback function if a contract
        msg.sender.transfer(wdValue);

        emit NotifyWithdrawalSC(
            msg.sender,
            startBalance,
            finalBalance,
            wdValue
        );
    }

    event FallBackSC(address sender, uint256 value, uint256 blockNumber);

    function() external payable {
        // only 2300 gas available
        // storage data costs at least 5000 for initialized values, 20k for new
        emit FallBackSC(msg.sender, msg.value, block.number);
    }
}
