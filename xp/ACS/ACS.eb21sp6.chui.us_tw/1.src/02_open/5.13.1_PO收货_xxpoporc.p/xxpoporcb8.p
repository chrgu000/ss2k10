/* poporcb8.p - Process a purchase order receipts line .                      */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Process a purchase order receipts line .                                   */
/*                                                                            */
/* Revision: 1.2    BY: Zheng Huang      DATE: 07/12/00  ECO: *N0DK*          */
/* Revision: 1.3    BY: Mark Brown       DATE: 08/13/00  ECO: *N0KQ*          */
/* Revision: 1.4    BY: Mark Brown       DATE: 08/21/00  ECO: *N0LJ*          */
/* Revision: 1.5    BY: Jean Miller      DATE: 11/08/00  ECO: *N0TN*          */
/* Revision: 1.6    BY: Murali Ayyagari  DATE: 12/14/00  ECO: *N0V1*          */
/* Revision: 1.7    BY: Manish K.        DATE: 01/12/01  ECO: *N0VL*          */
/* Revision: 1.8    BY: Katie Hilbert    DATE: 04/01/01  ECO: *P002*          */
/* Revision: 1.9    BY: Irine Fernandes  DATE: 10/22/01  ECO: *M1N4*          */
/* Revision: 1.10   BY: Patrick Rowan    DATE: 04/17/02  ECO: *P043*          */
/* Revision: 1.11   BY: Jeff Wootton     DATE: 05/14/02  ECO: *P03G*          */
/* Revision: 1.12   BY: Dan Herman       DATE: 05/24/02  ECO: *P018*          */
/* Revision: 1.13   BY: Steve Nugent        DATE: 06/13/02  ECO: *P08K*       */
/* Revision: 1.14   BY: Mercy Chittilapilly DATE: 11/26/02  ECO: *M21D*       */
/* Revision: 1.15   BY: Nishit V            DATE: 01/10/02  ECO: *N23L*       */
/* Revision: 1.16   BY: Orawan S.           DATE: 05/28/03  ECO: *P0RG*       */
/* Revision: 1.18   BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00J*       */
/* Revision: 1.19   BY: Mamata Samant       DATE: 08/02/03  ECO: *P0X6*       */
/* Revision: 1.20   BY: Rajiv Ramaiah       DATE: 08/11/03  ECO: *P0ZK*       */
/* Revision: 1.21   BY: Dipesh Bector       DATE: 09/01/03  ECO: *P111*       */
/* Revision: 1.22   BY: Katie Hilbert       DATE: 09/02/03  ECO: *P123*       */
/* Revision: 1.23   BY: Shilpa Athalye      DATE: 12/16/03  ECO: *P1DY*       */
/* Revision: 1.24   BY: Preeti Sattur       DATE: 01/21/04  ECO: *Q05F*       */
/* Revision: 1.25   BY: Annapurna V.       DATE: 10/21/04  ECO: *P2QG*       */
/* $Revision: 1.26 $ BY: Steve Nugent  DATE: 08/11/05  ECO: *P2PJ*  */
/* REVISION: eB2.1 SP6   BY: Apple Tam    DATE: 09/04/10 ECO: *SS-20100904.1* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{cxcustom.i "POPORCB8.P"}

{gplabel.i}
{pxmaint.i}
{gprunpdf.i "mcpl" "p"}
{porcdef.i}

/* Define Handles for the programs. */
{pxphdef.i popoxr}
{pxphdef.i porcxr1}
/* End Define Handles for the programs. */

/* ========================================================================== */
/* ******************************* PARAMETERS  ****************************** */
/* ========================================================================== */
define parameter buffer pod_det for pod_det.
define  input parameter receivernbr    as character         no-undo.
define  input parameter ship_date      as date              no-undo.
define  input parameter shipnbr        as character         no-undo.
define  input parameter inv_mov        as character         no-undo.
define  input parameter i_shipto       like abs_shipto      no-undo.
define  input parameter ip_is_usage    like mfc_logical     no-undo.
define  input parameter ip_usage_qty   like tr_qty_req      no-undo.
define  input parameter ip_woiss_trnbr like tr_rmks         no-undo.
define output parameter op_rctpo_trnbr like tr_trnbr        no-undo.

/* ========================================================================== */
/* ******************************* DEFINITIONS ****************************** */
/* ========================================================================== */
define new shared variable conv_to_stk_um  as   decimal.
define new shared variable cur_mthd        like cs_method.
define new shared variable cur_set         like cs_set.
define new shared variable curr_yn         as   logical.
define new shared variable glx_mthd        like cs_method.
define new shared variable glx_set         like cs_set.
define new shared variable msg-num         like tr_msg.
define new shared variable newbdn_ll       as   decimal.
define new shared variable newbdn_tl       as   decimal.
define new shared variable newcst          as   decimal.
define new shared variable newlbr_ll       as   decimal.
define new shared variable newlbr_tl       as   decimal.
define new shared variable newmtl_ll       as   decimal.
define new shared variable newmtl_tl       as   decimal.
define new shared variable newovh_ll       as   decimal.
define new shared variable newovh_tl       as   decimal.
define new shared variable newsub_ll       as   decimal.
define new shared variable newsub_tl       as   decimal.
define new shared variable nrecov_tax_avg  like tx2d_tottax  no-undo.
define new shared variable poddb           like pod_po_db.
define new shared variable pod_entity      like si_entity.
define new shared variable pod_po_entity   like si_entity.
define new shared variable podpodb         like pod_po_db.
define new shared variable rct_site        like pod_site.
define new shared variable qty_chg         like tr_qty_loc.
define new shared variable qty_ord         like pod_qty_ord.
define new shared variable reavg_yn        as   logical.
define new shared variable sct_recno       as   recid.
define new shared variable s_base_amt      like base_amt      no-undo.
define new shared variable wr_recno        as   recid.

define     shared variable stdcst          like tr_price.
define     shared variable price           like tr_price.
define     shared variable project         like pvo_project.
define     shared variable undo_all        like mfc_logical no-undo.
/* KANBAN TRANSACTION NUMBER, SHARED FROM poporcm.p AND kbporcm.p */
define     shared variable kbtransnbr      as integer no-undo.

define     shared workfile posub
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

define            buffer po_mstr for po_mstr.
define            variable del-yn          like mfc_logical  no-undo.
define            variable mc-error-number like msg_nbr      no-undo.
define            variable nonrecov_tax    like tx2d_tottax  no-undo.
define            variable i               as   integer      no-undo.
define            variable tax_amt         like tx2d_tax_amt no-undo.
define            variable rec_tax_amt     like tx2d_tax_amt no-undo.

/*SS-20100904 add***********/
define shared variable recgp         as character.
/*SS-20100904 end *********/

{pocnvars.i} /* Variables for Consignment Inventory */

{pxphdef.i ictrxr}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

/* This read is necessary to prevent passing in the po_mstr buffer. */
{pxrun.i &PROC = 'processRead' &PROGRAM = 'popoxr.p'
   &HANDLE=ph_popoxr
   &PARAM = "(input pod_nbr,
              buffer po_mstr,
              input {&NO_LOCK_FLAG},
              input {&NO_WAIT_FLAG})"
   &CATCHERROR = true
   &NOAPPERROR = true
   }

if is-return = no
then do:
   {mfpotr.i "DELETE" "RECEIPT" }
end. /* IF is-return = no */

/* Get item master information */

{pxrun.i &PROC = 'getItemConversionFactor' &PROGRAM = 'porcxr1.p'
   &HANDLE=ph_porcxr1
   &PARAM = "(input pod_part,
              input pod_rum,
              input pod_rum_conv,
              input pod_um_conv,
              output conv_to_stk_um)"
   &CATCHERROR = true
   &NOAPPERROR = true
   }

for first icc_ctrl
   fields(icc_domain icc_cur_set icc_gl_set)
   where icc_ctrl.icc_domain = global_domain
no-lock:
end. /* FOR FIRST ICC_CTRL */

stdcst = 0.

/* VALUE FOR move IS NOW SET IN THE HEADER SCREEN */

for first pt_mstr
   where pt_domain = global_domain and pt_part = pod_part
no-lock:
end. /* FOR FIRST pt_mstr */

if available pt_mstr then do:
   pt_recno = recid(pt_mstr).

   for first pl_mstr
      fields(pl_domain pl_prod_line)
      where pl_domain = global_domain
       and  pl_prod_line = pt_prod_line
   no-lock:
   end. /* FOR FIRST PL_MSTR */

   if pod_type = "" then do:
      {gpsct06.i &part=pt_part &site=pod_site &type=""GL"" }
      sct_recno = recid(sct_det).
   end.
   else sct_recno = ?.

if ((not using_supplier_consignment) or
    (using_supplier_consignment and not pod_consignment) or
    (using_supplier_consignment and pod_consignment and ip_is_usage))
   then do:
   /* Determine costing method */
   {gprun.i ""csavg01.p""
      "(input  pt_part,
        input  pod_site,
        output glx_set,
        output glx_mthd,
        output cur_set,
        output cur_mthd)" }
end. /*If not using supplier_consign*/
   curr_yn = yes.
   if can-find(wr_route where wr_domain = global_domain
               and wr_lot = wolot and wr_op = woop)
      or glx_mthd = "AVG" then curr_yn = no.


   if not pod_cst_up or (pod_type <> "" and pod_type <> "S") then
      cur_mthd = ?.

   /* Update current cost & post any GL discrepancy */
   /* Calculate amounts to average by cost category */


   if glx_mthd = "AVG" or
      cur_mthd = "AVG" or
      cur_mthd = "LAST"
   then do:

      base_amt = price.
      if po_curr <> base_curr
      then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  po_curr,
              input  base_curr,
              input  exch_rate,
              input  exch_rate2,
              input  base_amt,
              input  false, /* DO NOT ROUND */
              output base_amt,
              output mc-error-number)" }
      end.

      if  using_supplier_consignment and ip_is_usage
      then
         assign
            qty_chg   = ip_usage_qty
            transtype = "RCT-PO".
      else
         qty_chg = pod_qty_chg * conv_to_stk_um.

      if is-return then qty_chg = - qty_chg.

      assign nonrecov_tax   = 0
             nrecov_tax_avg = 0.
      /* Remove recoverable tax from cost basis */

      for each tx2d_det
            fields (tx2d_domain tx2d_cur_recov_amt tx2d_cur_tax_amt
                    tx2d_line tx2d_nbr tx2d_rcpt_tax_point
                    tx2d_tax_code
                    tx2d_ref tx2d_tax_in tx2d_tr_type)
            where
               tx2d_domain  = global_domain and
               tx2d_tr_type = tax_tr_type   and
               tx2d_ref     = receivernbr   and
               tx2d_nbr     = po_nbr        and
               tx2d_line    = pod_line
      no-lock:

         for first tx2_mstr no-lock
             where tx2_domain = global_domain
              and  tx2_tax_code = tx2d_tax_code:
         end.

         /* ACCRUE TAX AT RECEIPT ONLY WHEN DEALING WITH PURCHASE RECEIPTS */
         /* AND CONSIGNED MATERIAL USAGES (RCT-PO TRANSACTIONS). DO NOT    */
         /* ACCRUE TAX AT RECEIPT WHEN PHYSICALLY RECEIVING CONSIGNED      */
         /* MATERIAL (CN-RCT TRANSACTIONS).                                */

         if available tx2_mstr
            and
            /* PURCHASE RECEIPT */
            (tx2d_rcpt_tax_point) and
            (not using_supplier_consignment or not pod_consignment)
            or
            /* CONSIGNMENT USAGE */
            (using_supplier_consignment and
             pod_consignment            and
             tx2_usage_tax_point        and
             ip_is_usage)
         then do:
            /* Accrue tax at receipt */
            if not tx2d_tax_in then
               /* Tax not included in price */
               nonrecov_tax = nonrecov_tax
               /* Add all tax */
               + tx2d_cur_tax_amt
               /* Subtract recoverable tax */
               - tx2d_cur_recov_amt.
            else
               /* Tax included in price */
               nonrecov_tax = nonrecov_tax
               /* Subtract recoverable tax */
               - tx2d_cur_recov_amt.
         end. /* if (tx2d_rcpt_tax_point) and */
         else
         /* Accrue tax at voucher */
         if tx2d_tax_in then
            /* Tax included in price */
            nonrecov_tax = nonrecov_tax
            /* Subtract all tax */
            - tx2d_cur_tax_amt.
      end.  /* for each tx2d_det */
      assign base_amt = price + (nonrecov_tax / qty_chg)
             nrecov_tax_avg = nonrecov_tax / qty_chg.

      if po_curr <> base_curr
      then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  po_curr,
                          input  base_curr,
                          input  exch_rate,
                          input  exch_rate2,
                          input  base_amt,
                          input  false, /* DO NOT ROUND */
                          output base_amt,
                          output mc-error-number)" }
      end.

      for first sr_wkfl
         fields (sr_domain sr_lineid sr_site sr_userid)
         where sr_domain = global_domain
         and   sr_userid = mfguser
         and   sr_lineid = string(pod_line)
      no-lock:

         site = sr_site.

      end. /* FOR FIRST sr_wkfl */

      /* ADDED CALCULATION OF TAX FOR CONSIGNMENT INVENTORY */
      /* WHEN GL COSTING IS SET TO AVERAGE                  */
      if using_supplier_consignment and ip_is_usage then do:

         for first gl_ctrl
            fields (gl_domain gl_rcptx_acct gl_rcptx_sub
                    gl_rcptx_cc gl_rnd_mthd)
            where gl_domain = global_domain
         no-lock:
         end. /* FOR FIRST Gl_CTRL */

         {pxrun.i &PROC = 'processConsigntax' &PROGRAM = 'ictrxr.p'
                  &HANDLE = ph_ictrxr
                  &PARAM = "(input po_nbr,
                             input pod_line,
                             input pod_part,
                             input pod_site,
                             input qty_chg,
                             output tax_amt,
                             output rec_tax_amt)"
                  &CATCHERROR = true
                  &NOAPPERROR = true}

         /* IN THIS PROGRAM ONLY THE NON-RECOVERABLE TAX AMT IS REQUIRED. */
         /* THE RECOVERABLE TAX AMOUNT IS CONSIDERED IN pocnppv.p         */
         /* ROUND PER BASE CURRENCY ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output tax_amt,
           input gl_rnd_mthd,
           output mc-error-number)"}

          base_amt = price + (tax_amt / qty_chg).

      end. /* IF USING_SUPPLIER_CONSIGNMENT */

      s_base_amt = base_amt.

      {&POPORCB8-P-TAG1}

      /* csavg02.p  MOVED TO poporcb6.p FOR PO RETURNS OF INVENTORY ITEMS */
      /* FROM A SITE DIFFERENT FROM THE PO LINE SITE                      */

      if (not using_supplier_consignment) or
         (using_supplier_consignment and not pod_consignment) or
         (using_supplier_consignment and pod_consignment and ip_is_usage)
         then do:

         if pod_type                <> ""
         or site                    = pod_site
         or qty_chg                 >= 0
         or right-trim(po_fsm_type) <> ""
         then do:

            if pod_type = ""
            then do:

               /* ADDED 8th INPUT PARAMETER AS RECEIVING */
               /* SITES CONSIGNMENT INVENTORY USAGE      */

               {gprun.i ""csavg02.p""
                        "(input  pt_part,
                          input  pod_site,
                          input  transtype,
                          input  kbtransnbr,
                          input  recid(pt_mstr),
                          input  po_nbr,
                          input  qty_chg,
                          input  ip_usage_qty,
                          input  base_amt,
                          input  glx_set,
                          input  glx_mthd,
                          input  cur_set,
                          input  cur_mthd,
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
                          output msg-num)" }
            end.
            else if pod_type = "S"
            and curr_yn
            then do:

               /* ADDED 8th INPUT PARAMETER AS RECEIVING */
               /* SITES CONSIGNMENT INVENTORY USAGE      */

               {gprun.i ""csavg02.p""
                        "(input  pt_part,
                          input  pod_site,
                          input  ""PO-SUB"",
                          input  kbtransnbr,
                          input  recid(pt_mstr),
                          input  po_nbr,
                          input  qty_chg,
                          input  ip_usage_qty,
                          input  base_amt,
                          input  glx_set,
                          input  glx_mthd,
                          input  cur_set,
                          input  cur_mthd,
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
                          output msg-num)" }

            end.
         end. /* IF pod_type <> "" ... */
      end. /* If not using_supplier_consignemnt */
   end. /*if glx_mthd = ...*/
end.  /*if available pt_mstr*/
else  sct_recno = ?.

for first si_mstr
   fields(si_domain si_cur_set si_db si_entity si_git_acct
          si_git_sub si_git_cc si_gl_set si_site)
   where si_domain = global_domain
    and  si_site = pod_site
no-lock:
end. /* FOR FIRST SI_MSTR */
assign
   pod_entity = si_entity
   poddb = si_db.

if pod_po_site <> "" then
   for first si_mstr
      fields( si_domain si_cur_set si_db si_entity si_git_acct
             si_git_sub si_git_cc si_gl_set si_site)
       where si_domain = global_domain
        and  si_site = pod_po_site
   no-lock:
   end. /* FOR FIRST SI_MSTR */
assign
   pod_po_entity = si_entity
   podpodb       = si_db
   project       = pod_project
   rct_site      = pod_site
   pod_recno     = recid(pod_det).

if undo_all then return.

assign
   pt_recno  = recid(pt_mstr)
   pod_recno = recid(pod_det)
   po_recno  = recid(po_mstr)
   wr_recno  = recid(wr_route).

/* Create tr_hist, post to different */
/* applicable GL accounts */

/*SS-20100904* {gprun.i ""poporcb6.p""*/
/*SS-20100904*/ {gprun.i ""xxpoporcb6.p""
   "(input shipnbr,
     input ship_date,
     input inv_mov,
     input pod_consignment,
     input ip_is_usage,
     input ip_usage_qty,
     input ip_woiss_trnbr,
     output op_rctpo_trnbr)" }

if undo_all then return.

if pod_qty_chg <> 0 then do:

   find rmd_det
      where rmd_domain = global_domain and
            rmd_nbr    = pod_nbr       and
            rmd_prefix = "V"           and
            rmd_line   = pod_line
   exclusive-lock no-error.

   /*******************************************/
   /* Update receive/ship date and qty in rma */
   /*******************************************/
   if available rmd_det then do:
      if rmd_type = "O" then
         rmd_qty_acp  = - (pod_qty_rcvd + pod_qty_chg).
      else
         rmd_qty_acp  =   pod_qty_rcvd + pod_qty_chg.
      if rmd_qty_acp <> 0 then
         rmd_cpl_date =   eff_date.
      else
         rmd_cpl_date = ?.
   end.
end.  /**********end pod_qty_chg*************/

pod_recno = recid(pod_det).

/* ADDED 4TH INPUT PARAMETER ip_is_usage */

{gprun.i ""poporcb2.p"" "(input ship_date,
                          input i_shipto,
                          input pod_consignment,
                          input ip_is_usage)" }

/* Post the credit terms interest component of the item price */
/* to a statiscal acccount for the PO receipt.                */
{gprun.i ""poporcb4.p"" }
