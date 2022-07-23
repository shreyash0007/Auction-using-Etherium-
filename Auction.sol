// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// creating contract named Auction
contract Auction
{
    // defining auction parameters
    address public OwnerAddress;
    uint256 public end_time;
    uint256 public top_bid;
    address public top_bidder; 

    // Initializing a boolean variable to ensure that auction is completed
    bool complete;

    // When the top bid increases then this event will be executed
    event topBidIncreased(address bidder, uint256 bidAmount);
    
    // Defining auction function
    function auction (address owner, uint256 biddingTime)
    public
    {
        // auction owner address
        OwnerAddress = owner;
        // closing time of auction
        end_time = block.timestamp + biddingTime;
    }

    // defining biding function to carry out the transaction part 
    function biding()
    public
    payable
    {
        // Checking the validity of address of the bidder, if the bid placed within time (before end time), if bid amount is greater than lowest bid 
        require(top_bidder != address(0));
        require(block.timestamp <= end_time);
        require(top_bid > 1);  // top_bid > 1 ether (min bid)

        // check if the amount is greater then top bid  
        require(msg.value > top_bid);

        // if all the above conditions meet then excute the below lines 
        // setting new top bidder and new top bid and then emit the event topBidIncreased
        top_bidder = msg.sender;
        top_bid = msg.value;
        emit topBidIncreased(msg.sender, msg.value);
    }

    // this event will execute after auction is closed
    event auction_Result(address winner, uint256 bidAmount);

    /// Auction ends and highest bid is sent
    /// to the beneficiary.

    function auctionClose()
    public
    {
        // checking conditions
        require(block.timestamp >= end_time); // auction not complete
        require(!complete);

        // if time exceeds the end time then,
        complete = true;
        emit auction_Result(top_bidder, top_bid);

        // transfering top_bid amount to the owner of the auction
        payable(OwnerAddress).transfer(top_bid);
    }
}