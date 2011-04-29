/* icintr.p - COMMON PROGRAM FOR MISC INVENTORY TRANSACTIONS                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.47 $                                       */
/* REVISION: 2.1      LAST MODIFIED: 10/01/87   BY: wug                       */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: wug *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 04/09/90   BY: wug *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 07/30/90   BY: ram *D030*                */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: wug *D619*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: wug *D569*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: wug *D575*                */
/* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*                */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*                */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91   BY: wug *D920*                */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: wug *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 05/22/92   BY: pma *F522*                */
/* REVISION: 7.0      LAST MODIFIED: 05/27/92   BY: emb *F541*                */
/* REVISION: 7.0      LAST MODIFIED: 05/27/92   BY: jjs *F681*                */
/* REVISION: 7.0      LAST MODIFIED: 07/07/92   BY: pma *F735*                */
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: pma *F772*                */
/* REVISION: 7.3      LAST MODIFIED: 10/02/92   BY: mpp *G011*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: rwl *G264*                */
/* REVISION: 7.3      LAST MODIFIED: 11/30/92   BY: pma *G366*                */
/* REVISION: 7.3      LAST MODIFIED: 03/20/93   BY: pma *G852*                */
/* REVISION: 7.3      LAST MODIFIED: 03/31/93   BY: ram *G886*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.4      LAST MODIFIED: 09/01/93   BY: dpm *H075*                */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM10*                */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94   BY: ljm *GM02*                */
/* REVISION: 7.4      LAST MODIFIED: 10/11/94   BY: dpm *GN25*                */
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   by: rwl *GO25*                */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 12/21/94   BY: ktn *J041*                */
/* REVISION: 7.4      LAST MODIFIED: 12/22/94   by: pxd *F0BK*                */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   by: pxd *F0LZ*                */
/* REVISION: 8.5      LAST MODIFIED: 05/17/95   BY: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   by: rmh *J04R*                */
/* REVISION: 7.4      LAST MODIFIED: 07/13/95   by: dzs *G0S3*                */
/* REVISION: 7.3      LAST MODIFIED: 11/01/95   BY: ais *G0V9*                */
/* REVISION: 8.5      LAST MODIFIED: 03/05/96   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 05/01/96   BY: jym *G1MN*                */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *G1VC* Julie Milligan     */
/* REVISION: 8.6      LAST MODIFIED: 10/19/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *J1CZ* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 01/27/97   BY: *H0QP* Julie Milligan     */
/* REVISION: 8.6      LAST MODIFIED: 04/15/96   BY: *K08N* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/22/97   BY: *H1HN* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 03/26/00   BY: *N0DJ* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 9.1      LAST MODIFIED: 09/27/00   BY: *N0W6* Mudit Mehta        */
/* Revision: 1.20        BY: Niranjan R.         DATE: 07/12/01  ECO: *P00L*  */
/* Revision: 1.22        BY: Niranjan R.         DATE: 07/12/01  ECO: *P019*  */
/* Revision: 1.23        BY: Niranjan R.         DATE: 07/31/01  ECO: *P01B*  */
/* Revision: 1.24        BY: Niranjan R.         DATE: 08/31/01  ECO: *P01X*  */
/* Revision: 1.26        BY: Ellen Borden        DATE: 10/24/01  ECO: *P00G*  */
/* Revision: 1.27        BY: Samir Bavkar        DATE: 04/05/02  ECO: *P000*  */
/* Revision: 1.32        BY: Jean Miller         DATE: 05/15/02  ECO: *P05V*  */
/* Revision: 1.34        BY: Steve Nugent        DATE: 06/10/02  ECO: *P07Y*  */
/* Revision: 1.35        BY: Ashish Maheshwari   DATE: 07/17/02  ECO: *N1GJ*  */
/* Revision: 1.36        BY: Vinod Nair          DATE: 10/03/02  ECO: *N1WB*  */
/* Revision: 1.37        BY: Dorota Hohol        DATE: 02/25/03  ECO: *P0N6*  */
/* Revision: 1.39        BY: K Paneesh           DATE: 03/20/03  ECO: *P0NZ*  */
/* Revision: 1.40        BY: Manisha Sawant      DATE: 05/05/03  ECO: *N2F1*  */
/* Revision: 1.42        BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00G*  */
/* Revision: 1.44        BY: Jean Miller         DATE: 08/22/03  ECO: *P10J*  */
/* Revision: 1.45        BY: Dorota Hohol        DATE: 10/02/03 ECO: *P112* */
/* Revision: 1.46        BY: Russ Witt           DATE: 06/21/04  ECO: *P1CZ*  */
/* $Revision: 1.47 $       BY: Paul Dreslinski     DATE: 10/28/04  ECO: *M1LL*  */
/*By: Neil Gao 09/03/17 ECO: *SS 20090317* */

/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Type of transaction:  "RCT-UNP" (unplanned receipts)                       */
/*                       "RCT-SOR" (s.o. returns)                             */
/*                       "RCT-RS"  (return to stock)                          */
/*                       "RCT-WO"  (unplanned receipts backward exploded)     */
/*                       "ISS-UNP" (unplanned isue)                           */
/*                       "ISS-RV"  (return to vendor)                         */
/*                       "ISS-PRV" (PO rtn to vendor)                         */

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
{mfaititl.i} /* SUPPRESS DISPLAY OF SCREEN TITLE IN API MODE */
{cxcustom.i "ICINTR.P"}

define new shared variable yn like mfc_logical.
define new shared variable part like tr_part.
define new shared variable um like pt_um no-undo.
define new shared variable conv like um_conv label "Conversion" no-undo.
define new shared variable ref like glt_ref.
define new shared variable eff_date like glt_effdate label "Effective".
define new shared variable trlot like tr_lot.
define new shared variable qty_loc like tr_qty_loc.
define new shared variable qty_loc_label as character format "x(12)".
define new shared variable issrct as character format "x(3)".
define new shared variable issuereceipt as character format "x(7)".
define new shared variable unit_cost like tr_price label "Unit Cost".
define new shared variable total_amt like tr_gl_amt label "Total Cost".
define new shared variable ordernbr like tr_nbr.
define new shared variable orderline like tr_line.
define new shared variable so_job like tr_so_job.
define new shared variable addr like tr_addr.
define new shared variable rmks like tr_rmks.
define new shared variable serial like tr_serial.
define new shared variable dr_acct like trgl_dr_acct.
define new shared variable dr_sub like trgl_dr_sub.
define new shared variable dr_cc like trgl_dr_cc.
define new shared variable cr_acct like trgl_cr_acct.
define new shared variable cr_sub like trgl_cr_sub.
define new shared variable cr_cc like trgl_cr_cc.
define new shared variable trqty like tr_qty_loc.
define new shared variable i as integer.
define new shared variable tot_units as character format "x(16)".
define new shared variable del-yn like mfc_logical initial no.
define new shared variable null_ch as character initial "".
define new shared variable reject_qty_label as character format "x(11)".
define new shared variable qty_reject like tr_qty_loc.
define new shared variable qty_iss_rcv like qty_loc.
define new shared variable pt_recid as recid.
define new shared variable project like wo_proj.
define new shared variable multi_entry like mfc_logical label "Multi Entry"
   no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline as character.
define new shared variable issue_or_receipt as character.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable total_lotserial_qty like sr_qty label "Total Qty".
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable tr_recno as recid.

define shared variable transtype as character format "x(7)".

define variable lotum as character.
define variable dr_desc like ac_desc format "x(23)".
define variable cr_desc like ac_desc format "x(23)".
define variable dr_proj like wo_proj.
define variable cr_proj like wo_proj.

define variable valid_acct  like mfc_logical.
define variable undo-input  like mfc_logical.
define variable lotnext     like wo_lot_next .
define variable lotprcpt    like wo_lot_rcpt no-undo.
define variable error-found like mfc_logical.
define variable total_amt_fmt as character.
define variable shipnbr     like tr_ship_id no-undo.
define variable inv_mov     like tr_ship_inv_mov no-undo.
define variable ship_date   like tr_ship_date no-undo.
define variable gl-site     like in_site   no-undo.
define variable gl-set      like in_gl_set no-undo.

define variable dftPURAcct       like pl_pur_acct no-undo.
define variable dftPURSubAcct    like pl_pur_sub  no-undo.
define variable dftPURCostCenter like pl_pur_cc   no-undo.
define variable dftFLRAcct       like pl_flr_acct no-undo.
define variable dftFLRSubAcct    like pl_flr_sub  no-undo.
define variable dftFLRCostCenter like pl_flr_cc   no-undo.
define variable dftCOPAcct       like pl_cop_acct no-undo.
define variable dftCOPSubAcct    like pl_cop_sub  no-undo.
define variable dftCOPCostCenter like pl_cop_cc   no-undo.

define variable l_acct           like pl_pur_acct no-undo.
define variable l_sub            like pl_pur_sub  no-undo.
define variable l_cc             like pl_pur_cc   no-undo.
{&ICINTR-P-TAG8}
{&ICINTR-P-TAG6}

/* CONSIGNMENT VARIABLES. */
{socnvars.i}

define variable consigned_line             like mfc_logical  no-undo.

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}
/* INVENTORY CONTROL API TEMP-TABLE */
{icicit01.i}


{gpglefv.i}
{gprunpdf.i "gpglvpl" "p"}

if c-application-mode = "API" then do:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
            "(output apiMethodHandle,
              output apiProgramName,
              output apiMethodName,
              output apiContextString)"}

   /* GET TRANSACTION DETAIL TEMP-TABLE */
   run getInventoryTransDet in apiMethodHandle
      (output table ttInventoryTransDet).

   /* GET TRANSACTION RECORD FROM TEMP-TABLE
    * (ONLY THE FIRST RECORD IS PROCESSED)
    */
   run getInventoryTransRecord in apiMethodHandle
      (buffer ttInventoryTrans).
   assign
      transtype   = ttInventoryTrans.transType.

end. /* IF c-application-mode = "API" */


form
   pt_part             colon 17
   pt_lot_ser          colon 57
   pt_um
   pt_desc1            colon 17
   pt_desc2            at 19    no-label
   lotserial_qty       colon 17
   site                colon 57
   um                  colon 17
   location            colon 57
   conv                colon 17
   lotserial           colon 57
   lotref              colon 57
   multi_entry         colon 57
   unit_cost           colon 17
   total_lotserial_qty colon 57 format "->>>,>>>,>>9.9<<<<<<<<<"
   ordernbr            colon 17
   total_amt           colon 57
   orderline           colon 17
   so_job              colon 17
   addr                colon 17
/*SS 20090317 - B*/
/*
   rmks                colon 17
*/
   rmks                colon 17 format "x(24)"
/*SS 20090317 - E*/
   eff_date            colon 17
   dr_acct             colon 17
   dr_sub                       no-label
   dr_cc                        no-label
   dr_proj                      no-label
   dr_desc                      no-label
   cr_acct             colon 17
   cr_sub                       no-label
   cr_cc                        no-label
   cr_proj                      no-label
   cr_desc                      no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

if transtype = "ISS-RV" then do:
   if can-find(first po_mstr
               where po_domain = global_domain and
                     po_nbr >= "") and
      can-find(first ap_mstr
               where ap_domain = global_domain and
                     ap_type >= "" and ap_ref >= "")
   then do:
      /* Use PO RTS Issue */
      {pxmsg.i &MSGNUM=350 &ERRORLEVEL=2}
      pause.
      leave.
   end.
end.

issrct = substring(transtype,1,3).

if issrct = "RCT" then
   issue_or_receipt = getTermLabel("RECEIPT",8).
else
   issue_or_receipt = getTermLabel("ISSUE",8).

assign
   lotnext = ""
   lotprcpt = no.

{gprun.i ""socrshc.p""}
find first shc_ctrl where shc_domain = global_domain no-lock.

mainloop:
repeat:

   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API"
      then return error return-value.

   do transaction:

      for each sr_wkfl where sr_domain = global_domain and
                             sr_userid = mfguser
      exclusive-lock:
         delete sr_wkfl.
      end.

      {gprun.i ""gplotwdl.p""}

   end.

   /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
   if c-application-mode <> "API" then
      prompt-for pt_part with frame a no-validate
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i pt_mstr pt_part  "pt_domain = global_domain and pt_part"
              pt_part pt_part pt_part}

      if recno <> ? then
         display
            pt_part
            pt_desc1
            pt_um
            pt_lot_ser
            pt_desc2
         with frame a.

   end.

   status input.

   /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
   if c-application-mode = "API" then
      assign
         total_lotserial_qty = 0
         total_amt = 0.
   else
      display
         "" @ total_lotserial_qty
         "" @ total_amt
      with frame a.

   if c-application-mode = "API" then
       find pt_mstr where pt_domain = global_domain and
                          pt_part = ttInventoryTrans.part
        no-lock no-error.
   else
   find pt_mstr where pt_domain = global_domain and
                      pt_part   = input pt_part
   no-lock no-error.
   if not available pt_mstr then do:
      /* Item is not available */
      {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
      undo, retry.
   end.

   assign
      pt_recid = recid(pt_mstr)
      um = pt_um
      conv = 1.

   if eff_date = ? then eff_date = today.

   find pl_mstr where pl_domain    = global_domain and
                      pl_prod_line = pt_prod_line
   no-lock.

   do transaction:
      /* GET NEXT LOT */
      {mfnxtsq.i  "wo_domain = global_domain and "
                  wo_mstr wo_lot woc_sq01 trlot}
   end.

   /* SET GLOBAL PART VARIABLE */
   assign
      global_part = pt_part
      part = pt_part
      um = pt_um
      conv = 1.

   /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
   if c-application-mode <> "API" then
      display
         pt_part
         pt_lot_ser
         pt_um
         pt_desc1
         pt_desc2
         um
         conv
      with frame a.

   assign
      total_lotserial_qty = 0
      lotserial_control = pt_lot_ser.

   setd:
   repeat on endkey undo mainloop, retry mainloop:

      assign
         site = ""
         location = ""
         lotserial = ""
         lotref = ""
         lotserial_qty = total_lotserial_qty
         cline = ""
         global_part = pt_part
         i = 0.

      for each sr_wkfl where sr_domain = global_domain
                         and sr_userid = mfguser
                         and sr_lineid = cline
      no-lock:
         i = i + 1.
         if i > 1 then leave.
      end.

      if i = 0 and available pt_mstr then do:
         site = pt_site.
         location = pt_loc.
      end.

      else
      if i = 1 then do:
         find first sr_wkfl where sr_domain = global_domain
                              and sr_userid = mfguser
                              and sr_lineid = cline
         no-lock.
         site = sr_site.
         location = sr_loc.
         lotserial = sr_lotser.
         lotref = sr_ref.
      end.

      do on error undo, retry on endkey undo mainloop, retry mainloop:

         /* DO NOT RETRY WHEN PROCESSING API REQUEST */
         if retry and c-application-mode = "API"
            then return error return-value.
         /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
         if c-application-mode = "API" then do:
          /*
           * SUM TOTAL QUANTITY FROM LOT/SERIAL DETAIL
           */
            ACCUM-LOOP:
            for each ttInventoryTransDet no-lock:
               accumulate ttInventoryTransDet.qty (count).
               if (Accum count ttInventoryTransDet.qty) > 1
               then do:
                  multi_entry = yes.
                  leave ACCUM-LOOP.
               end.
            end.
            find first ttInventoryTransDet
               no-lock no-error.
            if not available ttInventoryTransDet then do:
               /* INVALID DATA PASSED */
               {pxmsg.i &MSGNUM=1960 &ERRORLEVEL=4}
            end.
            else assign
               {mfaiset.i lotserial_qty ttInventoryTransDet.qty}
               {mfaiset.i um ttInventoryTrans.um}
               {mfaiset.i conv ttInventoryTrans.conv}
               {mfaiset.i site ttInventoryTransDet.site}
               {mfaiset.i location ttInventoryTransDet.loc}
               {mfaiset.i lotserial ttInventoryTransDet.lotSer}
               {mfaiset.i lotref ttInventoryTransDet.ref}
               {mfaiset.i multi_entry yes}
                .
            /*
             * SET CURRENT POSITION TO FIRST RECORD FOR
             * SUB-PROGRAM ACCESS
             */
            run setInventoryTransDetRow
               in apiMethodHandle (input ?).
         end. /* IF c-application-mode = "API" */

         else /* IF c-application-mode <> "API" */
         update
            lotserial_qty
            um
            conv
            site
            location
            lotserial
            lotref
            multi_entry
         with frame a
         editing:
            global_site = input site.
            global_loc = input location.
            global_lot = input lotserial.
            readkey.
            apply lastkey.
         end.

         {&ICINTR-P-TAG9}

         if um <> pt_um then do:
            if not conv entered then do:
               {gprun.i ""gpumcnv.p""
                  "(input um, input pt_um, input pt_part, output conv)"}
               if conv = ? then do:
                  {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                  /* NO UOM CONVERSION EXISTS */
                  conv = 1.
               end.
               /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
               if c-application-mode <> "API" then
                  display conv with frame a.
            end.
         end.

         find in_mstr where in_domain = global_domain and
                            in_part   = pt_part and
                            in_site   = site
         no-lock no-error.

         /* GPSCT03.I LOOKS FOR IN_MSTR AND GETS THE COST, IF */
         /* IT IS NOT AVAILABLE, VALUES OF 0.00 ARE RETURNED. */
         /* IF NOT AVAIABLE,IN_MSTR IS CREATED LATER IN THIS  */
         /* PROGRAM.                                          */
         /* WITH LINKED SITE COSTING,IF THE SELECTED ITEM AND */
         /* SITE ARE LINKED TO ANOTHER SITE,I.E.IF A LINKING  */
         /* RULE EXIST FOR SELECTED SITE, THEN IN_MSTR IS     */
         /* CREATED WITH THE LINK. (I.E. IN_GL_COST SITE =    */
         /* SOURCE SITE AND IN_GL_SET = SOURCE GL COST SET.)  */
         /* THEREFORE FOR LINKED SITES THE UNIT COST RETRIEVED*/
         /* HERE SHOULD BE THE COST AT THE SOURCE SITE .      */
         /* TO AVOID CHANGING THE IN_MSTR CREATION TIMING WE  */
         /* FIND THE SOURCE SITE AND GET THE COST AT THAT SITE*/

         gl-site = site.

         if not available in_mstr then do:
            /* SITE VALIDATION IS DONE LATER IN THE PROGRAM. WE */
            /* NEED TO MAKE SURE si_mstr is AVAILABLE BEFORE    */
            /* CALLING gpingl.p.                                */
            for first si_mstr where si_domain = global_domain and
                                    si_site   = site
            no-lock: end.
            if available si_mstr then
               {gprun.i ""gpingl.p""
                        "(input  site,
                          input  pt_part,
                          output gl-site,
                          output gl-set)"}
            for first in_mstr where in_domain = global_domain and
                                    in_part = pt_part and
                                    in_site = gl-site
            no-lock: end.
         end. /* IF NOT AVAILABLE IN_MSTR */

         if transtype = "ISS-RV" or transtype = "ISS-PRV" then do:
            {gpsct03.i &cost=sct_mtl_tl}
         end.
         else do:
            {gpsct03.i &cost=sct_cst_tot}
         end.

         unit_cost = glxcst.

         i = 0.
         for each sr_wkfl where sr_domain = global_domain and
                                sr_userid = mfguser and
                                sr_lineid = cline
         no-lock:
            i = i + 1.
            if i > 1 then do:
               multi_entry = yes.
               leave.
            end.
         end.

         trans_um = um.
         trans_conv = conv.

         if multi_entry then do:

            if i >= 1 then do:
               site = "".
               location = "".
               lotserial = "".
               lotref = "".
            end.

            /* ADDED SIXTH INPUT PARAMETER AS NO */
            {gprun.i ""icsrup.p""
               "(input ?,
                 input """",
                 input """",
                 input-output lotnext,
                 input lotprcpt,
                 input no)"}
         end.

         else do:

            {gprun.i ""icedit.p""
               "(transtype,
                 site,
                 location,
                 part,
                 lotserial,
                 lotref,
                 lotserial_qty * trans_conv,
                 trans_um,
                 """",
                 """",
                 output undo-input)"}

            if undo-input then undo, retry.

            find first sr_wkfl where sr_domain = global_domain
                                 and sr_userid = mfguser
                                 and sr_lineid = cline
            no-error.

            if lotserial_qty = 0 then do:
               if available sr_wkfl then do:
                  total_lotserial_qty = total_lotserial_qty - sr_qty.
                  delete sr_wkfl.
               end.
            end.

            else do:

               if available sr_wkfl then do:
                  assign
                     total_lotserial_qty = total_lotserial_qty - sr_qty
                     + lotserial_qty
                     sr_site = site
                     sr_loc = location
                     sr_lotser = lotserial
                     sr_ref = lotref
                     sr_qty = lotserial_qty.
               end.

               else do:

                  create sr_wkfl.
                  assign
                     sr_domain = global_domain
                     sr_userid = mfguser
                     sr_lineid = cline
                     sr_site   = site
                     sr_loc    = location
                     sr_lotser = lotserial
                     sr_ref    = lotref
                     sr_qty    = lotserial_qty.

                  if recid(sr_wkfl) = -1 then .

                  total_lotserial_qty = total_lotserial_qty + lotserial_qty.

               end.

            end.

         end.

      end.

      /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
      if c-application-mode <> "API" then do:
         display
            total_lotserial_qty
            "" @ total_amt
         with frame a.
      end. /* IF c-application-mode <> "API" */

      unit_cost = unit_cost * conv.

      run getGLDefaults.
      run getPurchaseAccountDefaults.

      if issrct = "RCT" then do:

         assign
            dr_acct = ""
            dr_sub = ""
            dr_cc = ""
            dr_proj = ""
            dr_desc = "".

         if transtype = "RCT-SOR" then do:
            find first gl_ctrl where gl_domain = global_domain no-lock.
            assign
               cr_acct = gl_rtns_acct
               cr_sub  = gl_rtns_sub
               cr_cc = gl_rtns_cc.
         end.

         else
         if transtype = "RCT-UNP" then do:
            {&ICINTR-P-TAG1}
            assign
               cr_acct = dftPURAcct
               cr_sub  = dftPURSubAcct
               cr_cc   = dftPURCostCenter.
         end.

         else
         if transtype = "RCT-RS" then do:

            find first ptp_det where ptp_domain = global_domain
                                 and ptp_part   = pt_part
                                 and ptp_site   = in_site
            no-lock no-error.

            if ((available ptp_det and ptp_iss_pol = no) or
                (not available ptp_det and available pt_mstr and pt_iss_pol = no))
            then do:
               assign
                  cr_acct = dftFLRAcct
                  cr_sub  = dftFLRSubAcct
                  cr_cc   = dftFLRCostCenter.
            end.

            else do:
               assign
                  cr_acct = dftCOPAcct
                  cr_sub  = dftCOPSubAcct
                  cr_cc   = dftCOPCostCenter.
            end.

         end.

         find ac_mstr where ac_domain = global_domain and
                            ac_code   = cr_acct
         no-lock no-error.
         if available ac_mstr then
            cr_desc = ac_desc.
         else
            cr_desc = "".
      end.

      else
      if issrct = "ISS" then do:

         assign
            cr_acct = ""
            cr_sub = ""
            cr_cc = ""
            cr_proj = ""
            cr_desc = "".

         if transtype = "ISS-RV" or transtype = "ISS-PRV" then do:
            assign
               dr_acct = dftPURAcct
               dr_sub  = dftPURSubAcct
               dr_cc   = dftPURCostCenter.
         end.

         else
         if transtype = "ISS-UNP" then do:

            {&ICINTR-P-TAG2}

            find first ptp_det where ptp_domain = global_domain
                                 and ptp_part   = pt_part
                                 and ptp_site   = in_site
            no-lock no-error.

            if ((available ptp_det and ptp_iss_pol = no) or
                (not available ptp_det and available pt_mstr and pt_iss_pol = no))
            then do:
               assign
                  dr_acct = dftFLRAcct
                  dr_sub  = dftFLRSubAcct
                  dr_cc   = dftFLRCostCenter.
            end.
            else do:
               assign
                  dr_acct = dftCOPAcct
                  dr_sub  = dftCOPSubAcct
                  dr_cc   = dftCOPCostCenter.
            end.

            {&ICINTR-P-TAG3}

         end.

         find ac_mstr where ac_domain = global_domain and
                            ac_code   = dr_acct
         no-lock no-error.
         if available ac_mstr then
            dr_desc = ac_desc.
         else
            dr_desc = "".

      end.

      /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
      if c-application-mode <> "API" then do:
         display dr_desc cr_desc with frame a.
      end. /* IF c-application-mode <> "API" */

      if eff_date = ? then eff_date = today.

      seta:
      do on endkey undo mainloop, retry mainloop on error undo, retry
      with frame a:
          /* DO NOT RETRY IF PROCESSING API REQUEST */
         if retry and c-application-mode = "API"
            then return error return-value.

         /*  IF THIS IS A BATCH RUN AND WE ARE DOING A RETRY, UNDO   */
         /*  AND LEAVE MAINLOOP (mfglef.i ERROR WAS INEFFECTIVE)     */
         {gpcimex.i "mainloop"}

         if c-application-mode <> "API" then
            display unit_cost with frame a.

         if transtype = "RCT-UNP"
         then
            assign
               l_acct = cr_acct
               l_sub  = cr_sub
               l_cc   = cr_cc.

         else
         if transtype = "ISS-RV"
         or transtype = "ISS-PRV"
         then
            assign
               l_acct = dr_acct
               l_sub  = dr_sub
               l_cc   = dr_cc.

         if c-application-mode <> "API" then do:
            display unit_cost with frame a.

            update
               ordernbr
               orderline
               so_job
               addr
               rmks
               eff_date
               dr_acct when (issrct = "ISS")
               dr_sub  when (issrct = "ISS")
               dr_cc   when (issrct = "ISS")
               dr_proj when (issrct = "ISS")
               cr_acct when (issrct <> "ISS")
               cr_sub  when (issrct <> "ISS")
               cr_cc   when (issrct <> "ISS")
               cr_proj when (issrct <> "ISS")
            with frame a.
         end.

         else do: /* IF c-application-mode = "API" */
            assign
               {mfaiset.i ordernbr  ttInventoryTrans.nbr}
               {mfaiset.i orderline ttInventoryTrans.line}
               {mfaiset.i so_job    ttInventoryTrans.soJob}
               {mfaiset.i addr      ttInventoryTrans.addr}
               {mfaiset.i rmks      ttInventoryTrans.rmks}
               {mfaiset.i project   ttInventoryTrans.project}
               {mfaiset.i eff_date  ttInventoryTrans.effdate}.
            if issrct = "ISS" then
               assign
                  {mfaiset.i dr_acct ttInventoryTrans.drAcct}
                  {mfaiset.i dr_cc   ttInventoryTrans.drCc}.
            else
               assign
                  {mfaiset.i cr_acct ttInventoryTrans.crAcct}
                  {mfaiset.i cr_cc   ttInventoryTrans.crCc}.
         end.

         project = if issrct = "ISS" then dr_proj else cr_proj.

         if addr <> " " then do:

            run getPurchaseAccountDefaults.

            if transtype = "RCT-UNP" then do:
               assign
                  cr_acct = if l_acct = cr_acct
                            then
                               dftPURAcct
                            else
                               cr_acct
                  cr_sub  = if l_sub = cr_sub
                            then
                               dftPURSubAcct
                            else
                               cr_sub
                  cr_cc   = if l_cc = cr_cc
                            then
                               dftPURCostCenter
                            else
                               cr_cc.

               if c-application-mode <> "API" then
                  display
                     cr_acct
                     cr_sub
                     cr_cc
                  with frame a.
            end.

            else
            if transtype = "ISS-RV" or transtype = "ISS-PRV" then do:
               assign
                  dr_acct = if l_acct = dr_acct
                            then
                               dftPURAcct
                            else
                               dr_acct
                  dr_sub  = if l_sub = dr_sub
                            then
                               dftPURSubAcct
                            else
                               dr_sub
                  dr_cc   = if l_cc = dr_cc
                            then
                               dftPURCostCenter
                            else
                               dr_cc.
               if c-application-mode <> "API" then
                  display
                     dr_acct
                     dr_sub
                     dr_cc
                  with frame a.
            end.

         end.

         /* CHECK EFFECTIVE DATE */
         find si_mstr where si_domain = global_domain and
                            si_site   = site no-lock.
         {gpglef1.i
            &module = ""IC""
            &entity = si_entity
            &date = eff_date
            &prompt = "eff_date"
            &frame = "a"
            &loop = "seta"}

         /*VALIDATE ACCOUNTS*/
         find first gl_ctrl where gl_domain = global_domain no-lock no-error.

         if gl_verify then do with frame a:

            if issrct = "ISS" then do:

               if c-application-mode = "API" or
                  batchrun then do:
                  run verify-gl-accounts
                     (input dr_acct,
                      input dr_sub,
                      input dr_cc,
                      input project,
                      output valid_acct).
                  if valid_acct = no then do:
                     next-prompt dr_acct with frame a.
                     undo mainloop, retry.
                  end.
               end.

               else do:
                  run verify-gl-accounts
                     (input dr_acct,
                      input dr_sub,
                      input dr_cc,
                      input project,
                      output valid_acct).
                  if valid_acct = no then do:
                     next-prompt dr_acct with frame a.
                     undo, retry.
                  end.
               end.

            end. /* if issrct = "ISS" */

            else do:

               if c-application-mode = "API" or batchrun then do:
                  run verify-gl-accounts
                     (input cr_acct,
                     input cr_sub,
                     input cr_cc,
                     input project,
                     output valid_acct).
                  if valid_acct = no then do:
                     next-prompt cr_acct with frame a.
                     undo mainloop, retry.
                  end.
               end.

               else do:
                  run verify-gl-accounts
                     (input cr_acct,
                      input cr_sub,
                      input cr_cc,
                      input project,
                      output valid_acct).
                  if valid_acct = no then do:
                     next-prompt cr_acct with frame a.
                     undo, retry.
                  end.
               end.

            end. /* if issrct <> "ISS" */

         end. /* if gl_verify */

      end.

      find ac_mstr no-lock  where ac_mstr.ac_domain = global_domain and
      ac_code = dr_acct no-error.
      if available ac_mstr then
         dr_desc = ac_desc.
      else
         dr_desc = "".

      find ac_mstr no-lock  where ac_mstr.ac_domain = global_domain and
      ac_code = cr_acct no-error.
      if available ac_mstr then
         cr_desc = ac_desc.
      else
         cr_desc = "".

      if c-application-mode <> "API" then
         display
            dr_desc
            cr_desc
         with frame a.

      total_amt = unit_cost * total_lotserial_qty.
      {gprun.i ""gpcurrnd.p""
         "(input-output total_amt, input gl_rnd_mthd)"}

      total_amt_fmt = total_amt:format.
      {gprun.i ""gpcurfmt.p""
         "(input-output total_amt_fmt, input gl_rnd_mthd)"}

      total_amt:format = total_amt_fmt.

      if c-application-mode <> "API" then
         display total_amt with frame a.

      i = 0.
      for each sr_wkfl no-lock  where sr_wkfl.sr_domain = global_domain and
      sr_userid = mfguser
            and sr_lineid = cline:
         i = i + 1.
         if i > 1 then do:
            leave.
         end.
      end.

      if i > 1 and c-application-mode <> "API" then
      do on endkey undo mainloop, retry mainloop:

         yn = yes.
         /* DISPLAY LOTSERIALS BEING RECEIVED? */
         {pxmsg.i &MSGNUM=359 &ERRORLEVEL=1 &CONFIRM=yn}

         if yn then do:

            hide frame a.

            form
               pt_part
            with frame b side-labels width 80.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

            display pt_part with frame b.

            for each sr_wkfl no-lock  where sr_wkfl.sr_domain = global_domain
            and  sr_userid = mfguser
            with frame f-a width 80:

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame f-a:handle).

               display
                  sr_site
                  sr_loc
                  sr_lotser
                  sr_ref  format "x(8)" column-label "Ref"
                  sr_qty  format "->>>,>>>,>>9.9<<<<<<<<<".

               {gpwait.i &INSIDELOOP=YES &FRAMENAME=f-a}

            end.

            {gpwait.i &OUTSIDELOOP=YES}

         end.

      end.

      assign
         shipnbr = ""
         ship_date = ?
         {&ICINTR-P-TAG4}
         inv_mov = "".
         {&ICINTR-P-TAG5}

      /* Pop-up to collect shipment information */
      if transtype = "RCT-UNP" or
         transtype = "RCT-SOR" or
         transtype = "RCT-RS"
      then do:

         ship_date = eff_date.

         if shc_ship_rcpt then do:
            pause 0.
            {gprun.i ""icshup.p""
               "(input-output shipnbr,
                 input-output ship_date,
                 input-output inv_mov,
                 input transtype, yes,
                 input 10,
                 input 20)"}
         end. /* if shc_ship_rcpt */

      end. /* if transtype = "RCT-UNP" or ... */

      do on endkey undo mainloop, retry mainloop:

         /* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
         {gprun.i ""gpmfc01.p""
              "(input ENABLE_CUSTOMER_CONSIGNMENT,
                input 10,
                input ADG,
                input CUST_CONSIGN_CTRL_TABLE,
                output using_cust_consignment)"}

         if using_cust_consignment and
            ((transtype = "ISS-UNP"  and lotserial_qty < 0) or
             (transtype = "RCT-UNP"  and lotserial_qty > 0)) and
            ordernbr    <> "" and
            lotserial_qty <> 0
         then do:

            /*Check sales order to see if it is consigned and      */
            /* that the transfer item matches the sales order item*/
            run checkConsignedOrder
               (input ordernbr,
                input orderline,
                input pt_part,
                output consigned_line,
                output error-found).

            if error-found then do:
               /* MATCHING ORDER LINE ITEM FOR THIS PART NOT FOUND*/
               {pxmsg.i &MSGNUM=8285 &ERRORLEVEL=3}
                 next setd.
            end.

         end. /*if using_cust_consignment*/

         if using_cust_consignment and
            ((transtype = "ISS-UNP"  and lotserial_qty > 0) or
             (transtype = "RCT-UNP"  and lotserial_qty < 0)) and
            lotserial_qty <> 0
         then do:

            run checkConsignmentInventory
               (input ordernbr,
                input orderline,
                input site,
                input pt_part,
                input location,
                input lotserial,
                input lotref,
                input lotserial_qty * trans_conv,
                output error-found).

            if error-found
               then do:
               /* UNABLE TO ISSUE/RECEIVE CONSIGNED INVENTORY*/
               {pxmsg.i &MSGNUM=4937 &ERRORLEVEL=3}
               next setd.
            end.

         end. /*if using_cust_consignment*/

         yn = yes.

         if c-application-mode <> "API" then do:
            /* IS ALL INFO CORRECT? */
            {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
         end.

         /* ADDED SECTION TO DO FINAL ISSUE CHECK */
         if yn then do:

            release ld_det.

            {icintr2.i "sr_userid = mfguser"
               transtype
               pt_part
               trans_um
               error-found
               """"}

            if error-found then do:
               /* UNABLE TO ISSUE OR RECEIVE FOR ITEM*/
               {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3 &MSGARG1=part}
               next setd.
            end.

            leave setd.

         end.
         if c-application-mode = "API" then leave setd.
      end.

   end. /*setd*/

   /* FOURTH PARAMETER IS KANBAN ID - NOT USED HERE SO PASS AS 0     */
   {gprun.i ""icintra.p"" "(shipnbr, ship_date, inv_mov, 0, true)" }

   {&ICINTR-P-TAG7}

   if c-application-mode = "API" then leave.

   hide frame b.

end.

if c-application-mode = "API" then return {&SUCCESS-RESULT}.

PROCEDURE verify-gl-accounts:
   /* THIS SUBROUTINE DETERMINES THE VALIDITY OF THE ACCOUNT, SUB-    */
   /* ACCOUNT, COST CENTER AND PROJECT  USING THE PERSISTENT          */
   /* PROCEDURES.                                                     */
   define input  parameter acct     like trgl_dr_acct no-undo.
   define input  parameter sub      like trgl_dr_sub no-undo.
   define input  parameter cc       like trgl_dr_cc   no-undo.
   define input  parameter proj     like wo_proj   no-undo.
   define output parameter glvalid  like mfc_logical initial true no-undo.

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* AP_ACCT/SUB/CC VALIDATION */
   {gprunp.i "gpglvpl" "p" "validate_fullcode"
      "(input acct,
        input sub,
        input cc,
        input proj,
        output glvalid)"}

END PROCEDURE.

PROCEDURE getGLDefaults:
   /* FIND DEFAULT FOR COST OF PRODUCTION ACCT */

   {gprun.i ""glactdft.p""
      "(input ""WO_COP_ACCT"",
        input pt_mstr.pt_prod_line,
        input if available in_mstr then in_mstr.in_site
                                   else site,
        input """",
        input """",
        input no,
        output dftCOPAcct,
        output dftCOPSubAcct,
        output dftCOPCostCenter)"}

   /* FIND DEFAULT FOR FLOOR STOCK ACCT */
   {gprun.i ""glactdft.p""
      "(input ""WO_FLR_ACCT"",
        input pt_mstr.pt_prod_line,
        input if available in_mstr then in_mstr.in_site
                                   else site,
        input """",
        input """",
        input no,
        output dftFLRAcct,
        output dftFLRSubAcct,
        output dftFLRCostCenter)"}

END PROCEDURE.

PROCEDURE getPurchaseAccountDefaults:

   /* Find default for purchases acct */
   for first vd_mstr
      fields( vd_domain vd_addr vd_type)
       where vd_mstr.vd_domain = global_domain and vd_addr = addr
   no-lock: end.

   {gprun.i ""glactdft.p""
      "(input ""PO_PUR_ACCT"",
        input pt_mstr.pt_prod_line,
        input if available in_mstr then in_mstr.in_site
                                   else site,
        input if available vd_mstr then vd_type
                                   else """",
        input """",
        input no,
        output dftPURAcct,
        output dftPURSubAcct,
        output dftPURCostCenter)"}

END PROCEDURE.

PROCEDURE checkConsignmentInventory:

   define input  parameter ip_ordernbr    as character no-undo.
   define input  parameter ip_orderline   as character no-undo.
   define input  parameter ip_site        like ld_site no-undo.
   define input  parameter ip_part        like ld_part no-undo.
   define input  parameter ip_location    like ld_loc  no-undo.
   define input  parameter ip_lotser      like ld_lot  no-undo.
   define input  parameter ip_ref         like ld_ref  no-undo.
   define input  parameter ip_tran_qty    as decimal   no-undo.
   define output parameter op_error      as logical   no-undo.

   define variable consigned_line        as logical   no-undo.
   define variable unconsigned_qty       as decimal   no-undo.
   define variable consigned_qty_oh      as decimal   no-undo.
   define variable location_qty          as decimal   no-undo.
   define variable procid                as character no-undo.

   /*IF A SALES ORDER WAS ENTERED, CHECK WHETHER IT IS FOR A   */
   /*CONSIGNED ITEM.                                           */

   if ip_ordernbr <> "" then do:
      run checkConsignedOrder
         (input ip_ordernbr,
          input ip_orderline,
          input ip_part,
          output consigned_line,
          output op_error).
      if consigned_line then
         op_error = yes.
      else
         op_error = no.
   end.

   if not op_error then do:
      /*IF CONSIGNED, FIND OUT HOW MUCH NON-CONSIGNED INVENTORY   */
      /*IS AT THE LOCATION. IF THERE IS NOT ENOUGH TO COVER THE   */
      /*QTY BEING ISSUED, THEN ERROR.                             */

      /*RETRIEVE THE TOTAL QTY ON-HAND FOR THE LOCATION */
      for first ld_det
          fields( ld_domain ld_qty_oh ld_cust_consign_qty)
           where ld_domain = global_domain and
                 ld_part = ip_part     and
                 ld_site = ip_site     and
                 ld_loc  = ip_location and
                 ld_lot  = ip_lotser   and
                 ld_ref  = ip_ref
      no-lock:
         assign
             location_qty  = ld_qty_oh
             consigned_qty_oh = ld_cust_consign_qty.

      end. /*for first ld_det*/

      unconsigned_qty = location_qty - consigned_qty_oh.

      if (consigned_qty_oh <> 0) and
         ((ip_tran_qty > 0 and unconsigned_qty < ip_tran_qty) or
          (ip_tran_qty < 0 and unconsigned_qty < (ip_tran_qty * -1)))
      then
        op_error = yes.

   end.

END PROCEDURE. /*checkConsignmentInventory*/

PROCEDURE checkConsignedOrder:
   define input parameter ip_ordernbr    as character no-undo.
   define input parameter ip_orderline   as character no-undo.
   define input parameter ip_part        as character no-undo.
   define output parameter op_consigned  as logical   no-undo.
   define output parameter op_error      as logical   no-undo.

   op_consigned = no.

   {gprunmo.i
      &program = "socnsod1.p"
      &module = "ACN"
      &param = """(input ip_ordernbr,
                   input ip_orderline,
                   output op_consigned,
                   output consign_loc,
                   output intrans_loc,
                   output max_aging_days,
                   output auto_replenish)"""}

   if op_consigned then do:
      if can-find(first sod_det where
                        sod_domain = global_domain and
                        sod_nbr = ordernbr and
                        sod_line = orderline and
                        sod_part = ip_part)
      then
         op_error = no.
      else
         op_error = yes.
   end. /* IF op_consigned */

END PROCEDURE. /*checkConsignedOrder*/
