/* sfoptra.p - LABOR FEEDBACK CONTINUATION PROGRAM                            */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
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
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.20     BY: Rajesh Thomas         DATE: 06/19/01 ECO: *M18V*    */
/* Revision: 1.22     BY: Narathip W.           DATE: 04/29/03 ECO: *P0QN*    */
/* Revision: 1.26     BY: Paul Donnelly (SB)    DATE: 06/28/03 ECO: *Q00L*    */
/* Revision: 1.27     BY: Ken Casey             DATE: 02/19/04 ECO: *N2GM*    */
/* Revision: 1.28     BY: Marian Kucera         DATE: 07/14/04 ECO: *Q06H*    */
/* Revision: 1.29     BY: Sushant Pradhan       DATE: 08/26/05 ECO: *Q0L3*    */
/* $Revision: 1.29.2.1 $  BY: Amit Singh      DATE: 06/23/06 ECO: *P4RH*    */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* SS - 100301.1 By: Kaine Zhang */
/* SS - 100316.1 By: Kaine Zhang */
/* SS - 100715.1 By: Kaine Zhang */
/* SS - 100824.1 By: Kaine Zhang */
/* SS - 101130.1 By: Kaine Zhang */
/* SS - 101208.1 By: Kaine Zhang */
/* SS - 110221.1 By: Kaine Zhang */


/* SS - 100320.1 - RNB
[110221.1]
ref: �κ����ʼ�. 20110215.���칫˾�����Ż�-V1-110215.doc
[101208.1]
ref: XinTian, He Hongyu email by Kaine, 20101203-20101208.
1. wip = move in - comp - reject.
2. validate: input (comp + reject) <= wip.
[101208.1]
[100824.1]
��������,���������������'׼��ʱ��/����ʱ��'��0����. -- ��Ϊ������ж�η������������.
[100824.1]
[100320.1]
�����û�����: ׼�Ṥʱ, �ӹ�ʱ��, �ܹ�ʱ.
include: 100301.1 -- 100331.1
[100320.1]
SS - 100320.1 - RNE */

/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "SFOPTRA.P"}

{sfopvar.i "shared"}

/* SS - 100301.1 - B */
define shared variable d1 as decimal no-undo.
define shared variable d2 as decimal no-undo.
define variable d3 as decimal no-undo.
define variable d4 as decimal no-undo.
/* SS - 100301.1 - E */
/* SS - 100320.1 - B */
define shared variable bIsStock as logical format "Zzk/Xc" label "Zzk/Xc" initial no no-undo.
/* SS - 100320.1 - E */

/* SS - 100824.1 - B */
define shared variable bIsNoSetup as logical initial no no-undo.
define shared variable bIsNoRun as logical initial no no-undo.
/* SS - 100824.1 - E */

/* SS - 101130.1 - B */
{xxsfoptr01rejectvar.i "shared"}
/* SS - 101130.1 - E */

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
define new shared variable pay_rate like emp_pay_rate.
define new shared variable sf_lbr_acct like dpt_lbr_acct.
define new shared variable sf_bdn_acct like dpt_bdn_acct.
define new shared variable sf_wip_acct like dpt_lbr_acct.
define new shared variable sf_cop_acct like dpt_lbr_acct.
define new shared variable sf_lbr_sub like dpt_lbr_sub.
define new shared variable sf_bdn_sub like dpt_bdn_sub.
define new shared variable sf_wip_sub like dpt_lbr_sub.
define new shared variable sf_cop_sub like dpt_lbr_sub.
define new shared variable sf_lbr_cc like dpt_lbr_cc.
define new shared variable sf_bdn_cc like dpt_lbr_cc.
define new shared variable sf_wip_cc like dpt_lbr_cc.
define new shared variable sf_cop_cc like dpt_cop_cc.
define new shared variable sf_dr_acct like dpt_lbr_acct.
define new shared variable sf_dr_sub like dpt_lbr_sub.
define new shared variable sf_dr_cc like dpt_lbr_cc.
define new shared variable sf_cr_acct like dpt_lbr_acct.
define new shared variable sf_cr_sub like dpt_lbr_sub.
define new shared variable sf_cr_cc like dpt_lbr_cc.
define new shared variable sf_gl_amt like tr_gl_amt.
define new shared variable ref like glt_ref.
define new shared variable op_recno as recid.
define new shared variable qty_comp like wr_qty_comp.
define new shared variable start_time as character.
define new shared variable stop_time as character.
define new shared variable error_flag like mfc_logical.
define new shared variable lead_trans like op_trnbr.
define new shared variable wo_recno  as recid.
define new shared variable complot like op_wo_lot.
define new shared variable compop like op_wo_op.
define new shared variable transtype as character.
define new shared variable wo_recid as recid.
define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.
define new shared variable operation like wr_op no-undo.
define new shared variable order_id like wr_lot no-undo.

define variable move1 like opc_move.
define variable qty_wip like wr_qty_wip.
define variable qty_comp_this_op like wr_qty_comp no-undo.
define variable curr_lot like wr_lot.
define variable curr_op  like wr_op.
define variable actrun   like op_act_run no-undo.
define variable undo_stat like mfc_logical no-undo.
define variable move_to_wkctr like wc_wkctr no-undo.
define variable move_to_mch like wc_mch no-undo.
{&SFOPTRA-P-TAG1}

/* SS - 100715.1 - B */
define variable decWrOpWIP as decimal no-undo.
/* SS - 100715.1 - E */

define buffer ophist for op_hist.
define buffer wrroute for wr_route.

define new shared workfile rejfile no-undo
   field rejreason like op_rsn_rjct
   field rejqty like op_qty_rjct.

define new shared workfile rwkfile no-undo
   field rwkreason like op_rsn_rwrk
   field rwkqty like op_qty_rwrk.

{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

if is_wiplottrace_enabled() then do:
   {gprunmo.i &program=""wlpl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}
   {gprunmo.i &program=""wlfl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}
end.

{gpglefv.i}

/* SS - 100301.1 - B
{sfopfmb.i} /* frame b definition */
SS - 100301.1 - E */
/* SS - 100301.1 - B */
{xxsfopfmb.i} /* frame b definition */
/* SS - 100301.1 - E */

/* E-Sig support include file */
{sfoptres.i}

/* E-Signature Persistent Procedure initialization */
ll_isesig_on = isEsigConfigured("0002") or
               isEsigConfigured("0003").
if ll_isesig_on then run initESig.

/* CREATE SESSION TRIGGER FOR USLH_HIST */
if ll_isesig_on then
   run createUslhHistSessionTrigger.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
if not available gl_ctrl then do:

   msg_var1 = getTermLabel("GENERAL_LEDGER",18).
   {pxmsg.i &MSGNUM=533
            &ERRORLEVEL=4
            &MSGARG1=msg_var1}
   leave.
end.

/* DISPLAY */
mainloop:
repeat with frame b:

   if ll_quitmfgpro then undo, leave mainloop.

   find wr_route no-lock where recid(wr_route) = wr_recno.
   find wc_mstr where recid(wc_mstr) = wc_recno no-lock no-error.
   find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr = wr_nbr
      and wo_lot = wr_lot no-lock no-error.

   /* THE DEFAULT IF NO EMPLOYEE RATE GETS USED */
   pay_rate = wc_lbr_rate.

   if emp <> "" then do:
      find first emp_mstr  where emp_mstr.emp_domain = global_domain and
      emp_addr = emp no-lock no-error.
      if available emp_mstr
         and emp_pay_type = "HR" and emp_pay_rate <> 0
      then do:
         pay_rate = emp_pay_rate.
         if earn <> "" then do:
            find first ea_mstr  where ea_mstr.ea_domain = global_domain and
            ea_earn = earn no-lock no-error.
            if available ea_mstr then pay_rate = pay_rate * ea_rate.
         end.
      end.
   end.
   if not available emp_mstr then pay_rate = wc_lbr_rate.

   /* SS - 100321.1 - B
   wocomp = yes.
   compprev = yes.
   SS - 100321.1 - E */
    /* SS - 100321.1 - B */
    assign
        wocomp = no
        compprev = no
        .
    /* SS - 100321.1 - E */
   if not time_ind then start_setup = string(0,"HH:MM:SS").
   else start_setup = string(0,"9.999").
   assign
      start_run = start_setup
      stop_setup = start_setup
      stop_run = start_setup
      downtime = start_setup
      total_rej = 0
      total_rwk = 0
      reason = ""
      qty_comp = min((wr_qty_move - wr_qty_comp - wr_sub_comp -
                      wr_qty_rjct), wr_qty_wip).

    /* SS - 100316.1 - B */
    assign
        stop_setup = string(wr_setup)
        stop_run = string(wr_run)
        .
    /* SS - 100316.1 - E */
    
    /* SS - 100824.1 - B */
    if bIsNoSetup then stop_setup = "".
    if bIsNoRun then stop_run = "".
    /* SS - 100824.1 - E */

   if qty_comp < 0 then qty_comp = 0.

   curr_lot = wr_lot.
   curr_op = wr_op.
   do for wrroute:
      find last wrroute  where wrroute.wr_domain = global_domain and
      wrroute.wr_lot = curr_lot
         use-index wr_lot no-lock no-error.

      if  wrroute.wr_op <= curr_op
         then move = no.
   end.

   display
        /* SS - 100321.1 - B */
        bIsStock
        /* SS - 100321.1 - E */
      qty_comp @ op_qty_comp
      rejects
      reworks
      eff_date
      wocomp
      move
      compprev
      0 @ op_act_setup
      start_setup
      stop_setup
      0 @ op_act_run
      start_run
      stop_run
      downtime
      reason.

   set_ophist:
   do on error undo, retry:

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sfoptra'
         &FRAME = 'yn'}

        /* SS - 100715.1 - B */
        {gprun.i
            ""xxgetwropwip.p""
            "(
                input wr_route.wr_lot,
                input wr_route.wr_op,
                output decWrOpWIP
            )"
        }
        
        display 0 @ op_qty_comp with frame b.
        /* SS - 100715.1 - E */
        
      prompt-for
         op_qty_comp
         rejects
         reworks
        /* SS - 100321.1 - B */
        bIsStock
        /* SS - 100321.1 - E */
         eff_date
         wocomp
         move
         compprev
         /* SS - 100321.1 - B
         start_setup
         stop_setup
         start_run
         stop_run
         SS - 100321.1 - E */
         op_comment
         downtime
         reason
        /* SS - 100301.1 - B */
        d1
        /* SS - 100316.1 - B
        d2
        SS - 100316.1 - E */
        /* SS - 100301.1 - E */
      with frame b.
        
        /* SS - 100715.1 - B */
        if input op_qty_comp > decWrOpWIP then do:
            /* todo pxmsg xxxx */
            message "����������ɴ�����������".
            next-prompt op_qty_comp with frame b.
            undo set_ophist, retry set_ophist.
        end.
        /* SS - 100715.1 - E */

        /* SS - 100316.1 - B */
        do on endkey undo set_ophist, retry set_ophist:
            /* SS - 100321.1 - B
            assign
                d3 = decimal(input stop_setup)
                d4 = decimal(input stop_run)
                no-error
                .
            SS - 100321.1 - E */
            /* SS - 100321.1 - B */
            assign
                d3 = decimal(stop_setup)
                d4 = decimal(stop_run)
                no-error
                .
            /* SS - 100321.1 - E */
            assign d1 bIsStock.
            /* SS - 110221.1 - B
            d2 = d3 + (input op_qty_comp) * d4 + d1.
            SS - 110221.1 - E */
            /* SS - 110221.1 - B */
            d2 = (if input op_qty_comp <> 0 then d3 else 0) + (input op_qty_comp) * d4 + d1.
            /* SS - 110221.1 - E */
            display d2 with frame b.
            /* SS - 100321.1 - B
            update d2 with frame b.
            SS - 100321.1 - E */
        end.
        /* SS - 100316.1 - E */

      assign
         rejects
         reworks
         eff_date
         comment = input op_comment.

      if eff_date = ? then eff_date = today.

      /* CHECK GL EFFECTIVE DATE */

      find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
      wo_site no-lock.
      {gpglef1.i
         &module = ""WO""
         &entity = si_entity
         &date = eff_date
         &prompt = "eff_date"
         &frame = "b"
         &loop = "set_ophist"
         }

      /* CHECK FOR MASTER SPECIFICATION */
      wo_recno = recid(wo_mstr).

      /* Display the latest E-Signature */
      if ll_isesig_on then do:
         run displayLatestESig( buffer wr_route ).
         if valid-handle(lh_frame_a) then do:
            view lh_frame_a.
            view frame b.
         end.
      end.

      /* ADDED FOURTH PARAMETER eff_date IN CALL TO mpwindow.i */

      {mpwindow.i wr_part wr_op
         "if wo_routing = """" then wr_part else wo_routing"
         eff_date}

      assign
         wocomp
         move
         compprev
         start_setup stop_setup
         start_run stop_run
         downtime reason.

      {mftimec.i start_setup stop_setup}

      display elapse @ op_act_setup.

      if not time_ind
      then
         display
            time_hm1 format "999:99:99" @ start_setup
            time_hm2 format "999:99:99" @ stop_setup.
      else
         display
            time_hd1 @ start_setup
            time_hd2 @ stop_setup.

      {mftimec.i start_run stop_run}

      actrun = elapse.

      display elapse @ op_act_run.

      if not time_ind
      then
         display
            time_hm1 format "999:99:99" @ start_run
            time_hm2 format "999:99:99" @ stop_run.
      else
         display
            time_hd1 @ start_run
            time_hd2 @ stop_run.

      if downtime > "" then do:
         stop_setup = "".

         {mftimec.i stop_setup downtime}

         if not time_ind
         then display time_hm2 format "999:99:99" @ downtime.
         else display time_hd2 @ downtime.

         if elapse <> 0 and
            can-find (first rsn_ref  where rsn_ref.rsn_domain = global_domain
            and  rsn_type = "DOWN" ) then
            repeat with frame b on endkey undo set_ophist, retry set_ophist:
               find rsn_ref no-lock  where rsn_ref.rsn_domain = global_domain
               and  rsn_type = "DOWN"
                  and rsn_code = reason no-error.
               if available rsn_ref then leave.
               {pxmsg.i &MSGNUM=534 &ERRORLEVEL=1}
               /* PLEASE ENTER REASON CODE */
               update reason.
            end.

         if elapse = 0 then downtime = "".
      end.

      if not rejects then do:
         {mfdel.i "rejfile"}
      end.

      if not reworks then do:
         {mfdel.i "rwkfile"}
      end.

      if rejects or reworks then do:
         /* COLLECT MULTIPLE REJECTS/REWORKS WITH REASON CODES */
         {gprun.i ""sfoptrd.p""}
      end.
      if total_rej <> 0 then display total_rej.
      else display no @ rejects "" @ total_rej.

        /* SS - 101208.1 - B */
        if input op_qty_comp + total_rej > decWrOpWIP then do:
            /* todo pxmsg xxxx */
            message "����������Ʒ�����ܺͲ��ɴ�����������".
            next-prompt op_qty_comp with frame b.
            undo set_ophist, retry set_ophist.
        end.
        /* SS - 101208.1 - E */

      if total_rwk <> 0 then display total_rwk.
      else display no @ reworks "" @ total_rwk.

      if input op_qty_comp + total_rej > wr_qty_wip then do:
         {pxmsg.i &MSGNUM=512 &ERRORLEVEL=2}
         /* Qty completed + rejected EXCEEDS QUANTITY IN WIP */
      end.

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
             where wr_route.wr_domain = global_domain and  wr_nbr = wrnbr and
             wr_lot = wrlot no-error.
         if not available wr_route or
            qty_comp_this_op > wr_qty_comp + wr_sub_comp then do:
            {pxmsg.i &MSGNUM=1386 &ERRORLEVEL=2}
            /* QUANTITY completed + rejected EXCEEDS ORDER QUANTITY */
         end.
         find wr_route no-lock where recid(wr_route) = wr_recno.
      end.

      if is_wiplottrace_enabled()
         and is_operation_queue_lot_controlled(wo_lot, wr_op,
         OUTPUT_QUEUE)
      then do:

         /* ASSIGN VARIABLES FOR SCROLLING WINDOW */
         assign
            operation = wr_op
            order_id = wr_lot
            .

         run init_bkfl_output_wip_lot_temptable
            in h_wiplottrace_procs.

         for first pt_mstr  where pt_mstr.pt_domain = global_domain and
         pt_part = wo_part no-lock:
         end.

         if not (is_last_operation(wr_lot, wr_op)) and move
         then do:

            assign
               move_to_wkctr = wc_wkctr
               move_to_mch = wc_mch
               .

            run get_destination_wkctr_mch_from_user
               in h_wiplottrace_procs
               (input wr_lot,
               input next_milestone_operation(wr_lot, wr_op),
               output move_to_wkctr,
               output move_to_mch,
               output undo_stat).

            if undo_stat then undo, retry.
         end. /* IF NOT LAST OPERATION AND MOVE NEXT OPERATION */

         run get_bkfl_output_wip_lots_from_user
            in h_wiplottrace_procs
            (input wr_lot, input wr_op, input input op_qty_comp,
            input 1, input pt_um, input move, input wo_site,
            input wc_wkctr, wc_mch, output undo_stat).
         if undo_stat then
            undo, retry.

      end. /* if is_wiplottrace_enabled() */

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sfoptra'
         &FRAME = 'yn' &CONTEXT = 'SFOPTRA'}

    /* SS - 101130.1 - B */
    pause 0 before-hide.
    if bRejectRct then do:
        if total_rej <> 0 then do:
            {xxsfoptr01rejectrctinput.i}
        end.
    end.
    /* SS - 101130.1 - E */

      yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sfoptra'
         &FRAME = 'yn'}

      if yn = no then undo, retry.

       /* E-Signature Pre-Signing */
       if ll_isesig_on then
       do:
          run preSignESigData (buffer wr_route).
          if valid-handle(lh_frame_a) then
          do:
             view lh_frame_a.
             view frame b.
          end.
          if not ll_success then undo set_ophist, next mainloop.
          on write of op_hist do:
             find first tt_log no-lock where
                tt_rec = recid(op_hist) no-error.
             if not available tt_log then
             do:
                create tt_log.
                tt_rec = recid(op_hist).
             end.
          end.
       end.

    /* SS - 101130.1 - B */
    if bRejectRct then do:
        if total_rej <> 0 then do:
            {gprun.i
                ""xxsfoptr01rejectrctcim.p""
                "(
                    input wr_lot,
                    input sSite,
                    input sLoc,
                    input total_rej
                )"
            }
        end.
    end.
    /* SS - 101130.1 - E */

      find wo_mstr exclusive-lock  where wo_mstr.wo_domain = global_domain and
      wo_nbr = wr_nbr
         and wo_lot = wr_lot no-error.

      find wr_route exclusive-lock where recid(wr_route) = wr_recno.

      if not can-find(first op_hist  where op_hist.op_domain = global_domain
      and  op_wo_lot = wr_lot
         and op_wo_op = wr_op) then do:
         qty_wip = wr_qty_ord.
         find prev wr_route
             where wr_route.wr_domain = global_domain and  wr_nbr = wrnbr and
             wr_lot = wrlot no-error.
         if available wr_route then
         assign
            qty_wip = wr_qty_comp
            wr_qty_wip = wr_qty_wip - wr_qty_comp.
         find wr_route exclusive-lock where recid(wr_route) = wr_recno.
         move1 = move.
         move = no.
         {mfopmv.i qty_wip}
         {&SFOPTRA-P-TAG2}
         move = move1.
      end.

      assign
         wr_act_setup = wr_act_setup + input op_act_setup
         wr_act_run   = wr_act_run   + actrun
         wr_qty_comp  = wr_qty_comp  + input op_qty_comp
         wr_qty_rjct  = wr_qty_rjct  + total_rej
         wr_qty_rwrk  = wr_qty_rwrk  + total_rwk.

      if wr_status <> "C" then do:
         if wr_act_run > 0 then wr_status = "R".
         else if wr_act_setup > 0 then wr_status = "S".
         else wr_status = "Q".
      end.

      wr_qty_wip = wr_qty_wip - total_rej.

      if wocomp then
         wr_status = "C".

      create op_hist. op_hist.op_domain = global_domain.

      {mfnoptr.i}

      assign
         op_wo_nbr = wr_nbr
         op_wo_op = wr_op
         op_emp = emp
         op_earn = earn
         op_dept = dept
         op_site = wo_site
         op_shift = shift
         op_project = project
         op_wo_lot = wr_lot
         op_part = wr_part
         op_tran_date = today
         op_type = "LABOR"
         op_wkctr = wc_wkctr
         op_mch = wc_mch
         op_date = eff_date
         op_std_run = wr_run
         op_qty_comp
         op_act_setup
         op_act_run = actrun
         {&SFOPTRA-P-TAG3}
         op_comment
        /* SS - 100301.1 - B */
        op__qad01 = string(d1)
        op__qad02 = string(d2)
        /* SS - 100301.1 - E */
         .

        /* SS - 100322.1 - B */
        {gprun.i
            ""xxxtopcomp.p""
            "(
                input op_wo_nbr,
                input op_wo_lot,
                input op_wo_op,
                input op_emp,
                input op_dept,
                input bIsStock,
                input op_qty_comp,
                input total_rej,
                input total_rwk,
                input op_trnbr
            )"
        }
        /* SS - 100322.1 - E */
       

      op_recno = recid(op_hist).

      if is_wiplottrace_enabled()
         and is_operation_queue_lot_controlled(wo_lot, wr_op,
         OUTPUT_QUEUE)
      then do:

         run bkfl_produce_wip_lots in h_wiplottrace_procs
            (input op_trnbr, input wr_lot, input wr_op,
            input 1, input wo_site, input wc_wkctr,
            input wc_mch).

         if not (is_last_operation(wr_lot, wr_op)) and move
         then
            run bkfl_move_wip_lots in h_wiplottrace_procs
               (input wr_lot, input wr_op, input 1,
               input wo_site, input wc_wkctr, input wc_mch,
               input move_to_wkctr, input move_to_mch).

      end. /* if is_wiplottrace_enabled() */

      if op_wkctr <> wr_wkctr or op_mch <> wr_mch
      then do:

         {gprun.i ""reupopst.p"" "(input op_recno)" }

      end.

      assign
         op_qty_rjct = total_rej
         op_qty_rwrk = total_rwk.

      {gprun.i ""sfoptrc.p""}

      for each rejfile exclusive-lock where rejqty = 0:
         delete rejfile.
      end.

      for each rwkfile exclusive-lock where rwkqty = 0:
         delete rwkfile.
      end.

      find first rejfile no-error.
      if available rejfile then do:
         assign
            op_qty_rjct = rejqty
            op_rsn_rjct = rejreason.
         delete rejfile.
      end.
      find first rwkfile no-error.
      if available rwkfile then do:
         assign
            op_qty_rwrk = rwkqty
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

            create op_hist. op_hist.op_domain = global_domain.
            {mfnoptr.i}
            assign
               op_hist.op_wo_nbr = ophist.op_wo_nbr
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
               {&SFOPTRA-P-TAG4}
               op_hist.op_comment = ophist.op_comment.

            if available rejfile then do:
               assign
                  op_hist.op_qty_rjct = rejqty
                  op_hist.op_rsn_rjct = rejreason.
               delete rejfile.
            end.
            if available rwkfile then do:
               assign
                  op_hist.op_qty_rwrk = rwkqty
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
         find prev wr_route no-lock  where wr_route.wr_domain = global_domain
         and  wr_lot = complot
            use-index wr_lot no-error.
         if available wr_route then do:
            assign
               compop = wr_op
               transtype = "OP-CLOSE"
               wo_recid = recid(wo_mstr).
            {&SFOPTRA-P-TAG5}
            {gprun.i ""sfopclse.p""}
         end.
      end.

      /* E-Signature Signing */
      if ll_isesig_on then
      do:
         release op_hist no-error.
         on write of op_hist revert.
         run signESigData.
         if valid-handle(lh_frame_a) then
         do:
            view lh_frame_a.
            view frame b.
         end.
         if not ll_success then undo mainloop, retry mainloop.
      end.
      leave.
   end.
end.

/* DUE TO THE TRANSACTION SCOPING AND THE USLH_HIST RECORDS */
/* CREATED IN CREATELOGONHISTORY WHICH GETS UNDONE WHEN THE */
/* USER IS DEACTIVATED, WE NOW NEED TO CREATE THEM AGAIN.   */
if ll_isesig_on and ll_quitmfgpro then
   run revertUslhHistSessionTrigger.

/* E-Sig cleaning */
if ll_isesig_on then run cleanupEsig.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.
