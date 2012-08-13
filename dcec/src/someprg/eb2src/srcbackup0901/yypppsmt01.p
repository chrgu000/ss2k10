/* pppsmt01.p - ITEM SITE INVENTORY MAINTENANCE                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.1.6 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.0      LAST MODIFIED: 10/09/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: pma *F087*          */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*          */
/* REVISION: 7.3      LAST MODIFIED: 08/12/93   BY: ram *GE15*          */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*          */
/* REVISION: 7.3      LAST MODIFIED: 06/06/94   BY: ais *FO63*          */
/* REVISION: 7.3      LAST MODIFIED: 06/28/94   BY: pxd *FP14*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/* REVISION: 8.5      LAST MODIFIED: 10/17/94   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 7.2      LAST MODIFIED: 05/04/95   BY: qzl *F0R6*          */
/* REVISION: 8.5      LAST MODIFIED: 12/05/96   BY: *G2HJ* Murli Shastri   */
/* REVISION: 8.5      LAST MODIFIED: 07/07/97   BY: *J1PS* Felcy D'Souza   */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 9.0      LAST MODIFIED: 02/22/99   BY: *M08Y* Niranjan R.     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *H1HP*                    */
/* $Revision: 1.10.1.6 $    BY: Zheng Huang           DATE: 01/31/02  ECO: *P000*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 8.5      LAST MODIFIED: 10/16/03   BY: Kevin               */
/* REVISION: eb2+sp6 retrofit     by tao fengqin  ECO *tfq*               */
/*FL60*/ {mfdtitle.i "b+ "}
define variable part like in_part.
define variable site like in_site.

define variable inrecno as recid no-undo.
&SCOPED-DEFINE PP_FRAME_NAME A
form 
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{ppptmta1.i}
   site colon 19 skip(.4)
with frame a side-labels width 80  attr-space NO-BOX THREE-D .

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

display site /*V8! skip(.4) */ with frame a.

display global_part @ pt_part global_site @ site with frame a.

form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   in_abc             colon 20
   in_iss_date        colon 58
   in_avg_int         colon 20
   in_avg_date        colon 58
   in_cyc_int         colon 20
   in_cnt_date        colon 58

   in_rctpo_status    colon 20
   in_rctpo_active    colon 37
   in_user1        colon 58 label "缺省库位"              /*tfq*/
   in_rctwo_status    colon 20
   in_rctwo_active    colon 37
   in__qadc01         colon 58 label "保管员"   skip(.4)              /*tfq*/
with frame c side-labels width 80 attr-space NO-BOX THREE-D .
DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:HIDDEN in frame c = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5.  /*GUI*/
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* DISPLAY */

mainloop:
repeat:

   view frame a.
   view frame c.

   do with frame a on endkey undo, leave mainloop:

      prompt-for pt_part site with no-validate
      editing:

         /* SET GLOBAL PART VARIABLE */

         assign global_part = input pt_part
            global_site = input site.

         if frame-field = "pt_part" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i in_mstr pt_part in_part site in_site in_part}
         end.
         else if frame-field = "site" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            /* Changed search index from "in_site" to "in_part" */
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i in_mstr site in_site in_part
               "input pt_part" in_part}
         end.
         else do:
            readkey.
            apply lastkey.
         end.

         if recno <> ? then do:
            find pt_mstr where pt_part = in_part no-lock no-error.

            if available pt_mstr then do:

               display {ppptmta1.i} with frame a.
               display in_part @ pt_part in_site @ site with frame a.

               if in_abc = ? then
               display
                  "" @ in_abc
                  "" @ in_avg_int
                  "" @ in_cyc_int
               with frame c.
               else
               display
                  in_abc
                  in_avg_int
                  in_cyc_int
                  in_iss_date
                  in_avg_date
                  in_cnt_date

                  in_rctpo_status
                  in_rctpo_active
                  in_user1                                  /*tfq*/
                  in_rctwo_status
                  in_rctwo_active
                  in__qadc01                                 /*tfq*/
               with frame c.
            end. /* if available pt_mstr */

         end. /* if recno <> ? */
      end. /* prompt-for pt_part site */

      /* ADD/MODIFY  */
      /*NOTE: DELETING THE IN_MSTR RECORD SHOULD NOT BE ALLOWED. */
      if not can-find (pt_mstr where pt_part = input pt_part) then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /* ITEM NUMBER IS NOT AVAILABLE */
         undo, retry.
      end.

      if not can-find (si_mstr where si_site = input site) then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* SITE IS NOT AVAILABLE */
         next-prompt site with frame a.
         undo, retry.
      end.

      find si_mstr where si_site = input site no-lock no-error.
      if available si_mstr and si_db <> global_db then do:
         {pxmsg.i &MSGNUM=5421 &ERRORLEVEL=3}
         /* SITE NOT ASSIGNED TO THIS DATABASE */
         next-prompt site with frame a.
         undo, retry.
      end.

      if available si_mstr then do:
         {gprun.i ""gpsiver.p""
            "(input site, input recid(si_mstr), output return_int)"}
         if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO SITE */
            next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.
      end.

      find pt_mstr where pt_part = input pt_part
      exclusive-lock no-error.
      if not available pt_mstr then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /* ITEM NUMBER IS NOT AVAILABLE */
         undo, retry.
      end.

      find ptp_det where ptp_part = pt_part
         and ptp_site = input site
      no-lock no-error.

      find in_mstr where in_part = pt_part
         and in_site = input site
      exclusive-lock no-error.

      /* NEW ITEM */
      if not available in_mstr then do:
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* CREATING NEW RECORD */


         assign site.
         {gprun.i ""gpincr.p"" "(input no,
              input pt_part,
              input site,
              input si_gl_set,
              input si_cur_set,
              input pt_abc,
              input pt_avg_int,
              input pt_cyc_int,
              input pt_rctpo_status,
              input pt_rctpo_active,
              input pt_rctwo_status,
              input pt_rctwo_active,
              output inrecno)"}

         find in_mstr where recid(in_mstr) = inrecno
         exclusive-lock.

         {gpsct04.i &type=""GL""}
         {gpsct04.i &type=""CUR""}

      end. /* if not available in_mstr */

      if in_abc = ? then in_abc = pt_abc.

      if in_avg_int = ? then  in_avg_int = pt_avg_int.
      if in_cyc_int= ? then in_cyc_int = pt_cyc_int.

      display {ppptmta1.i} with frame a.
      display in_part @ pt_part in_site @ site with frame a.
      display
         in_abc
         in_iss_date
         in_avg_int
         in_avg_date
         in_cyc_int
         in_cnt_date

         in_rctpo_status
         in_rctpo_active
         in_user1                           /*tfq*/
         in_rctwo_status
         in_rctwo_active
         in__qadc01                          /*tfq*/
      with frame c.

      setc:
      do with frame c on error undo setc, retry:
         set in_abc in_avg_int in_cyc_int

            in_rctpo_status in_rctpo_active
            when ({gppswd3.i &field=""in_rctpo_status""})
            in_user1                           /*tfq*/
            in_rctwo_status in_rctwo_active
            when ({gppswd3.i &field=""in_rctwo_status""})
            in__qadc01                          /*tfq*/
         with frame c.
            /*added by tfq, 2005/06/23 to add a field to record the warehouse clerk*/
                  find loc_mstr where loc_site = in_site and loc_loc = input in_user1 no-lock no-error.
                  if not available loc_mstr then do:
                    /*tfq   {mfmsg.i 229 3} */
                     {pxmsg.i
               &MSGNUM=229
               &ERRORLEVEL=3
                         }

                       next-prompt in_user1 with frame c.
                       undo setc, retry setc.
                  end.
                  if pt_site = in_site and pt_loc <> input in_user1 then do:
                   message "提示: 与缺省地点的缺省库位不一致!".
                end.
                
                          
              find code_mstr where code_fldname = "in__qadc01" and code_value = input in__qadc01 
              no-lock no-error.
              if not available code_mstr then do:
                   message "错误: 通用代码中未定义请重新输入!" view-as alert-box error.
                   next-prompt in__qadc01 with frame c.
                   undo setc, retry setc.
              end.
                                        
/*end added by tfq, 2005/06/23*/
         if (in_rctpo_active or in_rctpo_status <> "") and
            not can-find (is_mstr where is_status = in_rctpo_status)
         then do:

            next-prompt in_rctpo_status.
            /* INVENTORY STATUS IS NOT DEFINED */
            {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
            undo setc, retry.

         end. /* IF (IN_RCTPO_ACTIVE ... */

         if (in_rctwo_active or in_rctwo_status <> "") and
            not can-find (is_mstr where is_status = in_rctwo_status)
         then do:

            next-prompt in_rctwo_status.
            /* INVENTORY STATUS IS NOT DEFINED */
            {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
            undo setc, retry.

         end. /* IF (IN_RCTWO_ACTIVE ... */

      end. /* setc: do with frame c */

   end. /* do with frame a */

end. /* main loop */

status input.

