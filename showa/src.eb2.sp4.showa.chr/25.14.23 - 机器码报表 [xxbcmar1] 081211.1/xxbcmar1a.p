/* SS - 20081019.1 By: Bill Jiang */

/*
1. Linux
As the root user (or user with appropriate permissions) 
Type "ifconfig -a" 
From the displayed information, find eth0 (this is the default first Ethernet adapter) 
Locate the number next to the HWaddr. This is your MAC address 
The MAC Address will be displayed in the form of 00:08:C7:1B:8C:02. 
Example "ifconfig -a" output:
eth0      Link encap:Ethernet HWaddr 00:08:C7:1B:8C:02
          inet addr:192.168.111.20  Bcast:192.168.111.255  Mask:255.255.255.0

...additional output removed...

2. 无论使用哪种方法,都要注意执行权限的问题
*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE OUTPUT PARAMETER macaddress AS CHARACTER.

DEFINE VARIABLE tmpfilename AS CHARACTER.
DEFINE VARIABLE comm-line AS CHARACTER.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.

DEFINE TEMP-TABLE tt1
   FIELD tt1_c1 AS CHARACTER
   .

tmpfilename = "tmp".
{gprun.i ""xxbcmar1b.p"" "(
   INPUT '',
   INPUT-OUTPUT tmpfilename
   )"}

comm-line = "ifconfig -a > " + tmpfilename.
os-command silent value(comm-line).

EMPTY TEMP-TABLE tt1.
IF SEARCH(tmpfilename) = ? THEN RETURN.
INPUT FROM VALUE(SEARCH(tmpfilename)).
REPEAT:
   CREATE tt1.
   IMPORT DELIMITER "`" tt1.
END.
INPUT CLOSE.

OS-DELETE VALUE(tmpfilename).

FOR FIRST tt1:
   i1 = INDEX(tt1_c1, "HWaddr ").
   i2 = LENGTH("HWaddr ").
   IF i1 = 0 THEN RETURN.
   macaddress = SUBSTRING(tt1_c1, i1 + i2).
END.
