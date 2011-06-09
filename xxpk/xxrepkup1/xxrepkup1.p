/* xxrepkup.p - REPETITIVE PICKLIST CALCULATION                              */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110609.1"}

define variable line   like ln_line no-undo.
define variable line1  like ln_line no-undo.
define variable issue  as date no-undo.
define variable issue1 as date no-undo.
define variable update_data as logical no-undo initial yes.

/* SELECT FORM */
form
   line   colon 15
   line1  label {t001.i} colon 49 skip
   issue  colon 15
   issue1 label {t001.i} colon 49 skip(1)
   update_data colon 25
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:
    if line1 = hi_char then line1 = "".
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update line line1 issue issue1 update_data with frame a.

{wbrp06.i &command = update
          &fields = " line line1 issue issue1 update_data"
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i line  }
   {mfquoter.i line1 }
   {mfquoter.i issue }
   {mfquoter.i issue1}

   line1 = line1 + hi_char.
   if issue1 = ? then issue1 = hi_date.
end.
        /* SELECT PRINTER  */

        {mfselbpr.i "printer" 132}
        {mfphead.i}

        for each si_mstr
            no-lock break by si_site with frame b width 132 no-box.

           /* SET EXTERNAL LABELS */
           setFrameLabels(frame b:handle).

           display  si_site si_desc.
           {mfrpexit.i}
        end.

        /* REPORT TRAILER  */
        {mfrtrail.i}

end.  /* repeat: */

{wbrp04.i &frame-spec = a}
