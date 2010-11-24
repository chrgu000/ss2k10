/* xxexctrl.p - expir crontrl                                                */
/* REVISION: 0BYI LAST MODIFIED: 11/28/10   BY: zy                           */
/* REVISION END                                                              */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/****test program************************************************************

/*  9201 "许可证#将在#天后过期" */
/*  9202 "许可证#已过期"        */
{mfdeclre.i}
DEFINE VARIABLE vdays AS INTEGER.
DEFINE VARIABLE vLicCode as character.


{gprunp.i "xxexctrl" "P" "setExpirDate" "(input date(11,19,2010))"}
/*{gprunp.i "xxexctrl" "P" "setExpirDate" "(input today)"} */
{gprunp.i "xxexctrl" "P" "getExpirDays" "(input today,output vdays)"}
{gprunp.i "xxexctrl" "P" "getLicenseCode" "(output vLicCode)"}

if vdays < 0 then do:
    {pxmsg.i &MSGNUM=9211 &MSGARG1=vLicCode}
    RETURN.
end.
if vdays <= 5 then do:
     {pxmsg.i &MSGNUM=9210 &MSGARG1=vLicCode &MSGARG2=vdays &ERRORLEVEL=2}
end.
****test program************************************************************/

define variable vCtrlExpirDate as date.
DEFINE VARIABLE vLicenseCode AS CHARACTER FORMAT "x(12)".
DEFINE VARIABLE vExpirAfterDays as integer initial 5 no-undo.

assign vLicenseCode= "sh005"
       vCtrlExpirDate = date(1,1,1900).

PROCEDURE getExpirDate:
DEFINE OUTPUT PARAMETER DATE1 AS DATE.
    ASSIGN DATE1 = vCtrlExpirDate.
END PROCEDURE.

PROCEDURE getExpirDays:
DEFINE INPUT  PARAMETER idatef AS DATE.
DEFINE OUTPUT PARAMETER odays  AS INTEGER.
    ASSIGN odays = vCtrlExpirDate - idatef.
END PROCEDURE.

PROCEDURE setExpirDate:
DEFINE INPUT PARAMETER idates AS DATE.
    ASSIGN vCtrlExpirDate = idates.
END PROCEDURE.

PROCEDURE setLicenseCode:
DEFINE INPUT PARAMETER iLicenseCode AS CHARACTER.
    ASSIGN vLicenseCode = iLicenseCode.
END PROCEDURE.

PROCEDURE getLicenseCode:
DEFINE OUTPUT PARAMETER getLicenseCode AS CHARACTER.
    ASSIGN getLicenseCode = vLicenseCode.
END PROCEDURE.

PROCEDURE setExpAfterDays:
DEFINE INPUT PARAMETER vdays as integer.
  assign vExpirAfterDays = vdays.
END PROCEDURE.

PROCEDURE getExpAfterDays:
DEFINE OUTPUT PARAMETER vdays as integer.
  assign vdays = vExpirAfterDays.
END PROCEDURE.
