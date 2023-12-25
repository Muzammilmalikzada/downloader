// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

///////////////////////////////////////////////////////////////////////////
//                                                                       //
//   ██████╗░███████╗███╗░░██╗██████╗░███████╗██████╗░███████╗██████╗░   //
//   ██╔══██╗██╔════╝████╗░██║██╔══██╗██╔════╝██╔══██╗██╔════╝██╔══██╗   //
//   ██████╔╝█████╗░░██╔██╗██║██║░░██║█████╗░░██████╔╝█████╗░░██████╔╝   //
//   ██╔══██╗██╔══╝░░██║╚████║██║░░██║██╔══╝░░██╔══██╗██╔══╝░░██╔══██╗   //
//   ██║░░██║███████╗██║░╚███║██████╔╝███████╗██║░░██║███████╗██║░░██║   //
//   ╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝╚═════╝░╚══════╝╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝   //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

import "./Strings.sol";

import "./IRenderer.sol";
import "./IRoshambo.sol";

/// @title Renderer
/// @author swaHili (swa.eth)
/// @notice Renders the svg metadata for Roshambo
contract Renderer is IRenderer {
    using Strings for uint256;

    function generateImage(
        uint256 _tokenId,
        uint256 _pot,
        address _player1,
        Choice _choice1,
        address _player2,
        Choice _choice2
    ) external pure returns (string memory svg) {
        svg = ROOT;
        (string memory _block, string memory _paper, string memory _scissors) = generatePalette(
            _tokenId,
            _pot,
            _player1,
            _choice1,
            _player2,
            _choice2
        );
        if (
            (_choice1 == Choice.NONE || _choice1 == Choice.HIDDEN) &&
            (_choice2 == Choice.NONE || _choice2 == Choice.HIDDEN)
        ) {
            svg = string.concat(svg, _generateGame(_block, _paper, _scissors));
        } else {
            svg = string.concat(
                svg,
                "<g transform='scale (-1, 1)' transform-origin='center'>",
                _generateBlock(_block),
                _generateAnimation(),
                "</path></g>"
            );
            if (_choice1 == Choice.BLOCK)
                svg = string.concat(svg, TRANSFORM, _generateBlock(_block), REVEAL);
            if (_choice1 == Choice.PAPER)
                svg = string.concat(svg, "<g opacity='0'>", _generatePaper(_paper), REVEAL);
            if (_choice1 == Choice.SCISSORS)
                svg = string.concat(svg, TRANSFORM, _generateScissors(_scissors), REVEAL);

            svg = string.concat(
                svg,
                "<g>",
                _generateBlock(_block),
                _generateAnimation(),
                "</path></g>"
            );
            if (_choice2 == Choice.BLOCK)
                svg = string.concat(svg, "<g opacity='0'>", _generateBlock(_block), REVEAL);
            if (_choice2 == Choice.PAPER)
                svg = string.concat(svg, TRANSFORM, _generatePaper(_paper), REVEAL);
            if (_choice2 == Choice.SCISSORS)
                svg = string.concat(svg, "<g opacity='0'>", _generateScissors(_scissors), REVEAL);
        }

        svg = string.concat(svg, "</svg>");
    }

    function generatePalette(
        uint256 _tokenId,
        uint256 _pot,
        address _player1,
        Choice _choice1,
        address _player2,
        Choice _choice2
    ) public pure returns (string memory _block, string memory _paper, string memory _scissors) {
        bytes32 hash = keccak256(
            abi.encodePacked(_tokenId, _pot, _player1, _choice1, _player2, _choice2)
        );

        uint256 index = _tokenId % 31;
        uint256 r = uint8(hash[index]) % 256;
        uint256 g = uint8(hash[index + 1]) % 256;
        uint256 b = uint8(hash[index + 2]) % 256;

        uint256 min = 30;
        uint256 max = 225;
        r = (r % (max - min)) + min;
        g = (g % (max - min)) + min;
        b = (b % (max - min)) + min;

        _block = string.concat("rgb(", r.toString(), ",", g.toString(), ",", b.toString(), ")");
        _paper = string.concat("rgb(", g.toString(), ",", b.toString(), ",", r.toString(), ")");
        _scissors = string.concat("rgb(", b.toString(), ",", r.toString(), ",", g.toString(), ")");
    }

    function getChoice(Choice _choice) external pure returns (string memory choice) {
        if (_choice == Choice.NONE) {
            choice = "None";
        } else if (_choice == Choice.HIDDEN) {
            choice = "Hidden";
        } else if (_choice == Choice.BLOCK) {
            choice = "Block";
        } else if (_choice == Choice.PAPER) {
            choice = "Paper";
        } else if (_choice == Choice.SCISSORS) {
            choice = "Scissors";
        }
    }

    function getStage(Stage _stage) external pure returns (string memory stage) {
        if (_stage == Stage.PENDING) {
            stage = "Pending";
        } else if (_stage == Stage.COMMIT) {
            stage = "Commit";
        } else if (_stage == Stage.REVEAL) {
            stage = "Reveal";
        } else if (_stage == Stage.SETTLE) {
            stage = "Settle";
        } else if (_stage == Stage.DRAW) {
            stage = "Draw";
        } else if (_stage == Stage.SUCCESS) {
            stage = "Success";
        }
    }

    function _generateGame(
        string memory _block,
        string memory _paper,
        string memory _scissors
    ) internal pure returns (string memory) {
        return
            string.concat(
                "<g><path fill='",
                _block,
                "' d='m697.2 548.4c10.801 7.1992 25.199 10.801 39.602 6 19.199-6 32.398-25.199 32.398-45.602v-42c16.801-9.6016 28.801-26.398 31.199-46.801l8.3984-61.199c4.8008-32.398-6-66-27.602-91.199l-54-62.398v-49.199c0-8.3984-6-14.398-14.398-14.398s-14.398 6-14.398 14.398v55.199c0 3.6016 1.1992 7.1992 3.6016 9.6016l57.602 66c16.801 19.199 24 43.199 20.398 68.398l-8.3984 61.199c-2.3984 18-18 31.199-36 30l-74.398-1.1992c-9.6016 0-16.801-7.1992-16.801-16.801 0-4.8008 2.3984-8.3984 4.8008-12 3.6016-3.6016 7.1992-4.8008 12-4.8008l50.398 2.3984c7.1992 0 13.199-4.8008 14.398-12l4.8008-32.398c1.1992-8.3984-4.8008-15.602-12-16.801s-15.602 4.8008-16.801 12l-2.3984 16.801c-50.398-24-46.801-73.199-46.801-75.602 1.1992-8.3984-4.8008-14.398-13.199-15.602h-1.1992c-7.1992 0-13.199 6-14.398 13.199-2.3984 20.398 3.6016 54 28.801 80.398-9.6016 1.1992-19.199 4.8008-26.398 12-3.6016 3.6016-6 7.1992-8.3984 10.801-7.1992-4.8008-15.602-7.1992-25.199-7.1992-14.398 0-27.602 7.1992-36 18-7.1992-6-16.801-8.3984-26.398-8.3984-7.1992 0-13.199 1.1992-19.199 4.8008-7.1992-40.801-8.3984-82.801-8.3984-112.8 0-26.398 14.398-50.398 36-64.801l13.199-8.3984c4.8008-2.3984 7.1992-7.1992 7.1992-12v-57.602c0-8.3984-6-14.398-14.398-14.398s-14.398 6-14.398 14.398v49.199l-2.4141 1.207c-31.199 19.199-49.199 52.801-50.398 88.801 0 37.199 1.1992 91.199 13.199 140.4-1.1992 4.8008-2.3984 9.6016-2.3984 14.398v46.801c0 25.199 20.398 48 45.602 48 10.801 0 19.199-3.6016 27.602-8.3984 8.3984 10.801 21.602 18 36 18 9.6016 0 19.199-3.6016 26.398-8.3984 8.3984 10.801 21.602 19.199 37.199 19.199 14.398-1.2031 27.598-8.4023 35.996-19.203zm8.4023-74.398 28.801 1.1992h4.8008v36c0 9.6016-7.1992 16.801-16.801 16.801-9.6016 0-16.801-7.1992-16.801-16.801zm-153.6 27.602c0 9.6016-7.1992 16.801-16.801 16.801-9.6016 0-16.801-7.1992-16.801-16.801v-49.199c0-9.6016 7.1992-16.801 16.801-16.801 9.6016 0 16.801 7.1992 16.801 16.801zm62.398 8.3984c0 9.6016-7.1992 16.801-16.801 16.801-9.6016 0-16.801-7.1992-16.801-16.801l0.003906-66c0-9.6016 7.1992-16.801 16.801-16.801 9.6016 0 16.801 7.1992 16.801 16.801zm28.801 10.801v-51.602c6 2.3984 12 3.6016 18 4.8008h15.602v46.801c0 9.6016-7.1992 16.801-16.801 16.801s-16.801-7.2031-16.801-16.801z'/><path fill='",
                _scissors,
                "' d='m546 687.6c-10.801-4.8008-24-6-34.801-1.1992l-108 39.602 72-60c19.199-15.602 21.602-45.602 6-64.801-16.801-19.199-45.602-21.602-64.801-6l-128.4 106.8c-16.801-12-39.602-14.398-60-6l-57.602 24c-31.199 13.199-54 38.398-64.801 69.602l-26.398 78-43.199 25.199c-7.1992 3.6016-9.6016 13.199-4.8008 19.199s13.199 9.6016 19.199 4.8008l48-27.602c3.6016-1.1992 4.8008-4.8008 6-8.3984l27.602-82.801c8.3984-24 25.199-43.199 49.199-52.801l57.602-24c16.801-7.1992 34.801 0 44.398 14.398v1.1992l36 64.801c4.8008 8.3984 1.1992 18-6 22.801-3.5977 3.6016-8.3984 3.6016-13.199 2.4023s-8.3984-4.8008-9.6016-8.3984l-24-45.602c-3.6016-6-10.801-9.6016-18-7.1992l-30 12c-7.1992 2.3984-10.801 10.801-8.3984 18 2.3984 7.1992 10.801 10.801 18 8.3984l15.602-6c4.8008 55.199-39.602 76.801-42 78-7.1992 3.6016-10.801 12-7.1992 19.199 0 0 0 1.1992 1.1992 1.1992 3.6016 6 12 9.6016 18 6 18-8.3984 44.398-30 55.199-64.801 6 7.1992 14.398 13.199 24 15.602 4.8008 1.1992 9.6016 2.3984 15.602 1.1992 0 6 0 13.199 2.3984 19.199 1.1992 2.3984 2.3984 4.8008 3.6016 7.1992 6 9.6016 15.602 16.801 25.199 20.398-3.6016 10.805-3.6016 20.406 0 30.004 1.1992 2.3984 2.3984 4.8008 3.6016 7.1992 3.6016 6 8.3984 10.801 13.199 14.398-30 24-62.398 43.199-86.398 57.602-22.801 13.199-50.398 13.199-74.398 1.1992l-14.398-7.1992c-4.8008-2.3984-9.6016-2.3984-14.398 0l-49.207 27.602c-7.1992 3.6016-9.6016 13.199-4.8008 19.199 3.6016 7.1992 13.199 9.6016 19.199 4.8008l43.199-25.199 7.1992 3.6016c32.398 16.801 70.801 16.801 102-1.1992 30-16.801 72-43.199 108-74.398 2.3984 0 3.6016-1.1992 6-1.1992l45.602-16.801c24-8.3984 36-34.801 27.602-58.801-3.6016-9.6016-9.6016-16.801-18-21.602 1.1992-1.1992 2.3984-3.6016 3.6016-4.8008 4.8008-10.801 6-24 1.1992-34.801-2.3984-6-4.8008-10.801-8.3984-14.398l92.398-33.602c12-3.6016 20.398-12 26.398-24 4.8008-10.801 6-24 1.1992-34.801-4.8008-12-13.199-20.398-24-26.398zm-237.6 36s0-1.1992-1.1992-1.1992l126-105.6c7.1992-6 18-4.8008 24 2.3984 1.1992 1.1992 1.1992 1.1992 1.1992 2.3984 3.6016 7.1992 2.3984 16.801-3.6016 21.602l-130.8 109.2zm37.203 151.2c-3.6016-2.3984-7.1992-4.8008-8.3984-9.6016-3.6016-8.3984 1.1992-19.199 9.6016-21.602l62.398-22.801c4.8008-1.1992 8.3984-1.1992 13.199 0 3.6016 1.1992 6 3.6016 7.1992 7.1992 0 1.1992 1.1992 1.1992 1.1992 2.3984 1.1992 4.8008 1.1992 8.3984-1.1992 13.199-2.3984 3.6016-4.8008 7.1992-9.6016 8.3984l-62.398 22.801c-3.6016 2.4062-8.4023 2.4062-12 0.007812zm98.398 31.199c-2.3984 3.6016-4.8008 7.1992-9.6016 8.3984l-45.602 16.801c-4.8008 1.1992-8.3984 1.1992-13.199 0-4.8008-1.1992-7.1992-4.8008-8.3984-9.6016-1.1992-4.8008-1.1992-8.3984 0-13.199 2.3984-3.6016 6-7.1992 9.6016-8.3984l45.602-16.801c8.3984-3.6016 19.199 1.1992 21.602 9.6016 2.3945 4.8008 2.3945 8.3984-0.003906 13.199zm97.199-169.2c-2.3984 3.6016-4.8008 7.1992-9.6016 8.3984l-182.4 66c0-7.1992-1.1992-15.602-4.8008-22.801l-4.8008-9.6016 181.2-66c4.8008-1.1992 8.3984-1.1992 13.199 0 3.6016 2.3984 7.1992 4.8008 8.3984 9.6016 1.207 6 1.207 9.6016-1.1953 14.402z'/><path fill='",
                _paper,
                "' d='m1162.8 882-42-24-21.602-70.801c-9.6016-33.602-32.398-61.199-63.602-78l-90-48c-21.602-12-48-4.8008-61.199 16.801-1.1992 1.1992-1.1992 3.6016-2.3984 4.8008l-97.199-54c-21.602-12-50.398-4.8008-62.398 16.801-3.6016 6-4.8008 13.199-6 20.398-18-2.3984-36 6-45.602 22.801-9.6016 16.801-7.1992 37.199 3.6016 50.398-6 3.6016-10.801 8.3984-14.398 15.602-12 21.602-4.8008 50.398 16.801 62.398l16.801 9.6016c-4.8008 3.6016-8.3984 8.3984-10.801 13.199-12 21.602-4.8008 50.398 16.801 62.398l61.199 34.801c14.398 8.3984 30 18 46.801 32.398l2.3984 1.1992c38.398 30 139.2 108 212.4 61.199l42 24c7.1992 3.6016 15.602 1.1992 19.199-6 3.6016-7.1992 1.1992-15.602-6-19.199l-49.199-27.602c-4.8008-2.3984-10.801-2.3984-15.602 1.1992-56.398 44.398-150-28.801-186-56.398l-2.3984-1.1992c-18-14.398-34.801-25.199-50.398-33.602l-61.199-34.801c-8.3984-4.8008-10.801-14.398-6-22.801 4.8008-8.3984 15.602-10.801 22.801-6l90 50.398c7.1992 3.6016 15.602 1.1992 19.199-6 3.6016-7.1992 1.1992-15.602-6-19.199l-140.41-82.793c-8.3984-4.8008-10.801-15.602-6-22.801 4.8008-8.3984 14.398-10.801 22.801-6l123.6 69.602c7.1992 3.6016 15.602 1.1992 19.199-4.8008 3.6016-7.1992 1.1992-15.602-6-19.199l-144-81.602c-8.3984-4.8008-10.801-15.602-6-22.801 4.8008-8.3984 15.602-10.801 22.801-6l133.2 75.602c7.1992 3.6016 15.602 1.1992 19.199-6 3.6016-7.1992 1.1992-15.602-6-19.199l-112.8-63.602c-8.3984-4.8008-10.801-15.602-6-22.801 4.8008-8.3984 14.398-10.801 22.801-6l108 61.199c3.6016 12 10.801 22.801 21.602 28.801l31.199 18c-25.199 100.8 54 134.4 55.199 134.4 7.1992 2.3984 14.398 0 18-6 0 0 0-1.1992 1.1992-1.1992 2.3984-7.1992-1.1992-15.602-8.3984-18-2.3984-1.1992-54-22.801-40.801-92.398 3.6016 2.3984 8.3984 6 12 9.6016l7.1992 6c6 4.8008 14.398 4.8008 20.398-1.1992 4.8008-6 4.8008-14.398-1.1992-20.398l-7.1992-6c-7.1992-13.203-15.598-20.402-26.398-25.203l-45.602-26.398c-4.8008-2.3984-7.1992-6-8.3984-10.801s0-9.6016 2.3984-13.199c4.8008-8.3984 15.602-10.801 22.801-6l90 48c24 13.199 42 34.801 50.398 61.199l22.801 76.801c1.1992 3.6016 3.6016 6 7.1992 8.3984l46.801 26.398c7.1992 3.6016 15.602 1.1992 19.199-6 4.8008-7.1992 2.4023-16.797-4.7969-20.398z'/></g>"
            );
    }

    function _generateAnimation() internal pure returns (string memory) {
        return
            "<animate attributeName='opacity' from='1' to='0' begin='6s' dur='0.5s' fill='freeze'/><animateTransform attributeName='transform' attributeType='XML' type='scale' keyTimes='0; 0.5; 1' keySplines='0.42 0 1 1; 0.42 0 1 1' values='1; 0.8; 1' begin='0s' dur='2s' repeatCount='3' calcMode='spline'/><animateTransform attributeName='transform' attributeType='XML' type='rotate' keyTimes='0; 0.5; 1' keySplines='0.42 0 1 1; 0.42 0 1 1' values='0; -10; 0' begin='0s' dur='2s' additive='sum' repeatCount='3' calcMode='spline'/>";
    }

    function _generateBlock(string memory _fill) internal pure returns (string memory) {
        return
            string.concat(
                "<path fill='",
                _fill,
                "' d='m868.8 459.6 67.199-8.3984c27.602-3.6016 54 4.8008 74.398 22.801l72 63.602c2.3984 2.3984 6 3.6016 10.801 3.6016h60c8.3984 0 15.602-7.1992 15.602-15.602 0-8.3984-7.1992-15.602-15.602-15.602h-54l-68.398-60c-27.602-24-63.602-34.801-99.602-30l-67.199 8.3945c-22.801 2.3984-40.801 15.602-51.602 33.602h-46.801c-22.801 0-43.199 13.199-50.398 34.801-4.8008 16.801-1.1992 32.398 7.1992 44.398-12 9.6016-20.398 24-20.398 40.801s8.3984 31.199 20.398 39.602c-6 8.3984-9.6016 18-9.6016 28.801 0 15.602 7.1992 30 19.199 39.602-6 8.3984-9.6016 18-9.6016 30 0 27.602 25.199 50.398 52.801 50.398l52.805-0.003906c6 0 10.801-1.1992 15.602-2.3984 54 12 112.8 14.398 153.6 14.398 39.602 0 76.801-20.398 97.199-55.199l4.8008-7.1992h54c8.3984 0 15.602-7.1992 15.602-15.602 0-8.3984-7.1992-15.602-15.602-15.602h-63.602c-6 0-10.801 2.3984-13.199 7.1992l-8.4023 13.203c-15.602 25.199-42 39.602-70.801 39.602-33.602 0-79.199-1.1992-123.6-8.3984 3.6016-6 4.8008-13.199 4.8008-21.602 0-10.801-3.6016-21.602-9.6016-30 12-9.6016 19.199-24 19.199-39.602 0-10.801-3.6016-20.398-8.3984-27.602 4.8008-2.3984 8.3984-4.8008 12-8.3984 7.1992-8.3984 12-18 13.199-28.801 28.801 27.602 66 34.801 87.602 32.398 8.3984-1.1992 14.398-7.1992 14.398-15.602l0.003906-1.1953c-1.1992-8.3984-8.3984-14.398-16.801-14.398-2.3984 0-56.398 4.8008-82.801-51.602l18-2.3984c8.3984-1.1992 14.398-9.6016 13.199-18-1.1992-8.3984-9.6016-14.398-18-13.199l-36 4.8008c-8.3984 1.1992-13.199 8.3984-13.199 16.801l2.3984 55.199c0 4.8008-1.1992 9.6016-4.8008 13.199-3.6016 3.6016-8.3984 6-13.199 6-9.6016 0-18-8.3984-18-18l-1.1992-81.602c-1.1992-16.801 13.203-34.801 32.402-37.199zm-104.4 34.797h39.602v6l1.1992 32.398h-39.602c-10.801 0-19.199-8.3984-19.199-19.199-1.1992-10.797 8.4023-19.199 18-19.199zm-30 87.602c0-10.801 8.3984-19.199 19.199-19.199h51.602v18c0 7.1992 2.3984 13.199 4.8008 20.398h-56.398c-10.801-1.1992-19.203-9.5977-19.203-19.199zm93.602 156h-54c-10.801 0-19.199-8.3984-19.199-19.199s8.3984-19.199 19.199-19.199h54c10.801 0 19.199 8.3984 19.199 19.199s-8.3984 19.199-19.199 19.199zm9.6016-105.6c10.801 0 19.199 8.3984 19.199 19.199 0 10.801-8.3984 19.199-19.199 19.199h-73.199c-10.801 0-19.199-8.3984-19.199-19.199 0-10.801 8.3984-19.199 19.199-19.199z'>"
            );
    }

    function _generatePaper(string memory _fill) internal pure returns (string memory) {
        return
            string.concat(
                "<path fill='",
                _fill,
                "' d='m532.8 547.2c3.6016-6 4.8008-13.199 4.8008-20.398 0-25.199-20.398-45.602-45.602-45.602h-109.2v-4.8008c-1.1992-24-20.398-43.199-44.398-44.398l-100.8-2.3984c-34.801-1.1992-67.199 12-92.398 36l-52.805 50.398h-48c-8.3984 0-14.398 6-14.398 14.398 0 8.3984 6 14.398 14.398 14.398h54c3.6016 0 7.1992-1.1992 9.6016-3.6016l57.602-54c19.199-19.199 45.602-28.801 72-27.602l100.8 2.3984c9.6016 0 16.801 7.1992 16.801 16.801 0 4.8008-1.1992 9.6016-4.8008 13.199-3.6016 3.6016-8.3984 6-13.199 6h-51.602c-10.801 0-22.801 1.1992-33.602 3.6016l-9.6016 2.3984c-7.1992 1.1992-12 9.6016-10.801 16.801 1.1992 7.1992 9.6016 12 16.801 10.801l9.6016-2.3984c4.8008-1.1992 9.6016-1.1992 14.398-2.3984-21.602 66-76.801 60-79.199 60-7.1992-1.1992-14.398 4.8008-15.602 12v2.3984c0 7.1992 4.8008 13.199 12 14.398 1.1992 0 86.398 9.6016 112.8-88.801h34.801c13.199 0 24-4.8008 33.602-14.398h122.4c9.6016 0 16.801 7.1992 16.801 16.801 0 9.6016-7.1992 16.801-16.801 16.801l-128.4 0.003906c-8.3984 0-14.398 6-14.398 14.398 0 8.3984 6 14.398 14.398 14.398l151.2 0.003906c9.6016 0 16.801 7.1992 16.801 16.801 0 9.6016-7.1992 16.801-16.801 16.801l-164.4-0.003906c-8.3984 0-14.398 6-14.398 14.398 0 7.1992 6 14.398 14.398 14.398h140.4c9.6016 0 16.801 7.1992 16.801 16.801 0 9.6016-7.1992 16.801-16.801 16.801l-160.8 0.003906c-8.3984 0-14.398 6-14.398 14.398 0 8.3984 6 14.398 14.398 14.398h102c9.6016 0 16.801 7.1992 16.801 16.801 0 9.6016-7.1992 16.801-16.801 16.801h-69.602c-18 0-37.199 1.1992-60 4.8008h-2.3984c-43.199 6-159.6 24-187.2-42-2.3984-8.3984-7.1992-12-13.199-12h-56.402c-7.1992 0-14.398 6-14.398 14.398 0 8.3984 6 14.398 14.398 14.398h48c40.801 75.602 165.6 57.602 213.6 50.398h2.3984c21.602-3.6016 39.602-4.8008 56.398-4.8008h69.602c25.199 0 45.602-20.398 45.602-45.602 0-6-1.1992-12-3.6016-16.801h18c25.199 0 45.602-20.398 45.602-45.602 0-7.1992-2.3984-14.398-4.8008-20.398 16.801-7.1992 28.801-22.801 28.801-42-2.3984-17.992-14.398-34.793-31.199-40.793z'>"
            );
    }

    function _generateScissors(string memory _fill) internal pure returns (string memory) {
        return
            string.concat(
                "<path fill='",
                _fill,
                "' d='m1155.6 672h-56.398c-4.8008 0-9.6016 2.3984-12 7.1992l-8.3984 13.199c-14.398 22.801-38.398 36-63.602 36-27.602 0-64.801-1.1992-102-6 2.3984-6 4.8008-12 4.8008-19.199 0-2.3984 0-4.8008-1.1992-8.3984-1.1992-9.6016-6-18-13.199-25.199 7.1992-8.3984 12-19.199 12-30 0-2.3984 0-4.8008-1.1992-8.3984-1.1992-6-3.6016-12-7.1992-18 4.8008-2.3984 8.3984-4.8008 12-8.3984 7.1992-7.1992 10.801-15.602 12-25.199 26.398 25.199 60 31.199 79.199 28.801 7.1992-1.1992 13.199-7.1992 13.199-14.398v-1.1992c-1.1992-7.1992-7.1992-13.199-15.602-13.199-2.3984 0-51.602 3.6016-74.398-45.602l15.602-2.3984c7.1992-1.1992 13.199-8.3984 12-15.602-1.1992-7.1992-8.3984-13.199-15.602-12l-32.398 4.8008c-7.1992 1.1992-12 7.1992-12 14.398l2.3984 50.398c0 4.8008-1.1992 8.3984-4.8008 12-3.6016 3.6016-7.1992 4.8008-12 4.8008-8.3984 0-16.801-7.1992-16.801-16.801l-1.1992-73.199v-1.1992c0-18 13.199-32.398 30-34.801l61.199-8.3984c24-3.6016 49.199 4.8008 67.199 20.398l64.801 57.602c2.3984 2.3984 6 3.6016 9.6016 3.6016h54c8.3984 0 14.398-6 14.398-14.398 0-8.3984-6-14.398-14.398-14.398h-49.199l-61.199-54c-25.199-21.602-57.602-31.199-90-27.602l-61.199 8.3984c-21.602 2.3984-39.602 16.801-48 34.801l-160.8-28.801c-25.199-4.8008-48 12-52.801 37.199-4.8008 24 12 48 37.199 52.801l91.199 15.602-112.8 22.789c-12 2.3984-22.801 8.3984-28.801 19.199-7.1992 9.6016-9.6016 21.602-7.1992 33.602 2.3984 12 8.3984 22.801 18 28.801 9.6016 7.1992 21.602 9.6016 33.602 7.1992l96-16.801c-1.1992 6-1.1992 10.801 0 16.801 2.3984 12 8.3984 22.801 18 28.801 1.1992 1.1992 3.6016 2.3984 4.8008 2.3984-3.6016 8.3984-6 18-3.6016 27.602 4.8008 24 27.602 40.801 52.801 37.199l48-8.3984c2.3984 0 3.6016-1.1992 6-1.1992 46.801 9.6016 96 10.801 129.6 10.801 36 0 68.398-19.199 87.602-49.199l3.6016-6h49.199c8.3984 0 14.398-6 14.398-14.398-0.003906-8.4062-6.0039-14.406-14.402-14.406zm-481.2-165.6c-8.3984-1.1992-14.398-8.3984-14.398-16.801v-2.3984c1.1992-9.6016 10.801-15.602 19.199-13.199l160.8 27.602v1.1992l1.1992 32.398zm-15.598 124.8c-4.8008 1.1992-8.3984 0-12-2.3984-3.6016-2.3984-6-6-7.1992-10.801-1.1992-4.8008 0-9.6016 2.3984-13.199 2.3984-3.6016 6-6 10.801-7.1992l187.2-33.602v10.801c0 8.3984 2.3984 15.602 7.1992 21.602zm128.4 24v-2.3984c0-3.6016 1.1992-7.1992 2.3984-9.6016 2.3984-3.6016 6-6 10.801-7.1992l64.801-12c9.6016-1.1992 18 4.8008 19.199 13.199 1.1992 4.8008 0 8.3984-2.3984 12-2.3984 3.6016-6 6-10.801 7.1992l-64.801 12c-4.8008 1.1992-8.3984 0-12-2.3984-3.5977-3.6016-6-7.1992-7.1992-10.801zm98.402 57.602c-2.3984 3.6016-6 6-10.801 7.1992l-48 8.3984c-4.8008 1.1992-8.3984 0-13.199-2.3984-3.6016-2.3984-6-6-7.1992-10.801-1.1992-9.6016 4.8008-18 13.199-19.199l48-8.3984c4.8008-1.1992 8.3984 0 13.199 2.3984 3.6016 2.3984 6 6 7.1992 10.801 0 3.5977 0 8.3984-2.3984 12z'>"
            );
    }
}