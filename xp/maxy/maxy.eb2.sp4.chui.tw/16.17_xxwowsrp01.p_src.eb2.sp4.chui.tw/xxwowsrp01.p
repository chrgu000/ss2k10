/* wowsrp01.p - WORK ORDER COMPONENT SHORTAGE BY PART REPORT                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                        */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 4.0    LAST MODIFIED: 04/26/89    BY: emb *A722*                 */
/* REVISION: 6.0    LAST MODIFIED: 04/16/91    BY: RAM *D530*                 */
/* REVISION: 7.1    LAST MODIFIED: 03/16/94    BY: wug *A175*                 */
/* REVISION: 7.4    LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                 */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97    BY: ays *K0YP*                 */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane           */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan          */
/* REVISION: 8.6E   LAST MODIFIED: 10/28/99    BY: *L0KR* Jyoti Thatte        */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown          */
/* Revision: 1.11     BY: Katie Hilbert        DATE: 04/01/01   ECO: *P008*   */
/* Revision: 1.14     BY: Vivek Gogte          DATE: 04/30/01 ECO: *P001*     */
/* $Revision: 1.15 $  BY: Manjusha Inglay      DATE: 08/28/01 ECO: *P01R*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090713.1 By: Roger Xiao */
/* SS - 090721.1 By: Roger Xiao */

/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090713.1 - RNB
1.本次修改只是确保:每次換行,只要換了零件就顯示零件號和說明.
2.另發現標准程式有bug,本次未修改: 發料政策為no的零件的首筆工單記錄不會顯示.
SS - 090713.1 - RNE */

/* SS - 090721.1 - RNB
修改成:發料政策為no的零件全部不顯示
SS - 090721.1 - RNE */

{mfdtitle.i "090721.1"}




/* DISPLAY TITLE */
/*{mfdtitle.i "b+ "}*/

define variable nbr   like wod_nbr.
define variable nbr1  like wod_nbr.
define variable lot   like wod_lot.
define variable part  like wod_part.
define variable part1 like wod_part.
define variable site  like wod_site no-undo.
define variable site1 like wod_site no-undo.
define variable ord_okay like wod_lot.
define variable ord_ignore like wod_lot.
define variable old_part like wod_part.
define variable open_ref like wod_qty_req format ">>>,>>9.9999".
define variable desc2 like pt_desc2.

/* SS - 090713.1 - B */
    define var v_part  like pt_part .
    define var v_desc1 like pt_desc1 .
    define var v_desc2 like pt_desc2 .
/* SS - 090713.1 - E */
define buffer wod_det1 for wod_det.

form
   part     colon 15 part1     label {t001.i} colon 49 skip
   nbr      colon 15 nbr1      label {t001.i} colon 49 skip
   site     colon 15 site1     label {t001.i} colon 49 skip(1)
   lot      colon 15  skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if nbr1  = hi_char then  nbr1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".

   if c-application-mode <> 'web' then
      update part part1 nbr nbr1 site site1 lot with frame a.

   {wbrp06.i &command = update &fields = "  part part1 nbr nbr1 site site1
                                         lot" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i lot    }

      if nbr1  = "" then nbr1  = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   old_part = ?.

   /* FIND AND DISPLAY */
   for each wod_det where (wod_nbr >= nbr and wod_nbr <= nbr1)
         and (wod_lot = lot or lot = "")
         and (wod_part >= part and wod_part <= part1)
         and (wod_site >= site and wod_site <= site1)
         and wod_qty_req > wod_qty_iss
         and wod_qty_req <> 0
         no-lock by wod_part by wod_nbr by wod_lot
      with frame b.

      form
         wod_part
         pt_desc1
         wo_nbr
         wo_lot
         wod_iss_date
         open_ref
         wo_part
         wo_so_job
         wo_due_date
      with frame b width 132 no-attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if ord_ignore = wod_lot then next.
      if old_part <> wod_part then do with frame b:
         ord_ignore = wod_lot.
         find wo_mstr where wo_lot = wod_lot no-lock no-error.
         if not available wo_mstr then next.
         if (wo_status <> "R") then next.

         for each wod_det1 where wod_det1.wod_lot = wo_lot no-lock:
            if wod_det1.wod_qty_iss > 0 then do:
               find pt_mstr no-lock where pt_part = wod_part no-error.
               find ptp_det where ptp_part = wod_part
                  and ptp_site = wod_site no-lock no-error.

               if (available ptp_det and ptp_iss_pol = yes)
                  or (not available ptp_det and available pt_mstr
                  and pt_iss_pol = yes)
               then do:
                  assign
                     ord_ignore = ""
                     ord_okay = wo_lot.
                  leave.
               end.
            end.
         end.

         if wo_lot = ord_ignore then next.
         old_part = wod_part.
         find pt_mstr where pt_part = wod_part no-lock no-error.

         for first ptp_det
               fields(ptp_iss_pol ptp_part ptp_site)
               where ptp_part = wod_part no-lock:
         end. /* FOR FIRST PTP_DET */

         if (available ptp_det and ptp_iss_pol = no)
            or (not available ptp_det and available pt_mstr
            and pt_iss_pol = no) then next.

         if desc2 <> "" then do with frame b:
            display desc2 @ pt_desc1.
            desc2 = "".
            down 1.
         end.
         desc2 = pt_desc2.
         if old_part <> ? then put skip(1).
         if page-size - line-counter < 4 then page.
         display wod_part label "Component Item" pt_desc1.
            /* SS - 090713.1 - B */
            v_part = wod_part .  /*每次顯示part,記錄本行的part,防止本行重复顯示*/
            /* SS - 090713.1 - E */
      end.

      if ord_okay <> wod_lot then do:
         ord_ignore = wod_lot.
         find wo_mstr where wo_lot = wod_lot no-lock no-error.
         if not available wo_mstr then next.
         if (wo_status <> "R") then next.

         for each wod_det1 where wod_det1.wod_lot = wo_lot no-lock:
            if wod_det1.wod_qty_iss > 0 then do:
               find pt_mstr no-lock where pt_part = wod_part no-error.
               find ptp_det where ptp_part = wod_part
                  and ptp_site = wod_site no-lock no-error.

               if (available ptp_det and ptp_iss_pol = yes)
                  or (not available ptp_det and available pt_mstr
                  and pt_iss_pol = yes)
               then do:
                  assign
                     ord_ignore = ""
                     ord_okay = wo_lot.
                  leave.
               end.
            end.
         end.
         if wo_lot = ord_ignore then next.

      end.

      if page-size - line-counter < 2
         and desc2 <> "" then page.

      open_ref = max(wod_qty_req - max(wod_qty_iss,0),0).

/* SS - 090713.1 - B 
      if open_ref > 0 then
         display
            wo_nbr
            wo_lot
            wod_iss_date
            open_ref
            wo_part
            wo_so_job
            wo_due_date
         with frame b.
   SS - 090713.1 - E */
/* SS - 090713.1 - B */
        if open_ref > 0 then do:
            /* SS - 090721.1 - B */
                find pt_mstr where pt_part = wod_part no-lock no-error.
                find ptp_det where ptp_part = wod_part and ptp_site = wod_site no-lock no-error.
                if (available ptp_det and ptp_iss_pol = no)
                    or (not available ptp_det and available pt_mstr
                    and pt_iss_pol = no)
                then next .
            /* SS - 090721.1 - E */

            if v_part <> wod_part then do:
                find pt_mstr where pt_part = wod_part no-lock no-error.
                desc2 = if avail pt_mstr then pt_desc2 else  "" .
                if old_part <> ? then put skip(1).
                if page-size - line-counter < 4 then page.
                display wod_part label "Component Item" pt_desc1.
            end.

            display
                wo_nbr
                wo_lot
                wod_iss_date
                open_ref
                wo_part
                wo_so_job
                wo_due_date
            with frame b.

            v_part = wod_part . /*每次換行都記錄上一行的part*/
        end.
/* SS - 090713.1 - E */
      {mfrpexit.i}

      if desc2 <> "" then do:
         down 1.
         display desc2 @ pt_desc1 .
         desc2 = "".
      end. /* IF DESC2 <> "" */

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
