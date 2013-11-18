/* glcrmt.p - GL CUSTOM REPORT MAINTENANCE                              */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 4.0      LAST MODIFIED: 03/12/88   BY: PML                 */
/* REVISION: 4.0      LAST MODIFIED: 04/08/88   BY: FLM *A197*          */
/*                                 : 09/29/88   by: jms *A460*          */
/*                                 : 02/21/89   by: jms *A656*          */
/* REVISION: 5.0      LAST MODIFIED: 05/22/89   by: jms *B138*          */
/* REVISION: 6.0      LAST MODIFIED: 09/24/90   by: jms *D034*          */
/* REVISION: 7.0      LAST MODIFIED: 09/11/91   by: jms *F058*          */
/*                                   06/17/92   by: jms *F661*          */
/*                                   08/03/92   by: jms *F830*          */
/*                                   08/12/92   by: jms *F843*          */
/*                                   09/28/92   by: jms *G104*          */
/* Oracle changes (share-locks)    09/11/94           BY: rwl *FR18*    */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Revision: 1.8  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.9 $    BY: Rafiq S.             DATE: 08/29/06  ECO: *P537*  */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                              */

/* SS - 090520.1 By: Bill Jiang */

/* SS - 090520.1 - RNB
[090520.1]

修改于以下标准程序:
  - 自定义报表账户维护 [glcrmt.p]

注意,本程序因程序名而异:
  - xxicampt.p: 零件分配范围维护
  - xxicampl.p: 产品线分配范围维护
  - xxicamcc.p: 适用于标准加工单的在制品成本中心分配范围维护
  - xxicamln.p: 适用于累计加工单的生产线分配范围维护

增加了以下验证:
  - 定制代码[glr_code]: 必须在控制文件中已经定义

[090520.1]

SS - 090520.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "090520.1"}

define variable del-yn  like mfc_logical initial no.
define variable linenum like glrd_line.
define variable acc_end like glrd_acct.
define variable sub_end like glrd_sub.
define variable cc_end  like glrd_cc.
define variable use_sub like co_use_sub.
define variable use_cc  like co_use_cc.
define buffer g1 for glrd_det.

/* DISPLAY SELECTION FORM */
form
   glr_code       colon 25
   glr_title      colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   glrd_line      colon 25   skip(1)
   /* SS - 090520.1 - B
   glrd_acct      colon 25   
   glrd_acct1 colon 40 label "To"
   glrd_sub       colon 25   glrd_sub1  colon 40 label "To"
   glrd_cc        colon 25   glrd_cc1   colon 40 label "To"
   SS - 090520.1 - E */
   /* SS - 090520.1 - B */
   glrd_acct      colon 25   FORMAT "x(18)"
   glrd_acct1 colon 25 label "To" FORMAT "x(18)"
   /* SS - 090520.1 - E */
   glrd_sums      colon 25
with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* SS - 090520.1 - B */
DEFINE VARIABLE FIELD_mfc LIKE mfc_field.

IF execname = "xxicampt.p" THEN DO:
   glrd_acct:FORMAT IN FRAME b = "x(18)".
   glrd_acct1:FORMAT IN FRAME b = "x(18)".
   FIELD_mfc = "SoftspeedIC_to_pt".
END.
ELSE IF execname = "xxicampl.p" THEN DO:
   glrd_acct:FORMAT IN FRAME b = "x(4)".
   glrd_acct1:FORMAT IN FRAME b = "x(4)".
   FIELD_mfc = "SoftspeedIC_to_pl".
END.
ELSE IF execname = "xxicamcc.p" THEN DO:
   glrd_acct:FORMAT IN FRAME b = "x(4)".
   glrd_acct1:FORMAT IN FRAME b = "x(4)".
   FIELD_mfc = "SoftspeedIC_to_cc".
END.
ELSE IF execname = "xxicamln.p" THEN DO:
   glrd_acct:FORMAT IN FRAME b = "x(8)".
   glrd_acct1:FORMAT IN FRAME b = "x(8)".
   FIELD_mfc = "SoftspeedIC_to_ln".
END.
/* SS - 090520.1 - E */

/* READ GL CONTROL FILE */
find first co_ctrl
   where co_ctrl.co_domain = global_domain
no-lock no-error.

if not available co_ctrl
then do:
   /*CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT*/
   {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
   pause.
   leave.
end. /* IF NOT AVAILABLE co_ctrl */

assign
   use_cc  = co_use_cc
   use_sub = co_use_sub.

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

      if recno <> ?
      then
         display
            glr_code
            glr_title.
   end. /* EDITING */

   /* ADD/MOD/DELETE  */
   find glr_mstr using  glr_code
      where glr_mstr.glr_domain = global_domain
   no-error.
   if not available glr_mstr then do:
      {pxmsg.i &MSGNUM=3047 &ERRORLEVEL=3} /* REPORT CODE NOT FOUND */
      undo mainloop, retry.
   end.

   /* SS - 090520.1 - B */
   FIND FIRST mfc_ctrl 
      WHERE mfc_domain = GLOBAL_domain 
      AND mfc_field = FIELD_mfc
      AND mfc_char = glr_code
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETRY.
   END.
   /* SS - 090520.1 - E */

   recno = recid(glr_mstr).
   display glr_title.

   ststatus  =  stline[2].
   status input ststatus.
   del-yn = no.

   loopa:
   do on error undo, retry:
      set glr_title go-on("F5" "CTRL-D").

      /* DELETE */
      if lastkey = keycode("F5") or
         lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no
         then
            undo loopa.
      end. /* IF LASTKEY */

      if del-yn
      then do:
         for each glrd_det exclusive-lock
            where glrd_det.glrd_domain = global_domain
            and   glrd_code            = glr_code:

            delete glrd_det.
         end. /* FOR EACH glrd_det */
         delete glr_mstr.
         clear frame a.
         del-yn = no.
         next mainloop.
      end. /* IF del-yn */
   end. /* loopa */

   find last glrd_det
      where glrd_det.glrd_domain = global_domain
      and   glrd_code            = glr_code
      and   glrd_fpos            = 0
   use-index glrd_code no-lock no-error.

   if available glrd_det
   then
      linenum = glrd_line + 1.
   else
      linenum = 1.

   display linenum @ glrd_line with frame b.

   detloop:
   repeat with frame b:
      prompt-for glrd_line
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i glrd_det glrd_code " glrd_det.glrd_domain = global_domain
              and glrd_code  = glr_code and
              glrd_fpos = 0
            " glrd_line glrd_line}

         if recno <> ?
         then do:
            acc_end = glrd_acct1.
            if acc_end = hi_char
            then
               acc_end = "".
            sub_end = glrd_sub1.
            if sub_end = hi_char
            then
               sub_end = "".
            cc_end = glrd_cc1.
            if cc_end = hi_char
            then
            cc_end = "".
            display
               glrd_line
               glrd_acct
               acc_end @ glrd_acct1
               /* SS - 090520.1 - B
               glrd_sub sub_end @ glrd_sub1
               glrd_cc cc_end @ glrd_cc1
               SS - 090520.1 - E */
               glrd_sums.
         end. /* IF rscno <> ? */
      end. /* EDITING */

      /* ADD/MOD/DELETE  */
      if input glrd_line = 0
      then do:
         find last glrd_det
            where glrd_det.glrd_domain = global_domain
            and   glrd_code            = glr_code
            and   glrd_fpos            = 0
         use-index glrd_code
         no-lock no-error.

         if available glrd_det
         then
            linenum = glrd_line + 1.
         else
            linenum = 1.
         display linenum @ glrd_line with frame b.
      end. /* IF INPUT glrd_line = 0 */
      find glrd_det
         where glrd_det.glrd_domain = global_domain
         and   glrd_code            = glr_code
         and   glrd_fpos            = 0
         and   glrd_line            = input glrd_line
      no-error.

      if not available glrd_det
      then do:
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}   /* Adding new record */
         create glrd_det.
         glrd_det.glrd_domain = global_domain.
         assign glrd_code = glr_code
            glrd_line.
      end. /* IF NOT AVAILABLE glrd_det */
      recno = recid(glrd_det).

      ststatus  =  stline[2].
      status input ststatus.
      del-yn = no.

      if glrd_acct1 = hi_char
      then
         glrd_acct1 = "".
      if glrd_sub1  = hi_char
      then
         glrd_sub1  = "".
      if glrd_cc1   = hi_char
      then
         glrd_cc1   = "".

      display
         glrd_acct
         glrd_acct1
         /* SS - 090520.1 - B
         glrd_sub
         glrd_sub1
         glrd_cc
         glrd_cc1
         SS - 090520.1 - E */
         glrd_sums.

      loopb:
      do on error undo, retry:
         set
            glrd_acct
            glrd_acct1
            /* SS - 090520.1 - B
            glrd_sub when (use_sub)
            glrd_sub1 when (use_sub)
            glrd_cc when (use_cc)
            glrd_cc1 when (use_cc)
            SS - 090520.1 - E */
            glrd_sums go-on("F5" "CTRL-D").

         /* DELETE */
         if lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn = no
            then
               undo loopb.
         end. /* IF LASTKEY */

         if del-yn
         then do:
            delete glrd_det.
            clear frame b.
            del-yn = no.
            next detloop.
         end. /* IF del-yn */

         else do:
            if not can-find(g1  where g1.glrd_domain = global_domain
                                and   g1.glrd_fpos   = glrd_det.glrd_sums
                                and   g1.glrd_code   = glr_code)
            then do:
               {pxmsg.i &MSGNUM=3012 &ERRORLEVEL=3}
               /* INVALID FORMAT POSITION */
               next-prompt glrd_sums with frame b.
               undo loopb, retry.
            end. /* IF NOT CAN-FIND g1 */
         end. /* ELSE DO */
      end. /* loopb */
   end. /* detloop */
end. /* mainloop */
status input.
