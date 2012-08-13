TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_so.

if xxqad_so = "1" then do:

/* yyexbom.p    Explore BOM  (FOR DCEC ONLY)                                 */
/* Revision: 1.0           BY: Leo Zhou (SH)                DATE: 11/23/07   */

define variable v_part   like pt_part.
define variable v_site   like pt_site.
define variable phm      like pt_phantom.
define variable grp_list as char.
define variable i as int.

define workfile wf
       field wf_part  like ps_comp
       field wf_op    like ps_op
       field wf_usage like ps_qty_per.

/*Initialization*/
for each xxpkd_det:   delete xxpkd_det.  end.

/*Get pt_group list*/
grp_list = "".
for each code_mstr no-lock where code_fldname = "Expand_group":
    if grp_list = "" then grp_list = code_value.
    else grp_list = grp_list + "," + code_value.
end.

/*Get SO list */
for each xxsod_det where xxsod_date = today and xxsod_flg = "0":
    
    /*Explore BOM*/
    for each wf:  delete wf.  end.
    run ex_bom (xxsod_so, today, 1).

    for each wf:

        find first pt_mstr where pt_part = wf_part no-lock no-error.
	find first opm_mstr where opm_std_op = string(wf_op) no-lock no-error.
      
	create xxpkd_det.
	assign xxpkd_so    = xxsod_so
	       xxpkd_comp  = wf_part
	       xxpkd_desc  = if avail pt_mstr  then pt_desc2  else ""
	       xxpkd_wkctr = if avail opm_mstr then opm_wkctr else ""
	       xxpkd_op    = string(wf_op)
	       xxpkd_qty   = wf_usage.
 
    end.  /* for each wk */
    
    /* Add to history table */
    for each xxpkd_det:
        create xxph_hist.
        assign xxph_date  = today
               xxph_time  = time
	       xxph_so    = xxpkd_so
	       xxph_comp  = xxpkd_comp
	       xxph_desc  = xxpkd_desc
	       xxph_wkctr = xxpkd_wkctr
	       xxph_op    = xxpkd_op
	       xxph_qty   = xxpkd_qty
	       xxph_chr01 = xxpkd_chr01
	       xxph_chr02 = xxpkd_chr02.
    end.  /*for each xxpkd_det*/
    
    assign xxsod_flg = "1".

end.  /* for each xxsod_det */

xxqad_so = "2".
end.  /*xxqad_so = "1"*/


procedure ex_bom:
   define input parameter part    like pt_part no-undo.
   define input parameter effdate as date no-undo.
   define input parameter usage   like ps_qty_per no-undo.

   define buffer psmstr for ps_mstr.

   /*Component validation*/
   find pt_mstr where pt_part = part no-lock no-error.
   if not avail pt_mstr then do:
      find bom_mstr where bom_parent = part no-lock no-error.
      if not avail bom_mstr then return.
   end.

   for each ps_mstr no-lock where ps_par = part and 
           (ps_start <= effdate or ps_start = ?) and 
           (ps_end   >= effdate or ps_end = ?) :
    
       find first psmstr no-lock where psmstr.ps_par = ps_mstr.ps_comp
             and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
	     and (psmstr.ps_end   >= effdate or psmstr.ps_end = ?) no-error.

       v_part = "".
       v_site = "".
       if substr(ps_mstr.ps_comp,length(ps_mstr.ps_comp) - 1,2) = "ZZ" then
          v_part = substr(ps_mstr.ps_comp,1,length(ps_mstr.ps_comp) - 2).
       else v_part = ps_mstr.ps_comp.

       find first pt_mstr where pt_part = v_part no-lock no-error.
       
       if can-do(grp_list,pt_group) then v_site = "DCEC-C".
       else v_site = ps_mstr.ps__chr01.

       find first ptp_det where ptp_site = v_site 
              and ptp_part = v_part no-lock no-error.

       phm = if available ptp_det then ptp_phantom else pt_phantom.

       if avail psmstr and 
          (phm = yes or 
           phm = no and can-do(grp_list, pt_group)) then do:
          run ex_bom (ps_mstr.ps_comp, effdate, usage * ps_mstr.ps_qty_per).
       end.
       else do:
          /* Skip phantom leaf node */
          if phm = yes or can-do(grp_list, pt_group) then next.
      /*ÐÂÔö*/ if not can-find(first ptp_det no-lock where ptp_part = ps_mstr.ps_comp) then next.

             create wf.
             assign wf_part  = ps_mstr.ps_comp
	            wf_op    = ps_mstr.ps_op
                    wf_usage = ps_mstr.ps_qty_per * usage.
  
       end. /* else do */
   end.  /* for each ps_mstr */

end.  /*procedure*/
