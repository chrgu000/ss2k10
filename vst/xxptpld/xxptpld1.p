/* xxpt.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxptpld.i}
define variable vfile as character.

assign vfile = "xxptld.p." + string(today,"99999999") + '.' + string(time).

output to value(vfile + ".bpi").
for each xxtmppt no-lock where xxpt_chk = "".
    put unformat '"' xxpt_part '" "' xxpt_site '"' skip.
    put unformat xxpt_ms ' - ' xxpt_timefnce ' - - ' xxpt_ord_per ' ' xxpt_sfty_stk ' ' xxpt_sfty_tme ' - - - '.
    put unformat xxpt_buyer ' - - ' xxpt_pm_code ' - ' xxpt_mfg_lead ' '  xxpt_pur_lead ' ' xxpt_ins_rqd ' ' xxpt_ins_lead ' - - '.
    put unformat xxpt_phantom ' ' xxpt_ord_min ' - '  xxpt_ord_mult  ' - ' xxpt_yld_pct skip.
end.
output close.

if cloadfile then do:
   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""pppsmt02.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.

   for each xxtmppt exclusive-lock where xxpt_chk = "":
       find first ptp_det no-lock where ptp_part = xxpt_part and
                  ptp_site = xxpt_site no-error.
       if available ptp_det and
                    xxpt_ms = ptp_ms  and
                    xxpt_timefnce = ptp_timefnce and
                    xxpt_ord_per  = ptp_ord_per and
                    xxpt_sfty_stk = ptp_sfty_stk and
                    xxpt_sfty_tme = ptp_sfty_tme and
                    xxpt_buyer =  ptp_buyer and
                    xxpt_pm_code  = ptp_pm_code and
                    xxpt_mfg_lead = ptp_mfg_lead and
                    xxpt_pur_lead = ptp_pur_lead and
                    xxpt_ins_rqd  = ptp_ins_rqd and
                    xxpt_ins_lead = ptp_ins_lead and
                    xxpt_phantom  = ptp_phantom and
                    xxpt_ord_min  = ptp_ord_min and
                    xxpt_ord_mult = ptp_ord_mult and
                    xxpt_yld_pct  = ptp_yld_pct
          then do:
          assign xxpt_chk = "OK".
       end.
       else do:
          assign xxpt_chk = "FAIL".
       end.
   end.
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
end.
