/* relsrp.p  - REPETITIVE LINE SCHEDULE REPORT                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5 $                                                           */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 9.1      CREATED: 06/07/99   BY: *N005* Luke Pokic               */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                  */
/* $Revision: 1.5 $    BY: Saurabh C.            DATE: 02/07/02  ECO: *N18M*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100818.1 By: Bill Jiang */

/* SS - 100818.1 - RNB
[100818.1]

[100818.1]

SS - 100818.1 - RNE */

/*
{mfdtitle.i "b+ "}
*/
{mfdtitle.i "100818.1"}

/* SS - 100818.1 - B */
{xxrelsrp0001.i "new"}
/* SS - 100818.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE relsrp_p_1 "Primary Run Sequence"
/* MaxLen: 23 Comment: Primary sort sequence */

&SCOPED-DEFINE relsrp_p_2 "Secondary Run Sequence"
/* MaxLen: 23 Comment: Secondary sort sequence */

&SCOPED-DEFINE relsrp_p_3 "Sort"
/* MaxLen: 5 Comment: Can be Ascending or Descending only */

&SCOPED-DEFINE relsrp_p_6 "Item Number"
/* MaxLen: 18 Comment: */

&SCOPED-DEFINE relsrp_p_7 "Rel Date"
/* MaxLen: 8 Comment: Release date */

&SCOPED-DEFINE relsrp_p_8 "Scheduled"
/* MaxLen: 12 Comment: Quantity scheduled */

&SCOPED-DEFINE relsrp_p_9 "Completed"
/* MaxLen: 12 Comment: Quantity completed */

&SCOPED-DEFINE relsrp_p_10 "Open"
/* MaxLen: 12 Comment: Quantity scheduled minus quantity completed*/

&SCOPED-DEFINE relsrp_p_11 "Due Date"
/* MaxLen: 8 Comment: */

&SCOPED-DEFINE relsrp_p_12 "Run Seq 1"
/* MaxLen: 9 Comment: Primary sort sequence*/

&SCOPED-DEFINE relsrp_p_13 "Run Seq 2"
/* MaxLen: 9 Comment: Secondary sort sequence*/

&SCOPED-DEFINE relsrp_p_14 "Ascending/Descending"
/* MaxLen: 20 Comment: Valid values for sort field*/

&SCOPED-DEFINE relsrp_p_15 "Release Date"
/* MaxLen: 23 Comment: Release date*/

/* ********** End Translatable Strings Definitions ********* */

define variable site            like wo_site      no-undo.
define variable site1           like wo_site      no-undo.
define variable prline          like rps_line     no-undo.
define variable prline1         like rps_line     no-undo.
define variable release_date    like wr_start     no-undo.
define variable release_date1   like ro_end       no-undo.
define variable primary_seq     like lnd_run_seq1 no-undo.
define variable primary_seq1    like lnd_run_seq1 no-undo.
define variable primary_sort    like mfc_logical  no-undo
   initial yes format {&relsrp_p_14}.
define variable secondary_seq   like lnd_run_seq2 no-undo.
define variable secondary_seq1  like lnd_run_seq2 no-undo.
define variable secondary_sort  like mfc_logical  no-undo
   initial yes format {&relsrp_p_14}.
define variable old_start       like release_date no-undo initial today.
define variable open_qty        like rps_qty_req  no-undo.
define variable l_site          as  character     format "x(8)"  no-undo.
define variable l_line          as  character     format "x(24)" no-undo.

form
   site              colon 24
   site1             colon 44 label {t001.i}
   prline            colon 24
   prline1           colon 44 label {t001.i}
   release_date      colon 24 label {&relsrp_p_15}
   release_date1     colon 44 label {t001.i}
   /* SS - 100818.1 - B
   primary_seq       colon 24 label {&relsrp_p_1}
   primary_seq1      colon 44 label {t001.i}
   primary_sort      colon 66 label {&relsrp_p_3}
   secondary_seq     colon 24 label {&relsrp_p_2}
   secondary_seq1    colon 44 label {t001.i}
   secondary_sort    colon 66 label {&relsrp_p_3}
   SS - 100818.1 - E */
   skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   rps_rel_date    column-label {&relsrp_p_7}  at 1
   rps_due_date    column-label {&relsrp_p_11} at 11
   lnd_run_seq1    column-label {&relsrp_p_12} at 21
   lnd_run_seq2    column-label {&relsrp_p_13} at 32
   rps_part        column-label {&relsrp_p_6}  at 43
   pt_desc1                                    at 63
   rps_qty_req     column-label {&relsrp_p_8}  at 89
   rps_qty_comp    column-label {&relsrp_p_9}  at 103
   open_qty        column-label {&relsrp_p_10} at 117
with frame b down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

assign
   l_site = getTermLabelRtColon("SITE",8)
   l_line = getTermLabelRtColon("PRODUCTION_LINE",24).

/* INTERNAL PROCEDURES TO HANDLE CALLS TO relsrp.i */
PROCEDURE sort_run_seq_asc_asc:

   /* RUN SEQUENCE 1 ASCENDING, RUN SEQUENCE 2 ASCENDING */
   { relsrp.i " " " " }

END PROCEDURE.

PROCEDURE sort_run_seq_asc_desc:

   /* RUN SEQUENCE 1 ASCENDING, RUN SEQUENCE 2 DESCENDING */
   { relsrp.i " " descending }

END PROCEDURE.

PROCEDURE sort_run_seq_desc_asc:

   /* RUN SEQUENCE 1 DESCENDING, RUN SEQUENCE 2 ASCENDING */
   { relsrp.i descending " "}

END PROCEDURE.

PROCEDURE sort_run_seq_desc_desc:

   /* RUN SEQUENCE 1 DESCENDING, RUN SEQUENCE 2 DESCENDING */
   { relsrp.i descending descending }

END PROCEDURE.


{wbrp01.i}

repeat:
   release_date = old_start.

   if site1 = hi_char
   then
      site1 = "".

   if prline1 = hi_char
   then
      prline1 = "".

   if (release_date = ? or release_date = low_date)
   then
      release_date = today.

   if release_date1 = hi_date
   then
      release_date1 = ?.

   if primary_seq1 = hi_char
   then
      primary_seq1 = "".

   if secondary_seq1 = hi_char
   then
      secondary_seq1 = "".

   if c-application-mode <> 'WEB'
   then
      update
         site
         site1
         prline
         prline1
         release_date
         release_date1
      /* SS - 100818.1 - B
         primary_seq
         primary_seq1
         primary_sort
         secondary_seq
         secondary_seq1
         secondary_sort
         SS - 100818.1 - E */
      with frame a.

   {wbrp06.i &command = update
             &fields = "site
                        site1
                        prline
                        prline1
                        release_date
                        release_date1
      /* SS - 100818.1 - B
                        primary_seq
                        primary_seq1
                        primary_sort
                        secondary_seq
                        secondary_seq1
                        secondary_sort
      SS - 100818.1 - E */
      "
             &frm = "a"}

   if     (c-application-mode <> 'WEB')
      or  (c-application-mode = 'WEB'
      and (c-web-request begins 'DATA'))
   then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".

      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i prline }
      {mfquoter.i prline1 }
      {mfquoter.i release_date }
      {mfquoter.i release_date1 }
      {mfquoter.i primary_seq }
      {mfquoter.i primary_seq1 }
      {mfquoter.i primary_sort }
      {mfquoter.i secondary_seq }
      {mfquoter.i secondary_seq1 }
      {mfquoter.i secondary_sort }

      if site1 = ""
      then
         site1 = hi_char.

      if prline1 = ""
      then
         prline1 = hi_char.

      if primary_seq1 = ""
      then
         primary_seq1 = hi_char.

      if secondary_seq1 = ""
      then
         secondary_seq1 = hi_char.

      if release_date  = ?
      then
         release_date = low_date.

      if release_date1 = ?
      then
         release_date1 = hi_date.

   end. /* c-application-mode <> 'WEB' .. */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType                = "printer"
               &printWidth               = 132
               &pagedFlag                = " "
               &stream                   = " "
               &appendToFile             = " "
               &streamedOutputToTerminal = " "
               &withBatchOption          = "yes"
               &displayStatementType     = 1
               &withCancelMessage        = "yes"
               &pageBottomMargin         = 6
               &withEmail                = "yes"
               &withWinprint             = "yes"
               &defineVariables          = "yes"}

   /* SS - 100818.1 - B
   /* INCLUDE FILE TO PRINT PAGE HEADING FOR REPORTS */
   {mfphead.i}

   old_start = release_date.

   /* LOGIC TO CALL relsrp.i WITH REQUIRED ORDER OF SORTING */
   if primary_sort
   then do:

      if secondary_sort
      then do:
         run sort_run_seq_asc_asc.
      end. /* IF secondary_sort  */

      else do:
         run sort_run_seq_asc_desc.
      end. /* ELSE DO secondary_sort  */

   end. /* IF primary_sort */
   else do:

      if secondary_sort
      then do:
         run sort_run_seq_desc_asc.
      end. /* IF secondary_sort */

      else do:
         run sort_run_seq_desc_desc.
      end. /* ELSE DO  secondary-sort  */

   end. /* ELSE DO primary_sort */

   /* REPORT TRAILER INCLUDE FILE  */
   { mfrtrail.i}
   SS - 100818.1 - E */
   /* SS - 100818.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttxxrelsrp0001.
   
   {gprun.i ""xxrelsrp0001.p"" "(
      input site,
      input site1,
      input prline,
      input prline1,
      input release_date,
      input release_date1
      )"}
   
   EXPORT DELIMITER ";" "rps_site" "rps_line" "rps_part" "pt_desc1" "pt_desc2" "rps_rel_date" "rps_due_date" "lnd_run_seq1" "lnd_run_seq2" "rps_qty_req" "rps_qty_comp" "open_qty".
   FOR EACH ttxxrelsrp0001:
      EXPORT DELIMITER ";" ttxxrelsrp0001.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {xxmfrtrail.i}
   /* SS - 100818.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
