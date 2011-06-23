/* soise01.p - SALES ORDER COMPONENT ISSUE INPUT                              */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 01/14/91   BY: emb *D313 */
/* REVISION: 6.0      LAST MODIFIED: 09/12/91   BY: WUG *D858**/
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887**/
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190**/
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: sas *F595**/
/* REVISION: 7.0      LAST MODIFIED: 06/29/92   BY: afs *F674**/
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247**/
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302**/
/* REVISION: 7.3      LAST MODIFIED: 12/16/92   BY: tjs *G451**/
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: WUG *G936**/
/* REVISION: 7.3      LAST MODIFIED: 05/20/93   BY: kgs *GB24**/
/* REVISION: 7.3      LAST MODIFIED: 07/09/93   BY: tjs *GD31**/
/* REVISION: 7.3      LAST MODIFIED: 07/23/93   BY: tjs *GD63**/
/* REVISION: 7.3      LAST MODIFIED: 07/28/93   BY: tjs *GD80**/
/* REVISION: 7.3      LAST MODIFIED: 06/14/94   BY: WUG *GK26**/
/* REVISION: 7.3      LAST MODIFIED: 06/22/94   BY: WUG *GK60**/
/* REVISION: 7.3      LAST MODIFIED: 09/15/94   by: slm  *GM64*/
/* REVISION: 7.3      LAST MODIFIED: 09/21/94   by: ljm  *GM77*/
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   by: mwd  *J034*/
/* REVISION: 7.3      LAST MODIFIED: 10/21/94   by: rmh  *FQ08*/
/* REVISION: 7.3      LAST MODIFIED: 11/06/94   by: rwl  *GO30*/
/* REVISION: 7.3      LAST MODIFIED: 11/07/94   by: ljm  *GO33*/
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   by: taf  *J038*/
/* REVISION: 8.5      LAST MODIFIED: 12/28/94   by: ktn  *J041*/
/* REVISION: 8.5      LAST MODIFIED: 05/17/95   by: sxb  *J04D*/
/* REVISION: 7.3      LAST MODIFIED: 10/17/95   by: jym  *F0TC*/
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   by: ais  *G1RS*/
/* REVISION: 8.6      LAST MODIFIED: 11/06/97   by: *K15N* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 02/26/98   BY: *J2FY* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/13/99   BY: *J2MD* A. Philips         */
/* REVISION: 9.1      LAST MODIFIED: 08/25/99   BY: *L0GV* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 09/16/99   BY: *J3L9* J. Fernando        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/28/00   BY: *N0CF* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0JM* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.8       BY: Rajaneesh S.      DATE: 02/21/02  ECO: *L13N* */
/* Revision: 1.10.1.9       BY: Jean Miller       DATE: 05/15/02  ECO: *P05V* */
/* Revision: 1.10.1.11      BY: Ashish Maheshwari  DATE: 07/17/02 ECO: *N1GJ* */
/* Revision: 1.10.1.13      BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.10.1.16      BY: Rajaneesh S.       DATE: 08/27/03 ECO: *N2JQ* */
/* Revision: 1.10.1.17      BY: Karan Motwani      DATE: 01/13/04 ECO: *P1HP* */
/* Revision: 1.10.1.18      BY: Karan Motwani      DATE: 01/21/04 ECO: *P1KK* */
/* Revision: 1.10.1.19      BY: Ken Casey          DATE: 02/19/04 ECO: *N2GM* */
/* Revision: 1.10.1.20    BY: Bhagyashri Shinde  DATE: 08/16/04  ECO: *P2FN* */
/* Revision: 1.10.1.21  BY: Binoy John           DATE: 01/27/05  ECO: *P35M* */
/* Revision: 1.10.1.23  BY: Alok Gupta           DATE: 02/17/05  ECO: *P38M* */
/* Revision: 1.10.1.24  BY: Shivganesh Hegde DATE: 06/21/05  ECO: *P3Q3* */
/* Revision: 1.10.1.26  BY: Vinod Kumar DATE: 07/05/05  ECO: *Q0K1* */
/* $Revision: 1.10.1.26.2.1 $ BY: Masroor Alam DATE: 06/28/06  ECO: *P4VR* */
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
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter sodnbr like sod_nbr no-undo.
define input parameter sodln like sod_line no-undo.
define input parameter qtychg like sod_qty_chg no-undo.
define output parameter l_rej like mfc_logical no-undo.

{mfaimfg.i} /* Common API constants and variables */
/* ASN API TEMP-TABLE */
{soshxt01.i}

/* SS - 20081112.1 - B */
DEFINE SHARED VARIABLE vv_location LIKE sr_loc .
/* SS - 20081112.1 - E */

define new shared variable back_site like sr_site.
define new shared variable transtype as character initial "ISS-FAS".
define new shared variable parent_assy like pts_par.
define new shared variable part like wod_part.
define new shared variable wopart_wip_acct like pl_wip_acct.
define new shared variable wopart_wip_sub like pl_wip_sub.
define new shared variable wopart_wip_cc like pl_wip_cc.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable lotserial_qty like wod_qty_chg no-undo.
define new shared variable multi_entry like mfc_logical label "Multi Entry"
   no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline   as character.
define new shared variable row_nbr as integer.
define new shared variable col_nbr as integer.
define new shared variable issue_or_receipt as character.
define new shared variable total_lotserial_qty like wod_qty_chg.
define new shared variable wo_recid as recid.
define new shared variable pk_recno as recid.
define new shared variable comp like ps_comp.
define new shared variable display-messages as logical no-undo.

define new shared variable fill_all  like mfc_logical label "Issue Alloc"
   initial no.
define new shared variable fill_pick like mfc_logical label "Issue Picked"
   initial yes.
define new shared variable undo-input like mfc_logical.

define new shared variable filter_status like is_status.
define new shared variable filter_loc like ld_loc.
define new shared variable filter_expire like ld_expire.
define new shared variable trans_um like pt_um.

define shared variable undo-all  like mfc_logical initial yes no-undo.
define shared variable eff_date  like glt_effdate.
define shared variable sod_recno as recid.
define shared variable change_db like mfc_logical.

define variable back_assy like pt_part label "Backflush Assy" no-undo.
define variable back_qty  like sr_qty no-undo.
define variable back_um   like pt_um no-undo.
define variable back_conv like um_conv label "Conv" no-undo.
define variable back_loc  like sr_loc no-undo.

define variable nbr      like wo_nbr no-undo.
define variable qopen    like wod_qty_all label "Qty Open" no-undo.
define variable yn       like mfc_logical no-undo.
define variable ref      like glt_ref no-undo.
define variable desc1    like pt_desc1 no-undo.
define variable i as integer no-undo.
define variable trqty    like tr_qty_chg no-undo.
define variable trlot    like tr_lot no-undo.
define variable qty_left like tr_qty_chg no-undo.
define variable del-yn   like mfc_logical initial no no-undo.
define variable j as integer no-undo.

define variable tot_lad_all    like lad_qty_all no-undo.
define variable ladqtychg      like lad_qty_all no-undo.
define variable firstpass      like mfc_logical no-undo.
define variable cancel_bo      like mfc_logical label "Cancel B/O" no-undo.
define variable backflush_qty  like wod_qty_chg no-undo.
define variable default_cancel like cancel_bo no-undo.
define variable pick_logic     like mfc_logical initial yes label "Pick Logic"
   no-undo.
define variable pm_code like pt_pm_code no-undo.

define variable lotnext like wo_lot_next no-undo.
define variable lotprcpt like wo_lot_rcpt no-undo.
define variable any_rejected like mfc_logical.
define variable rejected like mfc_logical no-undo.

define variable  l_pkpart  like pk_part     no-undo.
define variable  l_cline   like sr_lineid   no-undo.
define variable  l_flag    like mfc_logical no-undo.
define variable  l_undo    like mfc_logical no-undo.

define buffer ptmstr for pt_mstr.
define buffer ptmaster for pt_mstr.

define shared temp-table compute_ldd no-undo
   field compute_site   like abs_site
   field compute_loc    like abs_loc
   field compute_lot    like abs_lot
   field compute_item   like abs_item
   field compute_ref    like abs_ref
   field compute_qty    like abs_qty
   field compute_lineid like sr_lineid
   index compute_index compute_site compute_item
         compute_loc   compute_lot  compute_ref .

/* SS - 20081127.1 - B */
DEFINE NEW SHARED VARIABLE v_flag AS LOGICAL.
v_flag = NO .
/* SS - 20081127.1 - E */

/* SS - 20081202.1 - B */
DEF VAR v_sr_qty LIKE sr_qty .
DEFINE TEMP-TABLE ttsr
   FIELD ttsr_userid   LIKE sr_userid 
   FIELD ttsr_lineid   LIKE sr_lineid 
   FIELD ttsr_loc      LIKE sr_loc 
   FIELD ttsr_lotser   LIKE sr_lotser
   FIELD ttsr_qty      LIKE v_sr_qty  
   FIELD ttsr_assay    LIKE sr_assay 
   FIELD ttsr_expire   LIKE sr_expire 
   FIELD ttsr_site     LIKE sr_site 
   FIELD ttsr_user1    LIKE sr_user1 
   FIELD ttsr_user2    LIKE sr_user2 
   FIELD ttsr_ref      LIKE sr_ref  
   FIELD ttsr_rev      LIKE sr_rev 
   FIELD ttsr_vend_lot LIKE sr_vend_lot 
   FIELD ttsr_to_loc   LIKE sr_to_loc 
   FIELD ttsr_to_site  LIKE sr_to_site 
   FIELD ttsr_status   LIKE sr_status
   FIELD ttsr__qadc01  LIKE sr__qadc01
   FIELD ttsr_domain   LIKE sr_domain 
   FIELD ttoid_sr_wkfl LIKE oid_sr_wkfl
   .
/* SS - 20081202.1 - E */

form
   back_assy     colon 17                    pt_desc1 no-label at 51
   back_loc      colon 17 back_site colon 34 pt_desc2 no-label at 51
   back_qty      colon 17 back_um   colon 34 back_conv
   skip(1)
   pick_logic    colon 17
   filter_loc    colon 17
   filter_status colon 17
   filter_expire colon 17
with frame a width 80 side-labels.

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame a:handle).

form
   pk_part
   pk_qty       label "Qty Req" format "->>>>,>>9.9<<<<<<"
with frame c 8 down scroll 8 no-attr-space width 80
title color normal (getFrameTitle("ISSUE_DATA_INPUT",24))
row (if {gpiswrap.i} then 3 else 4) overlay.


if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).

form
   part          colon 13 pt_um  site         colon 54
   location      colon 68 label "Loc"
   pt_desc1      colon 13       lotserial    colon 54
   lotserial_qty colon 13       lotref       colon 54
   multi_entry   colon 54
with frame d side-labels width 80 attr-space
/*V8-*/ row 16 overlay /*V8+*/ .

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

if c-application-mode = "API" then do:

   /*
   * GET HANDLE OF API CONTROLLER
   */
   {gprun.i ""gpaigh.p""
            "(output apiMethodHandle,
            output apiProgramName,
            output apiMethodName,
            output apiContextString)"}

   /* GET SO SHIPMENT DETAIL TEMP-TABLE */
   run getSoShipDetRecord in apiMethodHandle
      (buffer ttSoShipDet).

   /* GET SO SHIPMENT LOT SERIAL TEMP-TABLE */
   run getSoShipLotSerial in apiMethodHandle
      (output table ttSoShipLotSerial).

end. /* IF c-application-mode = "API" */

issue_or_receipt = getTermLabel("ISSUE",8).

/* IF THE INVENTORY DB IS THE SAME AS THE CENTRAL DB LOOKUP */
/* SALES ORDER LINE BY recid FOR MORE EFFICIENT PROCESSING. */
if change_db then do:
   for first sod_det
      fields( sod_domain sod_line sod_nbr sod_part sod_qty_ord
             sod_site sod_um sod_um_conv)
       where sod_det.sod_domain = global_domain and  sod_nbr  = sodnbr
        and sod_line = sodln
   no-lock: end.
end.
else do:
   for first sod_det
      fields( sod_domain sod_line sod_nbr sod_part sod_qty_ord
             sod_site sod_um sod_um_conv)
      where recid(sod_det) = sod_recno
   no-lock: end.
end.

for first pt_mstr
   fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
          pt_part pt_pm_code pt_um)
    where pt_mstr.pt_domain = global_domain and  pt_part = sod_part
no-lock: end.

/* SETTING back_qty BASED ON THE CENTRAL DB sod_qty_chg (qtychg) */
assign
   back_assy = sod_part
   back_loc  = ""
   back_site = sod_site
   back_qty  = qtychg
   back_um   = sod_um
   back_conv = sod_um_conv.

if c-application-mode <> "API" then
   display
      back_assy
      pt_desc1
      pt_desc2
   with frame a.

undo-all = yes.

mainloop:
repeat on error undo, retry:

   if c-application-mode = "API" and retry
      then return error return-value.

   if c-application-mode <> "API" then do:
      clear frame c.
      hide frame c.
      hide frame d.
   end. /* IF C-APPLICATION-MODE <> "API" THEN */

   undo-all = yes.

   do on error undo, retry with frame a:

      if c-application-mode = "API" and retry
         then return error return-value.

      /* SS - 20081112.1 - B */
      /*
      if c-application-mode <> "API" then
         update
            back_loc back_site back_qty back_um back_conv
            pick_logic filter_loc filter_status filter_expire
      with frame a.
      else
         assign
            {mfaiset.i back_loc ttSoShipDet.ed_back_loc}
            {mfaiset.i back_site ttSoShipDet.ed_back_site}
            {mfaiset.i back_qty ttSoShipDet.ed_back_qty}
            {mfaiset.i back_um ttSoShipDet.ed_back_um}
            {mfaiset.i back_conv ttSoShipDet.ed_back_conv}
            {mfaiset.i pick_logic ttSoShipDet.ed_pick_logic}
            {mfaiset.i filter_loc ttSoShipDet.ed_filter_loc}
            {mfaiset.i filter_status ttSoShipDet.ed_filter_status}
            {mfaiset.i filter_expire ttSoShipDet.ed_filter_expire}.
      */
      BACK_loc = vv_location .
      filter_loc = vv_location.
      if c-application-mode = "API" then
         assign
            {mfaiset.i back_loc ttSoShipDet.ed_back_loc}
            {mfaiset.i back_site ttSoShipDet.ed_back_site}
            {mfaiset.i back_qty ttSoShipDet.ed_back_qty}
            {mfaiset.i back_um ttSoShipDet.ed_back_um}
            {mfaiset.i back_conv ttSoShipDet.ed_back_conv}
            {mfaiset.i pick_logic ttSoShipDet.ed_pick_logic}
            {mfaiset.i filter_loc ttSoShipDet.ed_filter_loc}
            {mfaiset.i filter_status ttSoShipDet.ed_filter_status}
            {mfaiset.i filter_expire ttSoShipDet.ed_filter_expire}.
      /* SS - 20081112.1 - E */

      /* ADDED FIELD SI_AUTO_LOC TO FIELDLIST   */
      for first si_mstr
         fields( si_domain si_auto_loc si_site)
          where si_mstr.si_domain = global_domain and  si_site = back_site
      no-lock: end.

      if not available si_mstr
      then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* SITE DOES NOT EXIST */
         next-prompt back_site with frame a.
         undo, retry.
      end.

      if not si_auto_loc
         and ((not pick_logic
               and back_loc > "")
              or (pick_logic
                  and filter_loc > ""))
      then do:
         for first loc_mstr
            fields( loc_domain loc_site loc_loc)
            where loc_mstr.loc_domain = global_domain
            and   loc_site            = back_site
            and   loc_loc             = if pick_logic
                                        then
                                           filter_loc
                                        else
                                           back_loc
         no-lock:
         end. /* FOR FIRST loc_mstr */

         if not available loc_mstr
         then do:
            /* LOCATION DOES NOT EXIST */
            {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE LOC_MSTR */
      end. /* IF NOT SI_AUTO_LOC */

      {gprun.i ""gpsiver.p"" "(input back_site,
                               input ?,
                               output return_int)"}
      if return_int = 0
      then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
         next-prompt back_site with frame a.
         undo, retry.
      end.

      undo-all = no.

   end. /* DO ON ERROR... */

   if back_um <> pt_um and
      back_um entered and
      back_conv not entered
   then do:
      {gprun.i ""gpumcnv.p"" "(input back_um,
                               input pt_um,
                               input back_assy,
                               output back_conv)"}
      if back_conv = ? then do:
         /* Unit of Measure conversion does not exist */
         {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
         back_conv = 1.
      end.
      if c-application-mode <> "API" then
         display back_conv with frame a.
   end.

   do transaction:

      if c-application-mode = "API" and retry
         then return error return-value.
      for each sr_wkfl
         where sr_wkfl.sr_domain = global_domain
         and   sr_userid         = mfguser
         and   sr_lineid begins string(sod_line) + "ISS"
      exclusive-lock:

         for each compute_ldd
            where compute_lineid = string(recid(sr_wkfl))
         exclusive-lock:
            delete compute_ldd.
         end. /* FOR EACH compute_ldd */

         delete sr_wkfl.
      end. /* FOR EACH sr_wkfl */

      for each lotw_wkfl  where lotw_wkfl.lotw_domain = global_domain and
      lotw_mfguser = mfguser
      exclusive-lock:
         delete lotw_wkfl.
      end. /* FOR EACH lotw_wkfl */

      for each pk_det  where pk_det.pk_domain = global_domain and  pk_user =
      mfguser
      exclusive-lock:
         delete pk_det.
      end.

      for each sob_det
         fields( sob_domain sob_line sob_loc sob_nbr sob_part sob_qty_req
         sob_site)
          where sob_det.sob_domain = global_domain and  sob_nbr  = sod_nbr
           and sob_line = sod_line
           and sob_qty_req <> 0
      no-lock:
          cline = string(sod_line) + "ISS".

         /* PLACE NON-CONFIGURED S.O. BILL ITEMS IN PACK LIST DETAIL */
         pm_code = "".

         for first ptmaster
            fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                   pt_part pt_pm_code pt_um)
             where ptmaster.pt_domain = global_domain and  ptmaster.pt_part =
             sob_part
         no-lock: end.

         if available ptmaster then
            pm_code = ptmaster.pt_pm_code.

         for first ptp_det
            fields( ptp_domain ptp_part ptp_pm_code ptp_site)
             where ptp_det.ptp_domain = global_domain and  ptp_part = sob_part
              and ptp_site = sob_site
         no-lock: end.

         if available ptp_det then
            pm_code = ptp_pm_code.

         if pm_code <> "C"
         then do:

            find first pk_det  where pk_det.pk_domain = global_domain and
            pk_user = mfguser
                                and pk_part = sob_part
            exclusive-lock no-error.

            if not available pk_det
            then do:

               create pk_det. pk_det.pk_domain = global_domain.
               assign
                  pk_user = mfguser
                  pk_part = sob_part.

               if not pick_logic
               then
                  if back_loc > ""
                  then
                     pk_loc = back_loc.
                  else
                     pk_loc = ptmaster.pt_loc.
               else
                  if filter_loc > ""
                  then
                     pk_loc = filter_loc.

               if recid(pk_det) = -1 then .

            /*  ADDED LOGIC TO USE EXISTING PICKING RECORDS IF AVAILABLE */

            for each lad_det
               where lad_domain  = global_domain
               and   lad_dataset = "sob_det"
               and   lad_nbr     = sod_nbr
               and   lad_line    = string(sod_line)
               and   lad_part    = pk_part
            no-lock:

               find sr_wkfl
                  where sr_domain = global_domain
                  and   sr_userid = mfguser
                  and   sr_lineid = cline + pk_part
                  and   sr_site   = back_site
                  and   sr_loc    = lad_loc
                  and   sr_lot    = lad_lot
                  and   sr_ref    = lad_ref
               exclusive-lock no-error.
                  if not available sr_wkfl then do:
                     create sr_wkfl.
                     assign
                        sr_domain = global_domain
                        sr_userid = mfguser
                        sr_lineid = cline + pk_part
                        sr_site   = back_site
                        sr_loc    = lad_loc
                        sr_lot    = lad_lot
                        sr_qty    = lad_qty_all.
                  end.
            end.
        end.
               if     sod_um_conv <> 0
                  and sod_qty_ord <> 0
               then
                  pk_qty = pk_qty + (sob_qty_req / sod_um_conv / sod_qty_ord)
                                 * back_qty * back_conv.
            end.
      end.

      if pick_logic then do:
         display-messages = true.
         /* SS - 20081113.1 - B */
         {gprun.i ""xxsoise02ad.p""}
         
         /* SS - 20081202.1 - B */
         v_sr_qty = 0.            
         FOR EACH ttsr :
            DELETE ttsr .
         END.
         FOR EACH sr_wkfl WHERE sr_wkfl.sr_domain = GLOBAL_domain
            AND sr_userid = mfguser
            AND sr_lineid BEGINS STRING(sod_line) + "ISS"
            BREAK BY sr_lineid BY sr_site BY sr_loc BY sr_lotser :
            v_sr_qty = v_sr_qty + sr_qty .
            IF LAST-OF(sr_lot) THEN DO:
               CREATE ttsr.
               ASSIGN
                  ttsr_userid   = sr_userid 
                  ttsr_lineid   = sr_lineid 
                  ttsr_loc      = sr_loc 
                  ttsr_lotser   = sr_lotser
                  ttsr_qty      = v_sr_qty  
                  ttsr_assay    = sr_assay 
                  ttsr_expire   = sr_expire 
                  ttsr_site     = sr_site 
                  ttsr_user1    = sr_user1 
                  ttsr_user2    = sr_user2 
                  ttsr_ref      = sr_ref  
                  ttsr_rev      = sr_rev 
                  ttsr_vend_lot = sr_vend_lot 
                  ttsr_to_loc   = sr_to_loc 
                  ttsr_to_site  = sr_to_site 
                  ttsr_status   = sr_status 
                  ttsr__qadc01  = sr__qadc01 
                  ttsr_domain   = sr_domain 
                  ttoid_sr_wkfl = oid_sr_wkfl
                  .
               v_sr_qty = 0.
            END.
         END.

         FOR EACH sr_wkfl WHERE sr_wkfl.sr_domain = GLOBAL_domain
            AND sr_userid = mfguser
            AND sr_lineid BEGINS STRING(sod_line) + "ISS" :
            DELETE sr_wkfl .
         END.
         FOR EACH ttsr :
            CREATE sr_wkfl .
            ASSIGN
                  sr_userid   = ttsr_userid 
                  sr_lineid   = ttsr_lineid 
                  sr_loc      = ttsr_loc 
                  sr_lotser   = ttsr_lotser
                  sr_qty      = ttsr_qty  
                  sr_assay    = ttsr_assay 
                  sr_expire   = ttsr_expire 
                  sr_site     = ttsr_site 
                  sr_user1    = ttsr_user1 
                  sr_user2    = ttsr_user2 
                  sr_ref      = ttsr_ref  
                  sr_rev      = ttsr_rev 
                  sr_vend_lot = ttsr_vend_lot 
                  sr_to_loc   = ttsr_to_loc 
                  sr_to_site  = ttsr_to_site 
                  sr_status   = ttsr_status 
                  sr__qadc01  = ttsr__qadc01 
                  sr_domain   = ttsr_domain 
                  oid_sr_wkfl = ttoid_sr_wkfl
                  .
         END.
         /* SS - 20081202.1 - E */
         
         IF v_flag THEN DO:
            for each sr_wkfl
               where sr_wkfl.sr_domain           = global_domain
                 and substring(sr_lineid ,1 ,1 ) = string(sod_line)
            exclusive-lock:
               delete sr_wkfl .
            end.  /* FOR EACH sr_wkfl */

         END.
         /* SS - 20081113.1 - E */
      end.

      else do:

         any_rejected = no.

         for each pk_det
            fields( pk_domain pk_loc pk_part pk_qty pk_user)
             where pk_det.pk_domain = global_domain and  pk_user = mfguser
         no-lock:

            find first sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
                 and sr_lineid = cline + pk_part
                 and sr_site   = back_site
                 and sr_loc    = pk_loc
            exclusive-lock no-error.

            for first ptmstr
               fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                      pt_part pt_pm_code pt_um)
                where ptmstr.pt_domain = global_domain and  ptmstr.pt_part =
                pk_part
            no-lock: end.

            {gprun.i ""icedit2.p""
               "(input ""ISS-FAS"",
                 input back_site,
                 input pk_loc,
                 input pk_part,
                 input """",
                 input """",
                 input pk_qty + if available sr_wkfl then sr_qty else 0,
                 input if available ptmstr then ptmstr.pt_um else """",
                 input """",
                 input """",
                 output rejected)"}

            if rejected
            then do on endkey undo mainloop, retry mainloop:
               any_rejected = yes.
               {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3 &MSGARG1=pk_part}
               /* SS - 20081127.1 - B */
               v_flag = YES .
               for each sr_wkfl
                  where sr_wkfl.sr_domain           = global_domain
                    and substring(sr_lineid ,1 ,1 ) = string(sod_line)
               exclusive-lock:
                  delete sr_wkfl .
               end.  /* FOR EACH sr_wkfl */
               UNDO,RETRY.
               /* SS - 20081127.1 - E */
               next.
            end.

            if not available sr_wkfl
            then do:

               create sr_wkfl. sr_wkfl.sr_domain = global_domain.
               assign
                  sr_userid = mfguser
                  sr_lineid = cline + pk_part
                  sr_site   = back_site
                  sr_loc    = pk_loc.

               if recid(sr_wkfl) = -1 then .
            end.

            sr_qty = sr_qty + pk_qty.

         end.

         if c-application-mode <> "API" then do:
            if not batchrun
            then
               if any_rejected
               then
                  pause.
         end. /* IF C-APPLICATION-MODE <> "API" THEN */
      end.

      for each pk_det
         fields( pk_domain pk_loc pk_part pk_qty pk_user)
          where pk_det.pk_domain = global_domain and  pk_user = mfguser
      no-lock:

         for first sr_wkfl
            fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                   sr_ref sr_site sr_userid)
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
              and sr_lineid = cline + pk_part
         no-lock: end.

         if not available sr_wkfl
         then do:
            create sr_wkfl. sr_wkfl.sr_domain = global_domain.
            assign
               sr_userid = mfguser
               sr_lineid = cline + pk_part
               sr_site   = back_site
               sr_loc    = pk_loc.

            if recid(sr_wkfl) = -1 then .
         end.

      end.

   end.

   pk_recno = ?.

   seta:
   repeat:

      if c-application-mode = "API" and retry
         then return error return-value.

      do transaction on error undo, retry:

         if c-application-mode = "API" and retry
            then return error return-value.

         setb:
         repeat:

            if c-application-mode = "API" and retry
               then return error return-value.

            if c-application-mode <> "API" then do:
               clear frame d.
               view frame d.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */

            /* DISPLAY DETAIL */
            setc:
            repeat on endkey undo, leave
            with frame c:

               if c-application-mode = "API" and retry
                  then return error return-value.

               /* SS - 20081112.1 - B */
               batchrun = YES .
               /* SS - 20081112.1 - E */

               if c-application-mode <> "API" then do:
                  if not batchrun
                  then do:
                     {icswndow.i &domain="pk_det.pk_domain = global_domain and "
                     &domain2="sr_wkfl.sr_domain = global_domain and "
                        &file1=pk_det
                        &file2=sr_wkfl
                        &framename="c"
                        &record-id=pk_recno
                        &search1=pk_user
                        &equality1=mfguser
                        &search2="sr_userid = mfguser
                         and sr_lineid = string(sod_line) + """ISS""" + pk_part"
                        &scroll-field=pk_part
                        &update-leave=yes
                        &display11=pk_part
                        &display12=pk_qty
                        &display21=sr_site
                        &display22=sr_loc
                        &display23=sr_lotser
                        &display30=sr_ref
                        &display24="sr_qty format """->>>>>>9.9<<<<<<"""
                        column-label ""Qty to Iss"" "}
                  end.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */

               if keyfunction(lastkey) = "end-error" then
                  leave.

               if c-application-mode <> "API" then do:
                  pause 0.
                  clear frame d.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */

               setd:
               repeat on error undo, retry with frame d:

                  if c-application-mode = "API" and retry
                     then return error return-value.

                  part = "".

                  if pk_recno <> ? then do:
                     for first pk_det
                        fields( pk_domain pk_loc pk_part pk_qty pk_user)
                        where recid(pk_det) = pk_recno
                     no-lock:
                        part = pk_part.
                     end. /* FOR FIRST PK_DET */
                  end.

                  /* SS - 20081112.1 - B */
                  /*
                  if c-application-mode <> "API" then
                     display part.
                    */
                  /* SS - 20081112.1 - E */

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                            pt_part pt_pm_code pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      part
                  no-lock: end.

                  if c-application-mode <> "API" then do:
                     /* SS - 20081112.1 - B */
                     /*
                     if available pt_mstr then
                        display pt_desc1.
                     else
                        display "" @ pt_desc1.
                       */
                     /* SS - 20081112.1 - E */

                     if not {gpiswrap.i}
                     then
                        input clear.

                     /* SS - 20081112.1 - B */
                     /*
                     update
                        part
                     with frame d editing:

                        if frame-field = "part"
                        then do:

                            /* FIND NEXT/PREVIOUS RECORD */
                           {mfnp01.i pk_det part pk_part mfguser  "
                           pk_det.pk_domain = global_domain and pk_user "  pk_det}

                           if recno <> ? then do:
                              part = pk_part.
                              display part with frame d.

                              for first pt_mstr
                                 fields( pt_domain pt_desc1 pt_desc2 pt_loc
                                 pt_lot_ser
                                        pt_part pt_pm_code pt_um)
                                  where pt_mstr.pt_domain = global_domain and
                                  pt_part = part
                              no-lock: end.

                              if available pt_mstr then
                                 display pt_um pt_desc1 with frame d.

                           end.

                        end.

                        else do:
                           status input.
                           readkey.
                           apply lastkey.
                        end.

                     end. /* EDITING */
                     
                     status input.
                     */
                     /* SS - 20081112.1 - E */

                  end. /* IF C-APPLICATION-MODE <> "API" THEN */
                  else {mfaiset.i part ttSoShipDet.ed_picklist_part}.

                  assign part.
                  if part = "" then
                     leave setc.

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                            pt_part pt_pm_code pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      part
                  no-lock: end.

                  if not available pt_mstr
                  then do:
                     {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
                     undo, retry.
                  end.

                  assign
                     part = pt_part
                     cline = string(sod_line) + "ISS" + pt_part
                     l_cline   = cline
                     firstpass = yes.

                  frame-d-loop:
                  repeat:

                     if c-application-mode = "API" and retry
                        then return error return-value.

                     multi_entry = no.

                     find first pk_det  where pk_det.pk_domain = global_domain
                     and  pk_user = mfguser
                                         and pk_part = part
                     exclusive-lock no-error.

                     if not available pk_det
                     then do:
                        {pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}
                        /* PART DOES NOT EXIST ON THIS BILL OF MATERIAL */
                        create pk_det. pk_det.pk_domain = global_domain.
                        assign
                           pk_user = mfguser
                           pk_part = part.
                        if recid(pk_det) = -1 then .
                     end.

                     for first pt_mstr
                        fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                               pt_part pt_pm_code pt_um)
                         where pt_mstr.pt_domain = global_domain and  pt_part =
                         part
                     no-lock: end.

                     if not available pt_mstr
                     then do:
                        {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}
                        /* SS - 20081112.1 - B */
                           /*
                        if c-application-mode <> "API" then
                           display
                              part
                              " " @ pt_um
                              " " @ pt_desc1
                           with frame d.
                           */
                        /* SS - 20081112.1 - E */

                     end.

                     else do:
                        if new pk_det then
                           pk_loc = pt_loc.

                        /* SS - 20081112.1 - B */
                        /*
                        if c-application-mode <> "API" then
                           display
                              pt_part @ part
                              pt_um
                              pt_desc1
                           with frame d.
                           */
                        /* SS - 20081112.1 - E */

                     end.

                     assign
                        qopen     = pk_qty
                        lotserial_control = ""
                        site      = ""
                        location  = ""
                        lotserial = ""
                        lotref    = "".

                     if available pt_mstr then
                        lotserial_control = pt_lot_ser.

                     assign
                        cline = string(sod_line) + "ISS" + pk_part
                        global_part = pk_part
                        lotserial_qty = 0.

                     for first sr_wkfl
                        fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                               sr_ref sr_site sr_userid)
                         where sr_wkfl.sr_domain = global_domain and  sr_userid
                         = mfguser
                          and sr_lineid = cline
                     no-lock: end.

                     if available sr_wkfl
                     then do:

                        assign
                           site      = sr_site
                           location  = sr_loc
                           lotserial = sr_lotser
                           lotref    = sr_ref.
                           i = 0.

                        for each sr_wkfl
                           fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                                  sr_ref sr_site sr_userid)
                            where sr_wkfl.sr_domain = global_domain and
                            sr_userid = mfguser
                             and sr_lineid = cline
                        no-lock:
                           i = i + 1.
                           lotserial_qty = lotserial_qty + sr_qty.
                        end.

                        if i > 1 then do:
                           multi_entry = yes.
                           assign
                              site      = ""
                              location  = ""
                              lotserial = ""
                              lotref    = "".
                        end.

                     end.

                     else do:
                        site = back_site.
                        location = if back_loc > "" then back_loc
                                                    else pk_loc.
                     end.

                     locloop:
                     do on error undo, retry on endkey undo frame-d-loop, leave:

                        if c-application-mode = "API" and retry
                           then return error return-value.

                        pk_recno = recid(pk_det).
                        global_part = pk_part.

                        if c-application-mode = "API" then
                           assign
                              {mfaiset.i lotserial_qty ttSoShipDet.ed_sod_qty}
                              {mfaiset.i site ttSoShipDet.ed_sod_site}
                              {mfaiset.i location ttSoShipDet.ed_sod_loc}
                              {mfaiset.i lotserial ttSoShipDet.ed_sod_lotser}
                              {mfaiset.i lotref ttSoShipDet.ed_sod_ref}
                              .
                        else do:  /* C-APPLICATION-MODE <> "API" */
                           /* SS - 20081112.1 - B */
                           /*
                           update
                              lotserial_qty
                              site
                              location
                              lotserial
                              lotref
                              multi_entry
                           with frame d editing:
                              global_site = input site.
                              global_loc  = input location.
                              readkey.
                              apply lastkey.
                           end.
                           */
                           /* SS - 20081112.1 - E */
                        end. /* IF C-APPLICATION-MODE <> "API" THEN */

                        i = 0.

                        for each sr_wkfl
                           fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                                  sr_ref sr_site sr_userid)
                            where sr_wkfl.sr_domain = global_domain and
                            sr_userid = mfguser
                             and sr_lineid = cline
                        no-lock:
                           i = i + 1.
                           if i > 1 then
                              leave.
                        end.

                        if i > 1 then
                           multi_entry = yes.

                        total_lotserial_qty = pk_qty.

                        if multi_entry
                        then do:

                           /* POPULATE TTINVENTORYTRANSFERDET TEMP TABLE. THIS
                              TEMP-TABLE IS REQUIRED BY ICSRUP.P
                           */
                           if c-application-mode = "API" then do:
                              {gpttcp.i
                                 ttSoShipLotSerial
                                 ttInventoryTransDet
                                 " ttSoShipLotSerial.nbr = ttSoShipDet.nbr and
                                   ttSoShipLotSerial.line = ttSoShipDet.line
                                 "
                              }
                              run setInventoryTransDet in apiMethodHandle(
                                 input table ttInventoryTransDet).

                           end. /* IF C-APPLICATION-MODE = "API" THEN */

                           lotnext  = "".
                           lotprcpt = no.

                           if available pt_mstr
                           then
                              trans_um = pt_um.

                           /* Identify context for QXtend */
                           {gpcontxt.i
                              &STACKFRAG = 'icsrup,soise01,sosoisd,sosoism,sosoism,sosois'
                              &FRAME = 'a,c' &CONTEXT = 'SOISE01'}

                           /* ADDED SIXTH INPUT PARAMETER AS NO */
                           {gprun.i ""icsrup.p""
                              "(input sod_site,
                                input """",
                                input """",
                                input-output lotnext,
                                input lotprcpt,
                                input no)"}

                           /* Clear context for QXtend */
                           {gpcontxt.i
                              &STACKFRAG = 'icsrup,soise01,sosoisd,sosoism,sosoism,sosois'
                              &FRAME = 'a,c'}

                        end.

                        else do with frame d:

                           {gprun.i ""icedit.p""
                              "(input ""ISS-FAS"",
                                input site,
                                input location,
                                input pk_part,
                                input lotserial,
                                input lotref,
                                input lotserial_qty,
                                input if available pt_mstr then pt_um else """",
                                input """",
                                input """",
                                output undo-input)" }

                           if undo-input then
                              undo, retry.

                           if sod_site <> site
                           then do:

                              if available pt_mstr then
                                 trans_um = pt_um.

                              {gprun.i ""icedit4.p""
                                 "(input ""ISS-FAS"",
                                   input sod_site,
                                   input site,
                                   input pt_loc,
                                   input location,
                                   input pk_part,
                                   input lotserial,
                                   input lotref,
                                   input lotserial_qty,
                                   input trans_um,
                                   input """",
                                   input """",
                                   output yn)"}

                              if yn then
                                 undo locloop, retry.

                           end.

                           l_pkpart = pk_part.

                           find first sr_wkfl  where sr_wkfl.sr_domain =
                           global_domain and  sr_userid = mfguser
                                                and sr_lineid = cline
                           exclusive-lock no-error.

                           if lotserial_qty = 0 then do:
                              if available sr_wkfl
                              then do:
                                 assign
                                    total_lotserial_qty =
                                       total_lotserial_qty - sr_qty
                                    sr_qty = 0.
                              end.
                           end.

                           else do:

                              if not available sr_wkfl
                              then do:
                                 create sr_wkfl. sr_wkfl.sr_domain =
                                 global_domain.
                                 assign
                                    sr_userid = mfguser
                                    sr_lineid = cline.
                                 if recid(sr_wkfl) = -1 then .
                              end.

                              assign
                                 total_lotserial_qty = total_lotserial_qty
                                             - sr_qty + lotserial_qty
                                 sr_site = site
                                 sr_loc = location
                                 sr_lotser = lotserial
                                 sr_ref = lotref
                                 sr_qty = lotserial_qty.
                           end.

                        end. /* else do with frame d */

                     end. /* locloop */

                     leave.

                  end.

               end.

               if batchrun or c-application-mode = "API" then leave.

            end.

            /* LOGIC INTRODUCED FOR DELETION OF sr_wkfl RECORDS OF LINES */
            /*     WHICH CANNOT BE SHIPPED DUE TO INSUFFICIENT INVENTORY */
            /*               WHEN OVERISSUE IS SET TO NO                 */

            l_flag  = no .

            for each pk_det no-lock
               where pk_det.pk_domain = global_domain
               and pk_user = mfguser :

               for each sr_wkfl no-lock
                  where sr_wkfl.sr_domain = global_domain
                  and   sr_userid =  mfguser
                  and   sr_lineid  begins (string(sod_line) + "ISS" + pk_part) :

                  /* SS - 20081127.1 - B */
                    /*
                  {gprun.i ""rcinvchk.p""
                     "(input  pk_part,
                       input  sr_site,
                       input  sr_loc,
                       input  sr_lotser,
                       input  sr_ref,
                       input  sr_qty ,
                       input  string(recid(sr_wkfl)),
                       input  no,
                       output l_undo)"}
                  */

                  {gprun.i ""xxrcinvchkad.p""
                     "(input  pk_part,
                       input  sr_site,
                       input  sr_loc,
                       input  sr_lotser,
                       input  sr_ref,
                       input  sr_qty ,
                       input  string(recid(sr_wkfl)),
                       input  no,
                       output l_undo)"}
                  /* SS - 20081127.1 - E */

                  if  l_undo = yes
                  then do:
                     assign
                        l_flag  = yes
                        l_rej   = yes.
                     leave .
                  end . /* IF l_undo */
               end.   /* FOR each sr_wkfl */
            end. /* FOR  EACH pk_det */

            if l_flag  = yes
            then do:
               for each sr_wkfl
                  where sr_wkfl.sr_domain           = global_domain
                    and substring(sr_lineid ,1 ,1 ) = string(sod_line)
               exclusive-lock:
                  delete sr_wkfl .
               end.  /* FOR EACH sr_wkfl */
            end. /* IF l_flag =  */

            repeat:

               if c-application-mode = "API" and retry
                  then return error return-value.

               yn = yes.

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'soise01,sosoisd,sosoism,sosoism,sosois'
                  &FRAME = 'yn' &CONTEXT = 'SOISE01_1'}

               /* SS - 20081112.1 - B */
                  /*
               /* Display WO Lines being shipped */
               {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1 &CONFIRM=yn}

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'soise01,sosoisd,sosoism,sosoism,sosois'
                  &FRAME = 'yn'}

               if yn = yes and c-application-mode <> "API"
               then do:

                  hide frame c no-pause.
                  hide frame d no-pause.

                  for each pk_det
                     fields( pk_domain pk_loc pk_part pk_qty pk_user)
                      where pk_det.pk_domain = global_domain and  pk_user =
                      mfguser
                  no-lock with frame e down row 4 overlay:

                     display
                        pk_part
                        pk_qty label "Qty Req" format "->>>,>>9.9<<<<<".

                     for each sr_wkfl
                        fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                               sr_ref sr_site sr_userid)
                         where sr_wkfl.sr_domain = global_domain and  sr_userid
                         = mfguser
                          and sr_lineid = string(sod_line) + "ISS" + pk_part
                          and sr_qty <> 0
                     no-lock with frame e width 80
                     title (getFrameTitle("ISSUE_DATA_REVIEW",25))
                     break by sr_site by sr_loc by sr_lotser by sr_ref:

                        if first-of(sr_lotser)
                        then do:

                           /* SET EXTERNAL LABELS */
                           setFrameLabels(frame e:handle).

                           display
                              sr_site
                              sr_loc
                              sr_lotser column-label "Lot/Serial!Ref".

                           if sr_ref <> " " then
                              down 1.

                        end.

                        display
                           sr_ref format "x(8)" when (sr_ref <> "") @ sr_lotser
                           sr_qty column-label "Issue Qty"
                                  format "->>>,>>9.9<<<<<".

                        sr_qty:label in frame e =
                           getTermLabel("ISSUE_QUANTITY",10).

                        down 1.

                     end. /* for each sr_wkfl */

                     up 1.

                  end. /* for each pk_det */

               end. /* if Display WO Lines */
               */
               /* SS - 20081112.1 - E */

               leave.

            end. /* repeat */

            do on endkey undo seta, leave seta:

               if c-application-mode = "API" and retry
                  then return error return-value.

               yn = yes.

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'soise01,sosoisd,sosoism,sosoism,sosois'
                  &FRAME = 'yn' &CONTEXT = 'SOISE01_2'}

               /* SS - 20081112.1 - B */
                  /*
               /* "Is all info correct?" */
               {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
               /*V8! if yn = ? then
                    undo seta, leave seta. */
               */
               /* SS - 20081112.1 - E */
                    
               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'soise01,sosoisd,sosoism,sosoism,sosois'
                  &FRAME = 'yn'}

            end.

            /* SS - 20081112.1 - B */
               /*
            if yn then do:

               for each pk_det
                  fields( pk_domain pk_loc pk_part pk_qty pk_user)
                   where pk_det.pk_domain = global_domain and  pk_user =
                   mfguser no-lock,
                   each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                         sr_ref sr_site sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = string(sod_line) + "ISS" + pk_part
                    and sr_qty <> 0
               no-lock:

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_loc pt_lot_ser
                            pt_part pt_pm_code pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      pk_part
                  no-lock: end.

                  if available pt_mstr and
                     index("LS",pt_lot_ser) > 0 and
                     sr_lotser = ""
                  then do:
                     pk_recno = recid(pk_det).
                     {pxmsg.i &MSGNUM=1119 &ERRORLEVEL=3}
                     next setb.
                  end.

               end.

               if c-application-mode <> "API" then do:
                  hide frame c.
                  hide frame d.
                  hide frame e.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */

               leave mainloop.

            end. /* if yn */
            */
            if c-application-mode <> "API" then do:
               hide frame c.
               hide frame d.
               hide frame e.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */

            leave mainloop.
            /* SS - 20081112.1 - E */

         end. /* setb */

      end.
      leave.

   end.

   /* Clear context for QXtend */
   {gpcontxt.i
      &STACKFRAG = 'soise01,sosoisd,sosoism,sosoism,sosois'
      &FRAME = 'yn'}

   if c-application-mode <> "API" then do:
      clear frame c.
      hide frame c.
      hide frame d.
   end. /* IF C-APPLICATION-MODE <> "API" THEN */

end.

if c-application-mode <> "API" then do:
   hide frame d.
   hide frame c.
   hide frame a.
end. /* IF C-APPLICATION-MODE <> "API" THEN */

/* EOF */
