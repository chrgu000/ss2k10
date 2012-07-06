/* xxpt.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{xxptpld.i}
define variable txt as character.
empty temp-table xxtmppt no-error.
input from value(flhload).
repeat:
  create xxtmppt.
  import delimiter "," xxtmppt.
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
