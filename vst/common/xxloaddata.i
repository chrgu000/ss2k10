/* xxloaddata.i - loadData common procedure                                  */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120828.1 LAST MODIFIED: 08/28/12 BY: zy                         */
/* REVISION END                                                              */

/*
define variable vusrwkey1 as character initial "xxcimload_filename_default_value".
*/
/* vusrwkey1 reference to cimload filename list.                              */
/* xxpcld.p = usrw_key3                                                       */


FUNCTION deltmpfile RETURNS logical():
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable vstat as logical.
  assign vstat = yes.
  find first code_mstr no-lock where code_fldname = "Keep_Temp_WorkFile"
         and code_value = "YES|OTHER" and code_cmmt = "YES" no-error.
  if available code_mstr then do:
      assign vstat = no.
  end.
  return vstat.
END FUNCTION. /*FUNCTION deltmpfile*/

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose: getMsg content
    Parameters: inbr message number
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = global_user_lang
         and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return string(inbr).
  end.
END FUNCTION. /*FUNCTION getMsg*/

/* 日期YYYY-MM-DD转换为QAD日期格式 */
FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER,INPUT fmt AS CHARACTER):
    DEFINE VARIABLE sstr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iY   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iM   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE id   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE od   AS DATE      NO-UNDO.
    if datestr = "" then do:
        assign od = ?.
    end.
    else do:
    		if lower(fmt) = "ymd" then do:
           ASSIGN sstr = datestr.
           ASSIGN iY = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,"-") - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,"-") + 1).
           
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,"-") - 1)).
           ASSIGN iD = INTEGER(SUBSTRING(sstr,INDEX(sstr,"-") + 1)).
           ASSIGN od = DATE(im,id,iy).
        end.
    end.
    RETURN od.

END FUNCTION.

FUNCTION Pct2Dec RETURNS Decimal(input iPercentStr AS CHARACTER):
 /* -----------------------------------------------------------
    Purpose: 将百分比数值转化为数值。
    Parameters: 可以不带百分号。
    Notes: 直接截取掉百分号的。
  -------------------------------------------------------------*/	
	Define variable oRet as decimal format "->>>,>>>,>>>,>>>,>>>,>>9.<<<<<<<<<<<".
	if substring(trim(iPercentStr),length(trim(iPercentStr)),1) <> "%" then do:
  	 assign oRet = decimal(trim(iPercentStr)).
  end.
  else do:
  	 assign oRet = decimal(substring(trim(iPercentStr),1,length(trim(iPercentStr)) - 1)).
  end.
  RETURN oRet.
END FUNCTION.
