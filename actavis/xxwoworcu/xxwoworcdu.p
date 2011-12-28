/* GUI CONVERTED from woworcd.p (converter v1.78) Tue Apr 18 14:44:36 2006 */
/* woworcd.p - WORK ORDER RECEIPT W/ SERIAL NUMBERS                         */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.45 $                                                             */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.2     LAST MODIFIED: 04/12/94    BY: pma *FN34*              */
/* REVISION: 7.4     LAST MODIFIED: 05/16/94    BY: ais *H371*              */
/* REVISION: 8.5     LAST MODIFIED: 10/05/94    BY: taf *J035*              */
/* REVISION: 8.5     LAST MODIFIED: 10/28/94    BY: pma *J040*              */
/* REVISION: 8.5     LAST MODIFIED: 11/17/94    BY: taf *J038*              */
/* REVISION: 8.5     LAST MODIFIED: 12/20/94    BY: ktn *J041*              */
/* REVISION: 7.4     LAST MODIFIED: 12/22/94    BY: ais *H09K*              */
/* REVISION: 7.4     LAST MODIFIED: 01/18/95    BY: qzl *H09V*              */
/* REVISION: 8.5     LAST MODIFIED: 03/08/95    BY: dzs *J046*              */
/* REVISION: 7.4     LAST MODIFIED: 04/17/95    BY: jpm *H0CJ*              */
/* REVISION: 8.5     LAST MODIFIED: 04/23/95    BY: sxb *J04D*              */
/* REVISION: 7.4     LAST MODIFIED: 06/06/95    BY: dzs *G0P4*              */
/* REVISION: 7.3     LAST MODIFIED: 06/26/95    by: qzl *G0R0*              */
/* REVISION: 8.5     LAST MODIFIED: 07/31/95    BY: kxn *J069*              */
/* REVISION: 7.2     LAST MODIFIED: 08/17/95    BY: qzl *F0TC*              */
/* REVISION: 8.5     LAST MODIFIED: 11/09/95    BY: tjs *J08X*              */
/* REVISION: 8.5     LAST MODIFIED: 11/29/95    BY: kxn *J09C*              */
/* REVISION: 7.4     LAST MODIFIED: 02/05/96    BY: rvw *H0JL*              */
/* REVISION: 8.5     LAST MODIFIED: 03/18/96    by: jpm *J0F5*              */
/* REVISION: 8.5     LAST MODIFIED: 01/18/96    BY: bholmes *J0FY*          */
/* Revision  8.5     Last Modified: 04/26/96    BY: BHolmes *J0KF*          */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: jym *J0QX*              */
/* REVISION: 8.5     LAST MODIFIED: 07/27/96    BY: jxz *J12C*              */
/* REVISION: 8.5     LAST MODIFIED: 08/01/96    BY: GWM *J10N*              */
/* REVISION: 8.5     LAST MODIFIED: 08/06/96    BY: *G1YK* Russ Witt        */
/* REVISION: 8.5     LAST MODIFIED: 08/12/96    BY: *J141* Fred Yeadon      */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *J1GW* Murli Shastri    */
/* REVISION: 8.5     LAST MODIFIED: 08/17/97    BY: *J1Z9* Felcy D'Souza    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.5      LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *J35X* Thomas Fernandes */
/* REVISION: 9.0      LAST MODIFIED: 01/27/99   BY: *J38V* Viswanathan M    */
/* REVISION: 9.0      LAST MODIFIED: 03/05/99   BY: *J3C2* Vivek Gogte      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 03/30/99   BY: *J39K* Sanjeev Assudani */
/* REVISION: 9.1      LAST MODIFIED: 09/04/99   BY: *J3KM*  G.Latha         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *L0TJ* Mark Christian   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LW* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.25     BY: Irene D'Mello      DATE: 06/25/01 ECO: *P00X*     */
/* Revision: 1.26     BY: Irene D'Mello      DATE: 09/10/01 ECO: *M164*     */
/* Revision: 1.28     BY: Manisha Sawant     DATE: 04/15/02 ECO: *N1GG*     */
/* Revision: 1.30     BY: Ashish Maheshwari  DATE: 07/17/02 ECO: *N1GJ*     */
/* Revision: 1.31     BY: Kirti Desai        DATE: 01/23/03 ECO: *N241*     */
/* Revision: 1.32     BY: Geeta Kotian       DATE: 02/07/03 ECO: *N25T*     */
/* Revision: 1.35     BY: Narathip W.        DATE: 04/19/03 ECO: *P0Q7*     */
/* Revision: 1.37     BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*     */
/* Revision: 1.38     BY: Dipesh Bector      DATE: 08/04/03 ECO: *P0TY*     */
/* Revision: 1.39     BY: Dorota Hohol       DATE: 08/25/03 ECO: *P112*     */
/* Revision: 1.40     BY: Kirti Desai        DATE: 10/22/03 ECO: *P16R*     */
/* Revision: 1.41     BY: Kirti Desai        DATE: 10/28/03 ECO: *P17C*     */
/* Revision: 1.42     BY: Sukhad Kulkarni    DATE: 09/06/04 ECO: *P2J6*     */
/* Revision: 1.43     BY: Swati Sharma       DATE: 10/06/04 ECO: *P2N2*     */
/* Revision: 1.44     BY: Sukhad Kulkarni    DATE: 01/20/05 ECO: *P34N*     */
/* $Revision: 1.45 $  By: Jean Miller        DATE: 01/10/06  ECO: *Q0PD*    */
/* $Revision: 1.45 $  By: Zhang Yun          DATE: 01/10/06  ECO: *2C06*    */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/************************************************************************/
/*  MOVED ALL FUNCTIONAL CODE FROM WOWORC.P DUE TO R-CODE CONSTRAINT    */
/************************************************************************/
/* ss lambert 20100517 修改入库数量必须等于最后一道工序的回报数量
   无工序工单、半成品工单（03开头）、最后一道工序委外的工单 不作限制
 */

 /* ss - 100517.1 by: jack */  /* 外协工单批序抓收货最后批序*/
 /* ss - 100526.1 by: jack */
 /* ss - 100528.1 by: jack */
 /* ss - 100602.1 by: jack */  /* 修改*/


{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "WOWORCD.P"}
{pxmaint.i}
{pxphdef.i wocmnrtn}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworcd_p_1 "Receive All Co/By-Products"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_2 "Scrapped Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_4 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_5 "Total Units"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_6 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_7 "Close"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_8 "Conversion"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_9 "Open Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_11 "    Receipt Qty = Open Qty"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define output parameter p_recv_all like mfc_logical no-undo.

define new shared variable jp-yn like mfc_logical initial yes.
define new shared variable recv-yn like mfc_logical.
define new shared variable recv_all like mfc_logical.
define new shared variable recv like mfc_logical initial yes.
define new shared variable recpt-bkfl like mfc_logical initial no.
define new shared variable firstpass like mfc_logical initial no.

define shared variable nbr like wo_nbr.
define shared variable yn like mfc_logical.
define shared variable open_ref like wo_qty_ord label {&woworcd_p_9}.
define shared variable rmks like tr_rmks.
define shared variable serial like tr_serial.
define shared variable ref like glt_ref.
define shared variable lot like ld_lot.
define shared variable i as integer.
define shared variable total_lotserial_qty like sr_qty.
define shared variable null_ch as character initial "".
define shared variable close_wo like mfc_logical label {&woworcd_p_7}.
define shared variable comp like ps_comp.
define shared variable qty like wo_qty_ord.
define shared variable eff_date like glt_effdate.
define shared variable wo_recno as recid.
define shared variable leadtime like pt_mfg_lead.
define shared variable prev_status like wo_status.
define shared variable prev_release like wo_rel_date.
define shared variable prev_due like wo_due_date.
define shared variable prev_qty like wo_qty_ord.
define shared variable prev_site like wo_site.
define shared variable del-yn like mfc_logical.
define shared variable deliv like wod_deliver.
define shared variable any_issued like mfc_logical.
define shared variable any_feedbk like mfc_logical.
define shared variable conv like um_conv
   label {&woworcd_p_8} no-undo.
define shared variable um like pt_um no-undo.
define shared variable tot_units like wo_qty_chg
   label {&woworcd_p_5}.
define shared variable reject_um like pt_um no-undo.
define shared variable reject_conv like conv no-undo.
define shared variable pl_recno as recid.
define shared variable fas_wo_rec like fac_wo_rec.
define shared variable reject_qty like wo_rjct_chg
   label {&woworcd_p_2} no-undo.
define shared variable multi_entry like mfc_logical
   label {&woworcd_p_6} no-undo.
define shared variable lotserial_control as character.
define shared variable site like sr_site no-undo.
define shared variable location like sr_loc no-undo.
define shared variable lotserial like sr_lotser no-undo.
define shared variable lotref like sr_ref format "x(8)" no-undo.
define shared variable lotserial_qty like sr_qty no-undo.
define shared variable cline as character.
define shared variable trans_um like pt_um.
define shared variable trans_conv like sod_um_conv.
define shared variable transtype as character initial "RCT-WO".
define shared variable undo_all like mfc_logical no-undo.
define shared variable msg-counter as integer no-undo.
define shared variable undo_setd like mfc_logical no-undo.
define shared variable chg_attr like mfc_logical no-undo.
define shared variable undo_jp like mfc_logical.
define shared variable jp like mfc_logical.
define shared variable base like mfc_logical.
define shared variable base_id like wo_base_id.
define shared variable base_qty like sr_qty.
define shared variable issue_or_receipt as character.

define variable lotnext like wo_lot_next.
define variable newlot like wo_lot_next.
define variable trans-ok like mfc_logical.
define variable lotprcpt like wo_lot_rcpt no-undo.
define variable alm_recno as recid.
define variable filename as character.
define variable wonbr like wo_nbr.
define variable wolot like wo_lot.
define variable regular like mfc_logical initial yes.
define variable almr like alm_pgm.
define variable ii as integer.
define variable l_yn     like mfc_logical initial no no-undo.
{&WOWORCD-P-TAG1}
/* ss - 100517.1 -b */
DEFINE VAR v_logical AS LOGICAL .
/* ss - 100517.1 -e */
/* ss - 100528.1 -b */
DEFINE VAR v_qty AS DECIMAL .
/* ss - 100528.1 -e */

/*2C06*/  define variable vworctqty as decimal.
/*2C06*/  define variable vporctqty as decimal.

issue_or_receipt = getTermLabel("RECEIPT",8).

/* setframelabels IS SET IN CALLING PROGRAM mfworc.i */
/* NEED NOT SET IT AGAIN HERE */
define shared frame a.

/* DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE */
{gpatrdef.i "shared"}


/*FRAME A*/
{mfworc.i }

FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
skip (1)
   recv_all colon 40 label {&woworcd_p_1}
   recv     colon 40 label {&woworcd_p_11}
   skip (1)
 SKIP(.4)  /*GUI*/
with frame r side-labels overlay row 9 column 24
    width 50
   attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-r-title AS CHARACTER.
 F-r-title = (getFrameTitle("CO/BY-PRODUCTS_RECEIPT_OPTIONS",48)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame r = F-r-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame r =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame r + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame r =
  FRAME r:HEIGHT-PIXELS - RECT-FRAME:Y in frame r - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME r = FRAME r:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame r:handle).

for first clc_ctrl
   fields( clc_domain clc_lotlevel)
    where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   for first clc_ctrl
      fields( clc_domain clc_lotlevel)
       where clc_ctrl.clc_domain = global_domain no-lock:
   end. /* FOR FIRST clc_ctrl */

end. /* IF NOT AVAILABLE clc_ctrl */

for first wo_mstr
   fields( wo_domain wo_assay wo_batch wo_expire wo_fsm_type wo_grade
   wo_joint_type
          wo_loc wo_lot wo_lot_next wo_lot_rcpt wo_nbr
          wo_part wo_qty_chg wo_qty_comp wo_qty_ord wo_qty_rjct
          wo_rctstat wo_rctstat_active wo_rjct_chg wo_rmks
          wo_site wo_status wo_type)
      where recid(wo_mstr) = wo_recno no-lock:
end. /* FOR FIRST wo_mstr */

for first pt_mstr
   fields( pt_domain pt_auto_lot pt_desc1 pt_loc pt_lot_grp pt_lot_ser pt_part
   pt_um)
    where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
   no-lock:
end. /* FOR FIRST pt_mstr */

assign
   close_wo  = no
   undo_setd = yes.

if jp
then do:

   assign
      regular   = no
      jp-yn     = yes
      firstpass = yes
      recv_all  = yes
      recv      = no.

   pause 0.
   if base
   then
      display recv_all with frame r.

   update
      recv_all when (not base)
   with frame r.

   if recv_all
   then
      update recv with frame r.
   hide frame r.

   /* STORE THIS VALUE WHICH INDICATES THE */
   /* RECEIPT OF SINGLE CO / BY-PRODUCT.   */
   p_recv_all = recv_all.

   if recv_all or
      base
   then do:

      /* Branch off to JP Receipts Frame */
      {gprun.i ""wojprc.p"" "(input wo_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      if undo_setd = yes
      then
         leave.
   end. /* IF recv_all */
end. /* IF jp */

if regular or
   not recv_all
then do:

   if index("ER",wo_type) > 0
   then
      assign
         wonbr    = ""
         wolot    = ""
         lotprcpt = no.
   else
      assign
         wonbr    = wo_nbr
         wolot    = wo_lot
         lotprcpt = wo_lot_rcpt.

   for first pt_mstr
      fields( pt_domain pt_auto_lot pt_desc1 pt_loc pt_lot_grp pt_lot_ser
      pt_part pt_um)
       where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
      no-lock:
   end. /* FOR FIRST pt_mstr */

   /* wo_lot_next HOLDS THE LOT NUMBER FOR A PARTICULAR WORK ORDER.   */
   /* WHEN THE PARENT ITEM IS LOT CONTROLLED AND LOT GROUP IS BLANK,  */
   /* wo_lot_next SHOULD BE ASSIGNED THE WORK ORDER ID.               */
   do transaction:

      for first wo_mstr
         where recid(wo_mstr) = wo_recno
         exclusive-lock:
      end. /* FOR FIRST WO_MSTR */

      if  pt_auto_lot = yes
      and pt_lot_ser  = "L"
      and pt_lot_grp  = " "
      then do:
         if (wo_lot_next = "")
         then
            wo_lot_next =   wo_lot.
      end. /* IF PT_AUTO_LOT = YES */
   end. /* DO TRANSACTION */

   if (pt_lot_ser = "L")  and
      (not pt_auto_lot or (index("ER", wo_type) > 0))
   then
      lotserial = wo_lot_next.
   else
      lotserial = "".

   assign
      lotnext = ""
      newlot  = "".

    /* ss - 100517.1 -b */
   v_logical = NO .
   FIND FIRST pod_det WHERE pod_domain = GLOBAL_domain AND pod_type = "s" AND
              pod_wo_lot = wo_lot NO-LOCK NO-ERROR .
   IF AVAILABLE pod_det THEN DO:
       v_logical = YES .

   END.
   /* ss - 100517.1 -e */

 /* ss - 100517.1 -b
   if (pt_lot_ser = "L" and
      pt_auto_lot = yes and
      pt_lot_grp <> "") and
      (index("ER", wo_type) = 0)
   then do:
   ss - 100517.1 e */
   /* ss - 100517.1 -b */
     if (pt_lot_ser = "L" and
      pt_auto_lot = yes and
      pt_lot_grp <> "") and
      (index("ER", wo_type) = 0)
         AND v_logical = NO
   then do:
   /* ss - 100517.1 -e */

      for first alm_mstr
         fields( alm_domain alm_lot_grp alm_pgm alm_site)
          where alm_mstr.alm_domain = global_domain and  alm_lot_grp =
          pt_lot_grp
           and alm_site    = wo_site
         no-lock:
      end. /* FOR FIRST alm_mstr */

      if not available alm_mstr
      then
         for first alm_mstr
            fields( alm_domain alm_lot_grp alm_pgm alm_site)
             where alm_mstr.alm_domain = global_domain and  alm_lot_grp =
             pt_lot_grp
              and alm_site    = ""
            no-lock:
         end. /* FOR FIRST alm_mstr */

      if not available alm_mstr
      then do:

         /* LOT FORMAT RECORD DOES NOT EXIST */
         {pxmsg.i &MSGNUM=2737 &ERRORLEVEL=3}
         leave.
      end. /* IF NOT AVAILABLE alm_mstr */

      else do:

         if (search(alm_pgm) = ?)
         then do:

            assign
               ii   = index(alm_pgm,".p")
               almr = global_user_lang_dir + "/"
                      + substring(alm_pgm, 1, 2) + "/"
                      + substring(alm_pgm,1,ii - 1) + ".r".

            if (search(almr)) = ?
            then do:
               /* AUTO LOT PROGRAM NOT FOUND*/
               {pxmsg.i &MSGNUM=2732 &ERRORLEVEL=4 &MSGARG1=alm_pgm}
               leave.
            end. /* IF (SEARCH(almr)) = ? */
         end. /* IF (SEARCH(alm_pgm) = ?) */
      end. /* ELSE DO */

      for first sr_wkfl
         fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_site
         sr_userid)
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
           and sr_lineid = cline
         no-lock:
      end. /* FOR FIRST sr_wkfl */

      if available sr_wkfl
      then
         lotserial = sr_lotser.

      if newlot = ""
      then do:

         assign
            alm_recno = recid(alm_mstr)
            filename  = "wo_mstr".

         if false
         then do:

            {gprun.i ""gpauto01.p"" "(input  alm_recno,
                                      input  wo_recno,
                                      input  "filename",
                                      output newlot,
                                      output trans-ok)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF FALSE */

         {gprun.i alm_pgm "(input  alm_recno,
                            input  wo_recno,
                            input  "filename",
                            output newlot,
                            output trans-ok)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if not trans-ok
         then do:
            /* LOT FORMAT RECORD DOES NOT EXIST */
            {pxmsg.i &MSGNUM=2737 &ERRORLEVEL=3}
            leave.
         end. /* IF NOT trans-ok */

         lotserial = newlot.
         release alm_mstr.
      end.  /* newlot = "" */
   end.  /* pt_lot_ser = L */

   /* ss - 100517.1 -b */
   IF v_logical  THEN DO:
       /* ss - 100602.1 -b
       FIND LAST pod_det WHERE pod_domain = GLOBAL_domain AND pod_type = "s" AND  pod_wo_lot = wo_lot NO-LOCK NO-ERROR .
       IF AVAILABLE pod_det  THEN DO:

              FIND LAST prh_hist WHERE prh_domain = GLOBAL_domain AND prh_nbr = pod_nbr  /* ss - 100531.1 -b AND prh_line = pod_line ss - 100531.1 -e */  NO-LOCK NO-ERROR .
              IF AVAILABLE prh_hist  THEN
                     lotserial = prh__chr01 .

           END.
       ss - 100602.1 -e */
       /* ss - 100602.1 -b */


            FIND LAST prh_hist WHERE prh_domain = GLOBAL_domain  AND
                      prh_lot = wo_lot NO-LOCK NO-ERROR .
                   IF AVAILABLE prh_hist THEN DO:
                      lotserial = prh__chr01.
                   END .



     /*   ss - 100602.1 -e */
   END.


   /* ss - 100517.1 -e */

   display lotserial with frame a.

   setd:
      repeat on endkey undo setd, leave:


         assign
            site = ""
            location = ""
            lotref = ""
            lotserial_qty = total_lotserial_qty.


         if wo_joint_type <> "" and
            wo_joint_type <> "5"
         then
            cline = "RCT" + wo_part.
         else
            cline = "".

         assign
            global_part = wo_part
            i           = 0.

         for each sr_wkfl
            fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_site
            sr_userid)
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
              and sr_lineid = cline
              no-lock:

            i = i + 1.
            if i > 1
            then
               leave.
         end. /* FOR EACH sr_wkfl */

         if i = 0
         then do:
            assign
               site     = wo_site
               location = wo_loc.
            if location = "" and
               available pt_mstr
            then
               location = pt_loc.

         end. /* IF i = 0 */
         else
            if i = 1
            then do:

               for first sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_site
                         sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                   and  sr_lineid = cline
                  no-lock:
               end. /* FOR FIRST sr_wkfl */

                  if available sr_wkfl
                  then
                     assign
                        site      = sr_site
                        location  = sr_loc
                        lotserial = sr_lotser
                        lotref    = sr_ref.
            end. /* IF i = 1 */

         /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/

         {pxrun.i &PROC    = 'get_default_wo_attr'
                  &PROGRAM = 'wocmnrtn.p'
                  &HANDLE  = ph_wocmnrtn
                  &PARAM   = "(
                               input         recid(wo_mstr),
                               input-output  chg_assay,
                               input-output  chg_grade,
                               input-output  chg_expire,
                               input-output  chg_status,
                               input-output  assay_actv,
                               input-output  grade_actv,
                               input-output  expire_actv,
                               input-output  status_actv
                             )"
         }

            resetattr   = no.

         locloop:
         do on error undo, retry on endkey undo setd, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


            if available pt_mstr
            then do:

               if pt_auto_lot
               then do:

                  if pt_lot_grp = ""
                  then
                     lotserial = wo_lot_next.

                  multi_entry = no.
                  display
                     lotserial multi_entry with frame a.


                  {&WOWORCD-P-TAG2}
                  update
                     lotserial_qty
                     um
                     conv
                     reject_qty
                     reject_um
                     reject_conv
                     site
                     location
                     lotref
                     multi_entry
                     chg_attr
                  with frame a
                  editing:

                     {&WOWORCD-P-TAG3}
                     assign
                        global_site = input site
                        global_loc  = input location.
                     readkey.
                     apply lastkey.
                  end. /* EDITING */
               end.   /* IF pt_auto_lot */

               else do:

                  {&WOWORCD-P-TAG4}
                  update
                     lotserial_qty
                     um
                     conv
                     reject_qty
                     reject_um
                     reject_conv
                     site
                     location
                     lotserial
                     lotref
                     multi_entry
                     chg_attr
                  with frame a
                  editing:

                     {&WOWORCD-P-TAG5}
                     assign
                        global_site = input site
                        global_loc  = input location
                        global_lot  = input lotserial.
                     readkey.
                     apply lastkey.
                  end. /* EDITING */
               end. /* ELSE DO */
               {&WOWORCD-P-TAG9}



               if um <> pt_um
               then do:

                  if not conv entered
                  then do:


                     {gprun.i ""gpumcnv.p"" "(input  um,
                                              input  pt_um,
                                              input  wo_part,
                                              output conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                     if conv = ?
                     then do:

                        /* NO UNIT OF MEASURE EXISTS */
                        {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                        conv = 1.
                     end. /* IF conv = ? */
                     display conv with frame a.
                  end. /* IF NOT conv ENTERED */
               end. /* IF um <> pt_um */

               if reject_um <> pt_um
               then do:

                  if not reject_conv entered
                  then do:

                     {gprun.i ""gpumcnv.p"" "(input  reject_um,
                                              input  pt_um,
                                              input  wo_part,
                                              output reject_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     if reject_conv = ?
                     then do:
                        /* NO UNIT OF MEASURE EXISTS */
                        {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                        reject_conv = 1.
                     end. /* IF reject_conv = ? */
                     display reject_conv with frame a.
                  end. /* IF NOT reject_conv ENTERED */
               end. /* IF REJECT_UM <> PT_UM */

               /* IF SINGLE LOT PER RECEIPT THEN VERIFY IF LOT IS USED */
               if (lotprcpt = yes) and
                  (pt_lot_ser = "L") and
                  (clc_lotlevel <> 0)
               then do:

                  for first lot_mstr
                     fields( lot_domain lot_line lot_nbr lot_part lot_serial)
                      where lot_mstr.lot_domain = global_domain and  lot_serial
                      = lotserial
                       and lot_part   = wo_part
                       and lot_nbr    = wo_nbr
                       and lot_line   = wo_lot
                      no-lock:
                  end. /* FOR FIRST lot_mstr */

                  if available lot_mstr
                  then do:

                     /* LOT IS IN USE */
                     {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                     next-prompt lotserial with frame a.
                     undo, retry.
                  end. /* IF AVAILABLE lot_mstr */

                  for first lotw_wkfl
                     fields( lotw_domain lotw_lotser lotw_mfguser lotw_part)
                      where lotw_wkfl.lotw_domain = global_domain and
                      lotw_lotser = lotserial
                       and lotw_mfguser <> mfguser
                       and lotw_part    <> pt_part
                     no-lock:
                  end. /* FOR FIRST lotw_wkfl */

                  if available lotw_wkfl
                  then do:

                     /* LOT IS IN USED */
                     {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                      next-prompt lotserial with frame a.
                      undo, retry.
                  end. /* IF AVAILABLE lotw_wkfl */
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF (lotprcpt = YES) ... */

            end. /* IF AVAILABLE pt_mstr */

            else do:

               {&WOWORCD-P-TAG6}
               update
                  lotserial_qty
                  um
                  conv
                  reject_qty
                  reject_um
                  reject_conv
                  site
                  location
                  lotserial
                  lotref
                  chg_attr
                  multi_entry
               with frame a
               editing:

                  {&WOWORCD-P-TAG7}
                  assign
                     global_site = input site
                     global_loc = input location
                     global_lot = input lotserial
                     global_ref = input lotref.
                  readkey.
                  apply lastkey.
               end. /* EDITING */
            end. /* ELSE DO */

            if reject_qty <> 0
            then do:
               if can-find(first isd_det
                  where isd_domain  = global_domain
                  and   isd_status  = string(pt_status,"x(8)") + "#"
                  and   isd_tr_type = "RJCT-WO")
               then do:
                  /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
                  {pxmsg.i &MSGNUM=358
                     &ERRORLEVEL=3
                     &MSGARG1=pt_status}
                  undo locloop, retry locloop.
               end. /* IF CAN-FIND(FIRST isd_det)... */
            end. /* IF reject_qty > 0 */

            i = 0.

            for each sr_wkfl
               fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
               sr_site
                      sr_userid)
               no-lock
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
                 and sr_lineid = cline:

               i = i + 1.
               if i > 1
               then do:
                  multi_entry = yes.
                  leave.
               end. /* IF i > 1 */
            end. /* FOR EACH sr_wkfl */

            assign
               trans_um   = um
               trans_conv = conv.

            if multi_entry
            then do:

               if i >= 1
               then
                  assign
                     site     = ""
                     location = ""
                     lotref   = "".

               if (lotprcpt = yes)
               then
                  lotnext = lotserial.

               /* ASSIGN RMA WORK ORDER NUMBER TO wonbr FOR MULTI-ENTRY */
               /* AS THE CHECK FOR LOT/SERIAL WILL BE DONE IN icsrup.p. */

               if  available pt_mstr
               and pt_lot_ser <> ""
               and available wo_mstr
               and wo_fsm_type = "RMA"
               and wonbr       = ""
               then
                  assign
                     l_yn  = yes
                     wonbr = wo_nbr.

               /* ADDED SIXTH INPUT PARAMETER AS NO */
               {gprun.i ""icsrup.p"" "(input        wo_site,
                                       input        wonbr,
                                       input        wolot,
                                       input-output lotnext,
                                       input        lotprcpt,
                                       input        no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if l_yn
               then
                  wonbr = "".
            end. /* IF multi_entry */
            else do:

              /* wo rct qty check po rct qty */
/*2C06*/         find first pod_det no-lock where pod_domain = global_domain
/*2C06*/                and pod_type = "S" and pod_wo_lot = wo_lot no-error.
/*2C06*/         if available pod_det then do:
/*2C06*/            if not can-find(first tr_hist use-index tr_nbr_eff where
/*2C06*/                               tr_domain = global_domain and
/*2C06*/                               tr_nbr = pod_nbr and
/*2C06*/                               tr_type = "rct-po" and
/*2C06*/                               tr_qty_loc = lotserial_qty) then do:
/*2C06*/                  {pxmsg.i &MSGNUM=9014 &ERRORLEVEL=3}
/*2C06*/                  undo,retry.
/*2C06*/             end.
/*2C06*/             else do:
/*2C06*/                  assign vworctqty = 0 vporctqty = 0.
/*2C06*/									for each tr_hist use-index tr_nbr_eff no-lock where
/*2C06*/                           tr_domain = global_domain and
/*2C06*/                           tr_nbr = wo_nbr and tr_type = "rct-wo":
/*2C06*/                      assign vworctqty = vworctqty + tr_qty_loc.
/*2C06*/                  end.
/*2C06*/                  assign vworctqty = vworctqty + lotserial_qty.
/*2C06*/                  for each tr_hist use-index tr_nbr_eff where
/*2C06*/                           tr_domain = global_domain and
/*2C06*/                           tr_nbr = pod_nbr and
/*2C06*/                           tr_type = "rct-po":
/*2C06*/                      assign vporctqty = vporctqty + tr_qty_loc.
/*2C06*/                  end.
/*2C06*/                  if vworctqty > vporctqty then do:
/*2C06*/                     {pxmsg.i &MSGNUM=9015 &ERRORLEVEL=3}
/*2C06*/                     undo,retry.
/*2C06*/                  end.
/*2C06*/             end.
/*2C06*/         end.

               if lotserial_qty <> 0
               then do:

                  if available pt_mstr
                  and pt_lot_ser <> ""
                  and available wo_mstr
                  and wo_fsm_type = "RMA"
                  and wonbr       = ""
                  then
                     l_yn = yes.

                  /* FOR WORK ORDERS RELEASED FROM RMA, SET TRANSACTION */
                  /* TYPE TO "RCT-WOR" IF ITEM-LOT/SERIAL ISSUED TO WO  */
                  /* IS SAME AS FOR RECEIPT.                            */

                  if  available pt_mstr
                  and pt_lot_ser <> ""
                  and l_yn
                  then
                     for first tr_hist
                        fields( tr_domain tr_fsm_type tr_nbr tr_part tr_serial
                        tr_type)
                         where tr_hist.tr_domain = global_domain and  tr_nbr
                           = wo_nbr
                        and   tr_part     = wo_part
                        and   tr_serial   = lotserial
                        and   tr_type     = "ISS-WO"
                        and   tr_fsm_type = "RMA"
                        no-lock:
                        transtype = "RCT-WOR".
                     end. /* FOR FIRST tr_hist */

                  /* CHANGED FIRST INPUT PARAMETER TO transtype */
                  /* FROM ""RCT-WO""                            */

                   { gprun.i ""icedit.p"" " ( input  transtype,
                                             input  site,
                                             input  location,
                                             input  global_part,
                                             input  lotserial,
                                             input  lotref,
                                             input  lotserial_qty * trans_conv,
                                             input  trans_um,
                                             input  wonbr,
                                             input  wolot,
                                             output yn )"
                  }
/*GUI*/ if global-beam-me-up then undo, leave.

                  if yn
                  then
                     undo locloop, retry.
               end. /* IF lotserial_qty <> 0 */

               if wo_site <> site
               then do:

                  if lotserial_qty <> 0
                  then do:
                     {gprun.i ""icedit4.p"" "(input ""RCT-WO"",
                                              input wo_site,
                                              input site,
                                              input pt_loc,
                                              input location,
                                              input global_part,
                                              input lotserial,
                                              input lotref,
                                              input lotserial_qty
                                                    * trans_conv,
                                              input trans_um,
                                              input wonbr,
                                              input wolot,
                                              output yn)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.

                     if yn
                     then
                        undo locloop, retry.
                  end. /* IF lotserial_qty <> 0 */
               end. /* IF wo_site <> site */

               find first sr_wkfl
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = cline
                  exclusive-lock no-error.

               if lotserial_qty = 0
               then do:

                  if available sr_wkfl
                  then do:
                     total_lotserial_qty = total_lotserial_qty - sr_qty.
                     delete sr_wkfl.
                  end. /* IF AVAILABLE sr_wkfl */
               end. /* IF lotserial_qty = 0 */

               else do:

                  if available sr_wkfl
                  then
                     assign
                        total_lotserial_qty = total_lotserial_qty - sr_qty
                                              + lotserial_qty
                        sr_site             = site
                        sr_loc              = location
                        sr_lotser           = lotserial
                        sr_ref              = lotref
                        sr_qty              = lotserial_qty.

                  else do:

                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                     assign
                        sr_userid           = mfguser
                        sr_lineid           = cline
                        sr_site             = site
                        sr_loc              = location
                        sr_lotser           = lotserial
                        sr_ref              = lotref.
                        sr_qty              = lotserial_qty.
                        total_lotserial_qty = total_lotserial_qty
                                              + lotserial_qty.
                  end. /* ELSE DO */
               end. /* ELSE DO */
            end. /*else do (multi-entry = no)*/

            /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
            /* ADDED THIRD PARAMETER EFF_DATE */
            {gprun.i ""worcat02.p"" "(input        recid(wo_mstr),
                                      input        chg_attr,
                                      input        eff_date,
                                      input-output chg_assay,
                                      input-output chg_grade,
                                      input-output chg_expire,
                                      input-output chg_status,
                                      input-output assay_actv,
                                      input-output grade_actv,
                                      input-output expire_actv,
                                      input-output status_actv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /*TEST FOR ATTRIBUTE CONFLICTS*/
            for each sr_wkfl
               fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
               sr_site
                      sr_userid)
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
                 and sr_lineid = cline
               no-lock with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


               /* ADDED SIXTH PARAMETER EFF_DATE */
               /* ADDED SEVENTH PARAMETER sr_qty * trans_conv */
               {gprun.i ""worcat01.p"" "(input        recid(wo_mstr),
                                         input        sr_site,
                                         input        sr_loc,
                                         input        sr_ref,
                                         input        sr_lotser,
                                         input        eff_date,
                                         input        sr_qty
                                                      * trans_conv,
                                         input-output chg_assay,
                                         input-output chg_grade,
                                         input-output chg_expire,
                                         input-output chg_status,
                                         input-output assay_actv,
                                         input-output grade_actv,
                                         input-output expire_actv,
                                         input-output status_actv,
                                         output       trans-ok)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if not trans-ok
               then
                  do with frame a:
                     next-prompt site.
                     undo locloop, retry.
                  end. /* DO WITH FRAME a */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*FOR EACH sr_wkfl*/
         end. /*locloop*/

         tot_units = total_lotserial_qty * conv
                     + reject_qty * reject_conv.

         if ((total_lotserial_qty * conv > 0) and
            (reject_qty * reject_conv < 0)) or
            ((total_lotserial_qty * conv < 0) and
            (reject_qty * reject_conv > 0))
         then do:

            /*GOOD & SCRAPPED MUST HAVE SAME SIGN*/
            {pxmsg.i &MSGNUM=502 &ERRORLEVEL=3}
            reject_qty = 0.
            undo, retry.
         end. /* IF ((total_lotserial_qty * conv > 0) */

         /* CHECK FOR lotserial_qty ENTERED */
         if (wo_qty_ord > 0 and
            (wo_qty_comp + (total_lotserial_qty * conv)) < 0) or
            (wo_qty_ord < 0 and
            (wo_qty_comp + (total_lotserial_qty * conv)) > 0)
         then do:

            /*REVERSE RCPT MAY NOT EXCEED PREV RCPT*/
            {pxmsg.i &MSGNUM=556 &ERRORLEVEL=3}
            reject_qty = 0.
            undo, retry.
         end. /* IF (wo_qty_ord > 0 */

         /* CHECK FOR reject_qty ENTERED */
         if (wo_qty_ord > 0 and
            (wo_qty_rjct + (reject_qty * reject_conv)) < 0) or
            (wo_qty_ord < 0 and (wo_qty_rjct + (reject_qty * reject_conv)) >  0)
         then do:

            /*REVERSE SCRAP MAY NOT EXCEED PREV SCRAP*/
            {pxmsg.i &MSGNUM=1373 &ERRORLEVEL=3}.
            reject_qty = 0.
            undo, retry.
         end. /* IF (wo_qty_ord > 0 */

         display tot_units with frame a.


         /* ss lambert 20100517 begin */
         /* ss - 100526.1 -b
         if not ( wo_nbr begins "03" ) then do: /* 不是半成品工单 */
           ss - 100526.1 -e */
         /* ss - 100526.1 -b */
         if not ( wo_part begins "03" ) then do: /* 不是半成品工单 */
        /* ss - 100526.1 -e */
             for last wr_route no-lock where wr_domain = global_domain
                  and wr_lot = wo_lot break by wr_op:
           end.
           if avail wr_route then do: /* 有工艺记录 */
             find first pod_det no-lock where pod_domain = global_domain and
               pod_wo_lot = wo_lot and pod_op = wr_op no-error.
             if not avail pod_det then do:  /* 不是委外加工单 */
               if wr_status <> "C" then do:
                 message "工时汇报未完成" .
                 undo, retry.
               end.

                 IF wr_qty_comp <> 0  THEN DO:  /***Tony 2011-08-08 added ******/

                 if tot_units <> wr_qty_comp then do:
                     /* ss - 100528.1 -b
                 message "入库数量不等于回报数量" .
                 undo, retry.
                       ss - 100528.1 -e */
                     /* ss - 100528.1 -b */
                        v_qty =  lotserial_qty .
                       message "入库数量不等于汇报数量:"  + string(wr_qty_comp) .
                      next-prompt  lotserial_qty with frame a.
                        UNDO setd ,   RETRY setd.
                     /* ss - 100528.1 -e */
               end.

             /*** Tony added 2010-07-21 *******/
               if tot_units + wo_qty_comp + wo_qty_rjct > (wo_qty_ord  + wo_qty_ord * 0.15) then do:
                    message "入库总数量超过工单下达数量:"  + STRING(tot_units + wo_qty_comp + wo_qty_rjct) + ">" +  string(wo_qty_ord) + "的%15" .
                      next-prompt  lotserial_qty with frame a.
                        UNDO setd ,   RETRY setd.
               end.
             /*** Tony added 2010-07-21 ***/
             end.
                 END. /***Tony 2011-08-08 added ******/
           end.
         end.
         /* ss lambert 20100517 end */

         if regular
         then
            do on endkey undo setd, retry:
               update
                  rmks
                  close_wo
               with frame a.
            end. /* DO ON ENDKEY UNDO */

         /* CLOSING FOR A SINGLE JOINT PRODUCT RECEIPT   */
         /* RESULTS IN CLOSING ALL RELATED JOINT PRODUCT */
         /* WORK ORDERS                                  */
         if jp
         then
            do on endkey undo setd, retry:
               update
                  rmks
                  close_wo
               with frame a.
            end. /* DO ON ENDKEY UNDO */

         /*MAKE SURE THAT ALL JOINT ORDERS USE THE SAME COST SETS*/
         if close_wo and
            jp
         then do:

            /* ALL JOINT WOS WILL CLOSE */
            {pxmsg.i &MSGNUM=6554 &ERRORLEVEL=2}
            {gprun.i ""woavgck1.p"" "(input  wo_nbr,
                                      output undo_all)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if undo_all
            then do:

               /*COST SET ASSIGN INCOMPLETE*/
               {pxmsg.i &MSGNUM=6553 &ERRORLEVEL=4}
               close_wo = no.
               next-prompt close_wo with frame a.
            end. /* IF undo_all */
         end. /* IF close_wo */

         do on endkey undo setd, retry setd:
            yn = yes.
            /* Display lotserials being received? */
            {pxmsg.i &MSGNUM=359 &ERRORLEVEL=1 &CONFIRM=yn}
            if yn
            then do:

               hide frame a.
               FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
                     wo_nbr
                     wo_lot
                     wo_part
                SKIP(.4)  /*GUI*/
with frame b side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
               display wo_nbr wo_lot wo_part with frame b.

               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_site
                         sr_userid)
                  no-lock
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  with frame b-2 width 80:

                  /* SET EXTERNAL LABELS */
                  setFrameLabels(frame b-2:handle).
                  display
                           space(1)
                           sr_site
                           sr_loc
                           sr_lotser
                           sr_ref format "x(8)" column-label {&woworcd_p_4}
                           sr_qty.
               end. /* FOR EACH sr_wkfl */
            end. /* IF yn */
         end. /* DO ON ENDKEY UNDO setd, RETRY setd */

         do on endkey undo setd, retry setd:

            yn = yes.
            /* "IS ALL INFO CORRECT?" */
            {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}

            if yn
            then do:

               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                          sr_site   sr_userid)
                  where sr_domain = global_domain
                  and   sr_userid = mfguser
                  and   sr_lineid = cline
               no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


                  {gprun.i ""worcat01.p""
                     "(input        recid(wo_mstr),
                       input        sr_site,
                       input        sr_loc,
                       input        sr_ref,
                       input        sr_lotser,
                       input        eff_date,
                       input        sr_qty * trans_conv,
                       input-output chg_assay,
                       input-output chg_grade,
                       input-output chg_expire,
                       input-output chg_status,
                       input-output assay_actv,
                       input-output grade_actv,
                       input-output expire_actv,
                       input-output status_actv,
                       output       trans-ok)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if not trans-ok
                  then
                     undo setd, retry setd.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*FOR EACH sr_wkfl*/

               {gplock.i  &domain="wo_mstr.wo_domain = global_domain and "
               &file-name=wo_mstr
                         &find-criteria="recid(wo_mstr) = wo_recno"
                         &exit-allowed=yes
                         &record-id=recno}

               if keyfunction(lastkey) = "end-error"
               then do:
                  for first wo_mstr
                     fields( wo_domain wo_assay wo_batch wo_expire wo_fsm_type
                            wo_grade wo_joint_type wo_loc wo_lot wo_lot_next
                            wo_lot_rcpt wo_nbr wo_part wo_qty_chg wo_qty_comp
                            wo_qty_ord wo_qty_rjct wo_rctstat wo_rctstat_active
                            wo_rjct_chg wo_rmks wo_site wo_status wo_type)
                     where recid(wo_mstr) = wo_recno
                     no-lock:
                  end. /* FOR FIRST wo_mstr */

                  next setd.
               end. /* IF KEYFUNCTION(LASTKEY) = "END-ERROR" */

               if not available wo_mstr
               then do:
                  /* WORK ORDER/LOT DOES NOT EXIST. */
                  {pxmsg.i &MSGNUM=510 &ERRORLEVEL=4}
                  leave.
               end. /* IF NOT AVAILABLE wo_mstr */

               if conv <> 1
               then
                  for each sr_wkfl exclusive-lock  where sr_wkfl.sr_domain =
                  global_domain and  sr_userid = mfguser
                                                  and   sr_lineid = cline:
                     sr_qty = sr_qty * conv.
                  end. /* FOR EACH sr_wkfl */

               assign
                  total_lotserial_qty = total_lotserial_qty * conv
                  {&WOWORCD-P-TAG8}
                  wo_qty_chg          = total_lotserial_qty
                  wo_rjct_chg         = reject_qty * reject_conv.

               release wo_mstr.
               undo_setd = no.

            end. /* IF yn */
            hide frame b.
            hide frame b-2.
            if yn
            then
               leave setd.

         end. /* DO ON ENDKEY UNDO setd, RETRY setd */

         undo_setd = no.

               hide frame b.
   end. /*setd*/
end.  /* IF regular OR NOT jp-yn */

if keyfunction(lastkey) = "END-ERROR"
then
   undo_setd = yes.

assign
   site      = global_site
   location  = global_loc.
