/* mfworlb.i - PRINT PICKLISTS                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.15 $                                                        */
/*V8:ConvertMode=Report                                                     */
/* REVISION: 1.0     LAST MODIFIED: 05/06/86    BY: EMB                     */
/* REVISION: 1.0     LAST MODIFIED: 09/02/86    BY: EMB *12*                */
/* REVISION: 1.0     LAST MODIFIED: 02/05/87    BY: EMB *35*                */
/* REVISION: 2.0     LAST MODIFIED: 07/24/87    BY: EMB *A75*               */
/* REVISION: 2.0     LAST MODIFIED: 09/03/87    BY: EMB *A88*               */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: WUG *A94*               */
/* REVISION: 4.0     LAST MODIFIED: 01/29/88    BY: PML *A119*              */
/* REVISION: 4.0     LAST MODIFIED: 06/08/88    BY: FLM *A268*              */
/* REVISION: 4.0     LAST MODIFIED: 06/16/88    BY: EMB *A288*              */
/* REVISION: 4.0     LAST MODIFIED: 07/15/88    BY: WUG *A324*              */
/* REVISION: 4.0     LAST MODIFIED: 07/26/88    BY: WUG *A363*              */
/* REVISION: 4.0     LAST MODIFIED: 09/22/88    BY: EMB *A451*              */
/* REVISION: 4.0     LAST MODIFIED: 11/18/88    BY: EMB *A539*              */
/* REVISION: 4.0     LAST MODIFIED: 12/13/88    BY: RL  *B001*              */
/* REVISION: 4.0     LAST MODIFIED: 03/16/89    BY: MLB *A672*              */
/* REVISION: 4.0     LAST MODIFIED: 01/22/90    BY: EMB *A802*              */
/* REVISION: 6.0     LAST MODIFIED: 05/03/90    BY: MLB *D024*              */
/* REVISION: 6.0     LAST MODIFIED: 07/03/90    BY: WUG *D043*              */
/* REVISION: 6.0     LAST MODIFIED: 07/31/90    BY: WUG *D051*              */
/* REVISION: 6.0     LAST MODIFIED: 07/31/90    BY: WUG *D054*              */
/* REVISION: 6.0     LAST MODIFIED: 04/09/91    BY: RAM *D508*              */
/* REVISION: 6.0     LAST MODIFIED: 04/16/91    BY: RAM *D530*              */
/* REVISION: 6.0     LAST MODIFIED: 10/05/91    BY: SMM *D887*              */
/* REVISION: 7.0     LAST MODIFIED: 04/01/92    BY: ram *F351*              */
/* REVISION: 7.0     LAST MODIFIED: 08/18/92    BY: ram *F858*              */
/* REVISION: 7.3     LAST MODIFIED: 02/03/93    BY: emb *G656*              */
/* REVISION: 7.3     LAST MODIFIED: 04/29/93    BY: ksp *GA63*              */
/* Oracle changes (share-locks)     09/12/94    BY: rwl *FR19*              */
/* REVISION: 7.5     LAST MODIFIED: 10/14/94    BY: TAF *J035*              */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane        */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan       */
/* REVISION: 8.6E    LAST MODIFIED: 10/28/98    BY: *J330* Mugdha Tambe     */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.13     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*         */
/* $Revision: 1.15 $    BY: Tiziana Giustozzi     DATE: 09/16/01  ECO: *N12M*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfworlb_i_2 "Work Order Due Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_3 "Site!Location"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_5 "Required!Qty to Issue"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_6 "Rv"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_7 "Rev"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_9 "Lot/Serial!Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_10 " Issued"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_11 "Floor Stock"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

DEFINE VAR v_qty_oh LIKE ld_qty_oh.

define variable description like pt_desc1.
define variable um like pt_um.
define variable loc like pt_loc.
define variable issued as character initial "(      )" label {&mfworlb_i_10}.
define variable issued1 as character initial "(      )" .
DEFINE VAR v_flag11 AS LOGICAL.
define variable com_rev like pt_rev label {&mfworlb_i_6}.
define variable issue-date like wod_iss_date.
define variable qtyall like lad_qty_all.
define variable c-cont as character format "x(18)" no-undo.
define variable c-quantity as character format "x(18)" no-undo.
define variable c-not-avail as character format "x(18)" no-undo.
define variable c-msg-text  as character format "x(45)" no-undo.

define new shared variable wod_recno as recid.
define new shared variable fas_unit_qty as character.

define workfile floorstk no-undo
   field fs_part as character label {&mfworlb_i_11} format "x(28)"
   field fs_qty like wod_qty_req.

assign
   c-cont = "*** " + getTermLabel("CONTINUED",18) + " ***"
   c-quantity = getTermLabel("QUANTITY",18)
   c-not-avail = getTermLabel("NOT_AVAILABLE",18) + ":".

{xxmfworlb1.i &row="1"}

/* SS - Micho 20060320 B */
/*
form
   skip (1)
   wo_nbr         colon 13
   wod_iss_date   colon 68
   wo_lot         colon 13
   wo_batch       colon 13
   wo_part        colon 13
   par_rev        colon 40 label {&mfworlb_i_7}
   wo_due_date    colon 68 label {&mfworlb_i_2} skip
   wo_des         no-label format "x(49)" at 15
   wo_rmks        colon 13
   wo_so_job      colon 68
   wo_qty         colon 13
   wo_um          no-label
   deliv          colon 68 skip (1)
with frame picklist page-top side-labels no-attr-space width 80
   title (getFrameTitle("WORK_ORDER_PICKLIST",25)).
   */
form
   skip (1)
   wo_nbr         COLON 13
   wod_iss_date   colon 68
   wo_lot         COLON 13
   wo_due_date    colon 68 label {&mfworlb_i_2} 
   wo_batch       COLON 13
   wo_part        COLON 13 FORMAT "x(18)" 
   wo_des         no-label format "x(49)" at 35
   wo_rmks        COLON 13
   wo_so_job      colon 68
   /*par_rev        colon 40 label {&mfworlb_i_7}*/
   wo_qty         COLON 13
   wo_um          no-label
   deliv          colon 68 skip (1)
with frame picklist page-top side-labels no-attr-space width 95
   title (getFrameTitle("WORK_ORDER_PICKLIST",25)).
/* SS - Micho 20060320 E */

FORM HEADER
     SKIP
     "_____________________________________________________________________________________________"   SKIP(1)
     "编制：                           审批：                          盖章：                      " 
     WITH STREAM-IO FRAME v_page PAGE-BOTTOM WIDTH 120 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame picklist:handle).

/* Read control file for configured product unit control flag */
do transaction:
   fas_unit_qty = string(false).      /*DEFAULT VALUE*/
   find first fac_ctrl no-lock no-error.
   if available fac_ctrl then fas_unit_qty = string(fac_unit_qty).
end.

find pt_mstr where pt_part = wo_part no-lock no-error.

assign
   wo_des = ""
   wo_um = ""
   par_rev = "".

if available pt_mstr
then do:
   assign
      wo_des = pt_desc1
      wo_des = wo_des + " " + pt_desc2
      wo_um = pt_um.

   /*  REVISION NUMBER IS DISPLAYED FROM PTP_DET TO GET LATEST  */
   /*  MODIFIED REVISION NUMBER                                 */
   for first ptp_det
      where ptp_part = wo_part and ptp_site = wo_site
      no-lock:
   end. /* FOR FIRST PTP_DET */

   if available ptp_det then
      assign par_rev = ptp_rev .

   else assign par_rev =  pt_rev .

end.

issue-date = ?.

for each wod_det where wod_lot = wo_lot no-lock:

   if issue-date = ? or issue-date > wod_iss_date then
      issue-date = wod_iss_date.

   if incl_floor_stk
   then do:
      find pt_mstr where pt_part = wod_part no-lock no-error.
      find ptp_det where ptp_part = wod_part and ptp_site = wod_site
      no-lock no-error.

      if (available ptp_det and ptp_iss_pol = no)
         or (not available ptp_det
         and available pt_mstr and pt_iss_pol = no)
      then do:
         find last floorstk where fs_part < wod_part no-error.
         create floorstk.
         assign
            fs_part = wod_part
            fs_qty = wod_qty_req.
      end.

   end.

end.

for each wod_det exclusive-lock
   where wod_lot = wo_lot
     and ((wod_qty_req = 0 and incl_zero_reqd)
     or wod_qty_all <> 0
     or (wod_qty_pick <> 0 and incl_pick_qtys)
     or (max(wod_qty_req - wod_qty_iss,0) = 0 and incl_zero_open)
     or (max(wod_qty_req - wod_qty_iss,0) > 0 and wod_qty_all <> 0))
   break by wod_lot by wod_iss_date by wod_part
   with frame detail no-box down:

   picklistprinted = yes.

   if first-of(wod_iss_date)
   then do:
      hide frame picklist.
      page.
      display wod_iss_date with frame picklist.
   end.

   if first-of(wod_lot)
   then do:
      display
         wo_nbr
         wo_lot
         wo_batch
         wo_part
         /* SS - Micho 20060320 B */
         /*
         par_rev 
         */
         /* SS - Micho 20060320 E */
         wod_iss_date
         wo_due_date
         wo_des
         wo_rmks
         wo_so_job
         wo_qty
         wo_um deliv
      with frame picklist.

      for each sod_det where sod_nbr = wo_so_job no-lock:

         if sod_fa_nbr = wo_nbr and sod_lot = wo_lot
         then do:
            {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
         end.
         else
      if sod_fa_nbr = wo_nbr and sod_lot = "" and fas_unit_qty = string(true)
      then do:
            find pt_mstr where pt_part = sod_part no-lock no-error.

            if available pt_mstr and pt_lot_ser = "S"
            then do:
               {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
            end.

         end.

      end.

   end.
   else view frame picklist.

   /*DISPLAY COMMENTS */
   if first-of(wod_iss_date)
   then do:
      {gpcmtprt.i &type=RP &id=wo_cmtindx &pos=3}
      PUT SKIP(1) .
   end.

   assign
      um = ""
      loc = ""
      com_rev = ""
      loc = wod_loc
      description = "".

   find pt_mstr where pt_part = wod_part no-lock no-error.

   FIND ld_det WHERE ld_site = wod_site AND ld_Loc = wod_loc AND ld_part = wod_part NO-LOCK NO-ERROR.
   IF AVAIL ld_det THEN v_qty_oh = ld_qty_oh  .

   find ptp_det where ptp_part = wod_part and ptp_site = wod_site
   no-lock no-error.

   if (available ptp_det and ptp_iss_pol = no)
      or (not available ptp_det
      and available pt_mstr and pt_iss_pol = no) then next.

   if available pt_mstr
   then do:
      um = pt_um.

      if loc = "" then
         loc = pt_loc.

      assign
         description = pt_desc1
         description = description + " " + pt_desc2.

      if available ptp_det then
         assign
           com_rev = ptp_rev .
      else
         assign
            com_rev = pt_rev .
   end.

   
   if page-size - line-counter < 4 THEN PAGE.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame detail:handle).

   display
      wod_part COLUMN-LABEL "项目!说明"
      /* SS - Micho 20060320 B */
      /*
      com_rev
      */
      /* SS - Micho 20060320 E */
      wod_site @ lad_loc column-label "厂别!库位"
      "" @ lad_lot column-label "批/序号!参考号"
      v_qty_oh @ ld_qty_oh COLUMN-LABEL "现有!库存量"
      max(wod_qty_req - wod_qty_iss,0) @ wod_qty_all column-label "需发放量"
      um
      issued COLUMN-LABEL "已发放"
      issued1 NO-LABEL
   with frame detail width 95 no-attr-space.
   down 1 with frame detail.

   if available pt_mstr and pt_desc1 <> ""
   then do:
      if page-size - line-counter < 1
      then do:
         page.
         /*DISPLAY CONTINUED*/
         display
            wod_part
            c-cont @ lad_lot
         with frame detail.
         down 1 with frame detail.

      end.

      put pt_desc1 skip.

   end.

   if available pt_mstr and pt_desc2 <> ""
   then do:
      if page-size - line-counter < 1
      then do:
         page.
         /*DISPLAY CONTINUED*/
         display
            wod_part
            c-cont @ lad_lot
         with frame detail.
         down 1 with frame detail.

      end.

      put pt_desc2 skip.

   end.


   /*DISPLAY ALLOCATION DETAIL*/
   for each lad_det
      where lad_dataset = "wod_det"
        and lad_nbr = wod_lot and lad_line = string(wod_op)
        and lad_part = wod_part with frame detail:

      find ld_det
         where ld_site = lad_site
           and ld_loc = lad_loc
           and ld_part = lad_part
           and ld_lot = lad_lot
           and ld_ref = lad_ref
         no-lock no-error.

      accumulate lad_qty_all (total).

      if page-size - line-counter < 1
      then do:
         page.
         /*DISPLAY CONTINUED*/
         display
            wod_part
            c-cont @ lad_lot
         with frame detail.
         down 1 with frame detail.

      end.

      if incl_pick_qtys then
         qtyall = lad_qty_all + lad_qty_pick.
      else
         qtyall = lad_qty_all.

      display
         lad_loc
         lad_lot
         qtyall @ wod_qty_all column-label "需发放量"
         issued COLUMN-LABEL "已发放"
         issued1 NO-LABEL
         with frame detail.
      down 1 with frame detail.

      display
         lad_ref @ lad_lot
      with frame detail.

      if available ld_det and ld_expire <> ? then
         display
            ld_expire @ lad_loc
         with frame detail.
         down 1 with frame detail.

      /*IF QTY OH - QTY ALL TO OTHER ORDERS < QTY ALL TO THIS ORDER*/
      if not available ld_det
         or ld_qty_oh - ld_qty_all + lad_qty_all < lad_qty_all
      then do:
         if page-size - line-counter < 1
         then do:
            page.
            /*DISPLAY CONTINUED*/
            display
               wod_part
               c-cont @ lad_lot
            with frame detail.
            down 1 with frame detail.

         end.

            /*Quantity not available at this location*/
            {pxmsg.i &MSGNUM=4992 &ERRORLEVEL=1 &MSGBUFFER=c-msg-text}

            put c-msg-text at 20 skip.
      end.

      /*UPDATE QTY PICKED*/
      assign
         lad_qty_pick = lad_qty_pick + lad_qty_all
         lad_qty_all = 0.

   end.

   
   if wod_qty_all > accum total(lad_qty_all)
      then do with frame detail:

      if page-size - line-counter < 1
      then do:
         page.
         /*DISPLAY CONTINUED*/
         display
            wod_part
            c-cont @ lad_lot
         with frame detail.
         down 1 with frame detail.

      end.

      display
         "      ********" @ wod_part
         c-quantity @ lad_loc
         c-not-avail @ lad_lot
         wod_qty_all - accum total (lad_qty_all) @ wod_qty_all
         "********" @ issued
      with frame detail.
   end.

   VIEW FRAME v_page .
   
   put skip(1).
   assign
      wod_qty_pick = wod_qty_pick + accum total(lad_qty_all)
      wod_qty_all = wod_qty_all - accum total(lad_qty_all).

end. /*FOR EACH*/

if incl_floor_stk
then do:
   find first floorstk no-error.

   if available floorstk
   then do:
      if picklistprinted = no
      then do:
         hide frame picklist.
         page.

         display
            wo_nbr
            wo_lot
            wo_batch
            wo_part

            /* SS - Micho 20060320 B */
            /*
            par_rev
            */
            /* SS - Micho 20060320 E */
            wo_due_date
            issue-date @ wod_iss_date
            wo_des
            wo_rmks
            wo_so_job
            wo_qty
            wo_um
            deliv
         with frame picklist.

         for each sod_det where sod_nbr = wo_so_job no-lock:

            if sod_fa_nbr = wo_nbr and sod_lot = wo_lot
            then do:
               {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
            end.

         end.

         /* DISPLAY COMMENTS */
         {gpcmtprt.i &type=RP &id=wo_cmtindx &pos=3}
         PUT SKIP(1).
         
         picklistprinted = yes.

      end. /*if picklistprinted = no.*/

      display skip(1) with frame floorstk1.

   end.

   if available floorstk then

   for each floorstk with frame floorstk width 80 no-attr-space down:

      find pt_mstr where pt_part = fs_part no-lock no-error.

      if (pt_desc1 <> "" or pt_desc2 <> "")
         and (page-size - line-counter < 2) then page.
      else
   if (pt_desc1 <> "" and pt_desc2 <> "")
         and (page-size - line-counter < 3) then page.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame floorstk:handle).

      display
         space(3)
         fs_part
         fs_qty
         pt_um.

      if pt_desc1 <> "" then down 1.
      if pt_desc1 <> "" then display "   " + pt_desc1 @ fs_part.
      if pt_desc2 <> "" then down 1.
      if pt_desc2 <> "" then display "   " + pt_desc2 @ fs_part.

      delete floorstk.

   end.

end.

page.
hide frame picklist.
