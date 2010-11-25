/* xxcmmt.p - PART COMMENTS -copy from gpcmmt.p                              */
/* REVISION: 0BYP LAST MODIFIED: 11/25/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "0BYP"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gpcmmt_p_1 " Master Comments "
&SCOPED-DEFINE gpcmmt_p_2 " DOMAIN!CODE "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable del-yn like mfc_logical initial no.

define variable l-value     as character no-undo.
define variable l-fontvalue as integer   no-undo.
define variable qad_rsrv as character  no-undo initial "QADRSRV".

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY FORM */
form
   cd_ref      colon 18
   cd_lang     colon 71
   cd_type     colon 18
   cd_domain   colon 36 label {&gpcmmt_p_2}
   batchdelete colon 62
   cd_seq      colon 71
   skip(1)
   cd_cmmt    no-label
   /*V8!view-as fill-in size 76 by 1 at 2 */
with frame a title color normal (getFrameTitle("MASTER_COMMENTS",23))
   side-labels width 80
   attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

get-key-value section "ProADE" key "FixedFont" value l-value.

if l-value = ? or l-value = ""
then
   l-value = "0". /* DEFAULT PROGRESS ADE FIXEDFONT VALUE */

l-fontvalue = integer(l-value).

assign
   cd_cmmt[1]:font = l-fontvalue
   cd_cmmt[2]:font = l-fontvalue
   cd_cmmt[3]:font = l-fontvalue
   cd_cmmt[4]:font = l-fontvalue
   cd_cmmt[5]:font = l-fontvalue
   cd_cmmt[6]:font = l-fontvalue
   cd_cmmt[7]:font = l-fontvalue
   cd_cmmt[8]:font = l-fontvalue
   cd_cmmt[9]:font = l-fontvalue
   cd_cmmt[10]:font = l-fontvalue
   cd_cmmt[11]:font = l-fontvalue
   cd_cmmt[12]:font = l-fontvalue
   cd_cmmt[13]:font = l-fontvalue
   cd_cmmt[14]:font = l-fontvalue
   cd_cmmt[15]:font = l-fontvalue.

/* DISPLAY */
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   display 1 @ cd_seq with frame a.

   prompt-for cd_ref cd_type cd_domain cd_lang cd_seq
   /* Prompt for the delete variable in the key frame at the
    * End of the key field/s only when batchrun is set to yes */
   batchdelete no-label when (batchrun)
   editing:
      if frame-field = "cd_ref"
      then do:
         {mfnp05.i cd_det cd_ref_type  " cd_det.cd_domain = cd_domain and
         yes "  cd_ref "input cd_ref"}
      end. /* IF frame-field = "cd_ref" */
      else
      if frame-field = "cd_type"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_det.cd_domain = cd_domain and cd_ref  = input cd_ref"
            cd_type "input cd_type"}
      end. /* IF frame-field = "cd_type" */
/*      else                                                     */
/*      if frame-field = "cd_domain"                             */
/*      then do:                                                 */
/*                                                               */
/*      end. /* IF frame-field = "cd_domain" */                  */
      else
      if frame-field = "cd_lang"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_det.cd_domain = cd_domain and cd_ref  = input cd_ref and
            cd_type = input cd_type"
            cd_lang "input cd_lang"}
      end. /* IF frame-field = "cd_lang" */
      else
      if frame-field = "cd_seq"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_det.cd_domain = cd_domain and cd_ref  = input cd_ref and
            cd_type = input cd_type
              and cd_lang = input cd_lang"
            cd_seq "input cd_seq + 1"}
      end. /* IF frame-field = "cd_seq" */
      else do:
         readkey.
         apply lastkey.
      end. /* ELSE DO */

      if recno <> ?
      then do:
         display cd_ref cd_type cd_lang cd_seq + 1 @ cd_seq
            cd_det.cd_domain cd_cmmt.
      end. /* IF recno <> ? */
   end. /* PROMPT-FOR....EDITING */

   find cd_det
       where cd_det.cd_domain = qad_rsrv and  cd_ref  = input cd_ref
      and   cd_type = input cd_type
      and cd_lang   = input cd_lang
      and cd_seq    = input cd_seq - 1
   exclusive-lock no-error.
   if not available cd_det
   then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create cd_det. cd_det.cd_domain = input cd_domain.
      assign
         cd_ref
         cd_type
         cd_lang
         cd_seq = input cd_seq - 1.
   end. /* IF NOT AVAILABLE cd_det */

   display cd_ref cd_type cd_lang cd_seq + 1 @ cd_seq cd_cmmt
           cd_det.cd_domain.

   assign
      recno = recid(cd_det)
      ststatus = stline[2].

   status input ststatus.
   del-yn = no.
   display cd_cmmt.

   set1:
   do on error undo, retry:
      set text(cd_cmmt) go-on ("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Delete to be executed if batchdelete is set to "x" */
      or input batchdelete = "x":U
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if not del-yn
         then
            undo set1, retry.
      end. /* IF LASTKEY = KEYCODE("F5") */
   end. /* DO ON ERROR UNDO, RETRY */

   if del-yn
   then do:
      delete cd_det.
      clear frame a.
      next.
   end. /* IF del-yn */

   next-prompt cd_seq.
end. /* REPEAT WITH FRAME a */
