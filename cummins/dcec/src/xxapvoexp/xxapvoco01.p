/* GUI CONVERTED from apvoco01.p (converter v1.78) Wed Jun 17 22:33:13 2009 */
/* apvoco01.p - CONFIRM VOUCHERS SELECTED CRITERIA RANGE                      */
/* Copyright 1986-2009 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.0      LAST MODIFIED: 08/15/91   by: mlv *F002*                */
/*                                   01/13/92   by: mlv *F082*                */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   by: jms *G024*                */
/*                                   09/27/93   by: jcd *G247*                */
/*                                   05/06/93   by: bcm *GA58*                */
/*                                   07/06/93   by: jms *GD18*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   by: pcd *H039*                */
/*                                   08/30/93   by: pcd *H099*                */
/*                                   04/05/94   by: pcd *H323*                */
/*                                   09/12/94   by: slm *GM17*                */
/*                                   09/26/94   by: bcm *H479*                */
/*                                   09/29/94   by: bcm *H542*                */
/*                                   03/06/95   by: srk *G0G4*                */
/*                                   03/29/95   by: dzn *F0PN*                */
/*                                   04/25/95   by: wjk *H0CS*                */
/*                                   09/05/95   by: jzw *H0FR*                */
/*                                   10/24/95   by: jzw *G1B3*                */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   by: mwd *J053*                */
/*                                   04/05/96   by: jzw *G1T9*                */
/*                                   07/31/96   by: M. Deleeuw *J12H*         */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: bjl *K001*                */
/*                                   11/19/96   BY: jpm *K020*                */
/*                                   03/09/97   BY: *K082* E. Hughart         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.9               */
/* REVISION: 9.0      LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N009* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0C9* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MG* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *M0T8* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0W0* Mudit Mehta        */
/* Revision: 1.11.1.14     BY: Katie Hilbert       DATE: 04/27/01 ECO: *N0Y7* */
/* Revision: 1.11.1.15     BY: Vinod Nair          DATE: 08/07/01 ECO: *M1GX* */
/* Revision: 1.11.1.16     BY: Mercy Chittilapilly DATE: 03/18/02 ECO: *M1WF* */
/* Revision: 1.11.1.17     BY: Patrick Rowan       DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.11.1.18     BY: Paul Donnelly       DATE: 12/10/01 ECO: *N16J* */
/* Revision: 1.11.1.20     BY: Lena Lim            DATE: 06/06/02 ECO: *P07V* */
/* Revision: 1.11.1.23     BY: Samir Bavkar        DATE: 06/20/02 ECO: *P09D* */
/* Revision: 1.11.1.24     BY: Hareesh V.          DATE: 06/21/02 ECO: *N1HY* */
/* Revision: 1.11.1.25     BY: Robin McCarthy      DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.11.1.26     BY: Manjusha Inglay     DATE: 07/29/02 ECO: *N1P4* */
/* Revision: 1.11.1.27     BY: Mercy Chittilapilly DATE: 08/19/02 ECO: *N1RM* */
/* Revision: 1.11.1.29     BY: Piotr Witkowicz     DATE: 03/17/03 ECO: *P0NP* */
/* Revision: 1.11.1.30     BY: Orawan S.           DATE: 04/23/03 ECO: *P0QC* */
/* Revision: 1.11.1.32     BY: Paul Donnelly (SB)  DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.11.1.33     BY: Rajinder Kamra      DATE: 04/25/03 ECO: *Q003* */
/* Revision: 1.11.1.34     BY: Patrick de Jong     DATE: 07/22/03 ECO: *Q019* */
/* Revision: 1.11.1.35     BY: Sachin Deshmukh     DATE: 10/13/04 ECO: *P2G6* */
/* Revision: 1.11.1.36     BY: Tony Brooks         DATE: 05/11/05 ECO: *N322* */
/* Revision: 1.11.1.37     BY: Steve Nugent        DATE: 07/26/05 ECO: *P2PJ* */
/* $Revision: 1.11.1.37.2.1 $     BY: Ashim Mishra        DATE: 06/15/09 ECO: *Q30M* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=FullGUIReport                                                */
/*! --------------------------------------------------------------------------*
 * Version 8.6F Program Structure (of significant programs only):-
 *
 *  apvoco01.p         Voucher Confirmation (Automatic), menu 28.6
 *    apapgl.p         Control GL creation for AP vouchers
 *                     (also run by aprvvo.p, apvoco.p, apvomt.p, apvomtk.p)
 *      apglpl.p       procedure apgl-create-all-glt
 *        gpglpl.p     procedure gpgl-convert-to-account-currency
 *        gpglpl.p     procedure gpgl-create-one-glt
 *    apvocsu1.p       Update Item Cost, create tr_hist and trgl_det
 *                     (also run from apvomtk3.p and apvoco.p)
 *      apvotax.i      Inventory cost tax calculation
 *I     apvocsua.p     Update Item Cost, create tr_hist and trgl_det
 *    gpacctp.p        Display GL distribution
 *    gpglrp.p         Display currency summary
 *
 *I = runs connected to inventory site database
 *----------------------------------------------------------------------------*
*/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "20121026.1"}
{cxcustom.i "APVOCO01.P"}

/* DEFINE GPRUNP VARIABLES OUTSIDE OF FULL GUI INTERNAL PROCEDURES */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mgdompl" "p"}

{pxpgmmgr.i}

{gldydef.i new}
{gldynrm.i new}

define variable voucher like vo_ref.
define variable voucher1 like vo_ref.
define variable vend like ap_vend.
define variable vend1 like ap_vend.
define variable batch like ap_batch.
define variable batch1 like ap_batch.
define variable apdate like ap_date label "Voucher Date".
define variable apdate1 like ap_date.
define variable effdate like ap_effdate
   label "Effective (Blank to not change)".
define variable apeffdate like ap_effdate.
define variable name like ad_name.
define variable confirm like mfc_logical
   label "Confirm" initial yes.

define new shared variable base_amt like ap_amt.
define new shared variable curr_amt like ap_amt.
define new shared variable base_det_amt like ap_amt.
define new shared variable undo_all like mfc_logical.
define new shared variable vod_recno as recid.
define new shared variable vo_recno as recid.
define new shared variable ap_recno as recid.
define new shared variable vph_recno as recid.
define new shared variable prh_recno as recid.
define new shared variable jrnl like glt_ref.
define new shared variable rndmthd  like rnd_rnd_mthd.
define new shared variable old_curr like ap_curr.
/* SHARED VARIABLE DEL-YN NEEDED FOR PRM ROUTINE PJAPUPDT.P */
define new shared variable del-yn   like mfc_logical initial no.

define variable base_rpt like ap_curr.
define variable mixed_rpt like mfc_logical initial no
   label "Mixed Currencies".
define variable entity like ap_entity.
define variable entity1 like ap_entity.
define variable disp_curr as character format "x(1)".
define variable summary like mfc_logical format "Summary/Detail"
   label "Summary/Detail".
define variable votype like vo_type.
define variable votype1 like vo_type.
define variable authorized like emp_addr.
define variable authorized1 like emp_addr.
define variable vopo like vpo_po.
define variable current_batch like ap_batch.
define variable batch_base_amt like ap_amt.
define variable total_base_amt like ap_amt.
define variable batch_reject_base_amt like ap_amt.
define variable total_reject_base_amt like ap_amt.
define variable base_amt_fmt as character no-undo.
define variable ap_amt_fmt   as character no-undo.
define variable ap_amt_old   as character no-undo.
define variable oldsession   as character.
define variable doc-numeric-format as character.
define variable detl_amt        like ap_amt.
define variable mc-error-number like msg_nbr no-undo.
define variable msg          as character no-undo.
define variable l_entity_ok     like mfc_logical no-undo.

define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.
define variable use-log-acctg as logical no-undo.
define variable log_charge_voucher like mfc_logical no-undo.
{&APVOCO01-P-TAG5}
define variable lv_error_num as integer no-undo.
define variable lv_name      as character no-undo.
define variable l_msg        as character no-undo format "x(70)".





{apconsdf.i}
{&APVOCO01-P-TAG2}

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

/*DEFINE WORKFILE FOR CURRENCY ACCUMULATIONS*/
{gpacctp.i "new"}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
skip (1)
   batch          colon 15
   batch1         colon 45 label "To"
   vend           colon 15
   vend1          colon 45 label "To"
   voucher        colon 15
   voucher1       colon 45 label "To"
   votype         colon 15
   votype1        colon 45 label "To" skip
   apdate         colon 15
   apdate1        colon 45 label "To"
   entity         colon 15
   entity1        colon 45 label "To"
   authorized     colon 15 label "Assigned-To"
   authorized1    colon 45 label "To" skip(1)
   effdate        colon 32
   confirm        colon 32
   summary        colon 32
   base_rpt       colon 32
   mixed_rpt      colon 32
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   ap_batch
with STREAM-IO /*GUI*/  frame b side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   vo__qad01 column-label "Assigned-To"
   vo_ref
   ap_vend
   name
   apeffdate
   ap_date
   ap_vend
   vo_invoice  format "x(16)"
   vo_po
   ap_entity
   ap_curr
   base_amt
   disp_curr no-label
with STREAM-IO /*GUI*/  frame c width 132 down.


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

FORM /*GUI*/ 
   space(4)
   vod_ln
   vod_acct
   vod_sub
   vod_cc
   vod_project
   vod_entity
   base_amt
   vod_desc
with STREAM-IO /*GUI*/  frame d width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* FORM FOR TOTALS */
FORM /*GUI*/ 
   vo_ref
   ap_vend
   name
   apeffdate
   ap_date
   vo_invoice format "x(16)"
   vo_po
   ap_entity
   ap_curr
   base_amt
with STREAM-IO /*GUI*/  frame e no-labels width 132 down.

assign
   base_amt_fmt = base_amt:format in frame c
   ap_amt_old   = base_amt:format in frame c.
{gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                          input gl_rnd_mthd)"}

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* ASSUMED START UP SESSION IS FOR BASE CURRENCY */
oldsession = SESSION:numeric-format.


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if batch1 = hi_char then batch1 = "".
   if vend1 = hi_char then vend1 = "".
   if voucher1 = hi_char then voucher1 = "".
   if apdate = low_date then apdate = ?.
   if apdate1 = hi_date then apdate1 = ?.
   if entity1 = hi_char then entity1 = "".
   if votype1 = hi_char then votype1 = "".
   if authorized1 = hi_char then authorized1 = "".

   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   /* VERIFY GL EFFECTIVE DATE FOR PRIMARY ENTITY     */
   /* (USE PRIMARY SINCE THEY CAN EDIT ENITY FIELD IN */
   /* THE NEXT FRAME - USE WARNING IF POSSIBLE)       */

   if effdate <> ? then do:

      {gpglef01.i ""AP"" glentity effdate}
      if gpglef > 0 then do:
         /* IF PERIOD CLOSED THEN WARNING ONLY */
         if gpglef = 3036 then do:
            {pxmsg.i &MSGNUM=3005 &ERRORLEVEL=2}
            /* OTHERWISE REGULAR ERROR MESSAGE */
         end.
         else if gpglef <> 3036 then do:
            {pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=3}
            /*GUI NEXT-PROMPT removed */
            /*GUI UNDO removed */ RETURN ERROR.
         end.
      end.

   end. /* IF EFFDATE <> ? */

   bcdparm = "".

   {gprun.i ""gpquote.p""
      "(input-output bcdparm, 19,
                  batch,
                  batch1,
                  vend,
                  vend1,
                  voucher,
                  voucher1,
                  votype,
                 votype1,
                 string(apdate),
                 string(apdate1),
                 entity,
                 entity1,
                 authorized,
                 authorized1,
                 string(effdate),
                 string(confirm),
                 string(summary),
                 base_rpt,
                 string(mixed_rpt),
                 null_char)"}

   if  batch1 = "" then batch1 = hi_char.
   if  vend1 = "" then vend1 = hi_char.
   if  voucher1 = "" then voucher1 = hi_char.
   if  apdate1 = ? then apdate1 = hi_date.
   if  apdate = ? then apdate = low_date.
   if  entity1 = "" then entity1 = hi_char.
   if  votype1 = "" then votype1 = hi_char.
   if  authorized1 = "" then authorized1 = hi_char.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

define buffer apmstr for ap_mstr.
define buffer vomstr for vo_mstr.
define buffer voddet for vod_det.



   /* DELETE GL WORKFILE ENTRIES */
   do transaction:
      /* CORRECTED EXCLUSIVE TO EXCLUSIVE-LOCK BELOW */
      for each gltw_wkfl exclusive-lock  where gltw_wkfl.gltw_domain =
      global_domain and  gltw_userid = mfguser:
         delete gltw_wkfl.
      end.
   end.

   /* DELETE AP CURRENCY SUMMARY WORKFILE */
   do transaction:
      for each ap_wkfl exclusive-lock:
         delete ap_wkfl.
      end.
   end.

   {mfphead.i}

   assign
      current_batch = ?
      total_base_amt = 0
      total_reject_base_amt = 0.

   find first apc_ctrl  where apc_ctrl.apc_domain = global_domain no-lock.

   voucherloop:
   for each ap_mstr  where ap_mstr.ap_domain = global_domain and (  ap_type =
   "VO"
         and (ap_batch >= batch and ap_batch <= batch1)
         and (ap_vend >= vend and ap_vend <= vend1)
         and (ap_ref >= voucher and ap_ref <= voucher1)
         and (ap_date >= apdate and ap_date <= apdate1)
         and (ap_entity >= entity and ap_entity <= entity1)
         and ((ap_curr = base_rpt) or (base_rpt = ""))
         ) no-lock,
         each vo_mstr  where vo_mstr.vo_domain = global_domain and  vo_ref =
         ap_ref and vo_confirmed = no
         and (vo_type >= votype and vo_type <= votype1)
         and (vo__qad01 >= authorized and vo__qad01 <= authorized1)
         /* ss lambert 20121026  
         and vo__chr01 = "SS.Lambert"
         ss lambert 20121026 */
         no-lock
         break by ap_batch by vo__qad01 by ap_ref
         on error undo voucherloop, leave:
        {&APVOCO01-P-TAG3}
      assign
         vo_recno = recid(vo_mstr)
         ap_recno = recid(ap_mstr).

      /* CHECK IF ANOTHER USER HAS CONFIRMED SINCE SELECTION, */
      /* POSSIBLE WITH MULTIPLE USERS WITH OVERLAPPING SELECTIONS */
      do for vomstr:
         find vomstr where recid(vomstr) = vo_recno
            no-lock.
         if vo_confirm = yes then next voucherloop.
      end.

      /* DETERMINE IF THIS IS A LOGISTICS CHARGE VOUCHER */
      log_charge_voucher = false.
      if use-log-acctg then do:
         for first vph_hist
         fields( vph_domain vph_pvo_id)
          where vph_hist.vph_domain = global_domain and  vph_ref = vo_ref
         and can-find(first pvo_mstr  where pvo_mstr.pvo_domain = global_domain
         and  pvo_id = vph_pvo_id
                                      and pvo_lc_charge <> "")
         no-lock:
            log_charge_voucher = true.
         end.
      end. /* IF USE LOGISTICS ACCTNG AND AVAILABLE VO_MSTR */

      if vo_curr <> old_curr or old_curr = "" then do:

         /* GET ROUNDING METHOD FROM CURRENCY MASTER */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input vo_curr,
              output rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
            pause.
            undo voucherloop, next voucherloop.
         end.

         ap_amt_fmt = ap_amt_old.
         {gprun.i ""gpcurfmt.p"" "(input-output ap_amt_fmt,
                                   input rndmthd)"}

         /* GET PUNCTUATION EUROPEAN OR AMERICAN */
         {apcurpnc.i "voucherloop"}
         doc-numeric-format = SESSION:numeric-format.

         old_curr = vo_curr.
      end.

      /* IF CHANGE OF BATCH, DO BATCH TOTALS, START NEW BATCH */
      if ap_batch <> current_batch then do:
         if current_batch <> ? then do:
            if base_rpt = "" then
            assign
               base_amt:format in frame e = base_amt_fmt
               SESSION:numeric-format = oldsession.
            else
            assign
               base_amt:format in frame e = ap_amt_fmt
               SESSION:numeric-format = doc-numeric-format.

            display
               "" @ vo_invoice
               "" @ vo_po
               "----------------" @ base_amt with frame e STREAM-IO /*GUI*/ .
            down 1 with frame e.
            display

               (if base_rpt = "" then "  " + getTermLabel("BASE",4)
               else "   " + base_rpt)
               + " " + getTermLabel("BATCH",5) @ vo_invoice
               getTermLabel("TOTAL",5) + ":" @ vo_po

               batch_base_amt @ base_amt
            with frame e STREAM-IO /*GUI*/ .
            down 1 with frame e.
            total_base_amt = total_base_amt + batch_base_amt.
            if batch_reject_base_amt <> 0 then do:

               display
                  getTermLabelRt("ERROR",10) @ vo_invoice
                  getTermLabel("VOUCHERS",8) + ":" format "x(9)" @ vo_po
                  batch_reject_base_amt @ base_amt
               with frame e STREAM-IO /*GUI*/ .
               down 1 with frame e.
               total_reject_base_amt = total_reject_base_amt
                                     + batch_reject_base_amt.
            end.
         end.
         assign
            current_batch = ap_batch
            batch_base_amt = 0
            batch_reject_base_amt = 0.

         display ap_batch with frame b STREAM-IO /*GUI*/ .

         if confirm
         then do:
            /* GET NEXT JOURNAL REFERENCE NUMBER  */
            do transaction:
           {apnjrnl.i today jrnl}
            end.
            /* MFNCTRL RELEASES APC_CTRL, SO WE NEED TO FIND AGAIN */
            find first apc_ctrl  where apc_ctrl.apc_domain = global_domain
            no-lock.
         end. /* IF CONFIRM */
      end.

      {&APVOCO01-P-TAG1}
      /*DISPLAY VOUCHERS BEING CONFIRMED*/
      name = "".
      find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      ap_vend no-lock no-error.

      find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr =
      ap_mstr.ap_vend no-lock no-error.
      if (available vd_mstr and vd_misc_cr) and
         ap_mstr.ap_remit <> ""
      then
         find first ad_mstr  where ad_mstr.ad_domain = global_domain and
         ad_addr = ap_mstr.ap_remit
         no-lock no-error.

      if available ad_mstr then name = ad_name.
      if effdate <> ? then apeffdate = effdate.
      else apeffdate = ap_effdate.

      /*IF NECESSARY, CONVERT AMOUNT TO BASE*/
      /*IF MIXED_RPT, LEAVE FOREIGN AMOUNTS IN THEIR ORIG CURR*/

      /* TO RECTIFY THE AMOUNT FORMAT DISPLAYED IN FRAME c */
      if base_rpt = ""
         and not mixed_rpt
      then
         assign
            SESSION:numeric-format     = oldsession
            base_amt:format in frame c = base_amt_fmt.
      else
         assign
            SESSION:numeric-format     = doc-numeric-format
            base_amt:format in frame c = ap_amt_fmt.

      if ap_curr = base_curr or ap_curr = base_rpt
      then
         base_amt = ap_amt.
      else
         base_amt = ap_base_amt.

      /* SET disp_curr to 'Y' ONLY WHEN THE AMOUNT IS CONVERTED */
      if (base_rpt   =  ""
          and not mixed_rpt)
         and ap_curr <> base_curr
      then
         disp_curr = getTermLabel("YES",1).
      else
         disp_curr = " ".

      find first vpo_det  where vpo_det.vpo_domain = global_domain and  vpo_ref
      = vo_ref no-lock no-error.
      vopo = if available vpo_det then vpo_po else "".

      display
         vo__qad01 column-label "Assigned-To"
         vo_ref
         ap_vend
         name
         apeffdate
         ap_date
         ap_vend
         vo_invoice  format "x(16)"
         vopo @ vo_po
         ap_entity
         ap_curr
         if base_rpt = "" and mixed_rpt = no then base_amt else
         ap_amt @ base_amt
         disp_curr no-label
      with frame c STREAM-IO /*GUI*/ .
      down with frame c.

      {glenchk.i &entity=ap_mstr.ap_entity &entity_ok=l_entity_ok}
      if not l_entity_ok
      then
         next voucherloop.

      /* Multiple PO section -- Begin */
      find next vpo_det  where vpo_det.vpo_domain = global_domain and  vpo_ref
      = vo_ref no-lock no-error.
      do while available vpo_det:
         down 1 with frame c.
         display vpo_po @ vo_po with frame c STREAM-IO /*GUI*/ .
         find next vpo_det  where vpo_det.vpo_domain = global_domain and
         vpo_ref = vo_ref no-lock no-error.
      end.
      /* Multiple PO section -- End */

      batch_base_amt = batch_base_amt + base_amt.

      /* CHECK THAT INVENTORY DOMAINS ARE CONNECTED */
         for each vph_hist
               fields /* (none) */
                where vph_hist.vph_domain = global_domain and  vph_ref = vo_ref
               no-lock,
               each pvo_mstr
               fields( pvo_domain pvo_internal_ref pvo_line)
                where pvo_mstr.pvo_domain = global_domain and  pvo_id =
                vph_pvo_id  and
                     pvo_lc_charge   = "" and
                     pvo_internal_ref_type = {&TYPE_POReceiver}
               no-lock,
               each prh_hist
               fields( prh_domain prh_site)
                where prh_hist.prh_domain = global_domain and  prh_receiver =
                pvo_internal_ref
               and prh_line = pvo_line
               no-lock,
               first si_mstr
               fields( si_domain si_db)
                where si_mstr.si_domain = global_domain and  si_site = prh_site
               no-lock
               break by si_db:
         if first-of(si_db) then do:
            if global_db <> si_db then do:
               {gprunp.i "mgdompl" "p" "ppDomainConnect"
                                  "(input si_db,
                                    output lv_error_num,
                                    output lv_name)"}

               if lv_error_num <> 0 then do:
                 {pxmsg.i &MSGNUM=lv_error_num
                          &ERRORLEVEL=3
                          &MSGBUFFER=l_msg
                          &MSGARG1=lv_name}
                  put l_msg
                  skip(1).
               batch_reject_base_amt = batch_reject_base_amt
                                     + base_amt.
               next voucherloop.
            end.
         end.
      end.
      end.

      /* VALIDATE GL PERIOD FOR THIS ENTITY AND EFFECTIVE DATE */
      {gpglef01.i ""AP"" ap_entity apeffdate}
      if gpglef > 0 then do:
         /* IF PERIOD CLOSED */
         if gpglef = 3036 then do:

            {pxmsg.i &MSGNUM = 3721 &MSGBUFFER = msg}
            put msg
               skip(1).
            batch_reject_base_amt = batch_reject_base_amt
                                  + base_amt.
            next voucherloop.
         end.
         /* OTHER ERROR MESSAGES */
         else if gpglef <> 3036 then do:

            {pxmsg.i &MSGNUM = 3722 &MSGBUFFER = msg}
            put msg
               skip(1).
            batch_reject_base_amt = batch_reject_base_amt
                                  + base_amt.
            next voucherloop.
         end.
      end.

      /* IT IS EXTREMELY IMPORTANT THAT THIS TRANSACTION COVERS:- */
      /* 1. UPDATING VOUCHER MASTER TO CONFIRMED                  */
      /* 2. UPDATING AP MASTER EFFECTIVE DATE                     */
      /* 3. FOR EACH VOUCHER DETAIL, CREATING GL TRANSACTIONS     */
      /* 4. FOR EACH VOUCHER DETAIL, CREATING GL REPORT WORKFILE  */
      /* 5. UPDATING SUPPLIER BALANCE                             */
      /* 6. UPDATING ITEM AVERAGE COSTS                           */

      do transaction on error undo voucherloop, leave:

         /*SET CONFIRMED FLAG AND EFFECTIVE DATE*/
         if confirm = yes then do:

            do for vomstr:
               find vomstr where recid(vomstr) = vo_recno
                  exclusive-lock.
               /* IF ANOTHER USER HAS CONFIRMED SINCE SELECTION, */
               /* SKIP THIS VOUCHER, PROCESS NEXT VOUCHER */
               if vo_confirm = yes then do:

                  {pxmsg.i &MSGNUM = 3723 &MSGBUFFER = msg}
                  put msg
                     skip(1).
                  batch_reject_base_amt = batch_reject_base_amt
                                        + base_amt.
                  next voucherloop.
               end.
               vo_confirm = yes.
               /* SS Lambert 20121026 */
               vo__chr02 = "SS.Lambert".
               /* SS Lambert 20121026 */
               vo_conf_by = report_userid.

               {&APVOCO01-P-TAG6}

               release vomstr.
            end.

            if effdate <> ?
            then
               do for apmstr:
                  find apmstr
                     where recid(apmstr) = ap_recno
                  exclusive-lock.
                     ap_effdate = effdate.
                     for each vph_hist
                        where vph_domain = global_domain
                        and   vph_ref    = ap_ref
                     exclusive-lock:
                        vph_inv_date = ap_effdate.
                     end. /* FOR EACH vph_hist */
                  release apmstr.
               end. /* DO FOR apmstr: */
            {&APVOCO01-P-TAG4}
         end.  /* IF CONFIRM = YES */

         /* STORE TOTALS, BY CURRENCY, IN WORK FILE. */
         if base_rpt = ""
            and mixed_rpt
         then do:
            find first ap_wkfl where vo_curr = apwk_curr no-error.
            /* If a record for this currency doesn't exist, */
            /* Create one. */
            if not available ap_wkfl then do:
               create ap_wkfl.
               apwk_curr = ap_curr.
            end.
            /* Accumulate individual currency totals in work file. */
            apwk_for = apwk_for + ap_amt.
            if base_curr <> ap_curr then
               apwk_base = apwk_base + base_amt.
            else
               apwk_base = apwk_for.
         end. /* IF BASE_RPT = "" */

         /* PROCESS ALL DETAILS FOR THIS VOUCHER */
         for each vod_det  where vod_det.vod_domain = global_domain and
         vod_ref = vo_ref no-lock:

            /* CALCULATE BASE AMOUNT TO POST TO GL AND GL REPORT */

            assign
               base_amt = vod_base_amt
               curr_amt = vod_amt.

            /* CREATE GLT_DET */
            if confirm then do:
               assign
                  vod_recno = recid(vod_det)
                  undo_all = yes
                  base_det_amt = base_amt.
               {gprun.i ""apapgl.p""}

               do for voddet:

                  find first voddet
                     where recid(voddet) = vod_recno
                     exclusive-lock no-error.
                  if available voddet
                  then
                     voddet.vod_dy_num = nrm-seq-num.

                  release voddet.

               end. /* DO FOR voddet */

               if undo_all then undo voucherloop, leave.
            end.

            /* DISPLAY DETAIL */
            if summary = no then do:

               display
                  space(4)
                  vod_ln
                  vod_acct vod_sub vod_cc
                  vod_project
                  vod_entity
               with frame d width 132 down STREAM-IO /*GUI*/ .

               if base_rpt = ""
                  and mixed_rpt = no
               then
               assign
                  detl_amt = base_amt
                  SESSION:numeric-format = oldsession
                  base_amt:format in frame d = base_amt_fmt.
               else
               assign
                  detl_amt = vod_amt
                  SESSION:numeric-format = doc-numeric-format
                  base_amt:format in frame d = ap_amt_fmt.

               display detl_amt @ base_amt vod_desc with frame d STREAM-IO /*GUI*/ .
               down with frame d.

            end.  /** IF SUMMARY = NO **/

            /* LOCK VENDOR SO GLTW_WKFL CAN BE CREATED WITH */
            /* VENDOR, RFLAG AND LINE AS UNIQUE KEY.        */
            /* NO UPDATE WILL BE DONE.                      */
            find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr
            = ap_vend
               exclusive-lock no-error.

            /* CREATE WORKFILE RECORDS FOR GL PRINT */
            /* ALL GL AMOUNTS SHOWN IN BASE */
            /* CREDIT TO AP */

            {gpnextln.i &ref=ap_vend &line=return_int}
            create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
            assign
               gltw_entity = ap_entity
               gltw_acct = ap_acct
               gltw_sub = ap_sub
               gltw_cc = ap_cc
               gltw_ref = ap_vend
               gltw_line = return_int
               gltw_date = ap_date
               gltw_effdate = apeffdate /*ap_effdate*/
               gltw_userid = mfguser
               gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
                         + " " + ap_vend
               gltw_amt = - base_amt
               recno = recid(gltw_wkfl).
            /* DEBIT TO VOD_ACCT */
            {gpnextln.i &ref=ap_vend &line=return_int}
            create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
            assign
               gltw_entity = vod_entity
               gltw_acct = vod_acct
               gltw_sub = vod_sub
               gltw_cc = vod_cc
               gltw_project = vod_project
               gltw_ref = ap_vend
               gltw_line = return_int
               gltw_date = ap_date
               gltw_effdate = apeffdate /*ap_effdate*/
               gltw_userid = mfguser
               gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
                         + " " + ap_vend
               gltw_amt = base_amt
               recno = recid(gltw_wkfl).

            /* FOLLOWING SECTION FOR INTERCOMPANY TRANSACTION */
            if (ap_entity <> vod_entity)
            then do:
               {glenacex.i &entity=vod_entity
                        &type='"CR"'
                        &module='"AP"'
                        &acct=ico_acct
                        &sub=ico_sub
                        &cc=ico_cc }

               /*CREDIT DETAIL ENTITY*/
               {gpnextln.i &ref=ap_vend &line=return_int}
               create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
               assign
                  gltw_entity = vod_entity
                  gltw_acct = ico_acct
                  gltw_sub = ico_sub
                  gltw_cc = ico_cc
                  gltw_project = vod_project
                  gltw_ref = ap_vend
                  gltw_line = return_int
                  gltw_date = ap_date
                  gltw_effdate = apeffdate /*ap_effdate*/
                  gltw_userid = mfguser
                  gltw_desc = ap_batch + " " + ap_type + " " +
                              ap_ref + " " + ap_vend
                  gltw_amt = - base_amt
                  recno = recid(gltw_wkfl).
               /*DEBIT HEADER ENTITY*/
               {glenacex.i &entity=ap_entity
                           &type='"DR"'
                           &module='"AP"'
                           &acct=ico_acct
                           &sub=ico_sub
                           &cc=ico_cc }
               {gpnextln.i &ref=ap_vend &line=return_int}
               create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
               assign
                  gltw_entity = ap_entity
                  gltw_acct = ico_acct
                  gltw_sub = ico_sub
                  gltw_cc = ico_cc
                  gltw_project = vod_project
                  gltw_ref = ap_vend
                  gltw_line = return_int
                  gltw_date = ap_date
                  gltw_effdate = apeffdate /*ap_effdate*/
                  gltw_userid = mfguser
                  gltw_desc = ap_batch + " " + ap_type + " "
                            + ap_ref + " " + ap_vend
                  gltw_amt = base_amt
                  recno = recid(gltw_wkfl).
            end. /* Intercompany trans */

            /* FINISHED WITH VENDOR LOCK, NO UPDATE DONE */
            release vd_mstr.

         end. /* For each vod_det */

         /* UPDATE VENDOR BALANCES */
         if confirm then do:
            find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr
            = ap_vend exclusive-lock
               no-error.

            base_amt = ap_base_amt - vo_base_applied.
            vd_balance = vd_balance + base_amt.

            /* UPDATE COSTS ON EACH INVENTORY ITEM */
            if not log_charge_voucher then
               for each vph_hist
                      where vph_hist.vph_domain = global_domain and  vph_ref =
                      vo_ref
                       and vph_pvo_id <> 0
                       and vph_pvod_id_line > 0
                     no-lock,
                   each pvo_mstr
                      where pvo_mstr.pvo_domain = global_domain and  pvo_id =
                      vph_pvo_id  and
                     pvo_lc_charge   = "" and
                     pvo_internal_ref_type = {&TYPE_POReceiver}
                     no-lock,
                   each prh_hist
                      where prh_hist.prh_domain = global_domain and
                      prh_receiver = pvo_internal_ref
                     and prh_line = pvo_line
                     no-lock:

                  assign
                     vo_recno = recid(vo_mstr)
                     ap_recno = recid(ap_mstr)
                     vph_recno = recid(vph_hist)
                     prh_recno = recid(prh_hist).

                  /* APVOCSU1.P IS RUN FROM APVOMTK3.P, */
                  /* APVOCO.P AND APVOCO01.P            */
                  /* AND UPDATES COSTS FOR ONE ITEM.    */

                  {gprun.i ""apvocsu1.p""}        /* COST UPDATE */

               end. /* FOR EACH VPH_HIST */
            else do:
               {gprunmo.i &module = "LA" &program = "apvocola.p"
                          &param  = """(buffer ap_mstr,
                                        buffer vo_mstr)"""}.
            end. /* IF LOGISTICS CHARGE VOUCHER */
         end. /* IF CONFIRM */

      end. /* DO TRANSACTION */
   end. /* Voucherloop (each ap_mstr,vo_mstr) */

   /* PRINT LAST BATCH TOTAL */
   if current_batch <> ? then do:

      /* IF THE REPORT IS IN BASE OR "ALL" CURRENCIES, (BLANK) */
      /* THEN THE TOTALS LINE WILL REFLECT BASE TOTALS         */

      if base_rpt = "" then
      assign
         base_amt:format in frame e = base_amt_fmt
         SESSION:numeric-format = oldsession.
      else
      assign
         base_amt:format in frame e = ap_amt_fmt
         SESSION:numeric-format = doc-numeric-format.

      display
         "" @ vo_invoice
         "" @ vo_po
         "----------------" @ base_amt with frame e STREAM-IO /*GUI*/ .
      down 1 with frame e.
      display

         (if base_rpt = "" then "  " + getTermLabel("BASE",4)
         else "   " + base_rpt)
         + " " + getTermLabel("BATCH",5) @ vo_invoice
         getTermLabel("TOTAL",5) + ":" @ vo_po

         batch_base_amt @ base_amt
      with frame e STREAM-IO /*GUI*/ .
      down 1 with frame e.
      total_base_amt = total_base_amt + batch_base_amt.
      if batch_reject_base_amt <> 0 then do:

         display
            getTermLabelRt("ERROR",10) @ vo_invoice
            getTermLabel("VOUCHERS",8) + ":" format "x(9)" @ vo_po
            batch_reject_base_amt @ base_amt
         with frame e STREAM-IO /*GUI*/ .
         down 1 with frame e.
         total_reject_base_amt = total_reject_base_amt
                               + batch_reject_base_amt.
      end.
   end.

   /* PRINT REPORT TOTAL */
   if current_batch <> ? then do:

      /* IF THE REPORT IS IN BASE OR "ALL" CURRENCIES, (BLANK) */
      /* THEN THE TOTALS LINE WILL REFLECT BASE TOTALS         */

      if base_rpt = "" then
      assign
         base_amt:format in frame e = base_amt_fmt
         SESSION:numeric-format = oldsession.
      else
      assign
         base_amt:format in frame e = ap_amt_fmt
         SESSION:numeric-format = doc-numeric-format.

      display "----------------" @ base_amt with frame e STREAM-IO /*GUI*/ .
      down 1 with frame e.
      display

         (if base_rpt = "" then " " + getTermLabel("BASE",4)
         else "  " + base_rpt)
         + " " + getTermLabel("REPORT",6) @ vo_invoice
         getTermLabel("TOTAL",5) + ":" @ vo_po

         total_base_amt @ base_amt
      with frame e STREAM-IO /*GUI*/ .
      if total_reject_base_amt <> 0 then do:
         down 1 with frame e.

         display
            getTermLabelRt("ERROR",10) @ vo_invoice
            getTermLabel("VOUCHERS",8) + ":" format "x(9)" @ vo_po
            total_reject_base_amt @ base_amt
         with frame e STREAM-IO /*GUI*/ .
      end.
   end.
   SESSION:numeric-format = oldsession.

   /* DISPLAY CURRENCY TOTALS */
   if base_rpt = ""
      and mixed_rpt
   then do:
      {gprun.i ""gpacctp.p""}
   end.

   /* PRINT GL DISTRIBUTION */
   page.
   {gprun.i ""gpglrp.p""}

   /*REPORT TRAILER*/
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end. /* REPEAT */

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" batch batch1 vend vend1 voucher voucher1 votype votype1 apdate apdate1 entity entity1 authorized authorized1 effdate confirm summary base_rpt mixed_rpt "} /*Drive the Report*/
