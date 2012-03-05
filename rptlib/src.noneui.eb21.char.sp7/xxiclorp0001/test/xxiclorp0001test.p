/* iclorp.p - PART LOCATION REPORT                                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 07/17/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 09/15/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 09/09/87   BY: WUG *A94**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88    BY: WUG *A175**/
/* REVISION: 6.0      LAST MODIFIED: 05/14/90    BY: WUG *D002**/
/* REVISION: 6.0      LAST MODIFIED: 07/10/90    BY: WUG *D051**/
/* REVISION: 6.0      LAST MODIFIED: 01/07/91    BY: emb *D337**/
/* REVISION: 6.0      LAST MODIFIED: 10/07/91    BY: SMM *D887*/
/* REVISION: 7.3      LAST MODIFIED: 04/16/93    BY: pma *G960*/
/* REVISION: 8.6      LAST MODIFIED: 10/16/97    BY: mur *K0NQ*/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13  BY: Jean Miller DATE: 04/06/02 ECO: *P056* */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091109.1 By: Bill Jiang */

/* SS - 091109.1 - RNB
[091109.1]
  
[091109.1]

SS - 091109.1 - RNE */

/* SS - 091109.1 - B */
{xxiclorp0001.i "new" }
/* SS - 091109.1 - E */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "091109.1"}

define variable part like pt_part.
define variable part1 like pt_part.
define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable um like pt_um.

/* SELECT FORM */
form
   part           colon 15
   part1          label "To" colon 49 skip
   site           colon 15
   site1          label "To" colon 49 skip
   loc            colon 15
   loc1           label "To" colon 49 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".

   if c-application-mode <> 'web' then
      update part part1 site site1 loc loc1 with frame a.

   {wbrp06.i &command = update
      &fields = "  part part1 site site1 loc loc1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i loc    }
      {mfquoter.i loc1   }

      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.

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
   /* SS - 091109.1 - B
   {mfphead.i}

   for each ld_det no-lock
       where ld_det.ld_domain = global_domain and  (ld_part >= part and ld_part
       <= part1)
      and (ld_site >= site and ld_site <= site1)
      and (ld_loc >= loc and ld_loc <= loc1)
      use-index ld_loc_p_lot,
      each pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = ld_part,
      each loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and
      loc_loc = ld_loc and loc_site = ld_site,
      each is_mstr no-lock  where is_mstr.is_domain = global_domain and
      is_status = ld_status
   break by ld_site by ld_loc by ld_part by ld_lot
   with frame b width 132:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if first-of(ld_lot) and last-of(ld_lot) and ld_ref = ""
      then do:
         display
            ld_site
            ld_loc
            ld_part
            ld_lot   column-label "Lot/Serial!Ref"
            pt_um
            ld_qty_oh
            ld_date
            ld_expire
            ld_assay
            ld_grade
            ld_status
            is_avail
            is_nettable
            is_overissue.
      end.

      else do:
         if first-of(ld_lot) then do:
            display ld_site ld_loc ld_part ld_lot.
            down 1.
         end.
         display
            ld_ref @ ld_lot
            pt_um
            ld_qty_oh
            ld_date
            ld_expire
            ld_assay
            ld_grade
            ld_status
            is_avail
            is_nettable
            is_overissue.
      end.

      if last-of(ld_loc) then do:
         down 1.
      end.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}
   SS - 091109.1 - E */

   /* SS - 091109.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH ttxxiclorp0001:
       DELETE ttxxiclorp0001.
   END.

   {gprun.i ""xxiclorp0001.p""
      "(input part,
        input part1,
        input site,
        input site1,
        input loc,
        input loc1
        )"}

   EXPORT DELIMITER ";" "地点" "库位" "物料号" "批/序号" "参考" "单位" "库存量" "生成日期" "到期日期" "检验 %" "等级" "库存状态" "可供货量" "可计划" "过量发放".
   EXPORT DELIMITER ";" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出".
   EXPORT DELIMITER ";" "ld_site" "ld_loc" "ld_part" "ld_lot" "ld_ref" "pt_um" "ld_qty_oh" "ld_date" "ld_expire" "ld_assay" "ld_grade" "ld_status" "is_avail" "is_nettable" "is_overissue".

   FOR EACH ttxxiclorp0001:
       EXPORT DELIMITER ";" ttxxiclorp0001 .
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {xxmfrtrail.i}
   /* SS - 091109.1 - E */

end.

{wbrp04.i &frame-spec = a}
