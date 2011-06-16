/* GUI CONVERTED from rqpobldb.p (converter v1.76) Sun Aug  4 17:02:52 2002 */
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

/*ZH002 ADD****************************************************/

define shared temp-table rqpo2_wrk no-undo
   field rqpo2_nbr                     like rqm_mstr.rqm_nbr
   field rqpo2_line                    like rqd_line
   field rqpo2_site                    like rqd_site
   field rqpo2_item                    like rqd_part
   field rqpo2_net_qty                 like rqd_req_qty
   field rqpo2_need_date               like rqd_need_date
   field rqpo2_supplier                like rqd_vend
   field rqpo2_ship                    like rqd_ship
   field rqpo2_buyer_id                like rqm_buyer
   field rqpo2_copy_to_po              like mfc_logical  label "Copy"
   field rqpo2_finish                  like mfc_logical
   index rqpo2_index1                  is unique primary
   rqpo2_nbr ascending
   rqpo2_line ascending.

define shared temp-table rqpo3_wrk no-undo
   field rqpo3_nbr                     like rqm_mstr.rqm_nbr
   field rqpo3_line                    like rqd_line
   field rqpo3_site                    like rqd_site
   field rqpo3_item                    like rqd_part
   field rqpo3_net_qty                 like rqd_req_qty
   field rqpo3_need_date               like rqd_need_date
   field rqpo3_supplier                like rqd_vend
   field rqpo3_ship                    like rqd_ship
   field rqpo3_buyer_id                like rqm_buyer
   field rqpo3_copy_to_po              like mfc_logical  label "Copy"
   field rqpo3_finish                  like mfc_logical
   field rqpo3_um                      like rqd_um
   index rqpo3_index1                  is unique primary
   rqpo3_nbr ascending
   rqpo3_line ascending.

define shared temp-table rqpo4_wrk no-undo
   field rqpo4_nbr                     like rqm_mstr.rqm_nbr
   field rqpo4_line                    like rqd_line
   field rqpo4_site                    like rqd_site
   field rqpo4_item                    like rqd_part
   field rqpo4_net_qty                 like rqd_req_qty
   field rqpo4_need_date               like rqd_need_date
   field rqpo4_supplier                like rqd_vend
   field rqpo4_ship                    like rqd_ship
   field rqpo4_buyer_id                like rqm_buyer
   field rqpo4_copy_to_po              like mfc_logical  label "Copy"
   field rqpo4_finish                  like mfc_logical
   field rqpo4_um                      like rqd_um
   index rqpo4_index1                  is unique primary
   rqpo4_nbr ascending
   rqpo4_line ascending.

define new shared variable rqpo2_recno as recid.
define shared variable vendor          like rqd_vend no-undo.
define variable logical                as logical.
define variable mon                    as character format "x(1)".

/*ZH002 END****************************************************/

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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/


c-supplier-consignment = getTermLabel("SUPPLIER_CONSIGNEMT", 30).

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/


mainloop:
repeat on endkey undo, leave:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/

/*ZH002*/     vendor = "".
/*ZH002*/   for each rqpo2_wrk where rqpo2_copy_to_po and not rqpo2_finish no-lock break by rqpo2_supplier by rqpo2_item:

/*ZH002*/     if vendor = rqpo2_supplier then next.          
/*ZH002*/     if first-of(rqpo2_supplier) and vendor <> rqpo2_supplier then do:
/*ZH002*/     vendor = rqpo2_supplier.

   assign
      so_job = ""
      disc = 0
      comment_type = global_type.

/*ZH002*/ PROLOOP:

   /* TRANSACTION TO GET PURCHASE ORDER */
   do transaction on error undo, retry:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/


      view frame a.
      view frame vend.
      view frame ship_to.

/*ZH002*/ display "" @ po_nbr "" @ po_vend "" @ po_ship with frame a.

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
            "po_type <> ""B"" and po_fsm_type = """""
            po_nbr
            "input po_nbr"
            yes
            yes }

         /* WHEN THE PURCHASE ORDER IS FOUND, THEN DISPLAY */
         if recno <> ? then do:
            disc = po_disc_pct.

            /* CREDIT TERMS */
            find ct_mstr where ct_code = po_cr_term no-lock no-error.
            if available ct_mstr then pocrt_int = ct_terms_int.
            else pocrt_int = 0.

            {mfaddisp.i po_vend vend}
            {mfaddisp.i po_ship ship_to}
            display po_nbr po_vend po_ship with frame a.

         end.  /* IF RECNO <> ? */
      end. /* PROMPT-FOR...EDITING */

      find po_mstr where po_nbr = input po_nbr no-lock no-error.
      if available po_mstr then do:
      
/*ZH002*/    message "此PO已经存在,请重新输入." view-as alert-box.
/*ZH002*/    undo proloop,retry proloop.      
      
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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/

         if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}  /* USER DOES NOT HAVE ACCESS TO SITE */
            next-prompt po_nbr with frame a.
            undo, retry.
         end.

      end.  /* if available po_mstr */

      if input po_nbr <> "" then ponbr = input po_nbr.

      /* GET NEXT GENERATED PO NUMBER FROM CONTROL FILE */
      if input po_nbr = "" then do:

/*ZH002 ADD*************************************************/
         
                 if month(today) = 10 then mon = "A".
                 if month(today) = 11 then mon = "B".
                 if month(today) = 12 then mon = "C".
                 if month(today) < 10 then mon = string(month(today)).         
         
         find vd_mstr where vd_addr = rqpo2_supplier exclusive-lock no-error.
           if avail vd_mstr then do:
              if vd__chr01 = "" then do:
                 ponbr = "P" + substr(string(year(today)),3,2) + mon + substr(vd_sort,1,2) + string(01,"99").
                 repeat:
                   find po_mstr where po_nbr = ponbr no-lock no-error.
                     if avail po_mstr then ponbr = "P" + substr(string(year(today)),3,2) + mon + substr(vd_sort,1,2) 
                                         + string(integer(substr(ponbr,7,2)) + 1,"99").
                     if not avail po_mstr then leave.
                 end.
              end.
              else do:
                 if string(year(today)) > substr(vd__chr01,2,2) then do:
                    ponbr = "P" + substr(string(year(today)),3,2) + mon + substr(vd_sort,1,2) + string(01,"99").
	                 repeat:
	                   find po_mstr where po_nbr = ponbr no-lock no-error.
	                     if avail po_mstr then ponbr = "P" + substr(string(year(today)),3,2) + mon + substr(vd_sort,1,2) 
	                                         + string(integer(substr(ponbr,7,2)) + 1,"99").
	                     if not avail po_mstr then leave.
	                 end.                    
                 end.
                 if mon <> substr(vd__chr01,4,1) then do:
                    ponbr = "P" + substr(string(year(today)),3,2) + mon + substr(vd_sort,1,2) + string(01,"99").
                 end.
                 if substr(string(year(today)),3,2) = substr(vd__chr01,2,2) and mon = substr(vd__chr01,4,1)
                 then do:
                    if integer(substr(vd__chr01,7,2)) + 1 > 99 then do:
                       message "是否按MFG/PRO标准逻辑产生单号?" view-as alert-box QUESTION BUTTONS YES-NO
                       UPDATE choice AS LOGICAL.
                       if choice then do:
		         {mfnctrlc.i
		            poc_ctrl
		            poc_po_pre
		            poc_po_nbr
		            po_mstr
		            po_nbr
		            ponbr}                          
                       end.
                       else do:
                         undo mainloop,retry.
                       end.
                     end.
                     else do:
                          ponbr = "P" + substr(string(year(today)),3,2) + mon + substr(vd_sort,1,2) + 
                          string(integer(substr(vd__chr01,7,2)) + 1,"99").
		                 repeat:
		                   find po_mstr where po_nbr = ponbr no-lock no-error.
		                     if avail po_mstr then ponbr = "P" + substr(string(year(today)),3,2) + mon + substr(vd_sort,1,2) 
		                                         + string(integer(substr(ponbr,7,2)) + 1,"99").
		                     if not avail po_mstr then leave.
		                 end.
                     end.
                 end.
              end.

              vd__chr01 = ponbr.
           
           end.      
                 
                 


/*ZH002 END*************************************************/

/*ZH002 DELETE**************

         {mfnctrlc.i
            poc_ctrl
            poc_po_pre
            poc_po_nbr
            po_mstr
            po_nbr
            ponbr}

*ZH002 END**************/

      end.
   end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/
  /* TRANSACTION TO GET PURCHASE ORDER */

   /* TRANSACTION TO GET SUPPLIER & SHIP-TO */
   do transaction on error undo, retry with frame a:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/

      find first poc_ctrl no-lock.
      if not available poc_ctrl then create poc_ctrl.
      pocmmts = poc_hcmmts.
      find po_mstr where po_nbr = ponbr exclusive-lock no-error.
      if not available po_mstr then do:
         clear frame vend.
/* /*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame vend = F-vend-title.  */
         clear frame ship_to.
/* /*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame ship_to = F-ship_to-title. */
         new_po = yes.
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create po_mstr.
         run initialize_po_mstr.

         /* POPULATE SCREEN WITH REQUISITION DATA */
/*ZH002           find first rqpo_wrk where rqpo_copy_to_po no-lock no-error.*/
/*ZH002*/         find first rqpo_wrk where rqpo_copy_to_po and rqpo_supplier = rqpo2_supplier no-lock no-error.
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
         find ct_mstr where ct_code = po_cr_term no-lock no-error.
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

      end.  /* (IF PO_MSTR WAS AVAILABLE)  */

      recno = recid(po_mstr).

      display po_nbr po_vend po_ship with frame a.

      assign
         old_vend = po_vend
         old_ship = po_ship.

      if new_po then do:
         vendblk:
         do on error undo, retry:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/

/*ZH002 DELETE***************************************************

            prompt-for po_mstr.po_vend with frame a
               editing:

               /* FIND NEXT/PREVIOUS  RECORD */
               {mfnp.i vd_mstr po_vend vd_addr
                  po_vend vd_addr vd_addr}

               if recno <> ? then do:
                  po_vend = vd_addr.
                  display po_vend with frame a.
                  find ad_mstr where ad_addr = vd_addr  no-lock.
                  {mfaddisp.i po_vend vend}
               end.
            end.  /* prompt-for po_mstr.po_vend */

            {mfaddisp.i "input po_vend" vend}

            find vd_mstr where
               vd_addr = input po_vend no-lock no-error.
            if not available ad_mstr or
               not available vd_mstr then do:
               {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}  /* NOT A VALID SUPPLIER */
               next-prompt po_vend with frame a.
               undo, retry.
            end.

*ZH002 END***************************************************/

/*ZH002 ADD***************************************************/

            
            {mfaddisp.i rqpo2_supplier vend}

            find vd_mstr where
               vd_addr = rqpo2_supplier no-lock no-error.
            if not available ad_mstr or
               not available vd_mstr then do:
               {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}  /* NOT A VALID SUPPLIER */
               next-prompt po_vend with frame a.
               undo, retry.
            end.

/*ZH002 END***************************************************/

         end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/
 /* VENDBLK */

      end.  /* if new_po */

      else do:
         find vd_mstr where
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
         po_vend = input po_vend
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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/

/*ZH002 DELETE***************************************************

         prompt-for po_mstr.po_ship with frame a
            editing:

            /* FIND NEXT/PREVIOUS  RECORD */
            {mfnp.i ad_mstr po_ship ad_addr po_ship ad_addr ad_addr}

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
         
*ZH002 END***************************************************/         
         
         {mfaddisp.i po_ship ship_to}

         if not available ad_mstr then do:
            {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}
            next-prompt po_ship with frame a.
            undo, retry.
         end.
      end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/
 /* shipblk */

      /* SET GLOBAL REFERENCE VARIABLE FOR COMMENTS TO VENDOR */
      global_ref = po_vend.

      /* INITIALIZE */
      po_recno = recid(po_mstr).
      continue = yes.
      pause 0.

      /* POPULATE PO HEADER ONLY WHEN NEW */
      if new_po then do:
         {gprun.i ""rqpobldc.p""}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/
  /* SIMILAR TO popomtb.p */
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
         FORM  /* /*GUI*/ 
            

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
*/
po_ers_opt label "ERS Option" colon 22
            skip
            po_pr_lst_tp label "ERS Price List Option" colon 22
         
/*
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
*/
with frame ers overlay side-labels centered
            row(frame-row(a) + 11)
            width 30. 
	    /*
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-ers-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame ers = F-ers-title.
 RECT-FRAME-LABEL:HIDDEN in frame ers = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame ers =
  FRAME ers:HEIGHT-PIXELS - RECT-FRAME:Y in frame ers - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME ers = FRAME ers:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/
*/

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame ers:handle).

         /*POC ERS IS ON AND ERS OPTION IS ON*/
         if new_po then
            po_ers_opt = poc_ers_opt.

         /*UPDATE ERS FIELDS*/
         display
            po_ers_opt
            po_pr_lst_tp
         with frame ers
/* &IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/ */
.

         ers-loop:
         do with frame ers on error undo, retry:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/

            set po_ers_opt po_pr_lst_tp.

            /*VALIDATE ERS OPTION*/
            if not ({gppoers.v po_ers_opt}) then do:
               {pxmsg.i &MSGNUM=2303 &ERRORLEVEL=3}    /* INVALID ERS OPTION */
               next-prompt po_ers_opt.
               undo, retry ers-loop.
            end.
         end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/
 /*DO WITH FRAME ERS*/

         hide frame ers.
      end. /*AVAILABLE POC_CTRL*/

      if using_supplier_consignment then do:

         run setPoConsigned
            (input-output po_consignment).
         hide frame consign.

         if po_consignment then do:
            run setAgingDays
               (input-output po_max_aging_days).
            hide frame aging.
         end.
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
         where pod_nbr = po_nbr
         use-index pod_nbrln no-error.
      if available pod_det then line = pod_line.

      po_recno = recid(po_mstr).

   end.
   
/*ZH002*/ end.   /*if first-of(rqpo2_vend)*/   
   
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/
  /* TRANSACTION  TO GET SUPPLIER & SHIP-TO */

   {mfselprt.i "printer" 132 }
/* /*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2. */

   {mfphead.i }

   /* POPULATE PO LINE ITEMS */
/*ZH002     {gprun.i ""rqpobldd.p"" "(input using_supplier_consignment)"}*/
/*ZH002*/   {gprun.i ""xxrqpobldd.p"" "(input using_supplier_consignment)"}

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/


   /* CALCULATING TAX FOR GTM ENVIRONMENT */
   {gprun.i ""txcalc.p"" "(input l_tax_tr_type,
                           input po_nbr,
                           input l_tax_nbr,
                           input l_tax_lines,
                           input no,
                           output result-status)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/


   if use-log-acctg and po_tot_terms_code <> "" then

      for each pod_det
         fields (pod_nbr pod_part pod_line pod_um pod_site pod_qty_ord)
         where pod_nbr = po_nbr
         no-lock:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/


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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/


   /*  REPORT TRAILER  */
   {mfrtrail.i }

   /* UPDATE OTHER DBs */
   {gprun.i ""popomtg.p""}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/

/*ZH002*/     if last(rqpo2_supplier) then logical = yes.
/*ZH002*/     rqpo2_finish = YES.

   release po_mstr no-error.

   return_code = 1107.
   leave.

/*ZH002*/ end. /*for each rqpo2_wrk*/
/*ZH002*/ if logical then leave.

end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/* /*GUI*/ if global-beam-me-up then undo, leave. */
&ENDIF /*GUI*/
  /* REPEAT: MAINLOOP */

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
