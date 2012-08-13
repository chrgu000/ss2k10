/* xxsoivmta.p - PENDING INVOICE LINE ITEM MAINTENANCE                          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.42.3.1 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 08/31/86   BY: pml *17*                  */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*                */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D007*                */
/* REVISION: 6.0      LAST MODIFIED: 04/02/90   BY: ftb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: wug *B649*                */
/* REVISION: 6.0      LAST MODIFIED: 05/02/90   BY: mlb *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: emb *D040*                */
/* REVISION: 6.0      LAST MODIFIED: 08/09/90   BY: mlb *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: mlb *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D356*                */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: mlb *D443*                */
/* REVISION: 6.0      LAST MODIFIED: 06/17/91   BY: emb *D710*                */
/* REVISION: 6.0      LAST MODIFIED: 07/08/91   BY: afs *D751*                */
/* REVISION: 6.0      LAST MODIFIED: 08/02/91   BY: wug *D810*                */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: mlv *D825*                */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: mlv *F015*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 11/14/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: tjs *F191*                */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*                */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: pma *F315*                */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356*                */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: afs *F398*                */
/* REVISION: 7.0      LAST MODIFIED: 05/06/92   BY: tjs *F470*                */
/* REVISION: 7.0      LAST MODIFIED: 06/05/92   BY: tjs *F504*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*                */
/* REVISION: 7.3      LAST MODIFIED: 09/16/92   BY: tjs *G035*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 01/17/93   BY: afs *G501*                */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: tjs *G579*                */
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416*                */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*                */
/* REVISION: 7.3      LAST MODIFIED: 04/07/93   BY: bcm *G889*                */
/* REVISION: 7.3      LAST MODIFIED: 04/28/93   BY: tjs *G948*                */
/* REVISION: 7.3      LAST MODIFIED: 07/26/93   BY: afs *GD61*                */
/* REVISION: 7.3      LAST MODIFIED: 08/23/93   BY: afs *GC24*                */
/* REVISION: 7.4      LAST MODIFIED: 10/10/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 10/2/93    BY: cdt *H184*                */
/* REVISION: 7.4      LAST MODIFIED: 11/03/93   BY: bcm *H206*                */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: afs *H238*                */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: dpm *GI46*                */
/* REVISION: 7.4      LAST MODIFIED: 02/18/94   BY: afs *FL81*                */
/* REVISION: 7.4      LAST MODIFIED: 03/16/94   BY: afs *H295*                */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: wug *GJ21*                */
/* REVISION: 7.4      LAST MODIFIED: 03/31/94   BY: afs *H108*                */
/* REVISION: 7.4      LAST MODIFIED: 07/20/94   BY: bcm *H449*                */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: bcm *GM05*                */
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95*                */
/* REVISION: 7.4      LAST MODIFIED: 12/12/94   BY: dpm *FT84*                */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*                */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: rxw *F0PJ*                */
/* REVISION: 7.4      LAST MODIFIED: 04/19/95   BY: dpm *J044*                */
/* REVISION: 8.5      LAST MODIFIED: 04/12/95   BY: dah *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 08/29/95   BY: jym *G0VQ*                */
/* REVISION: 8.5      LAST MODIFIED: 09/25/95   BY: jym *G0Y0*                */
/* REVISION: 8.5      LAST MODIFIED: 10/04/95   BY: kxn *J087*                */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*                */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: ais *G1R4*                */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 04/29/96   BY: *J0KJ* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: *J0N2* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: *J0XR* Dennis Henson      */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *H0NF* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/14/96   BY: *G2J1* Amy Esau           */
/* REVISION: 8.6      LAST MODIFIED: 01/01/97   BY: *K03Y* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 01/08/97   BY: *J1DV* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 02/21/97   BY: *H0SM* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 05/02/97   BY: *J1QH* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 05/15/97   BY: *G2MG* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *J1TQ* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 07/08/97   BY: *K0DT* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 11/12/97   BY: *H1GM* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98   BY: *J2K3* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic         */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/28/00   BY: *N0DM* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* REVISION: 9.1      LAST MODIFIED: 11/03/00   BY: *L15F* Kaustubh K         */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0W8* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.32          BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.33          BY: Russ Witt          DATE: 06/19/01  ECO: *P00J* */
/* Revision: 1.34          BY: Rajesh Thomas      DATE: 07/11/01  ECO: *M136* */
/* Revision: 1.35          BY: Jeff Wootton       DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.36          BY: Steve Nugent       DATE: 10/15/01  ECO: *P004* */
/* Revision: 1.37          BY: Rajiv Ramaiah      DATE: 10/31/01  ECO: *M1LM* */
/* Revision: 1.38          BY: Rajesh Kini        DATE: 03/14/02  ECO: *M1WN* */
/* Revision: 1.39          BY: Jean Miller        DATE: 05/14/02  ECO: *P05V* */
/* Revision: 1.40          BY: Veena Lad          DATE: 06/26/02  ECO: *N1M4* */
/* Revision: 1.41          BY: Vivek Gogte        DATE: 10/22/02  ECO: *N1XT* */
/* Revision: 1.42          BY: Dipesh Bector      DATE: 01/14/03  ECO: *M21Q* */
/* $Revision: 1.42.3.1 $         BY: Santosh Rao        DATE: 06/25/03  ECO: *N2HN* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVMTA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* SET so_to_inv TO YES ONLY ON ADDING A NEW LINE OR MODIFYING THE */
/* QUANTITY OF EXISTING LINE ITEMS                                 */

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
define shared variable base_amt like ar_amt.
define shared variable ln_fmt like soc_ln_fmt.
define shared variable tax_in like cm_tax_in.
define shared variable exch_rate like exr_rate.
define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable so_db like dc_name.
define shared variable soc_pc_line like mfc_logical.
define shared variable socrt_int like sod_crt_int.
define shared variable mult_slspsn like mfc_logical no-undo.
define shared variable reprice          like mfc_logical.
define shared variable new_order        like mfc_logical.

define new shared variable trlot like tr_lot.
define new shared variable sod_recno as recid.
define new shared variable pcqty like sod_qty_ord.
define new shared variable sodcmmts like soc_lcmmts label "Comments".
define new shared variable prev_consume like sod_consume.
define new shared variable amd as character.
define new shared variable pl like pt_prod_line.
define new shared variable ad_mod_del as character.
define new shared variable undo_all like mfc_logical initial no.
define new shared variable prev_type like sod_type.
define new shared variable prev_site like sod_site.
define new shared variable clines as integer initial ?.
define new shared variable delete_line like mfc_logical.
define new shared variable new_site like sod_site.
define new shared variable err_stat as integer.
define new shared variable sonbr like sod_nbr.
define new shared variable soline like sod_line.
define new shared variable continue like mfc_logical.
define new shared variable location like sod_loc.
define new shared variable lotser like sod_serial.
define new shared variable lotrf like sr_ref.
define new shared variable exch-rate like exr_rate.
define new shared variable exch-rate2 like exr_rate2.
define new shared variable new_line like mfc_logical.
define new shared variable noentries as integer no-undo.
define new shared variable discount as decimal label "Discount"
   format "->>>9.9<<<".
define new shared variable reprice_dtl like mfc_logical
   label "Reprice".
define new shared variable save_parent_list like sod_list_pr.
define new shared variable cmtindx          like cmt_indx.

define new shared frame c.
define new shared frame d.

define variable desc1            like pt_desc1.
define variable l_ln_fmt         like soc_ln_fmt no-undo.
define variable first_time       like mfc_logical initial yes.
define variable err-flag         as integer.
define variable ptstatus         like pt_status.
define variable imp-okay         like mfc_logical no-undo.
define variable l_changedb       like mfc_logical no-undo.
define variable return-msg       like msg_nbr initial 0 no-undo.
define variable rtn_error        as logical no-undo.
define variable disc_min_max     like mfc_logical.
define variable disc_pct_err     as   decimal.
define variable mc-error-number  like msg_nbr no-undo.
define variable cust-resv-loc    like locc_loc    no-undo.
define variable useloc           like mfc_logical no-undo.
define variable l_sonbr          like sod_nbr     no-undo.
define variable i                as   integer     no-undo.
define variable l_sod_qty_chg    like sod_qty_chg no-undo.

define new shared workfile wf-tr-hist
   field trsite like tr_site
   field trloc like tr_loc
   field trlotserial like tr_serial
   field trref like tr_ref
   field trqtychg like tr_qty_chg
   field trum like tr_um
   field trprice like tr_price.

define shared frame bi.
define shared stream bi.

/* Define Logistics external data tables */
{lgivdefs.i &type="lg"}

/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}
/*V8:DontRefreshTitle=bi */

for first so_mstr
   fields(so_curr so_cust so_due_date so_ex_rate so_ex_rate2
          so_fix_pr so_fr_list so_fsm_type so_nbr so_po so_pricing_dt
          so_project so_pr_list so_pst so_req_date so_ship
          so_ship_date so_site so_slspsn so_taxable so_taxc
          so_tax_env so_tax_usage)
      where recid(so_mstr) = so_recno
no-lock: end.

for first cm_mstr
   where cm_mstr.cm_addr = so_cust
no-lock: end.

find first soc_ctrl no-lock.
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



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

display
   so_nbr
   so_cust
   ln_fmt
with frame a.

/* SET DISPLAY OF THE MULTIPLE SALESPERSON FLAG          */
/* MULPITLE COMMISSION UPDATES WILL ONLY HAPPEN IF TRUE. */
if so_slspsn[2] <> "" or so_slspsn[3] <> "" or so_slspsn[4] <> "" then
   mult_slspsn = true.
else
   mult_slspsn = false.

if ln_fmt then clines = 1.

/* Define shared line screens */
{xxsoivlnfm.i}

/* If Logistics, set up the first line of input to read */
if lgData then do:
   for first lgil_lgdet
   no-lock: end.
   if not available lgil_lgdet then return.
end.

{&SOIVMTA-P-TAG1}
linefmt:
repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


   assign l_ln_fmt = ln_fmt.
   {&SOIVMTA-P-TAG2}
   if not first_time then
   {&SOIVMTA-P-TAG3}
      update ln_fmt with frame a.

   if l_ln_fmt <> ln_fmt  then
      clear frame c all no-pause.

   clines = ?.
   if ln_fmt then clines = 1.

   first_time = no.
   {&SOIVMTA-P-TAG4}

   mainloop:
   repeat on endkey undo, next linefmt
   with frame c down:
/*GUI*/ if global-beam-me-up then undo, leave.


      find first so_mstr where recid(so_mstr) = so_recno
      exclusive-lock no-error.

      reprice_dtl = reprice.
/**xx**/  reprice_dtl = YES.

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
            {pxmsg.i &MSGNUM=7418 &ERRORLEVEL=2}  /* LINE CANNOT BE > 999 */
         end.

      clear frame bi.

      find sod_det where sod_nbr = so_nbr and sod_line = line
      no-lock no-error.

      if not available sod_det then do:

         discount = if not pic_so_fact then
                       0
                    else
                       1.
         display
            line
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
         else
         if sod_desc <> "" then
            desc1 = sod_desc.
         else
            desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).

         /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount */
         {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

         /* REMEMBER, RMA RECEIPT LINES CONTAIN NEGATIVE QTY'S */
         /* BUT THEY SHOULD DISPLAY POSITIVE...                */
         display
            line
            sod_part
            sod_qty_inv        when (sod_fsm_type <> "RMA-RCT") @ sod_qty_chg
            (sod_qty_inv * -1) when (sod_fsm_type = "RMA-RCT") @ sod_qty_chg
            sod_um
            sod_list_pr
            discount
            sod_price
         with frame c.

         if ln_fmt then do:

            if sod_fsm_type <> "RMA-RCT" then do:
               if sod_qty_ord >= 0 then
                  display
                     max(sod_qty_ord - sod_qty_ship, 0) @ sod_bo_chg
                  with frame d.
               else
                  display
                     min(sod_qty_ord - sod_qty_ship, 0) @ sod_bo_chg
                  with frame d.
            end.

            else /* FOR RMA RECEIPT LINES, FLIP THE SIGN */
               display
                  (sod_qty_inv * -1) @ sod_bo_chg
               with frame d.

            display
               sod_std_cost
               sod_type
               sod_due_date
               sod_loc
               sod_fr_list
               sod_site
               sod_qty_all
               sod_qty_pick
               sod_qty_inv        when (sod_fsm_type <> "RMA-RCT")
               (sod_qty_inv * -1) when (sod_fsm_type = "RMA-RCT") @ sod_qty_inv
               sod_serial
               sod_acct
               sod_sub
               sod_cc
               sod_project
               sod_dsc_acct
               sod_dsc_sub
               sod_dsc_cc
               sod_dsc_project
               sod_confirm
               sod_um_conv
               sod_taxable
               sod_taxc
               sod_req_date
               sod_per_date
               sod_slspsn[1]
               mult_slspsn
               sod_comm_pct[1]
               desc1
               (sod_cmtindx <> 0) @ sodcmmts
               sod_crt_int
               sod_fix_pr
               sod_pricing_dt
            with frame d.

         end.

      end.

      /* Update from screen if not Logistics */
      if not lgData then do:

         update line with frame c
         editing:

            /* TO SHOW SO LINES FOR SELECTED SO IN CHAR AND GUI  */
            /* USING LOOK-UP OR DRILL DOWN BROWSE ON LINE FIELD. */

            {gpbrparm.i &browse=gpbr241.p &parm=c-brparm1 &val="so_nbr"}
            {gpbrparm.i &browse=gplu241.p &parm=c-brparm1 &val="so_nbr"}

            l_sonbr = so_nbr.

            on leave of line in frame c do:
                    
               do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.

                  {gpbrparm.i &browse=gpbr241.p &parm=c-brparm1 &val="l_sonbr"}
                  {gpbrparm.i &browse=gplu241.p &parm=c-brparm1 &val="l_sonbr"}
                  run q-leave in global-drop-down-utilities.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO ON ERROR ... */

               run q-set-window-recid in global-drop-down-utilities.
               if return-value = "error"
                  then return no-apply.   

            end. /* ON LEAVE ... */

            /* FIND NEXT RECORD */
            {mfnp01.i sod_det line sod_line so_nbr sod_nbr sod_nbrln}

            if recno <> ? then do:
               find pt_mstr where pt_part = sod_part no-lock no-error no-wait.
               if available pt_mstr then
                  desc1 = pt_desc1.
               else
               if sod_desc <> "" then
                  desc1 = sod_desc.
               else
                  desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).
               line = sod_line.

               /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount */
               {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}
               display
                  line
                  sod_part
                  sod_qty_inv        when (sod_fsm_type <> "RMA-RCT")
                     @ sod_qty_chg
                  (sod_qty_inv * -1) when (sod_fsm_type =  "RMA-RCT")
                     @ sod_qty_chg
                  sod_um
                  sod_list_pr
                  discount
                  sod_price
       /*xx*/  sod__dec02
               with frame c.

               if ln_fmt then do:
                  if sod_fsm_type <> "RMA-RCT" then do:
                     if sod_qty_ord >= 0 then
                        display
                           max(sod_qty_ord - sod_qty_ship, 0) @ sod_bo_chg
                        with frame d.
                     else
                        display
                           min(sod_qty_ord - sod_qty_ship, 0) @ sod_bo_chg
                        with frame d.
                  end.
                  else /* FOR RMA RECEIPT LINES, FLIP THE SIGN */
                     display
                        (sod_qty_inv * -1)  @ sod_bo_chg
                     with frame d.

                  display
                     sod_std_cost sod_type sod_due_date sod_loc
                     sod_fr_list
                     sod_site
                     sod_qty_all
                     sod_qty_pick
                     sod_qty_inv        when (sod_fsm_type <> "RMA-RCT")
                     (sod_qty_inv * -1) when (sod_fsm_type = "RMA-RCT")
                        @ sod_qty_inv
                     sod_serial
                     sod_acct
                     sod_sub
                     sod_cc
                     sod_project
                     sod_dsc_acct
                     sod_dsc_sub
                     sod_dsc_cc
                     sod_dsc_project
                     sod_confirm
                     sod_um_conv sod_taxable sod_taxc
                     sod_req_date sod_per_date
                     sod_slspsn[1] mult_slspsn sod_comm_pct[1]
                     desc1 (sod_cmtindx <> 0) @ sodcmmts
                     sod_crt_int
                     sod_fix_pr
                     sod_pricing_dt
                     sod_order_category
                  with frame d.

               end.

            end.

         end.

         /* ADD/MOD/DELETE  */
         find sod_det where sod_nbr = so_nbr and sod_line = input line no-error.

      end.

      else do:
         /* For logistics orders set the line per the input request */
         find sod_det where sod_nbr = lgSoNbr and
            sod_line = lgil_sod_line no-error.
      end.

      assign noentries = 0.

      for each wf-tr-hist exclusive-lock:
         delete wf-tr-hist.
      end.

      /* DO NOT LET THE USER CREATE RMA LINE ITEMS HERE - USE RMA MAINT */
      if not available sod_det  and so_fsm_type = "RMA" then do:
         {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}    /* RECORD NOT FOUND */
         {pxmsg.i &MSGNUM=1262 &ERRORLEVEL=1}
         /* USE RMA MAINT TO CREATE NEW RMA LINES */
         undo, retry.
      end.    /* if not available sod_det and... */

      if not available sod_det then do:

         /* LINE 0 ENTRY SHOULD NOT BE ALLOWED */
         if line = 0
         then do:

            /* INVALID LINE NUMBER */
            {pxmsg.i &MSGNUM=642 &ERRORLEVEL=4}
            undo mainloop, retry.
         end. /* IF line = 0 */

         if not new_order then
            reprice_dtl = yes.  /*This will cause the line to be priced*/

         amd = "ADD".

         create sod_det.
         assign
            sod_nbr         = so_nbr
            sod_line        = input line
            sod_confirm     = yes
            sod_due_date    = so_due_date
            sod_pricing_dt  = so_pricing_dt
            sod_pr_list     = so_pr_list
            sod_site        = so_site
            sod_slspsn[1]   = so_slspsn[1]
            sod_slspsn[2]   = so_slspsn[2]
            sod_slspsn[3]   = so_slspsn[3]
            sod_slspsn[4]   = so_slspsn[4]
            sodcmmts        = soc_lcmmts
            sod_fr_list     = so_fr_list
            sod_fix_pr      = so_fix_pr
            sod_crt_int     = socrt_int
            sod_enduser     = so_ship
            sod_contr_id    = so_po
            sod_project     = so_project
            sod_dsc_project = so_project.

         if so_req_date <> so_due_date then
            sod_req_date = so_req_date.

         desc1 = "".
         new_line = yes.

         assign
            so_invoiced = no
            so_to_inv   = yes.

         /* Set tax defaults */
         /* INITIALIZE TAX MANAGEMENT FIELDS */
         assign
            sod_taxable   = so_taxable
            sod_taxc      = so_taxc
            sod_tax_usage = so_tax_usage
            sod_tax_env   = so_tax_env
            sod_tax_in    = tax_in.

         assign line.

         /* DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount */
         {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

         display
            line
            sod_part
            sod_qty_inv @ sod_qty_chg
            sod_um
            sod_list_pr
            discount
            sod_price
         with frame c no-attr-space.

         /* Display line detail if in single line mode */
         if ln_fmt then
         display
            base_curr
            sod_std_cost
            sod_type
            sod_due_date
            sod_loc
            sod_fr_list
            sod_site sod_qty_all sod_qty_pick sod_qty_inv
            sod_serial
            sod_acct
            sod_sub
            sod_cc
            sod_project
            sod_dsc_acct
            sod_dsc_sub
            sod_dsc_cc
            sod_dsc_project
            sod_confirm
            sod_um_conv sod_taxable sod_taxc
            sod_req_date sod_per_date
            sod_slspsn[1] mult_slspsn sod_comm_pct[1]
            desc1 sodcmmts
            sod_crt_int
            sod_fix_pr
            sod_pricing_dt
            sod_order_category
         with frame d.

         /* For Logistics, do not update the part */
         if not lgData then do:

            prompt-for sod_det.sod_part with frame c
            editing:

               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i pt_mstr sod_part pt_part sod_part pt_part pt_part}

               if recno <> ? then do:
                  assign
                     desc1    = pt_desc1
                     sod_part = pt_part
                     sod_um   = pt_um.

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input base_curr,
                          input so_curr,
                          input so_ex_rate2,
                          input so_ex_rate,
                          input pt_price,
                          input false,
                          output sod_list_pr,
                          output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  sod_price = sod_list_pr.

                  /*DETERMINE DISCOUNT DISPLAY FORMAT AND SET VARIABLE discount*/
                  {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

                  display
                     sod_part
                     sod_um
                     sod_list_pr
                     discount
                     sod_price
                  with frame c.

                  if ln_fmt then display desc1 with frame d.

               end.

            end.

            assign sod_part = input sod_part.

         end.

         else do: /*Read the part from the input data*/
            if lgil_sod_part <> "" and lgil_sod_part <> sod_part then do:
               /* No new line items may be added to this transaction */
               {pxmsg.i &MSGNUM=3130 &ERRORLEVEL=4}
               undo, return.
            end.
            sod_price = sod_list_pr.
         end.

         sod_recno = recid(sod_det).
         /* CHECKING OF CUST PART AND COMMISSION CALCULATION */
         {gprun.i ""xxsoivmta3.p"" "(output rtn_error)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if rtn_error then undo, retry.

         find pt_mstr where pt_part = sod_part no-lock no-error.
         /* Set line defaults from part master (if available) */
         if available pt_mstr then do:

            /* INITIALIZE FREIGHT VALUES*/
            assign
               sod_fr_class = pt_fr_class
               sod_fr_wt    = pt_ship_wt
               sod_fr_wt_um = pt_ship_wt_um
               ptstatus = pt_status
               substring(ptstatus,9,1) = "#".

            if can-find(isd_det where isd_status = ptstatus
                                  and isd_tr_type = "ADD-SO")
            then do:
               {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
               undo, retry.
            end.

            /* Tax information */
            assign
               sod_taxable  = (so_taxable and pt_taxable)
               sod_taxc     = pt_taxc
               sod_prodline = pt_prod_line
               sod_um       = pt_um .

            /* SEE IF THERE IS A DEFAULT LOCATION FOR A  */
            /* CUSTOMER RESERVED LOCATION                */
            {gprun.i ""sorldft.p""
               "(input so_ship,
                 input so_bill,
                 input so_cust,
                 input sod_site,
                 output cust-resv-loc,
                 output useloc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if useloc = yes then
               sod_loc = cust-resv-loc.
            else
               sod_loc  = pt_loc.

            if so_curr = base_curr then
               assign
                  sod_price   = if sod_fsm_type <> "RMA-RCT" then
                                   pt_price
                                else
                                   sod_price
                  sod_list_pr = if sod_fsm_type <> "RMA-RCT" then
                                   pt_price
                                else
                                   sod_list_pr.

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
                     {pxmsg.i &MSGNUM=6201 &ERRORLEVEL=1 &MSGARG1=sod_site}
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
                     {pxmsg.i &MSGNUM=715 &ERRORLEVEL=3}
                     /* Item does not exist at site */
                     undo mainloop, next mainloop.
                  end.

               end.

            end.

         end.  /* available pt_mstr */

         else if not ln_fmt and so_site = "" then do:
            {pxmsg.i &MSGNUM=941 &ERRORLEVEL=3} /* BLANK SITE NOT ALLOWED */
            undo mainloop, next mainloop.
         end.

      end. /* ADD NEW LINE ITEM */

      else do:

         /* MODIFY EXISTING LINE */
         if not sod_confirm then do:
            {pxmsg.i &MSGNUM=646 &ERRORLEVEL=3}
            /* Sales order line has not been confirmed */
            undo, next mainloop.
         end.

         /* IF THIS IS A RMA RECEIPT LINE, INVOICE AND BACKORDER QTYS */
         /* (AS STORED IN SOD_DET) ARE NEGATIVE, SO, WE'LL NEED TO DO */
         /* SOME EXTRA WORK TO SHOW THEM AS POSITIVE.  ALSO, TELL THE */
         /* USER IF HE'S PICKED UP A RECEIPT LINE.                    */
         if sod_fsm_type = "RMA-RCT" then do:
            {pxmsg.i &MSGNUM=1261 &ERRORLEVEL=1}
            /* THIS IS AN RMA RETURN LINE */
         end.   /* if sod_fsm_type = "RMA-RCT" */

         new_line = no.

         /* ADDED SECTION BELOW TO ACCESS TR_HIST OF THE INVENTORY DATABASE */
         find si_mstr where si_site = sod_site no-lock no-error.
         l_changedb = (si_db <> so_db).
         if l_changedb then do:
            {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         /* ACCESS tr_hist RECORDS TO CREATE WORKFILE wf-tr-hist */
         {gprun.i ""soivmtu3.p""
            "(input sod_nbr, input sod_line,
              input sod_part, input-output lotrf,
              input-output noentries)"  }
/*GUI*/ if global-beam-me-up then undo, leave.


         if l_changedb then do:
            {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         /* Check for detail allocations */
         if can-find(first lad_det where lad_dataset = "sod_det"
                                     and lad_nbr = sod_nbr
                                     and lad_line = string(sod_line))
         then do:
            /* Detail Allocations Exist */
            {pxmsg.i &MSGNUM=4990 &ERRORLEVEL=2}
         end.

         /* Create screen buffer with old line info to track changes */
         do with frame bi on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            amd = "MODIFY".
            sod_qty_chg = - sod_qty_inv.

            FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.


            {mfoutnul.i &stream_name = "bi"}

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

      if not lgData then do: /* Do not pause for logistics */
         /* Pause to show messages that will otherwise be hidden when */
         if ln_fmt then do:
            message.
            message.
         end.
      end.

      assign
         prev_type     = sod_type
         prev_site     = sod_site
         undo_all      = yes
         l_sod_qty_chg = sod_qty_chg
         so_recno      = recid(so_mstr)
         sod_recno     = recid(sod_det).

      hide message no-pause.

      {gprun.i ""xxsoivmtea.p"" "(output return-msg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if amd = "MODIFY"
      and l_sod_qty_chg <> sod_qty_chg
      then
         assign
            so_to_inv   = yes
            so_invoiced = no.

      if undo_all = yes then undo mainloop, next mainloop.

      /* CREATING pk_det RECORD FOR FAMILY PLANNING ITEMS. */
      if sod_sched then do:
         {mfdel.i pk_det "where pk_user = mfguser"}
         part = sod_part.
         {gprun.i ""sopbex.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF sod_sched */
   
      if not lgData then do:
          /*******XX**********/
          /* Switch to the inventory database and update it */
         {gprun.i ""soivmtu1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
                    /***************XX******************/
      end.

      else do:
         /* FOR LOGISTICS ORDERS, INVOICING AN ORDER DOES NOT MEAN IT WAS */
         /* SHIPPED. DO NOT MOVE INVENTORY, DO NOT DEALLOCATE. */
         /* JUST UPDATE THE QUANTITY TO INVOICE. */
         assign
            sod_qty_inv = sod_qty_chg
            sod_qty_chg = 0.
      end.

      if del-yn = yes then do:
         continue = no.
         {gprun.i ""soivmta4.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         if continue = no then undo mainloop, next mainloop.
         if continue = yes then next mainloop.
      end.

      if not sod_bonus
         and soc_apm
         and available cm_mstr
         and cm_promo <> ""
      then
      for each pih_hist where pih_doc_type = 1
            and pih_nbr      = sod_nbr
            and pih_line     = sod_line
      no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


         if pih_promo2 = "B" then do on endkey undo, leave:
            find pi_mstr where pi_list_id = pih_list_id
            no-lock no-error.
            if available pi_mstr then do:
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

      if lgData then do:
         /* Get the next input line from the Logistics tables. */
         find next lgil_lgdet no-lock no-error.
         /* If no more lines, done. */
         if not available lgil_lgdet then leave linefmt.
      end.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* mainloop */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* linefmt */

{&SOIVMTA-P-TAG5}
if ln_fmt then hide frame d.
hide frame c.
hide frame a.

output stream bi close.
