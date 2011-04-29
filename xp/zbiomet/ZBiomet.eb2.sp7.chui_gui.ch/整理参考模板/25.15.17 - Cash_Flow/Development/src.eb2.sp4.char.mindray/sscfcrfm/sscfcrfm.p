/* glcrfmt.p - GENERAL LEDGER CUSTOM REPORT FORMAT MAINTENANCE          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION:  7.0      LAST MODIFIED: 10/07/91   by: jms *F058*         */
/* REVISION:  7.3      LAST MODIFIED: 09/11/94   by: rmh *GM08*         */
/* REVISION:  7.3      LAST MODIFIED: 11/06/94   by: rwl *GO24*         */
/* REVISION:  8.6      LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7 $    BY: John Pison            DATE: 05/14/02  ECO: *N1HN*  */
/* $Revision: 1.7 $    BY: Bill Jiang            DATE: 12/13/07  ECO: *SS - 20071213.1*  */

/* SS - 20071213.1 - B */
/*
1. 增加了以下客户化字段:
   glrd_user1:0 - 所有发生额,1 - 借方发生额,2 - 贷方发生额
*/
/* SS - 20071213.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable del-yn like mfc_logical initial no.
define variable sums_into like glrd_fpos.

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
   /* SS - 20071213.1 - B */
   glrd_user1      colon 25
   /* SS - 20071213.1 - E */
   glrd_sums      colon 25
   glrd_dr_cr     colon 25
   glrd_page      colon 25
   glrd_header    colon 25
   glrd_total     colon 25
   glrd_skip      colon 25
   glrd_underln   colon 25
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
      {mfnp.i glr_mstr glr_code glr_code glr_code glr_code glr_code}

      if recno <> ? then display glr_code glr_title.
   end.

   /* ADD/MOD/DELETE  */
   find glr_mstr using glr_code no-error.
   if not available glr_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}   /* Adding new record */
      create glr_mstr.
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

         for each glrd_det where glrd_code = glr_code exclusive-lock:
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
            {mfnp05.i glrd_det glrd_code "glrd_code = glr_code and
                 glrd_fpos <> 0" glrd_fpos glrd_fpos}

            if recno <> ? then do:
               display glrd_fpos glrd_desc
                  /* SS - 20071213.1 - B */
                  glrd_user1
                  /* SS - 20071213.1 - E */
                  glrd_sums glrd_dr_cr glrd_page
                  glrd_header glrd_total glrd_skip glrd_underln.
            end.

         end.

         /* FORMAT POSITION CANNOT BE EQUAL TO ZERO */
         if input glrd_fpos = 0 then do:
            {pxmsg.i &MSGNUM=3012 &ERRORLEVEL=3} /* INVALID FORMAT POSITION */
            undo detloop, retry.
         end.

         /* ADD/MOD/DELETE  */
         find glrd_det where glrd_code = glr_code and
            glrd_fpos = input glrd_fpos no-error.
         if not available glrd_det  then do:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}   /* Adding new record */
            create glrd_det.
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

         display glrd_desc 
            /* SS - 20071213.1 - B */
            glrd_user1
            /* SS - 20071213.1 - E */
            glrd_sums glrd_dr_cr glrd_page
            glrd_header glrd_total glrd_skip glrd_underln.

         loopb:
         do on error undo, retry:
            set glrd_desc 
               /* SS - 20071213.1 - B */
               glrd_user1
               /* SS - 20071213.1 - E */
               glrd_sums glrd_dr_cr glrd_page
               glrd_header glrd_total glrd_skip glrd_underln
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
               if can-find (first g1 where g1.glrd_sums = sums_into
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

               if not can-find(g1 where g1.glrd_fpos =
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
            end.
         end.
      end.
   end.
end.
status input.
