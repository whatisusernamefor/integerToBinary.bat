@echo off
:: Called from file: 	toBinary.bat
::
::hjjjh Takes One INTEGER (4-bit, 0-15)
::   Output is displayed as HEX in variable: %rHEX4Bit%
::   FORMAT: [0-9 A-F]
if [%1]==[] (set rHEX4Bit=0& GOTO eof)
:: Converts first integer.
if %1 LSS 10 (set rHEX4Bit=%1& GOTO eof )
if %1 EQU 10 (set rHEX4Bit=A& GOTO eof )
if %1 EQU 11 (set rHEX4Bit=B& GOTO eof )
if %1 EQU 12 (set rHEX4Bit=C& GOTO eof )
if %1 EQU 13 (set rHEX4Bit=D& GOTO eof )
if %1 EQU 14 (set rHEX4Bit=E& GOTO eof )
if %1 EQU 15 (set rHEX4Bit=F& GOTO eof )
SET rHEX4Bit=%1
:eof

