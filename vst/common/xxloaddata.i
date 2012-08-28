/* xxload.i - loadData common procedure                                      */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120828.1 LAST MODIFIED: 08/28/12 BY: zy                         */
/* REVISION END                                                              */

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
