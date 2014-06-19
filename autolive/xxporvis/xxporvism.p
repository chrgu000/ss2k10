/* porvism.p - PURCHASE ORDER RETURN W/ SERIAL NUMBER CONTROL                 */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: porvism.p 31157 2013-05-16 13:44:05Z p8k                          $: */
/*                                                                            */
/* Supports running in API mode                                               */
/*                                                                            */
/* REVISION: 7.3            CREATED: 11/08/94   BY: bcm *GO37*                */
/* REVISION: 7.3      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J040*                */
/* REVISION: 8.5      LAST MODIFIED: 07/28/95   BY: kxn *J066*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 7.3      LAST MODIFIED: 08/30/95   BY: ais *G0VX*                */
/* REVISION: 8.5      LAST MODIFIED: 10/13/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 01/09/96   BY: tjs *J0B1*                */
/* REVISION: 8.5      LAST MODIFIED: 02/14/96   BY: rxm *H0JJ*                */
/* REVISION: 8.5      LAST MODIFIED: 04/23/96   BY: ajw *J0K5*                */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: rxm *G1SL*                */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: taf *J0ZS*                */
/* REVISION: 8.5      LAST MODIFIED: 07/30/96   BY: *G2B5* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 10/30/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 08/14/97   BY: *H1B4* Manmohan K.Pardesi */
/* REVISION: 8.6      LAST MODIFIED: 09/10/97   BY: *H1F0* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *J2MG* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 10/26/98   BY: *L0CF* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 07/21/99   BY: *J3JP* Prashanth Narayan  */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/10/00   BY: *L0Z4* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 01/12/01   BY: *N0VL* Manish Kulkarni    */
/* Revision: 1.19.3.8     BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.19.3.9     BY: Rajaneesh Sarangi   DATE: 05/08/01  ECO: *M0W6* */
/* Revision: 1.19.3.10    BY: Jean Miller         DATE: 05/08/01  ECO: *M11Z* */
/* Revision: 1.19.3.11    BY: John Pison          DATE: 03/08/02  ECO: *N1BT* */
/* Revision: 1.19.3.12    BY: Ashwini Ghaisas     DATE: 04/26/02  ECO: *M1XB* */
/* Revision: 1.19.3.13    BY: Jeff Wootton        DATE: 05/23/02  ECO: *P075* */
/* Revision: 1.19.3.14    BY: Ellen Borden        DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.19.3.15    BY: Ashish Maheshwari   DATE: 06/03/02  ECO: *N1K6* */
/* Revision: 1.19.3.16    BY: Steve Nugent        DATE: 06/13/02  ECO: *P08K* */
/* Revision: 1.19.3.17    BY: Luke Pokic          DATE: 06/19/02  ECO: *P099* */
/* Revision: 1.19.3.18    BY: Ashish Maheshwari   DATE: 11/27/02  ECO: *N204* */
/* Revision: 1.19.3.20    BY: Pawel Grzybowski    DATE: 03/27/03  ECO: *P0NT* */
/* Revision: 1.19.3.23    BY: Paul Donnelly       DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.19.3.24    BY: Rajinder Kamra      DATE: 04/25/03  ECO: *Q003* */
/* Revision: 1.19.3.25    BY: Ed van de Gevel     DATE: 08/14/03  ECO: *Q024* */
/* Revision: 1.19.3.26    BY: Laxmikant Bondre    DATE: 02/06/04  ECO: *P1MV* */
/* Revision: 1.19.3.27    BY: Subramanian Iyer    DATE: 03/19/04  ECO: *N2QC* */
/* Revision: 1.19.3.28    BY: Veena Lad           DATE: 06/03/04  ECO: *P24K* */
/* Revision: 1.19.3.29    BY: Swati Sharma        DATE: 03/04/05  ECO: *P3B2* */
/* Revision: 1.19.3.31    BY: Shivganesh Hegde    DATE: 04/15/05  ECO: *P3FL* */
/* Revision: 1.19.3.32    BY: Steve Nugent        DATE: 08/23/05  ECO: *P2PJ* */
/* Revision: 1.19.3.33    BY: Andrew Dedman       DATE: 10/16/05  ECO: *R01P* */
/* Revision: 1.19.3.34    BY: Ellen Borden        DATE: 12/01/05  ECO: *R000* */
/* Revision: 1.19.3.35    BY: Ellen Borden        DATE: 01/17/06  ECO: *R008* */
/* Revision: 1.19.3.36    BY: Sushant Pradhan     DATE: 05/17/06  ECO: *P4RC* */
/* Revision: 1.19.3.37    BY: Niranjan Ranka      DATE: 06/05/06  ECO: *R05V* */
/* Revision: 1.19.3.38    BY: Robin McCarthy      DATE: 06/30/06  ECO: *R04J* */
/* Revision: 1.19.3.39    BY: Ajay Nair           DATE: 10/03/06  ECO: *P58K* */
/* Revision: 1.19.3.41    BY: Deirdre O'Brien     DATE: 07/11/07  ECO: *R0C6* */
/* Revision: 1.19.3.42    BY: Namita Patil        DATE: 01/07/08  ECO: *P5XB* */
/* Revision: 1.19.3.45    BY: Nan Zhang           DATE: 05/22/08  ECO: *R0JS* */
/* Revision: 1.19.3.46    BY: Ashim Mishra        DATE: 01/14/09  ECO: *Q27D* */
/* Revision: 1.19.3.48    BY: Mukesh singh        DATE: 03/12/09  ECO: *P61X* */
/* Revision: 1.19.3.49    BY: Yizhou Mao          DATE: 03/16/09  ECO: *R1DT* */
/* Revision: 1.19.3.51    BY: Jordan Fei          DATE: 09/16/09  ECO: *R1V9* */
/* Revision: 1.19.3.55    BY: Miguel Alonso       DATE: 05/07/10  ECO: *R204* */
/* Revision: 1.19.3.56    BY: Yiqing Chen         DATE: 04/28/10  ECO: *R22Q* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 *  ANY CHANGES MADE TO PORVISM.P MAY ALSO BE NEEDED IN POPORC.P
 */

/* DISPLAY TITLE */
{us/bbi/mfdeclre.i}
{us/gp/gpuid.i}
{us/bbi/gplabel.i} /* EXTERNAL LABEL INCLUDE */
{us/px/pxphdef.i ppitxr}

/* COMMON VARIABLES ARE DECLARED IN us/po/porcdef.i */
{us/po/porcdef.i "new"}

{us/gp/gpldcons.i} /* CONSTANTS FOR LEGAL DOCUMENT */
{us/gp/gpglefdf.i}
{us/px/pxsevcon.i} /* SEVERITY PREPROCESSOR CONSTANT DEFN INCLUDE FILE */
{us/px/pxmaint.i} /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{us/px/pxphdef.i mcpl} /* INCLUDE FILE FOR DEFINING PERSISTENT HANDLE */
{us/px/pxpgmmgr.i} /* INCLUDE FILE FOR RETRIEVING PROGRAM MANAGER */
{us/po/porcsshp.i} /*SUBCONTRACT SHIPPER TEMP TABLE*/

/* DEFINE SHARED TEMP-TABLES FOR PRM */
{us/pj/pjportt.i "new"}

/* COMMON API CONSTANTS AND VARIABLES */
{us/mf/mfaimfg.i}

define input parameter p_int_ref_type   like lacd_internal_ref_type   no-undo.
/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable rndmthd     like rnd_rnd_mthd.
define new shared variable fiscal_id   like prh_receiver.
define new shared variable fiscal_rec  as logical initial no.
define new shared variable maint       like mfc_logical no-undo.
define new shared variable qopen       like pod_qty_rcvd label "Net Received".
define new shared variable receivernbr like prh_receiver label "RTV Nbr".
define new shared variable msg         as character format "x(60)".
define new shared variable l_tt_consign like mfc_logical no-undo.
define new shared variable l_pod_det_recid as recid      no-undo.
define new shared variable l_include_retain like mfc_logical initial yes  no-undo.

/* KANBAN TRANSACTION NUMBER NEEDED FOR POPORCB8.P */
define new shared variable kbtransnbr  as integer no-undo.

/* MOVED TO POTRLDEF.I */
define new shared variable convertmode as character no-undo.

define new shared workfile tax_wkfl
   field tax_nbr                   like pod_nbr
   field tax_line                  like pod_line
   field tax_env                   like pod_tax_env
   field tax_usage                 like pod_tax_usage
   field tax_taxc                  like pod_taxc
   field tax_in                    like pod_tax_in
   field tax_taxable               like pod_taxable
   field tax_price                 like prh_pur_cost.

/*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
define new shared workfile attr_wkfl no-undo
   field chg_line   like sr_lineid
   field chg_assay  like tr_assay
   field chg_grade  like tr_grade
   field chg_expire like tr_expire
   field chg_status like tr_status
   field assay_actv as logical
   field grade_actv as logical
   field expire_actv as logical
   field status_actv as logical.

/* LOGISTICS CHARGE - PENDING VOUCHER MASTER TEMP TABLE DEFINITION */
define new shared temp-table tt-pvocharge no-undo
   field tt-lc_charge           like lc_charge
   field tt-pvo_id              as   integer
   index tt-index
   tt-lc_charge
   tt-pvo_id.

define new shared temp-table tt-pod no-undo
   field tt-domain       like pod_domain
   field tt-nbr          like pod_nbr
   field tt-line         like pod_line
   field tt-consign      like pod_consign
   index tt-index
   tt-domain
   tt-nbr
   tt-line.

define new shared variable vendlot      like tr_vend_lot no-undo.
/* DEFINE SHARED VARIABLE PRM-AVAIL SINCE IT IS REQUIRED */
/* BY THE SUBROUTINE POPORCB6.P                          */
define new shared variable prm-avail    like mfc_logical initial no no-undo.
define new shared variable receipt_date like prh_rcp_date no-undo.

define new shared variable fill-all     like mfc_logical label "Receive All" no-undo.

define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.

define new shared frame    b.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define            variable yn          like mfc_logical.
define            variable pook        like mfc_logical.
define            variable ent_exch    like exr_rate.
define            variable cmmt_yn     like mfc_logical label "Comments".
define            variable rcv_type    like poc_rcv_type.
define            variable vndname     like ad_name.
define            variable ship_date   as date no-undo.
define            variable v_shipfrom  like abs_shipfrom no-undo.
define            variable v_shipto    like abs_shipto   no-undo.
define            variable v_int       as   integer      no-undo.
define            variable v_fromname  like si_desc      no-undo.
define            variable v_toname    like si_desc      no-undo.
define            variable v_abs_recid as   recid        no-undo.
define            variable v_shipnbr   like tr_ship_id   no-undo.
define            variable v_shipdate  like tr_ship_date no-undo.
define            variable v_invmov    like tr_ship_inv_mov no-undo.
define            variable accum_qty_chg like pod_qty_chg no-undo.
define            variable rejected    like mfc_logical no-undo.
define            variable old_db      like global_db no-undo.
define            variable err-flag    as integer no-undo.
define            variable mc-error-number like msg_nbr no-undo.
define            variable l_tax_edited like mfc_logical initial true no-undo.
define            variable l_flag       like mfc_logical initial true no-undo.
define            variable auto_receipt like mfc_logical
                  initial false no-undo.
define            variable op_rctpo_trnbr like tr_trnbr no-undo.
define            variable lv_error_num   as integer    no-undo.
define            variable lv_name        as character  no-undo.
define            variable l_order_active_yn as logical no-undo.
define            variable l_continue     as logical no-undo.
define            variable hBlockedTransactionlibrary as handle no-undo.
define            variable l_pt_lot_ser   as   character no-undo.
define            variable lgdnbr         like lgd_nbr   no-undo.
define            variable l_elec_ld      as   logical   no-undo.

/* Local variables to store UI values */
define variable cPoNbr as character no-undo.

/* Local variables API Customizations */
define variable lCustomOK as logical no-undo.

/* Define Handles for the programs. */
{us/px/pxphdef.i gpsecxr}

/* PO Return API dataset definition */
{us/po/podsrvis.i "reference-only"}

{us/tx/txcalvar.i}
{us/wl/wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{us/wl/wlcon.i} /*CONSTANTS DEFINITIONS*/

if is_wiplottrace_enabled() then do:
   {us/bbi/gprun.i ""wlpl.p"" "persistent set h_wiplottrace_procs"}
   {us/bbi/gprun.i ""wlfl.p"" "persistent set h_wiplottrace_funcs"}
end.

assign
   issueld = yes
   ship_date = today.

form
   po_nbr         colon 15
   po_vend
   po_stat
   receivernbr    to 78
with frame b side-labels width 80.

/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame b:handle).

form
   po_nbr         colon 15
   po_vend
   po_stat
   eff_date       colon 68
   receivernbr    colon 15
   vndname        at 27 no-label
   fill-all       colon 68 label "Return All"
   v_shipfrom     colon 15 label "Ship-From"
   v_fromname     at 27 no-label format "x(20)"
   replace        colon 68
   v_shipto       colon 15 label "Ship-To"
   v_toname       at 27 no-label
   cmmt_yn        colon 68
   move           colon 68 label "Move To Next Operation"
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame a:handle).

{us/po/pocurvar.i "NEW"}
{us/tx/txcurvar.i "NEW"}
/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{us/po/potrldef.i "NEW"}
assign
   nontax_old         = nontaxable_amt:format
   taxable_old        = taxable_amt:format
   lines_tot_old      = lines_total:format
   tax_tot_old        = tax_total:format
   order_amt_old      = order_amt:format
   prepaid_old        = po_prepaid:format.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

assign
   convertmode = "MAINT"
   maint = true
   shipper_rec = false
   fiscal_rec = false
   cmmt-prefix = "RTV:"
   transtype = "ISS-PRV".

/* CHECK IF PRM IS INSTALLED */
{us/pj/pjchkprm.i}

/* PRM-ENABLED VARIABLE DEFINED IN PJCHKPRM.I */
prm-avail = prm-enabled.


if c-application-mode = "API" then do on error undo, return:

   /* Get handle of API Controller */
   {us/bbi/gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}

   if not valid-handle(ApiMethodHandle) then do:
      /* API Error */
      {us/bbi/pxmsg.i &MSGNUM=10461 &ERRORLEVEL=4}
      return.
   end.

   /* Get the PO Return API dataset from the controller */
   run getRequestDataset in
       ApiMethodHandle (output dataset dsPurchaseOrderReturn bind).

end.  /* If c-application-mode = "API" */

main-loop:
repeat:

   /* Initialize electronic legal document flag and shipper recid.
    * These fields will be used to determine whether to print
    * electronic legal document
    */
   assign
      l_elec_ld   = no
      v_abs_recid = ?.

   /* Get the PO Return record from the API controller */
   if c-application-mode = "API" then do:
      run getNextRecord in ApiMethodHandle (input "ttPurchaseOrderReturn").
      if return-value = {&RECORD-NOT-FOUND} then
         leave main-loop.
   end. /* if c-application-mode = "API" */

   /* DELETE qad_wkfl RECORDS */
   {us/px/pxrun.i &PROC='DeleteQadwkfl'
      &PROGRAM='porcxr.p'
      &PARAM="(input 'RECEIVER',
        input receivernbr,
        input SessionUniqueID,
        input global_userid)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   {us/gp/gprunp.i "soldxr" "p" "clearWorkTableOfLGAndGL"}

   /* SPLIT THE ORIGINAL DO TRANSACTION IN TWO DO TRANSACTION      */
   /* BLOCKS TO SOLVE TRANSACTION SCOPING PROBLEM IN ORACLE        */
   /* ALSO SHIFTED DOWN CODE RELATED TO FOREIGN CURRENCY AND       */
   /* TRANSACTION COMMENTS IN THE SECOND TRANSACTION BLOCK         */

   do transaction:

      do for poc_ctrl:
         find first poc_ctrl where poc_ctrl.poc_domain = global_domain no-lock.
         rcv_type = poc_rcv_type. /* RETURNS ARE NEGATIVE RECEIVERS */
      end.

      if c-application-mode <> "API" then
         view frame a.

      if receivernbr = ? then
         receivernbr = "".
      if eff_date = ? then
         eff_date = today.

      assign
         fill-all = no
         move = yes
         replace = no
         cmmt_yn = yes.

      if c-application-mode <> "API" then do:
         display
            receivernbr
            eff_date
            replace
            fill-all
            cmmt_yn
            move
         with frame a.
      end. /* c-application-mode <> "API" */
      else do:
         /* SET THE DEFAULTS IN API TABLE FOR AN ADD OPERATION */
         assign
            {us/mf/mfaidflt.i ttPurchaseOrderReturn.receiverNbr         receivernbr}
            {us/mf/mfaidflt.i ttPurchaseOrderReturn.effDate             eff_date}
            {us/mf/mfaidflt.i ttPurchaseOrderReturn.returnToReplace     replace}
            {us/mf/mfaidflt.i ttPurchaseOrderReturn.fillAll             fill-all}
            {us/mf/mfaidflt.i ttPurchaseOrderReturn.moveToNextOperation move}.
      end.

      receivernbr = "".

      /* EMPTY LOGISTICS ACCOUNTING TEMP TABLE */
      for each tt-pvocharge exclusive-lock:
         delete tt-pvocharge.
      end.

      seta:
      do on error undo, retry:
         if c-application-mode = "API" and retry then
            undo main-loop, next main-loop.


         if c-application-mode <> "API" then do:
            prompt-for po_nbr
            with frame a
               editing:
               if frame-field = "po_nbr" then do:
                  /* FIND NEXT/PREVIOUS RECORD */
                  /* Do not scroll thru RTS for PO or PO for RTS */
                  {us/mf/mfnp06.i
                     po_mstr
                     po_nbr
                     " po_mstr.po_domain = global_domain and po_type  <> ""B"" and
                       po_fsm_type = ports"
                     po_nbr
                     "input po_nbr"
                     yes
                     yes }

                  if recno <> ? then do:
                     find ad_mstr  where ad_mstr.ad_domain = global_domain and
                        ad_addr = po_vend no-lock no-error.
                     if available ad_mstr then
                        vndname = ad_name.
                     else
                        vndname = "".
                     display
                        po_nbr
                        receivernbr
                        po_vend
                        po_stat
                        vndname
                     with frame a.
                  end.
               end.
               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.
            end.
         end. /* c-application-mode <> "API" */

         /* Assign the local variables from either the UI or API */
         assign
            cPoNbr = if c-application-mode <> "API" then
                      (input po_nbr)
                   else
                       ttPurchaseOrderReturn.poNbr.


         /* END EDITING PORTION OF FRAME A */

         /* READ THE po_mstr WITH NO-LOCK WHEN PURCHASE ORDER IS A   */
         /* CLOSED, CANCELLED, TYPE BLANKET OR ACCESSING RTS ORDER   */
         /* VIA PO RETURNS AND FOR PURCHASE ORDER WITH NO DETAIL LINE*/
         /* READ IT WITH AN EXCLUSIVE-LOCK OTHERWISE                 */

         if can-find (first po_mstr
            where po_mstr.po_domain = global_domain and
              ((po_stat = "C"
            or  po_stat = "X")
            or  po_type = "B"
            or  po_fsm_type <> "" )
            using po_nbr)
         or not can-find (first pod_det
            where pod_det.pod_domain = global_domain and
                  pod_nbr = cPoNbr)
         then
            for first po_mstr where po_mstr.po_domain = global_domain and
                                    po_mstr.po_nbr = cPoNbr
            no-lock: end.

         else
            find po_mstr where po_mstr.po_domain = global_domain and
                   po_mstr.po_nbr = cPoNbr
            exclusive-lock no-error.

         if not available po_mstr then do:
            /* PURCHASE ORDER DOES NOT EXIST */
            {us/bbi/pxmsg.i &MSGNUM=343 &ERRORLEVEL=3
            &FIELDNAME=""poNbr""}
            if c-application-mode <> "API" then
               next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

         {us/gp/gpbrparm.i &browse=gplu908.p &parm=c-brparm1 &val=po_nbr}

         if po_type = "B" then do:
            /* BLANKET ORDER NOT ALLOWED */
            {us/bbi/pxmsg.i &MSGNUM=385 &ERRORLEVEL=3
            &FIELDNAME=""poNbr""}
            if c-application-mode <> "API" then
               next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

         /* IS Field Service? */
         if po_fsm_type <> "" then do:
            /* Can not process RTS orders with PO programs. */
            {us/bbi/pxmsg.i &MSGNUM=7364 &ERRORLEVEL=3
            &FIELDNAME=""poNbr""}
            if c-application-mode <> "API" then
               next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

         /* start blocked transaction library to run persistently */
         run mfairunh.p
            (input "mgbltrpl.p",
             input ?,
             output hBlockedTransactionlibrary).

         {us/mg/mgbltrpl.i "hBlockedTransactionlibrary"}

         /* Check to see if Supplier has any blocked transactions */
         if blockedSupplier(input po_vend,
                            input {&PO012},
                            input true,
                            input "Supplier")
         then do:
            undo, retry.
         end.

         delete PROCEDURE hBlockedTransactionlibrary.

         /* MAKE SURE THAT CENTRAL DATABASE IS CONNECTED */
         find first pod_det  where pod_det.pod_domain = global_domain and
            pod_nbr = cPoNbr no-lock no-error.

         if global_db <> pod_po_db then do:
            {us/gp/gprunp.i "mgdompl" "p" "ppDomainConnect"
               "(input  pod_po_db,
                 output lv_error_num,
                 output lv_name)"}

            if lv_error_num <> 0 then do:
               /* DOMAIN # IS NOT AVAILABLE */
               {us/bbi/pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=3 &MSGARG1=lv_name}
               undo seta, retry.
            end.
         end. /* if global_db <> pod_po_db then do: */

         /* Warn user if PO will be re-opened */
         if (po_stat = "c" or po_stat = "x") then do:
            yn = no.
         if c-application-mode <> "API" then do:
            /* PO AND/OR PO LINE CLOSED OR CANCELLED - REOPEN ? */
            {us/bbi/pxmsg.i &MSGNUM=339 &ERRORLEVEL=1 &CONFIRM=yn}
         end.
         else yn  =  ttPurchaseOrderReturn.Reopen.

            if yn = yes
            then do:
               /* EXCLUSIVE-LOCK THE po_mstr WHEN REOPENING A CLOSED */
               /* OR CANCELLED PURCHASE ORDER                        */
               find po_mstr where po_mstr.po_domain = global_domain
                             and po_nbr = cPoNbr
               exclusive-lock no-error.

               find first pod_det  where pod_det.pod_domain = global_domain and
                  pod_nbr = cPoNbr
               no-lock no-error.
               old_db = global_db.
               if global_db <> pod_po_db then do:
                  {us/bbi/gprun.i ""gpalias3.p""
                     "(pod_po_db,
                       output err-flag)" }
               end. /* IF GLOBAL_DB <> POD_PO_DB THEN */
               /* RE-OPEN PO IN ORDER DATABASE */
               {us/bbi/gprun.i ""porstat.p""  "(cPoNbr)"}
               if old_db <> global_db then do:
                  {us/bbi/gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
               end. /* IF OLD_DB <> GLOBAL_DB */

               assign
                  po_stat = ""
                  po_cls_date = ?.
               if c-application-mode <> "API" then do:
                  display
                     po_stat
                  with frame a.
               end. /* c-application-mode <> "API" */
            end. /* IF YN = YES */
            else do:
               if c-application-mode <> "API" then
                  next-prompt po_nbr with frame a.
               undo seta, retry.
            end.
         end.

         if po_curr = gl_base_curr then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {us/gp/gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input po_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3
               &FIELDNAME=""poNbr""}
               if c-application-mode <> "WEB" then do:
                  if c-application-mode <> "API" then
                     next-prompt po_nbr with frame a.
               end.
               undo seta, retry.
            end.
         end.

         {us/po/pocurfmt.i}

         find si_mstr no-lock  where si_mstr.si_domain = global_domain and
            si_site = po_ship no-error.
         find ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and
            ad_addr = po_vend no-error.

         assign
            v_shipfrom = po_ship
            v_fromname = if available si_mstr then si_desc else ""
            v_shipto   = po_vend
            v_toname   = if available ad_mstr then ad_name else "".

         find ad_mstr
            where ad_mstr.ad_domain = global_domain
             and  ad_addr = po_vend
         no-lock no-error.
         if available ad_mstr then
            vndname = ad_name.
         else
            vndname = "".
         if c-application-mode <> "API" then do:
            display
               receivernbr
               po_vend
               po_stat
               vndname
               v_shipfrom
               v_fromname
               v_shipto
               v_toname
            with frame a.
         end. /* c-application-mode <> "API" */
         else do:
            /* SET THE DEFAULTS IN API TABLE FOR AN ADD OPERATION */
            assign
               {us/mf/mfaidflt.i ttPurchaseOrderReturn.receiverNbr receivernbr}
               {us/mf/mfaidflt.i ttPurchaseOrderReturn.shipFrom    v_shipfrom}
               {us/mf/mfaidflt.i ttPurchaseOrderReturn.shipTo      v_shipto}.
         end.
         pook = no.

         chkpodsite:
         for each pod_det  where pod_det.pod_domain = global_domain and
               pod_nbr = po_nbr no-lock:

            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
               = pod_site no-lock no-error.

            if available si_mstr and si_db = global_db then do:
               {us/bbi/gprun.i ""gpsiver.p""
                  "(input si_site, input recid(si_mstr), output return_int)"}
               if return_int = 1 then do:
                  pook = yes.
                  leave chkpodsite.
               end.  /* IF RETURN_INT = 1 */
            end.

         end.   /* FOR EACH pod_det */

         if not pook then do:
            {us/bbi/pxmsg.i &MSGNUM=352 &ERRORLEVEL=3
            &FIELDNAME=""poNbr""}
            if c-application-mode <> "API" then
               next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

      end.

      seta1:
      do on error undo, retry:
         if c-application-mode = "API" and retry then
            undo main-loop, next main-loop.

         global_addr = po_vend.
         if c-application-mode <> "API" then do:
            set
              receivernbr
              v_shipfrom
              v_shipto
              eff_date
              fill-all when not (can-find(first pod_det
              where pod_det.pod_domain = global_domain
              and pod_nbr              = po_nbr
              and pod_consignment      = yes))
              replace
              cmmt_yn
              move
           with frame a.
         end. /* c-application-mode <> "API" */
         else do:
            /* Assign the local variables from either the UI or API */
            assign
               receivernbr  =  ttPurchaseOrderReturn.receiverNbr
               v_shipfrom   =  ttPurchaseOrderReturn.shipFrom
               v_shipto     =  ttPurchaseOrderReturn.shipTo
               eff_date     =  ttPurchaseOrderReturn.effDate
               replace      =  ttPurchaseOrderReturn.returnToReplace
               move         =  ttPurchaseOrderReturn.moveToNextOperation
               fill-all     =  ttPurchaseOrderReturn.fillAll.
         end. /* c-application-mode = "API" */

         {us/px/pxrun.i &PROC='validateReceiverId'
            &PROGRAM='porcxr.p'
            &PARAM="(input receivernbr,
              input rcv_type)"
            &NOAPPERROR=true
            &CATCHERROR=true }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            /* RTV NUMBER ALREADY EXISTS */
            {us/bbi/pxmsg.i &MSGNUM=377 &ERRORLEVEL={&APP-ERROR-RESULT}}
            if c-application-mode <> "API" then
               next-prompt receivernbr with frame a.
            undo seta1, retry.
         end. /* IF return-value <> ... */

         /* Validate ship-from site */
         if v_shipfrom <> "" then do:

            find si_mstr where si_mstr.si_domain = global_domain
               and si_site = v_shipfrom
            no-lock no-error.

            if not available si_mstr then do:
               {us/bbi/pxmsg.i &MSGNUM=708 &ERRORLEVEL=3
               &FIELDNAME=""shipFrom""}  /* Site does not exist */
               if c-application-mode <> "API" then
                  next-prompt v_shipfrom with frame a.
               undo seta1, retry seta1.
            end. /* If not available si_mstr */

            {us/bbi/gprun.i
               ""gpsiver.p""
               "(si_site, recid(si_mstr), output v_int)"}

            if v_int = 0 then do:
               /* User does not have access to this site */
               {us/bbi/pxmsg.i &MSGNUM=725 &ERRORLEVEL=3
               &FIELDNAME=""shipFrom""}
               if c-application-mode <> "API" then
                  next-prompt v_shipfrom with frame a.
               undo seta1, retry seta1.
            end.  /* if v_int */
            v_fromname = si_desc.
         end.  /* if v_shipfrom */

         else
            v_fromname = "".
            if c-application-mode <> "API" then do:
               display
                  v_fromname
               with frame a.
            end. /* c-application-mode <> "API" */

         /* Validate ship-to address */
         if v_shipto <> "" then do:

            find ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and
               ad_addr = v_shipto no-error.

            if not available ad_mstr then do:
               {us/bbi/pxmsg.i &MSGNUM=980 &ERRORLEVEL=3
               &FIELDNAME=""shipTo""} /* Address does not exist */
               if c-application-mode <> "API" then
                  next-prompt v_shipto with frame a.
               undo seta1, retry seta1.
            end. /* If not available ad_mstr */

            v_toname = ad_name.

         end.  /* if v_shipto */
         else
            v_toname = "".

         if c-application-mode <> "API" then do:
            display
               v_toname
            with frame a.
         end. /* c-application-mode <> "API" */

         if eff_date = ? then
            eff_date = today.

         if po_sched then do:

            /*Check the scheduled ORDER is active*/
            run checkEffectiveDate
               (input eff_date,
                input pod_nbr,
                input pod_line,
                output l_order_active_yn).

            if l_order_active_yn = no then do:
               /* ORDER IS NOT ACTIVE AS OF THE RETURN EFFECTIVE DATE. CONTINUE?*/
               {us/bbi/pxmsg.i &MSGNUM=6766 &ERRORLEVEL=2 &CONFIRM=l_continue}
               if l_continue = no then do:
                  undo seta1, retry.
               end. /* IF l_continue */
            end. /* if l_order_active */

         end. /* po_sched = yes */

         /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
         /* NOT PRIMARY ENTITY                               */

         /* IF RETURN ALL IS YES, VERIFY OPEN GL PERIOD FOR EACH  */
         /* LINE ITEM SITE/ENTITY                                 */
         if fill-all and available po_mstr then
         for each pod_det where pod_det.pod_domain = global_domain
            and (pod_nbr = po_nbr and
                 pod_line >= 0 and
                (pod_qty_rtnd < pod_qty_rcvd or pod_qty_ord = 0))
         no-lock use-index pod_nbrln:

            for first si_mstr
               where si_mstr.si_domain = global_domain and si_site = pod_site
            no-lock: end.

            if available si_mstr then do:
               /* CHECK GL EFFECTIVE DATE */
               {us/gp/gpglef02.i &module = ""IC""
                  &entity = si_entity
                  &date   = eff_date
                  &prompt = "eff_date"
                  &frame  = "a"
                  &loop   = "seta1"}
            end. /* IF AVAILABLE si_mstr */
         end. /* FOR EACH pod_det */
      end.
      if can-find (mfc_ctrl
         where mfc_ctrl.mfc_domain = global_domain
         and   mfc_field           = "enable_supplier_perf"
         and   mfc_logical)
         and   can-find (_File where _File-name = "vef_ctrl")
         and   receivernbr = ""
      then do:
         do for poc_ctrl :
            {us/mf/mfnctrlc.i
               "poc_ctrl.poc_domain = global_domain"
               "poc_ctrl.poc_domain"
               "prh_hist.prh_domain = global_domain"
               poc_ctrl
               poc_rcv_pre
               poc_rcv_nbr
               prh_hist
               prh_receiver
               receivernbr}
         end. /* DO FOR poc_ctrl transaction: */
      end. /* IF ENABLE SUPPLIER PERFORMANCE */
   end. /* DO TRANSACTION */

   do transaction:

      if c-application-mode = "API" and retry
         then return error return-value.


      /* FIND EXCH RATE IF CURRENCY NOT BASE */
      if base_curr <> po_curr
      then do:

         if po_fix_rate then
         assign
            exch_rate = po_ex_rate
            exch_rate2 = po_ex_rate2
            ent_exch  = po_ent_ex.

         else do:

            /* CREATE EXCHANGE RATE USAGE */
            {us/gp/gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input po_curr,
                 input base_curr,
                 input exch_ratetype,
                 input eff_date,
                 output exch_rate,
                 output exch_rate2,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo, retry.
            end. /* IF mc-error-number <> 0 */

            seta1_sub:
            do on error undo, retry:

               if c-application-mode = "API" and retry then
                  undo main-loop, next main-loop.

/*324*/         {us/gp/gprunp.i "xxmcui" "p" "mc-ex-rate-input"
                  "(input po_curr,
                    input base_curr,
                    input eff_date,
                    input exch_exru_seq,
                    input false,
                    input 12,
                    input-output exch_rate,
                    input-output exch_rate2,
                    input-output po_fix_rate)"}

            end. /* DO ON ERROR UNDO,RETRY */

         end. /* IF NOT po_fix_rate */

      end. /* IF base_curr <> po_curr */

      else
         assign
            exch_rate  = 1.0
            exch_rate2 = 1.0.

      /* ADD COMMENTS, IF DESIRED */
      if cmmt_yn = yes or c-application-mode = "API"
      then do:
         if c-application-mode <> "API" then
            hide frame a no-pause.

         /* Let the API controller know the name of the transaction */
         /* comments buffer.                                        */
         if c-application-mode = "API" then do:
            run setCommonDataBuffer in ApiMethodHandle
               (input "ttPurchaseOrderReturnComment").
         end. /* c-application-mode = "API" */

         assign
            cmtindx    = po_cmtindx
            global_ref = cmmt-prefix + " " + po_nbr.
         {us/bbi/gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
         po_cmtindx = cmtindx.

         if c-application-mode = "API" then do:
            run setCommonDataBuffer in ApiMethodHandle
               (input "").
         end. /* c-application-mode = "API" */

      end. /* IF cmmt_yn */

      {us/mf/mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot
         woc_sq01 trlot}

      for each sr_wkfl where sr_wkfl.sr_domain = global_domain
         and sr_userid = SessionUniqueID
      exclusive-lock:
         delete sr_wkfl.
      end.

      /* DETAIL FRAME C AND SINGLE LINE PROCESSING FRAME D */
      release pod_det.
      preppoddet:

      for each pod_det where pod_det.pod_domain = global_domain
         and (pod_nbr = po_nbr
         and (pod_qty_rtnd < pod_qty_rcvd or pod_qty_ord = 0))
      exclusive-lock
      break by pod_site by pod_loc by pod_serial by pod_part:

         if first-of (pod_part) then
         assign
            accum_qty_chg = 0.

         find si_mstr where si_mstr.si_domain = global_domain
            and  si_site = pod_site
         no-lock no-error.

         if not available si_mstr
         or (available si_mstr and si_db <> global_db)
         then
            next preppoddet.

         if fill-all = yes then do:

            {us/px/pxrun.i &PROC  = 'getFieldDefault' &PROGRAM = 'ppitxr.p'
                     &HANDLE=ph_ppitxr
                     &PARAM = "( input  pod_part,
                                 input  pod_site,
                                 input ""pt_lot_ser"",
                                 output l_pt_lot_ser)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}

            /* ONLY AUTO-FILL PARTS THAT ARE NOT LOT/SERIAL CONTROLLED */
            find pt_mstr where pt_mstr.pt_domain = global_domain
               and  pt_part = pod_part
            no-lock no-error.
            if not available pt_mstr
               or (available pt_mstr and l_pt_lot_ser = "" and pod_type <> "S" )
               then
            assign
               pod_qty_chg = pod_qty_rcvd - pod_qty_rtnd.
            else
            assign
               pod_qty_chg = 0.

            rejected = no.

            if pod_type = "" then do:

               accum_qty_chg = accum_qty_chg + (pod_qty_chg * pod_um_conv).

               {us/bbi/gprun.i ""icedit2.p""
                  "(input "transtype",
                    input pod_site,
                    input pod_loc,
                    input pod_part,
                    input """",
                    input """",
                    input accum_qty_chg,
                    input pod_um,
                    input """",
                    input """",
                    output rejected)"}

            end.

            if rejected then do on endkey undo, retry:
               accum_qty_chg = accum_qty_chg - (pod_qty_chg * pod_um_conv).
               pod_qty_chg = 0.
               {us/bbi/pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 &MSGARG1=pod_part}
            end.

            if pod_qty_chg <> 0 then do:
               create sr_wkfl.
               assign
                  sr_domain = global_domain
                  sr_userid = SessionUniqueID
                  sr_lineid = string(pod_line)
                  sr_site = pod_site
                  sr_loc = pod_loc
                  sr_lotser = ""
                  sr_ref = ""
                  sr_qty = pod_qty_chg.
            end.

            if porec or is-return then do:

               /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */
               find loc_mstr where loc_mstr.loc_domain = global_domain
                  and loc_site = pod_site
                  and loc_loc = pod_loc
               no-lock no-error.

               if available loc_mstr and loc_single = yes then do:

                  {us/gp/gploc02.i  "buff1.pod_domain = global_domain and " pod_det
                     pod_nbr pod_line pod_part}

                  if error_flag = 0 and loc__qad01 = yes then do:

                     /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) FOR
                        DIFFERENT ITEMS OR LOT/SERIALS IN SAME LOCATION */
                     {us/bbi/gprun.i ""gploc01.p""
                        "(pod_site,
                          pod_loc,
                          pod_part,
                          pod_serial,
                          "" "",
                          loc__qad01,
                          output error_flag)"}

                     if error_flag <> 0
                       /* ADJUSTING QTY ON A PREVIOUS VIOLATION (CREATED
                          BEFORE THIS PATCH) OF SINGLE ITEM/LOT/SERIAL
                          LOCATION ALLOWED; CREATING ANOTHER VIOLATION
                          DISALLOWED.
                       */
                     and can-find(ld_det where ld_det.ld_domain = global_domain
                                           and ld_site = pod_site
                                           and ld_loc = pod_loc
                                           and ld_part = pod_part
                                           and ld_lot = pod_serial
                                           and ld_ref = "")
                     then
                        error_flag = 0.

                  end. /* error_flag = 0 and loc__qad01 = yes */

                  if error_flag <> 0 then do:
                     /* TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOC */
                     {us/bbi/pxmsg.i &MSGNUM=596 &ERRORLEVEL=2}
                     undo preppoddet, next preppoddet.
                  end.

               end.  /* avail loc_mstr and loc_single = yes */

            end. /* porec or is-return*/

         end.
         else
            pod_qty_chg = 0.

         assign
            pod_ps_chg = pod_qty_chg
            pod_rum = pod_um
            pod_rum_conv = 1
            pod_reason = "".

      end. /* for each pod_det */

      l_pod_det_recid = ?.

      empty temp-table tt-pod.

      if c-application-mode <> "API" then
         hide frame a no-pause.

      /* RUN porvisa.p TO SELECT EDIT ITEMS TO BE RECEIVED */
      po_recno = recid(po_mstr).
      proceed = no.
      {us/bbi/gprun.i ""porvisa.p""
         "(input-output table tt_shipper_scroll)"}

      /* RUN poporcb.p TO CREATE RECEIPTS & UPDATE TRANSACTIONS */
      if proceed = yes then do:

         assign
            v_shipnbr  = ""
            v_shipdate = ship_date
            v_invmov   = "".
            /* Create a shipper for the PO return */
            if v_shipfrom <> "" and v_shipto <> "" then do:
               if c-application-mode <> "API" then do:
                  hide frame b no-pause.
               end.

               if c-application-mode = "API" then do:
                  run setCommonDataBuffer in ApiMethodHandle(input "ttPOReturnShipper").
               end.

               {us/bbi/gprun.i ""porvism1.p""
                  "(v_shipfrom,
                    v_shipto,
                    transtype,
                    eff_date,
                    recid(po_mstr),
                    output v_abs_recid)" }

               if c-application-mode = "API" then do:
                  run setCommonDataBuffer in ApiMethodHandle(input "").
               end. /* c-application-mode = "API" */

               if c-application-mode = "API" and return-value = {&APP-ERROR-RESULT}
                  then undo main-loop, retry main-loop.

               if c-application-mode <> "API" then do:
                  /* Get associated shipper */
                  find abs_mstr where recid(abs_mstr) = v_abs_recid
                  no-lock no-error.

                  if available abs_mstr then do:
                     assign
                        v_shipnbr  = substring(abs_id,2)
                        v_shipdate = abs_shp_date
                        v_invmov   = abs_inv_mov.

                     /* Global Shipping: Legal Document */
                     /* Update exchange rate and calculate the LD amounts */
                     {us/gp/gprunp.i "soldxr" "p" "updateExchangeRateForLD"
                                      "(input recid(abs_mstr),
                                        input exch_rate,
                                        input exch_rate2)"}

                     /* Assign Legal Doc nbr */
                     {us/bbi/gprun.i ""gpldnbr.p"" "(recid(abs_mstr))"}

                     /* get comments data */
                     {us/bbi/gprun.i ""gpldcmt.p"" "(recid(abs_mstr), 'PO')"}

                     /* Assign packing slip qty */
                     run assignPackingSlip(input abs_mstr.abs_id).

                     /* Record the legal document number for the Return PO.
                        Also set the status to Confirmed. */
                     run recordLegalNbr.

                     /* Print non-electronic legal document */
                     /* If fiscal confirm is required, we'll postpone the printing till ERS is run. */
                     if can-find(first poc_ctrl where poc_domain = global_domain
                        and poc_fiscal_confirm = no)
                     then do:

                        /* Determine whether shipper has electronic legal document */
                        {us/gp/gprunp.i "soldxr" "p" "checkElecLDForShipper"
                           "(input oid_abs_mstr,
                             output l_elec_ld)"}

                     end.
                     else do:
                        if lgdnbr <> "" then do:
                           /* LEGAL DOCUMENT # HAS BEEN GENERATED */
                           {us/bbi/pxmsg.i &MSGNUM=11144 &ERRORLEVEL=1 &MSGARG1=lgdnbr}
                           pause.
                        end.

                        hide all no-pause.
                        display
                           dtitle format "x(78)"
                        with no-labels color messages
                        width 80 row 1 column 1
                        frame dtitle no-box.
                     end. /* if not can-find(first poc_ctrl */
                  end.

                  view frame b.
               end.
            end.  /* if v_shipfrom */

         {us/bbi/gprun.i ""poporcb.p""
            "(v_shipnbr,
              v_shipdate,
              v_invmov,
              v_shipto,
              auto_receipt,
              no,
              0,
              0,
              """",
              0,
              p_int_ref_type,
              output op_rctpo_trnbr)"}

         /*UPDATE SUBSHIPPER RECORDS*/
         find first tt_shipper_scroll no-lock no-error.
         if available tt_shipper_scroll then do:
           {us/bbi/gprun.i ""porcshpu.p""
              "(input table tt_shipper_scroll)"}
         end. /*IF AVAILABLE TT_SHIPPER_SCROLL*/

         {us/bbi/gprun.i ""poporcd.p""}

      end. /* IF PROCEED = YES */

      old_db = global_domain.
      for each tt-pod :
         if tt-domain <> global_domain
         then do:
            {us/bbi/gprun.i ""gpmdas.p"" "(tt-domain, output err-flag)"}
         end. /* IF tt-domain <> global_domain */

         {us/bbi/gprun.i ""porvism2.p"" "(input tt-nbr,
                                 input tt-line,
                                 input tt-consign )"}
         if old_db <> global_domain
         then do:
            {us/bbi/gprun.i ""gpmdas.p"" "(old_db, output err-flag)"}
         end. /* IF old_db <> global_domain */
      end.     /* FOR EACH tt-po*/

      l_pod_det_recid = ?.

   end. /* DO TRANSACTION */

   /* If fiscal confirm is required, we'll postpone the LD printing till ERS is run. */
   if can-find(first poc_ctrl where poc_domain = global_domain
      and poc_fiscal_confirm = no)
   then do:

      /* NOTE: PRINT ELECTRONIC LEGAL DOCUMENT AFTER THE
       *       TRANACTION IS COMMITED TO PREVENT SENDING
       *       ELECTRONIC REQUEST FOR ANY LEGAL DOCUMENT
       *       THAT IS ROLLED BACK BY THE SYSTEM.
       */
      /* Postpone legal print after tax calculating in poporcb.p */
      if v_abs_recid <> ? then do:
         {us/bbi/gprun.i ""icldprt.p"" "(v_abs_recid)"}
      end.
   end.

   /* CALCULATE AND EDIT TAXES */
   if proceed = yes then do:

      undo_trl2 = true.

      {us/bbi/gprun.i ""porctrl2.p""}

      if undo_trl2 then undo.

      {us/bbi/gprun.i ""txedtchk.p""
         "(input "20",
           cPoNbr,
           input po_blanket,
           input 0,
           output l_tax_edited)"}

      if l_tax_edited then do:
         /* EDITED PREVIOUS TAX VALUES TYPE 20: RECALCULATE? */
         {us/bbi/pxmsg.i &MSGNUM=2579 &ERRORLEVEL=2 &MSGARG1="20"
                  &CONFIRM=l_flag}
      end. /* IF l_tax_edited ... */

      if not l_tax_edited
         or l_flag
      then do:
         {us/bbi/gprun.i ""txcalc.p""
            "(input "20",
              cPoNbr,
              input po_blanket,
              input 0,
              input no,
              output result-status)"}.
      end. /* IF not l_tax_edited ...  */

      else do:

         for each tx2d_det
            where tx2d_domain  = global_domain
            and   tx2d_ref     = po_nbr
            and   tx2d_tr_type = "20"
         no-lock:

            if not tx2d_edited
            then do:
               {us/bbi/gprun.i ""txcalc.p""
                  "(input "20",
                    input tx2d_ref,
                    input tx2d_nbr,
                    input tx2d_line,
                    input l_tax_edited,
                    output result-status)"}
            end. /* IF NOT tx2d_edited */

         end. /* FOR EACH tx2d_det */

      end. /* ELSE DO */

   end. /* IF PROCEED = YES  */

   if c-application-mode <> "API" then
      hide frame b no-pause.

   {us/gp/gprunp.i "soldxr" "p" "updateLegalNumToUnpostedGL"}

   if c-application-mode = "API" then do:
      /* Run any customizations in API mode for ro_det */
      run applyCustomizations in ApiMethodHandle
         (input "ttPurchaseOrderReturn",
          input (buffer po_mstr:handle),
          input "a",
          output lCustomOK).

      if not lCustomOK then
         undo, retry.
   end.


end.

if c-application-mode <> "API" then
   status input.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.

PROCEDURE checkEffectiveDate:

   /*This procedure checks whether the effective date is within    */
   /*the scheduled order HEADER  effective date range.             */
   define input  parameter ip_eff_date as date       no-undo.
   define input  parameter ip_po_nbr   like po_nbr   no-undo.
   define input  parameter ip_pod_line like pod_line no-undo.
   define output parameter op_hdr_active as logical no-undo.

   define variable hdr_start        as date    no-undo.
   define variable hdr_end          as date    no-undo.
   define variable line_start       as date    no-undo.
   define variable line_end         as date    no-undo.

    /*CALL ROUTINE TO GET ORDER LINE EFFECTIVE DATE RANGE*/
   {us/bbi/gprun.i ""rseffd.p""
            "(input  ip_po_nbr,
              input  ip_pod_line,
              output hdr_start,
              output hdr_end,
              output line_start,
              output line_end)"}

    if ip_eff_date < hdr_start or
      ip_eff_date > hdr_end then
      op_hdr_active  = no.
    else
       op_hdr_active  = yes.

END PROCEDURE. /* checkEffectiveDate*/

PROCEDURE assignPackingSlip:
   define input parameter pAbsId as character no-undo.

   define buffer lgdd_det for lgdd_det.

   /* Assign packing slip qty to lgdd_ps_qty */
   for each lgdd_det where lgdd_domain = global_domain
      and lgdd_shipper_id = pAbsId exclusive-lock,
      each pod_det where pod_domain = global_domain
      and pod_nbr  = lgdd_order
      and pod_line = lgdd_order_line
   no-lock:
      lgdd_ps_qty = pod_ps_chg.
   end.

END PROCEDURE.

PROCEDURE recordLegalNbr:

   define buffer lgd_mstr for lgd_mstr.
   define variable l_new_ref as character.
   define variable vi_error as integer no-undo.

   for first lgd_mstr exclusive-lock
      where lgd_mstr.lgd_domain     = global_domain
      and   lgd_mstr.lgd_shipper_id = abs_mstr.abs_id
      and   lgd_mstr.lgd_type       = yes
      and   lgd_mstr.lgd_status <> {&LD_CANCELLED}:
      assign
         lgdkey              = lgd_mstr.oid_lgd_mstr
         lgd_mstr.lgd_status = {&LD_CONFIRMED}
         lgdnbr              = lgd_mstr.lgd_nbr.
   end.

   release lgd_mstr.

   for first lgd_mstr no-lock
      where lgd_mstr.lgd_domain     = global_domain
      and   lgd_mstr.lgd_shipper_id = abs_mstr.abs_id
      and   lgd_mstr.lgd_type       = yes:

   if lgd_trans_curr <> base_curr then do:

         l_new_ref = string(lgd_mstr.lgd_shipfrom,"x(8)") + lgd_mstr.lgd_nbr.

         for each tx2d_det where
             tx2d_domain  = global_domain    and
             tx2d_ref     = l_new_ref        and
             tx2d_tr_type = "17":


             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_tax_amt,
                                          input true,
                                          output tx2d_tax_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.


             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_tottax,
                                          input true,
                                          output tx2d_tottax,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.


             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_cur_tax_amt,
                                          input true,
                                          output tx2d_cur_tax_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_ent_tax_amt,
                                          input true,
                                          output tx2d_ent_tax_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_cur_nontax_amt,
                                          input true,
                                          output tx2d_cur_nontax_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_nontax_amt,
                                          input true,
                                          output tx2d_nontax_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_ent_nontax_amt,
                                          input true,
                                          output tx2d_ent_nontax_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_taxable_amt,
                                          input true,
                                          output tx2d_taxable_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_cur_recov_amt,
                                          input true,
                                          output tx2d_cur_recov_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_recov_amt,
                                          input true,
                                          output tx2d_recov_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_ent_recov_amt,
                                          input true,
                                          output tx2d_ent_recov_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_cur_abs_ret_amt,
                                          input true,
                                          output tx2d_cur_abs_ret_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_abs_ret_amt,
                                          input true,
                                          output tx2d_abs_ret_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.

             /* CONVERT FROM TRANSACTION  TO BASE CURRENCY */
             {us/gp/gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input lgd_trans_curr,
                                          input base_curr,
                                          input lgd_ex_rate,
                                          input lgd_ex_rate2,
                                          input tx2d_ent_abs_ret_amt,
                                          input true,
                                          output tx2d_ent_abs_ret_amt,
                                          output vi_error)"}

             if vi_error <> 0 then do:
                {us/bbi/pxmsg.i &MSGNUM=vi_error &ERRORLEVEL=2}
             end.
         end. /* for each tx2d_det */

        end. /* if lgd_trans_curr <> base_curr */

    end. /* for first lgd_mstr */

END PROCEDURE. /* recordLegalNbr */
