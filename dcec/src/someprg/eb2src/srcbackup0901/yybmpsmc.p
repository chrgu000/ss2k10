/* bmpsmc.p - PRODUCT STRUCTURE COMPONENT MULTIPLE ADD/REPLACE/DELETE         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0         LAST EDIT: 06/11/90     MODIFIED BY: SMM *C197*      */
/* REVISION: 5.0         LAST EDIT: 11/26/90     MODIFIED BY: SXL *B831*      */
/* REVISION: 6.0         LAST EDIT: 12/11/90     MODIFIED BY: SXL *D249*      */
/* REVISION: 6.0         LAST EDIT: 03/05/91     MODIFIED BY: emb *D397*      */
/* REVISION: 7.0         LAST EDIT: 03/24/92     MODIFIED BY: pma *F089*      */
/* REVISION: 7.0         LAST EDIT: 03/24/92     MODIFIED BY: pma *F089*      */
/* REVISION: 7.0         LAST EDIT: 04/02/92     MODIFIED BY: emb *F346*      */
/* REVISION: 7.3         LAST EDIT: 07/29/93     MODIFIED BY: emb *GD82*      */
/* REVISION: 7.4         LAST EDIT: 10/12/93     MODIFIED BY: pma *H013*(rev) */
/* REVISION: 7.4         LAST EDIT: 01/26/94     MODIFIED BY: ais *FL64*      */
/* REVISION: 7.4         LAST EDIT: 03/16/94     MODIFIED BY: pxd *FL60*      */
/* REVISION: 7.4         LAST EDIT: 08/01/94     MODIFIED BY: jxz *FP79*      */
/* REVISION: 8.5         LAST EDIT: 12/18/94     MODIFIED BY: dzs *J011*      */
/* REVISION: 7.4         LAST EDIT: 05/03/95     MODIFIED BY: qzl *H0D3*      */
/* REVISION: 7.4         LAST EDIT: 12/15/95     MODIFIED BY: rwl *F0WR*      */
/* REVISION: 7.4         LAST EDIT: 01/24/96     MODIFIED BY: bcm *G1KV*      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/12/98   BY: *J34C* Sandesh Mahagaokar */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *N08H* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *N0F3* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 07/26/00   BY: *N0GX* Phil DeRogatis     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* Revision: 9.1      Last Modified: 08/29/00   BY: *N0PW* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.25     BY: Jean Miller            DATE: 12/14/01  ECO: *P03Q*  */
/* $Revision: 1.26 $    BY: Deepak Rao           DATE: 08/22/02  ECO: *N1RZ*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*Kevin(NOTES): Added a new function, change 'part1" must be a item
         to can be just a bom code****************************/
/*TFQ RETROFIT ON EB2+SP6 */         
/*********************************************************/
/* NOTES:   1. Patch FL60 sets in_level to a value       */
/*             of 999999 when in_mstr is created or      */
/*             when any structure or network changes are */
/*             made that affect the low level codes.     */
/*          2. The in_levels are recalculated when MRP   */
/*             is run or can be resolved by running the  */
/*             mrllup.p utility program.                 */
/*********************************************************/

{mfdtitle.i "2+ "}

define variable part     like pt_part  label "Existing Item".
define variable part1    like pt_part  label "New Item".
define variable effdate  like ps_start label "Effective".
define variable ptum     like pt_um.
define variable ptum2    like pt_um.
define variable ptdesc1  like pt_desc1.
define variable ptdesc2  like pt_desc2.
define variable continue like mfc_logical no-undo.

define buffer psmstr  for ps_mstr.

define new shared variable ps_recno as recid.
define new shared variable parent like ps_par.
define new shared variable comp like ps_comp.

define variable action as character format "!(1)".
define variable ad_rep_title as character format "x(60)".
define variable unknown_char as character initial ?.
define variable ptstatus like pt_status.
define variable conflicts like mfc_logical.
define variable disp-char1  as character format "x(40)" no-undo.
define variable disp-char6  as character format "x(40)" no-undo.
define variable disp-char10 as character format "x(40)" no-undo.
define variable disp-char11 as character format "x(35)" no-undo.
define variable msg-text1   like msg_desc no-undo.
define variable msg-text2   like msg_desc no-undo.
/**********tfq added begin********************************/
define buffer xxptmp-mstr for xxptmp_mstr .
/*************tfq added end********************************/
 def var part_yn like mfc_logical.             /*kevin,means whether input part is a item*/
assign
   disp-char1  = "A - " + getTermLabel("ADD_NEW_COMPONENT_ITEM",35)
   disp-char6  = "D - " + getTermLabel("DELETE_EXISTING_COMPONENT_ITEM",35)
   disp-char10 = "R - " + getTermLabel("REPLACE_EXISTING_COMPONENT_ITEM",35)
   disp-char11 = getTermLabel("WITH_NEW_COMPONENT_ITEM",35).

/* For all effective product structures where component item exists*/
{pxmsg.i &MSGNUM=3700 &ERRORLEVEL=1 &MSGBUFFER=msg-text1}
msg-text1 = msg-text1 + ":".

/* NOTE: This process is incompatible with PCO controlled changes */
{pxmsg.i &MSGNUM=3711 &ERRORLEVEL=1 &MSGBUFFER=msg-text2}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   /* For all effective structures where compnt item exists */
   msg-text1    at 2 no-label
   msg-text2    at 2 no-label
   skip(1)
   effdate      colon 23
   part         colon 23 ptdesc1 at 45 no-label
   ptum         colon 23 ptdesc2 at 45 no-label
   skip(1)
   action       colon 23 label "Action"
   disp-char1   no-label at 30
   disp-char6   no-label at 30
   disp-char10  no-label at 30
   disp-char11  no-label at 42
SKIP(.4)  /*GUI*/
with frame a width 80 side-labels NO-BOX THREE-D /*GUI*/.

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

form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   part1 colon 23 ptdesc1 at 45 no-label
   ptum2 colon 23 ptdesc2 at 45 no-label
  SKIP(.4)  /*GUI*/
with frame b width 80 side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/  psmstr with frame copy THREE-D /*GUI*/.

effdate = today.

display
   msg-text1
   msg-text2
   disp-char1
   disp-char6
   disp-char10
   disp-char11
with frame a.
view frame b.

repeat:

   update
      effdate
      part
      action
      with frame a
   editing:

      if frame-field = "part" then do:

         {mfnp.i ps_mstr part ps_comp part ps_comp ps_comp}

         if recno <> ? then do with frame a:
            find pt_mstr no-lock where pt_part = ps_comp no-error.
            if available pt_mstr then
            display
               pt_part @ part
               pt_desc1 @ ptdesc1
               pt_desc2 @ ptdesc2
               pt_um @  ptum.
            else
            display
               ps_comp @ part
               " " @ ptdesc1
               " " @ ptdesc2
               " " @ ptum.
         end.
         recno = ?.

      end. /* Editing */
      else do:
         readkey.
         apply lastkey.
      end.
   end.
 part_yn = yes.                         /*kevin*/
   find pt_mstr no-lock where pt_part = part no-error.
   if available pt_mstr then do with frame a:
      display
         pt_desc1 @ ptdesc1
         pt_desc2 @ ptdesc2
         pt_um @ ptum.
   end.
   else do with frame a:
      display
         " " @ ptdesc1
         " " @ ptdesc2
         " " @ ptum.
      {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}
        part_yn = no.                     /*kevin*/ 
   end.

   if not can-find (first ps_mstr where ps_comp = part) then do:
      {pxmsg.i &MSGNUM=100 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* VALIDATE ACTION */
   if (index("ARD",action)) = 0 then do:
      /* ACTION REQUESTED MUST BE (A)DD, (D)ELETE or (R)EPLACE */
      {pxmsg.i &MSGNUM=3554 &ERRORLEVEL=3}
      next-prompt action with frame a.
      undo,retry.
   end.

   if action = "A" or action = "R" then do on error undo, retry:

      set part1
         with frame b
      editing:

         {mfnp.i pt_mstr part1 pt_part part1 pt_part pt_part}

         if recno <> ? then do with frame b:
            display
               pt_part @ part1
               pt_desc1 @ ptdesc1
               pt_desc2 @ ptdesc2
               pt_um @  ptum2.
         end.

      end. /* EDITING */

      /* VALIDATE PART */
      if part = part1 then do:
         /* ITEM NUMBER MUST BE DIFFERENT */
         {pxmsg.i &MSGNUM=3555 &ERRORLEVEL=3}
         undo,retry.
      end.

      find pt_mstr no-lock where pt_part = part1 no-error.
      if available pt_mstr then do with frame b:

         ptstatus = pt_status.
         substring(ptstatus,9,1) = "#".
         if can-find(isd_det where isd_status = ptstatus
                               and isd_tr_type = "ADD-PS")
         then do:
            {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
            undo, retry.
         end.

         part1 = pt_part.
         display
            pt_desc1 @ ptdesc1
            pt_desc2 @ ptdesc2
            pt_um @ ptum2.

      end.

      else do with frame b:
      /*********marked by kevin******
         display " " @ ptdesc1 " " @ ptdesc2 " " @ ptum2.
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
         undo, retry.
        **** end marked by kevin*/
         /******added by kevin***************/
                if part_yn then do:
		        display " " @ ptdesc1 " " @ ptdesc2 " " @ ptum2.
		   /*tfq     {mfmsg.i 16 3}   */
		   {pxmsg.i
               &MSGNUM=16
               &ERRORLEVEL=3
                          }
		        undo, retry. 
		  end.
		  else do:
		        find bom_mstr where bom_parent = part1 no-lock no-error.
		        if not available bom_mstr then do:
		            message "零件号、或产品结构代码都不存在" view-as alert-box error.
		            undo,retry.
		        end.
		        else do:
		            disp bom_desc @ ptdesc2 bom_batch_um @ ptum2.
		        end.
		  end. /*if not part_yn*/
/****************end added by kevin**************/
      end.

   end.

   else do:
      part1 = "".
      clear frame b.
      hide frame b.
   end.

   continue = no.
   {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=continue}
   if not continue
   then
      undo, retry.

   copy:
   do transaction:

      if can-find (first ps_mstr where ps_comp = part)
      then do:
         if action = "R" or action = "D" then do:
            {inmrp.i &part=part   &site=unknown_char}
         end.
         if action = "A" then do:
            {inmrp.i &part=part1  &site=unknown_char}
         end.
      end.

      for each ps_mstr where ps_comp = part
            and (effdate = ?
            or ((ps_start <= effdate or ps_start = ?)
            and (ps_end >= effdate or ps_end = ?)))
            and ps_ps_code <> "J":

         if action = "A" or action = "R" then do:

            find psmstr where
                   psmstr.ps_par = ps_mstr.ps_par
               and psmstr.ps_comp = part1
               and psmstr.ps_ref = ps_mstr.ps_ref
               and psmstr.ps_start = ps_mstr.ps_start
               and psmstr.ps_ps_code <> "J"
            no-error.

            if not available psmstr then do:

               conflicts = false.

               for each psmstr no-lock
                  where psmstr.ps_par = ps_mstr.ps_par
                    and psmstr.ps_comp = part1
                    and psmstr.ps_ref = ps_mstr.ps_ref
                    and psmstr.ps_ps_code <> "J"
                    and (
                     (psmstr.ps_end = ? and ps_mstr.ps_end = ?)
                  or (psmstr.ps_start = ? and ps_mstr.ps_start = ?)
                  or (psmstr.ps_start = ? and psmstr.ps_end = ?)
                  or (ps_mstr.ps_start = ? and ps_mstr.ps_end = ?)
                  or ((ps_mstr.ps_start >= psmstr.ps_start
                  or psmstr.ps_start = ?)
                    and ps_mstr.ps_start <= psmstr.ps_end)
                     or (ps_mstr.ps_start <= psmstr.ps_end
                    and ps_mstr.ps_end >= psmstr.ps_start) ):

                  conflicts = true.
                  leave.

               end.

               if conflicts then do:
                  {pxmsg.i &MSGNUM=122 &ERRORLEVEL=3}
                  undo copy, leave copy.
               end.

               if action = "A" then do:

                  find psmstr where psmstr.ps_par = ps_mstr.ps_par
                     and psmstr.ps_comp = part
                     and psmstr.ps_ref = ps_mstr.ps_ref
                     and psmstr.ps_start = ps_mstr.ps_start
                     and psmstr.ps_ps_code <> "J"
                  no-error.

                  if opsys = "unix" then
                     output to "/dev/null".
                  else
                  if opsys = "msdos" or opsys = "win32" then
                     output to "nul".
                  else if opsys = "vms" then
                     output to "nl:".
                  else if opsys = "btos" then
                     output to "[nul]".

                  display psmstr with frame copy.
                  display part1 @ psmstr.ps_comp with frame copy.

                  output close.

                  create psmstr.
                  assign psmstr.

                  ps_recno = recid(psmstr).
                  ps_mstr.ps_mod_date = today.
                  ps_mstr.ps_userid = global_userid.

               end.

               if action = "R" then do:
                  ps_mstr.ps_comp = part1.
                  ps_mstr.ps_mod_date = today.
                  ps_mstr.ps_userid = global_userid.
                  ps_recno = recid(ps_mstr).
               end.

               /* CYCLIC PRODUCT STRUCTURE CHECK */
               {gprun.i ""bmpsmta.p""}

               if ps_recno = 0 then do:
                  {pxmsg.i &MSGNUM=206 &ERRORLEVEL=3}
                  /* CYCLIC PRODUCT STRUCTURE NOT ALLOWED. */
                  undo copy, leave copy.
               end.

               for each in_mstr exclusive-lock where in_part = ps_mstr.ps_comp
                  and not can-find (ptp_det where ptp_part = in_part
                                              and ptp_site = in_site):
                  if available in_mstr then
                     in_level = 99999.
               end.

               for each ptp_det where ptp_part = ps_mstr.ps_comp:
                  find in_mstr where in_part = ptp_part and
                                     in_site =  ptp_site
                  exclusive-lock no-error.
                  if available in_mstr then
                     in_level = 99999.
               end.

            end. /* IF NOT Available*/

            else do:
               {pxmsg.i &MSGNUM=260 &ERRORLEVEL=3}
               /* Product structure already exists */
               undo copy, leave copy.
            end.

         end. /*if action = A or R */

         {inmrp.i &part=ps_mstr.ps_par  &site=unknown_char}

         /* ADDED CALL TO bmpsmtd.p TO SET THE in_mrp FLAG OF THE PARENT OF */
         /* A LOCAL PHANTOM WHEN ITS COMPONENT IS ADDED/DELETED/REPLACED.   */
         {gprun.i ""bmpsmtd.p"" "(ps_mstr.ps_par)" }

         if action = "D" then do:
            delete ps_mstr.
         end.

      end. /*For Each*/
        /*********tfq added begin**************************/
        {gprun.i ""yybmpsmc1.p"" "(input part ,
                                   input part1,
                                   input action)"}
        
        /*************tfq added end****************************/
   end. /*Transaction*/

end. /* REPEAT LOOP */

