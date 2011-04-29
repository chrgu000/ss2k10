/* icsrup2.p - PROGRAM TO UPDATE sr_wkfl MULTI LINE ENTRY W/O SITE INPUT*/
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 7.3      LAST MODIFIED: 12/14/92   BY: tjs *G443**/
/* REVISION: 7.3      LAST MODIFIED: 09/14/93   BY: tjs *GE59**/
/*                                   07/30/94   BY: rmh *FP73**/
/*                                   10/27/94   BY: ljm *GN62**/
/* REVISION: 8.5      LAST MODIFIED: 12/05/94   BY: ktn *J038**/
/* REVISION: 8.5      LAST MODIFIED: 12/14/94   BY: ktn *J041**/
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040**/
/* REVISION: 7.3      LAST MODIFIED: 03/10/95   BY: jpm *G0GY**/
/* REVISION: 8.5      LAST MODIFIED: 06/04/95   BY: sxb *J04D**/
/* REVISION: 7.3      LAST MODIFIED: 07/07/95   BY: jym *G0RY**/
/* REVISION: 7.2      LAST MODIFIED: 11/02/95   BY: jym *F0TC**/
/* REVISION: 8.5      LAST MODIFIED: 01/17/96   BY: tjs *J0C1**/
/* REVISION: 8.5      LAST MODIFIED: 05/14/96   BY: rxm *G1SL**/
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: kxn *J11S**/
/* REVISION: 8.5      LAST MODIFIED: 08/29/96   BY: *J14K* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 11/22/96   BY: *J192* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 06/27/97   BY: *J1V7* Aruna Patil  */
/* REVISION: 8.5      LAST MODIFIED: 12/08/97   BY: *J27Q* Mandar K.    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *J2P2* Niranjan R.  */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 06/03/99   BY: *J3FN* Sachin Shinde    */
/* REVISION: 9.1      LAST MODIFIED: 09/30/99   BY: *J3M0* Steve Nugent     */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *J3M5* G. Latha         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* REVISION: 9.1      LAST MODIFIED: 07/12/00   BY: *N0G4* Katie Hilbert    */
/* REVISION: 9.1      LAST MODIFIED: 05/22/00   BY: Strip/Beautify:  3.0    */
/* REVISION: 9.1      LAST MODIFIED: 06/15/00   BY: *N0DK* Zheng Huang        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0K2* Phil DeRogatis     */
/* Revision: 1.21     BY: Manjusha Inglay       DATE: 01/03/02  ECO: *N178*  */
/* Revision: 1.22     BY: Karan Motwani         DATE: 06/24/02  ECO: *N1M1*  */
/* Revision: 1.23     BY: Narathip W.           DATE: 05/03/02  ECO: *P0R5*  */
/* Revision: 1.25     BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00G*  */
/* Revision: 1.26     BY: Gnanasekar            DATE: 08/05/03  ECO: *P0XW*  */
/* Revision: 1.29     BY: Shoma Salgaonkar      DATE: 09/26/03  ECO: *N2K8*  */
/* Revision: 1.30     BY: Dan Herman            DATE: 11/04/04  ECO: *M1V1* */
/* Revision: 1.31     BY: Bhagyashri Shinde     DATE: 01/25/05  ECO: *P35C* */
/* Revision: 1.32  BY: Priyank Khandare      DATE: 02/02/05  ECO: *P35K* */
/* Revision: 1.32.2.2 BY: Kirti Desai           DATE: 12/28/05  ECO: *P4CF* */
/* $Revision: 1.32.2.3 $     BY: Shridhar M            DATE: 05/18/06  ECO: *P4J2* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110112.1  By: Roger Xiao */  /*check loc for pod_type = "s" */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SIMILAR TO icsrup.p, USED FOR MULTIPLE ENTRIES ON A PO RECEIPT, */
/* OR RTS SHIPMENT/RECEIPT.                                        */

/*V8:ConvertMode=Maintenance                                            */
{mfdeclre.i}
/* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxmaint.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "ICSRUP2.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icsrup2_p_1 "Ref"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input        parameter base_site      like si_site.
define input        parameter ponbr          like pod_nbr.
define input        parameter poline         like pod_line.
define input        parameter singlelot      like pod_lot_rcpt.
define input        parameter l_multi_return like mfc_logical no-undo.
define output       parameter l_error        like mfc_logical no-undo.
define input-output parameter lotnext        like pod_lot_next.
define input-output parameter vendlot        like tr_vend_lot.
/* l_update_sr_wkfl IS DEFINED AS UNDO TO UPDATE THIS FLAG TO   */
/* YES ONLY WHEN sr_wkfl RECORD GETS UPDATED/DELETED WITHOUT    */
/* ANY ERRORS ATLEAST ONCE IN THIS PROGRAM.                     */
/* PLEASE DO NOT MAKE THIS PARAMETER AS NO-UNDO.                */
define input-output parameter l_update_sr_wkfl like mfc_logical.

define new shared variable msgref          as   character format "x(20)".

define shared variable podtype             like pod_type.
define shared variable multi_entry         as   log         no-undo.
define shared variable cline               as   character.
define shared variable lotserial_control   like pt_lot_ser.
define shared variable issue_or_receipt    as   character.
define shared variable total_lotserial_qty like sr_qty.
define shared variable site                like sr_site     no-undo.
define shared variable location            like sr_loc      no-undo.
define shared variable lotserial           like sr_lotser   no-undo.
define shared variable lotserial_qty       like sr_qty      no-undo.
define shared variable trans_um            like pt_um.
define shared variable trans_conv          like sod_um_conv.
define shared variable transtype           as   character.
define shared variable lotref              like sr_ref
   format "x(8)" label {&icsrup2_p_1}                       no-undo.
define shared variable pod_recno as recid.
define shared variable is-return           like mfc_logical no-undo.
define shared variable porec               like mfc_logical no-undo.
define shared variable ports               as   character   no-undo.

define variable sr_recno       as   recid.
define variable del-yn         like mfc_logical.
define variable num_recs       as   integer.
define variable rec_indx       as   integer.
define variable undo-input     like mfc_logical.
define variable i              as   integer.
define variable j              as   integer.
define variable iiii           as   integer.
define variable serialcount    as   integer.
define variable serials_yn     like mfc_logical.

define variable nextserial     as   decimal                 no-undo.
define variable serialprefix   as   character.
define variable serialsuffix   as   character.
define variable intstart       as   integer.
define variable intend         as   integer.
define variable seriallength   as   integer.
define variable intcount       as   integer.
define variable iss_yn         like mfc_logical.
define variable getlot         like mfc_logical.
define variable errsite        like pod_site                no-undo.
define variable errloc         like pod_loc                 no-undo.
define variable errmsg         as   integer                 no-undo.
define variable l_addon        like mfc_logical initial yes no-undo.
define variable l_count        as   integer                 no-undo.
define variable vLotSerialQty  like lotserial_qty           no-undo.
define variable l_flag         like mfc_logical             no-undo.
define variable l_continue     like mfc_logical initial no  no-undo.
define variable l_scan         like mfc_logical initial yes no-undo.

{mfaimfg.i}  /* Common API constants and variables */

{popoit01.i} /* Define API purchase order temp tables  */
{mfctit01.i} /* Define API transaction comments temp tables */

l_error = no.
if c-application-mode = "API" then do:

   /* Get handle of API controller */
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output ApiContextString)"}

   /* Get current purchase order transaction detail record */
   run getPurchaseOrderTransDetRecord in ApiMethodHandle
      (buffer ttPurchaseOrderTransDet).

end. /* IF c-application-mode = "API" */

/*MAIN-BEGIN*/

/*@CTRL BEGIN*/
for first clc_ctrl
   fields( clc_domain clc_lotlevel)
 where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:

   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields( clc_domain clc_lotlevel)
    where clc_ctrl.clc_domain = global_domain no-lock:
   end. /* FOR FIRST clc_ctrl */

end. /* IF NOT AVAILABLE clc_ctrl */
/*@CTRL END*/

/*@EVENT POReceiptLine-read*/
{pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
         &PARAM="(input global_part,
                  buffer pt_mstr,
                  input {&NO_LOCK_FLAG},
                  input {&NO_WAIT_FLAG})"
         &NOAPPERROR=true
         &CATCHERROR=true
   }

pause 0.

form
   space(1)
   location
   lotserial
   lotref  column-label {&icsrup2_p_1}
   vendlot format "x(22)"
   lotserial_qty
   space(1)
   /*V8! space(6) */
with frame a column 3 no-attr-space overlay no-underline
   /*V8-*/ width 76 /*V8+*/.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form with frame c 6 down scroll 1
   overlay column 5 row 8 attr-space
   title color normal " " + issue_or_receipt +
   (getFrameTitle("DETAIL_-_QUANTITY:",26)) +
   string(lotserial_qty) + " " + trans_um + " ".

setFrameLabels(frame c:handle).

if c-application-mode <> "API" then do:
   view frame c.
   view frame a.
end.

/*V8! frame a:y = frame c:y + frame c:height-pixels. */

loop1:
repeat:

   /* IF ITEM IS LOT/SERIAL CONTROLLED AND ENTERING MULTI-ENTRY WITH */
   /* AN SR_WKFL WITH A BLANK LOT/SERIAL, THEN DELETE THE SR_WKFL    */

   if available pt_mstr
      and pt_lot_ser <> ""
   then do:
      for first sr_wkfl
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
         and   sr_lineid = cline
      exclusive-lock:
      end. /* FOR FIRST sr_wkfl */

      if available sr_wkfl
         and sr_lotser = ""
      then do:
         delete sr_wkfl.
         total_lotserial_qty = 0.
      end. /* IF AVAILABLE sr_wkfl */

   end. /* IF AVAILABLE pt_mstr */

   loop2:
   repeat with frame a:
      if c-application-mode <> "API" then
         view.

      /* READ/DISPLAY EXISTING SR_WKFL'S IN FRAME C */

      clear frame c all no-pause.

      for first sr_wkfl
         fields( sr_domain sr_lineid sr_loc    sr_lotser sr_qty sr_ref
                sr_site   sr_userid sr_vend_lot)
         where recid(sr_wkfl) = sr_recno
      no-lock:
      end. /* FOR FIRST sr_wkfl */

      if available sr_wkfl
      then do:

         do i = 1 to truncate(frame-down(c) / 2,0)
            while available sr_wkfl:
            find next sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.
         end. /* DO i = 1 TO TRUNCATE(FRAME-DOWN(c) / 2,0) */

         if not available sr_wkfl
         then
            find last sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.

         do i = 1 to frame-down(c) - 1
            while available sr_wkfl:
            find prev sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.
         end. /* DO i = 1 TO FRAME-DOWN(c) */

         if not available sr_wkfl
         then do:
            /*@EVENT POReceiptLine-read*/
            {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                     &PARAM="(input integer(cline),
                              buffer sr_wkfl,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"
                     &NOAPPERROR=true
                     &CATCHERROR=true
               }
         end. /* IF NOT AVAILABLE sr_wkfl */

      end. /* IF AVAILABLE sr_wkfl */

      else do:
         {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                           buffer sr_wkfl,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true
            }
      end. /* IF NOT AVAILABLE sr_wkfl */

      if available sr_wkfl
      then do with frame c:

         do i = 1 to frame-down(c)
            while available sr_wkfl:
            if c-application-mode <> "API" then
               display
                  space(1)
                  sr_loc
                  sr_lotser
                  sr_ref       format "x(8)" column-label {&icsrup2_p_1}
                  sr_vend_lot  format "x(22)"
                  sr_qty
                  space(1)
               with frame c column 3 width 76.

            find next sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.

            if frame-line(c) < frame-down(c)
            then
               down 1 with frame c.
         end. /* DO i = 1 TO FRAME-DOWN(c) */

      end.    /* IF AVAILABLE sr_wkfl */

      for first sr_wkfl
         fields( sr_domain sr_lineid sr_loc    sr_lotser sr_qty sr_ref
                sr_site   sr_userid sr_vend_lot)
         where recid(sr_wkfl) = sr_recno
      no-lock:
      end. /* FOR FIRST sr_wkfl */

      if not available sr_wkfl
      then do:
         {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                           buffer sr_wkfl,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true
            }
      end. /* IF NOT AVAILABLE sr_wkfl */

      /* DISPLAY EITHER THE FIRST OR THE CURRENT SR_WKFL  */
      /* IN THE WORK FRAME - FRAME A                      */

      if available sr_wkfl
      then
         assign
            site          = sr_site
            location      = sr_loc
            lotserial     = sr_lotser
            lotref        = sr_ref
            vendlot       = sr_vend_lot
            lotserial_qty = sr_qty.

      /* MESSAGE #300 - TOTAL LOT/SERIAL QUANTITY ENTERED: */
      {pxmsg.i
         &MSGNUM=300
         &ERRORLEVEL={&INFORMATION-RESULT}
         &MSGARG1=total_lotserial_qty}

      idloop:
      do on error undo, retry:

         if c-application-mode = "API" and retry
            then return error return-value.

         /* GETLOT INDICATES ICSRUP2.P WILL GET A LOT NUMBER FROM */
         /* USER INPUT - NOT AUTOLOT-GENERATED                    */
         /* REPLACED THE FIRST INPUT PARAMETER TO global_part     */
         /* FROM pt_part                                          */
         /*@EVENT POReceiptLine-read (also enablement)*/

         getlot = ({pxfunct.i &FUNCTION='isUserToProvideReceiptLot'
                             &PROGRAM='porcxr2.p'
                             &PARAM="input global_part,
                                     input singlelot,
                                     input
                             (lotserial = lotnext and lotnext <> """"),
                                     input podtype,
                                     input (porec and not is-return)"
                  }).

         if c-application-mode <> "API" then
            display
               location
               lotserial.

         if c-application-mode <> "API" then
         update
            location
            lotserial when (getlot = yes)
            lotref
            vendlot
         editing:

            /*@EVENT POReceiptDetail-create*/
            assign
               global_loc = input location
               global_lot = input lotserial.

            {mfnp08.i sr_wkfl sr_id
               " sr_wkfl.sr_domain = global_domain and sr_userid  = mfguser and
               sr_lineid = cline"
               sr_site "site" sr_loc "input location"
               sr_lotser "input lotserial" sr_ref "input lotref"}

            if recno <> ?
            then do:
               assign
                  location      = sr_loc
                  lotserial     = sr_lotser
                  lotserial_qty = sr_qty
                  vendlot       = sr_vend_lot
                  lotref        = sr_ref.

               display
                  location
                  lotserial
                  lotref
                  vendlot
                  lotserial_qty .
            end. /* IF recno <> ? */
         end.    /* EDITING */

         if c-application-mode = "API" then do:
            assign {mfaiset.i location ttPurchaseOrderTransDet.loc}
                   {mfaiset.i lotref ttPurchaseOrderTransDet.ref}
                   {mfaiset.i vendlot ttPurchaseOrderTransDet.vendLot}.
            if getlot = yes then
               assign {mfaiset.i lotserial ttPurchaseOrderTransDet.lotSer}.
         end.

         /* IN CASE OF RTS RECEIPTS FOR SERIALIZED ITEMS, SKIP THE     */
         /* VALIDATION FOR SERIAL NUMBER USING THE PROCEDURE           */
         /* validateLotSerialUsage WHEN THE SHIPMENT AND RECEIPT FOR   */
         /* THE SERIALIZED ITEM ARE PERFORMED ON THE SAME RTS WITH THE */
         /* SAME SERIAL NUMBER.                                        */

         for first pod_det
            fields( pod_domain      pod_fsm_type pod_line     pod_nbr
                    pod_consignment pod_part     pod_rma_type)
             where pod_det.pod_domain = global_domain and   pod_nbr      = ponbr
            and    pod_line     = poline
            and    pod_fsm_type = "RTS-RCT"
         no-lock:

            l_flag = no.

            for first rmd_det
               fields( rmd_domain rmd_nbr     rmd_part rmd_prefix
                       rmd_qty_acp rmd_ser  rmd_type)
                where rmd_det.rmd_domain = global_domain and   rmd_nbr    =
                pod_nbr
               and    rmd_part   = pod_part
               and    rmd_prefix = "V"
               and    rmd_type   = "O"
               and    rmd_qty_acp > 0
            no-lock:
               if rmd_ser <> lotserial
               then do:
                  for first tr_hist
                     fields( tr_domain tr_nbr     tr_part
                             tr_program tr_serial)
                      where tr_hist.tr_domain = global_domain and  tr_serial  =
                      lotserial
                     and   tr_nbr     = pod_nbr
                     and   tr_part    = pod_part
                     and   tr_program = "fsrtvis.p"
                  no-lock:
                  end. /* FOR FIRST tr_hist */

                  if not available tr_hist
                  then
                     l_flag = yes.

               end. /* IF rmd_ser <> lotserial */

            end. /* FOR FIRST rmd_det ... */

            if not available rmd_det
            then
               l_flag = yes.

         end. /* FOR FIRST pod_det */

         if not available pod_det
         then

            /* FOR ALL OTHER TRANSACTIONS, EXCEPT RTS RECEIPTS */
            /* FOR SERIALIZED ITEMS.                           */

            l_flag = yes.

         for first rmd_det
            fields (rmd_domain rmd_nbr rmd_part rmd_prefix rmd_site
                    rmd_loc rmd_qty_acp rmd_ser rmd_type   rmd_iss )
            where rmd_domain = global_domain
            and   rmd_nbr    = pod_nbr
            and   rmd_part   = pod_part
            and   rmd_line   = pod_line
            and   rmd_prefix = "V"
            and   rmd_type   = "I"
         no-lock:
         end. /* FOR FIRST rmd_det */

         if l_flag = yes
         then do:

            if available pod_det
               and  pod_type     = "R"
               and  pod_fsm_type = "RTS-RCT"
            then do:

               if available rmd_det
               then do:

                  if rmd_iss = no
                  then do:

                     l_continue = no.

                     /* PROMPT WARNING MESSAGE ASKING USER             */
                     /* IF HE WISHES TO RECEIVE ITEM WITH LOT/SERIAL   */
                     /* DIFFERENT FROM THE ONE SHIPPED                 */
                     /* WHEN INV ISSUE = NO AND LOT CONTROL LEVEL > 0. */

                     if clc_lotlevel > 0
                     then do:

                        /* SERIAL DIFFERS FROM EXPECTED VALUE */
                        /* FOR ITEM RECEIVED. CONTINUE?       */
                        {pxmsg.i &MSGNUM=6379
                                 &ERRORLEVEL=2
                                 &CONFIRM=l_continue}

                     end. /* IF clc_lotlevel > 0 */

                     else
                        l_continue = yes.

                     if l_continue = no
                     then
                        undo, retry.
                     else do:
                        /* IF USER WISHES TO CONTINUE, EXECUTE LOGIC TO */
                        /* FIND IF THE RECEIVED LOTSERIAL IS PRESENT IN */
                        /* ANY SITE/LOCATION OTHER THAN THE SHIP-FROM   */
                        /* SITE/LOCATION IN COMBINATION WITH ACTIVE     */
                        /* COMPLIANCE LEVEL.                            */

                        if (can-find (first ld_det
                           where ld_domain = global_domain
                           and   ( ( ld_site <> rmd_site
                                   and ld_loc  <> rmd_loc)
                                 or (ld_site <> rmd_site))
                           and ld_lot  = lotserial
                           and ( ( clc_lotlevel = 1
                                 and ld_part = pod_part)
                               or  clc_lotlevel = 2)))
                        then
                           l_scan = yes.
                        else do:
                           l_scan = no.
                           if can-find (first tr_hist
                              where tr_domain  = global_domain
                              and   tr_serial  = lotserial
                              and   tr_nbr     <> pod_nbr
                              and   tr_part    = pod_part
                              and   tr_program = "fsrtvis.p")
                           then
                              l_scan = yes.
                        end. /* ELSE DO */

                     end. /* ELSE DO */

                  end. /* IF rmd_iss = no */

               end. /* IF AVAILABLE rmd_det */

            end. /* IF AVAILABLE pod_det */

            /* ADDED CONDITION TO PROCEED FOR NORMAL PO FUNCTIONALITY */
            if l_scan = yes
            then do:

               /* REPLACED THE FIRST INPUT PARAMETER TO global_part     */
               /* FROM pt_part                                          */
               /*@EVENT POReceiptDetail-create*/
               {pxrun.i &PROC='validateLotSerialUsage' &PROGRAM='porcxr2.p'
                        &PARAM="(input global_part,
                                 input singlelot,
                                 input (lotnext <> lotserial),
                                 input lotserial,
                                 input site,
                                 input integer(cline),
                                 input lotref,
                                 input ponbr,
                                 input location)"
                        &NOAPPERROR=true
                        &CATCHERROR=true
               }
            end. /* IF l_scan = YES */

         end. /* IF l_flag = YES */

         if l_flag
            and l_scan = yes
            and return-value <> {&SUCCESS-RESULT}
         then
            undo idloop, retry idloop.

         /*@EVENT POReceiptDetail-create*/
         {pxrun.i &PROC='processRead' &PROGRAM='porcxr2.p'
                  &PARAM="(input mfguser,
                           input integer(cline),
                           input site,
                           input location,
                           input lotserial,
                           input lotref,
                           buffer sr_wkfl,
                           input {&LOCK_FLAG},
                           input {&WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true
            }
         if return-value <> {&SUCCESS-RESULT}
         then do:
            /*  ADDING NEW RECORD */
            {pxmsg.i
               &MSGNUM=1
               &ERRORLEVEL={&INFORMATION-RESULT}}

            /*@EVENT POReceiptDetail-create*/
            {pxrun.i &PROC='createPOReceiptDetail' &PROGRAM='porcxr2.p'
                     &PARAM="(buffer sr_wkfl,
                              input mfguser,
                              input integer(cline),
                              input site,
                              input location,
                              input lotserial,
                              input lotref,
                              input vendlot,
                              input 0)"
                     &NOAPPERROR=true
                     &CATCHERROR=true
               }
         end. /* IF NOT AVAILABLE sr_wkfl */

         else
            assign
               lotserial_qty = sr_qty
               sr_vend_lot   = vendlot.

         status input stline[2].

         if c-application-mode <> "API" then
         update
            lotserial_qty go-on ("F5" "CTRL-D").

         /* l_update_sr_wkfl IS SET TO YES WHEN THE QUANTITY FIELD */
         /* (lotserial_qty) IS MODIFIED BY THE USER.               */
         l_update_sr_wkfl = yes.
         if c-application-mode = "API" then do:
            assign {mfaiset.i lotserial_qty ttPurchaseOrderTransDet.qty}.
         end.

         if l_multi_return
            and can-find (first pod_det
                             where pod_domain = global_domain
                             and   pod_nbr    = ponbr
                             and   pod_line   = poline
                             and   pod_consignment)
            and lotserial_qty < 0
         then do:
            /* NEGATIVE QUANTITY ENTERED FOR A CONSIGNED LINE ITEM */
            {pxmsg.i &MSGNUM=4938 &ERRORLEVEL=3}
            undo idloop, retry idloop.
         end. /*IF l_multi_return */

         {&ICSRUP2-P-TAG1}
         if    lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:

            del-yn = yes.

            /* PLEASE CONFIRM DELETE */

            {pxmsg.i
               &MSGNUM=11
               &ERRORLEVEL={&INFORMATION-RESULT}
               &CONFIRM=del-yn}

            if del-yn = no
            then
               undo idloop, retry idloop.
            assign
               lotserial_qty       = 0
               total_lotserial_qty = total_lotserial_qty - sr_qty.

            /*@EVENT POReceiptDetail-delete*/
            {pxrun.i &PROC='processDelete' &PROGRAM='porcxr2.p'
                     &PARAM="(buffer sr_wkfl)"
                     &NOAPPERROR=true
                     &CATCHERROR=true
               }

            {&ICSRUP2-P-TAG2}
            find next sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.

            if not available sr_wkfl
            then
               find prev sr_wkfl
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and   sr_lineid = cline
               no-lock no-error.

            if not available sr_wkfl
            then do:
               {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                        &PARAM="(input integer(cline),
                                 buffer sr_wkfl,
                                 input {&NO_LOCK_FLAG},
                                 input {&NO_WAIT_FLAG})"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                  }
            end. /* IF NOT AVAILABLE sr_wkfl */

            if available sr_wkfl
            then
               sr_recno = recid(sr_wkfl).
            else
               sr_recno = ?.

            next loop2.
         end.    /* IF LASTKEY... */

         /* IF USER ENTERED SOME NON-ZERO QUANTITY... */

         if lotserial_qty <> 0
         then do:
            /* validateWrite will exist in the POReceiptDetail DTC, not ROP*/
            serialcount = 1.

            /* SEE IF QTY > 1 AND LIST OF SERIALS SHOULD BE GENERATED */

            /*@EVENT POReceiptLine-write*/
            if available pt_mstr
               and pt_lot_ser = "s"
               and (lotserial_qty > 1 or lotserial_qty < -1)
            then do:
               serials_yn = yes.

               if not batchrun
               then do:

                  /* CREATE LIST OF SERIAL NUMBERS? */

                  {pxmsg.i
                     &MSGNUM=1100
                     &ERRORLEVEL={&INFORMATION-RESULT}
                     &CONFIRM=serials_yn}
               end. /* IF NOT batchrun */

               if not serials_yn
               then
                  undo idloop, retry idloop.

               /*@EVENT createSerialNumbers-button*/
               {pxrun.i &PROC='getSerialFormat' &PROGRAM='porcxr2.p'
                        &PARAM="(input-output lotserial_qty,
                                 input lotserial,
                                 output serialprefix,
                                 output serialsuffix,
                                 output nextserial,
                                 output seriallength,
                                 output serialcount
                               )"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                  }
               if return-value <> {&SUCCESS-RESULT}
               then
                  undo idloop, retry idloop.

            end.     /* IF AVAILABLE pt_mstr AND... */

            /* IF USER ENTERED QTY OF 1, SERIALCOUNT WILL BE THAT 1. */
            /* OTHERWISE, SERIALCOUNT WILL CONTAIN THE NUMBER OF     */
            /* SERIALS THAT NEED TO BE GENERATED.                    */

            do i = 1 to serialcount:

               /* IF THIS IS A SERIALIZED ITEM, ENSURE THERE AREN'T  */
               /* MULTIPLE SR_WKFL'S FOR THE CURRENT SERIAL NUMBER   */

               /*@EVENT createSerialNumbers-button*/
               if available pt_mstr
               then do:
                  {pxrun.i &PROC='validateLotSerialAlreadyUsed'
                           &PROGRAM='porcxr2.p'
                           &PARAM="(input pt_lot_ser,
                                    input lotserial,
                                    input site,
                                    input integer(cline),
                                    input lotref,
                                    input ponbr,
                                    input pt_part,
                                    input location )"
                           &NOAPPERROR=true
                           &CATCHERROR=true
                     }
                  if return-value <> {&SUCCESS-RESULT}
                  then
                     undo idloop, retry idloop.
               end. /* IF AVAILABLE pt_mstr */

               /* IF AN SR_WKFL DOESN'T EXIST FOR THE CURRENT   */
               /* SERIAL NUMBER, CREATE ONE                     */

               /*@EVENT createSerialNumbers-button*/
               {pxrun.i &PROC='processRead' &PROGRAM='porcxr2.p'
                        &PARAM="(input mfguser,
                                 input integer(cline),
                                 input site,
                                 input location,
                                 input lotserial,
                                 input lotref,
                                 buffer sr_wkfl,
                                 input {&LOCK_FLAG},
                                 input {&WAIT_FLAG})"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                  }

               if return-value <> {&SUCCESS-RESULT}
               then do:
                  /*@EVENT createSerialNumbers-button*/
                  {pxrun.i &PROC='createPOReceiptDetail' &PROGRAM='porcxr2.p'
                           &PARAM="(buffer sr_wkfl,
                                   input mfguser,
                                   input integer(cline),
                                   input site,
                                   input location,
                                   input lotserial,
                                   input lotref,
                                   input vendlot,
                                   input 0)"
                           &NOAPPERROR=true
                           &CATCHERROR=true
                     }
               end. /* IF return-value <> {&SUCCESS-RESULT} */

               /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */

               if porec
                  or is-return
               then do:

                  /*@EVENT POReceiptLine-write*/
                  {pxrun.i &PROC='validateSingleItemOrLotSerialLocation'
                           &PROGRAM='porcxr2.p'
                           &PARAM="(input site,
                                    input location,
                                    input lotserial,
                                    input lotref,
                                    input ponbr,
                                    input poline,
                                    input yes)"
                           &NOAPPERROR=true
                           &CATCHERROR=true
                     }
                  if return-value <> {&SUCCESS-RESULT}
                  then
                     undo idloop, retry idloop.
               end.    /* IF porec OR is-return */

               assign
                  total_lotserial_qty = total_lotserial_qty - sr_qty
                  sr_qty              = lotserial_qty
                  /*@EVENT updateReceiptQuantity-button*/
                  total_lotserial_qty = total_lotserial_qty + sr_qty.

               /* EDIT NON MEMO-ITEM PO RECEIPTS AND ALL RTS      */
               /* SHIPMENTS OR RECEIPTS. FOR RTS, PODTYPE = ""    */
               /* IF INVENTORY ISSUE/RECEIPT = YES.               */
               /* PODTYPE = "R" IF INVENTORY ISSUE/RECEIPT = NO.  */

               if podtype = ""
                  or podtype = "S" /* SS - 110112.1 */
                  or (ports = "RTS" and podtype = "R")
               then do:

                  /* I = 1 IF THIS IS AN SR_WKFL ENTERED DIRECTLY  */
                  /* BY THE USER, AS COMPARED TO ONE GENERATED     */
                  /* FROM THE AUTO-GENNED LIST OF SERIAL NUMBERS   */

                  if i = 1
                  then do:

                     /* IF THIS IS AN RTS LINE WITH INVENTORY ISSUE/REC=NO, */
                     /* WE'RE ABOUT TO DO A TRANSFER BETWEEN THE SUPPLIER   */
                     /* SITE/LOC ON THE RTS LINE AND THE INTERNAL SITE/     */
                     /* LOCATION THOSE EDITS ARE DONE BY FSRTVED.P.         */

                     /*@MODULE RTS BEGIN*/
                     if (ports = "RTS" and podtype = "R")
                     then do:
                        if not available pod_det
                        then
                           for first pod_det
                              fields (pod_domain pod_fsm_type    pod_line
                                      pod_nbr    pod_consignment
                                      pod_part   pod_rma_type)
                              where pod_recno = recid(pod_det)
                           no-lock:
                           end. /* FOR FIRST pod_det */

                        /* NEED TO VALIDATE INVENTORY IN CASE LOT/SERIAL */
                        /* ALREADY EXISTS FOR ANY OTHER ITEM.            */
                        if l_scan = yes
                           and  l_flag = yes
                           and available pod_det
                           and pod_fsm_type = "RTS-RCT"
                        then do:
                           {pxrun.i &PROC='validateInventory'
                                    &PROGRAM='porcxr2.p'
                                    &PARAM="(input transtype,
                                             input site,
                                             input location,
                                             input global_part,
                                             input lotserial,
                                             input lotref,
                                             input LotSerial_Qty,
                                             input trans_um,
                                             input ponbr,
                                             input string(poline),
                                             input yes)"
                                    &NOAPPERROR=True
                                    &CATCHERROR=True
                           }
                        end. /* IF l_scan = YES AND... */

                        if return-value <> {&SUCCESS-RESULT}
                        then
                           undo-input = yes.
                        else do:
                           /* ADDED ELEVENTH INPUT PARAMETER l_flag */
                           {gprun.i ""fsrtved.p""
                              "(input pod_nbr,
                                input pod_line,
                                input pod_rma_type,
                                input site,
                                input location,
                                input lotserial,
                                input lotref,
                                input lotserial_qty,
                                input trans_conv,
                                input trans_um,
                                input l_flag,
                                output undo-input,
                                output errmsg,
                                output errsite,
                                output errloc)"}
                        end. /* ELSE DO */

                        if undo-input
                        then do:

                           {pxmsg.i
                              &MSGNUM=errmsg
                              &ERRORLEVEL={&INFORMATION-RESULT}
                              &MSGARG1=errsite
                              &MSGARG2=errloc
                              &MSGARG3=""""}
                        end. /* IF undo-input */

                     end.    /* IF ports = "RTS"... */
                     /*@MODULE RTS END*/

                     else do:

                        /* ELSE, THIS IS EITHER A PURCHASE ORDER OR         */
                        /* AN RTS LINE WHERE INVENTORY ISSUE/RECEIPT = YES, */
                        /* SO RCT-PO EDITS SHOULD BE DONE.                  */

                        /* IF THIS IS AN RTS SHIPMENT (PORTS = RTS AND      */
                        /* POREC = NO), THEN THIS "RCT-PO" TRANSACTION WILL */
                        /* ACTUALLY BE FOR A NEGATIVE QUANTITY - A RETURN   */
                        /* AMOUNT.                                          */

                        /*@EVENT POReceiptLine-write*/
                        vLotSerialQty = (if ports = "RTS" and not porec
                                         then
                                            lotserial_qty * -1
                                         else lotserial_qty).
                        {pxrun.i &PROC='validateInventory' &PROGRAM='porcxr2.p'
                                 &PARAM="(input transtype,
                                          input site,
                                          input location,
                                          input global_part,
                                          input lotserial,
                                          input lotref,
                                          input vLotSerialQty,
                                          input trans_um,
                                          input (if ports = ""RTS""
                                          then """"
                                          else ponbr),
                                          input (if ports = ""RTS""
                                          then """"
                                          else string (poline)),
                                          input yes)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true
                           }
                        if return-value <> {&SUCCESS-RESULT}
                        then
                           undo-input = yes.

                     end.    /* ELSE, NOT A SPECIAL RTS, DO */

                  end.    /* IF i = 1 THEN DO */

                  else do:

                     /* VALIDATION TO BE DONE FOR EVERY LOT/SERIAL  */
                     /* IF INV ISSUE = NO AND LOT CONTROL LEVEL > 0 */

                     l_flag = no.
                     if (can-find (first ld_det
                        where ld_domain = global_domain
                        and   ( (ld_site <> rmd_site
                                and ld_loc  <> rmd_loc)
                              or (ld_site <> rmd_site))
                        and ld_lot  = lotserial
                        and ( ( clc_lotlevel = 1
                              and ld_part = pod_part)
                            or  clc_lotlevel = 2)))
                     then
                        l_scan = yes.
                     else do:
                        l_scan = no.
                           if can-find (first tr_hist
                              where tr_domain  =  global_domain
                              and   tr_serial  = lotserial
                              and   tr_nbr     <> pod_nbr
                              and   tr_part    = pod_part
                              and   tr_program = "fsrtvis.p")
                           then
                              l_scan = yes.
                        end. /* ELSE DO */

                     if l_scan = no
                     then
                        l_flag = yes.

                     /* IF THIS IS AN RTS LINE WITH INVENTORY ISSUE/REC=NO, */
                     /* WE'RE ABOUT TO DO A TRANSFER BETWEEN THE SUPPLIER   */
                     /* SITE/LOC ON THE RTS LINE AND THE INTERNAL SITE/     */
                     /* LOCATION. THOSE EDITS ARE DONE BY FSRTVED.P.        */

                     /*@MODULE RTS BEGIN*/
                     if (ports = "RTS" and podtype = "R")
                     then do:
                        if not available pod_det
                        then
                           for first pod_det
                              fields (pod_domain pod_fsm_type    pod_line
                                      pod_nbr    pod_consignment
                                      pod_part   pod_rma_type)
                              where pod_recno = recid(pod_det)
                           no-lock:
                           end. /* FOR FIRST pod_det */

                        if l_scan = yes
                           and available pod_det
                           and pod_fsm_type = "RTS-RCT"
                        then do:
                           {pxrun.i &PROC='validateInventory'
                                    &PROGRAM='porcxr2.p'
                                    &PARAM="(input transtype,
                                             input site,
                                             input location,
                                             input global_part,
                                             input lotserial,
                                             input lotref,
                                             input LotSerial_Qty,
                                             input trans_um,
                                             input ponbr,
                                             input string(poline),
                                             input yes)"
                                    &NOAPPERROR=True
                                    &CATCHERROR=True
                           }
                        end. /* IF l_scan = YES AND... */

                        if return-value <> {&SUCCESS-RESULT}
                        then
                           undo-input = yes.
                        else do:

                           /* ADDED ELEVENTH INPUT PARAMETER l_flag */
                           {gprun.i ""fsrtved.p""
                              "(input pod_nbr,
                                input pod_line,
                                input pod_rma_type,
                                input site,
                                input location,
                                input lotserial,
                                input lotref,
                                input lotserial_qty,
                                input trans_conv,
                                input trans_um,
                                input l_flag,
                                output undo-input,
                                output errmsg,
                                output errsite,
                                output errloc)"}
                        end. /* ELSE DO */

                        if undo-input
                        then do:

                           {pxmsg.i
                              &MSGNUM=errmsg
                              &ERRORLEVEL={&INFORMATION-RESULT}
                              &MSGARG1=errsite
                              &MSGARG2=errloc
                              &MSGARG3=""""}

                        end. /* IF undo-input */

                     end.    /* IF ports = "RTS"... */

                     /*@MODULE RTS END*/

                     else do:

                        /* ELSE, THIS IS EITHER A PURCHASE ORDER OR AN RTS  */
                        /* LINE WHERE INVENTORY ISSUE/RECEIPT = YES IF THIS */
                        /* IS AN RTS SHIPMENT (PORTS = RTS AND POREC = NO), */
                        /* THEN THIS "RCT-PO" TRANSACTION WILL ACTUALLY BE  */
                        /* FOR A NEGATIVE QUANTITY - A RETURN AMOUNT.       */

                        /*@EVENT POReceiptLine-write*/
                        vLotSerialQty = (if ports = "RTS" and not porec
                                         then
                                            lotserial_qty * -1
                                         else
                                            lotserial_qty).
                        {pxrun.i &PROC='validateInventory' &PROGRAM='porcxr2.p'
                                 &PARAM="(input transtype,
                                          input site,
                                          input location,
                                          input global_part,
                                          input lotserial,
                                          input lotref,
                                          input vLotSerialQty,
                                          input trans_um,
                                          input (if ports = ""RTS""
                                                 then
                                                    """"
                                                 else
                                                    ponbr),
                                          input (if ports = ""RTS""
                                                 then
                                                    """"
                                                 else
                                                    string (poline)),
                                          input no)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true
                           }
                        if return-value <> {&SUCCESS-RESULT}
                        then
                           undo-input = yes.
                     end.    /* ELSE, NOT A SPECIAL RTS, DO */

                  end.    /* ELSE, i <> 1, DO */

                  if undo-input
                  then do:
                     /* l_error IS SET TO YES WHEN THE INVENTORY VALIDATION */
                     /* FAILS AND USER RE-ENTERS idloop                     */
                     l_error = yes.
                     undo idloop, retry idloop.
                  end. /* IF undo-input */

                  /*@EVENT POReceiptLine-write*/
                  {pxrun.i &PROC='validateReceiptToPOSiteTransfer'
                           &PROGRAM='porcxr2.p'
                           &PARAM="
                                   (input base_site,
                                    input site,
                                    input transtype,
                                    input pt_loc,
                                    input location,
                                    input global_part,
                                    input lotserial,
                                    input lotref,
                                    input lotserial_qty,
                                    input trans_um,
                                    input """",
                                    input 0 )"
                           &NOAPPERROR=true
                           &CATCHERROR=true
                     }
                  if return-value <> {&SUCCESS-RESULT}
                  then
                     undo idloop, retry idloop.
               end.    /* IF podtype = " " */

               sr_recno = recid(sr_wkfl).

               if serialcount > 1
               then do:
                  {pxrun.i &PROC='getNextSerialNumber' &PROGRAM='porcxr2.p'
                           &PARAM="(input serialprefix,
                                    input serialsuffix,
                                    input-output nextserial,
                                    input-output seriallength,
                                    output lotserial
                                    )"
                           &NOAPPERROR=true
                           &CATCHERROR=true
                     }
                  if return-value <> {&SUCCESS-RESULT}
                  then
                     undo idloop, retry idloop.
               end. /* IF serialcount > 1 */

            end. /* DO i = 1 TO serialcount */

            if singlelot
            then
               lotnext = lotserial.

            if lotserial_qty < 0
            then do:
               for first pod_det
                  fields (pod_domain pod_consignment pod_fsm_type
                          pod_line   pod_nbr         pod_part     pod_rma_type)
                  where pod_domain = global_domain
                    and pod_nbr    = ponbr
                    and pod_line   = poline
               no-lock:
               end. /* FOR FIRST pod_det */

               /* FOR A NEGATIVE RECEIPT AGAINST A CONSIGNED LINE      */
               /* CHECK WHETHER A POSITIVE RECEIPT EXISTS FOR THE LINE */

               if available pod_det
                  and pod_consignment
               then do:
                  for each cnsix_mstr no-lock
                     where cnsix_domain         = global_domain
                       and cnsix_part           = pod_part
                       and cnsix_site           = pod_site
                       and cnsix_po_nbr         = pod_nbr
                       and cnsix_pod_line       = pod_line
                       and cnsix_lotser         = lotserial
                       and cnsix_ref            = lotref:

                     accumulate cnsix_qty_consigned (total).
                  end.
                  if (accum total cnsix_qty_consigned) < abs(lotserial_qty)
                  then do:
                     /* NO CONSIGNED INVENTORY CAN BE RETURNED FOR PO LINE */
                     {pxmsg.i
                        &MSGNUM=6303
                        &ERRORLEVEL=3
                        &MSGARG1=pod_nbr
                        &MSGARG2=pod_line
                     }
                     lotserial_qty = 0.
                     undo idloop, retry idloop.
                  end. /* IF accum total */
               end. /* IF AVAILABLE pod_det */

            end. /* IF lotserial_qty < 0 */
         end. /* IF lotserial_qty <> 0 */

         else do:
            assign
               lotserial_qty       = 0
               total_lotserial_qty = total_lotserial_qty - sr_qty.
            delete sr_wkfl.

            {&ICSRUP2-P-TAG3}
            find next sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.

            if not available sr_wkfl
            then
               for first sr_wkfl
                  fields( sr_domain sr_lineid sr_loc    sr_lotser sr_qty sr_ref
                         sr_site   sr_userid sr_vend_lot)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and   sr_lineid = cline
               no-lock:
               end. /* FOR FIRST sr_wkfl */

               if available sr_wkfl
               then
                  sr_recno = recid(sr_wkfl).
               else
                  sr_recno = ?.
         end.    /* ELSE, lotserial_qty = 0... */
      end.    /* idloop DO */
      if c-application-mode = "API" then leave.
   end.   /* loop2 REPEAT */

   /* TOTAL LOT/SERIAL QUANTITY ENTERED: */
   {pxmsg.i
      &MSGNUM=300
      &ERRORLEVEL={&INFORMATION-RESULT}
      &MSGARG1=total_lotserial_qty}

   /* REPLACED attr-space WITH no-attr-space IN &frame-attr */

   if not batchrun and c-application-mode <> "API"
   then do:
      {swindowb.i &domain="sr_wkfl.sr_domain = global_domain and "
         &file=sr_wkfl
         &framename="c"
         &frame-attr="overlay column 3 row 8 no-attr-space
           title color normal
              issue_or_receipt             + ' ' +
              getTermLabel(""DETAIL"",6)   + "" - "" +
              getTermLabel(""SITE"",4)     + "": "" +
              site                         + ' ' +
              getTermLabel(""QUANTITY"",8) + "": "" +
              string(lotserial_qty)        + ' ' +
              trans_um"
         &downline=6
         &record-id=sr_recno
         &search=sr_lineid
         &equality=cline
         &other-search="and sr_userid = mfguser"
         &scroll-field=sr_loc
         &create-rec=no
         &assign="sr_userid = mfguser sr_lineid = cline"
         &update-leave=yes
         &s0="/*"
         &display1=sr_loc
         &display2=sr_lotser
         &display3="sr_ref format ""x(8)"" column-label "{&icsrup2_p_1}" "
         &display4=sr_qty
         &display5=sr_vend_lot
         }

   end.   /* IF NOT batchrun THEN */

   if keyfunction(lastkey) = "end-error"
   then
      leave.
   if batchrun
      and keyfunction(lastkey) = "."
   then
      leave.
   if c-application-mode = "API" then leave.

end.  /* loop1: REPEAT: */

if c-application-mode <> "API" then do:
   hide frame c no-pause.
   hide frame a no-pause.
end.
/*MAIN-END*/
