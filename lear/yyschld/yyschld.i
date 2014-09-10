/* xxmndld.p - mgpwmt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)" no-undo.
define {1} shared variable cate as integer format "9" initial 3 no-undo.
define {1} shared variable inc_sum as logical no-undo.
define {1} shared variable effdate as date no-undo.
define {1} shared variable cloadfile as logical initial "no" no-undo.
define {1} shared variable maxEntry as integer.

define {1} shared temp-table xsch_data
           fields xsd_sn as integer
           fields xsd_data as character
           fields xsd_line as integer
           fields xsd_chk as character.

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = global_user_lang
         and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return "ERROR.".
  end.
END FUNCTION. /*FUNCTION getMsg*/
