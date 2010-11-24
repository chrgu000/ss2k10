/* woworc.p - WORK ORDER RECEIPT W/ SERIAL NUMBERS                            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* REVISION: 1.0      LAST MODIFIED: 04/02/86   BY: pml                       */
/* REVISION: 1.0      LAST MODIFIED: 08/21/86   BY: emb                       */
/* REVISION: 1.0      LAST MODIFIED: 10/30/86   BY: emb *39*                  */
/* REVISION: 2.1      LAST MODIFIED: 08/04/87   BY: wug *A94*                 */
/* REVISION: 2.1      LAST MODIFIED: 11/04/87   BY: wug *A102*                */
/* REVISION: 4.0      LAST MODIFIED: 01/18/88   BY: wug *A151*                */
/* REVISION: 4.0      LAST MODIFIED: 02/04/88   BY: emb *A172*                */
/* REVISION: 4.0      LAST MODIFIED: 03/15/88   BY: rl  *A171*                */
/* REVISION: 4.0      LAST MODIFIED: 04/19/88   BY: emb *A206*                */
/* REVISION: 4.0      LAST MODIFIED: 05/03/88   BY: emb *A225*                */
/* REVISION: 4.0      LAST MODIFIED: 05/04/88   BY: flm *A222*                */
/* REVISION: 4.0      LAST MODIFIED: 05/24/88   BY: flm *A250*                */
/* REVISION: 4.0      LAST MODIFIED: 05/24/88   BY: flm *A252*                */
/* REVISION: 4.0      LAST MODIFIED: 08/25/88   BY: wug *A408*                */
/* REVISION: 4.0      LAST MODIFIED: 09/19/88   BY: wug *A441*                */
/* REVISION: 5.0      LAST MODIFIED: 03/24/89   BY: emb *B061*                */
/* REVISION: 4.0      LAST MODIFIED: 04/24/89   BY: emb *A719*                */
/* REVISION: 5.0      LAST MODIFIED: 06/15/89   BY: mlb *B130*                */
/* REVISION: 5.0      LAST MODIFIED: 06/22/89   BY: rl  *B157*                */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: mlb *B159*                */
/* REVISION: 5.0      LAST MODIFIED: 07/06/89   BY: wug *B175*                */
/* REVISION: 5.0      LAST MODIFIED: 08/21/89   BY: emb *B237*                */
/* REVISION: 5.0      LAST MODIFIED: 09/21/89   BY: emb *B265*                */
/* REVISION: 5.0      LAST MODIFIED: 01/23/90   BY: mlb *B522*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: wug *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 06/27/90   BY: emb *D024*                */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: wug *D051*                */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: wug *D447*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*                */
/* REVISION: 6.0      LAST MODIFIED: 04/12/91   BY: ram *D524*                */
/* REVISION: 6.0      LAST MODIFIED: 04/24/91   BY: ram *D581*                */
/* REVISION: 6.0      LAST MODIFIED: 06/19/91   BY: ram *D717*                */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*                */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*                */
/* REVISION: 6.0      LAST MODIFIED: 09/12/91   BY: wug *D858*                */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*                */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91   BY: wug *D920*                */
/* REVISION: 6.0      LAST MODIFIED: 11/27/91   BY: ram *D954*                */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92   BY: pma *F104*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: ram *F896*                */
/* REVISION: 7.3      LAST MODIFIED: 09/22/92   BY: ram *G079*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: emb *G292*                */
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: emb *G558*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/03/93   BY: fwy *G630*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G871*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: pxd *GH30*                */
/* REVISION: 7.3      LAST MODIFIED: 03/21/94   BY: pxd *FM90*                */
/* REVISION: 7.2      LAST MODIFIED: 04/12/94   BY: pma *FN34*                */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94   BY: slm *GM61*                */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*                */
/* REVISION: 7.4      LAST MODIFIED: 09/27/94   BY: emb *GM78*                */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: taf *J035*                */
/* REVISION: 8.5      LAST MODIFIED: 10/25/94   BY: pma *J040*                */
/* REVISION: 7.4      LAST MODIFIED: 11/02/94   BY: ame *FT23*                */
/* REVISION: 8.5      LAST MODIFIED: 11/17/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: ktn *J041*                */
/* REVISION: 7.4      LAST MODIFIED: 03/06/95   BY: jzs *G0FB*                */
/* REVISION: 8.5      LAST MODIFIED: 03/08/94   BY: dzs *J046*                */
/* REVISION: 8.5      LAST MODIFIED: 03/08/95   BY: pma *J046*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.3      LAST MODIFIED: 06/26/95   BY: qzl *G0R0*                */
/* REVISION: 8.5      LAST MODIFIED: 10/20/95   BY: tjs *J08X*                */
/* REVISION: 8.5      LAST MODIFIED: 02/28/96   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jym *G1Q9*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 06/24/96   BY: rvw *G1XY*                */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: kxn *J0QX*                */
/* REVISION: 8.5      LAST MODIFIED: 07/27/96   BY: jxz *J12C*                */
/* REVISION: 8.6      LAST MODIFIED: 03/19/97   BY: *J1LF* Murli Shastri      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *M0QJ* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* Revision: 1.15      BY: Katie Hilbert           DATE: 04/01/01 ECO: *P008* */
/* Revision: 1.16      BY: Robin McCarthy          DATE: 11/26/01 ECO: *P023* */
/* Revision: 1.17      BY: Dan Herman              DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.18      BY: Steve Nugent            DATE: 06/06/02 ECO: *P07Y* */
/* Revision: 1.20      BY: Niranjan Ranka          DATE: 06/25/02 ECO: *P09L* */
/* Revision: 1.21      BY: Vivek Gogte             DATE: 08/06/02 ECO: *N1QQ* */
/* Revision: 1.22      BY: Kirti Desai             DATE: 01/23/03 ECO: *N241* */
/* Revision: 1.23      BY: Dorota Hohol            DATE: 02/25/03 ECO: *P0N6* */
/* Revision: 1.26      BY: Narathip Weerakitpanich DATE: 04/19/03 ECO: *P0Q7* */
/* Revision: 1.28      BY: Paul Donnelly (SB)      DATE: 06/28/03 ECO: *Q00N* */
/* Revision: 1.29      BY: Vivek Gogte             DATE: 08/06/03 ECO: *P0Z2* */
/* Revision: 1.30      BY: Vandna Rohira           DATE: 01/29/04 ECO: *P1LK* */
/* Revision: 1.31      BY: Robin McCarthy          DATE: 04/19/04 ECO: *P15V* */
/* $Revision: 1.33 $   BY: James Wilson            DATE: 05/17/05 ECO: *Q0JC* */
/*By: Neil Gao 08/10/05 ECO: *SS 20081005* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdtitle.i "1+ "}
{cxcustom.i "WOWORC.P"}
{gldydef.i new}
{gldynrm.i new}

define new shared variable gldetail like mfc_logical no-undo initial no.
define new shared variable gltrans like mfc_logical no-undo initial no.
define new shared variable nbr like wo_nbr.
define new shared variable yn like mfc_logical.
define new shared variable open_ref like wo_qty_ord label "Open Qty".
define new shared variable rmks like tr_rmks.
define new shared variable serial like tr_serial.
define new shared variable ref like glt_ref.
define new shared variable lot like ld_lot.
define new shared variable i as integer.
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable null_ch as character initial "".
define new shared variable close_wo like mfc_logical label "Close".
define new shared variable comp like ps_comp.
define new shared variable qty like wo_qty_ord.
define new shared variable eff_date like glt_effdate.
define new shared variable wo_recno as recid.
define new shared variable leadtime like pt_mfg_lead.
define new shared variable prev_status like wo_status.
define new shared variable prev_release like wo_rel_date.
define new shared variable prev_due like wo_due_date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable prev_site like wo_site.
define new shared variable del-yn like mfc_logical.
define new shared variable deliv like wod_deliver.
define new shared variable any_issued like mfc_logical.
define new shared variable any_feedbk like mfc_logical.
define new shared variable conv like um_conv label "Conversion" no-undo.
define new shared variable um like pt_um no-undo.
define new shared variable tot_units like wo_qty_chg label "Total Units".
define new shared variable reject_um like pt_um no-undo.
define new shared variable reject_conv like conv no-undo.
define new shared variable pl_recno as recid.
define new shared variable fas_wo_rec like fac_wo_rec.
define new shared variable reject_qty like wo_rjct_chg
   label "Scrapped Qty" no-undo.
define new shared variable multi_entry like mfc_logical
   label "Multi Entry" no-undo.
define new shared variable lotserial_control as character.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable cline as character.
define new shared variable issue_or_receipt as character.
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable transtype as character initial "RCT-WO".
define new shared variable back_qty like sr_qty.
define new shared variable undo_jp like mfc_logical.
define new shared variable joint_type like wo_joint_type.
define new shared variable sf_cr_acct like dpt_lbr_acct.
define new shared variable sf_dr_acct like dpt_lbr_acct.
define new shared variable sf_cr_sub like dpt_lbr_sub.
define new shared variable sf_dr_sub like dpt_lbr_sub.
define new shared variable sf_cr_cc like dpt_lbr_cc.
define new shared variable sf_dr_cc like dpt_lbr_cc.
define new shared variable sf_cr_proj like glt_project.
define new shared variable sf_dr_proj like glt_project.
define new shared variable sf_gl_amt like tr_gl_amt.
define new shared variable sf_entity like en_entity.
define new shared variable undo_all like mfc_logical no-undo.
define new shared variable critical-part like wod_part no-undo.
define new shared variable critical_flg  like mfc_logical no-undo.
define new shared variable msg-counter as integer no-undo.
define new shared variable undo_setd like mfc_logical no-undo.
define new shared variable wo_recid as recid.
define new shared variable tr_recno as recid.
define new shared variable jp like mfc_logical.
define new shared variable base like mfc_logical.
define new shared variable base_id like wo_base_id.
define new shared variable joint_qtys  like mfc_logical.
define new shared variable joint_dates like mfc_logical.
define new shared variable no_msg      like mfc_logical.
define new shared variable err_msg as integer.
define new shared variable chg_attr like mfc_logical no-undo
   label "Set Attributes".
define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.
define new shared variable proc_to_run as character no-undo.
define new shared variable proc_hdl as handle no-undo.
/*SS 20081005 - B*/
define input parameter iptnbr like wo_nbr.
define input parameter iptlot like wo_lot.
/*SS 20081005 - E*/

/*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
{gpatrdef.i "new shared"}

define variable glcost like sct_cst_tot.
define variable msgref like tr_msg.
define variable wip_accum like wo_wip_tot.
define variable glx_mthd like cs_method.
define variable glx_set like cs_set.
define variable cur_mthd like cs_method.
define variable cur_set like cs_set.
define variable alloc_mthd like acm_method.
define variable gl_tmp_amt as decimal no-undo.
define variable wobaseid as character no-undo.
define variable wobaseid_last_opnbr like wr_op no-undo.
define variable wobasenbr as character no-undo.
define variable wobaserecid as recid no-undo.
define variable wkctr like wc_wkctr no-undo.
define variable mch like wc_mch no-undo.
define variable baseproc_qty_comp as decimal no-undo.
define variable total_qty_rcv as decimal no-undo.
define variable total_entered_qty as decimal no-undo.
define variable undo_stat as logical no-undo.
define variable ophist_recid as recid no-undo.
define variable total_output_queue_qty as decimal no-undo.
define variable base_site as character no-undo.
define variable base_um as character no-undo.
define variable is_wo_issue as logical initial true no-undo.
define variable io_batch   like cnsu_batch  no-undo.
define variable l_recv_all like mfc_logical no-undo.

{pocnvars.i}

{&WOWORC-P-TAG1}
{&WOWORC-P-TAG5}

define buffer womstr for wo_mstr.
define buffer base_wo_mstr for wo_mstr.
define buffer base_pt_mstr for pt_mstr.

define new shared workfile alloc_wkfl no-undo
   field alloc_wonbr as character
   field alloc_recid as recid
   field alloc_numer as decimal
   field alloc_pct   as decimal.

define new shared frame a.

/*FRAME A*/
{mfworc.i}

{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

assign
   eff_date         = today
   issue_or_receipt = getTermLabel("RECEIPT",8).

if is_wiplottrace_enabled()
then do:
   {gprunmo.i &program=""wlpl.p"" &module="AWT"
              &persistent="""persistent set h_wiplottrace_procs"""}

   {gprunmo.i &program=""wlfl.p"" &module="AWT"
              &persistent="""persistent set h_wiplottrace_funcs"""}
end. /* IF is_wiplottrace_enabled() */

for first gl_ctrl
   fields (gl_domain gl_rnd_mthd)
   where   gl_domain = global_domain
no-lock: end.

do transaction:

   find mfc_ctrl
       where mfc_domain = global_domain
       and   mfc_field = "fas_wo_rec"
   exclusive-lock no-error.

   if available mfc_ctrl then do:

      find first fac_ctrl
         where fac_domain = global_domain
      exclusive-lock no-error.

      if available fac_ctrl then do:
         fac_wo_rec = mfc_logical.
         delete mfc_ctrl.
      end. /* IF AVAILABLE fac_ctrl */
      release fac_ctrl.
   end. /* IF AVAILABLE mfc_ctrl */
   release mfc_ctrl.

   for first fac_ctrl
      fields (fac_domain fac_wo_rec)
      where   fac_domain = global_domain
   no-lock:
      fas_wo_rec = fac_wo_rec.
   end.

end. /* DO TRANSACTION */

/* DISPLAY */
mainloop:
repeat with frame a:
   transtype = "RCT-WO".

   /*V8!  hide all no-pause.
          if global-tool-bar
          and global-tool-bar-handle <> ?
          then
             view global-tool-bar-handle.
   */
   /* PROMPT FOR WO, INITIAL VALIDATION, SAVE prev VALUES */
/*SS 20081005 - B*/
/*
   {gprun.i ""woworcf.p""}
*/
   {gprun.i ""xxdywoworcf.p"" "(input iptnbr,input iptlot)"}
/*SS 20081005 - E*/

   if undo_all then
      leave.

   for first wo_mstr
      fields (wo_domain wo_base_id wo_batch wo_joint_type wo_lot wo_lot_next
              wo_lot_rcpt wo_nbr wo_part wo_qty_chg wo_rmks wo_site wo_so_job
              wo_status wo_stat_close_date wo_stat_close_userid wo_type
              wo_wip_tot)
      where recid(wo_mstr) = wo_recno
   no-lock: end.

   for first pt_mstr
      fields (pt_domain pt_abc pt_auto_lot pt_avg_int pt_cyc_int pt_desc1
              pt_lot_ser pt_part pt_prod_line pt_rctpo_active pt_rctpo_status
              pt_rctwo_active pt_rctwo_status pt_shelflife pt_um)
      where   pt_domain = global_domain
      and     pt_part = wo_part
   no-lock: end.

   /*REMEMBER BASE ID ETC*/
   assign
      wobaseid  = wo_lot
      wobasenbr = wo_nbr.

   if wo_base_id <> "" then
      wobaseid = wo_base_id.

   /*GET THE LAST OPERATION NUMBER IF THERE IS ONE*/
   wobaseid_last_opnbr = ?.

   for last wr_route
      fields (wr_domain wr_lot wr_op)
      where   wr_domain = global_domain
      and     wr_lot = wobaseid
   no-lock:
      wobaseid_last_opnbr = wr_op.
   end.

   /*SET UP THE EXIT PROCEDURE TO CALL FROM WOWORCA.P*/
   assign
      proc_to_run = ?
      proc_hdl    = ?.

   if is_wiplottrace_enabled()
      and wobaseid_last_opnbr <> ?
      and is_operation_queue_lot_controlled
         (wobaseid, wobaseid_last_opnbr, OUTPUT_QUEUE)
   then
      assign
         proc_to_run = 'wiplot_trace_receipt'
         proc_hdl    = this-procedure.

   do for base_wo_mstr, base_pt_mstr:
      for first base_wo_mstr
         fields (wo_domain wo_base_id wo_batch wo_joint_type wo_lot wo_lot_next
                 wo_lot_rcpt wo_nbr wo_part wo_qty_chg wo_rmks wo_site wo_so_job
                 wo_status wo_stat_close_date wo_stat_close_userid wo_type
                 wo_wip_tot)
         where   wo_domain = global_domain
         and     wo_lot = wobaseid
      no-lock: end.

      base_site = wo_site.

      for first base_pt_mstr
         fields (pt_domain pt_abc pt_auto_lot pt_avg_int pt_cyc_int pt_desc1
                 pt_lot_ser pt_part pt_prod_line pt_rctpo_active pt_rctpo_status
                 pt_rctwo_active pt_rctwo_status pt_shelflife pt_um)
         where   pt_domain = global_domain
         and     pt_part = wo_part
      no-lock: end.

      base_um = pt_um.
   end. /* DO FOR base_wo_mstr, base_pt_mstr */

   assign
      {&WOWORC-P-TAG2}
      lotserial_qty = 0
      reject_qty    = 0
      um            = ""
      reject_um     = "".

   if available pt_mstr then
      assign
         {&WOWORC-P-TAG3}
         um        = pt_um
         reject_um = pt_um.

   assign
      conv              = 1
      reject_conv       = 1
      lotserial_control = "".

   if available pt_mstr then
      lotserial_control = pt_lot_ser.

   do transaction:
      for each sr_wkfl
         where sr_domain = global_domain
         and   sr_userid = mfguser
      exclusive-lock:
         delete sr_wkfl.
      end.

      {gprun.i ""gplotwdl.p""}
   end. /* DO TRANSACTION */

   if is_wiplottrace_enabled() then
      run init_bkfl_output_wip_lot_temptable in h_wiplottrace_procs.

   if is_wiplottrace_enabled()
      and wobaseid_last_opnbr <> ?
      and is_operation_queue_lot_controlled
      (wobaseid, wobaseid_last_opnbr, OUTPUT_QUEUE)
   then do:
      /*GET WORKCENTER/MACHINE FROM USER*/
      run get_current_wkctr_mch_from_user
         in h_wiplottrace_procs
         (input wobaseid,
          input wobaseid_last_opnbr,
          output wkctr,
          output mch,
          output undo_stat).

      if undo_stat then
         undo mainloop, retry mainloop.

      /* IDENTIFY CONTEXT FOR QXTEND */
      {gpcontxt.i
         &STACKFRAG = 'wlpl,wlui,wluiwro,wlpl,woworc'
         &FRAME = 'yn' &CONTEXT = 'WIP'}

      /*GET OUTPUT WIP LOTS TO BACKFLUSH FROM USER*/
      run get_worc_output_wip_lots_from_user
         in h_wiplottrace_procs
         (input wobaseid,
          input wobaseid_last_opnbr,
          input base_um,
          input base_site,
          input wkctr,
          input mch,
          output total_entered_qty,
          output undo_stat).

      /* CLEAR CONTEXT FOR QXTEND */
      {gpcontxt.i
         &STACKFRAG = 'wlpl,wlui,wluiwro,wlpl,woworc'
         &FRAME = 'yn'}

      if undo_stat then
         undo, retry.
   end. /* IF is_wiplottrace_enabled() */

   undo_setd = no.
   /* INDICATE SINGLE CO / BY-PRODUCT RECEIPT */
   {gprun.i ""woworcd.p""
            "(output l_recv_all)"}

   if undo_setd then
      undo mainloop, retry mainloop.

   {&WOWORC-P-TAG6}

   if is_wiplottrace_enabled()
      and wobaseid_last_opnbr <> ?
      and is_operation_queue_lot_controlled
      (wobaseid, wobaseid_last_opnbr, OUTPUT_QUEUE)
   then do:
      yn = true.
      /* PLEASE CONFIRM UPDATE */
      {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}
      if yn <> true then
         undo mainloop, retry mainloop.

      do transaction:
         {gprun.i ""reophist.p""
                  "(input 'RECEIPT',
                    input wobaseid,
                    input wobaseid_last_opnbr,
                    input '',
                    input wkctr,
                    input mch,
                    input '',
                    input '',
                    input eff_date,
                    output ophist_recid)"}

         find op_hist
            where recid(op_hist) = ophist_recid
         exclusive-lock no-error.

         op_qty_wip = total_entered_qty.

         run worc_consume_wip_lots in h_wiplottrace_procs
            (input op_trnbr,
             input wobaseid,
             input wobaseid_last_opnbr,
             input 1,
             input base_site,
             input wkctr,
             input mch).
      end. /* DO TRANSACTION */
   end. /* IF is_wiplottrace_enabled() */

   /* REGULAR PRODUCT INVENTORY, GL, AND WO_MSTR UPDATES */
   if not jp then do:

      /* CREATE TRANSACTION HISTORY RECORD */
      /* THE TWO PARAMETERS WILL BE USED BY FLOW */
      /* FIRST INPUT PARAMETER IS LOT ID. OTHER THAN FLOW IT WILL BE BLANK */
      /* SECOND INPUT PARAMETER IS ACCUMLATED TRANSACTION AMOUNT. OTHER THAN */
      /* FLOW IT WILL BE ALWAYS O */
      {gprun.i ""woworca.p""
               "(input """",
                 input 0)"}

      do transaction:
         {gplock.i
            &domain="wo_mstr.wo_domain = global_domain and "
            &file-name=wo_mstr
            &find-criteria="recid(wo_mstr) = wo_recno"
            &exit-allowed=no
            &record-id=recno}

         if (wo_lot_rcpt = no) then
            wo_lot_next = lotserial.

         if close_wo then do:
            wo_status = "C".

            /* UPDATE STATUS CLOSE DATE AND USERID ON DISCRETE WORK ORDERS */
            {wostatcl.i}
         end. /* IF close_wo */

         release wo_mstr.
      end. /* DO TRANSACTION */

      if close_wo then do:
         {gprun.i ""wowomta.p""}
      end. /* IF close_wo */
   end.  /* IF NOT jp THEN DO */

   /* JOINT PRODUCT INVENTORY, GL, AND WO_MSTR UPDATES */
   if jp
      and not undo_setd
   then do:
      do transaction:
         for first womstr
            fields (wo_domain wo_base_id wo_batch wo_joint_type wo_lot
                    wo_lot_next wo_lot_rcpt wo_nbr wo_part wo_qty_chg wo_rmks
                    wo_site wo_so_job wo_status wo_stat_close_date
                    wo_stat_close_userid wo_type wo_wip_tot)
            where recid(womstr) = wo_recno
         no-lock: end.

         /* MEMO RECEIPT FOR BASE PROCESS ORDER */
         find first wo_mstr
            where wo_mstr.wo_domain = global_domain
            and   wo_mstr.wo_nbr = womstr.wo_nbr
            and   wo_mstr.wo_joint_type = "5"
         exclusive-lock no-error.

         if available wo_mstr
         then do:
            wo_mstr.wo_qty_chg = 1.

            {ictrans.i
               &addrid=""""
               &bdnstd=0
               &cracct=""""
               &crsub=""""
               &crcc=""""
               &crproj=""""
               &curr=""""
               &dracct=""""
               &drsub=""""
               &drcc=""""
               &drproj=""""
               &effdate=eff_date
               &exrate=0
               &exrate2=0
               &exratetype=""""
               &exruseq=0
               &glamt=0
               &lbrstd=0
               &line=0
               &location=""""
               &lotnumber=wo_mstr.wo_lot
               &lotserial=wo_mstr.wo_lot
               &lotref=""""
               &mtlstd=0
               &ordernbr=wo_mstr.wo_nbr
               &ovhstd=0
               &part=wo_mstr.wo_part
               &perfdate=?
               &price=glcost
               &quantityreq=0
               &quantityshort=0
               &quantity=1
               &revision=""""
               &rmks=rmks
               &shiptype=""M""
               &site=wo_mstr.wo_site
               &slspsn1=""""
               &slspsn2=""""
               &sojob=""""
               &substd=0
               &transtype=""RCT-WO""
               &msg=0
               &ref_site=wo_mstr.wo_site}

         end. /* IF AVAILABLE wo_mstr */

         /* MEMO ISSUES OF BASE PROCESS ITEM TO JOINT PRODUCT LOT #s */
         for each womstr
            where womstr.wo_domain = global_domain
            and   womstr.wo_nbr = wo_mstr.wo_nbr
            and   womstr.wo_joint_type <> "5"
            and   wo_mstr.wo_joint_type > ""
            and   womstr.wo_base_id = wo_mstr.wo_lot:

            for first sr_wkfl
               fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                       sr_userid)
               where   sr_domain = global_domain
               and     sr_userid = mfguser
               and     trim(substring(sr_lineid,4,18)) = womstr.wo_part
               and     sr_lineid begins "RCT"
            no-lock:

               {ictrans.i
                  &addrid=""""
                  &bdnstd=0
                  &cracct=""""
                  &crsub=""""
                  &crcc=""""
                  &crproj=""""
                  &curr=""""
                  &dracct=""""
                  &drsub=""""
                  &drcc=""""
                  &drproj=""""
                  &effdate=eff_date
                  &exrate=0
                  &exrate2=0
                  &exratetype=""""
                  &exruseq=0
                  &glamt=0
                  &lbrstd=0
                  &line=0
                  &location=""""
                  &lotnumber=womstr.wo_lot
                  &lotserial=wo_mstr.wo_lot
                  &lotref=""""
                  &mtlstd=0
                  &ordernbr=womstr.wo_nbr
                  &ovhstd=0
                  &part=wo_mstr.wo_part
                  &perfdate=?
                  &price=glcost
                  &quantityreq=0
                  &quantityshort=0
                  &quantity=1
                  &revision=""""
                  &rmks=rmks
                  &shiptype=""M""
                  &site=wo_mstr.wo_site
                  &slspsn1=""""
                  &slspsn2=""""
                  &sojob=""""
                  &substd=0
                  &transtype=""ISS-WO""
                  &msg=0
                  &ref_site=wo_mstr.wo_site}

               if available trgl_det then
                  delete trgl_det.

               /* CREATE CONSIGNMENT USAGE RECORDS IF CONSIGNMENT ENABLED*/
               /* AND CONSIGNMENT INVENTORY EXISTS.                      */
               if using_supplier_consignment then do:
                  {gprunmo.i &program = ""pocnsix4.p"" &module  = "ACN"
                             &param   = """(input womstr.wo_part,
                                            input womstr.wo_site,
                                            input
                                               right-trim(
                                               substring(sr_lotser,1,18)),
                                            input sr_ref,
                                            input (if sr_qty < 0 then true
                                                   else false),
                                            output consign_flag)"""}

                  /*IF CONSIGNED INVENTORY EXISTS, DETERMINE WHETHER TO */
                  /*USE IT PRIOR TO UNCONSIGNED INVENTORY.              */
                  if consign_flag then do:
                     {gprunmo.i &program = ""ictrancn.p"" &module  = "ACN"
                                &param   = """(input womstr.wo_nbr,
                                               input womstr.wo_lot,
                                               input tr_wod_op,
                                               input womstr.wo_so_job,
                                               input sr_qty,
                                               input sr_lotser,
                                               input womstr.wo_part,
                                               input womstr.wo_site,
                                               input sr_loc,
                                               input sr_ref,
                                               input eff_date,
                                               input tr_trnbr,
                                               input is_wo_issue,
                                               input-output io_batch)"""}
                  end. /* IF consign_flag */
               end. /* IF USING_SUPPLIER_CONSIGNMENT */
            end. /* FOR FIRST sr_wkfl */
         end. /* FOR EACH womstr */

         /* BASE PROCESS WORK ORDER */
         for first womstr
            fields (wo_domain wo_base_id wo_batch wo_joint_type wo_lot
                    wo_lot_next wo_lot_rcpt wo_nbr wo_part wo_qty_chg wo_rmks
                    wo_site wo_so_job wo_status wo_stat_close_date
                    wo_stat_close_userid wo_type wo_wip_tot)
            where   womstr.wo_domain = global_domain
            and     womstr.wo_nbr = wo_mstr.wo_nbr
            and     womstr.wo_joint_type = "5"
         no-lock: end.

         if not l_recv_all
         then do:

            /* RECORD INVENTORY AND GL TRANSACTION ONLY FOR */
            /* THIS SINGLE RECEIPT OF CO / BY-PRODUCT       */
            find first wo_mstr
               where recid(wo_mstr) = wo_recno
            exclusive-lock no-error.

            if available wo_mstr then do:

               /* CREATE INVENTORY AND GL TRANSACTIONS */
               /* FOR THIS WORK ORDER                  */
               {gprun.i ""woworca.p""
                        "(input """",
                          input 0)"}

               /* UPDATE wip_accum */
               assign
                  wip_accum          = wip_accum + wo_mstr.wo_wip_tot
                  wo_mstr.wo_wip_tot = 0.

            end. /* IF AVAILABLE wo_mstr */

         end. /* IF NOT l_recv_all */

         else do:

            /* JOINT PRODUCT WORK ORDERS */
            for each wo_mstr
               where wo_mstr.wo_domain = global_domain
               and   wo_mstr.wo_nbr = womstr.wo_nbr
               and   wo_mstr.wo_joint_type <> ""
               and   recid(wo_mstr) <> recid(womstr)
            exclusive-lock:
               wo_recno = recid(wo_mstr).

               /* INVENTORY AND GL TRANSACTIONS FOR JOINT PRODUCT ORDERS */
               /* THE TWO PARAMETERS WILL BE USED BY FLOW. */
               /* FIRST INPUT PARAMETER IS LOT ID. OTHER THAN FLOW IT WILL  */
               /* BE BLANK SECOND INPUT PARAMETER IS ACCUMLATED TRANSACTION  */
               /* AMOUNT. OTHER THAN FLOW IT WILL BE ALWAYS O */
               {gprun.i ""woworca.p""
                        "(input """",
                          input 0)"}

               /* UPDATE wip_accum */
               assign
                  wip_accum          = wip_accum + wo_mstr.wo_wip_tot
                  wo_mstr.wo_wip_tot = 0.

            end. /* END - JOINT PRODUCT WORK ORDERS */

         end. /* ELSE DO */

         /* UPDATE BASE PROCESS ORDER */
         find wo_mstr
            where wo_mstr.wo_domain = global_domain
            and   wo_mstr.wo_nbr = womstr.wo_nbr
            and   wo_mstr.wo_joint_type = "5"
         exclusive-lock no-error.

         if available wo_mstr
         then do:

            /* UPDATE RATE AND USAGE VARIANCES FOR BASE PROCESS ORDER */
            if wip_accum <> 0
            then do:
               /*DETERMINE COSTING METHOD*/
               {gprun.i ""csavg01.p""
                        "(input wo_mstr.wo_part,
                          input wo_mstr.wo_site,
                          output glx_set,
                          output glx_mthd,
                          output cur_set,
                          output cur_mthd)"}

               if glx_mthd <> "AVG"
               then do:
                  assign
                     wo_recid  = recid(wo_mstr)
                     transtype = "VAR-POST".

                  {gprun.i ""wovarup.p""}
               end. /* IF glx_mthd <> "AVG" */
            end. /* IF wip_accum <> 0 */

            /* UPDATE wo_wip_tot FOR BASE PROCESS ORDER */
            assign
               wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot + wip_accum
               wip_accum = 0.

            /* CLOSE BASE PROCESS ORDER */
            if close_wo then do:
               assign
                  wo_mstr.wo_status = "C"
                  wo_recno          = recid(wo_mstr).

               /* UPDATE STATUS CLOSE DATE AND USERID ON DISCRETE WORK ORDERS */
               {wostatcl.i}

               {gprun.i ""wowomta.p""}

               /* UPDATE JOINT WOs WITH STATUS AND UNIT COST */
               {gprun.i ""wowomti.p""}

               if glx_mthd = "AVG"
                  or cur_mthd = "AVG"
                  or cur_mthd = "LAST"
               then do:

                  /* ALLOC METHOD PROGs HERE FOR XREF ONLY. NOT RUN. */
                  if false then do:
                     {gprun0.i ""wocsal01.p""}
                     {gprun0.i ""wocsal02.p""}
                     {gprun0.i ""wocsal03.p""}
                  end. /* IF false */

                  /*CHOOSE ALLOCATION METHOD*/
                  {gprun.i ""wocsjpal.p""
                           "(input wo_mstr.wo_part,
                             input wo_mstr.wo_site,
                             output alloc_mthd)"}

                  /*CALCULATE ALLOCATION PERCENTAGE*/
                  {gprun.i alloc_mthd "(input recid(wo_mstr))"}

                  {gprun.i ""csavg04.p""
                           "(input recid(wo_mstr),
                             input glx_mthd,
                             input glx_set,
                             input cur_mthd,
                             input cur_set,
                             input gltrans,
                             input gldetail,
                             output wip_accum)"}

                  wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot - wip_accum.

               end. /* IF GLX_MTHD = "AVG" ... */
            end. /* IF CLOSE_WO */
         end. /* BASE PROCESS ORDER UPDATE */
      end. /* DO TRANSACTION */
   end. /* IF JP THEN DO */
   {&WOWORC-P-TAG4}

end. /* REPEAT */

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.

/*****************************************/
/**            PROCEDURES               **/
/*****************************************/

PROCEDURE wiplot_trace_receipt:
   /* PERFORM THE CONSUMPTION AND TRACING OF CONSUMED WIP LOTS
    * THIS PROCEDURE IS CALLED FROM WOWORCA.P (VIA WLISRCX.P)
    * SO THAT TRACING RECORDS ARE CREATED WITHIN ITS TRANSACTION
    * SCOPE*/

   define input parameter ip_wo_lot like wo_lot no-undo.
   define input parameter ip_op like wr_op no-undo.
   define input parameter ip_part like ld_part no-undo.
   define input parameter ip_site like ld_site no-undo.
   define input parameter ip_loc like ld_loc no-undo.
   define input parameter ip_lotser like ld_lot no-undo.
   define input parameter ip_ref like ld_ref no-undo.
   define input parameter ip_qty as decimal no-undo.

   define variable temp_qty as decimal no-undo.
   define variable trans_type as character initial "RECEIPT" no-undo.

   for first wo_mstr
      fields (wo_domain wo_base_id wo_batch wo_joint_type wo_lot wo_lot_next
              wo_lot_rcpt wo_nbr wo_part wo_qty_chg wo_rmks wo_site wo_so_job
              wo_status wo_stat_close_date wo_stat_close_userid wo_type
              wo_wip_tot)
      where   wo_domain = global_domain
      and     wo_lot = ip_wo_lot
   no-lock: end.

   for first op_hist
      fields (op_domain op_qty_wip op_trnbr)
      where  recid(op_hist) = ophist_recid
   no-lock: end.

   /* REGISTER THE FINISHED MATERIAL RECEIVED IN THE TRACING JOURNAL */
   run add_trace_record
      in h_wiplottrace_procs
      (input OPERATION_HISTORY,
       input op_trnbr,
       input PRODUCED_MTL,
       input ITEM_MTL,
       input '',
       input 0,
       input ip_part,
       input ip_lotser,
       input '',
       input ip_qty).
END PROCEDURE. /* wiplot_trace_receipt */
