/* gpmpup.p - Recalculate Materials Plan - Net Change, Regen, Selective */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.13.1.19 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.2       LAST EDIT: 01/25/95   MODIFIED BY: *F0GM* Evan Bishop */
/* REVISION: 7.3       LAST EDIT: 05/30/96   MODIFIED BY: *G1WY* Evan Bishop */
/* REVISION: 7.3       LAST EDIT: 06/21/96   MODIFIED BY: *G1YJ* Evan Bishop */
/* REVISION: 7.4       LAST EDIT: 01/09/97   MODIFIED BY: *H0R2* Russ Witt   */
/* REVISION: 7.3       LAST EDIT: 07/16/96   MODIFIED BY: *G29B* Evan Bishop */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 04/06/98   BY: *J23R* Sandesh Mahagaokar */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 02/17/99   BY: *J3B7* Mugdha Tambe       */
/* REVISION: 9.1      LAST MODIFIED: 03/01/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 10/11/99   BY: *J3LH* Prashanth Narayan  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 12/13/00   BY: *M0Y2* Vandna Rohira      */
/* Revision: 1.13.1.10 BY: Irine D'Mello         DATE: 09/10/01  ECO: *M164*  */
/* Revision: 1.13.1.11 BY: Anitha Gopal          DATE: 11/12/01  ECO: *N164*  */
/* Revision: 1.13.1.14 BY: Saurabh Chaturvedi    DATE: 12/19/01  ECO: *M1SJ*  */
/* Revision: 1.13.1.16 BY: Tony Brooks           DATE: 05/02/02  ECO: *P05X*  */
/* Revision: 1.13.1.18 BY: Tony Brooks           DATE: 07/23/02  ECO: *P0BY*  */
/* $Revision: 1.13.1.19 $ BY: Tony Brooks        DATE: 10/31/02  ECO: *P0JR*  */

/* $Revision: ss - 090616.1  $    BY: mage chen : 05/14/09 ECO: *090616.1*    */


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:NonStreamIoFrame=audit */

/* CODE MODIFIED TO PREVENT INFINITE LOOPING AFTER PROCESSING            */
/* 1000 IN_MRP RECORDS AT SAME LOW LEVEL CODE FOR WHICH IN_MRP           */
/* FLAG HAS NOT BEEN CHANGED FORM YES TO NO                              */

{mfglobal.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gpmpup_p_1 "Elapsed!Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_2 "Planned!Orders!Processed"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_4 "Process Started"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_5 "Process Stopped"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_6 "Order!Count"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_9 "Items!Processed"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* Define the shared variables used here and in called subroutines */
{gpmpvar2.i "shared" }

define new shared variable reldays like mrpc_reldays.
define new shared variable frwrd like soc_fcst_fwd.
define new shared variable mrfsup1_frwrd like soc_fcst_fwd no-undo.
define new shared variable bck    like soc_fcst_bck.
define new shared variable in_recid as recid.
define new shared variable horizon as integer no-undo.
define new shared variable wo_recid as recid.
define new shared variable comp as character.
define new shared variable qty as decimal.
define new shared variable eff_date as date.
define new shared variable part as character.
define new shared variable site as character.
define new shared variable increment as integer.
define new shared variable numorders as integer
   format "->>>,>>>,>>>"
   column-label {&gpmpup_p_2}.
define new shared variable use-op-yield as logical no-undo.

define shared variable mfguser as character.
define shared variable dtitle as character.
define shared variable batchrun like mfc_logical.
/*V8!    define shared variable execname as character. */
define shared variable hi_date as date.
define shared variable low_date as date.

define variable pt_recid as recid no-undo.
define variable z as integer column-label {&gpmpup_p_9}
   format ">,>>>,>>9" no-undo.
define variable z1 as integer format ">>>>>>9" no-undo.
define variable low_level as integer no-undo.
define variable max_level as integer no-undo.
define variable min_level as integer no-undo.
define variable audit like mfc_logical initial yes no-undo.
define variable part_orders as integer column-label {&gpmpup_p_6}
   format ">>>>9" no-undo.
define variable start_time as integer extent 3 no-undo.
define variable start_date as date extent 2 no-undo.
define variable elapsed as integer column-label {&gpmpup_p_1}
   format ">>>>>,>>>" no-undo.

define stream audit.

define variable started as character format "x(20)"
   label {&gpmpup_p_4} no-undo.
define variable stopped as character format "x(20)"
   label {&gpmpup_p_5} no-undo.
define variable last_flag as logical no-undo.
define variable dblcol as character initial "::" no-undo.
define variable qad-recno as recid no-undo.
define variable qadmrpkey as character initial "mrp/drp" no-undo.
define variable qadkey2 as character no-undo.
define variable save_mrp_req as logical no-undo.
define variable path as character no-undo.
define variable last_part as character no-undo.
define variable last_site as character no-undo.
define variable ptp_recid as recid no-undo.
define variable n_items_proc as integer no-undo.
define variable prev_part  like in_part  no-undo.
define variable prev_level like in_level no-undo.
define variable l_pmcode like pt_pm_code no-undo.

define buffer qadwkfl for qad_wkfl.

define new shared buffer gl_ctrl for gl_ctrl.
define new shared buffer in_mstr for in_mstr.
define new shared buffer pt_mstr for pt_mstr.
define new shared buffer ptp_det for ptp_det.

define new shared temp-table tt-routing-yields no-undo
   field tt-op         like ro_op
   field tt-start      like ro_start
   field tt-end        like ro_end
   field tt-yield-pct  like ro_yield_pct
   index tt-op is unique primary
   tt-op
   tt-start.


/* AppServer MultiThread vars*/

{mtdef.i}

define variable app-string as character no-undo.
define variable last-time as integer no-undo.
define variable item-count as integer no-undo.
define variable last-rowid as rowid no-undo.
define variable req-tot as integer no-undo.
define variable tmp-desc1 like pt_desc1 no-undo.
define variable elap-time as integer no-undo.
define variable open-date as date no-undo.
define variable open-time as integer no-undo.
define variable mrppl as handle no-undo.
define variable oracle-db as logical no-undo.
define variable mrppl-tot as integer no-undo.

assign oracle-db = dbtype("qaddb") = "ORACLE".

define temp-table tt_rep no-undo
   field tt_part like in_part
   field tt_site like in_site
   field tt_desc like pt_desc1
   field tt_orders as integer
   field tt_time as integer
   index main tt_part tt_site.

define temp-table tt_req_sub no-undo
       field tt_part like in_part
       field tt_site like in_site
       field tt_desc like pt_desc1
       field tt_orders as integer
       field tt_inc as integer
       field tt_etime as integer .

define temp-table tt_back no-undo
       field tt_part like in_part
       field tt_site like in_site
       field tt_desc like pt_desc1
       field tt_orders as integer
       field tt_inc as integer
       field tt_etime as integer .

define variable req-sub-count as integer no-undo.
define variable temp-table-depth as integer no-undo.


/* Connect to AppServer */
if apps_threads > 0 then do:

   for first aps_mstr
             fields(aps_name aps_appservice_name aps_host_name aps_port_nbr)
             where aps_name = apps-name
             no-lock: end.


   if not available(aps_mstr) then do:
      /*Cannot connect to AppServer #*/
      {pxmsg.i &MSGNUM=3888 &ERRORLEVEL=3 &MSGARG1="(2)"}
      pause.
      return.
   end.

   assign app-string = "-AppService " + aps_appservice_name + " -H " +
                       aps_host_name + " -S " + aps_port_nbr.

   {mtinit.i &threads=apps_threads &appserver=app-string}

end.

{mfphead2.i "stream log" "(log)"}

form
   z1 no-label
   in_mstr.in_site
   pt_mstr.pt_part
   pt_mstr.pt_desc1 format "x(22)"
   in_mstr.in_level format "->>>9"
   part_orders
   elapsed
with frame log down no-attr-space width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame log:handle).

form
   started z numorders elapsed stopped
with frame log-audit width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame log-audit:handle).

form
   started z numorders elapsed stopped
with frame audit width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame audit:handle).

assign
   path = local-path
   save_mrp_req = mrp_req.

/**************************************************************
The variable 'increment' is the template for the order number
for planned orders created in the MRP/DRP calculations.  All
planned orders created in the calculations will have an order
number based on this variable.  As each order is created, this
variable will be incremented by 1 (one), checking first to see
that the resulting number is not already in use by some other
order. Note that if enough orders are created in this run, that
the order number may not be recognizable as being of the form
"MMDD0001", which is the initial format, ie., starting with an
increment value of '01250001' and creating 100,000 planned orders
will result in planned order numbers of the form "01350001".
****************************************************************/

increment =   integer(string(month(today),"99")
            + string(day(today),"99") + "0001").

for first gl_ctrl no-lock:
end.  /* FOR FIRST gl_ctrl NO-LOCK */


horizon = ?.

for first mrpc_ctrl
   fields(mrpc_horizon mrpc_reldays mrpc_op_yield)
no-lock:
end. /* FOR FIRST mrpc_ctrl */

if available mrpc_ctrl
then
   assign
      reldays = mrpc_reldays
      horizon = mrpc_horizon.

do for soc_ctrl:
   for first soc_ctrl
       fields(soc_fcst_fwd soc_fcst_bck)
       no-lock:
   end. /* for first soc_ctrl */

   if available soc_ctrl
   then
   assign
      frwrd = soc_fcst_fwd
      mrfsup1_frwrd = soc_fcst_fwd
      bck = soc_fcst_bck.
end.

/*SS - 090616.1 - B*  befor mrp cal , cal myself mrp ************************************************/
define new shared  temp-table pln_det no-undo  /*原始需求 from schd_det , by date by order by line */
   field  pln_site      like pt_site
   field  pln_part      like pt_part
   field  pln_nbr       like so_nbr
   field  pln_line      like sod_line
   field  pln_date      like pod_due_date
   field  pln_due_date  like pod_due_date
   field  pln_rel_date  like pod_due_date
   field  pln_qty_ord   like seq_qty_req 
   field  pln_cum_req   like seq_qty_req 
   field  pln_cum_rcvd  like pod_qty_ord
   field  pln_um        like pod_um
   index  plan1 is primary  unique   
     pln_site ascending  
     pln_part ascending  
     pln_date ascending 
     pln_nbr  ascending  
     pln_line ascending .

 
define temp-table temp1 /*需求 : 按Due_date日期汇总的需求*/
   field  t1_site      like pod_site
   field  t1_part      like  pt_part
   field  t1_date      like pod_due_date
   field  t1_qty_ord   like seq_qty_req 
   field  t1_qty_shp   like seq_qty_req 
   index  temp1 is primary  unique   
     t1_site ascending  
     t1_part ascending  
     t1_date ascending 
     .

 
define temp-table temp2 /*供给: 未删除掉的工单 */
   field  t2_site      like wo_site
   field  t2_nbr       like wo_nbr 
   field  t2_lot       like wo_lot
   field  t2_part      like wo_part
   field  t2_date      like wo_due_date
   field  t2_qty_ord   like wo_qty_ord 
   index  temp2 is primary  unique   
     t2_site ascending  
     t2_lot  ascending
     t2_part ascending  
     .

define temp-table temp3  /*供给: 本次需产生的新工单*/
   field  t3_site      like wo_site
   field  t3_part      like wo_part
   field  t3_date      like wo_due_date
   field  t3_qty_ord   like wo_qty_ord 
   index  temp2 is primary  unique   
     t3_site ascending  
     t3_part ascending  
     t3_date ascending 
     .

for each temp1 :   delete temp1 .  end.
for each temp2 :   delete temp2 .  end. 
for each temp3 :   delete temp3 .  end. 
for each pln_det:  delete pln_det. end.


 
/*查找原始需求*/
for each scx_ref
            fields(scx_line scx_order scx_part scx_po scx_shipfrom scx_shipto 
            scx_type scx_custref scx_modelyr  )
            where scx_type      = 1  
            no-lock,
    each pt_mstr  
            fields(pt_part pt_run_seq2) 
            where pt_part = scx_part 
            and pt_run_seq2 = "sp-mrp"  /*限指定类型*/
            no-lock,
    each sod_det
            fields( sod_cmtindx  sod_contr_id sod_cum_qty sod_curr_rlse_id
                  sod_custpart sod_dock  sod_line    sod_nbr sod_site sod_consignment
                  sod_ord_mult sod_part  sod_pkg_code sod_um sod_start_eff[1] sod_end_eff[1])
            where sod_nbr   = scx_order
            and   sod_line  = scx_line
            and   sod_site  >= site1 and sod_site <= site2
            no-lock,
    each so_mstr
            fields( so_cmtindx so_cum_acct so_cust so_nbr so_ship_cmplt)
            where so_nbr    = sod_nbr
            no-lock,
    each sch_mstr
            fields( sch_cmtindx sch_line sch_nbr sch_pcr_qty sch_rlse_id sch_type)
            where sch_type   = scx_type
            and sch_nbr      = sod_nbr
            and sch_line     = sod_line
            and sch_rlse_id  = sod_curr_rlse_id[1]
            no-lock,
    each schd_det
            fields( schd_cmtindx   schd_cum_qty  schd_date
            schd_discr_qty schd_line     schd_nbr  schd_reference
            schd_rlse_id   schd_ship_qty schd_time schd_type)
            where schd_type    = sch_type
            and schd_nbr       = sch_nbr 
            and schd_line      = sch_line
            and schd_rlse_id   = sch_rlse_id
            and (schd_discr_qty >= schd_ship_qty  and not schd__log01 ) /*客户日程未出货完成,且未审核*/
            no-lock
    break
        by scx_shipfrom
        by scx_shipto
        by scx_order
        by scx_line 
        by schd_date
        by schd_time
        by schd_rlse_id
        by schd_reference /*
        by sod_part
        by sod_contr_id
        by scx_custref
        by scx_modelyr */
        :

        find first pln_det 
             where pln_site = sod_site 
             and pln_nbr    = sod_nbr 
             and pln_line   = sod_line 
             and pln_part   = sod_part 
             and pln_date   = schd_date 
        no-error.
        if not available pln_det then do:
            create pln_det .
            assign pln_site   = sod_site  
                   pln_nbr    = sod_nbr
                   pln_line   = sod_line
                   pln_part   = sod_part
                   pln_date   = schd_date
                   pln_um     = sod_um
                   pln_cum_rcvd = sod_cum_qty[1]  /*这个什么时候用???*/
                   .
        end.

        assign  pln_qty_ord  = pln_qty_ord  + schd_discr_qty - schd_ship_qty.
        if pln_cum_req < schd_cum_qty then  assign pln_cum_req = schd_cum_qty.   /*这个什么时候用???*/
  
end. /* FOR EACH scx_ref */

/*
for each pln_det :
message "test001"  
pln_site 
pln_nbr  
pln_line 
pln_part 
pln_date 
pln_um   
pln_qty_ord
pln_cum_req
pln_cum_rcvd
view-as alert-box .
end.
*/

/*begin: 产生wo_mstr wo_status = "F" **************************************************/

/*modify like mrmpup02.p* 

{mfdeclre.i}
{gplabel.i}
{pxmaint.i}

{pxphdef.i wocmnrtn}  

define new shared variable dsd_recno1 as recid.
define new shared variable del-yn1 like mfc_logical.

define new shared variable part like pt_part.
define new shared variable increment1 as integer.
define new shared variable plan_qty1       like mrp_qty      extent 1000 no-undo.
define new shared variable plan_date1      like mrp_due_date extent 1000 no-undo.
define new shared variable plan_yield_pct1 like wo_yield_pct extent 1000 no-undo.

define new shared buffer in_mstr for in_mstr.
define new shared buffer pt_mstr for pt_mstr.
define new shared buffer ptp_det for ptp_det.
define new shared buffer gl_ctrl for gl_ctrl.

define buffer supply for mrp_det.
define buffer scrap for mrp_det.
define buffer womstr for wo_mstr.
define buffer dsrmstr for dsr_mstr.

define temp-table dsr-req-nbr no-undo
   field dsr-req-nbr as character
   index dsr-req-nbr is unique primary
   dsr-req-nbr ascending.

define query q-supply for supply.
**************************************************/


define var v_undo      like mfc_logical .   v_undo = no .
define var v_qty_avail like in_qty_avail .
define var v_qty_need  like in_qty_avail .
define var sfty_stk    like in_sfty_stk .
define var v_date_begin as date .


define variable needed as date no-undo.
define variable leadtime like pt_mfg_lead no-undo.
define variable i as integer no-undo.
define variable inc as character format "x(8)" no-undo.
define variable safety_insp  as integer no-undo.
define variable mrpdet_recno as recid   no-undo.
define variable wdays as integer no-undo.
define variable sfty_time like pt_sfty_time no-undo.
define variable insp_rqd  like pt_insp_rqd  no-undo.
define variable insp_lead like pt_insp_lead no-undo.
define variable ord_pol   like pt_ord_pol   no-undo.
define variable timefence like pt_timefence no-undo.
define variable ord_qty   like pt_ord_qty   no-undo.
define variable ord_min   like pt_ord_min   no-undo.
define variable ord_per   like pt_ord_per   no-undo.
define variable ord_mult  like pt_ord_mult  no-undo.
define variable mfg_lead  like pt_mfg_lead  no-undo.
define variable pur_lead  like pt_pur_lead  no-undo.
define variable routing   like pt_routing   no-undo.
define variable bom_code  like ptp_bom_code no-undo.
define variable planned     as integer   no-undo.
define variable err-flag    as integer   no-undo.
define variable original_db as character no-undo.
define variable l_errorno   as integer   no-undo.
define variable wovar                 like woc_var                no-undo.
define variable joint_type            like wo_joint_type          no-undo.
define variable supplier_perf_enabled like mfc_logical initial no no-undo.
define variable dsr_recid as integer no-undo.
/*define variable pm_code   like pt_pm_code   no-undo.  */
/*define variable site      like in_site      no-undo.  */


{inmrp1.i}

/*{mfdatev.i} *duplicate var*/
define variable nonwdays as integer no-undo.
define variable workdays as integer no-undo.
define variable overlap as integer no-undo.
define variable know_date as date no-undo.
define variable find_date as date no-undo.
define variable interval as integer no-undo.

original_db = global_db.


/*累计需求量qty_ord, 计算due_date rel_date*/
for each pln_Det break by pln_site by pln_part by pln_date:
    if first-of(pln_part) then do: 

       find first pt_mstr where pt_part = pln_part no-lock no-error.
       find first in_mstr where in_site = pln_site and in_part = pln_part no-lock no-error.
       find first ptp_det where ptp_site = pln_site and ptp_part = pln_part no-lock no-error .

       if available ptp_det
        then
          assign
          bom_code   = ptp_bom_code
          joint_type = ptp_joint_type
          routing    = ptp_routing
          sfty_time  = ptp_sfty_tme
          insp_rqd   = ptp_ins_rqd
          pm_code    = ptp_pm_code
          insp_lead  = ptp_ins_lead
          ord_pol    = ptp_ord_pol
          timefence  = ptp_timefnce
          ord_qty    = ptp_ord_qty
          ord_min    = ptp_ord_min
          ord_per    = ptp_ord_per
          ord_mult   = ptp_ord_mult
          mfg_lead   = ptp_mfg_lead
          pur_lead   = ptp_pur_lead.

         else
         assign
          routing    = pt_routing
          bom_code   = pt_bom_code
          joint_type = pt_joint_type
          sfty_time  = pt_sfty_time
          insp_rqd   = pt_insp_rqd
          pm_code    = pt_pm_code
          insp_lead  = pt_insp_lead
          ord_pol    = pt_ord_pol
          timefence  = pt_timefence
          ord_qty    = pt_ord_qty
          ord_min    = pt_ord_min
          ord_per    = pt_ord_per
          ord_mult   = pt_ord_mult
          mfg_lead   = pt_mfg_lead
          pur_lead   = pt_pur_lead.

        assign
          timefence = max(timefence,0)
          safety_insp = sfty_time.


         leadtime = mfg_lead.

        if leadtime = ?
        then
           leadtime = 0. 
            
           /*清理旧工单*/
           for each wo_mstr  
               where wo_site = pln_site 
               and   wo_part = pln_part 
               and  (wo_status = "P" 
                     or ( wo_status = "F" 
                         and wo__chr05 = "sp-mrp" /*标识本程式产生的*/
                         and not wo__log01 /*标识未核准的*/
                        )
                    ) 
               exclusive-lock:

               {mfdel1.i wr_route  "where wr_lot = wo_lot"}

               for each wod_det exclusive-lock
                  where wod_lot = wo_lot:

                  {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}
                  {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)}

                  run inmrp (input wod_part, input wod_site).

                  delete wod_det.

               end.

               {mfmrwdel.i "wo_mstr" wo_part wo_nbr wo_lot """"}

               run inmrp (input wo_part, input wo_site).

               delete wo_mstr.

           end. /*for each wo_mstr */

           {mfdel1.i mrp_det  "where mrp_dataset = 'cs sch_mstr' and mrp_part = pln_part "}

    end.  /*if first-of(pln_part) then */

    /*计算due_date*/
    pln_due_date = ? .
    {mfdate.i pln_due_date  pln_date  safety_insp wo_site}

    /*due_date提前期不足的/过期的 , 挪到今天(+时界点)*/
    if pln_due_date < today + timefence then do:
        pln_due_date = today + timefence.
        {mfhdate.i pln_due_date 1 pln_site }
    end.

    /*计算下达日期*
    pln_rel_date = ? .
    {mfdate.i pln_rel_date  pln_due_date  leadtime  wo_site}*/

    /*按Due_date汇总每日需求*/
    find first temp1 where t1_site = pln_site and t1_part = pln_part and t1_date = pln_due_date no-lock no-error .
    if not avail temp1 then do:
        create temp1 .
        assign t1_site = pln_site 
               t1_part = pln_part 
               t1_date = pln_due_date
               t1_qty_ord = pln_qty_ord 
               .
    end.
    else t1_qty_ord = pln_qty_ord + t1_qty_ord .

end.  /*for each pln_Det*/

/*
for each temp1 :
message "test002" 
t1_site
t1_part
t1_date
t1_qty_ord
view-as alert-box .
end.
*/

for each temp1 break by t1_site by t1_part by t1_date :
    if first-of(t1_part) then do:
       find first pt_mstr where pt_part = t1_part no-lock no-error.
       find first ptp_det where ptp_site = t1_site and ptp_part = t1_part no-lock no-error .

       if available ptp_det
        then
          assign
          bom_code   = ptp_bom_code
          joint_type = ptp_joint_type
          routing    = ptp_routing
          sfty_time  = ptp_sfty_tme
          insp_rqd   = ptp_ins_rqd
          pm_code    = ptp_pm_code
          insp_lead  = ptp_ins_lead
          ord_pol    = ptp_ord_pol
          timefence  = ptp_timefnce
          ord_qty    = ptp_ord_qty
          ord_min    = ptp_ord_min
          ord_per    = ptp_ord_per
          ord_mult   = ptp_ord_mult
          mfg_lead   = ptp_mfg_lead
          sfty_stk   = ptp_sfty_stk
          pur_lead   = ptp_pur_lead.

         else
         assign
          routing    = pt_routing
          bom_code   = pt_bom_code
          joint_type = pt_joint_type
          sfty_time  = pt_sfty_time
          insp_rqd   = pt_insp_rqd
          pm_code    = pt_pm_code
          insp_lead  = pt_insp_lead
          ord_pol    = pt_ord_pol
          timefence  = pt_timefence
          ord_qty    = pt_ord_qty
          ord_min    = pt_ord_min
          ord_per    = pt_ord_per
          ord_mult   = pt_ord_mult
          mfg_lead   = pt_mfg_lead
          sfty_stk   = pt_sfty_stk
          pur_lead   = pt_pur_lead.

        assign
          timefence = max(timefence,0)
          safety_insp = sfty_time.


         leadtime = mfg_lead.

        if leadtime = ?
        then
           leadtime = 0. 
           
        find first in_mstr where in_site = t1_site and in_part = t1_part no-lock no-error.
        v_qty_avail = if avail in_mstr then in_qty_avail else 0 .
        v_qty_need  = sfty_stk - v_qty_avail .

        for each temp2: delete temp2 . end .
        
        for each wo_mstr 
                where wo_site = t1_site 
                and wo_part = t1_part 
                and index("XC",wo_status) = 0 
                and wo_qty_ord > wo_qty_comp 
            no-lock :
            find first temp2 where t2_site = wo_site and t2_lot = wo_lot and t2_part = wo_part no-lock no-error .
            if not avail temp2 then do:
                create temp2 .
                assign t2_site = wo_site 
                       t2_lot  = wo_lot
                       t2_nbr  = wo_nbr
                       t2_part = wo_part 
                       t2_date = wo_due_date 
                       t2_qty_ord = wo_qty_ord - wo_qty_comp
                       .
            end.            
        end.
        
        /*现有库存不足安全库存,提示:1001 开始可用性小于零 *oa_det会被标准MRP开始时删除*
        if v_qty_need > 0 then do:
            create oa_det.  
            assign
            oa_detail  = "testtest"
            oa_part    = t1_part
            oa_nbr     = ""
            oa_site    = t1_site
            oa_line    = ""
            oa_code    = 1001
            oa_qty     = v_qty_need
            oa_fr_date = today + timefence
            oa_to_date = ? .
            if recid(oa_det) = -1 then .
        end.*/

        /*现有库存不足安全库存,*/
        if v_qty_need > 0 then do:
            /*首笔需求在时界点之外,则修改供给直到满足安全库存需要*/
            if t1_date > today + timefence  then do:
                for each temp2 where t2_site = t1_site and t2_part = t1_part and t2_qty_ord > 0 break by t2_site by t2_part by t2_date:
                    if v_qty_need = 0 then leave .

                    if v_qty_need >= t2_qty_ord then do:
                        v_qty_need = v_qty_need - t2_qty_ord .
                        t2_qty_ord = 0 .
                    end.
                    else do:
                        t2_qty_ord = t2_qty_ord - v_qty_need .

                        /*所有修改供给的地方都要产生oa_det. *oa_det会被标准MRP开始时删除**
                        create oa_det.
                        assign
                        oa_detail  = "加工单"
                        oa_part    = t2_part
                        oa_nbr     = t2_nbr
                        oa_site    = t2_site
                        oa_line    = t2_lot
                        oa_code    = 1010
                        oa_qty     = t2_qty_ord
                        oa_fr_date = today + timefence
                        oa_to_date = wo_due_date.
                        if recid(oa_det) = -1 then .*/

                        v_qty_need = 0 .
                    end.
                end. /*for each temp2*/
                /*现有工单调整duedate,仍不满足安全库存的,新产生工单*/
                if v_qty_need > 0 then do:
                    find first temp3 where t3_site = t1_site and t3_part = t1_part and t3_date = today no-error.
                    if not avail temp3 then do:
                        create temp3.
                        assign t3_site = t1_site 
                               t3_part = t1_part
                               t3_date = today
                               t3_qty_ord = v_qty_need 
                               .
                    end.
                    else t3_qty_ord = v_qty_need + t3_qty_ord .
                    v_qty_need = 0 .
                end.
                v_qty_avail = 0 .
            end. /*if t1_date > today + */
            else do:
                t1_qty_ord  = t1_qty_ord + v_qty_need .
                v_qty_avail = 0 .
                v_qty_need  = 0 .
            end.

        end. /*if v_qty_need > 0 */

    end. /*if first-of(t1_part)*/
/*
for each temp3:
message "test003.line" 
t3_site
t3_part
t3_date
t3_qty_ord
view-as alert-box .
end.
*/
    if v_qty_avail > 0 then do:  /*满足安全库存和前面日期的需求后,有剩余库存*/
        if t1_qty_ord > v_qty_avail then do:
            t1_qty_ord  = t1_qty_ord - v_qty_avail .
            v_qty_avail = 0.
        end.
        else do:
            t1_qty_ord = 0 .
            v_qty_avail = v_qty_avail - t1_qty_ord .
        end.
    end. /*if v_qty_avail > 0*/

    if t1_qty_ord > 0 then do: 
        for each temp2 where t2_site = t1_site and t2_part = t1_part and t2_qty_ord > 0 break by t2_site by t2_part by t2_date:
            if t1_qty_ord = 0 then leave .

            if t1_qty_ord >= t2_qty_ord then do:
                t1_qty_ord = t1_qty_ord - t2_qty_ord .
                t2_qty_ord = 0 .
            end.
            else do:
                t2_qty_ord = t2_qty_ord - t1_qty_ord .
                t1_qty_ord = 0 .
            end.
        end. /*for each temp2*/
        /*现有工单调整duedate,仍不满足此日期需求的,新产生工单*/
        if t1_qty_ord > 0 then do:
            find first temp3 where t3_site = t1_site and t3_part = t1_part and t3_date = t1_date no-error.
            if not avail temp3 then do:
                create temp3.
                assign t3_site = t1_site 
                       t3_part = t1_part
                       t3_date = t1_date
                       t3_qty_ord = t1_qty_ord 
                       .
            end.
            else t3_qty_ord = t1_qty_ord + t3_qty_ord .
            t1_qty_ord = 0 .
        end.
    end. /*if t1_qty_ord > 0*/

end. /*for each temp1*/

/*
for each temp3:
message "test003" 
t3_site
t3_part
t3_date
t3_qty_ord
view-as alert-box .
end.
*/

for each temp3 break by t3_site by t3_part by t3_date :
    /*产生"F"状态的WO*/
    {gprun.i ""xxwowomtxp.p"" "(input t3_site, input t3_part , input t3_date , input t3_qty_ord , output v_undo)" }
end. /*for each temp3*/



/*写入对应的MRP需求,供查询23.17*/
define variable mrp_recno as recid. /*from mfdeclre.i*/
define variable next_seq  as  integer format ">>>>>>>>" no-undo.   /*from mfdeclre.i*/
for each pln_det :
    {xxmfmrwxp.i 
        "cs sch_mstr"  pln_part  pln_nbr string(pln_line) string(pln_date) 
        ?   pln_date  pln_qty_ord
        "DEMAND" CUSTOMER_SCHEDULES_SALES_ORDER pln_site 
    }
end.  /*for each pln_det*/




/*
message "test004 :sp-mrp 运行完成,跳过mrp" view-as alert-box .
leave .
*/

/*end: 产生wo_mstr wo_status = "F" **************************************************/

/*SS - 090616.1 - E*  befor mrp cal , cal myself mrp ************************************************/


/* Initinalized vars on AppServer */

if apps_threads > 0 then do:

   for each tt_threads no-lock:

       {gprun.i ""gpmpup02.p""
             "(frwrd, bck, horizon, reldays, drp, mrp, ms, non_ms, buyer,
               vendor, pm_code, prod_line, ptgroup, part_type,
           tt_threads.tt_thread)"
             "on tt_thread_handle"}
   end.
end.

if batchrun
then
   audit = no.

assign
   start_time = integer(time)
   start_date = today.

if audit
then do:

   output stream audit to terminal.

   display stream audit
      string(start_date[1]) + " " +
      string(start_time[1],"HH:MM:SS AM") @ started
   with frame audit.
end.  /* IF audit */

if lowlevel
   and (can-find (first in_mstr where in_level = 99999)
   or  can-find (first in_mstr where in_level = 88888))
then do:

   /* Update low-level codes (in_mstr.in_level) */
   {gprun.i ""gpmpupa.p"" "(sync_code)"}

   /* VALUE OF FOURTH PARAMETER CHANGED FROM {&gpmpup_p_7} */
   /* TO getTermLabel("LOW_LEVEL_CODE_UPDATE",23)          */

   {gpmplog.i
      &item-count = """"
      &site-code = """"
      &item-code = """"
      &log-description = getTermLabel(""LOW_LEVEL_CODE_UPDATE"",23)
      &level = """"
      &part-orders = """"
      &tot-orders = """"
      }

end.  /* IF lowlevel AND ... */

if mrp_req = no
   and (sync_calc or sync_code <> "")
then do:

   /* Synchronized regeneration calculation
   -- update mrp required flags (in_mstr.in_mrp) */
   {gprun.i ""gpmpupb.p"" "(sync_code)"}

   /* VALUE OF FOURTH PARAMETER CHANGED FROM {&gpmpup_p_10} */
   /* TO getTermLabel("UPDATE_MRP/DRP_FLAGS",23)           */

   {gpmplog.i
      &item-count = """"
      &site-code = """"
      &item-code = """"
      &log-description = getTermLabel(""UPDATE_MRP/DRP_FLAGS"",23)
      &level = """"
      &part-orders = """"
      &tot-orders = """"
      }

   /* Make the calculation now behave like a net change */
   mrp_req = yes.
end.  /* IF mrp_req = NO ... */

/* LOOP THROUGH ALL PARTS NETTING SUPPLY AGAINST DEMAND */
max_level = 0.
for last in_mstr
   fields (in_level in_mrp in_part in_site)
   where in_level >= -99999999 and in_mrp >= no
   and in_part >= "" and in_site >= ""
   use-index in_level no-lock
   query-tuning(no-index-hint hint "INDEX_DESC(T0 IN_MSTR##IN_LEVEL)"):
end. /* FOR LAST in_mstr */

if available in_mstr
then
   max_level = in_level.

min_level = 0.
for first in_mstr
   fields (in_level in_mrp in_part in_site)
   where in_level >= -99999999 and in_mrp >= no
     and in_part  >= "" and in_site >= ""

   use-index in_level no-lock:
end. /* FOR FIRST in_mstr */

if available in_mstr
then
   min_level = in_level.

assign
   prev_part  = part1
   prev_level = min_level.

mainloop:
do low_level = min_level to max_level
      on error undo, retry:

   if retry then .

   if prev_level <> low_level
   then
      assign
         prev_part = part1
         prev_level = low_level
         last-rowid = ?.

   if not can-find (first in_mstr where in_level = low_level)
   then do:

      for first in_mstr
         fields(in_level)
      no-lock where in_level > low_level:
      end. /* FOR FIRST in_mstr */

      if available in_mstr
      then
         low_level = in_level.
      else
         leave.
   end. /* IF NOT CAN-FIND( FIRST in_mstr ... */

   /***********************************************************
   Multi-threaded calculation coordination logic -- qad_wkfl is
   used to register this calculation's activity so that other
   synchronized calculations can react in an appropriate and
   consistent manner.
   ***********************************************************/
   do transaction:

      find first qad_wkfl exclusive-lock
         where qad_key3 = qadmrpkey and qad_key4 = mfguser no-error.

      if not available qad_wkfl
      then
         find qad_wkfl exclusive-lock
            where qad_key1 = qadmrpkey
              and qad_key2 = mfguser + dblcol + qadmrpkey no-error.

      if not available qad_wkfl
      then do:

         create qad_wkfl.
         assign
            qad_key1 = qadmrpkey
            qad_key2 = mfguser + dblcol + qadmrpkey
            qad_key3 = qadmrpkey
            qad_key4 = mfguser
            qad_key5 = qadmrpkey + sync_code
            qad_key6 = string(low_level).

         if recid(qad_wkfl) = -1 then.

      end. /* IF NOT AVAILABLE qad_wkfl */
      else
         qad_key6 = string(low_level).

      assign
         qad_charfld[1] = global_userid
         qad_datefld[1] = today
         qad_decfld[1] = time.
   end. /* DO TRANSACATION */

   define query q_in_mstr for in_mstr
      fields(in_mrp in_level in_part in_site) SCROLLING.

   if mrp_req = no
   then
      open query q_in_mstr
      for each in_mstr
         no-lock use-index in_level
         where in_level = low_level
           and (in_part >= part1 and in_part <= part2)
           and (in_site >= site1 and in_site <= site2).
   else
      open query q_in_mstr
      for each in_mstr
         no-lock use-index in_level
         where in_level = low_level
           and in_mrp = yes
           and (in_part >= prev_part and in_part <= part2)
           and (in_site >= site1 and in_site <= site2).

   if mrp_req = no and last-rowid <> ? then
      reposition q_in_mstr to rowid last-rowid.


   hide message no-pause.

   /* Reset Queue Depth to 4 */
   assign n_items_proc = 0
          queue-depth = 4
          temp-table-depth = 1
          open-date = today
          open-time = time.

   /*Current/maximum level: */
   {pxmsg.i &MSGNUM=1106 &ERRORLEVEL=1
            &MSGARG1="string(low_level) + ' / ' + string(max_level)"}


   blocka:
   repeat:

      assign n_items_proc = n_items_proc + 1.

      get next q_in_mstr no-lock.

      if not available in_mstr
      then
         leave blocka.


      if n_items_proc > 10000
      then do:
         assign elapsed = (today - open-date) * 86400 + time - open-time.

         if elapsed > 900
         then do:
            if in_part <> prev_part then do:
               assign last-rowid = rowid(in_mstr).
               undo mainloop, retry mainloop.
            end.
         end.
         else assign n_items_proc = 0.
      end.

      assign
         prev_part  = in_part
         prev_level = low_level
         part = in_part
         site = in_site
         last_part = in_part
         last_site = in_site
         qadkey2 = dblcol + part + dblcol + site + dblcol
         in_recid = recid(in_mstr)
         last_flag = in_mrp.


      if apps_threads = 0 then do:
         /**********************************************************
         Look in the qad_wkfl table for possible conflicts with
         other calculations and if not a conflict, register the item
         and site and low-level code this calculation is processing
         to give the appropriate visibility to other calculations.
         ***********************************************************/
         multi-thread:
         do transaction:

            find first qad_wkfl exclusive-lock
               where qad_key3 = qadmrpkey
                 and qad_key4 = mfguser no-error.

            assign
               qad_charfld[1] = global_userid
               qad_datefld[1] = today
               qad_decfld[1] = time
               qad_key2 = qadkey2 no-error.

            if not error-status:error
            then
               validate qad_wkfl no-error.

            if error-status:error
            then
               CASE error-status:get-number(1):
                  when (1443) /*Duplicate unique key in db table*/ or
                  when (1502) /*same as error 1443, for 8.2C+*/ or
                  when (132)  /*table already exists with key*/
                  then undo, next blocka.
                  otherwise do:
                     message error-status:get-message(1) view-as alert-box.
                     undo, next blocka.
                  end. /* OTHERWISE DO */
               end. /* CASE */

            if mrp_req = yes
            then do:
               if not can-find
                  (in_mstr where in_mstr.in_level = low_level
                  and in_mstr.in_mrp   = yes
                  and in_mstr.in_part  = part
                  and in_mstr.in_site  = site)
                  then undo, next blocka.
            end. /* IF mrp_req = yes THEN DO */
         end. /* DO TRANSACTION */

         repeat:

            for first qadwkfl
               fields (qad_charfld qad_datefld qad_decfld qad_key1
                       qad_key2 qad_key3 qad_key4 qad_key5 qad_key6)
               no-lock
               where qadwkfl.qad_key5 = qadmrpkey + sync_code
                 and integer(qadwkfl.qad_key6) < in_level:
            end. /* FOR FIRST qadwkfl */

            if not available qadwkfl
            then
               leave.

            if dbtype("qaddb") = "PROGRESS"
            then do:

               qad-recno = recid(qadwkfl).

               find qadwkfl exclusive-lock
               where recid(qadwkfl) = qad-recno
               no-wait no-error.

               if available qadwkfl
               then do:
                  delete qadwkfl.
                  next.
               end. /* IF AVAILABLE qadwkfl   */
            end.  /* IF DBTYPE("qaddb") = ... */

            hide message no-pause.
            /*Waiting for synchronized calculation to reach level*/
            {pxmsg.i &MSGNUM=972 &ERRORLEVEL=1
               &MSGARG1="string(low_level) + '.'"}

            repeat:
               pause 2 no-message.
               leave.
            end. /* REPEAT */

            /*Current/maximum level: */
            {pxmsg.i &MSGNUM=1106 &ERRORLEVEL=1
                  &MSGARG1="string(low_level) + ' / ' + string(max_level)"}

         end.


         create tt_rep.
         assign tt_rep.tt_part = in_part
                tt_rep.tt_site = in_site.

         {gprunp.i "mrppl" "p" "gpmpup01"
                              "(input tt_part, input tt_site,
                input-output increment,
                                output tt_orders, output tt_time,
                                output tt_desc)"}

         assign req-tot = req-tot + 1
        mrppl-tot = mrppl-tot + 1
                part_orders = tt_rep.tt_orders
                numorders = numorders + part_orders.

         if oracle-db and mrppl-tot > max-requests then do:
        {gpdelp.i "mrppl" "p"}
        assign mrppl-tot = 0.
         end.

         if audit and time <> last-time then
            run disptot.
      end.
      else do:

         create tt_req_sub.

         assign tt_req_sub.tt_part = in_part
                tt_req_sub.tt_site = in_site
                tt_req_sub.tt_inc = increment
                req-sub-count = req-sub-count + 1.

         /* Could not pass the standards checker with out this */
         /* Even if it is a temp table */

         if recid(tt_req_sub) = -1 then .

         if req-sub-count < temp-table-depth then next blocka.

         {mtrun.i &data=in_part &info=in_site}
         {gprun.i ""gpmpup04.p""
             "(input-output table tt_req_sub)"
             "on tt_thread_handle asynchronous set tt_request_handle
              event-procedure 'mtthreadisdone'"}

         empty temp-table tt_req_sub.
         assign tt_num_requests = tt_num_requests + req-sub-count
        req-sub-count = 0.

         if oracle-db and
        can-find(first tt_threads where tt_num_requests > max-requests)
        then do:

            {mtwait.i}
        run delproc.

            for each tt_threads exclusive-lock:

               {gprun.i ""gpmpup02.p""
                "(frwrd, bck, horizon, reldays, drp, mrp, ms, non_ms, buyer,
                  vendor, pm_code, prod_line, ptgroup, part_type,
              tt_threads.tt_thread)"
                "on tt_thread_handle"}

            assign tt_num_requests = 0.
            end.
         end.

      end.

   end. /* REPEAT */

   find first tt_req_sub no-lock no-error.

   if available(tt_req_sub) then do:

         {mtrun.i &data=tt_req_sub.tt_part &info=tt_req_sub.tt_site}
         {gprun.i ""gpmpup04.p""
             "(input-output table tt_req_sub)"
             "on tt_thread_handle asynchronous set tt_request_handle
              event-procedure 'mtthreadisdone'"}

         empty temp-table tt_req_sub.
         assign tt_num_requests = tt_num_requests + req-sub-count
                req-sub-count = 0.

   end.
   {mtwait.i}
   run writereport.

end. /* DO low_level = min_level TO max_level */

hide message no-pause.

/* Delete the qad_wkfl record used by this calculation to
register its calculation activity */
do transaction:
   find first qad_wkfl exclusive-lock
      where qad_wkfl.qad_key3 = qadmrpkey
        and qad_wkfl.qad_key4 = mfguser no-error.
   if available qad_wkfl
   then
      delete qad_wkfl.
end.  /* DO TRANSACATION */

assign elapsed = (today - start_date[1]) * 86400 + time - start_time[1]
       z = req-tot.

display stream log
   string(start_date[1]) + " " +
   string(start_time[1],"HH:MM:SS AM")
   @ started
   z numorders
   string(truncate((elapsed / 3600),0),">>9:")
   + string(truncate(((elapsed -
   truncate((elapsed / 3600),0) * 3600) / 60),0),"99:")
   + string(((elapsed -
   truncate((elapsed / 60),0) * 60)),"99") format "x(9)"
   @ elapsed
   string(today) + " " +
   string(start_time[1] + elapsed,"HH:MM:SS AM")
   @ stopped
with frame log-audit.

if audit
then do with frame audit:
   display stream audit
      string(truncate((elapsed / 3600),0),">>9:")
      + string(truncate(((elapsed -
      truncate((elapsed / 3600),0) * 3600) / 60),0),"99:")
      + string(((elapsed -
      truncate((elapsed / 60),0) * 60)),"99") format "x(9)"
      @ elapsed
      string(today) + " " +
      string(start_time[1] + elapsed,"HH:MM:SS AM")
      @ stopped.
end. /* IF audit THEN DO WITH ... */

output stream audit close.

if apps_threads > 0 then
   run delproc.
else do:
   {gpdelp.i "mrppl" "p"}
end.

{mtclean.i}

/* In case we flipped it internally in this subroutine */
mrp_req = save_mrp_req.

hide frame audit no-pause.


/******************************************************************/

/*   I N T E R N A L    P R O C E D U R E S     */

/******************************************************************/

PROCEDURE mtthreadisdone:

/* Event Procedure for Async AppServer call */

define input parameter table for tt_back.

    find first tt_req where tt_request_handle = self
                        exclusive-lock no-error.
    find first tt_threads where tt_threads.tt_thread = tt_req.tt_thread
                            exclusive-lock no-error.

    assign tt_threads.tt_depth = tt_threads.tt_depth - 1
           tt_isdone = yes.

    if self:error or self:stop then do:
      /*An error occurred with an AppServer request*/
      {pxmsg.i &MSGNUM=5272 &ERRORLEVEL=3}
      return.
    end.

    for each tt_back:
        assign increment = max(tt_inc,increment)
               req-tot = req-tot + 1
               part_orders = tt_back.tt_orders
               numorders = numorders + part_orders.

        create tt_rep.
        assign tt_rep.tt_part = tt_back.tt_part
               tt_rep.tt_site = tt_back.tt_site
               tt_rep.tt_desc = tt_back.tt_desc
               tt_rep.tt_order = tt_back.tt_orders
               tt_rep.tt_time = tt_back.tt_etime.

    end.

    if audit and time <> last-time then
       run disptot.

empty temp-table tt_back.

END PROCEDURE.


PROCEDURE writereport:

/* Procedure that writes the report after each level */

define variable tot-parts as integer no-undo.
define variable tot-planned as integer no-undo.

   for each tt_rep no-lock:

       assign item-count = item-count + 1
              tot-parts = tot-parts + 1
              tot-planned = tot-planned + tt_orders.

       display stream log
          item-count @ z1
          tt_site @ in_mstr.in_site
          tt_part @ pt_mstr.pt_part
          tt_desc @ pt_mstr.pt_desc1 format "x(22)"
          low_level @ in_mstr.in_level
          tt_orders @ part_orders
          tt_time @ elapsed
          with frame log down no-attr-space width 132.

       if page-size(log) - line-counter(log) = 0 then page stream log.
       else down stream log 1 with frame log.


   end.

   display stream log
         "(" + string(tot-parts) + ")" @ in_mstr.in_site
         "*** " + caps(getTermLabel("SUBTOTAL",10)) + " ***" @ pt_mstr.pt_part
         tot-planned @ pt_mstr.pt_desc1
         low_level @ in_mstr.in_level

         string(truncate ((elapsed / 3600),0),">>9:")
         + string(truncate (((elapsed -
         truncate
         ((elapsed / 3600),0) * 3600) / 60),0),"99:")
         + string(((elapsed -
         truncate ((elapsed / 60),0) * 60)),"99")
         format "x(9)" @ elapsed
         with frame log no-attr-space.

   if page-size(log) - line-counter(log) = 0 then page stream log.
      else down stream log 1 with frame log.


   empty temp-table tt_rep.
END PROCEDURE.


PROCEDURE disptot:

/* Procedure that displays the status on the screen */

   if audit = no then return.

   assign last-time = time
          elapsed = (today - start_date[1]) * 86400 + time - start_time[1].

   display stream audit
          req-tot @ z
          numorders @ numorders
          string(truncate ((elapsed / 3600),0),">>9:")
          + string(truncate (((elapsed -
          truncate ((elapsed / 3600),0) * 3600) / 60),0),"99:")
          + string(((elapsed -
          truncate ((elapsed / 60),0) * 60)),"99") format "x(9)"
          @ elapsed
       with frame audit width 80 no-attr-space.


END PROCEDURE.


PROCEDURE delproc:

/* This procedure runs gpmpup03.p on the AppServer to delete the persistent */
/* procedure mrppl.p */

   for each tt_threads exclusive-lock:
      {gprun.i ""gpmpup03.p"" "on tt_thread_handle"}
   end.


END PROCEDURE.
