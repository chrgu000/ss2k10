/* sosoisu2.p - SALES ORDER SHIPMENT VALIDATE SHIP SITE, LOCATION             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.12 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 6.0      LAST MODIFIED: 11/13/91   BY: WUG *D887**/
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190**/
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: afs *F209**/
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247**/
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302**/
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: tjs *G318**/
/* REVISION: 7.3      LAST MODIFIED: 03/12/93   BY: tjs *G451**/
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: tjs *G935**/
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39**/
/* REVISION: 7.3      LAST MODIFIED: 08/02/93   BY: afs *GD90**/
/* REVISION: 7.3      LAST MODIFIED: 01/21/94   BY: cdt *FL48**/
/* REVISION: 7.3      LAST MODIFIED: 01/26/94   BY: afs *FL68**/
/* REVISION: 7.2      LAST MODIFIED: 02/22/94   BY: cdt *FM33**/
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: jxz *FT33**/
/* REVISION: 8.5      LAST MODIFIED: 11/21/94   BY: taf *J038**/
/* REVISION: 7.3      LAST MODIFIED: 12/06/94   BY: smp *FU35**/
/* REVISION: 7.3      LAST MODIFIED: 08/03/95   BY: jym *G0T9**/
/* REVISION: 7.3      LAST MODIFIED: 10/16/95   BY: rvw *G0X0**/
/* REVISION: 7.2      LAST MODIFIED: 11/02/95   BY: jym *F0TC**/
/* REVISION: 8.5      LAST MODIFIED: 03/14/96   BY: kxn *J0FN**/
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/06/96   BY: *G1PF* Tony Patel         */
/* REVISION: 8.5      LAST MODIFIED: 06/05/96   BY: *J0QV* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: *J0NK* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 09/04/96   BY: *G2CM* Ajit Deodhar       */
/* REVISION: 8.5      LAST MODIFIED: 09/09/97   BY: *H1F2* Todd Runkle        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/13/99   BY: *J2MD* A. Philips         */
/* REVISION: 9.1      LAST MODIFIED: 06/29/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/09/00   BY: *N0WT* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.5        BY: Russ Witt         DATE: 06/18/01  ECO: *P00J* */
/* Revision: 1.8.1.8        BY: Hareesh V         DATE: 10/08/01  ECO: *P027* */
/* Revision: 1.8.1.9        BY: Rajaneesh S.      DATE: 02/21/02  ECO: *L13N* */
/* Revision: 1.8.1.10  BY: Jean Miller DATE: 05/13/02 ECO: *P05V* */
/* $Revision: 1.8.1.12 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

{cxcustom.i "SOSOISU2.P"}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable cline as character.
define shared variable lotserial_control as character.
define shared variable total_lotserial_qty like sod_qty_chg.
define shared variable site like sr_site no-undo.
define shared variable location like sr_loc no-undo.
define shared variable lotserial like sr_lotser no-undo.
define shared variable lotserial_qty like sr_qty no-undo.
define shared variable trans_um like pt_um.
define shared variable trans_conv like sod_um_conv.
define shared variable loc like pt_loc.
define shared variable change_db like mfc_logical.
define shared variable ship_site like sod_site.
define shared variable ship_so like so_nbr.
define shared variable ship_line like sod_line.
define shared variable lotref like sr_ref no-undo.
define shared variable undo-all like mfc_logical no-undo.

/* NOTE:  FOR SERVICE ENGINEER ORDERS (SEO'S) OR KIT REPLENISHMENT
   ORDERS, FSEOSH.P WILL (WITH THE NEW SHARED VARIABLE TRANSTYPE)
   HAVE CALLED THIS ROUTINE.  FOR THESE TRANSACTION TYPES, RATHER
   THAN THE 'NORMAL' ISS-SO SHIPMENT TRANSACTION, AN ISS-TR INVENTORY
   TRANSFER TRANSACTION IS BEING DONE.    */
define shared variable transtype as character initial "ISS-SO".

define variable yn          like mfc_logical no-undo.
define variable tot_this_ld like sr_qty no-undo.
define variable rejected    like mfc_logical no-undo.
define variable trans-ok    like mfc_logical no-undo.
define variable trtype      like tr_type no-undo.
define variable ret-flag    as integer no-undo.
define variable msg-arg     as character format "x(16)" no-undo.

define buffer soddet for sod_det.

for first so_mstr
   fields( so_domain so_bill so_cust so_fsm_type so_nbr so_ship)
    where so_mstr.so_domain = global_domain and  so_nbr = ship_so
no-lock: end.

for first sod_det
   fields( sod_domain sod_line sod_nbr sod_part sod_qty_ord
          sod_rma_type sod_site sod_type sod_um_conv)
    where sod_det.sod_domain = global_domain and  sod_nbr = ship_so
     and sod_line = ship_line
no-lock: end.

trtype = transtype.

if sod_type = "" then do:
   define variable check_overissue like mfc_logical.

   {gprun.i ""sosoisck.p"" "(output check_overissue)"}

   /* Use icedit with error messages for regular issues. */
   if (sod_rma_type <> "" and sod_qty_ord >= 0)
   or sod_rma_type = ""
   then do:

      if so_fsm_type = "SEO" or
         so_fsm_type = "KITASS"
      then
         trtype = transtype.

      {&SOSOISU2-P-TAG1}

      /* SS - 20080901.1 - B */
      {xxicedit.i
         &transtype=trtype
         &site=site
         &location=location
         &part=global_part
         &lotserial=lotserial
         &lotref=lotref
         &quantity="lotserial_qty * trans_conv"
         &um=trans_um
         &overissue_check="and check_overissue"
         &trnbr = """"
         &trline = """"}

      {&SOSOISU2-P-TAG2}

   end.

   /* Use icedit2 without error messages for issues    */
   if sod_qty_ord < 0 then do:

      if sod_rma_type <> "I" then do:

         {gprun.i ""icedit2.p""
            "(input transtype,
              input site,
              input location,
              input global_part,
              input lotserial,
              input lotref,
              input lotserial_qty * trans_conv,
              input trans_um,
              input """",
              input """",
              output rejected)"}

         /* Add call to icedit1.i to catch non-location related   */
         {&SOSOISU2-P-TAG3}
         {icedit1.i
            &site=site
            &part=global_part
            &lotserial=lotserial
            &quantity="lotserial_qty * trans_conv"
            &um=trans_um
            &transtype=""ISS-SO""}
         {&SOSOISU2-P-TAG4}

      end.

      else do:

         /* IF CODE ISS-RMA DOES NOT EXIST ADD IT TO CODE_MSTR   */
         for first code_mstr
            fields( code_domain code_cmmt code_fldname code_value)
             where code_mstr.code_domain = global_domain and  code_fldname =
             "tr_type"
              and code_value = "ISS-RMA"
         no-lock: end.

         if not available code_mstr then do:

            create code_mstr. code_mstr.code_domain = global_domain.
            assign
               code_fldname = "tr_type"
               code_value   = "ISS-RMA".

            code_cmmt = getTermLabel("PSEUDO_TRANS-TYPE_FOR_RMA_RECEIPT",40).

         end.

         {icedit.i
            &transtype=""ISS-RMA""
            &site=site
            &location=location
            &part=global_part
            &lotserial=lotserial
            &lotref=lotref
            &quantity=" (lotserial_qty * -1) * trans_conv"
            &um=trans_um
            &overissue_check="and check_overissue"
            &trnbr = """"
            &trline = """"}
      end.

   end.

   /* Check site and location again */
   for first si_mstr
      fields( si_domain si_auto_loc si_db si_entity
             si_site si_status si_xfer_acct)
       where si_mstr.si_domain = global_domain and  si_site = site
   no-lock: end.

   if not available si_mstr then do:
      /* Site does not exist */
      {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
      leave.
   end.

   if not si_auto_loc then do:

      for first loc_mstr
         fields( loc_domain loc_loc loc_single loc_site
                loc_status loc_type loc__qad01)
          where loc_mstr.loc_domain = global_domain and  loc_site = site
           and loc_loc = location
      no-lock: end.

      if not available loc_mstr then do:
         /* Location does not exist */
         {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
         leave.
      end.

   end.

   /* CHECK TO SEE IF RESERVED LOCATION EXISTS */
   /* FOR OTHER CUSTOMERS--                    */
   run check-reserved-location.

   if ret-flag = 0 then do:
      /* THIS LOCATION RESERVED FOR ANOTHER CUSTOMER */
      {pxmsg.i &MSGNUM=3346 &ERRORLEVEL=3}
      leave.
   end.

   /* Check to see whether this shipment plus previous shipments */
   /* Issues used for receipt do not have overissue concerns.      */
   if available is_mstr
      and check_overissue and available ld_det
   then do:

      if not (is_overissue and
         (if sod_rma_type <> "I" then lotserial_qty * trans_conv
          else lotserial_qty * trans_conv * -1) > ld_qty_oh  )
      then do:

         tot_this_ld = 0.

         for each soddet
            fields( sod_domain sod_line sod_nbr sod_part sod_qty_ord
                   sod_rma_type sod_site sod_type sod_um_conv)
             where soddet.sod_domain = global_domain and  soddet.sod_nbr =
             sod_det.sod_nbr
              and soddet.sod_part =  sod_det.sod_part
              and soddet.sod_line <> sod_det.sod_line
         no-lock:

            for each sr_wkfl
               fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                      sr_ref sr_site sr_userid)
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
                 and sr_lineid = string(soddet.sod_line)
                 and sr_site   = ld_site
                 and sr_loc    = ld_loc
                 and sr_lot    = ld_lot
                 and sr_ref    = ld_ref
            no-lock:
               tot_this_ld = tot_this_ld + (sr_qty * sod_um_conv).
            end.    /* for each sr_wkfl */

         end.   /* for each soddet */

         /* IF THIS IS AN RMA RECEIPT (SOD_RMA_TYPE = "I" FOR INBOUND,
            AND "O" FOR OUTBOUND - RECEIPTS ARE TYPE I), THEN CHANGE
            THE SIGN ON THE QUANTITY SINCE WE ARE 'ISSUING' A NEGATIVE
            QUANTITY.    */

         if ld_qty_oh - tot_this_ld -
            (if sod_rma_type <> "I" then lotserial_qty * trans_conv
            else -1 * lotserial_qty * trans_conv) < 0
         then do:

            if not is_overissue
            then do:
               /* Quantity available this site/location: */
               msg-arg = string(ld_qty_oh - tot_this_ld).
               {pxmsg.i &MSGNUM=208 &ERRORLEVEL=3 &MSGARG1=msg-arg}
               undo, retry.
            end.
            else do:
               /* Quantity available this site/location: */
               msg-arg = string(ld_qty_oh - tot_this_ld).
               {pxmsg.i &MSGNUM=208 &ERRORLEVEL=2 &MSGARG1=msg-arg}
            end.

         end.

      end. /* If not(is_overissue and lotserial_qty > ld_qty_oh */

   end.  /* End of overissue check */

   undo-all = no.

   if sod_site <> site then do:

      {&SOSOISU2-P-TAG5}
      {gprun.i ""icedit4.p"" "(input ""ISS-SO"",
                               input sod_site,
                               input site,
                               input pt_loc,
                               input location,
                               input global_part,
                               input lotserial,
                               input lotref,
                               input (if sod_rma_type <> 'I'
                                      then lotserial_qty
                                      else - lotserial_qty) ,
                               input trans_um,
                               input """",
                               input """",
                               output yn)"}
      {&SOSOISU2-P-TAG6}

      if yn then undo, retry.
   end.

end.  /* Inventory validation */
else
   undo-all = no.  /* sod_type <> "" */

{&SOSOISU2-P-TAG7}

find first sr_wkfl  where sr_wkfl.sr_domain = global_domain and  sr_userid =
mfguser
                     and sr_lineid = cline
exclusive-lock no-error.

if lotserial_qty = 0 then do:

   if available sr_wkfl then do:
      total_lotserial_qty = total_lotserial_qty - sr_qty.
      delete sr_wkfl.
   end.

   for each lotw_wkfl  where lotw_wkfl.lotw_domain = global_domain and
   lotw_mfguser = mfguser
   exclusive-lock:
      delete lotw_wkfl.
   end. /* FOR EACH lotw_wkfl */

end.

else do:

   if available sr_wkfl then do:
      total_lotserial_qty = total_lotserial_qty - sr_qty + lotserial_qty.
      assign
         sr_site   = site
         sr_loc    = location
         sr_lotser = lotserial
         sr_ref  = lotref
         sr_qty    = lotserial_qty.
   end.

   else do:
      create sr_wkfl. sr_wkfl.sr_domain = global_domain.
      assign
         sr_userid = mfguser
         sr_lineid = cline
         sr_site   = site
         sr_loc    = location
         sr_lotser = lotserial
         sr_ref  = lotref
         sr_qty    = lotserial_qty.
      total_lotserial_qty = total_lotserial_qty + lotserial_qty.
   end.

end.

/* DETERMINE IF LOC TO BE USED IS VALID                                */
PROCEDURE check-reserved-location:

   ret-flag = 2.

   /* Bypass checking SSM orders */
   if so_mstr.so_fsm_type = "" then do:
     {gprun.i ""sorlchk.p""
              "(input so_ship,
                input so_bill,
                input so_cust,
                input site,
                input location,
                output ret-flag)"}
   end.

END PROCEDURE.
