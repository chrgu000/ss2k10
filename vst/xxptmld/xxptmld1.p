/* xxptpld.p - pppsmt02.p cim load                                           */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxptpld.i}
define variable vfile as character.

assign vfile = "xxptld.p." + string(today,"99999999") + '.' + string(time).
if cloadfile then do:
for each xxtmppt exclusive-lock where xxpt_chk = "".
		output to value(vfile + ".bpi").
    put unformat '"' xxpt_part '"' skip.
    put unformat xxpt_ms ' - ' xxpt_timefnce ' - - ' xxpt_ord_per ' ' xxpt_sfty_stk ' ' xxpt_sfty_tme ' - - - '.
    put unformat xxpt_buyer ' - - ' xxpt_pm_code ' - ' xxpt_mfg_lead ' '  xxpt_pur_lead ' ' xxpt_ins_rqd ' ' xxpt_ins_lead ' - - '.
    put unformat xxpt_phantom ' ' xxpt_ord_min ' - '  xxpt_ord_mult  ' - ' xxpt_yld_pct ' - - - - - "' xxpt_routing '" "' xxpt_bom_code '"' skip.
    output close.
    batchrun = yes.
    input from value(vfile + ".bpi").
    output to value(vfile + ".bpo") keep-messages.
    hide message no-pause.
    cimrunprogramloop:
    do on stop undo cimrunprogramloop,leave cimrunprogramloop:
       {gprun.i ""ppptmt02.p""}
    end.
    hide message no-pause.
    output close.
    input close.
    batchrun = no.
    
    find first pt_mstr no-lock where pt_part = xxpt_part no-error.
       if available pt_mstr and
                    xxpt_ms = pt_ms  and
                    xxpt_timefnce = pt_timefence and
                    xxpt_ord_per  = pt_ord_per and
                    xxpt_sfty_stk = pt_sfty_stk and
                    xxpt_sfty_tme = pt_sfty_time and
                    xxpt_buyer =  pt_buyer and
                    xxpt_pm_code  = pt_pm_code and
                    xxpt_mfg_lead = pt_mfg_lead and
                    xxpt_pur_lead = pt_pur_lead and
                    xxpt_ins_rqd  = pt_insp_rqd and
                    xxpt_ins_lead = pt_insp_lead and
                    xxpt_phantom  = pt_phantom and
                    xxpt_ord_min  = pt_ord_min and
                    xxpt_ord_mult = pt_ord_mult and
                    xxpt_yld_pct  = pt_yield_pct and
                    xxpt_routing = pt_routing and
                    xxpt_bom_code = pt_bom_code
          then do:
          assign xxpt_chk = "OK".
				   os-delete value(vfile + ".bpi").
				   os-delete value(vfile + ".bpo").
       end.
       else do:
          assign xxpt_chk = "FAIL".
       end.
end.
end.
