/* mrppl.p - MRP/DRP Persistent Procedure Library                       */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*                                                                      */
/* This procedure combines a number of the main MRP/DRP procedures that */
/* were taking up the most time to run into one persistent procedure    */
/* that can be run on an AppServer.                                     */
/*                                                                      */
/* The following procedures are now in here (mrmpup01.p , mrmpup02.p    */
/* mrmpup03.p, mrmpupc.p, mrmpupa.p, mrmpupb.p) and mrfsup.p & mrsfupa.p*/
/* have been rewritten into mrfsup1                                     */
/*                                                                      */
/* mrmpup02.p & mrmpup03.p have not been obsoleted because of the APO   */
/* API.                                                                 */
/*                                                                      */
/* Revision: 1.3    BY: Tony Brooks        DATE: 10/09/02   ECO: *P0JR* */
/* Revision: 1.5    BY: Paul Donnelly (SB) DATE: 06/28/03   ECO: *Q00J* */
/* Revision: 1.6    BY: Patrick de Jong    DATE: 08/13/03   ECO: *Q022* */
/* Revision: 1.7    BY: Ed van de Gevel    DATE: 09/16/03   ECO: *Q03G* */
/* Revision: 1.8    BY: Salil Pradhan      DATE: 03/12/04   ECO: *P1T5* */
/* Revision: 1.9    BY: Ajay Nair          DATE: 03/12/04   ECO: *P1T3* */
/* Revision: 1.10   BY: Ajay Nair          DATE: 12/17/04   ECO: *P30D* */
/* Revision: 1.10.1.3  BY: Somesh Jeswani  DATE: 05/31/05   ECO: *Q0JN* */
/* Revision: 1.10.1.4   BY: Kirti Desai    DATE: 10/19/05   ECO: *P45C* */
/* Revision: 1.10.1.5   BY: Shridhar Mangalore   DATE: 11/23/05   ECO: *P490* */
/* $Revision: 1.10.1.6 $  BY: Ajay Nair          DATE: 11/29/05   ECO: *P49W* */
/* By: Neil Gao Date: 20071105 ECO: * ss 20071105 * */
/* By: Neil Gao Date: 20071120 ECO: * ss 20071120 * */

/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=NoConvert                                              */

{mfdeclre.i}
{gplabel.i}
{pxmaint.i}
{gpmpvar2.i shared}

define new shared variable part         as character.
define new shared variable site         as character.
define new shared variable increment    as integer.
define new shared variable wo_recid     as recid.
define new shared variable comp         as character.
define new shared variable numorders    as integer format "->>>,>>>,>>>".
define new shared variable pt_recid     as recid no-undo.
define new shared variable in_recid     as recid.
define new shared variable use-op-yield as logical no-undo.

define new shared temp-table tt-routing-yields no-undo
   field tt-op         like ro_op
   field tt-start      like ro_start
   field tt-end        like ro_end
   field tt-yield-pct  like ro_yield_pct
   index tt-op is unique primary
   tt-op
   tt-start.

define shared variable bck           like soc_fcst_bck.
define shared variable mrfsup1_frwrd like soc_fcst_fwd no-undo.
define shared variable horizon       as integer no-undo.
define shared variable reldays       like mrpc_reldays.

define shared buffer in_mstr for in_mstr.
define shared buffer pt_mstr for pt_mstr.
define shared buffer ptp_det for ptp_det.

define new shared buffer gl_ctrl for gl_ctrl.

/* Variables from mrmpup01.p*/
define new shared variable plan_qty       like mrp_qty
                                          extent 1000 no-undo.
define new shared variable plan_date      like mrp_due_date
                                          extent 1000 no-undo.
define new shared variable plan_yield_pct like wo_yield_pct
                                          extent 1000 no-undo.
define variable safety_insp as integer no-undo.
define variable planned     as integer no-undo.
define variable timefence   like pt_timefence no-undo.
define variable leadtime    like pt_mfg_lead no-undo.
define variable yield_pct   like pt_yield_pct no-undo.

/* ss 20071106 - b */
define new shared variable plan_nbr       like mrp_nbr extent 1000 no-undo.
define new shared variable plan_line      like mrp_line extent 1000 no-undo.
/* ss 20071106 - e */

/* ss 20071112 - b */
define var inqty like in_qty_oh.
define buffer xxwomstr for wo_mstr.
define var xxsonbr like so_nbr.
define var ifwoavail as logical.
/* ss 20071112 - e */

{mfdatev.i}

/* Variables from mrmpup02.p*/
define new shared variable dsd_recno as recid.
define new shared variable del-yn    like mfc_logical.
define temp-table dsr-req-nbr no-undo
   field dsr-req-nbr as character
   index dsr-req-nbr is unique primary
   dsr-req-nbr ascending.

define buffer supply  for mrp_det.
define buffer scrap   for mrp_det.
define buffer womstr  for wo_mstr.
define buffer dsrmstr for dsr_mstr.

define query q-supply for supply.

define variable supplier_perf_enabled like mfc_logical initial no no-undo.
define variable wovar                 like woc_var                no-undo.

/* Variables from mrmpupc.p */
define new shared variable fcsduedate as date.

/*Variables from mrfsup.p*/
define new shared variable grs like fcs_fcst_qty extent 156 no-undo.
define new shared variable net like fcs_fcst_qty extent 156 no-undo.

/*Variables from mrmpup03.p */
define new shared variable dsd_db    like si_db.
define new shared variable undo-all  like mfc_logical.

/* mrfsup1 */
define temp-table tt-fcs no-undo
   field fcs_year as integer
   field fcs_week as integer
   field fcs_gross as decimal
   field fcs_net as decimal
   field fcs_week_idx as integer
   index main fcs_week_idx
   index yearweek fcs_year fcs_week.

define buffer b-tt-fcs for tt-fcs.

&SCOPED-DEFINE PT_MSTR_FIELDS pt_abc pt_avg_int pt_bom_code pt_buyer ~
pt_cyc_int pt_desc1 pt_group pt_insp_lead pt_insp_rqd pt_joint_type ~
pt_ord_min pt_part pt_prod_line pt_loc pt_mfg_lead pt_mstr.pt_ms ~
pt_network pt_ord_max pt_ord_mult pt_ord_per pt_ord_pol pt_ord_qty ~
pt_part_type pt_phantom pt_plan_ord pt_mstr.pt_pm_code pt_pur_lead ~
pt_routing pt_sfty_stk pt_sfty_time pt_rctwo_status pt_rctwo_active ~
pt_timefence pt_vend pt_yield_pct pt_status pt_op_yield

&SCOPED-DEFINE PTP_DET_FIELDS ptp_bom_code ptp_buyer ptp_ins_lead ptp_ins_rqd ~
ptp_joint_type ptp_mfg_lead ptp_ms ptp_network ~
ptp_ord_max ptp_ord_min ptp_ord_mult ptp_ord_per ~
ptp_ord_pol ptp_ord_qty ptp_part ptp_phantom ~
ptp_plan_ord ptp_pm_code ptp_pur_lead ptp_routing ~
ptp_sfty_stk ptp_sfty_tme ptp_site ptp_timefnce ~
ptp_vend ptp_yld_pct ptp_op_yield

define temp-table tt_pk_det no-undo
   field pk_part      like pk_part
   field pk_reference like pk_reference
   field pk_start     like pk_start
   field pk_end       like pk_end
   field pk_lot       like pk_lot
   field pk_qty       like pk_qty
   field pk_batch_qty as decimal
   field pk_user1     like pk_user1
   field pk_loc       like pk_loc
   index main pk_part pk_reference pk_start pk_end.

define temp-table tt-cnt no-undo
   field tt-dom  like sod_domain
   field tt-nbr  like sod_nbr
   field tt-line like sod_line
   field tt-part like sod_part
   field tt-qty  like sod_qty_ord
   index tt-nbr tt-nbr tt-line .

for first gl_ctrl
 where gl_ctrl.gl_domain = global_domain no-lock:
end.

/* CHECK TO SEE IF SUPPLIER PERFORMANCE IS INSTALLED */

if can-find (first mfc_ctrl
    where mfc_ctrl.mfc_domain = global_domain and  mfc_field  =
    "enable_supplier_perf"
   and mfc_module = "ADG"
   and mfc_logical = yes)
then
   supplier_perf_enabled = yes.

for first woc_ctrl
   fields( woc_domain woc_var)  where woc_ctrl.woc_domain = global_domain
   no-lock:
   assign wovar = woc_var.
end. /* for first woc_ctrl */

PROCEDURE mrmpup01:
/* mrmpup01.p - MRP PROCESSOR NETTING LOGIC SUBROUTINE                  */

   define variable qavail as decimal no-undo.
   define variable needed as date no-undo.
   define variable more_demand like mfc_logical initial yes no-undo.
   define variable more_supply like mfc_logical initial yes no-undo.

   define variable i as integer no-undo.

   define variable inc as character format "x(8)" no-undo.
   define variable week as integer no-undo.

   define variable mrpdet_recno as recid no-undo.

   define buffer demand for mrp_det.
   define buffer supply for mrp_det.
   define buffer scrap for mrp_det.

/* ss 20071106 - b */
		define variable plannbr like mrp_nbr.
		define variable planline like mrp_line.
/* ss 20071106 - e */

   define variable wdays as integer no-undo.

   define variable sfty_stk  like pt_sfty_stk no-undo.
   define variable sfty_time like pt_sfty_time no-undo.
   define variable insp_rqd  like pt_insp_rqd  no-undo.
   define variable pm_code   like pt_pm_code   no-undo.
   define variable insp_lead like pt_insp_lead no-undo.
   define variable ord_pol   like pt_ord_pol   no-undo.
   define variable ord_qty   like pt_ord_qty   no-undo.
   define variable ord_min   like pt_ord_min   no-undo.
   define variable ord_per   like pt_ord_per   no-undo.
   define variable ord_mult  like pt_ord_mult  no-undo.
   define variable mfg_lead  like pt_mfg_lead  no-undo.
   define variable pur_lead  like pt_pur_lead  no-undo.

   define variable routing   like pt_routing   no-undo.
   define variable site      like in_site      no-undo.

   define variable bom_code  like ptp_bom_code no-undo.

   define variable joint_type as character no-undo.

   define variable co-product as character initial "1" no-undo.
   define variable by-product as character initial "2" no-undo.
   define variable base-process as character initial "5" no-undo.

   define variable mrp_ord_max as integer initial 1000 no-undo.

   define variable temp_date as date no-undo.
   define variable fwd_bck as integer no-undo.

   define variable first_workday as date no-undo.

   assign
      plan_qty = 0
      plan_date = ?
      plan_yield_pct = 0
      planned = 0
/* ss 20071106 - b */
			plan_nbr = ""
			plan_line = ""
/* ss 20071106 - e */
      fcsduedate = ?.

   if not available in_mstr then leave.
   site = in_site.

   if not available pt_mstr then leave.
   part = pt_part.

   {fcsdate.i today fcsduedate week site}
   fcsduedate = fcsduedate - 7 * bck.

   first_workday = today.
   fwd_bck = 1.      /* MOVE FORWARD, IF NECESSARY */
   {mfhdate.i first_workday fwd_bck site}

   if available ptp_det then do:
      assign
         joint_type = ptp_joint_type
         bom_code   = ptp_bom_code
         routing    = ptp_routing
         sfty_stk   = ptp_sfty_stk
         sfty_time  = ptp_sfty_tme
         insp_rqd   = ptp_ins_rqd
         pm_code    = ptp_pm_code
         insp_lead  = ptp_ins_lead
         ord_pol    = ptp_ord_pol
         yield_pct  = ptp_yld_pct
         timefence  = ptp_timefnce
         ord_qty    = ptp_ord_qty
         ord_min    = ptp_ord_min
         ord_per    = ptp_ord_per
         ord_mult   = ptp_ord_mult
         mfg_lead   = ptp_mfg_lead
         pur_lead   = ptp_pur_lead.
   end.
   else do:
      assign
         joint_type = pt_joint_type
         bom_code   = pt_bom_code
         routing    = pt_routing
         sfty_stk   = pt_sfty_stk
         sfty_time  = pt_sfty_time
         insp_rqd   = pt_insp_rqd
         pm_code    = pt_pm_code
         insp_lead  = pt_insp_lead
         ord_pol    = pt_ord_pol
         yield_pct  = pt_yield_pct
         timefence  = pt_timefence
         ord_qty    = pt_ord_qty
         ord_min    = pt_ord_min
         ord_per    = pt_ord_per
         ord_mult   = pt_ord_mult
         mfg_lead   = pt_mfg_lead
         pur_lead   = pt_pur_lead.
   end.

   if lookup(ord_pol,"OTO,FOQ,POQ,LFL") = 0 then ord_pol = "LFL".

   if joint_type = co-product then do:
      {gprun.i ""mrmpup1a.p"" "(bom_code,site,output joint_type)"}
   end.

   assign
      needed = today
/* ss 20071106 - b */
/*
      qavail = in_qty_oh - sfty_stk
*/		
      qavail = in_qty_oh - sfty_stk
			inqty = in_qty_oh 
/* ss 20071106 - e */
      timefence = max(timefence,0)
      safety_insp = sfty_time.

/* ss 20071106 */ assign plannbr = "" planline = "".

   if insp_rqd and pm_code = "P"
   then
      safety_insp = safety_insp + insp_lead.

   leadtime = mfg_lead.
   if pm_code = "P" then leadtime = pur_lead.
   if leadtime = ? then leadtime = 0.

   /* Re-establish initial jp_det demand for base process items */
   if joint_type = base-process then do:
      qavail = 0.

      {gprun.i ""mrjpup1b.p""
         "(part,site,0,low_date,leadtime,pm_code,safety_insp,
           ord_pol,ord_per,ord_qty,fcsduedate)"}
   end.

   if qavail < 0 then do transaction:
      create oa_det. oa_det.oa_domain = global_domain.
      assign
         oa_part    = part
         oa_site    = site
         oa_code    = 1001
         oa_qty     = qavail
         oa_to_date = today.

      if in_qty_oh < 0 then do:

         assign
            oa_code = 1000
            oa_qty  = in_qty_oh.
      end.

      release oa_det.
   end.

   /* Aggregate and net past due demand to today for initial qavail     */
   if (ord_pol = "FOQ" or ord_pol = "LFL" or ord_pol = "POQ")
      and joint_type <> base-process
   then do:

      for each demand
         fields( mrp_domain mrp_dataset mrp_detail mrp_due_date
                mrp_line mrp_line2 mrp_nbr mrp_part
                mrp_qty mrp_site mrp_type) no-lock
          where demand.mrp_domain = global_domain and  demand.mrp_part = part
           and demand.mrp_site = site
           and demand.mrp_type = "DEMAND"
           and demand.mrp_dataset <> "wo_scrap"
           and  demand.mrp_due_date <  today
         use-index mrp_sitetype:

         qavail = qavail - demand.mrp_qty.
         
/* ss 20071106 - b */
				 assign plannbr = demand.mrp_nbr
				 				planline = demand.mrp_line.
/* ss 20071106 - e */

         if demand.mrp_dataset = "sod_det"
            and (pm_code = "C"
            or can-find (first sob_det  where sob_det.sob_domain =
            global_domain and (  sob_nbr = demand.mrp_nbr
            and sob_line = integer(demand.mrp_line))))
         then do:
            if can-find (first supply
                where supply.mrp_domain = global_domain and (
                supply.mrp_dataset = "sod_fas"
               and supply.mrp_part = demand.mrp_part
               and supply.mrp_nbr = demand.mrp_nbr
               and supply.mrp_line = demand.mrp_line
               and supply.mrp_line2 = ""))
               or can-find (first supply
                where supply.mrp_domain = global_domain and  supply.mrp_dataset
                = "wo_mstr"
               and supply.mrp_part = demand.mrp_part
               and supply.mrp_nbr  = demand.mrp_nbr
               + "." + demand.mrp_line)
            then
               qavail = qavail + demand.mrp_qty.
         end.

      end.

   end.

/*SS 20080410 - B*/
		for each wod_det where wod_domain = global_domain
			and wod_part = part no-lock,
			each wo_mstr where wo_domain = global_domain and wo_nbr = wod_nbr 
				and wo_lot = wod_lot and wo_status = "F" no-lock,
			each so_mstr where so_domain = global_domain and so_nbr = substring(wo_nbr,1,8) no-lock:
			for each demand 
				where demand.mrp_domain = global_domain and  demand.mrp_part = part
				and demand.mrp_site = site
      	and demand.mrp_type = "DEMAND"
      	and demand.mrp_dataset = "wod_det"
      	and demand.mrp_nbr = wod_nbr
      	and demand.mrp_line = wod_lot
      	and demand.mrp_due_date >= today :
      	demand.mrp_user1 = string(so_ord_date).
      end.
		end.
/*SS 20080410 - E*/

   define query demand_query for demand.
   open query demand_query
      for each demand no-lock
       where demand.mrp_domain = global_domain and  demand.mrp_part = part
      and demand.mrp_site = site
      and demand.mrp_type = "DEMAND"
      and demand.mrp_dataset <> "wo_scrap"
      and demand.mrp_due_date >= today
/*SS 20080410 - B*/
/*
      use-index mrp_sitetype query-tuning(cache-size 20 row).
*/
      use-index mrp_user1 query-tuning(cache-size 20 row).
/*SS 20080410 - E*/

   define query supply_query for supply.
   open query supply_query
      for each supply no-lock
       where supply.mrp_domain = global_domain and  supply.mrp_part = part
        and supply.mrp_site = site
        and supply.mrp_type >= "SUPPLY"
        and supply.mrp_type < "SUPPLYP"
      use-index mrp_sitetype query-tuning(cache-size 20 row).

   A-BLOCK:
   repeat while more_demand or more_supply or qavail < 0:
      B-BLOCK:
      do while qavail >= 0 and (more_demand or more_supply):

         if ord_pol = "OTO" and qavail > 0 then more_demand = no.
         if more_demand = no then do:

            get next supply_query.
            do while available supply:

               release wo_mstr.
               if supply.mrp_dataset = "wo_mstr" then

               for first wo_mstr
                  fields( wo_domain wo_joint_type wo_lot wo_nbr wo_type) no-lock
                   where wo_mstr.wo_domain = global_domain and  wo_lot =
                   supply.mrp_line:
               end. /* for first wo_mstr */

               if (supply.mrp_dataset <> "wo_mstr"
                  and supply.mrp_dataset <> "sod_fas")
                  or (supply.mrp_dataset = "wo_mstr"
                  and (not available wo_mstr or wo_type <> "F"
                  or (wo_joint_type = "" and joint_type = ""
                  and wo_type <> "F")
                  or (wo_joint_type <> "" and wo_joint_type <> by-product
                  and joint_type <> "")))
               then do:

                  create oa_det. oa_det.oa_domain = global_domain.
                  assign
                     oa_nbr     = supply.mrp_nbr
                     oa_part    = supply.mrp_part
                     oa_site    = supply.mrp_site
                     oa_line    = string(supply.mrp_line,"x(10)")
                                + supply.mrp_line2
                     oa_code    = 1005  /* cancel */
                     oa_qty     = supply.mrp_qty
                     oa_detail  = supply.mrp_detail
                     oa_fr_date = supply.mrp_due_date
                     oa_to_date = today.

               end.

               release oa_det.

               get next supply_query.

            end.
            more_supply = no.
         end.
         else do:

            get next demand_query.

            do while available demand:
               if demand.mrp_dataset begins "fcs_" then do:
                  if demand.mrp_due_date < fcsduedate then do:

                     get next demand_query.
                     next.
                  end.
               end.
               /* For a base process item, only consider the jp_det     */
               if joint_type <> base-process
                  or (joint_type = base-process
                  and demand.mrp_dataset = "jp_det")
               then do:
                  assign
                     qavail = qavail - demand.mrp_qty
                     needed = max(demand.mrp_due_date,today).

/* ss 20071106 - b */
									/*if part = "test02" then do: message qavail "q5". pause. end.*/
				 					assign plannbr = demand.mrp_nbr
				 						planline =demand.mrp_line.
/* ss 20071106 - e */

                  if demand.mrp_dataset = "sod_det"
                     and (pm_code = "C"
                     or can-find (first sob_det  where sob_det.sob_domain =
                     global_domain and (
                     sob_nbr = demand.mrp_nbr
                     and sob_line = integer(demand.mrp_line))))
                  then do:
                     if can-find (first supply
                         where supply.mrp_domain = global_domain and (
                         supply.mrp_dataset = "sod_fas"
                        and supply.mrp_part = demand.mrp_part
                        and supply.mrp_nbr = demand.mrp_nbr
                        and supply.mrp_line = demand.mrp_line
                        and supply.mrp_line2 = ""))
                        or can-find (first supply
                         where supply.mrp_domain = global_domain and
                         supply.mrp_dataset = "wo_mstr"
                        and supply.mrp_part = demand.mrp_part
                        and supply.mrp_nbr = demand.mrp_nbr
                        + "." + demand.mrp_line)
                     then
                        qavail = qavail + demand.mrp_qty.
                  end.
               end. /* joint_type <> base-process . . . */

               if qavail < 0 then next a-block.

               get next demand_query.
            end.
            more_demand = no.

         end.
      end.

      C-BLOCK:
      do while qavail < 0:
         /* For base processes, supply of the base process is           */
         if more_supply = no or joint_type = base-process then do:

            if needed > today + horizon then do:
               leave a-block.
            end.

            /* For normal items (joint_type = ""), use a planned order  */

            if joint_type = "" then do:
               find next supply no-lock  where supply.mrp_domain =
               global_domain and  supply.mrp_part = part
                  and supply.mrp_site = site
                  and supply.mrp_type = "SUPPLYP"
                  and supply.mrp_dataset = "wo_mstr"
                  and supply.mrp_due_date <= needed
                  use-index mrp_sitetype no-error.

               do while available supply:

                  for first wo_mstr
                     fields( wo_domain wo_joint_type wo_lot wo_nbr wo_type)
                     no-lock
                      where wo_mstr.wo_domain = global_domain and  wo_lot =
                      supply.mrp_line
                     and wo_nbr = supply.mrp_nbr:
                  end. /* for first wo_mstr */

/* ss 20071106 - b */
/*
                  if available wo_mstr and wo_joint_type <> "" then
                     qavail = qavail + supply.mrp_qty.
*/
                  if available wo_mstr and wo_joint_type <> "" then do:
                     qavail = qavail + supply.mrp_qty.
                     /*if part = "test02" then do: message qavail "q7". pause. end.*/
                     plannbr = wo_nbr .
                     planline = wo_line.
                  end.
/* ss 20071106 - e */

                  if qavail >= 0 then next a-block.

                  find next supply no-lock  where supply.mrp_domain =
                  global_domain and  supply.mrp_part = part
                     and supply.mrp_site = site
                     and supply.mrp_type = "SUPPLYP"
                     and supply.mrp_dataset = "wo_mstr"
                     and supply.mrp_due_date <= needed
                     use-index mrp_sitetype no-error.
               end.
            end. /* joint_type = "" */

            if planned >= mrp_ord_max then do:
               create oa_det. oa_det.oa_domain = global_domain.
               assign oa_part = part
                  oa_site = site
                  oa_code = 1015 /* planned order count exceeds max */
                  oa_to_date = needed.
               leave a-block.
            end.

            /* TO CALCULATE PLANNED QUANITITY CORRECTLY */
            /* WHEN YIELD  IS LESS THAN 100%            */

            assign
               planned = planned + 1
               plan_date[planned] = needed
               plan_qty[planned] = max(- qavail,0).

/* ss 20071106 - b */
						assign 
							plan_nbr[planned] = plannbr
							plan_line[planned] = planline.
/* ss 20071106 - e */

            /*Call internal procedure to calculate yield */
            if use-op-yield then
               run ip-get-yield.
            plan_yield_pct[planned] = yield_pct.

            if ord_pol = "FOQ" and ord_qty <> 0 then do:
               if ord_qty >= ord_min then do:
                  /* Use order qty, truncate decimals */
                  plan_qty[planned] = max(plan_qty[planned],ord_qty).
                  if (plan_qty[planned] / ord_qty)
                     - truncate(plan_qty[planned] / ord_qty,0) <> 0
                  then
                     plan_qty[planned] =
                     (truncate (plan_qty[planned] / ord_qty,0) + 1) * ord_qty.
               end.
               else do:
                  /* Use minimum order qty, truncate decimals */
                  plan_qty[planned] = max(plan_qty[planned],ord_min).
                  if (plan_qty[planned] / ord_min)
                     - truncate(plan_qty[planned] / ord_min,0) <> 0
                  then
                     plan_qty[planned] =
                     (truncate (plan_qty[planned] / ord_min,0) + 1) * ord_min.
               end.
            end.

            if ord_pol = "FOQ"
               and yield_pct <> 0 and yield_pct <> 100
            then do:
               qavail = qavail - plan_qty[planned] * (1 - yield_pct * .01).
            end.

            if ord_pol = "OTO" then do:

               assign
                  plan_qty[planned] = 1
                  qavail = 0
                  more_demand = no.
               next a-block.
            end.

            if (qavail + plan_qty[planned]) >= 0
               and joint_type <> base-process
            then do:

               get next demand_query.
               do while available demand:

                  if demand.mrp_dataset begins "fcs_" then do:
                     if demand.mrp_due_date < fcsduedate then do:

                        get next demand_query.

                        next.
                     end.
                  end.
                  qavail = qavail - demand.mrp_qty.

/* ss 20071106 - b */
									/*if part = "test02" then do: message qavail "q9". pause. end.*/
									assign plannbr = demand.mrp_nbr
				 						planline =demand.mrp_line.
/* ss 20071106 - e */

                  if demand.mrp_dataset = "sod_det"
                     and (pm_code = "C" or
                     can-find (first sob_det  where sob_det.sob_domain =
                     global_domain and  sob_nbr = demand.mrp_nbr
                     and sob_line = integer(demand.mrp_line)))
                  then do:
                     if can-find (first supply
                         where supply.mrp_domain = global_domain and (
                         supply.mrp_dataset = "sod_fas"
                        and supply.mrp_part = demand.mrp_part
                        and supply.mrp_nbr = demand.mrp_nbr
                        and supply.mrp_line = demand.mrp_line
                        and supply.mrp_line2 = ""))
                        or can-find (first supply
                         where supply.mrp_domain = global_domain and
                         supply.mrp_dataset = "wo_mstr"
                        and supply.mrp_part = demand.mrp_part
                        and supply.mrp_nbr = demand.mrp_nbr
                        + "." + demand.mrp_line)
                     then
                        qavail = qavail + demand.mrp_qty.
                  end.

                  if ord_pol = "POQ"
                     and demand.mrp_due_date < needed + ord_per
                  then do:
                     /*ACCUMULATE DEMANDS INTO SINGLE PERIOD */
                     plan_qty[planned] = max(- qavail,0).

                  end.
                  else do:
                     needed = max(demand.mrp_due_date,today).
                     leave. /* PROCEED TO NEXT PLANNED ORDER */
                  end.

                  get next demand_query.

               end.
            end.

            if (ord_pol = "POQ" or ord_pol = "LFL")
               and plan_qty[planned] <> 0
            then do:
               if yield_pct <> 0 then
                  plan_qty[planned] = plan_qty[planned] * 100 / yield_pct.
               if plan_qty[planned] < ord_min
               then
                  plan_qty[planned] = ord_min.
               plan_qty[planned] = max(plan_qty[planned],ord_mult).
               if ord_mult <> 0 then do:
                  if plan_qty[planned] / ord_mult -
                     truncate(plan_qty[planned] / ord_mult,0) <> 0
                  then
                     plan_qty[planned] =
                        (truncate (plan_qty[planned] / ord_mult,0) + 1)
                        * ord_mult.
               end.
            end.
            if plan_qty[planned] < ord_min
               and plan_qty[planned] <> 0
               and ord_pol <> "FOQ"
            then
               plan_qty[planned] = ord_min.

            plan_qty[planned] = truncate(plan_qty[planned] + .9999999999,0).

            if yield_pct <> 0
               and ord_pol <> "FOQ"
            then do:
               qavail = qavail + plan_qty[planned] * yield_pct * .01.
            end.
            else do:
               qavail = qavail + plan_qty[planned].
            end.
            if plan_qty[planned] = 0 then planned = planned - 1.

            /* EXPLODE BASE PROCESS SUPPLY UP INTO JOINT PRODUCTS */
            if joint_type = base-process then do:
               {gprun.i ""mrjpup1b.p""
                  "(part,site,plan_qty[planned],plan_date[planned],leadtime,
                    pm_code,safety_insp,ord_pol,ord_per,ord_qty,fcsduedate)"}

               if dbtype("qaddb") = "ORACLE" then do:
                  open query demand_query
                     for each demand no-lock
                      where demand.mrp_domain = global_domain and
                      demand.mrp_part     = part
                     and demand.mrp_site     = site
                     and demand.mrp_type     = "DEMAND"
                     and demand.mrp_dataset  <> "wo_scrap"
                     and demand.mrp_due_date > needed
                     use-index mrp_sitetype query-tuning(cache-size 20 row).
               end. /* IF DBTYPE ("QADDB") */

               if qavail > 0 then
                  qavail = 0.
            end.
         end.
         else do:

            get next supply_query.

            do while available supply:

               qavail = qavail + supply.mrp_qty.
               /*if part = "test02" then do: message qavail "q1". pause. end.*/

               if supply.mrp_dataset = "sod_fas"
               then do:
                  if can-find (demand  where demand.mrp_domain = global_domain
                  and  demand.mrp_dataset = "sod_det"
                     and demand.mrp_part = supply.mrp_part
                     and demand.mrp_nbr = supply.mrp_nbr
                     and demand.mrp_line = supply.mrp_line
                     and demand.mrp_line2 = "" )
                  then
                     qavail = qavail - supply.mrp_qty.
               end.

               if (pm_code = "C"
                  and supply.mrp_dataset = "wo_mstr"
                  and index(supply.mrp_nbr,".") <> 0)
                  or (supply.mrp_dataset = "wo_mstr"
                  and can-find (wo_mstr  where wo_mstr.wo_domain =
                  global_domain and  wo_type = "F"
                  and wo_nbr = supply.mrp_nbr and wo_lot = supply.mrp_line))
               then do:
                  if can-find (first demand
                      where demand.mrp_domain = global_domain and
                      demand.mrp_dataset = "sod_det"
                     and demand.mrp_part = supply.mrp_part
                     and demand.mrp_nbr =
                     substring(supply.mrp_nbr,1,index(supply.mrp_nbr,".") - 1)
                     and demand.mrp_line =
                     substring(supply.mrp_nbr,index(supply.mrp_nbr,".") + 1)
                     and demand.mrp_line2 = "")
                  then
                     qavail = qavail - supply.mrp_qty.
               end.
               else
               if supply.mrp_dataset = "wo_mstr" then do:

                  for first scrap
                     fields( mrp_domain mrp_dataset mrp_detail mrp_due_date
                            mrp_line mrp_line2 mrp_nbr mrp_part
                            mrp_qty mrp_site mrp_type) no-lock
                      where scrap.mrp_domain = global_domain and
                      scrap.mrp_dataset = "wo_scrap"
                       and scrap.mrp_part = supply.mrp_part
                       and scrap.mrp_nbr = supply.mrp_nbr
                       and scrap.mrp_line = supply.mrp_line
                       and scrap.mrp_line2 = supply.mrp_line2:
                  end. /* for first scrap */

                  if available scrap then qavail = qavail - scrap.mrp_qty.
                  /*if part = "test02" then do: message qavail "q2". pause. end.*/
               end.

               assign
                  temp_date = needed
                  fwd_bck = -1.       /* backwards */

               repeat:
                  {mfhdate.i temp_date fwd_bck supply.mrp_site}

                  if temp_date >= today or fwd_bck = 1 then leave.
                  assign
                     temp_date = today
                     fwd_bck = 1.     /* forwards */
               end.

               {mfwday.i supply.mrp_due_date temp_date
                  wdays supply.mrp_site}

               if supply.mrp_due_date < temp_date then wdays = wdays * -1.

               if supply.mrp_dataset = "dsd_det" then do:

                  for first dsd_det
                     fields( dsd_domain dsd_due_date dsd_req_nbr dsd_shipsite
                            dsd_site dsd_trans_id)
                      where dsd_det.dsd_domain = global_domain and  dsd_req_nbr
                      = supply.mrp_nbr
                       and dsd_shipsite = supply.mrp_line2
                       and dsd_site = supply.mrp_site
                  no-lock:
                  end. /* for first dsd_det */

                  if available dsd_det then

                     for first shm_mstr
                        fields( shm_domain shm_code shm_end shm_rec_site
                               shm_src_site shm_start shm_unld_lt)
                         where shm_mstr.shm_domain = global_domain and (
                         shm_code = dsd_trans_id
                          and shm_rec_site = dsd_site
                          and shm_src_site = dsd_shipsite
                          and (shm_start <= dsd_due_date or shm_start = ?)
                          and (shm_end   >= dsd_due_date or shm_end = ?)
                     ) no-lock:
                     end. /* for first shm_mstr */

                  if available shm_mstr then wdays = wdays + shm_unld_lt.
               end.

               wdays = wdays + sfty_time.
               if (supply.mrp_dataset = "pod_det"
                  or  supply.mrp_dataset = "ss sch_mstr"
                  or  supply.mrp_dataset = "req_det")
                  and insp_rqd
               then
                  wdays = wdays + insp_lead.

               if wdays <> 0 or supply.mrp_due_date < today then do:

                  if supply.mrp_dataset = "wo_mstr"
                  then
                     for first wo_mstr
                        fields( wo_domain wo_joint_type wo_lot wo_nbr wo_type)
                         where wo_mstr.wo_domain = global_domain and  wo_lot =
                         supply.mrp_line
                     no-lock:
                     end. /* then for first wo_mstr */

                  if supply.mrp_dataset <> "wo_mstr"
                     and supply.mrp_dataset <> "sod_fas"
                     or (supply.mrp_dataset = "wo_mstr"
                     and (not available wo_mstr or wo_type <> "F"))
                  then do:

                     create oa_det. oa_det.oa_domain = global_domain.
                     assign
                        oa_part    = supply.mrp_part
                        oa_nbr     = supply.mrp_nbr
                        oa_site    = supply.mrp_site
                        oa_line    = string(supply.mrp_line,"x(10)")
                                   + supply.mrp_line2
                        oa_qty     = supply.mrp_qty
                        oa_detail  = supply.mrp_detail
                        oa_fr_date = supply.mrp_due_date.

                     {mfdate.i oa_to_date oa_fr_date wdays oa_site}

                     if oa_to_date > oa_fr_date then oa_code = 1003.

                     if oa_to_date < oa_fr_date then oa_code = 1004.

                     if supply.mrp_due_date < today then do:

                        if oa_to_date <= first_workday then oa_code = 1010.

                        else do:
                           create oa_det. oa_det.oa_domain = global_domain.
                           assign
                              oa_part    = supply.mrp_part
                              oa_site    = supply.mrp_site
                              oa_line    = string(supply.mrp_line,"x(10)")
                                         + supply.mrp_line2
                              oa_nbr     = supply.mrp_nbr
                              oa_qty     = supply.mrp_qty
                              oa_code    = 1010
                              oa_detail  = supply.mrp_detail
                              oa_fr_date = supply.mrp_due_date.
                        end.
                        oa_to_date = today.
                     end.

                     release oa_det.
                  end.
               end.

               if ord_pol = "OTO" then more_demand = no.

               if qavail >= 0 then next a-block.

               get next supply_query.

            end.
            more_supply = no.
         end.
      end.
   end.

   /* CREATE AND DELETE PLANNED ORDERS AS NECESSARY */
   if joint_type = co-product
   then
      assign
         plan_qty = 0
         plan_date = ?.

   run mrmpup02.

END PROCEDURE.

PROCEDURE ip-get-yield:

   /* This routine will determine operation yield percentage        */
   /* used.                                                         */
   /* In order to determine yield, release date must first be       */
   /* determined.                                                   */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  none.                                                        */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  none.                                                        */
   /*                                                               */
   /*  return calculated yield in variable yield_pct.               */

   define variable         v-rel-date     like wo_rel_date    no-undo.
   define variable         v-due-date     like wo_rel_date    no-undo.

   /*  determine release date (needed to calculate yield)           */
   if safety_insp <> 0 then do:
      v-due-date = ?.
      {mfdate.i v-due-date plan_date[planned] safety_insp site}
   end.
   else do:
      v-due-date = plan_date[planned].
      {mfhdate.i v-due-date -1 site}
   end.
   if v-due-date < today + timefence
   then do:
      v-due-date = today + timefence.
      {mfhdate.i v-due-date 1 site }
   end.

   if pm_code <> "P" then do:
      v-rel-date = ?.
      {mfdate.i v-rel-date v-due-date leadtime site}
   end.
   else do:
      v-rel-date = v-due-date - leadtime.
      {mfhdate.i v-rel-date -1 site}
   end.

   /*  determine operation yield to be used     */
   yield_pct = 100.
   /* read all operations in temp table for appropriate rel date */
   for each tt-routing-yields
         where tt-start <= v-rel-date
         and tt-end   >= v-rel-date:
      yield_pct = yield_pct * tt-yield-pct * .01.
   end. /* for each tt-routing-yields */
END PROCEDURE.   /* procedure ip-get-yield  */

/******************************************************************/

PROCEDURE mrmpup02:

   define variable needed as date no-undo.
   define variable leadtime like pt_mfg_lead no-undo.
   define variable i as integer no-undo.
   define variable inc as character format "x(8)" no-undo.
   define variable safety_insp  as integer no-undo.
   define variable mrpdet_recno as recid   no-undo.
   define variable wdays as integer no-undo.
   define variable sfty_time like pt_sfty_time no-undo.
   define variable insp_rqd  like pt_insp_rqd  no-undo.
   define variable pm_code   like pt_pm_code   no-undo.
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
   define variable site      like in_site      no-undo.
   define variable bom_code  like ptp_bom_code no-undo.
   define variable planned     as integer   no-undo.
   define variable err-flag    as integer   no-undo.
   define variable original_db as character no-undo.
   define variable l_errorno   as integer   no-undo.
   define variable joint_type            like wo_joint_type          no-undo.
   define variable dsr_recid as integer no-undo.

   empty temp-table dsr-req-nbr.
   assign
      dsd_recno = ?
      del-yn = no.

   original_db = global_db.

   if not available in_mstr
   then
      leave.
   site = in_site.

   if not available pt_mstr
   then
      leave.
   part = pt_part.

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

   if insp_rqd and pm_code = "P"
   then
      safety_insp = safety_insp + insp_lead.

   leadtime = mfg_lead.
   if pm_code = "P"
   then
      leadtime = pur_lead.
   if leadtime = ?
   then
      leadtime = 0.

   for first pl_mstr
      fields( pl_domain pl_flr_acct  pl_flr_sub   pl_flr_cc   pl_mvar_acct
      pl_mvar_sub
             pl_mvar_cc   pl_mvrr_acct pl_mvrr_sub pl_mvrr_cc   pl_prod_line
             pl_svar_acct pl_svar_sub  pl_svar_cc  pl_svrr_acct pl_svrr_sub
             pl_svrr_cc   pl_wip_acct  pl_wip_sub  pl_wip_cc    pl_xvar_acct
             pl_xvar_sub pl_xvar_cc)
   no-lock  where pl_mstr.pl_domain = global_domain and  pl_prod_line =
   pt_prod_line:
   end. /* for first pl_mstr */

   open query q-supply for each supply no-lock
       where supply.mrp_domain = global_domain and  supply.mrp_site = site
        and supply.mrp_part = part
        and supply.mrp_type = "supplyp"
      by supply.mrp_site by supply.mrp_part
      by supply.mrp_type by supply.mrp_due_date.

   do planned = 1 to 1000:

      if plan_qty[planned] = 0
         or plan_date[planned] = ?
      then
         leave.

      do while true:

         get next q-supply.

         if available supply
            and supply.mrp_dataset = "dsd_det"
         then do:

            if can-find (first dsr-req-nbr
               where dsr-req-nbr = supply.mrp_nbr)
            then
               next.
         end. /* IF AVAILABLE supply */

         if available supply
            and supply.mrp_due_date <> ?
         then do:

            /* Wrong planned order type for pm_code */
            if (pm_code = "D" and supply.mrp_dataset <> "dsd_det")
               or (pm_code <> "D" and supply.mrp_dataset = "dsd_det")
            then do:

               get current q-supply exclusive-lock.

               assign
                  supply.mrp_qty = 0
                  supply.mrp_due_date = ?.
               next.
            end.

            if supply.mrp_dataset = "wo_mstr"
            then do:

               /* Skip joint product order if this item not joint product  */

               for first wo_mstr
                  fields( wo_domain wo_acct wo_sub wo_cc wo_bom_code wo_bo_chg
                  wo_due_date
                         wo_flr_acct wo_flr_sub wo_flr_cc wo_joint_type wo_lot
                         wo_mvar_acct wo_mvar_sub wo_mvar_cc wo_nbr wo_ord_date
                         wo_part wo_mvrr_acct wo_mvrr_sub wo_mvrr_cc wo_qty_chg
                         wo_qty_ord wo_rel_date wo_routing wo_site wo_status
                         wo_svar_acct wo_svar_sub wo_svar_cc wo_svrr_acct
                         wo_svrr_sub wo_svrr_cc wo_type wo_var wo_xvar_acct
                         wo_xvar_sub wo_xvar_cc wo_yield_pct)
               no-lock
                   where wo_mstr.wo_domain = global_domain and  wo_lot  =
                   supply.mrp_line
                    and wo_nbr  = supply.mrp_nbr
                    and wo_part = supply.mrp_part
                    and wo_site = supply.mrp_site:
               end. /* for first wo_mstr */

               if available wo_mstr
                  and ((joint_type = "" and wo_joint_type <> "")
                  or (joint_type <> "" and wo_joint_type = ""))
               then
                  next.

            end.

         end.
         leave.
      end.

      /* Manufactured or Purchased */
      if pm_code <> "D"
      then do:

         release wo_mstr.

         if available supply
            and supply.mrp_due_date <> ?
         then
            find wo_mstr exclusive-lock
                where wo_mstr.wo_domain = global_domain and  wo_lot  =
                supply.mrp_line
                 and wo_nbr  = supply.mrp_nbr
                 and wo_part = supply.mrp_part
                 and wo_site = supply.mrp_site
            no-error.

/* ss 20071120 - b */
				 /*
				 *if plan_nbr[planned] <> "" and plan_line[planned] <> ""  
         *then do:
         *		if avail wo_mstr and wo_status = "P" and plan_line[planned] <> wo_lot then do:
         *     /* DELETE PLANNED ORDER & COMPONENTS */
					*		{mfdel1.i wr_route  " where wr_route.wr_domain = global_domain and  wr_lot =	wo_lot"}
         *     for each wod_det
         *         where wod_det.wod_domain = global_domain and  wod_lot = wo_lot
         *         exclusive-lock:
         *            {mfmrwdel.i "wod_det" wod_part wod_nbr  wod_lot """"}
         *            {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)}
         *            run inmrp (input wod_part,input wod_site).
         *            delete wod_det.
         *     end. /* FOR EACH wod_det */
         *    	/* PLANNED ORDER */
         *    	{mfmrwdel.i "wo_mstr" wo_part wo_nbr wo_lot """"}
         *    	/* SCRAP REQUIREMENT */
         *    	{mfmrwdel.i "wo_scrap" wo_part wo_nbr wo_lot """"}
         *    	delete wo_mstr.
         *		end.
         *		find wo_mstr exclusive-lock
         *       where wo_mstr.wo_domain = global_domain 
         *        and wo_nbr  = plan_line[planned]
         *        and wo_part = part
         *        and wo_site = site
         *   no-error.
         *end.
         */
          if avail wo_mstr then do:
          	if plan_nbr[planned] <> "" and plan_line[planned] <> "" then do:
          		wo_so_job = plan_nbr[planned] + "&" + plan_line[planned] .
          	end.
          	else do:
          		wo_so_job = "sfty".
          	end.
        	end.
        	
/* ss 20071120 - e */

         if not available wo_mstr
         then do:

            assign increment = increment + 1.

            do while can-find (first wo_mstr
                   where wo_mstr.wo_domain = global_domain and (  wo_nbr =
                   string(increment,"99999999")))
                  or (pm_code = "P"
                  and can-find (first req_det
                   where req_det.req_domain = global_domain and  req_nbr =
                   string(increment,"99999999"))):
               increment = increment + 1.
            end.

            inc = string(increment,"99999999").

            create wo_mstr. wo_mstr.wo_domain = global_domain.
            assign
               wo_part = part
               wo_nbr  = inc
               wo_site = site.

            /* GET NEXT LOT NUMBER */
            {mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot
            woc_sq01 wo_lot}
            if recid(wo_mstr) = -1 then .

/* ss 20071106 - b */

						if plan_line[planned] <> "" then do:
							wo_so_job = plan_nbr[planned] + "&" + plan_line[planned].
						end.
						else wo_so_job = "sfty".

/* ss 20071106 - e */         
         
         end.

{mfdel1.i wr_route  " where wr_route.wr_domain = global_domain and  wr_lot =
wo_lot"}

         assign
            wo_status = "P"
            wo_qty_ord = plan_qty[planned]
            wo_qty_chg = 0
            wo_bo_chg = 0
            wo_ord_date = today
            wo_routing = routing
            wo_bom_code = bom_code
            wo_var = wovar
            wo_yield_pct = plan_yield_pct[planned].

/* ss 20071113 - b */
/*
				 if inqty > 0 then do:
				 	find first xxsob_det where xxsob_domain = global_domain and xxsob_nbr = wo_so_job 
				 	and xxsob_part = wo_part and ( xxsob_user2 <> "" or xxsob_user1 <> "" )no-lock no-error.
				 	if not avail xxsob_det then do:
				 		
				 		if inqty >= plan_qty[planned] then
				 			assign wo_qty_ord = 0 
				 						 inqty = inqty - plan_qty[planned].
				 		else assign wo_qty_ord = plan_qty[planned] - inqty
				 								inqty = 0.
				 	end.
				 end.
*/
/* ss 20071113 - e */

         if ord_pol = "FOQ"
            and ord_qty > 0
            and plan_qty[planned] > ord_qty
         then
            wo_qty_ord = ord_qty.

         if wo_qty_ord < ord_min
         then
            wo_qty_ord = ord_min.

         if joint_type = "5"
            and wo_status = "P"
         then
            wo_joint_type = joint_type.

         if wo_bom_code = ""
            and joint_type = "5"
         then
            wo_bom_code = wo_part.

         /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */

         run assign_default_wo_rctstat (
            buffer in_mstr,
            buffer pt_mstr,
            output wo_rctstat,
            output wo_rctstat_active,
            output l_errorno).

         /* ASSIGN DEFAULT VARIANCE ACCOUNT SUB-ACCOUNT AND COST CENTER CODE */
         run assign_default_wo_acct(buffer wo_mstr,
            input  pt_prod_line).

         if safety_insp <> 0
         then do:
            wo_due_date = ?.
            {mfdate.i wo_due_date plan_date[planned]
               safety_insp wo_site}
         end.
         else do:
            wo_due_date = plan_date[planned].
            {mfhdate.i wo_due_date -1 wo_site}
         end.

         if wo_due_date < today + timefence
         then do:

            if timefence <> 0
            then do:

               create oa_det. oa_det.oa_domain = global_domain.
               assign
                  oa_detail  = getTermLabel("PLANNED_ORDER",24)
                  oa_part    = wo_part
                  oa_nbr     = wo_nbr
                  oa_site    = wo_site
                  oa_line    = wo_lot
                  oa_code    = 1011
                  oa_qty     = wo_qty_ord
                  oa_fr_date = today + timefence
                  oa_to_date = wo_due_date.

               if recid(oa_det) = -1 then .

            end.

            wo_due_date = today + timefence.
            {mfhdate.i wo_due_date 1 wo_site }
            if available oa_det
            then
               oa_fr_date = wo_due_date.

         end.

         if pm_code <> "P"
         then do:
            wo_rel_date = ?.
            {mfdate.i wo_rel_date wo_due_date leadtime wo_site}
         end.
         else do:
            wo_rel_date = wo_due_date - leadtime.
            {mfhdate.i wo_rel_date -1 wo_site}
         end.

         if wo_qty_ord = 0
         then do:

            /* Delete Joint Product orders for Base order */
            if wo_joint_type = "5"
            then do:
               for each womstr exclusive-lock
                   where womstr.wo_domain = global_domain and  womstr.wo_nbr  =
                   wo_mstr.wo_nbr
                    and womstr.wo_type = ""
                    and index ("1234",womstr.wo_joint_type) <> 0
                    and womstr.wo_lot <> wo_mstr.wo_lot:

                  /* DELETE PLANNED ORDER & COMPONENTS */

{mfdel1.i wr_route  " where wr_route.wr_domain = global_domain and  wr_lot =
womstr.wo_lot"}

                  for each wod_det exclusive-lock
                      where wod_det.wod_domain = global_domain and  wod_lot =
                      womstr.wo_lot:

                     {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}
                     {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot
                        string(wod_op)}

                     run inmrp (input wod_part, input wod_site).

                     delete wod_det.

                  end.

                  {mfmrwdel.i "wo_mstr" womstr.wo_part
                     womstr.wo_nbr womstr.wo_lot """"}

                  run inmrp (input womstr.wo_part, input womstr.wo_site).

                  delete womstr.

               end.
            end.

            /* DELETE PLANNED ORDER COMPONENTS */
            for each wod_det exclusive-lock
                where wod_det.wod_domain = global_domain and  wod_lot =
                wo_mstr.wo_lot:

               {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}
               {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)}

               run inmrp (input wod_part, input wod_site).

               delete wod_det.
            end.

            {mfmrwdel.i "wo_mstr" wo_mstr.wo_part wo_mstr.wo_nbr
               wo_mstr.wo_lot """"}

            delete wo_mstr.
         end.
      end.

      else do: /* Intersite supplied (pm_code = "D") */

         release dsr_mstr.

         if available supply
            and supply.mrp_due_date <> ?
         then
            find dsr_mstr exclusive-lock
                where dsr_mstr.dsr_domain = global_domain and  dsr_req_nbr =
                supply.mrp_nbr
                 and dsr_part    = supply.mrp_part
                 and dsr_site    = supply.mrp_line
            no-error.

         if not available dsr_mstr
         then do:

            outside-loop:
            repeat:

               do while can-find (first dsr_mstr
                   where dsr_mstr.dsr_domain = global_domain and  dsr_req_nbr =
                   string(increment,"99999999")):
                  increment = increment + 1.
               end.

               assign dsr_recid = 0.

               create dsr_mstr. dsr_mstr.dsr_domain = global_domain.
               assign
                  dsr_part = part
                  dsr_req_nbr = string(increment,"99999999")
                  dsr_site    = site
                  dsr_recid = recid(dsr_mstr) no-error.

               if dsr_recid = 0 or error-status:error then do:
                  increment = increment + 1.
                  delete dsr_mstr.
                  next.
               end.

               leave outside-loop.
            end.

         end.

         assign
            dsr_status = "P"
            dsr_qty_req = plan_qty[planned]
            dsr_loc = in_loc
            dsr_ord_date = today.

         if dsr_loc = ""
         then
            dsr_loc = pt_loc.

         if ord_pol = "FOQ"
            and ord_qty > 0
            and plan_qty[planned] > ord_qty
         then
            dsr_qty_req = ord_qty.

         if dsr_qty_req < ord_min
         then
            dsr_qty_req = ord_min.

         dsr_due_date = ?.
         {mfdate.i dsr_due_date plan_date[planned] safety_insp dsr_site}

         if supplier_perf_enabled
         then
            run update_supp_perf
               (input dsr_req_nbr,
                input dsr_site,
                input dsr_due_date).

         if dsr_due_date < today + timefence
         then do:
            create oa_det. oa_det.oa_domain = global_domain.
            assign
               oa_detail  = getTermLabel("PLANNED_DISTRIBUTION_ORDER",26)
               oa_part    = dsr_part
               oa_nbr     = dsr_req_nbr
               oa_site    = dsr_site
               oa_code    = 1011
               oa_qty     = dsr_qty_req
               oa_fr_date = today + timefence
               oa_to_date = dsr_due_date.
            if recid(oa_det) = -1 then .

            {mfhdate.i oa_fr_date 1 oa_site}
            dsr_due_date = oa_fr_date.
         end.

         if dsr_due_date <> ? and
            not can-find (first dsr-req-nbr where dsr-req-nbr = dsr_req_nbr)
         then do:
            create dsr-req-nbr.
            dsr-req-nbr = dsr_req_nbr.
            if recid(dsr-req-nbr) = -1 then .
         end. /* IF dsr_due_date <> ? */
      end.

      if ord_pol = "FOQ"
         and max(ord_qty,ord_min) > 0
         and plan_qty[planned] > max(ord_qty,ord_min)
      then do:

         /* REDUCE plan_qty BY QTY JUST ORDERED */
         if ord_qty >= ord_min
         then do:

            /* USE ORDER QTY, TRUNCATE DECIMALS */
            plan_qty[planned] = max(plan_qty[planned] - ord_qty,ord_qty).
            if (plan_qty[planned] / ord_qty)
               - truncate(plan_qty[planned] / ord_qty,0) <> 0
            then
               plan_qty[planned] =
               (truncate (plan_qty[planned] / ord_qty,0) + 1) * ord_qty.
         end.

         else do:

            /* USE MINIMUM ORDER QTY, TRUNCATE DECIMALS */
            plan_qty[planned] = max(plan_qty[planned] - ord_min,ord_min).
            if (plan_qty[planned] / ord_min)
               - truncate(plan_qty[planned] / ord_min,0) <> 0
            then
               plan_qty[planned] =
               (truncate (plan_qty[planned] / ord_min,0) + 1) * ord_min.
         end.

         /* FOQ: STAY ON PLAN DATE UNTIL REQMNTS SATISFIED */
         planned = planned - 1.

      end.
   end.

   get next q-supply.

   if not available supply
   then do:
      open query q-supply for each supply no-lock
          where supply.mrp_domain = global_domain and  supply.mrp_site     =
          site
         and   supply.mrp_part     = part
         and   supply.mrp_type     = "supplyp"
         and   supply.mrp_due_date = ?
         by    supply.mrp_site by supply.mrp_part
         by    supply.mrp_type by supply.mrp_due_date.

      get first q-supply.
   end. /* IF NOT AVAILABLE supply */

   repeat while available supply:
      mrpdet_recno = recid(supply).

      if supply.mrp_dataset = "wo_mstr"
      then do:

         find wo_mstr exclusive-lock
             where wo_mstr.wo_domain = global_domain and (  wo_mstr.wo_lot
                = supply.mrp_line
            and (wo_mstr.wo_joint_type = "" or wo_mstr.wo_joint_type = "5")
         ) no-error.

         if available wo_mstr
         then do:

            if wo_mstr.wo_joint_type = "5"
            then do:

               /* Delete the Joint Product WOs for the Base Process WO */
               for each womstr exclusive-lock
                   where womstr.wo_domain = global_domain and  womstr.wo_nbr  =
                   wo_mstr.wo_nbr
                    and womstr.wo_type = ""
                    and index ("1234",womstr.wo_joint_type) <> 0
                    and womstr.wo_lot <> wo_mstr.wo_lot:
                  /* DELETE PLANNED ORDER COMPONENTS */

{mfdel1.i wr_route  " where wr_route.wr_domain = global_domain and  wr_lot =
womstr.wo_lot"}

                  for each wod_det exclusive-lock
                         where wod_det.wod_domain = global_domain and  wod_lot
                         = womstr.wo_lot:
                     {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}
                     {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)}

                     run inmrp (input wod_part, input wod_site).

                     delete wod_det.
                  end.

                  {mfmrwdel.i "wo_mstr" womstr.wo_part
                     womstr.wo_nbr womstr.wo_lot """"}

                  run inmrp (input womstr.wo_part, input womstr.wo_site).

                  delete womstr.
               end.
            end.

{mfdel1.i wr_route  " where wr_route.wr_domain = global_domain and  wr_lot =
wo_mstr.wo_lot"}

            for each wod_det exclusive-lock
                where wod_det.wod_domain = global_domain and  wod_lot =
                wo_mstr.wo_lot:

               {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}
               {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)}

               run inmrp (input wod_part, input wod_site).

               delete wod_det.
            end.

            delete wo_mstr.
         end.

         get current q-supply exclusive-lock.
         if available supply
         then
            delete supply.

      end.

      else
      if supply.mrp_dataset = "dsd_det"
      then do:

         if not can-find (first dsr-req-nbr
            where dsr-req-nbr = supply.mrp_nbr)
         then do:

            find dsr_mstr exclusive-lock
                where dsr_mstr.dsr_domain = global_domain and  dsr_req_nbr =
                supply.mrp_nbr
                 and dsr_site    = supply.mrp_line no-error.

            for each dsd_det exclusive-lock
                where dsd_det.dsd_domain = global_domain and  dsd_req_nbr =
                supply.mrp_nbr
                 and dsd_site    = supply.mrp_line:

               for first si_mstr
                  fields( si_domain si_cur_set si_db si_gl_set si_site) no-lock
                   where si_mstr.si_domain = global_domain and  si_site =
                   dsd_shipsite:
               end. /* for first si_mstr */

               if available si_mstr
                  and si_db <> global_db
               then do:

                  {gprun.i ""gpalias3.p"" "(si_db,output err-flag)"}

                  if err-flag = 0
                  then do:

                     /* Start a new routine which will use the shipping
                     * site database, find the remote ds_det record and
                     * delete it from the remote database
                     */

                     {gprun.i ""mrmpup2a.p""
                        "(dsd_req_nbr,dsd_part,dsd_shipsite,dsd_site)"}
                  end.

                  else do:
                     /* Update the ds_det record in the local database
                     * so that we can update the remote database later
                     */

                     assign
                        dsd_recno = recid(dsd_det)
                        del-yn = yes.

                     {gprun.i ""dsdmmtu3.p""}
                  end.

                  {gprun.i ""gpalias3.p"" "(original_db,output err-flag)"}

               end.

               else do:
                  find ds_det exclusive-lock
                      where ds_det.ds_domain = global_domain and  ds_req_nbr  =
                      dsd_req_nbr
                       and ds_shipsite = dsd_shipsite
                       and ds_site     = dsd_site
                       and ds_part = dsd_part no-error.

                  if available ds_det
                  then do:
                     {mfmrwdel.i "ds_det" ds_part
                        ds_req_nbr ds_shipsite ds_site }

                     run inmrp (input ds_part, input ds_shipsite).

                     delete ds_det.
                  end.
               end.

               for first mrp_det
                  fields( mrp_domain mrp_dataset mrp_due_date mrp_line mrp_line2
                         mrp_nbr mrp_part mrp_qty mrp_site mrp_type)
               no-lock
                   where mrp_det.mrp_domain = global_domain and
                   mrp_det.mrp_dataset = "dsd_det"
                    and mrp_det.mrp_part    = dsd_part
                    and mrp_det.mrp_nbr     = dsd_req_nbr
                    and mrp_det.mrp_line    = dsd_site
                    and mrp_det.mrp_line2   = dsd_shipsite:
               end. /* for first mrp_det */

               if available mrp_det
                  and recid(mrp_det) <> mrpdet_recno
               then do:
                  {mfmrwdel.i "dsd_det" dsd_part
                     dsd_req_nbr dsd_site dsd_shipsite }
               end.

               delete dsd_det.
            end.

            if available dsr_mstr
            then do:

               for each qad_wkfl
                   where qad_wkfl.qad_domain = global_domain and  qad_key1 =
                   "dsr_mstr_ve"
                    and qad_key2 = string(dsr_site, 'x(8)') +
                                   string(dsr_req_nbr, 'x(8)')
               exclusive-lock:

                  delete qad_wkfl.

               end.  /* for each qad_wkfl */

               delete dsr_mstr.

            end. /* if available dsr_mstr */

            get current q-supply exclusive-lock.
            if available supply
            then
               delete supply.

         end. /* if not can-find (first dsr-req-nbr... */

      end.

      get next q-supply.

      if not available supply
      then do:

         open query q-supply for each supply no-lock
             where supply.mrp_domain = global_domain and  supply.mrp_site     =
             site
              and supply.mrp_part     = part
              and supply.mrp_type     = "supplyp"
              and supply.mrp_due_date = ?
            by supply.mrp_site by supply.mrp_part
            by supply.mrp_type by supply.mrp_due_date.

         get first q-supply.

      end.

   end.

END PROCEDURE.

PROCEDURE update_supp_perf:
   define input parameter req_nbr   like dsr_req_nbr   no-undo.
   define input parameter site      like dsr_site      no-undo.
   define input parameter due_date  like dsr_due_date  no-undo.

   for first qad_wkfl
       where qad_wkfl.qad_domain = global_domain and  qad_key1 = "dsr_mstr_ve"
      and qad_key2 = string(site, 'x(8)') + string(req_nbr, 'x(8)')
   exclusive-lock:
   end.

   if not available qad_wkfl
   then do:
      create qad_wkfl. qad_wkfl.qad_domain = global_domain.
      assign
         qad_key1 = "dsr_mstr_ve"
         qad_key2 = string(site, 'x(8)')  + string(req_nbr, 'x(8)').
   end.

   qad_datefld[1] = due_date.

   if recid(qad_wkfl) = -1 then .

END PROCEDURE.

/* INCLUDE FILE WHICH CONTAINS PROCEDURE assign_default_wo_acct */
{woacct.i}
{inmrp1.i}

PROCEDURE mrmpupc:
/* mrmpupc.p - INITIALIZE WORKFILES FOR MRP                             */

   define        buffer in_mstr_co for in_mstr.
   define        buffer mrpdet     for mrp_det.

   define variable i          as integer               no-undo.
   define variable week       as integer               no-undo.
   define variable start      as date                  no-undo.
   define variable site       like in_site             no-undo.
   define variable datestring as character             no-undo.
   define variable joint_type as character             no-undo.
   define variable bom_code   as character             no-undo.
   define variable co-product as character initial "1" no-undo.

   assign
      site = in_mstr.in_site
      part = in_mstr.in_part
      fcsduedate = ?.

   if available ptp_det
   then
      assign
         joint_type = ptp_joint_type
         bom_code = ptp_bom_code.
   else do:

      if available pt_mstr
      then
         assign
            joint_type = pt_joint_type
            bom_code = pt_bom_code.
   end.

   /* Delete joint product demands derived from this item which
   * were placed on base process items during previous calculations
   */

   /* Delete these records if the item is no longer a valid co-product
   * since the processing of the base-process may not remove these
   * old dependent demand records.
   */
   if joint_type <> co-product then
      for each mrp_det
         exclusive-lock
          where mrp_det.mrp_domain = global_domain and  mrp_dataset = "jp_det"
           and mrp_nbr = part
           and mrp_line = site
           and mrp_site = site
      query-tuning(cache-size 20 row):

         /* Update the MRP flag of the base process items */
         run inmrp (input mrp_part, input mrp_site).
         delete mrp_det.
      end.

   /* Flag the base process for this co-product to be planned */
   if joint_type = co-product
   then do for in_mstr_co transaction:

      for first in_mstr_co
         fields( in_domain in_part in_site in_level in_mrp )
          where in_mstr_co.in_domain = global_domain and  in_part = bom_code
          and in_site = site
      no-lock:
      end.

      if available in_mstr_co and in_mrp = no then do:

         find current in_mstr_co exclusive-lock.
         in_mrp = yes.
      end.
   end.

   if can-find (first rps_mstr  where rps_mstr.rps_domain = global_domain and
   rps_part = part
      and rps_site = site)
   then do:
      {gprun.i ""mrrpex.p""}
   end.

   /* Update the fcs_sum records based on current production forecasts
      for this item/site combination */
   {gprun.i ""gppfcup.p"" "(part,site,0)"}

   /* SECTION TO CONSOLIDATE MRP_DET RESULTING FROM SEASONAL BUILD */

   if can-find (first mrp_det  where mrp_det.mrp_domain = global_domain and
   mrp_dataset = "fc_det"
      and mrp_part = part)
   then
      for each mrp_det no-lock use-index mrp_sitetype
           where mrp_det.mrp_domain = global_domain and  mrp_dataset = "fc_det"
            and mrp_site = site
            and mrp_part = part
            and mrp_type = "DEMAND"
            and mrp_due_date <= today
          break
            by mrp_site descending
            by mrp_part descending
            by mrp_type descending
            by mrp_due_date descending:

      do for mrpdet:
         find mrpdet exclusive-lock
           where recid(mrpdet) = recid(mrp_det)
         no-error.

         if first-of (mrp_det.mrp_site) then do:

            for first fc_det
               fields( fc_domain fc_qty fc_part fc_site fc_start)
                where fc_det.fc_domain = global_domain and  fc_part = mrp_part
                 and fc_site = mrp_site
                 and fc_start = mrp_due_date
            no-lock:
            end.
            if not available fc_det then delete mrpdet.
            else mrp_qty = fc_qty.
         end.

         else delete mrpdet.
      end.
   end.

   /* ACTION MESSAGES */
{mfdel1.i oa_det  " where oa_det.oa_domain = global_domain and  oa_part = part
and oa_site = site"}

   /* WORK ORDERS */
   for each wo_mstr
      fields( wo_domain wo_lot wo_nbr wo_part wo_site wo_status wo_yield_pct)
       where wo_mstr.wo_domain = global_domain and  wo_part = part and
       wo_status = "P"
        and wo_site = site and wo_yield <> 100 no-lock
    query-tuning(cache-size 20 row):
      {mfmrwdel.i "wo_scrap" wo_part wo_nbr wo_lot """"}
   end.

   {fcsdate.i today start week site}
   assign
      start = start - 7 * bck
      fcsduedate = start.

   if can-find (first fcs_sum  where fcs_sum.fcs_domain = global_domain and
   fcs_part = part
      and fcs_site = site)
   then do:
      /* Recalculate consumed forecast */
      run mrfsup1.
   end.

   else do:

      if can-find(first mrp_det  where mrp_det.mrp_domain = global_domain and
      mrp_dataset = "fcs_sum"
         and mrp_part = part and mrp_site = site)
      then do:
         /* Recalculate consumed forecast */
         run mrfsup1.
      end.
   end.

END PROCEDURE.

PROCEDURE mrmpup03:
/* mrmpup03.p - MRP PROCESSOR EXPLODE PLANNED & FIRM PLANNED ORDERS           */

   define buffer oadet  for oa_det.
   define buffer ptmstr for pt_mstr.

   define variable qavail       as   decimal               no-undo.
   define variable atp          as   decimal               no-undo.
   define variable atp_date     as   date                  no-undo.
   define variable needed       as   date                  no-undo.
   define variable demand       as   integer               no-undo.
   define variable supply       as   integer               no-undo.
   define variable leadtime     like pt_mfg_lead           no-undo.
   define variable i            as   integer               no-undo.
   define variable safety_insp  as   integer               no-undo.
   define variable mrpdet_recno as   recid                 no-undo.
   define variable plan_ord     like pt_plan_ord           no-undo.
   define variable pm_code      like pt_pm_code            no-undo.
   define variable ord_pol      like pt_ord_pol            no-undo.
   define variable ord_qty      like pt_ord_qty            no-undo.
   define variable ord_min      like pt_ord_min            no-undo.
   define variable ord_max      like pt_ord_max            no-undo.
   define variable partsite     like in_site               no-undo.
   define variable dsr-recid    as   recid                 no-undo.
   define variable network      like pt_network            no-undo.
   define variable err-flag     as   integer               no-undo.
   define variable git_acct     like si_git_acct           no-undo.
   define variable git_sub      like si_git_sub            no-undo.
   define variable git_cc       like si_git_cc             no-undo.
   define variable original_db  as   character             no-undo.
   define variable wdays        as   integer               no-undo.
   define variable sfty_time    like pt_sfty_time          no-undo.
   define variable by-product   as   character initial "2" no-undo.
   define variable joint_type   as   character             no-undo.
   define variable bom_code     like pt_bom_code           no-undo.
   define variable oacode       as   integer               no-undo.
   define variable oacode-2     as   integer               no-undo.
   define variable oatodate     as   date                  no-undo.
   define variable l_serial     like mfc_logical           no-undo.

   empty temp-table tt-cnt.

   assign
      site = ""
      dsd_recno = ?
      dsd_db = ""
      del-yn = no
      undo-all = no.

   assign
      original_db = global_db
      part        = pt_mstr.pt_part
      partsite    = in_mstr.in_site
      site        = in_mstr.in_site
      l_serial    = can-find(first ptmstr
                                where ptmstr.pt_domain       = global_domain
                                and ptmstr.pt_part           = part
                                and ptmstr.pt_lot_ser        = "s").

   if available ptp_det
   then
      assign
         joint_type = ptp_joint_type
         bom_code   = ptp_bom_code
         network    = ptp_network
         plan_ord   = ptp_plan_ord
         pm_code    = ptp_pm_code
         sfty_time  = ptp_sfty_tme
         ord_pol    = ptp_ord_pol
         ord_qty    = ptp_ord_qty
         ord_min    = ptp_ord_min
         ord_max    = ptp_ord_max.
   else
      assign
         joint_type = pt_joint_type
         bom_code   = pt_bom_code
         network    = pt_network
         plan_ord   = pt_plan_ord
         pm_code    = pt_pm_code
         sfty_time  = pt_sfty_time
         ord_pol    = pt_ord_pol
         ord_qty    = pt_ord_qty
         ord_min    = pt_ord_min
         ord_max    = pt_ord_max.

   for each oa_det
      fields( oa_domain oa_code oa_detail oa_fr_date oa_line     oa_nbr
             oa_part oa_qty    oa_site    oa_to_date)
       where oa_det.oa_domain = global_domain and  oa_part = part
      and   oa_site = partsite
      and   oa_code = 1011
   no-lock:

      if oa_nbr = "" then next.

      for first wo_mstr
         fields( wo_domain wo_acct       wo_base_id  wo_bom_code        wo_cc
                 wo_due_date   wo_flr_acct wo_flr_cc          wo_flr_sub
                 wo_joint_type wo_line     wo_lot             wo_mvar_acct
                 wo_mvar_cc    wo_mvar_sub wo_mvrr_acct       wo_mvrr_cc
                 wo_mvrr_sub   wo_nbr      wo_ord_date        wo_part
                 wo_prod_pct   wo_qty_comp wo_qty_ord         wo_qty_rjct
                 wo_qty_type   wo_rctstat  wo_rctstat_active  wo_rel_date
                 wo_routing    wo_site     wo_status          wo_sub
                 wo_svar_acct  wo_svar_cc  wo_svar_sub        wo_svrr_acct
                 wo_svrr_cc    wo_svrr_sub wo_type            wo_xvar_acct
                 wo_xvar_cc    wo_xvar_sub wo_yield_pct)
          where wo_mstr.wo_domain = global_domain and  wo_nbr      = oa_nbr
         and   wo_lot      = oa_line
         and   wo_part     = oa_part
         and   wo_status   = "P"
         and   wo_due_date = oa_fr_date
      no-lock:
      end. /* FOR FIRST wo_mstr */

      if  available wo_mstr
         and wo_qty_ord <> oa_qty
      then do:

         find oadet
            where recid(oadet) = recid(oa_det)
         exclusive-lock no-error.

         oadet.oa_qty = wo_qty_ord.

      end. /* IF AVAILABLE wo_mstr */

      if  not plan_ord
         or (ord_pol  = "FOQ" and ord_qty  = 0)
      then do:

         find first oadet
             where oadet.oa_domain = global_domain and  oadet.oa_part    =
             oa_det.oa_part
            and   oadet.oa_site    = oa_det.oa_site
            and   oadet.oa_code    = oa_det.oa_code
            and   oadet.oa_nbr     = ""
            and   oadet.oa_line    = ""
            and   oadet.oa_to_date = oa_det.oa_to_date
         exclusive-lock no-error.

         if available oadet
         then do:

            oadet.oa_qty = oadet.oa_qty + oa_det.oa_qty.

            find oadet
               where recid(oadet) = recid(oa_det)
            exclusive-lock no-error.

            delete oadet.

         end. /* IF AVAILABLE oadet */
         else do:

            find oadet
               where recid(oadet) = recid(oa_det)
            exclusive-lock no-error.

            assign
               oadet.oa_nbr  = ""
               oadet.oa_line = "".

         end. /* ELSE */

      end. /* IF NOT plan_ord */

   end. /* FOR EACH oa_det */

   for each mrp_det
      fields( mrp_domain mrp_dataset  mrp_detail mrp_due_date mrp_line
              mrp_line2    mrp_nbr    mrp_part     mrp_qty
              mrp_rel_date mrp_site   mrp_type)
       where mrp_det.mrp_domain = global_domain and  mrp_part      = part
      and   mrp_site      = partsite
      and   mrp_type      = "SUPPLYF"
      and   mrp_rel_date <= today + reldays
   no-lock:

      /* SCREEN OUT REPETITIVE SCHEDULES FOR RELEASE MESSAGES */
      /* AND SCREEN OUT MESSAGES FOR BY-PRODUCTS              */

      if mrp_dataset = "wo_mstr"
      then do:

         for first wo_mstr
            fields( wo_domain wo_acct       wo_base_id  wo_bom_code        wo_cc
                    wo_due_date   wo_flr_acct wo_flr_cc          wo_flr_sub
                    wo_joint_type wo_line     wo_lot             wo_mvar_acct
                    wo_mvar_cc    wo_mvar_sub wo_mvrr_acct       wo_mvrr_cc
                    wo_mvrr_sub   wo_nbr      wo_ord_date        wo_part
                    wo_prod_pct   wo_qty_comp wo_qty_ord         wo_qty_rjct
                    wo_qty_type   wo_rctstat  wo_rctstat_active  wo_rel_date
                    wo_routing    wo_site     wo_status          wo_sub
                    wo_svar_acct  wo_svar_cc  wo_svar_sub        wo_svrr_acct
                    wo_svrr_cc    wo_svrr_sub wo_type            wo_xvar_acct
                    wo_xvar_cc    wo_xvar_sub wo_yield_pct)
             where wo_mstr.wo_domain = global_domain and  wo_lot  = mrp_line
            and   wo_nbr  = mrp_nbr
            and   wo_part = mrp_part
         no-lock:
         end. /* FOR FIRST wo_mstr */

         if available wo_mstr
            and (wo_type        = "S"
            or   wo_type        = "W"
            or   wo_joint_type  = by-product
            or  (joint_type     = ""
            and  wo_joint_type <> "")
            or  (joint_type    <> ""
            and  bom_code      <> wo_bom_code))
         then
            next.

      end. /* IF mrp_dataset = "wo_mstr" */

      /* SCREEN OUT RELEASE DUE AND RELEASE PAST DUE MESSAGES FOR  */
      /* UNEXPLODED REPETITIVE SCHEDULES (mrp_dataset = rps_mstr). */
      /* THESE WON'T EXIST FROM THE NORMAL OPERATION OF THE MRP    */
      /* LOGIC, BUT COULD WHEN THIS SUBROUTINE IS CALLED FROM THE  */
      /* APO IMPORT PROCESS.                                       */

      if mrp_dataset = "rps_mstr"
      then
         next.

      if mrp_rel_date >= today
      then
         /* ORDER RELEASE DUE NOW */
         run update_oa_det
           (input mrp_part,
            input mrp_site,
            input mrp_nbr,
            input string(mrp_line,"x(10)") + mrp_line2,
            input 1006,
            input mrp_rel_date,
            input mrp_due_date,
            input mrp_qty,
            input mrp_detail,
            input 1007).
      else
         /* ORDER RELEASE PAST DUE */
         run update_oa_det
           (input mrp_part,
            input mrp_site,
            input mrp_nbr,
            input string(mrp_line,"x(10)") + mrp_line2,
            input 1007,
            input mrp_rel_date,
            input mrp_due_date,
            input mrp_qty,
            input mrp_detail,
            input 1006).

   end. /* FOR EACH mrp_det */

   for each wo_mstr
      fields( wo_domain wo_acct       wo_base_id  wo_bom_code        wo_cc
              wo_due_date   wo_flr_acct wo_flr_cc          wo_flr_sub
              wo_joint_type wo_line     wo_lot             wo_mvar_acct
              wo_mvar_cc    wo_mvar_sub wo_mvrr_acct       wo_mvrr_cc
              wo_mvrr_sub   wo_nbr      wo_ord_date        wo_part
              wo_prod_pct   wo_qty_comp wo_qty_ord         wo_qty_rjct
              wo_qty_type   wo_rctstat  wo_rctstat_active  wo_rel_date
              wo_routing    wo_site     wo_status          wo_sub
              wo_svar_acct  wo_svar_cc  wo_svar_sub        wo_svrr_acct
              wo_svrr_cc    wo_svrr_sub wo_type            wo_xvar_acct
              wo_xvar_cc    wo_xvar_sub wo_yield_pct)
       where wo_mstr.wo_domain = global_domain and  wo_type  = "F"
      and   wo_part  = part
      and   wo_site  = partsite
      and wo_status <> "C"
   no-lock:

      do i = length(wo_nbr) to 1 by -1:

         if substring(wo_nbr,i,1) = "."
         then
            leave.

      end. /* DO i = LENGTH(wo_nbr) TO 1 BY -1 */

      release sod_det.

      if  i > 0
         and i < length(wo_nbr)
      then
         for first sod_det
            fields(sod_domain   sod_due_date sod_line sod_nbr
                   sod_part     sod_status   sod_qty_ord)
             where sod_det.sod_domain = global_domain
             and  (sod_nbr            = substring(wo_nbr,1,i - 1)
             and   sod_line           = integer(substring(wo_nbr,i + 1))
             and  (sod_status         = "FAS"
             or    sod_status         = "")) no-lock:
         end. /* FOR FIRST sod_det */

      if available sod_det
        and wo_part = sod_part
      then do:
        find first tt-cnt
           where tt-dom  = sod_domain
           and   tt-nbr  = sod_nbr
           and   tt-line = sod_line
           and   tt-part = sod_part
        exclusive-lock no-error.
        if not available tt-cnt
        then do:
              create tt-cnt.
              assign tt-dom  = sod_domain
                     tt-nbr  = sod_nbr
                     tt-line = sod_line
                     tt-part = sod_part
                     tt-qty  = sod_qty_ord .
        end. /* IF NOT AVAILABLE tt-cnt */
        tt-qty = tt-qty - (if wo_qty_ord = 1
                              then
                                 1
                              else
                                 0).
        if l_serial
        then
           find first tt-cnt
              where tt-dom  = sod_domain
              and   tt-nbr  = sod_nbr
              and   tt-line = sod_line
              and   tt-part = sod_part
              and   tt-qty  >= 0
        no-error.
      end. /* IF AVAILABLE sod_det */

      wdays = 0.

      if available sod_det
         and sod_part = wo_part
         and available tt-cnt
      then do:

         {mfwday.i wo_due_date
            sod_due_date
            wdays
            wo_site}

         if wo_due_date < sod_due_date
         then
            wdays = wdays * -1.

         wdays = wdays + sfty_time.

      end. /* IF AVAILABLE sod_det */

      if wdays <> 0
      then do:

         oatodate = ?.

         {mfdate.i oatodate
            wo_due_date
            wdays
            wo_site}

         if oatodate > wo_due_date
         then
            /* RESCHEDULE ORDER OUT - DE-EXPEDITE */
            run update_oa_det
              (input wo_part,
               input wo_site,
               input wo_nbr,
               input wo_lot,
               input 1003,
               input oatodate,
               input wo_due_date,
               input max(wo_qty_ord - max(wo_qty_comp,0),0),
               input getTermLabel("FINAL_ASSEMBLY_W/O",24),
               input 1004).
         else
         if oatodate < wo_due_date
         then
            /* RESCHEDULE ORDER IN  - EXPEDITE */
            run update_oa_det
              (input wo_part,
               input wo_site,
               input wo_nbr,
               input wo_lot,
               input 1004,
               input oatodate,
               input wo_due_date,
               input max(wo_qty_ord - max(wo_qty_comp,0),0),
               input getTermLabel("FINAL_ASSEMBLY_W/O",24),
               input 1003).

      end. /* IF wdays <> 0 */

      if available sod_det
         and sod_part    = wo_part
         and wo_due_date < today
         and available tt-cnt
      then
         /* ORDER PAST DUE */
         run update_oa_det
           (input wo_part,
            input wo_site,
            input wo_nbr,
            input wo_lot,
            input 1010,
            input today,
            input wo_due_date,
            input max(wo_qty_ord - max(wo_qty_comp,0),0),
            input getTermLabel("FINAL_ASSEMBLY_W/O",24),
            input 0).

      if not available sod_det
         or (available sod_det
            and wo_part = sod_part
            and not available tt-cnt)
         or (available sod_det
        and sod_part <> wo_part)
      then
         /* CANCEL ORDER */
         run update_oa_det
           (input wo_part,
            input wo_site,
            input wo_nbr,
            input wo_lot,
            input 1005,
            input today,
            input wo_due_date,
            input max(wo_qty_ord - max(wo_qty_comp,0),0),
            input getTermLabel("FINAL_ASSEMBLY_W/O",24),
            input 0).

   end. /* FOR EACH wo_mstr */

   empty temp-table tt-cnt.

   comp = "".

   for first wo_mstr
      fields( wo_domain wo_acct       wo_base_id  wo_bom_code        wo_cc
              wo_due_date   wo_flr_acct wo_flr_cc          wo_flr_sub
              wo_joint_type wo_line     wo_lot             wo_mvar_acct
              wo_mvar_cc    wo_mvar_sub wo_mvrr_acct       wo_mvrr_cc
              wo_mvrr_sub   wo_nbr      wo_ord_date        wo_part
              wo_prod_pct   wo_qty_comp wo_qty_ord         wo_qty_rjct
              wo_qty_type   wo_rctstat  wo_rctstat_active  wo_rel_date
              wo_routing    wo_site     wo_status          wo_sub
              wo_svar_acct  wo_svar_cc  wo_svar_sub        wo_svrr_acct
              wo_svrr_cc    wo_svrr_sub wo_type            wo_xvar_acct
              wo_xvar_cc    wo_xvar_sub wo_yield_pct)
       where wo_mstr.wo_domain = global_domain and  wo_part = part
      and   wo_site = partsite
      and   wo_type = ""
   no-lock:
   end. /* FOR FIRST wo_mstr */

   if available wo_mstr
   then
      repeat:

         if not available wo_mstr
         then
            leave.

         if  wo_status = "A"
            and wo_type   = ""
            and wo_rel_date <= today + reldays
         then do:

            if wo_rel_date >= today
            then
               /* ORDER RELEASE DUE NOW */
               run update_oa_det
                  (input wo_part,
                   input wo_site,
                   input wo_nbr,
                   input wo_lot,
                   input 1006,
                   input wo_rel_date,
                   input wo_due_date,
                   input wo_qty_ord,
                   input getTermLabel("WORK_ORDER",24),
                   input 1007).
            else
               /* RELEASE DATE PAST DUE */
               run update_oa_det
                  (input wo_part,
                   input wo_site,
                   input wo_nbr,
                   input wo_lot,
                   input 1007,
                   input wo_rel_date,
                   input wo_due_date,
                   input wo_qty_ord,
                   input getTermLabel("WORK_ORDER",24),
                   input 1006).

         end. /* IF wo_status = "A" */

         if (wo_status = "P"
            or  wo_status = "F")
            and wo_type   = ""
         then do:

            wo_recid = recid(wo_mstr).

            if comp          = ""
               or (wo_bom_code  > ""
               and comp        <> wo_bom_code)
               or (wo_bom_code  = ""
               and comp        <> wo_part)
            then do:

               comp = if wo_bom_code > ""
                      then
                         wo_bom_code
                      else
                         wo_part.

               if can-find (first ps_mstr
                   where ps_mstr.ps_domain = global_domain and  ps_par = comp)
               then do:
                  run mrmpupb.
               end. /* IF (CAN-FIND (FIRST ps_mstr */
               else do:
                  empty temp-table tt_pk_det.
               end. /* ELSE */

            end. /* IF comp = "" */

            if wo_status = "P"
            then do:

               assign
                  numorders = numorders + 1
                  oacode    = 1002
                  oacode-2  = 0
                  oatodate  = wo_due_date.

               /* PLANNED ORDER RELEASE DUE NOW */
               if wo_rel_date <= today + reldays
               then
                  assign
                     oacode   = 1006
                     oacode-2 = 1007
                     oatodate = wo_rel_date.

               /* RELEASE DATE PAST DUE */
               if wo_rel_date < today
               then
                  assign
                     oacode   = 1007
                     oacode-2 = 1006
                     oatodate = wo_rel_date.

               /* CHANGED THE 9TH INPUT PARAMETER       */
               /* FROM getTermLabel("WORK_ORDER",24)    */
               /* TO   getTermLabel("PLANNED_ORDER,24)  */
               run update_oa_det
                  (input wo_part,
                  input wo_site,
                  input wo_nbr,
                  input wo_lot,
                  input oacode,
                  input oatodate,
                  input wo_due_date,
                  input wo_qty_ord,
                  input getTermLabel("PLANNED_ORDER",24),
                  input oacode-2).

               find first oa_det
                   where oa_det.oa_domain = global_domain and  oa_part    =
                   wo_part
                  and   oa_site    = wo_site
                  and   oa_code    = oacode
                  and   oa_nbr     = wo_nbr
                  and   oa_line    = wo_lot
                  and   oa_to_date = oatodate
               exclusive-lock no-error.

               if  not plan_ord
                  or (ord_pol = "FOQ"
                  and ord_qty = 0)
                  or  pm_code = "P"
               then do:

                  for first wo_mstr
                     where recid(wo_mstr) = wo_recid
                  exclusive-lock:
                  end. /* FOR FIRST wo_mstr */

                  /* DELETE PLANNED ORDER & COMPONENTS */
{mfdel1.i wr_route  " where wr_route.wr_domain = global_domain and  wr_lot =
wo_lot"}

                  for each wod_det
                      where wod_det.wod_domain = global_domain and  wod_lot =
                      wo_lot
                  exclusive-lock:

                     {mfmrwdel.i "wod_det"
                        wod_part
                        wod_nbr
                        wod_lot
                        """"}

                     {mfmrwdel.i "wod_det"
                        wod_part
                        wod_nbr
                        wod_lot
                        string(wod_op)}

                     run inmrp (input wod_part,
                        input wod_site).

                     delete wod_det.

                  end. /* FOR EACH wod_det */

                  if  not plan_ord
                     or (ord_pol = "FOQ"
                     and ord_qty = 0)
                  then do:

                     /* PLANNED ORDER */
                     {mfmrwdel.i "wo_mstr"
                        wo_part
                        wo_nbr
                        wo_lot
                        """"}

                     /* SCRAP REQUIREMENT */
                     {mfmrwdel.i "wo_scrap"
                        wo_part
                        wo_nbr
                        wo_lot
                        """"}

                     delete wo_mstr.

                     do for oadet:

                        find first oadet
                            where oadet.oa_domain = global_domain and  oa_part
                              = oa_det.oa_part
                           and   oa_site    = oa_det.oa_site
                           and   oa_code    = oa_det.oa_code
                           and   oa_nbr     = ""
                           and   oa_line    = ""
                           and   oa_to_date = oa_det.oa_to_date
                        exclusive-lock no-error.

                        if available oadet
                        then do:
                           oa_qty = oa_qty + oa_det.oa_qty.
                           delete oa_det.
                        end. /* IF AVAILABLE */
                        else
                           assign
                              oa_det.oa_nbr  = ""
                              oa_det.oa_line = "".

                     end. /* DO FOR oadet */

                  end. /* IF NOT plan_ord */

               end. /* IF NOT plan_ord */

               if   plan_ord
                  and (ord_pol <> "FOQ"
                  or   ord_qty <> 0)
               then do:

                  if oa_code = 1002
                  then
                     delete oa_det.

                  if wo_qty_ord < ord_min
                  then
                  /* ORDER LESS THAN MINIMUM */
                  run update_oa_det
                     (input wo_part,
                     input wo_site,
                     input wo_nbr,
                     input wo_lot,
                     input 1008,
                     input wo_rel_date,
                     input wo_due_date,
                     input wo_qty_ord,
                     input getTermLabel("PLANNED_ORDER",24),
                     input 1009).
                  else
                  if (wo_qty_ord > ord_max
                     and ord_max    > 0)
                  then
                  /* ORDER EXCEEDS MAXIMUM */
                  run update_oa_det
                     (input wo_part,
                     input wo_site,
                     input wo_nbr,
                     input wo_lot,
                     input 1009,
                     input wo_rel_date,
                     input wo_due_date,
                     input wo_qty_ord,
                     input getTermLabel("PLANNED_ORDER",24),
                     input 1008).

                  {mfmrw.i "wo_mstr"
                     wo_part
                     wo_nbr
                     wo_lot
                     """"
                     wo_rel_date
                     wo_due_date
                     "wo_qty_ord - wo_qty_comp - wo_qty_rjct"
                     "SUPPLYP" PLANNED_ORDER
                     wo_site}

                  {mfmrw.i "wo_scrap"
                     wo_part
                     wo_nbr
                     wo_lot
                     """"
                     wo_rel_date
                     wo_due_date
                     "(wo_qty_ord - wo_qty_comp - wo_qty_rjct)
                       * (1 - wo_yield_pct / 100)"
                     "DEMAND" SCRAP_REQUIREMENT
                     wo_site}

                  /* EXPLODE PLANNED ORDER IF NOT PURCHASED OR JOINT PROD */
                  if  pm_code <> "P"
                     and index("1234",wo_joint_type) = 0
                  then do:
                     run mrmpupa.
                  end. /* IF pm_code <> "P" */

               end. /* IF plan_ord */

            end. /* IF wo_status = "P" */

            /* EXPLODE FIRM ORDER IF NOT JOINT PRODUCT ORDER */
            else
            if  wo_status = "F"
               and index("1234",wo_joint_type) = 0
            then do:
               run mrmpupa.
            end. /* IF wo_status = "F" */

         end. /* IF wo_status = "P" */

         /* SCREEN OUT MESSAGES FOR BY-PRODUCTS -- DO NOT DELETE ALL      */
         /* oa_det IF wo_joint_type = by-product BECAUSE THERE MAY BE     */
         /* ACTION MESSAGES FOR ORDERS WHERE wo_joint_type IS NOT         */
         /* BY-PRODUCT                                                    */
         if   available wo_mstr
            and ((joint_type     = ""
            and  wo_joint_type <> "")
            or (wo_joint_type  = "2"))
         then
            for each oa_det
                where oa_det.oa_domain = global_domain and  oa_det.oa_part =
                wo_part
               and   oa_det.oa_site = wo_site
               and   oa_det.oa_line = wo_lot
               and   oa_det.oa_nbr  = wo_nbr
            exclusive-lock:
               delete oa_det.
            end. /* FOR EACH oa_det */

         find next wo_mstr
             where wo_mstr.wo_domain = global_domain and  wo_part = part
            and   wo_site = partsite
            and   wo_type = ""
         no-lock no-error.

      end. /* IF AVAILABLE wo_mstr */

      /* IMPLODE PLANNED/FIRM PLANNED ORDERS INTO JOINT PRODUCT ORDERS */

      if can-find(first ps_mstr  where ps_mstr.ps_domain = global_domain and
      ps_comp = part ) then do:
         if can-find(first ps_mstr  where ps_mstr.ps_domain = global_domain and
         (  ps_comp = part
            and ps_qty_per <> 0
            and ps_ps_code = "J")) or
            can-find(first wo_mstr  where wo_mstr.wo_domain = global_domain and
            (  wo_part = part
            and wo_joint_type = "5"
            and wo_site = partsite
            and (wo_status = "P" or wo_status = "F"))) then

         run mrjpup03 (part, partsite) .

      end.

      if can-find (first dsr_mstr
          where dsr_mstr.dsr_domain = global_domain and  dsr_part = part
         and   dsr_site = partsite)
      then do:

         for first dsr_mstr
            fields( dsr_domain dsr_due_date dsr_part dsr_qty_req
                    dsr_req_nbr  dsr_site dsr_status)
             where dsr_mstr.dsr_domain = global_domain and  dsr_part = part
            and   dsr_site = partsite
         no-lock:
         end. /* FOR FIRST dsr_mstr */

         assign
            git_acct = ""
            git_sub  = ""
            git_cc   = "".

         if git_acct = ""
         then do:

            for first ssd_det
               fields( ssd_domain ssd_end      ssd_network ssd_rec_site
                      ssd_src_site ssd_start   ssd_trans)
                where ssd_det.ssd_domain = global_domain and (  ssd_network  =
                network
               and   ssd_rec_site = dsr_site
               and  (ssd_start    = ?
               or    ssd_start   <= dsr_due_date)
               and  (ssd_end      = ?
               or    ssd_end     >= dsr_due_date)
            ) no-lock:
            end. /* FOR FIRST ssd_det */

            for first pld_det
               fields( pld_domain pld_inv_acct pld_inv_sub  pld_inv_cc
                       pld_loc      pld_prodline pld_site)
                where pld_det.pld_domain = global_domain and  pld_prodline =
                pt_prod_line
               and   pld_site     = partsite
               and   pld_loc      = (if available(ssd_det)
                                     then
                                        ssd_trans
                                     else
                                        "")
            no-lock:
            end. /* FOR FIRST pld_det */

            if  available pld_det
               and pld_inv_acct <> ""
            then
               assign
                  git_acct = pld_inv_acct
                  git_sub  = pld_inv_sub
                  git_cc   = pld_inv_cc.
            else do:

               for first pl_mstr
                  fields( pl_domain pl_inv_acct pl_inv_sub pl_inv_cc
                  pl_prod_line)
                   where pl_mstr.pl_domain = global_domain and  pl_prod_line =
                   pt_prod_line
               no-lock:
               end. /* FOR FIRST pl_mstr */

               if  available pl_mstr
                  and pl_inv_acct <> ""
               then
                  assign
                     git_acct = pl_inv_acct
                     git_sub  = pl_inv_sub
                     git_cc   = pl_inv_cc.
               else do:

                  for first si_mstr
                     fields( si_domain si_cur_set si_db     si_git_acct
                     si_git_cc
                             si_git_sub si_gl_set si_site)
                      where si_mstr.si_domain = global_domain and  si_site =
                      partsite
                  no-lock:
                  end. /* FOR FIRST si_mstr */

                  if  available si_mstr
                     and si_git_acct <> ""
                  then
                     assign
                        git_acct = si_git_acct
                        git_sub  = si_git_sub
                        git_cc   = si_git_cc.
                  else do:
                     if available gl_ctrl
                     then
                        assign
                           git_acct = gl_inv_acct
                           git_sub  = gl_inv_sub
                           git_cc   = gl_inv_cc.
                  end. /* IF NOT AVAILABLE si_mstr */

               end. /* ELSE */

            end. /* ELSE */

         end. /* IF git_acct = "" */

      end. /* IF CAN-FIND (FIRST dsr_mstr */

      /* PROCESS AND EXPLODE PLANNED DISTRIBUTION ORDERS */
      for first dsr_mstr
         fields( dsr_domain dsr_due_date dsr_part dsr_qty_req
                 dsr_req_nbr  dsr_site dsr_status)
          where dsr_mstr.dsr_domain = global_domain and  dsr_part = part
         and   dsr_site = partsite
      no-lock:
      end. /* FOR FIRST dsr_mstr */

      if available dsr_mstr
      then
      repeat:

         if not available dsr_mstr
         then
            leave.

         if dsr_status = "P"
            or dsr_status = "F"
         then do:

            dsr-recid = recid(dsr_mstr).

            if dsr_status = "P"
            then do:

               numorders = numorders + 1.

               if  not plan_ord
                  or (ord_pol       = "FOQ"
                  and ord_qty       = 0)
                  or  dsr_qty_req   = 0
                  or  dsr_due_date  = ?
                  or  pm_code      <> "D"
               then do:

                  find dsr_mstr
                     where recid(dsr_mstr) = dsr-recid
                  exclusive-lock no-error.

                  if available dsr_mstr
                  then do:

                     for each dsd_det
                         where dsd_det.dsd_domain = global_domain and
                         dsd_req_nbr = dsr_req_nbr
                        and   dsd_site    = dsr_site
                     exclusive-lock:

                        for first si_mstr
                           fields( si_domain si_cur_set si_db     si_git_acct
                           si_git_sub
                                  si_git_cc  si_gl_set si_site)
                            where si_mstr.si_domain = global_domain and
                            si_site = dsd_shipsite
                        no-lock:
                        end. /* FOR FIRST si_mstr */

                        if  available si_mstr
                           and si_db <> global_db
                        then do:

                           {gprun.i ""gpalias3.p"" "(si_db,output err-flag)"}

                           if err-flag = 0
                           then do:
                              {gprun.i ""mrmpup2a.p""
                                 "(dsd_req_nbr,
                                   dsd_part,
                                   dsd_shipsite,
                                   dsd_site)"}

                           end. /* IF err-flag = 0 */
                           else do:

                              /* UPDATE THE ds_det RECORD IN THE LOCAL DATABASE SO  */
                              /* THAT WE CAN UPDATE THE REMOTE DATABASE LATER       */
                              assign
                                 dsd_recno = recid(dsd_det)
                                 del-yn    = yes.

                              {gprun.i ""dsdmmtu3.p""}

                           end. /* ELSE */

                           {gprun.i ""gpalias3.p"" "(original_db,output err-flag)"}

                        end. /* IF AVAILABLE si_mstr */
                        else do:

                           find ds_det
                               where ds_det.ds_domain = global_domain and
                               ds_req_nbr  = dsd_req_nbr
                              and   ds_shipsite = dsd_shipsite
                              and   ds_site     = dsd_site
                              and   ds_part     = dsd_part
                           exclusive-lock no-error.

                           if available ds_det
                           then do:

                              {mfmrwdel.i "ds_det"
                                 ds_part
                                 ds_req_nbr
                                 ds_shipsite
                                 ds_site }

                              run inmrp (input ds_part,
                                 ds_shipsite).

                              delete ds_det.

                           end. /* IF AVAILABLE ds_det */

                        end. /* ELSE */

                        {mfmrwdel.i "dsd_det"
                           dsd_part
                           dsd_req_nbr
                           dsd_site
                           dsd_shipsite }

                        delete dsd_det.

                     end. /* FOR EACH dsd_det */

                     if  dsr_qty_req  <> 0
                        and dsr_due_date <> ?
                     then do:

                        find first oa_det
                            where oa_det.oa_domain = global_domain and
                            oa_det.oa_part    = dsr_part
                           and   oa_det.oa_site    = dsr_site
                           and   oa_det.oa_code    = 1002
                           and   oa_det.oa_nbr     = ""
                           and   oa_det.oa_line    = ""
                           and   oa_det.oa_to_date = dsr_due_date
                        exclusive-lock no-error.

                        if available oa_det
                        then
                           oa_det.oa_qty = oa_det.oa_qty + dsr_qty_req.
                        else
                           run update_oa_det
                              (input dsr_part,
                               input dsr_site,
                               input "",
                               input "",
                               input 1002,
                               input dsr_due_date,
                               input dsr_due_date,
                               input dsr_qty_req,
                               input getTermLabel("PLANNED_I/S_REQUISITION",24),
                               input 0).

                     end. /* IF dsr_qty_req <> 0 */

                     for each qad_wkfl
                         where qad_wkfl.qad_domain = global_domain and
                         qad_key1 = "dsr_mstr_ve"
                        and   qad_key2 = string(dsr_site, 'x(8)')  +
                                         string(dsr_req_nbr, 'x(8)')
                     exclusive-lock:

                        delete qad_wkfl.

                     end. /* FOR EACH qad_wkfl */

                     delete dsr_mstr.

                  end. /* IF AVAILABLE dsr_mstr */

               end. /* IF NOT plan_ord */

            end. /* IF dsr_status = "P" */

            if available dsr_mstr
            then do:
               /* EXPLODE ORDER INTO SITE DEMANDS */
               {gprun.i ""dsdmmta.p""
                  "(input dsr-recid,
                    input network,
                    input git_acct,
                    input git_sub,
                    input git_cc)" }

               for first dsd_det
                  fields( dsd_domain dsd_due_date dsd_part     dsd_qty_ord
                         dsd_req_nbr  dsd_shipdate dsd_shipsite
                         dsd_site)
                   where dsd_det.dsd_domain = global_domain and  dsd_req_nbr =
                   dsr_req_nbr
                  and   dsd_site    = dsr_site
               no-lock:
               end. /* FOR FIRST dsd_det */

               if available dsd_det
               then do:

                  for each dsd_det
                     fields( dsd_domain dsd_due_date dsd_part     dsd_qty_ord
                            dsd_req_nbr  dsd_shipdate dsd_shipsite
                            dsd_site)
                      where dsd_det.dsd_domain = global_domain and  dsd_req_nbr
                      = dsr_req_nbr
                     and   dsd_site    = dsr_site
                  no-lock:

                     if dsd_shipdate < today
                     then
                        /* RELEASE DATE PAST DUE */
                        run update_oa_det
                           (input dsd_part,
                            input dsd_site,
                            input dsd_req_nbr,
                            input string(dsd_shipsite,"x(10)") + dsd_site,
                            input 1013,
                            input dsd_shipdate,
                            input dsd_due_date,
                            input dsd_qty_ord,
                            input getTermLabel("PLANNED_I/S_REQUISITION",24),
                            input 1012).
                     else
                     if dsd_shipdate <= today + reldays
                     then
                        /* PLANNED ORDER SHIPMENT DUE NOW */
                        run update_oa_det
                           (input dsd_part,
                            input dsd_site,
                            input dsd_req_nbr,
                            input string(dsd_shipsite,"x(10)") + dsd_site,
                            input 1012,
                            input dsd_shipdate,
                            input dsd_due_date,
                            input dsd_qty_ord,
                            input getTermLabel("PLANNED_I/S_REQUISITION",24),
                            input 1013).

                     if dsd_qty_ord < ord_min
                     then
                        /* ORDER QUANTITY LESS THAN MINIMUM */
                        run update_oa_det
                           (input dsd_part,
                            input dsd_site,
                            input dsd_req_nbr,
                            input string(dsd_shipsite,"x(10)") + dsd_site,
                            input 1008,
                            input dsd_due_date,
                            input dsd_due_date,
                            input dsd_qty_ord,
                            input getTermLabel("PLANNED_I/S_REQUISITION",24),
                            input 1009).
                     else
                     if (dsd_qty_ord > ord_max
                        and ord_max     > 0)
                     then
                        /* ORDER QUANTITY EXCEEDS MAXIMUM */
                        run update_oa_det
                           (input dsd_part,
                            input dsd_site,
                            input dsd_req_nbr,
                            input string(dsd_shipsite,"x(10)") + dsd_site,
                            input 1009,
                            input dsd_due_date,
                            input dsd_due_date,
                            input dsd_qty_ord,
                            input getTermLabel("PLANNED_I/S_REQUISITION",24),
                            input 1008).

                  end. /* FOR EACH dsd_det */

               end. /* IF AVAILABLE dsd_det */
               else do:

                  find first oa_det
                      where oa_det.oa_domain = global_domain and  oa_part    =
                      dsr_part
                     and   oa_site    = dsr_site
                     and   oa_code    = 1002
                     and   oa_nbr     = ""
                     and   oa_line    = ""
                     and   oa_to_date = dsr_due_date
                  exclusive-lock no-error.

                  if available oa_det
                  then
                     oa_qty = oa_qty + dsr_qty_req.
                  else
                     /* PLANNED REQUISITION NEEDED */
                     run update_oa_det
                        (input dsr_part,
                         input dsr_site,
                         input "",
                         input "",
                         input 1002,
                         input dsr_due_date,
                         input dsr_due_date,
                         input dsr_qty_req,
                         input getTermLabel("PLANNED_I/S_REQUISITION",24),
                         input 0).

                  /* PLANNED REQUISITION HAS NO SOURCE OF SUPPLY */
                  find first oa_det
                      where oa_det.oa_domain = global_domain and  oa_part    =
                      dsr_part
                     and   oa_site    = dsr_site
                     and   oa_code    = 1014
                     and   oa_nbr     = (if dsr_status = "P"
                                         then
                                            ""
                                         else
                                            dsr_req_nbr)
                     and   oa_line    = ""
                     and   oa_to_date = dsr_due_date
                  exclusive-lock no-error.

                  if available oa_det
                  then
                     oa_qty = oa_qty + dsr_qty_req.
                  else
                     run update_oa_det
                        (input dsr_part,
                         input dsr_site,
                         input (if dsr_status = "P"
                                then
                                   ""
                                else
                                   dsr_req_nbr),
                         input "",
                         input 1014,
                         input dsr_due_date,
                         input dsr_due_date,
                         input dsr_qty_req,
                         input getTermLabel("PLANNED_I/S_REQUISITION",24),
                         input 0).

                  if dsr_status = "P"
                  then do:

                     find dsr_mstr
                        where recid(dsr_mstr) = dsr-recid
                     exclusive-lock no-error.

                     for each qad_wkfl
                         where qad_wkfl.qad_domain = global_domain and
                         qad_key1 = "dsr_mstr_ve"
                        and   qad_key2 = string(dsr_site, 'x(8)')  +
                                         string(dsr_req_nbr, 'x(8)')
                     exclusive-lock:

                        delete qad_wkfl.

                     end. /* FOR EACH qad_wkfl */

                     delete dsr_mstr.

                  end. /* IF dsr_status = "P" */

               end. /* ELSE */

            end. /* IF AVAILABLE dsr_mstr */

         end. /* IF dsr_status = "P" */

         find next dsr_mstr
             where dsr_mstr.dsr_domain = global_domain and  dsr_part = part
            and   dsr_site = partsite
         no-lock no-error.

      end. /* IF AVAILABLE dsr_mstr */
END PROCEDURE.

PROCEDURE update_oa_det:

   define input parameter item         as character no-undo.
   define input parameter site         as character no-undo.
   define input parameter order        as character no-undo.
   define input parameter line         as character no-undo.
   define input parameter actioncode   as integer   no-undo.
   define input parameter to_date      as date      no-undo.
   define input parameter from_date    as date      no-undo.
   define input parameter quantity     as decimal   no-undo.
   define input parameter orderdetail  as character no-undo.
   define input parameter actioncode-2 as integer   no-undo.

   find first oa_det
       where oa_det.oa_domain = global_domain and  oa_part = item
      and   oa_site = site
      and   oa_code = actioncode
      and   oa_nbr  = order
      and   oa_line = line
      exclusive-lock no-error.

   if  not available oa_det
   and actioncode-2 <> 0
   then
      find first oa_det
          where oa_det.oa_domain = global_domain and  oa_part = item
         and   oa_site = site
         and   oa_code = actioncode-2
         and   oa_nbr  = order
         and   oa_line = line
         exclusive-lock no-error.

   if not available oa_det
   then do:

      create oa_det. oa_det.oa_domain = global_domain.

      assign
         oa_part    = item
         oa_site    = site
         oa_code    = actioncode
         oa_nbr     = order
         oa_line    = line
         oa_to_date = to_date
         oa_qty     = quantity
         oa_detail  = orderdetail
         oa_fr_date = from_date.

      if recid(oa_det) = -1
      then.

   end. /* IF NOT AVAILABLE oa_det */
   else
      assign
         oa_code    = actioncode
         oa_qty     = quantity
         oa_detail  = orderdetail
         oa_fr_date = from_date
         oa_to_date = to_date.

   /* IF ORDER IS ALREADY PAST DUE AND THE RECOMMENDATION IS  */
   /* TO DE-EXPEDITE TO TODAY OR EARLIER, DON'T GIVE THE      */
   /* RESCHEDULE MESSAGE -- IT DOESN'T HELP.                  */

   if  oa_code    = 1003    /* DE-EXPEDITE ORDER              */
   and from_date <  today   /* ORIGINAL DUE DATE IS PAST DUE  */
   and to_date   <= today   /* RESCHEDULE TO TODAY OR EARLIER */
   then
      delete oa_det.

END PROCEDURE. /* PROCEDURE update_oa_det */

PROCEDURE mrmpupa:
/* mrmpupa.p - RECALCULATE MATERIALS PLAN Planned order explosion       */

   define variable i as integer no-undo.
   define variable qty as decimal no-undo.
   define variable lt_off like ps_lt_off no-undo.
   define variable item-yield as decimal no-undo.

   assign fcsduedate = ?.

   if not available wo_mstr then leave.

   for each tt_pk_det no-lock:

      if (pk_start = ? or pk_start <= wo_rel_date)
         and (pk_end = ? or pk_end >= wo_rel_date)
      then do:
         if can-find
            (first wod_det  where wod_det.wod_domain = global_domain and
            wod_lot = wo_lot and wod_part = pk_part
             and wod_op = integer(pk_reference))
         then next.

         create wod_det. wod_det.wod_domain = global_domain.
         assign
            wod_part = pk_part
            wod_nbr = wo_nbr
            wod_lot = wo_lot
            wod_site = wo_site
            wod_iss_date = wo_rel_date
            wod_op = integer(pk_reference).
      end.  /* if (pk_start = ? ... */
   end. /* for each tt_pk_det */

   for each wod_det
       where wod_det.wod_domain = global_domain and  wod_lot = wo_lot
   exclusive-lock:
      lt_off = ?.
      qty = 0.

      for each tt_pk_det no-lock
         where pk_part = wod_part
           and pk_reference = string(wod_op):

         if (pk_start = ? or pk_start <= wo_rel_date) and
            (pk_end = ? or pk_end >= wo_rel_date)
         then do:
            if lt_off = ? then lt_off = integer(pk_lot).
            else lt_off = min(lt_off,integer(pk_lot)).

            item-yield = 100.
            /* check flags to see if yield calculations are to be used    */
            /* and also determine routing code to be used.                */
            if use-op-yield then do:
               for each tt-routing-yields
                  where tt-op < wod_op
                    and tt-start <= wo_rel_date
                    and tt-end   >= wo_rel_date:
                  item-yield = item-yield * tt-yield-pct * .01.
               end. /* for each tt-routing-yields */
            end. /* if use-op-yield...  */
            wod_yield_pct = item-yield.

            qty = qty + (pk_qty * wo_qty_ord * item-yield * .01)
                / (pk_batch_qty).
         end.  /* if (pk_start = ?... */
      end. /* for each tt_pk_det */

      if qty = 0 then do:

         {mfmrw.i "wod_det" wod_part wod_nbr wod_lot """" ? wod_iss_date
            "0" "DEMAND" PLANNED_ORDER_COMPONENT wod_site}

         {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
            ? wod_iss_date 0 "DEMAND" PLANNED_ORDER_COMPONENT wod_site}

         delete wod_det.
      end.  /* qty = 0  */

      else do:
         if wod_iss_date <> wo_rel_date or lt_off <> 0
            or wo_site <> wod_site
            or wod_qty_req <> qty
         then do:

            assign
               wod_qty_req = qty
               wod_site = wo_site.

            if lt_off = 0 then wod_iss_date = wo_rel_date.
            else do:
               wod_iss_date = ?.
               {mfdate.i wo_rel_date wod_iss_date lt_off wod_site}
            end.

            {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
               ? wod_iss_date wod_qty_req "DEMAND"
               WORK_ORDER_COMPONENT wod_site}

         end.   /* if wod_iss_date <> wo_rel_date... */
      end.   /* else do (qty <> 0) */
   end.   /* for each wod_det  */

END PROCEDURE.

PROCEDURE mrjpup03:
/* mrjpup03.p - MRP IMPLODE PLANNED & FIRM ORDERS INTO JOINT PRODUCT ORDERS   */

   define input parameter part as character no-undo.
   define input parameter partsite as character no-undo.

   define variable in_recid     as   recid no-undo.
   define variable pt_recid     as   recid no-undo.
   define variable wo_recid     as   recid no-undo.
   define variable qty          as   decimal no-undo.
   define variable eff_date     as   date no-undo.
   define variable comp         like ps_comp no-undo.
   define variable leadtime     like pt_mfg_lead no-undo.
   define variable i            as   integer no-undo.
   define variable safety_insp  as   integer no-undo.
   define variable mrpdet_recno as   recid no-undo.
   define variable mrptype      as   character no-undo.
   define variable co_product   like mrp_detail  no-undo.
   define variable l_errorno    like mfc_logical no-undo.

   define buffer womstr for wo_mstr.
   define buffer womstr1 for wo_mstr.

   comp = "".

   /* SCRATCH JP WORKFILE FROM LAST BASE PROCESS */

   empty temp-table tt_pk_det.

{mfdel1.i mrp_det " where mrp_det.mrp_domain = global_domain and  mrp_dataset =
""jp-supply"" and
        mrp_nbr = part and mrp_site = partsite"}

   for first bom_mstr
      fields( bom_domain bom_batch bom_parent) no-lock
       where bom_mstr.bom_domain = global_domain and  bom_parent = part:
   end. /* for first bom_mstr */

   /* IMPLODE BASE ITEM, CREATE tt_pk_det FOR EACH JOINT PRODUCT */

   for each ps_mstr
      fields( ps_domain ps_comp ps_par ps_ps_code ps_cop_qty ps_end
             ps_joint_type ps_prod_pct ps_qty_per ps_qty_type
             ps_start) no-lock
       where ps_mstr.ps_domain = global_domain and  ps_comp = part
        and ps_qty_per <> 0
        and ps_ps_code = "J":

      create tt_pk_det.
      assign
         pk_part      = ps_par
         pk_start     = ps_start
         pk_end       = ps_end
         pk_reference = ps_joint_type
         pk_lot       = ps_qty_type
         pk_user1     = string(ps_prod_pct)
         pk_qty       = ps_cop_qty.

      if available bom_mstr
      then
         pk_loc = string(bom_batch).
      else
         pk_loc = "1".
   end. /* for each ps_mstr */

   /* GET FIRST BASE PROCESS ORDER */

   define query q_womstr for womstr.
   open query q_womstr for each womstr
   no-lock
       where womstr.wo_domain = global_domain and (  womstr.wo_part = part
        and womstr.wo_joint_type = "5"
        and womstr.wo_site = partsite
        and (womstr.wo_status = "P" or womstr.wo_status = "F") ) .
   get first q_womstr.

   repeat:
      if not available womstr then leave.

      wo_recid = recid(womstr).
      /* DELETE EXISTING JOINT PRODUCT ORDERS */
      for each womstr1 exclusive-lock
          where womstr1.wo_domain = global_domain and  womstr1.wo_nbr =
          womstr.wo_nbr
           and womstr1.wo_type = ""
           and index ("1234",womstr1.wo_joint_type) <> 0
           and womstr1.wo_lot <> womstr.wo_lot:

         if can-find (first tt_pk_det where pk_part = womstr1.wo_part
            and pk_ref = "")
         then do:

            for first tt_pk_det
            no-lock
               where pk_part = womstr1.wo_part and pk_ref = ""
                and (pk_start <= womstr.wo_rel_date or pk_start = ?)
                and (pk_end >= womstr.wo_rel_date or pk_end = ?):
            end. /* for first tt_pk_det */

            if available tt_pk_det then next.
         end.

         /* DELETE JOINT PRODUCT WO ROUTING */

{mfdel1.i wr_route  " where wr_route.wr_domain = global_domain and  wr_lot =
womstr1.wo_lot"}

         /* DELETE JOINT PRODUCT BOM */
         for each wod_det exclusive-lock
             where wod_det.wod_domain = global_domain and  wod_lot =
             womstr1.wo_lot:
            {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

            {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)}

            run inmrp (input wod_part, input wod_site).

            delete wod_det.
         end.

         /* DELETE JOINT PRODUCT MRP DETAIL */
         {mfmrwdel.i "wo_mstr" womstr1.wo_part
            womstr1.wo_nbr womstr1.wo_lot """"}

         run inmrp (input womstr1.wo_part, input womstr1.wo_site).

         /* DELETE JOINT PRODUCT WO */
         delete womstr1.
      end.

      /* CREATE NEW JOINT PRODUCT ORDERS BASED ON WHERE-USED */

      for each tt_pk_det
         no-lock
          where (pk_start <= womstr.wo_rel_date or pk_start = ?)
            and (pk_end >= womstr.wo_rel_date or pk_end = ?):

         find first womstr1 exclusive-lock
             where womstr1.wo_domain = global_domain and  womstr1.wo_nbr  =
             womstr.wo_nbr
            and   womstr1.wo_part = pk_part
            and womstr1.wo_lot    <> womstr.wo_lot no-error.
         if not available womstr1 then do:


            create womstr1. womstr1.wo_domain = global_domain.

            assign
               womstr1.wo_nbr = womstr.wo_nbr
               womstr1.wo_part = pk_part
               womstr1.wo_base_id = womstr.wo_lot
               womstr1.wo_qty_type = pk_lot
               womstr1.wo_prod_pct = decimal(pk_user1)
               womstr1.wo_joint_type = pk_reference.

            /* GET NEXT LOT NUMBER */

            {mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot
            woc_sq01 womstr1.wo_lot}

            if recid(womstr1) = -1 then .


            for first pt_mstr fields( pt_domain {&PT_MSTR_FIELDS})
            no-lock
                where pt_mstr.pt_domain = global_domain and  pt_part = pk_part:
            end. /* for first pt_mstr */

            for first in_mstr
               fields( in_domain  in_abc in_avg_int in_cur_set in_cyc_int
               in_gl_set
                       in_level in_mrp in_part in_rctpo_active in_rctpo_status
                       in_rctwo_active in_rctwo_status in_site)
                where in_mstr.in_domain = global_domain and  in_part =
                womstr1.wo_part
                 and in_site = womstr1.wo_site
            no-lock:
            end. /* for first in_mstr */

            /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */

            run assign_default_wo_rctstat(buffer in_mstr,
               buffer pt_mstr,
               output womstr1.wo_rctstat,
               output womstr1.wo_rctstat_active,
               output l_errorno).

            /* ASSIGN DEFAULT VARIANCE ACCOUNT SUB-ACCOUNT AND COST CENTER CODE. */
            run assign_default_wo_acct(buffer womstr1,
               input pt_prod_line).

         end.

         assign
            womstr1.wo_qty_ord  = womstr.wo_qty_ord * pk_qty
                                / decimal(pk_loc)
            womstr1.wo_site     = womstr.wo_site
            womstr1.wo_rel_date = womstr.wo_rel_date
            womstr1.wo_due_date = womstr.wo_due_date
            womstr1.wo_line     = womstr.wo_line
            womstr1.wo_ord_date = womstr.wo_ord_date
            womstr1.wo_status   = womstr.wo_status
            womstr1.wo_bom_code = womstr.wo_bom_code
            womstr1.wo_routing  = womstr.wo_routing.

         if womstr1.wo_bom_code = "" then
            womstr1.wo_bom_code = womstr.wo_part.

         mrptype = "SUPPLYP".
         if womstr1.wo_status = "F" then mrptype = "SUPPLYF".

         {mfmrwnew.i "wo_mstr" womstr1.wo_part womstr1.wo_nbr
            womstr1.wo_lot """" womstr1.wo_rel_date womstr1.wo_due_date
            "womstr1.wo_qty_ord - womstr1.wo_qty_comp - womstr1.wo_qty_rjct"
            mrptype PLANNED_ORDER womstr1.wo_site}

      end. /* for each tt_pk_det */

      get next q_womstr.

   end.

END PROCEDURE.

PROCEDURE gpmpup01:
/* gpmpup01.p - Recalculate Materials Plan - Net Change, Regen, Selective */

   define input parameter p_part like pt_mstr.pt_part no-undo.
   define input parameter p_site as character no-undo.
   define input-output parameter p_inc as integer no-undo.
   define output parameter p_item_orders as integer no-undo.
   define output parameter p_elapsed_time as integer no-undo.
   define output parameter p_desc1 like pt_desc1 no-undo.
   define output parameter p_mrpyn like mfc_logical no-undo.

   define variable z as integer format ">,>>>,>>9" no-undo.
   define variable ptp_recid as recid no-undo.
   define variable l_pmcode like pt_pm_code no-undo.
   define variable l_runmrp like mfc_logical no-undo.

   empty temp-table tt-routing-yields.

   etime(yes).

   for first pt_mstr fields( pt_domain {&PT_MSTR_FIELDS})
       where pt_mstr.pt_domain = global_domain and  pt_mstr.pt_part = p_part
   no-lock:
   end.

   for first in_mstr
      fields( in_domain in_abc in_avg_int in_cur_set in_cyc_int in_gl_set
      in_level
             in_loc in_mrp in_part in_qty_oh in_qty_ord in_qty_req
             in_rctwo_status in_rctwo_active in_rctpo_active
             in_rctpo_status in_site in_user1 in_user2)
       where in_mstr.in_domain = global_domain and  in_part = p_part and
       in_site = p_site
   no-lock:
   end.

   for first ptp_det
      fields( ptp_domain {&PTP_DET_FIELDS})
       where ptp_det.ptp_domain = global_domain and  ptp_part = p_part
        and ptp_site = P_site
   no-lock:
   end. /* FOR FIRST ptp_det */

   for first mrpc_ctrl
      fields(mrpc_domain mrpc_op_yield)
      where mrpc_domain = global_domain
   no-lock:
   end. /* FOR FIRST mrpc_ctrl */

   assign
      part = p_part
      site = p_site
      pt_recid = recid(pt_mstr)
      in_recid = recid(in_mstr)
      ptp_recid = recid(ptp_det)
      increment = p_inc
      numorders = 0
      wo_recid = ?
      comp = ?
      use-op-yield = no.

   if ( (available ptp_det
         and ((drp = yes and ptp_pm_code = "D")
         or (mrp = yes and ptp_pm_code <> "D"))
         and ((ms = yes and ptp_ms = yes)
         or (non_ms = yes and ptp_ms = no))
         and (buyer = "" or ptp_buyer = buyer)
         and (vendor = "" or ptp_vend = vendor)
         and (pm_code = "" or ptp_pm_code = pm_code))

         or (not available ptp_det
         and ((drp = yes and pt_pm_code = "D")
         or (mrp = yes and pt_pm_code <> "D"))
         and ((ms = yes and pt_ms = yes)
         or (non_ms = yes and pt_ms = no))
         and (buyer = "" or pt_buyer = buyer)
         and (vendor = "" or pt_vend = vendor)
         and (pm_code = "" or pt_pm_code = pm_code)) )
         and (prod_line = "" or pt_prod_line = prod_line)
         and (ptgroup = "" or pt_group = ptgroup)
         and (part_type = "" or pt_part_type = part_type)
   then do:

      if (available ptp_det and ptp_ord_pol <> "")
      or (not available ptp_det and pt_ord_pol <> "")
      then do:

     assign
            z = z + 1
            l_runmrp = true.

         /* Initialize workfiles */
         run mrmpupc.

         /* Check for operation based yield functionality */
         run ip-load-routing-temp-table.

         /* Netting Logic */
         run mrmpup01.

         /* Explode planned and firm planned orders */
         run mrmpup03.

         if recid(pt_mstr) <> pt_recid then
            for first pt_mstr fields( pt_domain {&PT_MSTR_FIELDS})
            no-lock
               where recid(pt_mstr) = pt_recid:
            end. /* FOR FIRST pt_mstr */

         assign
            part = pt_part
            comp = pt_part.

         /* RE-CALCULATE (DELETE) PRODUCTION FORECAST AND      */
         /* PLANNED ORDERS EVEN WHEN CURRENT PRODUCT STRUCTURE */
         /* DOES NOT HAVE ANY CONFIGURED, PLANNING COMPONENTS, */
         /* BUT PREVIOUSLY HAD SOME, WHICH RESULTED IN         */
         /* PRODUCTION FORECAST AND PLANNED ORDERS.            */

         /* VALIDATION FOR CALCULATING PRODUCTION FORECAST ONLY   */
         /* FOR FAMILY OR CONFIGURED ITEMS WITH PRODUCT STRUCTURE */
         /* TYPE "P" OR "O"                                       */

         if available ptp_det
         then do:
            l_pmcode = ptp_pm_code.
            if ptp_bom_code > ""
            then
               comp = ptp_bom_code.
         end. /* IF AVAILABLE ptp_det */
         else do:
            l_pmcode = pt_pm_code.
            if pt_bom_code > ""
            then
               comp     = pt_bom_code.
         end. /* ELSE DO IF AVAILABLE ptp_det */

         if ((l_pmcode = "F"
            and (can-find(first ps_mstr
                             where ps_mstr.ps_domain = global_domain
                             and   (ps_par           = comp
                             and   (ps_ps_code       = "P"
                                    or ps_ps_code    = "O")))))
            or (l_pmcode = "C"
            and(can-find(first ps_mstr
             where ps_mstr.ps_domain = global_domain and (  ps_par     = comp
              and ps_ps_code = "O"))))
            or ((l_pmcode <> "P" and
                 l_pmcode <> "D" and
                 l_pmcode <> "F" and
                 l_pmcode <> "C")
            and(can-find(first ps_mstr
             where ps_mstr.ps_domain = global_domain and (  ps_par     = comp
            and  (ps_ps_code = "O" or
                  ps_ps_code = "P")))))
            or (can-find(first pfc_det
             where pfc_det.pfc_domain = global_domain and  pfc_site     =
             in_site
              and pfc_peg_part = in_part)))
         then do:

            /* PERFORMS PRODUCTION FORECAST RELATED CALCULATIONS */
            {gprun.i ""mrpbex01.p"" }

         end. /* l_pmcode = "F" ..*/

      end.  /* IF (AVAILABLE ptp_det AND ptp_ord_pol <> "") */

      else do:

         /* This item not planned by MRP/DRP
            -- initialize workfiles for activity which
            may have been generated previously */
         {gprun.i ""mrmpupc1.p""}
         l_runmrp = false.
      end. /* ELSE DO */

      if in_mrp
      then do transaction:
         find current in_mstr
         exclusive-lock no-error no-wait.
         if available in_mstr
         then
            in_mrp = no.
      end.  /* IF in_mrp THEN DO TRANSACTION */
   end.  /* IF AVAILABLE ptp_det ...         */

   assign
      p_item_orders = numorders
      p_elapsed_time = etime
      p_inc = increment
      p_desc1 = pt_desc1
      p_mrpyn = l_runmrp.

END PROCEDURE.

PROCEDURE ip-load-routing-temp-table:

   /* This routine will load routing information  for a part into   */
   /* a temp table.                                                 */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  none.                                                        */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  none.                                                        */
   /*                                                               */
   /* Note: prior to the call to this internal procedure the        */
   /*       appropriate part and site have been used to find        */
   /*       the pt_mstr and ptp_det records.  Records are not       */
   /*       reread in this procedure.                               */

   define variable         v-routing   as character  no-undo.
   define buffer           bf_ro_det   for ro_det.

   /* clear temp table                    */
   for each tt-routing-yields exclusive-lock:
      delete tt-routing-yields.
   end. /* FOR EACH tt-routing-yields */

   /* see if operation yield should be used...  */
   if (available mrpc_ctrl and mrpc_ctrl.mrpc_op_yield = no)
      or (not available mrpc_ctrl)
      or (available ptp_det and ptp_det.ptp_op_yield = no)
      or (not available ptp_det and pt_mstr.pt_op_yield = no)
   then do:
      use-op-yield = no.
      return.
   end. /* IF (AVAILABLE mrpc_ctrl ... */

   use-op-yield = yes.
   /* determine routing code to be used  */
   v-routing = "".

   if available ptp_det
   then
      v-routing  = if ptp_det.ptp_routing <> ""
                   then
                      ptp_det.ptp_routing
                   else
                      ptp_det.ptp_part.

   if v-routing = ""
   then
      v-routing  = if pt_mstr.pt_routing  <> ""
                   then
                      pt_mstr.pt_routing
                   else
                      pt_mstr.pt_part.

   /* load all routing records found */
   for each bf_ro_det
      fields( ro_domain ro_routing ro_op ro_start ro_end ro_yield_pct)
       where bf_ro_det.ro_domain = global_domain and  ro_routing = v-routing
       no-lock:

      if ro_yield_pct = 0
         or ro_yield_pct = ?
      then
         next.

      create tt-routing-yields.
      assign
         tt-op        = ro_op
         tt-start     = if (ro_start = ?) then low_date else ro_start
         tt-end       = if (ro_end   = ?) then hi_date  else ro_end
         tt-yield-pct = ro_yield_pct.
   end.  /* for each ro_det... */
END PROCEDURE.   /* procedure ip-load-routing-temp-table */

PROCEDURE mrmpupb:
/* mrmpupb.p - PICKLIST EXPLOSION FOR MRP RECALCULATION                  */

   define variable qty as decimal initial 1 no-undo.

   define variable level as integer initial 1 no-undo.
   define variable i as integer no-undo.
   define variable effstart as date no-undo.
   define variable effend as date no-undo.
   define variable find_start as date no-undo.
   define variable find_end as date no-undo.

   define variable conv like um_conv initial 1 no-undo.
   define variable batchqty like bom_batch initial 1 no-undo.
   define variable tempqty as decimal no-undo.
   define variable par_type like ps_qty_type initial "" no-undo.
   define variable save_batchqty as decimal extent 100 no-undo.
   define variable save_conv as decimal extent 100 no-undo.
   define variable save_par_type as character extent 100 no-undo.

   /* Made following variables no-undo and
      based on extents of 100 instead of 1000 */
   define variable maxlevel as integer initial 99 no-undo.
   define variable record as integer extent 100 no-undo.
   define variable save_qty as decimal extent 100 no-undo.
   define variable eff_start like pk_det.pk_start extent 100 no-undo.
   define variable eff_end like pk_det.pk_end extent 100 no-undo.
   define variable prev_batchqty like batchqty no-undo.
   define variable assy_op like ps_op no-undo.

   define buffer b_pt_mstr for pt_mstr.
   define buffer b_ptp_det for ptp_det.

   empty temp-table tt_pk_det.

   for first ps_mstr
      use-index ps_parcomp
       where ps_mstr.ps_domain = global_domain and  ps_par = comp no-lock :
   end.


   repeat:

      if not available ps_mstr then do:
         repeat:
            level = level - 1.
            if level < 1 then leave.
            for first ps_mstr
               where recid(ps_mstr) = record[level]
            no-lock:
            end.
            assign
               comp = ps_par
               qty = save_qty[level]
               batchqty = save_batchqty[level].
            if level = 1 then effstart = ?.
            else effstart = eff_start[level - 1].
            if level = 1 then effend = ?.
            else effend = eff_end [level - 1].
            find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
            global_domain and  ps_par = comp
            no-lock no-error.
            if available ps_mstr then leave.
         end.
      end.

      if level < 1 then leave.

      if level = 1 then
         assign
            batchqty = 1
            assy_op = ps_op.

      if ps_ps_code = "X"
         or (ps_ps_code = "" and not can-find (pt_mstr  where pt_mstr.pt_domain
         = global_domain and (  pt_part = ps_comp)))
      then do:
         assign
            record[level] = recid(ps_mstr)
            save_qty[level] = qty
            eff_start[level] = max(effstart,ps_start).
         if effstart = ? then eff_start[level] = ps_start.
         if ps_start = ? then eff_start[level] = effstart.
         eff_end[level] = min(effend,ps_end).
         if effend = ? then eff_end[level] = ps_end.
         if ps_end = ? then eff_end[level] = effend.
         if level < maxlevel or maxlevel = 0 then do:
            comp = ps_comp.

            for first b_pt_mstr
               fields( pt_domain pt_bom_code pt_loc pt_part)
            no-lock  where b_pt_mstr.pt_domain = global_domain and  pt_part =
            ps_comp:
            end.
            for first b_ptp_det
               fields( ptp_domain ptp_bom_code ptp_joint_type ptp_network
               ptp_part
                      ptp_site)
            no-lock
                where b_ptp_det.ptp_domain = global_domain and  ptp_part =
                ps_comp
                 and ptp_site = site :
            end.

        /* ADDED QUALIFIER TO THE REFERENCING OF FIELDS TO PICK UP */
            /* THE CORRECT BUFFER VALUE.                               */


        if available b_ptp_det and b_ptp_det.ptp_bom_code <> ""
            then
               comp = ptp_bom_code.
            else
            if available b_ptp_det and b_ptp_det.ptp_bom_code = ""
            then
               comp = ptp_part.
            else
            if not available b_ptp_det and available b_pt_mstr
               and b_pt_mstr.pt_bom_code <> ""
            then
               comp = pt_bom_code.
            else
            if not available b_ptp_det and available b_pt_mstr
               and b_pt_mstr.pt_bom_code = ""
            then
               comp = pt_part.

            qty = qty * (if ps_qty_type <> "" then
                         ps_qty_per_b else
                         ps_qty_per) * 100 / (100 - ps_scrp_pct).
            if ps_qty_type <> "" then save_batchqty[level] = batchqty.
            else save_batchqty[level] = 1.
            for first bom_mstr
               fields( bom_domain bom_parent bom_batch)
            no-lock  where bom_mstr.bom_domain = global_domain and  bom_parent
            = ps_par:
            end.
            if available bom_mstr and bom_batch <> 0
               and bom_batch <> 1 and ps_qty_type <> ""
            then do:
               batchqty = batchqty * bom_batch.
            end.

            effstart = max(eff_start[level],ps_start).
            if eff_start[level] = ? then effstart = ps_start.
            if ps_start = ? then effstart = eff_start[level].
            effend = min(eff_end[level],ps_end).
            if eff_end[level] = ? then effend = ps_end.
            if ps_end = ? then effend = eff_end[level].
            level = level + 1.
            for first ps_mstr
               use-index ps_parcomp  where ps_mstr.ps_domain = global_domain
               and  ps_par = comp
            no-lock:
            end.
         end.
         else do:
            find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
            global_domain and  ps_par = comp
            no-lock no-error.
         end.
      end.
      else do:
         if ps_qty_per <> 0
            and can-find (pt_mstr  where pt_mstr.pt_domain = global_domain and
            pt_part = ps_comp)
         then do:
            prev_batchqty = batchqty.
            if ps_qty_type <> "" then save_batchqty[level] = batchqty.
            else save_batchqty[level] = 1.
            for first bom_mstr
               fields( bom_domain bom_batch bom_parent)
            no-lock  where bom_mstr.bom_domain = global_domain and  bom_parent
            = ps_par :
            end.
            if available bom_mstr and bom_batch <> 0
               and bom_batch <> 1 and ps_qty_type <> ""
            then do:
               batchqty = batchqty * bom_batch.
            end.

            if ps_ps_code = "" then do:

               for first tt_pk_det
                  where pk_reference = string(assy_op)
                    and pk_part = ps_comp
                    and pk_start = max(if effstart = ? then low_date else effstart,
                                       if ps_start <> ? then ps_start else low_date)
                    and pk_end = min(if effend = ? then hi_date else effend,
                                     if ps_end <> ? then ps_end else hi_date) :
               end.
               if available (tt_pk_det)
               then do:
                  if ps_lt_off < integer(pk_lot)
                  then
                     pk_lot = string(ps_lt_off).
               end.
               else do:
                  create tt_pk_det.
                  assign
                     pk_part = ps_comp
                     pk_lot = string(ps_lt_off)
                     pk_reference = string(assy_op)
                     pk_start = max(if effstart = ? then low_date else effstart,
                                    if ps_start <> ? then ps_start else low_date)
                     pk_end = min(if effend = ? then hi_date else effend,
                                  if ps_end <> ? then ps_end else hi_date).

               end.

               pk_qty = pk_qty * batchqty
                      + (if ps_qty_type <> ""
                      then
                         ps_qty_per_b
                      else
                         ps_qty_per) * qty * 100
                      * (if pk_batch_qty <> 0
                      then
                         pk_batch_qty else 1) / (100 - ps_scrp_pct).

               pk_batch_qty = batchqty * (if pk_batch_qty <> 0 then
                                          pk_batch_qty else 1).

               if pk_qty > 100000000000000000000.0 then do:
                  pk_qty = pk_qty / 10000000000.0.
                  pk_batch_qty = pk_batch_qty / 10000000000.0.
               end.

            end.
         end.
         find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
         global_domain and  ps_par = comp
         no-lock no-error.
         if available ps_mstr then batchqty = prev_batchqty.
      end.
   end.
END PROCEDURE.

/* mrfsup.p - NEW MRP FORECAST CONSUMPTION RECALCULATION   */
PROCEDURE mrfsup1:

   define variable gross as decimal no-undo.
   define variable net as decimal no-undo.
   define variable net-neg as logical no-undo.
   define variable all-neg as logical initial yes no-undo.
   define variable base-year as integer no-undo.
   define variable i as integer no-undo.
   define variable mrpqty like mrp_qty no-undo.
   define variable ran-mfmrwfs as logical no-undo.

   define variable fcsstart as date no-undo.
   define variable ii as integer no-undo.

   empty temp-table tt-fcs.

   /* Delete all MRP workfile records for old forecasts derived from this
      item/site (mrp_due_date before earliest forecast effective date) */
   {mfdel1.i "mrp_det" " where mrp_det.mrp_domain = global_domain
        and mrp_dataset             = ""fcs_sum""
        and mrp_part                = in_mstr.in_part
        and mrp_site                = in_mstr.in_site
        and substring (mrp_nbr,1,4) <= string(year(today))
        and mrp_due_date            < fcsduedate"}

   assign frwrd = mrfsup1_frwrd.

   /* For each fcs_sum create a temp table row tt-fcs if net <> 0 */
   for each fcs_sum
       where fcs_sum.fcs_domain = global_domain and  fcs_part = in_mstr.in_part
        and fcs_site = in_site
   no-lock by fcs_year:

      if base-year = 0 then assign base-year = fcs_sum.fcs_year.

      do i = 1 to 52:
         assign
            gross = fcs_fcst_qty[i]
            net = fcs_fcst_qty[i] - fcs_sold_qty[i].

         if net < 0 then assign net-neg = yes.
         if net > 0 then assign all-neg = no.

         if net <> 0 then do:
            create tt-fcs.
            assign
               tt-fcs.fcs_year = fcs_sum.fcs_year
               fcs_week = i
               fcs_gross = gross
               fcs_net = net
               fcs_week_idx = ((fcs_sum.fcs_year - base-year) * 52) + i.
         end.
      end.
   end.

   /* If all nets are negative then just delete all mrp_det */

   if all-neg then do:
{mfdel1.i "mrp_det" " where mrp_det.mrp_domain = global_domain and  mrp_dataset
= ""fcs_sum""
           and mrp_part = in_mstr.in_part and mrp_site = in_mstr.in_site"}

      leave.
   end.

   /* If there is a negative net run the netting logic */
   if net-neg then do:

      for each tt-fcs
         where fcs_net < 0 exclusive-lock
         by tt-fcs.fcs_year
         by tt-fcs.fcs_week:

         do ii = 1 to max(frwrd,bck):

            if ii <= bck then do:

               find b-tt-fcs
                  where b-tt-fcs.fcs_week_idx = tt-fcs.fcs_week_idx - ii
                    and b-tt-fcs.fcs_net > 0
               exclusive-lock no-error.

               if available(b-tt-fcs) then do:
                  assign b-tt-fcs.fcs_net = b-tt-fcs.fcs_net + tt-fcs.fcs_net.
                  if b-tt-fcs.fcs_net >= 0 then leave.
                  assign
                     tt-fcs.fcs_net = b-tt-fcs.fcs_net
                     b-tt-fcs.fcs_net = 0.
               end.

            end.

            if ii <= frwrd then do:
               find b-tt-fcs
                  where b-tt-fcs.fcs_week_idx = tt-fcs.fcs_week_idx + ii
                    and b-tt-fcs.fcs_net > 0
               exclusive-lock no-error.

               if available(b-tt-fcs) then do:
                  assign b-tt-fcs.fcs_net = b-tt-fcs.fcs_net + tt-fcs.fcs_net.
                  if b-tt-fcs.fcs_net >= 0 then leave.
                  assign
                     tt-fcs.fcs_net = b-tt-fcs.fcs_net
                     b-tt-fcs.fcs_net = 0.
               end.

            end.

         end.
         delete tt-fcs.
      end.

   end.

   /* If there are any tt-fcs where the net is now 0 then delete them */

   for each tt-fcs where tt-fcs.fcs_net = 0 exclusive-lock:
      delete tt-fcs.
   end.

   /* Now go through all tt-fcs and check the mrp_det qty's */

   for each tt-fcs break by tt-fcs.fcs_year by tt-fcs.fcs_week:
      if first-of(tt-fcs.fcs_year) then do:
         /* Calculate start date of forecast year */
         {fcsdate1.i tt-fcs.fcs_year fcsstart}
      end.
      mrpqty = min(tt-fcs.fcs_gross,tt-fcs.fcs_net).

      if fcsstart + (tt-fcs.fcs_week - 1) * 7 < fcsduedate then mrpqty = 0.

      if mrpqty = 0 then next.

      {mfmrwfs.i "fcs_sum" in_mstr.in_part
         "string(tt-fcs.fcs_year) + in_mstr.in_site"
         string(tt-fcs.fcs_week) """" ? "fcsstart + (tt-fcs.fcs_week - 1) * 7"
         mrpqty "DEMAND" FORECAST in_mstr.in_site}

      assign ran-mfmrwfs = yes.
   end.

   /* Final check all mrp_det's and make sure there is a tt-fcs row for them */
   for each mrp_det
      fields( mrp_domain mrp_dataset mrp_part mrp_site mrp_nbr mrp_line mrp_qty)
       where mrp_det.mrp_domain = global_domain and  mrp_dataset = "fcs_sum"
        and mrp_part = in_part
        and mrp_site = in_site
   no-lock:

      if not can-find(tt-fcs
         where tt-fcs.fcs_year = integer(substring(mrp_nbr,1,4))
           and fcs_week = integer(mrp_line))
      then do:

         /* Did not want to create another buffer for mrp_det just to delete*/
         find scrap where recid(scrap) = recid(mrp_det) exclusive-lock.
         delete scrap.
      end.

   end.

   /* Fix for mfmrwfs.i which has an include file that finds pt_mstr
      with less fields than is needed to run the rest of MRP */

   if ran-mfmrwfs = yes then do:

      for first pt_mstr fields( pt_domain {&PT_MSTR_FIELDS})
      no-lock
         where recid(pt_mstr) = pt_recid:
      end. /* for first pt_mstr */

   end.

END PROCEDURE.

PROCEDURE initmrp:
   /* Used to startup the persistent procedure from gpmpup02 using gprunp.i */

END PROCEDURE.
