/* xxsfoptr01.p - LABOR FEEDBACK BY WORK ORDER TRANSACTION                */
/* GUI CONVERTED from sfoptr01.p (converter v1.71) Fri May 22 23:59:59 1998 */
/* sfoptr01.p - LABOR FEEDBACK BY WORK ORDER TRANSACTION                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 4.0     LAST MODIFIED: 02/03/88    BY: rl  *A171*          */
/* REVISION: 4.0     LAST MODIFIED: 05/04/88    BY: flm *A222*          */
/* REVISION: 4.0     LAST MODIFIED: 08/18/88    BY: flm *A398*          */
/* REVISION: 4.0     LAST MODIFIED: 09/09/88    BY: flm *A431*          */
/* REVISION: 4.0     LAST MODIFIED: 09/20/88    BY: flm *A443*          */
/* REVISION: 4.0     LAST MODIFIED: 09/21/88    BY: flm *A449*          */
/* REVISION: 4.0     LAST MODIFIED: 12/27/88    BY: flm *A571*          */
/* REVISION: 5.0     LAST MODIFIED: 02/08/89    BY: flm *B029*          */
/* REVISION: 4.0     LAST MODIFIED: 03/29/89    BY: rl  *A688*          */
/* REVISION: 5.0     LAST MODIFIED: 09/26/89    BY: mlb *B316*          */
/* REVISION: 5.0     LAST MODIFIED: 12/11/89    BY: wug *B437*          */
/* REVISION: 5.0     LAST MODIFIED: 02/07/90    BY: pml *B555*          */
/* REVISION: 5.0     LAST MODIFIED: 04/25/90    BY: emb *B672*          */
/* REVISION: 5.0     LAST MODIFIED: 07/05/90    BY: emb *B728*          */
/* REVISION: 6.0     LAST MODIFIED: 01/24/91    BY: emb *D315*          */
/* REVISION: 6.0     LAST MODIFIED: 03/22/91    BY: emb *D448*          */
/* REVISION: 6.0     LAST MODIFIED: 04/30/91    BY: emb *D600*          */
/* REVISION: 6.0     LAST MODIFIED: 06/14/91    BY: emb *D704*          */
/* REVISION: 6.0     LAST MODIFIED: 07/24/91    BY: bjb *D782*          */
/* REVISION: 6.0     LAST MODIFIED: 08/02/91    BY: pma *D806*(rev only)*/
/* REVISION: 7.0     LAST MODIFIED: 12/10/91    BY: dgh *D960*          */
/* REVISION: 7.0     LAST MODIFIED: 04/29/92    BY: emb *F445*          */
/* REVISION: 7.3     LAST MODIFIED: 12/07/92    BY: emb *G400*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 03/15/93    BY: emb *G876*          */
/* REVISION: 7.3     LAST MODIFIED: 03/31/93    BY: ram *G886*          */
/* REVISION: 7.3     LAST MODIFIED: 05/18/93    BY: pma *GB08*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 08/05/93    BY: emb *GD95*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 06/02/94    BY: pxd *FO53*          */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: WUG *GN76*          */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    BY: mwd *J034*          */
/* REVISION: 7.2     LAST MODIFIED: 07/17/95    BY: qzl *F0T9*          */
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    BY: jym *G1Q9*          */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*          */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6      LAST MODIFIED: 10/19/00   BY: *JY004* Frankie Xu* */

         /* DISPLAY TITLE */
         {mfdtitle.i "a+ "} /*GD95*/

/*K001*/ {gldydef.i new}
/*K001*/ {gldynrm.i new}

/*D782*/ define new global shared variable global_rsntyp like rsn_type.

/*G876*/ {sfopvar.i "new shared"}
/*G1Q9*/ define new shared variable gldetail like mfc_logical no-undo init no.
/*G1Q9*/ define new shared variable gltrans like mfc_logical no-undo init no.
         define variable msgnbr like msg_nbr.
         define variable wonbr like wr_nbr.
         define variable wolot like wr_lot.
         define variable yn like mfc_logical.

/*F0T9*/ /* RE-ARRANGED FIELD POSITIONS TO DISPLAY FULL OP DESC */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*F0T9*     wr_nbr         colon 20                        wr_lot colon 62
      *     wr_op          colon 20
      *     wr_desc        no-label format "x(20)"       wrstatus colon 62
      *     skip(1)
      *     emp            colon 20 emp_lname no-label format "x(18)"
      *                                                      earn colon 62
      *     dept           colon 20 op_wkctr colon 43    time_ind colon 62
      *     shift          colon 20   op_mch colon 43     project colon 62
*F0T9*/
/*F0T9*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wr_nbr         colon 17                        wr_lot colon 62
/*F0T9*/    wr_op          colon 17
/*F0T9*/    wr_desc        no-label                      wrstatus colon 62
/*F0T9*/    skip(1)
/*F0T9*/    emp            colon 17 emp_lname no-label format "x(18)"
/*F0T9*/                                                     earn colon 62
/*F0T9*/    dept           colon 17 op_wkctr colon 40    time_ind colon 62
/*F0T9*/    shift          colon 17   op_mch colon 40     project colon 62
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*G876*/ {sfopfmb.i} /* frame b definition */

/*G876*  /* Moved frame definition to sfopfmb.i */
         form
            op_qty_comp    colon 20
            op_date        colon 62
            total_rej      colon 20
            wocomp         colon 62
            total_rwk      colon 20
            move           colon 62 skip(1)
            start_setup    colon 20
            stop_setup     colon 20
            op_act_setup   colon 62 format "->>>9.999" label "Elapsed Setup"
            start_run      colon 20
            stop_run       colon 20
            op_act_run     colon 62 format "->>>9.999" label "Elapsed Run"
            op_comment     colon 20
            downtime       colon 20
            reason         colon 62
         with frame b side-labels width 80 attr-space.
         *G876*/

/*K001*/ if daybooks-in-use then
/*K001*/    {gprun.i ""nrm.p"" "persistent set h-nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* DISPLAY */
         view frame a.
         view frame b.

         find first ea_mstr where ea_type = "1" no-lock no-error.
         if available ea_mstr then earn = ea_earn.
         else earn = "".

         find first opc_ctrl no-lock no-error.
         if available opc_ctrl then do:
            if opc_time_ind = "D" then time_ind = yes.
            else time_ind = no.
            move = opc_move.
         end.
         release opc_ctrl.

         display earn time_ind with frame a.

/*D782*/ global_rsntyp = "down".

         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            do transaction with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


               ststatus = stline[1].
               status input ststatus.
               wrnbr = "".

               prompt-for wr_nbr wr_lot wr_op editing:

                  if frame-field = "wr_nbr" then do:

                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp.i wr_route wr_nbr wr_nbr wr_nbr wr_nbr wr_nbr}
                     wonbr = input wr_nbr.
                  end.
                  else if frame-field = "wr_lot" then do:

                     if wonbr = "" then do:
                        /* FIND NEXT/PREVIOUS RECORD */
                        {mfnp.i wr_route wr_lot wr_lot wr_lot wr_lot wr_lot}
                     end.
                     else do:
                       /* FIND NEXT/PREVIOUS RECORD FOR THE WORK ORDER NUMBER */
                        {mfnp01.i wr_route wr_lot wr_lot
                        "input wr_nbr" wr_nbr wr_nbrop}
                     end.
                     wolot = input wr_lot.
                  end.
                  else if frame-field = "wr_op" then do:

                     if input wr_nbr > ""
                     and wolot = "" then do:
                        /* FIND NEXT/PREVIOUS RECORD */
                        {mfnp01.i wr_route wr_op wr_op
                        "input wr_nbr" wr_nbr wr_nbrop}
                     end.
                     else do:
                        /* FIND NEXT/PREVIOUS RECORD */
                        {mfnp01.i wr_route wr_op wr_op
                        "input wr_lot" wr_lot wr_lot}
                     end.
                  end.
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                  end.

                  if recno <> ? then do:
                     {mfwrstat.i wrstatus}
                     display wr_nbr wr_lot wr_op wr_desc wrstatus
                        wr_wkctr @ op_wkctr wr_mch @ op_mch.

                     find wo_mstr no-lock where wo_nbr = wr_nbr
                     and wo_lot = wr_lot no-error.
                     display wo_project @ project.
                     find wc_mstr no-lock where wc_wkctr = wr_wkctr
                     and wc_mch = wr_mch no-error.
                     if available wc_mstr then display wc_dept @ dept.
                  end.
                  recno = ?.
               end.

               if input wr_nbr > "" and input wr_lot > ""
               and input wr_op > "" then
               find wr_route
/*F445*/       no-lock
               using wr_nbr and wr_lot and wr_op no-error.

               if input wr_nbr > "" and input wr_lot = ""
               and input wr_op > "" then
               find first wr_route
/*F445*/       no-lock
               using wr_nbr and wr_op no-error.

               if input wr_nbr = "" and input wr_lot > ""
               and input wr_op > "" then
               find wr_route
/*F445*/       no-lock
               using wr_lot and wr_op no-error.

               if not available wr_route then do:
                  next-prompt wr_nbr.
/*FO53*/          msgnbr = 510.
                  if input wr_nbr > "" and input wr_lot > "" then do:
                     find first wo_mstr where wo_nbr = input wr_nbr
                     and wo_lot = input wr_lot no-lock no-error.
                     if not available wo_mstr then do:

                        msgnbr = 510. /* Work order/lot does not exist */

                        if can-find (first wo_mstr where wo_nbr = input wr_nbr)
                        and can-find (first wo_mstr where wo_lot = input wr_lot)
                        then msgnbr = 508.
                        /* Lot number belongs to different work order */
                     end.
                  end.

                  if input wr_nbr > "" and input wr_lot = "" then do:

                     find first wo_mstr no-lock
                     where wo_nbr = input wr_nbr no-error.
                     if not available wo_mstr
                     then msgnbr = 503. /* Work order number does not exist */
                  end.

                  if input wr_nbr = "" and input wr_lot > "" then do:
                     next-prompt wr_lot.
                     find first wo_mstr no-lock
                     where wo_lot = input wr_lot no-error.
                     if not available wo_mstr
                     then msgnbr = 509. /* Lot number does not exist */
                  end.
                  if not available wo_mstr then do:
                     {mfmsg.i msgnbr 3}
                     undo, retry.
                  end.
               end.

               if not available wr_route then do:
                  {mfmsg.i 511 3} /* Work order operation does not exist */
                  next-prompt wr_op.
                  undo, retry.
               end.

               if wr_status = "C" then do:
                  {mfmsg.i 524 3} /* "Operation closed". */
                  next-prompt wr_op.
                  undo, retry.
               end.

               find wo_mstr no-lock where wo_nbr = wr_nbr
               and wo_lot = wr_lot no-error.
               if available wo_mstr then do:
                  if lookup(wo_status,"R,C") = 0 then do:
                     /* RELEASED & CLOSED ORDERS ONLY */
                     {mfmsg02.i 525 3 wo_status}
                     next-prompt wr_nbr.
                     undo, retry.
                  end.

                  /*GN76 ADDED FOLLOWING SECTION*/
                  if wo_type = "c" and wo_nbr = "" then do:
                     {mfmsg.i 5123 3}
                     undo, retry.
                  end.
                  /*GN76 END SECTION*/

/*J034*/          {gprun.i ""gpsiver.p""
                   "(input wo_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg02.i 2710 3 wo_site} /* USER DOES NOT HAVE  */
/*J034*/                                        /* ACCESS TO SITE XXXX */
/*J034*/             undo mainloop, retry.
/*J034*/          end.
               end.

               wrnbr = wr_nbr.
               wrlot = wr_lot.

               {mfwrstat.i wrstatus}
               display wr_nbr wr_lot wr_op wr_desc wrstatus
               wr_wkctr @ op_wkctr wr_mch @ op_mch.

               find wo_mstr where wo_lot = wr_lot no-lock no-error.
               display wo_project @ project.
               find wc_mstr where wc_wkctr = wr_wkctr
               and wc_mch = wr_mch no-lock no-error.
               if available wc_mstr then display wc_dept @ dept.

               clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

               do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                  prompt-for emp dept shift op_wkctr op_mch
                  earn time_ind project editing:

                     if frame-field = "emp" then do:

                        /* FIND NEXT/PREVIOUS RECORD */
                        {mfnp.i emp_mstr emp emp_addr emp emp_addr emp_addr}

                        if recno <> ? then do:
                           display emp_addr @ emp emp_lname.
                        end.
                     end.
                     else if frame-field = "op_wkctr" then do:

                        /* FIND NEXT/PREVIOUS RECORD */
                       {mfnp.i wc_mstr op_wkctr wc_wkctr op_mch wc_mch wc_wkctr}

                        if recno <> ? then do:
                           display wc_wkctr @ op_wkctr wc_mch @ op_mch.
                           if input dept = "" then display wc_dept @ dept.
                        end.
                     end.
                     else if frame-field = "op_mch" then do:

                        /* FIND NEXT/PREVIOUS RECORD */
                        {mfnp01.i wc_mstr op_mch wc_mch "input op_wkctr"
                        wc_wkctr wc_wkctr}

                        if recno <> ? then do:
                           display wc_wkctr @ op_wkctr wc_mch @ op_mch.
                           if input dept = "" then display wc_dept @ dept.
                        end.
                     end.
                     else do:
                        status input.
                        readkey.
                        apply lastkey.
                     end.
                  end.

                  find emp_mstr where emp_addr = input emp no-lock no-error.
                  if not available emp_mstr then do:
                     next-prompt emp.
                     {mfmsg.i 520 3} /* Employee number does not exist */
                     undo,retry.
                  end.

/*D448*/          if lookup(emp_status,"AC,PT") = 0 then do:
/*D448*/             next-prompt emp.
/*D448*/             {mfmsg.i 4027 3} /* "Employee not on active status" */
/*D448*/             undo,retry.
/*D448*/          end.

                  assign dept.
                  if available emp_mstr and input dept = "" then do:
                     dept = emp_dept.
                     display dept.
                  end.

                  find first dpt_mstr where dpt_dept = dept no-lock no-error.
                  if not available dpt_mstr then do:
                     next-prompt dept.
                     {mfmsg.i 532 3} /* Department does not exist */
                     undo, retry.
                  end.
                  if input earn <> "" then do:
                     find first ea_mstr no-lock
                     where ea_earn = input earn no-error.
                     if not available ea_mstr then do:
                        next-prompt earn.
                        {mfmsg.i 4025 3} /* Invalid earnings code */
                        undo, retry.
                     end.
                  end.

                  assign emp earn shift dept project.
                  if available emp_mstr then display emp_lname.

                  find first wc_mstr where wc_wkctr = input op_wkctr
                  and wc_mch = input op_mch no-lock no-error.
                  if not available wc_mstr then do:
                     next-prompt op_wkctr.
                     {mfmsg.i 528 3}
                     undo, retry.
                  end.

                  if wc_dept <> dept then do:
                     {mfmsg02.i 540 2 wc_dept}
                     yn = no.
                     {mfmsg01.i 32 1 yn}
                     if yn = no then undo, retry.
                  end.

                  if project = "" then do:
                     find wo_mstr where wo_nbr = wr_nbr
                     and wo_lot = wr_lot no-lock.
                     project = wo_project.
                     display project.
                  end.

/*G886*/          /* VALIDATE PROJECT */
/*G886*/          {gpglprj2.i
                     &project=project
                  }

               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               recno = recid(wr_route).
               wr_recno = recid(wr_route).
               wc_recno = recid(wc_mstr).

               assign time_ind.
               status input.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*JY004**   {gprun.i ""sfoptra.p""}     **/
/*JY004*/   {gprun.i ""xxsfoptra.p""}     

/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         status input.
/*K001*/ if daybooks-in-use then delete procedure h-nrm no-error.
