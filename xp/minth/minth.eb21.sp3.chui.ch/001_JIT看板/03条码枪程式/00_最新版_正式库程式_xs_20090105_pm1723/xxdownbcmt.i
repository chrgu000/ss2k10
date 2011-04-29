
find first si_mstr
     where si_mstr.si_domain = global_domain 
       and si_site = site no-lock no-error.

sf_entity = (if available si_mstr then si_entity else "").

find first emp_mstr
     where emp_mstr.emp_domain = global_domain 
       and emp_addr = emp no-lock no-error.

project = (if available emp_mstr then emp_project else "").
pay_rate = (if available emp_mstr then emp_pay_rate else 0).

earn = "".
for first ea_mstr
   fields( ea_domain ea_earn ea_rate ea_type)
    where ea_mstr.ea_domain = global_domain and  ea_type = "1"
   no-lock:
   earn = ea_earn.
end. /* FOR FIRST ea_mstr */

find first gl_ctrl
     where gl_ctrl.gl_domain = global_domain no-lock no-error.

for first wc_mstr
   fields( wc_domain wc_bdn_pct wc_bdn_rate wc_dept wc_lbr_rate wc_mch
           wc_wkctr)
    where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
            and   wc_mch   = mch
            no-lock:
end. /* FOR FIRST wc_mstr */

if not available wc_mstr
   and wkctr <> ""
then do:
   next-prompt p_bc.

   /* WORK CENTER/MACHINE NOT FOUND */
   {pxmsg.i &MSGNUM=528 &ERRORLEVEL=3}
   undo, retry.
end. /* IF NOT AVAILABLE wc_mstr ... */

assign
   sf_lbr_acct = gl_lbr_acct
   sf_lbr_sub  = gl_lbr_sub
   sf_lbr_cc   = gl_lbr_cc
   sf_bdn_acct = gl_bdn_acct
   sf_bdn_sub  = gl_bdn_sub
   sf_bdn_cc   = gl_bdn_cc
   sf_cop_acct = gl_cop_acct
   sf_cop_sub  = gl_cop_sub
   sf_cop_cc   = gl_cop_cc.

create op_hist. 
       op_hist.op_domain = global_domain.

{mfnoptr.i}

assign
     op_emp       = emp
     op_earn      = earn
     op_dept      = dept
     op_shift     = shift
     op_site      = site
     op_project   = project
     op_tran_date = today
     op_type      = "DOWN"
     op_wkctr     = wkctr
     op_mch       = mch
     op__chr01    = down_rsn_code
     op_date      = eff_date
     op_act_run   = act_setup_hrs20
     op_recno     = recid(op_hist).

  {sfnplgl.i}