/* rqpobldb.p - Requisition To Purchase Order Build Sub-Program             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.5.1.11 $                                                     */
/*V8:ConvertMode=ReportAndMaintenance                                       */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *J1Q2* Patrick Rowan    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L040* Brenda Milton    */
/* REVISION: 8.6E     LAST MODIFIED: 07/05/99   BY: *J3HN* Reetu Kapoor     */
/* REVISION: 9.1      LAST MODIFIED: 08/02/99   BY: *N014* Robin McCarthy   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00   BY: *N0RC* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.5.1.5     BY: Katie Hilbert       DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.5.1.6     BY: Tiziana Giustozzi   DATE: 07/03/01 ECO: *N104* */
/* Revision: 1.5.1.7     BY: Steve Nugent        DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.5.1.8     BY: Dan herman          DATE: 06/06/02 ECO: *P07Y* */
/* $Revision: 1.5.1.11 $ BY: Tiziana Giustozzi DATE: 07/24/02 ECO: *P09N* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Display front-end screen before copy-to-po process.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
 1) A temp-table is used to hold the requisition lines.  All lines that are
    to be copied to the new PO have been flagged.  This program calls the
    routine that performs the copy function.
 2) This program is a clone of pomt.p, release 85 upto and including
patch J1RQ.
The code has been stripped of obsolete code.
============================================================================
!*/
{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

{pocurvar.i "NEW"}
{txcurvar.i "NEW"}
{potrldef.i "NEW"}
{txcalvar.i}

define input  parameter v_vend like po_vend .
define input  parameter v_site like po_site .
define output parameter v_nbr  like po_nbr .

/* POPOMT.P VARIABLES*/
define new shared variable blanket like mfc_logical initial 'no'.

/* POMT.P VARIABLES*/
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like po_curr.
define new shared variable line like pod_line.
define new shared variable due_date like pod_due_date.
define new shared variable del-yn like mfc_logical.
define new shared variable qty_ord like pod_qty_ord.
define new shared variable so_job like pod_so_job.
define new shared variable sngl_ln like poc_ln_fmt.
define new shared variable disc like pod_disc label "Ln Disc".
define new shared variable po_recno as recid.
define new shared variable vd_recno as recid.
define new shared variable yn like mfc_logical initial yes.
define new shared variable ponbr like po_nbr.
define new shared variable old_po_stat like po_stat.
define new shared variable line_opened as logical.
define new shared variable old_rev like po_rev.
define variable old_vend like po_vend.
define variable old_ship like po_ship.
define new shared variable pocmmts like mfc_logical
   label "Comments".
define new shared variable cmtindx as integer.
define new shared variable base_amt like pod_pur_cost.
define new shared variable comment_type like po_lang.
define new shared variable new_po like mfc_logical.
define new shared variable new_db like si_db.
define new shared variable old_db like si_db.
define new shared variable new_site like si_site.
define new shared variable old_site like si_site.
define new shared variable continue like mfc_logical no-undo.
define new shared variable tax_in like ad_tax_in.
define new shared frame b.
define new shared frame vend.
define new shared frame ship_to.
define new shared variable tax_recno as recid.
define variable zone_to    like txe_zone_to.
define variable zone_from  like txe_zone_from.

define new shared variable pocrt_int like pod_crt_int.
define new shared variable impexp      like mfc_logical no-undo.
define            variable impexp_edit like mfc_logical no-undo.
define            variable upd_okay    like mfc_logical no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_tax_tr_type like tx2d_tr_type initial "20" no-undo.
define variable l_tax_nbr     like tx2d_nbr     initial ""   no-undo.
define variable l_tax_lines   like tx2d_line    initial 0    no-undo.

/* LOGICALS */
define variable blank_suppliers       like mfc_logical no-undo
   label "Blank Suppliers Only".
define variable default_copy          like mfc_logical no-undo
   label "Default Copy".
define variable c-supplier-consignment as character no-undo.
define variable use-log-acctg as logical                  no-undo.
define variable ref-type      like lacd_internal_ref_type no-undo.

/* COUNTERS */
define variable rqcd_det_cntr as integer no-undo.

/* SHARED VARIABLES*/
{xxrqpovars.i}
{apconsdf.i}

{pocnvars.i} /* Variables for consignment inventory */
{pocnpo.i}  /* Consignment procedures and frames */

/* FRAME A: SELECTION FORM */
{popomt02.i}



{mfadform.i "vend" 1 SUPPLIER}
{mfadform.i "ship_to" 41 SHIP_TO}

run initialize-variables.

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
      input 11,
      input ADG,
      input SUPPLIER_CONSIGN_CTRL_TABLE,
      output using_supplier_consignment)"}

c-supplier-consignment = getTermLabel("SUPPLIER_CONSIGNEMT", 30).

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}


mainloop:
repeat on endkey undo, leave:

   assign
      so_job = ""
      disc = 0
      comment_type = global_type.

   /* TRANSACTION TO GET PURCHASE ORDER */
   do transaction on error undo, retry:

/*       view frame a.       */
/*       view frame vend.    */
/*       view frame ship_to. */

/*       prompt-for po_nbr with frame a                                  */
/*          editing:                                                     */
/*                                                                       */
/*          /* Allow last PO number refresh */                           */
/*          if keyfunction(lastkey) = "RECALL" or lastkey = 307          */
/*             then display ponbr @ po_nbr with frame a.                 */
/*                                                                       */
/*          /* FIND NEXT/PREVIOUS RECORD */                              */
/*          /* Do not scroll thru RTS for PO or PO for RTS */            */
/*          {mfnp06.i                                                    */
/*             po_mstr                                                   */
/*             po_nbr                                                    */
/*             "po_type <> ""B"" and po_fsm_type = """""                 */
/*             po_nbr                                                    */
/*             "input po_nbr"                                            */
/*             yes                                                       */
/*             yes }                                                     */
/*                                                                       */
/*          /* WHEN THE PURCHASE ORDER IS FOUND, THEN DISPLAY */         */
/*          if recno <> ? then do:                                       */
/*             disc = po_disc_pct.                                       */
/*                                                                       */
/*             /* CREDIT TERMS */                                        */
/*             find ct_mstr where ct_code = po_cr_term no-lock no-error. */
/*             if available ct_mstr then pocrt_int = ct_terms_int.       */
/*             else pocrt_int = 0.                                       */
/*                                                                       */
/*             {mfaddisp.i po_vend vend}                                 */
/*             {mfaddisp.i po_ship ship_to}                              */
/*             display po_nbr po_vend po_ship with frame a.              */
/*                                                                       */
/*          end.  /* IF RECNO <> ? */                                    */
/*       end. /* PROMPT-FOR...EDITING */                                 */

    /*xp001*/
      find last po_mstr where po_vend = v_vend 
                        and po_site = v_site 
						and po_stat = "" /*未结*/
                        and po__chr01 = "" /*未核准*/
                        and po__chr02 = "A"  /*非手工维护:所以po_fsm_type = "" , po_type = "", po_sched = no */
                        no-lock no-error .
      if avail po_mstr then do:
          
				/*xp001*/
				/*       end.                                                       */
				/*                                                                  */
				/*       find po_mstr where po_nbr = input po_nbr no-lock no-error. */
				/*       if available po_mstr then do:                              */
						 if po_fsm_type <> "" then do:
							{pxmsg.i &MSGNUM=7364 &ERRORLEVEL=3}
							/* CAN NOT PROCESS RTS ORDERS WITH PO PROGRAMS. */
							next-prompt po_nbr with frame a.
							undo, retry.
						 end.  /* if po_fsm_type <> "" */

						 if po_stat = "c" then do:
							{pxmsg.i &MSGNUM=326 &ERRORLEVEL=3}  /* PURCHASE ORDER CLOSED */
							next-prompt po_nbr with frame a.
							undo, retry.
						 end.

						 if po_stat = "x" then do:
							{pxmsg.i &MSGNUM=395 &ERRORLEVEL=3}  /* PURCHASE ORDER CANCELLED */
							next-prompt po_nbr with frame a.
							undo, retry.
						 end.

						 find first pod_det where pod_nbr = po_nbr no-lock no-error.
						 if available pod_det and
							pod_po_db <> global_db then do:
							{pxmsg.i &MSGNUM=2514
									 &ERRORLEVEL=3
									 &MSGARG1=getTermLabel(""PURCHASE_ORDER"",25)
									 &MSGARG2=pod_po_db
							}
							/* PO IS FOR DATABASE POD_PO_DB */
							next-prompt po_nbr with frame a.
							undo, retry.
						 end.

						 if po_type = "B" then do:
							{pxmsg.i &MSGNUM=385 &ERRORLEVEL=3}  /* BLANKET ORDER NOT ALLOWED */
							next-prompt po_nbr with frame a.
							undo, retry.
						 end.

						 if po_sched then do:
							{pxmsg.i &MSGNUM=8210 &ERRORLEVEL=3}
							/* ORDER WAS CREATED BY SCHEDULED ORDER MAINTENANCE */
							next-prompt po_nbr with frame a.
							undo, retry.
						 end.

						 /* VERIFY ACCESS TO SITE DATA */
						 {gprun.i ""gpsiver.p""
							"(input po_site, input ?, output return_int)"}
						 if return_int = 0 then do:
							{pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}  /* USER DOES NOT HAVE ACCESS TO SITE */
							next-prompt po_nbr with frame a.
							undo, retry.
						 end.


 /*xp001*/       
			 find first pod_det where pod_nbr = po_nbr and ( pod_stat <> "" or pod_qty_rcvd <> 0 ) no-lock no-error.
			 if available pod_det then do:
					ponbr = "" .
			 end.
			 else 	ponbr = po_nbr .
      end.  /* if available po_mstr */
      else /*xp001*/ do:
          ponbr =  "" .
      end.

/*  /*xp001*/     if input po_nbr <> "" then ponbr = input po_nbr. */
      

      /* GET NEXT GENERATED PO NUMBER FROM CONTROL FILE */
/*       if input po_nbr = "" then do: */
      if ponbr = "" then do: /*xp001*/
         {mfnctrlc.i
            poc_ctrl
            poc_po_pre
            poc_po_nbr
            po_mstr
            po_nbr
            ponbr}
      end.
   end.  /* TRANSACTION TO GET PURCHASE ORDER */

   /* TRANSACTION TO GET SUPPLIER & SHIP-TO */
   do transaction on error undo, retry with frame a:
      find first poc_ctrl no-lock.
      if not available poc_ctrl then create poc_ctrl.
      pocmmts = poc_hcmmts.
      find po_mstr where po_nbr = ponbr exclusive-lock no-error.
      if not available po_mstr then do:
         clear frame vend.
         clear frame ship_to.
         new_po = yes.
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create po_mstr.
		 assign po__chr02 = "A" .  /*xp001*/ 
         run initialize_po_mstr.

         /* POPULATE SCREEN WITH REQUISITION DATA */
         find first rqpo_wrk where rqpo_copy_to_po
							 and rqpo_supplier = v_vend /*xp001*/
							 and rqpo_site = v_site     /*xp001*/
              no-lock no-error.
         if available(rqpo_wrk) then do:

            rqpo_recno = recid(rqpo_wrk).

            /* OBTAIN SHIP-TO FROM 1ST REQUISITION LINE SELECTED */
            po_ship = rqpo_ship.
/*xp001*/           /* {mfaddisp.i po_ship ship_to}*/

            /* OBTAIN SUPPLIER FROM 1ST REQUISITION LINE SELECTED */
            po_vend = rqpo_supplier.
/*xp001*/            /*{mfaddisp.i po_vend vend}*/

         end.  /* if available(rqpo_wrk) */

      end.  /* IF NOT AVAILABLE PO_MSTR */

      else do:
         /* I.E. IF PO_MSTR WAS AVAILABLE */
         find ct_mstr where ct_code = po_cr_term no-lock no-error.
         if available ct_mstr then
            pocrt_int = ct_terms_int.
         else
            pocrt_int = 0.

         new_po = no.
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
/*xp001*/        /* {mfaddisp.i po_vend vend}*/
/*xp001*/        /* {mfaddisp.i po_ship ship_to} */
         disc = po_disc_pct.
         if available pod_det then
            so_job = pod_so_job.

      end.  /* (IF PO_MSTR WAS AVAILABLE)  */

      recno = recid(po_mstr).

 /*xp001*/ /*     display po_nbr po_vend po_ship with frame a. */

      assign
         old_vend = po_vend
         old_ship = po_ship.
/*xp001*/ 
/*       if new_po then do:                                                     */
/*          vendblk:                                                            */
/*          do on error undo, retry:                                            */
/*             prompt-for po_mstr.po_vend with frame a                          */
/*                editing:                                                      */
/*                                                                              */
/*                /* FIND NEXT/PREVIOUS  RECORD */                              */
/*                {mfnp.i vd_mstr po_vend vd_addr                               */
/*                   po_vend vd_addr vd_addr}                                   */
/*                                                                              */
/*                if recno <> ? then do:                                        */
/*                   po_vend = vd_addr.                                         */
/*                   display po_vend with frame a.                              */
/*                   find ad_mstr where ad_addr = vd_addr  no-lock.             */
/*                   {mfaddisp.i po_vend vend}                                  */
/*                end.                                                          */
/*             end.  /* prompt-for po_mstr.po_vend */                           */
/*                                                                              */
/*             {mfaddisp.i "input po_vend" vend}                                */
/*                                                                              */
/*             find vd_mstr where                                               */
/*                vd_addr = input po_vend no-lock no-error.                     */
/*             if not available ad_mstr or                                      */
/*                not available vd_mstr then do:                                */
/*                {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}  /* NOT A VALID SUPPLIER */ */
/*                next-prompt po_vend with frame a.                             */
/*                undo, retry.                                                  */
/*             end.                                                             */
/*                                                                              */
/*          end. /* VENDBLK */                                                  */
/*                                                                              */
/*       end.  /* if new_po */                                                  */
/*                                                                              */
/*       else do:                                                               */
/*          find vd_mstr where                                                  */
/*             vd_addr = po_vend no-lock.                                       */
/*       end.  /* if NOT new_po */                                              */
/*xp001*/ 

      find vd_mstr where vd_addr = po_vend no-lock no-error . /*xp001*/ 
      find ad_mstr where ad_addr = po_vend no-lock no-error.  /*xp001*/
      tax_in = ad_tax_in.

      /* INVOICE METHOD */
      if new_po then do:
         po_inv_mthd = ad_po_mthd.
         if po_inv_mthd = "n" or po_inv_mthd = "e" then
            po_print = no.
      end.

      assign
         /* po_vend = input po_vend */ /*xp001*/ 
         vd_recno = recid(vd_mstr).


      /* IF USING SUPPLIER CONSIGNMENT THEN INITIALIZE */
      /* CONSIGNMENT FIELDS.   */
      if using_supplier_consignment then do:
         run initializeSuppConsignFields
            (input po_vend,
             output po_consignment,
             output po_max_aging_days).

         if return-value <> {&SUCCESS-RESULT}
         then do:
            /*if return-value = "3388" then do:
               {pxmsg.i &MSGNUM=return-value
                        &ERRORLEVEL=3
                        &MSGARG1= c-supplier-consignment}
            end.
            else do:
               {pxmsg.i &MSGNUM=return-value &ERRORLEVEL=2}
            end.
            next-prompt po_vend with frame a.
            undo, retry. xp001 */

			po_consignment = no .
			po_max_aging_days = 0.
         end. /* if return-value <> */
      end. /* IF using_supplier_consignment */
/*xp001*/ 
/*       shipblk:                                                       */
/*       do on error undo, retry:                                       */
/*          prompt-for po_mstr.po_ship with frame a                     */
/*             editing:                                                 */
/*                                                                      */
/*             /* FIND NEXT/PREVIOUS  RECORD */                         */
/*             {mfnp.i ad_mstr po_ship ad_addr po_ship ad_addr ad_addr} */
/*                                                                      */
/*             if recno <> ? then do:                                   */
/*                po_ship = ad_addr.                                    */
/*                display po_ship with frame a.                         */
/*                {mfaddisp.i po_ship ship_to}                          */
/*             end.                                                     */
/*          end.                                                        */
/*                                                                      */
/*          if input po_ship = "" then do:                              */
/*             {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}                       */
/*             undo, retry.                                             */
/*          end.                                                        */
/*                                                                      */
/*          assign po_ship = input po_ship.                             */
/*          {mfaddisp.i po_ship ship_to}                                */
/*                                                                      */
/*          if not available ad_mstr then do:                           */
/*             {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}                       */
/*             next-prompt po_ship with frame a.                        */
/*             undo, retry.                                             */
/*          end.                                                        */
/*       end. /* shipblk */                                             */
/*xp001*/ 
      /* SET GLOBAL REFERENCE VARIABLE FOR COMMENTS TO VENDOR */
      global_ref = po_vend.

      /* INITIALIZE */
      po_recno = recid(po_mstr).
      continue = yes.
      pause 0.      



      /* POPULATE PO HEADER ONLY WHEN NEW */
      if new_po then do:
         {gprun.i ""xxrqpobldc.p""}  /* SIMILAR TO popomtb.p */    /*xp001*/ 
      end.  /* POPULATE PO HEADER */




      /* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE */
      if not new_po then do:
         /* NEED TO DETERMINE ROUNDING METHOD FOR LATER PROCESSING */

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
      end.  /* DETERMINE ROUNDING METHOD */

      if continue = no then
         undo mainloop, retry.

      /* EVALUATED RECEIPT SETTLEMENT (ERS) */
      find first poc_ctrl no-lock no-error.
      if available poc_ctrl and poc_ers_proc then do: /*ERS ON*/
         /*form
            po_ers_opt label "ERS Option" colon 22
            skip
            po_pr_lst_tp label "ERS Price List Option" colon 22
         with frame ers overlay side-labels centered
            row(frame-row(a) + 11)
            width 30.

         /* SET EXTERNAL LABELS*/
         setFrameLabels(frame ers:handle). xp001*/

         /*POC ERS IS ON AND ERS OPTION IS ON*/
         if new_po then
            po_ers_opt = poc_ers_opt.

         /*display
            po_ers_opt
            po_pr_lst_tp
         with frame ers.

         ers-loop:
         do with frame ers on error undo, retry:
            set po_ers_opt po_pr_lst_tp.

            if not ({gppoers.v po_ers_opt}) then do:
               {pxmsg.i &MSGNUM=2303 &ERRORLEVEL=3}    /* INVALID ERS OPTION */
               next-prompt po_ers_opt.
               undo, retry ers-loop.
            end.
         end. /*DO WITH FRAME ERS*/

         hide frame ers.  xp001*/


      end. /*AVAILABLE POC_CTRL*/

      /*if using_supplier_consignment then do:

         run setPoConsigned
            (input-output po_consignment).
         hide frame consign.

         if po_consignment then do:
            run setAgingDays
               (input-output po_max_aging_days).
            hide frame aging.
         end.
      end.  if using_supplier_consignment then do  xp001 */

      if (oldcurr <> po_curr) or oldcurr = "" then do:
         /* SET CURRENCY DEPENDENT FORMATS */
         {pocurfmt.i}
         oldcurr = po_curr.
      end.

      /* USE SHIP-TO INFO FOR TAX RATE PERCENTAGES */
      if po_tax_date <> ?
         then tax_date = po_tax_date.
      else
   if po_due_date <> ?
         then tax_date = po_due_date.
      else
         tax_date = po_ord_date.

      /* FIND LAST LINE */
      line = 0.
      find last pod_det no-lock
         where pod_nbr = po_nbr
         use-index pod_nbrln no-error.
      if available pod_det then line = pod_line.

      po_recno = recid(po_mstr).

   end.  /* TRANSACTION  TO GET SUPPLIER & SHIP-TO */

/*    {mfselprt.i "printer" 132 } */        /*xp001*/ 
/*    {mfphead.i }                */   /*xp001*/ 


   /* POPULATE PO LINE ITEMS */
   {gprun.i ""xxrqpobldd.p"" "(input using_supplier_consignment ,input v_vend ,input v_site )"} /*xp001*/ 

	   /* CALCULATING TAX FOR GTM ENVIRONMENT */
	   {gprun.i ""xxxtxcalc.p"" "(input l_tax_tr_type,
							   input po_nbr,
							   input l_tax_nbr,
							   input l_tax_lines,
							   input no,
							   output result-status)"}



	   if use-log-acctg and po_tot_terms_code <> "" then

		  for each pod_det
			 fields (pod_nbr pod_part pod_line pod_um pod_site pod_qty_ord)
			 where pod_nbr = po_nbr
			 no-lock:

			 ref-type = {&TYPE_PO}.
			 {gprunmo.i
				&program=""lapotax.p""
				&module="LA"
				&param="""(input ref-type,
						   input pod_nbr,
						   input l_tax_nbr,
						   input pod_line,
						   input pod_qty_ord)"""}

		  end.


   /*  REPORT TRAILER  */
/*    {mfrtrail.i } */     /*xp001*/ 

   /* UPDATE OTHER DBs */
   {gprun.i ""popomtg.p""}
   release po_mstr no-error.

   v_nbr = ponbr .

   return_code = 1107.
   leave.
end.  /* REPEAT: MAINLOOP */

hide frame a no-pause.
hide frame vend  no-pause.
hide frame ship_to  no-pause.

/*  INITIALIZE-VARIABLES PROCEDURE  */
PROCEDURE initialize-variables:
   assign
      nontax_old         = nontaxable_amt:format in frame potot
      taxable_old        = taxable_amt:format
      lines_tot_old      = lines_total:format
      tax_tot_old        = tax_total:format
      order_amt_old      = order_amt:format
      prepaid_old        = po_prepaid:format in frame pomtd
      oldcurr = "".

end.  /* procedure initialize-variables. */

/*  INITIALIZE PO_MSTR PROCEDURE  */
PROCEDURE initialize_po_mstr:
   assign
      po_mstr.po_ers_opt = "1"
      po_nbr = ponbr
      po_ord_date = today
      po_due_date = today
      po_tax_date = ?
      po_ship = poc_ctrl.poc_ship
      po_bill = poc_bill
      po_confirm = yes
      disc = 0
      po_user_id = global_userid
      po_fst_id = poc_fst_id /*(GST exempt id for company)*/
      po_pst_id = poc_pst_id.
   if recid(po_mstr) = -1 then .

end.  /* initialize_po_mstr procedure */
