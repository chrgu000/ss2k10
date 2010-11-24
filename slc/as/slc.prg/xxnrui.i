/* nrui.i - NRM - Interactive Interface                                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19.1.8 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6      LAST MODIFIED: 06/10/96   BY: pcd  *K002*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/*                                   09/27/96   BY: jzw  *K00R*               */
/*                                   10/07/96   BY: jzw  *K00V*               */
/*                                   10/22/96   BY: jzw  *K018*               */
/*                                   10/25/96   BY: jzw  *K019*               */
/*                                   10/31/96   BY: jzw  *K01Q*               */
/*                                   02/13/97   *K064*  Jeff Wootton          */
/*                                   03/21/97   *K08H*  Brenda Milton         */
/*                                   03/24/97   *K08M*  Brenda Milton         */
/*                                   04/18/97   *K0C1*  E. Hughart            */
/*                                   04/24/97   *K0CD*  E. Hughart            */
/*                                   04/30/97   *K0CR*  Jeff Wootton          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *K064*                    */
/* Old ECO marker removed, but no ECO header exists *K08H*                    */
/* Old ECO marker removed, but no ECO header exists *K08M*                    */
/* Old ECO marker removed, but no ECO header exists *K0C1*                    */
/* Old ECO marker removed, but no ECO header exists *K0CD*                    */
/* Old ECO marker removed, but no ECO header exists *K0CR*                    */
/* Revision: 1.19.1.4     BY: Jean Miller         DATE: 04/08/02  ECO: *P058* */
/* Revision: 1.19.1.6     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.19.1.7     BY: Jean Miller         DATE: 03/02/04  ECO: *Q067* */
/* $Revision: 1.19.1.8 $  BY: Reena Ambavi         DATE: 11/25/04  ECO: *P2WD* */
/* By: Neil Gao Date: 07/12/03 ECO: * ss 20071203 * */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

define variable seq-id            like nr_seqid.
define variable seq-desc          like nr_desc.
define variable seq-dataset       like nr_dataset.
define variable seq-internal      like nr_internal.
define variable seq-allow-discard like nr_allow_discard.
define variable seq-allow-void    like nr_allow_void.
define variable seq-effdate       like nr_effdate.
define variable seq-expdate       like nr_exp_date.
define variable seq-next-val      like nrh_number no-undo.

define variable segsettings  as character format "x(44)" label "Settings".
define variable segcontrol   as character label "Control".

define variable seg-nbr      as integer format ">9" label "Nbr".
define variable seg-type     as character format "x(8)" label "Type".

define variable handle_seg_list as widget-handle.

define new shared variable fname like lngd_dataset initial "nr_mstr" no-undo.

/* FORM DEFINITIONS */
form
   seq-id                  colon 20 format "x(8)"
   seq-desc                colon 20 format "x(40)"
   seq-dataset             colon 20 format "x(16)"
   seq-internal            colon 20
   seq-allow-discard       colon 20
   seq-effdate             colon 60
   seq-allow-void          colon 20
   seq-expdate             colon 60
with side-labels width 80 frame hdr
title color normal (getFrameTitle("SEQUENCE_MASTER",23)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame hdr:handle).

form
   seg-nbr at 3 format ">9"
   seg-type
   segsettings
   segcontrol
with width 80 no-labels frame seg_key.

form
   seq-next-val colon 16
with side-labels width 80
title color normal (getFrameTitle("LAST_USED_SEQUENCE_NUMBER",38))
frame set_next overlay centered.

/* SET EXTERNAL LABELS */
setFrameLabels(frame set_next:handle).

/* NRM ENGINE */
PROCEDURE sequence_mt:
   define variable done as logical.

   mainloop:
   repeat:

      run get_key (output done).
      /*V8! if global-beam-me-up then undo, leave. */
      if done then leave mainloop.

      do transaction:
         run set_key.
         if error_state then do:
            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
            undo mainloop, retry.
         end.

         run display_header.

         run edit_header (output done).
         /*V8! if global-beam-me-up then undo, leave. */

         if done then do:
            clear frame hdr.
            next mainloop.
         end.

         if keyfunction(lastkey) = "END-ERROR" then do:
            clear frame hdr.
            undo mainloop, retry.
         end.

         if not in_use then do:
            run edit_seg_list.
            /*V8! if global-beam-me-up then undo, leave. */
         end.
         else /* SEQUENCE IS IN USE, SEGMENTS CANNOT BE UPDATED */
            run display_seg_list.

         if (keyfunction(lastkey) = "END-ERROR" and
            segment_count = 0 and not in_use) then do:
            clear frame hdr.
            undo mainloop, retry.
         end.

         run nr_save
            (input seq-id).

         do while error_state:

            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}

            run nr_clear_error.

            hide handle_seg_list.
            if not in_use then do:
               run edit_seg_list.
               /*V8! if global-beam-me-up then undo, leave. */
            end.
            else /* SEQUENCE IS IN USE, SEGMENTS CANNOT BE UPDATED */
               run display_seg_list.

            run nr_save
               (input seq-id).

         end.

      end. /* do transaction */

      release nr_mstr.
      hide handle_seg_list.

   end.

END PROCEDURE.

PROCEDURE get_key:
   define output parameter done as logical initial true.

   key_block:
   do on error undo, retry:

      prompt-for
         seq-id
      with frame hdr
      editing:
         {mfnp.i nr_mstr seq-id  " nr_domain = global_domain and
         nr_seqid "  seq-id nr_seqid nr_seqid}
         if recno <> ? then do:
            run display_header1 (buffer nr_mstr).
         end.

         if lastkey = keycode( "?" ) then do:
            bell.
            clear frame hdr.
            undo, retry.
         end.
      end.

      if input seq-id = "" then do:
         /* Blank not allowed */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         undo key_block.
      end.

   end.

   assign
      seq-id.
   done = false.

END PROCEDURE.

PROCEDURE set_key:

   run nr_create.

   if can-find(nr_mstr where nr_domain = global_domain
                         and nr_seqid = seq-id)
   then do:
      run nr_load
         (input seq-id,
          input true). /* EXCLUSIVE-LOCK */
   end.
   else do:
      run nr_save (seq-id).
      clear frame hdr.
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
   end.

END PROCEDURE.

PROCEDURE edit_header:
   define output parameter done as logical no-undo initial false.

   define variable del-yn as logical no-undo initial false.

   ststatus = stline[2].
   status input ststatus.

   set_block:
   do on error undo, retry:

      run nr_clear_error.

      set
         seq-desc
         seq-dataset       when (not in_use)
         seq-internal      when (not in_use)
         seq-allow-discard when (not in_use)
         seq-allow-void    when (not in_use)
         seq-effdate
         seq-expdate
      go-on (F5 CTRL-D)
      with frame hdr
      editing:

         /* Reject Progress Unknown */
         readkey.
         if lastkey <> keycode("?") or ( lastkey = keycode("?") and
            frame-field = "seq-expdate")
         then apply lastkey.
         else bell.

         /* Delete logic */
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then do:

            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn = no then undo set_block.
            done = true.

            run nr_delete.

            if error_state then do:
               {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
               return.
            end.

            return.

         end. /* Delete logic */

      end. /* Set with frame hdr editing */

      if seq-expdate = ? then
         seq-expdate = hi_date.

      run nr_set_description
         (input seq-desc).

      if not in_use then do:

         run nr_set_target
            (input seq-dataset).
         run nr_set_internal
            (input seq-internal).
         run nr_set_discards
            (input seq-allow-discard).

         run nr_set_voids
            (input seq-allow-void).
         if error_state then do:
            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
            next-prompt seq-allow-void with frame hdr.
            undo set_block, retry.
         end.

      end.

      run nr_set_effdt
         (input seq-effdate,
          input seq-expdate).
      if error_state then do:
         {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
         next-prompt seq-effdate with frame hdr.
         undo set_block, retry.
      end.

   end. /* set_block */

END PROCEDURE.

PROCEDURE edit_seg_list:
   define variable seg-recno as recid.
   define variable done as logical.

   segment_loop:
   repeat:
      run nr_clear_error.
      run display_seg_list.
      run get_seg_key (output done).
      /*V8! if global-beam-me-up then undo, leave. */
      if done then leave segment_loop.
      run seg_find
         (input seg-nbr,
          input seg-type,
          output seg-recno).
      if error_state then do:
         {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
         undo segment_loop, retry.
      end.

      find segment where recid (segment) = seg-recno.

      /* SEGMENT NUMBER WAS ENTERED, SEGMENT TYPE WAS DISPLAYED, */
      /* DO NOT PAUSE BEFORE EDITING SEGMENT DATA.               */
      hide frame seg_key no-pause.
      run value (seg_exe_edit)
         (input seg-recno).
      if error_state
         or not segment_edited
      then
         undo segment_loop, retry.

      clear frame seg_key no-pause.

      seg-nbr = ?.
      seg-type = "".

   end.

   clear frame seg_key no-pause.

   hide frame seg_key no-pause.

END PROCEDURE.

PROCEDURE get_seg_key:
   define output parameter done as logical initial true.

   define variable seg-format as character no-undo.
   define variable seg-settings as character no-undo.
   define variable seg-control as character no-undo.
   define variable segcode as character.
   define variable seglabel as character.
   define variable valid_mnemonic as logical initial false.

   key_block:
   do on error undo, retry:

      /* SELECT OR ENTER SEGMENT NUMBER */
      prompt-for
         seg-nbr
      with frame seg_key
      editing:

         /* FIND SEGMENT BY SCROLLING THROUGH SEGMENTS */
         {mfnp06.i segment
            seg-nbr
            seg_attached
            seg_nbr
            seg-nbr
            seg_nbr
            seg-nbr}

         if lastkey = keycode("?") then do:
            bell.
            clear frame seg_key.
            undo, retry.
         end.

         /* FIND SEGMENT BY ENTERING THE SEGMENT NUMBER */
         if recno = ? then do:
            if input seg-nbr <= "" then
               undo, retry.
            find segment where seg_nbr = input seg-nbr
               and seg_attached no-error.
            if available segment then
               recno = recid(segment).
         end.

         if recno <> ? then do:
            /* DISPLAY AN EXISTING SEGMENT */
            run display_segment
               (input recno,
                output seg-format,
                output seg-settings,
                output seg-control).

            {gplngn2a.i
               &file        = ""nr_mstr""
               &field       = ""seg-type""
               &code        = seg_type
               &mnemonic    = segcode
               &label       = seglabel      }

            display
               seg_nbr      @ seg-nbr
               segcode      @ seg-type
               seg-settings @ segsettings
               seg-control  @ segcontrol
            with frame seg_key.
         end.

         else do:
            /* CLEAR DATA FROM PREVIOUS SEGMENT DISPLAY */
            display
               input seg-nbr @ seg-nbr
               ""            @ seg-type
               ""            @ segsettings
               ""            @ segcontrol
            with frame seg_key.
         end.

      end. /* prompt-for */

      assign
         seg-nbr
         seg-type.

      if not available segment and
         (seg-nbr < 1 or seg-nbr > segment_count + 1 )
      then do:
         {pxmsg.i &MSGNUM=2932 &ERRORLEVEL=3}
         /* Segment numbers must be consecutive */
         next-prompt seg-nbr with frame seg_key.
         undo, retry.
      end.

      /* CREATING SEGMENT, ENTER SEGMENT TYPE */
      if not available segment then
         update
            seg-type
         with frame seg_key.

      /* VALIDATE seg-type MNEMONIC FROM lngd_det */
      {gplngv.i &file     = ""nr_mstr""
         &field    = ""seg-type""
         &mnemonic = seg-type
         &isvalid  = valid_mnemonic    }

      if not valid_mnemonic then do:
         /* INVALID MNEMONIC seg-type */
         {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3 &MSGARG1=seg-type}
         next-prompt seg-type with frame seg_key.
         undo, retry.
      end.

      {gplnga2n.i
         &file       = ""nr_mstr""
         &field      = ""seg-type""
         &mnemonic   = seg-type
         &code       = seg-type
         &label      = seglabel}

      if seg-type = "3" /* FISCAL */
         and expdate = hi_date
      then do:
         {pxmsg.i &MSGNUM=2927 &ERRORLEVEL=3} /* FISCAL SEGMENT REQUIRES */
         /* AN EXPIRATION DATE */
         next-prompt seg-type with frame seg_key.
         undo, retry.
      end.

      find segment where seg_nbr = seg-nbr and seg_attached no-error.

      done = false.

   end. /* KEY_BLOCK */

END PROCEDURE.

PROCEDURE seg_find:
   define input parameter seg-nbr like seg_nbr.
   define input parameter seg-type like seg_type.
   define output parameter seg-recno as recid.

   define variable seglabel as character.

   find segment where seg_nbr = seg-nbr and seg_attached no-error.
   if available segment then do:
      seg-recno = recid(segment).
      return.
   end.
   else do:
      run nr_seg_make
         (input seg-type,
          output seg-recno).
      if error_state then return.
      run nr_add_segment
         (input seg-recno).
   end.

END PROCEDURE.

PROCEDURE display_header:

   display
      seq-id
      description     @ seq-desc
      vdataset        @ seq-dataset
      internal        @ seq-internal
      discard_allowed @ seq-allow-discard
      effdate         @ seq-effdate
      void_allowed    @ seq-allow-void
      (if expdate <> hi_date then expdate else ?) @ seq-expdate
   with frame hdr.

END PROCEDURE.

PROCEDURE display_seg_list:
   define variable segcode as character.
   define variable seglabel as character.
   define variable seg-settings as character no-undo.
   define variable seg-control as character no-undo.
   define variable done as logical initial false.

   /* FORM IS DEFINED HERE SO IT WILL BE RE-CREATED BEFORE EACH */
   /* DISPLAY, BECAUSE THE "CLEAR" IS BYPASSED BY THE GUI CONVERTOR. */
   /*V8:HiddenDownFrame=seg_list*/
   form
      seg-nbr at 2
      seg-type
      segsettings
      segcontrol
   with 4 down
   title color normal (getFrameTitle("SEGMENT_LIST",19))
   width 80 frame seg_list.

   view frame seg_list.

   handle_seg_list = frame seg_list:handle.

   for each segment exclusive-lock where seg_attached by seg_nbr
   on endkey undo, retry:

      run value(seg_exe_display)
         (input recid(segment),
          output seg-settings,
          output seg-control).

      {gplngn2a.i  &file     = ""nr_mstr""
         &field    = ""seg-type""
         &code     = seg_type
         &mnemonic = segcode
         &label    = seglabel      }

      display
         seg_nbr      @ seg-nbr
         segcode      @ seg-type
         seg-settings @ segsettings
         seg-control  @ segcontrol
      with frame seg_list.

      down with frame seg_list.

   end.

END PROCEDURE.

PROCEDURE display_segment:
   define input parameter seg-recno as recid.
   define output parameter seg-format as character no-undo.
   define output parameter seg-settings as character no-undo.
   define output parameter seg-control as character no-undo.

   find segment where recid(segment) = seg-recno.
   run value (seg_exe_display)
      (input seg-recno,
       output seg-settings,
       output seg-control).

END PROCEDURE.

PROCEDURE display_header1:
   define parameter buffer nr_mstr for nr_mstr.

   display
      nr_seqid         @ seq-id
      nr_desc          @ seq-desc
      nr_dataset       @ seq-dataset
      nr_internal      @ seq-internal
      nr_allow_discard @ seq-allow-discard
      nr_effdate       @ seq-effdate
      nr_allow_void    @ seq-allow-void
      nr_exp_date      @ seq-expdate with frame hdr.

END PROCEDURE.

PROCEDURE next_mt:

   define variable done as logical.

   mainloop:
   repeat:

      run get_key (output done).
      /*V8! if global-beam-me-up then undo, leave. */
      if done then leave mainloop.

      do transaction:

         run retrieve_key.

         if error_state then do:
            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
            undo mainloop, retry.
         end.

         run display_header.
         run display_seg_list.
         run edit_next (output done).
         /*V8! if global-beam-me-up then undo, leave. */

         if done then next mainloop.

         run nr_save (seq-id).

      end.

      release nr_mstr.

   end.

END PROCEDURE.

PROCEDURE retrieve_key:

   run nr_create.

   if can-find(nr_mstr where nr_domain = global_domain
                         and nr_seqid = seq-id)
   then do:
      run nr_load
         (input seq-id,
          input true). /* EXCLUSIVE-LOCK */
   end.
   else do:
      error_state = true.
      error_nbr = 2914. /* Sequence not found */
   end.

END PROCEDURE.

PROCEDURE edit_next:
   define output parameter done as logical no-undo initial false.

   run nr_clear_error.

   run nr_value
      (output seq-next-val).

   display
      seq-next-val
   with frame set_next.

   if not Internal then do:
      /* Set next sequence number allowed for internal sequences only*/
      {pxmsg.i &MSGNUM=2928 &ERRORLEVEL=4}
   end.

   else
   /* Discards Must be Allowed */
   if not Discard_allowed then do:
      /*Set next Sequence number allowed for allow discarding only */
      {pxmsg.i &MSGNUM=2913 &ERRORLEVEL=4}
   end.

   else do:

      set_block:
      do on error undo, retry:

         set
            seq-next-val
         with frame set_next.

         run nr_set_next
            (input seq-id,
             input seq-next-val).

         if error_state then do:
            if error_nbr = 2917 then do:
               /* INVALID SEQUENCE VALUE FOR SEGMENT n */
               {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3 &MSGARG1=error_seg_nbr}
            end.
            else do:
               {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
            end.
            undo set_block.
         end.

      end. /* set_block */

   end. /* else do */

END PROCEDURE.

PROCEDURE ext_seq_mt:
   /* Sequence Maintenance to be accessed from an external program */
   define variable done as logical.
   define input parameter s-id like nr_seqid no-undo.

   assign seq-id = s-id.

   mainloop:
   repeat:
      run set_key.
      run display_header1 (buffer nr_mstr).

      /* SEQUENCE EDITOR LOGIC */
      set_block:
      do on error undo, retry:

         run nr_clear_error.

         set
            seq-desc
            seq-dataset
            seq-internal
            seq-allow-discard
            seq-allow-void
            seq-effdate
            seq-expdate
         with frame hdr
         editing:
            readkey.
            if lastkey <> keycode("?") or (lastkey = keycode("?")
               and frame-field = "seq-expdate")
            then apply lastkey.
            else bell.
         end. /* set / editing */

         if seq-expdate = ? then
            seq-expdate = hi_date.

         run nr_set_description
            (input seq-desc).
         run nr_set_target
            (input seq-dataset).
         run nr_set_internal
            (input seq-internal).
         run nr_set_discards
            (input seq-allow-discard).
         run nr_set_voids
            (input seq-allow-void).

         if error_state then do:
            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
            next-prompt seq-allow-void with frame hdr.
            undo set_block, retry.
         end.

         run nr_set_effdt
            (input seq-effdate,
             input seq-expdate).

         if error_state then do:
            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
            next-prompt seq-effdate with frame hdr.
            undo set_block, retry.
         end.

      end. /* SET_BLOCK */

      if done then do:
         clear frame hdr.
         next mainloop.
      end.

      if keyfunction(lastkey) = "END-ERROR" then do:
         undo mainloop, leave.
      end.

      run edit_seg_list.
      /*V8! if global-beam-me-up then undo, leave. */

      if (keyfunction(lastkey) = "END-ERROR"
         and segment_count = 0)
      then do:
         undo mainloop, retry.
      end.

      run nr_save (seq-id).
      do while error_state:
         {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
         run nr_clear_error.
         hide handle_seg_list.
         run edit_seg_list.
         /*V8! if global-beam-me-up then undo, leave. */
         run nr_save (seq-id).
      end.

      release nr_mstr.
      hide handle_seg_list.

   end. /* MAINLOOP */

   hide frame hdr.

END PROCEDURE.
