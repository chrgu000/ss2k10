/* porvisa.p - PURCHASE ORDER RETURN TO SUPPLIER ISSUE                  */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 6.0     LAST MODIFIED: 08/08/90    BY: RAM *D030*          */
/* REVISION: 6.0     LAST MODIFIED: 10/29/90    BY: WUG *D151*          */
/* REVISION: 6.0     LAST MODIFIED: 12/17/90    BY: WUG *D227*          */
/* REVISION: 6.0     LAST MODIFIED: 01/15/91    BY: RAM *D300*          */
/* REVISION: 6.0     LAST MODIFIED: 03/27/91    BY: RAM *D462*          */
/* REVISION: 6.0     LAST MODIFIED: 04/11/91    BY: RAM *D518*          */
/* REVISION: 6.0     LAST MODIFIED: 05/10/91    BY: RAM *D641*          */
/* REVISION: 6.0     LAST MODIFIED: 05/30/91    BY: RAM *D666*          */
/* REVISION: 6.0     LAST MODIFIED: 06/25/91    BY: RAM *D676*          */
/* REVISION: 6.0     LAST MODIFIED: 07/16/91    BY: RAM *D777*          */
/* REVISION: 6.0     LAST MODIFIED: 08/29/91    BY: pma *D829*          */
/* REVISION: 6.0     LAST MODIFIED: 09/12/91    BY: WUG *D858*          */
/* REVISION: 6.0     LAST MODIFIED: 09/20/91    BY: RAM *D871*          */
/* REVISION: 6.0     LAST MODIFIED: 10/03/91    BY: alb *D887*          */
/* REVISION: 6.0     LAST MODIFIED: 11/08/91    BY: RAM *D923*          */
/* REVISION: 7.0     LAST MODIFIED: 12/02/91    BY: pma *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F070*          */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*          */
/* REVISION: 7.0     LAST MODIFIED: 03/25/92    BY: pma *F089*          */
/* REVISION: 7.3     LAST MODIFIED: 09/27/92    BY: jcd *G247*          */
/* REVISION: 7.3     LAST MODIFIED: 11/09/92    BY: afs *G303*          */
/* REVISION: 7.3     LAST MODIFIED: 12/14/92    BY: tjs *G443*          */
/* REVISION: 7.3     LAST MODIFIED: 02/25/93    BY: tjs *G751*          */
/* REVISION: 7.3     LAST MODIFIED: 09/14/93    BY: tjs *GE59*          */
/* REVISION: 7.3     LAST MODIFIED: 11/03/93    BY: afs *H220*          */
/* REVISION: 7.4     LAST MODIFIED: 07/19/94    BY: dpm *FP45*          */
/* REVISION: 7.4     LAST MODIFIED: 09/11/94    BY: rmh *GM16*          */
/* REVISION: 7.4     LAST MODIFIED: 10/27/94    BY: ljm *GN62*          */
/* REVISION: 8.5     LAST MODIFIED: 11/18/94    BY: taf *J038*          */
/* REVISION: 7.4     LAST MODIFIED: 11/19/94    BY: bcm *GO37*          */
/* REVISION: 8.5     LAST MODIFIED: 11/28/94    BY: mwd *J034*          */
/* REVISION: 8.5     LAST MODIFIED: 12/19/94    BY: ktn *J041*          */
/* REVISION: 8.5     LAST MODIFIED: 08/21/95    BY: kxn *J066*          */
/* REVISION: 7.4     LAST MODIFIED: 10/17/95    BY: jym *F0TC*          */
/* REVISION: 8.5     LAST MODIFIED: 05/14/96    BY: rxm *G1SL*          */
/* REVISION: 8.5     LAST MODIFIED: 07/10/96    BY: *G1Z8* Ajit Deodhar */
/* REVISION: 8.5     LAST MODIFIED: 07/30/96    BY: *G2B5* suresh Nayak */
/* REVISION: 8.5     LAST MODIFIED: 09/09/96    BY: *G2DV* Aruna P.Patil*/
/* REVISION: 8.5     LAST MODIFIED: 04/16/97    BY: *G2M2* Suresh Nayak */
/* REVISION: 8.5     LAST MODIFIED: 08/14/97    BY: *H1B4* Manmohan K.Pardesi */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane     */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E    LAST MODIFIED: 06/12/98    BY: *J2N3* Niranjan R.   */
/* REVISION: 8.6E    LAST MODIFIED: 06/26/98    BY: *J2MG* Samir Bavkar  */
/* REVISION: 8.6E    LAST MODIFIED: 08/28/98    BY: *J2WJ* Ajit Deodhar  */
/* REVISION: 9.1     LAST MODIFIED: 06/26/99    BY: *J3H8* Sachin Shinde */
/* REVISION: 9.1     LAST MODIFIED: 06/30/99    BY: *N00R* Reetu Kapoor  */
/* REVISION: 9.1     LAST MODIFIED: 08/10/99    BY: *N01K* J. Fernando   */
/* REVISION: 9.1     LAST MODIFIED: 09/16/99    BY: *J3LC* Anup Pereira  */
/* REVISION: 9.1     LAST MODIFIED: 10/25/99    BY: *N002* Steve Nugent  */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 07/11/00    BY: *M0PQ* Falguni Dalal    */
/* REVISION: 9.1     LAST MODIFIED: 09/05/00    BY: *N0RF* Mark Brown       */
/* REVISION: 9.1     LAST MODIFIED: 09/06/00    BY: *M0RJ* Kaustubh K.      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Old ECO marker removed, but no ECO header exists *J04D*                  */
/* Revision: 1.16.3.16   BY: Hualin Zhong       DATE: 05/03/01 ECO: *N0Y8*  */
/* Revision: 1.16.3.17   BY: Hualin Zhong       DATE: 05/07/01 ECO: *N0YC*  */
/* Revision: 1.16.3.18   BY: Nishit V           DATE: 07/03/02 ECO: *N1MW*  */
/* Revision: 1.16.3.21   BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00P*  */
/* Revision: 1.16.3.22   BY: Rajinder Kamra     DATE: 06/23/03 ECO  *Q00Y*  */
/* Revision: 1.16.3.23   BY: Vandna Rohira      DATE: 05/17/04 ECO: *P21S*  */
/* Revision: 1.16.3.24   BY: Nishit V           DATE: 08/10/04 ECO: *P2DD*  */
/* Revision: 1.16.3.25   BY: Nishit V           DATE: 08/17/04 ECO: *P2FS*  */
/* Revision: 1.16.3.32   BY: Priya Idnani       DATE: 10/15/04 ECO: *P2PM*  */
/* Revision: 1.16.3.33   BY: Priya Idnani       DATE: 10/27/04 ECO: *Q0F2*  */
/* Revision: 1.16.3.34   BY: Sukhad Kulkarni    DATE: 10/28/04 ECO: *P2R7*  */
/* Revision: 1.16.3.35   BY: Shivanand H        DATE: 01/06/05 ECO: *P32W*  */
/* Revision: 1.16.3.36   BY: Priyank Khandare   DATE: 02/02/05 ECO: *P35K*  */
/* Revision: 1.16.3.37   BY: Ajit Philip        DATE: 15/03/05 ECO: *P3BV*  */
/* Revision: 1.16.3.38   BY: Shivganesh Hegde   DATE: 04/15/05  ECO: *P3FL* */
/* Revision: 1.16.3.39   BY: Anitha Gopal       DATE: 07/07/05  ECO: *P3RL* */
/* Revision: 1.16.3.40   BY: Geeta Kotian       DATE: 09/27/05  ECO: *P431* */
/* Revision: 1.16.3.40.1.1 BY: Kirti Desai      DATE: 12/28/05  ECO: *P4CF* */
/* Revision: 1.16.3.40.1.2 BY: Suyash Keny      DATE: 04/26/06  ECO: *P4QD* */
/* Revision: 1.16.3.40.1.4 BY: SurenderSingh Nihalani DATE: 05/16/06 ECO: *P4PQ* */
/* Revision: 1.16.3.40.1.5 BY: Sushant Pradhan  DATE: 05/16/06  ECO: *P4RC* */
/* Revision: 1.16.3.40.1.6 BY: SurenderSingh Nihalani DATE: 06/12/06 ECO: *P4S2* */
/* Revision: 1.16.3.40.1.7  BY: SurenderSingh Nihalani DATE: 06/19/06 ECO: *P4TZ* */
/* Revision: 1.16.3.40.1.8  BY: Suyash Keny     DATE: 08/11/06   ECO: *P51C* */
/* Revision: 1.16.3.40.1.9  BY: Ajay Nair       DATE: 10/03/06   ECO: *P58K* */
/* Revision: 1.16.3.40.1.10 BY: Amit Singh      DATE: 11/06/06   ECO: *P56L* */
/* Revision: 1.16.3.40.1.11 BY: Naseem Torgal   DATE: 01/03/07   ECO: *P5KH* */
/* Revision: 1.16.3.40.1.12 BY: Antony LejoS    DATE: 03/23/07   ECO: *P5RS* */
/* Revision: 1.16.3.40.1.13 BY: Anuradha K.     DATE: 05/23/07   ECO: *P5XB* */
/* $Revision: 1.16.3.40.1.14 $   BY: Anuradha K.     DATE: 05/31/07   ECO: *P5Y2* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110112.1  By: Roger Xiao */ /*subcontract po autorun woworc.p */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
porvisa.p - ITEM ENTRY FOR PO RETURNS
*/

/*!
CHANGES MADE IN THIS PROGRAM MUST ALSO BE MADE TO POPORCA.P
*/








/*V8:ConvertMode=Maintenance                                            */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porvisa_p_1 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_2 "Packing Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_4 "Issue"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_5 "Net Received"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_6 "Loc"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_7 "Lot/Serial"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_8 "Cmmts"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_9 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_10 "RTV Nbr"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvisa_p_11 "Return Qty"
/* MaxLen: Comment: */


/* ********** End Translatable Strings Definitions ********* */

{porcdef.i}
/* VARIABLE DEFINITION FOR GL CALENDAR VALIDATION */
{gpglefdf.i}

/*@MODULE PRM BEGIN*/
/* SHARED TEMP-TABLES FOR PRM */
{pjportt.i}
/*@MODULE PRM END*/

/* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxmaint.i}

/* DEFINE THE PERSISTENT HANDLE */
{pxphdef.i socmnrtn}

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable cline as character.
define new shared variable issue_or_receipt as character.
define new shared variable line like pod_line format ">>>" no-undo.
define new shared variable lotserial_control as character.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable multi_entry like mfc_logical
   label {&porvisa_p_1} no-undo.
define new shared variable podtype like pod_type.
define new shared variable rct_site like pod_site.
define new shared variable total_lotserial_qty like pod_qty_chg.
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable undo_all like mfc_logical.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define shared variable receivernbr         like prh_receiver
                                              label {&porvisa_p_10}.
define shared variable qopen               like pod_qty_rcvd
                                              label {&porvisa_p_5}.
define shared variable vendlot             like tr_vend_lot no-undo.
define shared variable h_wiplottrace_procs as handle        no-undo.
define shared variable h_wiplottrace_funcs as handle        no-undo.
define shared variable l_tt_consign        like mfc_logical no-undo.
define shared variable l_pod_det_recid     as   recid       no-undo.

define shared variable prm-avail           like mfc_logical no-undo.
define shared variable fill-all            like mfc_logical no-undo.

define shared frame b.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable cmmt_yn like mfc_logical label {&porvisa_p_9} no-undo.
define variable due like pod_due.
define variable dwn as integer.
define variable yn like mfc_logical.
define variable i as integer.
define variable del-yn like mfc_logical initial no.
define variable serial_control like mfc_logical initial no.
define variable qty_left like tr_qty_chg.
define variable cont like mfc_logical initial yes.
define variable first_down as integer initial 0.
define variable reset_um like mfc_logical initial no.
define variable conv_to_pod_um like pod_um_conv.
define variable packing_qty like pod_ps_chg
   label {&porvisa_p_2} no-undo.
define variable total_returned like pod_qty_rtnd no-undo.
define variable overage_qty like pod_qty_rtnd no-undo.
define variable return_um like pod_rum no-undo.
define variable lineid_list as character no-undo.
define variable overissue_ok like mfc_logical no-undo.
define variable undotran like mfc_logical no-undo.
define variable ponbr like pod_nbr no-undo.
define variable poline like pod_line no-undo.
define variable lotnext like pod_lot_next no-undo.
define variable lotprcpt like pod_lot_rcpt no-undo.
define variable l_reset_pod like mfc_logical no-undo.
define variable l_chkum     like mfc_logical no-undo.

define        variable rejected            like mfc_logical no-undo.
define        variable lotserials_req      like mfc_logical no-undo.
define        variable mess_desc           as character     no-undo.
define        variable leave_loop          like mfc_logical
   initial no       no-undo.
define        variable l_remove_srwkfl     like mfc_logical         no-undo.
define        variable l_consign_total     like cnsix_qty_consigned no-undo.
define        variable qty_ord             like pod_qty_ord         no-undo.
define        variable l_yn                like mfc_logical         no-undo.
define        variable l_multi_return      like mfc_logical         no-undo.

define variable l_upd_consign          like mfc_logical     no-undo.
define variable l_conv                 like pod_um_conv     no-undo.
define variable l_lotserial_qty        like lotserial_qty   no-undo.
define variable l_consign_qty          like pod_qty_rtnd    no-undo.
define variable l_status               like ld_status       no-undo.
define variable l_nonconsign_qty       like l_consign_qty   no-undo.

define variable l_delete_sr_wkfl like mfc_logical no-undo.
define variable l_update_sr_wkfl like mfc_logical no-undo.
define variable l_error          like mfc_logical no-undo.

define variable cancel-prm                like mfc_logical  no-undo.
define variable need-to-validate-defaults like mfc_logical  no-undo.
define variable default-receipts-valid    like mfc_logical  no-undo.
define variable invalid-prm-po-ln-rcpt    like mfc_logical  no-undo.

define variable l_um_conv like pod_um_conv no-undo.
define variable l_pt_um   like pt_um       no-undo.

/* TEMP-TABLE t_sr_wkfl STORES THE LIST OF DEFAULT sr_wkfl      */
/* RECORDS (NOT CREATED BY THE USER)                            */
define temp-table t_sr_wkfl no-undo
   field t_sr_userid like sr_userid
   field t_sr_lineid like sr_lineid
   field t_sr_site   like sr_site
   field t_sr_loc    like sr_loc
   field t_sr_lotser like sr_lotser
   field t_sr_ref    like sr_ref
   field t_sr_qty    like sr_qty
   index t_sr_lineid is unique t_sr_userid t_sr_lineid.

define shared temp-table tt-pod no-undo
   field tt-domain       like pod_domain
   field tt-nbr          like pod_nbr
   field tt-line         like pod_line
   field tt-consign      like pod_consign
   index tt-index
   tt-domain
   tt-nbr
   tt-line .


define buffer poddet  for pod_det.
define buffer ldd_det for ld_det.

{wlfnc.i} /* FUNCTION FORWARD DECLARATIONS */
{wlcon.i} /* CONSTANTS DEFINITIONS */

form
   po_nbr         colon 15
   po_vend
   po_stat
   receivernbr    to 78
with frame b side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
with frame c title color normal
   (getFrameTitle("PURCHASE_ORDER_LINE_ITEMS",36))
   6 down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   line           colon 14
   return_um      colon 34
   site           colon 55
   location       colon 69 no-attr-space label {&porvisa_p_6}
   lotserial_qty  colon 14
   wolot          colon 34
   lotserial      colon 55
   packing_qty    colon 14
   woop           colon 34
   lotref         colon 55 format "x(8)"
   pod_part       colon 14
   multi_entry    colon 55
   pod_vpart      colon 14
   pod_reason     colon 55
   cmmt_yn        colon 71 label {&porvisa_p_8}
with frame d side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

issue_or_receipt = getTermLabel("ISSUE", 7).

if is_wiplottrace_enabled() then
   run init_poline_bkfl_input_output.

find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock.
find po_mstr where recid(po_mstr) = po_recno.

assign
   line           = 1
   proceed        = no
   l_multi_return = no.

/*@MODULE PRM BEGIN*/
run build-prm-temp-table.
/*@MODULE PRM END*/

/* INITIALISE TEMP-TABLE t_sr_wkfl */
empty temp-table t_sr_wkfl.

edit-loop:

repeat on endkey undo, leave:

   display
      po_nbr
      po_vend
      po_stat
      receivernbr
   with frame b.

   lineloop:
   repeat:

      clear frame c all no-pause.
      clear frame d all no-pause.
      view frame dtitle.
      view frame b.
      view frame c.
      view frame d.

      for each pod_det no-lock  where pod_det.pod_domain = global_domain and
      pod_nbr = po_nbr
            and pod_line >= line and pod_qty_rtnd < pod_qty_rcvd
            use-index pod_nbrln by pod_line:

         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         pod_site no-lock.
         if si_db <> global_db then next.

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         pod_part no-lock no-error.

         if available pt_mstr
         then
            l_pt_um = pt_um.

         qopen = pod_qty_rcvd - pod_qty_rtnd.
         display
            pod_line
            /*V8!space(.5) */
            pod_part
            /*V8!space(.5) */
            pt_um when (available pt_mstr)
            /*V8!space(.5) */
            qopen
            /*V8!space(.5) */
            pod_um
            /*V8!view-as fill-in size 3.5 by 1 space(.5) */
            pod_qty_chg label {&porvisa_p_11}
            /*V8!space(.5) */
            pod_rum
            /*V8!view-as fill-in size 3.5 by 1 space(.5) */
            pod_project
            /*V8!space(.5) */
            pod_due_date
            /*V8!space(.5) */
            pod_type
         with frame c.
         if frame-line(c) = frame-down(c) then leave.
         down 1 with frame c.

      end.

      line = 0.

      do on error undo, retry:
         update line with frame d
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i pod_det line pod_line pod_nbr  " pod_det.pod_domain =
            global_domain and po_nbr "  pod_nbrln}
            if recno <> ? then
            np-poddet:
            do:
               find si_mstr  where si_mstr.si_domain = global_domain and
               si_site = pod_site no-lock no-error.
               if si_db <> global_db then leave np-poddet.
               line = pod_line.
               cmmt_yn = yes.
               display
                  line
                  pod_qty_chg @ lotserial_qty
                  pod_ps_chg @ packing_qty
                  pod_part
                  pod_vpart
                  pod_rum @ return_um
                  pod_wo_lot @ wolot
                  pod_op @ woop
                  pod_reason
                  cmmt_yn
               with frame d.

           /* do not display pt_desc on help keys from Desktop */
           if not ( {gpiswrap.i} and keyfunction(lastkey) = "help" ) then
              run get_pt_description
                     (input pod_part,
                      input pod_desc).

            end.

            /*@MODULE PRM BEGIN*/
            if prm-avail
            then do:

               if    keyfunction(lastkey) = "END-ERROR"
                  or keyfunction(lastkey) = "GO"
               then do:

                  need-to-validate-defaults = no.

                  /* NEED TO VALIDATE ALL PO LINES LINKED TO  */
                  /* PRM PROJECT LINES WHERE DEFAULT PO LINE  */
                  /* RECEIPT QUANTITIES ARE TO BE ACCEPTED    */
                  /* - I.E. EACH ttprm-det RECORD             */
                  if fill-all
                  then
                     for first ttprm-det
                     no-lock:
                        need-to-validate-defaults = yes.
                     end. /* FOR FIRST ttprm-det */

                  if need-to-validate-defaults
                  then
                     leave. /* LEAVE UPDATE..EDITING BLOCK */

                  if keyfunction(lastkey) = "END-ERROR"
                  then
                     undo lineloop, leave.

               end.  /* IF KEYFUNCTION(LASTKEY)... */
            end.  /* IF prm-avail */
            /*@MODULE PRM END*/
            else
               if keyfunction(lastkey) = "end-error"
               then
                  undo lineloop, leave.

         end. /* end update */

         if (line = 0)
         then do:         /* NO PO LINE SELECTED */

            if (prm-avail
               and not need-to-validate-defaults)
               or (not prm-avail)
            then
               leave lineloop.
            /*@MODULE PRM BEGIN*/
            else
           if     prm-avail
                  and need-to-validate-defaults
               then do:

                  /* VALIDATE THE DEFAULT VALUES THAT WERE ASSIGNED */
                  /* TO EACH OF THE PO LINES TO BE RECEIVED         */
                  {gprunmo.i
                     &program=""pjporvdl.p""
                     &module ="PRM"
                     &param  ="""(input  fill-all,
                                  output default-receipts-valid,
                                  output pod_recno,
                                  output cancel-prm)"""}

                  if cancel-prm
                  then do:
                     /* LEAVE LINE DETAILS AND RETURN TO HEADER */
                     /* SINCE WE DON'T WANT TO PROCESS THE PRM  */
                     /* RECORDS ASSOCIATED WITH THE PO          */
                     if c-application-mode <> "API"
                     then
                        run hide-frames.
                     undo, return.
                  end. /* IF cancel-prm */

                  /* CAN LEAVE THE LINELOOP IF PRM VALIDATIONS OF */
                  /* DEFAULT PO LINE VALUES INDICATES NO PROBLEMS */
                  /* BUT WHERE PROBLEM LINES EXIST THE FIRST ONE  */
                  /* WILL BE IDENTIFIED AND USER WILL BE ALLOWED  */
                  /* MAKE THE NECESSARY MODIFICATIONS (STAYS IN   */
                  /* LINELOOP)                                    */
                  if default-receipts-valid
                  then
                     leave lineloop.
                  else do:
                     /* FIND OUT WHICH LINE IS INVALID AND DISPLAY */
                     for first pod_det
                     no-lock
                        where pod_recno = recid(pod_det):

                        line = pod_line.

                        if c-application-mode <> "API"
                        then
                           run display-detail.
                     end. /* FOR FIRST pod_det */
                  end. /* ELSE DO */
                  /*@MODULE PRM END*/
               end. /* ELSE IF prm-avail... */
         end. /* IF line = 0 */

         find pod_det  where pod_det.pod_domain = global_domain and  pod_nbr =
         po_nbr
            and pod_line = line no-error.
         if not available pod_det then do:
            {pxmsg.i &MSGNUM=45 &ERRORLEVEL=3} /* Line item does not exist */
            undo, retry.
         end.

         /* VALIDATE THAT LINE IS FOR THIS DATABASE */
         else do:

            assign
               l_pod_det_recid = recid(pod_det)
               l_upd_consign   = no.

            if pod_consignment
               and (can-find ( first cnsix_mstr
                      where cnsix_mstr.cnsix_domain = global_domain
                      and   cnsix_po_nbr            = pod_nbr
                      and   cnsix_pod_line          = pod_line ) )
            then do:
               /* IS THE RETURNED ITEM CONSIGNED? */
               {pxmsg.i
                  &MSGNUM=6778
                  &ERRORLEVEL=1
                  &CONFIRM=l_upd_consign}

               l_tt_consign = pod_consignment.

            end. /* IF pod_consignment */
            else do:

               for first tt-pod
                 where  tt-domain = pod_domain
                 and    tt-nbr    = pod_nbr
                 and    tt-line   = pod_line  :
               end. /* FOR FIRST tt-pod */

               if not available tt-pod
               then do :
                 create tt-pod .
                 assign tt-domain      = pod_domain
                        tt-pod.tt-nbr  = pod_nbr
                        tt-pod.tt-line = pod_line
                        tt-consign     = pod_consignment .
               end . /* IF NOT AVAILABLE tt-pod */


               assign
                  l_tt_consign    = pod_consignment
                  pod_consignment = no.

            end. /* ELSE DO: */

            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = pod_site no-lock.
            if si_db <> global_db then do:
               /* SITE NOT ASSIGNED TO THIS DOMAIN */
               {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}
               undo, retry.
            end.
            ponbr = pod_nbr.

         end. /* ELSE DO */

         /*  PICK UP CURRENTLY EFFECTIVE CUM ORDER */

         run get_pt_description
            (input pod_part,
             input pod_desc).
         {gprun.i ""poporca5.p""
            "(input pod_nbr, input pod_line, input eff_date)"}

         if pod_status = "c" or pod_status = "x" then do:
            l_yn = no.

            /* PO AND/OR PO LINE CLOSED OR CANCELED. REOPEN */
            {pxmsg.i
               &MSGNUM=339
               &ERRORLEVEL=1
               &CONFIRM=l_yn}

            if l_yn
            then do:
               if replace
               then do:

                  {gprun.i ""rspostat.p""
                     "(input pod_nbr,
                       input pod_line)"}

                  {mfpotr.i
                     """"
                     """"}

               end. /* IF replace THEN DO */

            end. /* IF l_yn THEN */
            else
               undo lineloop, retry lineloop.

         end.
      end.
      assign
         packing_qty = pod_ps_chg
         wolot = pod_wo_lot
         woop = pod_op
         return_um = pod_rum
         cmmt_yn = yes.
      display
         line
         packing_qty
         pod_part
         pod_vpart
         return_um
         wolot
         woop
         pod_site @ site
         pod_loc  @ location /* SS - 110112.1 */
         pod_reason
         cmmt_yn
      with frame d.

      if available si_mstr then do:
         {gprun.i ""gpsiver.p""
            "(input si_site, input recid(si_mstr), output return_int)"}
      end.
      else do:
         {gprun.i ""gpsiver.p""
            "(input pod_site, input ?, output return_int)"}
      end.
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         pause.
         undo, retry.
      end.

      /* Initialize input variables, check for open vouchers. */

      pod_recno = recid(pod_det).
      {gprun.i ""poporca3.p""}
      assign
         lotnext =  lotserial
         lotprcpt = no
         poline = line
         vendlot = "".

      do transaction:
         locloop:
         do on error undo, retry:

            ststatus = stline[3].
            status input ststatus.

            find first sr_wkfl  where sr_wkfl.sr_domain = global_domain and
            sr_userid = mfguser
               and sr_lineid = cline no-lock no-error.

            i = 0.
            multi_entry = no.
            for each sr_wkfl no-lock  where sr_wkfl.sr_domain = global_domain and
            sr_userid = mfguser
                  and sr_lineid = cline:
               i = i + 1.
               if i > 1 then do:
                  multi_entry = yes.
                  leave.
               end.
            end.

            display
               lotserial_qty
               packing_qty
               return_um
               wolot
               woop
               site
               location
               lotserial
               lotref
               multi_entry
               pod_reason
               cmmt_yn
            with frame d.

            set
               lotserial_qty
               packing_qty
               return_um
               wolot
               woop
               site         when (not multi_entry and not
                            (is_wiplottrace_enabled() and pod_type = "s"))
               location     when (not multi_entry and not
                            (is_wiplottrace_enabled() and pod_type = "s"))
               lotserial    when (not multi_entry and not
                            (is_wiplottrace_enabled() and pod_type = "s"))
               lotref       when (not multi_entry and not
                            (is_wiplottrace_enabled() and pod_type = "s"))
               multi_entry  when     (not multi_entry
                                  and not (is_wiplottrace_enabled()
                                  and pod_type = "s"))
                                  and not (  pod_consignment = yes
                                        and  l_upd_consign   = yes)
               pod_reason
               cmmt_yn
            with frame d
            editing:
               assign
                  global_site = input site
                  global_loc = input location
                  global_lot = input lotserial.
               readkey.
               apply lastkey.
            end.

            /*@MODULE PRM BEGIN*/
            /* STORE THE RECEIPT QUANTITY IN THE PRM TEMP TABLE */
            run save-receipt-qty.
            /*@MODULE PRM END*/

            if pod_consignment
               and lotserial_qty < 0
            then do:
               /* NEGATIVE QUANTITY ENTERED FOR A CONSIGNED LINE ITEM */
               {pxmsg.i &MSGNUM=4938 &ERRORLEVEL=3}
               next-prompt
                  lotserial_qty
               with frame d.
               undo,retry.
            end. /* IF pod_consignment */


            assign
               l_chkum = no
               conv_to_pod_um = 1.

            if available pt_mstr and return_um = pt_um then
            assign
               l_chkum = yes
               conv_to_pod_um = 1 / pod_um_conv.
            else
               if return_um <> pod_um then do:
               /*LOOK FOR RETURN UM TO LINE ITEM UM CONV*/
               {gprun.i ""gpumcnv.p""
                  "(input return_um, input pod_um, input pod_part,
                    output conv_to_pod_um)"}
               if conv_to_pod_um = ? then do:
                  /*NOT FOUND, LOOK FOR RETURN UM TO STOCKING UM CONV*/
                  find pt_mstr  where pt_mstr.pt_domain = global_domain and
                  pt_part = pod_part no-lock no-error.
                  if available pt_mstr then do:
                     {gprun.i ""gpumcnv.p""
                        "(input return_um, input pt_um, input pod_part,
                          output conv_to_pod_um)"}
                     if conv_to_pod_um <> ? then
                        /*CHG RTN-TO-VNDR-UM-CONV TO RTN-FROM-LINEITEM-CONV*/
                        conv_to_pod_um =  conv_to_pod_um / pod_um_conv.
                  end.
               end.
            end. /* if return_um <> pod_um */

            if conv_to_pod_um = ? then do:
               {pxmsg.i &MSGNUM=33 &ERRORLEVEL=3}
               /* No unit of measure conversion exists */
               next-prompt return_um with frame d.
               undo, retry.
            end.

            {gprun.i ""gpsiver.p""
               "(input (input site), input ?, output return_int)"}
            if return_int = 0 then do:
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
               /* USER DOES NOT HAVE ACCESS TO THIS SITE */
               next-prompt site with frame d.
               undo, retry.
            end.

            /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY */

            for first si_mstr
                  fields( si_domain  si_db si_entity si_site )
                   where si_mstr.si_domain = global_domain and  si_site = site
                   no-lock:
            end. /* FOR FIRST SI_MSTR */

            if available si_mstr then do:
               /* CHECK GL EFFECTIVE DATE */
               {gpglef02.i &module = ""IC""
                  &entity = si_entity
                  &date   = eff_date
                  &prompt = "site"
                  &frame  = "d"
                  &loop   = "locloop"}
            end. /* IF AVAILABLE SI_MSTR */

            rct_site = pod_site.
            if pod_type = "S" then do:
               undo_all = false.
               pod_recno = recid(pod_det).
               /* SUBCONTRACT WORKORDER UPDATE */
               {gprun.i ""xxpoporca2x2.p""}  /* SS - 110112.1 */ 
               if undo_all then do:
                  next-prompt wolot with frame d.
                  undo, retry.
               end.

            end. /* pod_type = "S" */

            i = 0.
            for each sr_wkfl no-lock  where sr_wkfl.sr_domain = global_domain and
            sr_userid = mfguser
                  and sr_lineid = cline:
               i = i + 1.
               if i > 1 then do:
                  multi_entry = yes.
                  leave.
               end.
            end.

            total_lotserial_qty = pod_qty_chg.
            trans_um = return_um.

            if l_chkum then
               trans_conv = 1.
            else
               trans_conv = conv_to_pod_um * pod_um_conv.

            if multi_entry then do:

               /* THIS PATCH INSURES THAT AT LEAST ONE sr_wkfl ENTRY IS
               PASSED  TO icsrup2.p ( MULTI ENTRY  MODE HANDLER ) EVEN IF
               RECEIVE ALL IS SET TO NO; SO AS TO BRING CONSISTENCY WITH
               RECEIVE ALL SET TO YES.
               */

               /* CREATE BEGINS */

               find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
               = pod_part no-lock no-error.
               if not available pt_mstr         or
                     (available pt_mstr         and
                                pt_lot_ser = "" and
                                pod_type <> "s")
               then do:

                  find first sr_wkfl  where sr_wkfl.sr_domain = global_domain and
                  sr_userid = mfguser
                     and sr_lineid = cline no-lock no-error.
                  if not available sr_wkfl then do:
                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                     assign
                        sr_userid = mfguser
                        sr_lineid = cline
                        sr_site = site
                        sr_loc = location
                        sr_lotser = lotserial
                        sr_ref = lotref
                        sr_qty = lotserial_qty.

                     /* STORE THE ABOVE CREATED DEFAULT sr_wkfl */
                     run p_create_t_sr_wkfl
                        (input        mfguser,
                         input        cline,
                         input        site,
                         input        location,
                         input        lotserial,
                         input        lotref,
                         input        lotserial_qty,
                         input-output table t_sr_wkfl).
                  end.

               end.

               /* CREATE ENDS */

               find first sr_wkfl  where sr_wkfl.sr_domain = global_domain and
               sr_userid = mfguser
                  and sr_lineid = cline exclusive-lock no-error.
               if lotserial_qty = 0 then do:
                  if available sr_wkfl then do:
                     total_lotserial_qty = total_lotserial_qty - sr_qty.
                     delete sr_wkfl.
                  end.
               end.
               else do:
                  if available sr_wkfl then do:
                     find sr_wkfl  where sr_wkfl.sr_domain = global_domain and
                     sr_userid = mfguser and
                        sr_lineid = cline exclusive-lock no-error.
                     if not ambiguous sr_wkfl then
                     assign
                        sr_site = site
                        sr_loc = location
                        sr_lotser = lotserial
                        sr_ref = lotref
                        sr_qty = lotserial_qty.
                  end.    /* avail sr_wkfl */

               end.

               if i >= 1 then
               assign
                  location = ""
                  lotserial = ""
                  lotref = "".

               podtype = pod_type.

               total_lotserial_qty = 0.
               for each sr_wkfl  where sr_wkfl.sr_domain = global_domain and
               sr_userid = mfguser and
                     sr_lineid = cline no-lock:
                  total_lotserial_qty = total_lotserial_qty + sr_qty.
               end.

               assign
                  l_delete_sr_wkfl = no
                  l_update_sr_wkfl = no
                  l_multi_return   = yes.

               /* DEFAULT CREATED sr_wkfl RECORD IS DELETED TO AVOID    */
               /* DELETING IT MANUALLY IN MULTI ENTRY SCREEN. THIS WILL */
               /* ENSURE EVERY sr_wkfl RECORD IS PASSED FOR VALIDATION  */
               /* CHECK                                                 */
               run p_delete_sr_wkfl (input        mfguser,
                                     input        cline,
                                     input        table t_sr_wkfl,
                                     input-output total_lotserial_qty,
                                     input-output l_delete_sr_wkfl).


               /* IF sr_wkfl IS MODIFIED IN MULTI-ENTRY SCREEN, */
               /* l_update_sr_wkfl IS SET TO YES                */
               {gprun.i ""xxicsrup2x2.p""
                  "(input        rct_site,
                    input        ponbr,
                    input        poline,
                    input        lotprcpt,
                    input        l_multi_return,
                    output       l_error,
                    input-output lotnext,
                    input-output vendlot,
                    input-output l_update_sr_wkfl)"} /* SS - 110112.1 */

               /* IN CASE OF INVENTORY VALIDATION ERROR AND */
               /* sr_wkfl IS NOT MODIFIED, UNDO locloop.    */
               if l_error
               and not l_update_sr_wkfl
               then do:
                  if not batchrun
                  then
                     undo locloop, retry locloop.
                  else
                     undo locloop, leave locloop.
               end. /* IF l_error */

               /* RE-CREATE DEFAULT sr_wkfl, IF sr_wkfl IS NOT UPDATED */
               /* IN MULTI ENTRY SCREEN. SO THE INVENTORY VALIDATION   */
               /* CAN BE DONE.                                         */
               run p_create_default_sr_wkfl
                  (input        l_update_sr_wkfl,
                   input        mfguser,
                   input        cline,
                   buffer       sr_wkfl,
                   input-output table t_sr_wkfl,
                   input-output l_delete_sr_wkfl).

               assign pod__qad04[1] = vendlot.
            end.
            else do:
               if pod_type = ""
               then do:

                  if pod_consignment
                  then do:
                     run p_validateTransaction (input  "CN-RCT",
                                                input  site,
                                                input  location,
                                                input  global_part,
                                                output yn).
                  end. /* IF pod_consignment */
                  else do:
                     /* CHANGED TENTH INPUT PARAMETER STRING (POD_LINE) TO "" SO */
                     /* THAT MULTIPLE LINES OF SAME LOT CAN BE RETURNED          */
                     {gprun.i ""icedit.p""
                        "(input ""ISS-PRV"",
                          input site,
                          input location,
                          input global_part,
                          input lotserial,
                          input lotref,
                          input lotserial_qty * trans_conv,
                          input trans_um,
                          input pod_nbr,
                          input """",
                          output yn)"}
                  end. /* ELSE DO */

                  if yn
                  then
                     undo locloop, retry.

                  if pod_site <> site
                  then do:

                     if pod_consignment
                     then do:
                        run p_validateTransaction (input  "CN-RCT",
                                                   input  rct_site,
                                                   input  pod_loc,
                                                   input  global_part,
                                                   output yn).
                     end. /* IF pod_consignment */
                     else do:
                        /* SET QTY TO ZERO FOR TRANSFER TRANSACTION, SINCE */
                        {gprun.i ""icedit4.p""
                           "(input transtype,
                             input rct_site,
                             input site,
                             input pod_loc,
                             input location,
                             input global_part,
                             input lotserial,
                             input lotref,
                             input lotserial_qty * trans_conv,
                             input trans_um,
                             input """",
                             input """",
                             output yn)"}
                     end. /* ELSE DO */

                     if yn
                     then
                        undo locloop, retry.
                  end. /* IF pod_site <> site */
               end. /* IF pod_type = "" */

               else do:
                  if pod_type <> "S" then do:
                     {icedit1.i
                        &site=site
                        &part=global_part
                        &lotserial=lotserial
                        &quantity="lotserial_qty * trans_conv"
                        &um=trans_um
                        &transtype=transtype
                        }
                  end.   /* pod_type <> "S" */
            /* SS - 110112.1 - B */
                  else do:
                     {icedit1.i
                        &site=site
                        &part=global_part
                        &lotserial=lotserial
                        &quantity="lotserial_qty * trans_conv"
                        &um=trans_um
                        &transtype=transtype
                        }

                     {gprun.i ""icedit.p""
                        "(input ""ISS-PRV"",
                          input site,
                          input location,
                          input global_part,
                          input lotserial,
                          input lotref,
                          input lotserial_qty * trans_conv,
                          input trans_um,
                          input pod_nbr,
                          input """",
                          output yn)"}
                  end. /* ELSE DO */
            /* SS - 110112.1 - E */

               end.

               find first sr_wkfl  where sr_wkfl.sr_domain = global_domain and
               sr_userid = mfguser
                  and sr_lineid = cline exclusive-lock no-error.
               if lotserial_qty = 0 then do:
                  if available sr_wkfl then do:
                     total_lotserial_qty = total_lotserial_qty - sr_qty.
                     delete sr_wkfl.
                  end.
               end.
               else do:
                  if available sr_wkfl then
                     assign
                        total_lotserial_qty = total_lotserial_qty
                                            - sr_qty
                                            + lotserial_qty
                        sr_site = site
                        sr_loc = location
                        sr_lotser = lotserial
                        sr_ref = lotref
                        sr_qty = lotserial_qty.
                  else do:
                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                     assign
                        sr_userid = mfguser
                        sr_lineid = cline
                        sr_site = site
                        sr_loc = location
                        sr_lotser = lotserial
                        sr_ref = lotref
                        sr_qty = lotserial_qty
                        total_lotserial_qty = total_lotserial_qty
                                            + lotserial_qty.

                     if recid(sr_wkfl) = -1 then .
                  end. /* not avail sr_wkfl */
               end. /* lotserial_qty <> 0 */

               if porec or is-return then do:
                  /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */
                  find loc_mstr  where loc_mstr.loc_domain = global_domain and
                  loc_site = site
                     and loc_loc = location no-lock no-error.

                  if available loc_mstr and loc_single = yes then do:
                     {gploc02.i  "buff1.pod_domain = global_domain and " pod_det
                     pod_nbr pod_line pod_part}

                     if error_flag = 0 and loc__qad01 = yes then do:
                        /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) FOR
                        DIFFERENT ITEMS OR LOT/SERIALS IN SAME LOCATION */
                        {gprun.i ""gploc01.p""
                           "(site,
                             location,
                             pod_part,
                             lotserial,
                             lotref,
                             loc__qad01,
                             output error_flag)"}

                        if error_flag <> 0
                           /* ADJUSTING QTY ON A PREVIOUS VIOLATION (CREATED
                           BEFORE THIS PATCH) OF SINGLE ITEM/LOT/SERIAL
                           LOCATION ALLOWED; CREATING ANOTHER VIOLATION
                           DISALLOWED.
                           */
                           and can-find(ld_det  where ld_det.ld_domain =
                           global_domain and  ld_site = site
                           and ld_loc = location and ld_part = pod_part
                           and ld_lot = lotserial and ld_ref = lotref) then
                           error_flag = 0.
                     end. /* error_flag = 0 and loc__qad01 = yes */

                     if error_flag <> 0 then do:
                        {pxmsg.i &MSGNUM=596 &ERRORLEVEL=3}
                        /*TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOC*/
                        undo locloop, retry.
                     end.
                  end. /* avail loc_mstr and loc_single = yes */
               end. /* porec or is-return */
            end. /* not multi_entry */

            if pod_type = "" then do:
               lineid_list = "".

               for each poddet  where poddet.pod_domain = global_domain and
               poddet.pod_nbr = pod_det.pod_nbr
                                 and poddet.pod_part = pod_det.pod_part
                                 and poddet.pod_type = "" no-lock:
                  assign lineid_list = lineid_list +
                     trim(string(poddet.pod_line)) + ",".
               end. /* FOR EACH PODDET */

               lineid_list = substring(lineid_list,1,
                  ((r-index(lineid_list,",") - 1))).

               if lotserial_qty > 0 then do:

                  {gprun.i ""icoviss2.p"" "(input pod_det.pod_part,
                                            input pod_det.pod_nbr,
                                            input lineid_list,
                                            input pod_det.pod_line,
                                            input conv_to_pod_um,
                                            input l_chkum,
                                            output undotran,
                                            output overissue_ok)"
                     }
                  if undotran then undo locloop, retry locloop.
                  if not overissue_ok then undo locloop, retry locloop.
               end. /* IF LOTSERIAL_QTY > 0 THEN */
            end. /* IF pod_type = "" */

            /*@MODULE PRM BEGIN*/
            if     porec
               and prm-avail
            then do:
               run validate-prm-records.

               if invalid-prm-po-ln-rcpt
               then
                  undo locloop, retry.

            end.  /* IF porec AND prm-avail */
            /*@MODULE PRM END*/

         end.

         pod_qty_chg = total_lotserial_qty.

/* SS - 110112.1 - B */
if pod_type = "s" then do:
    if total_lotserial_qty > 0 then do:
        find first wo_mstr 
            where wo_domain = global_domain 
            and wo_lot = pod_wo_lot 
        no-lock no-error.
        if avail wo_mstr then do:
            if wo_part <> pod_part then do:
                {pxmsg.i &MSGNUM=692 &MSGARG1=wo_part &ERRORLEVEL=3}
                undo lineloop, retry lineloop.                    
            end.
            if wo_status <> "R" then do:
                {pxmsg.i &MSGNUM=525 &MSGARG1=wo_status &ERRORLEVEL=3}
                undo lineloop, retry lineloop.
            end.
        end.
        else do:
                {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                undo lineloop, retry lineloop.
        end.

        if wo_qty_comp - total_lotserial_qty * trans_conv < 0 then do:
                {pxmsg.i &MSGNUM=556 &MSGARG1=""WO:"" &ERRORLEVEL=3}
                undo lineloop, retry lineloop.
        end.
    end.
end.
/* SS - 110112.1 - E */

         /* CHECK OPERATION QUEUE QTIES*/
         {gprun.i ""poporca6.p""
            "(input ""return"", input pod_nbr, input wolot, input woop,
              input no)"}

         if l_chkum then
            total_returned = pod_qty_rtnd
                           + (total_lotserial_qty / pod_um_conv).
         else
            total_returned = pod_qty_rtnd
                           + (total_lotserial_qty * conv_to_pod_um).
         assign
            pod_rum_conv = conv_to_pod_um
            pod_rum = return_um
            pod_ps_chg = packing_qty.

         if pod_type = 's' then do:
            run check_and_get_wip_lots
               (input recid(pod_det),
               input wolot, input woop,
               input move,
               output leave_loop).

            if leave_loop then undo lineloop, retry lineloop.
         end.

         if     l_upd_consign
            and not (can-find (first ld_det
                                  where ld_det.ld_domain    = global_domain
                                  and   ld_site             = site
                                  and   ld_loc              = location
                                  and   ld_part             = global_part
                                  and   ld_lot              = lotserial
                                  and   ld_ref              = lotref
                                  and   ld_supp_consign_qty > 0))
         then do:

            /* RETURN QTY EXCEEDS QTY AVAILABLE SUPPLIER CONSIGNED */
            /* LOCATION QTY                                        */
            {pxmsg.i
               &MSGNUM=6779
               &ERRORLEVEL=3
               &MSGARG1="0"}
            undo lineloop, retry lineloop.
         end. /* IF l_upd_consign AND (CAN-FIND(FIRST ld_det */

         for each ld_det
            fields (ld_loc ld_lot  ld_part   ld_supp_consign_qty
                    ld_ref ld_site ld_qty_oh ld_domain)
            where ld_det.ld_domain = global_domain
            and   ld_site          = site
            and   ld_loc           = location
            and   ld_part          = global_part
            and   ld_lot           = lotserial
            and   ld_ref           = lotref
         no-lock:

            if    ld_supp_consign_qty > 0
               or pod_consignment
            then
               pod_consignment = yes.

            if pod_um <> return_um
            then do:
               {gprun.i ""gpumcnv.p""
                  "(return_um, pod_um, pod_part, output l_conv)"}

               if return_um <> l_pt_um
               then do:

                  l_um_conv = l_conv.

                  {gprun.i ""gpumcnv.p""
                     "(pod_um, l_pt_um, pod_part, output l_conv)"}

                  l_conv = l_conv * l_um_conv.
                  l_lotserial_qty = (lotserial_qty * l_conv).

               end. /* IF return_um <> l_pt_um */
               else
                  l_lotserial_qty = lotserial_qty.

            end. /* IF pod_um <> return_um */
            else
               l_lotserial_qty = (lotserial_qty * pod_um_conv).

            l_consign_qty          = 0.
            if  pod_consignment
            then do:

               for each cnsix_mstr
                  fields (cnsix_lotser cnsix_pod_line      cnsix_site
                          cnsix_po_nbr cnsix_qty_consigned cnsix_ref
                          cnsix_domain)
                  where cnsix_mstr.cnsix_domain = global_domain
                  and   cnsix_po_nbr            = pod_nbr
                  and   cnsix_pod_line          = pod_line
                  and   cnsix_site              = pod_site
                  and   cnsix_lotser            = lotserial
                  and   cnsix_ref               = lotref
               no-lock:
                  l_consign_qty = l_consign_qty  + cnsix_qty_consigned.
               end. /* FOR EACH cnsix_mstr */
            end. /* if  pod_consigned */

            if l_upd_consign
            then do:
               if ld_supp_consign_qty < l_lotserial_qty
               then do:
                  /* RETURN QTY EXCEEDS QTY AVAILABLE SUPPLIER CONSIGNED */
                  /* LOCATION QTY                                        */
                  {pxmsg.i
                     &MSGNUM=6779
                     &ERRORLEVEL=3
                     &MSGARG1=ld_supp_consign_qty}
                  undo lineloop, retry lineloop.
               end.

               /* CHECKING AVAILABLE CNSIX_MSTR CONSIGNED QUANTITY FOR THIS */
               /* PURCHASE ORDER                                            */

               if  l_consign_qty  < l_lotserial_qty
               then do:
                  /* RETURN QTY EXCEEDS PO'S CONSIGNED QTY # */
                  {pxmsg.i
                     &MSGNUM=6780
                     &ERRORLEVEL=3
                     &MSGARG1=l_consign_qty}
                  undo lineloop, retry lineloop.
               end .  /* IF l_consign_qty */

            end. /* IF l_upd_consign */
            if not l_upd_consign
            then  do:

               {pxrun.i
                  &PROC    = 'GetInvStatus'
                  &PROGRAM = 'socmnrtn.p'
                  &HANDLE  = ph_socmnrtn
                  &PARAM   = "(input  global_part,
                               input  site,
                               input  location,
                               input  lotserial,
                               input  ref,
                               output l_status,
                               buffer ldd_det)"}.

               if can-find(first is_mstr
                              where is_mstr.is_domain = global_domain
                              and   is_status    = l_status
                              and   is_overissue = no)
               then do:

                  if l_lotserial_qty > (ld_det.ld_qty_oh  -
                                          ld_det.ld_supp_consign_qty)
                  then do:
                     l_nonconsign_qty = (ld_det.ld_qty_oh -
                                          ld_det.ld_supp_consign_qty).

                     /* NON-CONSIGNED QUANTITY AVAILABLE IN SITE LOCATION FOR */
                     /* LOT/SERIAL                                            */
                     {pxmsg.i
                        &MSGNUM=6789
                        &ERRORLEVEL=3
                        &MSGARG1=l_nonconsign_qty}
                     undo lineloop, retry lineloop.

                  end. /* IF l_lotserial_qty > (ld_det.l_qty_oh .....*/
               end. /* IF CAN-FIND(FIRST is_mstr ... */
            end.  /*  IF NOT l_upd_consign */

         end. /* FOR EACH ld_det */

         for first tt-pod
            where  tt-domain = pod_domain
            and    tt-nbr    = pod_nbr
            and    tt-line   = pod_line  :
         end. /* FOR FIRST tt-pod */

         if not available tt-pod
         then do :
           create tt-pod .
           assign tt-domain      = pod_domain
                  tt-pod.tt-nbr  = pod_nbr
                  tt-pod.tt-line = pod_line
                  tt-consign     = pod_consignment .
         end . /* IF NOT AVAILABLE tt-pod */

         if l_upd_consign
         then
            pod_consignment = yes.
         else
            pod_consignment = no.

         l_consign_total = 0.

         for each cnsix_mstr
            where cnsix_mstr.cnsix_domain = global_domain
            and   cnsix_po_nbr            = pod_nbr
            and   cnsix_pod_line          = pod_line
            and   cnsix_lotser            = lotserial
            no-lock:

            l_consign_total = l_consign_total + cnsix_qty_consigned.
         end. /* FOR EACH cnsix_mstr */

         if ((pod_qty_rcvd         >= 0
            and (total_returned     <  0
               or total_returned    > pod_qty_rcvd))
               or (pod_qty_rcvd     < 0
            and (total_returned     > 0
               or total_returned    < pod_qty_rcvd)))
               or ((l_consign_total < l_lotserial_qty)
            and pod_consignment)
         then do:

            {pxmsg.i &MSGNUM=375 &ERRORLEVEL=3}
            /* Cannot return more than received */
            undo lineloop, retry lineloop.

         end. /* IF (   (pod_qty_rcvd            >= 0 */

         /* ADD COMMENTS, IF DESIRED */
         if cmmt_yn then do:
            hide frame b no-pause.
            hide frame c no-pause.
            hide frame d no-pause.
            cmtindx = pod_cmtindx.
            /* USE PREFIX VARIABLE = "RTV: " */

            global_ref = cmmt-prefix + " " +
                         pod_nbr + "/" + string(pod_line).
            {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}
            pod_cmtindx = cmtindx.
         end.

         /*@MODULE PRM BEGIN*/
         if     porec
            and prm-avail
            and c-application-mode <> "API"
         then
            run display-pao-lines.
         /*@MODULE PRM END*/
      end. /* DO TRANSACTION */

      release pod_det.

   end. /* REPEAT */

   do on endkey undo edit-loop, leave edit-loop:
      assign
         l_reset_pod     = yes
         l_remove_srwkfl = yes
         yn              = yes.
      {pxmsg.i &MSGNUM=376 &ERRORLEVEL=1 &CONFIRM=yn}
      /* Display purchase order lines being returned? */
      l_reset_pod = no.
      if yn then do:
         hide frame c.
         hide frame d.
         for each pod_det no-lock
                where pod_det.pod_domain = global_domain and  pod_nbr = po_nbr
                and pod_qty_chg <> 0
               use-index pod_nbrln,
               each sr_wkfl no-lock  where sr_wkfl.sr_domain = global_domain
               and  sr_userid = mfguser
               and sr_lineid = string(pod_line) with frame f_pod width 80
               break by pod_line by pod_part by sr_site
               by sr_loc by sr_lotser by sr_ref:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame f_pod:handle).

            if first-of(sr_lotser) then do:
               display
                  pod_line
                  pod_part
                  sr_site
                  sr_loc
                  sr_lotser
                  column-label {&porvisa_p_7}.
               if sr_ref <> "" then down 1.
            end.
            display
               sr_ref format "x(8)" when (sr_ref <> "") @ sr_lotser
               sr_qty
               pod_rum.
         end.
      end.
   end.

   do on endkey undo edit-loop, leave edit-loop:
      proceed = no.
      assign
         l_reset_pod = yes
         yn = yes.

      /* IS ALL INFORMATION CORRECT */
      /*V8-*/
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
      /*V8+*/

      /* IS ALL INFORMATION CORRECT */
      /*V8! {mfgmsg10.i 12 1 yn}
      if yn = ? then
         undo edit-loop, leave edit-loop.
      */

      assign
         l_remove_srwkfl = no
         l_reset_pod     = no.
      if yn then do:
         proceed = yes.
         leave.
      end.
   end.
end.

if l_reset_pod then
/* SET RECEIPT QTY TO ZERO FOR ALL PO LINES */
run p-upd-pod-det.

hide frame c no-pause.
hide frame d no-pause.

if l_remove_srwkfl then
do:
   for each sr_wkfl exclusive-lock  where sr_wkfl.sr_domain = global_domain and
    sr_userid = mfguser:
      delete sr_wkfl.
   end. /* FOR EACH SR_WKFL */
end. /* IF L_REMOVE_SRWKFL */

/* SET RECEIPT QTY TO ZERO FOR ALL PO LINES */
PROCEDURE p-upd-pod-det:

   for each pod_det exclusive-lock
          where pod_det.pod_domain = global_domain and  pod_nbr =
          po_mstr.po_nbr:
      pod_qty_chg = 0.
   end. /*FOR EACH POD_DET*/

END PROCEDURE. /* PROCEDURE P-UPD-POD-DET */

/* ADDED FOLLOWING PROCEDURE TO INITIALIZE WIP LOT TRACE TEMP TABLES*/
PROCEDURE init_poline_bkfl_input_output:
   run init_poline_bkfl_input_wip_lot
      in h_wiplottrace_procs.

   run init_poline_bkfl_output_wip_lot
      in h_wiplottrace_procs.
END PROCEDURE.

/* ADDED FOLLOWING PROCEDURE TO PROCESS/VALIDATE WIP LOTS */
PROCEDURE check_and_get_wip_lots:
   define input parameter ip_pod_recid as recid no-undo.
   define input parameter ip_wo_id as character no-undo.
   define input parameter ip_wo_op as integer no-undo.
   define input parameter ip_move as logical no-undo.
   define output parameter op_undo_all as logical no-undo.

   define variable rejected as logical no-undo.

   find pod_det where recid(pod_det) = ip_pod_recid exclusive-lock.
   for first po_mstr  where po_mstr.po_domain = global_domain and  po_nbr =
   pod_nbr no-lock:
   end.

   for first wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
   ip_wo_id
         and wo_nbr = "" no-lock:
   end.

   if not available wo_mstr then leave.

   for first wr_route
          where wr_route.wr_domain = global_domain and  wr_lot = ip_wo_id and
          wr_op = ip_wo_op
         no-lock:
   end.

   if not available wr_route then leave.

   if not wr_milestone then do:
      {pxmsg.i &MSGNUM=560 &ERRORLEVEL=2}

      if is_wiplottrace_enabled() then do:
         if prev_milestone_operation(ip_wo_id, ip_wo_op) <> ?
            and is_operation_queue_lot_controlled
            (ip_wo_id,
            prev_milestone_operation(ip_wo_id, ip_wo_op),
            OUTPUT_QUEUE)
         then do:
            {pxmsg.i &MSGNUM=8465 &ERRORLEVEL=3}
            /* WIP LOT TRACE IS ENABLED AND OPERATION IS A
               NON-MILESTONE */
            op_undo_all = true.
            leave.
         end.
      end.
   end.

   {gprun.i ""recrtcl.p""
      "(input wo_lot, input ip_wo_op, input yes,
        input  - pod_qty_chg * pod_um_conv * pod_rum_conv,
        input eff_date, input yes, input wr_wkctr,
        output rejected, output lotserials_req)"}

   if rejected then do:
      assign
         mess_desc =
         getTermLabel("FOR_PO_LINE", 16) + ": " + string(pod_line) + " " +
         getTermLabel("CUMULATIVE_ID", 9) + ": " + ip_wo_id + " " +
         getTermLabel("WORK_ORDER_OPERATION", 4) + ": " + string(ip_wo_op).

      if pod_type <> "M" and lotserials_req then do:
         {pxmsg.i &MSGNUM=1119 &ERRORLEVEL=3 &MSGARG1=mess_desc}
         /* LOT/SERIAL NUMBER REQUIRED */
      end.
      else do:
         {pxmsg.i &MSGNUM=1989 &ERRORLEVEL=4 &MSGARG1=mess_desc}
         /* INVALID INVENTORY FOR BACKFLUSH */
      end.

      {pxmsg.i &MSGNUM=1988 &ERRORLEVEL=3}
      /* PLEASE BACKFLUSH COMPONENTS MANUALLY */
   end.
   else do:
      if is_wiplottrace_enabled()
         and is_operation_queue_lot_controlled(ip_wo_id, ip_wo_op,
         OUTPUT_QUEUE)
      then do:
         run get_poline_porvis_wip_lots_from_user
            in h_wiplottrace_procs
            (
            input pod_nbr,
            input pod_line,
            input ip_wo_id,
            input ip_wo_op,
            input pod_qty_chg,
            input pod_um_conv * pod_rum_conv,
            input pod_rum,
            input ip_move,
            input wo_site,
            input po_vend,
            input '',
            output op_undo_all
            ) .
      end. /* if is_wiplottrace_enabled */
   end.
END PROCEDURE.

/*PROCEDURE WILL DISPLAY THE ITEM DESCRIPTION */
PROCEDURE get_pt_description:
   define input parameter p_pod_part like pt_part no-undo.
   define input parameter p_pod_desc like pod_desc no-undo.

   define variable p_pt_desc1 like pt_desc1 no-undo.
   define variable p_pt_desc2 like pt_desc2 no-undo.

   for first pt_mstr
      fields(pt_domain pt_part pt_desc1 pt_desc2)
      where pt_domain = global_domain
      and   pt_part   = p_pod_part
   no-lock:
   end. /* FOR FIRST pt_mstr */

   if available pt_mstr
   then
      assign
         p_pt_desc1 = pt_desc1
         p_pt_desc2 = pt_desc2.
   else
      assign
         p_pt_desc1 = p_pod_desc
         p_pt_desc2 = "".

   /* DESCRIPTION: p_pt_desc1 + p_pt_desc2 */
   {pxmsg.i &MSGNUM=2685
            &ERRORLEVEL=1
            &MSGARG1=getTermLabel('DESCRIPTION',45)
            &MSGARG2='":"'
            &MSGARG3=p_pt_desc1
            &MSGARG4=p_pt_desc2}

END PROCEDURE. /* get_pt_description */

PROCEDURE p_create_t_sr_wkfl:

   define input        parameter l_mfguser           as   character   no-undo.
   define input        parameter l_cline             as   character   no-undo.
   define input        parameter l_site              like si_site     no-undo.
   define input        parameter l_location          as   character   no-undo.
   define input        parameter l_lotserial         as   character   no-undo.
   define input        parameter l_lotref            as   character   no-undo.
   define input        parameter l_lotserial_qty     like lotserial_qty
                                                                      no-undo.
   define input-output parameter table               for  t_sr_wkfl.

   if not can-find(first t_sr_wkfl
                      where t_sr_userid = l_mfguser
                      and   t_sr_lineid = l_cline)
   then do:
      create t_sr_wkfl.
      assign
         t_sr_userid = l_mfguser
         t_sr_lineid = l_cline
         t_sr_site   = l_site
         t_sr_loc    = l_location
         t_sr_lotser = l_lotserial
         t_sr_ref    = l_lotref
         t_sr_qty    = l_lotserial_qty.
   end. /* IF NOT CAN-FIND(FIRST ... */
END PROCEDURE. /* p_create_t_sr_wkfl */

PROCEDURE p_create_default_sr_wkfl:

   define input        parameter l_update_sr_wkfl    like mfc_logical no-undo.
   define input        parameter l_mfguser           as   character   no-undo.
   define input        parameter l_cline             as   character   no-undo.
   define              parameter buffer sr_wkfl      for  sr_wkfl.
   define input-output parameter table               for  t_sr_wkfl.
   define input-output parameter l_delete_sr_wkfl    like mfc_logical no-undo.

   /* RE-CREATE DEFAULT sr_wkfl, IF sr_wkfl IS NOT UPDATED IN MULTI ENTRY */
   /* SCREEN. SO THE INVENTORY VALIDATION CAN BE DONE.                    */

   if l_delete_sr_wkfl
   then do:

      if not l_update_sr_wkfl
      then do:

         if not can-find(first sr_wkfl
                            where sr_domain = global_domain
                            and   sr_userid = l_mfguser
                            and   sr_lineid = l_cline)
         then do:
            for first t_sr_wkfl
               where t_sr_userid = l_mfguser
               and   t_sr_lineid = l_cline
               no-lock:

               create sr_wkfl.
               assign
                  sr_domain           = global_domain
                  sr_userid           = t_sr_userid
                  sr_lineid           = t_sr_lineid
                  sr_site             = t_sr_site
                  sr_loc              = t_sr_loc
                  sr_lotser           = t_sr_lotser
                  sr_ref              = t_sr_ref
                  sr_qty              = t_sr_qty.
               if recid(sr_wkfl) = -1
               then
                  .
            end. /* FOR FIRST t_sr_wkfl */

         end. /* IF NOT CAN-FIND(FIRST ... */
      end. /* IF NOT l_update_sr_wkfl */

      else do:

         /* DELETE TEMP-TABLE RECORD TO INDICATE DEFAULT sr_wkfl */
         /* IS UPDATED IN MULTI-ENTRY SCREEN                     */

         find first t_sr_wkfl
            where t_sr_userid = l_mfguser
            and   t_sr_lineid = l_cline
            exclusive-lock no-error.

         if available t_sr_wkfl
         then
            delete t_sr_wkfl.

      end. /* ELSE DO */

      l_delete_sr_wkfl = no.
   end. /* IF l_delete_sr_wkfl */
END PROCEDURE. /* p_create_default_sr_wkfl */

PROCEDURE p_delete_sr_wkfl:

   define input        parameter l_mfguser           as   character   no-undo.
   define input        parameter l_cline             as   character   no-undo.
   define input        parameter table               for  t_sr_wkfl.
   define input-output parameter l_tot_lotserial_qty like pod_qty_chg no-undo.
   define input-output parameter l_delete_sr_wkfl    like mfc_logical no-undo.

   define buffer sr_wkfl for sr_wkfl.

   for first t_sr_wkfl
      where t_sr_userid = l_mfguser
      and   t_sr_lineid = l_cline
      no-lock,
      first sr_wkfl
         where sr_domain  = global_domain
         and   sr_userid  = t_sr_userid
         and   sr_lineid  = t_sr_lineid
         and   sr_loc     = t_sr_loc
         and   sr_lotser  = t_sr_lotser
         and   sr_ref     = t_sr_ref
         exclusive-lock:

         assign
            l_tot_lotserial_qty = 0
            l_delete_sr_wkfl    = yes.

         delete sr_wkfl.

   end. /* FOR FIRST t_sr_wkfl */

END PROCEDURE. /* p_delete_sr_wkfl */

PROCEDURE p_validateTransaction:

   define input parameter p_transtype like tr_type.
   define input parameter p_site      like tr_site.
   define input parameter p_location  like tr_loc.
   define input parameter p_part      like tr_part.
   define output parameter p_undotran like mfc_logical no-undo.

   define variable l_status  like si_status initial "" no-undo.

   for first ld_det
      fields (ld_site ld_loc ld_lot ld_ref ld_part ld_status ld_domain
             ld_qty_oh ld_supp_consign_qty)
      where ld_det.ld_domain = global_domain
      and   ld_site          = p_site
      and   ld_loc           = p_location
      and   ld_part          = p_part
   no-lock:
      l_status = ld_status.
   end. /* FOR FIRST ld_det */

   if not available ld_det
   then do:

      for first loc_mstr
         fields (loc_site loc_loc loc_status loc_single loc__qad01 loc_domain)
         where loc_mstr.loc_domain = global_domain
         and   loc_site            = p_site
         and   loc_loc             = p_location
      no-lock:
         l_status = loc_status.
      end. /* FOR FIRST loc_mstr */

      if not available loc_mstr
      then do:

         for first si_mstr
            fields (si_site     si_status si_cur_set si_db     si_entity
                    si_git_acct si_git_cc si_git_sub si_gl_set si_domain)
            where si_mstr.si_domain = global_domain
            and   si_site           = p_site
         no-lock:
            l_status = si_status.
         end. /* FOR FIRST si_mstr */

      end. /* IF NOT AVALIABLE loc_mstr */
   end. /* IF NOT AVAILABLE ld_det */

   /* MAKE SURE STATUS CODE EXISTS AND TRANSTYPE ALLOWED */
   for first is_mstr
      fields (is_status is_domain)
      where is_mstr.is_domain = global_domain
      and   is_status         = l_status
   no-lock:
   end. /* FOR FIRST is_mstr */

   if not available is_mstr
   then do:
      /* INVENTORY STATUS IS NOT DEFINED */
      {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
      undo, retry.
   end.

   for first isd_det
      fields (isd_tr_type isd_status isd_bdl_allowed isd_domain)
      where isd_det.isd_domain = global_domain
      and   isd_tr_type        = p_transtype
      and   isd_status         = is_status
   no-lock:
   end. /* FOR FIRST isd_det */
   if available isd_det
   then do:
      if (batchrun            =  yes
          and isd_bdl_allowed <> yes)
         or batchrun <> yes
      then do:
      p_undotran = yes.
         /* TRANSACTION RESTRICTED FOR SITE/LOC */
         {pxmsg.i &MSGNUM=7086 &ERRORLEVEL=3
                  &MSGARG1=p_transtype
                  &MSGARG2=p_site
                  &MSGARG3=p_location}
         undo, retry.
      end. /* IF batchrun = yes */
   end. /* IF AVAILABLE isd_det */

END PROCEDURE. /* p_validateTransaction */

PROCEDURE build-prm-temp-table:

/*------------------------------------------------------------------
PURPOSE :   Build the temp table required for PRM records.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size.
-----------------------------------------------------------------*/

   /* CREATE TEMP-TABLE RECORD FOR PO LINE WHEN */
   /* PRM MODULE IS ENABLED AND PO LINE IS      */
   /* LINKED TO A PRM PROJECT LINE              */

   if     prm-avail
      and porec
   then
      for each pod_det
         fields (pod_bo_chg   pod_cmtindx  pod_due_date
                 pod_fsm_type pod_line     pod_lot_rcpt
                 pod_nbr      pod_op       pod_part
                 pod_pjs_line pod_project  pod_consignment
                 pod_ps_chg   pod_qty_chg  pod_qty_ord
                 pod_qty_rcvd pod_rma_type pod_rum
                 pod_rum_conv pod_sched    pod_site
                 pod_status   pod_taxable  pod_taxc
                 pod_tax_env  pod_tax_in   pod_tax_usage
                 pod_type     pod_um       pod_um_conv
                 pod_wo_lot   pod_vpart    pod__qad04[1])
      no-lock
         where pod_det.pod_domain = global_domain
         and   pod_nbr            = po_mstr.po_nbr:
      if     prm-avail
         and pod_det.pod_project  <> ""
         and pod_det.pod_pjs_line <> 0
      then do:

         {gprunmo.i
            &program=""pjporca1.p""
            &module="PRM"
            &param="""(buffer pod_det)"""}
      end.  /*  IF prm-avail */
   end. /* FOR EACH pod_det */

END PROCEDURE.

PROCEDURE validate-prm-records:

/*------------------------------------------------------------------
PURPOSE :   Validates the PRM records associated with the purchase
order lines.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size
------------------------------------------------------------------*/

   /* PERFORM PRM VALIDATIONS ON PO LINE RECEIPT */
   {gprunmo.i
      &program=""pjporvil.p""
      &module="PRM"
      &param="""(input site,
                 input location,
                 output invalid-prm-po-ln-rcpt,
                 buffer pod_det)"""}

END PROCEDURE.

/*============================================================================*/
PROCEDURE display-pao-lines:

/*------------------------------------------------------------------
PURPOSE :   Display the PRM Project Activity Order Lines attached that
can be linked to the project line..
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size.
------------------------------------------------------------------*/

   for first ttpao-det fields()
   no-lock
      where ttpao-recno = recid(pod_det):

      hide frame c no-pause.
      hide frame d no-pause.

      /* SELECT PAO LINES LINKED TO PROJECT LINE */
      /* ON WHICH PAR IS TO BE PERFORMED         */
      {gprunmo.i
         &program=""pjporpas.p""
         &module="PRM"
         &param="""(input lotserial_qty,
                    buffer pod_det)"""}

      view frame c.
      view frame d.
   end. /* FOR FIRST TTPAO-DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE save-receipt-qty:

/*------------------------------------------------------------------
PURPOSE :   Stores the receipt quantity entered into the PRM
temp-table ttprm-det for later reference.
PARAMETERS:
NOTES:
------------------------------------------------------------------*/
   for first ttprm-det
   exclusive-lock
      where ttprm-nbr  = pod_det.pod_nbr
      and   ttprm-line = pod_det.pod_line:

      ttprm-qty = lotserial_qty.
   end. /* FOR FIRST ttprm-det */

END PROCEDURE.
