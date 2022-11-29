// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract BetaFactory{
    address payable public BetaFactoryWallet;
    IERC20 public PPTTToken;

    constructor(address _token){
        BetaFactoryWallet = payable(msg.sender);
        PPTTToken = IERC20(_token);
    }

    struct challenger{
        bool open;
        bytes32 poolType;
        bytes32[4] answers;
        address challengedBy;
    }

    struct predictions{
        address predictedBy;
        uint256 predictionAmount;
        bytes32[] answers;
        bytes32 fixtureId;
        bytes32 questionaireId;
        challenger _challenger;
    }

    // @note initial Prediction Setup
    function _initialPredictSetup(address _predictedBy,
        uint256 _predictionAmount,
        bytes32[] memory _answers,
        bytes32 _fixtureId,
        bytes32 _questionaireId) private pure returns (bool) {
            bool success = false;

            challenger memory _initialChallenger;
            _initialChallenger.open = false;
            _initialChallenger.poolType = "";

            for(uint i=0; i<3; ++i){
                _initialChallenger.answers[i] = "";
            }
            
            _initialChallenger.challengedBy = address(0);

            predictions memory _prediction;
            _prediction.predictedBy = _predictedBy;
            _prediction.predictionAmount = _predictionAmount;

            for(uint i=0; i<3; ++i){
                _prediction.answers[i] = _answers[i];
            }

            _prediction.fixtureId = _fixtureId;
            _prediction.questionaireId = _questionaireId;
            _prediction._challenger = _initialChallenger;
            success = true;
            return success;
    }

    // @note main predcition setup
    function predictAnswer(
        address _predictedBy,
        uint256 _predictionAmount,
        bytes32[] memory _answers,
        bytes32 _fixtureId,
        bytes32 _questionaireId
    ) public payable {
        // @note _prediction amount is on decimals of 18
        require(_predictionAmount <= PPTTToken.balanceOf(msg.sender), "User don't have enough PPTT balance.");

        require(_initialPredictSetup(_predictedBy, _predictionAmount, _answers, _fixtureId, _questionaireId), "Initial setup is not yet completed!");

        PPTTToken.transferFrom(msg.sender, address(this), _predictionAmount);
    }

    // @note on new challenger request
    function challengePredict()public view{}

    function restoreETHtoFactoryWallet()public view{}

    function restorePPTTtoFactoryWallet()public view{}
}