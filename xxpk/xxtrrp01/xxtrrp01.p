/* xxtrrp01.p - TRANSACTION BY ORDER REPORT                                   */
/* xxrepkup0.p - REPETITIVE PICKLIST CALCULATION                             */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 08/19/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110819.1"}
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
   {&ICTRRP02-P-TAG6}

   if c-application-mode <> 'web' then
   {&ICTRRP02-P-TAG7}
   update nbr nbr1 trdate trdate1 part part1 site site1 so_job so_job1 type
   with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 trdate trdate1 part
        part1 site site1 so_job so_job1 type" &frm = "a"}

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
      {&ICTRRP02-P-TAG10}
      {mfquoter.i so_job      }
      {mfquoter.i so_job1     }
      {&ICTRRP02-P-TAG11}
      {mfquoter.i type        }

      {&ICTRRP02-P-TAG12}
      nbr1 = nbr1 + hi_char.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
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
   use-index tr_nbr_eff
   no-lock break by tr_nbr by tr_effdate by tr_part
   with frame b down width 132:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if first-of(tr_nbr) then do:
         if page-size - line-counter < 4 then page.
         if not first(tr_nbr) then put skip(1).
         display.
         put
            {gplblfmt.i &FUNC=getTermLabel(""ORDER"",8) &CONCAT="': '"}
            tr_nbr.
      end.

      desc1 = "".
      find pt_mstr where pt_part = tr_part no-lock no-error.
      if available pt_mstr then
         desc1 = pt_desc1 + " " + pt_desc2.

      if page-size - line-counter < 2 then page.

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
         tr_rmks
         tr_um
         tr_qty_req  format "->>,>>>,>>9.9<<<<<<<<<"
         tr_qty_loc  @ tr_qty_chg
         tr_loc at 6
         desc1
         tr_ship_id
         tr_ship_date
         tr_ship_inv_mov.

      {mfrpchk.i}

   end.

   {&ICTRRP02-P-TAG15}
   /* REPORT TRAILER */

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
