// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.21;

uint256 constant WEI = 100000000000000;
uint256 constant DATA_OFFSET_SAFE_COUNT = 16;
uint256 constant DATA_OFFSET_LIVE_COUNT = 32;
uint256 constant DATA_OFFSET_GAME_ROUND = 224;
uint256 constant DATA_OFFSET_ROUND_COUNT = 224;
uint256 constant DATA_OFFSET_GAME_NUMBER = 232;
uint256 constant MAX_TOKEN_ID = type(uint56).max;
uint256 constant FORFEIT_TOKEN_ID = 1e6;
uint256 constant REVEAL_THRESHOLD = 0xFFFFFFFF;
uint32 constant MIN_ROUND_TIME = 60 minutes;
uint32 constant MIN_PAUSE_TIME = 60 minutes;
uint32 constant MIN_RESET_TIME = 24 hours;
uint256 constant GAME_STATE_OFFLINE = 0x0;
uint256 constant GAME_STATE_STARTED = 0x1;
uint256 constant GAME_STATE_VIRTUAL = 0x2;
uint16 constant TOKEN_DELAY_ROUND = 4;
uint16 constant TOKEN_DELAY_PAUSE = 5;
uint16 constant MIN_TOKENS = 2;
uint16 constant MAX_TOKENS = 2**14;
uint32 constant OFFSET_GAME_NUMBER = 8;
uint8 constant MAX_TEAM_SPLIT = 50;
uint8 constant TOKEN_STATUS_BANNED = 0x00;
uint8 constant TOKEN_STATUS_BURNED = 0x02;
uint8 constant TOKEN_STATUS_QUEUED = 0x04;
uint8 constant TOKEN_STATUS_ACTIVE = 0x08;
uint8 constant TOKEN_STATUS_SECURE = 0x10;
uint8 constant TOKEN_STATUS_WINNER = 0x20;

