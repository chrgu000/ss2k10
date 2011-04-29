/* woworp04.p - WORK ORDER DISPATCH LIST                                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                       */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*                 */
/* REVISION: 4.0     LAST MODIFIED: 01/05/88    BY: emb *A124*                */
/* REVISION: 4.0     LAST MODIFIED: 02/07/88    BY: rl  *A171*                */
/* REVISION: 4.0     LAST MODIFIED: 02/10/88    BY: wug *A175*                */
/* REVISION: 4.0     LAST MODIFIED: 03/21/88    BY: wug *A194*                */
/* REVISION: 4.0     LAST MODIFIED: 12/09/88    BY: pml *A557*                */
/* REVISION: 4.0     LAST MODIFIED: 02/18/89    BY: pml *B004*                */
/* REVISION: 4.0     LAST MODIFIED: 06/28/89    BY: emb *A754*                */
/* REVISION: 6.0     LAST MODIFIED: 10/29/90    BY: wug *D151*                */
/* REVISION: 6.0     LAST MODIFIED: 01/22/91    BY: bjb *D248*                */
/* REVISION: 7.0     LAST MODIFIED: 10/11/91    BY: emb *F024*                */
/* REVISION: 7.3     LAST MODIFIED: 11/19/92    BY: jcd *G348*                */
/* REVISION: 7.3     LAST MODIFIED: 04/14/93    BY: ram *G952*                */
/* REVISION: 7.3     LAST MODIFIED: 07/28/94    BY: qzl *FP65*                */
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67*                */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0Y1*                */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane           */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan          */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown          */
/* REVISION: 9.1     LAST MODIFIED: 08/17/00   BY: *N0LW* Arul Victoria       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10      BY: Jyoti Thatte      DATE: 04/03/01 ECO: *P008*       */
/* Revision: 1.11  BY: Manjusha Inglay DATE: 08/28/01 ECO: *P01R* */
/* $Revision: 1.13 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/*By: Neil Gao 09/02/06 ECO: *SS 20090206* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp04_p_1 "Page Break on Work Center"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp04_p_2 "Operation"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp04_p_4 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp04_p_5 "Window Days"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable site  like si_site.
define variable site1 like si_site.
define variable wkctr like wr_wkctr.
define variable wkctr1 like wr_wkctr.
define variable open_ref like wo_qty_ord label {&woworp04_p_4}.
define variable setup like wr_setup.
define variable runtime like wr_run.
define variable op_status like wr_status format "x(8)".
define variable skpage like mfc_logical initial yes label {&woworp04_p_1}.

define variable wndw as integer label {&woworp04_p_5} initial 3.
define variable cutoff as date.
define variable i as integer.
define variable nonwdays as integer.
define variable overlap as integer.
define variable workdays as integer.
define variable interval as integer.
define variable know_date as date.
define variable find_date as date.

define variable frwrd as integer.
define variable last_wkctr like wr_wkctr.
define variable last_mch like wr_mch.
define variable op as character format "x(24)" label {&woworp04_p_2}.

/*SS 20090206 - B*/
define variable nbr   like wo_nbr.
define variable nbr1  like wo_nbr.
/*SS 20090206 - E*/

form
/*SS 20090206 - B*/
	 nbr            colon 30
   nbr1           label {t001.i} colon 55
/*SS 20090206 - E*/
   site           colon 30
   site1          label {t001.i} colon 49
   wkctr          colon 30
   wkctr1         label {t001.i} colon 49 skip (1)
   wndw         colon 30
   skpage         colon 30 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   wr_wkctr
   wr_mch
   wc_desc        no-label
with frame b side-labels page-top WIDTH 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

assign
   site = global_site
   site1 = global_site.

{wbrp01.i}
repeat:

   if wkctr1 = hi_char then wkctr1 = "".
   if site1 = hi_char then site1 = "".
/*SS 20090206 - B*/
		if nbr1 = hi_char then nbr1 = "".
/*SS 20090206 - E*/

   if c-application-mode <> "WEB" then
   update
/*SS 20090206 - B*/
			nbr nbr1
/*SS 20090206 - E*/
      site site1
      wkctr wkctr1
      wndw
      skpage
   with frame a.

/*SS 20090206 - B*/
		if nbr1 = "" then nbr1 = hi_char.
/*SS 20090206 - E*/

   {wbrp06.i &command = update &fields = "  site site1   wkctr wkctr1 wndw
        skpage" &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i wkctr  }
      {mfquoter.i wkctr1 }
      {mfquoter.i wndw }
      {mfquoter.i skpage }

      if wkctr1 = "" then wkctr1 = hi_char.
      if site1  = "" then site1  = hi_char.

   end.

   /* SELECT PRINTER  */
   {gpselout.i
       &printType = "printer"
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

   last_wkctr = ?.

   for each si_mstr  where si_mstr.si_domain = global_domain and
            si_site >= site and si_site <= site1
   no-lock with width 132 no-attr-space:

      {mfrpchk.i}

      cutoff = ?.
      know_date = today.

      {mfdate.i know_date cutoff wndw si_site}

      /* FIND AND DISPLAY */
      for each wr_route  where wr_route.wr_domain = global_domain and (
              (wr_wkctr >= wkctr)
/*SS 20090206 - B*/
					and ( wr_nbr >= nbr and wr_nbr <= nbr1 )
/*SS 20090206 - E*/
          and (wr_wkctr <= wkctr1)
          and (index ("QHSR",wr_status) > 0
           or  (wr_start <= cutoff and wr_status <> "C"))
      ) no-lock by wr_wkctr by wr_mch by wr_start by wr_due by wr_nbr
              by wr_lot by wr_op
      with frame c width 132 no-attr-space:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).

         {mfrpchk.i}

         find wc_mstr  where wc_mstr.wc_domain = global_domain and
              wc_wkctr = wr_wkctr
          and wc_mch = wr_mch
         no-lock no-error.

         if not available wc_mstr then next.

         find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
         wr_lot no-lock no-error.

         if available wo_mstr then do:

            if wo_status <> "R" then
               next.
            if wo_site <> si_site then
               next.

            if wr_wkctr <> last_wkctr or wr_mch <> last_mch
            then do:

               hide frame b.

               if last_wkctr <> ? and skpage then
                  page.

               display
                  wr_wkctr
                  wr_mch
                  wc_desc
                  si_site
               with frame b.

               last_wkctr = wr_wkctr.
               last_mch = wr_mch.

            end.
            else do:

               view frame b.

            end.

            open_ref = max(wr_qty_ord - (wr_qty_comp + wr_sub_com)
                       - wr_qty_rjct,0).

            setup = 0.

            if wr_status <> "C"
               and open_ref <> 0
               and wr_act_run = 0
            then
               setup = wr_setup.

            runtime = open_ref * wr_run.

            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part no-lock no-error.
            if available pt_mstr  and
               pt_desc2 <> "" and
               page-size - line-counter < 3
            then
               page.

            else
            if page-size - line-counter < 2 then
               page.

            display
               wo_part format "x(27)"
               wr_nbr string(wr_op) @ op
               wr_start
               wr_due
               setup
               runtime
               open_ref
               wr_status.

            down 1.

            display
               "   " + pt_desc1  @ wo_part
               "  " + getTermLabel("ID",6) + ": " + wr_lot @ wr_nbr
               wr_desc @ op.

            if available pt_mstr and pt_desc2 <> "" then do:
               down 1.
               display
                  "   " + pt_desc2  @ wo_part.
            end.

         end.

      end.

   end.

   hide frame b.
    {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


end.

{wbrp04.i &frame-spec = a}
