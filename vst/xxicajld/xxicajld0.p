/* xxrold.p - xxicccaj.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxloaddata.i}
{xxicajld.i}
define variable txt as character.
empty temp-table xxic no-error.
assign i = 0.
input from value(flhload).
repeat:
    import unformat txt.
    if i <> 0 then do:
          create xxic.
          assign xxic_part = trim(entry(1,txt,",")) no-error.
          assign xxic_site = trim(entry(2,txt,",")) no-error.
          assign xxic_loc = trim(entry(3,txt,",")) no-error.
          assign xxic_lot = trim(entry(4,txt,",")) no-error.
          assign xxic_ref = trim(entry(5,txt,",")) no-error.
          assign xxic_qty_ld = decimal(trim(entry(6,txt,","))) no-error.
          assign xxic_qty_adj = decimal(trim(entry(7,txt,","))) no-error.
          assign xxic_acct = trim(entry(8,txt,",")) no-error.
          assign xxic_sub = trim(entry(9,txt,",")) no-error.
          assign xxic_cc = trim(entry(10,txt,",")) no-error.
    end.
    i = i + 1.
end.
input close.
assign i = 1.
for each xxic exclusive-lock:
    if xxic_part <= "" or xxic_part >= "ZZZZZZZZ" then do:
       delete xxic.
    end.
    else do:
       assign xxic_sn = i
              xxic_chk = "".
    end.
    i = i + 1.
end.
i = i - 1.
/* check data */
for each xxic exclusive-lock:
    if not can-find(first pt_mstr no-lock where pt_part = xxic_part) then do:
          assign xxic_chk = getMsg(17).
          next.
    end.
    find first ld_det no-lock where ld_part = xxic_part and ld_site = xxic_site
           and ld_loc = xxic_loc and ld_lot = xxic_lot and ld_ref = xxic_ref
           no-error.
    if available ld_det then do:
       assign xxic_qty_loc = ld_qty_oh.
       if ld_qty_oh >= 1 then do:
          assign xxic_chk = getMsg(8841).
          next.
       end.
    end.
    else do:
         assign xxic_chk = getMsg(3454).
         next.
    end.
end.
