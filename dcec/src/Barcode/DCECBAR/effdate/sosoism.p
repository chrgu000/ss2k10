/* sosoism.p - SALES ORDER SHIPMENT WITH SERIAL NUMBERS                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*V8:RunMode=Character,Windows */
/*****************************************************************************/
/*                                                                           */
/*    Any for each loops which go through every sod_det for a                */
/*    so_nbr (i.e. for each sod_det where sod_nbr = so_nbr )                 */
/*    should have the following statments first in the loop.                 */
/*                                                                           */
/*       if (sorec = fsrmarec    and sod_fsm_type  <> "RMA-RCT")             */
/*       or (sorec = fsrmaship   and sod_fsm_type  <> "RMA-ISS")             */
/*       or (sorec = fssormaship and sod_fsm_type  =  "RMA-RCT")             */
/*       or (sorec = fssoship    and sod_fsm_type  <> "")                    */
/*       then next.                                                          */
/*                                                                           */
/*    this is to prevent rma receipt line from being processed               */
/*    when issue lines are processed (sas).                                  */
/*                                                                           */
/*    also, sosoisa.p is called by fsrmamtu.p which is called                */
/*    from fsrmamt.p (rma maintenance). Any shared variables                 */
/*    added to sosoisa.p will need to be added to one or both                */
/*    of the above rma programs....                                          */
/*                                                                           */
/*****************************************************************************/

/* REVISION: 1.0      LAST MODIFIED: 07/28/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: WUG *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 04/30/90   BY: MLB *D021*               */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D447*               */
/* REVISION: 6.0      LAST MODIFIED: 01/14/91   BY: emb *D313*               */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*               */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*               */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: afs *D477*   (rev only)  */
/* REVISION: 6.0      LAST MODIFIED: 04/08/91   BY: afs *D497*               */
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: afs *D510*               */
/* REVISION: 6.0      LAST MODIFIED: 05/09/91   BY: emb *D643*               */
/* REVISION: 6.0      LAST MODIFIED: 05/28/91   BY: emb *D661*               */
/* REVISION: 6.0      LAST MODIFIED: 06/04/91   BY: emb *D673*               */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*               */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: MLV *F029*               */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D858*               */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: WUG *D953*               */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: SAS *F017*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: afs *F209*               */
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: afs *F379*               */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: tjs *F504*               */
/* REVISION: 7.0      LAST MODIFIED: 07/01/92   BY: tjs *F726*               */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F732*               */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: tjs *F805*               */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*               */
/* REVISION: 7.2      LAST MODIFIED: 11/09/92   BY: emb *G292*               */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302*               */
/* REVISION: 7.3      LAST MODIFIED: 12/05/92   BY: mpp *G484*               */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: tjs *G702*               */
/* REVISION: 7.2      LAST MODIFIED: 03/16/93   BY: tjs *G451*               */
/* REVISION: 7.3      LAST MODIFIED: 03/18/93   BY: afs *G818*               */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39*               */
/* REVISION: 7.3      LAST MODIFIED: 06/09/93   BY: sas *GB82*               */
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: sas *GC18*               */
/* REVISION: 7.3      LAST MODIFIED: 06/25/93   BY: WUG *GC74*               */
/* REVISION: 7.3      LAST MODIFIED: 06/28/93   BY: afs *GC22*               */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   BY: jjs *GC96*               */
/* REVISION: 7.3      LAST MODIFIED: 07/27/93   BY: tjs *GD76*               */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*               */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*               */
/* REVISION: 7.4      LAST MODIFIED: 11/14/93   BY: afs *H222*               */
/* REVISION: 7.4      LAST MODIFIED: 01/24/94   BY: afs *FL52*               */
/* REVISION: 7.4      LAST MODIFIED: 07/20/94   BY: bcm *H447*               */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *FR31*               */
/* REVISION: 7.4      LAST MODIFIED: 09/23/94   BY: ljm *GM78*               */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*               */
/* REVISION: 8.5      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*               */
/* REVISION: 8.5      LAST MODIFIED: 11/01/94   BY: ame *GN90*               */
/* REVISION: 8.5      LAST MODIFIED: 11/11/94   BY: jxz *FT56*               */
/* REVISION: 8.5      LAST MODIFIED: 12/20/94   BY: rxm *F0B4*               */
/* REVISION: 8.5      LAST MODIFIED: 01/07/95   BY: smp *G0BM*               */
/* REVISION: 8.5      LAST MODIFIED: 01/16/95   BY: rxm *F0F0*               */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: pmf *G0JW*               */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*               */
/* REVISION: 8.5      LAST MODIFIED: 04/06/95   BY: tvo *H0BJ*               */
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 02/07/96   BY: ais *G0NX*               */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*               */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 06/13/96   BY: *G1Y6* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: *J0ZX* Andy Wasilczuk    */
/* REVISION: 8.5      LAST MODIFIED: 07/28/96   BY: *J0ZZ* T. Farnsworth     */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit       */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* Jeff Wootton      */
/* REVISION: 8.6      LAST MODIFIED: 01/02/97   BY: *J1D8* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 05/14/97   BY: *G2MT* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 07/14/97   BY: *G2NY* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 09/02/97   BY: *J205* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 10/24/97   BY: *K0JV* Surendra Kumar    */
/* REVISION: 8.6      LAST MODIFIED: 10/29/97   BY: *G2Q3* Steve Nugent      */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J22N* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 11/07/97   BY: *K15N* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 01/14/98   BY: *J29W* Aruna Patil       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: Adam Harris *L00L        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 05/12/98   BY: *J2DD* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *H1JB* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *H1LZ* Manish K.         */
/* REVISION: 8.6E     LAST MODIFIED: 09/15/98   BY: *J2YT* Irine D'mello     */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L092* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 02/16/99   BY: *J3B4* Madhavi Pradhan   */
/* REVISION: 8.6E     LAST MODIFIED: 02/28/00   BY: *L0SP* Kedar Deherkar    */
/* REVISION: 9.0      LAST MODIFIED: 07/11/00   BY: *M0PQ* Falguni Dalal     */
/* REVISION: 9.0      LAST MODIFIED: 07/20/00   BY: *L0QV* Manish K.         */
/* REVISION: 9.0      LAST MODIFIED: 09/25/00   BY: *M0T3* Rajesh Kini       */
/* REVISION: 9.0      LAST MODIFIED: 12/14/00   BY: *M0XX* Ashwini G.        */
/* REVISION: 9.0      LAST MODIFIED: 01/11/01   BY: *M0XM* Rajesh Lokre      */
         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosoism_p_1 " 批处理 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_2 "自动批处理发货"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_3 "发放"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_4 "  收货含备料量:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_5 "计算运费"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_6 "多记录"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_7 "待发货含领料量:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_8 "生效日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_9 "显示重量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_10 "订单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_11 "输出"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_12 "待发货含领料量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_13 "短缺量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_14 "待发货含备料量"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosoism_p_15 "待发货含备料量:"
         
         &SCOPED-DEFINE sosoism_p_16 "地点"
         
         &SCOPED-DEFINE sosoism_p_17 "销往"
          
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         {sosois1.i}

         define new shared variable rndmthd like rnd_rnd_mthd.
         define variable oldcurr like so_curr.
         define            variable  prefix       as character
                                                  initial "C".
         define new shared variable  copyusr      like mfc_logical.
         define            variable  cchar        as   character.
         define            variable  recalc       like mfc_logical
                                                  initial true.

         define variable csz as character format "X(38)".
         define variable due like sod_due.
         define new shared variable fill_all like mfc_logical
            label {&sosoism_p_14} initial no.
         define new shared variable fill_pick like mfc_logical
            label {&sosoism_p_12} initial yes.
         define variable dwn as integer.
         define variable qty_open like sod_qty_ship label {&sosoism_p_13}.
         define variable trnbr like tr_trnbr.
         define buffer somstr for so_mstr.
         define variable del-yn like mfc_logical initial no.
         define new shared variable so_mstr_recid as recid.

         define new shared variable qty_left like tr_qty_chg.
         define new shared variable trqty like tr_qty_chg.
         define new shared variable eff_date like glt_effdate label {&sosoism_p_8}.
         define new shared variable trlot like tr_lot.
         define new shared variable ref like glt_ref.
         define new shared variable qty_req like in_qty_req.
         define new shared variable open_ref like sod_qty_ord.
         define new shared variable fas_so_rec as character.
         define new shared variable undo-all like mfc_logical no-undo.

         define new shared variable cline as character.
         define new shared variable lotserial_control as character.
         define new shared variable issue_or_receipt as character
            initial {&sosoism_p_3}.
         define new shared variable total_lotserial_qty like sod_qty_chg.
      /* define new shared variable multi_entry as logical              **M0PQ*/
         define new shared variable multi_entry like mfc_logical        /*M0PQ*/
                                                label {&sosoism_p_6}.
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
         define buffer srwkfl for sr_wkfl.
/*L024*  define new shared variable exch_rate like exd_rate. */
/*L024*/ define new shared variable exch_rate like exr_rate.
/*L024* /*L00Y*/ define new shared variable exch_rate2 like exd_rate. */
/*L024*/ define new shared variable exch_rate2 like exr_rate2.
/*L00Y*/ define new shared variable exch_ratetype like exr_ratetype.
/*L00Y*/ define new shared variable exch_exru_seq like exru_seq.
         define new shared variable change_db like mfc_logical.
         define new shared variable so_db like dc_name.
         define new shared variable ship_site like sod_site.
         define new shared variable ship_db like dc_name.
         define new shared variable ship_entity like en_entity.
         define new shared variable ship_so like so_nbr.
         define new shared variable ship_line like sod_line.
         define new shared variable new_site like so_site.
         define new shared variable new_db like so_db.
         define            variable err-flag as integer.
         define new shared variable lotref like sr_ref format "x(8)" no-undo.
         define new shared variable lotrf  like sr_ref format "x(8)" no-undo.
         define new shared variable transtype as character initial "ISS-SO".
         define            variable filllbl   as character
                                              initial  {&sosoism_p_15}
                                              format "x(15)".
         define            variable fillpk    as character
                                              initial  {&sosoism_p_7}
                                              format "x(15)".
         define new shared variable freight_ok like mfc_logical.
         define new shared variable old_ft_type like ft_type.
         define new shared variable calc_fr   like mfc_logical
                                              label {&sosoism_p_5}.
         define            variable old_um    like fr_um.
         define new shared variable undo-select like mfc_logical no-undo.
         define new shared variable disp_fr   like mfc_logical
                                              label {&sosoism_p_9}.
         define new shared variable qty_chg   like sod_qty_chg.
         define new shared variable gl_amt    like sod_fr_chg.
         define new shared variable accum_qty_all like sod_qty_all.
         define new shared variable site_to         like sod_site.
         define new shared variable loc_to          like sod_loc.

         define            variable batch_update  like mfc_logical
                                              label {&sosoism_p_2}.
         define new shared variable batch_id      like bcd_batch.
         define            variable batch_mfc     like mfc_logical.
         define            variable btemp_menu    like bcd_exec.
         define            variable btemp_mfguser as character.
         define new shared variable dev           as character
                                                  label {&sosoism_p_11}.
         define            variable batch_review    like mfc_logical.
         define            variable l_old_entity    like si_entity no-undo.
/*L092*  define            variable connect_db      like dc_name.  *L092*/
         define            variable db_undo         like mfc_logical no-undo.
         define new shared variable new_line        like mfc_logical.
/*H1JB*/ define            variable l_recalc        like mfc_logical no-undo.
/*L024*/ define            variable mc-error-number like msg_nbr     no-undo.
/*H1LZ*/ define            variable check_vat       like mfc_logical no-undo.
/*H1LZ*/ define            variable err_check       like mfc_logical no-undo.
/*J3B4*/ define new shared variable base_amt        like ar_amt.
/*M0XM*/ define            variable l_undo          like mfc_logical no-undo.
         {txcalvar.i}

/*L00L*/ {etdcrvar.i "NEW"}
/*L00L*  {mfsotrla.i "NEW"}  */
/*L00L*/ {etsotrla.i "NEW"}

         /* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
         assign
           nontax_old   = nontaxable_amt:format
           taxable_old  = taxable_amt:format
           line_tot_old = line_total:format
           line_pst_old = line_pst:format
           disc_old     = disc_amt:format
           trl_amt_old  = so_trl1_amt:format
           tax_amt_old  = tax_amt:format
           tot_pst_old  = total_pst:format
           tax_old      = tax[1]:format
           amt_old      = amt[1]:format
           ord_amt_old  = ord_amt:format.

         /* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
         {gpglefv.i}

         /* INPUT OPTION FORM */
         form
            so_nbr         colon 12   label {&sosoism_p_10}
            filllbl        at 30      no-label
            fill_all                  no-label space(3)
            so_cust    label {&sosoism_p_17} 
            ship_site   label {&sosoism_p_16}
            eff_date       colon 12
            fillpk         AT 30       no-label
            fill_pick                 no-label space(3)
            ad_name        no-label
         with frame a THREE-D side-labels width 80.

         form
            so_fr_list       colon 26
            so_fr_min_wt     colon 26
            fr_um            no-label
            so_fr_terms      colon 26
            calc_fr          colon 26
            disp_fr          colon 26
         with frame d overlay side-labels centered row 7 width 50.

         /* Pop-up frame for batch update info */
         form
            batch_update colon 30
            dev          colon 30
            batch_id     colon 30
         with frame batr_up width 50 column 15 title color normal
         {&sosoism_p_1}
         side-labels overlay.

         if sorec = fsrmarec then
            assign filllbl = {&sosoism_p_4}
                   fillpk  = "".

         display filllbl
            fillpk
         with frame a.

         view frame a.

         find first gl_ctrl no-lock.
         find first soc_ctrl no-lock.
/*H1JB** eff_date = today. */
/*H1JB*/ assign
/*H1JB*/    eff_date = today
            so_db = global_db.

/*J2DD** SECTION MOVED TO INTERNAL PROCEDURE **
 *       /* Initialize batch update */
 *       find first mfc_ctrl where mfc_field = "soc_is_batch" no-lock no-error.
 *       if available mfc_ctrl then do:
 *
 *          assign
 *             batch_mfc    = true
 *             batch_update = mfc_logical.
 *
 *          find first mfc_ctrl where mfc_field = "soc_is_dev"
 *             no-lock no-error.
 *          if available mfc_ctrl then dev = mfc_char.
 *          find first mfc_ctrl where mfc_field = "soc_is_batid"
 *             no-lock no-error.
 *          if available mfc_ctrl then batch_id = mfc_char.
 *
 *       end.
 *J2DD** END OF SECTION MOVED **/

/*J2DD*/ run find-mfcctrl-j2dd.

         do transaction:
/*H1JB*/    /* MOVED CODE TO INTERNAL PROCEDURE DUE TO COMPILE SIZE ERROR */
/*H1JB**    BEGIN DELETE **
 *          find mfc_ctrl exclusive-lock where mfc_field = "fas_so_rec"
 *           no-error.
 *           if available mfc_ctrl then do:
 *              find first fac_ctrl exclusive-lock no-error.
 *              if available fac_ctrl then do:
 *                 fac_so_rec = mfc_logical.
 *                 delete mfc_ctrl.
 *           end.
 *              release fac_ctrl.
 *           end.
 *H1JB**    END DELETE ** */

/*H1JB*/    run p_find_mfc.

            find first fac_ctrl no-lock no-error.
            if available fac_ctrl then fas_so_rec = string(fac_so_rec).

         end.  /* transaction to find control file variables. */

         copyusr = no.
         {mfctrl01.i   mfc_ctrl
                 so_copy_usr
                 cchar
                 no
                 no}
         if  cchar = "yes" then
             copyusr = yes.

         oldcurr = "".

         /* DISPLAY */
         mainloop:
         repeat:
            /*V8! hide all no-pause.
               if global-tool-bar and global-tool-bar-handle <> ? then
               view global-tool-bar-handle.
               view frame a. */

            do transaction:
               display eff_date
                  fill_all
                        fill_pick   when (sorec <> fsrmarec)
               with frame a.

               prompt-for so_nbr
                  
                  fill_all
                  fill_pick when (sorec <> fsrmarec)
                  ship_site
               with frame a editing:
                  if frame-field = "so_nbr" then do:
                     /* FIND NEXT/PREVIOUS RECORD */
                     /* IF WE'RE SHIPPING/RECEIVING RMA'S, NEXT/PREV ON RMA'S */
                     /* ONLY ELSE, NEXT/PREV ON SALES ORDERS.                 */
                     if sorec = fsrmarec or sorec = fsrmaship then do:
                        {mfnp05.i
                            so_mstr
                            so_fsm_type
                            "so_fsm_type = ""RMA"" "
                            so_nbr
                            "input so_nbr"}
                     end.
                     else do:
                       /* FIND NEXT/PREVIOUS RECORD - SO'S ONLY */
                        {mfnp05.i
                             so_mstr
                             so_fsm_type
                             "so_fsm_type = "" "" "
                             so_nbr
                             "input so_nbr"}
                     end.
                     if recno <> ? then do:
                        display so_nbr so_cust with frame a.
                        find ad_mstr where ad_addr = so_cust no-lock no-error.
                        if available ad_mstr then display ad_name with frame a.
/*L092*                 if so_fr_list <> "" then calc_fr = yes.  *L092*/
/*L092*                 else calc_fr = no.                       *L092*/
/*L092*/                calc_fr = so_fr_list <> "".
                     end.
                  end.
                  else do:
                     readkey.
                     apply lastkey.
                  end.
               end.

               assign eff_date fill_all fill_pick ship_site.
               if eff_date = ? then eff_date = today.

               old_ft_type = "".
               find so_mstr using so_nbr exclusive-lock no-error no-wait.
               if locked so_mstr then do:
                  /* SALES ORDER BEING MODIFIED, PLEASE WAIT */
                  {mfmsg.i 666 2}
                  pause 5.
                  undo,retry.
               end.

               if not available so_mstr then do:
                  {mfmsg.i 609 3}  /* Sales order does not exist */
                  next-prompt so_nbr with frame a.
                  undo, retry.
               end.
               if so_conf_date = ? then do:
                  {mfmsg.i 621 2}  /* warning: Sales Order not confirmed */
               end.
               /* IF THIS IS AN RMA AND WE ARE SALES ORDER ONLY MODE, ERROR */
               if (can-find(rma_mstr where rma_nbr    = so_nbr
                                       and rma_prefix = prefix))
               then do:
                  if  sorec = fssoship  then do:
                      {mfmsg.i 7190 3}
                      /* CANNOT PROCESS IF ONLY SALES ORDERS */
                      undo, retry.
                  end.
               end.
               else
/*L092*        do:  *L092*/
                  if  sorec = fsrmaship  or
                      sorec = fsrmaall   or
                      sorec = fsrmarec
                  then do:
                      {mfmsg.i 7191 3} /* this is not an rma */
                      undo, retry.
                  end.
/*L092*        end.  *L092*/
/*H1LZ*/       run p_err_msg ( input so_fsm_type ,input so_secondary ,
/*H1LZ*/                       output err_check ) .
/*H1LZ*/       if err_check then
/*H1LZ*/          undo , retry .

/*H1LZ*/       /* MOVED CODE TO INTERNAL PROCEDURE DUE TO COMPILE SIZE ERROR */
/*H1LZ*        ** BEGIN DELETE **
 *             /* DO NOT LET USERS SHIP SEO'S OR CALL ACTIVITY */
 *             /* RECORDING ORDERS IN SOSOIS.P... */
 *             if so_fsm_type = "SEO" then do:
 *                {mfmsg.i 1052 3}
 *                /* SERVICE ENGINEER ORDERS ARE NOT SHIPPED HERE */
 *                undo, retry.
 *             end.   /* if so_fsm_type = "SEO" */
 *             else if so_fsm_type = "FSM-RO"        then do:
 *                {mfmsg.i 1058 3}
 *                 /* USE CALL ACTIVITY RECORDING FOR THIS ORDER */
 *                undo, retry.
 *             end.   /* if so_fsm_type = "FSM-RO" */
 *             else if so_fsm_type = "SC" then do:
 *                {mfmsg.i 5103 3}    /* INVALID ORDER TYPE */
 *                undo, retry.
 *             end.
 *             if so_secondary then do:
 *                {mfmsg.i 2822 3}
 *                /* BTB ORDERS ARE NOT ALLOWED IN THIS TRANSACTION */
 *                undo, retry.
 *             end.
 *H1LZ*        END DELETE**  */

               find first sod_det where  sod_nbr      = so_nbr
                                    and (sod_btb_type = "02" or
                                         sod_btb_type = "03")
                  no-lock no-error.
               if available sod_det then do:
                  {mfmsg.i 2822 3}
                  /* BTB ORDERS ARE NOT ALLOWED IN THIS TRANSACTION */
                  undo, retry.
               end.

               /* FIND EXCH RATE IF CURRENCY NOT BASE */
/*L024*        if base_curr <> so_curr then do: */
               if not so_fix_rate then do:

/*L024*           ** BEGIN DELETE **
 *                {gpgtex5.i &ent_curr = base_curr
 *                   &curr = so_curr
 *                   &date = eff_date
 *                   &exch_from = exd_rate
 *                   &exch_to = exch_rate}
 *L024*           ** END DELETE **/

/*L024*/          /* Create usage records for posting; delete later. */
/*L024*/          {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                     "(input  so_curr,
                       input  base_curr,
                       input  so_ex_ratetype,
                       input  eff_date,
                       output exch_rate,
                       output exch_rate2,
                       output exch_exru_seq,
                       output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 3}
/*L024*/             undo, retry.
/*L024*/          end.

               end.

               else
/*L024*/          assign
                     exch_rate     = so_ex_rate
/*L024*/             exch_rate2    = so_ex_rate2
/*L024*/             exch_exru_seq = so_exru_seq.

/*L024*        end. */

/*L024*        else */
/*L024*           exch_rate = 1.0. */

               if (oldcurr <> so_curr) or (oldcurr = "")
                  then do:
/*L024*           ** BEGIN DELETE **
 *                {gpcurmth.i
 *                     "so_curr"
 *                     "3"
 *                     "undo, retry"
 *                      "pause 0" }
 *L024*           ** END DELETE **/
/*L024*/          /** GET ROUNDING METHOD FROM CURRENCY MASTER **/
/*L024*/          {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input so_curr,
                       output rndmthd,
                       output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 3}
/*L024*/             undo, retry.
/*L024*/          end. /* if mc-error-number <> 0 */

                  {socurfmt.i}
                  oldcurr = so_curr.
               end. /* IF OLDCURR <> SO_CURR */

               find ad_mstr where ad_addr = so_cust  no-lock.

               display so_cust ad_name with frame a.
               calc_fr = so_fr_list <> "".
               find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
               if available ft_mstr then old_ft_type = ft_type.

               /* Check to see if batch update exists */

               run check-batch.

               if available qad_wkfl and
                  not batch_review then undo, retry.

               if so_stat <> "" then do:
                  /* SALES ORDER STATUS NOT BLANK */
                  {mfmsg.i 623 2}
               end. /* IF SO_STAT <> "" */

/*J2DD**       SECTION MOVED TO INTERNAL PROCEDURE **
 *             find cm_mstr where cm_addr = so_bill  no-lock.
 *             if cm_cr_hold then do:
 *                {mfmsg.i 614 2}  /* warning: Customer on credit hold */
 *                if not batchrun then pause.
 *             end.
 *
 *             if so_invoiced = yes then do:
 *                {mfmsg.i 603 2} /* Invoice printed but not posted */
 *                if not batchrun then pause.
 *             end.
 **J2DD**      END SECTION MOVED **/

/*J2DD*/       run find-cm-mstr (input so_bill, input so_invoiced).

               /* Determine the ship-from database */
               if ship_site = "" then do:
                  /* If this is the only database, use it */
                  if not can-find(first dc_mstr) or
                     not can-find(first sod_det where sod_nbr = so_nbr)
                  then
/*L092*           do:  *L092*/
                     ship_db = global_db.
/*L092*           end.  *L092*/
                  else do:
                     /* Take the database from the first line */
                     find first sod_det where sod_nbr = so_nbr no-lock.
                     find si_mstr where si_site = sod_site no-lock no-error.
                     if not available si_mstr then
                        ship_db = global_db.
                     else do:
                        ship_db = si_db.
                        /* Check to see if SO affects other databases */
                        /* (If so, the user must pick one)            */
                        for each sod_det where sod_nbr  =  so_nbr
                                           and sod_site <> si_site
                                           and sod_confirm
                           no-lock:
                           find si_mstr where si_site = sod_site
                              no-lock no-error.
                           if available si_mstr and si_db <> ship_db then do:
                              {mfmsg.i 2511 4}
                              /* SO spans databases, site must be specified */
                              display si_site @ ship_site with frame a.
                              undo mainloop, retry.
                           end.
                        end.  /* FOR EACH SOD_DET */
                     end.   /* ELSE DO - IF NOT AVAIL SI_MSTR */
                  end.   /* ELSE DO - TAKE DATABASE FROM FIRST LINE */
                  ship_entity = "".

                  /* PERFORM GL CALENDER VALIDATION WHEN ship_site IS BLANK
                     AND "Ship Allocated" OR "Ship Picked" IS YES. */

                  if fill_all = yes or fill_pick = yes then do:
                     l_old_entity = "".
                     for each sod_det no-lock where
                        sod_nbr = so_nbr and
                        sod_confirm break by sod_site:
                        if first-of(sod_site) then do:
                           find si_mstr where si_site = sod_site no-lock.
                           if l_old_entity <> si_entity then do:
                              l_old_entity = si_entity.

                              {gpglef3.i &from_db = so_db
                                         &to_db   = si_db
                                         &module  = ""IC""
                                         &entity  = si_entity
                                         &date    = eff_date
                                         &prompt  = "eff_date"
                                         &frame   = "a"
                                         &loop    = "mainloop"}

                           end. /* IF L_OLD_ENTITY <> SI_ENTITY */
                        end. /* IF FIRST-OF(SOD_SITE) */
                     end. /* FOR EACH sod_det */
                  end. /* IF INPUT FILL_ALL = YES OR INPUT FILL_PICK = YES */
               end.  /* IF SHIP-SITE = "" */
               else do:
                  find si_mstr where si_site = ship_site no-lock no-error.
                  if not available si_mstr then do:
                     {mfmsg.i 708 3}  /* Site does not exist */
                     next-prompt ship_site with frame a.
                     undo, retry.
                  end.
/*H1JB**          ship_db = si_db. */
/*H1JB*/          assign
/*H1JB*/             ship_db     = si_db
                     ship_entity = si_entity.
               end.

               if ship_site <> "" and available si_mstr then do:
/*M0XM*/          l_undo = no.
/*M0XM*/          run find-soddet-m0xm (input so_nbr, input ship_site,
                                        output l_undo).
/*M0XM*/          if l_undo
/*M0XM*/          and batchrun
/*M0XM*/          then
/*M0XM*/             undo mainloop, leave mainloop.
/*M0XM*/          else
/*M0XM*/          if l_undo
/*M0XM*/          then do:
/*M0XM*/             next-prompt ship_site with frame a.
/*M0XM*/             undo, retry.
/*M0XM*/          end. /* IF l_undo */


                  {gprun.i ""gpsiver.p""
                     "(input si_site, input recid(si_mstr), output return_int)"}
                  if return_int = 0 then do:
                     {mfmsg.i 725 3}
                     /* USER DOES NOT HAVE ACCESS TO THIS SITE */
                     next-prompt ship_site with frame a.
                     undo, retry.
                  end.
               end.

               /* MAKE SURE SHIP-FROM DATABASE IS CONNECTED */
               if global_db <> "" and not connected(ship_db) then do:
                  /* DATABASE NOT AVAILABLE */
                  {mfmsg03.i 2510 3 ship_db """" """"}
                  next-prompt ship_site with frame a.
                  undo mainloop, retry.
               end.

               /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY AND
                * DATABASE. WE ONLY NEED TO DO THIS IF THE SITE FIELD
                * WAS ENTERED, BECAUSE OTHERWISE WE DON'T KNOW WHICH
                * ENTITY TO VALIDATE YET. THIS IS OK BECAUSE THE LINE
                * ITEMS WILL ALSO BE VALIDATED. */

               if ship_entity <> "" then do:

                  /* VALIDATE GL PERIOD FOR SPECIFIED ENTITY/DATABASE */
                  {gpglef3.i &from_db = so_db
                             &to_db   = ship_db
                             &module  = ""IC""
                             &entity  = ship_entity
                             &date    = eff_date
                             &prompt  = "eff_date"
                             &frame   = "a"
                             &loop    = "mainloop"}

               end. /* IF SHIP_ENTITY <> "" */

               /* FREIGHT LIST, MIN SHIP WEIGHT & FREIGHT TERMS PARAMETERS */
               if calc_fr then do:
                  if so_fr_list <> "" then do:
                     find fr_mstr where
                        fr_list = so_fr_list and
                        fr_site = so_site    and
                        fr_curr = so_curr no-lock no-error.
                     if not available fr_mstr then
                        find fr_mstr where
                           fr_list = so_fr_list and
                           fr_site = so_site    and
                           fr_curr = base_curr no-lock no-error.

                     disp_fr = yes.
                     display
                        so_fr_list so_fr_min_wt so_fr_terms calc_fr disp_fr
                     with frame d.

                  end.

                  old_um = "".
                  if available fr_mstr then do:
                     display fr_um with frame d.
                     old_um = fr_um.
                  end.

                  set_d:
                  do on error undo, retry:

                     set so_fr_min_wt so_fr_terms calc_fr disp_fr with frame d.

                     if so_fr_list <> "" or (so_fr_list = "" and calc_fr)
                        then do:
                        find fr_mstr where
                           fr_list = so_fr_list and
                           fr_site = so_site    and
                           fr_curr = so_curr no-lock no-error.
                        if not available fr_mstr then
                           find fr_mstr where
                              fr_list = so_fr_list and
                              fr_site = so_site    and
                              fr_curr = base_curr no-lock no-error.
                        if not available fr_mstr then do:
                           /* WARN: FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
                           {mfmsg03.i 670 2 so_fr_list so_site so_curr}
                           /* Lines may be ok. No lines added, so no default.*/
                           if not batchrun then pause.
                        end.
                        display fr_um with frame d.
                        if old_um <> fr_um then do:
                           {mfmsg.i 675 2}
                           /* WARNING: UNIT OF MEASURE HAS CHANGED */
                           if not batchrun then pause.
                        end.
                     end.

                     if so_fr_terms <> "" or (so_fr_terms = "" and calc_fr)
                        then do:
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

               ship_so = so_nbr.

               /* Update batch shipment information if batch in use */
               /* (unless an existing batch job is already queued)  */

               run update-batch.

            end.  /* SO number input transaction */

            do transaction:
               /* Switch databases to get next trlot based on remote */
               /* Work order master for shipping transaction if necessary */
               change_db = (ship_db <> global_db).
               if change_db then do:
                  {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
/*L092*           assign
 *L092*              connect_db = ship_db
 *L092*              db_undo    = no.
 *L092*           run check-db-connect
 *L092*              (input connect_db, input-output db_undo).
 *L092*/
/*L092*/          run check-db-connect (input ship_db, output db_undo).
                  if db_undo then undo mainloop, retry mainloop.
                  /* RETRIEVE FAC CONTROL FILE SETTINGS FROM REMOTE DB */
                  {gprun.i ""sofactrl.p"" "(output fas_so_rec)"}
               end.
               {gprun.i ""gpnxtsq.p"" "(output trlot)"}
               if change_db then do:
                  {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*L092*           assign
 *L092*              connect_db = so_db
 *L092*              db_undo    = no.
 *L092*           run check-db-connect
 *L092*              (input connect_db, input-output db_undo).
 *L092*/
/*L092*/          run check-db-connect (input so_db, output db_undo).
                  if db_undo then undo mainloop, retry mainloop.

               end.
            end.

            if not batch_review then
               for each sr_wkfl exclusive-lock where sr_userid = mfguser:
                  delete sr_wkfl.
               end.

            /* Switch databases to find allocations if necessary */
            change_db = (ship_db <> global_db).
            if change_db then do:
               {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
/*L092*        assign
 *L092*           connect_db = ship_db
 *L092*           db_undo    = no.
 *L092*        run check-db-connect
 *L092*           (input connect_db, input-output db_undo).
 *L092*/
/*L092*/       run check-db-connect (input ship_db, output db_undo).
               if db_undo then undo mainloop, retry mainloop.

               {gprun.i ""sosoiss3.p""} /* Delete sr_wkfl in remote db */

               {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*L092*        assign
 *L092*           connect_db = so_db
 *L092*           db_undo    = no.
 *L092*        run check-db-connect
 *L092*           (input connect_db, input-output db_undo).
 *L092*/
/*L092*/       run check-db-connect (input so_db, output db_undo).
               if db_undo then undo mainloop, retry mainloop.
            end.

            /* CHECK FOR EXISTING ALLOCATIONS AND RESET BACKORDER CHANGE QUANTITY */
            /* (Get all lines to reset the change quantities) */
/*H1LZ*/    check_vat = no .
            if not batch_review then
               for each sod_det where sod_nbr = so_nbr
                  exclusive-lock
                  break by sod_site by sod_loc by sod_serial by sod_part:

/*H1JB**       sod_qty_chg = 0. */
/*H1JB*/       assign
/*H1JB*/          sod_qty_chg = 0
                  sod_bo_chg  = 0.

               if first-of(sod_part) then
                  accum_qty_all = 0.

               if not (sod_site = ship_site or ship_site = "") then next.

               /* Consider skipping this record based on something */
               if    (sorec = fsrmarec    and sod_rma_type  <> "I")
                  or (sorec = fsrmaship   and sod_rma_type  <> "O")
                  or (sorec = fssormaship and sod_rma_type  =  "I")
                  or (sorec = fssoship    and sod_fsm_type  <> "")
                  then next.

               ship_line = sod_line.

               /* Check for allocations if shipping based on allocations */
               if fill_all or fill_pick then do:
                  accum_qty_all = accum_qty_all + sod_qty_all.
                  {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
/*L092*           assign
 *L092*              connect_db = ship_db
 *L092*              db_undo    = no.
 *L092*           run check-db-connect
 *L092*              (input connect_db, input-output db_undo).
 *L092*/
/*L092*/          run check-db-connect (input ship_db, output db_undo).
                  if db_undo then undo mainloop, retry mainloop.

                  {gprun.i ""sosoisu1.p""}

                  {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*L092*           assign
 *L092*              connect_db = so_db
 *L092*              db_undo    = no.
 *L092*           run check-db-connect
 *L092*              (input connect_db, input-output db_undo).
 *L092*/
/*L092*/          run check-db-connect (input so_db, output db_undo).
                  if db_undo then undo mainloop, retry mainloop.

                  if change_db then sod_qty_chg = qty_chg.
               end.

               /* Stop setting To Ship to zero.                            */

/*H1LZ*/       if gl_vat and sod_fsm_type <> "RMA-RCT"
/*H1LZ*/                 and not check_vat
/*H1LZ*/                 and not can-find (first vt_mstr where
/*H1LZ*/                                   (vt_class = sod_taxc and
/*H1LZ*/                                    eff_date >= vt_start and
/*H1LZ*/                                    eff_date <= vt_end)) then do:
/*H1LZ*/          check_vat  = yes.
/*H1LZ*/          /* TAX CLASS DOES NOT EXIST */
/*H1LZ*/          {mfmsg.i 2032 2}
/*H1LZ*/       end . /* IF GL_VAT */

/*L092*        if sod_qty_ord >= 0 then
 *L092*           sod_bo_chg =
 *L092*              MAX((sod_qty_ord - sod_qty_ship - sod_qty_chg),0).
 *L092*        else
 *L092*           sod_bo_chg =
 *L092*              MIN((sod_qty_ord - sod_qty_ship - sod_qty_chg),0).
 *L092*/

/*L092*/       sod_bo_chg =
/*L092*/          if sod_qty_ord >= 0
/*L092*/             then max((sod_qty_ord - sod_qty_ship - sod_qty_chg),0)
/*L092*/             else min((sod_qty_ord - sod_qty_ship - sod_qty_chg),0).

            end.  /*for each sod_det*/

            if change_db then do:
               {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*L092*        assign
 *L092*           connect_db = so_db
 *L092*           db_undo    = no.
 *L092*        run check-db-connect
 *L092*           (input connect_db, input-output db_undo).
 *L092*/
/*L092*/       run check-db-connect (input so_db, output db_undo).
               if db_undo then undo mainloop, retry mainloop.
            end.

/*H1JB**    so_mstr_recid = recid(so_mstr). */
/*H1JB*/    assign
/*H1JB*/       so_mstr_recid = recid(so_mstr)
               undo-select   = true.

            release sod_det.

            /* SELECT LINES AND QUANTITES FOR SHIPMENT */
            {gprun.i ""sosoisd.p""}

            /* ADDED THE FOLLOWING TO RESET SOD_QTY_CHG, SOD_BO_CHG  */
            /* TO ZERO IF THE USER ABORTED OUT OF SOSOISD.P          */
            if undo-select then
/*L092*     do:  *L092*/
               for each sod_det where sod_nbr = so_nbr exclusive-lock:
                  assign sod_qty_chg = 0
                         sod_bo_chg  = 0.
               end.
/*L092*     end.  *L092*/

/*M0XX**    if undo-select then undo mainloop, retry mainloop. */
/*M0XX*/    if  undo-select
/*M0XX*/    and batchrun
/*M0XX*/    then
/*M0XX*/       undo mainloop, leave mainloop.
/*M0XX*/    else if undo-select
/*M0XX*/    then
/*M0XX*/       undo mainloop, retry mainloop.

            undo-all = yes.

/*M0T3*/    /* REVERSE SIGNS FOR TRAILER IF WE ARE IN FSRMAREC MODE */
/*M0T3*/    if sorec = fsrmarec
/*M0T3*/    then do:
/*M0T3*/       undo-select = false.
/*M0T3*/       {gprun.i ""sosoiss4.p""}
/*M0T3*/       if undo-select
/*M0T3*/       then
/*M0T3*/          undo mainloop, retry mainloop.
/*M0T3*/    end. /* IF sorec = fsrmarec THEN DO */

/*L092*     do transaction:  *L092*/
            /* CALCULATE FREIGHT */
            if calc_fr and so_fr_list <> "" and so_fr_terms <> "" then do
/*L092*/       transaction:
               so_mstr_recid = recid(so_mstr).
               {gprun.i ""sofrcals.p""}
/*L092*        end.  *L092*/
            end.   /* TRANSACTION */

            /* Make sure the alias is pointed back to the central db */
            if change_db then do:
               {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*L092*        assign
 *L092*           connect_db = so_db
 *L092*           db_undo    = no.
 *L092*        run check-db-connect
 *L092*           (input connect_db, input-output db_undo).
 *L092*/
/*L092*/       run check-db-connect (input so_db, output db_undo).
               if db_undo then undo mainloop, retry mainloop.
            end.

/*M0T3** BEGIN DELETE
 *          /* Reverse signs for trailer if we are in fsrmarec mode */
 *          if sorec = fsrmarec then do:
 *            undo-select = false.
 *            {gprun.i ""sosoiss4.p""}
 *            if undo-select then undo mainloop, retry mainloop.
 *          end.
 *M0T3** END DELETE */

            /* TRAILER DATA INPUT */
/*H1JB*/    /* ADDED OUTPUT PARAMETER L_RECALC */
            {gprun.i ""sosoisc.p"" "(output l_recalc)"}

            if undo-all then next.
            /* If batch update, create batch record */
            if batch_update then do transaction:
               run create-batch.
            end.  /* Batch record creation */
            else do:

               /* PROCESS SHIPMENTS ENTERED */
               so_mstr_recid = recid(so_mstr).

               /* POST FREIGHT ACCRUALS */
               if gl_amt <> 0 then do:
/*L0QV**          {gprun.i ""sofrpst.p""} */
/*L0QV*/          {gprun.i ""sofrpst.p"" "(input eff_date)"}
               end.

               undo-select = false.

               /* PROCESS SHIPMENTS ENTERED */
               {gprun.i ""sosoisa.p""}

/*L024*/       /* Delete exchange rate usage if not attached to SO */
/*L024*/       if exch_exru_seq <> so_exru_seq then
/*L024*/          run delete-ex-rate-usage (input exch_exru_seq).

               if undo-select then undo mainloop, retry mainloop.

/*H1JB*/       /* RECALCULATE SALES ORDER TAX DETAILS (TYPE 11) */
/*H1JB*/       if {txnew.i} and so_fsm_type = "" and l_recalc then do:

/*L0SP*/         /* TYPE 11 TAX DETAIL RECS DON'T EXIST FOR SCHEDULED ORDERS */
/*L0SP*/          if not so_sched then
/*L0SP*/          do:
/*H1JB*/             {gprun.i ""txcalc.p""
                        "(input  '11',
                          input  so_nbr,
                          input  so_quote,
                          input  0 ,
                          input  no,
                          output result-status)"}
/*L0SP*/          end. /* IF NOT SO_SCHED THEN */

/*H1JB*/       end. /* IF TXNEW.I AND SO_FSM_TYPE = "" AND L_RECALC */

               if {txnew.i} and so_fsm_type = "RMA" then do:

                  /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
                  find first tx2d_det where tx2d_ref     = so_nbr and
                                            tx2d_nbr     = ''     and
                                            tx2d_tr_type = '36'   and
                                            tx2d_edited
                     no-lock no-error.

                  if available(tx2d_det) then do:
                     {mfmsg01.i 917 2 recalc}
                  end.

                  if recalc then do:
                     /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST */
                     /* AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET  */
                     /* TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER      */
                     /* RECORDS FROM THIS CALL TO TXCALC.P                        */

                     {gprun.i ""txcalc.p""
                        "(input  '36',
                          input  so_nbr,
                          input  '',
                          input  0 /*ALL LINES*/,
                          input no,
                          output result-status)"}
                  end.

               end.

               /* Delete sr_wkfl in the shipping database */
               {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
/*L092*        assign
 *L092*           connect_db = ship_db
 *L092*           db_undo    = no.
 *L092*        run check-db-connect
 *L092*           (input connect_db, input-output db_undo).
 *L092*/
/*L092*/       run check-db-connect (input ship_db, output db_undo).
               if db_undo then undo mainloop, retry mainloop.

               {gprun.i ""sosoiss3.p""}

               /* Make sure the alias is pointed back to the central db */
               {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*L092*        assign
 *L092*           connect_db = so_db
 *L092*           db_undo    = no.
 *L092*        run check-db-connect
 *L092*           (input connect_db, input-output db_undo).
 *L092*/
/*L092*/       run check-db-connect (input so_db, output db_undo).
               if db_undo then undo mainloop, retry mainloop.

            end.
/*J2YT*/    release so_mstr.
         end.


         procedure check-db-connect:
            define input        parameter connect_db like dc_name     no-undo.
/*L092*/    define output       parameter db_undo    like mfc_logical no-undo.
/*L092*     define input-output parameter db_undo    like mfc_logical.  *L092*/

/*L092*/    db_undo = err-flag = 2 or err-flag = 3.
/*L092*/    if db_undo then do:
/*L092*     if err-flag = 2 or err-flag = 3 then do:  *L092*/
               {mfmsg03.i 2510 4 "connect_db" """" """"}
               /* DB NOT CONNECTED */
               next-prompt ship_site with frame a.
/*L092*        db_undo = yes.  *L092*/
            end.

         end procedure. /* check-db-connect */


         procedure check-batch:
/*L092*/    batch_review = false.
            find qad_wkfl where qad_key1 = "sosois.p" + so_mstr.so_nbr
                            and qad_key2 = "BATCH"
               no-lock no-error.
            if available qad_wkfl then do:
/*L092*        batch_review = no.  *L092*/
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
               else if available lngd_det then do:
                  /* WARNING: Batch shipment already exists with status: */
                  {mfmsg02.i 1122 2 lngd_translation}
               end.
               else do:
                  /* Batch shipment already exists */
                  {mfmsg.i 1121 2}
               end.

               {mfmsg01.i 2233 1 batch_review}  /* Continue? */
               if not batch_review then return.

               /* Set mfguser to match batch file */
               /* Along with ship_site?           */
               assign
                  btemp_mfguser = mfguser
                  ship_site     = qad_charfld[2]
                  ship_db       = qad_charfld[3]
                  .

               /* This procedure has been created to avoid the standard checker to give */
               /* An error message on the modification of the mfguser variable.         */
               {gprun.i ""gpmfguse.p""
                  "(input ""sosois.p"" + so_mstr.so_nbr, output mfguser)"}

               batch_review = true.

            end.  /* Batch shipment check */

/*L092*     else  *L092*/
/*L092*        batch_review = false.  *L092*/

         end procedure. /* check-batch */


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
                     {mfmsg.i 2235 3}
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

                  if (dev = "terminal" or dev = "/dev/tty" or dev = "tt:")
                  then do:
                     {mfmsg.i 66 3}
                     /* Output to terminal not allowed for batch request */
                     next-prompt dev.
                     undo bat_loop, retry.
                  end.
               end.

               /* Assign a unique userid for the shipping workfile */
               assign
                  btemp_mfguser = mfguser.

               /* This procedure has been created to avoid the standard checker to give */
               /* An error message on the modification of the mfguser variable.         */
               {gprun.i ""gpmfguse.p""
                  "(input ""sosois.p"" + so_mstr.so_nbr, output mfguser)"}

               hide frame batr_up.

            end.
         end procedure. /* update-batch */


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

            /* This procedure has been created to avoid the standard checker to give */
            /* An error message on the modification of the mfguser variable.         */
            {gprun.i ""gpmfguse.p"" "(input btemp_mfguser, output mfguser)"}
         end procedure.  /* create-batch */


/*J2DD** BEGIN ADDED INTERNAL PROCEDURE */
         procedure find-mfcctrl-j2dd:

            find first mfc_ctrl where mfc_field = "soc_is_batch"
               no-lock no-error.
            if available mfc_ctrl then do:
               assign
                  batch_mfc    = true
                  batch_update = mfc_logical.

               find first mfc_ctrl where mfc_field = "soc_is_dev"
                  no-lock no-error.
               if available mfc_ctrl then dev = mfc_char.

               find first mfc_ctrl where mfc_field = "soc_is_batid"
                  no-lock no-error.
               if available mfc_ctrl then batch_id = mfc_char.

            end.

         end procedure.
/*J2DD** END ADDED SECTION **/


/*J2DD** BEGIN ADDED INTERNAL PROCEDURE */
         procedure find-cm-mstr:

            define input parameter inpar_bill like so_bill.
            define input parameter inpar_inv  like so_invoiced.

            find cm_mstr where cm_addr = inpar_bill  no-lock.
            if cm_cr_hold then do:
               {mfmsg.i 614 2}  /* warning: Customer on credit hold */
               if not batchrun then pause.
            end.

            if inpar_inv then do:
               {mfmsg.i 603 2} /* Invoice printed but not posted */
               if not batchrun then pause.
            end.
         end procedure.
/*J2DD** END ADDED SECTION **/


/*H1JB*/ procedure p_find_mfc:
/*H1JB*/    find mfc_ctrl exclusive-lock where mfc_field = "fas_so_rec" no-error.
/*H1JB*/    if available mfc_ctrl then do:
/*H1JB*/       find first fac_ctrl exclusive-lock no-error.
/*H1JB*/       if available fac_ctrl then do:
/*H1JB*/          fac_so_rec = mfc_logical.
/*H1JB*/          delete mfc_ctrl.
/*H1JB*/       end. /* IF AVAILABLE FAC_CTRL */
/*H1JB*/       release fac_ctrl.
/*H1JB*/    end. /* IF AVAILABLE MFC_CTRL */
/*H1JB*/ end procedure.


/*L024*/ procedure delete-ex-rate-usage:
/*L024*/    /* Internal procedure to reduce compile-size */
/*L024*/    define input parameter i_exru_seq like so_exru_seq no-undo.

/*L024*/    {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input i_exru_seq)" }
/*L024*/ end procedure.  /* delete-ex-rate-usage */


/*H1LZ*/ procedure p_err_msg :
/*H1LZ*/    define input  parameter fsmtype  like so_fsm_type no-undo.
/*H1LZ*/    define input  parameter sosecond like so_secondary no-undo.
/*H1LZ*/    define output parameter err_chk  like mfc_logical  no-undo.
/*H1LZ*/    /* DO NOT LET USERS SHIP SEO'S OR CALL ACTIVITY */
/*H1LZ*/    /* RECORDING ORDERS IN SOSOIS.P... */
/*H1LZ*/    if fsmtype = "SEO" then do:
/*H1LZ*/       err_chk = yes.
/*H1LZ*/       {mfmsg.i 1052 3}
/*H1LZ*/       /* SERVICE ENGINEER ORDERS ARE NOT SHIPPED HERE */
/*H1LZ*/       return  .
/*H1LZ*/    end.   /* if so_fsm_type = "SEO" */
/*H1LZ*/    else if fsmtype = "FSM-RO" then do:
/*H1LZ*/       err_chk = yes.
/*H1LZ*/       {mfmsg.i 1058 3}
/*H1LZ*/       /* USE CALL ACTIVITY RECORDING FOR THIS ORDER */
/*H1LZ*/       return .
/*H1LZ*/    end.   /* if so_fsm_type = "FSM-RO" */
/*H1LZ*/    else if fsmtype = "SC" then do:
/*H1LZ*/       err_chk = yes.
/*H1LZ*/       {mfmsg.i 5103 3}    /* INVALID ORDER TYPE */
/*H1LZ*/       return .
/*H1LZ*/    end.
/*H1LZ*/    if sosecond then do:
/*H1LZ*/        err_chk = yes.
/*H1LZ*/        {mfmsg.i 2822 3}
/*H1LZ*/        /* BTB ORDERS ARE NOT ALLOWED IN THIS TRANSACTION */
/*H1LZ*/        return.
/*H1LZ*/    end.
/*H1LZ*/ end procedure. /* P_ERR_MSG */

/*M0XM*/ /* INTERNAL PROCEDURE CREATED TO AVOID ORACLE COMPILE SIZE ERROR */

         PROCEDURE find-soddet-m0xm :

            define input  parameter p_sonbr    like so_nbr      no-undo.
            define input  parameter p_shipsite like sod_site    no-undo.
            define output parameter p_l_undo   like mfc_logical no-undo.

            for first sod_det
               fields(sod_nbr sod_site)
               where sod_nbr  = p_sonbr
               and   sod_site = p_shipsite
            no-lock:
            end. /* FO FIRST sod_det */

            if not available sod_det
            then do:
               /* THE SITE ENTERED ON HEADER DOES NOT BELONG TO THE */
               /* LINE ITEM SITES OF SALES ORDER.                   */
               {mfmsg03.i 4561 3 p_sonbr """" """"}
               p_l_undo = yes.
            end. /* IF NOT AVAILABLE sod_det */

         END PROCEDURE.
