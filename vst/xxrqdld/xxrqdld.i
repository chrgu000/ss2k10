/* xxrqdld.i - rqrqmt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxrqd no-undo
       fields xxrqd_nbr like rqd_nbr
       fields xxrqd_line like rqd_line
       fields xxrqd_odue_date like rqd_due_date
       fields xxrqd_due_date like rqd_due_date
       fields xxrqd_ostat like rqd_status
       fields xxrqd_stat like rqd_status
       fields xxrqd_rqby like rqm_rqby_userid 
       fields xxrqd_chk as character format "x(40)"
       index xxrqd_nbr xxrqd_nbr xxrqd_line.

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
