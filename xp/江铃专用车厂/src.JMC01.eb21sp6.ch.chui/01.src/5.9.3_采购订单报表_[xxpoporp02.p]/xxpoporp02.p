/* poporp02.p - PURCHASE ORDER REPORT BY PART                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.6 $                                                      */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 6.0      LAST MODIFIED: 04/18/90   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 05/24/90   BY: WUG *D002*                */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: pma *G068*                */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: tjs *G704** (rev only)    */
/* REVISION: 8.5      LAST MODIFIED: 10/12/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/08/96   BY: jzw *G1LD*                */
/* REVISION: 8.6      LAST MODIFIED: 11/21/96   BY: *K022* Tejas Modi         */
/* REVISION: 8.6      LAST MODIFIED: 04/03/97   BY: *K09K* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 10/03/97   BY: *mur* *K0KT*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L020* Charles Yen        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.4    BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00J*  */
/* Revision: 1.10.1.5    BY: Katie Hilbert       DATE: 11/14/03  ECO: *Q04M*  */
/* $Revision: 1.10.1.6 $ BY: Jean Miller         DATE: 03/02/04  ECO: *Q069*  */
/* SS - 101029.1  By: Roger Xiao */  /*设定通用代码权限的才可以打印价格和金额*/
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "101029.1"}

/* SS - 101029.1 - B */

define var v_canrun as logical no-undo.
v_canrun = no .
{gprun.i ""xxpopc593.p"" "(input global_userid , output v_canrun )"} 
/* SS - 101029.1 - E */

define new shared variable incl_b2b_po like mfc_logical
                                       label "Include EMT PO's".

define variable rndmthd         like rnd_rnd_mthd no-undo.
define variable oldcurr         like po_curr      no-undo.
define variable part            like pod_part     no-undo.
define variable part1           like pod_part     no-undo.
define variable nbr             like po_nbr       no-undo.
define variable nbr1            like po_nbr       no-undo.
define variable due             like pod_due_date no-undo.
define variable due1            like pod_due_date no-undo.
define variable so_job          like pod_so_job   no-undo.
define variable so_job1         like pod_so_job   no-undo.
define variable name            like ad_name      no-undo.
define variable qty_open        like pod_qty_ord label "Qty Open" no-undo.
define variable ext_cost        like pod_pur_cost label "Ext Cost"
                                format "->,>>>,>>>,>>9.99" no-undo.
define variable desc1           like pt_desc1 format "x(49)" no-undo.
define variable um              like pt_um        no-undo.
define variable open_only       like mfc_logical initial yes
                                label "Open PO's Only" no-undo.
define variable perform         like pod_per_date no-undo.
define variable perform1        like pod_per_date no-undo.
define variable buyer           like po_buyer     no-undo.
define variable buyer1          like po_buyer     no-undo.
define variable site            like pod_site     no-undo.
define variable site1           like pod_site     no-undo.
define variable sortby          like mfc_logical label "Sort by Buyer"
                                initial no        no-undo.
define variable base_cost       like pod_pur_cost no-undo.
define variable base_rpt        like po_curr      no-undo.
define variable mc-error-number like msg_nbr      no-undo.

{gprunpdf.i "mcpl" "p"}

form
   part           colon 20
   part1          label "To" colon 49 skip
   nbr            colon 20
   nbr1           label "To" colon 49 skip
   so_job         colon 20
   so_job1        label "To" colon 49 skip
   due            colon 20
   due1           label "To" colon 49 skip
   perform        colon 20
   perform1       label "To" colon 49 skip
   buyer          colon 20
   buyer1         label "To" colon 49 skip
   site           colon 20
   site1          label "To" colon 49 skip (1)
   open_only      colon 20
   incl_b2b_po    colon 49
   sortby         colon 20
   base_rpt       colon 20
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

oldcurr = "".
find first gl_ctrl
   where gl_domain = global_domain
no-lock no-error.

{wbrp01.i}

repeat:

   if part1    = hi_char  then part1 = "".
   if nbr1     = hi_char  then nbr1 = "".
   if so_job1  = hi_char  then so_job1 = "".
   if due      = low_date then due = ?.
   if due1     = hi_date  then due1 = ?.
   if perform  = low_date then perform = ?.
   if perform1 = hi_date  then perform1 = ?.
   if buyer1   = hi_char  then buyer1 = "".
   if site1    = hi_char  then site1  = "".

   if c-application-mode <> "WEB" then
      update
         part part1
         nbr nbr1
         so_job so_job1
         due due1
         perform perform1
         buyer buyer1
         site site1
         open_only
         incl_b2b_po
         sortby
         base_rpt
      with frame a.

   /* CURRENCY CODE VALIDATION */
   if base_rpt <> "" then do:
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input base_rpt,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3} /* INVALID CURRENCY */
         next-prompt base_rpt.
         next.
      end.
   end.

   {wbrp06.i &command = update
             &fields = "  part part1 nbr nbr1 so_job so_job1
                          due due1 perform perform1 buyer buyer1
                          site site1 open_only incl_b2b_po sortby base_rpt"
             &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i part      }
      {mfquoter.i part1     }
      {mfquoter.i nbr       }
      {mfquoter.i nbr1      }
      {mfquoter.i so_job    }
      {mfquoter.i so_job1   }
      {mfquoter.i due       }
      {mfquoter.i due1      }
      {mfquoter.i perform   }
      {mfquoter.i perform1  }
      {mfquoter.i buyer     }
      {mfquoter.i buyer1    }
      {mfquoter.i site      }
      {mfquoter.i site1     }
      {mfquoter.i open_only }
      {mfquoter.i sortby    }
      {mfquoter.i incl_b2b_po}
      {mfquoter.i base_rpt  }

      if part1    = "" then part1 = hi_char.
      if nbr1     = "" then nbr1 = hi_char.
      if so_job1  = "" then so_job1 = hi_char.
      if due      = ?  then due = low_date.
      if due1     = ?  then due1 = hi_date.
      if perform  = ?  then perform = low_date.
      if perform1 = ?  then perform1 = hi_date.
      if buyer1   = "" then buyer1 = hi_char.
      if site1    = "" then site1  = hi_char.

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

   form header
      skip(1)
   with frame a1 width 80.
   view frame a1.

   /* SORT BY ITEM */
   if sortby = no then do:
      /* SS - 101029.1  */
      {xxpoporp02.i
         &sort1 = "pod_part"
         &sort2 = "pod_rev"
         &sort3 = "pod_due_date"
         &sort4 = "pod_nbr"
         &file1 = "b"}
   end.
   /* SORT BY BUYER */
   if sortby = yes then do:
       /* SS - 101029.1  */
      {xxpoporp02.i
         &sort1 = "po_buyer"
         &sort2 = "pod_part"
         &sort3 = "pod_rev"
         &sort4 = "pod_due_date"
         &file1 = "c"}
   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
