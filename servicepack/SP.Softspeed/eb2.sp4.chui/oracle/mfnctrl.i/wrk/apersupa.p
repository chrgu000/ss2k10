/* apersupa.p - Evaluated Receipts Processor */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.28.1.40 $                                               */
/* REVISION: 8.5       CREATED: 02/21/96     BY: *J0CV* Robert Wachowicz*/
/*               LAST MODIFIED: 04/18/96     BY: *J0JP* Andrew Wasilczuk*/
/*                              05/03/96     BY: *J0M2* Gary W. Morales */
/* REVISION: 8.5 LAST MODIFIED: 07/10/96     BY: *J0R8* Robert Wachowicz*/
/* REVISION: 8.6 LAST MODIFIED: 10/29/96     BY: *K01K* Barry J. Lass   */
/*   ORACLE PERFORMANCE FIX     11/19/96     BY: *H0PQ* Robin McCarthy  */
/* REVISION: 8.6 LAST MODIFIED  11/25/96     BY: *J17M* Cynthia J. Terry*/
/* REVISION: 8.6 LAST MODIFIED: 01/09/97     BY: *J1B1* Robin McCarthy  */
/*                              02/17/97     BY: *K01R* E. Hughart      */
/*                              03/04/97     BY: *J1J2* Brenda Milton   */
/*                              03/10/97     BY  *K084* Jeff Wootton    */
/*                              04/01/97     BY  *J1MH* Robin McCarthy  */
/* REVISION: 8.6 LAST MODIFIED: 09/03/97     BY: *J208* Samir Bavkar    */
/* REVISION: 8.6 LAST MODIFIED: 09/18/97     BY: *J213* Irine D'mello   */
/* REVISION: 8.6 LAST MODIFIED: 09/22/97     BY: *J21B* Irine D'mello   */
/* REVISION: 8.6 LAST MODIFIED: 10/08/97     BY: *K0JV* Surendra Kumar  */
/* REVISION: 8.6 LAST MODIFIED: 11/06/97     BY: *J25G* Irine D'mello   */
/* REVISION: 8.6 LAST MODIFIED: 11/14/97     BY: *J260* Irine D'mello   */
/* REVISION: 8.6 LAST MODIFIED: 12/15/97     BY: *J283* Irine D'mello   */
/* REVISION: 8.6E LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane       */
/* REVISION: 8.6E LAST MODIFIED: 02/23/98    BY: *J2GC* D. Tunstall     */
/* REVISION: 8.6E LAST MODIFIED: 05/09/98    BY: *L00Y* Jeff Wootton    */
/* Pre-86E commented code removed, view in archive revision 1.23        */
/* REVISION: 8.6E LAST MODIFIED: 07/23/98    BY: *L03K* Jeff Wootton    */
/* REVISION: 8.6E LAST MODIFIED: 08/21/98    BY: *J2X3* Prashanth Narayan */
/* REVISION: 8.6E LAST MODIFIED: 11/03/98    BY: *J335* Prashanth Narayan */
/* REVISION: 9.0  LAST MODIFIED: 03/10/99    BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0  LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0  LAST MODIFIED: 03/15/99    BY: *M0BG* Jeff Wootton      */
/* REVISION: 9.0  LAST MODIFIED: 05/05/99    BY: *J3F5* Hemali Desai      */
/* REVISION: 9.0  LAST MODIFIED: 06/01/99    BY: *J3G4* Abbas Hirkani     */
/* REVISION: 9.1  LAST MODIFIED: 09/08/99    BY: *J3L6* Jose Alex         */
/* REVISION: 9.1  LAST MODIFIED: 10/01/99    BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1  LAST MODIFIED: 11/01/99    BY: *N053* Jeff Wootton      */
/* REVISION: 9.1  LAST MODIFIED: 03/01/00    BY: *N03S* Jeff Wootton      */
/* REVISION: 9.1  LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1  LAST MODIFIED: 06/16/00    BY: *L0Z3* Shilpa Athalye    */
/* REVISION: 9.1  LAST MODIFIED: 08/11/00    BY: *N0KK* jyn               */
/* REVISION: 9.1  LAST MODIFIED: 09/27/00    BY: *J3Q9* Rajesh Lokre      */
/* REVISION: 9.1  LAST MODIFIED: 10/30/00    BY: *M0V8* Veena Lad         */
/* REVISION: 9.1  LAST MODIFIED: 09/23/00    BY: *N0W0* BalbeerS Rajput   */
/* Revision: 1.28.1.21    BY: Katie Hilbert  DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.28.1.22    BY: Katie Hilbert  DATE: 04/06/01  ECO: *P008*  */
/* Revision: 1.28.1.23    BY: Alok Thacker   DATE: 06/28/01  ECO: *M1C3*  */
/* Revision: 1.28.1.24    BY: Jean Miller    DATE: 12/13/01  ECO: *P03Q*  */
/* Revision: 1.28.1.26    BY: Patrick Rowan  DATE: 04/17/02  ECO: *P043*  */
/* Revision: 1.28.1.28    BY: Paul Donnelly  DATE: 12/24/01  ECO: *N16J*  */
/* Revision: 1.28.1.30    BY: Patrick Rowan  DATE: 04/30/02  ECO: *P05Q*  */
/* Revision: 1.28.1.36    BY: Amit Chaturvedi DATE: 05/22/02 ECO: *M1YG* */
/* Revision: 1.28.1.38    BY: Patrick Rowan DATE: 05/24/02  ECO: *P018* */
/* $Revision: 1.28.1.40 $ BY: Patrick Rowan DATE: 06/17/02  ECO: *P091* */
/*V8:ConvertMode=Report                                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*! --------------------------------------------------------------------------*
 * Version 8.6F Program Structure (of significant programs only):-
 *
 *  apersup.p          ERS Processor, menu 28.10.13, report selection
 *    apersupa.p       Main processing logic
 *      apvobidf.i     Define before-image for vod_det and vph_hist
 *      apvoprdf.i     Define prh_inv_qty temp-table
 *      apersup1.i     Validate account, cc, exchange, rounding
 *      apersup2.i     Determine price
 *I       gpsct05.p
 *I     apersupb.p     Determine costing method
 *      apvomta4.p     Backout and create voucher receipt details (but not GL)
 *        apvomta3.p   Determine accounts for variances
 *          apvotax.i  Inventory cost tax calculation
 *I         apvomtac.p Determine accounts for variances
 *      apvomti.p      Create vod_det tax lines and display (if recreate taxes)
 *I       apvomti0.p   Get QOH and costing method
 *      apvomtk.p        Process GL and Cost impact (after update)
 *        apvobidf.i     Define before-image for vod_det and vph_hist
 *        apvomtk1.p     Reverse previous Item Cost Update
 *          apvobidf.i   Define before-image for vod_det and vph_hist
 *I         apvomtka.p   Reverse previous Item Cost Update
 *            ictrans.i  Create Inventory transactions
 *I           nrm.p      New instance of NRM on inventory database
 *I           apvoglu1.p GL transactions for confirmed cost adjustments
 *I         apvoglu1.p   GL transactions for confirmed cost adjustments
 *        apapgl3.p      Reverse of apapgl.p
 *          apvobidf.i   Define before-image for vod_det and vph_hist
 *          apglpl.p     procedure apgl-create-all-glt
 *        apapgl.p       Create GL transactions
 *          apglpl.p     procedure apgl-create-all-glt
 *                       (also run by aprvvo.p, apvoco.p, apvoco01.p)
 *            gpglpl.p   procedure gpgl-convert-to-account-currency
 *            gpglpl.p   procedure gpgl-create-one-glt
 *        apvomtk3.p     Loop through vph and prh, run apvocsu1.p
 *          apvocsu1.p   Update Item Cost, create tr_hist and trgl_det
 *                       (also run from apvoco.p and apvoco01.p)
 *            apvotax.i  Inventory cost tax calculation
 *I           apvocsua.p Update Item Cost, create tr_hist and trgl_det
 *I           nrm.p      New instance of NRM on inventory database
 *I           apvoglu1.p GL transactions for confirmed cost adjustments
 *          apvoglu1.p   GL transactions for confirmed cost adjustments
 *        apvopru1.p     Store prh_inv_qty's in temp-table
 *          apvoprdf.i   Define prh_inv_qty temp-table
 *          apvopru2.p   Store one prh_inv_qty in temp-table
 *            apvoprdf.i Define prh_inv_qty temp-table
 *I         apvopru3.p   Update prh_inv_qty's on inventory databases
 *            apvoprdf.i Define prh_inv_qty temp-table
 *      apvomtd.p        Set Batch status
 *      apersup4.p       If audit report
 *
 *I = runs connected to inventory site database
 *----------------------------------------------------------------------------*
*/

{mfdeclre.i}
{cxcustom.i "APERSUPA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{gldydef.i}
{gldynrm.i}

/*INPUT SCREEN VARIABLES*/
define input parameter vend     as character.
define input parameter vend1    as character.
define input parameter site     as character.
define input parameter site1    as character.
define input parameter recvr    as character.
define input parameter recvr1   as character.
define input parameter recdate  as date.
define input parameter recdate1 as date.
define input parameter aud_rpt  as logical.
define input parameter vouch    as logical.

{txcalvar.i}
{apconsdf.i}

/*FOR POERS.P*/
define variable ersnbr  like ers_mstr.ers_opt no-undo.
define variable ersplo  like ers_mstr.ers_pr_lst_tp no-undo.
define variable error_code as integer no-undo.

/*FOR USE WITH GPGLEF01.I*/
define variable gl_trans_type as character no-undo.
define variable gl_trans_ent  as character no-undo.
define variable gl_effdt_date as date no-undo.
define variable gpglef        like msg_nbr no-undo.
define variable glvalid       as logical no-undo.

/*FOR USE WITH PRICE LIST LOOKUP*/
define variable price_list2 as character no-undo.
define variable new_pod     as logical initial yes no-undo.
define variable list_price  like prh_pur_cost.
define variable net_price   as decimal.
define variable minprice    as decimal.
define variable maxprice    as decimal.
define variable disc_pct    as decimal.
define variable pc_recno    as recid.

/*USED IF CURR_AMT = 0*/
define variable err_flag    as integer no-undo.

/*USED WHEN TEMP TABLE IS BUILT*/
define variable proc_rec  as logical.
define variable getref    as logical initial true.
define variable inbatch   as character.
define variable module    as character.
define variable doc_type  as character.
define variable bactrl    as integer.
define variable apref     as character.
define variable redu      as logical.
define variable disc_date as date.
define variable due_date  as date.

define new shared variable batch like ap_batch.
define new shared variable gtmconv     like  mfc_logical initial false
    no-undo.

/*USED FOR SITE USER AUTHORIZATION (GPSIRVR.P) */
define variable authorized as integer no-undo.

define variable effective_date as date no-undo.
define variable voucher_date as date no-undo.

define variable apentity like ap_entity no-undo.
define variable po_recid as recid.
define variable work_amt like ap_amt no-undo.

/* FOR MCPL.P PROCEDURES */
define variable mc-error-number like msg_nbr no-undo.

define variable l_valid_rcvr    like mfc_logical no-undo.

define buffer phist   for prh_hist.
define buffer prhhist for prh_hist.
define buffer pvomstr for pvo_mstr.
define buffer pmstr   for pvo_mstr.

{apersupa.i "new"}  /* Define valid_prh Temp-Table */

define variable extend_cost as decimal label "Extended Cost".

/*THE FOLLOWING ARE FOR APVOMTI.P*/
define new shared variable undo_txdist like mfc_logical.
define new shared variable base_det_amt like glt_amt.
define new shared variable base_amt like ap_amt.
define new shared variable curr_amt like vph_curr_amt.
define new shared variable vod_recno as recid.
define new shared variable undo_all like mfc_logical.
define new shared variable jrnl like glt_ref.
define new shared variable recalc_tax like mfc_logical initial true.
define new shared variable no_taxrecs like mfc_logical.
define new shared variable ap_recno as recid.
define new shared variable vo_recno as recid.
define new shared variable vd_recno as recid.
define new shared variable ba_recno as recid.
define new shared variable tax_tr_type like tx2d_tr_type initial "22".
define new shared variable aptotal  like ap_amt.
define new shared variable tax_flag like mfc_logical.
define new shared variable vod_amt_fmt as character.
define new shared frame c.
define new shared frame tax_dist.

/*SHARED VARIABLES FOR CURRENCY DEPENDENT ROUNDING*/
define new shared variable rndmthd like rnd_rnd_mthd.
{apcurvar.i "new"}

define variable l_ex_rate     like po_ex_rate     no-undo.
define variable l_ex_rate2    like po_ex_rate2    no-undo.
define variable l_exru_seq    like po_exru_seq    no-undo.
define variable l_ex_ratetype like po_ex_ratetype no-undo.

/*DEFINED FOR APVOMTA4.P*/
define new shared variable totinvdiff like ap_amt.
define new shared variable fill-all   like mfc_logical label "Vchr All".
define new shared variable new_vchr   like mfc_logical.
define new shared variable rcvd_open  like prh_rcvd.

/*DEFINE VARIABLES FOR ERROR REPORT*/
define variable po       like po_nbr no-undo.
define variable receiver like prh_receiver no-undo.
define variable line     like prh_line no-undo.
define variable msg1 as character format "x(75)" no-undo.
define shared stream rport.
define variable prhline_err_stat as logical.

/*FOR GL COSTING*/
define variable glx_mthd like cs_method.
define variable cur_mthd like cs_method.

/* DEFINE VARIABLES FOR DATABASE SWITCHING FOR APERSUPB.P */
define variable old_db              like si_db no-undo.
define new shared variable new_site like si_site.
define new shared variable new_db   like si_db.

/* DEFINE 'BEFORE IMAGE' WORKFILES */
{apvobidf.i "new"}

/* DEFINE PRH_HIST UPDATE TEMP-TABLE */
{apvoprdf.i "new"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

{&APERSUPA-P-TAG1}

/*DEFINE ERROR REPORT HEADER AND BODY*/

form
   po       at 3  label "PO"
   receiver at 16 label "Receiver"
   line     at 29 label "Line"
   msg1     at 34 label "Message"
with frame error width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame error:handle).

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

/*IF A SITE CANNOT BE ACCESSED BY A USER AN ERROR IS GENERATED*/

if authorized = 0 then do:
   for each si_mstr where si_site >= site
         and si_site <= site1
   no-lock:

      {gprun.i ""gpsiver.p"" "(input si_site,
                               input recid(si_mstr),
                               output authorized)"}
      if authorized = 0 then do:
         /*USER NOT AUTHORIZED FOR SITE*/
         {pxmsg.i &MSGNUM=2328 &ERRORLEVEL=4 &MSGBUFFER=msg1}
         display stream rport (msg1 + si_site) @ msg1
         with frame error down.
         down with frame error.
      end.
   end. /*FOR EACH SI_MSTR*/
end. /*AUTHORIZED = 0*/

/*GET CONTROL RECORDS*/
find first apc_ctrl no-lock no-error.
find first gl_ctrl  no-lock no-error.
find first poc_ctrl no-lock no-error.

mainloop:
for each pvo_mstr where (pvo_mstr.pvo_ers_status = 0
                     or  pvo_mstr.pvo_ers_status = 1)
     and pvo_mstr.pvo_lc_charge = ""
     and pvo_mstr.pvo_internal_ref_type = {&TYPE_POReceiver}
     and (pvo_mstr.pvo_internal_ref >= recvr
     and  pvo_mstr.pvo_internal_ref <= recvr1)
     and (pvo_mstr.pvo_shipto >= site
     and  pvo_mstr.pvo_shipto <= site1)
     and (pvo_mstr.pvo_supplier >= vend
     and  pvo_mstr.pvo_supplier <= vend1)
     and (pvo_mstr.pvo_trans_date >= recdate
     and  pvo_mstr.pvo_trans_date <= recdate1)
no-lock break by pvo_mstr.pvo_internal_ref:

   if first-of(pvo_mstr.pvo_internal_ref) then do:

      assign
         l_valid_rcvr = yes.


        find first pvomstr where
            pvomstr.pvo_lc_charge         = ""       and
            pvomstr.pvo_internal_ref_type = {&TYPE_POReceiver} and
            pvomstr.pvo_internal_ref = pvo_mstr.pvo_internal_ref  and
            pvomstr.pvo_external_ref = pvo_mstr.pvo_external_ref
            exclusive-lock no-error no-wait.

        if locked(pvomstr) then do:
         next mainloop.
      end.
      else do:
         proc_rec = true.  /*RESET PROCESS RECEIVER FLAG TO YES*/

         loopc:
         for each pvomstr where
             pvomstr.pvo_lc_charge         = ""       and
             pvomstr.pvo_internal_ref_type = {&TYPE_POReceiver} and
             pvomstr.pvo_internal_ref = pvo_mstr.pvo_internal_ref and
             pvomstr.pvo_external_ref = pvo_mstr.pvo_external_ref
         exclusive-lock break by pvomstr.pvo_internal_ref:

           if pvomstr.pvo_order = "" then do:
              pvomstr.pvo_ers_status = 3.
               next loopc.
            end. /*INVALID PRH NBR*/
            else do:
               loopc1:
               do on error undo loopc1, retry loopc1:

                  curr_amt = 0.

                  prhline_err_stat = false.

                  /*LOCATE RECEIVER */
                  for first prhhist
                      where prhhist.prh_receiver =
                            pvomstr.pvo_internal_ref
                         and prhhist.prh_line =
                            pvomstr.pvo_line
                      no-lock:
                  end.

                  /*CHECK DATABASE*/
                  find pod_det where pod_nbr  = prhhist.prh_nbr
                     and pod_line = prhhist.prh_line
                     no-lock no-error.
                  if available pod_det then do:
                     if pod_po_db <> global_db or pod_ers_opt = 1
                     then do:
                        {apnoers.i}
                     end. /*INVALID DB OR ERS IS OFF*/
                  end. /*AVAILABLE LINE ITEM*/

                  /* FIND MATCHING PO_MSTR */
                  find po_mstr where po_nbr = prhhist.prh_nbr
                     no-lock no-error.
                  if not available po_mstr then do:
                     if first-of(pvomstr.pvo_internal_ref) then do:
                        /*PO DOES NOT EXIST*/
                        {pxmsg.i &MSGNUM=2330 &ERRORLEVEL=4 &MSGBUFFER=msg1}
                        display stream rport {aperserr.i}
                           (msg1 + prhhist.prh_nbr) @ msg1
                        with frame error down.
                        down with frame error.
                     end.
                     {apnoers.i}
                  end. /*NOT AVAILABLE PO_MSTR*/

                  po_recid = recid(po_mstr).

                  /*CHECK ON LINE ITEM AVAILABILITY*/
                  /*NOTE: LINE ITEM WAS LOOKED FOR IN "CHECK DBASE"*/
                  /*THIS WAS PUT HERE SO MULTIPLE ERROR MESSAGES
                  WOULDN'T APPEAR IF THE PO WASN'T FOUND FIRST*/
                  if not available pod_det then do:
                     /*PO LINE NOT FOUND*/
                     {pxmsg.i &MSGNUM=2329 &ERRORLEVEL=4 &MSGBUFFER=msg1}
                     display stream rport {aperserr.i}
                        (msg1 + string(prhhist.prh_line)) @ msg1
                     with frame error down.
                     down with frame error.
                     {apnoers.i}
                  end. /*NOT AVAILABLE LINE ITEM*/

                  /*TEST THE LINE ITEM ERS OPTION*/
                  if (pod_ers_opt = 0 or pod_pr_lst_tp = 0) then do:
                     {gprun.i ""poers.p"" "(input prhhist.prh_vend,
                                            input prhhist.prh_site,
                                            input prhhist.prh_part,
                                            output ersnbr,
                                            output ersplo,
                                            output error_code)"}
                     if error_code <> 0 then do:
                        prhline_err_stat = true.
                        display stream rport {aperserr.i}
                        with frame error down.
                        if error_code = 3 then do:
                           /*SITE & SUPPLIER ERS MASTER MISSING*/
                           {pxmsg.i &MSGNUM=2301 &ERRORLEVEL=4 &MSGBUFFER=msg1}
                           display stream rport
                              (msg1 + " (" + prhhist.prh_site + "/" +
                              prhhist.prh_vend + ")") @ msg1
                           with frame error down.
                        end.
                        else if error_code = 2 then do:
                           /*SUPPLIER ERS MASTER MISSING*/
                           {pxmsg.i &MSGNUM=2309 &ERRORLEVEL=4 &MSGBUFFER=msg1}
                           display stream rport
                              (msg1 + prhhist.prh_vend) @ msg1
                           with frame error down.
                        end.
                        else if error_code = 1 then do:
                           /*SITE ERS MASTER MISSING*/
                           {pxmsg.i &MSGNUM=2311 &ERRORLEVEL=4 &MSGBUFFER=msg1}
                           display stream rport
                              (msg1 + prhhist.prh_site) @ msg1
                           with frame error down.
                        end.
                     end. /*ERROR_CODE <> 0 */
                     down with frame error.
                  end. /*POD ERS = 0*/

                  /*SAVE ERSNBR FOR TEMP TABLE*/
                  if pod_ers_opt <> 0 then ersnbr = pod_ers_opt.
                  if pod_pr_lst_tp <> 0 then ersplo = pod_pr_lst_tp.

                  if (error_code = 0 and ersnbr = 1) then do:
                     {apnoers.i}
                  end. /*POD ERS OFF*/

                  /* FIND PRE-EXISTING VOUCHER HISTORY */
                  /* ****  ONLY IF NOT CONSIGNED ****  */
                  if not pvomstr.pvo_consignment then do:
                     for first vph_hist
                        fields(vph_pvo_id vph_ref)
                        where
                        vph_ref = pvomstr.pvo_last_voucher and
                        vph_pvo_id = pvomstr.pvo_id and
                        vph_pvod_id_line = 0
                        no-lock:
                        /*VOUCHER ALREADY EXISTS FOR THIS RECEIVER AND PO LINE*/
                        {pxmsg.i &MSGNUM=2331 &ERRORLEVEL=4 &MSGBUFFER=msg1}
                        display stream rport {aperserr.i}
                           (msg1 + vph_ref) @ msg1
                           with frame error down.
                           down with frame error.
                           {apnoers.i}
                     end. /*FOR FIRST PVO_MSTR*/
                  end. /*NOT CONSIGNED */

                  run check_inv_database.
                  /*CHECK IF PACK SLIP REQUIRED*/
                  if apc_ers_ps_err = yes and prhhist.prh_ps_nbr = ""
                     and prhhist.prh_rcp_type <> "R"
                  then do:
                     /*PACKING SLIP REQUIRED*/
                     {pxmsg.i &MSGNUM=2344 &ERRORLEVEL=4 &MSGBUFFER=msg1}
                     display stream rport {aperserr.i}
                        msg1 with frame error down.
                     down with frame error.
                     prhline_err_stat = true.
                  end. /*PACK SLIP REQUIRED*/

                  /* IF THE TRANSACTION CURRENCY IS NOT BASE    */
                  /* AND THE FIXED RATE FLAG IS NO, GET THE     */
                  /* CURRENT EXCHANGE RATE, ELSE USE THE PO     */
                  /* EXCHANGE RATE.                             */

                  /* GET CURRENT EXCHANGE RATE IRRESPECTIVE OF  */
                  /* THE FIXED RATE FLAG SETTING TO KEEP        */
                  /* CONSISTENCY WITH VOUCHER MAINTENANCE       */

                  if po_curr <> base_curr
                  then do:
                     /* GET CURRENT EXCHANGE RATE, CREATE USAGE */
                     run p-get-rate.
                     assign
                        l_ex_ratetype = "".
                  end. /* IF po_curr <> base_curr ... */
                  else
                     assign
                     l_ex_rate     = po_ex_rate
                     l_ex_rate2    = po_ex_rate2
                     l_exru_seq    = po_exru_seq
                     l_ex_ratetype = po_ex_ratetype.

                  /*THIS INCLUDE RUNS ON THE FIRST RECEIVER RECORD*/
                  /*VALIDATION FOR SUPPLIER, GL EFF DATE, ACCTS, CC, ETC*/
                  if l_valid_rcvr then do:
                     assign
                        l_valid_rcvr = no.
                     {apersup1.i}
                  end. /* IF L_VALID_RCVR = YES*/

                  /*THIS INCLUDE VALIDATES DATES, PRICE AND CURRENCY*/
                  {apersup2.i}

                  /*BUILD TEMP FILE*/
                  if prhline_err_stat = true then do:
                     proc_rec = no.
                     pvomstr.pvo_ers_status = 1.
                     if last-of(pvomstr.pvo_internal_ref) then
                        leave loopc1.
                     else
                        next loopc.
                  end. /*ERRORS FOUND*/
                  else do:
                     create valid_prh.

                     run build_temp_table.

                  end. /*BUILD TEMP FILE*/
               end. /*END LOOPC1*/

               if last-of(pvomstr.pvo_internal_ref) then do:

                  if not proc_rec then do:
                     for each valid_prh where
                        prhreceiver = pvomstr.pvo_internal_ref
                     exclusive-lock:
                        delete valid_prh.
                     end. /*FOR EACH VALID_PRH*/
                     next mainloop.
                  end. /*NOT PROC RECEIVER*/

                  /* First voucher - get journal ref and batch id */
                  if getref and vouch then do:

                     /* Batch ID */
                     assign
                        inbatch = ""
                        module = "AP"
                        doc_type = "VO"
                        bactrl = 0.

                     {gprun.i ""gpgetbat.p""
                        "(input  inbatch,
                          input  module,
                          input  doc_type,
                          input  bactrl,
                          output ba_recno,
                          output batch)"}
                     getref = false.
                  end. /*GETREF AND VOUCH*/

                  if vouch then do:
                     for each valid_prh
                           where prhreceiver = prhhist.prh_receiver
                           break by prhersopt:
                        if first-of (prhersopt) then do:

                           /*GET VOUCHER REFERENCE*/
                           {&APERSUPA-P-TAG2}
                           {mfnctrl.i apc_ctrl apc_voucher vo_mstr
                              vo_ref apref}
                           loopd:
                           repeat:
                              redu = false.

                              for each bk_mstr
                                 where bk_code >= ""
                              no-lock:

                                 if bk_code = substring(apref,1,2)
                                 then do:
                                    /* A NEW VOUCHER NUMBER MUST BE FOUND AND
                                     * THE FIRST 2 DIGITS CANNOT CONFLICT WITH
                                     * A BANK CODE.  SINCE MFNCTRL.I ONLY
                                     * INCREASES THE REFERENCE NUMBER BY 1, THE
                                     * SYSTEM COULD BE BROUGHT TO A HALT IF
                                     * THE APC_VOUCHER NUMBER WAS SIX OR MORE
                                     * DIGITS LONG.  THEREFORE THE FIRST 2
                                     * DIGITS WILL BE INCREMENTED BY 1 THEN
                                     * MFNCTRL.I WILL BE RUN TO FIND A USABLE
                                     * NUMBER.  THIS PROCESS WILL BE REPEATED
                                     * FOR THE AP_MSTR LATER*/
                                    find first apc_ctrl exclusive-lock.
                                    if apc_voucher >= 99000000 then
                                       apc_voucher = 1.
                                    apc_voucher =
                                    integer(string(integer
                                       (substring(
                                       string(apc_voucher),1,2)) + 1)
                                       + substring(string(apc_voucher),3)).
                                    release apc_ctrl.
                                    {mfnctrl.i apc_ctrl apc_voucher vo_mstr
                                       vo_ref apref}
                                    redu = true.
                                 end. /*BANK CODE = APREF*/
                              end. /*FOR EACH BK_MSTR*/

                              /*VALIDATE VCHR REF DOESN'T EXIST */
                              /*FOR OTHER TYPES */
                              loopf:
                              repeat:
                                 find ap_mstr where ap_ref = apref
                                    and ap_type  = "RV"
                                    no-lock no-error.
                                 if available ap_mstr then do:
                                    find first apc_ctrl exclusive-lock.
                                    if apc_voucher >= 99000000 then
                                       apc_voucher = 1.
                                    apc_voucher = integer(string(integer(
                                       substring
                                       (string(apc_voucher),1,2)) + 1) +
                                       substring(string(apc_voucher),3)).
                                    release apc_ctrl.
                                    {mfnctrl.i apc_ctrl apc_voucher
                                       vo_mstr vo_ref apref}
                                    redu = true.
                                 end. /*MATCHING VOUCHER REF*/
                                 else do:
                                    redu = false.
                                    leave loopf.
                                 end.
                              end. /*LOOPF*/
                              if not redu then leave loopd.
                           end. /*LOOPD*/
                           {&APERSUPA-P-TAG3}

                           find vd_mstr where recid(vd_mstr) = vd_recno
                              no-lock.
                           find po_mstr where recid(po_mstr) = po_recid
                              no-lock.

                           {gprun.i ""gldydft.p""
                              "(input ""AP"",
                                input ""VO"",
                                input apentity,
                                output dft-daybook,
                                output daybook-desc)"}

                           /*CREATE AP_MSTR*/
                           create ap_mstr.

                           run build_ap_mstr.

                           /* CHANGED INPUT PARAMETER           */
                           /* FROM po_exru_seq TO l_exru_seq    */
                           /* COPY EXCHANGE RATE USAGE          */
                           {gprunp.i "mcpl" "p"
                              "mc-copy-ex-rate-usage"
                              "(input  l_exru_seq,
                                output ap_exru_seq)"}

                           /*CREATE VPO_DET*/
                           create vpo_det.
                           assign
                              vpo_po  = po_nbr
                              vpo_ref = ap_ref.

                           /*CALCULATE DISCOUNT AND DUE DATE*/
                           {&APERSUPA-P-TAG4}
                           assign
                              disc_date = ?
                              due_date  = ?.
                           {&APERSUPA-P-TAG5}
                           {&APERSUPA-P-TAG6}

                           /* CHECK WHETHER MULTIPLE DUE DATES   */
                           /* CREDIT TERMS                       */
                           for first ct_mstr
                           fields (ct_base_date ct_base_days ct_code
                                   ct_dating ct_disc_date ct_disc_days
                                   ct_disc_pct ct_due_date ct_due_days
                                   ct_due_inv ct_from_inv ct_min_days)
                              where ct_code = po_cr_terms
                           no-lock: end.

                           if not available ct_mstr or ct_dating = no
                           then do:
                              {gprun.i ""adctrms.p""
                                 "(input  ap_date,
                                   input  po_cr_terms,
                                   output disc_date,
                                   output due_date)"}
                           end. /* IF NOT AVAILABLE ct_mstr */
                           else do:
                              /* IF MULTIPLE DUE DATES CREDIT TERMS, */
                              /* CALCULATE DATES USING THE LAST      */
                              /* CREDIT TERMS RECORD                 */

                              for last ctd_det
                              fields (ctd_code ctd_date_cd)
                                 where ctd_code = po_cr_terms
                              no-lock: end.
                              if available ctd_det then do:
                                 {gprun.i ""adctrms.p""
                                    "(input  ap_date,
                                      input  ctd_date_cd,
                                      output disc_date,
                                      output due_date)"}
                              end. /* IF AVAILABLE ctd_det */
                           end. /* IF AVAILABLE ct_mstr and ... */

                           /*CREATE VO_MSTR*/
                           create vo_mstr.

                           run build_vo_mstr.

                           /* COPY EXCHANGE RATE USAGE           */
                           {gprunp.i "mcpl" "p"
                              "mc-copy-ex-rate-usage"
                              "(input  l_exru_seq,
                                output vo_exru_seq)"}

                           assign
                              ap_recno = recid(ap_mstr)
                              vo_recno = recid(vo_mstr).

                           run ip_curr_err
                              (buffer ap_mstr,
                               input  vo_curr,
                               input  vd_pay_spec).

                           /* CHECK SUPPLIER BANK EXISTS AND POPULATE */
                           /* THE FIELD vo__qad02                     */
                           for first csbd_det
                           fields (csbd_bank)
                                 where csbd_addr = ap_vend
                                 and csbd_beg_date <= ap_effdate
                                 and csbd_end_date >= ap_effdate
                           no-lock :
                              vo__qad02 = csbd_bank.
                           end.

                           /* IF CHECK FORM IS 3 OR 4 AND NO SUPPLIER */
                           /* BANK EXISTS ISSUE WARNING MESSAGE       */
                           run ip_chk_suppbank
                              (input vo__qad02,
                               input ap_ckfrm).

                        end. /*FIRST-OF PRHERSOPT*/
                        else do:
                           find ap_mstr where recid(ap_mstr) =
                              ap_recno exclusive-lock.
                           find vo_mstr where recid(vo_mstr) =
                              vo_recno no-lock.
                        end. /*end else do*/

                        /*CREATE VPH HIST RECORDS*/
                        create vph_hist.

                        run build_vph_hist.
                        if recid(vph_hist) = -1 then .

                        run convert-and-round-proc.

                        /*ASSIGN AP REF NUMBER TO TEMP FILE RECORDS*/
                        prhref = vo_mstr.vo_ref.

                        run updatePendingVoucherQuantity
                           (input prhreceiver,
                            input prhline,
                            input prhconref,
                            input prhref,
                            input vph_inv_qty).

                        /* GET COSTING METHOD FROM INVTY DATABASE */
                        assign
                           old_db = global_db
                           new_site = prhsite.
                        {gprun.i ""gpalias.p""}
                        {gprun.i ""apersupb.p""
                           "(input prhpart,
                             input prhsite,
                             output glx_mthd,
                             output cur_mthd)"}

                        new_db = old_db.
                        {gprun.i ""gpaliasd.p""}

                        for first apc_ctrl
                        fields (apc_gl_avg_cst)
                        no-lock:
                           if prhtype  = ""      and
                              glx_mthd = "avg"   and
                              vo_confirmed       and
                              apc_gl_avg_cst
                           then
                              vph_adj_inv = true.
                        end. /* FOR FIRST APC_CTRL ... */

                     end. /*FOR EACH VALID_PRH*/

                     /*CREATE VOD_DET FOR TAXES*/

                     /*SET OUTPUT TO NULL SO NOTHING IS DISPLAYED*/
                     if opsys = "unix" then
                     output to
                        "/dev/null".
                     else
                     if opsys = "msdos" or opsys = "win32"
                        then output to "nul".
                     else
                     if opsys = "vms"  then
                        output to "nl:".
                     else
                     if opsys = "btos" then
                        output  to "[nul]".

                     /*DEFINE SHARED FRAME FORMS FOR APVOMTI EVEN */
                     /*THOUGH THEY'RE NOT USED, THEY MUST BE DEFINED*/
                     {apvofmc.i}
                     {apvofmtx.i}

                     /* NOTE THESE FORMATS ARE NOT ACTUALLY USED UNTIL */
                     /* CALLED PGM APVOMTI.P (WITHIN REPEAT LOOP TXEDITCALC) */
                     assign
                        vod_amt_fmt = vod_amt:format in frame tax_dist
                        ap_amt_fmt  = ap_amt:format in frame c.

                     find first apc_ctrl no-lock no-error.

                     /*CREATE VOD_DET LINES */
                     {gprun.i ""apvomta4.p""}

                     /* INPUT PARAMETER VQ-POST  THE POST FLAG IS SET        */
                     /* TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER */
                     /* RECORDS FROM THIS CALL TO TXCALC.P */
                     {gprun.i ""txcalc.p""
                        "(input  tax_tr_type,
                          input  vo_ref,
                          input  "" "",
                          input  0 /*ALL LINES*/,
                          input no,
                          output result-status)"}
                     {gprun.i ""apvomti.p""}

                     output close.

                     {&APERSUPA-P-TAG9}
                     {gprun.i ""apvomtk.p"" "(1)"}
                     {&APERSUPA-P-TAG10}

                     /*ADD TAX*/
                     for each vod_det where vod_det.vod_ref = vo_ref
                           and (vod_det.vod_tax <> ""
                           and vod_det.vod_tax <> "n"
                           and vod_det.vod_tax <> "no"
                           and vod_det.vod_tax <> "t")
                     no-lock:
                        ap_amt = ap_amt + vod_det.vod_amt.
                        ap_base_amt = ap_base_amt + vod_det.vod_base_amt.
                     end.
                     {&APERSUPA-P-TAG11}

                     /* UPDATE ba_mstr */
                     find ba_mstr where ba_module = "AP"
                        and ba_batch  = batch
                        exclusive-lock no-error.
                     if available ba_mstr then
                     assign ba_ctrl  = ba_ctrl  + ap_amt
                        ba_total = ba_total + ap_amt.

                     /*ADJUST VENDOR BALANCE*/
                     if vo_confirmed then do:
                        find vd_mstr where recid(vd_mstr) = vd_recno
                           exclusive-lock no-error.
                        vd_balance = vd_balance + ap_amt.
                     end.

                  end. /*IF CREATE VOUCH*/
               end. /*LAST OF  RECEIVER*/

            end. /*ELSE DO PROCESS RECEIVER*/
         end. /*FOR EACH PRHHIST*/
      end. /*IF NOT LOCKED*/
   end. /*IF FIRST OF*/
end. /*MAINLOOP*/

/* CHECK & UPDATE BATCH STATUS */
{gprun.i ""apvomtd.p""}

/*IF AUDIT REPORT IS TO BE PRINTED*/
if aud_rpt then do:
   {gprun.i ""apersup4.p"" "(input batch)"}
end. /*IF AUD_RPT*/

{&APERSUPA-P-TAG7}
PROCEDURE convert-and-round-proc:

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input valid_prh.prhcurr,
        input base_curr,
        input prhexrate,
        input prhexrate2,
        input prhcurramt,
        input false, /* DO NOT ROUND */
        output vph_hist.vph_inv_cost,
        output mc-error-number)"}

   /* GET AP CURRENCY ROUNDING METHOD */
   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
      "(input ap_mstr.ap_curr,
        output rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   work_amt = vph_inv_qty * vph_curr_amt.

   /* ROUND THE AMOUNT */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output work_amt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   ap_mstr.ap_amt = ap_mstr.ap_amt + work_amt.

   /* CONVERT FROM FOREIGN */
   /* TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input ap_curr,
        input base_curr,
        input ap_ex_rate,
        input ap_ex_rate2,
        input work_amt,
        input true, /* ROUND */
        output work_amt,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   ap_base_amt = ap_base_amt + work_amt.
END PROCEDURE.

PROCEDURE check_inv_database:
   define variable msg_indx as integer.
   /* CHECK IF INVENTORY DATABASE CONNECTED */
   if global_db <> "" then do:
      for first si_mstr
            fields(si_db)
            where si_site = pod_det.pod_site
            no-lock:
         if not connected(si_db) then do:
            /* DATABASE # NOT AVAILABLE */
            {pxmsg.i &MSGNUM=2510 &ERRORLEVEL=4 &MSGBUFFER=msg1}
            msg_indx = index(msg1,"#").
            if msg_indx <> 0 then
               msg1 = substring(msg1, 1, msg_indx - 1)
                    + si_db
                    + substring(msg1, msg_indx + 1).
            display stream rport {aperserr.i}
               msg1
            with frame error down.
            down with frame error.
            prhline_err_stat = true.
         end.
      end.
   end.
END PROCEDURE.

PROCEDURE p-get-rate:
   {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
      "(input po_mstr.po_curr,
        input base_curr,
        input po_mstr.po_ex_ratetype,
        input today,
        output l_ex_rate,
        output l_ex_rate2,
        output l_exru_seq,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      /* EXCHANGE RATE NOT FOUND */
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4 &MSGBUFFER=msg1}
      display stream rport {aperserr.i}
         msg1 with frame error down.
      down with frame error.
      assign
         prhline_err_stat = true.
   end. /* IF mc-error-number  */
END PROCEDURE. /* END OF PROCEDURE p-get-rate */

PROCEDURE build_temp_table:
   assign
      valid_prh.prhersopt = ersnbr
      prhreceiver = prhhist.prh_receiver
      prhpart     = prhhist.prh_part
      prhsite     = prhhist.prh_site
      prhline     = prhhist.prh_line
      prhcurramt  = curr_amt
      prhexrate   = pvomstr.pvo_ex_rate
      prhexrate2  = pvomstr.pvo_ex_rate2
      prhcurr     = prhhist.prh_curr
      prhrcvd     = prhhist.prh_rcvd
      prhinvqty   = pvomstr.pvo_vouchered_qty
      prhnbr      = prhhist.prh_nbr
      prhacct     = pvomstr.pvo_accrual_acct
      prhsub      = pvomstr.pvo_accrual_sub
      prhcc       = pvomstr.pvo_accrual_cc
      prhelement  = prhhist.prh_element
      prhlstprice = list_price
      prhrecid    = recid(prhhist)
      prhcalcqty  = pvomstr.pvo_trans_qty - pvomstr.pvo_vouchered_qty
      prhtaxc     = pvomstr.pvo_taxc
      prhtaxusg   = pvomstr.pvo_tax_usage
      prhconref   = pvomstr.pvo_external_ref
      prhproject  = pvomstr.pvo_project
      prhconsign  = pvomstr.pvo_consignment
      prhtype     = prhhist.prh_type.

                     ext_cur_amt = prhcalcqty * prhcurramt.
                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input prhhist.prh_curr,
                          input base_curr,
                          input pvomstr.pvo_ex_rate,
                          input pvomstr.pvo_ex_rate2,
                          input prhcurramt,
                          input false, /* DO NOT ROUND */
                          output unit_cost,
                          output mc-error-number)"}

                     /* ASSIGN VOUCHER QTY  */
                     /* TO CONSIGNMENT USAGE RECORDS THAT WERE */
                     /* PROCESSED BY ERS.                      */

                     if using_supplier_consignment and prhconsign
                        then do:
                        {gprunmo.i
                           &program=""aperscn.p""
                           &module="ACN"
                           &param="""(input prhnbr,
                                      input prhline,
                                      input prhreceiver,
                                      input pvomstr.pvo_vouchered_qty)"""}
                     end. /* IF using_supplier_consignment ... */

END PROCEDURE.

PROCEDURE build_ap_mstr:
   assign
      ap_mstr.ap_acct = po_mstr.po_ap_acct
      ap_bank      = vd_mstr.vd_bank
      ap_batch     = batch
      ap_sub        = po_ap_sub
      ap_cc        = po_ap_cc
      ap_ckfrm     = vd_ckfrm
      ap_curr      = po_curr
      ap_date      = voucher_date
      ap_disc_acct = gl_ctrl.gl_apds_acct
      ap_disc_sub  = gl_apds_sub
      ap_disc_cc   = gl_apds_cc
      ap_effdate   = today
      ap_entity    = apentity
      ap_ex_rate   = l_ex_rate
      ap_ex_rate2  = l_ex_rate2
      ap_ex_ratetype = l_ex_ratetype
      ap_open      = yes
      ap_ref       = apref
      ap_type      = "VO"
      ap_vend      = po_vend
      ap_dy_code   = dft-daybook.

      for first apc_ctrl no-lock: end.
      if apc_multi_entity_pay = no then do:
         for first bk_mstr
         fields (bk_code bk_entity)
         no-lock
         where bk_code = ap_bank:
         end.

         ap_entity = bk_entity.
      end.

      {gpglef01.i ""AP"" ap_entity today}

      /* ISSUE AN ERROR MESSAGE WHEN THE GL CALENDAR DOES NOT EXIST   */
      /* FOR VOUCHER EFFECTIVE DATE OR WHEN THE GL CALENDAR IS CLOSED */
      /* FOR AP ENTITY IN THE AP MODULE                               */
      if gpglef > 0 then do:
         &IF defined(from_ecom) = 0 &THEN
            {pxmsg.i &MSGNUM=gpglef
                     &ERRORLEVEL=4
                     &MSGBUFFER=msg1}
            display stream rport {aperserr.i}
               msg1 with frame error down.
            down with frame error.
         &ELSE
            run cr_err_msg (
               input i_doc_seq,
               input i_proc_sess,
               input gpglef,
               input 4,
               input msg1).
         &ENDIF
         prhline_err_stat = true.
      end. /*GPGLEF > 0*/


END PROCEDURE.

PROCEDURE build_vo_mstr:
   assign
      vo_mstr.vo_is_ers = true
      vo_confirmed  = (if valid_prh.prhersopt = 3
                       then yes else no)
      vo_conf_by    = (if vo_confirmed then
                      "ers proc" else "")
      vo_cr_terms   = po_mstr.po_cr_terms
      vo_curr       = po_curr
      vo_disc_date  = disc_date
      vo_due_date   = due_date
      vo_ex_rate    = l_ex_rate
      vo_ex_rate2   = l_ex_rate2
      vo_ex_ratetype = l_ex_ratetype
      vo_hold       = no
      vo_hold_amt   = 0
      vo_base_hold_amt = 0
      vo_invoice    = (if prhhist.prh_ps_nbr <> "" then
                          prhhist.prh_ps_nbr
                       else
                          prhhist.prh_receiver)
      vo_modok      = yes
      vo_po_rcvd    = yes
      vo_receiver   = prhhist.prh_receiver
      vo_ref        = ap_mstr.ap_ref
      vo_ship       = po_ship
      vo_tax_date   = (if po_tax_date <> ?
                       then po_tax_date else ap_effdate)
      vo_po         = prhhist.prh_nbr
      vo_taxable    = po_taxable
      vo_taxc       = po_taxc
      vo_tax_usage  = po_tax_usage
      vo_tax_env    = po_tax_env
      vo_tax_pct[1] = po_tax_pct[1]
      vo_tax_pct[2] = po_tax_pct[2]
      vo_tax_pct[3] = po_tax_pct[3]
      vo_type       = "VO".
      {&APERSUPA-P-TAG8}
END PROCEDURE.

PROCEDURE build_vph_hist:

   define buffer pvomstr2 for pvo_mstr.

   for first pvomstr2
       field (pvo_id)
       where pvomstr2.pvo_lc_charge = ""
         and pvomstr2.pvo_internal_ref_type = {&TYPE_POReceiver}
         and pvomstr2.pvo_internal_ref = valid_prh.prhreceiver
         and pvomstr2.pvo_line = valid_prh.prhline
         and pvomstr2.pvo_external_ref = valid_prh.prhconref
         no-lock:
            vph_hist.vph_pvo_id   = pvomstr2.pvo_id.
         end.

   assign
      vph_hist.vph_acct = valid_prh.prhacct
      vph_sub      = prhsub
      vph_cc       = prhcc
      vph_curr_amt = prhcurramt
      vph_element  = prhelement
      vph_inv_date = ap_mstr.ap_effdate
      vph_inv_qty  = prhcalcqty
      vph_nbr      = prhnbr
      vph_project  = valid_prh.prhproject
      vph__qadc01  = prhtaxusg
                     + fill(" ",8 - length(prhtaxusg))
                     + prhtaxc
                     + fill(" ",3 - length(prhtaxc))
      vph_ref      = vo_mstr.vo_ref
      vph_pvod_id_line = 0.

END PROCEDURE.


PROCEDURE updatePendingVoucherQuantity:
   define input  parameter ip_receiver  as character no-undo.
   define input  parameter ip_line      as integer no-undo.
   define input  parameter ip_ext_ref   as character no-undo.
   define input  parameter ip_vo        as character no-undo.
   define input  parameter ip_vouchered_qty   as decimal no-undo.

   define variable work_vouchered_qty as decimal no-undo.

   work_vouchered_qty = ip_vouchered_qty.

   for each pmstr
      where pmstr.pvo_internal_ref_type = {&TYPE_POReceiver}
        and pmstr.pvo_lc_charge    = ""
        and pmstr.pvo_internal_ref = ip_receiver
        and pmstr.pvo_line = ip_line
        and pmstr.pvo_external_ref = ip_ext_ref
        and pmstr.pvo_trans_qty <> 0
      exclusive-lock:

         assign
            pmstr.pvo_last_voucher = ip_vo
            pmstr.pvo_ers_status = 2.


         /* UPDATE ALL THE PENDING VOUCHER RECORDS BY          */
         /* READING EACH ONE, ADDING TO THE VOUCHERED QTY,     */
         /* THE WORK IS DONE WHEN THE "for each" IS COMPLETE   */
         /* OR THE WORKING VOUCHER QUANTITY = 0.               */

         if work_vouchered_qty >=
            (pmstr.pvo_trans_qty - pmstr.pvo_vouchered_qty) then

            /* TOTAL INVOICE QTY > PENDING QTY */
            assign
              work_vouchered_qty = work_vouchered_qty -
                       (pmstr.pvo_trans_qty - pmstr.pvo_vouchered_qty)
              pmstr.pvo_vouchered_qty = pmstr.pvo_trans_qty
              .
         else

            /* TOTAL INVOICE QTY < PENDING QTY */
            assign
              pmstr.pvo_vouchered_qty =
                 pmstr.pvo_vouchered_qty + work_vouchered_qty
              work_vouchered_qty = 0.

         if work_vouchered_qty = 0 then
            leave.

   end.  /* for each pmstr */
END PROCEDURE. /* updatePendingVoucherQuantity */

PROCEDURE ip_curr_err:

   /* FOLLOWING CODE IS ADDED TO ASSIGN VALUE '3' TO VOUCHER CHECK */
   /* FORM WITH WARNING 'SETTING CHECK FORM TO 3' WHEN A VOUCHER   */
   /* IS BEING CREATED FOR FOREIGN CURRENCY PO WITH BASE CURRENCY  */
   /* BANK AND TO ISSUE WARNINGS                                   */
    define parameter buffer    ap_mstr       for  ap_mstr.
    define input     parameter l_vo_curr     like vo_curr     no-undo.
    define input     parameter l_vd_pay_spec like vd_pay_spec no-undo.

    for first bk_mstr
       fields(bk_code bk_curr bk_entity)
       where bk_code = ap_bank
       no-lock:

       if bk_curr     <> l_vo_curr
          and bk_curr =  base_curr
       then do:

          /* BANK CURR <> VOUCHER CURR */
          {pxmsg.i
              &MSGNUM=93
              &ERRORLEVEL=2
              &MSGBUFFER=msg1}
          display
             stream rport {aperserr.i}
             msg1
             with frame error down.
          down with frame error.

          if ap_ckfrm <> "3"
          then do:

             ap_ckfrm = "3".
             /* SETTING CHECK FORM TO 3 */
             {pxmsg.i
                 &MSGNUM=179
                 &ERRORLEVEL=2
                 &MSGBUFFER=msg1}
             display
                stream rport {aperserr.i}
                msg1
                with frame error down.
             down with frame error.
          end. /* IF ap_ckfrm <> "3" */

       end. /* IF bk_curr <> l_vo_curr AND ... */

    end. /* FOR FIRST bk_mstr */

    if not l_vd_pay_spec
    and (ap_ckfrm = "3"
     or  ap_ckfrm = "4")
    then do:

       /* PAY SPECIFICATION SET TO NO FOR SUPPLIER */
       {pxmsg.i
           &MSGNUM=2662
           &ERRORLEVEL=2
           &MSGBUFFER=msg1}
       display
          stream rport {aperserr.i}
          msg1
          with frame error down.
       down with frame error.

    end. /* IF NOT l_vd_pay_spec..... */

END PROCEDURE. /* ip_curr_err */

PROCEDURE ip_chk_suppbank:
   define input parameter l_vo__qad02 like vo__qad02 no-undo.
   define input parameter l_ap_ckfrm  like ap_ckfrm  no-undo.

   if l_vo__qad02  = " "
   and (l_ap_ckfrm = "3"
    or  l_ap_ckfrm = "4")
   then do:

      {pxmsg.i
          &MSGNUM=1841
          &ERRORLEVEL=2
          &MSGBUFFER=msg1}
      display
         stream rport {aperserr.i}
         msg1
         with frame error down.
      down with frame error.

   end. /* IF l_vo__qad02 = " " ......  */

END PROCEDURE. /* ip_chk_suppbank. */
