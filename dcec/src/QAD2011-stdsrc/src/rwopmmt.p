/* GUI CONVERTED from rwopmmt.p (converter v1.78) Fri Aug 12 04:08:06 2011 */
/* rwopmmt.p - STANDARD OPERATION MAINTENANCE                           */
/* Copyright 1986-2011 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 4.0      LAST MODIFIED: 03/18/88   BY: WUG *A194*/
/* REVISION: 5.0      LAST MODIFIED: 07/06/89   BY: emb *B169*/
/* REVISION: 6.0      LAST MODIFIED: 07/17/92   BY: emb *F778*/
/* REVISION: 7.3      LAST MODIFIED: 11/10/92   BY: emb *G689*/
/* REVISION: 7.3      LAST EDIT:     02/24/93   BY: sas *G740**/
/* REVISION: 7.3      LAST EDIT:     06/02/93   BY: dzs *GB32**/
/* Oracle changes (share-locks)    09/13/94           BY: rwl *GM49*    */
/* REVISION: 8.5      LAST MODIFIED: 01/13/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 02/22/96   BY: *G1MB* Sue Poland   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 07/29/98   BY: *J2V1* Rajesh Talele*/
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.3  BY: Katie Hilbert      DATE: 03/19/03 ECO: *P0MW* */
/* Revision: 1.9.1.5  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.9.1.6 $ BY: Anandhakumar K DATE: 08/11/11  ECO: *Q4ZP* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* DISPLAY TITLE */
/*V8:ConvertMode=Maintenance                                            */
{mfdtitle.i "1+ "}

define new shared variable cmtindx     as integer.

define            variable description like pt_desc1.
define            variable del-yn      like mfc_logical initial no.
define            variable opmcmmts    like mfc_logical
                                       initial no label "Comments".

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
opm_std_op     colon 30
   opm_desc       colon 30
   opm_wkctr      colon 30
   opm_mch        colon 30
   skip(1)
   opm_setup      colon 30
   opm_run        colon 30
   opm_move       colon 30
   skip(1)
   opm_yld_pct    colon 30
   opm_tool       colon 30
   opm_vend       colon 30
   opm_mile       colon 30
   opm_inv_val    colon 30
   opm_sub_cost   colon 30
   opm_sub_lead   colon 30
   opm_tran_qty   colon 30
   opmcmmts       colon 30
 SKIP(.4)  /*GUI*/
with frame a width 80 side-labels attr-space NO-BOX THREE-D /*GUI*/.

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

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   prompt-for opm_std_op
   editing:
      /* FIND NEXT/PREVIOUS RECORD */

      /* NEXT/PREV THROUGH ONLY THE NON-SERVICE OPERATIONS */
      {mfnp05.i opm_mstr opm_std_op " opm_mstr.opm_domain = global_domain and
      opm_fsm_type  = "" "" "
         opm_std_op "input opm_std_op"}

      if recno <> ? then do:
         display
            opm_std_op
            opm_desc
            opm_wkctr
            opm_mch
            opm_setup
            opm_run
            opm_move
            opm_yld_pct
            opm_tool
            opm_vend
            opm_mile
            opm_inv_val
            opm_sub_cost
            opm_sub_lead
            opm_tran_qty.
         if opm_cmtindx <> 0 then
            display yes @ opmcmmts.
         else
            display no @ opmcmmts.
      end.
   end.

   /* ADD/MOD/DELETE */

   find opm_mstr
       where opm_mstr.opm_domain = global_domain and  opm_std_op = input
       opm_std_op
   no-error.
   if not available opm_mstr then do:

      /* DON'T LET THE USER CREATE BLANK STANDARD OPERATIONS */
      if input opm_std_op = " " then do:
         /* BLANK NOT ALLOWED */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         undo, retry.
      end. /* if input opm_std_op = " " */

      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create opm_mstr. opm_mstr.opm_domain = global_domain.
      assign
         opm_std_op
         opm_mile = yes
         opmcmmts = no.
   end.
   else do:

      if opm_fsm_type <> " " then do:
         /* CONTROLLED BY SERVICE/SUPPORT MODULE */
         {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=2}
      end. /* if opm_fsm_type... */
   end.

   recno = recid(opm_mstr).
   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   if opm_cmtindx <> 0 then
      opmcmmts = yes.
   else
      opmcmmts = no.

   display
      opm_desc
      opm_wkctr
      opm_mch
      opm_setup
      opm_run
      opm_move
      opm_yld_pct
      opm_tool
      opm_vend
      opm_mile
      opm_inv_val
      opm_sub_cost
      opm_sub_lead
      opm_tran_qty
      opmcmmts.

   seta:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      set
         opm_desc
         opm_wkctr
         opm_mch
         opm_setup
         opm_run
         opm_move
         opm_yld_pct
         opm_tool
         opm_vend
         opm_mile
         opm_inv_val
         opm_sub_cost
         opm_sub_lead
         opm_tran_qty
         opmcmmts
      go-on ("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo seta.

         for each cmt_det exclusive-lock  where cmt_det.cmt_domain =
         global_domain and  cmt_indx = opm_cmtindx:
            delete cmt_det.
         end.

         delete opm_mstr.
         clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
         del-yn = no.
         next mainloop.
      end.

      if not can-find (wc_mstr  where wc_mstr.wc_domain = global_domain and
      wc_wkctr = opm_wkctr
         and wc_mch = opm_mch)
      then do:
         /* Work Center/Machine not found */
         {pxmsg.i &MSGNUM=528 &ERRORLEVEL=3}
         next-prompt opm_mch.
         undo, retry.
      end.

      if can-find (wc_mstr  where wc_mstr.wc_domain = global_domain and
      wc_wkctr = opm_wkctr and
         wc_fsm_type = "FSM")
      then do:
         /* This is an SSM work center, not a standard work center */
         {pxmsg.i &MSGNUM=7485 &ERRORLEVEL=2}
         next-prompt opm_wkctr.
         undo, retry.
      end.

      if opm_vend entered and opm_vend <> " " then do:
         find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr =
         opm_vend
         no-lock no-error.
         if not available vd_mstr then do:
            /* NOT A VALID SUPPLIER */
            {pxmsg.i &MSGNUM=2 &ERRORLEVEL=2}
         end. /* if not available vd_mstr */
      end. /* if opm_vend entered */

      if opmcmmts = yes then do:
         assign
            global_ref = string(opm_std_op)
            cmtindx    = opm_cmtindx.
         {gprun.i ""gpcmmt01.p"" "(input ""opm_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

         assign
            opm_cmtindx = cmtindx
            global_ref  = "".
      end.

      if opm_sub_lead = ?
      then do:
         /* UNKNOWN VALUE (QUESTION MARK) NOT ALLOWED. */
         {pxmsg.i &MSGNUM=1235 &ERRORLEVEL=3 &PAUSEAFTER=TRUE}
         if c-application-mode <> "API"
         then
            next-prompt opm_sub_lead.
            undo, retry.
      end. /* IF ro_sub_lead = ? */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.

end.
/*GUI*/ if global-beam-me-up then undo, leave.


status input.
