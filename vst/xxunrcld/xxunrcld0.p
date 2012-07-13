/* xxunrcld.p - icunrc.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120704.1 LAST MODIFIED: 07/04/12 BY:                            */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{xxunrcld.i}
define variable txt as character.
empty temp-table tmpic no-error.
input from value(flhload).
repeat:
    import unformat txt.
    create tmpic.
    assign tic_site = entry(1,txt,",")
           tic_nbr = entry(2,txt,",")
           tic_loc = entry(3,txt,",")
           tic_part = entry(4,txt,",")
           tic_qty = dec(entry(5,txt,","))
           tic_acct  = entry(6,txt,",")
           tic_sub  = entry(7,txt,",")
           tic_cc  = entry(8,txt,",") no-error.
    assign tic_proj  = entry(9,txt,",") no-error.
end.
input close.

for each tmpic exclusive-lock :
      if tic_part <= "" or tic_part >= "ZZZZZZZZ" then do:
         delete tmpic.
      end.
      else do:
         assign tic_chk = "".
      end.
end.

/* check data */
for each tmpic exclusive-lock:
    find first pt_mstr no-lock where  pt_part = tic_part no-error.
    if available pt_mstr then do:
         find first isd_det no-lock where isd_stat = pt_status
              and isd_tr_type = "RCT-UNP" no-error.
         if available isd_det then do:
              assign tic_chk = getMsg(2495).
         end.
    end.
    else do:
          assign tic_chk = getMsg(17).
    end.
    if tic_qty < 0  then do:
       find first ld_det no-lock where ld_site = tic_site and
            ld_loc = tic_loc and ld_part = tic_part no-error.
       if available ld_det and ld_qty_oh < abs(tic_qty) then do:
          assign tic_chk = getMsg(125).
       end.
       if not available ld_det then do:
          assign tic_chk = getMsg(125).
       end.
    end.
    find first si_mstr no-lock where si_site = tic_site no-error.
    if not available si_mstr then do:
       assign tic_chk = getMsg(2797).
    end.
    find first loc_mstr no-lock where loc_site = tic_site and
               loc_loc = tic_loc no-error.
    if not available loc_mstr then do:
       assign tic_chk = getMsg(229).
    end.
end.
