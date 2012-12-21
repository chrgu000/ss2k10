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
  if i > 0 and entry(1,txt,",") <> "" and entry(2,txt,",") <> "" then do:
    create xxtmppt.
    import delimiter "," xxpt_part
                         xxpt_ms
                         xxpt_timefnce
                         xxpt_ord_per
                         xxpt_sfty_stk
                         xxpt_sfty_tme
                         xxpt_buyer
                         xxpt_pm_code
                         xxpt_mfg_lead
                         xxpt_pur_lead
                         xxpt_ins_rqd
                         xxpt_ins_lead
                         xxpt_phantom
                         xxpt_ord_min
                         xxpt_ord_mult
                         xxpt_yld_pct .
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
    if can-find(first code_mstr no-lock where code_fldname = "pt_buyer") and
       not can-find(first code_mstr no-lock where code_fldname = "pt_buyer" and
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
