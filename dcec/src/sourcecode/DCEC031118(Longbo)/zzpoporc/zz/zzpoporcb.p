/* GUI CONVERTED from poporcb.p (converter v1.69) Wed Aug 27 03:10:27 1997 */
/* poporcb.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                     */
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003*            */
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F070*            */
/* REVISION: 7.0     LAST MODIFIED: 01/02/92    BY: WUG *F034*            */
/* REVISION: 7.0     LAST MODIFIED: 01/31/92    BY: RAM *F126*            */
/* REVISION: 7.0     LAST MODIFIED: 02/05/92    BY: RAM *F170*            */
/* REVISION: 7.0     LAST MODIFIED: 02/06/92    BY: RAM *F177*            */
/* REVISION: 7.0     LAST MODIFIED: 02/10/92    BY: MLV *F164*            */
/* REVISION: 7.0     LAST MODIFIED: 02/14/92    BY: SAS *F211*            */
/* REVISION: 7.0     LAST MODIFIED: 02/24/92    BY: sas *F211*            */
/* REVISION: 7.0     LAST MODIFIED: 02/24/92    BY: pma *F085*            */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: pma *F086*            */
/* REVISION: 7.0     LAST MODIFIED: 07/30/92    BY: ram *F819*            */
/* REVISION: 7.3     LAST MODIFIED: 09/29/92    BY: tjs *G028*            */
/* REVISION: 7.3     LAST MODIFIED: 11/10/92    BY: pma *G304*            */
/* REVISION: 7.3     LAST MODIFIED: 02/11/93    BY: tjs *G675*            */
/* REVISION: 7.3     LAST MODIFIED: 04/30/93    BY: WUG *GA61*            */
/* REVISION: 7.3     LAST MODIFIED: 05/21/93    BY: kgs *GB26*            */
/* REVISION: 7.3     LAST MODIFIED: 07/07/93    BY: afs *GD28*            */
/* REVISION: 7.3     LAST MODIFIED: 07/08/93    BY: cdt *GD29*            */
/* REVISION: 7.4     LAST MODIFIED: 10/23/93    BY: cdt *H184*            */
/* REVISION: 7.4     LAST MODIFIED: 11/04/93    BY: bcm *H210*            */
/* REVISION: 7.4     LAST MODIFIED: 11/12/93    BY: afs *H219*            */
/* REVISION: 7.4     LAST MODIFIED: 11/16/93    BY: afs *H227*            */
/* REVISION: 7.4     LAST MODIFIED: 03/22/94    BY: dpm *FM94*            */
/* REVISION: 7.4     LAST MODIFIED: 04/08/94    BY: dpm *H074*            */
/* REVISION: 7.4     LAST MODIFIED: 05/04/94    BY: bcm *H365*            */
/* REVISION: 7.4     LAST MODIFIED: 04/15/94    BY: dpm *FN24*            */
/* REVISION: 7.4     LAST MODIFIED: 08/08/94    BY: cdt *FP92*            */
/* REVISION: 7.4     LAST MODIFIED: 09/09/94    BY: bcm *H511*            */
/* REVISION: 8.5     LAST MODIFIED: 10/31/94    BY: taf *J038*            */
/* REVISION: 7.4     LAST MODIFIED: 11/10/94    BY: bcm *GO37*            */
/* REVISION: 7.4     LAST MODIFIED: 12/07/94    BY: bcm *H618*            */
/* REVISION: 7.4     LAST MODIFIED: 02/16/95    BY: jxz *F0JC*            */
/* REVISION: 7.4     LAST MODIFIED: 07/19/95    BY: rxm *G0QG*            */
/* REVISION: 7.4     LAST MODIFIED: 09/12/95    BY: ais *F0V7*            */
/* REVISION: 8.5     LAST MODIFIED: 10/13/95    BY: taf *J053*            */
/* REVISION: 7.4     LAST MODIFIED: 02/08/96    BY: emb *G1MS*            */
/* REVISION: 8.5     LAST MODIFIED: 02/06/96    BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5     LAST MODIFIED: 03/25/96    BY: *G1QK* Arthur Schain  */
/* REVISION: 8.5     LAST MODIFIED: 04/15/96    BY: *H0K5* Robin McCarthy */
/* REVISION: 8.5     LAST MODIFIED: 05/02/96    BY: *H0KT* Robin McCarthy */
/* REVISION: 8.5     LAST MODIFIED: 09/04/96    BY: *H0MK* Sanjay D Patil */
/* REVISION: 8.5     LAST MODIFIED: 10/11/96    BY: *G2FT* Suresh Nayak   */
/* REVISION: 8.5     LAST MODIFIED: 01/08/97    BY: *H0QF* Sue Poland     */
/* REVISION: 8.5     LAST MODIFIED: 02/20/97    BY: *H0SL* Jim Williams   */
/* REVISION: 8.5     LAST MODIFIED: 06/18/97    BY: *H19L* Aruna Patil    */
/* REVISION: 8.5     LAST MODIFIED: 07/04/97    BY: *H0ZX* Aruna Patil    */
/* REVISION: 8.5     LAST MODIFIED: 08/22/97    BY: *H1C4* Suresh Nayak   */
/* Revision  8.5     Last Modified: 11/28/03    BY: *LB01* Long Bo      */

/*!
    poporcb.p - PERFORM PO RECEIPT & RETURN TRANSACTIONS & POSTINGS
*/

/*!
poporcb.p - CALLED BY poporcm.p, porvism.p
*/

/*!
THE VALUES CONTAINED IN pod_det IN poporcb.p ARE THE VALUES *BEFORE* THE
RECEIPT UPDATE HAS TAKEN PLACE.  WHEN ENTERING poporcb5.p, THE pod_det RECORD
CONTAINS THE VALUES *AFTER* THE RECEIPT UPDATE HAS TAKEN PLACE.
*/

/*GO37*/ {mfdeclre.i}

/*GO37*/ {porcdef.i}

/*GO37*/ /* REORGANIZED VARIABLES */

         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
/*J053*/ define     shared variable rndmthd like rnd_rnd_mthd.
         define new shared variable cr_acct         like trgl_cr_acct extent 6.
         define new shared variable cr_cc           like trgl_cr_cc extent 6.
         define new shared variable cr_proj         like trgl_cr_proj extent 6.
/*H184*/ define new shared variable crtint_amt like trgl_gl_amt.
         define new shared variable dr_acct         like trgl_dr_acct extent 6.
         define new shared variable dr_cc           like trgl_dr_cc extent 6.
         define new shared variable dr_proj         like trgl_dr_proj extent 6.
         define new shared variable entity          like si_entity extent 6.
         define new shared variable gl_amt          like trgl_gl_amt extent 6.
         define new shared variable glx_mthd        like cs_method.
/*F126*/ define new shared frame    hf_prh_hist.
/*F126*/ define new shared stream   hs_prh.
         define new shared variable lotser          like sod_serial.
/*GO37*/ define new shared variable msg-num         like tr_msg.
/*F126*/ define new shared variable new_db          like si_db.
/*F126*/ define new shared variable new_site        like si_site.
/*F126*/ define new shared variable old_db          like si_db.
/*F126*/ define new shared variable old_site        like si_site.
         define new shared variable old_status      like pod_status.
         define new shared variable openqty         like mrp_qty.
/*H184*/ define new shared variable poc_crtacc_acct like gl_crterms_acct.
/*H184*/ define new shared variable poc_crtacc_cc   like gl_crterms_cc.
/*H184*/ define new shared variable poc_crtapp_acct like gl_crterms_acct.
/*H184*/ define new shared variable poc_crtapp_cc   like gl_crterms_cc.
         define new shared variable price           like tr_price.
         define new shared variable project         like prh_project.
         define new shared variable qty_oh          like in_qty_oh.
         define new shared variable qty_ord         like pod_qty_ord.
         define new shared variable rct_site        like pod_site.
         define new shared variable rcv_type        like poc_rcv_type.
         define new shared variable sct_recno       as recid.
         define new shared variable stdcst          like tr_price.
         define new shared variable trqty           like tr_qty_chg.
/*F211*/ define new shared variable undo_all        like mfc_logical no-undo.
         define new shared variable wr_recno        as recid.
/*F164*/ define new shared variable yes_char        as character format "x(1)".
/*GO37*/ define new shared variable conv_to_stk_um  as decimal.
/*GO37*/ define new shared variable cur_mthd        like cs_method.
/*GO37*/ define new shared variable cur_set         like cs_set.
/*GO37*/ define new shared variable curr_yn         like mfc_logical.
/*GO37*/ define new shared variable glx_set         like cs_set.
/*GO37*/ define new shared variable line_tax        like trgl_gl_amt.
/*GO37*/ define new shared variable newbdn_ll       as decimal.
/*GO37*/ define new shared variable newbdn_tl       as decimal.
/*GO37*/ define new shared variable newcst          as decimal.
/*GO37*/ define new shared variable newlbr_ll       as decimal.
/*GO37*/ define new shared variable newlbr_tl       as decimal.
/*GO37*/ define new shared variable newmtl_ll       as decimal.
/*GO37*/ define new shared variable newmtl_tl       as decimal.
/*GO37*/ define new shared variable newovh_ll       as decimal.
/*GO37*/ define new shared variable newovh_tl       as decimal.
/*GO37*/ define new shared variable newsub_ll       as decimal.
/*GO37*/ define new shared variable newsub_tl       as decimal.
/*GO37*/ define new shared variable poddb           like pod_po_db.
/*GO37*/ define new shared variable podpodb         like pod_po_db.
/*GO37*/ define new shared variable pod_entity      like si_entity.
/*GO37*/ define new shared variable pod_po_entity   like si_entity.
/*GO37*/ define new shared variable qty_chg         like tr_qty_loc.
/*GO37*/ define new shared variable reavg_yn        like mfc_logical.
/*GO37*/ define new shared variable trnbr           like op_trnbr.

/*GO37*/ define new shared workfile posub
/*GO37*/                   field    posub_nbr       as character
/*GO37*/                   field    posub_line      as integer
/*GO37*/                   field    posub_qty       as decimal
/*GO37*/                   field    posub_wolot     as character
/*GO37*/                   field    posub_woop      as integer
/*GO37*/                   field    posub_gl_amt    like glt_amt
/*GO37*/                   field    posub_cr_acct   as character
/*GO37*/                   field    posub_cr_cc     as character
/*GO37*/                   field    posub_effdate   as date
/*GO37*/                   field    posub_move      like mfc_logical
/*GO37*/    .

/*GO37**  /*F211*/ define new shared variable transtype as character
 **               format "x(7)" initial "ISS-TR".
 ** /*F085*/ define new shared variable msgref like tr_msg. **/

         /* SHARED VARIABLES, BUFFERS AND FRAMES */
         define     shared variable receivernbr like prh_receiver.
/*H074*/ define     shared variable fiscal_rec  like mfc_logical init false.
/*H074*/ define     shared workfile tax_wkfl
/*H074*/                  field tax_nbr         like pod_nbr
/*H074*/                  field tax_line        like pod_line
/*H074*/                  field tax_env         like pod_tax_env
/*H074*/                  field tax_usage       like pod_tax_usage
/*H074*/                  field tax_taxc        like pod_taxc
/*H074*/                  field tax_in          like pod_tax_in
/*H074*/                  field tax_taxable     like pod_taxable
/*H074*/                  field tax_price       like prh_pur_cost.

/*#247** define     shared variable mfguser     as character. **/
/*J038*/ define shared variable vendlot like tr_vend_lot no-undo.


         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
         define variable i                  as integer.
/*H210*/ define variable nonrecov_tax       like tx2d_tottax.
/*H511*/ define variable tax_lines          like tx2d_line initial 0.
/*G0QG*/ define variable del-yn             like mfc_logical no-undo.
/*H0ZX*/ define variable poc_seq_rcv like mfc_logical initial yes no-undo.

/*GO37** MADE SHARED TO SUPPORT POPORCB6.P
.         define variable conv_to_stk_um     as decimal.
.         define variable cur_mthd           like cs_method.
.         define variable cur_set            like cs_set.
.         define variable curr_yn            like mfc_logical.
.         define variable glx_set            like cs_set.
.         define variable line_tax           like trgl_gl_amt.
.         define variable newbdn_ll          as decimal.
.         define variable newbdn_tl          as decimal.
.         define variable newcst             as decimal.
.         define variable newlbr_ll          as decimal.
.         define variable newlbr_tl          as decimal.
.         define variable newmtl_ll          as decimal.
.         define variable newmtl_tl          as decimal.
.         define variable newovh_ll          as decimal.
.         define variable newovh_tl          as decimal.
.         define variable newsub_ll          as decimal.
.         define variable newsub_tl          as decimal.
.         define buffer   poddet             for pod_det.
.         define variable poddb              like pod_po_db.
.         define variable podpodb            like pod_po_db.
.         define variable pod_entity         like si_entity.
.         define variable pod_po_entity      like si_entity.
.         define variable qty_chg            like tr_qty_loc.
.         define variable reavg_yn           like mfc_logical.
.         define variable trnbr              like op_trnbr.
*GO37**/

/*GO37 ** MOVED THE FOLLOWING VARIABLES TO porcdef.i **
.         define     shared variable base_amt like pod_pur_cost.
.         define     shared variable eff_date like glt_effdate.
.         define     shared variable exch_rate like exd_rate.
.         define new shared variable location like sod_loc.
.         define new shared variable lotref like sr_ref.
.         define     shared variable move like mfc_logical.
.         define     shared variable po_recno as recid.
.         define new shared variable pod_recno as recid.
.         define     shared variable porec like mfc_logical no-undo.
.         define     shared variable ps_nbr like prh_ps_nbr.
.         define     shared variable ref like glt_ref.
.         define     shared variable qopen like pod_qty_rcvd label "Qty Open".
.         define     shared variable shipper_rec  like mfc_logical init false.
.         define new shared variable site like sod_site.
.         define     shared variable wolot like pod_wo_lot no-undo.
.         define     shared variable woop like pod_op no-undo.
 *GO37** END MOVED **/

/*J0CV*/  define input parameter ship_date like prh_ship_date no-undo.
/*G2FT*/  define            variable tax_date like tax_effdate no-undo.
/*G2FT*/  define new shared variable tax_recno as recid.
/*H1C4*/  define new shared variable l_next_line like pod_line no-undo .

/*GO37** {mfdeclre.i}  **/

        /*F164 FIND FIRST CHARACTERS OF YES/NO IN mfc_logical for u.s. taxes*/
        /*GA61 COMMENTED FOLLOWING SECTION*****************************
        find first _field where _field-name = "mfc_logical".        *
        yes_char = CAPS(substring(_format,1,1)).                    *
        **GA61 END SECTION********************************************/

        /*GA61 ADDED FOLLOWING SECTION*/
        {gpfieldv.i}
        {gpfield.i &field_name='"mfc_logical"'}
        yes_char = "Y".
        if field_found then yes_char = caps(substr(field_format,1,1)).
        /*GA61 END SECTION*/

/*GB26*/ find first gl_ctrl no-lock.

/*H511** MOVED BELOW **
 ** /*H074*/ /* IF FISCAL RECEIVING THEN BY PASS POPORCX.P */
 ** /*H074*  if {txnew.i} and receivernbr > ""   then do: */
 ** /*H074*/ if {txnew.i} and receivernbr > "" and fiscal_rec = no  then do:
 ** /*H210*/    {gprun.i ""poporcx.p""}
 ** /*H210*/ end. **/

/*F126*/ FORM /*GUI*/  prh_hist with frame hf_prh_hist THREE-D /*GUI*/.

/*F126*/ {mfoutnul.i &stream_name="hs_prh"}

         find po_mstr where recid(po_mstr) = po_recno.
         find first poc_ctrl no-lock no-error.
         rcv_type = poc_rcv_type.
         find first gl_ctrl no-lock.

/*H0ZX*/ find first mfc_ctrl where mfc_field = "poc_seq_rcv" no-lock no-error.
/*H0ZX*/ if available mfc_ctrl then
/*H0ZX*/    poc_seq_rcv =  mfc_logical.

/*H074*/ /* IF FISCAL RECEIVING THEN BY PASS POPORCX.P */
/*H511*/ if {txnew.i} and receivernbr > "" and fiscal_rec = no
/*H511*/ and rcv_type <> 2 then do:
/*H511*/    tax_lines = 0.
/*H511*/    {gprun.i ""poporcx.p"" "( input tax_lines )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H511*/ end.

/*H074*  if {txnew.i} and receivernbr > ""   then do: */
/*H511* /*H074*/ if {txnew.i} and receivernbr > "" and fiscal_rec = no  then do:
 ** /*H210*/    {gprun.i ""poporcx.p""}
 **      end.  **/

/*H184*/ assign crtint_amt = 0.

/*G1MS*** /* Moved to inside of pod_det loop so that receiver numbers are not
        *    consumed from the control file if no receipt is actually done */
/*FN24*/*if (rcv_type <> 2 and receivernbr = "") then do transaction :
/*FN24*/*         {mfnctrlc.i
        *            poc_ctrl
        *            poc_rcv_pre
        *            poc_rcv_nbr
        *            prh_hist
        *            prh_receiver
        *            receivernbr}
        *
/*FN24*/*   if {txnew.i} and fiscal_rec = no  then do:
/*H511*/*      tax_lines = 0.
/*H511*/*      {gprun.i ""poporcx.p"" "( input tax_lines )"}
/*H511*** /*FN24*/ {gprun.i ""poporcx.p""} **/
/*FN24*/*   end.
/*FN24*/*end.
**G1MS***/ /* End of moved section */

/*H0ZX*/ /* GENERATE RECEIVER NUMBER FOR RECEIVER TYPE = 1 WHEN SEQUENTIAL */
/*H0ZX*/ /* RECEIVER NOT REQUIRED */
/*H0ZX*/ if (rcv_type = 1 and receivernbr = "" and not poc_seq_rcv)
/*H0ZX*/ then do transaction :
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0ZX*/     {mfnctrlc.i
            poc_ctrl
            poc_rcv_pre
            poc_rcv_nbr
            prh_hist
            prh_receiver
            receivernbr}
/*H0ZX*/     if {txnew.i} and fiscal_rec = no  then do:
/*H0ZX*/        tax_lines = 0.
/*H0ZX*/        {gprun.i ""poporcx.p"" "( input tax_lines )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0ZX*/     end. /* IF {txnew.i} AND */
/*H0ZX*/ end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* END OF TRANSACTION  */

/*G2FT*/    if not {txnew.i} and not gl_can and not gl_vat then
/*G2FT*/    do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2FT*/       if po_tax_date = ? then tax_date = eff_date.
/*G2FT*/       else tax_date = po_mstr.po_tax_date.
/*G2FT*/       if tax_date = ? then tax_date = today.

/*G2FT*/       find ad_mstr where ad_addr = po_ship no-lock no-error.
/*G2FT*/           {gprun.i ""gptax.p"" "(input ad_state,
                                      input ad_county,
                                      input ad_city,
                                      input tax_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G2FT*/       find tax_mstr where recid(tax_mstr) = tax_recno no-lock no-error.
/*G2FT*/       if available tax_mstr then
/*G2FT*/          assign po_tax_pct[1] = tax_tax_pct[1]
/*G2FT*/                 po_tax_pct[2] = tax_tax_pct[2]
/*G2FT*/                 po_tax_pct[3] = tax_tax_pct[3].
/*G2FT*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* end of if us tax                                    */

/*F211*/ podloop:

/*GO37** RESTRUCTED LOGIC TO HANDLE PO RETURNS AS WELL AS RECEIPTS & FS RTV **
.         for each pod_det exclusive
.         where pod_nbr = po_nbr and pod_status <> "c"
.         and pod_status <> "x" and (pod_qty_chg <> 0 or pod_bo_chg = 0)
./*FP92*/ and ((not porec and pod_rma_type <> "I" and pod_rma_type <> "") or
./*FP92*/      (porec and pod_rma_type <> "O"))
./*H074*/ and((shipper_rec and pod_qty_chg <> 0 ) or not shipper_rec)
./*H074*/ and((pod_sched and pod_qty_chg <> 0 ) or not pod_sched)
.         break by pod_part:
*GO37** END **/

/*GO37*/ for each pod_det exclusive-lock
         where pod_nbr = po_nbr and
         (  (is-return and pod_qty_chg <> 0)
         or ( (not is-return) and
                 pod_status <> "c"
             and pod_status <> "x" and (pod_qty_chg <> 0 or pod_bo_chg = 0)
             and ((not porec and pod_rma_type <> "I" and pod_rma_type <> "") or
                  (porec and pod_rma_type <> "O"))
             and ((shipper_rec and pod_qty_chg <> 0 ) or not shipper_rec)
             and ((pod_sched and pod_qty_chg <> 0 ) or not pod_sched)
            )  )
         break by pod_part:
/*GUI*/ if global-beam-me-up then undo, leave.


/*FP92*/    /* Include RTS logic in for each statement. So first-of  */
/*FP92*/    /* pod_part logic works for receiver number generation,  */
/*FP92*/    /* when receipt is transacted before the issue.          */
/*FP92*/    /* if  porec then do:                                    */
/*FP92*/    /*     if  pod_rma_type <> "I"  and                      */
/*FP92*/    /*         pod_rma_type <> ""   then                     */
/*FP92*/    /*         next podloop.                                 */
/*FP92*/    /* end.                                                  */
/*FP92*/    /* else do:                                              */
/*FP92*/    /*     if  pod_rma_type <> "O" then                      */
/*FP92*/    /*         next podloop.                                 */
/*FP92*/    /* end.                                                  */

/*H074*/    /* IF FISCAL RECEIVING OR SHIPPER CONFIRM  HAS NOT RECEIVED THE
/*H074*/                POD_DET THEN SKIP */
/*H074*/    if shipper_rec and  pod_qty_chg = 0 then next podloop.

/*F177*/    find si_mstr where si_site = pod_site no-lock no-error.

/*F177*/    if available si_mstr and si_db = global_db then do:

/*H0SL  price = pod_pur_cost * (1 - (pod_disc_pct / 100)) / pod_um_conv. */

/*H0SL*/       if ((pod__qad02 = 0 or pod__qad02 = ?) and
/*H0SL*/           (pod__qad09 = 0 or pod__qad09 = ?)) then
/*H0SL*/
/*H0SL*/          price = pod_pur_cost *
/*H0SL*/                  (1 - (pod_disc_pct / 100)) / pod_um_conv.
/*H0SL*/       else
/*H0SL*/
/*H0SL*/          price = (pod__qad09 + (pod__qad02 / 100000)) / pod_um_conv.

/*H074*/       find first  tax_wkfl
/*H074*/          where tax_nbr = pod_nbr and  tax_line = pod_line no-error.
/*H074*/       if available tax_wkfl then do:

/*H0MK*       FIELD abs__qad07 STORES THE PRICE WHICH IS ALREADY DISCOUNTED. */
/*H0MK*       THIS PRICE IS ASSIGEND TO tax_price. THIS PART OF THE CODE IS  */
/*H0MK*       MODIFIED TO AVOID DISCOUNTING THE PRICE WHICH IS ALREADY       */
/*H0MK*       DISCOUNTED.                                                    */
/*H0MK** /*H074*/  price = tax_price *                                       */
/*H0MK** /*H074*/          (1 - (pod_disc_pct / 100)) / pod_um_conv.         */
/*H0MK*/       price = tax_price / pod_um_conv.
/*H074*/       end.

/*F0V7*/       /* IF receipt_um = pt_um, THE CONVERSION FACTOR SHOULD BE 1. */
/*F0V7*/       /* DUE TO TRUNCATION, conv_to_pod_um * pod_um_conv DOESN'T   */
/*F0V7*/       /* ALWAYS EQUAL 1, LEADING TO INVENTORY PROBLEMS             */

/*F0V7*/       find pt_mstr no-lock where pt_part = pod_part no-error.
/*F0V7*/       if available pt_mstr and pt_um = pod_rum
/*F0V7*/       then conv_to_stk_um = 1.
/*F0V7*/       else
/*F070*/          conv_to_stk_um = pod_rum_conv * pod_um_conv.
               old_status = pod_status.

/*H19L**       if (first-of(pod_part) and rcv_type = 2)     */
/*H19L*/       if (first-of(pod_part) and rcv_type = 2 and receivernbr = " ")
/*H0ZX**       or (rcv_type <> 2 and receivernbr = "") then do:  */
/*H0ZX*/       or (rcv_type <> 2 and receivernbr = "" and poc_seq_rcv) then do:
/*F126*/          {mfnctrlc.i
                     poc_ctrl
                     poc_rcv_pre
                     poc_rcv_nbr
                     prh_hist
                     prh_receiver
                     receivernbr}
/*G1MS*        end. */

/*G1MS*  /*H618*/ if rcv_type = 2 and {txnew.i} and fiscal_rec = no then do: */
/*H0KT /*G1MS*/   if {txnew.i} and fiscal_rec = no then do:                  */
/*H0KT /*H511*/      tax_lines = pod_line.                                   */
/*H0ZX** /*H0KT*/ if rcv_type <> 2 and {txnew.i} and fiscal_rec = no then do:*/
/*H0ZX*/          if rcv_type <> 2 and {txnew.i} and fiscal_rec = no and
/*H0ZX*/          poc_seq_rcv then do:
/*H0KT*/             tax_lines = 0.
/*H511*/          {gprun.i ""poporcx.p"" "( input tax_lines )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H618*/       end.

/*G1MS*/       end.

/*H0KT*/       if rcv_type = 2 and {txnew.i} and fiscal_rec = no then do:
/*H0KT*/          tax_lines = pod_line.
/*H0KT*/          {gprun.i ""poporcx.p"" "( input tax_lines )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0KT*/       end.

/*GO37*/       if not is-return then do:
                  {mfpotr.i "DELETE" "RECEIPT"}
/*GO37*/       end.

               /* GET ITEM MASTER INFORMATION */

               /*F003******************************************************/
               /*F003  MODIFIED THE CODE UPTO THE for each sr_wkfl BLOCK  */
               /*F003  EXTENSIVELY MODIFIED for each sr_wkfl BLOCK BELOW  */
               /*F003******************************************************/

               find first icc_ctrl no-lock.
               stdcst = 0.
/*GO37*/       if is-return then move = no.


/*F0JC         find pt_mstr where pt_part = pod_part exclusive no-error.*/
/*F0JC*/       find pt_mstr where pt_part = pod_part no-lock no-error.
               if available pt_mstr then do:
/*FM94*/          pt_recno = recid(pt_mstr).
                  find pl_mstr where pl_prod_line = pt_prod_line
                  no-lock no-error.

                  if pod_type = "" then do:
                     {gpsct06.i &part=pt_part &site=pod_site &type=""GL""}
                     sct_recno = recid(sct_det).
/*F085               stdcst = sct_cst_tot.                                 */
                  end.
/*FM94*/          else  sct_recno = ?.

                  /*DETERMINE COSTING METHOD*/
/*F085*/          {gprun.i ""csavg01.p"" "(input pt_part,
                                           input pod_site,
                                           output glx_set,
                                           output glx_mthd,
                                           output cur_set,
                                           output cur_mthd)"
                  }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F085*/          curr_yn = yes.
/*F085*/          if can-find(wr_route where wr_lot = wolot and wr_op = woop)
/*F085*/          or glx_mthd = "AVG" then curr_yn = no.


/*G1QK /*F085*/   if not pod_cst_up or pod_type <> "" then glx_mthd = ?.    */
/*F085*/          if not pod_cst_up or (pod_type <> "" and pod_type <> "S")
/*F085*/          then cur_mthd = ?.

/*F085*/          /*UPDATE CURRENT COST & POST ANY GL DISCREPANCY*/
/*F085*/          /*CALCULATE AMOUNTS TO AVERAGE BY COST CATEGORY*/
/*F085*/          if glx_mthd = "AVG" or cur_mthd = "AVG"
/*F085*/          or cur_mthd = "LAST" then do:
/*F085*/             if po_curr <> base_curr
/*F085*/             then base_amt = price / exch_rate.
/*F085*/             else base_amt = price.

/*H210*/             qty_chg = pod_qty_chg * conv_to_stk_um.
/*GO37*/             if is-return then qty_chg = - qty_chg.

/*H210*/             if {txnew.i} then do:
/*H210*/                nonrecov_tax = 0.
/*H210*/                /* REMOVE RECOVERABLE TAX FROM COST BASIS */
/*GO37** /*H210*/       for each tx2d_det where tx2d_tr_type = '21' and **/

/*GO37*/                for each tx2d_det where tx2d_tr_type = tax_tr_type and
/*H210*/                tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
/*H210*/                tx2d_line = pod_line
                        no-lock:
/*H365*/                    if substring(tx2d__qad02,33,1) <> 'y' then
/*H210*/                        nonrecov_tax = nonrecov_tax + tx2d_taxamt[1] -
/*H210*/                                tx2d_ntaxamt[5].
/*H365*/                    else
/*H365*/                        nonrecov_tax = nonrecov_tax - tx2d_ntaxamt[5].
/*H210*/                end.
/*H210*/                base_amt = price + (nonrecov_tax / qty_chg).
/*H210*/                if po_curr <> base_curr
/*H210*/                then base_amt = base_amt / exch_rate.
/*H210*/             end.
/*H210*/             else do:
/*GO37*/                /* If U.S. taxes, add taxes to total cost */
/*GO37*/                if pod_taxable
/*GO37*/                and not gl_vat and not gl_can
/*GO37*/                then do:
/*GO37*/                   line_tax = 0.
/*GO37*/                   do i = 1 to 3:
/*GO37*/                      line_tax = line_tax +
/*GO37*/                      base_amt * (po_tax_pct[i] / 100).
/*GO37*/                   end.
/*GO37*/                   base_amt = base_amt + line_tax.
/*GO37*/                end.
/*GO37** /*F085*/                if po_curr <> base_curr
 **      /*F085*/                then base_amt = price / exch_rate.
 **      /*F085*/                else base_amt = price. **/
/*H210*/             end.
/*H210** /*F085*/             qty_chg = pod_qty_chg * conv_to_stk_um. **/

/*F085*/             if pod_type = "" then do:
/*GO37**                                         input ""RCT-PO"", **/
/*F085*/                {gprun.i ""csavg02.p"" "(input pt_part,
                                                 input pod_site,
                                                 input transtype,
                                                 input recid(pt_mstr),
                                                 input po_nbr,
                                                 input qty_chg,
                                                 input base_amt,
                                                 input glx_set,
                                                 input glx_mthd,
                                                 input cur_set,
                                                 input cur_mthd,
                                                 output newmtl_tl,
                                                 output newlbr_tl,
                                                 output newbdn_tl,
                                                 output newovh_tl,
                                                 output newsub_tl,
                                                 output newmtl_ll,
                                                 output newlbr_ll,
                                                 output newbdn_ll,
                                                 output newovh_ll,
                                                 output newsub_ll,
                                                 output newcst,
                                                 output reavg_yn,
                                                 output msg-num)" /*GO37*/
/*GO37**                                         output msgref)" **/
                        }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F085*/             end.
/*F085*/             else if pod_type = "S" and curr_yn then do:
/*F085*/                {gprun.i ""csavg02.p"" "(input pt_part,
                                                 input pod_site,
                                                 input ""PO-SUB"",
                                                 input recid(pt_mstr),
                                                 input po_nbr,
                                                 input qty_chg,
                                                 input base_amt,
                                                 input glx_set,
                                                 input glx_mthd,
                                                 input cur_set,
                                                 input cur_mthd,
                                                 output newmtl_tl,
                                                 output newlbr_tl,
                                                 output newbdn_tl,
                                                 output newovh_tl,
                                                 output newsub_tl,
                                                 output newmtl_ll,
                                                 output newlbr_ll,
                                                 output newbdn_ll,
                                                 output newovh_ll,
                                                 output newsub_ll,
                                                 output newcst,
                                                 output reavg_yn,
                                                 output msg-num)" /*GO37*/
/*GO37**                                         output msgref)" **/
                        }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F085*/             end.
/*F085*/          end. /*if glx_mthd = ...*/
               end.  /*if available pt_mstr*/
/*FM94*/       else  sct_recno = ?.

               find si_mstr where si_site = pod_site no-lock.
               pod_entity = si_entity.
/*F126*/       poddb = si_db.

               if pod_po_site <> "" then
                  find si_mstr where si_site = pod_po_site no-lock.
               pod_po_entity = si_entity.
/*F126*/       podpodb = si_db.

               project = pod_project.
               rct_site = pod_site.

/*FM94*/       pod_recno = recid(pod_det).

/*GO37*/       /* MOVED THE WHOLE SR_LOOP TO POPORCB6.P */
/*GO37*/       /* SUBROUTINE CREATE DUE TO R CODE SIZE  */
/*GO37*/       /* ROUTINE CREATE TR_HIST , POST TO DIFFERENT APPLICABLE */
/*GO37*/       /* GL ACCOUNTS                                         */

/*FM94*/       if undo_all then undo podloop, next podloop.
/*GO37*/       assign
                  pt_recno  = recid(pt_mstr)
                  pod_recno = recid(pod_det)
                  po_recno  = recid(po_mstr)
                  wr_recno  = recid(wr_route).

/*FM94*/          /* MOVED THE WHOLE SR_LOOP TO POPORCB6.P */
/*FM94*/          /* SUBROUTINE CREATE DUE TO R CODE SIZE  */
/*FM94*/          /* ROUTINE CREATE TR_HIST , POST TO DIFFERENT APPLICABLE */
/*FM94*/          /* GL ACCOUNTS                                         */
/*LB01*/          {gprun.i ""zzpoporcb6.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FM94*/       if undo_all then undo podloop, next podloop.

/*F211*/       if  pod_qty_chg <> 0 then do:
/*F211*/
/*F211*/           find rmd_det
/*F211*/                where rmd_nbr      = pod_nbr
/*F211*/                and   rmd_prefix   = "V"
/*F211*/                and   rmd_line     = pod_line
/*F211*/                no-error.
/*F211*/
/*F211*/           /*******************************************/
/*F211*/           /* Update receive/ship date and qty in rma */
/*F211*/           /*******************************************/
/*F211*/
/*F211*/           if  available rmd_det then do:
/*F211*/
/*F211*/               if  rmd_type = "O" then
/*F211*/                   rmd_qty_acp  = - (pod_qty_rcvd + pod_qty_chg).
/*F211*/               else
/*F211*/                   rmd_qty_acp  =   pod_qty_rcvd + pod_qty_chg.
/*F211*/
/*H0QF*/               if rmd_qty_acp <> 0 then
/*F211*/                    rmd_cpl_date =   eff_date.
/*H0QF*/               else rmd_cpl_date = ?.
/*F211*/
/*F211*/           end.
/*F211*/
/*F211*/       end. /**********end pod_qty_chg*************/

/*F085*/       /*MOVED FOLLOWING SECTION TO POPORCB2.P*/
/*F819*/       pod_recno = recid(pod_det).

/*J0CV /*F085*/       {gprun.i ""poporcb2.p""} */
/*LB01*/       {gprun.i ""zzpoporcb2.p"" "(input ship_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* POST THE CREDIT TERMS INTEREST COMPONENT OF THE ITEM PRICE */
               /* TO A STATISCAL ACCCOUNT FOR THE PO RECEIPT.                */
/*LB01*/       {gprun.i ""zzpoporcb4.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


/*F177*/    end.  /* if available si_mstr and si_db = global_db */

/*H19L*/    if last-of(pod_part) and rcv_type = 2 then
/*H19L*/       receivernbr = "".

     end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* for each pod_det */

/*H210** MOVED TO poporcb4.p **                                        */
/*H184*/ /* POST THE CREDIT TERMS INTEREST COMPONENT OF THE ITEM PRICE */
/*H184*/ /* TO A STATISCAL ACCCOUNT FOR THE PO RECEIPT.                */
/*H0K5   RELOCATED poporcb4.p CALL TO BE WITHIN pod_det BLOCK
 *H0K5 /*H210*/ {gprun.i ""zzpoporcb4.p""} */

/*GO37*/ if not po_sched then do:
            close-po:
            do transaction on error undo, leave:
               if po_stat <> "c" then do:
                  for each pod_det where pod_nbr = po_nbr:
                     if pod_status <> "c" and pod_status <> "x" then
                        leave close-po.
                  end.
                  po_stat = "c".
                  po_cls_date = today.
               end.
            end.
/*GO37*/ end.

         /*GO37 SUBCONTRACT PROCESSING FOR NEW REPETITIVE*/
/*LB01*/     {gprun.i ""zzporcsubr.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

