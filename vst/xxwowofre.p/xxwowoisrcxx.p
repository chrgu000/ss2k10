/* wowoisrc.p - WORK ORDER RECEIPT BACKFLUSH                                */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/*N014*/ /*V8:RunMode=Character,Windows                                     */
/* REVISION: 6.0      LAST MODIFIED: 05/24/90   BY: emb                     */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*              */
/* REVISION: 6.0      LAST MODIFIED: 04/24/91   BY: ram *D581*              */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*              */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D744*              */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*              */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*              */
/* REVISION: 6.0      LAST MODIFIED: 11/27/91   BY: ram *D954*              */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92   BY: pma *F104*              */
/* REVISION: 7.0      LAST MODIFIED: 09/11/92   BY: ram *F896*              */
/* REVISION: 7.3      LAST MODIFIED: 09/30/92   BY: ram *G115*              */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: emb *G216*              */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G255*              */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: emb *G292*              */
/* REVISION: 7.3      LAST MODIFIED: 02/03/93   BY: fwy *G630*(rev only)    */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: emb *G656*(rev only)    */
/* REVISION: 7.3      LAST MODIFIED: 03/04/93   BY: ram *G782*              */
/* REVISION: 7.3      LAST MODIFIED: 07/06/93   BY: pma *GD11*(rev only)    */
/* REVISION: 7.3      LAST MODIFIED: 08/18/93   BY: pxd *GE21*(rev only)    */
/* REVISION: 7.3      LAST MODIFIED: 09/08/93   BY: emb *GE91*              */
/* REVISION: 7.3      LAST MODIFIED: 09/15/93   BY: ram *GF19*(rev only)    */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*              */
/* REVISION: 7.2      LAST MODIFIED: 02/17/94   BY: ais *FL87*              */
/* Oracle changes (share-locks)    09/15/94           BY: rwl *GM56*        */
/* REVISION: 7.2      LAST MODIFIED: 09/28/94   BY: ljm *GM78*              */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: wug *GN76*              */
/* REVISION: 8.5      LAST MODIFIED: 12/08/94   BY: mwd *J034*              */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*              */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: ktn *J041*              */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*              */
/* REVISION: 8.5      LAST MODIFIED: 03/08/95   BY: dzs *J046*              */
/* REVISION: 7.2      LAST MODIFIED: 04/13/95   BY: srk *G0KT*              */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   BY: tjs *J082*              */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   BY: tjs *J08X*              */
/* REVISION: 7.3      LAST MODIFIED: 12/12/95   BY: rvw *G1FL*              */
/* REVISION: 8.5      LAST MODIFIED: 03/06/96   BY: kxn *J09C*              */
/* REVISION: 8.5      LAST MODIFIED: 01/18/96   BY: bholmes *J0FY*          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland       */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone    */
/* REVISION: 8.5      LAST MODIFIED: 04/18/96   BY: jym *G1Q9*              */
/* Revision  8.5      LAST Modified: 04/26/96   BY: BHolmes *J0KF*          */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*              */
/* Revision  8.5      LAST Modified: 06/24/96   BY: RWitt   *G1XY*          */
/* Revision  8.5      LAST Modified: 07/08/96   BY: kxn     *J0Y1*          */
/* Revision  8.5      LAST Modified: 07/16/96   BY: kxn     *J0QX*          */
/* Revision  8.5      LAST Modified: 07/23/96   BY: GWM     *J10N*          */
/* Revision  8.6      LAST Modified: 02/04/97   BY: *J1GW* Murli Shastri    */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.5      LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 06/04/99   BY: *J3DH* Satish Chavan    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney   */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent     */
/* REVISION: 9.1      LAST MODIFIED: 02/11/00   BY: *J3P4* Sachin Shinde    */
/* REVISION: 9.1      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai      */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *L0TJ* Jyoti Thatte     */
/* REVISION: 9.1      LAST MODIFIED: 05/10/00   BY: *N091* Vandna Rohira    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *N0LH* Arul Victoria   */
/* REVISION: 9.1      LAST MODIFIED: 01/08/01   BY: *L171* Vivek Gogte     */
/* REVISION: 9.1      LAST MODIFIED: 04/22/04   BY: *ADM*  Heshiyu         */
/*                    Add time range and fixed the effdate                 */
/*                    relation prg: woworcaxx.p,xxictrans.i                */
/*                    Modified:      07/13/04   by: *ADM* Heshiyu    
                      relation prg: woisrc01xx.p,woisrc1dxx.p              */   

/*ss-20121226.1 by Steven*/
/*ADM*/ /* {mfdtitle.i "b+d "}  ss-20121226.1*/

{mfdtitle.i "20121226.1"}    /*ss-20121226.1*/


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowoisrc_p_1 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_3 "Cancel B/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_5 "    Receipt Qty = Open Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_6 "Close"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_7 "Backflush"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_8 "Conversion"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_9 "Substitute"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_10 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_11 "Receive"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_12 "Receive All Co/By-Products"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisrc_p_13 "Set Attributes"
/* MaxLen: Comment: */

/*N091** BEGIN DELETE
 * &SCOPED-DEFINE wowoisrc_p_14
 *  "Work Order receipt not allowed for final assy order"
/* MaxLen: Comment: */
 *N091** END DELETE */


/* ********** End Translatable Strings Definitions ********* */

/*N0LH* ------------------- BEGIN DELETE ----------------------- *
 * &SCOPED-DEFINE wowoisrc_p_2 " Co/By-Products Receipt Options "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE wowoisrc_p_4 "Issue"
 * /* MaxLen: Comment: */
 *
 *N0LH* ------------------- END   DELETE ----------------------- */

/*K001*/ {gldydef.i new}
/*K001*/ {gldynrm.i new}

/*G1Q9*/ define new shared variable gldetail like mfc_logical no-undo initial no.
/*G1Q9*/ define new shared variable gltrans like mfc_logical no-undo initial no.
         define new shared variable rmks like tr_rmks.
         define new shared variable serial like tr_serial.
         define new shared variable conv like um_conv
            label {&wowoisrc_p_8} no-undo.
         define new shared variable reject_conv like conv no-undo.
         define new shared variable pl_recno as recid.
         define new shared variable close_wo like mfc_logical label {&wowoisrc_p_6}.
         define new shared variable undo_all like mfc_logical no-undo.

         define new shared variable comp like ps_comp.
         define new shared variable qty like wo_qty_ord.
         define new shared variable leadtime like pt_mfg_lead.
         define new shared variable prev_status like wo_status.
         define new shared variable prev_release like wo_rel_date.
         define new shared variable prev_due like wo_due_date.
         define new shared variable prev_qty like wo_qty_ord.
         define new shared variable prev_site like wo_site.
         define new shared variable del-yn like mfc_logical.
         define new shared variable deliv like wod_deliver.
         define new shared variable any_issued like mfc_logical.
/*F896*/ define new shared variable any_feedbk like mfc_logical.

         define new shared variable part like wod_part.
         define variable issue like mfc_logical label {&wowoisrc_p_7}
                                                  initial yes.
         define variable receive like mfc_logical label {&wowoisrc_p_11}
                                                  initial yes.
/*J046   define variable nbr like wo_nbr.              **/
/*J046*/ define new shared variable nbr like wo_nbr.
         define variable qopen like wod_qty_all label {&wowoisrc_p_10}.
/*J046   define variable yn like mfc_logical.          **/
/*J046*/ define new shared variable yn like mfc_logical.
/*J046*/ define new shared variable sf_cr_acct like dpt_lbr_acct.
/*N014*/ define new shared variable sf_cr_sub  like dpt_lbr_sub .
/*J046*/ define new shared variable sf_dr_acct like dpt_lbr_acct.
/*N014*/ define new shared variable sf_dr_sub  like dpt_lbr_sub .
/*J046*/ define new shared variable sf_cr_cc like dpt_lbr_cc.
/*J046*/ define new shared variable sf_dr_cc like dpt_lbr_cc.
/*J046*/ define new shared variable sf_cr_proj like glt_project.
/*J046*/ define new shared variable sf_dr_proj like glt_project.
/*J046*/ define new shared variable sf_gl_amt like tr_gl_amt.
/*J046*/ define new shared variable sf_entity like en_entity.
         define new shared variable eff_date like glt_effdate.
         define new shared variable ref like glt_ref.
         define variable desc1 like pt_desc1.
/*J046   define variable i as integer.                 **/
/*J046*/ define new shared variable i as integer.
         define variable trqty like tr_qty_chg.
         define variable trlot like tr_lot.
         define variable qty_left like tr_qty_chg.
         define new shared variable wopart_wip_acct like pl_wip_acct.
/*N014*/ define new shared variable wopart_wip_sub  like pl_wip_sub .
         define new shared variable wopart_wip_cc like pl_wip_cc.
         define variable j as integer.
/*       define shared variable mfguser as character.           *G255* */
         define new shared variable wo_recno as recid.
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
         define new shared variable lotref like sr_ref format "x(8)" no-undo.
         define new shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable multi_entry as logical label {&wowoisrc_p_1}
                                                           no-undo.
         define new shared variable lotserial_control as character.
         define new shared variable cline as character.
         define new shared variable row_nbr as integer.
         define new shared variable col_nbr as integer.
         define new shared variable total_lotserial_qty like wod_qty_chg.
         define new shared variable wo_recid as recid.
         define new shared variable wod_recno as recid.
/*G0KT*/ define new shared variable outta_here as logical initial "no" no-undo.
/*G1FL*/ define new shared variable rejected   as logical initial "no" no-undo.
/*G1XY*/ define new shared variable critical-part like wod_part    no-undo.
/*M0JN*/ define new shared variable critical_flg  like mfc_logical no-undo.

         define variable tot_lad_all like lad_qty_all.
         define variable ladqtychg like lad_qty_all.

         define variable sub_comp like mfc_logical label {&wowoisrc_p_9}.
         define variable firstpass like mfc_logical.
         define variable cancel_bo as logical label {&wowoisrc_p_3}.

/*G292*  define variable fas_wo_rec as character. */
/*G292*/ define variable fas_wo_rec like fac_wo_rec.
/*J046*/ define new shared variable jp like mfc_logical.
/*J046*/ define new shared variable joint_type like wo_joint_type.
/*J046*/ define new shared variable base like mfc_logical.
/*J046*/ define new shared variable base_id like wo_base_id.
/*J046*/ define new shared variable jp-yn like mfc_logical.
/*J046*/ define new shared variable recv like mfc_logical initial yes.
/*J046*/ define new shared variable recv_all like mfc_logical initial no.
/*J046*/ define variable regular like mfc_logical initial yes.
/*J046*/ define new shared variable open_ref like sr_qty.
/*J046*/ define new shared variable um like pt_um no-undo.
/*J046*/ define new shared variable tot_units like wo_qty_chg.
/*J046*/ define new shared variable reject_um like pt_um no-undo.
/*J046*/ define new shared variable reject_qty like wo_rjct_chg no-undo.
/*J046*/ define new shared variable trans_um like pt_um.
/*J046*/ define new shared variable transtype as character
/*J09C*/ initial "RCT-WO".
/*J046*/ define new shared variable trans_conv like sod_um_conv.
/*J046*/ define new shared variable msg-counter as integer no-undo.
/*J046*/ define new shared variable recpt-bkfl like mfc_logical initial yes.
/*J046*/ define new shared variable back_qty like sr_qty.
/*J046*/ define variable backqty like sr_qty.
/*J046*/ define variable base_qty like sr_qty.
/*J046*/ define variable parent_item like pt_part.
/*J046*/ define variable base_item like pt_part.
/*J046*/ define variable reg as character format "x(1)".
/*J046*/ define variable parent_qty like sr_qty.
/*J046*/ define new shared variable undo_setd like mfc_logical no-undo.
/*J046*/ define new shared variable undo_jp like mfc_logical.
/*J046*/ define buffer womstr for wo_mstr.
/*J046*/ define variable glcost like sct_cst_tot.
/*J046*/ define variable msgref like tr_msg.
/*ADM*/  define shared variable v_timestr as char format "x(10)".
/*ADM*/  define shared variable v_effdate like glt_effdate.
/*ADM*/  define shared variable v_time as integer format "9".
/*ADM*/  define new shared variable v_mark as char format "x(24)".

/*J082** begin deleted block **********************
      *  define variable wip_accum like wo_wip_tot.
      *  define variable glx_mthd like cs_method.
      *  define variable glx_set like cs_set.
      *  define variable cur_mthd like cs_method.
      *  define variable cur_set like cs_set.
      *  define variable alloc_mthd like acm_method.
      *  define new shared workfile alloc_wkfl no-undo
      *     field alloc_wonbr as character
      *     field alloc_recid as recid
      *     field alloc_numer as decimal
      *     field alloc_pct   as decimal.
**J082** end deleted block */


/*N0LH* ------------------- BEGIN DELETE ----------------------- *
 *       define new shared variable issue_or_receipt as character
 *          initial {&wowoisrc_p_4}.
 *N0LH* ------------------- END   DELETE ----------------------- */

/*N0LH* ------------------- BEGIN ADD ----------------------- */
         define new shared variable issue_or_receipt as character.
         issue_or_receipt = getTermLabel("ISSUE",8).
/*N0LH* ------------------- END   ADD ----------------------- */

/*J040*/ define new shared variable chg_attr like mfc_logical no-undo
     label {&wowoisrc_p_13}.
/*J040*/ define new shared variable wolot like wo_lot.
/*J040*/ /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
/*J040*/ {gpatrdef.i "new shared"}

/*J041*/ define variable oldlot like sr_lotser .
/*J041*/ define variable trans_ok like mfc_logical.

/*J0FY*/ define variable w-file-type as character format "x(25)".
/*J0FY*/ define variable w_nbr like wo_mstr.wo_nbr.
/*J0FY*/ define variable w_wip_site like si_mstr.si_site.
/*J0FY*/ define variable w_wo_lot   like wo_mstr.wo_lot.
/*J0FY*/ define variable w_part     like pt_mstr.pt_part.
/*J0KF* moved from include file icrcex.i */
/*J0KF*/ define variable w-te_nbr as integer.
/*J0KF*/ define variable w-te_type as character.
/*J0KF*/ define variable w-datastr as character format "x(255)".
/*J0KF*/ define variable w-len as integer.
/*J0KF*/ define variable w-counter as integer.
/*J0KF*/ define variable w-tstring as character format "x(50)".
/*J0KF*/ define variable w-group as character format "x(18)".
/*J0KF*/ define variable w-str-len as integer.
/*J0KF*/ define variable w-update as character format "x".
/*J0KF*/ define variable w_whl_src_dest_id like whl_mstr.whl_src_dest_id.
/*J0KF*/ define variable w-sent as integer initial 0.
/*N002*/ define new shared variable h_wiplottrace_procs as handle no-undo.
/*N002*/ define new shared variable h_wiplottrace_funcs as handle no-undo.
/*N002*/ define variable routing_code as character no-undo.
/*N002*/ {wlfnc.i} /* FUNCTION FORWARD DECLARATIONS */
/*N002*/ {wlcon.i} /* CONSTANTS DEFINITIONS         */

/*J0QX* /*H039*/ {gpglefdf.i} */
/*J0QX*/ {gpglefv.i}

     /* INPUT OPTION FORM */
/*ADM*/ eff_date = v_effdate.

     form
        wo_nbr      colon 12 wo_lot      eff_date    colon 68
/*G782      wo_part     colon 12 wo_status   issue       colon 68 */
/*G782      desc1       at 14 no-label       receive     colon 68 */
/*G782*/    wo_part     colon 12 wo_status   receive     colon 68
/*ADM*/     v_timestr   at 1 no-label 
/*G782*/    desc1       at 14 no-label       issue       colon 68
     with frame a side-labels width 80 attr-space.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).

/*J046*/ form
/*J046*/            skip (1)
/*J1GW* /*J046*/    recv_all colon 40 label "Receive All Joint Products" */
/*J1GW*/    recv_all colon 40 label {&wowoisrc_p_12}
/*J046*/    recv     colon 40 label {&wowoisrc_p_5}
/*J046*/            skip (1)
/*J046*/ with frame r side-labels overlay row 9 column 19
/*J1GW* /*J046*/ title color normal " Joint Products Receipt Options " */
/*J1GW*/ title color normal
(getFrameTitle("CO/BY-PRODUCTS_RECEIPT_OPTIONS",42))
/*J046*/ width 50 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame r:handle).

/*K001*/ if daybooks-in-use then
/*K001*/    {gprun.i ""nrm.p"" "persistent set h-nrm"}.

/*ADM         eff_date = today. */
/*ADM*/      eff_date = v_effdate.
     do transaction:
/*G292*     fas_wo_rec = string(true).      /*DEFAULT VALUE*/
        {mfctrl01.i mfc_ctrl fas_wo_rec fas_wo_rec false} */

/*G292*/    /* Added section */
        find mfc_ctrl exclusive-lock where mfc_field = "fas_wo_rec"
        no-error.
        if available mfc_ctrl then do:
           find first fac_ctrl exclusive-lock no-error.
           if available fac_ctrl then do:
          fac_wo_rec = mfc_logical.
          delete mfc_ctrl.
           end.
           release fac_ctrl.
        end.

/*GE91*/    release mfc_ctrl.

        find first fac_ctrl no-lock no-error.
        if available fac_ctrl then fas_wo_rec = fac_wo_rec.
/*G292*/    /* End of added section */

     end.

     /* DISPLAY */
     mainloop:
     repeat:


/*J038*/    do transaction:
/*J038*/      for each sr_wkfl exclusive-lock where sr_userid = mfguser:
/*J038*/         delete sr_wkfl.
/*J038*/      end.
/*J038*/      {gprun.i ""gplotwdl.p""}

/*L171*/    /* ADDED LOGIC TO DELETE STRANDED lad_det RECORDS  */
/*L171*/       for each lad_det exclusive-lock
/*L171*/          where lad_dataset  = "wod_det"
/*L171*/            and lad_nbr      = wolot
/*L171*/            and lad_qty_all  = 0
/*L171*/            and lad_qty_pick = 0:
/*L171*/          delete lad_det.
/*L171*/       end. /* FOR EACH lad_det ... */

/*J038*/    end.

/*J3P4*/    assign
/*J3P4*/       regular = yes
/*J046*/       jp = no.
        nbr = "".
        display v_timestr /*ADM*/ eff_date issue receive with frame a.
/*G782      prompt-for wo_nbr wo_lot eff_date issue receive */

/*G782*ADM    prompt-for wo_nbr wo_lot eff_date receive issue   */
/*ADM*/     prompt-for wo_nbr wo_lot receive issue
        with frame a editing:
           if frame-field = "wo_nbr" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i wo_mstr wo_nbr wo_nbr wo_nbr wo_nbr wo_nbr}
           end.
           else if frame-field = "wo_lot" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          if input wo_nbr <> "" then do:
             {mfnp01.i
            wo_mstr
            wo_lot
            wo_lot
            "input wo_nbr"
            wo_nbr
            wo_nbr}
          end.
          else do:
             {mfnp.i wo_mstr wo_lot wo_lot wo_lot wo_lot wo_lot}
          end.
           end.
           else do:
          status input.
          readkey.
          apply lastkey.
           end.
           if recno <> ? then do:
/*J040*/          wolot = wo_lot.
          desc1 = "".
          find pt_mstr where pt_part = wo_part no-lock no-error.
          if available pt_mstr then desc1 = pt_desc1.
          display wo_nbr wo_lot wo_part wo_status desc1 with frame a.
           end.
/*J040*/       else do:
/*J040*/          wolot = input wo_lot.
/*J040*/       end.
        end.

/*ADM     assign eff_date issue receive.
        if eff_date = ? then eff_date = today.*/
/*ADM*/ assign issue receive.

        /* CHECK EFFECTIVE DATE */
/*H039*     {mfglef.i eff_date} */
/*J0QX* /*H039*/    {gpglef.i ""IC"" glentity eff_date} */

        nbr = input wo_nbr.
        if input wo_nbr <> "" then
        if not can-find(first wo_mstr using wo_nbr)
        then do:
           {mfmsg.i 503 3}.
           undo, retry.
        end.

        if nbr = "" and input wo_lot = "" then undo, retry.
        if nbr <> "" and input wo_lot <> "" then
        find wo_mstr where wo_nbr = nbr using wo_lot no-error.
        if nbr = "" and input wo_lot <> "" then
        find wo_mstr using wo_lot no-error.
        if nbr <> "" and input wo_lot = "" then
        find first wo_mstr where wo_nbr = nbr no-error.
        if not available wo_mstr then do:
           {mfmsg.i 510 3}
           /*  WORK ORDER DOES NOT EXIST.*/
           undo, retry.
        end.
/*J0QX*/    find si_mstr where si_site = wo_site no-lock.
/*J0QX*/    {gpglef1.i &module = ""WO""
             &entity = si_entity
             &date = eff_date
             &prompt = "eff_date"
             &frame = "a"
             &loop = "mainloop"
             }

/*J082*/    desc1 = "".
/*J082*/    display wo_nbr wo_part wo_lot wo_status desc1 with frame a.

/*J040*/    if input wo_lot <> "" or
/*J040*/       input wo_lot <> " " then do:
/*J040*/       wolot = input wo_lot.
/*J040*/    end.
/*J040*/    else do:
/*J040*/       wolot = wo_lot.
/*J040*/    end.

/*N05Q*/    /* DON'T ALLOW PROJECT ACTIVITY RECORDING WORK ORDERS */
/*N05Q*/    if wo_fsm_type = "PRM" then do:
/*N05Q*/        {mfmsg.i 3426 3}    /* CONTROLLED BY PRM MODULE */
/*N05Q*/        undo, retry.
/*N05Q*/    end.

        if lookup(wo_status,"A,R" ) = 0
        and (issue or receive)
        then do:
           {mfmsg.i 523 3}
           /* WORK ORDER LOT IS CLOSED, PLANNED OR FIRM PLANNED */
           {mfmsg02.i 525 1 wo_status}
           /* CURRENT WORK ORDER STATUS: */
           undo, retry.
        end.

        /* DON'T ALLOW CALL ACTIVITY RECORDING WORK ORDERS */
/*J04C*/    if wo_fsm_type = "FSM-RO" then do:
/*J04C*/        {mfmsg.i 7492 3}    /* FIELD SERVICE CONTROLLED */
/*J04C*/        undo, retry.
/*J04C*/    end.

/*J034*/    {gprun.i ""gpsiver.p""
         "(input wo_site, input ?, output return_int)"}
/*J034*/    if return_int = 0 then do:
/*J034*/       {mfmsg02.i 2710 3 wo_site} /* USER DOES NOT HAVE */
/*J034*/                                  /* ACCESS TO SITE XXXXX*/
/*J034*/       undo mainloop, retry.
/*J034*/    end.

/*GN76      ADDED FOLLOWING SECTION*/
        if wo_type = "c" and wo_nbr = "" then do:
           {mfmsg.i 5123 3}
           undo, retry.
        end.
/*GN76      END SECTION*/

/*N002*/ if is_wiplottrace_enabled() then do:

/*N002*/    routing_code = if wo_routing = "" then wo_part else wo_routing.

/*N002*/    for last wlrm_mstr where
/*N002*/             wlrm_routing = routing_code  and
/*N002*/             wlrm_start <= eff_date        and
/*N002*/             (wlrm_end >= eff_date or wlrm_end = ?)
/*N002*/              no-lock:
/*N002*/    end.

/*N002*/    if not available wlrm_mstr then do:
/*N002*/       for first wlrm_mstr where
/*N002*/                 wlrm_routing = routing_code and
/*N002*/                 wlrm_start = ?              and
/*N002*/                 (wlrm_end >= eff_date or wlrm_end = ?)
/*N002*/                 no-lock:
/*N002*/       end.
/*N002*/    end.

/*N002*/    if available wlrm_mstr and wlrm_trc_parent then do:
/*N002*/       {mfmsg.i 8552 3} /* WIP LOT TRACE ENABLED. USE*/
/*N002*/                        /* WORK ORDER BACKFLUSH */
/*N002*/       undo, retry.
/*N002*/    end.
/*N002*/    else do:
/*N002*/       for first wlc_ctrl no-lock: end.
/*N002*/       if wlc_trc_parent then do:
/*N002*/          {mfmsg.i 8552 3} /* WIP LOT TRACE ENABLED. USE */
/*N002*/                           /* WORK ORDER BACKFLUSH. */
/*N002*/          undo, retry.
/*N002*/       end.
/*N002*/    end.
/*N002*/ end.

        if receive then do:
/*G292*    if wo_type = "F" and fas_wo_rec = string(false) then do: */
/*G292*/   if wo_type = "F" and fas_wo_rec = false then do:
/*N091** BEGIN DELETE
 *            {mfmsg04.i
 *            ""{&wowoisrc_p_14}"" 3}
 *N091** END DELETE */
/*N091*/      /* WORK ORDER RECEIPT NOT ALLOWED FOR FINAL ASSY ORDER */
/*N091*/      {mfmsg.i 3804 3}
              undo, retry.
           end.
        end.
/*N014*/ assign
            prev_status     = wo_status
            prev_release    = wo_rel_date
            prev_due        = wo_due_date
            prev_qty        = wo_qty_ord
            prev_site       = wo_site
            wopart_wip_acct = wo_acct
/*N014*/    wopart_wip_sub  = wo_sub
            wopart_wip_cc   = wo_cc.

        desc1 = "".
        find pt_mstr where pt_part = wo_part no-lock no-error.
        if available pt_mstr then do:
           desc1 = pt_desc1.
           find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
           if available(pl_mstr) and wopart_wip_acct = "" then do:
/*N014*/     assign
               wopart_wip_acct = pl_wip_acct
/*N014*/       wopart_wip_sub  = pl_wip_sub
               wopart_wip_cc   = pl_wip_cc.
           end.
        end.

        display wo_nbr wo_part wo_lot wo_status desc1 with frame a.
/*ADM        if eff_date = ? then eff_date = today.*/

        wo_recno = recid(wo_mstr).

/*J046*/   /* CHECK FOR JOINT PRODUCT FLAGS */
/*J046*/   if wo_joint_type <> "" then do:
/*J046*/      jp = yes.
/*J046*/      if wo_joint_type = "5" then do:
/*J046*/         base_id = wo_lot.
/*J046*/         base = yes.
/*J046*/      end.
/*J046*/      else do:
/*J046*/         base = no.
/*J046*/         parent_item = wo_part.
/*J046*/         base_id = wo_base_id.
/*J046*/         parent_qty = wo_qty_ord.
/*J046*/      end.
/*J046*/   end.

/*J046*/    if jp then do:
/*J046*/       regular = no.
/*J046*/       jp-yn = yes.
/*J046*/       recv = yes.
/*J046*/    end.

        do transaction:
/*GM56*/       for each sr_wkfl exclusive-lock where sr_userid = mfguser:
          delete sr_wkfl.
           end.
/*G782*/       assign
/*G782*/          wo_qty_chg = 0
/*G782*/          wo_rjct_chg = 0.
        end.

/*G782      if issue then do:                                           */
/*G782         {gprun.i ""woisrc01.p""}                                 */
/*G782         if keyfunction(lastkey) = "end-error" then undo, retry.  */
/*G782      end.                                                        */

/*J046*/    if jp and receive then do:
/*J046*/       regular = no.
/*J046*/       jp-yn = yes.
/*J046*/       firstpass = yes.
/*J046*/       recv_all = yes.
/*J046*/       recv = no.
/*J046*/       pause 0.
/*J08X*/       if base then display recv_all with frame r.
/*J046*/       update recv_all when (not base) with frame r.
/*J046*/       if recv_all then update recv with frame r.
/*J046*/       if recv_all or base then do:
/*J046*/          hide frame a no-pause.
/*J0Y1*/          hide frame r no-pause.
/*J046*/          {gprun.i ""wojprc.p"" "(input wo_nbr)"}.
/*J046*/          if undo_jp then undo, retry.
/*J046*/       end.
/*J046*/    end.

/*L0TJ*/    release wo_mstr.
/*J046      if receive then do:  ****/
/*J046*/    if (regular and receive)  or (not recv_all and receive) then do:
/*J046*/       view frame a.

/*J041*        {gprun.i ""woisrc02.p""}                                 */
/*ADM/*J041*/       {gprun.i ""woisrc02.p"" "(output trans_ok)"}        */
/*ADM*/        {gprun.i ""woisrc02xx.p"" "(output trans_ok)"}        
/*J041*/       if not trans_ok then undo, retry.
/*GM78*/ /*V8-*/
           if keyfunction(lastkey) = "end-error" then undo, retry. /*V8+*/
        end.

/*J046*/    /*   DISPLAY THE BASE ITEM IN FRAME A ***/
/*J046*/    if jp and issue then do:
/*J046*/       find first wo_mstr no-lock where wo_lot = base_id no-error.
/*J046*/       if available wo_mstr then do:
/*J046*/          wo_recno = recid(wo_mstr).
/*J046*/          find pt_mstr where pt_part = wo_part no-lock no-error.
/*J046*/          if available pt_mstr then desc1 = pt_desc1.
/*J046*/          base_item = wo_part.
/*J046*/          base_qty = wo_qty_ord.
/*J046*/          find bom_mstr where bom_parent = base_item no-lock no-error.
/*J046*/          display wo_nbr wo_lot wo_part wo_status desc1 with frame a.
/*J046*/          if bom_mthd = "2" then back_qty = base_qty.
/*J046*/       end.
/*J046*/    end.

/*G782*/    if issue then do:
/*J046*/       if jp and undo_jp then undo, retry.
/*G0KT*/ /*V8! outta_here = no. */
/*G782*//*ADM*/  /*{gprun.i ""woisrc01xx.p""}*/ /*ss-20121226.1*/
                {gprun.i ""xxwoisrc01xx.p""}    /*ss-20121226.1*/
/*G0KT*/ /*V8-*/
/*G782*/       if keyfunction(lastkey) = "end-error" then undo, retry.
/*G0KT*/ /*V8+*/
/*G0KT*/ /*V8! if outta_here then undo, retry. */
/*G782*/    end.

        do transaction on endkey undo mainloop, retry mainloop:
           yn = yes.
           {mfmsg01.i 32 1 yn} /* "Please confirm update" */
           if yn then do:

           if issue then do:
/*G1FL*/             /* RECHECK INVENTORY TO VERIFY ALL IS STILL OK    */
/*G1FL*/             {gprun.i ""woisrc1c.p""}
/*G1FL*/             if rejected then undo mainloop, retry mainloop.

/*N002*/            /* ADDED ? AS INPUT INTO wowoisa.p. WIP LOT TRACING */
/*N002*/            /* ADDED A NEW INPUT PARAMETER TO wowoisa.p WHEN IT */
/*N002*/            /* WAS CALLED FROM wowois.p and wobkfl.p IN ORDER TO*/
/*N002*/            /* DO WIP LOT  TRACE PROCESSING. HOWEVER, THE OTHER */
/*N002*/            /* TWO PROGRAMS THAT CALL wowoisa.p (wowoisrc.p and */
/*N002*/            /* fsrmarla.p) DON'T USE WIP LOT TRACE. THEREFORE,  */
/*N002*/            /* WE NEED TO PASS A NULL VALUE FROM THESE TWO      */
/*N002*/            /* PROGRAMS INTO wowoisa.p SO THAT THE PROGRAM WILL */
/*N002*/            /* NOT BOMB OUT.                                    */

/*J3DH**      {gprun.i ""wowoisa.p""} */
/*J3DH*/      {gprun.i ""wowoisa.p"" "(input no, input ?)"}
           end.

/*J046            if receive then do:     **/
/*J046*/          if not jp and receive then do:

/*FL87*/ /*          find in_mstr where in_part = wo_part and in_site = wo_site
      *          exclusive no-error.
      *
      *          if available in_mstr then do:
      *             in_qty_ord = in_qty_ord
      *                        - max(wo_qty_ord
      *                             - (wo_qty_comp + wo_qty_rjct),0)
      *                        + max(wo_qty_ord
/*F104    *                             - (wo_qty_comp + (wo_qty_chg * conv) */
/*F104    *                               + wo_qty_rjct                      */
/*F104    *                               + (wo_rjct_chg * reject_conv)),0). */
/*F104*/  *                             - (wo_qty_comp + wo_qty_chg
/*F104*/  *                               + wo_qty_rjct
/*F104*/  *                               + wo_rjct_chg),0).
      *
      *             if in_qty_ord < 0 then in_qty_ord = 0.
      *          end.
/*FL87*/  */

/*J10N************ REPLACED BELOW INCLUDE FILE ICRCEX.I WITH WIICRCEX.P ***/

             /* DETERMINE IF WAREHOUSING INTERFACE IS ACTIVE */
/*J10N*/             if can-find(first whl_mstr
/*J10N*/                         where whl_act = true no-lock) then do:

/*J10N*/                for each sr_wkfl where sr_userid = mfguser no-lock:

/*J10N*/                   find wo_mstr where recid(wo_mstr) = wo_recno no-lock.

               /* EXPORT DATA TO WAREHOUSE INTERFACE */
/*J10N*/                   if sr_site = wo_site then location = sr_loc.
/*J10N*/                   else location = pt_loc.

/*J10N*/                   {gprun.i ""wiicrcex.p""
                    "(input 'wi-wowoisrc',
                      input wo_nbr,
                      input wo_lot,
                      input wo_part,
                      input sr_qty,
                      input trans_um,
                      input trans_conv,
                      input sr_site,
/*J2K7                    input sr_loc, */
/*J2K7*/                              input location,
                      input sr_lot,
                      input sr_ref,
                      input eff_date)"}

/*J10N*/                end. /* FOR EACH SR_WKFL */

/*J10N*/             end. /* IF WAREHOUSING ACTIVE */

/*J10N ************ REPLACED BELOW CODE WITH ABOVE CODE ******************
 * /*ben*/
 * /*J0FY*/            for each sr_wkfl where sr_userid = mfguser:
 * /*J0FY*/                find wo_mstr where recid(wo_mstr) = wo_recno.
 * /*J0FY*/                assign
 * /*J0FY*/                    w_nbr       = wo_nbr
 * /*J0FY*/                    w_wip_site  = ""
 * /*J0FY*/                    site        = wo_site
 * /*J0FY*/                location = if sr_site = wo_site then sr_loc else pt_l
 * /*J0FY*/                    w_wo_lot    = wo_lot
 * /*J0FY*/                    w_part      = wo_part
 * /*J0FY*/                    w-file-type = "wowoisrc".
 * /*J0FY*/                       {icrcex.i}
 *
 * /*J0FY*/            end.
 *J10N ************ END OF REPLACED CODE *********************************/

             /* CREATE TRANSACTION HISTORY RECORD */
/*ADM             {gprun.i ""woworca.p""}.*/
/*ADM*/      {gprun.i ""woworcaxx.p""}.
             find wo_mstr where recid(wo_mstr) = wo_recno.
             if close_wo then wo_status = "C".
             {gprun.i ""wowomta.p""}
          end.

/*J046*/          /* JOINT PRODUCT INVENTORY, GL, AND WO_MSTR UPDATES */
/*J046*/          if jp and not undo_jp and receive then do:
/*J082*/             {gprun.i ""wojprcb.p""}
/*J082*/          end.

/*J082************** begin deleted block *************************************
/*J046*/ *           find womstr no-lock where recid(womstr) = wo_recno
/*J046*/ *           no-error.
     *
/*J046*/ *           /* MEMO RECEIPT FOR BASE PROCESS ORDER */
/*J046*/ *           find first wo_mstr exclusive-lock
/*J046*/ *           where wo_mstr.wo_nbr = womstr.wo_nbr
/*J046*/ *           and wo_mstr.wo_joint_type = "5"
/*J046*/ *           no-error.
     *
/*J046*/ *           if available wo_mstr then do:
/*J046*/ *              wo_mstr.wo_qty_chg = 1.
/*J046*/ *              {ictrans.i
     *               &addrid=""""
     *               &bdnstd=0
     *               &cracct=""""
     *               &crcc=""""
     *               &crproj=""""
     *               &curr=""""
     *               &dracct=""""
     *               &drcc=""""
     *               &drproj=""""
     *               &effdate=eff_date
     *               &exrate=0
     *               &glamt=0
     *               &lbrstd=0
     *               &line=0
     *               &location=""""
     *               &lotnumber=wo_mstr.wo_lot
     *               &lotserial=""""
     *               &lotref=""""
     *               &mtlstd=0
     *               &ordernbr=wo_mstr.wo_nbr
     *               &ovhstd=0
     *               &part=wo_mstr.wo_part
     *               &perfdate=?
     *               &price=glcost
     *               &quantityreq=0
     *               &quantityshort=0
     *               &quantity=1
     *               &revision=""""
     *               &rmks=rmks
     *               &shiptype=""M""
     *               &site=wo_mstr.wo_site
     *               &slspsn1=""""
     *               &slspsn2=""""
     *               &sojob=""""
     *               &substd=0
     *               &transtype=""RCT-WO""
     *               &msg=0
     *               &ref_site=wo_mstr.wo_site
     *              }
     *
/*J046*/ *            /* MEMO ISSUES OF BASE PROCESS ITEM TO
     *               JOINT PRODUCT LOT#s */
/*J046*/ *            for each womstr where womstr.wo_nbr = wo_mstr.wo_nbr
/*J046*/ *            and womstr.wo_joint_type <> "5"
/*J046*/ *            and wo_mstr.wo_joint_type > ""
/*J046*/ *            and womstr.wo_base_id = wo_mstr.wo_lot:
/*J046*/ *                find first sr_wkfl where sr_userid = mfguser
/*J046*/ *                and substring(sr_lineid,4,18) = womstr.wo_part
/*J046*/ *                and sr_lineid begins "RCT" no-lock no-error.
/*J046*/ *                if available sr_wkfl then do:
/*J046*/ *                   {ictrans.i
     *                    &addrid=""""
     *                    &bdnstd=0
     *                    &cracct=""""
     *                    &crcc=""""
     *                    &crproj=""""
     *                    &curr=""""
     *                    &dracct=""""
     *                    &drcc=""""
     *                    &drproj=""""
     *                    &effdate=eff_date
     *                    &exrate=0
     *                    &glamt=0
     *                    &lbrstd=0
     *                    &line=0
     *                    &location=""""
     *                    &lotnumber=womstr.wo_lot
     *                    &lotserial=wo_mstr.wo_lot
     *                    &lotref=""""
     *                    &mtlstd=0
     *                    &ordernbr=womstr.wo_nbr
     *                    &ovhstd=0
     *                    &part=wo_mstr.wo_part
     *                    &perfdate=?
     *                    &price=glcost
     *                    &quantityreq=0
     *                    &quantityshort=0
     *                    &quantity=1
     *                    &revision=""""
     *                    &rmks=rmks
     *                    &shiptype=""M""
     *                    &site=wo_mstr.wo_site
     *                    &slspsn1=""""
     *                    &slspsn2=""""
     *                    &sojob=""""
     *                    &substd=0
     *                    &transtype=""ISS-WO""
     *                    &msg=0
     *                    &ref_site=wo_mstr.wo_site
     *                   }
/*J046*/ *                   if available trgl_det then delete trgl_det.
/*J046*/ *                end.
/*J046*/ *            end.
     *
/*J046*/ *            /* BASE PROCESS WORK ORDER */
/*J046*/ *            find womstr no-lock where womstr.wo_nbr = wo_mstr.wo_nbr
/*J046*/ *                                  and womstr.wo_joint_type = "5".
     *
/*J046*/ *            /* JOINT PRODUCT WORK ORDERS */
/*J046*/ *            for each wo_mstr exclusive-lock where
/*J046*/ *            wo_mstr.wo_nbr = womstr.wo_nbr and
/*J046*/ *            wo_mstr.wo_joint_type <> "" and
/*J046*/ *            recid(wo_mstr) <> recid(womstr):
/*J046*/ *               wo_recno = recid(wo_mstr).
     *
/*J046*/ *               /* INVENTORY AND GL TRANSACTIONS FOR
     *                  JOINT PRODUCT ORDERS */
     *
/*J046*/ *               {gprun.i ""woworca.p""}
     *
/*J046*/ *               /* UPDATE wip_accum */
/*J046*/ *               wip_accum = wip_accum + wo_mstr.wo_wip_tot.
/*J046*/ *               wo_mstr.wo_wip_tot = 0.
     *
/*J046*/ *               /* CLOSE JOINT PRODUCT WORK ORDERS */
/*J046*/ *               if close_wo then do:
/*J046*/ *                  wo_mstr.wo_status = "C".
/*J046*/ *                  {gprun.i ""wowomta.p""}
/*J046*/ *               end.
     *
/*J046*/ *            end. /* END - JOINT PRODUCT WORK ORDERS */
     *
/*J046*/ *            /* UPDATE BASE PROCESS ORDER */
/*J046*/ *            find wo_mstr exclusive-lock
/*J046*/ *            where wo_mstr.wo_nbr = womstr.wo_nbr
/*J046*/ *            and wo_mstr.wo_joint_type = "5" no-error.
/*J046*/ *            if available wo_mstr then do:
     *
/*J046*/ *               /* UPDATE RATE AND USAGE VARIANCES FOR
     *                  BASE PROCESS ORDER */
/*J046*/ *               if wip_accum <> 0 then do:
/*J046*/ *                  /*DETERMINE COSTING METHOD*/
/*J046*/ *                  {gprun.i ""csavg01.p"" "(input wo_mstr.wo_part,
     *                                           input wo_mstr.wo_site,
     *                                           output glx_set,
     *                                           output glx_mthd,
     *                                           output cur_set,
     *                                           output cur_mthd)"
     *                  }
/*J046*/ *                  if glx_mthd <> "AVG" then do:
/*J046*/ *                     wo_recid = recid(wo_mstr).
/*J046*/ *                     transtype = "VAR-POST".
/*J046*/ *                     {gprun.i ""wovarup.p""}
/*J046*/ *                  end.
/*J046*/ *               end.
/*J046*/ *               /* UPDATE wo_wip_tot FOR BASE PROCESS ORDER */
/*J046*/ *               wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot + wip_accum.
/*J046*/ *               wip_accum = 0.
     *
/*J041*/ *               if (wo_mstr.wo_lot_rcpt = no) then
/*J041*/ *                  wo_mstr.wo_lot_next = lotserial.
     *
/*J046*/ *               /* CLOSE BASE PROCESS ORDER */
/*J046*/ *               if close_wo then do:
/*J046*/ *                  wo_mstr.wo_status = "C".
/*J046*/ *                  {gprun.i ""wowomta.p""}
     *
/*J046*/ *                  if glx_mthd = "AVG" or cur_mthd = "AVG"
/*J046*/ *                  or cur_mthd = "LAST" then do:
     *
/*J046*/ *                     /*ADD STANDARD METHODS TO PROGRAM TRACE*/
/*J046*/ *                     if false then do:
/*J046*/ *                        {gprun0.i ""wocsal01.p""}
/*J046*/ *                        {gprun0.i ""wocsal02.p""}
/*J046*/ *                        {gprun0.i ""wocsal03.p""}
/*J046*/ *                     end.
     *
/*J046*/ *                     /*CHOOSE ALLOCATION METHOD*/
/*J046*/ *                     {gprun.i ""wocsjpal.p"" "(input wo_mstr.wo_part,
     *                                               input wo_mstr.wo_site,
     *                                               output alloc_mthd)"}
     *
/*J046*/ *                     /*CALCULATE ALLOCATION PERCENTAGE*/
/*J046*/ *                     {gprun.i alloc_mthd "(input recid(wo_mstr))"}
     *
/*J046*/ *                     /*UPDATE AVERAGE/LAST COSTS FOR JOINT PRODUCTS*/
/*J046*/ *                     {gprun.i ""csavg04.p"" "(input recid(wo_mstr),
     *                                              input glx_mthd,
     *                                              input glx_set,
     *                                              input cur_mthd,
     *                                              input cur_set,
     *                                              output wip_accum)"}
     *
/*J046*/ *                     wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot
     *                                        - wip_accum.
     *
/*J046*/ *                  end. /* IF GLX_MTHD = "AVG" ... */
/*J046*/ *               end. /*IF CLOSE_WO */
/*J046*/ *            end. /* BASE PROCESS ORDER UPDATE */
/*J046*/ *         end. /* DO TRANSACTION */
/*J046*/ *       end. /* IF JP THEN DO */
**J082********** end deleted block ********************************************/
           end.
        end.
/*J08X*/    if available wo_mstr then
/*J08X*/    display wo_nbr wo_lot wo_part wo_status with frame a.
         end.
/*K001*/ if daybooks-in-use then delete PROCEDURE h-nrm no-error.
