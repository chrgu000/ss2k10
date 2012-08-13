/* icsrup1.p - -- PROGRAM TO UPDATE sr_wkfl MULTI LINE ENTRY                  */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 1.2        BY: Kirti Desai           DATE: 02/08/02  ECO: *M1TV* */
/* Revision: 1.3        BY: Rajaneesh S.          DATE: 02/21/02  ECO: *L13N* */
/* Revision: 1.4        BY: Rajesh Kini           DATE: 04/26/02  ECO: *M1XW* */
/* Revision: 1.5        BY: Jean Miller           DATE: 05/22/02  ECO: *P074* */
/* Revision: 1.7        BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00G* */
/* Revision: 1.9        BY: Rajinder Kamra        DATE: 06/23/03  ECO *Q003*  */
/* Revision: 1.10       BY: Dorota Hohol          DATE: 08/25/03  ECO: *P112* */
/* Revision: 1.12       BY: Jean Miller           DATE: 02/17/04  ECO: *Q04Y* */
/* $Revision: 1.13 $    BY: Jean Miller           DATE: 01/10/06  ECO: *Q0PD* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ANY MODIFICATION DONE IN THIS PROGRAM MAY BE REQUIRED IN icsrup.p */

/*NOTE: icsrup1.p IS CLONE OF icsrup.p, EXCEPT FOR 6th INPUT-OUTPUT  */
/*      PARAMETER l_update_sr_wkfl. WHICH RETURNS TRUE IF sr_wkfl    */
/*      IS MODIFIED.                                                 */


{mfdeclre.i}
{cxcustom.i "ICSRUP1.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


define input parameter base_site       like si_site     no-undo.
define input parameter trnbr           like lot_nbr     no-undo.
define input parameter trline          like lot_line    no-undo.
define input-output parameter lotnext  like wo_lot_next no-undo.
define input parameter singlelot       like wo_lot_rcpt no-undo.

/* l_update_sr_wkfl IS SET TO YES WHEN THE QUANTITY FIELD       */
/* (lotserial_qty) IS MODIFIED BY THE USER.                     */
/* l_update_sr_wkfl IS DEFINED AS UNDO TO UPDATE THIS FLAG TO   */
/* YES ONLY WHEN sr_wkfl RECORD GETS UPDATED/DELETED WITHOUT    */
/* ANY ERRORS ATLEAST ONCE IN THIS PROGRAM.                     */
/* PLEASE DO NOT MAKE THIS PARAMETER AS NO-UNDO.                */

define input-output parameter l_update_sr_wkfl like mfc_logical.

define new shared variable h_ui_proc as handle no-undo.
define new shared variable msgref as character format "x(20)".

define shared variable multi_entry as log no-undo.
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

{&ICSRUP1-P-TAG3}

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
   fields(clc_domain clc_lotlevel)
   where clc_domain = global_domain
no-lock: end.

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields(clc_domain clc_lotlevel)
      where clc_domain = global_domain
   no-lock: end.

end. /* IF not available clc_ctrl */

for first pt_mstr
   fields(pt_domain pt_auto_lot pt_loc pt_lot_ser pt_part)
    where pt_domain = global_domain and pt_part = global_part
no-lock: end.

pause 0.

form
   space(1)
   site
   location
   lotserial
   lotref
   lotserial_qty
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

view frame c.

total_lotserial_qty = 0.

for each sr_wkfl
   fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev sr_site
          sr_userid)
    where sr_domain = global_domain
      and sr_userid = mfguser
      and sr_lineid = cline
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
      fields(si_domain si_db si_entity si_site)
       where si_domain = global_domain and si_site = site
   no-lock:
      ship_db = si_db.
   end. /* FOR FIRST si_mstr */

end. /* IF global_db <> "" */

loop1:
repeat:

   loop2:
   repeat with frame a:
      view.

      clear frame c all no-pause.

      for first sr_wkfl
         fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                sr_site sr_userid)
         where recid(sr_wkfl) = sr_recno
      no-lock: end.

      if available sr_wkfl then do:

         do i = 1 to truncate(frame-down(c) / 2,0)
            while available sr_wkfl:

            find next sr_wkfl where sr_domain = global_domain
                                and sr_userid = mfguser
                                and sr_lineid = cline
            no-lock no-error.

         end.

         if not available sr_wkfl then do:
            for last sr_wkfl
               fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                      sr_site sr_userid)
                where sr_domain = global_domain
                  and sr_userid = mfguser
                  and sr_lineid = cline
            no-lock: end.
         end. /* IF NOT AVAILABLE sr_wkfl */

         do i = 1 to frame-down(c) - 1 while available sr_wkfl:
            find prev sr_wkfl where sr_domain = global_domain
                                and sr_userid = mfguser
                                and sr_lineid = cline
            no-lock no-error.
         end.

         if not available sr_wkfl then do:
            for first sr_wkfl
               fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                      sr_site sr_userid)
                where sr_domain = global_domain
                  and sr_userid = mfguser
                  and sr_lineid = cline
            no-lock: end.
         end.

      end. /* IF AVAILABLE sr_wkfl */
      else do:
         for first sr_wkfl
            fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                   sr_site sr_userid)
             where sr_domain = global_domain
               and sr_userid = mfguser
               and sr_lineid = cline
            no-lock: end.
      end. /* ELSE DO */

      if available sr_wkfl then do with frame c:

         do i = 1 to frame-down(c) while available sr_wkfl:

            if sr_rev <> "SEO-DEL" then
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
               find next sr_wkfl where sr_domain = global_domain
                     and sr_userid = mfguser
                     and sr_lineid = cline
               no-lock no-error.

               if frame-line(c) < frame-down(c) then
                  down 1 with frame c.

            end. /* IF sr_rev <> "SEO-DEL" */
            else
               /* DON'T LEAVE AN EXTRA BLANK LINE IN FRAME C */
               find next sr_wkfl where sr_domain = global_domain
                                   and sr_userid = mfguser
                                   and sr_lineid = cline
               no-lock no-error.

         end. /* DO i = 1 TO FRAME-DOWN(c) */

      end. /* IF AVAILABLE sr_wkfl */

      for first sr_wkfl
         fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                sr_site sr_userid)
         where recid(sr_wkfl) = sr_recno
      no-lock: end.

      if not available sr_wkfl then
         for first sr_wkfl
            fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                   sr_site sr_userid)
             where sr_domain = global_domain
               and sr_userid = mfguser
               and sr_lineid = cline
         no-lock: end.

      if available sr_wkfl then do:
         if sr_rev <> "SEO-DEL" then
            assign
               site          = sr_site
               location      = sr_loc
               lotserial     = sr_lotser
               lotref        = sr_ref
               lotserial_qty = sr_qty.
      end.

      /* Total lot/serial quantity entered: # */
      {pxmsg.i &MSGNUM=300 &ERRORLEVEL=1 &MSGARG1= total_lotserial_qty}

      idloop:
      do on error undo, retry:

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

          /* KEEP FIELD LOTESERIAL UPDATEABLE IN CASE OF RCT-UNP TRANSACTION */
            if (pt_lot_ser = "L"
            and pt_auto_lot = yes)
            and (lotserial <> "")
            and (not transtype begins "ISS")
            and (transtype <> "RCT-UNP")
            then
               getlot = no.

         end. /* IF AVAILABLE pt_mstr */

         display
            site
            location
            lotserial
            lotserial_qty.

         update
            site
            location
            lotserial when (getlot = yes)
            lotref
         editing:

            assign
               global_site = input site
               global_loc  = input location
               global_lot  = input lotserial.

            {mfnp08.i sr_wkfl sr_id
               " sr_domain = global_domain and sr_userid  = mfguser and
               sr_lineid = cline"
               sr_site "input site" sr_loc "input location"
               sr_lotser "input lotserial" sr_ref "input lotref"}

            if recno <> ? then do:

               assign
                  site          = sr_site
                  location      = sr_loc
                  lotserial     = sr_lotser
                  lotserial_qty = sr_qty
                  lotref        = sr_ref.

               display
                  site
                  location
                  lotserial
                  lotref
                  lotserial_qty.

            end. /* IF recno <> ? */

         end. /* EDITING: */

         for first si_mstr
            fields(si_domain si_db si_entity si_site)
             where si_domain = global_domain and si_site = site
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
            and (global_type = "shipundo" or global_type = "shipok")
            and site <> ship_site
         then do:

            for first si_mstr
               fields(si_domain si_db si_entity si_site)
                where si_domain = global_domain and si_site = site
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
                               and lot_serial = lotserial
                               and lot_part = pt_part))
               then do:
                  /* LOT IS IN USE */
                  {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                  undo idloop, retry idloop.
               end. /* IF (CAN-FIND (FIRST lot_mstr */

               for first lotw_wkfl
                  fields(lotw_domain lotw_lotser lotw_mfguser lotw_part)
                   where lotw_domain = global_domain
                     and lotw_lotser = lotserial
                     and lotw_mfguser <> mfguser
                     and lotw_part    <> pt_part
               no-lock: end.

               if available lotw_wkfl
               then do:
                  /* LOT IS IN USE */
                  {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                  undo idloop, retry idloop.
               end. /* IF AVAILABLE lotw_wkfl */

            end. /* IF singlelot ... */

            if (pt_lot_ser = "S") then do:

               for first sr_wkfl
                  fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                         sr_rev sr_site sr_userid)
                   where sr_domain = global_domain
                     and sr_userid = mfguser
                     and sr_lotser = lotserial
               no-lock: end.

               if  available sr_wkfl
               and (sr_site       <> site
               or  (sr_lineid     <> cline
               and clc_lotlevel   = 2)
               or sr_ref        <> lotref
               or sr_loc        <> location)
               then do:

                  if clc_lotlevel = 0
                  then do:

                     /* SERIAL EXISTS AT SITE, LOCATION */
                     {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3
                              &MSGARG1= "sr_site + "", "" + sr_loc"}

                  end. /* IF clc_lotlevel = 0 */

                  else do:
                     /* LOT IS IN USE */
                     {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                  end. /* ELSE DO */

                  undo idloop, retry idloop.

               end. /* IF AVAILABLE sr_wkfl */

            end. /* IF (pt_lot_ser = "S") */

         end. /* IF AVAILABLE pt_mstr */

         find sr_wkfl where sr_domain = global_domain
            and sr_userid = mfguser
            and sr_lineid = cline
            and sr_site = site
            and sr_loc = location
            and sr_lotser = lotserial
            and sr_ref = lotref
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
            lotserial_qty = sr_qty.

         status input stline[2].

         set
            lotserial_qty
         go-on  ("F5" "CTRL-D").

         l_update_sr_wkfl = yes.

         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:

            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

            if del-yn = no
            then
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
                  fields(clc_domain clc_lotlevel)
                   where clc_domain = global_domain
               no-lock: end.

               if  available clc_ctrl
               and available pt_mstr
               then do :

                  if clc_lotlevel = 1
                  then do :
                     for each lotw_wkfl
                         where lotw_domain = global_domain
                           and lotw_mfguser = mfguser
                           and lotw_lotser  = lotserial
                           and lotw_part    = pt_part
                     exclusive-lock:
                        delete lotw_wkfl.
                     end. /* FOR EACH lotw_wkfl */
                  end. /* IF clc_lotlevel */

                  if clc_lotlevel = 2
                  then do :
                     for each lotw_wkfl
                         where lotw_domain = global_domain
                           and lotw_mfguser = mfguser
                           and lotw_lotser  = lotserial
                     exclusive-lock:
                        delete lotw_wkfl.
                     end. /* FOR EACH lotw_wkfl */
                  end. /* IF clc_lotlevel */

               end.  /* IF AVAILABLE clc_ctrl */

            end. /* IF execname = ... */

            find next sr_wkfl
                where sr_domain = global_domain
                  and sr_userid = mfguser
                  and sr_lineid = cline
            no-lock no-error.

            if not available sr_wkfl
            then do:

               find prev sr_wkfl
                   where sr_domain = global_domain
                     and sr_userid = mfguser
                     and sr_lineid = cline
               no-lock no-error.

            end. /* IF NOT AVAILABLE sr_wkfl */

            if not available sr_wkfl then do:

               for first sr_wkfl
                  fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                         sr_rev sr_site sr_userid)
                   where sr_domain = global_domain
                     and sr_userid = mfguser
                     and sr_lineid = cline
               no-lock: end.

            end. /* IF NOT AVAILABLE sr_wkfl */

            if available sr_wkfl
            then
               sr_recno = recid(sr_wkfl).
            else
               sr_recno = ?.

            next loop2.

         end. /* IF lastkey = keycode("F5") */

         if lotserial_qty <> 0 then do:

            serialcount = 1.

            if available pt_mstr and
               pt_lot_ser = "s" and
              (lotserial_qty > 1 or lotserial_qty < -1)
            then do:

               serials_yn = yes.

               /* Create list of serial numbers */
               {pxmsg.i &MSGNUM=1100 &ERRORLEVEL=1 &CONFIRM=serials_yn}

               if not serials_yn then undo idloop, retry idloop.

               serialcount = if lotserial_qty > 0 then
                                lotserial_qty
                             else
                                - lotserial_qty.

               /* HERE FIGURE OUT WHERE THE LAST INTEGER PORTION OF THE
                  SERIAL NUMBER IS */
               assign
                  intstart     = ?
                  intend       = ?
                  serialprefix = ""
                  serialsuffix = ""
                  i            = length(lotserial).

               do while i > 0 and
                  (substring(lotserial,i,1) < "0" or
                   substring(lotserial,i,1) > "9"):
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
                  serialsuffix  = substring(lotserial,intend + 1,40)
                  lotserial_qty = lotserial_qty / serialcount.

            end. /* IF AVAILABLE pt_mstr */

            if not available pt_mstr then
               pt_memo = yes.

            do i = 1 to serialcount:

               if available pt_mstr and (pt_lot_ser = "S")
               then do:

                  for first sr_wkfl
                     fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                            sr_rev sr_site sr_userid)
                      where sr_domain = global_domain
                        and sr_userid = mfguser
                        and sr_lotser = lotserial
                  no-lock: end.

                  if  available sr_wkfl
                     and (sr_site     <> site      or
                         (sr_lineid   <> cline     and
                     clc_lotlevel = 2)        or
                     sr_ref      <> lotref    or
                     sr_loc      <> location)
                  then do:

                     if clc_lotlevel = 0
                     then do:
                        /* SERIAL EXISTS AT SITE, LOCATION */
                        {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3
                                 &MSGARG1= "sr_site + "", "" + sr_loc"}
                     end. /* IF clc_lotlevel = 0 */

                     else do:
                        /* LOT IS IN USE */
                        {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                     end. /* ELSE DO */

                     undo idloop, retry idloop.

                  end. /* IF AVAILABLE sr_wkfl */
               end. /* IF AVAILABLE pt_mstr */

               find sr_wkfl
                   where sr_domain = global_domain
                     and sr_userid = mfguser
                     and sr_lineid = cline
                     and sr_site = site
                     and sr_loc = location
                     and sr_lotser = lotserial
                     and sr_ref = lotref
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

               /* If Memo Item, don't create the ld_det record */
               if transtype = "RCT-PO" and pt_memo  = no
               then do:

                  /*CREATE LD_DET RECORD IF ASSAY, ETC HAS BEEN CHGD*/
                  /*OR THERE IS AN ITEM DEFINED STATUS FOR THIS ITEM*/
                  for first pod_det
                     fields(pod_domain pod_line pod_nbr)
                      where pod_domain = global_domain
                        and pod_nbr  = trnbr
                        and pod_line = integer(trline)
                  no-lock: end.

                  if available pod_det then do:
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
                  fields(si_domain si_db si_entity si_site)
                   where si_domain = global_domain and si_site = site
               no-lock: end. /* FOR FIRST si_mstr */

               l_db = (if not available si_mstr then global_db
                       else si_db).

               if l_db <> global_db
               then do:

                  {gprun.i ""gpmdas.p""
                     "(input l_db, output l_err_flag)"}.

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

                  {&ICSRUP1-P-TAG1}
                  if i = 1 then do:

                     {gprun.i ""icedit.p""
                        "(transtype,
                          site,
                          location,
                          global_part,
                          lotserial,
                          lotref,
                          lotserial_qty * trans_conv,
                          trans_um,
                          trnbr,
                          trline,
                          output undo-input)" }

                     if undo-input then
                        undo idloop, retry idloop.

                  end. /* if i = 1 */

                  if l_glob_db <> global_db
                  then do:

                     {gprun.i ""gpmdas.p""
                        "(input l_glob_db, output l_err_flag)"}.

                     assign
                        l_con_db  = l_glob_db
                        l_db_undo = no.

                     run p_dom_connect
                        (input l_con_db,
                        input-output l_db_undo).

                     if l_db_undo then
                        undo idloop, retry idloop.

                  end. /* IF l_glob_db <> global_db */

                  else if lotserial_qty <> 0 then do:
                     {gprun.i ""icedit3.p""
                        "(transtype,
                          site,
                          location,
                          global_part,
                          lotserial,
                          lotref,
                          lotserial_qty * trans_conv,
                          trans_um,
                          trnbr,
                          trline,
                          output undo-input)" }
                  end.

                  if undo-input then undo idloop, retry idloop.

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

                  if  base_site <> ?
                  and base_site <> site
                  then do:

                     iss_yn = no.                            /*RECEIPT*/

                     if transtype begins "ISS" then
                        iss_yn = yes. /*ISSUE*/

                     {gprun.i ""icedit4.p""
                        "(transtype,
                          base_site,
                          site,
                          pt_loc,
                          location,
                          global_part,
                          lotserial,
                          lotref,
                          lotserial_qty * trans_conv,
                          trans_um,
                          trnbr,
                          trline,
                          output undo-input)"}

                     if undo-input then undo idloop, retry idloop.

                  end. /* IF  base_site <> ? ... */

                  {&ICSRUP1-P-TAG2}

               end. /* IF NOT pt_memo */

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
                     lotserial = serialprefix
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

         end. /* IF lotserial_qty <> 0 */

         else do:

            assign
               lotserial_qty       = 0
               total_lotserial_qty = total_lotserial_qty - sr_qty.

            delete sr_wkfl.

            for each lotw_wkfl
                where lotw_domain = global_domain
                  and lotw_mfguser = mfguser
            exclusive-lock:
               delete lotw_wkfl.
            end. /* FOR EACH lotw_wkfl */


            find next sr_wkfl where sr_domain = global_domain
                                and sr_userid = mfguser
                                and sr_lineid = cline
            no-lock no-error.

            if not available sr_wkfl then
               for first sr_wkfl
                  fields(sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                         sr_rev sr_site sr_userid)
                   where sr_domain = global_domain
                     and sr_userid = mfguser
                     and sr_lineid = cline
               no-lock: end. /* FOR FIRST sr_wkfl */

            if available sr_wkfl then
               sr_recno = recid(sr_wkfl).
            else
               sr_recno = ?.

         end. /* ELSE DO */
         {&ICSRUP1-P-TAG4}
      end. /* idloop */

      if global_type = "shipundo" then
         global_type = "shipok".

   end. /* loop2 */

   /* Total lot serial quantity entered */
   {pxmsg.i &MSGNUM=300 &ERRORLEVEL=1 &MSGARG1=total_lotserial_qty}

   if not batchrun then do:
      {swindowb.i &domain="sr_wkfl.sr_domain = global_domain and "
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
      if global_type = "shipundo"
      then
         global_type = "shipok".
      leave.
   end. /* IF KEYFUNCTION(LASTKEY) = "END-ERROR" */

   if batchrun and keyfunction(lastkey) = "." then leave.

end.  /* loop1: repeat: */

pause 0.
hide frame c.
hide frame a.

PROCEDURE p_dom_connect:
/*---------------------------------------------------------------------------
   Purpose:     Checks if the domain is connected properly
   Notes:
   History:
---------------------------------------------------------------------------*/
   define input        parameter l_con_db  like dc_name      no-undo.
   define input-output parameter l_db_undo like mfc_logical  no-undo.

   if l_err_flag = 2 or l_err_flag = 3
   then do:
      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=l_con_db}
      next-prompt site with frame a.
      l_db_undo = yes.
   end. /* IF l_err_flag = 2 OR l_err_flag = 3 */

END PROCEDURE.


PROCEDURE check-reserved-location:
/*---------------------------------------------------------------------------
   Purpose:     This program validates whether the location entered by
                The user in the calling program is a reserved location
                for the customer entered.  If the location is a reserved
                location then it can only be used by the customer assigned
                To it in reserved location maintenance.
   Exceptions:  None
   Notes:       Input fields used will be customer bill-to, customer sold-to,
                customer ship-to, site and location.
                The output parameter will be an integer flag where:
                  Returned value of 0 indicates the location is not
                    acceptable because the site and location is assigned to
                    another reserved location customer.
                  Returned value of 1 indicates the location is
                    acceptable because the location is assigned to this
                    customer.
                  Returned value of 2 indicates the location is
                    acceptable because the location is not assigned to
                    any reserved location customer.
   History:
---------------------------------------------------------------------------*/
   ret-flag = 2.

   for first so_mstr
      fields( so_domain so_nbr so_ship so_bill so_cust so_site so_fsm_type)
      where so_domain = global_domain
        and so_nbr = trnbr
      no-lock:
      /* bypass checking SSM orders */
      if so_fsm_type = "" then do:
        {gprun.i ""sorlchk.p""
                 "(input so_ship,
                   input so_bill,
                   input so_cust,
                   input site,
                   input location,
                   output ret-flag)"}
      end.
   end. /* FOR FIRST so_mstr  */

END PROCEDURE.

PROCEDURE return_updateframe_values:
/*---------------------------------------------------------------------------
   Purpose:     Display the values in the frame from window help
   Notes:
   History:
---------------------------------------------------------------------------*/
   define input parameter ip_lotserial like wld_lotser no-undo.
   define input parameter ip_lotref    like wld_ref    no-undo.

   display
      ip_lotserial @ lotserial
      ip_lotref    @ lotref
   with frame a.

END PROCEDURE.
