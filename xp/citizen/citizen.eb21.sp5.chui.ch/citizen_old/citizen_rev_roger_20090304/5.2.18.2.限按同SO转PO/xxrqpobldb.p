/* rqpobldb.p - Requisition To Purchase Order Build Sub-Program               */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: *F0PN* Doug Norton        */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *J1Q2* Patrick Rowan      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L040* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 07/05/99   BY: *J3HN* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/02/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00   BY: *N0RC* Mark Brown         */
/* Revision: 1.5.1.5       BY: Katie Hilbert       DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.5.1.6       BY: Tiziana Giustozzi   DATE: 07/03/01 ECO: *N104* */
/* Revision: 1.5.1.7       BY: Steve Nugent        DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.5.1.8       BY: Dan herman          DATE: 06/06/02 ECO: *P07Y* */
/* Revision: 1.5.1.11      BY: Tiziana Giustozzi   DATE: 07/24/02 ECO: *P09N* */
/* Revision: 1.5.1.13      BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.5.1.14      BY: Rajinder Kamra      DATE: 05/12/03 ECO: *Q003* */
/* Revision: 1.5.1.16      BY: Shoma Salgaonkar    DATE: 03/03/04 ECO: *P1RD* */
/* Revision: 1.5.1.17      BY: Abhishek Jha        DATE: 04/23/04 ECO: *P1YG* */
/* Revision: 1.5.1.18      BY: Robin McCarthy      DATE: 08/11/05 ECO: *P2PJ* */
/* Revision: 1.5.1.18.1.1  BY: Priya Idnani        DATE: 10/24/05 ECO: *P44H* */
/* $Revision: 1.5.1.18.1.2 $ BY: Robin McCarthy    DATE: 03/01/06 ECO: *P4JX* */

/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/12/04  ECO: *xp001*  */  /*NBR多类别控制*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/12  ECO: *xp002*  */  /*记录PO历史记录*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/16  ECO: *xp003*  */  /*限制同so_job同时转*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 * ----------------------------------------------------------------------------
 * DESCRIPTION: Display front-end screen before copy-to-po process.
 *              Supports the multi-line Purchase Requisition Module of MFG/PRO.
 *
 * Notes:
 * 1) A temp-table is used to hold the requisition lines.  All lines that are
 *    to be copied to the new PO have been flagged.  This program calls the
 *    routine that performs the copy function.
 * 2) This program is a clone of pomt.p, release 85 upto and including
 *    patch J1RQ.
 * The code has been stripped of obsolete code.
 * ============================================================================
!*/

/*V8:ConvertMode=ReportAndMaintenance                                         */
{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* DEFINE HANDLE FOR PROGRAM */
{pxphdef.i ieiexr}

{pocurvar.i "NEW"}
{txcurvar.i "NEW"}
{potrldef.i "NEW"}
{txcalvar.i}

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
define new shared variable pocrt_int like pod_crt_int.
define new shared variable impexp      like mfc_logical no-undo.


define var v_hist   like mfc_logical initial no .  /*xp002*/
define shared var v_sojob     as char label "销售订单" .    /*xp003*/
/*define shared var v_sojob1    as char label "至" .  xp003*/


define variable old_vend like po_vend.
define variable old_ship like po_ship.
define variable zone_to    like txe_zone_to.
define variable zone_from  like txe_zone_from.

define variable impexp_edit like mfc_logical no-undo.
define variable upd_okay    like mfc_logical no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_tax_tr_type like tx2d_tr_type initial "20" no-undo.
define variable l_tax_nbr     like tx2d_nbr     initial ""   no-undo.
define variable l_tax_lines   like tx2d_line    initial 0    no-undo.

/* LOGICALS */
define variable blank_suppliers        like mfc_logical            no-undo
   label "Blank Suppliers Only".
define variable default_copy           like mfc_logical            no-undo
   label "Default Copy".
define variable c-supplier-consignment as character                no-undo.
define variable use-log-acctg          as logical                  no-undo.
define variable ref-type               like lacd_internal_ref_type no-undo.
define variable l_taxflag              like mfc_logical            no-undo.



define shared var      v_type                like xdn_type  label "单据类别" no-undo . /*xp001*/
define shared variable v_site                  like rqd_site    no-undo.  /*xp001*/




/* COUNTERS */
define variable rqcd_det_cntr as integer no-undo.

/* SHARED VARIABLES*/
{rqpovars.i}
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
      so_job       = /*""*/  v_sojob /*xp003*/
      disc         = 0
      comment_type = global_type.

   /* TRANSACTION TO GET PURCHASE ORDER */
   do transaction on error undo, retry:

      view frame a.
      view frame vend.
      view frame ship_to.

      prompt-for po_nbr with frame a
         editing:

         /* Allow last PO number refresh */
         if keyfunction(lastkey) = "RECALL" or lastkey = 307
            then display ponbr @ po_nbr with frame a.

         /* FIND NEXT/PREVIOUS RECORD */
         /* Do not scroll thru RTS for PO or PO for RTS */
         {mfnp06.i
            po_mstr
            po_nbr
            " po_mstr.po_domain = global_domain and po_type  <> ""B"" and
            po_fsm_type = """""
            po_nbr
            "input po_nbr"
            yes
            yes }

         /* WHEN THE PURCHASE ORDER IS FOUND, THEN DISPLAY */
         if recno <> ? then do:
            disc = po_disc_pct.

            /* CREDIT TERMS */
            find ct_mstr  where ct_mstr.ct_domain = global_domain and  ct_code
            = po_cr_term no-lock no-error.
            if available ct_mstr then pocrt_int = ct_terms_int.
            else pocrt_int = 0.

            {mfaddisp.i po_vend vend}
            {mfaddisp.i po_ship ship_to}
            display po_nbr po_vend po_ship with frame a.

         end.  /* IF RECNO <> ? */
      end. /* PROMPT-FOR...EDITING */

      find po_mstr  where po_mstr.po_domain = global_domain and  po_nbr = input
      po_nbr no-lock no-error.
      if available po_mstr then do:
         if po_fsm_type <> "" then do:
            {pxmsg.i &MSGNUM=7364
                     &ERRORLEVEL=3}
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

         find first pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = po_nbr no-lock no-error.
         if available pod_det and
            pod_po_db <> global_db then do:
            /* PO IS FOR DOMAIN POD_PO_DB */
            {pxmsg.i &MSGNUM=6145 &ERRORLEVEL=3
                     &MSGARG1=getTermLabel(""PURCHASE_ORDER"",25)
                     &MSGARG2=pod_po_db
            }
            next-prompt po_nbr with frame a.
            undo, retry.
         end.

         if po_type = "B" then do:
            {pxmsg.i &MSGNUM=385 &ERRORLEVEL=3}  /* BLANKET ORDER NOT ALLOWED */
            next-prompt po_nbr with frame a.
            undo, retry.
         end.

         if po_sched then do:
            {pxmsg.i &MSGNUM=8210
                     &ERRORLEVEL=3}
            /* ORDER WAS CREATED BY SCHEDULED ORDER MAINTENANCE */
            next-prompt po_nbr with frame a.
            undo, retry.
         end.

         /* VERIFY ACCESS TO SITE DATA */
         {gprun.i ""gpsiver.p""
                  "(input po_site, input ?, output return_int)"}
         if return_int = 0 then do:
            /* USER DOES NOT HAVE ACCESS TO SITE */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            next-prompt po_nbr with frame a.
            undo, retry.
         end.

      end.  /* if available po_mstr */

      if input po_nbr <> "" then ponbr = input po_nbr.

      /* GET NEXT GENERATED PO NUMBER FROM CONTROL FILE */
      if input po_nbr = "" then do:

 /*xp001*/ 
		find first xdn_ctrl where xdn_domain = global_domain and xdn_site = v_site and xdn_ordertype = "PO" no-lock no-error.
		if not avail xdn_ctrl then do:
			message "未启用自动编号，由系统编号" .
			pause 1.

         {mfnctrlc.i "poc_ctrl.poc_domain = global_domain"
         "poc_ctrl.poc_domain" "po_mstr.po_domain = global_domain"
            poc_ctrl
            poc_po_pre
            poc_po_nbr
            po_mstr
            po_nbr
            ponbr}

		end.
		else do:
			find xdn_ctrl where xdn_domain = global_domain and xdn_site = v_site and xdn_ordertype = "PO" and xdn_type = v_type no-error.
			if not avail xdn_ctrl then do:
				message "无此采购单单据类型" + v_site + "/" + v_type + "，请先设定。" .
				undo,retry .
			end.
			else do:
				assign ponbr = xdn_prev + xdn_next .
				xdn_next = string(integer(xdn_next) + 1, "999999") .
				release xdn_ctrl .
			end.

		end.
 /*xp001*/ 




      end.
   end.  /* TRANSACTION TO GET PURCHASE ORDER */

   /* TRANSACTION TO GET SUPPLIER & SHIP-TO */
   do transaction on error undo, retry with frame a:
      find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock.
      if not available poc_ctrl then do:  create poc_ctrl. poc_ctrl.poc_domain
      = global_domain. end.
      pocmmts = poc_hcmmts.
      find po_mstr  where po_mstr.po_domain = global_domain and  po_nbr = ponbr
      exclusive-lock no-error.
      if not available po_mstr then do:
         clear frame vend.
         clear frame ship_to.
         new_po = yes.
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create po_mstr. po_mstr.po_domain = global_domain.
         run initialize_po_mstr.

         /* POPULATE SCREEN WITH REQUISITION DATA */
         find first rqpo_wrk where rqpo_copy_to_po no-lock no-error.
         if available(rqpo_wrk) then do:

            rqpo_recno = recid(rqpo_wrk).

            /* OBTAIN SHIP-TO FROM 1ST REQUISITION LINE SELECTED */
            po_ship = rqpo_ship.
            {mfaddisp.i po_ship ship_to}

            /* OBTAIN SUPPLIER FROM 1ST REQUISITION LINE SELECTED */
            po_vend = rqpo_supplier.
            {mfaddisp.i po_vend vend}

         end.  /* if available(rqpo_wrk) */

      end.  /* IF NOT AVAILABLE PO_MSTR */

      else do:
         /* I.E. IF PO_MSTR WAS AVAILABLE */
         find ct_mstr  where ct_mstr.ct_domain = global_domain and  ct_code =
         po_cr_term no-lock no-error.
         if available ct_mstr then
            pocrt_int = ct_terms_int.
         else
            pocrt_int = 0.

         new_po = no.
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
         {mfaddisp.i po_vend vend}
         {mfaddisp.i po_ship ship_to}
         disc = po_disc_pct.
         if available pod_det then
            so_job = pod_so_job.



/*xp002*/
v_hist = no .
{gprun.i ""xxhist001.p"" "(input ""PO"" ,input ponbr ,input 1,output v_hist )"}
/*xp002*/



      end.  /* (IF PO_MSTR WAS AVAILABLE)  */

      recno = recid(po_mstr).

      display po_nbr po_vend po_ship with frame a.

      assign
         old_vend = po_vend
         old_ship = po_ship.

      if new_po then do:
         vendblk:
         do on error undo, retry:
            prompt-for po_mstr.po_vend with frame a
               editing:

               /* FIND NEXT/PREVIOUS  RECORD */
               {mfnp.i vd_mstr po_vend  " vd_mstr.vd_domain = global_domain and
               vd_addr "
                  po_vend vd_addr vd_addr}

               if recno <> ? then do:
                  po_vend = vd_addr.
                  display po_vend with frame a.
                  find ad_mstr  where ad_mstr.ad_domain = global_domain and
                  ad_addr = vd_addr  no-lock.
                  {mfaddisp.i po_vend vend}
               end.
            end.  /* prompt-for po_mstr.po_vend */

            {mfaddisp.i "input po_vend" vend}

            find vd_mstr  where vd_mstr.vd_domain = global_domain and
               vd_addr = input po_vend no-lock no-error.
            if not available ad_mstr or
               not available vd_mstr then do:
               {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}  /* NOT A VALID SUPPLIER */
               next-prompt po_vend with frame a.
               undo, retry.
            end.

         end. /* VENDBLK */

      end.  /* if new_po */

      else do:
         find vd_mstr  where vd_mstr.vd_domain = global_domain and
            vd_addr = po_vend no-lock.
      end.  /* if NOT new_po */

      tax_in = ad_tax_in.

      /* INVOICE METHOD */
      if new_po then do:
         po_inv_mthd = ad_po_mthd.
         if po_inv_mthd = "n" or po_inv_mthd = "e" then
            po_print = no.
      end.

      assign
         po_vend  = input po_vend
         vd_recno = recid(vd_mstr).


      /* IF USING SUPPLIER CONSIGNMENT THEN INITIALIZE */
      /* CONSIGNMENT FIELDS.   */
      if using_supplier_consignment then do:
         run initializeSuppConsignFields
            (input po_vend,
             output po_consignment,
             output po_max_aging_days,
             output po__qadc01).

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if return-value = "3388" then do:
               {pxmsg.i &MSGNUM=return-value
                        &ERRORLEVEL=3
                        &MSGARG1= c-supplier-consignment}
            end.
            else do:
               {pxmsg.i &MSGNUM=return-value &ERRORLEVEL=2}
            end.
            next-prompt po_vend with frame a.
            undo, retry.
         end. /* if return-value <> */
      end. /* IF using_supplier_consignment */

      shipblk:
      do on error undo, retry:
         prompt-for po_mstr.po_ship with frame a
            editing:

            /* FIND NEXT/PREVIOUS  RECORD */
            {mfnp.i ad_mstr po_ship  " ad_mstr.ad_domain = global_domain and
            ad_addr "  po_ship ad_addr ad_addr}

            if recno <> ? then do:
               po_ship = ad_addr.
               display po_ship with frame a.
               {mfaddisp.i po_ship ship_to}
            end.
         end.

         if input po_ship = "" then do:
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
            undo, retry.
         end.

         assign po_ship = input po_ship.
         {mfaddisp.i po_ship ship_to}

         if not available ad_mstr then do:
            {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}
            next-prompt po_ship with frame a.
            undo, retry.
         end.
      end. /* shipblk */

      /* SET GLOBAL REFERENCE VARIABLE FOR COMMENTS TO VENDOR */
      global_ref = po_vend.

      /* INITIALIZE */
      po_recno = recid(po_mstr).
      continue = yes.
      pause 0.

      /* POPULATE PO HEADER ONLY WHEN NEW */
      if new_po
      then do:
         l_taxflag = no.
         {gprun.i ""xxrqpobldc.p""
                  "(input-output l_taxflag)" }  /* SIMILAR TO popomtb.p */ /*xp003*/
         if l_taxflag = no
         then
            undo mainloop, retry mainloop.
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
      find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock
      no-error.
      if available poc_ctrl and poc_ers_proc then do: /*ERS ON*/
         form
            po_ers_opt label "ERS Option" colon 22
            skip
            po_pr_lst_tp label "ERS Price List Option" colon 22
         with frame ers overlay side-labels centered
            row(frame-row(a) + 11)
            width 30.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame ers:handle).

         /*POC ERS IS ON AND ERS OPTION IS ON*/
         if new_po then
            po_ers_opt = poc_ers_opt.

         /*UPDATE ERS FIELDS*/
         display
            po_ers_opt
            po_pr_lst_tp
         with frame ers.

         ers-loop:
         do with frame ers on error undo, retry:
            set po_ers_opt po_pr_lst_tp.

            /*VALIDATE ERS OPTION*/
            if not ({gppoers.v po_ers_opt}) then do:
               {pxmsg.i &MSGNUM=2303 &ERRORLEVEL=3}    /* INVALID ERS OPTION */
               next-prompt po_ers_opt.
               undo, retry ers-loop.
            end.
         end. /*DO WITH FRAME ERS*/

         hide frame ers.
      end. /*AVAILABLE POC_CTRL*/

      if using_supplier_consignment then do:

         run setPoConsigned
            (input-output po_consignment,
             input        po_nbr,
             input        line).

            if keyfunction(lastkey) = "END-ERROR" then do:
               hide frame consign.
               undo, retry.
            end.

         hide frame consign.

         /* UPDATE AGING DAYS AND PO COST POINT */
         if po_consignment then do:
            run setAgingDays
               (input-output po_max_aging_days,
                input-output po__qadc01,          /* PO COST POINT */
                input yes).

            if keyfunction(lastkey) = "END-ERROR" then do:
               hide frame aging.
               undo, retry.
            end.

            hide frame aging.
         end.
         else
            /* IF NOT A CONSIGNED PO, THEN RESET COST POINT TO BLANK */
            /* (DEFAULTING OF CONSIGNMENT FIELDS OCCURS BEFORE USER  */
            /* HAS UPDATED THE CONSIGNMENT FLAG.)                    */
            po__qadc01 = "".
      end. /* if using_supplier_consignment then do */

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
          where pod_det.pod_domain = global_domain and  pod_nbr = po_nbr
         use-index pod_nbrln no-error.
      if available pod_det then line = pod_line.

      po_recno = recid(po_mstr).

   end.  /* TRANSACTION  TO GET SUPPLIER & SHIP-TO */

   {mfselprt.i "printer" 132 }
   {mfphead.i }

   /* POPULATE PO LINE ITEMS */
   {gprun.i ""xxrqpobldd.p"" "(input using_supplier_consignment)"} /*xp003*/

   /* CALCULATING TAX FOR GTM ENVIRONMENT */
   {gprun.i ""txcalc.p"" "(input l_tax_tr_type,
                           input po_nbr,
                           input l_tax_nbr,
                           input l_tax_lines,
                           input no,
                           output result-status)"}

   if use-log-acctg and po_tot_terms_code <> "" then

      for each pod_det
         fields( pod_domain pod_nbr pod_part pod_line pod_um pod_site
         pod_qty_ord)
          where pod_det.pod_domain = global_domain and  pod_nbr = po_nbr
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
   {mfrtrail.i }

   /* IMPORT EXPORT UPDATE */
   if impexp
   then do:
      {pxrun.i &PROC='import-export-update'}
   end. /* IF impexp */

   /* CLEAN UP FRAMES DISPLAYED */
   if not impexp_edit
   then do:
      hide all no-pause.
      if c-application-mode <> "API"
      then
         view frame dtitle.
   end. /* IF NOT impexp_edit */


		/*xp002*/
		v_hist = no .
		{gprun.i ""xxhist001.p"" "(input ""PO"" ,input ponbr ,input 2,output v_hist )"}
		if v_hist then do:
			do transaction :
			find first po_mstr where po_domain = global_domain and po_nbr = ponbr exclusive-lock no-error .
			if avail po_mstr then do:
				po__chr01 = "" . /*改为未发行版本*/
				po_rev = po_rev + 1 .
			end.
			end.
		end.
		/*xp002*/

   /* UPDATE OTHER DOMAINS */
   {gprun.i ""popomtg.p""}
   release po_mstr no-error.

   return_code = 1107.
   leave.

end.  /* REPEAT: MAINLOOP */

hide frame a.
hide frame vend.
hide frame ship_to.

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

PROCEDURE import-export-update:
/*------------------------------------------------------------------------------
  Purpose: To create and maintain intrastat detail records.
  Notes:
  History:
------------------------------------------------------------------------------*/
   assign
      impexp_edit = no
      upd_okay    = no.

   /* CREATE THE IMPORT/EXPORT RECORD */
   {pxrun.i &PROC='createIntrastatDetails'
            &PROGRAM='ieiexr.p'
            &HANDLE=ph_ieiexr
            &PARAM="(input '2',
                     input po_mstr.po_nbr)"}

   if not batchrun
   then do:

      /* VIEW/EDIT IMPORT-EXPORT DATA ? */
      {pxmsg.i
         &MSGNUM=271
         &ERRORLEVEL={&INFORMATION-RESULT}
         &CONFIRM=impexp_edit}

      if impexp_edit
      then do:

         hide all.
         if c-application-mode <> "API"
         then do:
            view frame dtitle.
            view frame a.
         end. /* IF c-application-mode <> "API" */

         /* MAINTAIN IMPORT/EXPORT RECORD */
         {gprun.i ""iedmta.p""
            "(input ""2"",
              input po_mstr.po_nbr,
              input-output upd_okay )" }

      end. /* IF impexp_edit */

   end. /* IF NOT batchrun */

END PROCEDURE. /* import-export-update */
