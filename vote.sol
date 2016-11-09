pragma solidity ^0.4.2;

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
        _;
    }

    function kill() onlyOwner {
        selfdestruct(owner);
    }
}


contract BaseBallot is Owned {
    struct Voter {
        bool voted;
        uint8 vote;
    }
    
    struct Proposal {
        uint8 voteCount;
        uint32 date; //yyyymmdd
    }
    
    mapping(address => Voter) voters;
    Proposal[] proposals;

    function Ballot(uint8 numProposals) {
        proposals.length = numProposals;
    }
    
    function changeProposal(uint index, uint32 date) onlyOwner {
        if (index >= proposals.length || proposals[index].voteCount > 0) {
            throw;//up   
        }
        else {
            proposals[index].date = date;
        }
    }
    
    /// Give a single vote to proposal $(proposal).
    function vote(uint8 proposal) {
        Voter voter = voters[msg.sender];
        if (voter.voted || proposal >= proposals.length) throw;
        
        voter.voted = true;
        voter.vote = proposal;
    }
    
    function getProposal(uint8 index) constant returns (uint8 votes, uint32 date) {
        Proposal p = proposals[index];
        votes = p.voteCount;
        date = p.date;
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

contract Ballot is BaseBallot {}
