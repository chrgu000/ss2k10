/* porvism.p - PURCHASE ORDER RETURN W/ SERIAL NUMBER CONTROL                */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */

/* REVISION: 7.3            CREATED: 11/08/94   BY: bcm *GO37*               */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J040*               */
/* REVISION: 8.5      LAST MODIFIED: 07/28/95   BY: kxn *J066*               */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*               */
/* REVISION: 7.3      LAST MODIFIED: 08/30/95   BY: ais *G0VX*               */
/* REVISION: 8.5      LAST MODIFIED: 10/13/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 01/09/96   BY: tjs *J0B1*               */
/* REVISION: 8.5      LAST MODIFIED: 02/14/96   BY: rxm *H0JJ*               */
/* REVISION: 8.5      LAST MODIFIED: 04/23/96   BY: ajw *J0K5*               */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: rxm *G1SL*               */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: taf *J0ZS*               */
/* REVISION: 8.5      LAST MODIFIED: 07/30/96   BY: *G2B5* suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 10/30/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 08/14/97   BY: *H1B4* Manmohan K.Pardesi*/
/* REVISION: 8.6      LAST MODIFIED: 09/10/97   BY: *H1F0* Ajit Deodhar      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *J2MG* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *L020* Charles Yen       */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent      */
/* REVISION: 8.6E     LAST MODIFIED: 10/26/98   BY: *L0CF* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED: 07/21/99   BY: *J3JP* Prashanth Narayan */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates        */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* David Morris      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/10/00   BY: *L0Z4* Abhijeet Thakur   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 01/12/01   BY: *N0VL* Manish K.         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.19.3.8      BY: Katie Hilbert     DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.19.3.9      BY: Rajaneesh S.      DATE: 05/08/01  ECO: *M0W6* */
/* Revision: 1.19.3.10     BY: Jean Miller       DATE: 05/08/01  ECO: *M11Z* */
/* Revision: 1.19.3.11     BY: John Pison        DATE: 03/08/02  ECO: *N1BT* */
/* Revision: 1.19.3.12     BY: Ashwini G.        DATE: 04/26/02  ECO: *M1XB* */
/* Revision: 1.19.3.13     BY: Jeff Wootton      DATE: 05/23/02  ECO: *P075* */
/* Revision: 1.19.3.14     BY: Ellen Borden      DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.19.3.15     BY: Ashish Maheshwari DATE: 06/03/02  ECO: *N1K6* */
/* Revision: 1.19.3.16     BY: Steve Nugent      DATE: 06/13/02  ECO: *P08K* */
/* Revision: 1.19.3.17     BY: Luke Pokic        DATE: 06/19/02  ECO: *P099* */
/* Revision: 1.19.3.18     BY: Ashish Maheshwari DATE: 11/27/02  ECO: *N204* */
/* Revision: 1.19.3.20     BY: Pawel Grzybowski  DATE: 03/27/03  ECO: *P0NT* */
/* Revision: 1.19.3.23     BY: Paul Donnelly     DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.19.3.24     BY: Rajinder Kamra    DATE: 04/25/03  ECO: *Q003* */
/* Revision: 1.19.3.25     BY: Ed van de Gevel   DATE: 08/14/03  ECO: *Q024* */
/* Revision: 1.19.3.26     BY: Laxmikant Bondre  DATE: 02/06/04  ECO: *P1MV* */
/* Revision: 1.19.3.27     BY: Subramanian Iyer  DATE: 03/19/04  ECO: *N2QC* */
/* Revision: 1.19.3.28     BY: Veena Lad         DATE: 06/03/04  ECO: *P24K* */
/* Revision: 1.19.3.29     BY: Swati Sharma      DATE: 03/04/05  ECO: *P3B2* */
/* Revision: 1.19.3.31     BY: Shivganesh Hegde  DATE: 04/15/05  ECO: *P3FL* */
/* Revision: 1.19.3.32     BY: Steve Nugent      DATE: 08/23/05  ECO: *P2PJ* */
/* $Revision: 1.19.3.32.1.1 $  BY: Sushant Pradhan   DATE: 05/16/06  ECO: *P4RC* */
/* By: Neil Gao Date: 07/12/23 ECO: * ss 20071223 * */

/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Maintenance                                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
    porvism.p - Purchase Order Returns
*/

/*!
    ANY CHANGES MADE TO PORVISM.P MAY ALSO BE NEEDED IN POPORC.P
*/


/* INCREASED THE SCOPE OF TRANSACTION TO AVOID READING/UPDATING          */
/* THE SAME PURCHASE ORDER SIMULTANEOUSLY IN MULTIPLE SESSIONS           */

/* DISPLAY TITLE */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* COMMON VARIABLES ARE DECLARED IN porcdef.i */
{porcdef.i "new"}

{gpglefdf.i}
{cxcustom.i "PORVISM.P"}
{pxsevcon.i} /* SEVERITY PREPROCESSOR CONSTANT DEFN INCLUDE FILE */
{pxmaint.i} /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxphdef.i mcpl} /* INCLUDE FILE FOR DEFINING PERSISTENT HANDLE */
{pxpgmmgr.i} /* INCLUDE FILE FOR RETRIEVING PROGRAM MANAGER */

{&PORVISM-P-TAG1}
/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable rndmthd     like rnd_rnd_mthd.
define new shared variable fiscal_id   like prh_receiver.
define new shared variable fiscal_rec  as logical initial no.
define new shared variable maint       like mfc_logical no-undo.
define new shared variable qopen       like pod_qty_rcvd label "Net Received".
define new shared variable receivernbr like prh_receiver label "RTV Nbr".
define new shared variable msg         as character format "x(60)".
define new shared variable l_tt_consign like mfc_logical no-undo.
define new shared variable l_pod_det_recid as   recid    no-undo.

/* KANBAN TRANSACTION NUMBER NEEDED FOR POPORCB8.P */
define new shared variable kbtransnbr  as integer no-undo.

/* MOVED TO POTRLDEF.I */
define new shared variable convertmode as character no-undo.

define new shared workfile tax_wkfl
   field tax_nbr                   like pod_nbr
   field tax_line                  like pod_line
   field tax_env                   like pod_tax_env
   field tax_usage                 like pod_tax_usage
   field tax_taxc                  like pod_taxc
   field tax_in                    like pod_tax_in
   field tax_taxable               like pod_taxable
   field tax_price                 like prh_pur_cost.

/*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
define new shared workfile attr_wkfl no-undo
   field chg_line   like sr_lineid
   field chg_assay  like tr_assay
   field chg_grade  like tr_grade
   field chg_expire like tr_expire
   field chg_status like tr_status
   field assay_actv as logical
   field grade_actv as logical
   field expire_actv as logical
   field status_actv as logical.

/* LOGISTICS CHARGE - PENDING VOUCHER MASTER TEMP TABLE DEFINITION */
define new shared temp-table tt-pvocharge no-undo
   field tt-lc_charge           like lc_charge
   field tt-pvo_id              as   integer
   index tt-index
   tt-lc_charge
   tt-pvo_id.

define new shared variable vendlot      like tr_vend_lot no-undo.
/* DEFINE SHARED VARIABLE PRM-AVAIL SINCE IT IS REQUIRED */
/* BY THE SUBROUTINE POPORCB6.P                          */
define new shared variable prm-avail    like mfc_logical initial no no-undo.
define new shared variable receipt_date like prh_rcp_date no-undo.

define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.

define new shared frame    b.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define            variable yn          like mfc_logical.
define            variable pook        like mfc_logical.
define            variable ent_exch    like exr_rate.
define            variable cmmt_yn     like mfc_logical label "Comments".
define            variable fill-all    like mfc_logical label "Receive All".
define            variable rcv_type    like poc_rcv_type.
define            variable vndname     like ad_name.
define            variable ship_date   as date no-undo.
define            variable v_shipfrom  like abs_shipfrom no-undo.
define            variable v_shipto    like abs_shipto   no-undo.
define            variable v_int       as   integer      no-undo.
define            variable v_fromname  like si_desc      no-undo.
define            variable v_toname    like si_desc      no-undo.
define            variable v_abs_recid as   recid        no-undo.
define            variable v_shipnbr   like tr_ship_id   no-undo.
define            variable v_shipdate  like tr_ship_date no-undo.
define            variable v_invmov    like tr_ship_inv_mov no-undo.
define            variable accum_qty_chg like pod_qty_chg no-undo.
define            variable rejected    like mfc_logical no-undo.
define            variable old_db      like global_db no-undo.
define            variable err-flag    as integer no-undo.
define            variable mc-error-number like msg_nbr no-undo.
define            variable l_tax_edited like mfc_logical initial true no-undo.
define            variable l_flag       like mfc_logical initial true no-undo.
define            variable auto_receipt like mfc_logical
                  initial false no-undo.
define            variable op_rctpo_trnbr like tr_trnbr no-undo.
define            variable lv_error_num   as integer    no-undo.
define            variable lv_name        as character  no-undo.


{txcalvar.i}
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

if is_wiplottrace_enabled() then do:
   {gprunmo.i &program=""wlpl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}
   {gprunmo.i &program=""wlfl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}
end.

ship_date = today.

form
   po_nbr         colon 15
   po_vend
   po_stat
   receivernbr    to 78
with frame b side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   po_nbr         colon 15
   po_vend
   po_stat
   eff_date       colon 68
   receivernbr    colon 15
   vndname        at 27 no-attr-space no-label
   fill-all       colon 68 label "Return All"
   v_shipfrom     colon 15 label "Ship-From"
   v_fromname     at 27 no-attr-space no-label format "x(20)"
   replace        colon 68
   v_shipto       colon 15 label "Ship-To"
   v_toname       at 27 no-attr-space no-label
   cmmt_yn        colon 68
   move           colon 68 label "Move To Next Operation"
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{pocurvar.i "NEW"}
{txcurvar.i "NEW"}
/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{potrldef.i "NEW"}
assign
   nontax_old         = nontaxable_amt:format
   taxable_old        = taxable_amt:format
   lines_tot_old      = lines_total:format
   tax_tot_old        = tax_total:format
   order_amt_old      = order_amt:format
   prepaid_old        = po_prepaid:format.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

assign
   convertmode = "MAINT"
   maint = true
   shipper_rec = false
   fiscal_rec = false
   cmmt-prefix = "RTV:"
   transtype = "ISS-PRV".

main-loop:
repeat:

   /* DELETE EXCH RATE USAGE RECORDS */
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input exch_exru_seq)"}

   /* DELETE qad_wkfl RECORDS */
   {pxrun.i &PROC='DeleteQadwkfl'
            &PROGRAM='porcxr.p'
            &PARAM="(input 'RECEIVER',
                     input receivernbr,
                     input mfguser,
                     input global_userid)"
            &NOAPPERROR=True
            &CATCHERROR=True}


   /* SPLIT THE ORIGINAL DO TRANSACTION IN TWO DO TRANSACTION      */
   /* BLOCKS TO SOLVE TRANSACTION SCOPING PROBLEM IN ORACLE        */
   /* ALSO SHIFTED DOWN CODE RELATED TO FOREIGN CURRENCY AND       */
   /* TRANSACTION COMMENTS IN THE SECOND TRANSACTION BLOCK         */

   do transaction:

      do for poc_ctrl:
         find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock.
         rcv_type = poc_rcv_type. /* RETURNS ARE NEGATIVE RECEIVERS */
      end.

      view frame a.

      if receivernbr = ? then
         receivernbr = "".
      if eff_date = ? then
         eff_date = today.

      assign
         fill-all = no
         move = yes
/* ss 20080107 - b */
/*
         replace = no
*/
         replace = yes
/* ss 20080107 - e */
         cmmt_yn = yes.

      display
         receivernbr
         eff_date
         replace
         fill-all
         cmmt_yn
         move
      with frame a.

      receivernbr = "".

      /* EMPTY LOGISTICS ACCOUNTING TEMP TABLE */
      for each tt-pvocharge exclusive-lock:
         delete tt-pvocharge.
      end.

      seta:
      do on error undo, retry:
         prompt-for po_nbr
            with frame a
         editing:
            if frame-field = "po_nbr" then do:
               /* FIND NEXT/PREVIOUS RECORD */
               /* Do not scroll thru RTS for PO or PO for RTS */
               {mfnp06.i
                  po_mstr
                  po_nbr
                  " po_mstr.po_domain = global_domain and po_type  <> ""B"" and
                  po_fsm_type = ports"
                  po_nbr
                  "input po_nbr"
                  yes
                  yes }

               if recno <> ? then do:
                  find ad_mstr  where ad_mstr.ad_domain = global_domain and
                  ad_addr = po_vend no-lock no-error.
                  if available ad_mstr then
                     vndname = ad_name.
                  else
                     vndname = "".
                  display
                     po_nbr
                     receivernbr
                     po_vend
                     po_stat
                     vndname
                  with frame a.
               end.
            end.
            else do:
               status input.
               readkey.
               apply lastkey.
            end.
         end.
         /* END EDITING PORTION OF FRAME A */

         /* READ THE po_mstr WITH NO-LOCK WHEN PURCHASE ORDER IS A   */
         /* CLOSED, CANCELLED, TYPE BLANKET OR ACCESSING RTS ORDER   */
         /* VIA PO RETURNS AND FOR PURCHASE ORDER WITH NO DETAIL LINE*/
         /* READ IT WITH AN EXCLUSIVE-LOCK OTHERWISE                 */

         if can-find (first po_mstr
                         where po_mstr.po_domain = global_domain and (
                         (po_stat = "C"
                           or  po_stat = "X")
                           or  po_type = "B"
                           or  po_fsm_type <> "" )
                        using po_nbr)
         or not can-find (first pod_det
                              where pod_det.pod_domain = global_domain and
                              pod_nbr = input po_nbr)
         then
            for first po_mstr
               fields( po_domain po_ap_acct po_ap_cc po_ap_sub po_cls_date
               po_frt po_rev
                       po_cmtindx po_curr po_del_to po_duty_type po_fob po_type
                       po_ent_ex po_ex_rate po_ex_rate2 po_fix_rate po_fsm_type
                       po_nbr po_prepaid po_print po_serv_chg po_ship po_shipvia
                       po_spec_chg po_stat po_tax_pct po_type po_vend)
using  po_nbr where po_mstr.po_domain = global_domain  no-lock:

            end. /* FOR FIRST po_mstr ... */

         else
find po_mstr using  po_nbr where po_mstr.po_domain = global_domain
exclusive-lock no-error.


         if not available po_mstr then do:
            /* PURCHASE ORDER DOES NOT EXIST */
            {pxmsg.i &MSGNUM=343 &ERRORLEVEL=3}
            next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

         {gpbrparm.i &browse=gplu908.p &parm=c-brparm1 &val=po_nbr}

         if po_type = "B" then do:
            /* BLANKET ORDER NOT ALLOWED */
            {pxmsg.i &MSGNUM=385 &ERRORLEVEL=3}
            next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

         /* IS Field Service? */
         if po_fsm_type <> "" then do:
            /* Can not process RTS orders with PO programs. */
            {pxmsg.i &MSGNUM=7364 &ERRORLEVEL=3}
            next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

         /* MAKE SURE THAT CENTRAL DATABASE IS CONNECTED */
         find first pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = po_nbr no-lock no-error.

     if global_db <> pod_po_db then do:
            {gprunp.i "mgdompl" "p" "ppDomainConnect"
                              "(input  pod_po_db,
                                output lv_error_num,
                                output lv_name)"}

            if lv_error_num <> 0 then do:
               /* DOMAIN # IS NOT AVAILABLE */
               {pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=3 &MSGARG1=lv_name}
               undo seta, retry.
            end.
         end. /* if global_db <> pod_po_db then do: */

         /* Warn user if PO will be re-opened */
         if (po_stat = "c" or po_stat = "x") then do:
            yn = no.
            /* PO AND/OR PO LINE CLOSED OR CANCELLED - REOPEN ? */
            {pxmsg.i &MSGNUM=339 &ERRORLEVEL=1 &CONFIRM=yn}
            if yn = yes
            then do:
               /* EXCLUSIVE-LOCK THE po_mstr WHEN REOPENING A CLOSED */
               /* OR CANCELLED PURCHASE ORDER                        */
find po_mstr using  po_nbr where po_mstr.po_domain = global_domain
exclusive-lock no-error.

               find first pod_det  where pod_det.pod_domain = global_domain and
                pod_nbr = po_nbr
                  no-lock no-error.
               old_db = global_db.
               if global_db <> pod_po_db then do:
                  {gprun.i ""gpalias3.p""
                     "(pod_po_db,
                       output err-flag)" }
               end. /* IF GLOBAL_DB <> POD_PO_DB THEN */
               /* RE-OPEN PO IN ORDER DATABASE */
               {gprun.i ""porstat.p""  "(input po_nbr)"}
               if old_db <> global_db then do:
                  {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
               end. /* IF OLD_DB <> GLOBAL_DB */

               assign
                  po_stat = "".
                  po_cls_date = ?.
               display
                  po_stat
               with frame a.

            end. /* IF YN = YES */
            else do:
               next-prompt po_nbr with frame a.
               undo seta, retry.
            end.
         end.

         if po_curr = gl_base_curr then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input po_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               if c-application-mode <> "WEB" then
                  next-prompt po_nbr with frame a.
               undo seta, retry.
            end.
         end.

         {pocurfmt.i}

         find si_mstr no-lock  where si_mstr.si_domain = global_domain and
         si_site = po_ship no-error.
         find ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and
         ad_addr = po_vend no-error.

         assign
            v_shipfrom = po_ship
            v_fromname = if available si_mstr then si_desc else ""
            v_shipto   = po_vend
            v_toname   = if available ad_mstr then ad_name else "".

         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         po_vend no-lock no-error.
         if available ad_mstr then
            vndname = ad_name.
         else
            vndname = "".

         display
            receivernbr
            po_vend
            po_stat
            vndname
            v_shipfrom
            v_fromname
            v_shipto
            v_toname
         with frame a.

         pook = no.

         chkpodsite:
         for each pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = po_nbr no-lock:

            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = pod_site no-lock no-error.

            if available si_mstr and si_db = global_db then do:
               {gprun.i ""gpsiver.p""
                  "(input si_site, input recid(si_mstr), output return_int)"}
               if return_int = 1 then do:
                  pook = yes.
                  leave chkpodsite.
               end.  /* IF RETURN_INT = 1 */
            end.

         end.   /* FOR EACH pod_det */

         if not pook then do:
            {pxmsg.i &MSGNUM=352 &ERRORLEVEL=3}
            next-prompt po_nbr with frame a.
            undo seta, retry.
         end.

      end.

      seta1:
      do on error undo, retry:
         global_addr = po_vend.
         set
            receivernbr
            {&PORVISM-P-TAG2}
            v_shipfrom
            v_shipto
            eff_date
            fill-all when not (can-find(first pod_det
                                      where pod_det.pod_domain = global_domain
                                      and pod_nbr              = po_nbr
                                      and pod_consignment      = yes))
            replace
            cmmt_yn
            move
         with frame a.
         {&PORVISM-P-TAG3}

         {pxrun.i &PROC='validateReceiverId'
                  &PROGRAM='porcxr.p'
                  &PARAM="(input receivernbr,
                           input rcv_type)"
                  &NOAPPERROR=True
                  &CATCHERROR=True }

         if return-value <> {&SUCCESS-RESULT}
         then do:

            /* RTV NUMBER ALREADY EXISTS */
            {pxmsg.i
                &MSGNUM=377
                &ERRORLEVEL={&APP-ERROR-RESULT}}

            next-prompt receivernbr with frame a.
            undo seta1, retry.
         end. /* IF return-value <> ... */

         {&PORVISM-P-TAG4}
         /* Validate ship-from site */
         if v_shipfrom <> "" then do:

            find si_mstr no-lock  where si_mstr.si_domain = global_domain and
            si_site = v_shipfrom no-error.

            if not available si_mstr then do:
               {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}  /* Site does not exist */
               next-prompt v_shipfrom with frame a.
               undo seta1, retry seta1.
            end. /* If not available si_mstr */

            {gprun.i
               ""gpsiver.p""
               "(si_site, recid(si_mstr), output v_int)"}

            if v_int = 0 then do:
               /* User does not have access to this site */
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
               next-prompt v_shipfrom with frame a.
               undo seta1, retry seta1.
            end.  /* if v_int */
            v_fromname = si_desc.
         end.  /* if v_shipfrom */

         else
            v_fromname = "".

         display
            v_fromname
         with frame a.

         /* Validate ship-to address */
         if v_shipto <> "" then do:

            find ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and
            ad_addr = v_shipto no-error.

            if not available ad_mstr then do:
               {pxmsg.i &MSGNUM=980 &ERRORLEVEL=3} /* Address does not exist */
               next-prompt v_shipto with frame a.
               undo seta1, retry seta1.
            end. /* If not available ad_mstr */

            v_toname = ad_name.

         end.  /* if v_shipto */
         else
            v_toname = "".

         display
            v_toname
         with frame a.

         if eff_date = ? then
            eff_date = today.

         /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
         /* NOT PRIMARY ENTITY                               */

         /* IF RETURN ALL IS YES, VERIFY OPEN GL PERIOD FOR EACH  */
         /* LINE ITEM SITE/ENTITY                                 */
         if fill-all and available po_mstr then
         for each pod_det
         fields( pod_domain pod_line pod_loc pod_nbr pod_part pod_po_db
                 pod_ps_chg pod_qty_chg pod_qty_ord pod_qty_rcvd
                 pod_qty_rtnd pod_reason pod_rum pod_rum_conv
                 pod_serial pod_site pod_type pod_um pod_um_conv )
          where pod_det.pod_domain = global_domain and (  pod_nbr = po_nbr and
          pod_line >= 0 and
              (pod_qty_rtnd < pod_qty_rcvd or pod_qty_ord = 0)
         ) no-lock use-index pod_nbrln:

            for first si_mstr
            fields( si_domain  si_db si_desc si_entity si_site )
             where si_mstr.si_domain = global_domain and  si_site = pod_site
            no-lock: end.

            if available si_mstr then do:
               /* CHECK GL EFFECTIVE DATE */
               {gpglef02.i &module = ""IC""
                  &entity = si_entity
                  &date   = eff_date
                  &prompt = "eff_date"
                  &frame  = "a"
                  &loop   = "seta1"}
            end. /* IF AVAILABLE si_mstr */
         end. /* FOR EACH pod_det */


      end.
   end. /* DO TRANSACTION */

   do transaction:

      /* FIND EXCH RATE IF CURRENCY NOT BASE */
      if base_curr <> po_curr
      then do:

         if po_fix_rate then
         assign
            exch_rate = po_ex_rate
            exch_rate2 = po_ex_rate2
            ent_exch  = po_ent_ex.

         else do:

            /* CREATE EXCHANGE RATE USAGE */
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input po_curr,
                 input base_curr,
                 input exch_ratetype,
                 input eff_date,
                 output exch_rate,
                 output exch_rate2,
                 output exch_exru_seq,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo, retry.
            end. /* IF mc-error-number <> 0 */

            seta1_sub:
            do on error undo, retry:

               {gprunp.i "mcui" "p" "mc-ex-rate-input"
                  "(input po_curr,
                    input base_curr,
                    input eff_date,
                    input exch_exru_seq,
                    input false,
                    input 12,
                    input-output exch_rate,
                    input-output exch_rate2,
                    input-output po_fix_rate)"}

            end. /* DO ON ERROR UNDO,RETRY */

         end. /* IF NOT po_fix_rate */
      end. /* IF base_curr <> po_curr */
      else
         assign
            exch_rate  = 1.0
            exch_rate2 = 1.0.

      /* ADD COMMENTS, IF DESIRED */
      if cmmt_yn
      then do:
         hide frame a no-pause.
         assign
            cmtindx    = po_cmtindx
            global_ref = cmmt-prefix + " " + po_nbr.

         {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
         po_cmtindx = cmtindx.
      end. /* IF cmmt_yn */

      {mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot
      woc_sq01 trlot}

      for each sr_wkfl  where sr_wkfl.sr_domain = global_domain and  sr_userid
      = mfguser exclusive-lock:
         delete sr_wkfl.
      end.

      /* DETAIL FRAME C AND SINGLE LINE PROCESSING FRAME D */
      release pod_det.
      preppoddet:

      for each pod_det  where pod_det.pod_domain = global_domain and (
               pod_nbr = po_nbr
          and (pod_qty_rtnd < pod_qty_rcvd or pod_qty_ord = 0)
      ) exclusive-lock
      break by pod_site by pod_loc by pod_serial by pod_part:

         if first-of (pod_part)
         then assign
            accum_qty_chg = 0.

         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         pod_site no-lock no-error.
         if not available si_mstr
            or (available si_mstr and si_db <> global_db)
         then
            next preppoddet.

         if fill-all = yes then do:
            /* ONLY AUTO-FILL PARTS THAT ARE NOT LOT/SERIAL CONTROLLED */
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = pod_part no-lock no-error.
            if not available pt_mstr
            or (available pt_mstr and pt_lot_ser = "" and pod_type <> "S" )
            then
               assign
                  pod_qty_chg = pod_qty_rcvd - pod_qty_rtnd.
            else
               assign
                  pod_qty_chg = 0.

            rejected = no.

            if pod_type = "" then do:

               accum_qty_chg = accum_qty_chg + (pod_qty_chg * pod_um_conv).

               {gprun.i ""icedit2.p""
                  "(input "transtype",
                    input pod_site,
                    input pod_loc,
                    input pod_part,
                    input """",
                    input """",
                    input accum_qty_chg,
                    input pod_um,
                    input """",
                    input """",
                    output rejected)"}
            end.

            if rejected then do on endkey undo, retry:
               accum_qty_chg = accum_qty_chg - (pod_qty_chg * pod_um_conv).
               pod_qty_chg = 0.
               {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 &MSGARG1=pod_part}
            end.

            if pod_qty_chg <> 0 then do:
               create sr_wkfl. sr_wkfl.sr_domain = global_domain.
               assign
                  sr_userid = mfguser
                  sr_lineid = string(pod_line)
                  sr_site = pod_site
                  sr_loc = pod_loc
                  sr_lotser = ""
                  sr_ref = ""
                  sr_qty = pod_qty_chg.
            end.

            if porec or is-return then do:

               /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */
               find loc_mstr  where loc_mstr.loc_domain = global_domain and
                    loc_site = pod_site and
                    loc_loc = pod_loc
               no-lock no-error.

               if available loc_mstr and loc_single = yes then do:

                  {gploc02.i  "buff1.pod_domain = global_domain and " pod_det
                  pod_nbr pod_line pod_part}

                  if error_flag = 0 and loc__qad01 = yes then do:

                     /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) FOR
                        DIFFERENT ITEMS OR LOT/SERIALS IN SAME LOCATION */
                     {gprun.i ""gploc01.p""
                              "(pod_site,
                                pod_loc,
                                pod_part,
                                pod_serial,
                                "" "",
                                loc__qad01,
                                output error_flag)"}

                     if error_flag <> 0
                     /* ADJUSTING QTY ON A PREVIOUS VIOLATION (CREATED
                        BEFORE THIS PATCH) OF SINGLE ITEM/LOT/SERIAL
                        LOCATION ALLOWED; CREATING ANOTHER VIOLATION
                        DISALLOWED.
                     */
                     and can-find(ld_det  where ld_det.ld_domain =
                     global_domain and  ld_site = pod_site
                     and ld_loc = pod_loc and ld_part = pod_part
                     and ld_lot = pod_serial and ld_ref = "")
                     then
                        error_flag = 0.

                  end. /* error_flag = 0 and loc__qad01 = yes */

                  if error_flag <> 0 then do:
                     /* TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOC */
                     {pxmsg.i &MSGNUM=596 &ERRORLEVEL=2}
                     undo preppoddet, next preppoddet.
                  end.

               end.  /* avail loc_mstr and loc_single = yes */

            end. /* porec or is-return*/

         end.
         else
            pod_qty_chg = 0.

         assign
            pod_ps_chg = pod_qty_chg
            pod_rum = pod_um
            pod_rum_conv = 1
            pod_reason = "".

      end. /* for each pod_det */

      l_pod_det_recid = ?.

      hide frame a no-pause.

      /* RUN porvisa.p TO SELECT EDIT ITEMS TO BE RECEIVED */
      po_recno = recid(po_mstr).
      proceed = no.
      {gprun.i ""porvisa.p""}

      /* RUN poporcb.p TO CREATE RECEIPTS & UPDATE TRANSACTIONS */
      if proceed = yes then do:

         assign
            v_shipnbr  = ""
            v_shipdate = ship_date
            v_invmov   = "".

         /* Create a shipper for the PO return */
         if v_shipfrom <> "" and v_shipto <> "" then do:

            hide frame b no-pause.

            {gprun.i ""porvism1.p""
               "(v_shipfrom,
                 v_shipto,
                 transtype,
                 eff_date,
                 recid(po_mstr),
                 output v_abs_recid)" }

            /* Get associated shipper */
            find abs_mstr where recid(abs_mstr) = v_abs_recid
            no-lock no-error.

            if available abs_mstr then
               assign
                  v_shipnbr  = substring(abs_id,2)
                  v_shipdate = abs_shp_date
                  v_invmov   = abs_inv_mov.

            view frame b.

         end.  /* if v_shipfrom */

         {gprun.i ""poporcb.p""
            "(v_shipnbr,
              v_shipdate,
              v_invmov,
              v_shipto,
              auto_receipt,
              no,
              0,
              0,
              """",
              0,
              output op_rctpo_trnbr)"}

         {gprun.i ""poporcd.p""}

      end. /* IF PROCEED = YES */

      for first pod_det
         where pod_det.pod_domain = global_domain
         and   recid(pod_det)     = l_pod_det_recid
      exclusive-lock:
      end. /* FOR FIRST pod_det */

      if available (pod_det)
      then
         pod_consignment = l_tt_consign.

      release pod_det.
      l_pod_det_recid = ?.

   end. /* DO TRANSACTION */

   /* CALCULATE AND EDIT TAXES */
   if proceed = yes then do:

      undo_trl2 = true.

      {gprun.i ""porctrl2.p""}

      if undo_trl2 then undo.

      /* CHANGED THIRD INPUT PARAMETER FROM "" TO tx2d_nbr */
      {gprun.i ""txedtchk.p""
         "(input "20",
           input po_nbr,
           input po_blanket,
           input 0,
           output l_tax_edited)"}

      if l_tax_edited then do:
         /* EDITED PREVIOUS TAX VALUES TYPE 20: RECALCULATE? */
         {pxmsg.i &MSGNUM=2579 &ERRORLEVEL=2
                  &MSGARG1="20"
                  &CONFIRM=l_flag}
      end. /* IF l_tax_edited ... */

      if not l_tax_edited
      or l_flag
      then do:
         /* CHANGED THIRD INPUT PARAMETER FROM "" TO tx2d_nbr */
         {gprun.i ""txcalc.p""
            "(input "20",
              input po_nbr,
              input po_blanket,
              input 0,
              input no,
              output result-status)"}.
      end. /* IF not l_tax_edited ...  */
      else do:
         for each tx2d_det
            fields(tx2d_domain tx2d_edited tx2d_line tx2d_nbr tx2d_ref
                   tx2d_tr_type)
            where tx2d_domain  = global_domain
            and   tx2d_ref     = po_nbr
            and   tx2d_tr_type = "20"
            no-lock:

            if not tx2d_edited
            then do:
               {gprun.i ""txcalc.p""
                  "(input "20",
                    input tx2d_ref,
                    input tx2d_nbr,
                    input tx2d_line,
                    input l_tax_edited,
                    output result-status)"}
            end. /* IF NOT tx2d_edited */

         end. /* FOR EACH tx2d_det */

      end. /* ELSE DO */

   end. /* IF PROCEED = YES  */

   hide frame b no-pause.

   /* DELETE EXCH RATE USAGE RECORDS */
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input exch_exru_seq)"}

/* ss 20071223 - b */
	 {gprun.i ""xxporvrp03.p"" "(input po_nbr)" }
/* ss 20071223 - e */

   {&PORVISM-P-TAG5}
end.

status input.

if is_wiplottrace_enabled() then
   delete procedure h_wiplottrace_procs no-error.
if is_wiplottrace_enabled() then
   delete procedure h_wiplottrace_funcs no-error.