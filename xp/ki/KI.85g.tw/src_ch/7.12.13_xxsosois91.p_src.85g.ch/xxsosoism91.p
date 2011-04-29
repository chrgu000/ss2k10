/* sosoism.p - SALES ORDER SHIPMENT WITH SERIAL NUMBERS                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/****************************************************************************/
/*                                                                          */
/*    Any for each loops which go through every sod_det for a               */
/*    so_nbr (i.e. for each sod_det where sod_nbr = so_nbr )                */
/*    should have the following statments first in the loop.                */
/*                                                                          */
/*       if (sorec = fsrmarec    and sod_fsm_type  <> "RMA-RCT")            */
/*       or (sorec = fsrmaship   and sod_fsm_type  <> "RMA-ISS")            */
/*       or (sorec = fssormaship and sod_fsm_type  =  "RMA-RCT")            */
/*       or (sorec = fssoship    and sod_fsm_type  <> "")                   */
/*       then next.                                                         */
/*                                                                          */
/*    this is to prevent rma receipt line from being processed              */
/*    when issue lines are processed (sas).                                 */
/*                                                                          */
/*    also, sosoisa.p is called by fsrmamtu.p which is called               */
/*    from fsrmamt.p (rma maintenance). Any shared variables                */
/*    added to sosoisa.p will need to be added to one or both               */
/*    of the above rma programs....                                         */
/*                                                                          */
/****************************************************************************/

/* REVISION: 1.0      LAST MODIFIED: 07/28/86   BY: PML                     */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*              */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: WUG *D002*              */
/* REVISION: 6.0      LAST MODIFIED: 04/30/90   BY: MLB *D021*              */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D447*              */
/* REVISION: 6.0      LAST MODIFIED: 01/14/91   BY: emb *D313*              */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*              */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*              */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: afs *D477*   (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 04/08/91   BY: afs *D497*              */
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: afs *D510*              */
/* REVISION: 6.0      LAST MODIFIED: 05/09/91   BY: emb *D643*              */
/* REVISION: 6.0      LAST MODIFIED: 05/28/91   BY: emb *D661*              */
/* REVISION: 6.0      LAST MODIFIED: 06/04/91   BY: emb *D673*              */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*              */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: MLV *F029*              */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*              */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D858*              */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D953*              */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: SAS *F017*              */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*              */
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: afs *F209*              */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F379*              */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: tjs *F504*              */
/* REVISION: 7.0      LAST MODIFIED: 07/01/92   BY: tjs *F726*              */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F732*              */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: tjs *F805*              */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*              */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*              */
/* REVISION: 7.2      LAST MODIFIED: 11/09/92   BY: emb *G292*              */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302*              */
/* REVISION: 7.3      LAST MODIFIED: 12/05/92   BY: mpp *G484*              */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: tjs *G702*              */
/* REVISION: 7.2      LAST MODIFIED: 03/16/93   BY: tjs *G451*              */
/* REVISION: 7.3      LAST MODIFIED: 03/18/93   BY: afs *G818*              */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39*              */
/* REVISION: 7.3      LAST MODIFIED: 06/09/93   BY: sas *GB82*              */
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: sas *GC18*              */
/* REVISION: 7.3      LAST MODIFIED: 06/25/93   BY: WUG *GC74*              */
/* REVISION: 7.3      LAST MODIFIED: 06/28/93   BY: afs *GC22*              */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   BY: jjs *GC96*              */
/* REVISION: 7.3      LAST MODIFIED: 07/27/93   BY: tjs *GD76*              */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*              */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*              */
/* REVISION: 7.4      LAST MODIFIED: 11/14/93   BY: afs *H222*              */
/* REVISION: 7.4      LAST MODIFIED: 01/24/94   BY: afs *FL52*              */
/* REVISION: 7.4      LAST MODIFIED: 07/20/94   BY: bcm *H447*              */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *FR31*              */
/* REVISION: 7.4      LAST MODIFIED: 09/23/94   BY: ljm *GM78*              */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*              */
/* REVISION: 8.5      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*              */
/* REVISION: 8.5      LAST MODIFIED: 11/01/94   BY: ame *GN90*              */
/* REVISION: 8.5      LAST MODIFIED: 11/11/94   BY: jxz *FT56*              */
/* REVISION: 8.5      LAST MODIFIED: 12/20/94   BY: rxm *F0B4*              */
/* REVISION: 8.5      LAST MODIFIED: 01/07/95   BY: smp *G0BM*              */
/* REVISION: 8.5      LAST MODIFIED: 01/16/95   BY: rxm *F0F0*              */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: pmf *G0JW*              */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*              */
/* REVISION: 8.5      LAST MODIFIED: 04/06/95   BY: tvo *H0BJ*              */
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053*              */
/* REVISION: 8.5      LAST MODIFIED: 02/07/96   BY: ais *G0NX*              */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*              */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland       */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone    */
/* REVISION: 8.5      LAST MODIFIED: 06/13/96   BY: *G1Y6* Sue Poland       */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: *J0ZX* Andy Wasilczuk   */
/* REVISION: 8.5      LAST MODIFIED: 07/28/96   BY: *J0ZZ* T. Farnsworth    */
/* REVISION: 8.5      LAST MODIFIED: 01/02/97   BY: *J1D8* Sue Poland       */
/* REVISION: 8.5      LAST MODIFIED: 05/14/97   BY: *G2MT* Ajit Deodhar     */
/* REVISION: 8.5      LAST MODIFIED: 07/14/97   BY: *G2NY* Aruna Patil      */
/* REVISION: 8.5      LAST MODIFIED: 08/22/97   *J1RN* Shankar Subramanian  */
/* REVISION: 8.5      LAST MODIFIED: 09/02/97   BY: *J205* Suresh Nayak     */
/* REVISION: 8.5      LAST MODIFIED: 10/14/97   BY: *J22N* Aruna Patil      */
/* REVISION: 8.5      LAST MODIFIED: 10/28/97   BY: *G2Q3* Steve Nugent     */
/* REVISION: 8.5      LAST MODIFIED: 01/14/98   BY: *J29W* Aruna Patil      */
/* REVISION: 8.5      LAST MODIFIED: 12/30/97   BY: *J29S* Jim Williams     */
/* REVISION: 8.5      LAST MODIFIED: 03/17/98   BY: *H1JB* Seema Varma      */

/* SS - 090707.1 By: Roger Xiao */


         {mfdeclre.i}

         {sosois1.i}

/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define variable oldcurr like so_curr.
/*F017*/ define            variable  prefix       as character
/*F017*/                                          initial "C".
/*F017*/ define new shared variable  copyusr      like mfc_logical.
/*F017*/ define            variable  cchar        as   character.
/*H0BJ*/ define            variable  recalc       like mfc_logical
/*H0BJ*/                                          initial true.

/*G247** define shared variable mfguser as character. **/
/*GC96   define variable line like sod_line format ">>>". */
         define variable csz as character format "X(38)".
         define variable due like sod_due.
         define new shared variable fill_all like mfc_logical
            label "已备料品出货" initial no.
         define new shared variable fill_pick like mfc_logical
            label "已捡料品出货" initial yes.
         define variable dwn as integer.
         define variable qty_open like sod_qty_ship label "未结数量".
/*GC96   define variable yn like mfc_logical.*/
         define variable trnbr like tr_trnbr.
         define buffer somstr for so_mstr.
/*GC96   define variable i as integer. */
         define variable del-yn like mfc_logical initial no.
         define new shared variable so_mstr_recid as recid.

         define new shared variable qty_left like tr_qty_chg.
         define new shared variable trqty like tr_qty_chg.
         define new shared variable eff_date like glt_effdate label "生效日期".
         define new shared variable trlot like tr_lot.
         define new shared variable ref like glt_ref.
         define new shared variable qty_req like in_qty_req.
         define new shared variable open_ref like sod_qty_ord.
         define new shared variable fas_so_rec as character.
/*G451*  define new shared variable undo-all like mfc_logical.*/
/*G451*/ define new shared variable undo-all like mfc_logical no-undo.

         define new shared variable cline as character.
         define new shared variable lotserial_control as character.
         define new shared variable issue_or_receipt as character
            initial " 发料".
         define new shared variable total_lotserial_qty like sod_qty_chg.
         define new shared variable multi_entry like mfc_logical label "多笔登录".
/*GC96   define variable cancel_bo like mfc_logical label "Cancel B/O". */
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
         define new shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable trans_um like pt_um.
         define new shared variable trans_conv like sod_um_conv.
         define new shared variable loc like pt_loc.
         define variable tot_lad_all like lad_qty_all.
         define variable ladqtychg like lad_qty_all.
         define new shared variable sod_recno as recid.
/*GC96   define variable mod_iss like mfc_logical label "Issue Components". */
         define buffer srwkfl for sr_wkfl.
         define new shared variable exch_rate like exd_rate.
/*F040*/ define new shared variable change_db like mfc_logical.
/*F040*/ define new shared variable so_db like dc_name.
/*F040*/ define new shared variable ship_site like sod_site.
/*F040*/ define new shared variable ship_db like dc_name.
/*J0DV*/ define new shared variable ship_entity like en_entity.
/*F040*/ define new shared variable ship_so like so_nbr.
/*F040*/ define new shared variable ship_line like sod_line.
/*F040*/ define new shared variable new_site like so_site.
/*F040*/ define new shared variable new_db like so_db.
/*F040*/ define            variable err-flag as integer.
/*D887*/ define new shared variable lotref like sr_ref format "x(8)" no-undo.
/*D887*/ define new shared variable lotrf  like sr_ref format "x(8)" no-undo.
/*D858*/ define new shared variable transtype as character initial "ISS-SO".
/*F379*/ define            variable filllbl   as character
                                              initial  "已备料品出货:"
                                              format "x(15)".
/*F379*/ define            variable fillpk    as character
                                              initial  "  已捡料品出货:"
                                              format "x(15)".
/*GC96   define            variable msgnbr    as integer. */
/*G035*/ define new shared variable freight_ok like mfc_logical.
/*G035*/ define new shared variable old_ft_type like ft_type.
/*H049** define            variable calc_fr   like mfc_logical           */
/*H049**                                      label "Calculate Freight". */
/*H049*/ define new shared variable calc_fr   like mfc_logical
/*H049*/                                      label "计算运费".
/*G035*/ define            variable old_um    like fr_um.
/*GC96   define            variable sav_global_type like cmt_type. */
/*GC96*/ define new shared variable undo-select like mfc_logical no-undo.
/*H049*/ define new shared variable disp_fr   like mfc_logical
/*H049*/                                      label "显示重量".
/*FL52*/ define new shared variable qty_chg   like sod_qty_chg.
/*H447*/ define new shared variable gl_amt    like sod_fr_chg.
/*F0B4*/ define new shared variable accum_qty_all like sod_qty_all.
/*J04C*/ define new shared variable site_to         like sod_site.
/*J04C*/ define new shared variable loc_to          like sod_loc.

/*G0NX*/ define            variable batch_update  like mfc_logical
/*G0NX*/                                      label "自动批次出货".
/*G0NX*/ define new shared variable batch_id      like bcd_batch.
/*G0NX*/ define            variable batch_mfc     like mfc_logical.
/*G0NX*/ define            variable btemp_menu    like bcd_exec.
/*G0NX*/ define            variable btemp_mfguser as character.
/*G0NX*/ define new shared variable dev           as character
                                                  label "输出".
/*G0NX*/ define            variable batch_review  like mfc_logical.
/*G2MT*/ define            variable l_old_entity  like si_entity no-undo.
/*J29S*/ define            variable connect_db like dc_name.
/*J29S*/ define            variable db_undo like mfc_logical no-undo.

/*J053*         define buffer somstr for so_mstr. */
/*J053*         define buffer srwkfl for sr_wkfl. */
/*J205*/ define new shared variable new_line      like mfc_logical.

/*H1JB*/ define variable l_recalc like mfc_logical no-undo.

/*J1RN*/ {txcalvar.i}

/*J053*/ {mfsotrla.i "NEW"}

/*J053*/ /* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
/*J053*/ assign
/*J053*/   nontax_old = nontaxable_amt:format
/*J053*/   taxable_old = taxable_amt:format
/*J053*/   line_tot_old = line_total:format
/*J053*/   line_pst_old = line_pst:format
/*J053*/   disc_old     = disc_amt:format
/*J053*/   trl_amt_old = so_trl1_amt:format
/*J053*/   tax_amt_old = tax_amt:format
/*J053*/   tot_pst_old = total_pst:format
/*J053*/   tax_old     = tax[1]:format
/*J053*/   amt_old     = amt[1]:format
/*J053*/   ord_amt_old = ord_amt:format.

         /* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
/*J0DV*/ {gpglefv.i}

/*J0DV* /*H039*/ {gpglefdf.i} */


         /* INPUT OPTION FORM */
         form
/*F379*/    so_nbr         colon 12   label "订单"
/*G0JW* /*F379*/ filllbl   colon 24   no-label  */
/*G0JW*/    filllbl        at 24      no-label
/*F379*/    fill_all                  no-label space(3)
            so_cust
            ship_site
            eff_date       colon 12
/*G0JW* /*F379*/ fillpk    colon 24   no-label  */
/*G0JW*/    fillpk         at 24      no-label
/*F379*/    fill_pick                 no-label space(3)
            ad_name        no-label
         with frame a side-labels width 80.

/*GC96   MOVED FRAMES IN SOSOISD.P
*        /* LINE ITEM DISPLAY FORM */
*        form with frame b title color normal "Sales Order Line Items"
*        6 down width 80.

*        /*F017* RMA LINE ITEM DISPLAY FORM */
*        form with frame f title color normal "Returned Line Items"
*        6 down width 80.

*        /* LINE ITEM ENTRY FORM */
*        form
*           line           colon 13
*           cancel_bo
*           site           colon 54
*           location       colon 68  label "Loc"
*           lotserial_qty  colon 13
*           lotserial      colon 54
*           sod_part       colon 13
*           sod_um
*           lotref         colon 54
*           sod_desc       colon 13
*           multi_entry    colon 54
*        with frame c side-labels attr-space width 80.
 *GC96 END OF MOVED FRAMES */

/*G035*/ form
/*G035*/    so_fr_list       colon 26
/*G035*/    so_fr_min_wt     colon 26
/*G035*/    fr_um            no-label
/*G035*/    so_fr_terms      colon 26
/*G035*/    calc_fr          colon 26
/*H049*/    disp_fr          colon 26
/*G035*/ with frame d overlay side-labels centered row 7 width 50.

/*G0NX*/ /* Pop-up frame for batch update info */
/*G0NX*/ form
/*G0NX*/    batch_update colon 30
/*G0NX*/    dev          colon 30
/*G0NX*/    batch_id     colon 30
/*G0NX*/ with frame batr_up width 50 column 15 title color normal
/*G0NX*/ " 批次作业 "
/*G0NX*/ side-labels overlay.

/*F379*/ if  sorec  = fsrmarec then
/*F379*/     assign filllbl  = "          全收:"
/*F379*/            fillpk   = "".

/*F379*/ display filllbl
/*F379*/    fillpk
/*F379*/ with frame a.

         view frame a.

/*G035*/ find first gl_ctrl no-lock.
         find first soc_ctrl no-lock.
         eff_date = today.
/*F040*/ so_db = global_db.

/*G0NX*/ /* Initialize batch update */
/*G0NX*/ find first mfc_ctrl where mfc_field = "soc_is_batch" no-lock no-error.
/*G0NX*/ if available mfc_ctrl then do:

/*G0NX*/    assign
/*G0NX*/       batch_mfc    = true
/*G0NX*/       batch_update = mfc_logical.

/*G0NX*/    find first mfc_ctrl where mfc_field = "soc_is_dev"
/*G0NX*/       no-lock no-error.
/*G0NX*/    if available mfc_ctrl then dev = mfc_char.
/*G0NX*/    find first mfc_ctrl where mfc_field = "soc_is_batid"
/*G0NX*/       no-lock no-error.
/*G0NX*/    if available mfc_ctrl then batch_id = mfc_char.

/*G0NX*/ end.

         do transaction:
/*G292*
 *            fas_so_rec = string(true).      /*DEFAULT VALUE*/
 *            {mfctrl01.i mfc_ctrl fas_so_rec fas_so_rec false}
 *G292*/

/*G292*/    /* Added section */
/*J04R*     find mfc_ctrl exclusive where mfc_field = "fas_so_rec" no-error.  */
/*J04R*/    find mfc_ctrl exclusive-lock where mfc_field = "fas_so_rec"
/*J04R*/    no-error.
            if available mfc_ctrl then do:
/*J04R*        find first fac_ctrl exclusive no-error.     */
/*J04R*/       find first fac_ctrl exclusive-lock no-error.
               if available fac_ctrl then do:
                  fac_so_rec = mfc_logical.
                  delete mfc_ctrl.
               end.
               release fac_ctrl.
            end.

            find first fac_ctrl no-lock no-error.
            if available fac_ctrl then fas_so_rec = string(fac_so_rec).

/*G292*/ /* End of added section */

/*GC22*/ end.  /* transaction to find control file variables. */

         /***value to see if we should copy user fields***/
         copyusr = no.
         {mfctrl01.i   mfc_ctrl
                 so_copy_usr
                 cchar
                 no
                 no}
         if  cchar = "yes" then
             copyusr = yes.

/*GC22** end. **/
/*J053*/ oldcurr = "".

         /* DISPLAY */
         mainloop:
         repeat:
/*GM78*/    /*V8! hide all no-pause.
               if global-tool-bar and global-tool-bar-handle <> ? then
               view global-tool-bar-handle.
               view frame a. */

            do transaction:
               display eff_date
                  fill_all
/*F379*/                fill_pick   when (sorec <> fsrmarec)
               with frame a.

               prompt-for so_nbr
                  eff_date
                  fill_all
/*F379*/          fill_pick when (sorec <> fsrmarec)
                  ship_site
               with frame a editing:
                  if frame-field = "so_nbr" then do:
                     /* FIND NEXT/PREVIOUS RECORD */
                     /* IF WE'RE SHIPPING/RECEIVING RMA'S, NEXT/PREV ON RMA'S */
                     /* ONLY ELSE, NEXT/PREV ON SALES ORDERS.                 */
/*G1Y6*/             if sorec = fsrmarec or sorec = fsrmaship then do:
/*G1Y6*/                {mfnp05.i
                            so_mstr
                            so_fsm_type
                            "so_fsm_type = ""RMA"" "
                            so_nbr
                            "input so_nbr"}
/*G1Y6*/             end.
/*G1Y6*/             else do:
                       /* FIND NEXT/PREVIOUS RECORD - SO'S ONLY */
/*G1Y6*/                {mfnp05.i
                             so_mstr
                             so_fsm_type
                             "so_fsm_type = "" "" "
                             so_nbr
                             "input so_nbr"}
/*G1Y6*/             end.
/*G1Y6*                     {mfnp.i so_mstr so_nbr so_nbr so_nbr so_nbr so_nbr}   */
                     if recno <> ? then do:
                        display so_nbr so_cust with frame a.
                        find ad_mstr where ad_addr = so_cust no-lock no-error.
                        if available ad_mstr then display ad_name with frame a.
/*G035*/                if so_fr_list <> "" then calc_fr = yes.
/*G035*/                else calc_fr = no.
                     end.
                  end.
                  else do:
/*J04C*/             /* STATUS INPUT HERE WAS DESTROYING THE STATUS LINE */
/*J04C*                     status input.     */
                     readkey.
                     apply lastkey.
                  end.
               end.

               assign eff_date fill_all fill_pick ship_site.
               if eff_date = ? then eff_date = today.

/*H039*           {mfglef.i eff_date}                 */
/*J0DV* /*H039*/  {gpglef.i ""IC"" glentity eff_date} */

/*G035*/          old_ft_type = "".
/*FT56            find so_mstr using so_nbr no-error. */
/*FT56*/          find so_mstr using so_nbr exclusive-lock no-error no-wait.
/*FT56*/          if locked so_mstr then do:
/*FT56*/             {mfmsg.i 666 2}
/*FT56*/             /*sales order being modified. please wait*/
/*FT56*/             pause 5.
/*FT56*/             undo,retry.
/*FT56*/          end.

                 if not available so_mstr then do:
                    {mfmsg.i 609 3}  /* Sales order does not exist */
                    next-prompt so_nbr with frame a.
                    undo, retry.
                 end.
                 if so_conf_date = ? then do:
/*F504*/            {mfmsg.i 621 2}  /* warning: Sales Order not confirmed */
/*F504*             {mfmsg.i 621 3}  /* Sales Order not confirmed */ */
/*F504*             next-prompt so_nbr with frame a.                 */
/*F504*             undo, retry.                                     */
                 end.
/*F017*/         /* IF THIS IS AN RMA AND WE ARE SALES ORDER ONLY MODE, ERROR */
                 if  (can-find(rma_mstr where rma_nbr    = so_nbr
                             and   rma_prefix = prefix))
                 then do:
                    if  sorec = fssoship  then do:
                        {mfmsg.i 7190 3}
                        /* cannot process if only sales orders */
                        undo, retry.
                    end.
                 end.
                 else do:
                    if  sorec = fsrmaship  or
                        sorec = fsrmaall   or
                        sorec = fsrmarec
                    then do:
                        {mfmsg.i 7191 3} /* this is not an rma */
                        undo, retry.
                    end.
                 end.

/*J04C*          ADDED THE FOLLOWING */
                 /* DO NOT LET USERS SHIP SEO'S OR CALL ACTIVITY */
                 /* RECORDING ORDERS IN SOSOIS.P... */
                 if so_fsm_type = "SEO" then do:
                    {mfmsg.i 1052 3}
                    /* SERVICE ENGINEER ORDERS ARE NOT SHIPPED HERE */
                    undo, retry.
                 end.   /* if so_fsm_type = "SEO" */
                 else if so_fsm_type = "FSM-RO"        then do:
                    {mfmsg.i 1058 3}
                    /* USE CALL ACTIVITY RECORDING FOR THIS ORDER */
                    undo, retry.
                 end.   /* if so_fsm_type = "FSM-RO" */
/*J04C*          END ADDED CODE */
/*J1D8*          ADDED THE FOLLOWING */
                 else if so_fsm_type = "SC" then do:
                    {mfmsg.i 5103 3}    /* INVALID ORDER TYPE */
                    undo, retry.
                 end.
/*J1D8*          END ADDED CODE */

                 /* FIND EXCH RATE IF CURRENCY NOT BASE */
                 if base_curr <> so_curr then do:
/*F029*/            if so_fix_rate = no then do:
/*G484*/               {gpgtex5.i &ent_curr = base_curr
                          &curr = so_curr
                          &date = eff_date
                          &exch_from = exd_rate
                          &exch_to = exch_rate}
/*G484**               find last exd_det where exd_curr = so_curr and
**G484**               exd_eff_date <= eff_date and
**G484**               exd_end_date >= eff_date
**G484**               no-lock no-error.
**G484**               if not available exd_det then do:
**G484**                  {mfmsg.i 81 3}  /* Exchange rate does not exist */
**G484**                  undo, retry.
**G484**               end.
**G484**               else exch_rate = exd_rate.
**G484*/
/*F029*/            end.
/*F029*/            else exch_rate = so_ex_rate.
                 end.
                 else exch_rate = 1.0.

/*J0ZZ******************** REPLACE WITH GPCURMTH.I ***************************
** /*J053*/         if (oldcurr <> so_curr) then do:
** /*J053* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE        */
** /*J053*/            if (gl_base_curr <> so_curr) then do:
** /*J053*/               find first ex_mstr where ex_curr = so_curr
** /*J053*/                  no-lock no-error.
** /*J053*/               if not available ex_mstr then do:
** /*J053*                   CURRENCY EXCHANGE MASTER DOES NOT EXIST       */
** /*J053*/                 {mfmsg.i 964 3}
** /*J053*/                 undo, retry.
** /*J053*/               end.
** /*J053*/               rndmthd = ex_rnd_mthd.
** /*J053*/            end.
** /*J053*/            else rndmthd = gl_rnd_mthd.
**J0ZZ**********************************************************************/

/*J0ZZ*/         if (oldcurr <> so_curr) or (oldcurr = "")
/*J0ZZ*/         then do:
/*J0ZZ*/            {gpcurmth.i
             "so_curr"
             "3"
             "undo, retry"
             "pause 0" }

/*J053*/            {socurfmt.i}
/*J053*/            oldcurr = so_curr.
/*J053*/         end. /* IF OLDCURR <> SO_CURR */

/*H222*/         find ad_mstr where ad_addr = so_cust  no-lock.

                 display so_cust ad_name with frame a.
/*G035*/         if so_fr_list <> "" then calc_fr = yes.
/*G035*/         else calc_fr = no.
/*G035*/         find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
/*G035*/         if available ft_mstr then old_ft_type = ft_type.

/*G0NX*/         /* Check to see if batch update exists */

/*J29S*/         run check-batch.

/*J29S*/         if available qad_wkfl and
/*J29S*/            not batch_review then undo, retry.

/*J29S** BEGIN DELETED SECTION MOVED TO INTERNAL PROCEDURE check-batch  ******
 *J29S** DONE TO REDUCE ACTION SEGMENT SIZE                             ******
 *               find qad_wkfl where qad_key1 = "sosois.p" + so_nbr
 *                               and qad_key2 = "BATCH"
 *                             no-lock no-error.
 *               if available qad_wkfl then do:
 *                  batch_review = no.
 *                  if qad_charfld[4] <> "" then
 *                     find lngd_det where lngd_dataset = "bcd_det"
 *                                     and lngd_field   = "bcd_run_stat"
 *                                     and lngd_key1    = qad_charfld[4]
 *                                     and lngd_lang    = global_user_lang
 *                                   no-lock no-error.
 *                  if available lngd_det and qad_charfld[4] = "3" then do:
 *                     /* ERROR: Batch shipment already exists with status: */
 *                     {mfmsg02.i 1122 3 lngd_translation}
 *                     undo, retry.
 *                  end.
 *                  else if available lngd_det
 *                  then do:
 *                     /* WARNING: Batch shipment already exists with status: */
 *                     {mfmsg02.i 1122 2 lngd_translation}
 *                  end.
 *                  else do:
 *                     /* Batch shipment already exists */
 *                     {mfmsg.i 1121 2}
 *                  end.
 *
 *                  {mfmsg01.i 9000 1 batch_review}  /* Continue? */
 *                  if not batch_review then undo, retry.
 *
 *                  /* Set mfguser to match batch file */
 *                  /* along with ship_site?           */
 *                  assign
 *                     btemp_mfguser = mfguser
 *                     mfguser       = "sosois.p" + so_nbr
 *                     ship_site     = qad_charfld[2]
 *                     ship_db       = qad_charfld[3]
 *                     .
 *
 *                  batch_review = true.
 *
 *               end.  /* Batch shipment check */
 *               else
 *                  batch_review = false.
 *J29S*** END DELETED SECTION ******************************************/
/*G0NX*/         /* End added code */

/*J22N*/     if so_stat <> "" then do:
/*J22N*/        /* SALES ORDER STATUS NOT BLANK */
/*J22N*/        {mfmsg.i 623 2}
/*J22N*/         end. /* IF SO_STAT <> "" */

/*H222*/         find cm_mstr where cm_addr = so_bill  no-lock.
/*F726*/         if cm_cr_hold then do:
/*F726*/            {mfmsg.i 614 2}  /* warning: Customer on credit hold */
/*FQ08*/            if not batchrun then pause.
/*F726*/         end.

                 if so_invoiced = yes then do:
                    {mfmsg.i 603 2} /* Invoice printed but not posted */
/*FQ08*/            if not batchrun then pause.
                 end.

/*F040*/         /* Determine the ship-from database */
                 if ship_site = "" then do:
                    /* If this is the only database, use it */
                    if not can-find(first dc_mstr)
                    or not can-find(first sod_det where sod_nbr = so_nbr)
                    then do:
                       ship_db = global_db.
                    end.
                    else do:
                       /* Take the database from the first line */
                       find first sod_det where sod_nbr = so_nbr no-lock.
/*J034*                find si_mstr where si_site = sod_site no-lock.  */
/*J034*/               find si_mstr where si_site = sod_site no-lock no-error.
/*J034*/               if not available si_mstr then
/*J034*/                  ship_db = global_db.
/*J034*/               else do:
/*J034*/                  ship_db = si_db.
                       /* Check to see if SO affects other databases */
                       /* (If so, the user must pick one)            */
                          for each sod_det where sod_nbr  =  so_nbr
                               and sod_site <> si_site
                               and sod_confirm
                          no-lock:
/*J034*                     find si_mstr where si_site = sod_site no-lock. */
/*J034*                     if si_db <> ship_db then do:                   */
/*J034*/                      find si_mstr where si_site = sod_site
                               no-lock no-error.
/*J034*/                     if available si_mstr and si_db <> ship_db then do:
                                {mfmsg.i 2511 4}
                                /* SO spans databases, site must be specified */
                                display si_site @ ship_site with frame a.
                                undo mainloop, retry.
                             end.
                          end.  /* FOR EACH SOD_DET */
                       end.   /* ELSE DO - IF NOT AVAIL SI_MSTR */
                    end.   /* ELSE DO - TAKE DATABASE FROM FIRST LINE */
/*J0DV*/            ship_entity = "".

/*G2MT*/         /* PERFORM GL CALENDER VALIDATION WHEN ship_site IS BLANK
                    AND "Ship Allocated" OR "Ship Picked" IS YES. */

/*G2NY** /*G2MT*/   if input fill_all = yes or input fill_pick = yes */
/*G2NY*/            if fill_all = yes or fill_pick = yes
/*G2MT*/        then do:
/*G2MT*/              l_old_entity = "".
/*G2MT*/              for each sod_det no-lock where
/*G2MT*/               sod_nbr = so_nbr and
/*G2MT*/                   sod_confirm break by sod_site:
/*G2MT*/                if first-of(sod_site)
/*G2MT*/        then do:
/*G2MT*/                   find si_mstr where si_site = sod_site no-lock.
/*G2MT*/                   if l_old_entity <> si_entity
/*G2MT*/                   then do:
/*G2MT*/                      l_old_entity = si_entity.

/*G2MT*/                      {gpglef3.i &from_db = so_db
                                         &to_db   = si_db
                                         &module  = ""IC""
                                         &entity  = si_entity
                                         &date    = eff_date
                                         &prompt  = "eff_date"
                                         &frame   = "a"
                                         &loop    = "mainloop"}

/*G2MT*/                   end. /* IF L_OLD_ENTITY <> SI_ENTITY */
/*G2MT*/                end. /* IF FIRST-OF(SOD_SITE) */
/*G2MT*/              end. /* FOR EACH sod_det */
/*G2MT*/            end. /* IF INPUT FILL_ALL = YES OR INPUT FILL_PICK = YES */
                 end.  /* IF SHIP-SITE = "" */
                 else do:
                    find si_mstr where si_site = ship_site no-lock no-error.
                    if not available si_mstr then do:
                       {mfmsg.i 708 3}  /* Site does not exist */
/*FL52*/               next-prompt ship_site with frame a.
                       undo, retry.
                    end.
                    ship_db = si_db.
/*J0DV*/            ship_entity = si_entity.
                 end.

/*J034*/       if ship_site <> "" and available si_mstr then do:
/*J034*/          {gprun.i ""gpsiver.p""
                  "(input si_site, input recid(si_mstr), output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}
                     /* USER DOES NOT HAVE ACCESS TO THIS SITE */
/*J034*/             next-prompt ship_site with frame a.
/*J034*/             undo, retry.
/*J034*/          end.
/*J034*/       end.

                 /* MAKE SURE SHIP-FROM DATABASE IS CONNECTED */
/*J0DV*/         /* (MOVED HERE FROM BELOW FREIGHT POPUP)     */
/*J0DV*/         if global_db <> "" and not connected(ship_db) then do:
/*J0DV*/            /* DATABASE NOT AVAILABLE */
/*J0DV*/            {mfmsg03.i 2510 3 ship_db """" """"}
/*J0DV*/            next-prompt ship_site with frame a.
/*J0DV*/            undo mainloop, retry.
/*J0DV*/         end.

/*J0DV*/         /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY AND
/*J0DV*/          * DATABASE. WE ONLY NEED TO DO THIS IF THE SITE FIELD
/*J0DV*/          * WAS ENTERED, BECAUSE OTHERWISE WE DON'T KNOW WHICH
/*J0DV*/          * ENTITY TO VALIDATE YET. THIS IS OK BECAUSE THE LINE
/*J0DV*/          * ITEMS WILL ALSO BE VALIDATED. */

/*J0DV*/         if ship_entity <> "" then do:

                    /* VALIDATE GL PERIOD FOR SPECIFIED ENTITY/DATABASE */
/*J0DV*/            {gpglef3.i &from_db = so_db
                               &to_db   = ship_db
                               &module  = ""IC""
                               &entity  = ship_entity
                               &date    = eff_date
                               &prompt  = "eff_date"
                               &frame   = "a"
                               &loop    = "mainloop"}

/*J0DV*/         end. /* IF SHIP_ENTITY <> "" */

/*G035*/         /* BEGIN BLOCK */
                 /* FREIGHT LIST, MIN SHIP WEIGHT & FREIGHT TERMS PARAMETERS */
                 if calc_fr then do:
                    if so_fr_list <> "" then do:
                       find fr_mstr where fr_list = so_fr_list and
                       fr_site = so_site and fr_curr = so_curr no-lock no-error.
                       if not available fr_mstr then
                          find fr_mstr where fr_list = so_fr_list and
                          fr_site = so_site and fr_curr = gl_base_curr
                          no-lock no-error.

/*H049*/               disp_fr = yes.
/*H049*                display so_fr_list so_fr_min_wt so_fr_terms calc_fr
                       with frame d. *H049*/
/*H049*/               display so_fr_list so_fr_min_wt so_fr_terms
/*H049*/               calc_fr  disp_fr with frame d.

                    end.

                    old_um = "".
                    if available fr_mstr then do:
                       display fr_um with frame d.
                       old_um = fr_um.
                    end.

                    set_d:
                    do on error undo, retry:

/*H049*/               /* set so_fr_min_wt so_fr_terms calc_fr with frame d. */
/*H049*/              set so_fr_min_wt so_fr_terms calc_fr disp_fr with frame d.

                       if so_fr_list <> "" or (so_fr_list = ""
                       and calc_fr) then do:
                          find fr_mstr where fr_list = so_fr_list and
                          fr_site = so_site and fr_curr = so_curr
                          no-lock no-error.
                          if not available fr_mstr then
                          find fr_mstr where fr_list = so_fr_list and
                          fr_site = so_site and fr_curr = gl_base_curr
                          no-lock no-error.
                          if not available fr_mstr then do:
                        /* WARN: FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
                             {mfmsg03.i 670 2 so_fr_list so_site so_curr}
                            /* Lines may be ok. No lines added, so no default.*/
/*FQ08*/                     if not batchrun then pause.
                          end.
                          display fr_um with frame d.
                          if old_um <> fr_um then do:
                             {mfmsg.i 675 2}
                             /* WARNING: UNIT OF MEASURE HAS CHANGED */
/*FQ08*/                     if not batchrun then pause.
                          end.

                       end.

                       if so_fr_terms <> "" or (so_fr_terms = ""
                       and calc_fr) then do:
                          find ft_mstr where ft_terms = so_fr_terms
                          no-lock no-error.
                          if not available ft_mstr then do:
                             /* INVALID FREIGHT TERMS */
                             {mfmsg03.i 671 3 so_fr_terms """" """"}
                             next-prompt so_fr_terms with frame d.
                             undo set_d, retry.
                          end.
                       end.

                       hide frame d no-pause.

                    end.
                 end.

/*G035*/         /* END BLOCK */

/*J0DV* *MOVE CODE TO ABOVE FREIGHT POPUP********************************
/*F040*/         /* Make sure ship-from database is connected */
 *               if global_db <> "" and not connected(ship_db) then do:
 *                  {mfmsg03.i 2510 3 ship_db """" """"}
 *                  /* Database not available */
 *                  undo, retry.
 *               end.
 *J0DV* *END MOVED CODE**************************************************/

                 ship_so = so_nbr.

/*G0NX*/         /* Update batch shipment information if batch in use */
                 /* (unless an existing batch job is already queued)  */

/*J29S*/         run update-batch.

/*J29S** BEGIN DELETED SECTION MOVED TO INTERNAL PROCEDURE update-batch ******
 *J29S** DONE TO REDUCE ACTION SEGMENT SIZE                             ******
 *               find first mfc_ctrl where mfc_field = "soc_is_batch"
 *                  no-lock no-error.
 *               if available mfc_ctrl and mfc_logical = yes
 *                  and not (available qad_wkfl and qad_charfld[4] = "") then
 *               bat_loop:
 *               do with frame batr_up on error undo, retry:
 *
 *                  update batch_update.
 *
 *                  if batch_update then do with frame batr_up:
 *
 *                     update dev batch_id.
 *
 *                     if dev = "" then do:
 *                       {mfmsg.i 9501 3}
 *                       next-prompt dev.
 *                       undo bat_loop, retry.
 *                     end.
 *
 *                     if batch_id = "" then do:
 *                     {mfmsg.i 67 3}  /* Batch control record does not exist */
 *                       next-prompt batch_id.
 *                       undo bat_loop, retry.
 *                     end.
 *
 *                     if not can-find(bc_mstr where bc_batch = batch_id)
 *                     then do:
 *                      {mfmsg.i 67 3} /* Batch control record does not exist */
 *                       next-prompt batch_id.
 *                       undo bat_loop, retry.
 *                     end.
 *
 *                     if (dev = "terminal" or dev = "/dev/tty"
 *                         or dev = "tt:") then do:
 *                       {mfmsg.i 66 3}
 *                       /* Output to terminal not allowed for batch request */
 *                       next-prompt dev.
 *                       undo bat_loop, retry.
 *                     end.
 *                  end.
 *
 *                  /* Assign a unique userid for the shipping workfile */
 *                   assign
 *                     btemp_mfguser = mfguser
 *                     mfguser       = "sosois.p" + so_nbr .
 *
 *                  hide frame batr_up.
 *
 *               end.
 *J29S*** END DELETED SECTION ******************************************/
/*G0NX*/         /* End added code for batch processing */
              end.  /* SO number input transaction */

              do transaction:
/*J04R*          {mfnctrl.i woc_ctrl woc_lot wo_mstr wo_lot trlot} */
/*J29S* /*J04R*/ {mfnxtsq.i wo_mstr wo_lot woc_sq01 trlot} */
/*J29S*/         /* Switch databases to get next trlot based on remote */
/*J29S*/         /* work order master for shipping transaction if necessary */
/*J29S*/         change_db = (ship_db <> global_db).
/*J29S*/         if change_db then do:
/*J29S*/            {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
/*J29S*/
/*J29S*/            assign connect_db = ship_db
/*J29S*/                   db_undo = no.
/*J29S*/            run check-db-connect
/*J29S*/                (input connect_db, input-output db_undo).
/*J29S*/            if db_undo then undo mainloop, retry mainloop.
/*J29S*/            /* RETRIEVE FAC CONTROL FILE SETTINGS FROM REMOTE DB */
/*J29S*/            {gprun.i ""sofactrl.p"" "(output fas_so_rec)"}
/*J29S*/         end.
/*J29S*/
/*J29S*/         {gprun.i ""gpnxtsq.p"" "(output trlot)"}
/*J29S*/
/*J29S*/         if change_db then do:
/*J29S*/            {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*J29S*/
/*J29S*/            assign connect_db = so_db
/*J29S*/                   db_undo = no.
/*J29S*/            run check-db-connect
/*J29S*/                (input connect_db, input-output db_undo).
/*J29S*/            if db_undo then undo mainloop, retry mainloop.
/*J29S*/         end.
              end.

/*GN90* /*FR31*/ for each sr_wkfl where sr_userid = mfguser:*/
/*G0NX*/      if not batch_review then
/*GN90*/      for each sr_wkfl exclusive-lock where sr_userid = mfguser:
                 delete sr_wkfl.
              end.

              /* Switch databases to find allocations if necessary */
              change_db = (ship_db <> global_db).
              if change_db then do:
                 {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }

/*J29S*/         assign connect_db = ship_db
/*J29S*/                db_undo = no.
/*J29S*/         run check-db-connect
/*J29S*/             (input connect_db, input-output db_undo).
/*J29S*/         if db_undo then undo mainloop, retry mainloop.

/*FL52*/         {gprun.i ""sosoiss3.p""} /* Delete sr_wkfl in remote db */

/*J0ZX*/         {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

/*J29S*/         assign connect_db = so_db
/*J29S*/                db_undo = no.
/*J29S*/         run check-db-connect
/*J29S*/             (input connect_db, input-output db_undo).
/*J29S*/         if db_undo then undo mainloop, retry mainloop.
              end.

/*F0F0 /*F0B4*/      accum_qty_all = 0. */

        /* CHECK FOR EXISTING ALLOCATIONS AND RESET BACKORDER CHANGE QUANTITY */
/*G818*/       /* (Get all lines to reset the change quantities) */
/*G0NX*/       if not batch_review then
               for   each sod_det where sod_nbr = so_nbr
/*G818**                and (sod_site = ship_site or ship_site = "") **/
/*F0B4         exclusive: */
/*F0B4*/       exclusive-lock
/*F0B4*/       break by sod_site by sod_loc by sod_serial by sod_part:

                  sod_qty_chg = 0.
                  sod_bo_chg = 0.

/*F0F0*/          if first-of(sod_part) then
/*F0F0*/             accum_qty_all = 0.

/*G818*/          if not (sod_site = ship_site or ship_site = "") then next.

/*F017*           Consider skipping this record based on something */
                  if  (sorec = fsrmarec    and sod_rma_type  <> "I")
                  or (sorec = fsrmaship   and sod_rma_type  <> "O")
                  or (sorec = fssormaship and sod_rma_type  =  "I")
/*G1Y6*/          or (sorec = fssoship    and sod_fsm_type  <> "")
                  then next.

/*F040*/          ship_line = sod_line.

                  /* Check for allocations if shipping based on allocations */
                  if fill_all or fill_pick then do:
/*F0B4*/             accum_qty_all = accum_qty_all + sod_qty_all.
/*J0ZX*/             {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }

/*J29S*/             assign connect_db = ship_db
/*J29S*/                    db_undo = no.
/*J29S*/             run check-db-connect
/*J29S*/                 (input connect_db, input-output db_undo).
/*J29S*/             if db_undo then undo mainloop, retry mainloop.

                     {gprun.i ""sosoisu1.p""}

/*J0ZX*/             {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

/*J29S*/             assign connect_db = so_db
/*J29S*/                    db_undo = no.
/*J29S*/             run check-db-connect
/*J29S*/                 (input connect_db, input-output db_undo).
/*J29S*/             if db_undo then undo mainloop, retry mainloop.

/*FL52*/             if change_db then sod_qty_chg = qty_chg.
/*F0F0 /*F0B4*/      if last-of(sod_part) then */
/*F0F0 /*F0B4*/         accum_qty_all = 0. */
                  end.

/*GD76*/          /* Stop setting To Ship to zero.                            */
/*GD76*           if can-find (first sob_det where sob_nbr  = sod_nbr         */
/*GD76*                               and sob_line = sod_line)                */
/*GD76*                             and sod_fa_nbr = "" then sod_qty_chg = 0. */

/*F732*           if sod_type = "" then                                    */
/*F732*              sod_bo_chg = sod_qty_ord - sod_qty_ship - sod_qty_chg. */
/*F732*           else                                                     */
/*F732*              sod_bo_chg = sod_qty_ord - sod_qty_ship.               */

/*F732*/          if sod_qty_ord >= 0 then
/*F732*/             sod_bo_chg =
/*F732*/                MAX((sod_qty_ord - sod_qty_ship - sod_qty_chg),0).
/*F732*/          else
/*F732*/             sod_bo_chg =
/*F732*/                MIN((sod_qty_ord - sod_qty_ship - sod_qty_chg),0).

               end. /*for each sod_det*/

               if change_db then do:
                  {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

/*J29S*/          assign connect_db = so_db
/*J29S*/                 db_undo = no.
/*J29S*/          run check-db-connect
/*J29S*/              (input connect_db, input-output db_undo).
/*J29S*/          if db_undo then undo mainloop, retry mainloop.
               end.

/*GC96*/       so_mstr_recid = recid(so_mstr).
/*GC96*/       undo-select = true.

/*J29W*/       release sod_det.

               /* SELECT LINES AND QUANTITES FOR SHIPMENT */
/*GC96*/       {gprun.i ""sosoisd.p""}

/*G0BM*        ADDED THE FOLLOWING TO RESET SOD_QTY_CHG, SOD_BO_CHG  */
/*G0BM*        TO ZERO IF THE USER ABORTED OUT OF SOSOISD.P          */
               if undo-select then do:
                   for each sod_det where sod_nbr = so_nbr exclusive-lock:
                       assign sod_qty_chg = 0
                              sod_bo_chg = 0.
                   end.
               end.
/*G0BM*        END ADDED CODE */

/*GC96*/       if undo-select then undo mainloop, retry mainloop.

/*GC96         /* MOVED FOLLOWING CODE TO SOSOISD.P */
*              line = 1.
*
*              loop0:
*              repeat transaction:
*                 /* DISPLAY DETAIL */
*                 repeat:
*                 clear frame b all no-pause.
*                 clear frame c all no-pause.
**F017*           clear frame f all no-pause.
*
*
**F017*           if sorec = fsrmarec then
**F017*              view frame f.
**F017*           else
*                    view frame b.
*
*                 view frame c.
*
*                 if not can-find(first sod_det where sod_nbr = so_nbr) then do:
*                    {mfmsg.i 611 2}  /* Order has no line items */
*                    leave.
*                 end.
*
*                 /* Display order detail */
*                 for each sod_det where sod_nbr = so_nbr
*                           and sod_line >= line
**F040*                     and (sod_site = ship_site or ship_site = "")
*                 by sod_line:
*
* /*F017*/        /* Consider skipping this record based on something */
*                 if  (sorec = fsrmarec    and sod_rma_type  <> "I")
*                 or (sorec = fsrmaship   and sod_rma_type  <> "O")
*                 or (sorec = fssormaship and sod_rma_type  =  "I")
*                 then next.
*
*                 /* Use different display if receiving against an RMA */
*
*                 if  sorec = fsrmarec then do:
*                     display
*                        sod_line
*                        sod_part
*                        sod_type
*                        (sod_qty_ord * -1.0)  format "->>>>>>9.9<<<<<<"
*                                              label "Expected"
*                        sod_qty_chg           format "->>>>>>9.9<<<<<<"
*                                              label "To Receive"
*                        (sod_qty_ship * -1.0) format "->>>>>>9.9<<<<<<"
*                                              label "Received"
*                        sod_site
*                     with frame f.
*                     if frame-line(f) = frame-down(f) then leave.
*                     down 1 with frame f.
*                 end. /* if fsrmarec */
*                 else do:
*                    display
*                       sod_line
*                       sod_part
*                       sod_type
*                       sod_qty_all   format "->>>>>>9.9<<<<<<"
*                          label "Allocated"
*                       sod_qty_pick  format "->>>>>>9.9<<<<<<"
*                          label "Picked"
*                       sod_qty_chg   format "->>>>>>9.9<<<<<<"
*                          label "To Ship"
*                       sod_bo_chg    format "->>>>>>9.9<<<<<<"
*                          label "Backorder"
*                       sod_site
*                    with frame b.
*                    if frame-line(b) = frame-down(b) then leave.
*                    down 1 with frame b.
*                 end. /* if not fsrmarec */
*
*              end.  /* Display order detail */
*
*              line = 0.
*
*              do on error undo, retry:
*                 input clear.
*
*                 cancel_bo = no.
*                 update line cancel_bo with frame c width 80 editing:
*                    if frame-field = "line" then do:
*                      {mfnp01.i sod_det line sod_line sod_nbr so_nbr sod_nbrln}
*                       if recno <> ? then do:
*                          line = sod_line.
*                          find pt_mstr where pt_part = sod_part
*                          no-lock no-error.
*                          display line sod_part sod_desc sod_um
*                          with frame c.
*
*                          if available pt_mstr then
*                             display pt_desc1 @ sod_desc with frame c.
*                       end.
*                    end.
*                    else do:
*                       status input.
*                       readkey.
*                       apply lastkey.
*                    end.
*                 end.
*                 status input.
*
*                 if line = 0 then leave.
*
*                 find sod_det where sod_nbr = so_nbr
*                 and sod_line = line no-error.
*                 if not available sod_det then do:
*                    {mfmsg.i 45 3}  /* Line item does not exist */
*                    undo, retry.
*                 end.
**F504*           if not sod_confirm then do:
**F504*              {mfmsg.i 646 3}
**F504*              /* Sales order line has not been confirmed */
**F504*              undo, retry.
**F504*           end.
*
**F379*           msgnbr = 0.
**F379*           if  sorec         = fsrmarec   and
**F379*           sod_rma_type <> "I"
**F379*           then do:
**F379*              msgnbr = 7228.  /* cannot process issues */
**F379*           end.
*
**F379*           if (sorec = fsrmaship     or
**F379*              sorec = fssoship      or
**F379*              sorec = fssormaship) and
**F379*              sod_rma_type = "I"
**F379*           then do:
**F379*              msgnbr = 7227.  /* cannot process returns */
**F379*           end.
*
**F379*           if  msgnbr <> 0 then do:
**F379*               {mfmsg.i msgnbr 3}
**F379*               undo, retry.
**F379*           end.
*
*                 display line sod_part sod_desc sod_um with frame c.
*                 find pt_mstr where pt_part = sod_part no-lock no-error.
*                 if available pt_mstr then display pt_desc1 @ sod_desc
*                 with frame c.
*
*                 lotserial_control = "".
**F209*           /* Don't bother with Item Master for Memo items */
**F732*           if sod_type <> "M" then do: *
**F732*           if sod_type = "" then do:
*                    find pt_mstr where pt_part = sod_part no-lock no-error.
*                    if not available pt_mstr then do:
*                       {mfmsg.i 16 2} /* WARNING - ITEM NOT IN INVENTORY */
*                    end.
*                 end.
*              end.
*
*              if available pt_mstr then lotserial_control = pt_lot_ser.
*              else lotserial_control = "".
*
*              assign
*                 site                = ""
*                 location            = ""
*                 lotserial           = ""
**G302*           lotref              = ""
*                 lotserial_qty       = sod_qty_chg
*                 cline               = string(line)
*                 global_part         = sod_part
*                 trans_um            = sod_um
*                 trans_conv          = sod_um_conv
*                 multi_entry         = no
*                 sod_qty_chg         = 0
*                 total_lotserial_qty = 0 .
*
*              i = 0.
*              for each sr_wkfl no-lock where sr_userid = mfguser
*              and sr_lineid = cline:
*                 i = i + 1.
*                 if i > 1 then multi_entry = yes.
*                 sod_qty_chg = sod_qty_chg + sr_qty.
*              end.
*              if i = 0 then do:
*                 site = sod_site.
*                 location = sod_loc.
*              end.
*              else
*              if i = 1 then do:
*                 find first sr_wkfl where sr_userid = mfguser
*                 and sr_lineid = cline no-lock.
*                 site = sr_site.
*                 location = sr_loc.
*                 lotserial = sr_lotser.
**G302*           lotref    = sr_ref.
*              end.
*
**G451*        setlot:
*              do on error undo, retry on endkey undo, leave:
**D887*           update lotserial_qty site location lotserial lotref
**F732*           multi_entry when sod_type <> "M" *
**F732*           multi_entry when sod_type = ""
*                 with frame c editing:
*                    global_site = input site.
*                    global_loc  = input location.
**D953*              global_lot  = input lotserial.
*                    readkey.
*                    apply lastkey.
*                 end.
*
*                 /* If specified site is not defined ship-from site, */
*                 /* make sure it's in the same database              */
*                 if site <> ship_site then do:
*                    find si_mstr where si_site = sod_site no-lock.
*                    if si_db <> ship_db then do:
*                       {mfmsg.i 2512 3}
*                       /* All ship-from sites must be in same db */
*                       next-prompt site with frame c.
*                       undo, retry.
*                    end.
*                 end.
*
*                 i = 0.
*                 for each sr_wkfl no-lock where sr_userid = mfguser
*                 and sr_lineid = cline:
*                    i = i + 1.
*                    if i > 1 then do:
*                       multi_entry = yes.
*                       leave.
*                    end.
*                 end.
*
*                 total_lotserial_qty = sod_qty_chg.
*
*                 change_db = (ship_db <> global_db).
*                 if (global_db <> "" and ship_db <> global_db) then do:
*                    {gprun.i ""gpalias2.p"" "(sod_site, output err-flag)" }
*                 end.
*
*                 sod_recno = recid(sod_det). /*GA39*/
*
*                 /* Build sr_wkfl, which holds shipped-from locations */
**G451*           undo-all = yes.
*                 if multi_entry then do:
*                    /* Prompt for multiple locations */
**G451*              sav_global_type = global_type.
**G451*              global_type = "shipundo".
**F190*              {gprun.i ""icsrup.p"" "(sod_site)"}
**G451*              if global_type = "shipok" then undo-all = no.
**G451*              global_type = sav_global_type.
*                 end.
*                 else do:
*                    /* Validate location */
*                    {gprun.i ""sosoisu2.p""}
*                 end.
**G451*           if undo-all then undo setlot, retry.
*
**F805*         /* WARN USER IF SHIPMENT ADJUSTMENT EXCEEDS ORIGINAL SHIPMENT */
**F805*           if (sod_qty_ord > 0 and total_lotserial_qty < 0 and
**F805*           sod_qty_ship < (total_lotserial_qty * -1))
**F805*           or (sod_qty_ord < 0 and total_lotserial_qty > 0 and
**F805*           (sod_qty_ship * -1) < total_lotserial_qty)
**F805*           then do:
**GB82*              if sod_fsm_type <> "RMA-RCT" then do:
**F805*                 /* Reversal qty exceeds original qty shipped */
**F805*                 {mfmsg02.i 812 2 sod_qty_ship}
**GB82*              end.
**F805*           end.
*
*                 /* WARN USER IF OVERSHIPPING */
*                 if sod_qty_ord * ( sod_qty_ord -
*                 (sod_qty_ship + total_lotserial_qty) ) < 0 then do:
*                    {mfmsg.i 622 2} /* Qty shiped > Qty Ordered */
*                 end.
*
*              end.
*
*              sod_qty_chg = total_lotserial_qty.
*              if cancel_bo then
*                 sod_bo_chg = 0.
*              else
**GC18*        /***********************************************/
**GC18*        /*  RMA quantites in sod_qty_chg are stored as */
**GC18*        /*  positive even though it is negative. Why?  */
**GC18*        /*  because I would have to do many + - +      */
**GC18*        /*  conversions throughout the code to handle  */
**GC18*        /*  RMA receipts because receipts are dislayed */
**GC18*        /*  as positive.  This will have to do for now */
**GC18*        /***********************************************/
**GC18*        if sod_fsm_type = "RMA-RCT" then
**GC18*           sod_bo_chg = sod_qty_ord - sod_qty_ship + sod_qty_chg.
**GC18*        else
*                 sod_bo_chg = sod_qty_ord - sod_qty_ship - sod_qty_chg.
*
*              if can-find (first sob_det where sob_nbr    = sod_nbr
*                                           and sob_line   = sod_line)
*                                           and sod_fa_nbr = ""
**G451*                                     and not undo-all
**G702*                                     and sod_type   = ""
*                                           and sod_lot    = "" then do:
*                 repeat:
*                    undo-all = no.
*                    mod_iss = ?.
*                    repeat with frame e row 16 column 21 side-labels
*                    1 down overlay:
*                       display yes @ mod_iss.
*                       set mod_iss.
*                       leave.
*                    end.
*                    hide frame e.
*                    if mod_iss <> yes then leave.
*                    hide frame c.
**F017*              hide frame f.
*                    hide frame b.
*                    sod_recno = recid(sod_det).
*                    {gprun.i ""soise01.p""}
**F017*              if sorec = fsrmarec then
**F017*                 view frame f.
**F017*              else
*                       view frame b.
*
*                    view frame c.
*                    pause 0.
*                    if undo-all = no then leave.
*                 end.
*                 if mod_iss <> yes then do:
*                    for each sr_wkfl where sr_userid = mfguser
*                    and sr_lineid begins string(sod_line) + "ISS":
*                       delete sr_wkfl.
*                    end.
*                 end.
*              end.
*
**GC74         /* ADDED FOLLOWING SECTION*/
*              if sod_sched then do:
*                 define variable newprice as dec.
*                 /* SET CURRENT PRICE */
*                 {gprun.i ""rcpccal.p"" "(input sod_part, input sod_pr_list,
*                input eff_date, input sod_um, input so_curr, output newprice)"}
*
*                 if newprice <> ? then sod_price = newprice.
*
*                 sod_list_pr = sod_price.
*              end.
**GC74         /* END SECTION*/
*           end.
*
**F379*     if  sorec = fsrmarec  then
**F379*         msgnbr = 7229.
**F379*     else
**F379*         msgnbr = 618.
*
*           /* Display Shipment information for user review */
*           do on endkey undo mainloop, retry mainloop:
*              yn = yes.
**F379*        {mfmsg01.i msgnbr 1 yn}
*              /* Display sales order lines being shipped? */
*              if yn = yes then do:
*                 hide frame b no-pause.
**F017*           hide frame f no-pause.
*                 hide frame c no-pause.
*
*                 /* Switch to the shipping db to display the shipment file */
*                 if ship_db <> global_db then do:
*                    {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
*                 end.
*
*                 {gprun.i ""sosoiss1.p""}
*
*                 {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
*
*              end.
*           end.
*
*           do on endkey undo mainloop, retry mainloop:
*              yn = yes.
*              {mfmsg01.i 12 1 yn} /* Is all info correct? */
*              if yn then do:
*                 hide frame b.
**F017*           hide frame f.
*                 hide frame c.
*                 leave loop0.
*              end.
*           end.
*        end.
 *GC96   END OF MOVED CODE */

         undo-all = yes.
/*GC96   so_mstr_recid = recid(so_mstr). */

/*G035*/ do transaction:
/*G035*/    /* CALCULATE FREIGHT */
/*G035*/    if calc_fr and so_fr_list <> "" and so_fr_terms <> "" then do:
/*G035*/       so_mstr_recid = recid(so_mstr).
/*G035*/       {gprun.i ""sofrcals.p""}
/*H049*/    /* if not freight_ok then do:                              */
/*H049*/    /*    {mfmsg.i 677 2}  Freight charge not added to trailer */
/*H049*/    /* end.                                                    */
/*G035*/    end.
/*G035*/ end.   /* TRANSACTION */

/*F040*/ /* Make sure the alias is pointed back to the central db */
         if change_db then do:
            {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

/*J29S*/    assign connect_db = so_db
/*J29S*/           db_undo = no.
/*J29S*/    run check-db-connect
/*J29S*/        (input connect_db, input-output db_undo).
/*J29S*/    if db_undo then undo mainloop, retry mainloop.
         end.

/*F017*/ /* reverse signs for trailer if we are in fsrmarec mode */
         if sorec = fsrmarec then do:
/*J29S*/   undo-select = false.

/*F379*/   {gprun.i ""sosoiss4.p""}

/*J29S*/   if undo-select then undo mainloop, retry mainloop.
         end.

         /* TRAILER DATA INPUT */
/*H1JB*/ /* ADDED OUTPUT PARAMETER L_RECALC */
/* SS - 090707.1 - B 
         {gprun.i ""sosoisc.p"" "(output l_recalc)"}
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
         {gprun.i ""xxsosoisc91.p"" "(output l_recalc)"}
/* SS - 090707.1 - E */

         if undo-all then next.
/*G0NX*/    /* If batch update, create batch record */
            if batch_update then do transaction:

/*J29S*/       run create-batch.

/*J29S** BEGIN DELETED SECTION MOVED TO INTERNAL PROCEDURE create-batch ******
 *J29S** DONE TO REDUCE ACTION SEGMENT SIZE                             ******
 *             /* No need to create batch if it is already queued normally */
 *             if not (available qad_wkfl and qad_charfld[4] = "") then do:
 *
 *                /* Reset the status for a failed batch */
 *                if available qad_wkfl then qad_charfld[4] = "".
 *
 *                bcdparm = "".
 *                {mfquoter.i so_nbr}
 *                {mfquoter.i eff_date}
 *                {mfquoter.i ship_site}
 *                {mfquoter.i ship_db}
 *
 *                find bc_mstr where bc_batch = batch_id no-lock.
 *
 *                create bcd_det.
 *                assign
 *                   bcd_batch    = batch_id
 *                   bcd_priority = bc_priority
 *                   bcd_date_sub = today
 *                   bcd_time_sub = string(time,"HH:MM:SS")
 *                   bcd_perm     = false
 *                   bcd_userid   = global_userid
 *                   bcd_exec     = "soisbt.p"
 *                   bcd_dev      = dev
 *                   bcd_parm     = bcdparm
 *                   bcd_process  = yes.
 *
 *                 {mfmsg.i 64 1} /* Request queued for batch processing */
 *
 *                /* Create qad_wkfl rec for quick identification of batch */
 *                find qad_wkfl where qad_key1 = mfguser /* sosois.p+so_nbr */
 *                                and qad_key2 = "BATCH"
 *                              no-lock no-error.
 *                /* If the record doesn't exist, create it.*/
 *                if not available qad_wkfl then do:
 *                   create qad_wkfl.
 *                   assign qad_key1 = mfguser
 *                          qad_key2 = "BATCH"
 *                          qad_charfld[1] = so_nbr
 *                          qad_datefld[1] = eff_date
 *                          qad_charfld[2] = ship_site
 *                          qad_charfld[3] = ship_db
 *                          qad_decfld[1]  = gl_amt  /* freight charge */
 *                          .
 *                   if qad_charfld[2] = ? then qad_charfld[2] = "".
 *                end.
 *
 *             end.
 *
 *             /* Reset mfguser to original setting */
 *             mfguser = btemp_mfguser.
 *J29S*** END DELETED SECTION ******************************************/

/*G0NX*/    end.  /* Batch record creation */
/*G0NX*/    else do:

         /* PROCESS SHIPMENTS ENTERED */
         so_mstr_recid = recid(so_mstr).

/*H447*/ /* POST FREIGHT ACCRUALS */
/*H447*/ if gl_amt <> 0 then do:
/*J04C* *H447*  so_mstr_recid = recid(so_mstr). WHY DUPLICATE EFFORT? */
/*H447*/    {gprun.i ""sofrpst.p""}
/*H447*/ end.

/*J29S*/ undo-select = false.

         /* PROCESS SHIPMENTS ENTERED */
         {gprun.i ""sosoisa.p""}

/*J29S*/ if undo-select then undo mainloop, retry mainloop.

/*H1JB*/ /* RECALCULATE SALES ORDER TAX DETAILS (TYPE 11) */
/*H1JB*/ if {txnew.i} and so_fsm_type = "" and l_recalc
/*H1JB*/ then do:

/*H1JB*/     {gprun.i ""txcalc.p""  "(input  '11',
                                      input  so_nbr,
                                      input  so_quote,
                                      input  0 ,
                                      input  no,
                                      output result-status)"}
/*H1JB*/ end. /* IF TXNEW.I AND SO_FSM_TYPE = "" AND L_RECALC */

/*H0BJ****************** NEW GTM CODE START ***************************/
   if {txnew.i} and so_fsm_type = "RMA" then do:

      /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
      find first tx2d_det where tx2d_ref     = so_nbr   and
                                tx2d_nbr     = ''       and
                                tx2d_tr_type = '36'     and
                                tx2d__qad03  = true no-lock no-error.

      if available(tx2d_det) then do:
          {mfmsg01.i 917 2 recalc}
      end.

      if recalc then do:
/*J1RN*/ /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST
 *          AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET
 *          TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER
 *          RECORDS FROM THIS CALL TO TXCALC.P */

         {gprun.i ""txcalc.p""  "(input  '36',
                           input  so_nbr,
                           input  '',
                           input  0 /*ALL LINES*/,
                           input  no,
                           output result-status)"}
      end.

   end.
/*H0BJ******************* NEW GTM CODE END *****************************/

         /* Delete sr_wkfl in the shipping database */
         {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }

/*J29S*/ assign connect_db = ship_db
/*J29S*/        db_undo = no.
/*J29S*/ run check-db-connect
/*J29S*/     (input connect_db, input-output db_undo).
/*J29S*/ if db_undo then undo mainloop, retry mainloop.

         {gprun.i ""sosoiss3.p""}

         /* Make sure the alias is pointed back to the central db */
         {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

/*J29S*/ assign connect_db = so_db
/*J29S*/        db_undo = no.
/*J29S*/ run check-db-connect
/*J29S*/     (input connect_db, input-output db_undo).
/*J29S*/ if db_undo then undo mainloop, retry mainloop.

         end.
/*G0NX*/ end.
/*J29S*/ procedure check-db-connect:
/*J29S*/    define input parameter connect_db like dc_name.
/*J29S*/    define input-output parameter db_undo like mfc_logical.

/*J29S*/    if err-flag = 2 or err-flag = 3 then do:
/*J29S*/       {mfmsg03.i 2510 4 "connect_db" """" """"}
/*J29S*/       /* DB NOT CONNECTED */
/*J29S*/       next-prompt ship_site with frame a.
/*J29S*/       db_undo = yes.
/*J29S*/    end.

/*J29S*/ end. /* procedure check-db-connect */
/*J29S** BEGIN ADDED SECTION */
         procedure check-batch:
            find qad_wkfl where qad_key1 = "sosois.p" + so_mstr.so_nbr
                            and qad_key2 = "BATCH"
                          no-lock no-error.
            if available qad_wkfl then do:
               batch_review = no.
               if qad_charfld[4] <> "" then
                  find lngd_det where lngd_dataset = "bcd_det"
                                  and lngd_field   = "bcd_run_stat"
                                  and lngd_key1    = qad_charfld[4]
                                  and lngd_lang    = global_user_lang
                                no-lock no-error.
               if available lngd_det and qad_charfld[4] = "3" then do:
                  /* ERROR: Batch shipment already exists with status: */
                  {mfmsg02.i 1122 3 lngd_translation}
                  return.
               end.
               else if available lngd_det
               then do:
                  /* WARNING: Batch shipment already exists with status: */
                  {mfmsg02.i 1122 2 lngd_translation}
               end.
               else do:
                  /* Batch shipment already exists */
                  {mfmsg.i 1121 2}
               end.

/*G2Q3         {mfmsg01.i 9000 1 batch_review}  /* Continue? */ */
/*G2Q3*/       {mfmsg01.i 2233 1 batch_review}  /* Continue? */
               if not batch_review then return.

               /* Set mfguser to match batch file */
               /* along with ship_site?           */
               assign
                  btemp_mfguser = mfguser
                  mfguser       = "sosois.p" + so_nbr
                  ship_site     = qad_charfld[2]
                  ship_db       = qad_charfld[3]
                  .

               batch_review = true.

            end.  /* Batch shipment check */
            else
               batch_review = false.
         end. /* procedure check-batch */
/*J29S** END ADDED SECTION */
/*J29S** BEGIN ADDED SECTION */
         procedure update-batch:
            find first mfc_ctrl where mfc_field = "soc_is_batch"
                 no-lock no-error.
            if available mfc_ctrl and mfc_logical = yes
               and not (available qad_wkfl and
           qad_wkfl.qad_charfld[4] = "") then
            bat_loop:
            do with frame batr_up on error undo, return error
                  on endkey undo, return error:

               update batch_update.

               if batch_update then do with frame batr_up:

                  update dev batch_id.

                  if dev = "" then do:
/*G2Q3               {mfmsg.i 9501 3} */
/*G2Q3*/             {mfmsg.i 2235 3}
                     next-prompt dev.
                     undo bat_loop, retry.
                  end.

                  if batch_id = "" then do:
                     {mfmsg.i 67 3}  /* Batch control record does not exist */
                     next-prompt batch_id.
                     undo bat_loop, retry.
                  end.

                  if not can-find(bc_mstr where bc_batch = batch_id)
                  then do:
                     {mfmsg.i 67 3} /* Batch control record does not exist */
                     next-prompt batch_id.
                     undo bat_loop, retry.
                  end.

                  if (dev = "terminal" or dev = "/dev/tty"
                      or dev = "tt:") then do:
                      {mfmsg.i 66 3}
                      /* Output to terminal not allowed for batch request */
                      next-prompt dev.
                      undo bat_loop, retry.
                  end.
               end.

               /* Assign a unique userid for the shipping workfile */
                assign
                  btemp_mfguser = mfguser
                  mfguser       = "sosois.p" + so_mstr.so_nbr .

               hide frame batr_up.

            end.
         end. /* procedure update-batch */
/*J29S** END ADDED SECTION */
/*J29S** BEGIN ADDED SECTION */
         procedure create-batch:
            /* No need to create batch if it is already queued normally */
            if not (available qad_wkfl and
           qad_wkfl.qad_charfld[4] = "") then do:

               /* Reset the status for a failed batch */
               if available qad_wkfl then qad_charfld[4] = "".

               bcdparm = "".
               {mfquoter.i so_mstr.so_nbr}
               {mfquoter.i eff_date}
               {mfquoter.i ship_site}
               {mfquoter.i ship_db}

               find bc_mstr where bc_batch = batch_id no-lock.

               create bcd_det.
               assign
                  bcd_batch    = batch_id
                  bcd_priority = bc_priority
                  bcd_date_sub = today
                  bcd_time_sub = string(time,"HH:MM:SS")
                  bcd_perm     = false
                  bcd_userid   = global_userid
                  bcd_exec     = "soisbt.p"
                  bcd_dev      = dev
                  bcd_parm     = bcdparm
                  bcd_process  = yes.

                {mfmsg.i 64 1} /* Request queued for batch processing */

               /* Create qad_wkfl rec for quick identification of batch */
               find qad_wkfl where qad_key1 = mfguser /* sosois.p+so_nbr */
                               and qad_key2 = "BATCH"
                             no-lock no-error.
               /* If the record doesn't exist, create it.*/
               if not available qad_wkfl then do:
                  create qad_wkfl.
                  assign qad_key1 = mfguser
                         qad_key2 = "BATCH"
                         qad_charfld[1] = so_nbr
                         qad_datefld[1] = eff_date
                         qad_charfld[2] = ship_site
                         qad_charfld[3] = ship_db
/*H1JB*/                 qad_charfld[5] = string(l_recalc , "Y/N")
                         qad_decfld[1]  = gl_amt  /* freight charge */
                         .
                  if qad_charfld[2] = ? then qad_charfld[2] = "".
               end.

            end.

            /* Reset mfguser to original setting */
            mfguser = btemp_mfguser.
         end. /* procedure create-batch */
/*J29S** END ADDED SECTION */
