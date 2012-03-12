/* xxcmmt.p - PART COMMENTS                                                   */
/*V8:ConvertMode=Maintenance                                                  */
/************************* REVISION HISTORY ***********************************/
/* REVISION:110520.1 Create: 05/20/11 BY: zy                                  */
/* LAST MODIFY:110715 by Zy:Modify it to eb2 version (Remove Domain)    *17YF */
/* Environment: Progress:10.1B   QAD:eb21sp5    Interface:                    */
/******************************************************************************/
/*-Revision:[15YJ]-------------------------------------------------------------
  Purpose:export nr_mstr record to source code for install to custmer
  Notes:This version only apply for mfg/pro eb21 or later.
------------------------------------------------------------------------------*/
{mfdtitle.i "17YF" }


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gpcmmt_p_1 " Master Comments "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable del-yn like mfc_logical initial no.

define variable l-value     as character no-undo.
define variable l-fontvalue as integer   no-undo.


/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY FORM */
form
   cd_ref      colon 18
   cd_lang     colon 71
   cd_type     colon 18
/*17YF*/   {xxcddom.i} {xxcolon18.i}
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

   prompt-for cd_ref cd_type
/*17YF*/   {xxcddom.i}
    cd_lang cd_seq
   /* Prompt for the delete variable in the key frame at the
    * End of the key field/s only when batchrun is set to yes */
   batchdelete no-label when (batchrun)
   editing:
      if frame-field = "cd_ref"
      then do:
         {mfnp05.i cd_det cd_ref_type  " yes "  cd_ref "input cd_ref"}
      end. /* IF frame-field = "cd_ref" */
      else
/*17YF*/    {xxcddommf.i}
      if frame-field = "cd_type"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_ref  = input cd_ref "
            cd_type "input cd_type"}
      end. /* IF frame-field = "cd_type" */
      else
      if frame-field = "cd_lang"
      then do:
         {mfnp05.i cd_det cd_ref_type
              " cd_ref  = input cd_ref and
            cd_type = input cd_type"
            cd_lang "input cd_lang"}
      end. /* IF frame-field = "cd_lang" */
      else
      if frame-field = "cd_seq"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_ref  = input cd_ref and
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
         display cd_ref
/*17YF*/    {xxcddom.i}
          cd_type cd_lang cd_seq + 1 @ cd_seq
            cd_cmmt.
      end. /* IF recno <> ? */
   end. /* PROMPT-FOR....EDITING */

   find cd_det where
/*17YF*/ {xxcddomi.i}
        cd_ref  = input cd_ref and
        cd_type = input cd_type and
        cd_lang   = input cd_lang and
        cd_seq    = input cd_seq - 1
   exclusive-lock no-error.
   if not available cd_det
   then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create cd_det.
      assign
         cd_ref
/*17YF*/ {xxcddom.i}
         cd_type
         cd_lang
         cd_seq = input cd_seq - 1.
   end. /* IF NOT AVAILABLE cd_det */

   display cd_ref
/*17YF*/   {xxcddom.i}
           cd_type cd_lang cd_seq + 1 @ cd_seq cd_cmmt.

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
