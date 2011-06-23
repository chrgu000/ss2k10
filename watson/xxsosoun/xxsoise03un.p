/* soise03.p - SALES ORDER BILL COMPONENT BACKFLUSH TRANSACTION               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision $                                                                */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: emb  *D313                */
/* REVISION: 6.0      LAST MODIFIED: 04/02/91   BY: WUG  *D472*               */
/* REVISION: 6.0      LAST MODIFIED: 06/05/91   BY: emb  *D673                */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb  *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 11/05/91   BY: pma  *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 01/25/92   BY: pma  *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma  *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb  *F369*               */
/* REVISION: 7.0      LAST MODIFIED: 05/11/92   BY: afs  *F459*               */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: afs  *F595*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd  *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 04/02/93   BY: WUG  *G898*               */
/* REVISION: 7.3      LAST MODIFIED: 05/05/93   BY: afs  *GA57*               */
/* REVISION: 7.3      LAST MODIFIED: 06/22/94   BY: WUG  *GK60*               */
/* REVISION: 7.3      LAST MODIFIED: 10/05/94   BY: pxd  *FR90*               */
/* REVISION: 7.3      LAST MODIFIED: 03/29/95   BY: dzn  *F0PN*               */
/* REVISION: 7.3      LAST MODIFIED: 11/02/95   BY: jym  *F0TC*               */
/* REVISION: 8.5      LAST MODIFIED: 07/20/95   BY: taf  *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 03/15/96   BY: ais  *G1QJ*               */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 08/25/97   BY: *H1DD* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 11/04/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CF* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 10/11/00   BY: *N0W8* Mudit Mehta        */
/* Revision: 1.11.3.9      BY: Niranjan Ranka     DATE: 07/13/01  ECO: *P00L* */
/* Revision: 1.11.3.10     BY: Ellen Borden       DATE: 06/08/01  ECO: *P00G* */
/* Revision: 1.11.3.11     BY: Jeff Wootton       DATE: 05/14/02  ECO: *P03G* */
/* Revision: 1.11.3.12     BY: Dan Herman         DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.11.3.18     BY: Steve Nugent       DATE: 06/12/02  ECO: *P07Y* */
/* Revision: 1.11.3.20     BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.11.3.21     BY: Rajinder Kamra     DATE: 06/23/03  ECO: *Q003* */
/* Revision: 1.11.3.22     BY: Jean Miller        DATE: 03/05/04  ECO: *Q06C* */
/* Revision: 1.11.3.23     BY: Robin McCarthy     DATE: 04/19/04  ECO: *P15V* */
/* Revision: 1.11.3.24     BY: Shoma Salgaonkar   DATE: 08/25/04  ECO: *Q0CJ* */
/* $Revision: 1.11.3.25 $    BY: Paul Dreslinski    DATE: 10/30/04  ECO: *M1M3* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "SOISE03.P"}

define input parameter sodnbr like sod_nbr.
define input parameter sodln like sod_line.

define new shared variable pt_recid as recid.
define new shared variable nbr like tr_nbr.
define new shared variable cr_acct like trgl_cr_acct.
define new shared variable cr_sub like trgl_cr_sub.
define new shared variable cr_cc like trgl_cr_cc.
define new shared variable cr_proj like trgl_cr_proj.
define new shared variable transtype as character format "x(7)".

define shared variable sod_recno as recid.
define shared variable eff_date as date.
define shared variable accum_wip like tr_gl_amt.
define shared variable qty_iss_rcv like tr_qty_loc.
define shared variable wolot   like tr_lot.
define shared variable change_db like mfc_logical.
define shared variable so_db like global_db.
define shared variable ship_db like global_db.
define shared variable undo-select like mfc_logical no-undo.

define variable qty_left like tr_qty_chg.
define variable trqty like tr_qty_chg.
define variable wopart_wip_acct like pl_wip_acct.
define variable wopart_wip_sub like pl_wip_sub.
define variable wopart_wip_cc like pl_wip_cc.
define variable wopart_wip_proj like wo_proj.
define variable ref like glt_ref.
define variable qty as decimal.
define variable serial like tr_serial.
define variable loc like ld_loc.
define variable site like ld_site.
define variable lotqty like wod_qty_chg.
define variable yn like mfc_logical.
define variable i as integer.
define variable part like pt_part.
define variable dr_acct like sod_acct.
define variable dr_sub like sod_sub.
define variable dr_cc like sod_cc.
define variable wip_acct like sod_acct.
define variable wip_sub like sod_sub.
define variable wip_cc like sod_cc.
define variable sod_entity like si_entity.
define variable gl_amt like glt_amt.
define variable pm_code like pt_pm_code no-undo.
define variable glcost like sct_cst_tot.
define variable assay like tr_assay.
define variable grade like tr_grade.
define variable expire like tr_expire.
define variable gl_tmp_amt as decimal no-undo.
define variable err-flag as integer.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
define variable is_xfer as logical initial false no-undo.
define variable io_batch like cnsu_batch no-undo.
define variable transfer as logical initial false no-undo.

/* SS - 20081114.1 - B */
DEF SHARED VAR v_loc LIKE tr_loc .
DEF SHARED VAR v_dn LIKE tr_loc .
DEF SHARED VAR v_bill LIKE so_bill.
DEF SHARED VAR v_ship LIKE so_ship.
/* SS - 20081114.1 - E */

{pocnvars.i}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{&SOISE03-P-TAG1}

for first gl_ctrl
   fields (gl_domain gl_inv_acct gl_inv_cc gl_inv_sub gl_rnd_mthd gl_wip_acct
           gl_wip_cc gl_wip_sub)
   where   gl_domain = global_domain
no-lock: end.

/* IF THE INVENTORY DOMAIN IS THE SAME AS THE CENTRAL DOMAIN LOOKUP */
/* SALES ORDER LINE BY recid FOR MORE EFFICIENT PROCESSING. */
if change_db then
   for first sod_det
      fields (sod_domain sod_fa_nbr sod_line sod_lot sod_nbr sod_part
              sod_project sod_site sod_type)
      where   sod_domain = global_domain
      and     sod_nbr  = sodnbr
      and     sod_line = sodln
   no-lock: end.
else
   for first sod_det
      fields (sod_domain sod_fa_nbr sod_line sod_lot sod_nbr sod_part
              sod_project sod_site sod_type)
      where recid(sod_det) = sod_recno
   no-lock: end.

for first pt_mstr
   fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
           pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type pt_loc
           pt_mfg_lead pt_mrp pt_network pt_ord_max pt_ord_min
           pt_ord_mult pt_ord_per pt_ord_pol pt_ord_qty pt_part
           pt_plan_ord pt_pm_code pt_prod_line pt_pur_lead
           pt_rctpo_active pt_rctpo_status pt_rctwo_active
           pt_rctwo_status pt_routing pt_sfty_time pt_shelflife
           pt_timefence pt_um pt_yield_pct)
   where   pt_domain = global_domain
   and     pt_part = sod_part
no-lock:
   for first pl_mstr
      fields (pl_domain pl_inv_acct pl_inv_cc pl_inv_sub pl_prod_line
              pl_wip_acct pl_wip_cc pl_wip_sub)
      where   pl_domain = global_domain
      and     pl_prod_line = pt_prod_line
   no-lock: end.
end.

for first si_mstr
   fields (si_domain si_cur_set si_db si_entity si_git_acct si_git_cc
           si_git_sub si_gl_set si_site si_status)
   where   si_domain = global_domain
   and     si_site = sod_site
no-lock: end.

assign
   sod_entity = si_entity
   pt_recid   = recid(pt_mstr).

{gprun.i ""glactdft.p""
         "(input ""WO_WIP_ACCT"",
           input pt_prod_line,
           input sod_site,
           input """",
           input """",
           input yes,
           output wopart_wip_acct,
           output wopart_wip_sub,
           output wopart_wip_cc)"}

assign
   wopart_wip_proj = sod_project
   nbr             = sod_nbr + "." + string(sod_line).

/* COMPONENT ISSUE TRANSACTIONS */
for each sr_wkfl
   where sr_domain = global_domain
   and   sr_userid = mfguser
   and   sr_lineid begins string(sod_line) + "ISS"
no-lock:

   part = substring(sr_lineid,length(string(sod_line)) + 4).

   release pl_mstr.

   /* GET PART MASTER INFORMATION */
   for first pt_mstr
      fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
              pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type pt_loc
              pt_mfg_lead pt_mrp pt_network pt_ord_max pt_ord_min
              pt_ord_mult pt_ord_per pt_ord_pol pt_ord_qty pt_part
              pt_plan_ord pt_pm_code pt_prod_line pt_pur_lead
              pt_rctpo_active pt_rctpo_status pt_rctwo_active
              pt_rctwo_status pt_routing pt_sfty_time pt_shelflife
              pt_timefence pt_um pt_yield_pct)
      where   pt_domain = global_domain
      and     pt_part = part
   no-lock:
      for first pl_mstr
         fields (pl_domain pl_inv_acct pl_inv_cc pl_inv_sub pl_prod_line
                 pl_wip_acct pl_wip_cc pl_wip_sub)
         where   pl_domain = global_domain
         and     pl_prod_line = pt_prod_line
      no-lock:

         for first pld_det
            fields (pld_domain pld_inv_acct pld_inv_cc pld_inv_sub pld_loc
                    pld_prodline pld_site)
            where   pld_domain = global_domain
            and     pld_prodline = pl_prod_line
            and     pld_site     = sr_site
            and     pld_loc      = sr_loc
         no-lock: end.
      end.
   end.

   assign
      glxcst = 0
      gl_amt = 0
      dr_acct = ""
      dr_sub = ""
      dr_cc = ""
      global_part = pt_part
      global_addr = ""
      transtype = "ISS-WO".

   if available pt_mstr then do:

      if sr_site <> sod_site then do:

         {gprun.i ""icxfer.p""
                  "(input wolot,
                    input sr_lotser,
                    input sr_ref,
                    input sr_ref,
                    input sr_qty,
                    input nbr,
                    input sod_nbr,
                    input """",
                    input wopart_wip_proj,
                    input eff_date,
                    input sr_site,
                    input sr_loc,
                    input sod_site,
                    input pt_loc,
                    input no,
                    input """",
                    input ?,
                    input """",
                    input 0,
                    input """",
                    output glcost,
                    output iss_trnbr,
                    output rct_trnbr,
                    input-output assay,
                    input-output grade,
                    input-output expire)"}

         assign
            glxcst = glcost
            transfer = yes.
      end.
      else do:
         {gpsct02.i &part=pt_part &site=sod_site &cost=sct_cst_tot}
      end.

      assign
         dr_acct = wopart_wip_acct
         dr_sub = wopart_wip_sub
         dr_cc = wopart_wip_cc
         gl_amt = sr_qty * glxcst.
   end.   /* IF available pt_mstr */

   {ictrans.i
      &addrid=""""
      &bdnstd=0
      &cracct="if available pl_mstr then
                  if available pld_det then pld_inv_acct
                  else pl_inv_acct
               else gl_inv_acct"
      &crsub="if available pl_mstr then
                 if available pld_det then pld_inv_sub
                 else pl_inv_sub
              else gl_inv_sub"
      &crcc="if available pl_mstr then
                if available pld_det then pld_inv_cc
                else pl_inv_cc
             else gl_inv_cc"
      &crproj=wopart_wip_proj
      &curr=""""
      &dracct=dr_acct
      &drsub=dr_sub
      &drcc=dr_cc
      &drproj=wopart_wip_proj
      &effdate=eff_date
      &exrate=0
      &exrate2=0
      &exratetype=""""
      &exruseq=0
      &glamt=gl_amt
      &lbrstd=0
      &line=sod_line
      &location="(if sod_site <> sr_site then pt_loc else sr_loc)"
      &lotnumber=wolot
      &lotserial=sr_lotser
      &lotref=sr_ref
      &mtlstd=0
      &ordernbr=nbr
      &ovhstd=0
      &part=part
      &perfdate=?
      &price=glxcst
      &quantityreq=sr_qty
      &quantityshort=0
      &quantity="- sr_qty"
      &revision=""""
      &rmks=""""
      &shiptype=""""
      &site=sod_site
      &slspsn1=""""
      &slspsn2=""""
      &sojob=sod_nbr
      &substd=0
      &transtype=""ISS-FAS""
      &msg=0
      &ref_site=tr_site}
      
   /*ASSAY, GRADE, EXPIRE */
   if sr_site <> sod_site then
     assign
         tr_assay  = assay
         tr_grade  = grade
         tr_expire = expire.

   /* SS - 20081114.1 - B */
   ASSIGN
      tr_user1 = v_bill
      tr_user2 = v_ship
      tr_so_job = v_dn
      tr__dec01 = - sr_qty
      tr__chr01 = pt_um
      .
   /* SS - 20081114.1 - E */

   /* CREATE CONSIGNMENT USAGE RECORDS IF CONSIGNMENT ENABLED*/
   /* AND CONSIGNMENT INVENTORY EXISTS.                      */
   if using_supplier_consignment then do:
      {gprunmo.i &program = ""pocnsix4.p"" &module = "ACN"
                 &param   = """(input part,
                               input sr_site,
                               input right-trim(substring(sr_lotser,1,18)),
                               input sr_ref,
                               input (if sr_qty < 0 then true else false),
                               output consign_flag)"""}

      /*IF CONSIGNED INVENTORY EXISTS, DETERMINE WHETHER TO */
      /*USE IT PRIOR TO UNCONSIGNED INVENTORY.              */
      if consign_flag and not transfer then do:
         {gprunmo.i &program = ""ictrancn.p"" &module = "ACN"
                    &param   = """(input sod_nbr,
                                   input sod_lot,
                                   input tr_wod_op,
                                   input tr_so_job,
                                   input sr_qty,
                                   input sr_lotser,
                                   input part,
                                   input sr_site,
                                   input sr_loc,
                                   input sr_ref,
                                   input eff_date,
                                   input tr_trnbr,
                                   input is_xfer,
                                   input-output io_batch)"""}
      end. /*If consign_flag*/
   end. /*IF USING_SUPPLIER_CONSIGNMENT*/

   /* ACCUMULATED WIP AMOUNT */
   if available pt_mstr then
      accum_wip = accum_wip + gl_amt.

   /* UPDATE sob_det RECORDS */
   qty_left = sr_qty.

   for each sob_det
      where sob_domain = global_domain
        and sob_nbr = sod_nbr
        and sob_line = sod_line
        and sob_qty_req <> 0
        and sob_part = part:

      if sob_qty_req >= 0
         and sob_qty_iss < sob_qty_req
         and qty_left > 0
      then do:
         assign
            trqty       = sob_qty_req - sob_qty_iss
            sob_qty_iss = sob_qty_iss + min(trqty,qty_left).

         find in_mstr
            where in_domain = global_domain
              and in_part = sob_part
              and in_site = sob_site
         exclusive-lock no-error.

         if available in_mstr then
            in_qty_req = in_qty_req - min(trqty,qty_left).

         qty_left   = qty_left - min(trqty,qty_left).
      end.
      else
      if sob_qty_req < 0
         and sob_qty_iss > sob_qty_req
         and qty_left < 0
      then do:
         assign
            trqty       = sob_qty_req - sob_qty_iss
            sob_qty_iss = sob_qty_iss + max(trqty,qty_left).

         find in_mstr
            where in_domain = global_domain
              and in_part = sob_part
              and in_site = sob_site
         exclusive-lock no-error.

         if available in_mstr then
            in_qty_req = in_qty_req - max(trqty,qty_left).

         qty_left = qty_left - max(trqty,qty_left).

      end.

      if sob_qty_req >= 0 then
         trqty = max(sob_qty_req - max(sob_qty_iss,0),0).
      else
         trqty = min(sob_qty_req - min(sob_qty_iss,0),0).

      if sod_fa_nbr <> ""
         or sod_lot <> ""
         or sod_type <> ""
      then
         trqty = 0.

      for first pt_mstr
         fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
                 pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type pt_loc
                 pt_mfg_lead pt_mrp pt_network pt_ord_max pt_ord_min
                 pt_ord_mult pt_ord_per pt_ord_pol pt_ord_qty pt_part
                 pt_plan_ord pt_pm_code pt_prod_line pt_pur_lead
                 pt_rctpo_active pt_rctpo_status pt_rctwo_active
                 pt_rctwo_status pt_routing pt_sfty_time pt_shelflife
                 pt_timefence pt_um pt_yield_pct)
         where   pt_domain = global_domain
         and     pt_part = sob_part
      no-lock: end.

      pm_code = pt_pm_code.

      for first ptp_det
         fields (ptp_domain ptp_bom_code ptp_ins_lead ptp_ins_rqd ptp_joint_type
                 ptp_mfg_lead ptp_network ptp_ord_max ptp_ord_min
                 ptp_ord_mult ptp_ord_per ptp_ord_pol ptp_ord_qty
                 ptp_part ptp_plan_ord ptp_pm_code ptp_pur_lead
                 ptp_routing ptp_sfty_tme ptp_site ptp_timefnce
                 ptp_yld_pct)
         where  ptp_domain = global_domain
         and    ptp_part = pt_part
         and    ptp_site = sob_site
      no-lock: end.

      if available ptp_det then
         pm_code = ptp_pm_code.

      if pm_code <> "C" then do:
         {mfmrw.i "sob_det" sob_part sob_nbr
            "string(sob_line) + ""-"" + sob_feature" sob_parent ? sob_iss_date
            trqty "DEMAND" SALES_ORDER_COMPONENT sob_site}
      end.

      /* UPDATE sob_qty_iss IN THE CENTRAL DOMAIN */
      if change_db then do:

         {gprun.i ""gpmdas.p"" "(input so_db, output err-flag)"}

         if err-flag = 2 or err-flag = 3 then do:
            /* DOMAIN # IS NOT AVAILABLE*/
            {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=so_db}
            if c-application-mode <> "API" then
            pause.
            undo-select = true.
            undo, leave.
         end.

         {gprun.i ""soise03a.p""
                  "(input sob_nbr,
                    input sob_line,
                    input sob_parent,
                    input sob_feature,
                    input sob_part,
                    input sob_qty_iss)"}

         /* SWITCH BACK TO THE INVENTORY DOMAIN */
         {gprun.i ""gpmdas.p"" "(input ship_db, output err-flag)"}

         if err-flag = 2 or err-flag = 3 then do:
            /* DOMAIN # IS NOT AVAILABLE*/
            {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=ship_db}
            if c-application-mode <> "API" then
            pause.
            undo-select = true.
            undo, leave.
         end.

      end.

   end.

   if qty_left <> 0 then do:

      if qty_left > 0 then
         find first sob_det
            where sob_domain = global_domain
            and   sob_nbr     = sod_nbr
            and   sob_line    = sod_line
            and   sob_part    = part
            and   sob_qty_req > 0
         exclusive-lock no-error.
      else
         find first sob_det
            where sob_domain = global_domain
            and   sob_nbr     = sod_nbr
            and   sob_line    = sod_line
            and   sob_part    = part
            and   sob_qty_req < 0
         exclusive-lock no-error.

      if not available sob_det then
         find first sob_det
            where sob_domain = global_domain
            and   sob_nbr = sod_nbr
            and   sob_line = sod_line
            and   sob_qty_req <> 0
            and   sob_part = part
         exclusive-lock no-error.

      if available sob_det then do:

         sob_qty_iss = sob_qty_iss + qty_left.

         if sob_qty_req >= 0 then
            trqty = max(sob_qty_req - max(sob_qty_iss,0),0).
         else
            trqty = min(sob_qty_req - min(sob_qty_iss,0),0).

         if sod_fa_nbr <> "" or sod_lot <> ""
            or sod_type <> "" then trqty = 0.

         for first pt_mstr
            fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int
                    pt_desc1 pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type
                    pt_loc pt_mfg_lead pt_mrp pt_network pt_ord_max
                    pt_ord_min pt_ord_mult pt_ord_per pt_ord_pol
                    pt_ord_qty pt_part pt_plan_ord pt_pm_code
                    pt_prod_line pt_pur_lead pt_rctpo_active
                    pt_rctpo_status pt_rctwo_active pt_rctwo_status
                    pt_routing pt_sfty_time pt_shelflife pt_timefence
                    pt_um pt_yield_pct)
            where   pt_domain = global_domain
            and     pt_part = sob_part
         no-lock: end.

         pm_code = pt_pm_code.

         for first ptp_det
            fields (ptp_domain ptp_bom_code ptp_ins_lead ptp_ins_rqd
                    ptp_joint_type
                    ptp_mfg_lead ptp_network ptp_ord_max ptp_ord_min
                    ptp_ord_mult ptp_ord_per ptp_ord_pol ptp_ord_qty
                    ptp_part ptp_plan_ord ptp_pm_code ptp_pur_lead
                    ptp_routing ptp_sfty_tme ptp_site ptp_timefnce
                    ptp_yld_pct)
            where   ptp_domain = global_domain
            and     ptp_part = pt_part
            and     ptp_site = sob_site
         no-lock: end.

         if available ptp_det then
            pm_code = ptp_pm_code.

         if pm_code <> "C" then do:
            {mfmrw.i "sob_det" sob_part sob_nbr
               "string(sob_line) + ""-"" + sob_feature" sob_parent ?
               sob_iss_date trqty "DEMAND" SALES_ORDER_COMPONENT sob_site}
         end.

         /* UPDATE sob_qty_iss IN THE CENTRAL DOMAIN */
         if change_db then do:

            {gprun.i ""gpmdas.p"" "(input so_db, output err-flag)"}

            if err-flag = 2 or err-flag = 3 then do:
               /* DOMAIN # IS NOT AVAILABLE*/
               {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=so_db}
                if c-application-mode <> "API" then
               pause.
               undo-select = true.
               undo, leave.
            end.

            {gprun.i ""soise03a.p""
                     "(input sob_nbr,
                       input sob_line,
                       input sob_parent,
                       input sob_feature,
                       input sob_part,
                       input sob_qty_iss)"}

            /* SWITCH BACK TO THE INVENTORY DOMAIN */
            {gprun.i ""gpmdas.p"" "(input ship_db, output err-flag)"}

            if err-flag = 2 or err-flag = 3 then do:
               /* DOMAIN # IS NOT AVAILABLE*/
               {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=ship_db}
               if c-application-mode <> "API" then
               pause.
               undo-select = true.
               undo, leave.
            end.
         end. /* if change_db */
      end. /* if available sob_det */
   end. /* if qty_left <> 0 */
end.
