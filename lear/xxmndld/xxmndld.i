/* xxmndld.p - mgpwmt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxdta
       fields xxd_menu as character format "x(18)"
       fields xxd_nbr  like mnd_nbr
       fields xxd_select like mnd_select
       fields xxd_run like mnd_canrun column-label "new"
       fields xxd_old like mnd_canrun column-label "old"
       fields xxd_chk as character format "x(20)".
       .
define {1} shared temp-table xxtmp
       fields xxt_menu as character format "x(18)"
       fields xxt_nbr like mnd_nbr
       fields xxt_select like mnd_select
       fields xxt_run as character format "x(10)"
       fields xxt_old like mnd_canrun
       fields xxt_new like mnd_canrun
       fields xxt_chk as character format "x(240)".

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
