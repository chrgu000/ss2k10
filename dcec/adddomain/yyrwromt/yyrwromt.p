/* GUI CONVERTED from rwromt.p (converter v1.78) Fri Aug 12 04:08:07 2011 */
/* rwromt.p - ROUTING MAINTENANCE                                             */
/* Copyright 1986-2011 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
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
/* Revision: 1.26      BY: Anil Sudhakaran      DATE: 11/29/01 ECO: *M1L9*    */
/* Revision: 1.27      BY: Subramanian Iyer     DATE: 10/29/02 ECO: *N1YD*    */
/* Revision: 1.29      BY: Paul Donnelly (SB)   DATE: 06/28/03 ECO: *Q00L*    */
/* Revision: 1.30      BY: Rajaneesh S.         DATE: 08/26/03 ECO: *N1XN*    */
/* Revision: 1.31      BY: Shilpa Athalye       DATE: 08/26/03 ECO: *N2HC*    */
/* Revision: 1.33      BY: Matthew Lee          DATE: 05/13/04 ECO: *N2SL*    */
/* Revision: 1.35      BY: Abhishek Jha         DATE: 07/30/05 ECO: *P3W2*    */
/* Revision: 1.38      BY: Chi Liu              DATE: 07/18/06 ECO: *P4WK*    */
/* Revision: 1.38.4.1  BY: Evan Todd            DATE: 02/19/09 ECO: *Q2D3*    */
/* Revision: 1.38.4.2  BY: Evan Todd            DATE: 09/03/09 ECO: *Q3BT*    */
/* Revision: 1.38.4.3  BY: Devna Sahai          DATE: 12/10/09 ECO: *Q3P3*    */
/* Revision: 1.38.4.4  BY: Ruchita Shinde       DATE: 06/24/10 ECO: *Q45Q*    */
/* Revision: 1.38.4.5  BY: Ravi Swami           DATE: 01/19/11 ECO: *Q4LS*    */
/* $Revision: 1.38.4.6 $ BY: Anandhakumar K DATE: 08/11/11  ECO: *Q4ZP* */
/* $Revision:eb21sp12  $ BY: Jordan Lin         DATE: 08/31/12  ECO: *SS-20120831.1*   */
/*-Revision end---------------------------------------------------------------*/

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

/* DISPLAY TITLE */
{mfdtitle.i "120831.1"}

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

{pxmaint.i}
 /* *SS-20120831.1* -b  */
def var sidesc like si_desc.                     /*kevin*/
def var msg-nbr as inte.                         /*kevin*/
/* *SS-20120831.1* -e  */
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
define variable save_recno     as   recid    no-undo.
define variable osv_ro_routing like ro_routing no-undo.
define variable osv_ro_op      like ro_op      no-undo.
define variable osv_ro_start   like ro_start   no-undo.
define variable l-restore      as   logical  initial yes no-undo.

define variable old_desc       like ro_desc      no-undo.
define variable old_wkctr      like ro_wkctr     no-undo.
define variable old_setup      like ro_setup     no-undo.
define variable old_move       like ro_move      no-undo.
define variable old_yield_pct  like ro_yield_pct no-undo.
define variable old_tool       like ro_tool      no-undo.
define variable old_vend       like ro_vend      no-undo.
define variable old_sub_cost   like ro_sub_cost  no-undo.
define variable old_tran_qty   like ro_tran_qty  no-undo.
define variable old_inv_value  like ro_inv_value no-undo.
define variable old_mch        like ro_mch       no-undo.
define variable old_milestone  like ro_milestone no-undo.
define variable old_std_op     like ro_std_op    no-undo.
define variable old_setup_men  like ro_setup_men no-undo.
define variable old_men_mch    like ro_men_mch   no-undo.
define variable old_mch_op     like ro_mch_op    no-undo.
define variable old_queue      like ro_queue     no-undo.
define variable old_wait       like ro_wait      no-undo.
define variable old_sub_lead   like ro_sub_lead  no-undo.
define variable old_cost       like ro_cost      no-undo.
define variable old_price      like ro_price     no-undo.
define variable old_fsc_code   like ro_fsc_code  no-undo.

define buffer rodet  for ro_det.
define buffer cmtdet for cmt_det.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* Define Handles for the programs. */
{pxphdef.i gpsecxr}

/* Local variables to store UI values */
define variable cRouting as character no-undo.
define variable iOp      as integer   no-undo.
define variable dtStart  as date      no-undo.

define variable lCustomOK as logical no-undo.

/* Routing API dataset definition */
{rwdsro.i "reference-only"}

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

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ro_routing      colon 20
   description     no-label
   ro_op           colon 20
   ro_start        colon 43
   ro_end          colon 68 skip(1)
 /* *SS-20120831.1*   */      ro__chr01     colon 20 label "地点" sidesc no-label       /*kevin*/
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
   ro_tool         colon 60
   ro_run          colon 30 format ">>>>>>>>9.9<<<<<<<<"
   ro_vend         colon 60
   ro_move         colon 30
   ro_inv_value    colon 60
   rostart         colon 30
   ro_sub_cost     colon 60
   roend           colon 30
   rocmmts         colon 60
   ro_yield_pct    colon 30
 SKIP(.4)  /*GUI*/
with frame a width 80 no-validate side-labels attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame a:handle).

/* DISPLAY */
if c-application-mode <> "API" then
   view frame a.

if c-application-mode = "API" then do on error undo, return:

   /* Get handle of API Controller */
   {gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if not valid-handle(ApiMethodHandle) then do:
      /* API Error */
      {pxmsg.i &MSGNUM=10461 &ERRORLEVEL=4}
      return.
   end.

   /* Get the Routing API dataset from the controller */
   run getRequestDataset in ApiMethodHandle (output dataset dsRouting bind).

end.  /* If c-application-mode = "API" */

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Get the routing record from the API controller */
   if c-application-mode = "API" then do:
      run getNextRecord in ApiMethodHandle (input "ttRouting").
      if return-value = {&RECORD-NOT-FOUND} then
         leave mainloop.
   end. /* if c-application-mode = "API" */

   /* INITIALIZE DELETE FLAG BEFORE EACH DISPLAY OF FRAME */
   batchdelete = "".

   assign
      description = ""
      rorecid     = ?
      save_recno = ?.

   if c-application-mode <> "API" then do:
      prompt-for
         ro_routing
         ro_op
         ro_start
         /* Prompt for the delete variable in the key frame at the
          * End of the key field/s only when batchrun is set to yes */
         batchdelete no-label when (batchrun) with frame a
         editing:

         /* SET GLOBAL PART VARIABLE */
         global_part = input ro_routing.

         if frame-field = "ro_routing"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */

            /* NEXT/PREV THROUGH NON-SERVICE ROUTINGS ONLY */
            {mfnp05.i ro_det ro_fsm_type
               " ro_det.ro_domain = global_domain and ro_fsm_type  = "" "" "
               ro_routing
               "input ro_routing"}
         end. /* IF FRAME-FIELD = "ro_routing" THEN DO: */
         else
         if frame-field = "ro_op"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            if available ro_det
            and ro_routing = input ro_routing
            then do:
               recno = rorecid.
               if {gpiswrap.i} then
                  l-restore = no.
            end.

            {mfnp06.i ro_det ro_routing " ro_det.ro_domain = global_domain and
            ro_routing  = input ro_routing"
               ro_op "input ro_op" ro_op "input ro_op"}
         end. /* ELSE IF FRAME-FIELD = "ro_op" THEN DO: */
         else
         if frame-field = "ro_start"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            recno = rorecid.
            if {gpiswrap.i} then
               l-restore = no.

            /* CHANGED THE THIRD PARAMETER FROM */
            /* TRUE TO ro_fsm_type = " "        */
            {mfnp08.i ro_det ro_routing " ro_det.ro_domain = global_domain and
            ro_fsm_type  = "" "" "
               ro_routing "INPUT ro_routing"
               ro_op "INPUT ro_op"
               ro_op "INPUT ro_op"}
         end. /* ELSE IF FRAME-FIELD = "ro_start" THEN DO: */
         else do:
            readkey.
            apply lastkey.
         end. /* ELSE DO: */

         if {gpiswrap.i} and
            not (lastkey = keycode("F10") or
                 keyfunction(lastkey) = "CURSOR-DOWN" or
                 lastkey = keycode("F9") or
                 keyfunction(lastkey) = "CURSOR-UP") and
            not (keyfunction(lastkey) = "HELP" and l-restore) then
               recno = ?.

         /* This routine modifies and uses recno outside of the mfnp */
         /* logic. Restore it in the specific case of the Desktop  */
         /* Help trigger. */
         if {gpiswrap.i} then do:
            if keyfunction(lastkey) = "HELP" then do:
               /* In the case of fill fields,                                */
               /* if screen values were changed then should not reset recno. */
               if osv_ro_routing <> input ro_routing or
                  osv_ro_op <> input ro_op or
                  osv_ro_start <> input ro_start then
                  assign
                     osv_ro_routing = input ro_routing
                     osv_ro_op = input ro_op
                     osv_ro_start = input ro_start.
               else do:
                  if l-restore then
                     recno = save_recno.
                  else
                     l-restore = yes.
               end.
            end.
            else
               save_recno = recno.
         end.

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

 /* *SS-20120831.1* -b  */  
  /********tfq added begin*****************/
               find si_mstr where  si_mstr.si_domain = global_domain and  si_site = ro__chr01 no-lock no-error.     /*kevin*/ 
               if available si_mstr then
                    sidesc = si_desc.
               else sidesc = "".     
   /***************tfq added end************/     

 /* *SS-20120831.1* -e  */  
            display
 /* *SS-20120831.1* -b  */    ro__chr01 sidesc                                         /*kevin*/
               ro_std_op
               ro_routing
               description
               ro_op
               ro_start
               ro_start @ rostart
               ro_end   @ roend
               ro_end
               ro_std_op
               ro_wkctr
            with frame a.

            if return-value = {&SUCCESS-RESULT}
            then
               display
                  wc_desc
               with frame a.
            else
               display
                  " " @ wc_desc
               with frame a.

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
            with frame a.

            assign
               rorecid = recno
               recno   = ?.
         end. /* IF recno <> ? THEN DO: */
      end. /* EDITING: */
   end. /* c-application-mode <> "API" */

   /* Assign the local variables from either the UI or API */
   assign
      cRouting = if c-application-mode <> "API" then
                    (input ro_routing)
                 else
                    ttRouting.roRouting
      iOp      = if c-application-mode <> "API" then
                    (input ro_op)
                 else
                    ttRouting.roOp
      dtStart  = if c-application-mode <> "API" then
                    (input ro_start)
                 else
                    ttRouting.roStart.

   /* ADD/MOD/DELETE */

   /* CHECK TO SEE IF ANY OPERATION ARE SSM OPERATIONS */
   is-ssm-routing = no.
   if {pxfunct.i &FUNCTION = 'validateServiceOpRouting' &PROGRAM = 'rwroxr.p'
      &PARAM = "input cRouting"
      &NOAPPERROR = true
      &CATCHERROR = true}
   then do:
      is-ssm-routing = yes.
      release ro_det.
   end. /* USING ro_routing)) THEN DO: */

   /* READ ITEM MASTER RECORD BASED ON ROUTING ID */
   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppitxr.p'
      &PARAM = "(input cRouting,
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
      &PARAM = "(input cRouting,
        input  iOp,
        input  dtStart,
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
         &PARAM = "(input cRouting,
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

      create ro_det. ro_det.ro_domain = global_domain.

      /* PATCH J0FH SHOULD BE REMOVED WHEN THE SCHEMA IS OPEN AND THE   */
      /* DEFAULT VALUE CAN BE CHANGED FOR THE FIELD RO_MV_NXT_OP - ALSO */
      /* NORMALIZED THE BELOW ASSIGN INTO ONE ASSIGN STATEMENT          */

      if c-application-mode <> "API" then do:
         assign
            ro_routing
            ro_op
            ro_start
            ro_milestone = yes.
      end. /* c-application-mode <> "API" */
      else do:
         assign
            ro_routing   = ttRouting.roRouting
            ro_op        = ttRouting.roOp
            ro_start     = ttRouting.roStart
            ro_milestone = yes.
      end. /* c-application-mode = "API" */

      /* VALIDATE OVERLAP OF DATE RANGE WITH EXISTING ROUTING OPERATION */
      /* BASED ON THE ENTERED START DATE                                */
      {pxrun.i &PROC = 'validateStartDateRange' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  dtStart,
           buffer ro_det)"
         &NOAPPERROR = true
         &CATCHERROR = true}
   end. /* IF NOT AVAILABLE ro_det THEN DO: */
 /* *SS-20120831.1* -b  */  
/************tfq added begin***********************************/
if return-value ={&SUCCESS-RESULT}
   then do:
   /*added by kevin, 10/22/2003 for site control*/
          if  ro__chr01 <> "" then do:
                 
                 find si_mstr no-lock where  si_mstr.si_domain = global_domain and  si_site = ro__chr01 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                    /*tfq {mfmsg.i msg-nbr 3} */
                    {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                          }
                     undo, retry.
                 end.
            
            if available si_mstr then disp si_site @ ro__chr01 si_desc @ sidesc with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/       /*tfq      {mfmsg.i 725 3}  */
{pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                        }  /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.
         end. /*if available ro_det*/
/*end added by kevin, 10/22/2003*/
   end.
/********************tfq added end****************************/

  /* *SS-20120831.1*  -e */  
   recno = recid(ro_det).

   /* SET GLOBAL PART VARIABLE */
   global_part = ro_routing.

 /* *SS-20120831.1* -b  */  

/**********tfq added  begin***************************/
           find si_mstr where si_mstr.si_domain = global_domain and  si_site = ro__chr01 no-lock no-error.          /*kevin*/
          if available si_mstr then
                sidesc = si_desc.
          else sidesc = "".
/**********tfq added end***************************/
 /* *SS-20120831.1* -e  */  

   if c-application-mode <> "API" then do:
      display
         ro_routing
         description
         ro_op
         ro_start
         ro_start @ rostart
         ro_end
         ro_end   @ roend
  /* *SS-20120831.1*  */  ro__chr01 sidesc                                                  /*kevin*/
         ro_std_op
         ro_wkctr
      with frame a.
   end. /* c-application-mode <> "API" */

   /* READ WORK CENTER RECORD BASED ON ROUTING WORK-CENTER AND MACHINE */
   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'rwwcxr.p'
      &PARAM = "(input  ro_wkctr,
        input  ro_mch,
        buffer wc_mstr,
        input  no,
        input  no)"
      &NOAPPERROR = true
      &CATCHERROR = true}

   if c-application-mode <> "API" then do:
      if return-value = {&SUCCESS-RESULT}
      then
         display
            wc_desc
         with frame a.
      else
         display
            " " @ wc_desc
         with frame a.

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
         rocmmts
      with frame a.
   end. /* c-application-mode <> "API" */

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

 /* *SS-20120831.1* -b  */  
/*********tfq added begin**********************************/
/*added by kevin, 10/17/2003 for site control*/
         if ro__chr01 = "" then disp global_site @ ro__chr01 with frame a.
                     
          set ro__chr01 with frame a editing:
               {mfnp.i si_mstr ro__chr01 si_site ro__chr01 si_site si_site}
               if recno <> ? then
                    disp si_site @ ro__chr01 si_desc @ sidesc with frame a. 
          end.
          
                 find si_mstr no-lock where si_mstr.si_domain = global_domain and si_site = input ro__chr01 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                /*tfq     {mfmsg.i msg-nbr 3} */
                {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                         }
                     undo, retry.
                 end.
            
            disp si_site @ ro__chr01 si_desc @ sidesc with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/           /*tfq  {mfmsg.i 725 3}   */
{pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                           }  /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.             
           
          assign global_site = ro__chr01.               /*kevin,01/17/2004*/
                
/*end added by kevin, 10/17/2003*/
/****************************tfq added end*****************/

 /* *SS-20120831.1* -e  */  
   if new ro_det
   then do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      if c-application-mode = "API" and retry then
         undo mainloop, next mainloop.

      assign
         old_std_op = ro_std_op.

      if c-application-mode <> "API" then do:
         set ro_std_op with frame a no-validate
         editing:
            if frame-field = "ro_std_op"
            then do:
               {mfnp05.i opm_mstr opm_std_op  " opm_mstr.opm_domain =
               global_domain and yes "
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
                     opm_sub_lead @ ro_sub_lead
                  with frame a.

                  if return-value = {&SUCCESS-RESULT}
                  then
                     display
                        wc_desc
                        wc_mch_op    @ ro_mch_op
                        wc_queue     @ ro_queue
                        wc_wait      @ ro_wait
                        wc_men_mch   @ ro_men_mc
                        wc_setup_men @ ro_setup_men
                     with frame a.
                  else
                     display
                        " " @ wc_desc
                        ro_mch_op
                        ro_queue
                        ro_wait
                        ro_men_mc
                        ro_setup_men
                     with frame a.

                  display
                     opm_setup    @ ro_setup
                     opm_run      @ ro_run
                     opm_move     @ ro_move
                     opm_yld_pct  @ ro_yield_pct
                     opm_tool     @ ro_tool
                     opm_vend     @ ro_vend
                     opm_inv_val  @ ro_inv_value
                     opm_sub_cost @ ro_sub_cost
                  with frame a.
               end. /* IF recno <> ? THEN DO: */
            end. /* IF FRAME-FIELD = "ro_std_op" THEN DO: */
            else do:
               status input.
               readkey.
               apply lastkey.
            end. /* ELSE DO: */
         end. /* EDITING: */
      end. /* c-application-mode <> "API" */
      else do:
         assign
            {mfaidflt.i ttRouting.roStdOp ro_std_op}
            ro_std_op = ttRouting.roStdOp.
      end. /* c-application-mode = "API" */

      if old_std_op <> ro_std_op
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_std_op',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_std_op with frame a.
            undo, retry.
         end.
      end.

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

         if c-application-mode <> "API" then do:
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
               opm_sub_cost @ ro_sub_cost
            with frame a.
         end. /* c-application-mode <> "API" */
         else do:
            /* SET THE DEFAULTS IN API TABLE FOR AN ADD OPERATION */
            assign
               {mfaidflt.i ttRouting.roStdOp      opm_std_op}
               {mfaidflt.i ttRouting.roWkctr      opm_wkctr}
               {mfaidflt.i ttRouting.roMch        opm_mch}
               {mfaidflt.i ttRouting.roTranQty    opm_tran_qty}
               {mfaidflt.i ttRouting.roMilestone  opm_mile}
               {mfaidflt.i ttRouting.roSubLead    opm_sub_lead}
               {mfaidflt.i ttRouting.roSetup      opm_setup}
               {mfaidflt.i ttRouting.roRun        opm_run}
               {mfaidflt.i ttRouting.roMove       opm_move}
               {mfaidflt.i ttRouting.roYieldPct   opm_yld_pct}
               {mfaidflt.i ttRouting.roTool       opm_tool}
               {mfaidflt.i ttRouting.roVend       opm_vend}
               {mfaidflt.i ttRouting.roInvValue   opm_inv_val}
               {mfaidflt.i ttRouting.roSubCost    opm_sub_cost}
               {mfaidflt.i ttRouting.roWipmtlPart ro_wipmtl_part}
               {mfaidflt.i ttRouting.roPoNbr      ro_po_nbr}
               {mfaidflt.i ttRouting.roPoLine     ro_po_line}
               {mfaidflt.i ttRouting.roMvNxtOp    ro_mv_nxt_op}
               {mfaidflt.i ttRouting.roAutoLbr    ro_auto_lbr}.
         end. /* c-application-mode = "API" */

         if opm_cmtindx <> 0
         then do:
            if c-application-mode <> "API" then
               display
                  yes @ rocmmts
               with frame a.

            /* COPY THE TRANSACTION COMMENTS FROM STANDARD OPERATION */
            {pxrun.i &PROC = 'copyComments' &PROGRAM = 'gpcmxr.p'
               &PARAM = "(input  opm_cmtindx,
                 output ro_cmtindx)"
               &NOAPPERROR = true
               &CATCHERROR = true}
         end. /* IF opm_cmtindx <> 0 THEN DO: */
         else do:
            if c-application-mode <> "API" then
               display
                  no @ rocmmts
               with frame a.
 /* *SS-20120831.1* -b  */  
/************tfq added begin***********************************/
/*added by kevin, 10/16/2003 for verify whether the standard op is same as the input site*/
                if opm__chr01 <> input ro__chr01 then do:
                    message "标准工序所对应的地点 '" + opm__chr01
                             + "' 与本工序地点不一致,请重新输入!" view-as alert-box error.
                    next-prompt ro_std_op.
                    undo,retry.
                end.
/*end added by kevin, 10/16/2003*/
/****************tfq added end**********************************/
  /* *SS-20120831.1* -e  */  
         end.
      end. /* DO: */
      else do:
         if c-application-mode <> "API" then do:
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
               ro_sub_cost
            with frame a.
         end. /* c-application-mode <> "API" */
         else do:
            /* SET THE DEFAULTS IN API TABLE FOR AN ADD OPERATION */
            assign
               {mfaidflt.i ttRouting.roDesc       ro_desc}
               {mfaidflt.i ttRouting.roWkctr      ro_wkctr}
               {mfaidflt.i ttRouting.roMch        ro_mch}
               {mfaidflt.i ttRouting.roTranQty    ro_tran_qty}
               {mfaidflt.i ttRouting.roMilestone  ro_milestone}
               {mfaidflt.i ttRouting.roSubLead    ro_sub_lead}
               {mfaidflt.i ttRouting.roSetup      ro_setup}
               {mfaidflt.i ttRouting.roRun        ro_run}
               {mfaidflt.i ttRouting.roMove       ro_move}
               {mfaidflt.i ttRouting.roYieldPct   ro_yield_pct}
               {mfaidflt.i ttRouting.roTool       ro_tool}
               {mfaidflt.i ttRouting.roVend       ro_vend}
               {mfaidflt.i ttRouting.roInvValue   ro_inv_value}
               {mfaidflt.i ttRouting.roSubCost    ro_sub_cost}
               {mfaidflt.i ttRouting.roWipmtlPart ro_wipmtl_part}
               {mfaidflt.i ttRouting.roPoNbr      ro_po_nbr}
               {mfaidflt.i ttRouting.roPoLine     ro_po_line}
               {mfaidflt.i ttRouting.roMvNxtOp    ro_mv_nxt_op}
               {mfaidflt.i ttRouting.roAutoLbr    ro_auto_lbr}.
         end. /* c-application-mode = "API" */
      end.

      if return-value <> {&SUCCESS-RESULT}
      and ro_std_op    > ""
      then do:
         /* MESSAGE #13 - NOT A VALID CHOICE */
         {pxmsg.i &MSGNUM=13
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &FIELDNAME=""roStdOp""
            }
         if c-application-mode <> "API" then
            next-prompt ro_std_op with frame a.
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
      then do:
         if c-application-mode <> "API" then do:
            display
               wc_desc
               wc_mch_op    @ ro_mch_op
               wc_queue     @ ro_queue
               wc_wait      @ ro_wait
               wc_men_mch   @ ro_men_mc
               wc_setup_men @ ro_setup_men
            with frame a.
         end. /* c-application-mode <> "API" */
         else do:
            /* SET THE DEFAULTS IN API TABLE FOR AN ADD OPERATION */
            assign
               {mfaidflt.i ttRouting.roMchOp    wc_mch_op}
               {mfaidflt.i ttRouting.roQueue    wc_queue}
               {mfaidflt.i ttRouting.roWait     wc_wait}
               {mfaidflt.i ttRouting.roMenMch   wc_men_mch}
               {mfaidflt.i ttRouting.roSetupMen wc_setup_men}.
         end. /* c-application-mode = "API" */
      end. /* return-value = {&SUCCESS-RESULT} */
      else do:
         if c-application-mode <> "API" then
            display
               " " @ wc_desc
               ro_mch_op
               ro_queue
               ro_wait
               ro_men_mc
               ro_setup_men
            with frame a.
         else do:
            /* SET THE DEFAULTS IN API TABLE FOR AN ADD OPERATION */
            assign
               {mfaidflt.i ttRouting.roMchOp    ro_mch_op}
               {mfaidflt.i ttRouting.roQueue    ro_queue}
               {mfaidflt.i ttRouting.roWait     ro_wait}
               {mfaidflt.i ttRouting.roMenMch   ro_men_mch}
               {mfaidflt.i ttRouting.roSetupMen ro_setup_men}.
         end. /* c-application-mode = "API" */
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* SET ro_std_op */

   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      if c-application-mode = "API" and retry then
         undo mainloop, next mainloop.

      assign
         old_wkctr = ro_wkctr
         old_mch   = ro_mch.

      if c-application-mode <> "API" then do:
        /* In UI, updated values display and scrolling display works well if
        ** recno is null.
        */
         if {gpiswrap.i} then recno = ?.

         set
            ro_wkctr
            ro_mch
            with frame a no-validate editing:

            if frame-field = "ro_wkctr"
            or frame-field = "ro_mch"
            then do:

               {mfnp05.i wc_mstr wc_wkctr  " wc_mstr.wc_domain = global_domain and
               yes "  wc_wkctr "input ro_wkctr"}
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
                     wc_setup_men @ ro_setup_men
                  with frame a.
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
               next-prompt ro_wkctr with frame a.
               next.
            end. /* IF (go-pending OR (frame-field <> "ro_wkctr")) */
         end. /* EDITING: */
      end. /* c-application-mode <> "API" */
      else do:
         /* IF IT IS A REMOVE OPERATION, LEAVE ALL VALUES AS THEY ARE */
         /* SO THE VALIDATIONS ALL WORK */
         if ttRouting.operation <> {&REMOVE} then
            assign
               ro_wkctr = ttRouting.roWkctr
               ro_mch   = ttRouting.roMch.
      end. /* c-application-mode = "API" */

      if old_wkctr <> ro_wkctr
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_wkctr',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_wkctr with frame a.
            undo, retry.
         end.
      end.

      if old_mch <> ro_mch
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_mch',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_mch with frame a.
            undo, retry.
         end.
      end.

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

         if c-application-mode <> "API" then do:
            display
               wc_desc
            with frame a.

            if ( ro_wkctr entered
            and  ro_wkctr <> old_wkctr)
            or ( ro_mch entered
            and  ro_mch   <> old_mch  )
            or new (ro_det)
            then
               display
                  wc_mch_op    @ ro_mch_op
                  wc_queue     @ ro_queue
                  wc_wait      @ ro_wait
                  wc_men_mch   @ ro_men_mc
                  wc_setup_men @ ro_setup_men
               with frame a.
            else
               display
                  ro_mch_op
                  ro_queue
                  ro_wait
                  ro_men_mc
                  ro_setup_men
               with frame a.
         end. /* c-application-mode <> "API" */
      end. /* IF AVAILABLE wc_mstr THEN DO: */
      else if c-application-mode <> "API" then do:
         display
            " " @ wc_desc
            ro_mch_op
            ro_queue
            ro_wait
            ro_men_mc
            ro_setup_men
         with frame a.
      end. /* c-application-mode <> "API" */

      if return-value <> {&SUCCESS-RESULT}
      then do:
         /* MESSAGE #528 - WORK CENTER / MACHINE NOT FOUND */
         {pxmsg.i &MSGNUM=528
            &ERRORLEVEL={&APP-ERROR-RESULT}
         }
         if batchrun
         then
            undo mainloop, leave mainloop.

         if c-application-mode <> "API" then
            next-prompt ro_mch with frame a.
         undo, retry.
      end. /* IF NOT AVAILABLE wc_mstr THEN DO: */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* SET ro_wkctr ro_mch */

   if c-application-mode <> "API" then do:
      ststatus = stline[2].
      status input ststatus.
      del-yn = no.
   end. /* c-application-mode <> "API" */

   seta:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      if c-application-mode = "API" and retry then
         undo mainloop, next mainloop.

      assign
         old_desc      = ro_desc
         old_mch_op    = ro_mch_op
         old_tran_qty  = ro_tran_qty
         old_queue     = ro_queue
         old_wait      = ro_wait
         old_milestone = ro_milestone
         old_sub_lead  = ro_sub_lead
         old_setup_men = ro_setup_men
         old_men_mch   = ro_men_mch
         old_setup     = ro_setup
         old_move      = ro_move
         old_yield_pct = ro_yield_pct
         old_tool      = ro_tool
         old_vend      = ro_vend
         old_inv_value = ro_inv_value
         old_sub_cost  = ro_sub_cost.

      if c-application-mode <> "API" then do:
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
            ro_tool
            ro_vend
            ro_inv_value
            ro_sub_cost
            rocmmts
            go-on ("F5" "CTRL-D") with frame a no-validate
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

            if (go-pending or (frame-field <> "ro_tool" and ro_tool entered))
            and not validToolCode(input ro_tool:screen-value)
            then do:
               next-prompt ro_tool with frame a.
               next.
            end. /* IF (go-pending or ... */
         end. /* EDITING */
      end. /* c-application-mode <> "API" */
      else do:
         /* IF IT IS A REMOVE OPERATION, LEAVE ALL VALUES AS THEY ARE */
         /* SO THE VALIDATIONS ALL WORK */
         if ttRouting.operation <> {&REMOVE} then
         assign
            ro_desc      = ttRouting.roDesc
            ro_mch_op    = ttRouting.roMchOp
            ro_tran_qty  = ttRouting.roTranQty
            ro_queue     = ttRouting.roQueue
            ro_wait      = ttRouting.roWait
            ro_milestone = ttRouting.roMilestone
            ro_sub_lead  = ttRouting.roSubLead
            ro_setup_men = ttRouting.roSetupMen
            ro_men_mch   = ttRouting.roMenMch
            ro_setup     = ttRouting.roSetup
            ro_run       = ttRouting.roRun
            ro_move      = ttRouting.roMove
            rostart      = ttRouting.roStart
            roend        = ttRouting.roEnd
            ro_yield_pct = ttRouting.roYieldPct
            ro_tool      = ttRouting.roTool
            ro_vend      = ttRouting.roVend
            ro_inv_value = ttRouting.roInvValue
            ro_sub_cost  = ttRouting.roSubCost.
      end. /* c-application-mode = "API" */

      /* VALIDATE FIELD SECURITY */
      if old_desc <> ro_desc
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_desc',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_desc with frame a.
            undo, retry.
         end.
      end.

      if old_mch_op <> ro_mch_op
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_mch_op',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_mch_op with frame a.
            undo, retry.
         end.
      end.

      if old_tran_qty <> ro_tran_qty
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_tran_qty',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_tran_qty with frame a.
            undo, retry.
         end.
      end.

      if old_queue <> ro_queue
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_queue',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_queue with frame a.
            undo, retry.
         end.
      end.

      if old_wait <> ro_wait
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_wait',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_wait with frame a.
            undo, retry.
         end.
      end.

      if old_milestone <> ro_milestone
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_milestone',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_milestone with frame a.
            undo, retry.
         end.
      end.

      if old_sub_lead <> ro_sub_lead
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_sub_lead',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_sub_lead with frame a.
            undo, retry.
         end.
      end.

      if old_setup_men <> ro_setup_men
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_setup_men',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_setup_men with frame a.
            undo, retry.
         end.
      end.

      if old_men_mch <> ro_men_mch
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_men_mch',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_men_mch with frame a.
            undo, retry.
         end.
      end.

      if old_setup <> ro_setup
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_setup',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_setup with frame a.
            undo, retry.
         end.
      end.

      if old_move <> ro_move
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_move',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_move with frame a.
            undo, retry.
         end.
      end.

      if old_yield_pct <> ro_yield_pct
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_yield_pct',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_yield_pct with frame a.
            undo, retry.
         end.
      end.

      if old_tool <> ro_tool
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_tool',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_tool with frame a.
            undo, retry.
         end.
      end.

      if not ({gpcode.v ro_tool})
      then do:
         /* VALUE MUST EXIST IN GENERALIZED CODES */
         {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3 &FIELDNAME=""roTool""}
         if c-application-mode <> "API" then
            next-prompt ro_tool with frame a.
         undo, retry.
      end.

      if old_vend <> ro_vend
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_vend',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_vend with frame a.
            undo, retry.
         end.
      end.

      if old_inv_value <> ro_inv_value
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_inv_value',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_inv_value with frame a.
            undo, retry.
         end.
      end.

      if old_sub_cost <> ro_sub_cost
      then do:
         {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
            &HANDLE=ph_gpsecxr
            &PARAM="(input 'ro_sub_cost',
                     input '')"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               next-prompt ro_sub_cost with frame a.
            undo, retry.
         end.
      end.

      /* VALIDATE ENTRY OF START DATE */
      {pxrun.i &PROC = 'validateStart' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  rostart,
           buffer ro_det)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API" then
            next-prompt rostart with frame a.
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
         if c-application-mode <> "API" then
            next-prompt rostart with frame a.
         undo, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE OVERLAP OF DATE RANGE WITH EXISTING ROUTING OPERATION */
      /* BASED ON THE ENTERED START AND END DATE                        */
      {pxrun.i &PROC = 'validateDateRange' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  rostart,
           input  roend,
           buffer ro_det)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API" then
            next-prompt roend with frame a.
         undo seta, retry seta.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE ENTRY OF YIELD PERCENTAGE */
      {pxrun.i &PROC = 'validateYield' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input ro_yield_pct)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API" then
            next-prompt ro_yield_pct with frame a.
         undo, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* CALCULATE CYCLE RATE BASED ON THE RUN TIME ENTERED */
      {pxrun.i &PROC = 'calculateCycleRate' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input  ro_run,
           output ro_cyc_rate)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      /* DELETE */
      if ((lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Delete to be executed if batchdelete is set to "x" */
      or input batchdelete = "x":U) and
         c-application-mode <> "API") or
      (c-application-mode = "API" and ttRouting.operation = {&REMOVE})
      then do:
         if c-application-mode <> "API" then do:
            del-yn = yes.
            /* MESSAGE #11 - PLEASE CONFIRM DELETE */
            {pxmsg.i &MSGNUM=11
               &ERRORLEVEL={&INFORMATION-RESULT}
               &CONFIRM=del-yn
            }
            if del-yn = no
            then
               undo seta.
         end. /* c-application-mode <> "API" */

         {rwrodel.i}

         if c-application-mode <> "API" then
            clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
         del-yn = no.
         next mainloop.
      end. /* THEN DO: */

      if ro_mch_op = ?
      then do:
         /* UNKNOWN VALUE (QUESTION MARK) NOT ALLOWED. */
         {pxmsg.i &MSGNUM=1235 &ERRORLEVEL=3 &PAUSEAFTER=TRUE}
         if c-application-mode <> "API"
         then
            next-prompt ro_mch_op with frame a.
            undo, retry.
      end. /* IF ro_mch_op = ? */

      if ro_sub_lead = ?
      then do:
         /* UNKNOWN VALUE (QUESTION MARK) NOT ALLOWED. */
         {pxmsg.i &MSGNUM=1235 &ERRORLEVEL=3 &PAUSEAFTER=TRUE}
         if c-application-mode <> "API"
         then
            next-prompt ro_sub_lead with frame a.
         undo, retry.
      end. /* IF ro_sub_lead = ? */

      if c-application-mode = "API" then do:
         /* Run any customizations in API mode for ro_det */
         run applyCustomizations in ApiMethodHandle
            (input "ttRouting",
             input (buffer ro_det:handle),
             input "a",
             output lCustomOK).

         if not lCustomOK then
            undo, retry.
      end.

      if rocmmts = yes or c-application-mode = "API"
      then do:
         /* Let the API controller know the name of the transaction */
         /* comments buffer.                                        */
         if c-application-mode = "API" then do:
            run setCommonDataBuffer in ApiMethodHandle
               (input "ttRoutingComment").
         end. /* c-application-mode = "API" */

         if ro_std_op > ""
         then
            global_ref = ro_std_op.
         else
            global_ref = string(ro_op).

         cmtindx = ro_cmtindx.
         {gprun.i ""gpcmmt01.p"" "(input ""ro_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

         assign
            ro_cmtindx = cmtindx
            global_ref = "".
      end. /* IF rocmmts = yes THEN DO: */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO ON ERROR UNDO, RETRY: */

   {gprun.i ""rwromta.p"" "(input recid(ro_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO ON ERROR UNDO, RETRY: */

if c-application-mode <> "API" then
   status input.
