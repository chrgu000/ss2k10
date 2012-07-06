/* xxpt.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxtmppt
       fields xxpt_part like pt_part
       fields xxpt_osite like pt_site
       fields xxpt_site like pt_site
       fields xxpt_oloc like pt_loc
       fields xxpt_loc like pt_loc
       fields xxpt_oabc like pt_abc
       fields xxpt_abc like pt_abc
       fields xxpt_ostat like pt_status
       fields xxpt_stat like pt_status
       fields xxpt_chk as character format "x(40)"
       index xxpt_part xxpt_part.

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = "TW" and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return "ERROR.".
  end.
END FUNCTION. /*FUNCTION getMsg*/
