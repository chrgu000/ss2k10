/* mgflhdrp.p - FIELD HELP TEXT REPORT                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 0BYJ LAST MODIFIED: 05/27/11 BY: zy                             */
/* REVISION END                                                              */

/******************************************************************************/
&SCOPED-DEFINE mgflhdrp_p_1 "Procedure"
/* DISPLAY TITLE */
{mfdtitle.i "15YQ"}

define variable lang       like flhm_lang.
define variable field_from like flhm_field.
define variable field_to like flhm_field label {t001.i}.
define variable pgm_from like flhm_call_pg format "x(20)" label {&mgflhdrp_p_1}.
define variable pgm_to   like flhm_call_pg format "x(20)" label {t001.i}.

/* DISPLAY TITLE */

form
   space(1)
   lang       colon 16 skip(1)
   field_from colon 16
   field_to   colon 16 skip(1)
   pgm_from   colon 16
   pgm_to     colon 16
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

lang = global_user_lang.

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update lang field_from field_to pgm_from pgm_to with frame a.

   {wbrp06.i &command = update
             &fields = " lang field_from field_to pgm_from pgm_to"
             &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}



   for each flhd_det where
            flhd_lang = lang and
            flhd_field >= field_from and
           (flhd_field <= field_to or field_to = "") and
            flhd_call_pg >= pgm_from and
           (flhd_call_pg <= pgm_to or pgm_to = "")
   no-lock with frame f-a:

      /* {mfrpchk.i}  */

      setFrameLabels(frame f-a:handle). /* SET EXTERNAL LABELS */

      display
         flhd_lang flhd_field flhd_call_pg flhd_text
      with width 132.

   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
