 /*icintra.p - COMMON PROGRAM FOR MISC INVTY TRANSACTIONS CONTINUED         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.19 $                                       */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*              */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*              */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   By: jcd *G247*              */
/* REVISION: 7.3      LAST MODIFIED: 11/30/92   BY: pma *G366*              */
/* REVISION: 7.3      LAST MODIFIED: 03/20/93   BY: pma *G852*              */
/* REVISION: 7.4      LAST MODIFIED: 09/01/93   BY: dpm *H075*              */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM10*              */
/* REVISION: 7.3      LAST MODIFIED: 10/05/94   BY: pxd *FR90*              */
/* REVISION: 8.5      LAST MODIFIED: 11/02/94   BY: ktn *J038*              */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dpm *J044*              */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 04/26/95   BY: sxb *J04D*              */
/* REVISION: 8.5      LAST MODIFIED: 07/31/95   BY: taf *J053*              */
/* REVISION: 8.6      LAST MODIFIED: 10/19/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/15/97   BY: *K08N* Vinay Nayak-Sujir */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/27/00   BY: *N0W6* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.13     BY: Ellen Borden   DATE: 10/24/01  ECO: *P00G*         */
/* Revision: 1.15     BY: Patrick Rowan  DATE: 05/24/02  ECO: *P018*         */
/* Revision: 1.18     BY: Steve Nugent   DATE: 06/06/02  ECO: *P07Y*         */
/* $Revision: 1.19 $ BY: Patrick Rowan DATE: 06/21/02  ECO: *P08K* */
/* Revision: 1.19     BY: Patrick Rowan           DATE: 06/21/02  ECO: *P08K* */
/* Revision: 1.20     BY: Dorota Hohol            DATE: 02/25/03  ECO: *P0N6* */
/* Revision: 1.20.3.4 BY: Robin McCarthy          DATE: 03/10/04  ECO: *P15V* */
/* $Revision: 1.20.3.5 $ BY: Russ Witt               DATE: 01/28/04  ECO: *P1CZ* */
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*N014************************************************************************/
/*      SUB-ACCOUNT FIELD ADDED; WILL BE USED IN CONJUNCTION WITH ACCT AND   */
/*      COST CENTER.  SUB-ACCOUNT IS NO LONGER CONCATENATED TO ACCT AND IS A */
/*      SEPARATE 8 CHARACTER FIELD.                                          */
/*N014************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{cxcustom.i "ICINTRA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
/* ********** Begin Translatable Strings Definitions ********* */
&SCOPED-DEFINE icintra_p_1 "Effective"
/* MaxLen: Comment: */
&SCOPED-DEFINE icintra_p_2 "Conversion"
/* MaxLen: Comment: */
&SCOPED-DEFINE icintra_p_3 "Unit Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
define input parameter shipnbr    like tr_ship_id      no-undo.
define input parameter ship_date  like tr_ship_date    no-undo.
define input parameter inv_mov    like tr_ship_inv_mov no-undo.
define input parameter kbtransnbr as   integer         no-undo.
define input parameter i_addship  as   logical         no-undo.
define new shared variable  ec_ok as logical.

define shared variable transtype as character format "x(7)".
define shared variable ref like glt_ref.
define shared variable issrct as character format "x(3)".
define shared variable um like pt_um no-undo.
define shared variable conv like um_conv label {&icintra_p_2} no-undo.
define shared variable eff_date like glt_effdate label {&icintra_p_1}.
define shared variable trlot like tr_lot.
define shared variable unit_cost like tr_price label "Unit Cost".
define shared variable ordernbr like tr_nbr.
define shared variable orderline like tr_line.
define shared variable so_job like tr_so_job.
define shared variable addr like tr_addr.
define shared variable rmks like tr_rmks.
define shared variable dr_acct like trgl_dr_acct.
define shared variable dr_sub like trgl_dr_sub.
define shared variable dr_cc like trgl_dr_cc.
define shared variable cr_acct like trgl_cr_acct.
define shared variable cr_sub like trgl_cr_sub.
define shared variable cr_cc like trgl_cr_cc.
define shared variable project like wo_proj.
define shared variable lotserial_qty like sr_qty no-undo.
define shared variable site like sr_site no-undo.
define shared variable part like tr_part.
define  shared variable tr_recno as recid .

define variable trans-ok like mfc_logical.
define variable wonbr like lot_nbr.
define variable woline like lot_line.
define variable gl_tmp_amt as decimal no-undo.
define variable v_abs_recid as recid no-undo.
/* CONSIGNMENT VARIABLES. */
{socnvars.i}
define variable consign_inv_acct as character no-undo.
define variable consign_inv_sub as character no-undo.
define variable consign_inv_cc as character no-undo.
define variable consign_intrans_acct as character no-undo.
define variable consign_intrans_sub as character no-undo.
define variable consign_intrans_cc as character no-undo.
define variable consign_offset_acct as character no-undo.
define variable consign_offset_sub as character no-undo.
define variable consign_offset_cc as character no-undo.
define variable glcost as decimal             no-undo.
define variable assay  as character           no-undo.
define variable grade  as character           no-undo.
define variable expire as date                no-undo.
define variable io_first_time as logical initial yes no-undo.
define variable hold_trnbr like tr_trnbr      no-undo.
define variable l_rmks as character no-undo.
define variable io_batch like cnsu_batch no-undo.
define variable using_supplier_consignment as logical no-undo.
/* SHARED TEMP TABLES */
{icshmtdf.i "new" }
l_rmks = getTermLabel("CONSIGNED",12).
find first gl_ctrl no-lock.
find first clc_ctrl no-lock no-error.
if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl no-lock.
end.
/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}
/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input 'enable_supplier_consignment',
           input 11,
           input ADG,
           input 'cns_ctrl',
           output using_supplier_consignment)"}
/* Read item record */
find pt_mstr no-lock where pt_part = part no-error.
/* Clear shipper line item temp table */
if i_addship then do:
   {gprun.i  ""icshmt1c.p"" }
end.  /* if i_addship */
for each sr_wkfl exclusive-lock where sr_userid = mfguser:
   lotserial_qty = sr_qty * conv.
   if issrct = "ISS" then lotserial_qty = - lotserial_qty.
   wonbr  = "".
   woline = "".
   if (transtype = "RCT-PO" or transtype = "RCT-WO") then do:
      wonbr  = ordernbr.
      woline = sr_lineid.
   end.
   /* ADD RECORD TO LOT MASTER */
   if (clc_lotlevel <> 0) and (sr_lotser <> "") then do:
      {gprun.i ""gpiclt.p""
               "(input part,
           input sr_lotser,
           input wonbr,
           input woline,
                 output trans-ok)"}
      if not trans-ok then do:
         {pxmsg.i &MSGNUM=2740 &ERRORLEVEL=4 }
         /* CURRENT TRANSACTION REJECTED - */
         delete sr_wkfl.
         next.               /* CONTINUE WITH NEXT TRANSACTION */
      end.
   end. /* IF (CLC_LOTLEV <> 0) */
   /* Add to shipper line item temp table */
   if i_addship then do:
      {&ICINTRA-P-TAG1}
      {gprun.i ""icshmt1a.p""
               "(input part,
                 input sr_lotser,
                 input sr_ref,
                 input sr_site,
                 input sr_loc,
                 input sr_qty,
                 input um,
                 input conv,
                 input if available pt_mstr then pt_net_wt * sr_qty * conv
           else 0,
                 input if available pt_mstr then pt_net_wt_um
           else """",
                 input if available pt_mstr then pt_size * sr_qty * conv
           else 0,
                 input if available pt_mstr then pt_size_um
           else """" )" }

      {&ICINTRA-P-TAG2}
   end.  /* if i_addship */
end.  /* for each sr_wkfl */
/* Create or add to shipper */
if i_addship then do:
   {gprun.i ""icshmt.p""
            "(input site,
              input addr,
              input transtype,
              input eff_date,
        output v_abs_recid)" }
   /* Get associated shipper */
   find abs_mstr no-lock where recid(abs_mstr) = v_abs_recid
      no-error.
   if available abs_mstr then
   assign
      shipnbr   = substring(abs_id,2)
      ship_date = abs_shp_date
      inv_mov   = abs_inv_mov.
end.  /* if i_addship */
for each sr_wkfl no-lock where sr_userid = mfguser:
   lotserial_qty = sr_qty * conv.
   if issrct = "ISS" then lotserial_qty = - lotserial_qty.
   {&ICINTRA-P-TAG3}
   {ictrans.i
      &addrid=addr
      &bdnstd=0
      &cracct="
        if issrct = ""RCT"" then cr_acct
        else
        if available pld_det then pld_inv_acct
        else pl_inv_acct"
      &crsub="
        if issrct = ""RCT"" then cr_sub
        else
        if available pld_det then pld_inv_sub
        else pl_inv_sub"
      &crcc="
        if issrct = ""RCT"" then cr_cc
        else
        if available pld_det then pld_inv_cc
        else pl_inv_cc"
      &crproj=project
      &curr=""""
      &dracct="
        if issrct = ""ISS""  then dr_acct
        else
        if available pld_det then pld_inv_acct
        else pl_inv_acct"
      &drsub="
        if issrct = ""ISS""  then dr_sub
        else
        if available pld_det then pld_inv_sub
        else pl_inv_sub"
      &drcc="
        if issrct = ""ISS""  then dr_cc
        else
        if available pld_det then pld_inv_cc
        else pl_inv_cc"
      &drproj=project
      &effdate=eff_date
      &exrate=0
      &exrate2=0
      &exratetype=""""
      &exruseq=0
      &glamt="
        if available sct_det then sct_cst_tot * sr_qty * conv
        else 0"
      &kbtrans=kbtransnbr
      &lbrstd=0
      &line=orderline
      &location=sr_loc
      &lotnumber=trlot
      &lotref=sr_ref
      &lotserial=sr_lotser
      &mtlstd=0
      &ordernbr=ordernbr
      &ovhstd=0
      &part=part
      &perfdate=?
      &price="
        if available sct_det then sct_cst_tot
        else 0"
      &quantityreq=0
      &quantityshort=0
      &quantity=lotserial_qty
      &revision=""""
      &rmks=rmks
      &shiptype=""""
      &shipnbr=shipnbr
      &shipdate=ship_date
      &invmov=inv_mov
      &site=sr_site
      &slspsn1=""""
      &slspsn2=""""
      &sojob=so_job
      &substd=0
      &transtype=transtype
      &msg=0
      &ref_site=tr_site}
   tr_recno = recid(tr_hist).
   if using_cust_consignment and
   ((transtype = "RCT-UNP" and lotserial_qty > 0) or
   (transtype = "ISS-UNP" and lotserial_qty < 0))
   then do:
      consign_flag = no.
      {gprunmo.i &program = "socnsod1.p" &module = "ACN"
         ?m = """(input ordernbr,
                      input orderline,
                      output consign_flag,
                      output consign_loc,
                      output intrans_loc,
                      output max_aging_days,
                      output auto_replenish)"""}
      if consign_flag then do:
         /* DETERMINE CONSIGNMENT ACCOUNTS */
         if consign_inv_acct = "" then do:
            {gprunmo.i &program = "socnacct.p" &module = "ACN"
               ?m = """(input part,
                            input site,
                            input sr_loc,
                            output consign_inv_acct,
                            output consign_inv_sub,
                            output consign_inv_cc,
                            output consign_intrans_acct,
                            output consign_intrans_sub,
                            output consign_intrans_cc,
                            output consign_offset_acct,
                            output consign_offset_sub,
                                    output consign_offset_cc)"""}
         end.
         /*UPDATE THE RCT-UNP/ISS-UNP REMARK WITH "CONSIGNED"*/
         hold_trnbr = tr_hist.tr_trnbr.
         if rmks = "" then
            for first tr_hist exclusive-lock
               where tr_hist.tr_trnbr = hold_trnbr:
               tr_rmks = l_rmks.
            end.
         /* CREATE CN-SHIP TRANSACTION */
         /* PASS IN THE RCT_TRNBR TO ICXFER3, TO BE USED FOR REMARKS*/
         {gprunmo.i &program = "icxfer3.p" &module = "ACN"
            ?m = """(input trlot,
                         input sr_lotser,
                         input sr_ref,
                         input sr_ref,
                         input -1 * lotserial_qty,
                         input ordernbr,
                         input ordernbr,
                         input orderline,
                         input "''",
                         input project,
                         input eff_date,
                         input sr_site,
                         input sr_loc,
                         input sr_site,
                         input sr_loc,
                         input no,
                         input "''",
                         input eff_date,
                         input inv_mov,
                         input (if sr_loc = intrans_loc then
                         consign_intrans_acct
                         else
                         consign_inv_acct),
                         input (if sr_loc = intrans_loc then
                         consign_intrans_sub
                         else
                         consign_inv_sub),
                         input (if sr_loc = intrans_loc then
                         consign_intrans_cc
                         else
                         consign_inv_cc),
                         input consign_offset_acct,
                         input consign_offset_sub,
                         input consign_offset_cc,
                         input base_curr,
                         input (if available sct_det then sct_cst_tot
                         else 0),
                         input 0,
                         output glcost,
                         input-output hold_trnbr,
                         input-output assay,
                         input-output grade,
                         input-output expire)"""}
             /* CREATE CONSIGNMENT SHIPMENT-INVENTORY X-REF */
             /* PARAMETER io_first_time  gets passed  in as YES initially    */
             /* to & socncix.p. When io_first_time is YES, then socncix.p    */
             /* will create a new cross ref rec.  Once io_first_time    is   */
             /* NO, socncix.p will try to reuse the same cross refernce rec  */
             /* if all other key information is the same.                    */
         {gprunmo.i &program = "socncix.p" &module = "ACN"
                  ?m = """(input ordernbr,
                               input orderline,
                               input sr_site,
                               input eff_date,
                               input lotserial_qty,
                               input um,
                               input "''",
                               input hold_trnbr,
                               input sr_loc,
                               input sr_lotser,
                               input sr_ref,
                               input "''",
                               input so_job,
                               input "''",
                               input "''",
                               input "''",
                               input "''",
                               input "''",
                               input true,
                               input-output io_first_time)"""}
      end. /* if consign_flag*/
   end. /*if using_cust_consignment*/
   if using_supplier_consignment and
      (transtype = "RCT-UNP" or transtype = "ISS-UNP")
   then do:
      /* STD TRANSACTION QTY IS PROCESSED AS -lotserial_qty SO IT IS TREATED */
      /* AS A POSITIVE QTY IN ictrancn.p, IMPLYING lotserial_qty IS NEGATIVE */
      /* TO START WITH.  THEREFORE, IF lotserialqty > 0, IT IS A REVERSAL.   */
      {gprunmo.i &program = ""pocnsix4.p"" &module = "ACN"
        ?m   =  """(input part,
                        input sr_site,
                        input right-trim(substring(sr_lotser,1,18)),
                        input sr_ref,
                                 input (if lotserial_qty > 0 then true
                                        else false),
                        output consign_flag)"""}
      if consign_flag then do:
         /*UPDATE THE RCT-UNP/ISS-UNP REMARK WITH "CONSIGNED"*/
         hold_trnbr = tr_hist.tr_trnbr.
         if rmks = "" then
            for first tr_hist exclusive-lock
                 where tr_hist.tr_trnbr = hold_trnbr:
                 tr_rmks = l_rmks.
            end.
         {gprunmo.i &program = ""ictrancn.p"" &module  = "ACN"
                  ?m   =  """(input ordernbr,
                                  input '',
                                  input 0,
                                  input tr_so_job,
                                  input - lotserial_qty,
                                  input sr_lotser,
                                  input part,
                                  input sr_site,
                                  input sr_loc,
                                  input sr_ref,
                                  input eff_date,
                                  input tr_trnbr,
                                  input FALSE,
                                  input-output io_batch)"""}
      end. /* IF consign_flag */
   end. /*if using_supplier_consignment*/
end.
do transaction:
   for each sr_wkfl where sr_userid = mfguser exclusive-lock:
      delete sr_wkfl.
   end.
end.
      
