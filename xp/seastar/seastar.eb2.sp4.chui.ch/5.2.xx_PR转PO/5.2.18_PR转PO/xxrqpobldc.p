/* rqpobldc.p - Requisition To PO -- Order Header subroutine                  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.10 $                                                       */
/*V8:ConvertMode=ReportAndMaintenance                                         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *J1Q2* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 01/07/97   BY: *J29D* Jim Josey          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L040* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 07/07/99   BY: *N00Y* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00   BY: *N0RC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 02/27/01   BY: *M12K* Rajesh Thomas      */
/* Revision: 1.5.1.6      BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.5.1.7      BY: Luke Pokic          DATE: 05/24/02  ECO: *P03Z* */
/* Revision: 1.5.1.8      BY: Jean Miller         DATE: 06/06/02  ECO: *P080* */
/* Revision: 1.5.1.9    BY: Robin McCarthy      DATE: 07/15/02  ECO: *P0BJ* */
/* $Revision: 1.5.1.10 $  BY: Ed van de Gevel  DATE: 02/24/03 ECO: *P0M7* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Populates purchase order header information.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
 1) Similar to popomtb.p; including ECO H0ND.
 2) This program is only called when the purchase order is being created.
============================================================================
!*/
{mfdeclre.i}
{cxcustom.i "RQPOBLDC.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* VARIABLES */
define variable i as integer no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable use-log-acctg as logical no-undo.
define variable type-po as character format "x(2)" no-undo.


/* CONSTANTS */
{rqconst.i}

/* SHARED VARIABLES */
{xxrqpovars.i}

/* POPOMTB.P VARIABLES */
define new shared variable tax_nbr like tx2d_nbr initial "".
define new shared variable tax_tr_type like tx2d_tr_type initial "20".
define new shared variable undo_all like mfc_logical.
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable line like pod_line.
define shared variable due_date like pod_due_date.
define shared variable del-yn like mfc_logical.
define shared variable qty_ord like pod_qty_ord.
define shared variable so_job like pod_so_job.
define shared variable disc like pod_disc label "Ln Disc".
define shared variable po_recno as recid.
define shared variable ponbr like po_nbr.
define shared variable old_po_stat like po_stat.
define shared variable line_opened as logical.
define shared variable old_rev like po_rev.
define shared variable pocmmts like mfc_logical label "Comments".
define shared variable new_po like mfc_logical.
define shared variable new_db like si_db.
define shared variable old_db like si_db.
define shared variable new_site like si_site.
define shared variable old_site like si_site.
define shared variable continue like mfc_logical no-undo.
define shared variable tax_in like ad_tax_in.
define shared variable pocrt_int like pod_crt_int.

define shared frame b.
define shared frame vend.
define shared frame ship_to.

define variable zone_to like txe_zone_to.
define variable zone_from like txe_zone_from.
define variable con-yn like mfc_logical.
define variable poc_pt_req      like mfc_logical.
define shared variable impexp   like mfc_logical no-undo.
define        variable imp-okay like mfc_logical no-undo.

define new shared variable global_recid as recid.  /*from txtxeget.p by xp001*/

{gptxcdec.i}  /* DECLARATIONS FOR gptxcval.i */
{popomt02.i}  /* Shared frames a and b */

/* TAX MANAGEMENT FORM */
form
   po_tax_usage colon 25
   po_tax_env   colon 25
   space(1)
   po_taxc      colon 25
   po_taxable   colon 25
   tax_in       colon 25
with frame set_tax row 8 centered overlay side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).

{mfadform.i "vend" 1 SUPPLIER}
{mfadform.i "ship_to" 41 SHIP_TO}

find rqpo_wrk exclusive-lock where recid(rqpo_wrk) = rqpo_recno.
find po_mstr exclusive-lock where recid(po_mstr) = po_recno.
find vd_mstr no-lock where vd_addr = po_vend.
find first poc_ctrl no-lock.
find first iec_ctrl no-lock no-error.

/* COPY REQUISITION FROM REMOTE DB TO TEMP-TABLE wkrqm_ */
{gprun.i ""xxrqpobldf.p""
   "(input true,
     input rqpo_site)"}

find first wkrqm_mstr exclusive-lock where
   wkrqm_nbr = rqpo_nbr.

/* IF SUPPLIER = SUPPLIER ON THE REQUISITION */
if po_vend = rqpo_supplier then do:
   /* USE REQUISITION INFO FOR DEFAULT */
   assign
      po_disc_pct   = wkrqm_disc_pct
      po_rmks       = wkrqm_rmks
      po_curr       = wkrqm_curr
      po_pr_list    = wkrqm_pr_list
      po_pr_list2   = wkrqm_pr_list2
      po_fix_rate   = wkrqm_fix_rate
      po_lang       = if wkrqm_lang = "" then vd_lang else wkrqm_lang.

   /* IS TERMINAL OPERATOR A BUYER? */
   if can-find (rqr_mstr where
      rqr_userid = global_userid and
      rqr_role = BUYER) then
      po_buyer   = global_userid.
   else
      po_buyer   = wkrqm_buyer.
end.  /* if po_vend = rqpo_vend */
else do:
   /* USE VENDOR INFO FOR DEFAULT */
   assign
      po_disc_pct   = vd_disc_pct
      po_rmks       = vd_rmks
      po_curr       = vd_curr
      po_pr_list    = vd_pr_list
      po_pr_list2   = vd_pr_list2
      po_lang       = vd_lang.

   /* IS TERMINAL OPERATOR A BUYER? */
   if can-find (rqr_mstr where
      rqr_userid = global_userid and
      rqr_role = BUYER) then
      po_buyer   = global_userid.
   else
      po_buyer   = vd_buyer.
end.  /* if po_vend <> rqpo_vend */

/* USE VENDOR INFO TO INITIALIZE FIELDS NOT FOUND ON REQUISITION */
assign
   po_cr_terms      = vd_cr_terms
   po_contact       = vd_pur_cntct
   po_shipvia       = vd_shipvia
   po_ap_acct       = vd_ap_acct
   po_ap_sub        = vd_ap_sub
   po_ap_cc         = vd_ap_cc
   po_taxable       = vd_taxable
   po_tot_terms_code = vd_tot_terms_code
   po_fix_pr         = vd_fix_pr.

/* USE DEFAULT ACCOUNT/SUB/COST CTR IF NOT PROVIDED */
if po_ap_acct = "" then do:
   find first gl_ctrl no-lock.
   assign
      po_ap_acct    = gl_ap_acct
      po_ap_sub     = gl_ap_sub
      po_ap_cc      = gl_ap_cc.
end.

/* OBTAIN INTEREST % FROM CREDIT TERMS MASTER */
if po_cr_terms <> "" then do:
   find first ct_mstr where
      ct_code = po_cr_terms
      no-lock no-error.
   if available ct_mstr then
      pocrt_int = ct_terms_int.
end.

/* LOAD DEFAULT TAX CLASS AND USAGE */
find ad_mstr where ad_addr = vd_addr no-lock no-error.
if available ad_mstr then
   assign
      po_taxable   = ad_taxable
      po_tax_usage = ad_tax_usage
      po_taxc      = ad_taxc
      tax_in       = ad_tax_in.

impexp = no.

/* SET THE DEFAULT VALUE BASED ON IEC_CTRL FILE */
if available iec_ctrl and iec_impexp = yes then impexp = yes.

assign
   po_due_date   = wkrqm_due_date
   so_job        = wkrqm_job
   po_site       = wkrqm_site
   po_project    = wkrqm_project
   po_req_id     = wkrqm_rqby_userid.

/* SITE VALIDATION */
{gprun.i ""gpsiver.p""
   "(po_site, input ?, output return_int)"}
if return_int = 0 then do:
   /* USER DOES NOT HAVE ACCESS TO THIS SITE */
   {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
   continue = no.
end.

/* EXCHANGE RATE VALIDATION */
undo_all = yes.
po_recno = recid(po_mstr).
{gprun.i ""xxrqpomtb1.p""}  /*xp001*/
if undo_all then
   continue = no.

/* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE    */

/* GET ROUNDING METHOD FROM CURRENCY MASTER */
{gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
   "(input po_curr,
     output rndmthd,
     output mc-error-number)"}
if mc-error-number <> 0 then do:
   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   pause 0.
   continue = no.
end.

po_pst = no.

ststatus = stline[1].
status input ststatus.

set_tax:
do on error undo, retry:
   if po_tax_env = "" then do:

      /* GET SHIP-TO TAX ZONE FROM PO_SITE ADDRESS */
      find ad_mstr where ad_addr = po_site no-lock no-error.
      if available(ad_mstr) then zone_to = ad_tax_zone.
      else do:
         /* GET SHIP-TO TAX ZONE FROM PO_SHIP ADDRESS */
         find ad_mstr where ad_addr = po_ship no-lock
            no-error.
         if available(ad_mstr) then zone_to = ad_tax_zone.
         else do:
            /* USE TAX DEFAULT COMPANY ADDRESS */
            find ad_mstr where ad_addr = "~~taxes"
               no-lock no-error.
            if available ad_mstr then
               zone_to = ad_tax_zone.
            else do:
               /* SITE ADDRESS DOES NOT EXIST */
               {pxmsg.i &MSGNUM=864 &ERRORLEVEL=2}
               zone_to = "".
            end.
         end.
      end.

      /* GET VENDOR SHIP-FROM TAX ZONE FROM ADDRESS */
      find first ad_mstr where ad_addr = po_vend
         no-lock no-error.
      if available(ad_mstr) then zone_from = ad_tax_zone.

      /* SUGGEST A TAX ENVIRONMENT */
      /* {gprun.i ""txtxeget.p"" "(input  zone_to,
                                input  zone_from,
                                input  po_taxc,
                                output po_tax_env)"} xp001 */

		/* SEARCH ALGORITHM ----get from txtxeget.p by xp001 */
		{gprun.i ""txtxget1.p""
		   "(input  zone_to,
			 input  zone_from,
			 input  po_taxc,
			 output po_tax_env)" }
		if po_tax_env = "" then do:
		   /* NO TAX ENVIRONMENT FOUND; USING DEFAULT */
		   for first txc_ctrl
			  fields(txc_tax_env) no-lock:
			  po_tax_env = txc_tax_env.
		   end. /* FOR FIRST TXC_CTRL */
		end. /* IF TAX_ENV = "" */

   end.  /* if po_tax_env = "" */

 /*  update po_tax_usage
      po_tax_env
      po_taxc
      po_taxable
      tax_in
   with frame set_tax.*/ /*xp001*/

   /* VALIDATE TAX ENVIRONMENT */
   if po_tax_env = "" then do:
      {pxmsg.i &MSGNUM=944 &ERRORLEVEL=3}
      /* BLANK TAX ENVIRONMENT NOT ALLOWED */
      next-prompt po_tax_env with frame set_tax.
      undo, retry set_tax.
   end.

   if not {gptxe.v po_tax_env ""no""} then do:
      {pxmsg.i &MSGNUM=869 &ERRORLEVEL=3}
      /* TAX ENVIRONMENT DOES NOT EXIST */
      next-prompt po_tax_env with frame set_tax.
      undo, retry set_tax.
   end.
   {&RQPOBLDC-P-TAG1}
end.  /* SET_TAX */
hide frame set_tax.

/* UPDATE ORDER HEADER TERMS INTEREST PERCENTAGE */
if pocrt_int <> 0  and po_cr_terms <> "" then do:
   find ct_mstr where ct_code = po_cr_terms no-lock no-error.
   if available ct_mstr and pocrt_int <> 0 then do:
      if pocrt_int <> ct_terms_int then do:
         /* Entered terms interest # does not match ct interest # */
         {pxmsg.i &MSGNUM=6212 &ERRORLEVEL=2
                  &MSGARG1=pocrt_int
                  &MSGARG2=ct_terms_int}
         con-yn = yes.
         /* Do you wish to continue? */
         {pxmsg.i &MSGNUM=7734 &ERRORLEVEL=2 &CONFIRM=con-yn}
         if not con-yn then do:
            next-prompt pocrt_int.
            undo, retry.
         end.
      end.
   end.
end.

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

if use-log-acctg
then do:

   type-po = {&TYPE_PO}.

   {gprunmo.i &module = "LA" &program = "laisupp.p"
              &param  = """(input po_nbr,
                           input type-po,
                           input po_vend,
                           input no)"""}

end.

if impexp then do:
   hide frame b.
   imp-okay = no.
   {gprun.i ""iemstrcr.p""
      "(input ""2"",
        input po_nbr,
        input recid(po_mstr),
        input-output imp-okay )"}
   if imp-okay = no then
      continue = no.
end.

/* COPY REQ HEADER COMMENTS, IF THEY EXIST & ARE FLAGGED */
if include_hcmmts and wkrqm_cmtindx <> 0 then do:

   /* INITIALIZE COUNTER */
   i = -1.

   /* COPY COMMENTS FROM WORKFILE */
   for each wkcmt_det where
         wkcmt_det.cmt_indx = wkrqm_cmtindx no-lock:
      if i = -1 then do:
         find last cmt_det where
            cmt_det.cmt_indx >= 0 and
            cmt_det.cmt_seq  >= 0 no-lock no-error.

         if available(cmt_det) then
            po_cmtindx = cmt_det.cmt_indx + 1.
         else
            po_cmtindx = 1.

         pause 0.
      end.

      create cmt_det.
      assign
         cmt_det.cmt_indx  = po_cmtindx
         cmt_det.cmt_seq   = wkcmt_det.cmt_seq
         cmt_det.cmt_ref   = wkcmt_det.cmt_ref
         cmt_det.cmt_type  = wkcmt_det.cmt_type
         cmt_det.cmt_print = wkcmt_det.cmt_print
         cmt_det.cmt_lang  = wkcmt_det.cmt_lang .

      do i = 1 to 15:
         cmt_det.cmt_cmmt[i] = wkcmt_det.cmt_cmmt[i].
      end.

      i = 1.

   end.  /* for each cmt_det where cmt_indx = wkrqm_cmtindx */

end.  /* if wkrqm_cmtindx <> 0 */
else
   po_cmtindx = 0.

/* WRITE HISTORY RECORD IN DB OF REQUISITION */
assign
   old_db = global_db
   new_site = po_site.
if po_site <> "" then do:
   {gprun.i ""gpalias.p""}
end.
{gprun.i ""rqwrthst.p""
   "(input rqpo_nbr,
     input 0,
     input ACTION_CREATE_PO,
     input global_userid,
     input '',
     input '')"}
new_db = old_db.

{gprun.i ""gpaliasd.p""}

/* RETURN */
