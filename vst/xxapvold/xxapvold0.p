/* xxapvold.p - apvomt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 131115.1 LAST MODIFIED: 11/15/13 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxapvold.i}
define variable txt as character.
define variable i as integer.
empty temp-table xxapvotmp no-error.
input from value(flhload).
repeat:
    import unformat txt.
    if trim(entry(1,txt,",")) <= "ZZZZZZZZ" then do:
       create xxapvotmp.
       assign xxapt_ref = trim(entry(1,txt,",")) no-error.
       assign xxapt_tot = decimal(trim(entry(2,txt,","))) no-error.
       assign xxapt_vd  = trim(entry(3,txt,",")) no-error.
       assign xxapt_sort = trim(entry(4,txt,",")) no-error.
       assign xxapt_invoice = trim(entry(5,txt,",")) no-error.
       assign xxapt_taxable = trim(entry(6,txt,",")) no-error.
       assign xxapt_acct = trim(entry(7,txt,",")) no-error.
       assign xxapt_amt = decimal(trim(entry(8,txt,","))) no-error.
       assign xxapt_cc   = trim(entry(9,txt,",")) no-error.
       assign xxapt_proj = trim(entry(10,txt,",")) no-error.
       assign xxapt_cmmt = trim(entry(11,txt,",")) no-error.
    end.
end.
input close.

assign i = 0.
for each xxapvotmp exclusive-lock break by xxapt_ref:
    if first-of(xxapt_ref) then i = i + 1.
    assign xxapt_sn = i
           xxapt_chk = "".
end.

/*
/* check data */
for each xxapvotmp exclusive-lock:
    find first pt_mstr no-lock where pt_part = xxpt_part no-error.
    if available pt_mstr then do:
       assign xxpt_osite = pt_site
              xxpt_oloc = pt_loc
              xxpt_oabc = pt_abc
              xxpt_ostat = pt_status.
    end.
    else do:
          assign xxpt_chk = getMsg(17).
    end.
    if xxpt_site <> "-" then do:
       find first si_mstr no-lock where si_site = xxpt_site no-error.
       if not available si_mstr then do:
          assign xxpt_chk = getMsg(2797).
       end.
       else do:
            if xxpt_loc <> "-" then do:
               find first loc_mstr no-lock where loc_site = xxpt_site and
                          loc_loc = xxpt_loc no-error.
               if not available loc_mstr then do:
                  assign xxpt_chk = getMsg(229).
               end.
            end.
       end.
    end.
    if xxpt_abc <> "-" then do:
       find first code_mstr no-lock where code_fldname = "pt_abc"
              and code_value = xxpt_abc no-error.
       if not available code_mstr then do:
          assign xxpt_chk = "ABC" + getMsg(716).
       end.
    end.
    if xxpt_stat <> "-" then do:
       find first qad_wkfl no-lock where qad_key1 = "pt_status"
              and qad_key2 = xxpt_stat no-error.
       if not available qad_wkfl then do:
          assign xxpt_chk = getMsg(362).
       end.
    end.
end.
*/