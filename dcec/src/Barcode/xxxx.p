{mfdtitle.i "2+ "}

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

define variable desc1 like pt_desc1 format "x(49)" no-undo.
define variable old_order like tr_nbr.
define variable first_pass like mfc_logical.
define variable site like in_site.
define variable site1 like in_site.

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

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if nbr1 = hi_char then nbr1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.

   if c-application-mode <> 'web' then
   update nbr nbr1 trdate trdate1 part part1 site site1 so_job so_job1 type
   with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 trdate trdate1 part
        part1 site site1 so_job so_job1 type" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i nbr         }
      {mfquoter.i nbr1        }
      {mfquoter.i trdate      }
      {mfquoter.i trdate1     }
      {mfquoter.i part        }
      {mfquoter.i part1       }
      {mfquoter.i site        }
      {mfquoter.i site1       }
      {mfquoter.i so_job      }
      {mfquoter.i so_job1     }
      {mfquoter.i type        }

      if nbr1 = "" then nbr1 = hi_char.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.

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
   with frame b down width 180:

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
         tr_loc
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
         desc1       at 6
         tr_ship_id
         tr_ship_date
         tr_ship_inv_mov.

      /*{mfrpchk.i}*/

   end.

   /* REPORT TRAILER */

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
