/* sfoptra.p - LABOR FEEDBACK CONTINUATION PROGRAM                            */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 4.0      LAST MODIFIED: 02/03/88   BY: RL  *A171*                */
/* REVISION: 4.0      LAST MODIFIED: 03/25/88   BY: WUG *A187*                */
/* REVISION: 4.0      LAST MODIFIED: 05/04/88   BY: flm *A222*                */
/* REVISION: 4.0      LAST MODIFIED: 05/06/88   BY: emb *A232*                */
/* REVISION: 4.0      LAST MODIFIED: 08/29/88   BY: flm *A411*                */
/* REVISION: 4.0      LAST MODIFIED: 09/12/88   BY: flm *A431*                */
/* REVISION: 5.0      LAST MODIFIED: 01/16/89   BY: flm *B015*                */
/* REVISION: 5.0      LAST MODIFIED: 02/02/89   BY: flm *B029*                */
/* REVISION: 5.0      LAST MODIFIED: 06/22/89   BY: emb *B153*                */
/* REVISION: 5.0      LAST MODIFIED: 09/26/89   BY: MLB *B316*                */
/* REVISION: 5.0      LAST MODIFIED: 02/28/90   BY: emb *B593*                */
/* REVISION: 5.0      LAST MODIFIED: 04/25/90   BY: emb *B672*                */
/* REVISION: 5.0      LAST MODIFIED: 07/05/90   BY: emb *B728*                */
/* REVISION: 6.0      LAST MODIFIED: 05/30/91   BY: emb *D704*                */
/* REVISION: 7.0      LAST MODIFIED: 10/08/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: dhg *D960*                */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: RAM *F298*                */
/* REVISION: 7.0      LAST MODIFIED: 04/29/92   BY: emb *F445*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: emb *F622*                */
/* REVISION: 7.0      LAST MODIFIED: 06/17/92   BY: smm *F614*                */
/* REVISION: 7.3      LAST MODIFIED: 12/07/92   BY: emb *G400*                */
/* REVISION: 7.3      LAST MODIFIED: 03/15/93   BY: emb *G876*                */
/* REVISION: 7.3      LAST MODIFIED: 05/18/93   BY: pma *GB08*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.2      LAST MODIFIED: 10/28/94   BY: ais *FS64*                */
/* REVISION: 7.2      LAST MODIFIED: 11/03/94   BY: ame *GO07*                */
/* REVISION: 7.3      LAST MODIFIED: 11/09/94   BY: WUG *GN76*                */
/* REVISION: 7.2      LAST MODIFIED: 03/23/95   BY: ais *F0NV*                */
/* REVISION: 7.4      LAST MODIFIED: 05/01/96   BY: jym *G1MN*                */
/* REVISION: 7.4      LAST MODIFIED: 08/27/96   BY: *G2D6*  Russ Witt         */
/* REVISION: 7.4      LAST MODIFIED: 09/22/97   BY: *H1FD*  Felcy D'Souza     */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/02/98   BY: *M00S* Sandesh Mahagaokar */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 09/10/00   BY: *N0JQ* Brian Smith        */
/* REVISION: 9.1      LAST MODIFIED: 05/30/01   BY: *M18V* Rajesh Thomas      */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/*N0JQ &SCOPED-DEFINE sfoptra_p_1 "General Ledger"*/
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*G876*/ {sfopvar.i "shared"}

         define new shared variable time_hm1 as character format "999:99:99".
         define new shared variable time_hm2 as character format "999:99:99".
         define new shared variable time_hd1 as decimal format "->>>9.999".
         define new shared variable time_hd2 as decimal format "->>>9.999".
         define new shared variable i as integer.
         define new shared variable j as integer.
         define new shared variable non_numeric as integer.
         define new shared variable date_change as integer.
         define new shared variable elapse as decimal format "->>>>>>>9.999".
         define new shared variable yn like mfc_logical.
/*F003   define new shared variable prev_found like mfc_logical. */
         define new shared variable pay_rate like emp_pay_rate.
         define new shared variable sf_lbr_acct like dpt_lbr_acct.
         define new shared variable sf_bdn_acct like dpt_bdn_acct.
         define new shared variable sf_wip_acct like dpt_lbr_acct.
         define new shared variable sf_cop_acct like dpt_lbr_acct.
/*N014*/ define new shared variable sf_lbr_sub like dpt_lbr_sub.
/*N014*/ define new shared variable sf_bdn_sub like dpt_bdn_sub.
/*N014*/ define new shared variable sf_wip_sub like dpt_lbr_sub.
/*N014*/ define new shared variable sf_cop_sub like dpt_lbr_sub.
         define new shared variable sf_lbr_cc like dpt_lbr_cc.
         define new shared variable sf_bdn_cc like dpt_lbr_cc.
         define new shared variable sf_wip_cc like dpt_lbr_cc.
         define new shared variable sf_cop_cc like dpt_cop_cc.
         define new shared variable sf_dr_acct like dpt_lbr_acct.
/*N014*/ define new shared variable sf_dr_sub like dpt_lbr_sub.
         define new shared variable sf_dr_cc like dpt_lbr_cc.
         define new shared variable sf_cr_acct like dpt_lbr_acct.
/*N014*/ define new shared variable sf_cr_sub like dpt_lbr_sub.
         define new shared variable sf_cr_cc like dpt_lbr_cc.
         define new shared variable sf_gl_amt like tr_gl_amt.
         define new shared variable ref like glt_ref.
         define new shared variable op_recno as recid.
/*G876*/ define new shared variable qty_comp like wr_qty_comp.
/*G876*  define variable qty_comp like wr_qty_comp. */
         define variable move1 like opc_move.
         define variable qty_wip like wr_qty_wip.
/*G2D6*/ define variable qty_comp_this_op like wr_qty_comp no-undo.

         define new shared variable start_time as character.
         define new shared variable stop_time as character.
         define new shared variable error_flag like mfc_logical.
         define new shared variable lead_trans like op_trnbr.
/*F614*/ define new shared variable wo_recno  as recid.

/*G876*/ define buffer ophist for op_hist.
/*G876*/ define new shared workfile rejfile no-undo
            field rejreason like op_rsn_rjct
            field rejqty like op_qty_rjct.

/*G876*/ define new shared workfile rwkfile no-undo
            field rwkreason like op_rsn_rwrk
            field rwkqty like op_qty_rwrk.

/*G876*/ define new shared variable complot like op_wo_lot.
/*G876*/ define new shared variable compop like op_wo_op.
/*G876*/ define new shared variable transtype as character.
/*G876*/ define new shared variable wo_recid as recid.

/*FS64*/ define variable curr_lot like wr_lot.
/*FS64*/ define variable curr_op  like wr_op.
/*M00S*/ define variable actrun   like op_act_run no-undo.

/*N002*/ define new shared variable h_wiplottrace_procs as handle no-undo.
/*N002*/ define new shared variable h_wiplottrace_funcs as handle no-undo.
/*N002*/ define new shared variable operation like wr_op no-undo.
/*N002*/ define new shared variable order_id like wr_lot no-undo.
/*N002*/ define variable undo_stat like mfc_logical no-undo.
/*N002*/ define variable move_to_wkctr like wc_wkctr no-undo.
/*N002*/ define variable move_to_mch like wc_mch no-undo.
/*N002*/ {wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
/*N002*/ {wlcon.i} /*CONSTANTS DEFINITIONS*/

/*N002*/ if is_wiplottrace_enabled() then do:
/*N002*/    {gprunmo.i &program=""wlpl.p"" &module="AWT"
            &persistent="""persistent set h_wiplottrace_procs"""}
/*N002*/    {gprunmo.i &program=""wlfl.p"" &module="AWT"
            &persistent="""persistent set h_wiplottrace_funcs"""}
/*N002*/ end.

/*G1MN* /*H039*/ {gpglefdf.i} */
/*G1MN*/ {gpglefv.i}


          /* ss - 130712.1 by: jack */
         DEFINE SHARED VAR v_down AS LOGICAL LABEL "Down" .
            define SHARED variable v_downtime as char format "x(09)" EXTENT 10 .
       define SHARED variable v_reason like rsn_code  EXTENT 10 .
        DEFINE  SHARED VAR v_nbr LIKE wr_nbr .
        DEFINE  shared VAR v_lot LIKE wr_lot .
        DEFINE  SHARED VAR v_op LIKE wr_op .
        DEFINE  shared VAR v_emp LIKE emp .
        DEFINE  shared VAR v_dept LIKE dept .
        DEFINE  SHARED VAR v_shift LIKE shift .
        DEFINE  shared VAR v_wkctr LIKE op_wkctr .
        DEFINE  shared VAR v_mch LIKE op_mch .
        DEFINE  shared VAR v_earn LIKE earn .
        DEFINE  shared VAR v_project LIKE project .
         /* ss - 130712.1 by: jack */

         /* ss - 130712.1 -
         {sfopfmb.i} /* frame b definition */
         */

         /* ss - 130712.1 - */
         {xxsfopfmb.i} /* frame b definition */

             eff_date = TODAY - 1  .
             /* ss - 130712.1 -e */

/*G876*  /* Moved frame b definition to sfopfmb.i */
.        form
.           op_qty_comp    colon 20
.           eff_date       colon 62
.           total_rej      colon 20
.           wocomp         colon 62
.           total_rwk      colon 20
.           move           colon 62 skip(1)
.           start_setup    colon 20
.           stop_setup     colon 20
.           op_act_setup   colon 62 format "->>>9.999" label "Elapsed Setup"
.           start_run      colon 20
.           stop_run       colon 20
.           op_act_run     colon 62 format "->>>9.999" label "Elapsed Run"
.           op_comment     colon 20
.           downtime       colon 20
.           reason         colon 62
.        with frame b side-labels width 80 attr-space.
.        *G876*/

/*G876*/ /* Added section */
         find first gl_ctrl no-lock no-error.
         if not available gl_ctrl then do:
/*N0JQ      msg_var1 = {&sfoptra_p_1}.*/
/*N0JQ*/    msg_var1 = getTermLabel("GENERAL_LEDGER",18).
            {mfmsg03.i 533 4 msg_var1 """" """"}
            leave.
         end.
/*G876*/ /* End of added section */

         /* DISPLAY */
         do transaction with frame b:

/*F445*     find wr_route where recid(wr_route) = wr_recno. */
/*F445*/    find wr_route no-lock where recid(wr_route) = wr_recno.

/*F0NV***   REMOVED THE FOLLOWING, AS SUPPORTING UTILITIES DO NOT EXIST YET
 *GN76*     {rewrsdef.i}
 *GN76*     {rewrsget.i &lot=wr_lot &op=wr_op}
 *GN76*     if substr(qad_charfld[10],84,1) > "" then
 *GN76*        move = wr_mv_nxt_op.
**F0NV**/
            find wc_mstr where recid(wc_mstr) = wc_recno no-lock no-error.
/*F298*/    find wo_mstr where wo_nbr = wr_nbr
            and wo_lot = wr_lot no-lock no-error.

            /* the default if no employee rate gets used */
            pay_rate = wc_lbr_rate.

            if emp <> "" then do:
               find first emp_mstr where emp_addr = emp no-lock no-error.
               if available emp_mstr
               and emp_pay_type = "HR" and emp_pay_rate <> 0
               then do:
                  pay_rate = emp_pay_rate.
                  if earn <> "" then do:
                     find first ea_mstr where ea_earn = earn no-lock no-error.
                     if available ea_mstr then pay_rate = pay_rate * ea_rate.
                  end.
               end.
            end.
            if not available emp_mstr then pay_rate = wc_lbr_rate.

            wocomp = yes.
/*G876*/    compprev = yes.
            if not time_ind then start_setup = string(0,"HH:MM:SS").
            else start_setup = string(0,"9.999").

            start_run = start_setup.
            stop_setup = start_setup.
            stop_run = start_setup.
            downtime = start_setup.
            total_rej = 0.
            total_rwk = 0.
/*GB08*/    reason = "".

/*G2D6*     BEGIN DELETED CODE
.           qty_comp = wr_qty_move - wr_qty_comp - wr_qty_rjct.
.           if wr_qty_move = 0 then do:
.              qty_comp = wr_qty_ord.
.              find prev wr_route no-lock
.              where wr_nbr = wrnbr and wr_lot = wrlot no-error.
.              if available wr_route then qty_comp = wr_qty_comp.
./*F445*       find wr_route where recid(wr_route) = wr_recno. */
./*F445*/      find wr_route no-lock where recid(wr_route) = wr_recno.
.           end.
.*G2D6*     END OF DELETED CODE   */
/*G2D6*/    qty_comp = min((wr_qty_move - wr_qty_comp - wr_sub_comp -
/*G2D6*/                    wr_qty_rjct), wr_qty_wip).
/*G2D6*/    if qty_comp < 0 then qty_comp = 0.

/*FS64*/    curr_lot = wr_lot.
/*FS64*/    curr_op = wr_op.
/*FS64*/    define buffer wrroute for wr_route.
/*FS64*/    do for wrroute:
/*FS64*/       find last wrroute where wrroute.wr_lot = curr_lot
/*FS64*/            use-index wr_lot no-lock no-error.
/*F0NV  *FS64* if  wrroute.wr_op > curr_op    */
/*F0NV  *FS64* then move = yes.               */
/*F0NV  *FS64* else move = no.                */
/*F0NV*/       if  wrroute.wr_op <= curr_op
/*F0NV*/       then move = no.
/*FS64*/    end.

            display qty_comp @ op_qty_comp
/*G876*        0 @ total_rej */
/*G876*        0 @ total_rwk */
/*G876*/       rejects reworks
               eff_date wocomp move
/*G876*/       compprev
               0 @ op_act_setup
               start_setup stop_setup
               0 @ op_act_run
               start_run stop_run /* 130712.1 -e */ v_down /* downtime reason */ .

            set_ophist:
            do on error undo, retry:
/*G876*        display 0 @ total_rej  0 @ total_rwk. */

               prompt-for op_qty_comp
/*G876*  /*F445*/ total_rej total_rwk */
/*G876*/          rejects reworks
                  eff_date wocomp move
/*G876*/          compprev
                  start_setup stop_setup start_run stop_run
                  op_comment  v_down /* downtime reason 130712.1 -e */
/*G876*/       with frame b.
/*G876*        /* Deleted section */
.              editing:
.
.                 readkey.
.
./*F445*          if frame-field = "eff_date"        and
.                 (keyfunction(lastkey) = "return" or
.                  keyfunction(lastkey) = "go"     or
.                  keyfunction(lastkey) = "tab")   then do: */
.
./*F445*           assign eff_date.
.                  if eff_date = ? then eff_date = today.
.                  /* CHECK GL EFFECTIVE DATE */
.                  {mfglef.i eff_date} */
.
./*F445*/          if frame-field = "total_rej"
./*F445*/          or frame-field = "total_rwk" then do:
.
.                     /* Collect multiple Rejects/Reworks with reasons */
.                     {gprun.i ""sfoptrd.p""}
.
.                     display total_rej total_rwk.
.
./*F445*              next-prompt wocomp. */
./*F445*/             next-prompt eff_date.
.                  end.
.                  else apply lastkey.
.               end.
.*G876*/        /* End of deleted section */

/*G876*  /*F445*/ assign total_rej total_rwk */
/*G876*/        assign rejects reworks
                eff_date
                comment = input op_comment.

/*F445*/        if eff_date = ? then eff_date = today.

                /* CHECK GL EFFECTIVE DATE */
/*F445*//*H039* {mfglef.i eff_date} */
/*G1MN* /*H039*/        {gpglef.i ""WO"" glentity eff_date} */
/*G1MN*/           find si_mstr where si_site = wo_site no-lock.
/*G1MN*/           {gpglef1.i
                     &module = ""WO""
                     &entity = si_entity
                     &date = eff_date
                     &prompt = "eff_date"
                     &frame = "b"
                     &loop = "set_ophist"
                     }

/*F298*/        /* ADDED FOLLOWING SECTION */
                /* CHECK FOR MASTER SPECIFICATION */
/*F614*/        wo_recno = recid(wo_mstr).

/*M18V*/        /* ADDED FOURTH PARAMETER eff_date IN CALL TO mpwindow.i */

                {mpwindow.i wr_part wr_op
                "if wo_routing = """" then wr_part else wo_routing"
                eff_date}


/*F298*/        /* END OF ADDED SECTION */

/*F445**        if not can-find(first op_hist where op_wo_lot = wr_lot
                and op_wo_op = wr_op) then do:
                   qty_wip = wr_qty_ord.
                   find prev wr_route
                   where wr_nbr = wrnbr and wr_lot = wrlot no-error.
                   if available wr_route then do:
                      qty_wip = wr_qty_comp.
                      wr_qty_wip = wr_qty_wip - wr_qty_comp.
                   end.
                   find wr_route where recid(wr_route) = wr_recno.
                   move1 = move.
                   move = no.
                   {mfopmv.i qty_wip}
                   move = move1.
                end.
                *F445*/

                assign wocomp move
/*G876*/        compprev
                start_setup stop_setup start_run stop_run
                /* downtime reason */ /* 130712.1 -e */ v_down.

                {mftimec.i start_setup stop_setup}

                display elapse @ op_act_setup.

                if not time_ind
                then
                display time_hm1 format "999:99:99" @ start_setup
                        time_hm2 format "999:99:99" @ stop_setup.
                else display time_hd1 @ start_setup time_hd2 @ stop_setup.

                {mftimec.i start_run stop_run}

/*M00S*/        assign actrun = elapse.

                display elapse @ op_act_run.

                if not time_ind
                then
                display time_hm1 format "999:99:99" @ start_run
                        time_hm2 format "999:99:99" @ stop_run.
                else display time_hd1 @ start_run time_hd2 @ stop_run.
/* 130715.1 -
                if downtime > "" then do:
                   stop_setup = "".
/*G400*            {mftimec.i downtime stop_setup} */
/*G400*/           {mftimec.i stop_setup downtime}

/*G400*            if not time_ind
                   then display time_hm1 format "999:99:99" @ downtime.
                   else display time_hd1 @ downtime. */

/*G400*/           if not time_ind
/*G400*/           then display time_hm2 format "999:99:99" @ downtime.
/*G400*/           else display time_hd2 @ downtime.

                   if elapse <> 0 and
                   can-find (first rsn_ref where rsn_type = "DOWN" ) then repeat
                   with frame b on endkey undo set_ophist, retry set_ophist:
                      find rsn_ref no-lock where rsn_type = "DOWN"
                      and rsn_code = reason no-error.
                      if available rsn_ref then leave.
                      {mfmsg.i 534 1} /* Please enter reason code */
                      bell.
                      update reason.
                   end.

                   if elapse = 0 then downtime = "".
                end.
                */

/*G876*/        /* Added section */
                if not rejects then do:
                   {mfdel.i "rejfile"}
                end.

                if not reworks then do:
                   {mfdel.i "rwkfile"}
                end.

                if rejects or reworks then do:
                   /* Collect multiple Rejects/Reworks with reason codes */
                   {gprun.i ""sfoptrd.p""}
                end.
                if total_rej <> 0 then display total_rej.
                else display no @ rejects "" @ total_rej.

                if total_rwk <> 0 then display total_rwk.
                else display no @ reworks "" @ total_rwk.
/*G876*/        /* End of added section */

/*G2D6*F445*    if input op_qty_comp > wr_qty_wip then do:            */
/*G2D6*/        if input op_qty_comp + total_rej > wr_qty_wip then do:
/*F445*/           {mfmsg.i 512 2} /* Qty completed + rejected
                                      exceeds quantity in WIP */
/*F445*/        end.

                /* ss - 130712.1 -b */
                    if v_down then do:
                   
                   {gprun.i ""xxsfoptrd.p""}
                   end.

/*G2D6*/        /* Added Section:  */
                /* ISSUE WARNING MESSAGE IF THE QUANTITY COMPLETED AT THIS   */
                /* OPERATION EXCEEDS ORDER QUANTITY AND IF QTY COMPLETE ALSO */
                /* EXCEEDS QTY COMPLETE AT PRIOR OPERATION (THIS ALLOWS THIS */
                /* MESSAGE TO ONLY APPEAR ONCE PER WORK ORDER, NOT AT ALL    */
                /* SUBSEQUENT OPERATION AFTER THE QTY COMPLETED HAS EXCEEDED */
                /* THE QUANTITY ORDERED)                                     */
                qty_comp_this_op = input op_qty_comp + total_rej +
                                   wr_qty_comp + wr_sub_comp + wr_qty_rjct.
                if qty_comp_this_op > wr_qty_ord then do:
                   find prev wr_route no-lock
                   where wr_nbr = wrnbr and wr_lot = wrlot no-error.
                   if not available wr_route or
                   qty_comp_this_op > wr_qty_comp + wr_sub_comp then do:
                      {mfmsg.i 1386 2} /* Quantity completed + rejected
                                          exceeds order quantity           */
                   end.
                   find wr_route no-lock where recid(wr_route) = wr_recno.
                end.
/*G2D6*/        /* End of Added Section  */

/*N002*/        if is_wiplottrace_enabled()
/*N002*/        and is_operation_queue_lot_controlled(wo_lot, wr_op,
/*N002*/                                              OUTPUT_QUEUE)
/*N002*/        then do:

/*N002*/         /* ASSIGN VARIABLES FOR SCROLLING WINDOW */
/*N002*/             assign
/*N002*/               operation = wr_op
/*N002*/               order_id = wr_lot
/*N002*/               .

/*N002*/             run init_bkfl_output_wip_lot_temptable
/*N002*/                 in h_wiplottrace_procs.

/*N002*/             for first pt_mstr where pt_part = wo_part no-lock: end.

/*N002*/             if not (is_last_operation(wr_lot, wr_op)) and move
/*N002*/             then do:

/*N002*/                assign
/*N002*/                  move_to_wkctr = wc_wkctr
/*N002*/                  move_to_mch = wc_mch
/*N002*/                  .

/*N002*/                  run get_destination_wkctr_mch_from_user
/*N002*/                      in h_wiplottrace_procs
/*N002*/                      (input wr_lot,
/*N002*/                       input next_milestone_operation(wr_lot, wr_op),
/*N002*/                       output move_to_wkctr,
/*N002*/                       output move_to_mch,
/*N002*/                       output undo_stat).

/*N002*/                       if undo_stat then undo, retry.
/*N002*/             end. /* if not last operation and move next operation */

/*N002*/                  run get_bkfl_output_wip_lots_from_user
/*N002*/                  in h_wiplottrace_procs
/*N002*/                  (input wr_lot, input wr_op, input input op_qty_comp,
/*N002*/                   input 1, input pt_um, input move, input wo_site,
/*N002*/                   input wc_wkctr, wc_mch, output undo_stat).
/*N002*/                   if undo_stat then do:
/*N002*/                      undo, retry.
/*N002*/                   end.

/*N002*/                   /* CHECK FOR MAX LOT SIZE EXCEEDED */
/*N002*/                   run bkfl_max_lotsize_check in h_wiplottrace_procs
/*N002*/                       (input wr_lot, input wr_op, input 1).

/*N002*/        end. /* if is_wiplottrace_enabled() */

/*F445*/        yn = yes.
/*F445*/        {mfmsg01.i 12 1 yn}
/*F445*/        if yn = no then undo, retry.

/*F445*/        find wo_mstr exclusive-lock where wo_nbr = wr_nbr
/*F445*/        and wo_lot = wr_lot no-error.

/*F445*/        find wr_route exclusive-lock where recid(wr_route) = wr_recno.

/*F445*/        /* MOVED FOLLOWING SECTION DOWN FROM ABOVE */
                if not can-find(first op_hist where op_wo_lot = wr_lot
                and op_wo_op = wr_op) then do:
                   qty_wip = wr_qty_ord.
                   find prev wr_route
                   where wr_nbr = wrnbr and wr_lot = wrlot no-error.
                   if available wr_route then do:
                      qty_wip = wr_qty_comp.
                      wr_qty_wip = wr_qty_wip - wr_qty_comp.
                   end.
                   find wr_route exclusive-lock where recid(wr_route) = wr_recno.
                   move1 = move.
                   move = no.
                   {mfopmv.i qty_wip}
                   move = move1.
                end.
/*F445*/        /* END OF SECTION MOVED DOWN FROM ABOVE */

                wr_act_setup = wr_act_setup + input op_act_setup.
/*M00S**        wr_act_run   = wr_act_run   + input op_act_run.         */
/*M00S*/        wr_act_run   = wr_act_run   + actrun.
                wr_qty_comp  = wr_qty_comp  + input op_qty_comp.
                wr_qty_rjct  = wr_qty_rjct  + total_rej.
                wr_qty_rwrk  = wr_qty_rwrk  + total_rwk.

                if wr_status <> "C" then do:
                   if wr_act_run > 0 then wr_status = "R".
                   else if wr_act_setup > 0 then wr_status = "S".
                   else wr_status = "Q".
                end.

/*F445*         if input op_qty_comp > wr_qty_wip then do:
.                  {mfmsg.i 512 2} /* Qty completed greater than qty WIP */
.               end. */

                wr_qty_wip = wr_qty_wip - total_rej.

                if wocomp then do:
                   wr_status = "C".
                end.

/*F445*         yn = yes.
.               {mfmsg01.i 12 1 yn}
.               if yn = no then undo, retry.
.               */

/*F003*         /* DELETED FOLLOWING SECTION */
.               prev_found = no.
.               find first op_hist where op_wo_lot = wr_lot
.               and op_wo_op = wr_op and op_type = "LABOR" no-lock no-error.
.               if available op_hist then prev_found = yes.
.*F003*/        /* END DELETED SECTION */

                create op_hist.

                {mfnoptr.i}

                assign op_wo_nbr = wr_nbr
                        op_wo_op = wr_op
                          op_emp = emp
                         op_earn = earn
                         op_dept = dept
/*G400*/                 op_site = wo_site
                        op_shift = shift
                      op_project = project
                       op_wo_lot = wr_lot
                         op_part = wr_part
                    op_tran_date = today
                         op_type = "LABOR"
                        op_wkctr = wc_wkctr
                          op_mch = wc_mch
                         op_date = eff_date
/*F622*/              op_std_run = wr_run
                     op_qty_comp
/*M00S**            op_act_setup op_act_run op_comment.            */
/*M00S*/            op_act_setup
/*M00S*/              op_act_run = actrun
/*M00S*/              op_comment.

                op_recno = recid(op_hist).

/*N002*/        if is_wiplottrace_enabled()
/*N002*/        and is_operation_queue_lot_controlled(wo_lot, wr_op,
/*N002*/                                              OUTPUT_QUEUE)
/*N002*/        then do:

/*N002*/             run bkfl_produce_wip_lots in h_wiplottrace_procs
/*N002*/                (input op_trnbr, input wr_lot, input wr_op,
/*N002*/                 input 1, input wo_site, input wc_wkctr,
/*N002*/                 input wc_mch).

/*N002*/             if not (is_last_operation(wr_lot, wr_op)) and move
/*N002*/             then do:
/*N002*/                   run bkfl_move_wip_lots in h_wiplottrace_procs
/*N002*/                       (input wr_lot, input wr_op, input 1,
/*N002*/                        input wo_site, input wc_wkctr, input wc_mch,
/*N002*/                        input move_to_wkctr, input move_to_mch).
/*N002*/             end. /* if not last operation */

/*N002*/        end. /* if is_wiplottrace_enabled() */

/*F622*/        if op_wkctr <> wr_wkctr or op_mch <> wr_mch
/*F622*/        then do:

/*H1FD*  FOLLOWING CODE IS COMMENTED OUT SINCE IT DOES NOT FIND THE       */
/*H1FD*  ALTERNATE WORK CENTER RUN RATE TO POPULATE THE STD RUN TIME IN   */
/*H1FD*  OPERATION HISTORY WHEN ITEM REPORTED HAS A ROUTING CODE DIFFERENT*/
/*H1FD*  FROM THE PART NUMBER.                                            */
/*H1FD*  THE FOLLOWING COMMENTED OUT CODE IS REPLACED BY REUPOPST.P       */

/*H1FD** /*F622*/    find wcr_route where wcr_part = op_part
 * /*F622*/          and wcr_wkctr = op_wkctr and wcr_mch = op_mch
 * /*F622*/          and wcr_op = op_wo_op no-lock no-error.
 * /*F622*/          if available wcr_route then
 * /*F622*/          if wcr_rate <> 0 then op_std_run = 1 / wcr_rate.
 *H1FD*/

/*H1FD   BEGIN OF ADDED CODE                                              */

                  {gprun.i ""reupopst.p""
                           "(input op_recno)"
              }

/*H1FD   END OF ADDED CODE                                                */

/*F622*/        end.

/*G876*         /* Deleted section */
./*F445*/       if lead_trans = 0 then assign
./*F445*/          op_qty_rjct = total_rej
./*F445*/          op_qty_rwrk = total_rwk.
.
.               if lead_trans > 0 then do:
.                  j = lead_trans.
.                  repeat:
.                     find first op_hist where op_trnbr >= j
.                     and op__dec01 =  lead_trans no-lock no-error.
.                     if not available op_hist then leave.
.                     else do:
.                        j = op_trnbr.
.                        find op_hist where op_trnbr = j exclusive-lock.
.                        op__dec01 = 0.
.                        op_comment = comment.
.                     end.
.                  end.
.               end.
.
.               find first gl_ctrl no-lock no-error.
.               if not available gl_ctrl then do:
.                  msg_var1 = "General Ledger".
.                  {mfmsg03.i 533 3 msg_var1 """" """"}.
.                  undo, retry.
.               end.
.
.               find op_hist where recid(op_hist) = op_recno.
.               op_qty_rjct = total_rej.
.
.               {gprun.i ""sfoptrc.p""}
.
./*F445*/       if lead_trans <> 0 then op_qty_rjct = 0.
.               lead_trans = 0.
.*G876*/        /* End of deleted section */

/*G876*/        /* Added section */
                assign op_qty_rjct = total_rej
                       op_qty_rwrk = total_rwk.

                {gprun.i ""sfoptrc.p""}

/*GO07*/        for each rejfile exclusive-lock where rejqty = 0:
                   delete rejfile.
                end.

/*GO07*/        for each rwkfile exclusive-lock where rwkqty = 0:
                   delete rwkfile.
                end.

                find first rejfile no-error.
                if available rejfile then do:
                   assign op_qty_rjct = rejqty
                          op_rsn_rjct = rejreason.
                   delete rejfile.
                end.
                find first rwkfile no-error.
                if available rwkfile then do:
                   assign op_qty_rwrk = rwkqty
                          op_rsn_rwrk = rwkreason.
                   delete rwkfile.
                end.

                find first rejfile no-error.
                find first rwkfile no-error.

                do while available rejfile
                or available rwkfile:

                   if available rejfile
                   or available rwkfile
                   then do:
                      find ophist no-lock where recid(ophist) = op_recno
                      no-error.

                      create op_hist.
                      {mfnoptr.i}
                      assign op_hist.op_wo_nbr = ophist.op_wo_nbr
                              op_hist.op_wo_op = ophist.op_wo_op
                                op_hist.op_emp = ophist.op_emp
                               op_hist.op_earn = ophist.op_earn
                               op_hist.op_dept = ophist.op_dept
                               op_hist.op_site = ophist.op_site
                              op_hist.op_shift = ophist.op_shift
                            op_hist.op_project = ophist.op_project
                             op_hist.op_wo_lot = ophist.op_wo_lot
                               op_hist.op_part = ophist.op_part
                          op_hist.op_tran_date = today
                               op_hist.op_type = "LABOR"
                              op_hist.op_wkctr = ophist.op_wkctr
                                op_hist.op_mch = ophist.op_mch
                               op_hist.op_date = eff_date
                            op_hist.op_comment = ophist.op_comment.

                      if available rejfile then do:
                         assign op_hist.op_qty_rjct = rejqty
                                op_hist.op_rsn_rjct = rejreason.
                         delete rejfile.
                      end.
                      if available rwkfile then do:
                         assign op_hist.op_qty_rwrk = rwkqty
                                op_hist.op_rsn_rwrk = rwkreason.
                         delete rwkfile.
                      end.
                   end.
                   find first rejfile no-error.
                   find first rwkfile no-error.
                end.

                if compprev then do:
                   qty_comp = wr_qty_comp + wr_sub_comp.
                   complot = wr_lot.
                   find prev wr_route no-lock where wr_lot = complot
                   use-index wr_lot no-error.
                   if available wr_route then do:
                      compop = wr_op.
                      transtype = "OP-CLOSE".
                      wo_recid = recid(wo_mstr).
                      {gprun.i ""sfopclse.p""}
                   end.
                end.
/*G876*/        /* End of added section */

                /* ss - 130712.1 -b */
                DEFINE VAR v_file AS CHAR .
                

                i = 1 .
                DO WHILE i <= 10 AND v_downtime[i] <> "" :

                    
                    v_file =   GLOBAL_userid  +  trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time),"99999") + trim(string(random(1,1000),"9999")) + STRING(i,"99") .
                    OUTPUT TO VALUE(v_file) .
                    PUT UNFORMATTED v_nbr SPACE v_lot SPACE v_op SKIP .
                    PUT UNFORMATTED v_emp SPACE v_dept SPACE v_shift SPACE  v_wkctr SPACE v_mch SPACE v_earn SPACE "-" SPACE v_project SKIP .
                    PUT UNFORMATTED "- - -" SPACE eff_date SPACE NO SPACE MOVE SPACE compprev SPACE "- - - - -" SPACE v_downtime[i] SPACE v_reason[i]  SKIP .
                    PUT UNFORMATTED "yes" SKIP .
                    PUT UNFORMATTED "." SKIP .
                     PUT UNFORMATTED "." SKIP .

                    OUTPUT CLOSE .  
                      
                  
                    INPUT FROM VALUE(v_file) .
                    OUTPUT TO VALUE(v_file + ".l") .

                     batchrun = YES .
                    {gprun.i ""sfoptr01.p""}
                      batchrun = NO .
                      
                     INPUT CLOSE .
                  
                     OUTPUT CLOSE .

                    unix silent value ("rm " + trim(v_file) + ".*").
                    
                    unix silent value("clear") .
                    i = i + 1 .
                END.
                
                /* ss - 130712.1 -e */


             end.
          end.

/*N002*/ if is_wiplottrace_enabled() then
/*N002*/    delete procedure h_wiplottrace_procs no-error.
/*N002*/ if is_wiplottrace_enabled() then
/*N002*/    delete procedure h_wiplottrace_funcs no-error.
