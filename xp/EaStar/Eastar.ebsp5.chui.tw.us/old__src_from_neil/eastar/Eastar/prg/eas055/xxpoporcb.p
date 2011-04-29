/* poporcb.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*  $Revision: 1.43.1.2 $                                                        */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.0      LAST MODIFIED: 11/19/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: RAM *F070*               */
/* REVISION: 7.0      LAST MODIFIED: 01/02/92   BY: WUG *F034*               */
/* REVISION: 7.0      LAST MODIFIED: 01/31/92   BY: RAM *F126*               */
/* REVISION: 7.0      LAST MODIFIED: 02/05/92   BY: RAM *F170*               */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: RAM *F177*               */
/* REVISION: 7.0      LAST MODIFIED: 02/10/92   BY: MLV *F164*               */
/* REVISION: 7.0      LAST MODIFIED: 02/14/92   BY: SAS *F211*               */
/* REVISION: 7.0      LAST MODIFIED: 02/24/92   BY: sas *F211*               */
/* REVISION: 7.0      LAST MODIFIED: 02/24/92   BY: pma *F085*               */
/* REVISION: 7.0      LAST MODIFIED: 03/09/92   BY: pma *F086*               */
/* REVISION: 7.0      LAST MODIFIED: 07/30/92   BY: ram *F819*               */
/* REVISION: 7.3      LAST MODIFIED: 09/29/92   BY: tjs *G028*               */
/* REVISION: 7.3      LAST MODIFIED: 11/10/92   BY: pma *G304*               */
/* REVISION: 7.3      LAST MODIFIED: 02/11/93   BY: tjs *G675*               */
/* REVISION: 7.3      LAST MODIFIED: 04/30/93   BY: WUG *GA61*               */
/* REVISION: 7.3      LAST MODIFIED: 05/21/93   BY: kgs *GB26*               */
/* REVISION: 7.3      LAST MODIFIED: 07/07/93   BY: afs *GD28*               */
/* REVISION: 7.3      LAST MODIFIED: 07/08/93   BY: cdt *GD29*               */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 11/04/93   BY: bcm *H210*               */
/* REVISION: 7.4      LAST MODIFIED: 11/12/93   BY: afs *H219*               */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: afs *H227*               */
/* REVISION: 7.4      LAST MODIFIED: 03/22/94   BY: dpm *FM94*               */
/* REVISION: 7.4      LAST MODIFIED: 04/08/94   BY: dpm *H074*               */
/* REVISION: 7.4      LAST MODIFIED: 05/04/94   BY: bcm *H365*               */
/* REVISION: 7.4      LAST MODIFIED: 04/15/94   BY: dpm *FN24*               */
/* REVISION: 7.4      LAST MODIFIED: 08/08/94   BY: cdt *FP92*               */
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: bcm *H511*               */
/* REVISION: 8.5      LAST MODIFIED: 10/31/94   BY: taf *J038*               */
/* REVISION: 7.4      LAST MODIFIED: 11/10/94   BY: bcm *GO37*               */
/* REVISION: 7.4      LAST MODIFIED: 12/07/94   BY: bcm *H618*               */
/* REVISION: 7.4      LAST MODIFIED: 02/16/95   BY: jxz *F0JC*               */
/* REVISION: 7.4      LAST MODIFIED: 07/19/95   BY: rxm *G0QG*               */
/* REVISION: 7.4      LAST MODIFIED: 09/12/95   BY: ais *F0V7*               */
/* REVISION: 8.5      LAST MODIFIED: 10/13/95   BY: taf *J053*               */
/* REVISION: 7.4      LAST MODIFIED: 02/08/96   BY: emb *G1MS*               */
/* REVISION: 8.5      LAST MODIFIED: 02/06/96   BY: *J0CV* Robert Wachowicz  */
/* REVISION: 8.5      LAST MODIFIED: 03/25/96   BY: *G1QK* Arthur Schain     */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *H0K5* Robin McCarthy    */
/* REVISION: 8.5      LAST MODIFIED: 05/02/96   BY: *H0KT* Robin McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   BY: *K008* Jeff Wootton      */
/* REVISION: 8.6      LAST MODIFIED: 09/04/96   BY: *H0MK* Sanjay D. Patil   */
/* REVISION: 8.6      LAST MODIFIED: 10/11/96   BY: *G2FT* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* Jeff Wootton      */
/* REVISION: 8.6      LAST MODIFIED: 01/08/97   BY: *H0QF* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 02/20/97   BY: *H0SL* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 06/18/97   BY: *H19L* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 07/04/97   BY: *H0ZX* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 08/22/97   BY: *H1C4* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 02/13/98   BY: *H1JM* Nirav Parikh      */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *L020* Charles Yen       */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L062* Steve Nugent      */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *J2WP* Irine D'mello     */
/* REVISION: 8.6E     LAST MODIFIED: 12/01/98   BY: *L0CN* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 12/04/98   BY: *H1N8* Felcy D'Souza     */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/22/99   BY: *J37F* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 03/26/99   BY: *L0DM* Kedar Deherkar    */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 07/21/99   BY: *J3JP* Prashanth Narayan */
/* REVISION: 9.0      LAST MODIFIED: 09/03/99   BY: *K22C* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* PATTI GAULTNEY    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.39     BY: Jack Rief             DATE: 07/20/00 ECO: *N0DK*   */
/* REVISION: 1.40     BY: Mark Brown            DATE: 08/13/00 ECO: *N0KQ*   */
/* Revision: 1.41     BY: Markus Barone         DATE: 07/20/00 ECO: *N0R3*   */
/* Revision: 1.42     BY: Murali Ayyagari       DATE: 11/06/00 ECO: *N0V1*   */
/* Revision: 1.43     BY: Manish K.             DATE: 01/12/01 ECO: *N0VL*   */
/* Revision: 1.43.1.1 BY: Steve Nugent          DATE: 06/05/01 ECO: *M11Z*   */
/*$Revision: 1.43.1.2 $ BY: Vivek Dsilva          DATE: 03/18/02 ECO: *N1D0*   */
/* REVISION: eB(SP5)     LAST MODIFIED: 08/16/06    BY: Apple      *EAS055A*   */
/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO            */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST             */
/* STATEMENTS FOR ORACLE PERFORMANCE.                                       */

         /*!
          * poporcb.p - PERFORM PO RECEIPT & RETURN TRANSACTIONS & POSTINGS
          */

         /*!
          * poporcb.p - CALLED BY poporcm.p, porvism.p
          */

         /*!
          * The values contained in pod_det in poporcb.p are the values
          * *before* the receipt update has taken place.  When entering
          * poporcb5.p, the pod_det record contains the values *after* the
          * receipt update has taken place.
*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* Define Handles for the programs. */
{pxphdef.i porcxr}
{pxphdef.i porcxr1}
/* End Define Handles for the programs. */


/* PARAMETERS */
define input parameter shipnbr           like tr_ship_id      no-undo.
define input parameter ship_date         like prh_ship_date   no-undo.
define input parameter inv_mov           like tr_ship_inv_mov no-undo.
define input parameter i_shipto like abs_shipto      no-undo.
define input parameter auto_receipt      like mfc_logical  no-undo.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable cr_acct         like trgl_cr_acct extent 6.
define new shared variable cr_sub          like trgl_cr_sub extent 6.
define new shared variable cr_cc           like trgl_cr_cc extent 6.
define new shared variable cr_proj         like trgl_cr_proj extent 6.
define new shared variable crtint_amt      like trgl_gl_amt.
define new shared variable dr_acct         like trgl_dr_acct extent 6.
define new shared variable dr_sub          like trgl_dr_sub extent 6.
define new shared variable dr_cc           like trgl_dr_cc extent 6.
define new shared variable dr_proj         like trgl_dr_proj extent 6.
define new shared variable entity          like si_entity extent 6.
define new shared variable gl_amt          like trgl_gl_amt extent 6.

define new shared frame    hf_prh_hist.
define new shared stream   hs_prh.
define new shared variable lotser          like sod_serial.

define new shared variable new_db          like si_db.
define new shared variable new_site        like si_site.
define new shared variable old_db          like si_db.
define new shared variable old_site        like si_site.
define new shared variable old_status      like pod_status.
define new shared variable openqty         like mrp_qty.

define new shared variable price           like tr_price.
define new shared variable project         like prh_project.
define new shared variable qty_oh          like in_qty_oh.


define new shared variable rcv_type        like poc_rcv_type.

define new shared variable stdcst          like tr_price.
define new shared variable trqty           like tr_qty_chg.


define new shared variable yes_char        as  character format "x(1)".

define new shared variable trnbr           like op_trnbr.
define new shared variable tax_recno       as   recid.
define new shared variable undo_all        like mfc_logical no-undo.
define new shared variable l_next_line     like pod_line no-undo.

define new shared workfile posub
   field    posub_nbr       as   character
   field    posub_line      as   integer
   field    posub_qty       as   decimal
   field    posub_wolot     as   character
   field    posub_woop      as   integer
   field    posub_gl_amt    like glt_amt
   field    posub_cr_acct   as   character
   field    posub_cr_sub    as   character
   field    posub_cr_cc     as   character
   field    posub_effdate   as   date
   field    posub_site      like sr_site
   field    posub_loc       like sr_loc
   field    posub_lotser    like sr_lotser
   field    posub_ref       like sr_ref
   field    posub_move      as   logical
   .

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define     shared variable rndmthd         like rnd_rnd_mthd.
define     shared variable vendlot         like tr_vend_lot no-undo.
define     shared variable qopen           like pod_qty_rcvd.
define     shared variable receipt_date    like prh_rcp_date no-undo.
define     shared variable receivernbr     like prh_receiver.
define     shared variable fiscal_rec      as   logical initial false.
define     shared workfile tax_wkfl
   field tax_nbr         like pod_nbr
   field tax_line        like pod_line
   field tax_env         like pod_tax_env
   field tax_usage       like pod_tax_usage
   field tax_taxc        like pod_taxc
   field tax_in          like pod_tax_in
   field tax_taxable     like pod_taxable
   field tax_price       like prh_pur_cost.

{porcdef.i}

/* LOCAL VARIABLES, BUFFERS AND FRAMES */


define variable tax_lines       like tx2d_line initial 0 no-undo.

define variable tax_date        like tax_effdate  no-undo.
define variable poc_seq_rcv     like mfc_logical initial yes no-undo.

define variable l_last_receiver like prh_receiver no-undo.
define variable comb_exch_rate  like exr_rate     no-undo.
define variable comb_exch_rate2 like exr_rate2    no-undo.


&if defined(gpfieldv) = 0 &then
   &global-define gpfieldv
   {gpfieldv.i}
&endif

{gpfield.i &field_name='"mfc_logical"'}
yes_char = getTermLabel("YES",1).
if field_found then yes_char = substring(field_format,1,1).

for first gl_ctrl
      fields (gl_can gl_vat) no-lock:
end. /* FOR FIRST GL_CTRL */


form prh_hist with frame hf_prh_hist.

find po_mstr where recid(po_mstr) = po_recno exclusive-lock.
{pxrun.i &PROC = 'getReceiverPolicy' &PROGRAM = 'porcxr.p'
          &HANDLE=ph_porcxr
         &PARAM = "(output rcv_type,
                    output poc_seq_rcv)"
         &CATCHERROR = TRUE
         &NOAPPERROR = TRUE
}

/* If fiscal receiving then by pass poporcx.p */
if {txnew.i} and receivernbr > "" and
   fiscal_rec = no and rcv_type <> 2 then do:
   tax_lines = 0.
   {gprun.i ""poporcx.p"" "( input tax_lines )" }
end.

crtint_amt = 0.

/* Generate receiver number for receiver type = 1 when sequential */
/* receiver not required */

/* Now also generate receiver number for receiver type = 0 when     */
/*eas055*****************************/
       if length(receivernbr) <= 1 then do:
	  {xxdncreate.i}
       end.
/*eas055*****************************/

if (rcv_type <> 2 and receivernbr = "" and not poc_seq_rcv)
then do:

   {mfnctrlc.i
      poc_ctrl
      poc_rcv_pre
      poc_rcv_nbr
      prh_hist
      prh_receiver
      receivernbr}

   if {txnew.i} and fiscal_rec = no  then do:
      tax_lines = 0.
      {gprun.i ""poporcx.p"" "( input tax_lines )" }
   end. /* if {txnew.i} and */
end. /* End of transaction  */

if not {txnew.i} and not gl_can and not gl_vat then do:

   if po_tax_date = ? then tax_date = eff_date.
   else tax_date = po_mstr.po_tax_date.
   if tax_date = ? then tax_date = today.

   for first ad_mstr
         fields(ad_addr ad_city ad_county ad_state)
         where ad_addr = po_ship no-lock:
   end. /* FOR FIRST AD_MSTR */

   {gprun.i ""gptax.p""
      "(input ad_state,
                 input ad_county,
                 input ad_city,
                 input tax_date)" }

   for first tax_mstr
         fields(tax_tax_pct)
         where recid(tax_mstr) =  tax_recno no-lock:
   end. /* FOR FIRST TAX_MSTR */

   if available tax_mstr then
   assign
      po_tax_pct[1] = tax_tax_pct[1]
      po_tax_pct[2] = tax_tax_pct[2]
      po_tax_pct[3] = tax_tax_pct[3].
end.  /* if not {txnew.1} */

podloop:

for each pod_det exclusive-lock where
      pod_nbr = po_nbr and
      ((is-return and pod_qty_chg <> 0) or
      ((not is-return) and
      pod_status <> "c" and
      pod_status <> "x" and
      (pod_qty_chg <> 0 or pod_bo_chg = 0) and
      ((not porec and pod_rma_type <> "I" and pod_rma_type <> "") or
      (porec and pod_rma_type <> "O")) and
      ((shipper_rec and pod_qty_chg <> 0 ) or not shipper_rec) and
      ((pod_sched and pod_qty_chg <> 0 ) or not pod_sched)))
      break by pod_part:

   /* Include RTS logic in for each statement. So first-of  */

   /* If fiscal receiving or shipper confirm has not received the
   /*H074*/       pod_det then skip */
   if shipper_rec and  pod_qty_chg = 0 then next podloop.

   for first si_mstr
         fields(si_cur_set si_db si_entity si_git_acct
         si_git_sub
         si_git_cc si_gl_set si_site)
         where si_site = pod_site no-lock:
   end. /* FOR FIRST SI_MSTR */

   if available si_mstr and si_db = global_db then do:
      {pxrun.i &PROC = 'calculateUnitCost' &PROGRAM = 'porcxr1.p'
                &HANDLE=ph_porcxr1
               &PARAM="(buffer pod_det,
                        output price)"
               &CATCHERROR = TRUE
               &NOAPPERROR = TRUE}

      find first tax_wkfl where

         tax_nbr  = pod_nbr and
         tax_line = pod_line no-lock no-error.

      if available tax_wkfl then do:
         price = tax_price / pod_um_conv.
      end.

      old_status = pod_status.
/*eas055*****************************/
       if length(receivernbr) <= 1 then do:
	  {xxdncreate.i}
       end.
/*eas055*****************************/

      if (first-of(pod_part) and rcv_type = 2 and receivernbr = " ") or
         (rcv_type <> 2 and receivernbr = "" and poc_seq_rcv) then do:

         {mfnctrlc.i
            poc_ctrl
            poc_rcv_pre
            poc_rcv_nbr
            prh_hist
            prh_receiver
            receivernbr}

         if rcv_type <> 2 and {txnew.i} and fiscal_rec = no and
            poc_seq_rcv then do:
            tax_lines = 0.
            {gprun.i ""poporcx.p"" "( input tax_lines )" }
         end.

      end.

      if rcv_type = 2 and {txnew.i} and fiscal_rec = no then do:
         tax_lines = pod_line.
         {gprun.i ""poporcx.p"" "( input tax_lines )" }
      end.

      /* ADDED FIFTH INPUT PARAMETER I_SHIPTO */
/*eas055      {gprun.i ""poporcb8.p""*/
/*eas055*/      {gprun.i ""xxpoporcb8.p""
               "(buffer pod_det,
                 input receivernbr,
                 input ship_date,
                 input shipnbr,
                 input inv_mov,
                 input i_shipto)"}
      if undo_all then undo podloop, next podloop.

   end.  /* if available si_mstr and si_db = global_db */
   if last-of(pod_part) and rcv_type = 2 then
   assign
      l_last_receiver = receivernbr
      receivernbr     = "".

end.  /* for each pod_det */

if rcv_type = 2 then
   receivernbr = l_last_receiver.

/* Post the credit terms interest component of the item price */
/* to a statiscal acccount for the PO receipt.                */

{pxrun.i &PROC = 'closePOIfNeeded' &PROGRAM = 'porcxr.p'
          &HANDLE=ph_porcxr
         &PARAM = "(input  po_nbr)"
         &CATCHERROR = TRUE
         &NOAPPERROR = TRUE}


if not auto_receipt then do:
   {gprun.i ""porcsubr.p"" }
end.
