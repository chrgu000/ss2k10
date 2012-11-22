/* xxshstld.p - xxshstmp.p cim load                                          */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */
/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */

{mfdeclre.i}
{xxshstld.i}
{xxusrwkey1202.i}

define variable txt as character.
define variable i as integer initial 0.
empty temp-table tmpsh no-error.
input from value(flhload).
assign i = 0.
repeat:
    import unformat txt.
    if i <> 0 then do:
       find first tmpsh exclusive-lock where tsh_site = trim(entry(1,txt,","))
              and tsh_abs_id = trim(entry(2,txt,","))
              and tsh_nbr = trim(entry(3,txt,",")) no-error.
       if not available tmpsh then do:
          create tmpsh.
          assign tsh_site = trim(entry(1,txt,","))
                 tsh_abs_id = trim(entry(2,txt,","))
                 tsh_nbr = trim(entry(3,txt,",")) no-error.
       end.
       assign tsh_stat = trim(entry(4,txt,",")) no-error.
    end.
    i = i + 1.
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
							 xxsh_abs_id = "S" + tsh_abs_id no-error.
		if not available xxsh_mst then do:
			 assign tsh_chk = getMsg(99803).
	  end.
end.

/* check data */
for each tmpsh exclusive-lock:
    find first si_mstr no-lock where si_domain = global_domain and
               si_site = tsh_site no-error.
    if not available si_mstr then do:
       assign tsh_chk = getMsg(708).
    end.
    find first abs_mstr no-lock where abs_domain = global_domain and
               abs_shipfrom = tsh_site and
               abs_id = "S" + tsh_abs_id and
               abs_type = "S" no-error.
    if not available abs_mstr then do:
       assign tsh_chk = getMsg(8145).
    end.
    if tsh_nbr = "" then do:
       assign tsh_chk = getMsg(99802).
    end.
end.
