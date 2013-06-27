/* rwromt.p - ROUTING MAINTENANCE                                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.27.3.2 $                                                      */
/*                                                                            */
/* Logic to view and maintain the routing operations information for the      */
/* product and allow the attachment of Transaction/Master Comments to it      */
/*                                                                            */
/* REVISION: 1.0      LAST MODIFIED: 06/17/86   BY: EMB                       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                 */
/* REVISION: 4.0      LAST MODIFIED: 01/26/88   BY: pml *A119*                */
/* REVISION: 4.0      LAST MODIFIED: 02/17/88   BY: RL  *A171*                */
/* REVISION: 4.0      LAST MODIFIED: 03/21/88   BY: WUG *A194*                */
/* REVISION: 4.0      LAST MODIFIED: 12/07/88   BY: emb *A554*                */
/* REVISION: 5.0      LAST MODIFIED: 07/03/89   BY: emb *B169*                */
/* REVISION: 5.0      LAST MODIFIED: 03/26/91   BY: emb *B923*                */
/* REVISION: 7.3      LAST MODIFIED: 11/10/92   BY: emb *G689*                */
/* REVISION: 7.3      LAST EDIT:     02/24/93   BY: sas *G740*                */
/* REVISION: 7.3      LAST MODIFIED: 04/29/93   BY: pma *GA43*                */
/* REVISION: 7.3      LAST MODIFIED: 05/14/93   BY: qzl *GA87*                */
/* REVISION: 7.3      LAST MODIFIED: 05/19/93   BY: pma *GB19*                */
/* REVISION: 7.3      LAST MODIFIED: 06/02/93   BY: dzs *GB32*                */
/* REVISION: 7.3      LAST MODIFIED: 10/22/93   BY: ais *GF70*                */
/* REVISION: 7.3      LAST MODIFIED: 08/22/94   BY: pxd *FQ36*                */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *GM49*                */
/* REVISION: 7.3      LAST MODIFIED: 10/26/94   BY: pxd *GN57*                */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*                */
/* REVISION: 7.3      LAST MODIFIED: 12/20/94   BY: qzl *F0B3*                */
/* REVISION: 7.2      LAST MODIFIED: 12/20/94   BY: ais *F0B7*                */
/* REVISION: 7.2      LAST MODIFIED: 02/01/95   BY: pxd *F0GP*                */
/* REVISION: 7.2      LAST MODIFIED: 04/14/95   BY: qzl *F0Q6*                */
/* REVISION: 7.2      LAST MODIFIED: 12/04/95   BY: bcm *G1F4*                */
/* REVISION: 7.3      LAST MODIFIED: 01/03/96   BY: bcm *G1HY*                */
/* REVISION: 7.3      LAST MODIFIED: 04/23/96   BY: jym *G1SS*                */
/* REVISION: 8.5      LAST MODIFIED: 07/26/96   BY: *G29T* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12T* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 10/29/96   BY: *J16X* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 12/09/96   BY: *K00C* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 01/03/97   BY: *K04C* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 03/07/97   BY: *K06Y* Steve Nugent       */
/* REVISION: 8.6      LAST MODIFIED: 03/19/97   BY: *G2LK* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: *G2NN* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 07/03/97   BY: *G2NS* Maryjeane Date     */
/* REVISION: 8.6      LAST MODIFIED: 07/21/97   BY: *K0GW* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 11/27/97   BY: *H1GY* Manmohan Pardesi   */
/* Note: Changes made here may also be needed in fsromt.p, fmromt.p,
         and fmopmta.p                                                        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *J2W6* Sandesh Mahagaokar */
/* REVISION: 8.6E     LAST MODIFIED: 07/29/98   BY: *J2V1* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 11/05/98   BY: *M00W* G.Latha            */
/* REVISION: 9.0      LAST MODIFIED: 02/08/00   BY: *L0R6* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *J0FH*                    */
/* Revision: 1.23   LAST MODIFIED: 06/19/00   BY: *N0DP* Anup Pereira         */
/* Revision: 1.24   LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown           */
/* Revision: 1.25   LAST MODIFIED: 10/23/01   BY: *N14Y* Saurabh C.           */
/* Revision: 1.26   BY: Anil Sudhakaran      DATE: 11/29/01  ECO: *M1L9*      */
/* Revision: 1.27   BY: Subramanian Iyer     DATE: 10/29/02  ECO: *N1YD*      */
/* Revision: 1.27.3.1 BY: Rajaneesh S.       DATE: 06/05/03  ECO: *N1XN*      */
/* $Revision: 1.27.3.2 $ BY: Shilpa Athalye DATE: 07/04/03  ECO: *N2HC*       */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/*! FIELD USAGE:
ro_cyc_rate CONTAINS THE INPUT VALUE OF PRODUCTION RATE, WHICH IS THEN
            INVERTED TO CALCULATE THE RUN TIME.  BOTH VALUES ARE NOW STORED
            IN THE DATABASE TO ELIMINATE ROUNDING DISCREPANCIES IN THE
            INVERSION CALCULATIONS.  *G1HY*
Last change:  Q    19 Mar 97    1:27 pm
*/


/****030627.1*******************************************************************
1.ro_routing如果录入的不是零件主档里的料号，则必须有错误提示。
2.模腔数原来默认的是”1:1“ ,现在更改”空:空“，即，用户无论是否填写数据，
  屏幕都会过到下一屏，不用错误提示.
*******************************************************************************/
/* DISPLAY TITLE */
{mfdtitle.i "test.1"}

{pxmaint.i}

define new shared variable cmtindx as integer.

define variable description    like pt_desc1 no-undo.
define variable del-yn         like mfc_logical initial no no-undo.
define variable rocmmts        like mfc_logical initial no no-undo
   label "Comments".
define variable rostart        like ro_start no-undo.
define variable roend          like ro_end   no-undo.
define variable i              as   integer  no-undo.
define variable rorecid        as   recid    no-undo.
define variable conflicts      as   logical  no-undo.
define variable is-ssm-routing as   logical  no-undo.

define buffer rodet  for ro_det.
define buffer cmtdet for cmt_det.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* FOR REPLACING SCHEMA VALIDATION OF ROUTING WORK CENTER */
FUNCTION validWorkCenter returns logical (input workCenter as character):
   {pxrun.i &PROC = 'validateWorkCenter' &PROGRAM = 'rwroxr.p'
      &PARAM = "(input workCenter)"
      &NOAPPERROR = true
      &CATCHERROR = true}
   return (return-value = {&SUCCESS-RESULT}).
END FUNCTION. /* validWorkCenter */

/* FOR REPLACING SCHEMA VALIDATION OF ROUTING TOOL CODE */
FUNCTION validToolCode returns logical (input toolCode as character):
   {pxrun.i &PROC = 'validateToolCode' &PROGRAM = 'rwroxr.p'
      &PARAM = "(input toolCode)"
      &NOAPPERROR = true
      &CATCHERROR = true}
   return (return-value = {&SUCCESS-RESULT}).
END FUNCTION. /* validToolCode */

/* USING THE FORMAT WITHOUT COMMAS WILL PREVENT ROUNDING ERRORS */
/* WHICH CAN BE INTRODUCED BY PROGRESS LIKE IN THE NUMBER       */
/* 1234.9999999   (see ro_run)                                  */

/*DISPLAY SELECTION FORM*/
form
   ro_routing      colon 20
   description     no-label
   ro_op           colon 20
   ro_start        colon 43
   ro_end          colon 68 skip(1)
   ro_std_op       colon 30
   ro_wkctr        colon 30
   wc_desc         no-label
   ro_mch          colon 30
   ro_desc         colon 30
   ro_mch_op       colon 30 format ">>>,>>>"
   ro_milestone    colon 60
   ro_tran_qty     colon 30
   ro_sub_lead     colon 60
   ro_queue        colon 30
   ro_setup_men    colon 60
   ro_wait         colon 30
   ro_men_mch      colon 60 skip(1)
   ro_setup        colon 30
   ro_tool         colon 55 format "x(18)" label "模具"
   ro_run          colon 30 format ">>>>>>>>9.9<<<<<<<<"
   ro_vend         colon 60
   ro_move         colon 30
   ro_inv_value    colon 60
   rostart         colon 30
   ro_sub_cost     colon 60
   roend           colon 30
   rocmmts         colon 60
   ro_yield_pct    colon 30
   ro__dec01       colon 50
with frame a width 80 no-validate side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
{mfdemo.i 06/01/2013 06/31/2013} /* ref mf1.p */
mainloop:
repeat with frame a:

   /* INITIALIZE DELETE FLAG BEFORE EACH DISPLAY OF FRAME */
   batchdelete = "".

   assign
      description = ""
      rorecid     = ?.

   prompt-for
      ro_routing
      ro_op
      ro_start
      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      batchdelete no-label when (batchrun)
      editing:

      /* SET GLOBAL PART VARIABLE */
      global_part = input ro_routing.

      if frame-field = "ro_routing"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */

         /* NEXT/PREV THROUGH NON-SERVICE ROUTINGS ONLY */
         {mfnp05.i ro_det ro_fsm_type
            "ro_fsm_type = "" "" " ro_routing
            "input ro_routing"}
      end. /* IF FRAME-FIELD = "ro_routing" THEN DO: */
      else
      if frame-field = "ro_op"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         if available ro_det
         and ro_routing = input ro_routing
         and ro_op      = input ro_op
         then
            recno = rorecid.
         {mfnp06.i ro_det ro_routing "ro_routing = input ro_routing"
            ro_op "input ro_op" ro_op "input ro_op"}
      end. /* ELSE IF FRAME-FIELD = "ro_op" THEN DO: */
      else
      if frame-field = "ro_start"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         if available ro_det
            and ro_routing = input ro_routing
            and ro_op      = input ro_op
            and ro_start   = input ro_start
         then
            recno = rorecid.

         /* CHANGED THE THIRD PARAMETER FROM */
         /* TRUE TO ro_fsm_type = " "        */
         {mfnp08.i ro_det ro_routing "ro_fsm_type = "" "" "
            ro_routing "INPUT ro_routing"
            ro_op "INPUT ro_op"
            ro_op "INPUT ro_op"}
      end. /* ELSE IF FRAME-FIELD = "ro_start" THEN DO: */
      else do:
         readkey.
         apply lastkey.
      end. /* ELSE DO: */

      rostart = ?.
      if recno <> ?
      then do:
         assign
            rostart     = ro_start
            description = "".

         /* READ ITEM MASTER RECORD BASED ON ROUTING ID */

         /* CHANGED FIRST INPUT PARAMETER FROM    */
         /* ro_routing:screen-value TO ro_routing */
         {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppitxr.p'
            &PARAM = "(input  ro_routing,
              buffer pt_mstr,
              input  no,
              input  no)"
            &NOAPPERROR = true
            &CATCHERROR = true}

         if return-value = {&SUCCESS-RESULT}
         then
            description = pt_desc1.

         /* READ WORK CENTER RECORD BASED ON ROUTING WORK-CENTER AND MACHINE */
         {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwwcxr.p'
            &PARAM = "(input  ro_wkctr,
              input  ro_mch,
              buffer wc_mstr,
              input  no,
              input  no)"
            &NOAPPERROR = true
            &CATCHERROR = true}

         display
            ro_std_op
            ro_routing
            description
            ro_op
            ro_start
            ro_start @ rostart
            ro_end   @ roend
            ro_end
            ro_std_op
            ro_wkctr.

         if return-value = {&SUCCESS-RESULT}
         then
            display
               wc_desc.
         else
            display
               " " @ wc_desc.

         if ro_cmtindx <> 0
         then
            rocmmts = yes.
         else
            rocmmts = no.

         display
            ro_mch
            ro_desc
            ro_mch_op
            ro_tran_qty
            ro_queue
            ro_wait
            ro_milestone
            ro_sub_lead
            ro_setup_men
            ro_men_mch
            ro_setup
            ro_run
            ro_move
            ro_yield_pct
            ro_start
            ro_start @ rostart
            ro_end
            ro_end   @ roend
            ro_tool
            ro_vend
            ro_inv_value
            ro_sub_cost
            rocmmts
            ro__dec01.

         assign
            rorecid = recno
            recno   = ?.
      end. /* IF recno <> ? THEN DO: */
   end. /* EDITING: */
   find first pt_mstr no-lock where pt_part = input ro_routing no-error.
   if not available pt_mstr then do:
      {mfmsg.i 16 3}
      next-prompt ro_routing with frame a.
      undo mainloop, retry.
   end.
   /* ADD/MOD/DELETE */

   /* CHECK TO SEE IF ANY OPERATION ARE SSM OPERATIONS */
   is-ssm-routing = no.
   if {pxfunct.i &FUNCTION = 'validateServiceOpRouting' &PROGRAM = 'rwroxr.p'
      &PARAM = "input ro_routing:screen-value"
      &NOAPPERROR = true
      &CATCHERROR = true}
   then do:
      is-ssm-routing = yes.
      release ro_det.
   end. /* USING ro_routing)) THEN DO: */

   /* READ ITEM MASTER RECORD BASED ON ROUTING ID */
   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppitxr.p'
      &PARAM = "(input  ro_routing:screen-value,
        buffer pt_mstr,
        input  no,
        input  no)"
      &NOAPPERROR = true
      &CATCHERROR = true}

   if return-value = {&SUCCESS-RESULT}
   then
      description = pt_desc1.

   /* READ ROUTING OPERATION RECORD */
   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwroxr.p'
      &PARAM = "(input  ro_routing:screen-value,
        input  ro_op:screen-value,
        input  ro_start:screen-value,
        buffer ro_det,
        input  yes,
        input  no)"
      &NOAPPERROR = true
      &CATCHERROR = true}

   if return-value = {&RECORD-LOCKED}
   then do:
      {pxmsg.i
         &MSGNUM=7006
         &ERRORLEVEL=4
         }
      undo, retry.
   end. /* IF return-value = {&RECORD-LOCKED} THEN DO: */

   if return-value <> {&SUCCESS-RESULT}
   then do:

      /* VALIDATE ENTRY OF BLANK OR SSM ROUTING */
      {pxrun.i &PROC = 'validateRoutingCodeEntry' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input ro_routing:screen-value,
           input is-ssm-routing)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then
         undo mainloop, retry mainloop.

      /* MESSAGE #1 - ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1
         &ERRORLEVEL={&INFORMATION-RESULT}
         }

      create ro_det.

      /* PATCH J0FH SHOULD BE REMOVED WHEN THE SCHEMA IS OPEN AND THE   */
      /* DEFAULT VALUE CAN BE CHANGED FOR THE FIELD RO_MV_NXT_OP - ALSO */
      /* NORMALIZED THE BELOW ASSIGN INTO ONE ASSIGN STATEMENT          */

      assign
         ro_routing
         ro_op
         ro_start
         ro_milestone = yes.

      /* VALIDATE OVERLAP OF DATE RANGE WITH EXISTING ROUTING OPERATION */
      /* BASED ON THE ENTERED START DATE                                */
      {pxrun.i &PROC = 'validateStartDateRange' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  ro_start:screen-value,
           buffer ro_det)"
         &NOAPPERROR = true
         &CATCHERROR = true}
   end. /* IF NOT AVAILABLE ro_det THEN DO: */

   recno = recid(ro_det).

   /* SET GLOBAL PART VARIABLE */
   global_part = ro_routing.

   display
      ro_routing
      description
      ro_op
      ro_start
      ro_start @ rostart
      ro_end
      ro_end   @ roend
      ro_std_op
      ro_wkctr.

   /* READ WORK CENTER RECORD BASED ON ROUTING WORK-CENTER AND MACHINE */
   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwwcxr.p'
      &PARAM = "(input  ro_wkctr,
        input  ro_mch,
        buffer wc_mstr,
        input  no,
        input  no)"
      &NOAPPERROR = true
      &CATCHERROR = true}

   if return-value = {&SUCCESS-RESULT}
   then
      display
         wc_desc.
   else
      display
         " " @ wc_desc.

   if ro_cmtindx <> 0
   then
      rocmmts = yes.
   else
      rocmmts = no.

   display
      ro_mch
      ro_desc
      ro_mch_op
      ro_tran_qty
      ro_queue
      ro_wait
      ro_milestone
      ro_sub_lead
      ro_setup_men
      ro_men_mch
      ro_setup
      ro_run
      ro_move
      ro_yield_pct
      ro_start @ rostart
      ro_end   @ roend
      ro_tool
      ro_vend
      ro_inv_value
      ro_sub_cost
      ro__dec01
      rocmmts.

   /* IF THIS OPERATION IS SSM ISSUE ERROR-IF NOT AND ANY OPERATION */
   /* IN THIS ROUTING IS SSM, THEN ISSUE WARNING ONLY               */
   if ro_fsm_type = "FSM"
   then do:
      /* MESSAGE #7423 - THIS IS A SERVICE ROUTING, NOT A STANDARD ROUTING */
      {pxmsg.i &MSGNUM=7423
         &ERRORLEVEL={&APP-ERROR-RESULT}
         }
      undo mainloop, retry mainloop.
   end. /* IF ro_fsm_type = "FSM" THEN DO: */
   if is-ssm-routing
   then do:
      /* MESSAGE #1643 - ROUTING HAS SERVICE OPERATIONS */
      {pxmsg.i &MSGNUM=1643
         &ERRORLEVEL={&WARNING-RESULT}
         }
   end. /* IF is-ssm-routing THEN DO: */

   if new ro_det
   then do on error undo, retry:
      set ro_std_op
         editing:
         if frame-field = "ro_std_op"
         then do:
            {mfnp05.i opm_mstr opm_std_op yes
               opm_std_op "input ro_std_op"}

            if recno <> ?
            then do:
               /* READ WORK CENTER RECORD BASED ON STANDARD OPERATION */
               /* WORK-CENTER AND MACHINE                             */
               {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwwcxr.p'
                  &PARAM = "(input  opm_wkctr,
                    input  opm_mch,
                    buffer wc_mstr,
                    input  no,
                    input  no)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

               display
                  opm_std_op   @ ro_std_op
                  opm_desc     @ ro_desc
                  opm_wkctr    @ ro_wkctr
                  opm_mch      @ ro_mch
                  opm_tran_qty @ ro_tran_qty
                  opm_mile     @ ro_milestone
                  opm_sub_lead @ ro_sub_lead.

               if return-value = {&SUCCESS-RESULT}
               then
                  display
                     wc_desc
                     wc_mch_op    @ ro_mch_op
                     wc_queue     @ ro_queue
                     wc_wait      @ ro_wait
                     wc_men_mch   @ ro_men_mc
                     wc_setup_men @ ro_setup_men.
               else
                  display
                     " " @ wc_desc
                     ro_mch_op
                     ro_queue
                     ro_wait
                     ro_men_mc
                     ro_setup_men.

               display
                  opm_setup    @ ro_setup
                  opm_run      @ ro_run
                  opm_move     @ ro_move
                  opm_yld_pct  @ ro_yield_pct
                  opm_tool     @ ro_tool
                  opm_vend     @ ro_vend
                  opm_inv_val  @ ro_inv_value
                  opm_sub_cost @ ro_sub_cost.
            end. /* IF recno <> ? THEN DO: */
         end. /* IF FRAME-FIELD = "ro_std_op" THEN DO: */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO: */
      end. /* EDITING: */

      /* READ STANDARD OPERATION RECORD BASED ON ROUTING STANDARD OPERATION */
      {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwopmxr.p'
         &PARAM = "(input  ro_std_op,
           buffer opm_mstr,
           input  no,
           input  no)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value = {&SUCCESS-RESULT}
      then do:
         /* VALIDATE THAT STANDARD OPERATION TYPE IS NOT FSM */
         {pxrun.i &PROC = 'validateFSMStdOp' &PROGRAM = 'rwopmxr.p'
            &PARAM = "(input opm_fsm_type)"
            &NOAPPERROR = true
            &CATCHERROR = true}
         if return-value <> {&SUCCESS-RESULT}
         then undo, retry.

         display
            opm_std_op   @ ro_std_op
            opm_desc     @ ro_desc
            opm_wkctr    @ ro_wkctr
            opm_mch      @ ro_mch
            opm_tran_qty @ ro_tran_qty
            opm_mile     @ ro_milestone
            opm_sub_lead @ ro_sub_lead
            opm_setup    @ ro_setup
            opm_run      @ ro_run
            opm_move     @ ro_move
            opm_yld_pct  @ ro_yield_pct
            opm_tool     @ ro_tool
            opm_vend     @ ro_vend
            opm_inv_val  @ ro_inv_value
            opm_sub_cost @ ro_sub_cost.

         if opm_cmtindx <> 0
         then do:
            display
               yes @ rocmmts.

            /* COPY THE TRANSACTION COMMENTS FROM STANDARD OPERATION */
            {pxrun.i &PROC = 'copyComments' &PROGRAM = 'gpcmxr.p'
               &PARAM = "(input  opm_cmtindx,
                 output ro_cmtindx)"
               &NOAPPERROR = true
               &CATCHERROR = true}
         end. /* IF opm_cmtindx <> 0 THEN DO: */
         else
            display
               no @ rocmmts.

      end. /* DO: */
      else
      display
         ro_desc
         ro_wkctr
         ro_mch
         ro_tran_qty
         ro_milestone
         ro_sub_lead
         ro_setup
         ro_run
         ro_move
         ro_yield_pct
         ro_tool
         ro_vend
         ro_inv_value
         ro_sub_cost.

      if return-value <> {&SUCCESS-RESULT}
      and ro_std_op    > ""
      then do:
         /* MESSAGE #13 - NOT A VALID CHOICE */
         {pxmsg.i &MSGNUM=13
            &ERRORLEVEL={&APP-ERROR-RESULT}
            }
         next-prompt ro_std_op.
         undo, retry.
      end. /* IF NOT AVAILABLE opm_mstr AND ro_std_op > "" THEN DO: */

      if return-value = {&SUCCESS-RESULT}
      then do:
         /* READ WORK CENTER RECORD BASED ON STANDARD OPERATION */
         /* WORK-CENTER AND MACHINE                             */
         {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwwcxr.p'
            &PARAM = "(input  opm_wkctr,
              input  opm_mch,
              buffer wc_mstr,
              input  no,
              input  no)"
            &NOAPPERROR = true
            &CATCHERROR = true}
      end. /* IF return-value = {&SUCCESS-RESULT} */
      else do:
         /* READ WORK CENTER RECORD BASED ON ROUTING WORK-CENTER AND MACHINE */
         {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwwcxr.p'
            &PARAM = "(input  ro_wkctr,
              input  ro_mch,
              buffer wc_mstr,
              input  no,
              input  no)"
            &NOAPPERROR = true
            &CATCHERROR = true}
      end. /* ELSE DO: */

      if return-value = {&SUCCESS-RESULT}
      then
         display
            wc_desc
            wc_mch_op    @ ro_mch_op
            wc_queue     @ ro_queue
            wc_wait      @ ro_wait
            wc_men_mch   @ ro_men_mc
            wc_setup_men @ ro_setup_men.
      else
         display
            " " @ wc_desc
            ro_mch_op
            ro_queue
            ro_wait
            ro_men_mc
            ro_setup_men.
   end. /* SET ro_std_op */

   do on error undo, retry:
      set
         ro_wkctr
         ro_mch
         editing:
         if frame-field = "ro_wkctr"
         or frame-field = "ro_mch"
         then do:

         if {gpiswrap.i}
         then
            recno = ? .

            {mfnp05.i wc_mstr wc_wkctr yes wc_wkctr "input ro_wkctr"}
            if recno <> ?
            then do:
               display
                  wc_wkctr     @ ro_wkctr
                  wc_desc
                  wc_mch       @ ro_mch
                  wc_mch_op    @ ro_mch_op
                  wc_queue     @ ro_queue
                  wc_wait      @ ro_wait
                  wc_men_mch   @ ro_men_mc
                  wc_setup_men @ ro_setup_men.
            end. /* IF recno <> ? THEN DO: */

         end. /* THEN DO: */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO: */

         if (go-pending or (frame-field <> "ro_wkctr"))
         and not validWorkCenter(input ro_wkctr:screen-value)
         then do:
            next-prompt ro_wkctr.
            next.
         end. /* IF (go-pending OR (frame-field <> "ro_wkctr")) */
      end. /* EDITING: */

      /* READ WORK CENTER RECORD BASED ON ROUTING WORK-CENTER AND MACHINE */
      {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwwcxr.p'
         &PARAM = "(input  ro_wkctr,
           input  ro_mch,
           buffer wc_mstr,
           input  no,
           input  no)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value = {&SUCCESS-RESULT}
      then do:
         /* VALIDATE THAT WORK CENTER TYPE IS NOT FSM */
         {pxrun.i &PROC = 'validateFSMWorkCenter' &PROGRAM = 'rwwcxr.p'
            &PARAM = "(input wc_fsm_type)"
            &NOAPPERROR = true
            &CATCHERROR = true}
         if return-value <> {&SUCCESS-RESULT}
         then undo, retry.

         display
            wc_desc.

         if ro_wkctr entered
         or ro_mch entered
         or new (ro_det)
         then
            display
               wc_mch_op    @ ro_mch_op
               wc_queue     @ ro_queue
               wc_wait      @ ro_wait
               wc_men_mch   @ ro_men_mc
               wc_setup_men @ ro_setup_men.
         else
            display
               ro_mch_op
               ro_queue
               ro_wait
               ro_men_mc
               ro_setup_men.
      end. /* IF AVAILABLE wc_mstr THEN DO: */
      else
      display
         " " @ wc_desc
         ro_mch_op
         ro_queue
         ro_wait
         ro_men_mc
         ro_setup_men.

      if return-value <> {&SUCCESS-RESULT}
      then do with frame a:
         /* MESSAGE #528 - WORK CENTER / MACHINE NOT FOUND */
         {pxmsg.i &MSGNUM=528
            &ERRORLEVEL={&APP-ERROR-RESULT}
         }
         next-prompt ro_mch.
         undo, retry.
      end. /* IF NOT AVAILABLE wc_mstr THEN DO WITH FRAME a: */
   end. /* SET ro_wkctr ro_mch */

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:

      set
         ro_desc
         ro_mch_op
         ro_tran_qty
         ro_queue
         ro_wait
         ro_milestone
         ro_sub_lead
         ro_setup_men
         ro_men_mch
         ro_setup
         ro_run
         ro_move
         rostart
         roend
         ro_yield_pct
         /*
         ro_tool
         ro_vend
         */
         ro_inv_value
         ro_sub_cost
         rocmmts
         go-on ("F5" "CTRL-D")
         editing:
         if frame-field = "ro_tool"
         then do:
            readkey.
            hide message no-pause.
            recno = ?.
            apply lastkey.
         end. /* IF FRAME-FIELD = "ro_tool" */
         else do:
            readkey.
            apply lastkey.
            recno = ?.
         end. /* ELSE DO: */
/* lambert 20120905.1
         if (go-pending or (frame-field <> "ro_tool" and ro_tool entered))
         and not validToolCode(input ro_tool:screen-value)
         then do:
            next-prompt ro_tool.
            next.
         end. /* IF (go-pending or ... */
         lambert 20120905.1 */
      end. /* EDITING */

      /* VALIDATE ENTRY OF START DATE */
      {pxrun.i &PROC = 'validateStart' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  rostart,
           buffer ro_det)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt rostart.
         undo, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      assign
         ro_start = rostart
         ro_end   = roend.

      /* VALIDATE ENTRY OF END DATE */
      {pxrun.i &PROC = 'validateEnd' &PROGRAM = 'rwroxr.p'
         &PARAM = "(buffer ro_det)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt rostart.
         undo, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE OVERLAP OF DATE RANGE WITH EXISTING ROUTING OPERATION */
      /* BASED ON THE ENTERED START AND END DATE                        */
      {pxrun.i &PROC = 'validateDateRange' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  rostart:screen-value,
           input  roend:screen-value,
           buffer ro_det)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt roend.
         undo seta, retry seta.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE ENTRY OF YIELD PERCENTAGE */
      {pxrun.i &PROC = 'validateYield' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input ro_yield_pct)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt ro_yield_pct.
         undo, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* CALCULATE CYCLE RATE BASED ON THE RUN TIME ENTERED */
      {pxrun.i &PROC = 'calculateCycleRate' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  ro_run,
           output ro_cyc_rate)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Delete to be executed if batchdelete is set to "x" */
      or input batchdelete = "x":U
      then do:
         del-yn = yes.
         /* MESSAGE #11 - PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11
            &ERRORLEVEL={&INFORMATION-RESULT}
            &CONFIRM=del-yn
         }
         if del-yn = no
         then
            undo seta.

         {rwrodel.i}

         clear frame a.
         del-yn = no.
         next mainloop.
      end. /* THEN DO: */

      if rocmmts = yes
      then do:
         if ro_std_op > ""
         then
            global_ref = ro_std_op.
         else
            global_ref = string(ro_op).

         cmtindx = ro_cmtindx.
         {gprun.i ""gpcmmt01.p"" "(input ""ro_det"")"}
         assign
            ro_cmtindx = cmtindx
            global_ref = "".
      end. /* IF rocmmts = yes THEN DO: */
      /* lambert 20120729*/
      /*
      define var myrc as  recid.
      find first pt_mstr no-lock where pt_part = ro_routing and pt_prod_line = "3700" no-error.
      if avail pt_mstr then do:
        myrc = recid(ro_det).
        {gprun.i ""xxrwromtb.p"" "(input myrc)"}
        find first ro_det where recid(ro_det) = myrc exclusive-lock.
        disp ro_vend ro_tool ro__dec01 with frame a.
      end.

      /* lambert 20120729*/
      */
   end. /* DO ON ERROR UNDO, RETRY: */

   define var myrc as  recid.
   myrc = recid(ro_det).
   {gprun.i ""xxrwromta.p"" "(input recid(ro_det))"}
   find first ro_det where recid(ro_det) = myrc exclusive-lock.
   disp ro_vend ro_tool ro__dec01 with frame a.
end. /* DO ON ERROR UNDO, RETRY: */
status input.
