/* xxecdc.i - md5 function setts                                              */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 9.1     Last modified: 08/17/00    By: *N0LJ* Mark Brown         */
/******************************************************************************/
{gplabel.i}
define variable inidte as date.
assign inidte = date(2,27,2012).

FUNCTION dts returns character(input idate as date):
 /* -----------------------------------------------------------
    Purpose: get md5 code.
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
    return string(year(idate),"9999") + "-" +
           string(month(idate),"99") + "-" +
           string(day(idate),"99") + ",#*2012".
end FUNCTION.

FUNCTION getMAC RETURNS CHARACTER:
 /* -----------------------------------------------------------
    Purpose: get MAC ADDRESS.
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable txt as character  format "x(70)".
/*  define variable rec as RECID.                                            */
/*  find first usrw_wkfl no-lock where {xxusrwdom1.i} {xxand.i}              */
/*             usrw_key1 = "MAC-ADDRESS-RECORD" and                          */
/*             usrw_key2 <> "" no-error.                                     */
/*  if not available usrw_wkfl then do:                                      */
     if opsys = "UNIX" then do:
/*      UNIX SILENT "netstat -v > ip.xxecdc.i.201020.cfg".                   */     
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
             if index(txt, trim(getTermLabel("PHYSICAL_ADDRESS_.....",12))) > 0 then do:
                assign txt = trim(entry(2,txt,":")).
                leave.
             end.
           end.
           input close.
           os-delete "ip.xxecdc.i.201020.cfg".
        end.
     end. /* else if opsys = "msdos" or opsys = "win32" then do: */
     if txt = "" then do:
        assign txt = "00-1E-65-B9-61-34".
     end.
/*     create usrw_wkfl.                                                     */
/*     assign {xxusrwdom1.i}                                                 */
/*            usrw_key1 = "MAC-ADDRESS-RECORD"                               */
/*            usrw_key2 = txt.                                               */
/*  end.                                                                     */
/*  else do:                                                                 */
/*       if usrw_key2 <> "" then do:                                         */
/*          assign txt = usrw_key2.                                          */
/*       end.                                                                */
/*       else do:                                                            */
/*          assign txt = "00-1E-65-B9-61-34".                                */
/*          assign REC = recid(usrw_wkfl).                                   */
/*          find first usrw_wkfl exclusive-lock where RECID(usrw_wkfl) = REC */
/*                     no-error.                                             */
/*          if available usrw_wkfl then do:                                  */
/*             assign usrw_key2 = txt.                                       */
/*          end.                                                             */
/*       end.                                                                */
/*  end.                                                                     */
/*  release usrw_wkfl.                                                       */
  return trim(txt).
END FUNCTION. /*FUNCTION getMAC*/

/***以下这些程序在progress 10.1下有问题暂时屏蔽 ********************************
FUNCTION getMd5 RETURNS CHARACTER(input keywords as CHARACTER):
 /* -----------------------------------------------------------
    Purpose: get md5 code.
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable x as raw.
  define variable y as character.
  define variable d as character init "0123456789abcdef".
  define variable i as integer.
  define variable b as integer.
  define variable d0 as integer.
  define variable d1 as integer.

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

FUNCTION getEn RETURNS CHARACTER(input ci as CHARACTER):
 /* -----------------------------------------------------------
    Purpose: EN code
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/

    DEFINE variable co AS CHARACTER.
    DEFINE VARIABLE mptr AS MEMPTR.
    DEFINE VARIABLE cnt  AS INTEGER.

    DEFINE VARIABLE i1 AS INTEGER.
    DEFINE VARIABLE i2 AS INTEGER.
    DEFINE VARIABLE c1 AS CHARACTER.

    SET-SIZE(mptr) = LENGTH(ci,"RAW") + 1.

    PUT-STRING(mptr, 1) = ci.


    c1 = "".
    REPEAT cnt = 1 TO LENGTH(ci,"RAW"):

       i1 = (cnt MOD 3).
       IF i1 = 1 THEN DO:
          i2 = 27.
       END.
       ELSE IF i1 = 2 THEN DO:
          i2 = 17.
       END.
       ELSE DO:
          i2 = 7.
       END.
       c1 = c1 + STRING(GET-BYTE(mptr, cnt)
               + (cnt MOD i2) * (cnt MOD i2)  + i1, "999").
    END.

    co = "".
    DO cnt = 1 TO LENGTH(c1,"RAW"):
       co = co + STRING(RANDOM(0,9)) + SUBSTRING(c1,cnt,1).
    END.
    return co.
END. /* FUNCTION getEn  */

FUNCTION getDn RETURNS CHARACTER(input ci as CHARACTER):
 /* -----------------------------------------------------------
    Purpose: DN code.
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/

  DEFINE variable co AS CHARACTER.
  DEFINE VARIABLE mptr AS MEMPTR.
  DEFINE VARIABLE cnt  AS INTEGER.

  DEFINE VARIABLE i1 AS INTEGER.
  DEFINE VARIABLE i2 AS INTEGER.
  DEFINE VARIABLE c1 AS CHARACTER.

  c1 = "".
  DO cnt = 1 TO (LENGTH(ci,"RAW") / 2):
     c1 = c1 + SUBSTRING(ci,cnt * 2,1).
  END.

  SET-SIZE(mptr) = INTEGER(LENGTH(c1,"RAW") / 3) + 1.


  REPEAT cnt = 1 TO (LENGTH(c1,"RAW") / 3):

     i1 = (cnt MOD 3).
     IF i1 = 1 THEN DO:
        i2 = 27.
     END.
     ELSE IF i1 = 2 THEN DO:
        i2 = 17.
     END.
     ELSE DO:
        i2 = 7.
     END.
     PUT-BYTE(mptr,cnt) = INTEGER(SUBSTRING(c1,cnt * 3 - 2,3))
                        - ((cnt MOD i2) * (cnt MOD i2)  + i1).
  END.
  PUT-BYTE(mptr,cnt) = 0.
  co=GET-STRING(mptr,1).
  return co.
END. /* FUNCTION getDn */

***以上这些程序在progress 10.1下有问题暂时屏蔽 ********************************/

FUNCTION getEncode RETURNS CHARACTER
        (key1 as CHARACTER, key2 as CHARACTER,
         key3 as CHARACTER, key4 as CHARACTER,
         key5 as CHARACTER, key6 as CHARACTER,
         key7 as CHARACTER, Key8 as CHARACTER):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable retVal as CHARACTER initial "".

/*
  assign retVal = getMd5(key1) + "," + getMd5(key2) + ","
                + getMd5(key3) + "," + getMd5(key4) + ","
                + getMd5(key5) + "," + getMd5(key6) + ","
                + getMd5(key7).
*/
  assign retVal = ENCODE(key1) + "," + ENCODE(key2) + ","
                + ENCODE(key3) + "," + ENCODE(key4) + ","
                + ENCODE(key5) + "," + ENCODE(key6) + ","
                + ENCODE(key7) + "," + ENCODE(key8) .

  return retVal.
END FUNCTION. /*FUNCTION getKey*/
