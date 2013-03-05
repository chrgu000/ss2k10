/* rwromt.p - ROUTING MAINTENANCE                                             */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.24.2.2 $                                                      */
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
/* Revision: 1.24.2.1    LAST MODIFIED: 10/09/01  BY: *M1L9* Anil Sudhakaran  */
/* $Revision: 1.24.2.2 $   LAST MODIFIED: 10/23/01  BY: *N14Y* Saurabh C.     */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/* ADM1   12/09/03 Brian Lo -add audit trail logic                            */
/* ADM1a  04/30/04 Derek Chu-add audit trail for deletion                    */
/* ADM2   05/21/04 Derek Chu-control QUOT part by quot user list             */
/* ADM3   08/16/04 Shiyu He -Add four fields to input:pt__dec01 stand qty,pt__dec02 card qty,
                             pt__chr10 stand pack unit,pt__chr09 card pack unit */

/*! FIELD USAGE:
ro_cyc_rate CONTAINS THE INPUT VALUE OF PRODUCTION RATE, WHICH IS THEN
            INVERTED TO CALCULATE THE RUN TIME.  BOTH VALUES ARE NOW STORED
            IN THE DATABASE TO ELIMINATE ROUNDING DISCREPANCIES IN THE
            INVERSION CALCULATIONS.  *G1HY*
Last change:  Q    19 Mar 97    1:27 pm
*/

/* DISPLAY TITLE */
{mfdtitle.i "b+d3"}

{pxmaint.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rwromt_p_1 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable cmtindx as integer.

define variable description    like pt_desc1 no-undo.
define variable del-yn         like mfc_logical initial no no-undo.
define variable rocmmts        like mfc_logical initial no no-undo
   label {&rwromt_p_1}.
define variable rostart        like ro_start no-undo.
define variable roend          like ro_end   no-undo.
define variable i              as   integer  no-undo.
define variable rorecid        as   recid    no-undo.
define variable conflicts      as   logical  no-undo.
define variable is-ssm-routing as   logical  no-undo.

define buffer rodet  for ro_det.
define buffer cmtdet for cmt_det.

/*ADM3*/define variable isitem         like mfc_logical initial no no-undo.
/*ADM3*/define variable ptdec01 like pt__dec01 no-undo.
/*ADM3*/define variable ptdec02 like pt__dec02 no-undo.
/*ADM3*/define variable ptchr10 like pt__chr10 no-undo.
/*ADM3*/define variable ptchr09 like pt__chr09 no-undo.
/*ADM3*/define variable um as char format "x(48)" init "(1-袋;2-盆;3-籃;4-輪;5-片;6-板;7-紙;8-箱)" no-undo.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* FOR REPLACING SCHEMA VALIDATION OF ROUTING WORK CENTER */
FUNCTION validWorkCenter RETURNS logical (input workCenter as character):
   {pxrun.i &PROC = 'validateWorkCenter' &PROGRAM = 'rwroxr.p'
            &PARAM = "(input workCenter)"
            &NOAPPERROR = True
            &CATCHERROR = True}
   RETURN (return-value = {&SUCCESS-RESULT}).
END FUNCTION. /* validWorkCenter */

/* FOR REPLACING SCHEMA VALIDATION OF ROUTING TOOL CODE */
FUNCTION validToolCode RETURNS logical (input toolCode as character):
   {pxrun.i &PROC = 'validateToolCode' &PROGRAM = 'rwroxr.p'
            &PARAM = "(input toolCode)"
            &NOAPPERROR = True
            &CATCHERROR = True}
   RETURN (return-value = {&SUCCESS-RESULT}).
END FUNCTION. /* validToolCode */

/* USING THE FORMAT WITHOUT COMMAS WILL PREVENT ROUNDING ERRORS */
/* WHICH CAN BE INTRODUCED BY PROGRESS LIKE IN THE NUMBER       */
/* 1234.9999999   (see ro_run)                                  */

/*ADM2*/ {quotuser.i}

/*DISPLAY SELECTION FORM*/
form
   ro_routing      colon 20
   description     no-label
   ro_op           colon 20
   ro_start        colon 43
   ro_end          colon 68 /*ADM skip(1) */
   um              colon 30 no-label
   ro_std_op       colon 30
   ro_wkctr        colon 30
   wc_desc         no-label
   ro_mch          colon 30
/*ADM3*/
   ptdec01       colon 64 label "Plas Bin" format ">>>>>>>9" 
   ptchr10       colon 74 no-label format "x(2)"  
/*ADM3*/ 
   ro_desc         colon 30
/*ADM3*/
   ptdec02       colon 64 label "Pallet"  format ">>>>>>>9"
   ptchr09       colon 74 no-label format "x(2)"  
/*ADM3*/
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
with frame a width 80 no-validate side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

/*ADM1*/
{gpaud.i &uniq_num1 = 01  &uniq_num2 = 02
         &db_file = ro_det &db_field = ro_routing}
/*ADM1 end*/

/*ADM3*/ {wbrp01.i} 

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
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
      end. /* if frame-field = "ro_routing" then do: */
      else if frame-field = "ro_op"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         if available ro_det and
            ro_routing = input ro_routing
         then
            recno = rorecid.
         {mfnp06.i ro_det ro_routing "ro_routing = input ro_routing"
            ro_op "input ro_op" ro_op "input ro_op"}
      end. /* else if frame-field = "ro_op" then do: */
      else if frame-field = "ro_start"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         recno = rorecid.
         {mfnp08.i ro_det ro_routing "TRUE"
            ro_routing "INPUT ro_routing"
            ro_op "INPUT ro_op"
            ro_op "INPUT ro_op"}
      end. /* else if frame-field = "ro_start" then do: */
      else do:
         readkey.
         apply lastkey.
      end. /* else do: */
/*ADM3*/
      find pt_mstr where pt_part = ro_routing no-lock no-error.
      if available pt_mstr then do:
          isitem = yes. 
          ptchr10 = pt__chr10.
          ptchr09 = pt__chr09.
          ptdec01 = pt__dec01.
          ptdec02 = pt__dec02.
      end.
      else do:
          isitem = no.
          ptchr10 = "". 
          ptchr09 = "". 
          ptdec01 = 0.
          ptdec02 = 0.
      end.    
/*ADM3*/
      rostart = ?.
      if recno <> ?
      then do:
         assign
            rostart     = ro_start
            description = "".

         /* READ ITEM MASTER RECORD BASED ON ROUTING ID */
         {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppitxr.p'
                  &PARAM = "(input  ro_routing:screen-value,
                             buffer pt_mstr,
                             input  no,
                             input  no)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

         if return-value = {&SUCCESS-RESULT} then description = pt_desc1.

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

         if return-value = {&SUCCESS-RESULT} then display wc_desc.
            else display " " @ wc_desc.
         if ro_cmtindx <> 0 then rocmmts = yes.
            else rocmmts = no.
         
/*ADM3 if isitem then display
/*ADM3*/    ptdec01 
/*ADM3*/    ptdec02 .*/
            
         display
/*ADM3*/    um
            ro_mch
            ro_desc
/*ADM3*/    ptdec01 
/*ADM3*/    ptchr10
            ro_mch_op
/*ADM3*/    ptdec02 
/*ADM3*/    ptchr09
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
            rocmmts.

         assign
            rorecid = recno
            recno   = ?.
      end. /* if recno <> ? then do: */
   end. /* editing: */

   /* ADD/MOD/DELETE */
/**ADM2*/ 
          if isquotuser then do:
	     if substr(ro_routing:screen-value,1,4) <> "QUOT" then do:
               if global_user_lang = "tw" then
		  compmsg ="您只可處理 QUOT 的物料.".
	       else
	          compmsg ="You only allow to process QUOT Part#".
	       {mfmsg03.i 2685 1 compmsg """" """"}
	       undo,retry.
	     end.
	  end.
          else do: 
	    if substr(ro_routing:screen-value,1,4) = "QUOT" then do:
               if global_user_lang = "tw" then
		  compmsg ="只有 QUOT USER 可處理 QUOT 的物料.".
	       else
	          compmsg ="Only QUOT USER allow to process QUOT Part#".
	       {mfmsg03.i 2685 1 compmsg """" """"}
	       undo,retry.
	    end.
          end.
/**ADM2*/ 

   /* CHECK TO SEE IF ANY OPERATION ARE SSM OPERATIONS */
   is-ssm-routing = no.
   if {pxfunct.i &FUNCTION = 'validateServiceOpRouting' &PROGRAM = 'rwroxr.p'
                 &PARAM = "input ro_routing:screen-value"
                 &NOAPPERROR = True
                 &CATCHERROR = True}
   then do:
      is-ssm-routing = yes.
      release ro_det.
   end. /* using ro_routing)) then do: */

   /* READ ITEM MASTER RECORD BASED ON ROUTING ID */
   {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppitxr.p'
            &PARAM = "(input  ro_routing:screen-value,
                       buffer pt_mstr,
                       input  no,
                       input  no)"
            &NOAPPERROR = true
            &CATCHERROR = true}

   if return-value = {&SUCCESS-RESULT} then description = pt_desc1.

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

   if return-value = {&RECORD-LOCKED} then do:
      {pxmsg.i
         &MSGNUM=7006
         &ERRORLEVEL=4
      }
      undo, retry.
   end.

   if return-value <> {&SUCCESS-RESULT}
   then do:

      /* VALIDATE ENTRY OF BLANK OR SSM ROUTING */
      {pxrun.i &PROC = 'validateRoutingCodeEntry' &PROGRAM = 'rwroxr.p'
               &PARAM = "(input ro_routing:screen-value,
                          input is-ssm-routing)"
               &NOAPPERROR = True
               &CATCHERROR = True}

      if return-value <> {&SUCCESS-RESULT} then
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
               &NOAPPERROR = True
               &CATCHERROR = True}
   end. /* if not available ro_det then do: */

   recno = recid(ro_det).

   /*ADM1*/
   {gpaud1.i &uniq_num1 = 01  &uniq_num2 = 02
      &db_file = ro_det &db_field = ro_routing}
   /*ADM1 end*/

   /* SET GLOBAL PART VARIABLE */
   global_part = ro_routing.
/*ADM3*/
      find pt_mstr where pt_part = ro_routing no-lock no-error.
      if available pt_mstr then do:
          isitem = yes.
          ptchr10 = pt__chr10. 
          ptchr09 = pt__chr09. 
          ptdec01 = pt__dec01.
          ptdec02 = pt__dec02.
      end.
      else do:
          isitem = no.
          ptchr10 = "".
          ptchr09 = "".
          ptdec01 = 0.
          ptdec02 = 0.
      end.    
/*ADM3*/

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

   if return-value = {&SUCCESS-RESULT} then display wc_desc.
   else display " " @ wc_desc.

   if ro_cmtindx <> 0 then rocmmts = yes.
   else rocmmts = no.

/*ADM3 if isitem then display
/*ADM3*/    ptdec01 
/*ADM3*/    ptdec02 .*/
            
   display
/*ADM3*/    um
      ro_mch
      ro_desc
/*ADM3*/ ptdec01
/*ADM3*/ ptchr10
      ro_mch_op
/*ADM3*/ ptdec02
/*ADM3*/ ptchr09
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
   end. /* if ro_fsm_type = "FSM" then do: */
   if is-ssm-routing
   then do:
      /* MESSAGE #1643 - ROUTING HAS SERVICE OPERATIONS */
      {pxmsg.i &MSGNUM=1643
               &ERRORLEVEL={&WARNING-RESULT}
      }
   end. /* if is-ssm-routing then do: */

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

               if return-value = {&SUCCESS-RESULT} then
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
            end. /* if recno <> ? then do: */
         end. /* if frame-field = "ro_std_op" then do: */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* else do: */
      end. /* editing: */

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
                  &NOAPPERROR = True
                  &CATCHERROR = True}
         if return-value <> {&SUCCESS-RESULT} then undo, retry.

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
            display yes @ rocmmts.

            /* COPY THE TRANSACTION COMMENTS FROM STANDARD OPERATION */
            {pxrun.i &PROC = 'copyComments' &PROGRAM = 'gpcmxr.p'
                     &PARAM = "(input  opm_cmtindx,
                                output ro_cmtindx)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}
         end. /* if opm_cmtindx <> 0 then do: */
         else display no @ rocmmts.

      end. /* do: */
      else
        display
/*ADM3*/    um
            ro_desc
            ro_wkctr
            ro_mch
/*ADM3*/    ptdec01
/*ADM3*/    ptchr10
/*ADM3*/    ptdec02            
/*ADM3*/    ptchr09
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

/*ADM3 if isitem then display
/*ADM3*/    ptdec01 
/*ADM3*/    ptdec02 .*/

      if return-value <> {&SUCCESS-RESULT} and ro_std_op > ""
      then do:
         /* MESSAGE #13 - NOT A VALID CHOICE */
         {pxmsg.i &MSGNUM=13
                  &ERRORLEVEL={&APP-ERROR-RESULT}
          }
         next-prompt ro_std_op.
         undo, retry.
      end. /* if not available opm_mstr and ro_std_op > "" then do: */

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
      end.
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
      end.

      if return-value = {&SUCCESS-RESULT} then
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
   end. /* set ro_std_op */

   do on error undo, retry:
      set
         ro_wkctr
         ro_mch
      editing:
         if frame-field = "ro_wkctr"
            or frame-field = "ro_mch"
         then do:
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
            end. /* if recno <> ? then do: */

         end. /* then do: */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* else do: */

         if (go-pending or (frame-field <> "ro_wkctr"))
         and not validWorkCenter(input ro_wkctr:screen-value)
         then do:
            next-prompt ro_wkctr.
            next.
         end.
      end. /* editing: */

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
                  &NOAPPERROR = True
                  &CATCHERROR = True}
         if return-value <> {&SUCCESS-RESULT} then undo, retry.

         display wc_desc.
         if ro_wkctr entered or ro_mch entered or new (ro_det) then
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
      end. /* if available wc_mstr then do: */
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
      end. /* if not available wc_mstr then do with frame a: */
      
/*ADM3*/
      find pt_mstr where pt_part = ro_routing no-error.
      if available pt_mstr then isitem = yes. else isitem = no.
      if isitem then do:
         if ptchr09 = "" then ptchr09 = "板".
         if ptchr10 = "" then ptchr10 = "袋".
         if not batchrun then do:
            update ptdec01 ptchr10 ptdec02 ptchr09 with frame a.
         end.
         {wbrp06.i &command = update &fields = "ptdec01 ptchr10 ptdec02 ptchr09"}
         
              case ptchr10:
                  when "1" then ptchr10 = "袋". 
                  when "2" then ptchr10 = "盆". 
                  when "3" then ptchr10 = "籃". 
                  when "4" then ptchr10 = "輪". 
                  when "5" then ptchr10 = "片". 
                  when "6" then ptchr10 = "板". 
                  when "7" then ptchr10 = "紙". 
                  when "8" then ptchr10 = "箱". 
              end case.
              
              case ptchr09:
                  when "1" then ptchr09 = "袋". 
                  when "2" then ptchr09 = "盆". 
                  when "3" then ptchr09 = "籃". 
                  when "4" then ptchr09 = "輪". 
                  when "5" then ptchr09 = "片". 
                  when "6" then ptchr09 = "板". 
                  when "7" then ptchr09 = "紙". 
                  when "8" then ptchr09 = "箱". 
              end case.
        	pt__dec01 = ptdec01.
         	pt__dec02 = ptdec02. 
         	pt__chr10 = ptchr10.            
         	pt__chr09 = ptchr09.            
      end.      
/*ADM3*/
      
   end. /* set ro_wkctr ro_mch */
   
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
         ro_tool
         ro_vend
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
         end.
         else do:
            readkey.
            apply lastkey.
            recno = ?.
         end.

         if (go-pending or (frame-field <> "ro_tool" and ro_tool entered))
         and not validToolCode(input ro_tool:screen-value)
         then do:
            next-prompt ro_tool.
            next.
         end.
      end. /* editing */

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
      end.

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
      end.

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
      end.

      /* VALIDATE ENTRY OF YIELD PERCENTAGE */
      {pxrun.i &PROC = 'validateYield' &PROGRAM = 'rwroxr.p'
               &PARAM = "(input ro_yield_pct)"
               &NOAPPERROR = true
               &CATCHERROR = true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt ro_yield_pct.
         undo, retry.
      end.

      /* CALCULATE CYCLE RATE BASED ON THE RUN TIME ENTERED */
      {pxrun.i &PROC = 'calculateCycleRate' &PROGRAM = 'rwroxr.p'
               &PARAM = "(input  ro_run,
                          output ro_cyc_rate)"
               &NOAPPERROR = true
               &CATCHERROR = true}

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      /* Delete to be executed if batchdelete is set to "x" */
      or input batchdelete = "x":U
      then do:
         del-yn = yes.
         /* MESSAGE #11 - PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11
                  &ERRORLEVEL={&INFORMATION-RESULT}
                  &CONFIRM=del-yn
         }
         if del-yn = no then undo seta.

         {rwrodel.i}

         /*ADM1a*/
         {gpaud2.i &uniq_num1 = 01 &uniq_num2 = 02
             &db_file = ro_det &db_field = ro_routing &db_field1 = ro_op }
         {gpaud3.i &uniq_num1 = 01  &uniq_num2 = 02
             &db_file = ro_det &db_field = ro_routing}
        /*ADM1a end*/   

         clear frame a.
         del-yn = no.
         next mainloop.
      end. /* then do: */

      if rocmmts = yes
      then do:
         if ro_std_op > "" then
            global_ref = ro_std_op.
         else
            global_ref = string(ro_op).

         cmtindx = ro_cmtindx.
         {gprun.i ""gpcmmt01.p"" "(input ""ro_det"")"}
         assign
            ro_cmtindx = cmtindx
            global_ref = "".
      end. /* if rocmmts = yes then do: */
   end. /* do on error undo, retry: */

   {gprun.i ""rwromta.p"" "(input recid(ro_det))"}

   /*ADM1*/
   {gpaud2.i &uniq_num1 = 01 &uniq_num2 = 02
             &db_file = ro_det &db_field = ro_routing &db_field1 = ro_op }
   {gpaud3.i &uniq_num1 = 01  &uniq_num2 = 02
             &db_file = ro_det &db_field = ro_routing}
   /*ADM1 end*/   
   
end. /* do on error undo, retry: */

            
status input.




