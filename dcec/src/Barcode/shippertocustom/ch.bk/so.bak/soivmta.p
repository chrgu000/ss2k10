/* GUI CONVERTED from soivmta.p (converter v1.75) Mon Nov  6 02:52:48 2000 */
/* soivmta.p - PENDING INVOICE LINE ITEM MAINTENANCE                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 1.0      LAST MODIFIED: 08/31/86   BY: pml *17*            */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*          */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D007*          */
/* REVISION: 6.0      LAST MODIFIED: 04/02/90   BY: ftb *D002*          */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: wug *B649*          */
/* REVISION: 6.0      LAST MODIFIED: 05/02/90   BY: mlb *D021*          */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: emb *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: mlb *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: mlb *D238*          */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D356*          */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: mlb *D443*          */
/* REVISION: 6.0      LAST MODIFIED: 06/17/91   BY: emb *D710*          */
/* REVISION: 6.0      LAST MODIFIED: 07/08/91   BY: afs *D751*          */
/* REVISION: 6.0      LAST MODIFIED: 08/02/91   BY: wug *D810*          */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: mlv *D825*          */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: mlv *F015*          */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)*/
/* REVISION: 6.0      LAST MODIFIED: 11/14/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: tjs *F191*          */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*          */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*          */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: pma *F315*          */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356*          */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: afs *F398*          */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*          */
/* REVISION: 7.0      LAST MODIFIED: 06/05/92   BY: tjs *F504*          */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*          */
/* REVISION: 7.3      LAST MODIFIED: 09/16/92   BY: tjs *G035*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 01/17/93   BY: afs *G501*          */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*          */
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416*          */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*          */
/* REVISION: 7.3      LAST MODIFIED: 04/07/93   BY: bcm *G889*          */
/* REVISION: 7.3      LAST MODIFIED: 04/28/93   BY: tjs *G948*          */
/* REVISION: 7.3      LAST MODIFIED: 07/26/93   BY: afs *GD61*          */
/* REVISION: 7.3      LAST MODIFIED: 08/23/93   BY: afs *GC24*          */
/* REVISION: 7.4      LAST MODIFIED: 10/10/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/2/93    BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 11/03/93   BY: bcm *H206*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: dpm *GI46*          */
/* REVISION: 7.4      LAST MODIFIED: 02/18/94   BY: afs *FL81*          */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*          */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: wug *GJ21*          */
/* REVISION: 7.4      LAST MODIFIED: 03/31/94   BY: afs *H108*          */
/* REVISION: 7.4      LAST MODIFIED: 07/20/94   BY: bcm *H449*          */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: bcm *GM05*          */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*          */
/* REVISION: 7.4      LAST MODIFIED: 12/12/94   BY: dpm *FT84*          */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*          */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*          */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: rxw *F0PJ*          */
/* REVISION: 7.4      LAST MODIFIED: 04/19/95   BY: dpm *J044*          */
/* REVISION: 8.5      LAST MODIFIED: 04/12/95   BY: dah *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 08/29/95   BY: jym *G0VQ*          */
/* REVISION: 8.5      LAST MODIFIED: 09/25/95   BY: jym *G0Y0*          */
/* REVISION: 8.5      LAST MODIFIED: 10/04/95   BY: kxn *J087*          */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*          */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: ais *G1R4*          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone*/
/* REVISION: 8.5      LAST MODIFIED: 04/29/96   BY: *J0KJ* Dennis Henson*/
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: *J0N2* Dennis Henson*/
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson*/
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: svs *K007*          */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *H0NF* Aruna Patil  */
/* REVISION: 8.6      LAST MODIFIED: 11/14/96   BY: *G2J1* Amy Esau     */
/* REVISION: 8.6      LAST MODIFIED: 01/01/97   BY: *K03Y* Jean Miller  */
/* REVISION: 8.6      LAST MODIFIED: 01/08/97   BY: *J1DV* Sue Poland   */
/* REVISION: 8.6      LAST MODIFIED: 02/21/97   BY: *H0SM* Suresh Nayak */
/* REVISION: 8.6      LAST MODIFIED: 05/02/97   BY: *J1QH* Ajit Deodhar */
/* REVISION: 8.6      LAST MODIFIED: 05/15/97   BY: *G2MG* Ajit Deodhar */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *J1TQ* Irine D'mello*/
/* REVISION: 8.6      LAST MODIFIED: 07/08/97   BY: *K0DT* Arul Victoria*/
/* REVISION: 8.6      LAST MODIFIED: 11/12/97   BY: *H1GM* Seema Varma  */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98   BY: *J2K3* Samir Bavkar */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L024* Sami Kureishy*/
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 11/03/00   BY: *L15F* Kaustubh K   */

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivmta_p_1 "折扣"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmta_p_2 "承诺日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmta_p_3 "零件无库存"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmta_p_4 "说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivmta_p_5 "重新定价"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         /* DEFINE RNDMTHD FOR CALL TO SOIVMTEA.P */
         define shared variable rndmthd like rnd_rnd_mthd.
         define shared variable line like sod_line.
         define shared variable del-yn like mfc_logical.
         define shared variable prev_due like sod_due_date.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable all_days as integer.
         define shared variable qty like sod_qty_ord.
         define shared variable part as character format "x(18)".
         define shared variable eff_date as date.
         define shared variable ref like glt_det.glt_ref.
         define shared variable so_recno as recid.
         define new shared variable trlot like tr_lot.
         define variable qty_all like sod_qty_all.
         define variable desc1 like pt_desc1.
         define variable trqty like tr_qty_chg.
         define variable qty_left like tr_qty_chg.
         define new shared variable sod_recno as recid.
         define new shared variable pcqty like sod_qty_ord.
         define new shared variable sodcmmts like soc_lcmmts label {&soivmta_p_4}.
         define shared variable promise_date as date label {&soivmta_p_2}.
         define shared variable base_amt like ar_amt.
         define new shared variable prev_consume like sod_consume.
         define new shared variable amd as character.
         define new shared variable pl like pt_prod_line.
         define new shared variable ad_mod_del as character.
         define new shared frame c.
         define new shared frame d.
         define new shared variable undo_all like mfc_logical initial no.
         define shared variable ln_fmt like soc_ln_fmt.
         define variable l_ln_fmt like soc_ln_fmt no-undo.
         define new shared variable clines as integer initial ?.
         define variable first_time like mfc_logical initial yes.
         define new shared variable prev_type like sod_type.
         define new shared variable prev_site like sod_site.
         define shared variable tax_in like cm_tax_in.
/*L024*  define shared variable exch_rate like exd_rate.*/
/*L024*/ define shared variable exch_rate like exr_rate.
/*L024* *L00Y* define shared variable exch_rate2 like exd_rate.*/
/*L024*/ define shared variable exch_rate2 like exr_rate2.
/*L00Y*/ define shared variable exch_ratetype like exr_ratetype.
/*L00Y*/ define shared variable exch_exru_seq like exru_seq.
         define shared variable so_db like dc_name.
         define variable err-flag as integer.
         define shared variable mult_slspsn like mfc_logical no-undo.
         define variable ptstatus like pt_status.
         define new shared variable new_line like mfc_logical.
         define variable vtclass as character extent 3.
         define buffer sod_buff for sod_det.
         define variable j as integer.
         define new shared variable delete_line like mfc_logical.
         define new shared variable new_site like sod_site.
         define new shared variable err_stat as integer.
         define shared variable soc_pc_line like mfc_logical.
         define shared variable socrt_int like sod_crt_int.
         define new shared variable sonbr like sod_nbr.
         define new shared variable soline like sod_line.
         define new shared variable continue like mfc_logical.
         define new shared variable location like sod_loc.
         define new shared variable lotser like sod_serial.
         define new shared variable lotrf like sr_ref.
/*L024*  define new shared variable exch-rate like exd_ent_rate. */
/*L024*/ define new shared variable exch-rate like exr_rate.
/*L024*  /*L00Y*/ define new shared variable  exch-rate2 like exd_ent_rate. */
/*L024*/ define new shared variable exch-rate2 like exr_rate2.
         define variable imp-okay        like mfc_logical no-undo.
         define            variable trqty_alloc like tr_qty_chg no-undo.
         define new shared variable noentries as integer no-undo.

         define variable l_changedb like mfc_logical no-undo.
         define variable return-msg  like msg_nbr initial 0 no-undo.
/*M017*/ define variable rtn_error as logical no-undo.

         define new shared workfile wf-tr-hist
            field trsite like tr_site
            field trloc like tr_loc
            field trlotserial like tr_serial
            field trref like tr_ref
            field trqtychg like tr_qty_chg
            field trum like tr_um
            field trprice like tr_price.
         define new shared variable discount as decimal label {&soivmta_p_1}
                                                        format "->>>9.9<<<".
         define new shared variable reprice_dtl like mfc_logical
                                                label {&soivmta_p_5}.
         define     shared variable reprice          like mfc_logical.
         define     shared variable new_order        like mfc_logical.
         define new shared variable save_parent_list like sod_list_pr.
         define new shared variable cmtindx          like cmt_indx.
         define            variable disc_min_max     like mfc_logical.
         define            variable disc_pct_err     as   decimal.
/*L024*/ define            variable mc-error-number  like msg_nbr no-undo.

         define shared frame bi.
         define shared stream bi.

         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}
         /*V8:DontRefreshTitle=bi */

/*L15F** find so_mstr where recid(so_mstr) = so_recno. */
/*L15F*/ for first so_mstr
/*L15F*/    fields(so_curr so_cust so_due_date so_ex_rate so_ex_rate2
/*L15F*/           so_fix_pr so_fr_list so_fsm_type so_nbr so_po so_pricing_dt
/*L15F*/           so_project so_pr_list so_pst so_req_date so_ship
/*L15F*/           so_ship_date so_site so_slspsn so_taxable so_taxc
/*L15F*/           so_tax_env so_tax_usage)
/*L15F*/    where recid(so_mstr) = so_recno no-lock:
/*L15F*/ end. /* FOR FIRST so_mstr */

/*M017*/ for first cm_mstr no-lock where cm_mstr.cm_addr = so_cust: end.
         find first soc_ctrl no-lock.
         find first gl_ctrl no-lock.
         eff_date = so_ship_date.

         find first pic_ctrl no-lock.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
            so_nbr
            so_cust
            ln_fmt
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         display so_nbr so_cust ln_fmt with frame a.

         /* SET DISPLAY OF THE MULTIPLE SALESPERSON FLAG          */
         /* MULPITLE COMMISSION UPDATES WILL ONLY HAPPEN IF TRUE. */
         if so_slspsn[2] <> "" or so_slspsn[3] <> "" or so_slspsn[4] <> ""
            then mult_slspsn = true.
         else mult_slspsn = false.

         if ln_fmt then clines = 1.

         /* Define shared line screens */
         {soivlnfm.i}

linefmt:
repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


            assign l_ln_fmt = ln_fmt.
   if not first_time then
    update ln_fmt with frame a.

            if l_ln_fmt <> ln_fmt  then
            clear frame c all no-pause.

   clines = ?.
   if ln_fmt then clines = 1.
   first_time = no.

   mainloop:
   repeat on endkey undo, next linefmt
    with frame c down:
/*GUI*/ if global-beam-me-up then undo, leave.


/*L15F*/ find first so_mstr
/*L15F*/    where recid(so_mstr) = so_recno exclusive-lock no-error.

         reprice_dtl = reprice.

         hide frame d.
      hide frame c.
      view frame c.
      if ln_fmt then view frame d.

      sodcmmts = soc_lcmmts.

         /* SCREENS & REPORTS DON'T SUPPORT 4 DIGIT LINE NOS. */
         if line < 999 then
        line = line + 1.
         else
         if line = 999 then do:
            {mfmsg.i 7418 2}  /* LINE CANNOT BE > 999 */
         end.

          clear frame bi.

      find sod_det where sod_nbr = so_nbr and sod_line = line
      no-lock no-error.
         if not available sod_det then do:

            discount = if not pic_so_fact then
                          0
                       else
                          1.
            display line
                    "" @ sod_part
                    0 @ sod_qty_chg
                    "" @ sod_um
                    0 @ sod_list_pr
                    discount
                    0 @ sod_price
            with frame c.
         end.
      if available sod_det then do:
     find pt_mstr where pt_part = sod_part no-lock no-error no-wait.
     if available pt_mstr then
      desc1 = pt_desc1.
     else if sod_desc <> "" then
      desc1 = sod_desc.
     else
      desc1 = {&soivmta_p_3}.
         /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount */
         {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
         /* REMEMBER, RMA RECEIPT LINES CONTAIN NEGATIVE QTY'S */
         /* BUT THEY SHOULD DISPLAY POSITIVE...                */
     display line
             sod_part
                 sod_qty_inv when (sod_fsm_type <> "RMA-RCT") @ sod_qty_chg
                (sod_qty_inv * -1) when (sod_fsm_type = "RMA-RCT") @ sod_qty_chg
             sod_um
         sod_list_pr discount sod_price with frame c.
     if ln_fmt then do:
            if sod_fsm_type <> "RMA-RCT" then do:
               if sod_qty_ord >= 0 then
                  display max(sod_qty_ord - sod_qty_ship, 0)
                          @ sod_bo_chg with frame d.
               else
                  display min(sod_qty_ord - sod_qty_ship, 0)
                          @ sod_bo_chg with frame d.
            end.
            else /* FOR RMA RECEIPT LINES, FLIP THE SIGN */
               display (sod_qty_inv * -1) @ sod_bo_chg with frame d.

        display
        sod_std_cost sod_type sod_due_date sod_loc
            sod_fr_list
        sod_site
        sod_qty_all sod_qty_pick
        sod_qty_inv
                when (sod_fsm_type <> "RMA-RCT")
           (sod_qty_inv * -1) when (sod_fsm_type = "RMA-RCT")
                              @ sod_qty_inv
        sod_serial sod_acct sod_cc sod_dsc_acct sod_dsc_cc
            sod_project sod_confirm
        sod_um_conv sod_taxable sod_taxc
        sod_req_date sod_per_date
            sod_slspsn[1] mult_slspsn sod_comm_pct[1]
        desc1 (sod_cmtindx <> 0) @ sodcmmts
            sod_crt_int
            sod_fix_pr
            sod_pricing_dt
        with frame d.
     end.
      end.

      update line with frame c editing:

     /* FIND NEXT RECORD */
     {mfnp01.i sod_det line sod_line so_nbr sod_nbr sod_nbrln}

     if recno <> ? then do:
        find pt_mstr where pt_part = sod_part no-lock no-error no-wait.
        if available pt_mstr then
         desc1 = pt_desc1.
        else if sod_desc <> "" then
         desc1 = sod_desc.
        else
         desc1 = {&soivmta_p_3}.
        line = sod_line.

            /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount */
            {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
        display line
                sod_part
                    sod_qty_inv       when (sod_fsm_type <> "RMA-RCT")
                                      @ sod_qty_chg
                   (sod_qty_inv * -1) when (sod_fsm_type =  "RMA-RCT")
                                      @ sod_qty_chg
                sod_um
                    sod_list_pr discount sod_price
        with frame c.

        if ln_fmt then do:
               if sod_fsm_type <> "RMA-RCT" then do:
                  if sod_qty_ord >= 0 then
                     display max(sod_qty_ord - sod_qty_ship, 0) @ sod_bo_chg
                     with frame d.
                  else
                     display min(sod_qty_ord - sod_qty_ship, 0) @ sod_bo_chg
                     with frame d.
               end.
               else /* FOR RMA RECEIPT LINES, FLIP THE SIGN */
                  display (sod_qty_inv * -1)  @ sod_bo_chg
                  with frame d.

           display
           sod_std_cost sod_type sod_due_date sod_loc
               sod_fr_list
           sod_site
           sod_qty_all sod_qty_pick
           sod_qty_inv
                   when (sod_fsm_type <> "RMA-RCT")
              (sod_qty_inv * -1) when (sod_fsm_type = "RMA-RCT")
                                 @ sod_qty_inv
           sod_serial sod_acct sod_cc sod_dsc_acct sod_dsc_cc
               sod_project sod_confirm
           sod_um_conv sod_taxable sod_taxc
           sod_req_date sod_per_date
               sod_slspsn[1] mult_slspsn sod_comm_pct[1]
           desc1 (sod_cmtindx <> 0) @ sodcmmts
               sod_crt_int
               sod_fix_pr
               sod_pricing_dt
           with frame d.
        end.
     end.
      end.

      /* ADD/MOD/DELETE  */

      find sod_det where sod_nbr = so_nbr and sod_line = input line no-error.

            assign noentries = 0.

            for each wf-tr-hist exclusive-lock:
              delete wf-tr-hist.
            end.

            /* DO NOT LET THE USER CREATE RMA LINE ITEMS HERE - USE RMA MAINT */
            if not available sod_det  and so_fsm_type = "RMA" then do:
               {mfmsg.i 1310 3}    /* RECORD NOT FOUND */
               {mfmsg.i 1262 1}    /* USE RMA MAINT TO CREATE NEW RMA LINES */
               undo, retry.
            end.    /* if not available sod_det and... */

      if not available sod_det then do:

         if not new_order then
            reprice_dtl = yes.  /*This will cause the line to be priced*/

     amd = "ADD".

     create sod_det.
     assign
      sod_nbr        = so_nbr
      sod_line       = input line
          sod_confirm    = yes
      sod_due_date   = so_due_date
          sod_pricing_dt = so_pricing_dt
          sod_pr_list    = so_pr_list
          sod_site       = so_site
      sod_slspsn[1]  = so_slspsn[1]
      sod_slspsn[2]  = so_slspsn[2]
          sod_slspsn[3]  = so_slspsn[3]
          sod_slspsn[4]  = so_slspsn[4]
      sodcmmts       = soc_lcmmts
          sod_fr_list    = so_fr_list
          sod_fix_pr     = so_fix_pr
          sod_crt_int    = socrt_int
          sod_enduser    = so_ship
          sod_contr_id   = so_po
          sod_project    = so_project .

/*J2K3*/  if so_req_date <> so_due_date then
/*J2K3*/     sod_req_date = so_req_date.

     desc1 = "".
         new_line = yes.

     /* Set tax defaults */
         /* INITIALIZE TAX MANAGEMENT FIELDS */
         if {txnew.i} then do:
      assign
          sod_taxable   = so_taxable
          sod_taxc      = so_taxc
          sod_tax_usage = so_tax_usage
          sod_tax_env   = so_tax_env
          sod_tax_in    = tax_in.
         end.
         else                                                do:
        sod_taxable = so_taxable.
        sod_taxc = so_taxc.
     end.
     if gl_can or gl_vat then sod_tax_in = tax_in.  /*cm_tax_in*/
     if gl_can then sod_pst = so_pst.               /*cm_pst*/

     assign line.

         /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount */
         {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
     display line sod_part sod_qty_inv @ sod_qty_chg sod_um
          sod_list_pr discount sod_price
     with frame c no-attr-space.

     /* Display line detail if in single line mode */
     if ln_fmt then
       display base_curr sod_std_cost sod_type sod_due_date sod_loc
           sod_fr_list
       sod_site sod_qty_all sod_qty_pick sod_qty_inv
       sod_serial sod_acct sod_cc sod_dsc_acct sod_dsc_cc
           sod_project sod_confirm
       sod_um_conv sod_taxable sod_taxc
       sod_req_date sod_per_date
           sod_slspsn[1] mult_slspsn sod_comm_pct[1]
       desc1 sodcmmts
           sod_crt_int
           sod_fix_pr
           sod_pricing_dt
     with frame d.

     prompt-for sod_det.sod_part with frame c editing:

        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i pt_mstr sod_part pt_part sod_part pt_part pt_part}

        if recno <> ? then do:
           assign
              desc1    = pt_desc1
              sod_part = pt_part
              sod_um   = pt_um.

/*L024*    sod_list_pr = pt_price * so_ex_rate.*/
/*L024*/      {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input base_curr,
                          input so_curr,
                          input so_ex_rate2,
                          input so_ex_rate,
                          input pt_price,
                          input false,
                          output sod_list_pr,
                          output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

               sod_price = sod_list_pr.

               /*DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount*/
               {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
               display sod_part sod_um sod_list_pr discount sod_price
        with frame c.
           if ln_fmt then display desc1 with frame d.
        end.
     end.

         assign sod_part = input sod_part.

         sod_recno = recid(sod_det).
         /* CHECKING OF CUST PART AND COMMISSION CALCULATION */
         /* MOVED TO SOIVMTA3.P DUE TO RCODE LIMITS           */
/*M017**         {gprun.i ""soivmta3.p""} */
/*M017*/ {gprun.i ""soivmta3.p"" "(output rtn_error)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/ if rtn_error then undo, retry.

     find pt_mstr where pt_part = sod_part no-lock no-error.
     /* Set line defaults from part master (if available) */
     if available pt_mstr then do:

            /* INITIALIZE FREIGHT VALUES*/
            sod_fr_class = pt_fr_class.
            sod_fr_wt    = pt_ship_wt.
            sod_fr_wt_um = pt_ship_wt_um.

            ptstatus = pt_status.
            substring(ptstatus,9,1) = "#".
            if can-find(isd_det where isd_status = ptstatus
            and isd_tr_type = "ADD-SO") then do:
                {mfmsg02.i 358 3 pt_status}
                undo, retry.
            end.

        /* Tax information */
            if {txnew.i} then do:
                sod_taxable = (so_taxable and pt_taxable).
                sod_taxc = pt_taxc.
            end.
            else if gl_vat or gl_can then do:
           if pt_taxable = yes and so_taxable = yes then do:
          sod_taxable = yes.
          sod_taxc = pt_taxc.
           end.
           else  do:
          sod_taxable = no.
          sod_taxc = pt_taxc.
          /*IF PART VAT CODE <> 0% THEN USE THE SO_TAXC*/
          if pt_taxable then do:
             find last vt_mstr where vt_class = pt_taxc
                     and vt_start <= sod_due_date
                     and vt_end >= sod_due_date
                     and vt_tax_pct = 0
                       no-lock no-error.
             if not available vt_mstr then sod_taxc = so_taxc.
          end.
           end.
               /* VALIDATE FEWER THAN 4 TAX CLASSES */
               if not ln_fmt then do:
                 {gpvatchk.i &counter = j   &buffer = sod_buff  &ref = so_nbr
          &buffref = sod_nbr        &file = sod_det     &taxc = sod_taxc
          &frame = d                &undo_yn = true
          &undo_label = mainloop}
               end.
        end.
        else /*not gl_vat and not gl_can*/
        if sod_taxable = yes and pt_taxable = no then do:
           sod_taxable = no.
           sod_taxc    = pt_taxc.
        end.

        assign
         sod_prodline = pt_prod_line
         sod_loc      = pt_loc
         sod_um       = pt_um .
        if so_curr = base_curr then do:
           assign
               sod_price   = if sod_fsm_type <> "RMA-RCT" then
                                pt_price
                             else
                                sod_price.
               sod_list_pr = if sod_fsm_type <> "RMA-RCT" then
                                pt_price
                             else
                                sod_list_pr.
        end.

            /* Set default line site to pt_mstr site if header site is */
            global_part = sod_part.
            if sod_type = "" then do:
               new_site = sod_site.
               {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               if err_stat <> 0 then do:
                  new_site = pt_site.
                  {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if err_stat = 0 then do:
                     sod_site = pt_site.
                     /* DEFAULT SITE INVALID */
                     /* CHANGED TO ITEM DEFAULT */
                     {mfmsg02.i 6201 1 sod_site}
                     if not batchrun then pause.

             /* NOW CHECK ITEM DEFAULT SITE */
                     {gprun.i ""soivmta5.p""
                      "(input pt_site, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                      if return_int = 0 and not ln_fmt then
                          undo mainloop, retry mainloop.

                  end.
                  /* If multi-line, we need to reject the line NOW. */
                  else if not ln_fmt then do:
                     {mfmsg.i 715 3} /* Item does not exist at site */
                     undo mainloop, next mainloop.
                  end.
               end.
            end.

     end.  /* available pt_mstr */
         else if not ln_fmt and so_site = "" then do:
            {mfmsg.i 941 3} /* BLANK SITE NOT ALLOWED */
            undo mainloop, next mainloop.
         end.

      end. /* ADD NEW LINE ITEM */
      else do:
     /* MODIFY EXISTING LINE */

         if not sod_confirm then do:
            {mfmsg.i 646 3} /* Sales order line has not been confirmed */
            undo, next mainloop.
         end.

         /* IF THIS IS A RMA RECEIPT LINE, INVOICE AND BACKORDER QTYS */
         /* (AS STORED IN SOD_DET) ARE NEGATIVE, SO, WE'LL NEED TO DO */
         /* SOME EXTRA WORK TO SHOW THEM AS POSITIVE.  ALSO, TELL THE */
         /* USER IF HE'S PICKED UP A RECEIPT LINE.                    */
         if sod_fsm_type = "RMA-RCT" then do:
            {mfmsg.i 1261 1} /* THIS IS AN RMA RETURN LINE */
         end.   /* if sod_fsm_type = "RMA-RCT" */

         new_line = no.

           /* ADDED SECTION BELOW TO ACCESS TR_HIST OF THE INVENTORY DATABASE */
                   find si_mstr where si_site = sod_site no-lock no-error.
                   l_changedb = (si_db <> so_db).
                   if l_changedb then
                   do:
                      {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                   end.

                   /* ACCESS tr_hist RECORDS TO CREATE WORKFILE wf-tr-hist */
                   {gprun.i ""soivmtu3.p"" "(input sod_nbr, input sod_line,
                   input sod_part, input-output lotrf,
               input-output noentries)"  }
/*GUI*/ if global-beam-me-up then undo, leave.


                   if l_changedb then
                   do:
                      {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                   end.

     /* Check for detail allocations */
     if can-find(first lad_det where lad_dataset = "sod_det"
                     and lad_nbr = sod_nbr
                     and lad_line = string(sod_line))
      then do:
        {mfmsg.i 4990 2} /* Detail Allocations Exist */
     end.

     /* Create screen buffer with old line info to track changes */
     do  with frame bi on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

        amd = "MODIFY".
        sod_qty_chg = - sod_qty_inv.
        FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.

        {mfoutnul.i &stream_name = "bi"}

            /* CHANGES DONE BY HONF ARE UNDONE BECAUSE FORMAT OF */
            /* SOD__QAD01 HAS CHANGED AT DATABASE LEVEL          */
            display stream bi sod_det with frame bi.

            output stream bi close.
     end.
/*GUI*/ if global-beam-me-up then undo, leave.


     sod_qty_chg = sod_qty_inv.
     if sod_qty_ord >= 0 then
        sod_bo_chg = max(sod_qty_ord - sod_qty_ship, 0).
     else
        sod_bo_chg = min(sod_qty_ord - sod_qty_ship, 0).

      end.  /* modify existing line */

         /* Pause to show messages that will otherwise be hidden when */
         if ln_fmt then do:
            message. message.
         end.

      assign
      prev_type = sod_type
      prev_site = sod_site
      undo_all = yes
      so_recno = recid(so_mstr)
      sod_recno = recid(sod_det).

         hide message no-pause.

         {gprun.i ""soivmtea.p"" "(output return-msg)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if undo_all = yes then undo mainloop, next mainloop.

      /* Switch to the inventory database and update it */
      {gprun.i ""soivmtu1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


      if del-yn = yes then do:
         continue = no .

         {gprun.i ""soivmta4.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         if continue = no then undo mainloop, next mainloop.

     if continue = yes then next mainloop.
      end.
/*M017*      if not sod_bonus and soc_apm then */
/*M017*/     if not sod_bonus
/*M017*/        and soc_apm
/*M017*/        and available cm_mstr
/*M017*/        and cm_promo <> "" then
      for each pih_hist where pih_doc_type = 1
                          and pih_nbr      = sod_nbr
                          and pih_line     = sod_line no-lock :
/*GUI*/ if global-beam-me-up then undo, leave.

          if pih_promo2 = "B" then do on endkey undo, leave :
             find pi_mstr where pi_list_id = pih_list_id
                  no-lock no-error.

             if available pi_mstr then do :
                cmtindx = pi_mstr.pi_cmtindx.
                {gprun.i ""gpcmmt04.p"" "(input ""pi_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

             end.
          end. /* contain bonus stock price list */
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*  for each pih_hist  */

         if not ln_fmt then down 1 with frame c.

         /* IF IMPORT EXPORT MASTER RECORD EXIST  THEN CALL THE IMPORT     */
         /* EXPORT DETAIL LINE CREATION PROGRAM TO CREATE ied_det          */

         imp-okay = no.
         if can-find(first ie_mstr where ie_type = "1" and ie_nbr =  sod_nbr)
         then do:
            {gprun.i ""iedetcr.p"" "(input ""1"",
                     input sod_nbr,
                     input sod_line,
                     input recid(sod_det),
                     input-output imp-okay)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if imp-okay = no  then undo mainloop, retry.
         end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* mainloop */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* linefmt */
if ln_fmt then hide frame d.
         hide frame c.
         hide frame a.

output stream bi close.
