/* icsrup.p - --- PROGRAM TO UPDATE sr_wkfl MULTI LINE ENTRY                  */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.52.1.8 $                                                      */
/* REVISION: 6.0      LAST MODIFIED: 04/16/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 05/21/90   BY: emb *D025*                */
/* REVISION: 6.0      LAST MODIFIED: 11/01/90   BY: emb *D167*                */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D447*                */
/* REVISION: 6.0      LAST MODIFIED: 01/22/91   BY: emb *D313*                */
/* REVISION: 6.0      LAST MODIFIED: 09/12/91   BY: WUG *D858*                */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*                */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91   BY: WUG *D920*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 03/12/92   BY: pma *F087*                */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: WUG *F410*                */
/* REVISION: 7.0      LAST MODIFIED: 05/22/92   BY: pma *F522*                */
/* REVISION: 7.0      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 03/02/93   BY: emb *G767*                */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: tjs *G451*                */
/* REVISION: 7.3      LAST MODIFIED: 05/15/93   BY: kgs *GB22*                */
/* REVISION: 7.3      LAST MODIFIED: 06/23/94   BY: afs *FP10*                */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM10*                */
/* REVISION: 7.3      LAST MODIFIED: 09/19/94   BY: ljm *GM66*                */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*                */
/* REVISION: 7.3      LAST MODIFIED: 11/06/94   BY: rwl *GO25*                */
/* REVISION: 7.3      LAST MODIFIED: 11/17/94   BY: ais *FT78*                */
/* REVISION: 7.4      LAST MODIFIED: 12/02/94   BY: mmp *H616*                */
/* REVISION: 8.5      LAST MODIFIED: 12/08/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 12/21/94   BY: ktn *J041*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*                */
/* REVISION: 7.4      LAST MODIFIED: 01/18/95   BY: srk *GO58*                */
/* REVISION: 7.4      LAST MODIFIED: 01/24/95   BY: srk *H09T*                */
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: pxd *F0LZ*                */
/* REVISION: 7.4      LAST MODIFIED: 03/17/95   BY: jpm *G0GY*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.2      LAST MODIFIED: 03/29/95   BY: qzl *F0PK*                */
/* REVISION: 8.5      LAST MODIFIED: 06/07/95   BY: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 08/04/95   BY: tjs *J062*                */
/* REVISION: 7.2      LAST MODIFIED: 08/21/95   BY: qzl *F0TC*                */
/* REVISION: 8.5      LAST MODIFIED: 12/20/95   BY: tjs *J09L*                */
/* REVISION: 8.5      LAST MODIFIED: 01/16/96   BY: kxn *J0BZ*                */
/* REVISION: 8.5      LAST MODIFIED: 04/02/96   BY: kxn *J0GS*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/09/96   BY: *J0LJ* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: *J0RQ* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: *J11S* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 06/30/97   BY: *J1VG* Manmohan K Pardesi */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.5      LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 09/07/98   BY: *J2YW* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 10/07/99   BY: *K23G* Mugdha Tambe       */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *J3M5* G. Latha           */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/14/00   BY: *L0VG* Mark Christian     */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N09X* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 07/12/00   BY: *N0G4* Katie Hilbert      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/03/00   BY: *J3QC* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 10/05/00   BY: *N0WT* Mudit Mehta        */
/* Revision: 1.24        BY: Nikita Joshi         DATE: 05/23/01  ECO: *M18B* */
/* Revision: 1.25        BY: Russ Witt            DATE: 06/05/01  ECO: *P00J* */
/* Revision: 1.26        BY: Hareesh V            DATE: 10/19/01  ECO: *P027* */
/* Revision: 1.27        BY: Kirti Desai          DATE: 11/01/01  ECO: *N151* */
/* Revision: 1.28        BY: Kirti Desai          DATE: 02/08/02  ECO: *M1TV* */
/* Revision: 1.31        BY: Rajaneesh Sarangi    DATE: 02/21/02  ECO: *L13N* */
/* Revision: 1.32        BY: Rajesh Kini          DATE: 04/26/02  ECO: *M1XW* */
/* Revision: 1.33        BY: Manisha Sawant       DATE: 05/03/02  ECO: *N1GG* */
/* Revision: 1.34        BY: Jean Miller          DATE: 05/23/02  ECO: *P074* */
/* Revision: 1.36        BY: Ashish Maheshwari    DATE: 07/17/02  ECO: *N1GJ* */
/* Revision: 1.37        BY: Nishit Vadhavkar     DATE: 09/11/02  ECO: *N1TK* */
/* Revision: 1.39        BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00G* */
/* Revision: 1.41        BY: Rajinder Kamra       DATE: 06/23/03  ECO: *Q003* */
/* Revision: 1.42        BY: Gnanasekar           DATE: 08/05/03  ECO: *P0XW* */
/* Revision: 1.43        BY: Dorota Hohol         DATE: 08/25/03  ECO: *P112* */
/* Revision: 1.44        BY: Jean Miller          DATE: 02/17/04  ECO: *Q04Y* */
/* Revision: 1.46        BY: Vandna Rohira        DATE: 04/14/04  ECO: *P1WX* */
/* Revision: 1.47        BY: Robin McCarthy       DATE: 04/19/04  ECO: *P15V* */
/* Revision: 1.48        BY: Anitha Gopal         DATE: 07/28/04  ECO: *P2CC* */
/* Revision: 1.49        BY: Shivganesh Hegde     DATE: 08/12/04  ECO: *P2F8* */
/* Revision: 1.51        BY: Bharath Kumar        DATE: 10/11/04  ECO: *P2P1* */
/* Revision: 1.52        BY: Dan Herman           DATE: 10/28/04  ECO: *M1LL* */
/* Revision: 1.52.1.1    BY: Shivganesh Hegde     DATE: 03/09/05  ECO: *P3C3* */
/* Revision: 1.52.1.3    BY: James Wilson         DATE: 05/17/05  ECO: *Q0JC* */
/* Revision: 1.52.1.4    BY: SurenderSingh Nihalani DATE: 07/07/05 ECO: *P3R9* */
/* Revision: 1.52.1.5    BY: Vinodkumar M.        DATE: 10/10/05 ECO: *P44D* */
/* Revision: 1.52.1.6    BY: Vinodkumar M.        DATE: 11/07/05 ECO: *Q0MG* */
/* Revision: 1.52.1.7   BY: Jean Miller       DATE: 01/10/06  ECO: *Q0PD* */
/* $Revision: 1.52.1.8 $        BY: Shridhar M           DATE: 05/19/06  ECO: *P4J2* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ANY MODIFICATION DONE IN THIS PROGRAM MAY BE REQUIRED IN icsrup1.p         */
/* BY DEFINING AN EXTRA INPUT-OUT PARAMETER IN THE PROGRAM CALLING icsrup.p,  */
/* icsrup1.p CAN BE USED INSTEAD OF icsrup.p (e.g reisslst.p/ reisrc01.p)     */

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "ICSRUP.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter base_site like si_site.
define input parameter trnbr like lot_nbr.
define input parameter trline like lot_line.
define input-output parameter lotnext like wo_lot_next.
define input parameter singlelot like wo_lot_rcpt no-undo.
define input parameter dirship   like mfc_logical no-undo.

define new shared variable h_ui_proc as handle no-undo.
define new shared variable msgref as character format "x(20)".

define shared variable multi_entry as logical no-undo.
define shared variable cline as character.
define shared variable lotserial_control like pt_lot_ser.
define shared variable issue_or_receipt as character.
define shared variable total_lotserial_qty like sr_qty.
define shared variable site like sr_site no-undo.
define shared variable location like sr_loc no-undo.
define shared variable lotserial like sr_lotser no-undo.
define shared variable lotserial_qty like sr_qty no-undo.
define shared variable trans_um like pt_um.
define shared variable trans_conv like sod_um_conv.
define shared variable transtype as character.
define shared variable lotref like sr_ref no-undo.

define variable sr_recno as recid.
define variable del-yn like mfc_logical.
define variable num_recs as integer.
define variable rec_indx as integer.
define variable undo-input like mfc_logical.
define variable i as integer.
define variable j as integer.
define variable iiii as integer.
define variable serialcount as integer.
define variable serials_yn like mfc_logical.
define variable nextserial as decimal no-undo.
define variable serialprefix as character.
define variable serialsuffix as character.
define variable intstart as integer.
define variable intend as integer.
define variable seriallength as integer.
define variable intcount as integer.
define variable iss_yn like mfc_logical.
define variable ship_site like site.
define variable ship_db   like global_db.
define variable pt_memo   like mfc_logical.
define variable newlot like wo_lot_next.
define variable trans-ok like mfc_logical.
define variable alm_recno as recid.
define variable getlot like mfc_logical.
define variable frametitle as character no-undo.
define variable ret-flag as integer no-undo.
define variable l_addon like mfc_logical initial yes no-undo.
define variable l_count as integer no-undo.
define variable l_db        like dc_name     no-undo.
define variable l_con_db    like dc_name     no-undo.
define variable l_err_flag  as   integer     no-undo.
define variable l_db_undo   like mfc_logical no-undo.
define variable l_glob_db   like dc_name     no-undo.
define variable l_ato_itm   like mfc_logical no-undo.
define variable l_read_tr   like mfc_logical no-undo.

{&ICSRUP-P-TAG3}

/* CONSIGNMENT VARIABLES */
define variable using_supplier_consignment  as logical   no-undo.
define variable using_cust_consignment      as logical   no-undo.
define variable key1                        as character no-undo.
define variable l_so_nbr                    as character no-undo.
define variable line_nbr                    as character no-undo.
define variable ok_to_ship                  as logical   no-undo.

/* CONSIGNMENT CONSTANTS */
define variable ADG                         as character no-undo
   initial "ADG".
define variable ENABLE_SUPPLIER_CONSIGNMENT as character no-undo
   initial "enable_supplier_consignment".
define variable SUPPLIER_CONSIGN_CTRL_TABLE as character no-undo
   initial "cns_ctrl".
define variable ENABLE_CUSTOMER_CONSIGNMENT as character no-undo
   initial "enable_customer_consignment".
define variable CUST_CONSIGN_CTRL_TABLE     as character no-undo
   initial "cnc_ctrl".

/* SS - 20080905.1 - B */
DEF VAR v_qty LIKE ld_qty_oh.
DEF VAR v_flag AS LOGICAL .
DEF VAR v__dec01 LIKE ld_qty_oh.
DEF VAR v_ord LIKE ld_qty_oh.
DEF VAR v_flag_pm1 AS LOGICAL.
/* SS - 20080905.1 - E */

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

{mfaimfg.i}   /* COMMON API CONSTANTS AND VARIABLES */
{icicit01.i}  /* INVENTORY CONTROL API TEMP-TABLE */

   /* GET HANDLE OF API CONTROLLER*/
if c-application-mode = "API" then do:
   {gprun.i ""gpaigh.p""
            "(output apiMethodHandle,
              output apiProgramName,
              output apiMethodName,
              output apiContextString)"}
end.

form
   sr_site
   sr_loc
   sr_lotser
   sr_ref
   sr_qty
with down frame c overlay title color normal frametitle.

assign
   h_ui_proc = this-procedure
   l_glob_db = global_db.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

for first clc_ctrl
   fields (clc_domain clc_lotlevel)
   where   clc_domain = global_domain
no-lock: end.

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields (clc_domain clc_lotlevel)
      where   clc_domain = global_domain
   no-lock: end.

end. /* IF not available clc_ctrl */

/* CHECK TO SEE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

/* CHECK TO SEE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

assign
   l_so_nbr = trnbr
   line_nbr = trline.

/* THE FOLLOWING SO SHIPMENT AND CONSIGNMENT PROGRAMS PASS IN A NON-BLANK  */
/* VALUE TO icsrup.p FOR THE ORDER (trnbr) AND ORDER LINE (trline). AFTER  */
/* THESE PARAMETER HAVE BEEN SAVED TO LOCAL VARIABLES, trnbr AND trline    */
/* NEEDS TO BE RESET TO THE BLANK VALUE THAT WOULD HAVE ORIGINALLY BEEN    */
/* PASSED IN PRIOR TO CHANGES FOR CUSTOMER CONSIGNMENT.                    */

/* THE FOLLOWING PROGRAMS NOW PASS IN A NON-BLANK VALUE TO icsrup.p FOR THE   */
/* ORDER (trnbr) AND ORDER LINE (trline). PREVIOUSLY, ONLY sosois.p (OF THE   */
/* SHIPMENT PROGRAMS) PASSED IN A NON-BLANK VALUE TO icsrup.p FOR THE ORDER   */
/* LINE. A BLANK BECOMES 0 WHEN THE INTEGER FUNCTION IS APPLIED TO IT.        */
/* FOR CONSIGNMENT, A NON-BLANK ORDER AND VALID LINE ARE NEEDED IN icsrup.    */
/* THEREFORE, THE CONSIGNMNET USAGE AND SHIPMENT PROGRAMS HAVE BEEN CHANGED   */
/* TO NOW PASS IN A VALID ORDER AND LINE NUMBER. AFTER THESE PARAMETERS HAVE  */
/* BEEN SAVED TO LOCAL VARIABLES, THEY ARE RESET TO THE BLANK VALUES THAT     */
/* WOULD HAVE ORIGINALLY BEEN PASSED IN BY THE OTHER SHIPMENT PROGRAMS.       */
if execname = "rcshmt.p"              /* Shipper Maint */
   or execname = "rcctmt.p"           /* Container Maint */
   or execname = "rcshwb.p"           /* Shipper Workbench */
   or execname = "socnuac.p"          /* Inventory Usage Create */
   or execname = "socnuac3.p"         /* Authorization Usage Create */
   or execname = "socnuac5.p"         /* Sequenced Usage Create */
   or execname = "socnuac7.p"         /* Shipper Usage Create */
   or execname = "sosois.p"           /* Sales Order Shipments */
   or execname = "fseops.p"           /* Material Order Shipments */
then
   assign
      trnbr  = ""
      trline = "".

for first pt_mstr
   fields (pt_domain pt_auto_lot pt_loc pt_lot_ser pt_part pt_pm_code)
   where   pt_domain = global_domain
   and     pt_part = global_part
no-lock: end.

pause 0.

/* IDENTIFY FRAMES FOR QXTEND */
{gpcontxt.i
   &STACKFRAG = 'icsrup,icisrc01,icintr01,icunrc01'
   &FRAME = 'a,c' &CONTEXT = 'ISS'}

form
   space(1)
   site
   location
   lotserial
   lotref
   /* SS - 20081208.1 - B */
   /*
   lotserial_qty   
   */
   lotserial_qty  FORMAT "->,>>>,>>9"
   /* SS - 20081208.1 - E */
   space(1)
   /*V8! space(6) */
with frame a column 5 attr-space overlay no-underline
/*V8-*/ width 72 /*V8+*/.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*V8! frame a:row = frame c:row + frame c:height-chars. */

/* ISSUE-OR-RECEIPT VALUES ARE:                          */
/*  SHIP   : SEO SHIPMENTS (OF TOTAL_LOTSERIAL_QTY)      */
/*   RETURN: SEO RETURNS (OF TOTAL_LOTSERIAL_QTY)        */
/*  RECEIPT: INVENTORY UNPLANNED RECEIPT (LOTSERIAL_QTY) */
/*  ISSUE  : WORK ORDER ISSUE (OF LOTSERIAL_QTY)         */

if c-application-mode <> "API" then do:
   if issue_or_receipt = " " + getTermLabel("RETURN",8) then
      frametitle = getFrameTitle("RETURN_DETAIL",20) + "- " +
                   getTermLabel("QUANTITY",16) + ": " +
                   string(total_lotserial_qty) + " " + trans_um + " ".
   else
   if issue_or_receipt = getTermLabel("RECEIPT",8) then
      frametitle = getFrameTitle("RECEIPT_DETAIL",20) + "- " +
                   getTermLabel("QUANTITY",16) + ": " +
                   string(lotserial_qty) + " " + trans_um + " ".
   else
   if issue_or_receipt = getTermLabel("ISSUE",8) then
      frametitle = getFrameTitle("ISSUE_DETAIL",18) + "- " +
                   getTermLabel("QUANTITY",16) + ": " +
                   string(lotserial_qty) + " " + trans_um + " ".
   else
   if issue_or_receipt = getTermLabel("SHIP",8) then
      frametitle = getFrameTitle("ISSUE_DETAIL",18) + "- " +
                   getTermLabel("QUANTITY",16) + ": " +
                   string(total_lotserial_qty) + " " + trans_um + " ".
end. /* IF c-application-mode <> "API" */

if c-application-mode <> "API" then
   view frame c.

total_lotserial_qty = 0.

for each sr_wkfl
   fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev sr_site
           sr_userid)
   where   sr_domain = global_domain
   and     sr_userid = mfguser
   and     sr_lineid = cline
no-lock:

   /* 'SEO-DEL' IS PUT INTO THE 'TOTAL' RECORD FOR SEO'S (SERVICE     */
   /* ENGINEER ORDERS), HOWEVER, SEO SHIPPING/RETURN LOGIC KNOWS TO   */
   /* SKIP THEM...                                                    */
   if sr_rev = "SEO-DEL" then
      next.

   total_lotserial_qty = total_lotserial_qty + sr_qty.

end. /* FOR EACH sr_wkfl */

if global_db <> "" then do:

   ship_site = site.

   for first si_mstr
      fields (si_domain si_db si_entity si_site)
      where   si_domain = global_domain
      and     si_site = site
   no-lock:
      ship_db = si_db.
   end. /* FOR FIRST si_mstr */

end. /* IF global_db <> "" */

/* GET API TEMP-TABLE WITH QUANTITY DETAIL  */
if c-application-mode = "API" then do:
   run getInventoryTransDet in apiMethodHandle
      (output table ttInventoryTransDet).
end. /* IF c-application-mode = "API" */

loop1:
repeat:

   loop2:
   repeat with frame a:

   /* DO NOT ACCESS UI WHEN PROCESSING API REQUEST */
      if c-application-mode <> "API" then do:
         view.

         clear frame c all no-pause.
      end. /* IF c-application-mode <> "API" */

      find sr_wkfl where recid(sr_wkfl) = sr_recno no-lock no-error.

      if available sr_wkfl then do:

         do i = 1 to truncate(frame-down(c) / 2,0)
         while available sr_wkfl:

            find next sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.
         end.

         if not available sr_wkfl then do:
            find last sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.
         end.

         do i = 1 to frame-down(c) - 1
         while available sr_wkfl:
            find prev sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.
         end.

         if not available sr_wkfl then do:
            find first sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.
         end.

      end.
      else do:
         find first sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
            and   sr_lineid = cline
         no-lock no-error.
      end.

      if available sr_wkfl then do with frame c:

         do i = 1 to frame-down(c) while available sr_wkfl:

            if sr_rev <> "SEO-DEL" and
               c-application-mode <> "API" then
               display
                  space(1)
                  sr_site
                  sr_loc
                  sr_lotser
                  sr_ref
                  sr_qty
                  space(1)
               with frame c.

            if sr_rev <> "SEO-DEL" then do:
               find next sr_wkfl
                  where sr_domain = global_domain
                  and   sr_userid = mfguser
                  and   sr_lineid = cline
               no-lock no-error.

               if c-application-mode <> "API" and
                  frame-line(c) < frame-down(c) then
                  down 1 with frame c.

            end. /* IF sr_rev <> "SEO-DEL" */
            else
               /* DON'T LEAVE AN EXTRA BLANK LINE IN FRAME C */
               find next sr_wkfl
                  where sr_domain = global_domain
                  and   sr_userid = mfguser
                  and   sr_lineid = cline
               no-lock no-error.

         end. /* DO i = 1 TO FRAME-DOWN(c) */

      end. /* IF AVAILABLE sr_wkfl */

      find sr_wkfl where recid(sr_wkfl) = sr_recno no-lock no-error.

      if not available sr_wkfl then do:
         find first sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
            and   sr_lineid = cline
         no-lock no-error.
      end.

      if available sr_wkfl then do:
         if sr_rev <> "SEO-DEL" then
         assign
            site = sr_site
            location = sr_loc
            lotserial = sr_lotser
            lotref = sr_ref
            lotserial_qty = sr_qty.
      end.

      /* Total lot/serial quantity entered: # */
      {pxmsg.i &MSGNUM=300 &ERRORLEVEL=1
               &MSGARG1= total_lotserial_qty}

      if dirship = yes then
         for first soc_ctrl
            fields (soc_domain soc_dum_loc)
            where   soc_domain = global_domain
         no-lock:
            location = soc_dum_loc.
         end.

      idloop:
      do on error undo, retry:
         if retry and c-application-mode = "API"
           then return error return-value.

         getlot = yes.

         if available pt_mstr
         then do:

            if ((pt_lot_ser = "L")
               and singlelot
               and (lotserial = lotnext
               and lotnext <> "")
               and (clc_lotlevel <> 0))
            then
               getlot = no.

            /* KEEP FIELD LOTSERIAL UPDATEABLE IN CASE OF RCT-UNP AND CN-USE */
            /* TRANSACTION                                                   */
            if (pt_lot_ser = "L"
               and pt_auto_lot = yes)
               and (lotserial <> "")
               and (not transtype begins "ISS")
               and (transtype <> "RCT-UNP")
               and (transtype <> "CN-USE")
            then
               getlot = no.

         end. /* IF AVAILABLE PT_MSTR */

         if c-application-mode <> "API" then do:
            display
               site
               location
               lotserial
               lotserial_qty.

            {gpbrparm.i
                &browse=gplu909.p
                &parm=c-brparm1
                &val="l_so_nbr"}

            {gpbrparm.i
                &browse=gplu909.p
                &parm=c-brparm2
                &val="string(line_nbr)"}

            /* SS - 20080905.1 - B */
            DISP lotref WITH FRAME a .
            /* SS - 20080905.1 - E */

            /* DO NOT ALLOW UPDATE TO LOCATION FOR DIR-SHIP EMT ORDER */
            update
               /* SS - 20080905.1 - B */
               /*
               site
               */
               /* SS - 20080905.1 - E */
               location  when (not dirship)
               lotserial when (getlot = yes)
               /* SS - 20080905.1 - B */
               /*
               lotref
               */
               /* SS - 20080905.1 - E */
            editing:

               assign
                  global_site = input site
                  global_loc  = input location
                  global_lot  = input lotserial.

               {mfnp08.i sr_wkfl sr_id
                  "sr_domain = global_domain and sr_userid  = mfguser and
                  sr_lineid = cline"
                  sr_site "input site" sr_loc "input location"
                  sr_lotser "input lotserial" sr_ref "input lotref"}

               if recno <> ? then do:

                  assign
                     site = sr_site
                     location = sr_loc
                     lotserial = sr_lotser
                     lotserial_qty = sr_qty
                     lotref = sr_ref.

                  display
                     site
                     location
                     lotserial
                     lotref
                     lotserial_qty.

               end. /* IF recno <> ? */

            end. /* EDITING: */
         end. /* IF c-application-mode <> "API" */

        /* GET NEXT RECORD IN API TEMP-TABLE AND SET INPUT VALUES */
         if c-application-mode = "API" then do:
            find next ttInventoryTransDet no-lock no-error.
            if available ttInventoryTransDet
            then
               assign
                  {mfaiset.i site ttInventoryTransDet.site}
                  {mfaiset.i location ttInventoryTransDet.loc}
                  {mfaiset.i lotserial ttInventoryTransDet.lotSer}
                  {mfaiset.i lotserial_qty ttInventoryTransDet.qty}
                  {mfaiset.i lotref ttInventoryTransDet.ref}
                  .
              else leave loop2.
         end.

         for first si_mstr
            fields (si_domain si_db si_entity si_site)
            where   si_domain = global_domain and si_site = site
         no-lock: end.

         if not available si_mstr
         then do:
            /* SITE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
            undo idloop, retry.
         end.

         {gprun.i ""gpsiver.p""
                  "(input site,
                    input ?,
                    output return_int)"}

         if return_int = 0
         then do:
            /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            undo idloop, retry.
         end.

         /* If this program is being called from Sales Order Shipment */
         /* in a multidomain environment, we have to do some extra  */
         /* validation to guard against shipments that span domains */
         if global_db <> ""
            and (global_type = "shipundo"
            or global_type = "shipok")
            and site <> ship_site
         then do:

            for first si_mstr
               fields (si_domain si_db si_entity si_site)
               where   si_domain = global_domain
               and     si_site = site
            no-lock: end.

            if si_db <> ship_db then do:
               /* All ship-from sites must be in same domain */
               {pxmsg.i &MSGNUM=6253 &ERRORLEVEL=3}
               undo, retry.
            end.

         end. /* IF global_db <> "" */

         if available pt_mstr
         then do:

            if singlelot
               and (lotnext <> lotserial)
               and (pt_lot_ser <> "")
               and (clc_lotlevel <> 0)
            then do:

               if (can-find (first lot_mstr
                  where lot_domain = global_domain
                  and   lot_serial = lotserial
                  and   lot_part = pt_part))
               then do:
                  /* LOT IS IN USE */
                  {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                  undo idloop, retry idloop.
               end. /* IF (CAN-FIND (FIRST lot_mstr */

               for first lotw_wkfl
                  fields (lotw_domain lotw_lotser lotw_mfguser lotw_part)
                  where   lotw_domain = global_domain
                  and     lotw_lotser = lotserial
                  and     lotw_mfguser <> mfguser
                  and     lotw_part    <> pt_part
               no-lock:
                  /* LOT IS IN USE */
                  {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                  undo idloop, retry idloop.
               end. /* FOR FIRST lotw_wkfl */

            end. /* IF singlelot ... */

            if (pt_lot_ser = "S") then do:

               for first sr_wkfl
                  fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                          sr_rev sr_site sr_userid)
                  where   sr_domain = global_domain
                  and     sr_userid = mfguser
                  and     sr_lotser = lotserial
               no-lock:

                  if (sr_site <> site
                     or  (sr_lineid <> cline
                     and clc_lotlevel = 2)
                     or sr_ref <> lotref
                     or sr_loc <> location)
                  then do:

                     if clc_lotlevel = 0
                     then do:
                        if     sr_userid = mfguser
                           and sr_lotser = lotserial
                           and sr_lineid = cline
                        then do:
                           /* SERIAL EXISTS AT SITE, LOCATION */
                           {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3
                                    &MSGARG1= "sr_site + "", "" + sr_loc"}
                           undo idloop, retry idloop.
                        end. /* IF sr_userid = MFGUSER */
                     end. /* IF clc_lotlevel = 0 */
                     else do:
                        /* LOT IS IN USE */
                        {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                        undo idloop, retry idloop.
                     end. /* ELSE DO */
                  end. /* IF sr_site <> site */
               end.   /* FOR FIRST sr_wkfl */

            end. /* IF (PT_LOT_SER = "S") */

            if execname = "socnuac.p"          /* Usage Create */
               or execname = "socnuac3.p"      /* Authorization Usage Create */
               or execname = "socnuac5.p"      /* Sequenced Usage Create */
               or execname = "socnuac7.p"      /* Shipper Usage Create */
            then do:
               if not can-find(first cncix_mstr
                  where cncix_domain      = global_domain
                  and   cncix_site        = base_site
                  and   cncix_current_loc = location
                  and   cncix_part        = pt_part
                  and   cncix_lotser      = lotserial
                  and   cncix_ref         = lotref
                  and   cncix_so_nbr      = l_so_nbr
                  and   cncix_sod_line    = integer(line_nbr)
                  and   cncix_qty_stock   > 0)
               and
                  (not can-find(first cncu_mstr
                     where cncu_domain    = global_domain
                     and   cncu_part      = pt_part
                     and   cncu_site      = base_site
                     and   cncu_so_nbr    = l_so_nbr
                     and   cncu_sod_line  = integer(line_nbr)
                     and   cncu_lotser    = lotserial
                     and   cncu_ref       = lotref)
               )
               then do:
                  /* NO SHIPMENT RECORD EXISTS FOR LOT/SERIAL */
                  {pxmsg.i &MSGNUM=6562 &ERRORLEVEL=3 &MSGARG1=lotserial}
                  next-prompt lotserial with frame a.
                  undo idloop, retry idloop.
               end. /* IF NOT CAN-FIND(FIRST cncix_mstr */
            end. /* IF execname = "socnuac.p"   */

         end. /* IF AVAILABLE PT_MSTR */

         find sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
            and   sr_lineid = cline
            and   sr_site = site
            and   sr_loc = location
            and   sr_lotser = lotserial
            and   sr_ref = lotref
         exclusive-lock no-error.

         if not available sr_wkfl
         then do:

            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

            create sr_wkfl.
            assign
               sr_domain = global_domain
               sr_userid = mfguser
               sr_lineid = cline
               sr_site = site
               sr_loc = location
               sr_lotser = lotserial
               sr_ref = lotref.

            if recid(sr_wkfl) = -1 then .

         end. /* IF NOT AVAILABLE sr_wkfl */
         else
            lotserial_qty =
               if c-application-mode <> "API" then sr_qty
                  else lotserial_qty + sr_qty.

         status input stline[2].

         /* SS - 20080905.1 - B */
         setvflagpm: 
         DO ON ERROR UNDO,RETRY:
            if c-application-mode <> "API" then
               set
                  lotserial_qty
               go-on  ("F5" "CTRL-D").

            /* 此程序只允许输入正数的发货 */
            IF lotserial_qty < 0 THEN DO:
               /* Quantity must be equal to or greater than zero (2969) */
               {pxmsg.i &MSGNUM=2969 &ERRORLEVEL=3 }
               NEXT-PROMPT lotserial_qty WITH FRAME a .
               UNDO ,RETRY.
            END.

            v_qty = 0.
            v_flag = NO.
            FOR EACH ld_det WHERE ld_domain = GLOBAL_domain
               AND ld_site = site
               AND ld_loc = location
               AND ld_lot = lotserial
               AND ld_ref = lotref
               AND ld_part = GLOBAL_part NO-LOCK :
               v_qty = ld_qty_oh .
               v_flag = YES.
            END.
            v__dec01 = 0.    
            v_ord = 0.
            FOR EACH sod_det WHERE sod_domain = GLOBAL_domain
               AND sod_nbr = trnbr
               AND STRING(sod_line) = trline NO-LOCK :
               v__dec01 = sod__dec02 .
               v_ord = sod_qty_ord .
            END.
            IF lotserial_qty < 0 THEN DO:
               IF v_flag = YES AND v_qty = 0
                  /* SS - 20081112.1 - B */
                  AND pt_pm_code <> "C"
                  /* SS - 20081112.1 - E */
                  THEN DO:
                  {pxmsg.i &MSGNUM=208 &ERRORLEVEL=2 &MSGARG1="0"}
               END.
               IF ABS(lotserial_qty) > v__dec01 THEN DO: 
                  {pxmsg.i &MSGNUM=812 &ERRORLEVEL=2}
               END.
            END.
            ELSE DO:
               IF lotserial_qty > v_qty
                  /* SS - 20081112.1 - B */
                  AND pt_pm_code <> "C"
                  /* SS - 20081112.1 - E */
                  THEN DO:
                  {pxmsg.i &MSGNUM=208 &ERRORLEVEL=3 &MSGARG1=STRING(v_qty) }
                  UNDO,RETRY.
               END.

               IF lotserial_qty > v__dec01 THEN DO:
                  {pxmsg.i &MSGNUM=90001 &ERRORLEVEL=2}
               END.
            END.

            /* SS - 20081202.1 - B */
            v_flag_pm1 = NO .
            IF pt_pm_code = "C" THEN DO:
               FOR EACH ps_mstr NO-LOCK WHERE ps_domain = GLOBAL_domain
                  AND ps_par = pt_part BREAK BY ps_comp :
                  FOR FIRST ld_det NO-LOCK 
                     WHERE ld_domain = GLOBAL_domain
                     AND ld_site = site
                     AND ld_loc = location
                     AND ld_part = ps_comp
                     AND ld_lot = lotserial
                     AND ld_ref = lotref :
                  END.
                  IF (NOT AVAIL ld_det) OR (AVAIL ld_det AND ld_qty_oh < lotserial_qty ) THEN DO:
                     {pxmsg.i &MSGNUM=208 &ERRORLEVEL=3
                              &MSGARG1="if available ld_det then
                                        ld_qty_oh else 0 " 
                              &MSGARG2=ps_comp }
                     v_flag_pm1 = YES.         
                  END.
                  IF LAST(ps_comp) AND v_flag_pm1 = YES THEN DO:
                     UNDO setvflagpm ,RETRY.
                  END.   
               END.
            END.
            /* SS - 20081202.1 - E */
         END.
         /* SS - 20080905.1 - E */

         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:

            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

            if del-yn = no then
               undo idloop, retry idloop.

            assign
               lotserial_qty       = 0
               total_lotserial_qty = total_lotserial_qty - sr_qty.

            delete sr_wkfl.

            if execname = "sosois.p"
               or execname = "fsrmash.p"
               or execname = "rcshwb.p"
            then do:

               for first clc_ctrl
                  fields (clc_domain clc_lotlevel)
                  where   clc_domain = global_domain
               no-lock:

                  if available pt_mstr then do:

                     if clc_lotlevel = 1 then do:
                        for each lotw_wkfl
                           where lotw_domain = global_domain
                           and   lotw_mfguser = mfguser
                           and   lotw_lotser  = lotserial
                           and   lotw_part    = pt_part
                        exclusive-lock:
                           delete lotw_wkfl.
                        end.
                     end. /* IF clc_lotlevel = 1 */

                     if clc_lotlevel = 2 then do :
                        for each lotw_wkfl
                           where lotw_domain = global_domain
                           and   lotw_mfguser = mfguser
                           and   lotw_lotser  = lotserial
                        exclusive-lock:
                           delete lotw_wkfl.
                        end.
                     end. /* IF clc_lotlevel = 2 */

                  end.   /* IF AVAILABLE pt_mstr */
               end. /* FOR FIRST clc_ctrl */


            end. /* IF execname = ... */

            find next sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.

            if not available sr_wkfl
            then do:

               find prev sr_wkfl
                   where sr_domain = global_domain
                   and   sr_userid = mfguser
                   and   sr_lineid = cline
               no-lock no-error.

            end. /* IF NOT AVAILABLE sr_wkfl */

            if not available sr_wkfl then do:

               for first sr_wkfl
                  fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                          sr_rev sr_site sr_userid)
                  where   sr_domain = global_domain
                  and     sr_userid = mfguser
                  and     sr_lineid = cline
               no-lock: end.

            end. /* IF NOT AVAILABLE sr_wkfl */

            if available sr_wkfl then
               sr_recno = recid(sr_wkfl).
            else
               sr_recno = ?.

            next loop2.

         end. /* IF lastkey = keycode("F5") */

         if lotserial_qty <> 0 then do:

            serialcount = 1.

            if available pt_mstr
               and pt_lot_ser = "s"
               and (lotserial_qty > 1 or lotserial_qty < -1)
            then do:
               if c-application-mode <> "API" then
                  serials_yn = yes.
               else do:
                  /* QUANTITY MUST BE -1 OR 1 */
                  {pxmsg.i &MSGNUM=314 &ERRORLEVEL=3}
                  undo, retry.
               end.

               /* Create list of serial numbers */
               {pxmsg.i &MSGNUM=1100 &ERRORLEVEL=1 &CONFIRM=serials_yn}

               if not serials_yn then
                  undo idloop, retry idloop.

               serialcount = if lotserial_qty > 0 then lotserial_qty
                             else - lotserial_qty.

               /* HERE FIGURE OUT WHERE THE LAST INTEGER PORTION OF THE
                * SERIAL NUMBER IS */
               assign
                  intstart     = ?
                  intend       = ?
                  serialprefix = ""
                  serialsuffix = ""
                  i = length(lotserial).

               do while i > 0
                  and (substring(lotserial,i,1) < "0"
                  or   substring(lotserial,i,1) > "9"):
                  i = i - 1.
               end.

               if i = 0 then do:
                  /* Unable to find integer portion of serial number */
                  {pxmsg.i &MSGNUM=1099 &ERRORLEVEL=3}
                  undo idloop, retry idloop.
               end.

               intend = i.

               do while i > 0
                  and substring(lotserial,i,1) >= "0"
                  and substring(lotserial,i,1) <= "9":
                  i = i - 1.
               end.

               assign
                  intstart     = i + 1
                  seriallength = intend - intstart + 1.

               if intstart > 1 then
                  serialprefix = substring(lotserial, 1, intstart - 1).

               assign
                  nextserial =
                     decimal(substring(lotserial,intstart,seriallength))
                  serialsuffix = substring(lotserial,intend + 1,40)
                  lotserial_qty = lotserial_qty / serialcount.

            end. /* IF AVAILABLE pt_mstr */

            if not available pt_mstr then
               pt_memo = yes.

            do i = 1 to serialcount:

               if available pt_mstr
                  and (pt_lot_ser = "S")
               then do:

                  for first sr_wkfl
                     fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                             sr_rev sr_site sr_userid)
                     where   sr_domain = global_domain
                     and     sr_userid = mfguser
                     and     sr_lotser = lotserial
                  no-lock:

                     if (sr_site <> site
                        or  (sr_lineid   <> cline
                        and clc_lotlevel = 2)
                        or sr_ref <> lotref
                        or sr_loc <> location)
                     then do:

                        if clc_lotlevel = 0
                        then do:
                           if     sr_userid = mfguser
                              and sr_lotser = lotserial
                              and sr_lineid = cline
                           then do:
                              /* SERIAL EXISTS AT SITE, LOCATION */
                              {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3
                                       &MSGARG1= "sr_site + "", "" + sr_loc"}
                              undo idloop, retry idloop.
                           end. /* IF sr_userid = MFGUSER */
                        end. /* IF clc_lotlevel = 0 */
                        else do:
                           /* LOT IS IN USE */
                           {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                           undo idloop, retry idloop.
                        end. /* ELSE DO */

                     end.   /* IF sr_site <> site */
                  end. /* FOR FIRST SR_WKFL */
               end. /* IF AVAILABLE PT_MSTR */

               find sr_wkfl
                  where sr_domain = global_domain
                  and   sr_userid = mfguser
                  and   sr_lineid = cline
                  and   sr_site = site
                  and   sr_loc = location
                  and   sr_lotser = lotserial
                  and   sr_ref = lotref
               exclusive-lock no-error.

               if not available sr_wkfl
               then do:

                  create sr_wkfl.
                  assign
                     sr_domain = global_domain
                     sr_userid = mfguser
                     sr_lineid = cline
                     sr_site = site
                     sr_loc = location
                     sr_lotser = lotserial
                     sr_ref = lotref.

                  if recid(sr_wkfl) = -1 then .

               end. /* IF NOT AVAILABLE sr_wkfl */

               assign
                  total_lotserial_qty = total_lotserial_qty - sr_qty
                  sr_qty              = lotserial_qty
                  total_lotserial_qty = total_lotserial_qty + sr_qty.

               if using_cust_consignment
                  /* ONLY CALL socnship.p IF ICSRUP.P IS BEING USED IN A SO  */
                  /* SHIPMENT FUNCTION.                                      */
                  and (execname = "sosois.p"        /* SO Shipments */
                  or   execname = "rcshmt.p"        /* Shipper Maint */
                  or   execname = "rcctmt.p"        /* Container Maint */
                  or   execname = "rcshwb.p")       /* Shipper Workbench */
               then do:

                  /* CREATE CONSIGNMENT TEMP-TABLE RECORD */
                  {gprunmo.i &program = "socnship.p" &module = "ACN"
                             &param   = """(input  l_so_nbr,
                                            input  integer(line_nbr),
                                            input  site,
                                            input  location,
                                            input  pt_part,
                                            input  lotserial,
                                            input  lotref,
                                            input  lotserial_qty,
                                            output ok_to_ship,
                                            input-output table
                                               tt_consign_shipment_detail)"""}

                  if not ok_to_ship then
                     undo idloop, retry idloop.

                  if can-find(first tt_consign_shipment_detail where
                     tt_consign_shipment_detail.sales_order = l_so_nbr and
                     tt_consign_shipment_detail.order_line = integer(line_nbr))
                  then do:
                     /* CHECK IF AGGREGATE SHIP QTY IN TEMP-TABLE VIOLATES */
                     /* OVERISSUE SETTING ON CONSIGNED LOCATION            */
                     {gprunmo.i &program = "socnovis.p" &module  = "ACN"
                                &param   = """(output ok_to_ship,
                                               input-output table
                                                  tt_consign_shipment_detail)"""}

                     if not ok_to_ship then
                        undo idloop, retry idloop.
                  end.

               end.  /* IF using_cust_consignment */

               /* If Memo Item, don't create the ld_det record */
               if transtype = "RCT-PO" and pt_memo  = no
               then do:

                  /*CREATE LD_DET RECORD IF ASSAY, ETC HAS BEEN CHGD*/
                  /*OR THERE IS AN ITEM DEFINED STATUS FOR THIS ITEM*/
                  for first pod_det
                     fields (pod_domain pod_consignment pod_line pod_nbr)
                     where   pod_domain = global_domain
                     and     pod_nbr  = trnbr
                     and  pod_line = integer(trline)
                  no-lock:

                     {gprun.i ""poporca1.p"" "(input recid(pod_det))"}

                     if msgref <> "" then do:
                        msgref = trim(msgref).
                        /* # status conflicts with existing inventory */
                        {pxmsg.i &MSGNUM=1914 &ERRORLEVEL=3 &MSGARG1=msgref}
                        undo idloop, retry idloop.
                     end.
                  end.

               end. /* IF transtype = "RCT-PO" */

               /* Convert quantity to stocking unit of measure */
               for first si_mstr
                  fields (si_domain si_db si_entity si_site)
                  where  si_domain = global_domain
                  and    si_site = site
               no-lock: end. /* FOR FIRST si_mstr */

               l_db = (if not available si_mstr then global_db
                       else si_db).

               if l_db <> global_db then do:

                  {gprun.i ""gpmdas.p""
                           "(input l_db,
                             output l_err_flag)"}

                  assign
                     l_con_db  = l_db
                     l_db_undo = no.

                  run p_dom_connect
                     (input l_con_db,
                     input-output l_db_undo).

                  if l_db_undo then
                     undo idloop, retry idloop.

               end. /*IF l_db <> global_db */

               if not pt_memo then do:

                  find first wo_mstr
                     where wo_domain   = global_domain
                     and   wo_fsm_type = "RMA"
                     and   wo_nbr      = trnbr
                  no-lock no-error.

                  if available wo_mstr
                  then
                     l_read_tr = yes.

                  {&ICSRUP-P-TAG1}
                  if i = 1 then do:

                     /* FOR WORK ORDERS RELEASED FROM RMA, SET TRANSACTION */
                     /* TYPE TO "RCT-WOR" IF ITEM-LOT/SERIAL ISSUED TO WO  */
                     /* IS SAME AS FOR RECEIPT.                            */
                     if execname   = "woworc.p"
                        and available pt_mstr
                        and pt_lot_ser <> ""
                        and l_read_tr
                     then
                        for first tr_hist
                           fields (tr_domain tr_fsm_type tr_nbr tr_part
                                   tr_serial   tr_type)
                           where   tr_domain = global_domain
                           and     tr_nbr    = trnbr
                           and     tr_part   = global_part
                           and     tr_type   = "ISS-WO"
                           and     tr_fsm_type = "RMA"
                        no-lock:
                           if tr_serial = lotserial then
                              transtype = "RCT-WOR".
                           trnbr = "".
                        end. /* FOR FIRST tr_hist */

                     /* TO ASSIGN l_ato_itm as "YES" WHEN ITEM    */
                     /* IS A CONFIGURATION ITEM AND CONFIGURATION */
                     /* TYPE IS SET TO 1 AND fac_so_rec IN        */
                     /* CONFIGURATION CONTROL IS "YES"            */
                     l_ato_itm = (can-find(sod_det
                                          where sod_domain   = global_domain
                                          and   sod_nbr      = l_so_nbr
                                          and   sod_line     = integer(line_nbr)
                                          and   sod_cfg_type = "1"
                                          and   sod_status   = "FAS")
                                  and can-find(fac_ctrl
                                              where fac_domain = global_domain
                                              and    fac_so_rec = yes ))
                                  or can-find(sod_det
                                             where sod_domain = global_domain
                                             and   sod_nbr  = l_so_nbr
                                             and   sod_line = integer(line_nbr)
                                             and   sod_cfg_type = "2").

                     /* TO NOT RUN icedit.p for CONFIGURED ITEM WHEN */
                     /* CONFIGURATION TYPE IS  1 OR 2 IN THE SO      */
                     if not l_ato_itm
                     then do:
                        /* SS - 20080901.1 - B */
                        {gprun.i ""xxiceditad.p""
                                 "(input transtype,
                                   input site,
                                   input location,
                                   input global_part,
                                   input lotserial,
                                   input lotref,
                                   input lotserial_qty * trans_conv,
                                   input trans_um,
                                   input trnbr,
                                   input trline,
                                   output undo-input)"}
                        if undo-input then
                           undo idloop, retry idloop.

                     end. /* IF NOT l_ato_itm .... */

                  end. /* if i = 1 */

                  if l_glob_db <> global_db then do:

                     {gprun.i ""gpmdas.p""
                              "(input l_glob_db,
                                output l_err_flag)"}

                     assign
                        l_con_db  = l_glob_db
                        l_db_undo = no.

                     run p_dom_connect
                        (input l_con_db,
                         input-output l_db_undo).

                     if l_db_undo then
                        undo idloop, retry idloop.

                  end. /* IF l_glob_db <> global_db */

                  else

                  /* TO NOT RUN icedit3.p FOR CONFIGURED ITEM WHEN */
                  /* CONFIGURATION TYPE IS 1 OR 2 IN THE SO        */
                  if not l_ato_itm
                     and lotserial_qty <> 0
                  then do:
                        {gprun.i ""icedit3.p""
                                 "(input transtype,
                                   input site,
                                   input location,
                                   input global_part,
                                   input lotserial,
                                   input lotref,
                                   input lotserial_qty * trans_conv,
                                   input trans_um,
                                   input trnbr,
                                   input trline,
                                   output undo-input)"}

                  end. /* IF NOT l_ato_itm...  */
                  if undo-input then
             undo idloop, retry idloop.

                  /* If this is a sales order, verify location used in not */
                  /* reserved for another customer                         */
                  if transtype = "ISS-SO" then do:
                     run check-reserved-location.

                     if ret-flag = 0 then do:
                        /* THIS LOCATION RESERVED FOR ANOTHER CUSTOMER */
                        {pxmsg.i &MSGNUM=3346 &ERRORLEVEL=3}
                        undo idloop, retry idloop.
                     end.
                  end. /* transtype = "ISS-SO" */

                  if base_site <> ?
                     and base_site <> site
                  then do:

                     iss_yn = no.                            /*RECEIPT*/

                     if transtype begins "ISS" then
                        iss_yn = yes. /*ISSUE*/

                     {gprun.i ""icedit4.p""
                              "(input transtype,
                                input base_site,
                                input site,
                                input pt_loc,
                                input location,
                                input global_part,
                                input lotserial,
                                input lotref,
                                input lotserial_qty * trans_conv,
                                input trans_um,
                                input trnbr,
                                input trline,
                                output undo-input)"}

                     if undo-input then undo idloop, retry idloop.

                  end. /* IF  base_site <> ? ... */

                  {&ICSRUP-P-TAG2}

               end. /* IF NOT PT_MEMO */

               sr_recno = recid(sr_wkfl).

               if serialcount > 1 then do:

                  /* TO TAKE INTO ACCOUNT OF THE CHANGING FORMULA AND */
                  /* TO GENERATE ERROR MESSAGE ONLY IF THE LENGTH     */
                  /* (lotserial) EXCEEDS 18 CHARACTERS                */
                  l_addon = yes.

                  do l_count = 0 to 8:
                     if index(string(nextserial),string(l_count)) <> 0
                     then
                        l_addon = no.
                  end. /* DO l_count = 0 to 8 */

                  if l_addon and length(string(nextserial)) = seriallength then
                     seriallength = seriallength + 1.

                  assign
                     nextserial = nextserial + 1
                     lotserial  = serialprefix
                                + string(nextserial,fill("9",seriallength))
                                + serialsuffix.

               end. /* IF serialcount > 1 */

               if length(lotserial) > 18
               then do:
                  /* INTEGER PORTION OF SERIAL NOT LONG ENOUGH */
                  {pxmsg.i &MSGNUM=1098 &ERRORLEVEL=3}
                  undo idloop,retry idloop.
               end. /* IF LENGTH(lotserial) */

            end. /* DO i = 1 TO serialcount */

            if singlelot then lotnext = lotserial.

            if using_supplier_consignment
               and lotserial_qty < 0
            then do:
               for first pod_det
                  fields (pod_domain pod_consignment pod_line pod_nbr pod_part)
                   where  pod_domain = global_domain
                     and  pod_nbr    = trnbr
                     and  pod_line   = integer(trline)
               no-lock:

                  /* FOR A NEGATIVE RECEIPT AGAINST A CONSIGNED LINE      */
                  /* CHECK WHETHER A POSITIVE RECEIPT EXISTS FOR THE LINE */

                  if pod_consignment
                  then do:
                     for each cnsix_mstr no-lock
                        where cnsix_domain         = global_domain
                        and   cnsix_part           = pod_part
                        and   cnsix_site           = pod_site
                        and   cnsix_po_nbr         = pod_nbr
                        and   cnsix_pod_line       = pod_line
                        and   cnsix_lotser         = lotserial
                        and   cnsix_ref            = lotref:
                        accumulate cnsix_qty_consigned (total).
                     end. /* for each cnsix */
                     if (accum total cnsix_qty_consigned) < abs(lotserial_qty)
                     then do:
                        /* NO CONSIGNED INVENTORY CAN BE RETURNED FOR PO LINE */
                        {pxmsg.i &MSGNUM=6303 &ERRORLEVEL=2
                                 &MSGARG1=pod_nbr
                                 &MSGARG2=pod_line}
                     end. /* if accum total */
                  end. /* IF pod_consignment */

               end. /* FOR FIRST pod_det */
            end. /* IF lotserial_qty < 0 */

         end. /* IF lotserial_qty <> 0 */
         else do:
            assign
               lotserial_qty       = 0
               total_lotserial_qty = total_lotserial_qty - sr_qty.

            delete sr_wkfl.

            for each lotw_wkfl
               where lotw_domain = global_domain
               and   lotw_mfguser = mfguser
            exclusive-lock:
               delete lotw_wkfl.
            end. /* FOR EACH lotw_wkfl */

            find next sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = cline
            no-lock no-error.

            if not available sr_wkfl then
               for first sr_wkfl
                  fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                          sr_rev sr_site sr_userid)
                  where   sr_domain = global_domain
                  and     sr_userid = mfguser
                  and     sr_lineid = cline
               no-lock: end. /* FOR FIRST sr_wkfl */

            if available sr_wkfl then
               sr_recno = recid(sr_wkfl).
            else
               sr_recno = ?.

         end. /* ELSE DO */
         {&ICSRUP-P-TAG4}
      end. /* idloop */

      if global_type = "shipundo" then
         global_type = "shipok".

   end. /* loop2 */

   /* Total lot serial quantity entered */
   {pxmsg.i &MSGNUM=300 &ERRORLEVEL=1 &MSGARG1=total_lotserial_qty}

   if not batchrun and c-application-mode <> "API" then do:
      {swindowb.i
         &domain="sr_domain = global_domain and "
         &file=sr_wkfl
         &framename="c"
         &frame-attr="overlay col 5 row 8 attr-space
         title color normal frametitle"
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
         &display1=sr_site
         &display2=sr_loc
         &display3=sr_lotser
         &display4=sr_ref
         &display5=sr_qty}
   end.

   /* Set global_type to "shipok" if ISSUE DETAIL frame not processed */
   if keyfunction(lastkey) = "end-error"
   then do:
      if global_type = "shipundo" then
         global_type = "shipok".
      leave.
   end. /* IF KEYFUNCTION(LASTKEY) = "END-ERROR" */

   if (batchrun and keyfunction(lastkey) = ".") or
      c-application-mode = "API" then leave.

end.  /* loop1: repeat: */

if using_cust_consignment
   /* ONLY CALL socntmp.p IF ICSRUP.P IS BEING USED IN A SO SHIPMENT FUNCTION */
   and (execname = "sosois.p"        /* SO Shipments */
   or   execname = "rcshmt.p"        /* Shipper Maint */
   or   execname = "rcctmt.p"        /* Container Maint */
   or   execname = "rcshwb.p")       /* Shipper Workbench */
then do:

   key1 = mfguser + "CONS".

   /* TRANSFER CONSIGNMENT TEMP-TABLE TO qad_wkfl, SO THAT     */
   /* ALL PROGRAMS CALLING icsrup.p DO NOT HAVE TO BE MODIFIED */
   /* TO PASS BACK AN OUTPUT PARAMETER FOR THIS TEMP-TABLE.    */
   /* CALLING PROGRAMS NEEDING THE TEMP-TABLE WILL RECONSTRUCT */
   /* IT FROM qad_wkfl.                                        */
   {gprunmo.i &program = "socntmp.p" &module  = "ACN"
              &param   = """(input 0,
                             input key1,
                             input-output table tt_consign_shipment_detail)"""}
end.

if c-application-mode <> "API" then do:
   pause 0.
   hide frame c.
   hide frame a.
end.

/* CLEAR FRAMES FOR QXTEND */
{gpcontxt.i
   &STACKFRAG = 'icsrup,icisrc01,icintr01,icunrc01'
   &FRAME = 'a,c'}

PROCEDURE p_dom_connect:
/*---------------------------------------------------------------------------
 * Purpose:     Checks if the domain is connected properly
 *---------------------------------------------------------------------------*/
   define input        parameter l_con_db  like dc_name      no-undo.
   define input-output parameter l_db_undo like mfc_logical  no-undo.

   if l_err_flag = 2 or l_err_flag = 3
   then do:
      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=l_con_db}
      if c-application-mode <> "API" then
         next-prompt site with frame a.
      l_db_undo = yes.
   end. /* IF l_err_flag = 2 OR l_err_flag = 3 */

END PROCEDURE.


PROCEDURE check-reserved-location:
/*---------------------------------------------------------------------------
 * Purpose:     This program validates whether the location entered by
 *              The user in the calling program is a reserved location
 *              for the customer entered.  If the location is a reserved
 *              location then it can only be used by the customer assigned
 *              To it in reserved location maintenance.
 * Exceptions:  None
 * Notes:       Input fields used will be customer bill-to, customer sold-to,
 *              customer ship-to, site and location.
 *              The output parameter will be an integer flag where:
 *                Returned value of 0 indicates the location is not
 *                  acceptable because the site and location is assigned to
 *                  another reserved location customer.
 *                Returned value of 1 indicates the location is
 *                  acceptable because the location is assigned to this
 *                  customer.
 *                Returned value of 2 indicates the location is
 *                  acceptable because the location is not assigned to
 *                  any reserved location customer.
 *---------------------------------------------------------------------------*/
   ret-flag = 2.

   for first so_mstr
      fields (so_domain so_nbr so_ship so_bill so_cust so_site so_fsm_type)
      where   so_domain = global_domain
      and     so_nbr = trnbr
   no-lock:
      /* Bypass checking SSM orders */
      if so_fsm_type = "" then do:
        {gprun.i ""sorlchk.p""
                 "(input so_ship,
                   input so_bill,
                   input so_cust,
                   input site,
                   input location,
                   output ret-flag)"}
      end.
   end. /* for first so_mstr  */
END PROCEDURE.

PROCEDURE return_updateframe_values:
/*---------------------------------------------------------------------------
 * Purpose:     Displays the values in the frame from window help
 *---------------------------------------------------------------------------*/
   define input parameter ip_lotserial like wld_lotser no-undo.
   define input parameter ip_lotref    like wld_ref    no-undo.

   display
      ip_lotserial @ lotserial
      ip_lotref    @ lotref
   with frame a.

END PROCEDURE.
