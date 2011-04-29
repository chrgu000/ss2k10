/* poporcm.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.45.1.9 $                                                               */
/*                                                                            */
/*                                                                            */
/* REVISION: 7.0      LAST MODIFIED: 11/19/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: RAM *F033*                */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: RAM *F070*                */
/* REVISION: 7.0      LAST MODIFIED: 01/31/92   BY: RAM *F126*                */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: RAM *F163*                */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: RAM *F177*                */
/* REVISION: 7.0      LAST MODIFIED: 02/14/92   BY: sas *F153*                */
/* REVISION: 7.0      LAST MODIFIED: 02/24/92   BY: sas *F211*                */
/* REVISION: 7.0      LAST MODIFIED: 03/09/92   BY: RAM *F269*                */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: pma *F087*                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: RAM *F311*                */
/* REVISION: 7.3      LAST MODIFIED: 08/12/92   BY: tjs *G028*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 10/22/92   BY: afs *G116*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/23/92   BY: mpp *G481*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: mpp *G263*                */
/* REVISION: 7.3      LAST MODIFIED: 11/10/92   BY: pma *G304*                */
/* REVISION: 7.3      LAST MODIFIED: 12/15/92   BY: tjs *G443*                */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   BY: tjs *G460*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/11/93   BY: bcm *G425*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/16/93   BY: tjs *G675*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/16/93   BY: tjs *G684*                */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: sas *G647*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: tjs *G718*                */
/* REVISION: 7.3      LAST MODIFIED: 04/19/93   BY: tjs *G964*                */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA34*                */
/* REVISION: 7.3      LAST MODIFIED: 05/13/93   BY: kgs *GA90*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: kgs *GB26*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: kgs *GB35*                */
/* REVISION: 7.4      LAST MODIFIED: 06/18/93   BY: jjs *H010*                */
/* REVISION: 7.4      LAST MODIFIED: 07/02/93   BY: dpm *H014*                */
/* REVISION: 7.4      LAST MODIFIED: 07/02/93   BY: jjs *H020*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 07/06/93   BY: jjs *H024*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.4      LAST MODIFIED: 09/10/93   BY: tjs *H093*                */
/* REVISION: 7.4      LAST MODIFIED: 10/06/93   BY: dpm *H075*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/05/93   BY: bcm *H210*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/12/93   BY: afs *H219*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/14/93   BY: afs *H220*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: afs *H227*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 11/19/93   BY: afs *H236*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: WUG *GI86*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/94   BY: dpm *H074*                */
/* REVISION: 7.4      LAST MODIFIED: 04/20/94   BY: tjs *GI57*                */
/* REVISION: 7.3      LAST MODIFIED: 04/21/94   BY: dpm *FN24*                */
/* REVISION: 7.2      LAST MODIFIED: 08/01/94   BY: dpm *FP66*                */
/* REVISION: 7.3      LAST MODIFIED: 08/10/94   BY: ais *FQ01*                */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM16*                */
/* REVISION: 7.4      LAST MODIFIED: 09/20/94   BY: ljm *GM74*                */
/* REVISION: 7.4      LAST MODIFIED: 10/11/94   BY: cdt *FS26*                */
/* REVISION: 7.4      LAST MODIFIED: 10/18/94   BY: cdt *FS54*                */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: cdt *FS95*                */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: bcm *GO37*                */
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*                */
/* REVISION: 7.4      LAST MODIFIED: 01/20/95   BY: smp *F0F5*                */
/* REVISION: 8.5      LAST MODIFIED: 01/30/95   BY: ktn *J041*                */
/* REVISION: 7.4      LAST MODIFIED: 03/10/95   BY: jpm *H0BZ*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: aed *G0JV*                */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: bcm *G0JN*                */
/* REVISION: 8.5      LAST MODIFIED: 09/20/95   BY: kxn *J07M*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 7.4      LAST MODIFIED: 10/06/95   BY: vrn *G0XW*                */
/* REVISION: 8.5      LAST MODIFIED: 01/09/96   BY: tjs *J0B1*                */
/* REVISION: 8.5      LAST MODIFIED: 10/09/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/14/96   BY: rxm *H0JJ*                */
/* REVISION: 8.5      LAST MODIFIED: 02/05/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: rxm *H0KH*                */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: rxm *G1SV*                */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: rxm *H0M3*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: *J22T* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2DD* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *J2MG* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *J2VC* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 09/04/98   BY: *L08R* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *K1WX* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 10/26/98   BY: *L0CF* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 11/12/98   BY: *J30M* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 05/15/99   BY: *J39K* Sanjeev Assudani   */
/* REVISION: 9.1      LAST MODIFIED: 07/07/99   BY: *N00N* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 09/03/99   BY: *J3L4* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Dan Herman         */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Thelma Stronge     */
/* REVISION: 9.1      LAST MODIFIED: 03/20/00   BY: *N08V* B. Gates           */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 9.1      LAST MODIFIED: 07/18/00   BY: *L0Z4* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 07/11/00   BY: *N0FS* Arul Victoria      */
/* Revision: 1.40     BY: Satish Chavan          DATE:06/27/00   ECO: *N0DK*  */
/* Revision: 1.41     BY: Mark Brown             DATE:08/13/00   ECO: *N0KQ*  */
/* Revision: 1.42     BY: Nikita Joshi           DATE:11/07/00   ECO: *L15J*  */
/* Revision: 1.43     BY: Ravikumar K            DATE:12/20/00   ECO: *L16V*  */
/* Revision: 1.44     BY: Mudit Mehta            DATE:09/30/00   ECO: *N0WT*  */
/* Revision: 1.45.1.2 BY: Rajesh Kini            DATE:02/27/01   ECO: *M12H*  */
/* Revision: 1.45.1.3 BY: Rajaneesh S.           DATE:05/08/01   ECO: *M0W6*  */
/* Revision: $        BY: Hareesh V              DATE:08/06/01   ECO: *M1GV*  */
/* Revision: 1.45.1.8 BY: John Pison             DATE:03/08/02   ECO: *N1BT*  */
/* $Revision: 1.45.1.9 $      BY: Ashwini G.             DATE:04/15/02   ECO: *M1XB*  */
/* REVISION: eB(SP5)     LAST MODIFIED: 08/16/06    BY: Apple      *EAS055A*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/*!
   poporcm.p - PO Receipts
*/

/*!
   ANY CHANGES MADE TO POPORCM.P SHOULD ALSO BE MADE TO PORVISM.P
*/



/* DISPLAY TITLE */
{mfdeclre.i}
{cxcustom.i "POPORCM.P"}
{pxsevcon.i} /* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxmaint.i}  /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxphdef.i mcpl} /* INCLUDE FILE FOR DEFINING PERSISTENT HANDLE */
{pxpgmmgr.i} /* INCLUDE FILE FOR RETRIEVING PROGRAM MANAGER */
{gplabel.i}  /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporcm_p_1 "Move to Next Operation"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_2 "Packing Slip"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_3 "Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_4 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_5 "Ship Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_6 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_7 "Ship All"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_8 "Receive All"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_9 "Receiver"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporcm_p_10 "Receiver/RTS Shipper"
/* MaxLen: 26 Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* COMMON VARIABLES, FRAMES & BUFFERS FOR RECEIPTS & RETURNS */
{porcdef.i "new"}

{gpglefdf.i}

/*@MODULE PRM BEGIN*/
/* DEFINE SHARED TEMP-TABLES FOR PRM */
{pjportt.i "new"}
/*@MODULE PRM END*/

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable h_wiplottrace_procs as   handle            no-undo.
define new shared variable h_wiplottrace_funcs as   handle            no-undo.
define new shared variable convertmode         as   character         no-undo.
define new shared variable fiscal_rec          as   logical initial   no.
define new shared variable rndmthd             like rnd_rnd_mthd.
define new shared variable fiscal_id           like prh_receiver.
define new shared variable qopen               like pod_qty_rcvd
                                               label {&poporcm_p_6}.
define new shared variable receivernbr         like prh_receiver.
define new shared variable maint               like mfc_logical       no-undo.
define new shared variable fill-all            like mfc_logical
                                               label {&poporcm_p_8}   no-undo.
define new shared variable vendlot             like tr_vend_lot       no-undo.
define new shared variable receipt_date        like prh_rcp_date      no-undo.
define new shared variable prm-avail           like mfc_logical       no-undo.

define new shared frame b.
define new shared workfile tax_wkfl
   field tax_nbr     like pod_nbr
   field tax_line    like pod_line
   field tax_env     like pod_tax_env
   field tax_usage   like pod_tax_usage
   field tax_taxc    like pod_taxc
   field tax_in      like pod_tax_in
   field tax_taxable like pod_taxable
   field tax_price   like prh_pur_cost.

/*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
define new shared workfile attr_wkfl no-undo
   field chg_line    like sr_lineid
   field chg_assay   like tr_assay
   field chg_grade   like tr_grade
   field chg_expire  like tr_expire
   field chg_status  like tr_status
   field assay_actv  as   logical
   field grade_actv  as   logical
   field expire_actv as   logical
   field status_actv as   logical.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable undo_loop       like mfc_logical                        no-undo.
define variable pook            like mfc_logical.
define variable dbconn          like mfc_logical                        no-undo.
define variable pod-db-name     like pod_po_db                          no-undo.
define variable ers-proc        like poc_ers_proc                       no-undo.
define variable ent_exch        like exr_rate                           no-undo.
define variable ent_exch2       like exr_rate2                          no-undo.
define variable cmmt_yn         like mfc_logical  label {&poporcm_p_4}  no-undo.
define variable rcv_type        like poc_rcv_type                       no-undo.
define variable err_flag        like mfc_logical                        no-undo.
define variable vndname         like ad_name                            no-undo.
define variable issqty          like pod_qty_ord                        no-undo.
define variable fromsite        like pod_site                           no-undo.
define variable fromloc         like pod_loc                            no-undo.
define variable tosite          like pod_site                           no-undo.
define variable toloc           like pod_loc                            no-undo.
define variable reject1         like mfc_logical                        no-undo.
define variable reject2         like mfc_logical                        no-undo.
define variable ship_date       like prh_ship_date                      no-undo.
define variable shipnbr         like tr_ship_id                         no-undo.
define variable inv_mov         like tr_ship_inv_mov                    no-undo.
define variable pur_cost        like pod_pur_cost                       no-undo.
define variable set_flag        like mfc_logical                        no-undo.
define variable ordernum        like po_nbr                             no-undo.
define variable newprice        like pod_pur_cost                       no-undo.
define variable dummy_disc      like pod_disc_pct                       no-undo.
define variable rejected        like mfc_logical                        no-undo.
define variable mc-error-number like msg_nbr                            no-undo.
define variable error_flag      as   integer                            no-undo.
define variable err             as   integer                            no-undo.
define variable recno_sr_wkfl   as   recid                              no-undo.
define variable pc_recno        as   recid                              no-undo.

{pxmaint.i}

/*MAIN-BEGIN*/

/*@MODULE WIPLOTTRACE BEGIN*/
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
/*@MODULE WIPLOTTRACE END*/
{gprunpdf.i "mcpl" "p"}

/* DEFINE & INITIALIZE CURRENCY DEPENDENT ROUNDING FORMAT VARS */
{pocurvar.i "NEW"}
{txcurvar.i "NEW"}

/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{potrldef.i "NEW"}

{txcalvar.i}

assign
   nontax_old    = nontaxable_amt:format
   taxable_old   = taxable_amt:format
   lines_tot_old = lines_total:format
   tax_tot_old   = tax_total:format
   order_amt_old = order_amt:format
   line_tax_old  = line_tax:format
   line_tot_old  = line_total:format
   tax_old       = tax_2:format
   tax_amt_old   = tax_amt:format
   ord_amt_old   = ord_amt:format
   vtord_amt_old = vtord_amt:format
   line_pst_old  = line_pst:format
   prepaid_old   = po_prepaid:format
   frt_old       = po_frt:format
   spec_chg_old  = po_spec_chg:format
   serv_chg_old  = po_serv_chg:format.

form
   po_nbr         colon 12   label {&poporcm_p_3}
   po_vend
   po_stat
   ps_nbr         to 78
with frame b side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

assign
   cmmt-prefix = "RCPT:"
   transtype   = "RCT-PO"
   convertmode = "MAINT".

form
   ordernum       colon 15       label {&poporcm_p_3}
   po_vend
   po_stat
   eff_date       colon 68
   ps_nbr         colon 15       label {&poporcm_p_2}
   move           colon 68       label {&poporcm_p_1}
   receivernbr    colon 15       label {&poporcm_p_9}
   vndname        at    27       no-attr-space no-label
   fill-all       colon 68
   cmmt_yn        colon 68
   ship_date      colon 68       label {&poporcm_p_5}
with frame a1 attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

/* IN THE HEADER OF THE RTS SHIPMENT THE receivernbr WILL NOW */
/* BE DISPLAYED WITH THE LABEL "Receiver/RTS Shipper"         */

form
   ordernum       colon 15       label {&poporcm_p_3}
   po_vend
   po_stat
   eff_date       colon 68
   ps_nbr         colon 15       no-label
   move           colon 68       no-label
   vndname        at    27       no-attr-space no-label
   fill-all       colon 68       label {&poporcm_p_7}
   receivernbr    colon 27       label {&poporcm_p_10}
   cmmt_yn        colon 68
with frame a2 attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a2:handle).

        /* Hide the variable "move" from the frame if porec = false */
        /* To avoid the value of move getting displayed */

        if not porec then
           move:hidden in frame a2 = true.

        /* DIFFERENT LABELS ARE DISPLAYED FOR SAME VARIABLE, */
    /* SO NEED TO ASSIGN LABELS MANUALLY.                */
    if dynamic-function('getTranslateFramesFlag' in h-label) then
    assign
       receivernbr:label = getTermLabel("RECEIVER/RTS_SHIPPER",26)
       fill-all:label    = getTermLabel("SHIP_ALL",11).

form
   ent_exch colon 15
   space(2)
with frame seta1_sub attr-space overlay side-labels
centered row frame-row(a) + 4.

/* SET EXTERNAL LABELS */
setFrameLabels(frame seta1_sub:handle).

/*@MODULE WIPLOTTRACE BEGIN*/
if is_wiplottrace_enabled() then do:
   run activate_wiplot_trace.
end. /* IF IS_WIPLOTTRACE_ENABLED() */
/*@MODULE WIPLOTTRACE END*/

for first gl_ctrl no-lock:
end. /* FOR FIRST GL_CTRL */

for first poc_ctrl
   fields(poc_ers_proc poc_rcv_all poc_rcv_type ) no-lock:
end. /* FOR FIRST POC_CTRL */

assign
/*@MODULE RCV-ALL BEGIN*/
   fill-all  = poc_rcv_all
/*@MODULE RCV-ALL END*/
   rcv_type  = poc_rcv_type
   ers-proc  = poc_ers_proc.

assign
   maint       = true
   shipper_rec = false
   fiscal_rec  = false.

{gprun.i ""socrshc.p""}

for first shc_ctrl no-lock:
end. /* FOR FIRST SHC_CTRL */

/*@MODULE PRM BEGIN*/
/* CHECK IF PRM IS INSTALLED */
{pjchkprm.i}

/* PRM-ENABLED VARIABLE DEFINED IN PJCHKPRM.I */
prm-avail = prm-enabled.
/*@MODULE PRM END*/

main-loop:
repeat:

/*M1XB*/   /* DELETE qad_wkfl RECORDS */
/*M1XB*/   {pxrun.i &PROC='DeleteQadwkfl'
                    &PROGRAM='porcxr.p'
                    &PARAM="(input 'RECEIVER',
                             input receivernbr,
                             input mfguser,
                             input global_userid)"
                    &NOAPPERROR=True
                    &CATCHERROR=True}

/*M1XB*/ /* SPLIT THE ORIGINAL DO TRANSACTION BLOCK INTO TWO DO TRANSACTION */
/*M1XB*/ /* BLOCKS TO TAKE CARE OF ORACLE TRANSACTION SCOPING PROBLEM  .    */
/*M1XB*/ /* poporcm.i MOVED IN THE FIRST DO TRANSACTION BLOCK. COMMENTED    */
/*M1XB*/ /* CODE RELATED TO FOREIGN CURRENCY AND TRANSACTION COMMENTS FROM  */
/*M1XB*/ /* poporcm.i AND COPIED IT IN THIS PROGRAM                         */

/*M1XB*/   do transaction:
/*M1XB*/      if porec
/*M1XB*/      then do:
/*eas055 /*M1XB*/         {poporcm.i &frame=a1}*/
/*eas055*/         {xxpoporcm.i &frame=a1}
/*M1XB*/      end. /* IF porec .. */
/*M1XB*/      else do:
/*eas055 /*M1XB*/         {poporcm.i &frame=a2}*/
/*eas055*/         {xxpoporcm.i &frame=a2}
/*M1XB*/      end. /* ELSE DO */
/*M1XB*/   end. /* DO TRANSACTION */

   do transaction :

/*M1XB*/ /* BEGIN ADD */
         if base_curr <> po_curr
         then do:
            if not po_fix_rate
            then do:
               seta1_sub:
               do on error undo, retry:
                  {gprunp.i "mcui" "p" "mc-ex-rate-input"
                     "(input po_curr,
                       input base_curr,
                       input eff_date,
                       input exch_exru_seq,
                       input false,
                       input frame-row(a) + 4,
                       input-output exch_rate,
                       input-output exch_rate2,
                       input-output po_fix_rate)"}

                  if keyfunction(lastkey) = "end-error"
                  then
                     undo seta1_sub, retry seta1_sub.
               end. /* DO ON ERROR UNDO, RETRY */
            end. /*IF NOT po_fix_rate */
         end. /* IF base_curr <> po_curr */

         /* ADD COMMENTS, IF DESIRED */
         if cmmt_yn
         then do:
            if porec
            then
               hide frame a1 no-pause.
            else
               hide frame a2 no-pause.

           /*@TO-DO- NEED TO CHECK HOW THESE DEFAULTS GET INTO COMMENTS IN XUI*/
           assign
              cmtindx    = po_cmtindx
              global_ref = cmmt-prefix + " " + po_nbr.

           {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
           po_cmtindx = cmtindx.
        end. /* IF cmmt_yn */

/*M1XB*/ /* END ADD */

    if porec then do:

/*M1XB** {poporcm.i &frame=a1}    */

      /* Pop-up to collect shipment information */
      if shc_ship_rcpt then do:
         {gprun.i ""icshup.p""
                  "(input-output shipnbr,
                    input-output ship_date,
                    input-output inv_mov,
                    input 'RCT-PO', no,
                    input 10, input 20)"}
      end. /* IF SHC_SHIP_RCPT */

      run proc-sup-perf.

   end. /* IF POREC */
/*M1XB**   else do:                     */
/*M1XB**      {poporcm.i &frame=a2}     */
/*M1XB**   end. /* ELSE DO: */          */

/*N1BT*/ {gpbrparm.i &browse=dtlu001.p &parm=c-brparm1 &val=po_nbr}

      {pxrun.i &PROC='clearPOReceiptDetails' &PROGRAM='porcxr2.p'
               &NOAPPERROR=True
               &CATCHERROR=True}

   /* Transaction */

   run initialize_lines
       (input po_nbr, input po_vend, input po_curr).

   if porec then hide frame a1 no-pause.
   else          hide frame a2 no-pause.

   /* PRM FUNCTIONALITY ONLY APPLIES WHEN PO BEING RECEIVED */
   /* NOT WHEN RETURN TO SUPPLIER AND WHEN PRM INSTALLED    */
   /* CLEAR PREVIOUS TEMP TABLE DATA IF ANY EXISTS          */
   /*@MODULE PRM BEGIN*/
   if porec and prm-avail then do:
      empty temp-table ttprm-det no-error.
      empty temp-table ttpao-det no-error.
   end. /* IF POREC AND PRM-AVAIL */
   /*@MODULE PRM END*/

   /* RUN poporca.p TO SELECT EDIT ITEMS TO BE RECEIVED */
   assign
      lotserial = ""
      po_recno  = recid(po_mstr)
      proceed   = no.
/*eas055   {gprun.i ""poporca.p""}*/
/*eas055*/   {gprun.i ""xxpoporca.p""}

   /*********************************************************/
   /* If this is a return to supplier then reverse the sign */
   /*********************************************************/
   if not porec then
      /*@MODULE RTS BEGIN*/
      run proc-rts (input po_nbr).
      /*@MODULE RTS END*/

   /* MOVED THE FOLLOWING INTO AN INTERNAL PROCEDURE */
   run create_update_trans
      (input proceed, input shipnbr, input ship_date, input inv_mov).

  end. /* DO TRANSACTION */

      /* CALCULATE AND EDIT TAXES */
   if proceed = yes and {txnew.i} then do:
      undo_trl2 = true.
      {gprun.i ""porctrl2.p""}
      if undo_trl2 then undo.

      run p-tax-detail.

   end. /* IF PROCEED = YES AND .. */

   hide frame b no-pause.

   /* DELETE EXCH RATE USAGE RECORDS */
   {pxrun.i &PROC='deleteExchangeRateUsage' &PROGRAM='mcexxr.p'
            &PARAM="(input exch_exru_seq)"
            &NOAPPERROR=True
            &CATCHERROR=True}

   release po_mstr.
   {&POPORCM-P-TAG1}

end. /* REPEAT: */

status input.

/*@MODULE WIPLOTTRACE BEGIN*/
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.
/*@MODULE WIPLOTTRACE END*/

/*MAIN-END*/

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE activate_wiplot_trace :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
activate_wiplot_trace (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   {gprunmo.i
      &program=""wlpl.p""
      &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}

   {gprunmo.i
      &program=""wlfl.p""
      &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}

END PROCEDURE.

/*============================================================================*/
PROCEDURE create_update_trans :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
create_update_trans (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter proceed   like mfc_logical     no-undo.
   define input parameter shipnbr   like tr_ship_id      no-undo.
   define input parameter ship_date like prh_ship_date   no-undo.
   define input parameter inv_mov   like tr_ship_inv_mov no-undo.

   /* RUN poporcb.p TO CREATE RECEIPTS & UPDATE TRANSACTIONS */
   if proceed = yes then do:
/*ss-eas055      {pxrun.i &PROC='commitReceipt' &PROGRAM='porcxr.p'*/
/*ss-eas055*/      {pxrun.i &PROC='commitReceipt' &PROGRAM='xxporcxr.p'
               &PARAM="(input shipnbr,
                        input ship_date,
                        input inv_mov)"
               &NOAPPERROR=True
               &CATCHERROR=True}


      {gprun.i ""poporcd.p""}

   end. /* IF PROCEED = YES */

END PROCEDURE.

/*============================================================================*/
PROCEDURE del-sr-wkfl :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
del-sr-wkfl (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   {pxrun.i &PROC='clearPOReceiptDetails' &PROGRAM='porcxr2.p'
            &NOAPPERROR=True
            &CATCHERROR=True}

END PROCEDURE.

/*============================================================================*/
PROCEDURE delete-sr-wkfl :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
delete-sr-wkfl (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   for each sr_wkfl
      where sr_userid = mfguser exclusive-lock:
      delete sr_wkfl.
   end. /* FOR EACH SR_WKFL */

END PROCEDURE.

/*============================================================================*/
PROCEDURE find-rmd-det :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
find-rmd-det (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_nbr  like pod_nbr      no-undo.
   define input parameter inpar_line like pod_line     no-undo.
   define input parameter inpar_site like pod_site     no-undo.
   define input parameter inpar_loc  like pod_loc      no-undo.
   define input parameter inpar_type like pod_rma_type no-undo.

   for first rmd_det
      fields (rmd_line rmd_loc rmd_nbr rmd_prefix rmd_site)
      where rmd_nbr = inpar_nbr
        and rmd_prefix = "V"
        and rmd_line   = inpar_line no-lock:
   end. /* FOR FIRST RMD_DET */

   /* Set up RTS Issues */
   if inpar_type = "O" then
      assign
         issqty    = issqty * -1
         fromsite  = inpar_site
         fromloc   = inpar_loc
         tosite    = rmd_site
         toloc     = rmd_loc.

   /* Set up RTS Receipts */
   if inpar_type = "I" then
      assign
         fromsite = rmd_site
         fromloc  = rmd_loc
         tosite   = inpar_site
         toloc    = inpar_loc.

END PROCEDURE.

/*============================================================================*/
PROCEDURE find-vp-mstr :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
find-vp-mstr (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_part    like pod_part  no-undo.
   define input parameter inpar_vend    like po_vend   no-undo.
   define input parameter inpar_um      like pod_um    no-undo.
   define input parameter inpar_curr    like po_curr   no-undo.
   define input parameter l_inpar_vpart like pod_vpart no-undo.

   set_flag = no.

   /* ADDED VP_VEND_VPART IN THE FIELD LIST BELOW */
   {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
            &PARAM="(input inpar_part,
                     input inpar_vend,
                     input l_inpar_vpart,
                     buffer vp_mstr,
                     input {&NO_LOCK_FLAG},
                     input {&NO_WAIT_FLAG})"
            &NOAPPERROR=True
            &CATCHERROR=True}

   if return-value = {&SUCCESS-RESULT} and
      qopen      >= vp_q_qty and
      inpar_um   =  vp_um    and
      vp_q_price >  0        and
      inpar_curr =  vp_curr then
      assign
         set_flag = yes
         pur_cost = vp_q_price.

END PROCEDURE.

/*============================================================================*/
PROCEDURE if_porec_or_is_return :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
if_porec_or_is_return (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter site       like pod_site               no-undo.
   define input parameter loc        like pod_loc                no-undo.
   define input parameter part       like pod_part               no-undo.
   define input parameter serial     like pod_serial             no-undo.
   define output parameter undo_loop like mfc_logical initial no no-undo.

   if porec or is-return then do:
      /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */
      for first loc_mstr
         fields (loc_loc loc_single loc_site loc__qad01)
         where loc_site = site
           and loc_loc  = loc no-lock:
      end. /* FOR FIRST LOC_MSTR */

      if available loc_mstr and loc_single = yes then do:
         recno_sr_wkfl = recid(sr_wkfl).
         run proc-gploc02 (input loc__qad01).

         error_flag = err.

         if error_flag = 0 and loc__qad01 = yes then do:
            /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) FOR
               DIFFERENT ITEMS OR LOT/SERIALS IN SAME LOCATION */
            {gprun.i ""gploc01.p""
                     "(site,
                       loc,
                       part,
                       serial,
                       "" "",
                       loc__qad01,
                       output error_flag)"}

            if error_flag <> 0
               /* ADJUSTING QTY ON A PREVIOUS VIOLATION (CREATED
                  BEFORE THIS PATCH) OF SINGLE ITEM/LOT/SERIAL
                  LOCATION ALLOWED; CREATING ANOTHER VIOLATION
                  DISALLOWED.
               */
               and can-find(ld_det where ld_site = site
               and ld_loc = loc and ld_part = part
               and ld_lot = serial and ld_ref = "") then
               error_flag = 0.
         end. /* IF ERROR_FLAG = 0 AND LOC__QAD01 = YES */

         if error_flag <> 0 then do:
            run proc-mfmsg.

            /* TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOC */
            undo_loop = yes.
         end. /* IF ERROR_FLAG <> 0 */
      end.  /* IF AVAILABLE LOC_MSTR AND LOC_SINGLE = YES */
   end. /* IF POREC OR IS-RETURN */

END PROCEDURE.

/*============================================================================*/
PROCEDURE initialize_lines :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
initialize_lines (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter ip_po_nbr  as character no-undo.
   define input parameter ip_po_vend as character no-undo.
   define input parameter ip_po_curr as character no-undo.

   define variable l_si_db like si_db no-undo.
   define variable vCancelBackOrder like mfc_logic no-undo.
   define variable vSiteId as character no-undo.

   /* DETAIL FRAME C AND SINGLE LINE PROCESSING FRAME D */
   preppoddet:
   for each pod_det
      where pod_nbr = ip_po_nbr
        and pod_status <> "c"
        and pod_status <> "x":

      /********************************************************/
      /*  If this is an rtv po then we need to check the type */
      /*  For normal receipts, the field will be blank.       */
      /*  For an rtv type it will be I.                       */
      /*  For an rtv return it will be O.                     */
      /*  For Return to Supplier transactions, the sign of    */
      /*  pod_qty_chg is reversed for display purposes,       */
      /*  because we are on a return screen. Before the       */
      /*  transaction is complete we reverse the signs to     */
      /*  to negative again.                                  */
      /********************************************************/
      if porec then do:
         if pod_rma_type <> "I"  and
            pod_rma_type <> ""   then next preppoddet.
      end. /* IF POREC */
      else if pod_rma_type <> "O" then next preppoddet.

      {pxrun.i &PROC='getSiteDatabase' &PROGRAM='icsixr.p'
               &PARAM="(input  pod_site,
                        output l_si_db)"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if return-value <> {&SUCCESS-RESULT}
         or l_si_db <> global_db then
         next preppoddet.

   /*@MODULE RCV-ALL BEGIN*/
      {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
               &PARAM="(input  pod_part,
                        buffer pt_mstr,
                        input  {&NO_LOCK_FLAG},
                        input  {&NO_WAIT_FLAG})"
               &NOAPPERROR=True
               &CATCHERROR=True}

      run proc-attr-wkfl
        (input pod_line,           input pod_assay,
         input pod_grade,          input pod_expire,
         input pod_rctstat,        input pod_rctstat_active,
         input pod_part,           input pod_site,
         input pod_loc,            input recid(pod_det)).

      if fill-all = yes then do:

         /* ICEDIT2 PERFORMS CHECK AGAINST RECEIPT WHICH AFFECT */
         /* INVENTORY.TO RESTRICT THE RECEIPT WHEN PO LINE IS   */
         /* EITHER OF TYPE "S" (SUBCONTRACT) OR  "M" (MEMO),    */
         /* WHICH DOES NOT AFFECTS UPDATE INVENTORY.            */

         if (pod_type = "M" or pod_type = "S") and
            available pt_mstr                  and
            can-find(first isd_det
               where isd_status  = string(pt_status,"x(8)") + "#"
                 and isd_tr_type = transtype)  then do:

            /* RESTRICTED TRANSACTION FOR STATUS CODE */

            run proc1-mfmsg02 (input pt_status).
            undo preppoddet, next preppoddet.
         end. /* IF POD_TYPE = "M" OR POD_TYPE = "S" */

         /* ONLY AUTO-FILL PARTS THAT ARE NOT LOT/SERIAL CONTROLLED */
         /* AND HAVE NO ATTRIBUTE (ERROR-FLAG = NO) CONFLICTS       */
         if not err_flag and
            (not available pt_mstr or
            (available pt_mstr and pt_lot_ser = ""
             and pod_type <> "S" )) then do:

            if pod_type = "" and pod_fsm_type = "" then do:
               {gprun.i ""icedit2.p""
                        "(input ""RCT-PO"",
                          input pod_site,
                          input pod_loc,
                          input pod_part,
                          input """",
                          input """",
                          input (pod_qty_ord - pod_qty_rcvd) * pod_um_conv,
                          input pod_um,
                          input pod_nbr,
                          input string(pod_line),
                          output rejected)"}
            end. /* IF POD_TYPE = "" AND POD_FSM_TYPE = "" */
            /*@MODULE RTS BEGIN*/
            /* RTS's generated by field service need sites, and  */
            /* locations identified. And qty properly expressed. */
            else if pod_fsm_type <> "" then do:
               assign
                  rejected  = no
                  reject1   = no
                  reject2   = no
                  issqty    = (pod_qty_ord - pod_qty_rcvd) * pod_um_conv.

               run find-rmd-det
                  (input pod_nbr, input pod_line, input pod_site,
                   input pod_loc, input pod_rma_type).

               /* RTS's receipts that have been previously  */
               /* issued from inventory do not need to test */
               /* the from site.                            */
               if fromsite <> "" then do:
                  {gprun.i ""icedit2.p""
                           "(input ""ISS-TR"",
                             input fromsite,
                             input fromloc,
                             input pod_part,
                             input """",
                             input """",
                             input issqty,
                             input pod_um,
                             input """",
                             input """",
                             output reject1)"}
               end. /* IF FROMSITE <> "" */

               /* RTS issues from inventory do not need to */
               /* test the tosite.                         */
               if tosite <> "" then do:
                  {gprun.i ""icedit2.p""
                           "(input ""RCT-TR"",
                             input tosite,
                             input toloc,
                             input pod_part,
                             input """",
                             input """",
                             input issqty,
                             input pod_um,
                             input """",
                             input """",
                             output reject2)"}
               end. /* IF TOSITE <> "" */

               if reject1 or reject2 then rejected = yes.
            end. /* ELSE IF POD_FSM_TYPE <> "" */
            /*@MODULE RTS END*/

            if rejected then do on endkey undo, retry:

               run proc-mfmsg02 (input pod_part).

               pod_qty_chg = 0.

               run p-assign
                 (input  pod_sched,
                  input  pod_qty_ord,
                  input  pod_qty_rcvd,
                  input  recid(pod_det),
                  output pod_bo_chg).
            end. /* IF REJECTED */
            else do:
               pod_bo_chg = 0.

               run p-assign
                 (input  pod_sched,
                  input  pod_qty_ord,
                  input  pod_qty_rcvd,
                  input  recid(pod_det),
                  output pod_qty_chg).
            end. /* ELSE DO: */
         end. /* IF NOT ERR_FLAG */
         else do:
            pod_qty_chg = 0.

            if not pod_sched then
               pod_bo_chg = pod_qty_ord - pod_qty_rcvd.
            else do:
               {gprun.i ""rsoqty.p""
                        "(input  recid(pod_det),
                          input  eff_date,
                          output qopen)"}
               pod_bo_chg = qopen.
            end. /* ELSE DO: */
         end. /* ELSE DO: */

         /*! CHECK PRICE LIST FOR SCHEDULED ITEMS */
         if pod_sched then do:
           {gprun.i ""gpsct05.p""
                    "(input        pod_part,
                      input        pod_site,
                      input        2,
                      output       glxcst,
                      output       curcst)"}

           glxcst = glxcst * pod_um_conv.

           if ip_po_curr <> base_curr
           then do:
              {pxrun.i &PROC='mc-curr-conv'
                       &PROGRAM='mcpl.p'
                       &HANDLE=ph_mcpl
                       &PARAM="(input  base_curr,
                                input  ip_po_curr,
                                input  exch_rate2,
                                input  exch_rate,
                                input  glxcst,
                                input  true,
                                output glxcst,
                                output mc-error-number)"}

              if mc-error-number <> 0
              then do:
                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
              end. /* IF mc-error-number <> 0 */
           end. /* IF ip_po_curr <> base_curr */

           dummy_disc = 0.
           /* CHANGED EIGHTH INPUT PARAMETER TO glxcst FROM pod_pur_cost */
           /* AND ELVENTH PARAMETER TO glxcst FROM newprice              */
           {gprun.i ""gppccal.p""
                    "(input        pod_part,
                      input        qopen,
                      input        pod_um,
                      input        pod_um_conv,
                      input        ip_po_curr,
                      input        pod_pr_list,
                      input        eff_date,
                      input        glxcst,
                      input        no,
                      input        dummy_disc,
                      input-output glxcst,
                      output       dummy_disc,
                      input-output newprice,
                      output       pc_recno)" }

            /* IF NO LIST PRICE WAS FOUND LETS TRY TO CHECK FOR   */
            /* A VP_Q_PRICE FOR THE ITEM.  IF WE CANT FIND ONE,   */
            /* POD_PRICE WILL REMAIN AS IT WAS ORIGINALLY.        */

            if pc_recno = 0 or newprice = 0 then do:

               run find-vp-mstr
                  (input pod_part, input ip_po_vend,
                   input pod_um,   input ip_po_curr,
                   input pod_vpart).

               if set_flag then pod_pur_cost = pur_cost.

            end. /* IF PC_RECNO = 0 OR NEWPRICE = 0 */
            else pod_pur_cost = newprice.
         end. /* IF POD_SCHED */

         if not porec then
            assign
               pod_qty_chg = - pod_qty_chg
               pod_bo_chg  = - pod_bo_chg.

         if pod_qty_chg <> 0 then do:
            create sr_wkfl.
            assign
               sr_userid = mfguser
               sr_lineid = string(pod_line)
               sr_site   = pod_site
               sr_loc    = pod_loc
               sr_lotser = ""
               sr_ref    = ""
               sr_qty    = pod_qty_chg.
            if recid(sr_wkfl) = -1 then .
         end. /* IF POD_QTY_CHG <> 0 */

         /* MOVED CODE BELOW INTO AN INTERNAL PROCEDURE */

         run if_porec_or_is_return
            (input pod_site,   input  pod_loc, input pod_part,
             input pod_serial, output undo_loop).

         if undo_loop then undo preppoddet, next preppoddet.

         {gprun.i ""gpsiver.p""
                  "(input pod_site,
                    input ?,
                    output return_int)"}

      end. /* IF FILL-ALL = YES */
   /*@MODULE RCV-ALL END*/

      {pxrun.i &PROC='assignDefaultsForNewLine' &PROGRAM='porcxr1.p'
               &PARAM="(buffer pod_det,
                        input  fill-all,
                        output vCancelBackOrder,
                        output vSiteId)"
               &NOAPPERROR=True
               &CATCHERROR=True}
   end. /* FOR EACH POD_DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE p-assign :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
p-assign (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input  parameter l_pod_sched    like pod_sched    no-undo.
   define input  parameter l_qty_ord      like pod_qty_ord  no-undo.
   define input  parameter l_qty_rcvd     like pod_qty_rcvd no-undo.
   define input  parameter l_recid        as   recid        no-undo.
   define output parameter l_qty_chg      like pod_qty_chg  no-undo.

   if not l_pod_sched then
      assign l_qty_chg  = l_qty_ord - l_qty_rcvd.
   else do:
      {gprun.i ""rsoqty.p""
               "(input l_recid,
                 input eff_date,
                 output qopen)"}
      assign l_qty_chg  = qopen.
   end. /* ELSE DO */

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-attr-wkfl :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-attr-wkfl (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_line           like pod_line           no-undo.
   define input parameter inpar_assay          like pod_assay          no-undo.
   define input parameter inpar_grade          like pod_grade          no-undo.
   define input parameter inpar_expire         like pod_expire         no-undo.
   define input parameter inpar_rctstat        like pod_rctstat        no-undo.
   define input parameter inpar_rctstat_active like pod_rctstat_active no-undo.
   define input parameter inpar_part           like pod_part           no-undo.
   define input parameter inpar_site           like pod_site           no-undo.
   define input parameter inpar_loc            like pod_loc            no-undo.
   define input parameter inpar_recid          as   recid              no-undo.

   /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/
   find first attr_wkfl
      where chg_line = string(inpar_line) exclusive-lock no-error.
   if not available attr_wkfl then do:
      create attr_wkfl.
      chg_line = string(inpar_line).
   end. /* IF NOT AVAILABLE ATTR_WKFL */

   {pxrun.i &PROC='initializeAttributes' &PROGRAM='porcxr1.p'
            &PARAM="(buffer pod_det,
                     input  eff_date,
                     output chg_assay,
                     output chg_grade,
                     output chg_expire,
                     output chg_status,
                     output assay_actv,
                     output grade_actv,
                     output expire_actv,
                     output status_actv,
                     output err_flag)"
            &NOAPPERROR=True
            &CATCHERROR=True}

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-gploc02 :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-gploc02 (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter loc__qad01 like loc__qad01 no-undo.

   for first sr_wkfl
      where recid(sr_wkfl) = recno_sr_wkfl:
   end. /* FOR FIRST SR_WKFL */

   {gploc02.i pod_det pod_nbr pod_line pod_part}

   err = error_flag.

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-mfmsg :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-mfmsg (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   /* MESSAGE #596 - TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOCATION */
   {pxmsg.i
      &MSGNUM=596
      &ERRORLEVEL={&WARNING-RESULT}}

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-mfmsg02 :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-mfmsg02 (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_part like pod_part no-undo.

   /* MESSAGE #161 - UNABLE TO ISSUE OR RECEIVE FOR ITEM */
   {pxmsg.i
      &MSGNUM=161
      &ERRORLEVEL={&WARNING-RESULT}
      &MSGARG1=inpar_part}

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-rts :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-rts (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_nbr like po_nbr no-undo.

   for each pod_det
      fields (pod_assay pod_bo_chg pod_expire pod_fsm_type
              pod_grade pod_line pod_loc pod_nbr pod_part
              pod_po_db pod_pr_list pod_ps_chg pod_pur_cost
              pod_qty_chg pod_qty_ord pod_qty_rcvd pod_rctstat
              pod_rctstat_active pod_rma_type pod_rum pod_rum_co
              pod_sched pod_serial pod_site pod_status pod_type
              pod_um pod_um_conv pod_vpart)
      where pod_nbr      =  inpar_nbr
        and pod_rma_type =  "O"
        and pod_status   <> "c"
        and pod_status   <> "x" exclusive-lock:

      if pod_qty_chg <> 0 then
         assign
            pod_qty_chg = - pod_qty_chg
            pod_bo_chg  = - pod_bo_chg
            pod_ps_chg  = - pod_ps_chg.

      for each sr_wkfl exclusive-lock
         where sr_userid = mfguser
           and sr_lineid = string(pod_line):
         sr_qty = - sr_qty.
      end. /* FOR EACH SR_WKFL */
   end. /* FOR EACH POD_DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc-sup-perf :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc-sup-perf (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   /** POP-UP TO COLLECT PERFORMANCE RECEIPT DATE **/
   /** CHECK THAT SUPPLIER PERFORMANCE DATA SHOULD BE COLLECTED **/
   if {pxfunct.i &FUNCTION = 'isSupplierPerformanceEnabled' &PROGRAM = 'adsuxr.p'}
   then do:
      {gprunmo.i
         &program =""popove.p""
         &module="ASP"
         &param="""(input recid(po_mstr))"""}
   end. /* IF ENABLE SUPPLIER PERFORMANCE */

END PROCEDURE.

/*============================================================================*/
PROCEDURE proc1-mfmsg02 :
/*------------------------------------------------------------------------------
<Comment1>
poporcm.tag.p
proc1-mfmsg02 (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter inpar_status like pt_status no-undo.

   /* MESSAGE #373 - RESTRICTED TRANSACTION FOR STATUS CODE: */
   {pxmsg.i
      &MSGNUM=373
      &ERRORLEVEL={&APP-ERROR-RESULT}
      &MSGARG1="inpar_status"}

END PROCEDURE.

/* TO REMOVE ACTION SEGMENT ERROR CREATED INTERNAL PROCEDURE */

PROCEDURE p-tax-detail:

   define variable l_tax_edited like mfc_logical          initial true  no-undo.
   define variable l_flag       like mfc_logical extent 2 initial true  no-undo.

   for each tx2d_det
      fields(tx2d_edited tx2d_line tx2d_nbr tx2d_ref tx2d_tr_type)
      where tx2d_ref     = po_mstr.po_nbr
      and   tx2d_tr_type = "20"
      no-lock:

      {gprun.i ""txedtchk.p""
               "(input "20",
                 input tx2d_ref,
                 input """",
                 input tx2d_line,
                 output l_tax_edited)"}

      if l_tax_edited
         and l_flag[2]
      then do:
         /* EDITED PREVIOUS TAX VALUES TYPE 20: RECALCULATE? */
         {pxmsg.i
            &MSGNUM=2579
            &ERRORLEVEL=2
            &MSGARG1="20"
            &CONFIRM=l_flag[1]}
         l_flag[2] = no.
      end. /* IF l_tax_edited ....... */

      if not l_tax_edited
         or  l_flag[1]
      then do:
         {gprun.i ""txcalc.p""
                  "(input "20",
                    input tx2d_ref,
                    input """",
                    input tx2d_line,
                    input no,
                    output result-status)"}.
      end. /* IF not l_tax_edited .... */

   end. /* FOR EACH tx2d_det ... */

END PROCEDURE. /* p-tax-detail */
