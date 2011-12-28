
define {1} shared temp-table tmp_data
  fields td_part like pt_part
  fields td_routing like ro_routing
  fields td_op  like ro_op
  fields td_nbr as character
  fields td_id  as character
  fields td_feature as character
  fields td_attr as character
  fields td_methd as character
  fields td_spec as character
  fields td_um as character
  fields td_effdate as date
  fields td_enddate as date
  fields td_rmks as character format "x(76)" extent 5
  fields td_chk as character format "x(120)".
 
 FUNCTION getmsg RETURNS CHARACTER (msgnbr as INTEGER,lng as character):
 		 define variable msgdesc like msg_desc.
 		 if lng = "" then assign lng = "CH".
 		 assign msgdesc = "".
 		 find first msg_mstr where msg_nbr = msgnbr and msg_lang = lng no-error.
 		 if avail msg_mstr then do:
 		 		assign msgdesc = msg_desc.
 		 end. 
 		 return msgdesc.
 end function.


 procedure chkData:
 for each tmp_data exclusive-lock:
 		  find pt_mstr where pt_domain = global_domain
                     and pt_part   = td_part no-lock no-error.
      if available pt_mstr then do:
      	 assign td_chk = getmsg(16,global_lang).
      end.
      if td_id <> "" then do:
     		 assign td_chk = td_chk + ";" + getmsg(40,global_lang).
      end.
      else do:
      	 assign td_chk =  getmsg(40,global_lang).
      end.
       if can-find(first ipd_det
                        where ipd_domain   = global_domain
                        and   (ipd_part    =td_part
                        and    ipd_routing = td_routing
                        and    ipd_op      = td_op
                        and    ipd_test    = td_id
                        and    ((ipd_start <= td_effdate
                                or ipd_start = ?)
                        and    (ipd_end    >= td_effdate
                                or ipd_end = ?))))
         then do:
            assign td_chk = td_chk + ";" + getmsg(122,global_lang).
         end.
         if td_enddate < td_effdate then do:
         	  assign td_chk = td_chk + ";" + getmsg(123,global_lang).
         end.
 end.
 end procedure.
 
