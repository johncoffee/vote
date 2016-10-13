// pragma solidity ^0.2.0;

contract Owned {

  function Owned() {
      owner = msg.sender;
  }

    // The owner of this registry.
    address public owner = msg.sender;

    // This contract only defines a modifier but does not use it - it will
    // be used in derived contracts.
    // The function body is inserted where the special symbol "_" in the
    // definition of a modifier appears.
    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _
    }

    function kill() onlyOwner {
        selfdestruct(owner);
    }
}


contract Ballot is Owned {
    struct Voter {
        bool voted;
        uint8 vote;
        address delegate;
    }
    
    struct Proposal {
        uint8 voteCount;
        uint timestamp;
    }
    
    mapping(address => Voter) voters;
    Proposal[] proposals;

    function Ballot() {
    }
    
    function getProposal(uint8 index) constant returns (uint8 votes, uint timestamp) {
        Proposal p = proposals[index];
        votes = p.voteCount;
        timestamp = p.timestamp;
    }

    /// Give a single vote to proposal $(proposal).
    function vote(uint8 proposal) {
        Voter sender = voters[msg.sender];
        if (sender.voted || proposal >= proposals.length) throw;
        
        sender.voted = true;
        sender.vote = proposal;
    }

    function getWinningProposalIndex() constant returns (uint8 winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 proposal = 0; proposal < proposals.length; proposal++)
            if (proposals[proposal].voteCount > winningVoteCount) {
                winningVoteCount = proposals[proposal].voteCount;
                winningProposal = proposal;
            }
    }
}
