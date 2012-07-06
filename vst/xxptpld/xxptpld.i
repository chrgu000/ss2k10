/* xxpt.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxtmppt
       fields xxpt_site like ptp_site
       fields xxpt_part like ptp_part
       fields xxpt_ms like ptp_ms
       fields xxpt_timefnce like ptp_timefnce
       fields xxpt_ord_per like ptp_ord_per
       fields xxpt_sfty_stk like ptp_sfty_stk
       fields xxpt_sfty_tme like ptp_sfty_tme
       fields xxpt_buyer like ptp_buyer
       fields xxpt_pm_code like ptp_pm_code
       fields xxpt_mfg_lead like ptp_mfg_lead
       fields xxpt_pur_lead like ptp_pur_lead
       fields xxpt_ins_rqd like ptp_ins_rqd
       fields xxpt_ins_lead like ptp_ins_lead
       fields xxpt_phantom like ptp_phantom
       fields xxpt_ord_min like ptp_ord_min
       fields xxpt_ord_mult like ptp_ord_mult
       fields xxpt_yld_pct like ptp_yld_pct
       fields xxpt_chk as character format "x(40)"
       index xxpt_site_part xxpt_site xxpt_part.

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
