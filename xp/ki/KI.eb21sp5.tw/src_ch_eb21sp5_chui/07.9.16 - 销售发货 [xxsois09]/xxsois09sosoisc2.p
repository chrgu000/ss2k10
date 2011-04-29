/* sosoisc2.p - SALES ORDER SHIPMENT TRAILER                                  */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.2            CREATED: 03/16/92   BY: tjs *F247*                */
/* REVISION: 7.2      LAST MODIFIED: 04/23/92   BY: sas *F379*                */
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: bcm *H127*                */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: dpm *FQ97*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: jxz *G0K1*                */
/* REVISION: 7.4      LAST MODIFIED: 06/06/95   BY: jym *G0ND*                */
/* REVISION: 8.5      LAST MODIFIED: 10/05/95   BY: taf *J053*                */
/* REVISION: 7.4      LAST MODIFIED: 12/27/95   BY: ais *G1HG*                */
/* REVISION: 8.5      LAST MODIFIED: 09/26/97   BY: *J21S* Niranjan Ranka     */
/* REVISION: 8.5      LAST MODIFIED: 12/30/97   BY: *J281* Manish Kulkarni    */
/* REVISION: 8.6      LAST MODIFIED: 11/07/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/13/98   BY: *J2MD* A. Philips         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *L116* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 01/24/01   BY: *M10S* Rajaneesh Sarangi  */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *N0WB* Mudit Mehta        */
/* Revision: 1.12.2.7      BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.12.2.8      BY: Vandna Rohira      DATE: 04/28/03  ECO: *N1YL* */
/* Revision: 1.12.2.9      BY: Narathip W.        DATE: 05/21/03  ECO: *P0S8* */
/* Revision: 1.12.2.11     BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.12.2.12     BY: Rajinder Kamra     DATE: 06/23/03  ECO: *Q003* */
/* Revision: 1.12.2.13     BY: Jean Miller        DATE: 06/23/03  ECO: *Q06C* */
/* Revision: 1.12.2.14     BY: Shivganesh Hegde   DATE: 09/22/04  ECO: *P2LM* */
/* Revision: 1.12.2.15     BY: Vinod Kumar        DATE: 12/10/04  ECO: *P2TK* */
/* $Revision: 1.12.2.15.1.2 $  BY: Robin McCarthy     DATE: 12/01/05  ECO: *P470* */
/*SS - 010307.1 by ken*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

/* DISPLAY TITLE */
{mfdeclre.i}
{cxcustom.i "SOSOISC2.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable so_recno as recid.

define shared variable so_mstr_recid as recid.
define shared variable undo-all like mfc_logical no-undo.
define shared variable eff_date like glt_effdate.
define shared variable undo_isc1 like mfc_logical.
define shared variable so_db   like dc_name.
define shared variable ship_db like dc_name.

define variable sonbr     like so_nbr no-undo.
define variable ship_via  like so_shipvia no-undo.
define variable ship_date like so_ship_date no-undo.
define variable bol       like so_bol no-undo.
define variable rmks      like so_rmks no-undo.
define variable inv_nbr   like so_inv_nbr no-undo.
define variable to_inv    like so_to_inv no-undo.
define variable invoiced  like so_invoiced no-undo.
define variable err_flag  as integer no-undo.
define variable w-accept  like mfc_logical no-undo.
define variable l_consolidate_ok as logical   no-undo.
define variable l_msg_text       as character no-undo.
{&SOSOISC2-P-TAG5}
define variable l_inv_nbr        like so_inv_nbr no-undo.

define buffer somstr for so_mstr.
define buffer simstr for si_mstr.
define shared frame f.
define shared frame sotot.

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* ASN API TEMP-TABLE */
{soshxt01.i}

{sosois1.i}
{mfsotrla.i}

if c-application-mode = "API" then do:

   /*
   * GET HANDLE OF API CONTROLLER
   */
   {gprun.i ""gpaigh.p""
      "( output apiMethodHandle,
         output apiProgramName,
         output apiMethodName,
         output apiContextString)"}

   /*
   * GET SO SHIPMENT HDR TEMP-TABLE
   */
   run getSoShipHdrRecord in apiMethodHandle
      (buffer ttSoShipHdr).

end. /* IF C-APPLICATION-MODE = "API" */

for first txc_ctrl
   fields(txc_domain txc__qad03)
   where txc_domain = global_domain
no-lock: end.

{&SOSOISC2-P-TAG6}
assign
   maint = yes
   undo-all = yes.

find so_mstr where recid(so_mstr) = so_mstr_recid exclusive-lock.

so_recno = recid(so_mstr).

form
   so_shipvia     colon 15
   so_inv_nbr     colon 55 skip
   so_ship_date   colon 15
   so_to_inv      colon 55 skip
   so_bol         colon 15
   so_invoiced    colon 55
   so_rmks        colon 15
with frame f side-labels width 80.

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f:handle).

assign
   sonbr = ""
   ship_via = ""
   ship_date = ?
   bol = ""
   rmks = ""
   inv_nbr = ""
   to_inv = no
   invoiced = no
   l_inv_nbr = so_mstr.so_inv_nbr.

{&SOSOISC2-P-TAG1}
settrl:
do on error undo, retry:

   if c-application-mode = "API" and retry
      then return error return-value.

   if c-application-mode <> "API" then do:
      if txc__qad03 then
         display
            l_nontaxable_lbl
            nontaxable_amt
            l_taxable_lbl
            taxable_amt
            with frame sotot.
      else
         display
            "" @ l_nontaxable_lbl
            "" @ nontaxable_amt
            "" @ l_taxable_lbl
            "" @ taxable_amt
            with frame sotot.

      display
         so_curr
         line_total
         so_disc_pct
         disc_amt
         tax_date
         user_desc[1]  so_trl1_cd  so_trl1_amt
         user_desc[2]  so_trl2_cd  so_trl2_amt
         user_desc[3]  so_trl3_cd  so_trl3_amt
         tax_amt
         ord_amt
         tax_edit
      with frame sotot.

      {&SOSOISC2-P-TAG2}
      {&SOSOISC2-P-TAG7}
      set
         so_shipvia
         so_ship_date
         so_bol
         so_rmks
         so_inv_nbr
         so_to_inv
         so_invoiced
      with frame f.
      {&SOSOISC2-P-TAG8}
      {&SOSOISC2-P-TAG3}

   end. /* IF C-APPLICATION-MODE <> "API" THEN */
   else
      assign
         {mfaiset.i so_shipvia ttSoShipHdr.ed_so_shipvia}
         {mfaiset.i so_ship_date ttSoShipHdr.ed_so_shp_date}
         {mfaiset.i so_bol ttSoShipHdr.ed_so_bol}
         {mfaiset.i so_rmks ttSoShipHdr.ed_remarks}
         {mfaiset.i so_inv_nbr ttSoShipHdr.ed_inv_nbr}
         {mfaiset.i so_to_inv  ttSoShipHdr.ed_ready_to_inv}
         {mfaiset.i so_invoiced  ttSoShipHdr.ed_invoiced}.

   w-accept = no.

   if can-find(mfc_ctrl where mfc_domain = global_domain and
                              mfc_module = "SO" and
                              mfc_seq = 170) and
   c-application-mode <> "API" then do while not w-accept:

      /* Please confirm update */
      {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=w-accept}

      if w-accept then leave.

      {&SOSOISC2-P-TAG9}

      set
         so_shipvia
         so_ship_date
         so_bol
         so_rmks
         so_inv_nbr
         so_to_inv
         so_invoiced
      with frame f.
      {&SOSOISC2-P-TAG10}

   end. /* multiple bol set */

      /*SS - 010307.1 B*/
      IF so_mstr.so_inv_nbr = "" THEN DO:

         next-prompt so_mstr.so_inv_nbr with frame f.
         /* DUPLICATE INVOICE NUMBER */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         undo settrl, retry.

      END.
      /*SS - 010307.1 E*/
      /*SS - 010408.1 B*/
      FIND FIRST rqm_mstr WHERE rqm_domain = GLOBAL_domain 
         AND rqm_nbr = so_mstr.so_inv_nbr NO-LOCK NO-ERROR.
      IF AVAIL rqm_mstr THEN DO:
         next-prompt so_mstr.so_inv_nbr with frame f.
         /* DUPLICATE INVOICE NUMBER */
         {pxmsg.i &MSGNUM=9901 &ERRORLEVEL=3}
         undo settrl, retry.
      END.
      /*SS - 010408.1 E*/


   if so_inv_nbr <> "" then do for somstr:

      /* CHECK FOR DUPLICATE INVOICE NUMBERS */
      for first somstr
         fields(so_domain so_bol so_curr so_disc_pct so_invoiced
                so_inv_nbr so_nbr so_pst_pct so_rmks so_shipvia so_ship_date
                so_site so_tax_pct so_to_inv so_trl1_amt so_trl1_cd
                so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd)
         where somstr.so_domain = global_domain
           and somstr.so_inv_nbr = so_mstr.so_inv_nbr
           and somstr.so_nbr <> so_mstr.so_nbr
      no-lock: end.

      for first ar_mstr
         fields(ar_domain ar_nbr)
         where ar_mstr.ar_domain = global_domain
           and ar_mstr.ar_nbr = so_mstr.so_inv_nbr
      no-lock: end.

      for first ih_hist
         fields(ih_domain ih_inv_nbr ih_nbr)
         where ih_domain = global_domain
           and ih_inv_nbr = so_mstr.so_inv_nbr
           and ih_nbr = so_mstr.so_nbr
      no-lock: end.

      if available somstr
      then do:

         for first si_mstr
            fields(si_domain si_site)
            where si_mstr.si_domain = global_domain
              and si_mstr.si_site = so_mstr.so_site
         no-lock: end.

         for first simstr
            fields(si_domain si_site)
            where simstr.si_domain = global_domain
              and simstr.si_site = somstr.so_site
         no-lock: end.

      end.
      if (available ar_mstr)
      then do:
         next-prompt so_mstr.so_inv_nbr with frame d.
         /* DUPLICATE INVOICE NUMBER */
         {pxmsg.i &MSGNUM=1165 &ERRORLEVEL=3}
         undo settrl, retry.
      end.
      else
      if (available ih_hist)
      then do:
         next-prompt so_mstr.so_inv_nbr with frame d.
         /* History for Sales Order/Invoice exists */
         {pxmsg.i &MSGNUM=1045 &ERRORLEVEL=3}
         undo settrl, retry.
      end.

      else do:

         if available somstr then do:

            /* PROCEDURE FOR CONSOLIDATION RULES */
            {gprun.i ""soconso.p""
               "(input 1,
                 input somstr.so_nbr,
                 input so_mstr.so_nbr,
                 output l_consolidate_ok,
                 output l_msg_text)"}

            if not l_consolidate_ok then do:
               next-prompt so_mstr.so_inv_nbr with frame d.
               /* Mismatch with open invoice - can't consolidate */
               {pxmsg.i &MSGNUM=1046 &ERRORLEVEL=3}
               undo settrl, retry.
            end.
            else do:
               /* Invoice already open.  Consolidation will be done */
               {pxmsg.i &MSGNUM=1047 &ERRORLEVEL=2}
               if c-application-mode <> "API" then
                  hide message.
            end.

         end.   /* avail somstr */

      end.  /* no ih_hist */
      {&SOSOISC2-P-TAG4}

   end.

   if so_mstr.so_inv_nbr = "" and so_mstr.so_invoiced = yes then do:
      next-prompt so_mstr.so_inv_nbr with frame f.
      {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /* Blank not allowed */
      undo settrl, retry.
   end.

   /* DELETE TYPE 16 TRANSACTION IF INVOICE NUMBER IS CHANGED */
   if so_mstr.so_inv_nbr <> l_inv_nbr
   then do:
      {gprun.i ""txdelete.p""
         "(input "16",
           input l_inv_nbr,
           input so_mstr.so_nbr)"}
   end.

   /* COPY THESE VALUE INTO REMOTE DOMAIN IF NECESSARY */
   if ship_db <> so_db then do:
      {gprun.i ""gpmdas.p"" "(input ship_db, output err_flag)" }
      if err_flag = 2 or err_flag = 3 then do:
         /* DOMAIN # IS NOT AVAILABLE*/
         {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=ship_db}
         if c-application-mode <> "API" then
            pause.
         undo settrl, retry.
      end.
   end.

   assign
      sonbr = so_nbr
      ship_via = so_shipvia
      ship_date = so_ship_date
      bol = so_bol
      rmks = so_rmks
      inv_nbr = so_inv_nbr
      to_inv = so_to_inv
      invoiced = so_invoiced.

   /* UPDATING SO TRAILER INFO AT REMOTE SITE */
   {gprun.i ""sosoisc3.p""
            "(input sonbr,
              input ship_via,
              input ship_date,
              input bol,
              input rmks,
              input inv_nbr,
              input to_inv,
              input invoiced)"}

   if ship_db <> so_db then do:
      {gprun.i ""gpmdas.p"" "(input so_db, output err_flag)" }
      if err_flag = 2 or err_flag = 3 then do:
         /* DOMAIN # IS NOT AVAILABLE*/
         {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=so_db}
         if c-application-mode <> "API" then
            pause.
         undo settrl, retry.
      end.
   end.

   /* SET PICK LIST REQUIRED TO YES */
   assign
      undo-all = no
      undo_isc1 = false.

end.
