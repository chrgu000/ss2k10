/* ictrrp02.p - TRANSACTION BY ORDER REPORT                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 6.0      LAST MODIFIED: 05/12/90   BY: PML                       */
/* REVISION: 7.0      LAST MODIFIED: 06/06/92   BY: pma *F584*                */
/* REVISION: 7.3      LAST MODIFIED: 08/18/92   BY: tjs *G028*                */
/* REVISION: 7.3      LAST MODIFIED: 05/23/94   BY: pxd *FO38*                */
/* REVISION: 7.3      LAST MODIFIED: 09/18/94   BY: qzl *FR49*                */
/* REVISION: 7.3      LAST MODIFIED: 12/05/95   BY: jym *G1FN*                */
/* REVISION: 8.6      LAST MODIFIED: 10/08/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0CW* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: gyk *K0PG*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/18/00   BY: *N0GB* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14     BY: Jean Miller          DATE: 04/06/02  ECO: *P056*  */
/* $Revision: 1.15 $    BY: Narathip W.          DATE: 05/03/03  ECO: *P0R5*  */
/* $Revision: 1.15 $    BY: Joy Huang            DATE: 10/06/04  ECO: *WOID*  */
/* $Revision: 1.15 $    BY: Martin tan           DATE: 08/23/06  ECO: *RMK8*  */
/* $Revision: 1.15 $    BY: Martin tan           DATE: 01/25/08  ECO: *L8S1A*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}
{cxcustom.i "ICTRRP02.P"}

define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable part like tr_part.
define variable part1 like tr_part.
define variable trnbr like tr_trnbr.
define variable trnbr1 like tr_trnbr.
define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable type like glt_tr_type format "x(8)".

{&ICTRRP02-P-TAG1}
define variable desc1 like pt_desc1 format "x(49)" no-undo.
{&ICTRRP02-P-TAG2}
define variable old_order like tr_nbr.
define variable first_pass like mfc_logical.
define variable site like in_site.
{&ICTRRP02-P-TAG3}
define variable site1 like in_site.
/*WOID*/ define variable loc  like tr_loc no-undo.
/*WOID*/ define variable loc1 like tr_loc no-undo.

{&ICTRRP02-P-TAG4}
form
   nbr            colon 20
   nbr1           label "To" colon 49 skip
   trdate         colon 20
   trdate1        label "To" colon 49 skip
   part           colon 20
   part1          label "To" colon 49 skip
   site           colon 20
   site1          label "To" colon 49 skip
/*WOID*/   loc           colon 20
/*WOID*/   loc1          label "To" colon 49 skip
   so_job         colon 20
   so_job1        label "To" colon 49 skip (1)
   type           colon 20 skip
with overlay frame a side-labels.
{&ICTRRP02-P-TAG5}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if nbr1 = hi_char then nbr1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
/*WOID*/   if loc1 = hi_char then loc1 = "".
   {&ICTRRP02-P-TAG6}

   if c-application-mode <> 'web' then
   {&ICTRRP02-P-TAG7}
   update nbr nbr1 trdate trdate1 part part1 site site1 loc loc1 so_job so_job1 type
   with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 trdate trdate1 part
        part1 site site1 loc loc1 so_job so_job1 type" &frm = "a"}

   {&ICTRRP02-P-TAG8}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i nbr         }
      {mfquoter.i nbr1        }
      {mfquoter.i trdate      }
      {mfquoter.i trdate1     }
      {&ICTRRP02-P-TAG9}
      {mfquoter.i part        }
      {mfquoter.i part1       }
      {mfquoter.i site        }
      {mfquoter.i site1       }
      {mfquoter.i loc          }
      {mfquoter.i loc1         }
      {&ICTRRP02-P-TAG10}
      {mfquoter.i so_job      }
      {mfquoter.i so_job1     }
      {&ICTRRP02-P-TAG11}
      {mfquoter.i type        }

      {&ICTRRP02-P-TAG12}
      if nbr1 = "" then nbr1 = hi_char.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
/*WOID*/       if loc1 = "" then loc1 = hi_char.
      {&ICTRRP02-P-TAG13}

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

   {&ICTRRP02-P-TAG14}
   for each tr_hist where (tr_nbr >= nbr and tr_nbr <= nbr1)
      and (tr_effdate >= trdate and tr_effdate <= trdate1)
      and (tr_part >= part) and (tr_part <= part1 or part1 = "")
      and (tr_so_job >= so_job) and (tr_so_job <= so_job1 or so_job1 = "")
      and (tr_site >= site) and (tr_site   <= site1   or site1 = "")
      and (tr_type = type or type = "")
      and (tr_type <> "ORD-SO" or type = "ORD-SO")
      and (tr_type <> "ORD-PO" or type = "ORD-PO")
/*WOID*/ and (tr_loc >= loc and tr_loc <= loc1)
   use-index tr_nbr_eff
   no-lock break by tr_nbr by tr_effdate by tr_part
/*RMK8*/   with frame b down width 180:
/*RMK8***  with frame b down width 150:  ***/

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

/*WOID*/     accum tr_qty_loc(total by tr_nbr).

      if first-of(tr_nbr) then do:
         if page-size - line-counter < 4 then page.
/*L8S1A**         if not first(tr_nbr) then put skip(1).**/
         display with frame b.
         put
            {gplblfmt.i &FUNC=getTermLabel(""ORDER"",8) &CONCAT="': '"}
            tr_nbr.

/*WOID*/ put
/*WOID*/    {gplblfmt.i &FUNC=getTermLabel(""ID"",8) &CONCAT="': '"}
/*WOID*/    tr_lot.
      end.

      desc1 = "".
      find pt_mstr where pt_part = tr_part no-lock no-error.
      if available pt_mstr then
         desc1 = pt_desc1 + " " + pt_desc2.

      if page-size - line-counter < 2 then page.

/*RMK8*/ find first code_mstr where code_value = tr_rmks and tr_rmks <> "" no-lock no-error.

      display
         tr_part
         tr_site
         tr_trnbr
         tr_date
         tr_effdate
         tr_type
         tr_so_job
         tr_ship_type
         tr_addr
/*RMK8** tr_rmks **/          
         tr_um
         tr_qty_req  format "->>,>>>,>>9.9<<<<<<<<<"
         tr_qty_loc  @ tr_qty_chg
/*WOID*/ tr_loc
/*RMK8*/ tr_rmks
/*RMK8*/ code_cmmt when (available code_mstr)	
	 desc1  at 6
/*L8S1A*/ tr_serial	 
         tr_ship_id
         tr_ship_date
         tr_ship_inv_mov
         with frame b.

/*WOID*/     if last-of(tr_nbr) then do:
/*WOID*/        underline tr_qty_chg format "->>>,>>>,>>9.9".
/*WOID*/        display "      ºÏ¼Æ£º" @ tr_qty_req accum total by tr_nbr tr_qty_loc format "->>>,>>>,>>9.9" @ tr_qty_chg
			with frame b.
/*WOID*/     end.

      {mfrpchk.i}

   end.

   {&ICTRRP02-P-TAG15}
   /* REPORT TRAILER */

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
