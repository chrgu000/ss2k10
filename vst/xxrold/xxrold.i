/* xxrold.i - rwromt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared variable i as integer no-undo.
define {1} shared temp-table xxro
       fields xxro_routing like ro_routing
       fields xxro_op like ro_op
       fields xxro_start like ro_start
       fields xxro_end like ro_end
       fields xxro_wkctr like ro_wkctr
       fields xxro_mch like ro_mch
       fields xxro_desc like ro_desc
       fields xxro_run like ro_run
       fields xxro_sn as integer
       fields xxro_chk as character format "x(40)"
       index xxro_def is primary xxro_routing xxro_op xxro_start.

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = "TW"
         and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return string(inbr).
  end.
END FUNCTION. /*FUNCTION getMsg*/
