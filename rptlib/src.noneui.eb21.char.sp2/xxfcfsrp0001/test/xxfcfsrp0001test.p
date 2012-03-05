/* fcfsrp.p - FORECAST REPORT                                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.19 $                                                      */
/*F0PN*/ /*K0X1*/
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 4.0      LAST MODIFIED: 01/27/88   BY: *A162* EMB                */
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: *A175* WUG                */
/* REVISION: 5.0      LAST MODIFIED: 11/13/89   BY: *B386* emb                */
/* REVISION: 5.0      LAST MODIFIED: 01/23/90   BY: *B523* MLB                */
/* REVISION: 5.0      LAST MODIFIED: 12/31/90   BY: *B859* emb                */
/* REVISION: 6.0      LAST MODIFIED: 07/30/90   BY: *D036* emb                */
/* REVISION: 6.0      LAST MODIFIED: 10/08/90   BY: *D080* emb                */
/* REVISION: 7.0      LAST MODIFIED: 10/10/91   BY: *F024* emb                */
/* REVISION: 7.0      LAST MODIFIED: 09/01/94   BY: *FQ67* ljm                */
/* REVISION: 7.2      LAST MODIFIED: 10/18/94   BY: *FS87* jzs                */
/* REVISION: 7.2      LAST MODIFIED: 12/19/94   BY: *F0D1* emb                */
/* REVISION: 7.3      LAST MODIFIED: 06/03/96   BY: *G1X3* rvw                */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: *K0X1* ays                */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/14/00   BY: *N0G1* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder      */
/* Revision: 1.6.1.5     BY: Mark Christian   DATE: 07/26/01  ECO: *M1G3*   */
/* Revision: 1.6.1.11    BY: Nikita Joshi     DATE: 03/13/02  ECO: *N1CX*   */
/* Revision: 1.6.1.12    BY: Rajaneesh S.     DATE: 07/24/02  ECO: *N1PK*   */
/* Revision: 1.6.1.13    BY: Hareesh V.       DATE: 09/18/02  ECO: *N1V7*   */
/* Revision: 1.6.1.17  BY: Rajiv Ramaiah DATE: 11/22/02 ECO: *N202* */
/* $Revision: 1.6.1.19 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100811.1 By: Bill Jiang */

/* SS - 100811.1 - RNB
[100811.1]

[100811.1]

SS - 100811.1 - RNE */

/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "100811.1"}

/* SS - 100811.1 - B */
{xxfcfsrp0001.i "new"}
/* SS - 100811.1 - E */

define new shared variable fcs_recid as   recid.
define new shared variable nett      like fcs_fcst_qty extent 156.
define new shared variable frwrd     like soc_fcst_fwd.
define new shared variable bck       like soc_fcst_bck.
define new shared variable prod_fcst as   decimal extent 52 no-undo.

define variable fcsduedate as   date no-undo.
define variable week       as   integer no-undo.
define variable part       like fcs_part no-undo.
define variable part1      like fcs_part no-undo.
define variable site       like fcs_site no-undo.
define variable site1      like fcs_site no-undo.
define variable fcsyear    like fcs_year no-undo.
define variable fcsyear1   like fcs_year no-undo.
define variable fcsweek    as   integer label "Week" format ">>" no-undo.
define variable fcsweek1   like fcsweek no-undo.
define variable net        like fcs_fcst_qty
                                column-label "Net Forecast" no-undo.
define variable i          as   integer no-undo.
define variable start      as   date extent 52 column-label
                                "Start" no-undo.
define variable weeks      as   integer extent 52 no-undo.
define variable totals     like fcs_fcst_qty extent 5 no-undo.
define variable prod_line  like pl_prod_line no-undo.
define variable det_sum    like mfc_logical format "Detail/Summary"
                                label "Summary/Detail" no-undo.
define variable fcsdate    as   date label "Date" no-undo.
define variable fcsdate1   as   date no-undo.
define variable mdate      as   date no-undo.
define variable fcst_only  like mfc_logical label "Forecasted Only"
                                initial yes no-undo.
define variable are_any    as   logical no-undo.
define variable l_print    like mfc_logical no-undo.
define variable l_printed  like mfc_logical no-undo.
define variable l_fcsdate  like fcsdate     no-undo.

form
   part           colon 20
   part1          label {t001.i} colon 45
   site           colon 20
   site1          label {t001.i} colon 45
   prod_line      colon 20
   fcsdate        colon 20
   fcsdate1       label {t001.i} colon 45
   /* SS - 100811.1 - B
   det_sum        colon 20
   fcst_only      colon 20
   SS - 100811.1 - E */
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*DEFAULT START AND END DATE FOR THIS YEARS fcs_sum*/
{fcsdate1.i year(today) fcsdate}

assign
   l_fcsdate = fcsdate
   fcsdate1  = fcsdate + (52 * 7) - 1.

for first soc_ctrl
   fields( soc_domain soc_fcst_bck soc_fcst_fwd)
    where soc_ctrl.soc_domain = global_domain no-lock:
end. /* FOR FIRST soc_ctrl */

if available soc_ctrl
then
   assign
      fcsduedate = fcsduedate - 7 * soc_fcst_bck
      frwrd      = soc_fcst_fwd
      bck        = soc_fcst_bck.

assign
   part  = global_part
   part1 = global_part
   site  = global_site
   site1 = global_site.

{wbrp01.i}

repeat:

   if part1 = hi_char
   then
      part1 = "".

   if site1 = hi_char
   then
      site1 = "".

   display part
           part1
           site
           site1
           prod_line
           fcsdate
           fcsdate1
   /* SS - 100811.1 - B
           det_sum
           fcst_only
   SS - 100811.1 - E */
   with frame a.

   if c-application-mode <> 'web'
   then
      set part
          part1
          site
          site1
          prod_line
          fcsdate
          fcsdate1
      /* SS - 100811.1 - B
          det_sum
          fcst_only
      SS - 100811.1 - E */
      with frame a.

   {wbrp06.i &command = set &fields = "  part part1  site site1 prod_line
         fcsdate fcsdate1 
      /* SS - 100811.1 - B
      det_sum  fcst_only
      SS - 100811.1 - E */
      " &frm = "a"}

   if  (c-application-mode <> 'web')
   or  (c-application-mode = 'web'
   and (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i site  }
      {mfquoter.i site1 }
      {mfquoter.i prod_line}
      {mfquoter.i fcsdate}
      {mfquoter.i fcsdate1}
      {mfquoter.i det_sum}
      {mfquoter.i fcst_only}

      if part1 = ""
      then
         part1 = hi_char.

      if site1 = ""
      then
         site1 = hi_char.

      /* DEFAULT START DATE FOR THIS YEAR */
      if fcsdate = ?
      then
         fcsdate = l_fcsdate.

      /* DEFAULT END DATE FOR THIS YEAR */
      if fcsdate1 = ?
      then
         fcsdate1 = l_fcsdate + (52 * 7) - 1.

   end. /* IF (C-APPLICATION-MODE <> 'WEB' */

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

   /* SS - 100811.1 - B
   {mfphead.i}

   /* CALCULATE END AND START WEEK AND YEAR */
   {fcsdate.i fcsdate1 mdate fcsweek1 global_site}
   {fcsdate.i fcsdate mdate fcsweek global_site}

   assign
      fcsyear  = year(fcsdate)
      fcsyear1 = year(fcsdate1).

   /* FOR BORDER CONIDITION e.g. 12/31/01 IS 1st WEEK OF 2002 */
   /* WEEK RETURNED WILL BE 53 IN SUCH CASE, SO SET IT RIGHT  */
   if fcsdate1 >= fcsdate
   then do:
      if fcsweek = 53
         and fcsweek = fcsweek1
         and fcsyear = fcsyear1
      then
         assign
            fcsweek  = 1
            fcsweek1 = fcsweek
            fcsyear  = fcsyear + 1
            fcsyear1 = fcsyear.
      else
         if fcsweek1 = 53
            and fcsyear = fcsyear1
         then
            assign
               fcsweek1 = 1
               fcsyear1 = fcsyear + 1.
      else
         if fcsweek = 53
            and fcsyear = fcsyear1
            and fcsweek1 >= fcsweek
         then
            assign
               fcsweek = 1
               fcsyear = fcsyear1.
      else
         if fcsweek = 53
            and fcsyear1 > fcsyear
         then
            assign
               fcsweek = 1
               fcsyear = fcsyear + 1.

   end. /* If fcsdate1 >= fcsdate */

   form
      fcs_part
      pt_desc1
      fcs_site
      fcsweek
      start[1]
      fcs_fcst_qty[1]   format "->>>>>>,>>9"
      fcs_sold_qty[1]   format "->>>>>>,>>9"
      fcs_abnormal[1]   format "->>>>>>,>>9"
      fcs_pr_fcst[1]    format "->>>>>>,>>9"
      net[1]            format "->>>>>>,>>9"
   with frame b down width 132 no-attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

   form
      fcs_part
      pt_desc1        format "x(23)"
      fcs_site
      start[1]
      start[2]        column-label "  End"
      fcs_fcst_qty[1] format "->>>>>>,>>9"
      fcs_sold_qty[1] format "->>>>>>,>>9"
      fcs_abnormal[1] format "->>>>>>,>>9"
      fcs_pr_fcst[1]  format "->>>>>>,>>9"
      net[1]          format "->>>>>>,>>9"
   with frame c down width 132 no-attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).

   for each pt_mstr no-lock
       where pt_mstr.pt_domain = global_domain and (  (pt_part >= part and
       pt_part <= part1)
      and   (pt_prod_line = prod_line or prod_line = "") ),
         each fcs_sum no-lock
         where fcs_sum.fcs_domain = global_domain and (  fcs_part = pt_part
        and  (fcs_site >= site and fcs_site <= site1)
        and ((fcs_year >= fcsyear or fcsyear = ?)
        and  (fcs_year <= fcsyear1 or fcsyear1 = ?))
        and  (fcst_only = no
        or    fcs_fcst_qty[1]  <> 0 or fcs_fcst_qty[2]  <> 0
        or    fcs_fcst_qty[3]  <> 0 or fcs_fcst_qty[4]  <> 0
        or    fcs_fcst_qty[5]  <> 0 or fcs_fcst_qty[6]  <> 0
        or    fcs_fcst_qty[7]  <> 0 or fcs_fcst_qty[8]  <> 0
        or    fcs_fcst_qty[9]  <> 0 or fcs_fcst_qty[10] <> 0
        or    fcs_fcst_qty[11] <> 0 or fcs_fcst_qty[12] <> 0
        or    fcs_fcst_qty[13] <> 0 or fcs_fcst_qty[14] <> 0
        or    fcs_fcst_qty[15] <> 0 or fcs_fcst_qty[16] <> 0
        or    fcs_fcst_qty[17] <> 0 or fcs_fcst_qty[18] <> 0
        or    fcs_fcst_qty[19] <> 0 or fcs_fcst_qty[20] <> 0
        or    fcs_fcst_qty[21] <> 0 or fcs_fcst_qty[22] <> 0
        or    fcs_fcst_qty[23] <> 0 or fcs_fcst_qty[24] <> 0
        or    fcs_fcst_qty[25] <> 0 or fcs_fcst_qty[26] <> 0
        or    fcs_fcst_qty[27] <> 0 or fcs_fcst_qty[28] <> 0
        or    fcs_fcst_qty[29] <> 0 or fcs_fcst_qty[30] <> 0
        or    fcs_fcst_qty[31] <> 0 or fcs_fcst_qty[32] <> 0
        or    fcs_fcst_qty[33] <> 0 or fcs_fcst_qty[34] <> 0
        or    fcs_fcst_qty[35] <> 0 or fcs_fcst_qty[36] <> 0
        or    fcs_fcst_qty[37] <> 0 or fcs_fcst_qty[38] <> 0
        or    fcs_fcst_qty[39] <> 0 or fcs_fcst_qty[40] <> 0
        or    fcs_fcst_qty[41] <> 0 or fcs_fcst_qty[42] <> 0
        or    fcs_fcst_qty[43] <> 0 or fcs_fcst_qty[44] <> 0
        or    fcs_fcst_qty[45] <> 0 or fcs_fcst_qty[46] <> 0
        or    fcs_fcst_qty[47] <> 0 or fcs_fcst_qty[48] <> 0
        or    fcs_fcst_qty[49] <> 0 or fcs_fcst_qty[50] <> 0
        or    fcs_fcst_qty[51] <> 0 or fcs_fcst_qty[52] <> 0)
        ) break by pt_part
              by fcs_part
              by fcs_site
              by fcs_year:

      {fcsdate1.i fcs_year start[1]}

      weeks[1] = 1.

      do i = 2 to 52:
         assign
            weeks[i] = i
            start[i] = start[i - 1] + 7.
      end. /* DO i = 2 TO 52 */

      if first-of (pt_part)
      then do:

         if  det_sum = no
         and page-size - line-counter < 2
         then
            page.

         if det_sum
         then
            display fcs_part pt_desc1 with frame b.
         else
            display fcs_part pt_desc1 with frame c.

         l_printed = no.

      end. /* IF FIRST-OF (pt_part) */

      if first-of (fcs_site)
      then do:

         assign
            totals = 0
            net    = 0.

         {fcsdate.i today fcsduedate week fcs_site}

         fcsduedate = fcsduedate - 7 * bck.

      end. /* IF FIRST-OF (fcs_site) */

      if det_sum
      then
         display fcs_site with frame b.
      else
         display fcs_site with frame c.

      {gprun.i ""gppfcre.p""
         "(fcs_part,fcs_site,fcs_year,output are_any)"}

      fcs_recid = recid(fcs_sum).

      {gprun.i ""fcfsre.p""}

      repeat i = if fcs_year = fcsyear
                 then
                    fcsweek
                 else
                    1
             to  if fcs_year = fcsyear1
                 then
                    min(fcsweek1,52)
                 else
                    52:

         if start[i] >= fcsduedate
         then
            net[i] = nett[i + 52].

         if det_sum
         then do:

            if ((i = fcsweek + 1 and fcs_year = fcsyear)
               or ((i = 2
               or (i = 1 and l_print))
               and fcs_year > fcsyear))
               and (first-of (pt_part) or l_print)
               and not l_printed
               and  available pt_mstr
            then do:
               display pt_desc2 @ pt_desc1 with frame b.
               l_printed = yes.
            end. /* IF ((i = fcsweek ... */

            display
               weeks[i]         @ fcsweek
               start[i]         @ start[1]
               fcs_fcst_qty[i]  @ fcs_fcst_qty[1]
               fcs_sold_qty[i]  @ fcs_sold_qty[1]
               fcs_abnormal[i]  @ fcs_abnormal[1]
               prod_fcst[i]     @ fcs_pr_fcst[1]
               net[i]           @ net[1]
            with frame b.

            down 1 with frame b.

            if page-size - line-counter < 0
            then
               page.

            /* FOR BORDER CASE e.g. 12/24/01 IS LAST WEEK IN 2001 AND */
            /* I/P RANGE IS FROM 12/24/01 TO <ANY DATE IN NEXT YEAR>  */
            if weeks[i] = 52
               and first-of(pt_part)
            then
               l_print = yes.
            else
               l_print = no.

         end. /* IF det_sum */

         assign
            totals[1] = totals[1] + fcs_fcst_qty[i]
            totals[2] = totals[2] + fcs_sold_qty[i]
            totals[3] = totals[3] + fcs_abnormal[i]
            totals[4] = totals[4] + prod_fcst[i]
            totals[5] = totals[5] + net[i].

      end. /* REPEAT */

      if det_sum
      then do:

         if  fcsweek = fcsweek1
         and fcsweek <> 0
         and fcsyear = fcsyear1
         and pt_desc2 <> ""
         and not l_printed
         then do:
            if fcsweek > fcsweek1
            then
               down 1 with frame b.
            display pt_desc2 @ pt_desc1 with frame b.
            l_printed = yes.
         end. /* IF fcsweek = fcsweek1 .. */
      end. /* IF det_sum */

      if last-of (fcs_site)
      then do:

         if det_sum
         then do:
            /* FOR CASES WHERE DATE RANGE IS B/W A WEEK */
            /* e.g WEEK START 01/15/01 AND IP RANGE IS 01/16 TO 01/20 */
            if fcsyear = fcsyear1
               and fcsweek > fcsweek1
               and pt_desc2 <> ""
               and not l_printed
            then do:
               down 1 with frame b.
               display pt_desc2 @ pt_desc1 with frame b.
               l_printed = yes.
            end. /* IF fcsyear = fcsyear1 */

            display
               getTermLabelRt("TOTAL",8) @ start[1]
               totals[1] @ fcs_fcst_qty[1]
               totals[2] @ fcs_sold_qty[1]
               totals[3] @ fcs_abnormal[1]
               totals[4] @ fcs_pr_fcst[1]
               totals[5] @ net[1]
            with frame b.

            down 2 with frame b.

            if page-size - line-counter < 3
            then
               page.

         end. /* IF det_sum */
         else do:

            display fcsdate   @ start[1]
                    fcsdate1  @ start[2]
                    totals[1] @ fcs_fcst_qty[1]
                    totals[2] @ fcs_sold_qty[1]
                    totals[3] @ fcs_abnormal[1]
                    totals[4] @ fcs_pr_fcst[1]
                    totals[5] @ net[1]
            with frame c.

            if not det_sum
            then do:
               if first-of (fcs_part)
               then do:
                  down 1 with frame c.
                  display pt_desc2 @ pt_desc1 with frame c.
                  l_printed = yes.
               end. /* IF FIRST-OF (fcs_part) */
               else
                  down 1 with frame c.


               if not l_printed
               then do:
                  display pt_desc2 @ pt_desc1 with frame c.
                  l_printed = yes.
               end. /* IF NOT l_printed */
           end. /* IF NOT det_sum */

           if last-of (pt_part)
           then
              down 1 with frame c.

         end. /* ELSE */

      end. /* IF LAST-OF (fcs_site) */

      {mfrpchk.i}

   end. /* FOR EACH pt_mstr */

   /* REPORT TRAILER */
   {mfrtrail.i}
   SS - 100811.1 - E */
   /* SS - 100811.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttxxfcfsrp0001.
   
   {gprun.i ""xxfcfsrp0001.p"" "(
      INPUT part,
      INPUT part1,
      INPUT site,
      INPUT site1,
      INPUT prod_line,
      INPUT fcsdate,
      INPUT fcsdate1
       )"}
   
   EXPORT DELIMITER ";" "part" "desc1" "desc2" "site" "week" "start" "fcst_qty" "sold_qty" "abnormal" "prod_fcst" "net".
   FOR EACH ttxxfcfsrp0001:
      EXPORT DELIMITER ";" ttxxfcfsrp0001.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {xxmfrtrail.i}
   /* SS - 100811.1 - E */
end. /* REPEAT */

{wbrp04.i &frame-spec = a}
