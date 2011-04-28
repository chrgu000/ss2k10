/* xxflhusr.p - FIELD HELP TEXT MAINTENANCE FOR USER                          */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 7.0      Last Modified: 04/01/92   By: rwl *F334*                */
/* Revision: 7.0      Last Modified: 04/27/92   By: rwl *F438*                */
/* Revision: 7.0      Last Modified: 04/28/92   By: rwl *F440*                */
/* Revision: 7.0      Last Modified: 05/26/92   By: rwl *F549*                */
/* Revision: 7.0      Last Modified: 06/30/92   By: rwl *F720*                */
/* Revision: 7.3      Last Modified: 01/25/93   By: mpp *G587*                */
/* Revision: 7.2      Last Modified: 03/03/94   By: kws *FM58*                */
/* Oracle changes (share-locks)    : 09/12/94   By: rwl *FR20*                */
/* Revision: 7.3      Last-Modified: 09/19/94   By: JPM *GM74*                */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: ame *GO02*                */
/* REVISION: 7.3      LAST MODIFIED: 01/04/95   BY: rmh *F0B8*                */
/* REVISION: 7.3      LAST MODIFIED: 02/06/95   BY: yep *G0DM*                */
/* REVISION: 7.3      LAST MODIFIED: 02/27/95   BY: srk *G0FS*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/02/00 BY: *N0HN* Jean Miller          */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb                  */
/* Revision: 1.14      BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00J*  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.15 $    BY: Vandna Rohira         DATE: 12/27/04  ECO: *P30V*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

/*允许不在菜单上的程序写程序说明.*/
{mfdtitle.i "14YS"}

define variable del-yn   like mfc_logical              no-undo.
define variable flhdtype like flhd_type initial "user" no-undo.

/* Temp array for flh_text */
define variable txt as character extent 15 format "x(62)" no-undo.

/* Size of array txt       */
define variable txt_size as integer initial 15 no-undo.

/* Index variable for txt  */
define variable i as integer no-undo.

/* Max number of text lines*/
define variable max_i as integer no-undo.

/* Temporary Variable to Display Label */
define variable text-label as character format "x(6)" no-undo.

define buffer flhddet  for flhd_det.
define buffer flhmmstr for flhm_mst.

{gpfieldv.i}

{gpdirpre.i}

/* DISPLAY SELECTION FORM */
/* Note flhm_lang is used instead of lng_lang in the following */
/* so that a screen area will exist for flhm_lang so it can be */
/* used in dictionary validation expressions                   */

form
   flhm_lang        colon 15
   lng_desc         no-label
   flhm_sub         colon 65
   flhm_field       colon 15 label "Calling Field"
   flhm_call_pg     colon 65 label "Calling Proc"
   flhm_lnk_fld     colon 15 label "Link to Field"
   flhm_lnk_pgm     colon 65 label "Link to Proc"
   flhm_sub         colon 65
   text-label       at 2     no-label
   txt              colon 10 no-label
   /*V8! view-as fill-in size 60 by 1 */
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

text-label = getTermLabelRtColon("TEXT",6).

/* DISPLAY */
display
   global_user_lang @ flhm_lang
   text-label
with frame a .

if keyfunction(lastkey) = "help"
then
   display frame-field @ flhm_field with frame a.

loopa:
repeat for flhm_mst:

   prompt-for flhm_lang with frame a
   editing:
      {mfnp05.i lng_mstr lng_lang yes lng_lang "input flhm_lang"}
      if recno <> ?
      then
         display
            lng_lang @ flhm_lang
            lng_desc
            with frame a.
   end.  /* EDITING: */

   find lng_mstr where lng_lang = input flhm_lang no-lock.

   display lng_lang @ flhm_lang lng_desc with frame a.

   loopb:
   repeat:

      prompt-for flhm_field flhm_call_pg with frame a
         no-validate
      editing:
         {mfnp05.i flhm_mst flhm_lang
            "flhm_lang = lng_lang"
            flhm_field "input flhm_field"}

         if recno <> ?
         then
            display
               flhm_field
               flhm_call_pg
               flhm_lnk_fld
               flhm_lnk_pgm
               flhm_sub
            with frame a.
      end.  /* PROMPT-FOR */

/*    if not (input flhm_call_pg = ""   or                                    */
/*       can-find(first mnd_det where mnd_exec = input flhm_call_pg) or       */
/*       can-find(first mnds_det where mnds_exec_sub = input flhm_call_pg)    */
/*       or                                                                   */
/*       (input flhm_call_pg begins "_" and                                   */
/*       can-find(first code_mstr                                             */
/*                   where code_mstr.code_domain = global_domain              */
/*                   and  code_fldname = "flhm_class"                         */
/*                   and  code_value   = substring(input flhm_call_pg, 2)) )) */
/*    then do:                                                                */
/*       /* PROCEDURE IS NOT IN THE MENU SYSTEM. */                           */
/*       {pxmsg.i &MSGNUM=5507 &ERRORLEVEL=2}                                 */
/*       undo loopb, retry.                                                   */
/*    end.  /* IF NOT (INPUT flhm_call_pg = "" OR */                          */

      find flhm_mst
         where flhm_lang    = lng_lang
         and   flhm_field   = input flhm_field
         and   flhm_call_pg = input flhm_call_pg
         exclusive-lock no-error.

      if not available flhm_mst
      then do:

         /* Adding new record.  QAD help text will be appended */
         {pxmsg.i &MSGNUM=1224 &ERRORLEVEL=2}

         create flhm_mst.
         assign
            flhm_lang   = lng_lang
            flhm_field
            flhm_call_pg.

         if recid(flhm_mst) = -1
         then
            .

         /* Try to find field in connected schemas */
         {gpfield.i &field_name=flhm_field}

         if field_found
         then do:
            if flhm_field <> ""
            then
               flhm_label = field_label.
            else do:
               /* GET LABEL FROM mnt_det */
               for first mnd_det
                  where mnd_exec = flhm_call_pg
                  no-lock:
                  for first mnt_det
                     where mnt_nbr  = mnd_nbr
                     and mnt_select = mnd_select
                     and mnt_lang   = flhm_lang
                     no-lock:
                     flhm_label = mnt_label.
                  end. /* FOR FIRST mnd_det */
               end. /* FOR FIRST mnt_det */
            end. /* IF flhm_field = "" */

            assign
               flhm_col_label = field_col-label
               flhm_format    = field_format.
            /* Get dictionary type and format length */
            {gprun.i ""mgfldict.p""
               "(input field_data-type,
                 input field_format,
                 output flhm_type,
                 output flhm_len)"}
         end.  /* IF field_found  */

      end.   /* IF NOT AVAILABLE flhm_mst */

      display
         flhm_lnk_fld
         flhm_lnk_pgm
         flhm_sub
      with frame a.

      /* Cannot edit if substitute value is "Yes" */
      if flhm_sub
      then do:
         {pxmsg.i &MSGNUM=5534 &ERRORLEVEL=3}
         next loopb.
      end.  /* IF flhm_sub  */

      /* Initialize local variables for text edit loop */
      assign
         flhdtype = "user"
         i        = 1
         txt      = ""
         del-yn   = no.

      /* Fill txt array from text fields */
      for each flhd_det no-lock
          where flhd_lang  = lng_lang
          and flhd_field   = flhm_field
          and flhd_call_pg = flhm_call_pg
          and flhd_type    = flhdtype
          and flhd_line   <= txt_size
          by flhd_line:
          txt[flhd_line] = flhd_text.
      end.  /* FOR EACH flhd_det  */

      ststatus = stline[2].
      status input ststatus.

      /* Edit the text fields */
      update text(txt) go-on ("F5" "CTRL-D")
      with frame a.

      if lastkey = keycode("F5") or
         lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no
         then
            undo loopb, retry.
      end.  /* IF LASTKEY = KEYCODE("F5") OR  */

      if del-yn
      then do:

         for each flhd_det exclusive-lock
            where flhd_lang     = lng_lang
               and flhd_field   = flhm_field
               and flhd_call_pg = flhm_call_pg
               and flhd_type    = flhdtype: /* user */
            delete flhd_det.
         end.  /* FOR EACH flhd_det EXCLUSIVE-LOCK  */

         if not can-find (first flhd_det
                            where flhd_lang  = lng_lang
                            and flhd_field   = flhm_field
                            and flhd_call_pg = flhm_call_pg)
            and not can-find (first flhm_mst
                                where flhm_lang    = input flhm_lang
                                and   flhm_lnk_fld = input flhm_field
                                and   flhm_lnk_pgm = input flhm_call_pg)
            then
               delete flhm_mst.
         clear frame a.
         next loopa.

      end.  /* IF del-yn  */

      /* Determine the last non-blank text line */
      /* max_i will still be 0 if all text lines are blank */
      max_i = 0.
      do i = txt_size to 1 by -1:
         if txt[i] <> ""
         then do:
            max_i = i.
            leave.
         end.  /* IF txt[i] <> ""  */
      end.  /* DO i = txt_size TO 1 BY -1: */

      /* Now fill text fields with txt array */
      do i = 1 to max_i:
         find flhd_det
            where flhd_lang    = lng_lang
            and   flhd_field   = flhm_field
            and   flhd_call_pg = flhm_call_pg
            and   flhd_type    = flhdtype
            and   flhd_line    = i
            exclusive-lock no-error.

         if not available flhd_det
         then do:
            /* insert new record */
            create flhd_det.
            assign
               flhd_lang    = lng_lang
               flhd_field   = flhm_field
               flhd_call_pg = flhm_call_pg
               flhd_type    = flhdtype
               flhd_line    = i.
         end.  /* IF NOT AVAILABLE flhd_det  */

         /* Assign text */
         flhd_text = txt[i].

      end.  /* DO i = 1 TO max_i: */

      /* Make sure that we have one blank line at end if max_i > 0 */
      if max_i > 0
      then do:

         find flhd_det
            where flhd_lang  = lng_lang
            and flhd_field   = flhm_field
            and flhd_call_pg = flhm_call_pg
            and flhd_type    = flhdtype
            and flhd_line    = max_i + 1
            exclusive-lock no-error.

         if not available flhd_det
         then do:
            create flhd_det.
            assign
               flhd_lang    = lng_lang
               flhd_field   = flhm_field
               flhd_call_pg = flhm_call_pg
               flhd_type    = flhdtype
               flhd_line    = max_i + 1.
         end.  /* IF NOT AVAILABLE flhd_det  */

         flhd_text = "".

      end.  /* IF max_i > 0  */

      /* Delete blank text field records */
      if max_i = 0
      then
         max_i = -1. /* delete all blank records */

      for each flhd_det exclusive-lock
         where flhd_lang    = lng_lang
         and   flhd_field   = flhm_field
         and   flhd_call_pg = flhm_call_pg
         and   flhd_type    = flhdtype
         and   flhd_line    > max_i + 1:
         delete flhd_det.
      end.  /* FOR EACH flhd_det */

   end. /* loopb */

end.  /* loopa */
