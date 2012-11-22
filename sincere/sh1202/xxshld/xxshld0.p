/* xxptld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */
/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */

{mfdeclre.i}
{xxshld.i}
{xxusrwkey1202.i}

define variable txt as character.
empty temp-table tmpsh no-error.
input from value(flhload).
repeat:
    import unformat txt.
    find first tmpsh exclusive-lock where tsh_site = trim(entry(1,txt,","))
           and tsh_abs_id = trim(entry(2,txt,","))
           and tsh_nbr = trim(entry(3,txt,",")) no-error.
    if not available tmpsh then do:
       create tmpsh.
       assign tsh_site = trim(entry(1,txt,","))
              tsh_abs_id = trim(entry(2,txt,","))
              tsh_nbr = trim(entry(3,txt,",")) no-error.
    end.
    assign tsh_lgvd = trim(entry(4,txt,",")) no-error.
    assign tsh_shipto = trim(entry(5,txt,","))  no-error.
    assign tsh_price = trim(entry(6,txt,",")) no-error.
    assign tsh_pc = trim(entry(7,txt,",")) no-error.
    assign tsh_dc  = trim(entry(8,txt,",")) no-error.
    assign tsh_uc  = trim(entry(9,txt,",")) no-error.
    assign tsh_lc = trim(entry(10,txt,",")) no-error.
    assign tsh_rmks  = trim(entry(11,txt,",")) no-error.
end.
input close.

for each tmpsh exclusive-lock :
      if tsh_site <= "" or tsh_site >= "ZZZZZZZZ" then do:
         delete tmpsh.
      end.
      else do:
         assign tsh_chk = "".
      end.
end.

for each tmpsh exclusive-lock:
		find first xxsh_mst no-lock where xxsh_domain = global_domain and
							 xxsh_site = tsh_site and xxsh_nbr = tsh_nbr and 
							 xxsh_abs_id = tsh_abs_id no-error.
		if available xxsh_mst then do:
			 if tsh_lgvd = "-" then assign tsh_lgvd = xxsh_lgvd.
			 if tsh_shipto = "-" then assign tsh_shipto = xxsh_shipto.	
			 if tsh_price = "-" then assign tsh_price = string(xxsh_price).
			 if tsh_pc = "-" then assign tsh_pc = string(xxsh_pc).
			 if tsh_dc = "-" then assign tsh_dc = string(xxsh_dc).
			 if tsh_uc = "-" then assign tsh_uc = string(xxsh_uc).
			 if tsh_lc = "-" then assign tsh_lc = string(xxsh_lc).
			 if tsh_rmks = "-" then assign tsh_rmks = xxsh_rmks.
	  end.
end.

/* check data */
for each tmpsh exclusive-lock:
    find first si_mstr no-lock where si_domain = global_domain and
               si_site = tsh_site no-error.
    if not available si_mstr then do:
       assign tsh_chk = getMsg(708).
       next.
    end.
    find first abs_mstr no-lock where abs_domain = global_domain and
               abs_shipfrom = tsh_site and
               abs_id = "S" + tsh_abs_id and
               abs_type = "S" no-error.
    if not available abs_mstr then do:
       assign tsh_chk = getMsg(8145).
       next.
    end.
    if tsh_nbr = "" then do:
       assign tsh_chk = getMsg(99802).
       next.
    end.
    if not can-find(first usrw_wkfl no-lock where usrw_domain = global_domain
                      and usrw_key1 = vlgvdkey and usrw_key2 = tsh_lgvd)
       or tsh_lgvd = "" then do:
       assign tsh_chk = getMsg(99800).
       next.
    end.
    if not can-find(first usrw_wkfl no-lock where usrw_domain = global_domain
                      and usrw_key1 = vsptokey and usrw_key2 = tsh_shipto)
       or tsh_shipto = "" then do:
       assign tsh_chk = getMsg(99802).
       next.
    end.
    if decimal(tsh_price) = 0 then do:
       assign tsh_chk = getMsg(317).
       next.
    end.
end.
