/* xxdtitle.i - md5 function setts                                            */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 9.1     Last modified: 08/17/00    By: *N0LJ* Mark Brown         */
/******************************************************************************/

FUNCTION getDateStr RETURNS CHARACTER
        (days as integer,
         reftoday as logical):

define variable inidte as date.
define variable calcDate as date.
assign inidte = date(2,27,2012).
if reftoday then do:
    assign calcDate = today + days.
end.
else do:
    assign calcDate = inidte + days.
end.

  return string(year(calcDate),"9999") + "-" +
         string(month(calcDate),"99") + "-" +
         string(day(calcDate),"99").

END FUNCTION.

FUNCTION getMAC RETURNS CHARACTER:
  define variable txt as character  format "x(70)".
  if opsys = "UNIX" then do:
     UNIX SILENT "/sbin/ifconfig -a > ip.xxecdc.i.201020.cfg".
     if search("ip.xxecdc.i.201020.cfg") <> ? then do:
        input from "ip.xxecdc.i.201020.cfg".
        repeat:
          import unformat txt.
          if index(txt,"HWaddr") > 0 then do:
             assign txt = substring(txt, index(txt,"HWaddr") + 7).
             leave.
          end.
        end.
        input close.
        os-delete "ip.xxecdc.i.201020.cfg".
     end.
  end. /* if opsys = "UNIX" then do: */
  else if opsys = "msdos" or opsys = "win32" then do:
      dos silent "ipconfig /all > ip.xxecdc.i.201020.cfg".
      if search("ip.xxecdc.i.201020.cfg") <> ? then do:
        input from "ip.xxecdc.i.201020.cfg".
        repeat:
          import unformat txt.
          if index(txt,"Physical Address") > 0 then do:
             assign txt = trim(entry(2,txt,":")).
             leave.
          end.
        end.
        input close.
        os-delete "ip.xxecdc.i.201020.cfg".
     end.
  end. /* else if opsys = "msdos" or opsys = "win32" then do: */
  return trim(txt).
END FUNCTION. /*FUNCTION getMAC*/


FUNCTION getMd5 RETURNS CHARACTER(input keywords as CHARACTER):
 /* -----------------------------------------------------------
    Purpose: get md5 code.
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable x as raw.
  define variable y as char.
  define variable d as char init "0123456789abcdef".
  define variable i as int.
  define variable b as int.
  define variable d0 as int.
  define variable d1 as int.

x = md5-digest(keywords).
y = "".

do i = 1 to length(x):
   b = getbyte (x, i).
   d0 = trunc (b / 16, 0).
   d1 = b mod 16.

   y = y + substr(d, d0 + 1, 1) + substr(d, d1 + 1, 1).
end.
return y.
END FUNCTION. /*FUNCTION getMd5*/

FUNCTION getEncode RETURNS CHARACTER
        (key1 as CHARACTER,key2 as CHARACTER,
         key3 as CHARACTER,key4 as CHARACTER,
         key5 as CHARACTER,key6 as CHARACTER):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable retVal as CHARACTER initial "".
/*   DEFINE VARIABLE ini_date AS DATE NO-UNDO. */
/*   ASSIGN ini_date = DATE(1,1,2012).         */
  assign retVal = getMd5(key1) + ";" + getMd5(key2) + ";"
                + getMd5(key3) + ";" + getMd5(key4) + ";"
                + getMd5(key5) + ";" + getMd5(key6) .
  return retVal.
END FUNCTION. /*FUNCTION getKey*/
