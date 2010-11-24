/* wowarp01.p - ALLOCATIONS BY ORDER REPORT                                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                        */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML                       */
/* REVISION: 1.0      LAST MODIFIED: 05/13/86   BY: EMB                       */
/* REVISION: 1.0      LAST MODIFIED: 09/02/86   BY: EMB *12*                  */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94*                 */
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175*                */
/* REVISION: 5.0      LAST MODIFIED: 10/26/89   BY: emb *B357*                */
/* REVISION: 5.0      LAST MODIFIED: 11/30/89   BY: emb *B409*                */
/* REVISION: 5.0      LAST MODIFIED: 04/13/90   BY: emb *B663*                */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: emb *G656*                */
/* REVISION: 7.2      LAST MODIFIED: 02/28/95   BY: ais *F0KM*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: ays *K102*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Revision: 1.10     BY: Katie Hilbert         DATE: 04/01/01 ECO: *P008*    */
/* Revision: 1.13     BY: Vivek Gogte           DATE: 04/30/01 ECO: *P001*    */
/* Revision: 1.14  BY: Manjusha Inglay DATE: 08/28/01 ECO: *P01R* */
/* $Revision: 1.16 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable vend like wo_vend.
define variable nbr like wod_nbr.
define variable nbr1 like wod_nbr.
define variable lot like wod_lot.
define variable part like wod_part   label "Component".
define variable part1 like wod_part.
define variable site  like wo_site no-undo.
define variable site1 like wo_site no-undo.
define variable desc1 like pt_desc1.
define variable desc2 as character format "x(152)".
define variable wodesc1 like pt_desc1.
define variable wodesc2 like pt_desc1.
define variable open_ref like wod_qty_req label "Qty Open".
define variable all_pick like wod_qty_req label "Qty Alloc/Pick".
define variable s_num as character extent 4.
define variable d_num as decimal decimals 9 extent 4.
define variable i as integer.
define variable j as integer.
define variable loc like wod_loc.

form
   nbr            colon 15
   nbr1           label {t001.i} colon 49 skip
   part           colon 15
   part1          label {t001.i} colon 49
   site           colon 15
   site1          label {t001.i} colon 49 skip (1)
   lot            colon 15 skip
   loc            colon 15 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if nbr1  = hi_char then nbr1  = "".
   if site1 = hi_char then site1 = "".

   if c-application-mode <> 'web' then
      update nbr nbr1 part part1 site site1 lot loc with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 part part1
                                          site site1 lot loc" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i lot    }
      {mfquoter.i loc    } 
      
      if nbr1  = "" then nbr1  = hi_char.
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

   /* FIND AND DISPLAY */
   for each wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and (
   (wo_nbr >= nbr and wo_nbr <= nbr1)
         and (wo_lot = lot or lot = "")
         and (wo_site >= site and wo_site <= site1) ),
         each wod_det  where wod_det.wod_domain = global_domain and (wod_lot
         = wo_lot and (wod_part >= part) and (wod_part <= part1 or part1 = "")
         and (wod_loc = loc or wod_loc = "")
         ) no-lock break by wo_nbr by wod_lot by wod_part
      with frame b width 300 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      form
         wo_nbr         colon 15        wo_lot       colon 45
         wo_rmks        colon 71
         wo_part        colon 15        wo_so_job    colon 45
         wo_qty_ord     colon 71
         pt_um          no-label
         wo_ord_date    colon 104
         desc1          at 17 no-label
         wo_qty_comp    colon 71        wo_rel_date  colon 104
         wo_status      colon 15        wo_vend      colon 45
         wo_qty_rjct    colon 71        wo_due_date  colon 104
      with frame c side-labels width 132 no-attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      if first-of(wod_lot) then do with frame c:
         desc1 = "".
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         wo_part no-lock no-error.
         if available pt_mstr then desc1 = pt_desc1.
         if page-size - line-counter < 9 then page.

         display
            wo_nbr wo_lot wo_qty_ord wo_ord_date wo_part desc1
            pt_um when (available pt_mstr)
            wo_qty_comp wo_rel_date wo_so_job wo_qty_rjct wo_due_date
            wo_vend wo_status wo_rmks
         with frame c side-labels.
      end.

      if wod_qty_req >= 0
      then open_ref = max(wod_qty_req - wod_qty_iss,0).
      else open_ref = min(wod_qty_req - wod_qty_iss,0).

      all_pick = wod_qty_all + wod_qty_pick.

      if wo_status = "C" then
      assign
         open_ref = 0
         all_pick = 0.

      desc1 = "".
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock no-error.
      if available pt_mstr then desc1 = pt_desc1.

      if page-size - line-counter < 2 and available pt_mstr
         and pt_desc2 <> "" then page.
         
     find first cd_det where cd_domain = global_domain and cd_ref = wod_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
     if avail cd_det then 
     do:
     	 desc2 =  cd_cmmt[1] + cd_cmmt[2]. 
     end.
     else
     do:
      if available pt_mstr and pt_desc2 <> "" then do with frame b:
        desc2 = pt_desc2.
      end.
     end.   

      display space(8) wod_part desc1
         wod_op
         wod_qty_req
         all_pick wod_qty_iss open_ref
         space(2) wod_iss_date desc2.
     
     
     
      {mfrpchk.i}
   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
