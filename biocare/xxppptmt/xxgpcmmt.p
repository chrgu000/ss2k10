/* gpcmmt.p - PART COMMENTS                                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.7 $                                                 */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 02/02/86   BY: PML */
/* REVISION: 2.0      LAST MODIFIED: 04/23/87   BY: EMB *A41* */
/* REVISION: 4.0      LAST MODIFIED: 11/17/87   BY: pml *A119 */
/* REVISION: 5.0      LAST MODIFIED: 02/02/89   BY: RL  *A623 */
/* REVISION: 6.0      LAST MODIFIED: 06/26/90   BY: WUG *D043 */
/* REVISION: 6.0      LAST MODIFIED: 04/22/91   BY: WUG *D613 */
/* REVISION: 6.0      LAST MODIFIED: 09/16/94   BY: LJM *FR42 */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 07/16/98   BY: *H1MB* Viswanathan M */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *D613*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *FR42*                    */
/* Revision: 1.6.1.4      BY: Anil Sudhakaran   DATE: 11/29/01  ECO: *M1H6*  */
/* Revision: 1.6.1.5  BY: Vandna Rohira DATE: 06/17/02 ECO: *N1LN* */
/* $Revision: 1.6.1.7 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00F* */
/* SS - 100412.1 By: Neil Gao */
/*-Revision end---------------------------------------------------------------*/

/* SS 100412.1 - B */
/*
可以调用和传递参数给这个程式
input part,lang,type
*/
/* SS 100412.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/* SS 100412.1 - B */
/*
{mfdtitle.i "2+ "}
*/
{mfdeclre.i}  
{gplabel.i} 
/* SS 100412.1 - E */

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

/* SS 100412.1 - B */
define input parameter iptpart like pt_part.
define input parameter iptlang as char.
define input parameter ipttype as char.
/* SS 100412.1 - E */

/* DISPLAY FORM */
form
   cd_ref      colon 18
   cd_lang     colon 71
   cd_type     colon 18
   batchdelete colon 32
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

/* SS 100412.1 - B */
	disp 	iptpart @ cd_ref
				ipttype @ cd_type
				iptlang @ cd_lang with frame a.
/* SS 100412.1 - E */

/* DISPLAY */
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   display 1 @ cd_seq with frame a.

   prompt-for cd_ref cd_type cd_lang cd_seq
   /* Prompt for the delete variable in the key frame at the
    * End of the key field/s only when batchrun is set to yes */
   batchdelete no-label when (batchrun)
   editing:
      if frame-field = "cd_ref"
      then do:
         {mfnp05.i cd_det cd_ref_type  " cd_det.cd_domain = global_domain and
         yes "  cd_ref "input cd_ref"}
      end. /* IF frame-field = "cd_ref" */
      else
      if frame-field = "cd_type"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_det.cd_domain = global_domain and cd_ref  = input cd_ref"
            cd_type "input cd_type"}
      end. /* IF frame-field = "cd_type" */
      else
      if frame-field = "cd_lang"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_det.cd_domain = global_domain and cd_ref  = input cd_ref and
            cd_type = input cd_type"
            cd_lang "input cd_lang"}
      end. /* IF frame-field = "cd_lang" */
      else
      if frame-field = "cd_seq"
      then do:
         {mfnp05.i cd_det cd_ref_type
            " cd_det.cd_domain = global_domain and cd_ref  = input cd_ref and
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
            cd_cmmt.
      end. /* IF recno <> ? */
   end. /* PROMPT-FOR....EDITING */

   find cd_det
       where cd_det.cd_domain = global_domain and  cd_ref  = input cd_ref
      and   cd_type = input cd_type
      and cd_lang   = input cd_lang
      and cd_seq    = input cd_seq - 1
   exclusive-lock no-error.
   if not available cd_det
   then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create cd_det. cd_det.cd_domain = global_domain.
      assign
         cd_ref
         cd_type
         cd_lang
         cd_seq = input cd_seq - 1.
   end. /* IF NOT AVAILABLE cd_det */

   display cd_ref cd_type cd_lang cd_seq + 1 @ cd_seq cd_cmmt.

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

/* SS 100412.1 - B */
hide frame a no-pause.
/* SS 100412.1 - E */
