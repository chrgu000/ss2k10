/* GUI CONVERTED from rwromt.p (converter v1.69) Mon Jul  7 18:02:26 1997 */
/* rwromt.p - ROUTING MAINTENANCE                                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 1.0      LAST MODIFIED: 06/17/86   BY: EMB                 */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*           */
/* REVISION: 4.0      LAST MODIFIED: 01/26/88   BY: pml *A119*          */
/* REVISION: 4.0      LAST MODIFIED: 02/17/88   BY: RL  *A171*          */
/* REVISION: 4.0      LAST MODIFIED: 03/21/88   BY: WUG *A194*          */
/* REVISION: 4.0      LAST MODIFIED: 12/07/88   BY: emb *A554*          */
/* REVISION: 5.0      LAST MODIFIED: 07/03/89   BY: emb *B169*          */
/* REVISION: 5.0      LAST MODIFIED: 03/26/91   BY: emb *B923*          */
/* REVISION: 7.3      LAST MODIFIED: 11/10/92   BY: emb *G689*          */
/* REVISION: 7.3      LAST EDIT:     02/24/93   BY: sas *G740*          */
/* REVISION: 7.3      LAST MODIFIED: 04/29/93   BY: pma *GA43*          */
/* REVISION: 7.3      LAST MODIFIED: 05/14/93   BY: qzl *GA87*          */
/* REVISION: 7.3      LAST MODIFIED: 05/19/93   BY: pma *GB19*          */
/* REVISION: 7.3      LAST MODIFIED: 06/02/93   BY: dzs *GB32*          */
/* REVISION: 7.3      LAST MODIFIED: 10/22/93   BY: ais *GF70*          */
/* REVISION: 7.3      LAST MODIFIED: 08/22/94   BY: pxd *FQ36*          */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *GM49*          */
/* REVISION: 7.3      LAST MODIFIED: 10/26/94   BY: pxd *GN57*          */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/94   BY: qzl *F0B3*          */
/* REVISION: 7.2      LAST MODIFIED: 12/20/94   BY: ais *F0B7*          */
/* REVISION: 7.2      LAST MODIFIED: 02/01/95   BY: pxd *F0GP*          */
/* REVISION: 7.2      LAST MODIFIED: 04/14/95   BY: qzl *F0Q6*          */
/* REVISION: 7.2      LAST MODIFIED: 12/04/95   BY: bcm *G1F4*          */
/* REVISION: 7.3      LAST MODIFIED: 01/03/96   BY: bcm *G1HY*          */
/* REVISION: 7.3      LAST MODIFIED: 04/23/96   BY: jym *G1SS*          */
/* REVISION: 8.5      LAST MODIFIED: 07/26/96   BY: *G29T* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12T* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 10/29/96   BY: *J16X* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 03/19/97   BY: *G2LK* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 06/24/97   BY: *G2NN* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 07/03/97   BY: *G2NS* Maryjeane Date     */
/* REVISION: 8.5      LAST MODIFIED: 10/16/03   BY: Kevin                     */

/* Note: Changes made here may also be needed in fsromt.p, fmromt.p,
            and fmopmta.p */

/*! FIELD USAGE:

    ro_cyc_rate CONTAINS THE INPUT VALUE OF PRODUCTION RATE, WHICH IS THEN
                INVERTED TO CALCULATE THE RUN TIME.  BOTH VALUES ARE NOW STORED
                IN THE DATABASE TO ELIMINATE ROUNDING DISCREPANCIES IN THE
                INVERSION CALCULATIONS.  *G1HY*
	Last change:  Q    19 Mar 97    1:21 pm
*/

         /* DISPLAY TITLE */
         {mfdtitle.i "e+ "} /*GF70*/

         define variable description like pt_desc1.
         define variable del-yn like mfc_logical initial no.
         define variable rocmmts like mfc_logical initial no label "说明".
         define new shared variable cmtindx as integer.
/*G740*/ define buffer rodet for ro_det.
/*GA87*/ define variable i as integer.
/*GA87*/ define buffer cmtdet for cmt_det.
/*GF70*/ define variable rorecid as recid.
/*GF70*/ define variable rostart like ro_start.
/*J16X*/ define variable is-ssm-routing like mfc_logical.

         def var sidesc like si_desc.                     /*kevin*/
         def var msg-nbr as inte.                         /*kevin*/

/*G1SS*/ /* USING THE FORMAT WITH OUT COMMAS WILL PREVENT ROUNDING ERRORS */
         /* WHICH CAN BE INTRODUCED BY PROGRESS LIKE IN THE NUMBER        */
         /* 1234.9999999   (see ro_run)                                   */

         /* DISPLAY SELECTION FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ro_routing      colon 30 description    no-label
            ro_op           colon 30
/*GB19      format ">>>>>" */
            skip(1)
            ro__chr01     colon 30 label "地点" sidesc no-label       /*kevin*/
            ro_std_op       colon 30
            ro_wkctr        colon 30 wc_desc        no-label
            ro_mch          colon 30 /*GB32 skip(1)*/
            ro_desc         colon 30
            ro_mch_op       colon 30
/*G689*/       format ">>>,>>9"
/*G689*/                               ro_milestone colon 60
            ro_tran_qty     colon 30   ro_sub_lead  colon 60
            ro_queue        colon 30   ro_setup_men colon 60
            ro_wait         colon 30   ro_men_mch   colon 60
            skip(1)
            ro_setup        colon 30   ro_yield_pct colon 60
            ro_run          colon 30
/*G1SS*/      format ">>>>>>>>9.9<<<<<<<<"
                                       ro_tool      colon 60
            ro_move         colon 30   ro_vend      colon 60
            ro_start        colon 30
/*GB32*/                               ro_inv_value colon 60
            ro_end          colon 30   ro_sub_cost  colon 60
                                       rocmmts      colon 60
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



         /* DISPLAY */
         view frame a.
         mainloop:
         repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


            description = "".
/*GF70*/    rorecid = ?.

            prompt-for ro_routing ro_op editing:

               /* SET GLOBAL PART VARIABLE */
               global_part = input ro_routing.

               if frame-field = "ro_routing" then do:
                  /* FIND NEXT/PREVIOUS RECORD */
/*GA43            {mfnp.i ro_det ro_routing ro_routing ro_op ro_op
                          ro_routing}  */
/*J12T* /*GA43*/  {mfnp.i ro_det ro_routing ro_routing ro_routing ro_routing */
/*J12T*                   ro_routing}                                        */
/*J12T*/          /* NEXT/PREV THROUGH NON-SERVICE ROUTINGS ONLY */
/*J12T*/          {mfnp05.i ro_det ro_fsm_type
                        "ro_fsm_type = "" "" " ro_routing
                        "input ro_routing"}
               end.
               else if frame-field = "ro_op" then do:
                  /* FIND NEXT/PREVIOUS RECORD */
/*GF70            {mfnp01.i ro_det ro_op ro_op ro_routing
                  "input ro_routing" ro_routing}          */
/*GF70*/          recno = rorecid.
/*GF70*/          {mfnp06.i ro_det ro_routing "ro_routing = input ro_routing"
                            ro_op "input ro_op" ro_op "input ro_op"}
               end.
               else do:
                  readkey.
                  apply lastkey.
               end.

/*GF70*/       rostart = ?.
               if recno <> ? then do:
/*GF70*/          rostart = ro_start.
                  description = "".
                  find pt_mstr where pt_part = ro_routing no-lock no-error.
                  if available pt_mstr then description = pt_desc1.
                  find wc_mstr where wc_wkctr = ro_wkctr and wc_mch = ro_mch
                    no-lock no-error.
               
               find si_mstr where si_site = ro__chr01 no-lock no-error.     /*kevin*/ 
               if available si_mstr then
                    sidesc = si_desc.
               else sidesc = "".     
                  display
                     ro__chr01 sidesc                                         /*kevin*/
                     ro_std_op ro_routing description
                     ro_op ro_std_op ro_wkctr.

                  if available wc_mstr then display wc_desc.
                  else display " " @ wc_desc.
                  if ro_cmtindx <> 0 then rocmmts = yes. else rocmmts = no.

                  display
                     ro_mch ro_desc ro_mch_op
                     ro_tran_qty ro_queue ro_wait
/*G689*/             ro_milestone
                     ro_sub_lead
                     ro_setup_men ro_men_mch
                     ro_setup ro_run ro_move
                     ro_yield_pct ro_start
                     ro_end ro_tool ro_vend
/*GB32*/             ro_inv_value
                     ro_sub_cost
                     rocmmts.
/*GF70*/          rorecid = recno.
                  recno = ?.
               end.
            end.

            /* ADD/MOD/DELETE */

/*J16X*/    /* CHECK TO SEE IF ANY OPERATION ARE SSM OPERATIONS   */
/*J16X*/    is-ssm-routing = no.
/*J16X*/    if (can-find (first ro_det where ro_fsm_type = "FSM"
/*J16X*/    using ro_routing)) then do:
/*J16X*/      is-ssm-routing = yes.
/*J16X*/      release ro_det.
/*J16X*/    end.

            find pt_mstr where pt_part = input ro_routing no-lock no-error.
            if available pt_mstr then description = pt_desc1.

/*J12T*     REMOVED REFERENCES TO QAD_WKFL...
./*G740*/    find first qad_wkfl
./*G740*/         where qad_key1 = "ro_fsm_op"
./*G740*/         and   qad_key2 begins input ro_routing
./*GN57*/         and   substring(qad_key2,1,18) = input ro_routing
./*G740*/         no-lock no-error.
.
./*G740*/    if available qad_wkfl then do:
./*G740*/       {mfmsg.i 7423 3}     /* THIS IS A SERVICE ROUTING
.                                       NOT A STANDARD ROUTING */
./*G740*/       undo , retry .
./*G740*/    end.
.*J12T*/

/*GF70      find ro_det using ro_routing and ro_op no-error.     */
/*GF70*/    /*  USE RO_DET FROM PREV/NEXT IF APPLICABLE          */
/*GF70*/    if rorecid <> ?
/*G29T*GF70*    then find ro_det where recid(ro_det) = rorecid no-error.  */
/*G29T*/        then find ro_det exclusive-lock
/*G29T*/             where recid(ro_det) = rorecid no-error.
/*GF70*/    if not avail ro_det or (avail ro_det and (
/*GF70*/       ro_routing <> input ro_routing or ro_op <> input ro_op or
/*GF70*/       ((ro_start <> rostart) and (rostart <> ?))))
/*GF70*/    then find first ro_det where
/*G29T*GF70*   ro_routing = input ro_routing and ro_op = input ro_op no-error.*/
/*G29T*/       ro_routing = input ro_routing and ro_op = input ro_op
/*G29T*/       exclusive-lock no-error.

/*J16X*     FOLLOWING CODE MOVED BELOW...
./*J12T*/    if available ro_det then
./*J12T*/        if ro_fsm_type <> " " then do:
./*J12T*/            {mfmsg.i 7423 3}     /* THIS IS A SERVICE ROUTING NOT A
.                                             STANDARD ROUTING */
./*J12T*/            undo , retry .
./*J12T*/        end.
.*J16X*     END OF MOVED CODE   */

/*added by kevin, 10/22/2003 for site control*/
          if available ro_det and ro__chr01 <> "" then do:
                 
                 find si_mstr no-lock where si_site = ro__chr01 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     {mfmsg.i msg-nbr 3}
                     undo, retry.
                 end.
            
            if available si_mstr then disp si_site @ ro__chr01 si_desc @ sidesc with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.
         end. /*if available ro_det*/
/*end added by kevin, 10/22/2003*/

            if not available ro_det then do:

/*J16X*        NEW SSM ROUTINGS NOT ALLOWED TO BE CREATED IN THIS PROGRAM  */
               if is-ssm-routing then do:
                 {mfmsg.i 7423 3}
                 /* THIS IS A SERVICE ROUTING, NOT A STANDARD ROUTING */
                 undo mainloop, retry mainloop.
               end.
/*J16X*        END ADDED CODE */

               {mfmsg.i 1 1}
               create ro_det.

/* PATCH J0FH SHOULD BE REMOVED WHEN THE SCHEMA IS OPEN AND THE DEFAULT     */
/* VALUE CAN BE CHANGED FOR THE FIELD RO_MV_NXT_OP - ALSO NORMALIZED THE    */
/* BELOW ASSIGN INTO ONE ASSIGN STATEMENT                                   */

/*J0FH         assign ro_routing ro_op. */
/*J0FH*/       assign ro_routing ro_op
/*J0FH*/         ro_mv_nxt_op = yes
/*G689*/         ro_milestone = yes.

               disp global_site @ ro__chr01 with frame a.       /*kevin,01/17/2004*/ 

            end.
            recno = recid(ro_det).


            /* SET GLOBAL PART VARIABLE */
            global_part = ro_routing.
          
          find si_mstr where si_site = ro__chr01 no-lock no-error.          /*kevin*/
          if available si_mstr then
                sidesc = si_desc.
          else sidesc = "".
            display ro_routing description ro_op 
            ro__chr01 sidesc                                                  /*kevin*/
            ro_std_op ro_wkctr.

            find wc_mstr where wc_wkctr = ro_wkctr and wc_mch = ro_mch
            no-lock no-error.
            if available wc_mstr then display wc_desc.
            else display " " @ wc_desc.

            if ro_cmtindx <> 0 then rocmmts = yes. else rocmmts = no.

            display
               ro_mch ro_desc ro_mch_op ro_tran_qty ro_queue ro_wait
/*G689*/       ro_milestone
               ro_sub_lead ro_setup_men ro_men_mch ro_setup ro_run ro_move
               ro_yield_pct ro_start ro_end ro_tool ro_vend
/*GB32*/       ro_inv_value
               ro_sub_cost rocmmts.

/*J16X*     IF THIS OPERATION IS SSM ISSUE ERROR-IF NOT AND ANY OPERATION */
/*          IN THIS ROUTING IS SSM, THEN ISSUE WARNING ONLY               */
            if ro_fsm_type = "FSM" then do:
                 {mfmsg.i 7423 3}
                 /* THIS IS A SERVICE ROUTING, NOT A STANDARD ROUTING */
                 undo mainloop, retry mainloop.
            end.
            if is-ssm-routing then do:
                 {mfmsg.i 1643 2}
            end.
/*J16X*     END ADDED CODE */

/*added by kevin, 10/17/2003 for site control*/
         if ro__chr01 = "" then disp global_site @ ro__chr01 with frame a.
                     
          set ro__chr01 with frame a editing:
               {mfnp.i si_mstr ro__chr01 si_site ro__chr01 si_site si_site}
               if recno <> ? then
                    disp si_site @ ro__chr01 si_desc @ sidesc with frame a. 
          end.
          
                 find si_mstr no-lock where si_site = input ro__chr01 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     {mfmsg.i msg-nbr 3}
                     undo, retry.
                 end.
            
            disp si_site @ ro__chr01 si_desc @ sidesc with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.             
           
          assign global_site = ro__chr01.               /*kevin,01/17/2004*/
                
/*end added by kevin, 10/17/2003*/

            if new ro_det then do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               set 
               ro_std_op editing:
                  if frame-field = "ro_std_op" then do:
                     {mfnp05.i opm_mstr opm_std_op yes
                      opm_std_op "input ro_std_op"}

                     if recno <> ? then do:
                        find wc_mstr where wc_wkctr = opm_wkctr
                        and wc_mch = opm_mch no-lock no-error.
                        display
                           opm_std_op @ ro_std_op
                           opm_desc @ ro_desc
                           opm_wkctr @ ro_wkctr
                           opm_mch @ ro_mch
                           opm_tran_qty @ ro_tran_qty
/*G689*/                   opm_mile @ ro_milestone
                           opm_sub_lead @ ro_sub_lead.

                        if available wc_mstr then
                        display
                           wc_desc
                           wc_mch_op @ ro_mch_op
                           wc_queue @ ro_queue
                           wc_wait @ ro_wait
                           wc_men_mch @ ro_men_mc
                           wc_setup_men @ ro_setup_men.
                        else
                        display
                            " " @ wc_desc
                            ro_mch_op ro_queue ro_wait
                            ro_men_mc ro_setup_men.

                        display
                           opm_setup @ ro_setup
                           opm_run @ ro_run
                           opm_move @ ro_move
                           opm_yld_pct @ ro_yield_pct
                           opm_tool @ ro_tool
                           opm_vend @ ro_vend
/*GB32*/                   opm_inv_val @ ro_inv_value
                           opm_sub_cost @ ro_sub_cost.
                     end.
                  end.
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                  end.
               end.


               find opm_mstr where opm_std_op = ro_std_op no-lock no-error.
               if available opm_mstr then /*G740*/ do:
/*G740*/          {fsopmv.i opm_std_op 2}
               display opm_std_op @ ro_std_op
                  opm_desc @ ro_desc
                  opm_wkctr @ ro_wkctr
                  opm_mch @ ro_mch
                  opm_tran_qty @ ro_tran_qty
/*G689*/          opm_mile @ ro_milestone
                  opm_sub_lead @ ro_sub_lead
                  opm_setup @ ro_setup
                  opm_run @ ro_run
                  opm_move @ ro_move
                  opm_yld_pct @ ro_yield_pct
                  opm_tool @ ro_tool
                  opm_vend @ ro_vend
/*GB32*/          opm_inv_val @ ro_inv_value
                  opm_sub_cost @ ro_sub_cost.

/*GA87*/            if opm_cmtindx <> 0 then do:
/*GA87*/                display yes @ rocmmts.
/*GA87*/                {gpcmtcpy.i &old_index = opm_cmtindx
/*GA87*/                            &new_index = ro_cmtindx
/*GA87*/                            &counter   = i}
/*GA87*/            end.
/*GA87*/            else display no @ rocmmts.

/*added by kevin, 10/16/2003 for verify whether the standard op is same as the input site*/
                if opm__chr01 <> input ro__chr01 then do:
                    message "标准工序所对应的地点 '" + opm__chr01
                             + "' 与本工序地点不一致,请重新输入!" view-as alert-box error.
                    next-prompt ro_std_op.
                    undo,retry.
                end.
/*end added by kevin, 10/16/2003*/

/*G740*/       end.
               else
               display
                  ro_desc ro_wkctr ro_mch
                  ro_tran_qty
/*G689*/          ro_milestone
                  ro_sub_lead
                  ro_setup ro_run ro_move
                  ro_yield_pct ro_tool
                  ro_vend
/*GB32*/          ro_inv_value
                  ro_sub_cost.

               if not available opm_mstr and ro_std_op > "" then do:
                  {mfmsg.i 13 3}
                  next-prompt ro_std_op.
                  undo, retry.
               end.

               if available opm_mstr then
               find wc_mstr no-lock where wc_wkctr = opm_wkctr
               and wc_mch = opm_mch no-error.
               else
               find wc_mstr no-lock where wc_wkctr = ro_wkctr
               and wc_mch = ro_mch no-error.

               if available wc_mstr then
               display
                  wc_desc
                  wc_mch_op @ ro_mch_op
                  wc_queue @ ro_queue
                  wc_wait @ ro_wait
                  wc_men_mch @ ro_men_mc
                  wc_setup_men @ ro_setup_men.
               else
               display
                  " " @ wc_desc
                  ro_mch_op ro_queue ro_wait ro_men_mc ro_setup_men.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               set ro_wkctr ro_mch editing:
                  if frame-field = "ro_wkctr"
                  or frame-field = "ro_mch"
                  then do:
                     {mfnp05.i wc_mstr wc_wkctr yes wc_wkctr "input ro_wkctr"}
                     if recno <> ? then do:
                        display
                           wc_wkctr @ ro_wkctr
                           wc_desc
                           wc_mch @ ro_mch
                           wc_mch_op @ ro_mch_op
                           wc_queue @ ro_queue
                           wc_wait @ ro_wait
                           wc_men_mch @ ro_men_mc
                           wc_setup_men @ ro_setup_men.
                     end.
                  end.
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                  end.
               end.

               find wc_mstr where wc_wkctr = ro_wkctr and wc_mch = ro_mch
               no-lock no-error.
               if available wc_mstr then do:
/*G740*/          {fswcv.i &fld=wc_wkctr &type=2}
                  display wc_desc.
                  if ro_wkctr entered or ro_mch entered or new (ro_det)
                  then display
                     wc_mch_op @ ro_mch_op
                     wc_queue @ ro_queue
                     wc_wait @ ro_wait
                     wc_men_mch @ ro_men_mc
                     wc_setup_men @ ro_setup_men.
                  else
                     display ro_mch_op ro_queue ro_wait ro_men_mc ro_setup_men.
               end.
               else display
                  " " @ wc_desc
                  ro_mch_op ro_queue ro_wait
                  ro_men_mc ro_setup_men.

               if not available wc_mstr then do with frame a:
                  {mfmsg.i 528 3}
                  next-prompt ro_mch.
                  undo, retry.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            ststatus = stline[2].
            status input ststatus.
            del-yn = no.

            seta:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2NN*         DO NOT PERFORM ASSIGN STATEMENTS...
./*G2LK*        BEGIN NEW CODE   */
.               if retry then assign
.                  ro_desc
.                  ro_mch_op
.                  ro_tran_qty
.                  ro_queue
.                  ro_wait
.                  ro_milestone
.                  ro_sub_lead
.                  ro_setup_men
.                  ro_men_mch
.                  ro_setup
.                  ro_run
.                  ro_move
.                  ro_start
.                  ro_end
.                  ro_yield_pct
.                  ro_tool
.                  ro_vend
.                  ro_inv_value
.                  ro_sub_cost
.                  rocmmts.
./*G2LK*        END NEW CODE   */
.*G2NN*         END OF REMOVED CODE     */

/*G2LK*        set     */
/*G2NS* /*G2LK*/       update  */

/*G2NS*/          set
                  ro_desc ro_mch_op ro_tran_qty
                  ro_queue ro_wait
/*G689*/          ro_milestone
                  ro_sub_lead ro_setup_men ro_men_mch
                  ro_setup ro_run ro_move
                  ro_start ro_end ro_yield_pct
                  ro_tool ro_vend
/*GB32*/          ro_inv_value
                  ro_sub_cost rocmmts
               go-on ("F5" "CTRL-D").

/*F0B3*/       if (ro_start <> ? and ro_end <> ?) then
/*F0B3*/       if ro_start > ro_end then do:
/*F0B3*/          {mfmsg.i 4 3}
/*F0B3*/          next-prompt ro_start.
/*F0B3*/          undo, retry.
/*F0B3*/       end.

/*F0B7*/       if ro_yield_pct = 0
/*F0B7*/       then do:
/*F0B7*/          {mfmsg.i 3953 3}
/*F0B7*/          next-prompt ro_yield_pct.
/*F0B7*/          undo, retry.
/*F0B7*/       end.
/*F0Q6* /*FQ36*/ ro_cyc_rate = 1 / ro_run. */
/*G1HY*/       ro_cyc_rate = if ro_run <> 0 then 1 / ro_run
/*G1HY*/                     else 0.

               /* DELETE */
               if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = yes.
                  {mfmsg01.i 11 1 del-yn}
                  if del-yn = no then undo seta.

/*F0GP*/          find first sop_det where sop_routing =
/*F0GP*/                   ro_routing no-lock no-error.
/*F0GP*/          if available sop_det then do:
/*F0GP*/            {mfmsg.i 5402 3}
/*F0GP*/            next mainloop.
/*F0GP*/          end.

                  /*! DELETE COMMENTS */
/*GM49*/          for each cmt_det exclusive-lock where cmt_indx = ro_cmtindx:
                     delete cmt_det.
                  end.

/*G1F4*/          /*! DELETE SIDE-FILE DATA */
/*G1F4*/          for each qad_wkfl where qad_key1 = "ro_det"
/*G1F4*/                                        + string(ro_routing,"x(18)")
/*G1F4*/                                        + string(ro_op,"99999")
/*G1F4*/          exclusive-lock:

/*G1F4*/             delete qad_wkfl.
/*G1F4*/          end.

                  delete ro_det.
                  clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
                  del-yn = no.
                  next mainloop.
               end.

               if rocmmts = yes then do:
                  if ro_std_op > "" then global_ref = ro_std_op.
                  else global_ref = string(ro_op).
                  cmtindx = ro_cmtindx.
                  {gprun.i ""gpcmmt01.p"" "(input ""ro_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  ro_cmtindx = cmtindx.
                  global_ref = "".
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*GN76*/    {gprun.i ""rwromta.p"" "(input recid(ro_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         status input.
