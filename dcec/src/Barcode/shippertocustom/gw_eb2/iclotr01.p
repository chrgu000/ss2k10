/* GUI CONVERTED from iclotr01.p (converter v1.78) Fri Oct 29 14:33:29 2004 */
/* iclotr01.p - LOCATION TRANSFER FOR MULTIPLE PARTS                          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26.3.2 $                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 5.0      LAST MODIFIED: 02/26/90   BY: emb                       */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 05/10/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: WUG *D156*                */
/* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*                */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 01/25/92   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: pma *F587*                */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: pma *F610*                */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: pma *F895*                */
/* REVISION: 7.0      LAST MODIFIED: 09/25/92   BY: pma *G097*                */
/* Revision: 7.3      last edit:     09/27/93   By: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: pma *G319*                */
/* REVISION: 7.3      LAST MODIFIED: 06/16/93   BY: pma *GC07*                */
/* REVISION: 7.3      LAST MODIFIED: 09/16/93   BY: pxd *GF33*                */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM10*                */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   by: mwd *J034*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: pxd *GO08*                */
/* REVISION: 7.2      LAST MODIFIED: 01/18/95   BY: ais *F0FH*                */
/* REVISION: 7.2      LAST MODIFIED: 03/20/95   BY: aed *G0HT*                */
/* REVISION: 8.5      LAST MODIFIED: 09/05/95   by: srk *J07G*                */
/* REVISION: 7.4      LAST MODIFIED: 02/05/96   BY: jym *G1M7*                */
/* REVISION: 8.5      LAST MODIFIED: 10/10/95   BY: bholmes *J0FY*            */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *G1ZL* Julie Milligan     */
/* REVISION: 8.6      LAST MODIFIED: 12/19/96   BY: *G2JP* Murli Shastri      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2DD* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 05/19/98   BY: *J2JV* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 05/30/98   BY: *J2L5* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *M0QW* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0VQ* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.21     BY: Seema Tyagi           DATE: 09/17/01  ECO: *M1KQ*   */
/* Revision: 1.23     BY: Ellen Borden          DATE: 06/07/01  ECO: *P00G*   */
/* Revision: 1.24     BY: Jeff Wootton          DATE: 05/14/02  ECO: *P03G*   */
/* Revision: 1.25     BY: Manjusha Inglay       DATE: 08/16/02  ECO: *N1QP*   */
/* Revision: 1.26     BY: Subramanian Iyer      DATE: 01/21/03  ECO: *N24M*   */
/* $Revision: 1.26.3.2 $  BY: A.R. Jayaram          DATE: 11/09/03  ECO: *P12D*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

{cxcustom.i "ICLOTR01.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE iclotr01_p_1 "Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_3 "Lot/Serial Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_4 "Transfer if different status"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_5 "Transfer if zero on hand"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_6 "Transfer From Site"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_7 "Transfer Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_8 "Transfer To Site"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}

{gldynrm.i new}

define new shared variable abc               like pt_abc.
define new shared variable abc1              like pt_abc.
define new shared variable loc               like ld_loc.
define new shared variable loc1              like ld_loc.
define new shared variable part              like pt_part.
define new shared variable part1             like pt_part.
define new shared variable vend              like pt_vend.
define new shared variable vend1             like pt_vend.
define new shared variable line              like pt_prod_line.
define new shared variable line1             like pt_prod_line.
define new shared variable yn                like mfc_logical.
define new shared variable conv              like um_conv.
define new shared variable ref               like glt_ref.
define new shared variable tr_recid          as   recid.
define new shared variable lot               like tr_lot.
define new shared variable trqty             like tr_qty_loc.
define new shared variable qty_loc           like tr_qty_loc
   label {&iclotr01_p_7}.
define new shared variable site_from         like pt_site
   label {&iclotr01_p_6} no-undo.
define new shared variable site_to           like pt_site
   label {&iclotr01_p_8}.
define new shared variable loc_from          like pt_loc      no-undo.
define new shared variable loc_to            like pt_loc.
define new shared variable nbr               like tr_nbr
   label {&iclotr01_p_1}.
define new shared variable so_job            like tr_so_job.
define new shared variable rmks              like tr_rmks.
define new shared variable serial            like tr_serial.
define new shared variable i                 as   integer.
define new shared variable transtype         as   character   format "x(7)"
                                                              initial "ISS-TR".
define new shared variable totlotqty         like pod_qty_chg.
define new shared variable lotqty            like pod_qty_chg
   label {&iclotr01_p_3}                                      initial 1.
define new shared variable del-yn            like mfc_logical initial no.
define new shared variable from_nettable     like mfc_logical.
define new shared variable to_nettable       like mfc_logical.
define new shared variable from_perm         like mfc_logical.
define new shared variable to_perm           like mfc_logical.
define new shared variable null_ch           as   character   initial "".
define new shared variable last_part         like ld_part.
define new shared variable desc2             like pt_desc2.
define new shared variable eff_date          like tr_effdate.
define new shared variable lotserial         like ld_lot.
define new shared variable intermediate_acct like trgl_dr_acct.
define new shared variable intermediate_sub  like trgl_dr_sub.
define new shared variable intermediate_cc   like trgl_dr_cc.
define new shared variable from_expire       like ld_expire.
define new shared variable from_date         like ld_date.
define new shared variable lotref            like ld_ref      format "x(8)".
define new shared variable statyn            like mfc_logical initial "no".
define new shared variable lotserial_qty     like sr_qty      no-undo.

define variable glcost        like sct_cst_tot.
define variable cmmt          as   character          format "x(15)".
define variable assay         like tr_assay.
define variable grade         like tr_grade.
define variable expire        like tr_expire.
define variable zeroyn        like mfc_logical.
define variable undo-input    as   logical            no-undo.
define variable v_abs_recid   as   recid              no-undo.
define variable v_shipnbr     like tr_ship_id         no-undo.
define variable v_shipdate    like tr_ship_date       no-undo.
define variable v_invmov      like tr_ship_inv_mov    no-undo.
define variable v_lines_found as   logical            no-undo.
define variable ve_recid      as   recid              no-undo.
define variable l_undo_trans  like mfc_logical        no-undo.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
define variable consigned_qty_oh as decimal no-undo.
define variable procid           as character no-undo.

define variable l_process_consign_now        like mfc_logical no-undo.
define variable l_non_cons                   like sr_qty      no-undo.
define variable l_using_supplier_consignment like mfc_logical no-undo.


{socnvars.i}

define buffer lddet  for ld_det.
define buffer ptmstr for pt_mstr.
define buffer plmstr for pl_mstr.
define buffer trhist for tr_hist.

{&ICLOTR01-P-TAG1}

/* TEMP TABLES */
define temp-table t_trhist no-undo
   field t_part      like global_part
   field t_lotserial like lotserial
   field t_lotref    like lotref
   field t_trqty     like trqty
   index t_part is primary
   t_part
   t_lotserial
   t_lotref.

/* SHARED TEMP TABLES */
{icshmtdf.i "new" }

{gpglefdf.i}

/* SELECT FORM */

{&ICLOTR01-P-TAG2}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part      colon 20  part1    colon 49 label {t001.i}
   line      colon 20  line1    colon 49 label {t001.i}
   vend      colon 20  vend1    colon 49 label {t001.i}
   abc       colon 20  abc1     colon 49 label {t001.i} skip(1)
   rmks      colon 20  skip(1)
   site_from colon 20  loc_from colon 49
   site_to   colon 20  loc_to   colon 49
   skip(1)
   eff_date  colon 20
   statyn    colon 35                    label {&iclotr01_p_4}
   zeroyn    colon 35                    label {&iclotr01_p_5}
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{&ICLOTR01-P-TAG3}

eff_date = today.

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ""enable_supplier_consignment"",
     input 11,
     input ""ADG"",
     input ""cns_ctrl"",
     output l_using_supplier_consignment)"}

mainloop:
repeat:

   if part1 = hi_char
   then
      part1 = "".

   if line1 = hi_char
   then
      line1 = "".

   if vend1 = hi_char
   then
      vend1 = "".

   if abc1 = hi_char
   then
      abc1 = "".

   {&ICLOTR01-P-TAG4}

   update
      part
      part1
      line
      line1
      vend
      vend1
      abc abc1
      rmks
      site_from
      loc_from
      site_to
      loc_to
      eff_date
      statyn
      zeroyn
   with frame a
   editing:

      if frame-field = "site_from"
      or frame-field = "loc_from"
      then do:

         global_site = input site_from.
         global_loc  = input loc_from.
         readkey.
         apply lastkey.

      end. /*IF FRAME-FIELD = "site-from" */
      else
      if frame-field = "site_to"
      or frame-field = "loc_to"
      then do:

         global_site = input site_to.
         global_loc  = input loc_to.
         readkey.
         apply lastkey.

      end. /* IF FRAME-FIELD = "site-to" ... */
      else do:
         readkey.
         apply lastkey.
      end. /* ELSE */

   end. /* EDITING */
    IF LOC_FROM = '8888' THEN DO:
               MESSAGE '该特殊库位不能直接移出!' VIEW-AS ALERT-BOX BUTTON OK. 
                   NEXT-PROMPT LOC_FROM WITH FRAME A. 
                  UNDO,RETRY.
                   END. 
   IF LOC_TO = '8888' THEN DO:
               MESSAGE '该特殊库位不能直接移入!' VIEW-AS ALERT-BOX BUTTON OK. 
                   NEXT-PROMPT LOC_TO WITH FRAME A. 
                  UNDO,RETRY.
                   END.

   if not can-find (si_mstr
   where si_site = site_from)
   then do:
      /*SITE DOES NOT EXIST*/
      {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
      next-prompt site_from with frame a.
      undo, retry.
   end. /* IF NOT CAN-FIND(si_mstr */

   if not batchrun
   then do:

      {gprun.i ""gpsiver.p""
         "(input  site_from,
           input  ?,
           output return_int)"}

      if return_int = 0
      then do:
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         next-prompt site_from with frame a.
         undo mainloop, retry.
      end. /* IF return_int = 0 */

   end. /* IF NOT batchrun */

   if not can-find (si_mstr
   where si_site = site_to)
   then do:
      /*SITE DOES NOT EXIST*/
      {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
      next-prompt site_to with frame a.
      undo, retry.
   end. /* IF NOT CAN-FIND(si_mstr */

   {gprun.i ""gpsiver.p""
      "(input  site_to,
        input  ?,
        output return_int)"}

   if return_int = 0
   then do:
      /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
      next-prompt site_to with frame a.
      undo mainloop, retry.
   end. /* IF return_int = 0 */

   for first si_mstr
      fields (si_auto_loc si_entity si_site si_status)
      where si_site = site_from
      no-lock:
   end. /* FOR FIRST si_mstr */

   if available si_mstr
   and not si_auto_loc
   then do:

      if not can-find (loc_mstr
      where loc_site = site_from
      and   loc_loc  = loc_from)
      then do:
         /*LOCATION MASTER DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=229 &ERRORLEVEL=3}
         next-prompt loc_from with frame a.
         undo, retry.
      end. /* IF NOT CAN-FIND (loc_mstr */

   end. /* IF AVAILABLE si_mstr */

   /* OPEN PERIOD VALIDATION FOR THE ENTITY OF FROM SITE */
   {gpglef02.i
      &module = ""IC""
      &entity = si_entity
      &date   = eff_date
      &prompt = "site_from"
      &frame  = "a"
      &loop   = "mainloop"}

   for first si_mstr
      fields (si_auto_loc si_entity si_site si_status)
      where si_site = site_to
      no-lock:
   end. /* FOR FIRST si_mstr */

   if available si_mstr
   and not si_auto_loc
   then do:

      if not can-find (loc_mstr
      where loc_site = site_to
      and   loc_loc  = loc_to)
      then do:
         /*LOCATION MASTER DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=229 &ERRORLEVEL=3}
         next-prompt loc_to with frame a.
         undo, retry.
      end. /* IF NOT CAN-FIND (loc_mstr */

   end. /* IF AVAILABLE si_mstr */

   {&ICLOTR01-P-TAG5}

   if  (site_from = site_to)
   and (loc_from  = loc_to)
   then do:
      /* DATA RESULTS IN NULL TRANSFER  */
      {pxmsg.i &MSGNUM=1919 &ERRORLEVEL=3}
      next-prompt loc_to with frame a.
      undo mainloop, retry mainloop.
   end. /* IF (site_from = site_to) */

   /* OPEN PERIOD VALIDATION FOR THE ENTITY OF TO SITE */
   {gpglef02.i &module = ""IC""
      &entity = si_entity
      &date   = eff_date
      &prompt = "site_to"
      &frame  = "a"
      &loop   = "mainloop"}

   run batch_params.

   if part1 = ""
   then
      part1 = hi_char.

   if line1 = ""
   then
      line1 = hi_char.

   if vend1 = ""
   then
      vend1 = hi_char.

   if abc1 = ""
   then
      abc1 = hi_char.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   {mfphead.i}

   /* CLEAR TRANSACTION HISTORY TEMP TABLE */
   for each t_trhist
      exclusive-lock:

      delete t_trhist.

   end. /* FOR EACH t_trhist */

   /* CLEAR SHIPPER LINE ITEM TEMP TABLE */
   {gprun.i  ""icshmt1c.p"" }

   v_lines_found = false.

   /* FIND AND DISPLAY */
   loop1:
   for each lddet
      no-lock
      where ld_site  = site_from
      and   ld_loc   = loc_from
      and   ld_part >= part
      and   ld_part <= part1,
          each ptmstr no-lock
         where pt_part       = ld_part
         and  (pt_vend      >= vend
         and   pt_vend      <= vend1)
         and  (pt_prod_line >= line
         and   pt_prod_line <= line1),
             each in_mstr
            no-lock
            where in_part = ld_part
            and in_site   = ld_site
            and (in_abc  >= abc
            and  in_abc  <= abc1),
                each plmstr no-lock
               where pl_prod_line = pt_prod_line
               break by ld_part
                     by ld_lot with width 132 frame f-a:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-a:handle).

      l_undo_trans = no.

      /* CHECKS FOR RESTRICTED TRANSACTIONS AGAINST THE STATUS CODE */
      run check_for_restricted_status (input  ld_status,
                                       input  batchrun,
                                       output l_undo_trans).

      if l_undo_trans
      then do:
         /* RESTRICTED STATUS FOR TRANSACTION CODE */
         {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3 &MSGARG1= "ld_status"}
         undo loop1, retry.
      end. /* IF l_undo_trans */

      if l_using_supplier_consignment
      then do:
         /* FIND THE TO LOCATION RECORD TO DETERMINE IF */
         /* OWNERSHIP WILL BE TRANSFERRED.              */
         for first loc_mstr
            fields(loc_loc loc_site loc_status loc_xfer_ownership)
            where loc_site = site_to
            and   loc_loc  = loc_to
         no-lock:
         end. /* FOR FIRST loc_mstr */

         /* READ CONTROL FILE */
         if can-find (first cns_ctrl where cns_active)
         then
            for first cns_ctrl
               fields(cns_active cns_picking_logic)
            no-lock:
               l_process_consign_now = (if cns_picking_logic = "1"
                                        then yes
                                        else no).
            end. /* FOR FIRST cns_ctrl */

         for first cnsix_mstr
            fields(cnsix_part cnsix_qty_consigned cnsix_site)
            where cnsix_part   = ld_part
            and   cnsix_site   = site_from
         no-lock:
         end. /* FOR FIRST cnsix_mstr */
         if available cnsix_mstr
         then do:
            l_non_cons = ld_qty_oh - cnsix_qty_consign.
            if l_process_consign_now = yes
               and cnsix_qty_consign  > 0
               and available loc_mstr
               and loc_xfer_ownership = no
               and (site_from        <> site_to)
            then do:
              /* CONSIGNMENT INVENTORY EXISTS IN THE TRANSFER QTY FOR ITEM # */
               {pxmsg.i &MSGNUM=6365
                        &ERRORLEVEL=3
                        &MSGARG1=cnsix_part}
              /* MUST TRANSFER OWNERSHIP FOR SITE, LOT/SERIAL, OR REF CHANGES */
               {pxmsg.i &MSGNUM=6366
                        &ERRORLEVEL=3}
               undo, retry.
            end. /* IF l_process_consign_now = YES AND ... */

            else
               if l_process_consign_now  = no
                  and cnsix_qty_consign  > 0
                  and available loc_mstr
                  and loc_xfer_ownership = no
                  and ld_qty_oh          > l_non_cons
                  and (site_from        <> site_to)
               then do:
               /* CONSIGNMENT INVENTORY EXISTS IN THE TRANSFER QTY FOR ITEM # */
                  {pxmsg.i &MSGNUM=6365
                           &ERRORLEVEL=3
                           &MSGARG1=cnsix_part}
               /* MUST TRANSFER OWNERSHIP FOR SITE, LOT/SERIAL,OR REF CHANGES */
                  {pxmsg.i &MSGNUM=6366
                           &ERRORLEVEL=3}
                  undo, retry.
               end. /* IF l_process_consign_now = NO AND ... */
         end. /* IF AVAILABLE cnsix_mstr */
      end. /* IF l_using_supplier_consignment */

      if using_cust_consignment then do:

         /*IF CONSIGNED, FIND OUT HOW MUCH NON-CONSIGNED INVENTORY   */
         /*IS AT THE LOCATION. IF THERE IS NOT ENOUGH TO COVER THE   */
         /*QTY BEING ISSUED, THEN ERROR.                             */
         consigned_qty_oh = ld_cust_consign_qty.
      end. /*if using_cust_consignment*/

      if using_cust_consignment and  consigned_qty_oh > 0 and
         ld_qty_oh - consigned_qty_oh = 0 then do:
         next loop1.
      end.

      if first-of(ld_part)
      then
         display
            pt_part
            pt_desc1
            pt_prod_line
            pt_vend
            pt_abc pt_um WITH STREAM-IO /*GUI*/ .

      display
         ld_lot
         ld_ref
         ld_qty_oh WITH STREAM-IO /*GUI*/ .

      if not zeroyn

         and (ld_qty_oh - consigned_qty_oh) = 0
      then do:
         display getTermLabel("NOT_TRANSFERRED",15) @ cmmt WITH STREAM-IO /*GUI*/ .
         next loop1.
      end. /* IF NOT zeroyn */
      else
         display "" @ cmmt no-label WITH STREAM-IO /*GUI*/ .

      assign
         trqty         = ld_qty_oh
         lotserial_qty = ld_qty_oh
         global_part   = pt_part
         lotserial     = ld_lot
         lotref        = ld_ref
         global_addr   = "".

      if using_cust_consignment then
      assign
         lotserial_qty = lotserial_qty - consigned_qty_oh
         trqty = trqty - consigned_qty_oh.

      run ip_process_details (output undo-input).

      if undo-input
      then do:
         display getTermLabel("NOT_TRANSFERRED",15) @ cmmt WITH STREAM-IO /*GUI*/ .
         next loop1.
      end.  /* IF undo-input */

      /* ADD TO TRANSACTION HISTORY TEMP TABLE */
      create t_trhist.

      assign
         t_part      = pt_part
         t_lotserial = lotserial
         t_lotref    = lotref
         t_trqty     = trqty.

      if recid (t_trhist) = -1
      then .

      {&ICLOTR01-P-TAG6}

      /* ADD TO SHIPPER LINE ITEM TEMP TABLE */
      {gprun.i
         ""icshmt1a.p""
         "(pt_part,
           lotserial,
           lotref,
           site_from,
           loc_from,
           trqty,
           pt_um,
           1,
           pt_net_wt * trqty,
           pt_net_wt_um,
           pt_size * trqty,
           pt_size_um)" }

      {&ICLOTR01-P-TAG7}

      v_lines_found = true.

      if not batchrun
      then do:

         ve_recid = recid(ld_det).

         /* DETERMINE IF SUPPLIER PERFORMANCE IS INSTALLED */
         if can-find (mfc_ctrl
         where mfc_field = "enable_supplier_perf"
         and   mfc_logical)
         and
         can-find (_File where _File-name = "vef_ctrl")
         then do:
/*N24M*/    /* REPLACED INPUT PARAMETER ve_recid WITH pt_part */
            {gprunmo.i
               &program=""iclotrve.p""
               &module="ASP"
               &param="""(input pt_part)"""}

         end.  /* IF ENABLE SUPPLIER PERFORMANCE */

         if keyfunction(lastkey) = "end-error"
         then
            next loop1.

      end. /* IF NOT batchrun */

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


   end. /* FOR EACH lddet */

   /* REPORT TRAILER */
   {mfrtrail.i}

   assign
      v_shipnbr  = ""
      v_shipdate = ?
      v_invmov   = "".

   /* CREATE OR ADD TO SHIPPER */
   if v_lines_found
   then do:

      {&ICLOTR01-P-TAG8}

      {gprun.i
         ""icshmt.p""
         "(site_from,
           site_to,
           ""ISS-TR"",
           eff_date,
           output v_abs_recid)" }

      {&ICLOTR01-P-TAG9}

      /* GET ASSOCIATED SHIPPER */
      for first abs_mstr
         fields (abs_id abs_inv_mov abs_shp_date)
         where recid(abs_mstr) = v_abs_recid
         no-lock:
      end. /*FOR FIRST abs_mstr */

      if available abs_mstr
      then
         assign
            v_shipnbr  = substring(abs_id,2)
            v_shipdate = abs_shp_date
            v_invmov   = abs_inv_mov.

   end.  /* IF v_lines_found */

   view frame a.

   /* BUILD TRANSACTION HISTORY FROM TEMP TABLE ENTRIES */
   for each t_trhist
   exclusive-lock:

      assign
         global_part = t_part
         global_addr = "".

      /* CREATE TRANSACTION HISTORY ENTRY                           */
      {gprun.i
         ""icxfer.p""
         "("""",
           t_lotserial,
           t_lotref,
           t_lotref,
           t_trqty,
           """",
           """",
           rmks,
           """",
           eff_date,
           site_from,
           loc_from,
           site_to,
           loc_to,
           no,
           v_shipnbr,
           v_shipdate,
           v_invmov,
           0,
           output glcost,
           output iss_trnbr,
           output rct_trnbr,
           input-output assay,
           input-output grade,
           input-output expire)" }

      delete t_trhist.

   end.  /* FOR EACH t_trhist */

end. /* REPEAT */

/* INTERNAL PROCEDURES */

PROCEDURE ip_process_details:

   define output parameter o_undo as logical initial true no-undo.

   build_blk:
   do transaction on error undo build_blk, leave build_blk:

      for first ld_det
         fields (ld_assay ld_date ld_expire ld_grade ld_loc ld_lot
                 ld_part ld_qty_oh ld_ref ld_site ld_status)
         where ld_det.ld_site = site_to
         and   ld_det.ld_loc  = loc_to
         and   ld_det.ld_part = lddet.ld_part
         and   ld_det.ld_lot  = lddet.ld_lot
         and   ld_det.ld_ref  = lddet.ld_ref
         exclusive-lock:
     end. /*FOR FIRST ld_det */

      if available ld_det
         and ((ld_det.ld_qty_oh <> 0 and not using_cust_consignment)
         or (using_cust_consignment and
         ld_det.ld_qty_oh - consigned_qty_oh <> 0))
      then do:

         if ((ld_det.ld_status <> lddet.ld_status
         and not statyn)
         or (ld_det.ld_grade  <> lddet.ld_grade)
         or (ld_det.ld_assay  <> lddet.ld_assay)
         or (ld_det.ld_expire <> lddet.ld_expire) )
         then
            leave build_blk.

         {gprun.i
            ""icedit2.p""
            "(""RCT-TR"",
              site_to,
              loc_to,
              lddet.ld_part,
              lddet.ld_lot,
              lddet.ld_ref,
              if using_cust_consignment
              then
                 lddet.ld_qty_oh - consigned_qty_oh
              else
                 lddet.ld_qty_oh,
              ptmstr.pt_um,
              """",
              """",
              output o_undo)" }

         if o_undo
         then
            leave build_blk.

      end. /* IF AVAILABLE ld_det */
      else do:

         /* IF ld_det.ld_qty_oh = 0 */
         if (available ld_det)
         then do:

            if (ld_det.ld_status <> lddet.ld_status)
            and (not statyn)
            then
               leave build_blk.

         end. /* IF AVAILABLE ld_det */
         else do:

            for first loc_mstr
               fields (loc_loc loc_site loc_status)
               where loc_site = site_to
               and   loc_loc  = loc_to
               no-lock:
            end. /* FOR FIRST loc_mstr */

            if available loc_mstr
            and lddet.ld_status <> loc_status
            and not statyn
            then
               leave build_blk.

         end. /* ELSE IF NOT AVAILABLE ld_det */

         {gprun.i
            ""icedit2.p""
            "(""RCT-TR"",
              site_to,
              loc_to,
              lddet.ld_part,
              lddet.ld_lot,
              lddet.ld_ref,
              lddet.ld_qty_oh,
              ptmstr.pt_um,
              """",
              """",
              output o_undo)" }

         if o_undo
         then
            leave build_blk.

         if not available ld_det
         then do:

            create ld_det.

            assign
               ld_det.ld_site = site_to
               ld_det.ld_loc  = loc_to
               ld_det.ld_part = lddet.ld_part
               ld_det.ld_lot  = lddet.ld_lot
               ld_det.ld_ref  = lddet.ld_ref
               recno          = recid(ld_det).

            if available loc_mstr
            then
               ld_det.ld_status = loc_status.
            else do:

               for first si_mstr
                  fields (si_auto_loc si_entity si_site si_status)
                  where si_site = site_to
                  no-lock:
               end. /* FOR FIRST si_mstr */

               if available si_mstr
               then
                  ld_det.ld_status = si_status.

            end. /* ELSE */

         end.  /* IF NOT AVAILABLE */

         assign
            ld_det.ld_date   = lddet.ld_date
            ld_det.ld_assay  = lddet.ld_assay
            ld_det.ld_grade  = lddet.ld_grade
            ld_det.ld_expire = lddet.ld_expire.

      end.  /* ELSE */

      for first is_mstr
         fields (is_overissue is_status)
         where is_status = ld_det.ld_status
         no-lock:
      end. /* FOR FIRST is_mstr */

      if available is_mstr
      and not is_overissue
      and ld_det.ld_qty_oh + trqty < 0
      then
         leave build_blk.

      o_undo = false.

   end.  /* build_blk */

END PROCEDURE.  /* PROCEDURE ip_process_details */

PROCEDURE batch_params:

   bcdparm = "".
   {mfquoter.i part   }
   {mfquoter.i part1  }
   {mfquoter.i line   }
   {mfquoter.i line1  }
   {mfquoter.i vend   }
   {mfquoter.i vend1  }
   {mfquoter.i abc    }
   {mfquoter.i abc1   }
   {mfquoter.i rmks   }
   {mfquoter.i site_from}
   {mfquoter.i loc_from}
   {mfquoter.i site_to}
   {mfquoter.i loc_to }
   {mfquoter.i eff_date}
   {mfquoter.i statyn }
   {mfquoter.i zeroyn }
   {&ICLOTR01-P-TAG10}

END PROCEDURE. /* PROCEDURE batch_params */


PROCEDURE check_for_restricted_status:

/* CHECKS IF THE STATUS CODE HAS A RESTRICTED TRANSACTION */
/* IF IT DOES THIS PROCEDURE RETURNS THE OUTPUT PARAMETER */
/* l_undo_trans = YES ELSE IT RETURNS l_undo_trans = NO   */

define input  parameter l_ld_status  like ld_status   no-undo.
define input  parameter l_batchrun   like batchrun    no-undo.
define output parameter l_undo_trans like mfc_logical no-undo.

l_undo_trans = no.

for first isd_det
   fields (isd_bdl_allowed isd_status isd_tr_type)
   where  (isd_tr_type = "ISS-TR"
   or      isd_tr_type = "RCT-TR")
   and     isd_status  = l_ld_status
   no-lock:
end. /* FOR FIRST isd_det */

if available isd_det
and  ((batchrun
and  not isd_bdl_allowed)
or   not batchrun)
then
   l_undo_trans = yes.

END PROCEDURE. /* PROCEDURE check_for_restricted_status */

/* END OF INTERNAL PROCEDURES */
