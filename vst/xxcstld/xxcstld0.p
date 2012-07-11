/* xxcstldo.p - ppcsbtld.p cim load                                          */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{xxcstld.i}
define variable txt as character.
define variable vdte as character.
define variable i as integer.
empty temp-table xxsptdet no-error.
assign i = 0.
input from value(flhload).
repeat:
    i = i + 1.
    import unformat txt.
    if i > 1 then do:
       find first xxsptdet exclusive-lock where
                  xxspt_site = trim(entry(2,txt,",")) and
                  xxspt_sim = trim(entry(3,txt,",")) and
                  xxspt_part = trim(entry(1,txt,",")) and
                  xxspt_element = trim(entry(4,txt,",")) no-error.
       if not available xxsptdet then do:
          create xxsptdet.
          assign xxspt_site = trim(entry(2,txt,","))
                 xxspt_sim = trim(entry(3,txt,","))
                 xxspt_part = trim(entry(1,txt,","))
                 xxspt_element = trim(entry(4,txt,",")).
       end.
          assign xxspt_cst = decimal(trim(entry(5,txt,","))) no-error.
    end. /* if i > 1 then do: */
end.
input close.

for each xxsptdet exclusive-lock :
      if xxspt_site <= "" or xxspt_site >= "ZZZZZZZZ" then do:
         delete xxsptdet.
      end.
      else do:
         assign xxspt_chk = "".
      end.
end.

/* check data */
for each xxsptdet exclusive-lock:
    find first pt_mstr no-lock where pt_part = xxspt_part no-error.
    if not available pt_mstr then do:
       assign xxspt_chk = getmsg(17).
    end.
    find first si_mstr no-lock where si_site = xxspt_site no-error.
    if not available si_mstr then do:
       assign xxspt_chk = getMsg(2797).
    end.
    find first cs_mstr no-lock where cs_set = xxspt_sim no-error.
    if not available cs_mstr then do:
       assign xxspt_chk = getMsg(5407).
    end.
    find first sc_mstr no-lock where sc_sim = xxspt_sim and
               sc_element = xxspt_element no-error.
    if not available sc_mstr then do:
       assign xxspt_chk = getMsg(5420).
    end.
    if xxspt_cst <= 0 then do:
       assign xxspt_chk = getMsg(4915).
    end.
    find first spt_det no-lock where spt_site = xxspt_site and
               spt_sim = xxspt_sim and spt_part = xxspt_part and
               spt_element = xxspt_element no-error.
    if available spt_det then do:
       assign xxspt_ocst = spt_cst_tl.
    end.
end.
