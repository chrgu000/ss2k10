/* ictrrp01.p - TRANSACTION BY PART REPORT                                    */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 05/12/90   BY: PML                       */
/* REVISION: 7.0      LAST MODIFIED: 02/03/92   BY: pma *F131*                */
/* REVISION: 7.3      LAST MODIFIED: 08/11/92   BY: tjs *G028*                */
/* REVISION: 7.3      LAST MODIFIED: 07/21/93   BY: qzl *GD58*                */
/* REVISION: 7.3      LAST MODIFIED: 09/18/94   BY: qzl *FR49*                */
/* REVISION: 7.3      LAST MODIFIED: 08/08/96   BY: *G1ZZ* Julie Milligan     */
/* REVISION: 8.6      LAST MODIFIED: 10/04/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: GYK *K0Q4*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: *J2L2* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0K2* Phil DeRogatis     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14     BY: Jean Miller          DATE: 04/06/02  ECO: *P056*    */
/* Revision: 1.15  BY: Narathip W. DATE: 05/03/03 ECO: *P0R5* */
/* Revision: 1.17  BY: Paul Donnelly (SB)      DATE: 06/28/03  ECO: *Q00G*    */
/* $Revision: 1.17.1.1 $By: Amandeep Saini   DATE: 09/10/07 ECO: *P676* */
/* SS - 121224.1 By: Randy Li */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
/*V8:ConvertMode=FullGUIReport                                                */

/* SS - 121210.1 - B */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "121224.1 "}
/* SS - 121210.1 - E */

{cxcustom.i "ICTRRP01.P"}

define variable nbr like tr_nbr no-undo.
define variable nbr1 like tr_nbr no-undo.
define variable so_job like tr_so_job no-undo.
define variable so_job1 like tr_so_job no-undo.
define variable part like tr_part no-undo.
define variable part1 like tr_part no-undo.
define variable effdate like tr_effdate no-undo.
define variable effdate1 like tr_effdate no-undo.
{&ICTRRP01-P-TAG1}
define variable trdate like tr_date no-undo.
define variable trdate1 like tr_date no-undo.
{&ICTRRP01-P-TAG2}
define variable trnbr like tr_trnbr no-undo.
define variable trnbr1 like tr_trnbr no-undo.
define variable type like tr_type no-undo.
define variable desc1 like pt_desc1 no-undo.
define variable site like tr_site no-undo.
define variable site1 like tr_site no-undo.
define variable end_bal like in_qty_oh label "End Balance" no-undo.
define variable last_type like tr_ship_type no-undo.
{&ICTRRP01-P-TAG3}
define variable part-to-read like tr_part no-undo.

/* SS - 121224.1 - B */
define variable loc  like tr_loc no-undo.
define variable loc1 like tr_loc no-undo.
/* SS - 121224.1 - E */
{&ICTRRP01-P-TAG4}
form
   part           colon 20
   part1          label "To" colon 49 skip
   effdate        colon 20
   effdate1       label "To" colon 49 skip
   trdate         colon 20
   trdate1        label "To" colon 49 skip
   nbr            colon 20
   nbr1           label "To" colon 49 skip
   site           colon 20
   site1          label "To" colon 49 skip
/* SS - 121224.1 - B */
	 loc           colon 20
	 loc1          label "To" colon 49 skip
/* SS - 121224.1 - E */
   so_job         colon 20
   so_job1        label "To" colon 49 skip(1)
   type           colon 20 skip
with frame a side-labels width 80 attr-space.
{&ICTRRP01-P-TAG5}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if part1 = hi_char then part1 = "".
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
   if site1 = hi_char then site1 = "".
   if nbr1 = hi_char then nbr1 = "".
/* SS - 121224.1 - B */
   if loc1 = hi_char then loc1 = "".
/* SS - 121224.1 - E */
   {&ICTRRP01-P-TAG6}

   if c-application-mode <> 'web' then
   {&ICTRRP01-P-TAG7}
   update
      part part1
      effdate effdate1
      trdate trdate1 nbr nbr1
/* SS - 121224.1 - B */
/*   site site1 so_job so_job1 type */
     site site1 loc loc1 so_job so_job1 type
   with frame a.
/* SS - 121224.1 - E */
   {wbrp06.i &command = update &fields = "  part part1
        effdate effdate1
        trdate trdate1 nbr nbr1 site site1 so_job so_job1
        type" &frm = "a"}

   {&ICTRRP01-P-TAG8}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part         }
      {mfquoter.i part1        }
      {mfquoter.i effdate      }
      {mfquoter.i effdate1     }
      {mfquoter.i trdate       }
      {mfquoter.i trdate1      }
      {mfquoter.i nbr          }
      {mfquoter.i nbr1         }
      {mfquoter.i site         }
      {mfquoter.i site1        }
      {&ICTRRP01-P-TAG9}
      {mfquoter.i so_job       }
      {mfquoter.i so_job1      }
      {&ICTRRP01-P-TAG10}
      {mfquoter.i type         }
      {&ICTRRP01-P-TAG11}

      if part1 = "" then part1 = hi_char.
      if effdate = ? then effdate = low_date.
      if effdate1 = ? then effdate1 = hi_date.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
      if site1 = "" then site1 = hi_char.
/* SS - 121224.1 - B */
      if loc1 = "" then loc1 = hi_char.
/* SS - 121224.1 - E */
      if nbr1 = "" then nbr1 = hi_char.
      {&ICTRRP01-P-TAG12}

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

   /* POSITION THE TR_HIST FILE TO THE BEGINING */

   find first tr_hist  where tr_hist.tr_domain = global_domain and  tr_part >=
   part
                        and tr_part <= part1
   no-lock no-error.

   if available tr_hist then
   repeat:

      part-to-read = tr_part.

      find first tr_hist no-lock  where tr_hist.tr_domain = global_domain and
      tr_part = part-to-read
                                   and tr_effdate >= effdate
                                   and tr_effdate <= effdate1
      use-index tr_part_eff no-error.

      if available tr_hist then leave.
	  
      find first tr_hist no-lock  where tr_hist.tr_domain = global_domain and
      tr_part > part-to-read
                                   and tr_part <= part1
      use-index tr_part_eff no-error.

      if not available tr_hist then leave.

   end.

   outer-loop:
   repeat:

      if not available tr_hist then leave outer-loop.

      part-to-read = tr_part.
      {&ICTRRP01-P-TAG13}

      for each tr_hist  where tr_hist.tr_domain = global_domain and (  tr_part
      = part-to-read
         and (tr_site >= site and tr_site <= site1)
         and (tr_effdate >= effdate and tr_effdate <= effdate1)
         and (tr_date >= trdate and tr_date <= trdate1)
         and (tr_nbr >= nbr and tr_nbr <= nbr1)
         and (tr_so_job >= so_job)
         and (tr_so_job <= so_job1 or so_job1 = "")
         and (tr_type = type or type = "")
         and (tr_type <> "ORD-SO" or type = "ORD-SO")
         and (tr_type <> "ORD-PO" or type = "ORD-PO")	 
		 /* SS - 121224.1 - B */
		  and (tr_loc >= loc and tr_loc <= loc1)
		 /* SS - 121224.1 - E */
      ) use-index tr_part_eff no-lock
      break by tr_part by tr_site
            by tr_ship_type
            by tr_trnbr
      with frame b down width 132 no-attr-space:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
/* SS - 121224.1 - B */
   accum tr_qty_loc(total).
/* SS - 121224.1 - E */
         if first-of(tr_site) then do:

            if page-size - line-counter < 4 then page.

            desc1 = "".

            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = tr_part no-lock no-error.
            if available pt_mstr then
               desc1 = pt_desc1 + " " + pt_desc2.
            display.
		/* SS - 121224.1 - B */
		/*
            put
               {gplblfmt.i &FUNC=getTermLabel(""ITEM"",4) &CONCAT=':'}
               " " tr_part " "
               {gplblfmt.i &FUNC=getTermLabel(""SITE"",4) &CONCAT=':'}
               " " tr_site " "
               desc1 format "x(49)" " "
               {gplblfmt.i &FUNC=getTermLabel(""UNIT_OF_MEASURE"",2) &CONCAT=':'}
               " " tr_um.
		*/
		/* SS - 121224.1 - E */
            last_type = "".

         end.

         if page-size - line-counter < 2 then page.

         if tr_ship_type <> "" and last_type = "" then do:

            if page-size - line-counter < 4 then page.
            down 1.

            put
               caps(getTermLabel("NON-INVENTORY_TRANSACTIONS",40))
               format "x(40)" at 40 skip.

            last_type = tr_ship_type.

         end.
		 
		/* SS - 121224.1 - B */
		 /*
         end_bal = tr_begin + tr_qty_loc.
		 */
		 end_bal = tr_loc_begin + tr_qty_loc.
	/*
         display
            tr_date
            tr_effdate @ tr_so_job  column-label "Eff Date!Sales/Job"
            tr_trnbr   @ tr_rmks    column-label "Trans!Remarks"
            tr_type                 column-label "Type!Ship Date"
            tr_nbr     @ tr_ship_id column-label "Order!Shipper Number"
            tr_addr                 column-label "Address!Inv Mov"
            (if tr_type = "CST-ADJ"
            then tr_loc_begin
               else tr_qty_req)     format "->>,>>>,>>9.9<<<<<<<<<"
            tr_qty_loc
            tr_loc
            tr_ship_type
            end_bal when (tr_ship_type = "").

         if (tr_so_job <> "" and tr_so_job <> tr_nbr) or
             tr_rmks         <> "" or
             tr_ship_date    <> ?  or
             tr_ship_id      <> "" or
             tr_ship_inv_mov <> ""
         then do:
            down 1.
            display
               tr_so_job
               tr_rmks
               tr_ship_date    @ tr_type
               tr_ship_id
               tr_ship_inv_mov @ tr_addr.
         end.
	*/
      find wo_mstr where 
	  wo_domain = global_domain and 
	  wo_lot = tr_lot no-lock no-error.

         display
		   tr_part tr_sit tr_loc tr_um desc1
            tr_date
            tr_effdate
            tr_trnbr
            tr_type
            tr_nbr
            wo_part                 when (avail wo_mstr)
            tr_addr
            tr_qty_req              format "->>,>>>,>>9.9<<<<<<<<<"
            tr_qty_loc
            tr_loc
            tr_ship_type
            end_bal when (tr_ship_type = "") with width 320.

         if (tr_so_job <> "" and tr_so_job <> tr_nbr) or
             tr_rmks         <> "" or
             tr_ship_date    <> ?  or
             tr_ship_id      <> "" or
             tr_ship_inv_mov <> ""
         then do:

            display
               tr_so_job
               tr_rmks
               tr_ship_date
               tr_ship_id
               tr_ship_inv_mov with width 320.

         end.

		if last(tr_part) then do:
			underline tr_qty_loc format "->>>,>>>,>>9.9".
			display "      ºÏ¼Æ£º" @ tr_qty_req accum total tr_qty_loc format "->>>,>>>,>>9.9" @ tr_qty_loc.
		end.
	
	/* SS - 121224.1 - E */
      end. /* for each tr_hist */

      /*BEGIN ADDED SECTION TO POSTION TR_HIST */
      find first tr_hist no-lock  where tr_hist.tr_domain = global_domain and
      tr_part > part-to-read
         and tr_part <= part1 no-error.

      if available tr_hist then
      repeat:

         part-to-read = tr_part.

         find first tr_hist no-lock  where tr_hist.tr_domain = global_domain
         and  tr_part = part-to-read
                                      and tr_effdate >= effdate
                                      and tr_effdate <= effdate1
         use-index tr_part_eff no-error.
         if available tr_hist then leave.

         find first tr_hist no-lock  where tr_hist.tr_domain = global_domain
         and  tr_part > part-to-read
                                      and tr_part <= part1
         use-index tr_part_eff no-error.
         if not available tr_hist then leave.

      end.

      {&ICTRRP01-P-TAG14}
      {mfrpchk.i}

   end. /* repeat outer-loop */

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
