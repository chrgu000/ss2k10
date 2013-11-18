/* glcrfmt.p - GENERAL LEDGER CUSTOM REPORT FORMAT MAINTENANCE          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION:  7.0      LAST MODIFIED: 10/07/91   by: jms *F058*         */
/* REVISION:  7.3      LAST MODIFIED: 09/11/94   by: rmh *GM08*         */
/* REVISION:  7.3      LAST MODIFIED: 11/06/94   by: rwl *GO24*         */
/* REVISION:  8.6      LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7  BY: John Pison DATE: 05/14/02 ECO: *N1HN* */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090616.1 By: Bill Jiang */

/* SS - 090616.1 - RNB
[090616.1]

修改于以下标准程序:
  - 自定义报表格式维护 [glcrfmt.p]

分配格式位置维护

增加了以下验证:
  - 定制代码[glr_code]: 必须在控制文件中已经定义

增加了以下字段:
  - 分配比例[SoftspeedIC_AR]: 用于指定该格式位置下账户的分配比例

[090616.1]

SS - 090616.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090616.1"}

define variable del-yn like mfc_logical initial no.
define variable sums_into like glrd_fpos.

/* SS - 090616.1 - B */
DEFINE VARIABLE SoftspeedIC_AR LIKE glrd_det.glrd_user1.
/* SS - 090616.1 - E */

define new shared variable glrd_recno as recid.
define new shared variable glr_recno as recid.

define buffer g1 for glrd_det.

/* DISPLAY SELECTION FORM */
form
   glr_code       colon 25
   glr_title      colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   glrd_fpos      colon 25
   glrd_desc      colon 25
   glrd_sums      colon 25
   glrd_dr_cr     colon 25
   glrd_page      colon 25
   glrd_header    colon 25
   glrd_total     colon 25
   glrd_skip      colon 25
   glrd_underln   COLON 25
   /* SS - 090616.1 - B */
   SoftspeedIC_AR   COLON 25
   /* SS - 090616.1 - E */

with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* DISPLAY */
view frame a.
view frame b.
mainloop:
repeat with frame a:
   clear frame b no-pause.
   prompt-for glr_code
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i glr_mstr glr_code  " glr_mstr.glr_domain = global_domain and
      glr_code "  glr_code glr_code glr_code}

      if recno <> ? then display glr_code glr_title.
   end.

   /* ADD/MOD/DELETE  */
find glr_mstr using  glr_code where glr_mstr.glr_domain = global_domain
no-error.
   if not available glr_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}   /* Adding new record */
      create glr_mstr. glr_mstr.glr_domain = global_domain.
      assign glr_code.

      if recid(glr_mstr) = -1 then .
   end.
   else do:
      /* Modifying existing record */
      {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
   end.

   recno = recid(glr_mstr).

   ststatus  =  stline[2].
   status input ststatus.
   del-yn = no.

   /* SS - 090616.1 - B */
   FIND FIRST mfc_ctrl 
      WHERE mfc_domain = GLOBAL_domain 
      AND mfc_field = "SoftspeedIC_glr_code_ie"
      AND mfc_char = glr_code
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETRY.
   END.
   /* SS - 090616.1 - E */

   display glr_title.
   loopa:
   do on error undo, retry:
      set glr_title go-on("F5" "CTRL-D").

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo loopa.
      end.

      if del-yn then do:
         /*DELETE ALL CUSTOM REPORT DETAIL RECORDS */

         for each glrd_det  where glrd_det.glrd_domain = global_domain and
         glrd_code = glr_code exclusive-lock:
            delete glrd_det.
         end.
         delete glr_mstr.
         clear frame a.
         del-yn = no.
         next mainloop.
      end.
      glr_recno = recid(glr_mstr).

      detloop:
      repeat with frame b:

         prompt-for glrd_fpos
         editing:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i glrd_det glrd_code " glrd_det.glrd_domain = global_domain
            and glrd_code  = glr_code and
                 glrd_fpos <> 0" glrd_fpos glrd_fpos}

            if recno <> ? then do:
               display glrd_fpos glrd_desc
                  glrd_sums glrd_dr_cr glrd_page
                  glrd_header glrd_total glrd_skip glrd_underln
                  /* SS - 090616.1 - B */
                  glrd_user1 @ SoftspeedIC_AR
                  /* SS - 090616.1 - E */
                  .
            end.

         end.

         /* FORMAT POSITION CANNOT BE EQUAL TO ZERO */
         if input glrd_fpos = 0 then do:
            {pxmsg.i &MSGNUM=3012 &ERRORLEVEL=3} /* INVALID FORMAT POSITION */
            undo detloop, retry.
         end.

         /* ADD/MOD/DELETE  */
         find glrd_det  where glrd_det.glrd_domain = global_domain and
         glrd_code = glr_code and
            glrd_fpos = input glrd_fpos no-error.
         if not available glrd_det  then do:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}   /* Adding new record */
            create glrd_det. glrd_det.glrd_domain = global_domain.
            assign glrd_fpos
               glrd_code = glr_code
               glrd_dr_cr = yes
               glrd_page   = no
               glrd_header = no
               glrd_total = no.

            if recid(glrd_det) = -1 then .
         end.
         recno = recid(glrd_det).
         glrd_recno = recno.

         ststatus  =  stline[2].
         status input ststatus.
         del-yn = no.

         display glrd_desc glrd_sums glrd_dr_cr glrd_page
            glrd_header glrd_total glrd_skip glrd_underln
            /* SS - 090616.1 - B */
            glrd_user1 @ SoftspeedIC_AR
            /* SS - 090616.1 - E */
            .

         loopb:
         do on error undo, retry:
            set glrd_desc glrd_sums glrd_dr_cr glrd_page
               glrd_header glrd_total glrd_skip glrd_underln
               /* SS - 090616.1 - B */
               SoftspeedIC_AR
               /* SS - 090616.1 - E */
               go-on("F5" "CTRL-D").

            /* DELETE */
            if lastkey = keycode("F5") or
               lastkey = keycode("CTRL-D") then do:
               del-yn = yes.
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn = no then undo loopb.
            end.

            if del-yn then do:
               /* CHECK FOR FORMAT POSITIONS USING FORMAT POSITION
               FOR SUMS INTO */
               sums_into = glrd_fpos.
               if can-find (first g1  where g1.glrd_domain = global_domain and
               g1.glrd_sums = sums_into
                  and g1.glrd_code = glr_code) then do:
                  {pxmsg.i &MSGNUM=3042 &ERRORLEVEL=3} /* CANNOT DELETE--FORMAT
                  POSITION USED AS 'SUMS INTO' */
                  undo loopb.
               end.

               /* OK TO DELETE */
               delete glrd_det.
               clear frame b.
               del-yn = no.
               next detloop.
            end.

            else do:
               if glrd_det.glrd_sums = glrd_det.glrd_fpos then do:
                  {pxmsg.i &MSGNUM=3012 &ERRORLEVEL=3}
                  /* INVALID FORMAT POSITION */
                  next-prompt glrd_det.glrd_sums with frame b.
                  undo loopb, retry.
               end.

               if not can-find(g1  where g1.glrd_domain = global_domain and
               g1.glrd_fpos =
                  glrd_det.glrd_sums and g1.glrd_code = glr_code) and
                  glrd_det.glrd_sums <> 0 then do:
                  {pxmsg.i &MSGNUM=3012 &ERRORLEVEL=3}
                  /* INVALID FORMAT POSITION */
                  next-prompt glrd_det.glrd_sums with frame b.
                  undo loopb, retry.
               end.

               /* CHECK FOR CYCLICAL FORMAT POSITIONS */
               {gprun.i ""glcrfmta.p""}
               if glrd_recno = 0 then do:
                  {pxmsg.i &MSGNUM=3043 &ERRORLEVEL=3}
                  /*CYCLICAL FORMAT POSITION*/
                  next-prompt glrd_det.glrd_sums with frame b.
                  undo loopb, retry.
               end.

               /* SS - 090616.1 - B */
               FIND FIRST CODE_mstr 
                  WHERE CODE_domain = GLOBAL_domain
                  AND CODE_fldname = "SoftspeedIC_AR"
                  AND CODE_value = SoftspeedIC_AR
                  NO-LOCK NO-ERROR.
               IF NOT AVAILABLE CODE_mstr THEN DO:
                  {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
                  /* Invalid entry */
                  next-prompt SoftspeedIC_AR with frame b.
                  undo loopb, retry.
               END.

               ASSIGN 
                  glrd_det.glrd_user1 = SoftspeedIC_AR
                  .
               /* SS - 090616.1 - E */

            end.
         end.
      end.
   end.
end.
status input.
