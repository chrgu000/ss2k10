/* xxptpld.p - pppsmt02.p cim load                                           */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxptpld.i}
{xxloaddata.i}
define variable txt as character.
empty temp-table xxtmppt no-error.
define variable i as integer.
assign i = 0.
input from value(flhload).
repeat:
	import unformat txt.
	if i > 0 and entry(1,txt,",") <> ""
	         and entry(1,txt,",") < "ZZZZZZZZ" 
	         and entry(2,txt,",") <> "" then do:
  	create xxtmppt.
  	assign xxpt_site = entry(1,txt,",")
  				 xxpt_part = entry(2,txt,",")
           xxpt_ms = logical(entry(3,txt,","))
           xxpt_timefnce = int(entry(4,txt,","))
           xxpt_ord_per = int(entry(5,txt,","))
           xxpt_sfty_stk = int(entry(6,txt,","))
           xxpt_sfty_tme = int(entry(7,txt,","))
           xxpt_buyer = entry(8,txt,",")
           xxpt_pm_code = entry(9,txt,",")
           xxpt_mfg_lead = int(Entry(10,txt,","))
           xxpt_pur_lead = int(entry(11,txt,","))
           xxpt_ins_rqd = logical(entry(12,txt,","))
           xxpt_ins_lead = int(entry(13,txt,","))
           xxpt_phantom = logical(entry(14,txt,","))
 /*          xxpt_ord_min = dec(entry(15,txt,","))
           xxpt_ord_mult = dec(entry(16,txt,","))
 */          xxpt_yld_pct = dec(entry(17,txt,","))
           xxpt_routing = entry(18,txt,",")
           xxpt_bom_code = entry(19,txt,",").
  end.
  i = i + 1.
end.
input close.

for each xxtmppt exclusive-lock :
      if xxpt_part <= "" or xxpt_part >= "ZZZZZZZZ" then do:
         delete xxtmppt.
      end.
      else do:
         assign xxpt_chk = "".
      end.
end.

/* check data */
for each xxtmppt exclusive-lock:
    find first pt_mstr no-lock where pt_part = xxpt_part no-error.
    if not available pt_mstr then do:
          assign xxpt_chk = getMsg(17).
    end.
    find first si_mstr no-lock where si_site = xxpt_site no-error.
    if not available si_mstr then do:
       assign xxpt_chk = getMsg(2797).
    end.
    if can-find(first code_mstr no-lock where code_fldname = "ptp_buyer") and
       not can-find(first code_mstr no-lock where code_fldname = "ptp_buyer" and
                          code_value = xxpt_buyer)then do:
       assign xxpt_chk = "Buyer" + getmsg(716).
    end.
    /* else do:                                                            */
    /*      find first loc_mstr no-lock where loc_site = xxpt_site and     */
    /*                 loc_loc = xxpt_loc no-error.                        */
    /*      if not available loc_mstr then do:                             */
    /*         assign xxpt_chk = getMsg(229).                              */
    /*      end.                                                           */
    /* end.                                                                */
end.
