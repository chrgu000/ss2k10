/* sosomtp.p - SALES ORDER MAINTENANCE UPDATE HEADER FRAME b                  */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Old ECO marker removed, but no ECO header exists *G035*                    */
/* Old ECO marker removed, but no ECO header exists *G415*                    */
/* Old ECO marker removed, but no ECO header exists *G484*                    */
/* Old ECO marker removed, but no ECO header exists *GA60*                    */
/* REVISION: 7.3      LAST MODIFIED: 05/23/93   BY: afs *GB31*                */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*                */
/* REVISION: 7.4      LAST MODIFIED: 07/30/93   BY: cdt *H048*                */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*                */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*                */
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: afs *GI55*                */
/* REVISION: 7.4      LAST MODIFIED: 06/29/94   BY: qzl *H419*                */
/* REVISION: 7.4      LAST MODIFIED: 07/29/94   BY: bcm *H465*                */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: bcm *GM05*                */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*                */
/* REVISION: 7.4      LAST MODIFIED: 09/29/94   BY: bcm *H541*                */
/* REVISION: 8.5      LAST MODIFIED: 10/18/94   BY: mwd *J034*                */
/* REVISION: 7.4      LAST MODIFIED: 10/19/94   BY: ljm *GN40*                */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*                */
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: mmp *H582*                */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: ljm *GO33*                */
/* REVISION: 7.4      LAST MODIFIED: 03/28/95   BY: kjm *F0PC*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/10/95   BY: yep *G0KL*                */
/* REVISION: 8.5      LAST MODIFIED: 04/12/95   BY: dpm *J044*                */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 10/27/95   BY: dpm *J08Y*                */
/* REVISION: 7.4      LAST MODIFIED: 06/15/95   BY: rxm *G0Q5*                */
/* REVISION: 7.4      LAST MODIFIED: 09/13/95   BY: ais *H0FW*                */
/* REVISION: 8.5      LAST MODIFIED: 07/12/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 03/14/96   BY: GWM *J0FQ*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/03/96   BY: DAH *J0KJ*                */
/* REVISION: 8.5      LAST MODIFIED: 07/04/96   BY: DAH *J0XR*                */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ*                */
/* REVISION: 8.5      LAST MODIFIED: 08/27/96   BY: *G2D5* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 09/16/96   BY: *G2F0* Ajit Deodhar       */
/* REVISION: 8.5      LAST MODIFIED: 10/17/96   BY: *G2H5* Ajit Deodhar       */
/* REVISION: 8.5      LAST MODIFIED: 11/07/96   BY: *G2HR* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 04/02/97   BY: *K09J* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 04/04/97   BY: *K09L* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 06/30/97   BY: *K0FL* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *J1TQ* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 07/07/97   BY: *K0DH* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/21/97   BY: *K0GS* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/06/97   BY: *K0KJ* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 10/21/97   BY: *J23V* Nirav Parikh       */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 01/15/98   BY: *K1FK* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *K1BN* Val Portugal       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *J2Q9* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/13/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/26/00   BY: *N0C6* Niranjan Ranka     */
/* REVISION: 9.1      LAST MODIFIED: 06/09/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 07/01/00   BY: *N0DX* BalbeerS Rajput    */
/* Revision: 1.33     BY: Niranjan Ranka          Date: 07/13/00  ECO: *N0DS* */
/* Revision: 1.34     BY: Mark Brown              Date: 08/12/00  ECO: *N0KN* */
/* Revision: 1.35     BY: Kaustubh K.             DATE: 01/25/01  ECO: *M109* */
/* Revision: 1.36     BY: Mudit Mehta             DATE: 10/16/00  ECO: *N0WB* */
/* Revision: 1.37     BY: Katie Hilbert           DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.39     BY: Sandeep Parab           DATE: 07/02/01  ECO: *M1CV* */
/* Revision: 1.41     BY: Rajiv Ramaiah           DATE: 08/31/01  ECO: *M1JT* */
/* Revision: 1.42     BY: Russ Witt               DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.43     BY: Patrick Rowan           DATE: 03/14/02  ECO: *P00G* */
/* Revision: 1.44     BY: Ashish Maheshwari       DATE: 05/20/02  ECO: *P04J* */
/* Revision: 1.46     BY: Robin McCarthy          DATE: 07/03/02  ECO: *P08Q* */
/* Revision: 1.47     BY: Robin McCarthy          DATE: 07/15/02  ECO: *P0BJ* */
/* Revision: 1.48     BY: Steve Nugent            DATE: 08/08/02  ECO: *P0DN* */
/* Revision: 1.49     BY: Robin McCarthy          DATE: 08/15/02  ECO: *P09K* */
/* Revision: 1.50     BY: Nishit Vadhavkar        DATE: 10/16/02  ECO: *N1X1* */
/* Revision: 1.51     BY: Robin McCarthy          DATE: 11/08/02  ECO: *P0JS* */
/* Revision: 1.54     BY: Wojciech Palczyski      DATE: 03/25/03  ECO: *P0P6* */
/* Revision: 1.56     BY: Paul Donnelly (SB)      DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.57     BY: Vinay Soman             DATE: 02/16/04  ECO: *P1P7* */
/* Revision: 1.59     BY: Jean Miller             DATE: 02/24/04  ECO: *Q063* */
/* Revision: 1.60     BY: Sushant Pradhan         DATE: 09/30/04  ECO: *P2MG* */
/* Revision: 1.61     BY: Priya Idnani            DATE: 10/21/04  ECO: *P2QP* */
/* Revision: 1.61.1.1 BY: Tejasvi Kulkarni        DATE: 05/26/05  ECO: *P3MW* */
/* Revision: 1.61.1.2 BY: Bhavik Rathod           DATE: 10/06/05  ECO: *P43S* */
/* Revision: 1.61.1.3 BY: Sushant Pradhan         DATE: 11/29/05  ECO: *Q0N3* */
/* $Revision: 1.61.1.4 $       BY: Preeti Sattur           DATE: 03/21/06  ECO: *Q0SL* */
/* By: Neil gao Date: 07/12/23 ECO: * ss 20071223 * */
/*By: Neil Gao 08/04/01 ECO: *SS 20080401* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "SOSOMTP.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

define input parameter this-is-rma as logical.
define input parameter consignment like mfc_logical no-undo.

define new shared variable old_slspsn    like so_slspsn   no-undo.
define new shared variable old_ft_type   like ft_type.
define new shared variable merror        like mfc_logical initial no.
define new shared variable tax_recno     as recid.
define new shared variable undo_sosomtb  like mfc_logical.

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable oldcurr like so_curr.
define shared variable so_recno as recid.
define shared variable undo_flag like mfc_logical.
define shared variable new_order like mfc_logical initial no.
define shared variable rebook_lines as logical initial no no-undo.
define shared variable mult_slspsn   like mfc_logical no-undo.
define shared variable promise_date  as   date label "Promise Date".
define shared variable perform_date  as   date label "Perform Date".
{&SOSOMTP-P-TAG1}
define shared variable confirm       like mfc_logical
   label "Confirmed"
   format "yes/no" initial yes.
{&SOSOMTP-P-TAG2}
define shared variable disp_fr       like mfc_logical
   label "Display Weights".
define shared variable socrt_int     like sod_crt_int.
define shared variable impexp        like mfc_logical no-undo.
{&SOSOMTP-P-TAG3}
define shared variable line_pricing  like pic_so_linpri.
{&SOSOMTP-P-TAG4}
define shared variable reprice       like mfc_logical.
define shared variable picust        like cm_addr.
define shared variable socmmts       like soc_hcmmts
   label "Comments".
define shared variable consume       like sod_consume.
define shared variable all_days      like soc_all_days.
define shared variable so-detail-all like soc_det_all.
define shared variable del-yn        like mfc_logical.
define shared variable freight_ok    like mfc_logical.
define shared variable calc_fr       like mfc_logical
   label "Calculate Freight".
define shared variable l_up_sales    like mfc_logical no-undo.

/* WHERE A SALES ORDER LINE HAS BEEN CONFIGURED WITH CONCINITY WE*/
/* WANT TO DELETE THE ASSOCIATED FILE HELD IN SOD__QADC01.*/
/* HOWEVER, WE CANNOT DELETE THE CONCINITY FILE UNTIL WE KNOW THAT*/
/* THE WHOLE SALES ORDER COULD BE DELETED AS THE UNDO COMMAND WILL*/
/* NOT UNDO ANY OS-DELETE COMMANDS*/
define new shared workfile cf_sod_rm
   field cf_ccq_name as character.
define new shared variable cfexists    like mfc_logical.


define buffer   somstr        for so_mstr.

define shared frame a.
/*V8-*/
define shared frame sold_to.
define shared frame ship_to.
/*V8+*/
define shared frame b.

define variable mc-error-number like msg_nbr no-undo.
define variable counter         as   integer     no-undo.
define variable old_fr_terms    like so_fr_terms.
define variable old_um          like fr_um.
define variable imp-okay        like mfc_logical no-undo.
define variable soc_pt_req      like mfc_logical.
define variable old_comm_pct    as decimal format ">>9.99" no-undo.
define variable l_up_comm       like mfc_logical no-undo.
define variable o-error_flag    like mfc_logical no-undo.
define variable l_ctr_ans       like mfc_logical no-undo.
/* THESE HANDLE FIELDS ARE USED TO GIVE RMA'S DIFFERENT LABELS */
define variable hdl-req-date    as  handle.
define variable hdl-due-date    as  handle.

define variable l_old_channel    like so_channel    no-undo.
define variable l_so_db          like global_db     no-undo.
define variable l_err_flag       as   integer       no-undo.
define variable l_old_pricing_dt like so_pricing_dt no-undo.
define variable use-log-acctg    as logical         no-undo.
define variable tax_type         like tx2d_tr_type  no-undo.
define variable order-on-shipper as logical         no-undo.
define variable l_parent_abs_id  like abs_id        no-undo.

{pppivar.i}   /* Shared pricing variables */

define temp-table tmp_db no-undo
   field tmp_db_name like si_db.

/* CONSIGNMENT VARIABLES */
define variable proc_id as character no-undo.
{socnvars.i}
using_cust_consignment = consignment.

{gptxcdec.i}  /* Define shared variables for gptxcval.i. */
{sosomt02.i}  /* Form definitions for shared frames a & b */
/*V8-*/
{mfadform.i "sold_to" 1 SOLD-TO}
{mfadform.i "ship_to" 41 SHIP-TO}
/*V8+*/

find so_mstr where recid(so_mstr) = so_recno exclusive-lock no-error.

for first soc_ctrl
   fields(soc_domain soc_apm soc_use_btb)
   where soc_domain = global_domain
no-lock: end.

for first iec_ctrl
   fields(iec_domain iec_impexp)
   where iec_domain = global_domain
no-lock: end.

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

reprice = no.
display reprice with frame b.

/* IF WE'RE DEALING WITH RMA'S, CHANGE THESE LABELS:       */
/* SO_REQ_DATE GOES FROM REQUIRED DATE TO DUE DATE         */
/* SO_DUE_DATE GOES FROM DUE DATE TO EXPECTED DATE         */
if  so_fsm_type = "RMA" then
assign
   hdl-req-date       = so_req_date:handle
   hdl-req-date:label = getTermLabel("DUE_DATE", 8)
   hdl-due-date       = so_due_date:handle
   hdl-due-date:label = getTermLabel("DATE_EXPECTED", 8).

l_old_pricing_dt = so_pricing_dt.

setb:
do on error undo, retry with frame b:

   l_old_channel = so_channel.
   /* Move down into new frame b1 */

   {&SOSOMTP-P-TAG5}
   set
      so_ord_date so_req_date promise_date so_due_date
      perform_date
      so_pricing_dt
      so_po when (so_secondary = no)
      so_rmks
      line_pricing when (new_order)
      so_pr_list
      so_site
      so_channel
      so_project
      confirm when (new so_mstr)
      so_curr when (new so_mstr)
      so_lang so_taxable
      so_taxc
      so_tax_date
      so_fix_pr
      so_cr_terms
      socrt_int
      reprice when (not new_order)
   go-on ("F5" "CTRL-D")
   editing:
      {&SOSOMTP-P-TAG6}

      /* DISPLAY INTEREST AFTER ENTERING CREDIT TERMS */
      readkey.

      if frame-field   = "so_pricing_dt"
      then do:

         if (keyfunction(lastkey) = "TAB"
         or  keyfunction(lastkey) = "GO"
         or  keyfunction(lastkey) = "CURSOR-DOWN"
         or  keyfunction(lastkey) = "CURSOR-UP"
         or  keyfunction(lastkey) = "RETURN")
         then do:

            if  not new so_mstr
            and (so_fsm_type = "" or
                 so_fsm_type = "RMA")
            and input so_pricing_dt <> l_old_pricing_dt
            and (can-find(mfc_ctrl
                    where mfc_domain = global_domain
                      and mfc_field   = "soc_pc_line"
                      and mfc_logical = no))
            then do:

               reprice = yes.

               display
                  reprice
               with frame b.

            end. /* IF NOT NEW so_mstr ... */
         end. /* IF (KEYFUNCTION(LASTKEY) = "TAB" ... */
      end. /* IF FRAME-FIELD = "so_pricing_dt" */

      if frame-field = "so_cr_terms" then do:

         if (lastkey = keycode("RETURN") or
             lastkey = keycode("CTRL-X") or
             lastkey = keycode("F1"))
            and so_cr_terms <> input so_cr_terms
         then do:

            for first ct_mstr
               fields( ct_domain ct_code ct_terms_int)
               where ct_domain = global_domain
                 and ct_code = input so_cr_terms
            no-lock: end.

            if available ct_mstr then do:
               display
                  string(ct_terms_int,"->>>9.99") @ socrt_int.
               socrt_int = ct_terms_int.
            end.

         end. /* IF ( LASTKEY = KEYCODE */

      end.

      if frame-field = "so_po" then do:
         if (lastkey = keycode("RETURN") or
             lastkey = keycode("CTRL-X") or
             lastkey = keycode("F1"))
         then do:
            if input so_po = ""
               and soc_use_btb
               and not this-is-rma
            then do:
               /* EMT sales order, PO not entered */
               {pxmsg.i &MSGNUM=2897 &ERRORLEVEL=2}
               if not batchrun
               then
                  pause.
               next-prompt so_rmks with frame b.
               next.
            end. /* IF input so_po = "" ... */
         end. /* IF lastkey = keycode("RETURN") ... */
      end. /* IF frame-field = "so_po" THEN DO ... */

      apply lastkey.

   end. /*editing*/

   /* UPDATE THE LINE ITEM PRICING DATE WITH THE HEADER PRICING DATE */
   /* WHEN SO LINE QTY IS PARTIALLY SHIPPED AND POSTED /NOT SHIPPED. */
   /* FOR RMA ORDERS, ONLY ISSUE LINES ARE UPDATED                   */
   if  not new so_mstr
   and (so_fsm_type   =  "" or
        so_fsm_type   =  "RMA")
   and  so_pricing_dt <> l_old_pricing_dt
   and (can-find(mfc_ctrl
           where mfc_domain = global_domain
             and mfc_field  = "soc_pc_line"
             and mfc_logical = no))
   then do:

      reprice = yes.

      display
         reprice
      with frame b.

      for each sod_det
         where sod_domain = global_domain
         and ( sod_nbr      = so_nbr
         and   sod_qty_inv  = 0
         and  (sod_rma_type = "" or
               sod_rma_type = "O"))
      exclusive-lock:
         sod_pricing_dt = so_pricing_dt.
      end. /* FOR EACH sod_det */

   end. /* IF NOT NEW so_mstr ... */

   if not new so_mstr and so_channel <> l_old_channel
   then do:

      l_so_db  = global_db.

      for each sod_det
         fields(sod_domain sod_btb_po sod_btb_type sod_contr_id
                sod_nbr sod_site)
         where sod_domain = global_domain
           and sod_nbr = so_nbr
      no-lock:

         for first si_mstr
            fields(si_domain si_db si_site)
            where si_domain = global_domain
              and si_site =  sod_site
              and si_db   <> l_so_db
         no-lock: end.

         if available si_mstr
         then do:
            if not (can-find (first tmp_db where tmp_db_name = si_db))
            then do:
               create tmp_db.
               tmp_db_name = si_db.
            end. /* IF NOT CAN-FIND FIRST tmp_db... */
         end. /* IF AVAILABLE si_mstr */

      end. /* FOR EACH sod_det */

      for each tmp_db:

         if tmp_db_name <> global_db then do:
            {gprun.i ""gpmdas.p"" "(input tmp_db_name, output l_err_flag)"}
         end.

         /* SOSOMTP1.P CALLED TO PROPAGATE CHANNEL DETAILS */
         /* TO REMOTE DATABASE */
         if l_err_flag = 0
         or l_err_flag = 9
         then do:
            {gprun.i ""sosomtp1.p""
               "(input so_nbr,
                 input so_channel)"}
         end. /* IF l_err_flag.. */

      end. /* FOR EACH tmp_db */

      if l_so_db <> global_db then do:
         {gprun.i ""gpmdas.p"" "(input l_so_db, output l_err_flag)"}
      end.

   end. /* IF NOT NEW so_mstr ... */

   if so_cr_terms <> ""
   then do:

      for first ct_mstr
         fields(ct_domain ct_code ct_terms_int)
         where ct_domain = global_domain and ct_code = so_cr_terms
      no-lock: end.

      if not available ct_mstr then do:
         /* CREDIT TERM CODE MUST EXIST OR BE BLANK */
         {pxmsg.i &MSGNUM=840 &ERRORLEVEL=3}
         next-prompt so_cr_terms with frame b.
         undo setb, retry setb.
      end.

   end.

   if so_primary and not so_secondary then
   assign
      so_cust_po = so_po
      so_ship_po = so_po.

   /* VALIDATE LINE PRICING OPTION VALID */
   if new_order and not line_pricing then do:

      for first mfc_ctrl
         fields(mfc_domain mfc_field mfc_logical)
         where mfc_domain = global_domain
           and mfc_field = "soc_pt_req"
      no-lock: end.

      if available mfc_ctrl and mfc_logical then do:
         /* PRICE LIST REQUIRED AND NO LINE PRICING NOT ALLOWED */
         {pxmsg.i &MSGNUM=1277 &ERRORLEVEL=3}
         next-prompt line_pricing.
         undo setb, retry setb.
      end.

   end. /* IF NOT LINE_PRICING */

   so_recno = recid(so_mstr).

   /* DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:

      /* THE USER MAY HAVE LINKED RTS LINE(S) TO ONE OR MORE LINES */
      /* ON THIS RMA.  CHECK FOR THAT, AND, IF IT EXISTS, GIVE THE */
      /* USER A CHANCE TO CHANGE HIS MIND.                         */
      if so_fsm_type = "RMA" then do:
         if can-find (first rmd_det where rmd_domain = global_domain
                                      and rmd_rma_nbr = so_nbr)
         then do:
            /* THIS IS LINKED TO ONE OR MORE RTS LINES */
            {pxmsg.i &MSGNUM=1120 &ERRORLEVEL=2}
         end.    /* if can-find... */
      end.     /* if so_fsm_type = "RMA" then */

      del-yn = yes.
      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if not del-yn then undo, retry.

   end.
   else if so_conf_date = ? and confirm = yes then
      so_conf_date = today.

   if del-yn then do:
			
/*SS 20080401 - B*/
			for first wo_mstr where wo_domain = global_domain and wo_nbr begins so_nbr no-lock:
				message "订单已经排程,不能删除".
				undo setb, retry setb.
			end.
/*SS 20080401 - E*/

      if can-find(first wo_mstr where wo_domain = global_domain
                                  and wo_nbr begins (so_nbr + ".")
                                  and wo_type = "F" )
      then do:
         /* Final assembly work order exists for S/O*/
         {pxmsg.i &MSGNUM=518 &ERRORLEVEL=2}
         pause.
      end.

      /* THIS LOGIC IS ADDED TO FIND IF ANY OF SO LINES IS AWATING REQUIRED */
      /* PO ACKNOWLEDGEMENT. IF ANY PENDING ACKNOWLEDGEMENT EXISTS AND IN */
      /* SALES ORDER CONTROL "ALLOW NON-ACK DELETES" IS SET TO NO THEN WE DO */
      /* NOT ALLOW TO DELETE THE SALES ORDER. */

      if so_primary
      and soc_use_btb
      then do:
         find first mfc_ctrl
            where mfc_domain = global_domain
            and   mfc_field  = "soc_emt_del"
         no-lock no-error.

         if available mfc_ctrl
         and mfc_logical then .
         else
            for each sod_det
               fields (sod_domain sod_nbr sod_btb_po)
               where sod_det.sod_domain =  global_domain
               and   sod_det.sod_nbr    =  so_nbr
               and   sod_det.sod_btb_po <> ""
            no-lock:
               for first po_mstr
                  fields(po_domain po_nbr po_xmit)
                  where po_mstr.po_domain = global_domain
                  and   po_nbr            = sod_btb_po
               no-lock:
                  if (po_xmit = "2"
                  or  po_xmit = "5")
                  then do:
                     /* Modification not allowed,Awaiting PO Acknowledgement */
                     {pxmsg.i &MSGNUM=2935 &ERRORLEVEL=4}
                     undo setb, retry setb.
                  end. /* IF po_xmit = "2" or po_xmit = "5" */
               end. /* FOR FIRST po_mstr */
            end. /* FOR EACH sod_det */
      end. /* IF so_primary */

      if so_secondary then do:
         /* Deletion is not allowed from the SBU */
         {pxmsg.i &MSGNUM=2938 &ERRORLEVEL=3}
         undo setb, retry setb.
      end.

/*SS 20080807 - B*/
				for each xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = so_nbr:
					delete xxcffw_mstr.
				end.
				for each xxcff_mstr where xxcff_key1 = "check" and xxcff_key_nbr = so_nbr  :
	     		delete xxcff_mstr.
	     	end.
	     	for each xxsob_det where xxsob_domain = global_domain and xxsob_nbr = so_nbr:
	     		delete xxsob_det.
	     	end.
/*SS 20080807 - E*/

      {&SOSOMTP-P-TAG7}
      {gprun.i ""sosomtd.p""}
      if merror then undo setb, retry.

      else do:
         leave setb.
      end.

   end.

   if so_po = ""
      and soc_use_btb
      and not this-is-rma
   then do:
      /* EMT sales order, PO not entered */
      {pxmsg.i &MSGNUM=2897 &ERRORLEVEL=2}
      if not batchrun
      then
         pause.
   end. /* IF so_po = "" ... */

   /* CHECK FOR DUPLICATE P.O. NUMBER */
   if so_mstr.so_po <> ""
   then do for somstr:

      if can-find(first somstr
         where somstr.so_domain = global_domain
         and  (somstr.so_po     = so_mstr.so_po
         and   somstr.so_cust   = so_mstr.so_cust
         and   somstr.so_nbr    <> so_mstr.so_nbr))
         or can-find(first ih_hist
            where ih_domain = global_domain
            and   ih_po     = so_mstr.so_po
            and   ih_cust   = so_mstr.so_cust
            and   ih_nbr    <> so_mstr.so_nbr)
         or can-find(first qo_mstr
            where qo_domain = global_domain
            and   qo_po     = so_mstr.so_po
        and   qo_cust   = so_mstr.so_cust
        and   qo_nbr    <> so_mstr.so_quote)
      then do:
         /* Duplicate customer purchase order */
         {pxmsg.i &MSGNUM=624 &ERRORLEVEL=2}
         if not batchrun
     then
        pause.
      end. /* IF CAN-FIND(FIRST SOMSTR .. ) */
   end. /* if so_mstr.so_po <> "" */

   else do: /* so_po was left blank */

      /* FOLLOWING CODE TO SUPPORT CHECK ON CUSTOMERS FOR WHOM A PO IS REQUIRED */
      if so_fsm_type = " " and (not so_sched) then do:

         /* SO_FSM_TYPE IS BLANK FOR NORMAL SALES ORDERS */
         for first cm_mstr
            fields(cm_domain cm_addr cm_po_reqd cm_promo)
            where cm_domain = global_domain and
                  cm_addr = so_cust
         no-lock: end.

         if available cm_mstr then
            if cm_po_reqd then do:
            /* PURCHASE ORDER IS REQUIRED FOR THIS CUSTOMER */
            {pxmsg.i &MSGNUM=631 &ERRORLEVEL=3}
            next-prompt so_po.
            undo, retry.
         end.
      end.    /* if so_fsm_type = " " */

      else do:
         /* IF SO_FSM_TYPE IS NON-BLANK, THIS MUST BE AN RMA */
         find rma_mstr where rma_domain = global_domain and
                             rma_nbr = so_nbr and
                             rma_prefix = "C"
         no-lock no-error.
         if available rma_mstr then do:
            find eu_mstr where eu_domain = global_domain and
                               eu_addr = rma_enduser
            no-lock no-error.
            if available eu_mstr then
               if eu_po_reqd then do:
               /* P.O. NUMBER IS REQUIRED FOR THIS END USER */
               {pxmsg.i &MSGNUM=322 &ERRORLEVEL=3}
               next-prompt so_po.
               undo, retry.
            end.
         end.    /* if available rma_mstr */
      end.    /* else do */

   end.   /* else do */

   /* UPDATE ALL LINE ITEMS WITH THE SO HEADER P. O. NUMBER */
   if not new_order and so_fsm_type = " " and not so_sched then do:
      for each sod_det where sod_det.sod_domain = global_domain and
                             sod_det.sod_nbr = so_mstr.so_nbr
      exclusive-lock:
         assign sod_contr_id = so_po.
      end. /* FOR EACH sod_det */
   end. /* IF NOT new_order AND so_fsm_type = " " */

   manual_list = so_pr_list.

   if so_site = ""
   then do:
      /* SITE ADDRESS DOES NOT EXIST */
      {pxmsg.i &MSGNUM=864 &ERRORLEVEL=3}
      next-prompt so_site with frame b.
      undo, retry.
   end. /* IF so_site = "" */

   {gprun.i ""gpsiver.p""
      "(input so_site, input ?, output return_int)"}
   if return_int = 0 then do:
      /* USER DOES NOT HAVE ACCESS TO THIS SITE */
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
      next-prompt so_site with frame b.
      undo, retry.
   end.

   /* EXCHANGE RATE CALCULATED FIRST TIME ONLY */
   if new so_mstr and base_curr <> so_mstr.so_curr then do:

      /* Validate currency */
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input  so_mstr.so_curr,
           output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         next-prompt so_mstr.so_curr.
         undo setb, retry setb.
      end.
      {&SOSOMTP-P-TAG14}
      /* Calculate exchange rate & create usage records */
      {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input  so_mstr.so_curr,
                 input  base_curr,
                 input  so_mstr.so_ex_ratetype,
                 input  so_mstr.so_ord_date,
                 output so_mstr.so_ex_rate,
                 output so_mstr.so_ex_rate2,
                 output so_mstr.so_exru_seq,
                 output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         next-prompt so_mstr.so_curr.
         undo setb, retry setb.
      end.
      {&SOSOMTP-P-TAG15}
   end.  /* if new so_mstr */

   if (oldcurr <> so_curr) or (oldcurr = "") then do:

      /** GET ROUNDING METHOD FROM CURRENCY MASTER **/
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input so_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         next-prompt so_mstr.so_curr.
         undo setb, retry setb.
      end. /* if mc-error-number <> 0 */

   end. /* if (oldcurr <> so_curr) or (oldcurr = "") */

   /* VALIDATE TAX CODE */
   {gptxcval.i &code=so_mstr.so_taxc &frame="b"}

   /* SET EXCHANGE RATE */
   /* Allow change to exrate only when new because tr_hist created */

   {&SOSOMTP-P-TAG16}

   if new so_mstr or so_conf_date = ? then do:
      {gprunp.i "mcui" "p" "mc-ex-rate-input"
            "(input        so_curr,
              input        base_curr,
              input        so_ord_date,
              input        so_exru_seq,
              input        true, /* update fixed-rate field */
              input        frame-row(b) + 4,
              input-output so_ex_rate,
              input-output so_ex_rate2,
              input-output so_fix_rate)"}
   end.  /* if new so_mstr */

   /* GET HEADER TAX DATA */
   undo_sosomtb = true.

   {&SOSOMTP-P-TAG17}

   {&SOSOMTP-P-TAG8}
   {gprun.i ""sosomtb.p""}
   if undo_sosomtb then undo setb, retry.

   /* UPDATE ORDER HEADER TERMS INTEREST PERCENTAGE */
   if socrt_int <> 0  and so_cr_terms <> ""
      and (new_order or so__qad02 <> socrt_int)
   then do:

      find ct_mstr where ct_domain = global_domain
                     and ct_code = so_cr_terms
      no-lock no-error.
      if available ct_mstr and socrt_int <> 0 then do:
         if socrt_int <> ct_terms_int then do:
            /* Entered terms interest # does not match ct interest # */
            {pxmsg.i &MSGNUM=6212 &ERRORLEVEL=2
                     &MSGARG1=socrt_int
                     &MSGARG2=ct_terms_int}
            l_ctr_ans = yes.
            /* DO YOU WISH TO CONTINUE? */
            {pxmsg.i &MSGNUM=8500 &ERRORLEVEL=2 &CONFIRM=l_ctr_ans}
            if not l_ctr_ans then do:
               next-prompt socrt_int.
               undo, retry.
            end.
         end.
      end.

   end.

   so__qad02 = socrt_int.
   undo_flag = false.

end. /*setb*/

hide frame b no-pause.

/* Check for deleted order and if we made it through the          */
/* first block, reset the flag to catch "F5" in the second block. */
if undo_flag then return.
else undo_flag = true.

ststatus = stline[3].
status input ststatus.
view frame b1.

calc_fr = no.
disp_fr = yes.
if new_order then calc_fr = yes.
old_fr_terms = so_fr_terms.
impexp = no.

/* SET THE DEFAULT VALUE BASED ON IEC_CTRL FILE */
if available iec_ctrl and iec_impexp = yes then impexp = yes.
{&SOSOMTP-P-TAG9}

/* IF USING CUSTOMER CONSIGNMENT THEN INITIALIZE THE SALES */
/* ORDER MASTER CONSIGNMENT RECORD.                        */
if new so_mstr
   and using_cust_consignment
then do:
   proc_id = "init".
   {gprunmo.i
       &program=""socnso.p""
       &module="ACN"
       &param= """(input proc_id,
                   input so_nbr,
                   input so_ship,
                   input so_site,
                   input no)"""}
end. /* IF NEW so_mstr AND using_cust_consignment */

display
   so_slspsn[1]
   mult_slspsn
   so_comm_pct[1]
   so_fr_list
   so_fr_min_wt
   so_fr_terms
   calc_fr
   disp_fr
   so_consignment when (using_cust_consignment and not this-is-rma)
   so_weight_um
   consume
   so-detail-all
   all_days
   socmmts
   impexp
with frame b1.

setb1:
do on error undo, retry with frame b1:

   do counter = 1 to 4:
      old_slspsn[counter] = so_slspsn[counter].
   end.

   old_comm_pct = so_comm_pct[1].

   /* Initialize Freight unit of measure */
   old_um = "".
   find fr_mstr where fr_domain = global_domain
                  and fr_list = so_fr_list
                  and fr_site = so_site
                  and fr_curr = so_curr
   no-lock no-error.

   if not available fr_mstr then
      find fr_mstr where fr_domain = global_domain
                     and fr_list = so_fr_list
                     and fr_site = so_site
                     and fr_curr = base_curr
      no-lock no-error.

   if available fr_mstr then do:
      old_um = fr_um.
      if so_weight_um = "" then so_weight_um = fr_um.
   end.

   set
      so_slspsn[1]
      mult_slspsn
      so_comm_pct[1]
      so_fr_list
      so_fr_min_wt
      so_fr_terms
      calc_fr
      disp_fr
      so_consignment when (using_cust_consignment and not this-is-rma)
      consume
      so-detail-all
      all_days
      socmmts
      impexp
   go-on ("F1" "CTRL-X").

/* ss 20071223 - b */
		if so_slspsn[1] = "" then do:
			message "业务员不存在".
			next-prompt so_slspsn[1] with frame b1.
      undo setb1, retry.
    end.
/* ss 20071223 - e */


   /* IF SHIPMENTS EXIST, DON'T ALLOW CHANGE TO SLSPSNS */
   if not new so_mstr and
      so_slspsn[1] entered
   then do:

      /* SHIP DATE COULD HAVE BEEN RESET, SO LOOK FOR SHIP HISTORY */
      {&SOSOMTP-P-TAG10}
      find first tr_hist where tr_domain = global_domain
                           and tr_nbr = so_nbr
                           and tr_type = "ISS-SO"
      no-lock no-error.

      {&SOSOMTP-P-TAG11}
      if available tr_hist then do:
         /*Shipment exists, salesperson change not allowed.*/
         {pxmsg.i &MSGNUM=130 &ERRORLEVEL=3}.
         so_slspsn[1] = old_slspsn[1].
         display so_slspsn[1] with frame b1.
         next-prompt so_slspsn[1] with frame b1.
         undo, retry setb1.
      end.

      if  input so_slspsn[1] <> old_slspsn[1]
      and not batchrun
      then do:
         /* SALESPERSON CHANGED, CHANGE ALL SALES LINES.   */
         {pxmsg.i &MSGNUM=5775 &ERRORLEVEL=1 &CONFIRM=l_up_sales}.
         if l_up_sales then
            rebook_lines = true.
      end. /* IF INPUT so_slspsn[1] <> old_slspsn[1] */
   end.

   if input so_slspsn[1] = "" then do:
      assign so_comm_pct[1] = 0.
      display so_comm_pct[1] with frame b1.
      pause 0.
   end.

   /* WHEN SALESPERSON IS CHANGED PROMPT THE USER TO DEFAULT THE NEW */
   /* SALESPERSON'S COMMISSION PERCENT.                              */
   if input so_slspsn[1] <> old_slspsn[1]   and
      input so_comm_pct[1] =  old_comm_pct  and
      input so_slspsn[1]  <> ""             and
      not batchrun
   then do:
      find sp_mstr where sp_domain = global_domain
                     and sp_addr = input so_slspsn[1]
      no-lock no-error.
      if input so_comm_pct[1] <> sp_comm_pct then do:
         /* Salesperson changed. Update default commission? */
         {pxmsg.i &MSGNUM=1396 &ERRORLEVEL=1 &CONFIRM=l_up_comm}
         if l_up_comm then do:
            assign so_comm_pct[1] = sp_comm_pct.
            display so_comm_pct[1] with frame b1.
            pause 0.
         end.
      end.
   end.

   old_slspsn[1] = input so_slspsn[1].

   /* MUILTIPLE SLSPSN ENTRY WITH HISTORY CHECK ON MODIFIED ORDER */
   if mult_slspsn then do:
      {gprun.i ""sososls.p""}
      if keyfunction(lastkey) = "end-error" then
         undo, retry setb1.
   end.

   /* Validate Freight list */
   if so_fr_list <> "" then do:

      find fr_mstr where fr_domain = global_domain
                     and fr_list = so_fr_list
                     and fr_site = so_site
                     and fr_curr = so_curr
      no-lock no-error.

      if not available fr_mstr then
         find fr_mstr where fr_domain = global_domain
                        and fr_list = so_fr_list
                        and fr_site = so_site
                        and fr_curr = base_curr
         no-lock no-error.

      if not available fr_mstr then do:
         /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
         {pxmsg.i &MSGNUM=670 &ERRORLEVEL=4
                  &MSGARG1=so_fr_list
                  &MSGARG2=so_site
                  &MSGARG3=so_curr}
         next-prompt so_fr_list with frame b1.
         undo, retry.
      end.

   end.

   /* FREIGHT PARAMETERS */
   if so_fr_list <> "" then do:

      if so_fr_list <> "" or
         (so_fr_list = "" and calc_fr)
      then do:

         find fr_mstr where fr_domain = global_domain
                        and fr_list = so_fr_list
                        and fr_site = so_site
                        and fr_curr = so_curr
         no-lock no-error.

         if not available fr_mstr then
            find fr_mstr where fr_domain = global_domain
                           and fr_list = so_fr_list
                           and fr_site = so_site
                           and fr_curr = base_curr
            no-lock no-error.

         if not available fr_mstr then do:
            /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
            {pxmsg.i &MSGNUM=670 &ERRORLEVEL=4
                     &MSGARG1=so_fr_list
                     &MSGARG2=so_site
                     &MSGARG3=so_curr}
            undo, retry.
         end.
         if old_um <> fr_um and not new_order then do:
            /* UNIT OF MEASURE HAS CHANGED */
            {pxmsg.i &MSGNUM=675 &ERRORLEVEL=2}
            if not batchrun then pause.
         end.
      end.

      if so_fr_terms <> "" or
         (so_fr_terms = "" and calc_fr)
      then do:
         find ft_mstr where ft_domain = global_domain
                        and ft_terms = so_fr_terms
         no-lock no-error.
         if not available ft_mstr then do:
            /* Invalid Freight Terms */
            {pxmsg.i &MSGNUM=671 &ERRORLEVEL=3 &MSGARG1=so_fr_terms}
            next-prompt so_fr_terms with frame b1.
            undo setb1, retry.
         end.
      end.

      if so_fr_terms <> old_fr_terms
         and not new_order and not calc_fr
      then do:
         /* CALCULATION REQUIRED WHEN FREIGHT TERMS CHANGE */
         {pxmsg.i &MSGNUM=681 &ERRORLEVEL=4}
         next-prompt calc_fr with frame b1.
         undo setb1, retry.
      end.
   end.  /* if so_fr_list <> "" */

   /* VALIDATION FOR FREIGHT TERMS WITH BLANK FREIGHT LIST */
   /* VALIDATE so_fr_terms WHEN ENTERED */
   if so_fr_terms <> "" then do:
      find ft_mstr where ft_domain = global_domain
                     and ft_terms = so_fr_terms
      no-lock no-error.
      if not available ft_mstr then do:
         /* INVALID FREIGHT TERMS */
         {pxmsg.i &MSGNUM=671 &ERRORLEVEL=3 &MSGARG1=so_fr_terms}
         next-prompt so_fr_terms with frame b1.
         undo setb1, retry.
      end. /* END OF NOT AVAILABLE ft_mstr */
   end. /* END OF so_fr_terms <> "" */

   /* IF LOGISTICS ACCOUNTING IS ENABLED */
   if use-log-acctg and so_fr_terms <> old_fr_terms and not new_order
   then do:
      order-on-shipper = no.

      /* CHECK IF ORDER ATTACHED TO AN UNCONFIRMED SHIPPER */
      {gprunmo.i  &module = "LA" &program = "larcsh02.p"
                  &param  = """(input so_nbr,
                                output l_parent_abs_id,
                                output order-on-shipper)"""}

      if order-on-shipper then do:
         /* FREIGHT TERMS CANNOT BE CHANGED. ORDER ON SHIPPER # */
         {pxmsg.i &MSGNUM=5373 &ERRORLEVEL=3
                  &MSGARG1=substring(l_parent_abs_id,2)}
         next-prompt so_fr_terms with frame b1.
         undo setb1, retry.
      end.
      else do:
         if so_fr_terms = "" then do:

            tax_type = "41".
            if so_fsm_type = "RMA" then
               tax_type = "46".

            /* DELETE ALL LOGISTICS ACCTG tx2d_det RECORDS FOR SO */
            {gprunmo.i &module = "LA" &program = "lataxdel.p"
                       &param  = """(input tax_type,
                                     input so_nbr,
                                     input 0)"""}

            /* DELETE LOGISTICS ACCTG CHARGE DETAIL */
            {gprunmo.i  &module = "LA" &program = "laosupp.p"
                        &param  = """(input 'DELETE',
                                      input '{&TYPE_SO}',
                                      input so_nbr,
                                      input ' ',
                                      input ' ',
                                      input ' ',
                                      input no,
                                      input no)"""}
         end.
         else do:
            /* UPDATE LOGISTICS ACCTG CHARGE DETAIL */
            {gprunmo.i  &module = "LA" &program = "laosupp.p"
                        &param  = """(input 'MODIFY',
                                      input '{&TYPE_SO}',
                                      input so_nbr,
                                      input ' ',
                                      input ft_lc_charge,
                                      input ft_accrual_level,
                                      input no,
                                      input no)"""}
         end.   /* so_fr_terms <> "" */
      end.   /* else order-on-shipper = no */
   end.   /* if so_fr_terms <> old_fr_terms */

   {&SOSOMTP-P-TAG12}
   /* IF IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT     */
   /* CREATE ROUTINE TO CREATE ie_mstr ied_det AND UPDATE  ie_mstr   */

   if impexp then do:
      hide frame b1 no-pause.
      imp-okay = no.
      {gprun.i ""iemstrcr.p""
         "(input ""1"",
           input so_nbr,
           input recid(so_mstr),
           input-output imp-okay )"}
      if imp-okay = no then do:
         undo setb1, retry.
      end.
   end.
   {&SOSOMTP-P-TAG13}

   for first cm_mstr
      fields(cm_domain cm_addr cm_promo)
      where cm_domain = global_domain
        and cm_addr = so_cust
   no-lock: end.

   if available cm_mstr then do:
      if soc_apm
         and cm_promo <> "" then do:
         hide frame b1 no-pause.
         {gprun.i ""sosoapm1.p""
            "(input cm_addr,
              input so_nbr,
              output o-error_flag)"}
         if o-error_flag then do:
            undo setb1, retry.
         end.
      end.  /* IF SOC_APM AND CM_PROMO <> "" */
   end.  /* IF AVAILABLE CM_MSTR */

end. /*setb1*/

/* DETERMINE IF CUSTOMER CONSIGNMENT POP-UP IS TO DISPLAY */
if using_cust_consignment and so_consignment and
   not this-is-rma then do:
   proc_id = "popup-update".
   {gprunmo.i
      &program=""socnso.p""
      &module="ACN"
      &param="""(input proc_id,
                 input so_nbr,
                 input so_ship,
                 input so_site,
                 input no)"""}

end. /* IF using_cust_consignment */

hide frame b1 no-pause.
undo_flag = false.
