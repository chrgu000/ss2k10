/*########################################################################
    Copyright  ST Kinetics., Singapore.
    All rights reserved worldwide.

      Program ID  : s7wiprp.p    (for China plant)
           Author : Niranjan Sangapur
   Service Req. No: mfg/ni/0264
               On : 11-Jun-06
       Description: Work Order WIP report
                    Part of Logic copied from s9wiprpt.p 7.13.18.21 WIP Report 
                    & s9racjrp1.p 7.13.18.4 Revenue Analysis for PBO.   
##########################################################################*/
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

{mfdtitle.i}
def var m_wo like wo_nbr no-undo.
def var m_wo1 like wo_nbr no-undo.

def temp-table tt_wip NO-UNDO
        fields t_wonbr  like wo_nbr column-label "加工单"
        fields t_lot    like wo_lot column-label "ID"
        fields t_date   like wo_date column-label "日期"
        fields t_part   like wo_part column-label "零件号"
        fields t_desc   like pt_desc1 column-label "摘要"
        fields t_line   like pt_prod_line column-label "序号"
        fields t_qty    like wo_qty_ord column-label "订货量"
        fields t_comp   like wo_qty_comp column-label "已完成量"
        fields t_mh     as dec label "Man Hour"
        fields t_mc     like sct_mtl_tl label "Material Cost"
        fields t_lb     as dec label "Labour Cost"
        fields t_sc     as dec label "SubCon Cost"
        fields t_rel    like wo_rel_date column-label "发布日期"
        fields t_age    as int FORMAT "->,>>,>>>" label "Aging Days"
        fields t_acct   like wo_acct column-label "帐户"
        fields t_cc     like wo_cc column-label "成本中心"
        INDEX ttindx1 t_wonbr.

form
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

repeat:
for each tt_wip: delete tt_wip. end. 
if m_wo1 = hi_char then m_wo1 = "".
update m_wo colon 22 label "工单"
       m_wo1 label "To"
       with frame a width 80 side-label.
if m_wo1 = "" then m_wo1 = hi_char.
bcdparm="".
{mfquoter.i m_wo}
{mfquoter.i m_wo1}
{mfselbpr.i "printer" 200}
{mfphead.i}

for each wo_mstr where wo_nbr >= m_wo
/*SS 20090207 - B*/
			and wo_domain = global_domain
/*SS 20090207 - E*/
                   and wo_nbr <= m_wo1:
        IF (wo_status = "P" or wo_status = "2" ) THEN NEXT .
        if wo_Status = "C"  then
        do:        
           find last tr_hist no-lock use-index tr_nbr 
               where tr_type = "RCT-WO"     
/*SS 20090207 - B*/
								and tr_domain = global_domain
/*SS 20090207 - E*/
               and   tr_nbr = wo_nbr 
            /* and tr_effdate <= dt1 */ no-error .
           if avail tr_hist then next.
        end. 
        find first pt_mstr where pt_part=wo_part
/*SS 20090207 - B*/
								and pt_domain = global_domain
/*SS 20090207 - E*/
                no-lock no-error.          
        create tt_wip.
        assign t_wonbr= wo_nbr
                t_lot = wo_lot
               t_date = wo_ord_date
               t_part = wo_part
               t_desc = (pt_desc1 + pt_desc2) 
                        when avail pt_mstr
               t_line = pt_prod_line when avail pt_mstr                         
               t_qty  = wo_qty_ord                              
               t_comp = wo_qty_comp                             
               t_rel  = wo_rel_date
               t_age  = today - wo_rel_date
               t_acct = wo_acct                   
               t_cc   = wo_cc.                           
                       

        for each op_hist no-lock use-index op_lot_op
         where op_wo_lot = wo_lot 
/*SS 20090207 - B*/
					and op_domain = global_domain
/*SS 20090207 - E*/         
         /* 
           and op_date <= dt1*/ :
           if op_type begins "DOWN" then NEXT.
           /*********************************
           if lookup(trim(string(op_wo_op)),ws_opn) <> 0 then
           /* ADDITIONAL MAN HOURS */
             t_mh = t_mh + op_act_setup.
           if lookup(trim(string(op_wo_op)),sq_opn) <> 0 then
           /* SUBCON COST */
             t_sc = t_sc + op_act_setup * 
             (if avail wc_mstr then wc_setup_rte else 0 ) .                  
           ***********************************/     
           ASSIGN
           t_mh = t_mh + op_act_run
           t_lb = t_lb + op_lbr_cost.
        end. /*for each op_hist*/
        
        for each wod_det no-lock
         where wod_lot = wo_lot 
/*SS 20090207 - B*/
					and wod_domain = global_domain
/*SS 20090207 - E*/
         break by wod_part:
         /* FIND WTD. AVG. MATERIAL COST FOR THE ISSUES OF COMP */
           if first-of(wod_part) then
           for each tr_hist use-index tr_nbr
              where tr_nbr  = wod_nbr
/*SS 20090207 - B*/
								and tr_domain = global_domain
/*SS 20090207 - E*/
                and tr_type = "ISS-WO"
                and tr_lot = wod_lot
                and tr_part = wod_part
                /*and tr_effdate <= dt1*/
                no-lock:
               t_mc=t_mc - (tr_qty_chg * (tr_price * (tr_ex_rate2 / tr_ex_rate))).
           end. /*for each tr_hist*/              
        end. /*for each wod_det */
end.   /*for each wo_mstr*/ 

   /* PORECEIPTS AGAINST THIS WO */
   if can-find(first pod_det where 
   pod_domain = global_domain and
   pod_so_job <> "" and 
                can-find(first tt_wip where t_wonbr=pod_so_job)) then
   for each pod_det NO-LOCK : 
      if pod_so_job = "" then next.    
      find first tt_wip where t_wonbr=pod_so_job no-error.                     
         
      if not avail tt_wip then next.                        
                
      for each prh_hist no-lock
         where prh_nbr = pod_nbr 
/*SS 20090207 - B*/
						and prh_domain = global_domain
/*SS 20090207 - E*/
           and prh_line = pod_line 
         use-index prh_nbr:
           t_mc = t_mc + 
           (prh_rcvd * (pod_pur_cost * (prh_ex_rate2 / prh_ex_rate))).
         if prh_type="M" then
           t_sc = t_sc +
           (prh_rcvd * (pod_pur_cost * (prh_ex_rate2 / prh_ex_rate))).
      end. /*for each prh_hist */
   end. /*for each po_det  */
for each tt_wip
        break by t_wonbr:
        disp tt_wip with frame fdet down width 250.
end.                        
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .

                   
end. /*repeat*/
