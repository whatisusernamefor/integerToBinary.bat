:: Programmer: Joseph Stone
:: E-Mail: JosephStoneBusiness@gmail.com
:: Creation date: 2/5/2012
:: Last Update: 3/4/2012
:: Complete: Yes, Needs better comments. 
::            HEX_ - doesn't returned non-formated string.
:: 
:: Takes var %1 and returns a binary number and assigns to var
::    binary.
:: VARIABLES RETURNED: [ 17 integer SAMPLE ]
::	fBINARY - format [ 0001 0001 ]
::	BINARY format [ 10001 ]
::	HEX_ - format [ 11 ]
::	fHEX_ - format [ 0x00 ]
::  Rather choppy commenting. I might get back to this..
@echo off
:: Modify as desired, just give credit where credit's due.
if NOT [%2]==[] (GOTO SKIP )
echo. Programmer: Pepperdirt
echo. E-Mail: Pepperdirt@gmail.com
IF NOT [%1]==[] (GOTO SKIP )
echo.Please supply an unsigned integer [ A positive number, no decimal ]
echo.   Will translate this number to Base 1 (Binary), and Base 16 (Hexidecimal)
GOTO eof
:SKIP

:: Need to take out hardcoded %1. 
::  Might need to split this number up if more than 256 bit number. or 1<<32.
::  Might need to re-iterate this sequence over and over.
SET /a PERCENT1=%1

:START
set fBINARY=
set BINARY=
SET HEX_=
SET indexOf8Bit=0
::   Assigns index == placeholder in binary. i.e. 1000 -> 1 is the 4th index.
::   num>>2 -> right shift 2x. IF %num%==16 -> 0001 0000 >>2 => 0000 0100 == 04, 0x04, 4
::   effectively divides by 2sq.
set /a index="%PERCENT1%>>2" 
:: Find the last shift value from right-to-left in binary.
::   Start at indx(2) and find if ( %PERCENT1% <= "1<<n" ) -> n == offset right-to-left.  

:: NOW CHECK for n being more than 32-bit. Cut it down if so.
:: PRELIMINARY CHECK-> IF SMALLER THAN 1-BIT NUM, NUMBER IS FOUND.
set n=0
IF %PERCENT1%==0 (GOTO Found )
IF %PERCENT1%==1 (GOTO Found )
:FindOffset
SET /a num="1<<%n%"
IF %PERCENT1% LSS %num% (GOTO Found )
SET /a n+=1
GOTO FindOffset
:Found
::	Not really magic numbers below. Fixes the offsets
::	 created by the first ">>2" operation.
IF %n% GTR 0 (SET /a n-=1 ) else SET /a n=%n%
SET /a INDEX=(%n%-1)%%4
::
:: fBINARY formatter.
IF %INDEX%==-1 (SET fBINARY=000)
IF %INDEX%==3 (SET INDEX=6& set fBINARY=000) 
IF %INDEX%==2 (SET INDEX=3)
IF %INDEX%==1 (SET INDEX=4& set fBINARY=0)
IF %INDEX%==0 (SET INDEX=1& set fBINARY=00)
set offset=%n%
set n=
IF %offset% GTR 0 (SET /a offsetCounter=%offset%-1 ) ELSE SET /a offsetCounter=%offset%
:: Now find all binary and place in variable %BINARY%
::    Find first bit (from left to right [HIGH-bit to LOW-bit] Big-endian )
:BinaryBitFinder
set /a bit="%PERCENT1%>>%offset%"
::::set BINARY=%BINARY%%bit%
SET /a INDEX+=1
SET /a tmp=%INDEX%%%4
IF %tmp%==0 (SET fBINARY=%fBINARY%%bit%) else SET fBINARY=%fBINARY%%bit%
SET BINARY=%bit%
SET numZerosAddBinary=
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: HEX ADDON.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::	EASIER to take full 8-bits of HEX val and adds to full val.
::	This Function is 2parts. This first part simply sets up for the 
:: 	  Second. Need this here for an initial value, and the next section
::	  will find the rest of the bits. 
::	This addon works by assembling the HEX value 8-bits at a time.
:: 	  This is done by finding the lVal (upper half of 8-bit num [4bits])
::	  one bit at a time, And adding the bits after every pass.
::	  Find the HEX equivilent of the INT that has been accumulating after 8-bits are calculated.
::	  Add this to HEX_.
::	This is done till the Current Offset ==0
::
::	Now! After first bit is determined, Need to set up for next func.
::	  Works by finding bit %CurrentOffset% ( within an 8 bit number )
::        and using knowledge of every 8-bits can be calculated independantly
::        and appended to each other to find final solution.
::*/	  
SET /a xBitOffset=%offset%
::  Checks what offset it is from a multiple of 1<<7 
::  Short circuits this series of if's IF %bit% is set to 0.
:: 	Find what index pos. we are working with.
::  	%indexOf8Bit% --
::	  Takes off from here and becomes the means for determining the current
::	  bit's offset of 8-bit Segment. This is completely contained in HEX ADDON. only.
::	  will keep getting decremented till == 0, then =7 again. Till script ends.


:: Stores offset's value so to replace later.
::  Decremnts offset until it is less than 8
::  Then passes, or rather 'drops' to next instruction
::  which finds current offset within an 8-bit segment.

SET TMPOFFSET=%offset%
IF %offset% LSS 8 (GOTO eightOffsetFind ) 
:F8bitOffset
set /a offset-=8
if %offset% LSS 8 (GOTO eightOffsetFind ) ELSE GOTO F8bitOffset
:eightOffsetFind
if %offset%==0 (SET indexOf8Bit=0& SET numZerosAddBinary=0000 &  GOTO skip )
set /a indexOf8Bit=%offset%%%7
if %indexOf8Bit%==0 (SET indexOf8Bit=7& GOTO skip )
set /a indexOf8Bit=%offset%%%6
if %indexOf8Bit%==0 (SET indexOf8Bit=6& GOTO skip )
set /a indexOf8Bit=%offset%%%5
if %indexOf8Bit%==0 (SET indexOf8Bit=5& GOTO skip )
set /a indexOf8Bit=%offset%%%4
if %indexOf8Bit%==0 (SET indexOf8Bit=4& GOTO skip )
set /a indexOf8Bit=%offset%%%3
if %indexOf8Bit%==0 (SET indexOf8Bit=3& SET numZerosAddBinary=0000 & GOTO skip )
set /a indexOf8Bit=%offset%%%2
if %indexOf8Bit%==0 (SET indexOf8Bit=2& SET numZerosAddBinary=0000 & GOTO skip )
SET indexOf8Bit=1
SET numZerosAddBinary=0000 
::
:
::::::::::::::::::::::::::::::::::::::
::* ********************************
::  NEED TO FIND offset within 4-bit increment.
:: * *******************************
::::::::::::::::::::::::::::::::::::::
:skip
SET offset=%TMPOFFSET%
SET TMPOFFSET=
:forBitOffsetFind
SET /a indexOf4Bit=%indexOf8Bit%-4
IF %indexOf4Bit% GTR 3 (GOTO forBitOffsetFind )
IF %indexOf4Bit% LSS 0 (SET indexOf4Bit=%indexOf8Bit%)
::	Bit is either true or false. (1||0). 
::	indexOf8Bit is offset of 8bit within whole value %PERCENT1%.
SET /a eightBitNum="%bit%<<%indexOf8Bit%"
SET /a fourBitNum="%bit%<<%indexOf4Bit%"
::set tmpInt=%eightBitNum%  

IF %indexOf8Bit% LSS 4 (SET HEX_=0)

:: If below is true, this is the final bit of the number
::  Need to calculate next 8bits to get HEX equivelant and add to current.
:::***IF %indexOf8Bit%==0 (GOTO Evaluate) ELSE GOTO SKIP
IF %indexOf4Bit%==0 (GOTO Evaluate) ELSE GOTO SKIP
:Evaluate
:: Returned value is in %rHEX8Bit%
:::***add8BitIntTO_HEX.bat %eightBitNum%
call add4BitIntTO_HEX.bat %fourBitNum%
:: Space is added after HEX_. So %HEX%_ == [0x?? ]
:::***SET HEX_=%rHEX8Bit%
SET HEX_=%rHEX4Bit%
IF %indexOf8Bit% LSS 4 (SET HEX_=0%HEX_% )
SET indexOf4Bit=4
IF %indexOf8Bit%==0 (SET indexOf8Bit=8)
SET fourBitNum=0


:SKIP
:::***echo.IndexOf8Bit==[%indexOf8Bit%], %HEX_%
SET /a indexOf8Bit-=1
SET /a indexOf4Bit-=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END HEX_ADDON
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
IF %offset%==0 (GOTO eof )
:BinaryFunc
::  Finds how many exlusive ORs need AND'ed to zero out all but single bit.
::    So, bit is found: %PERCENT1%>>%offset% & ~ ( 1<< (%offset%-%offsetCounter%-i) ) [%offset%-%offsetCounter% TIMES].
::    %n% == howManyBits I need to cancel out == times
SET /a times=%offset%-%offsetCounter%
SET lCounter=0
SET /a bit="%PERCENT1%>>%offsetCounter% & ~( 1<<(%offset% - %offsetCounter%) )"
:FindExlusiveOr
SET /a lCounter+=1
IF %lCounter% EQU %times% (goto eLoop )
SET /a "bit&=~( 1<<(%offset% - %offsetCounter% - %lCounter%) )"
GOTO FindExlusiveOr
:eLoop
SET /a INDEX+=1
SET /a tmp=%INDEX%%%4
IF %tmp%==0 (SET fBINARY=%fBINARY% %bit%) else SET fBINARY=%fBINARY%%bit%
SET BINARY=%BINARY%%bit%
SET /a offsetCounter-=1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: HEX ADDON.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  Checks what offset it is from a multiple of 2^4 or 2<<4
::  Short circuits this series of if's IF %bit% is set to 0.
::    NOT SURE WHY but starts at 6 so need to be 0 instead of -1

:::***IF %indexOf8Bit%==-1 (GOTO Add8Bits ) ELSE GOTO skip
IF %indexOf4Bit%==-1 (GOTO Add4Bits ) ELSE GOTO skip
:::***:Add8Bits
:Add4Bits
:: Returns HEX [%rHEX8Bit%]

call add4BitIntTO_HEX.bat %fourBitNum%
:: Difference in line is in the ending 0x20.
IF %indexOf8Bit%==-1 (SET HEX_=%HEX_%%rHEX4Bit% ) ELSE SET HEX_=%HEX_%%rHEX4Bit%
:::***SET HEX_=%HEX_% %rHEX8Bit%
IF %indexOf8Bit%==-1 (set indexOf8Bit=7)
SET indexOf4Bit=3
SET fourBitNum=0
IF %offsetCounter%==-1 (GOTO SKIPEND )
:skip
:::***set /a eightBitNum+="%bit%<<%indexOf8Bit%"
set /a fourBitNum+="%bit%<<%indexOf4Bit%"

SET /a indexOf8Bit-=1
SET /a indexOf4Bit-=1
::   Catches script before exit to find hex and add to existing.
IF %offsetCounter%==-1 (GOTO Add4Bits )

:: jumps here when program is done.
:SKIPEND
:
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END HEX_ADDON
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
IF %offsetCounter%==-1 (GOTO eof ) else GOTO BinaryFunc

:eof
echo.BASE 10: [%PERCENT1%]
set int=%PERCENT1%
SET PERCENT1=
if [%2]==[] (echo.%numZerosAddBinary%%fBINARY%) ELSE echo.%BINARY%
echo.%numZerosAddBinary%%fBINARY%>>C:\bin.txt
echo.x%HEX_%
