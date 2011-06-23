/* icedit.i - INCLUDE FILE TO EDIT INVENTORY TRANS INPUT                      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* $Revision: 1.36.1.2 $                                                               */
/* REVISION: 6.0      LAST MODIFIED: 05/02/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 07/10/90   BY: WUG *D051*                */
/* REVISION: 6.0      LAST MODIFIED: 07/17/90   BY: emb                       */
/* REVISION: 6.0      LAST MODIFIED: 04/15/91   BY: WUG *D526*                */
/* REVISION: 6.0      LAST MODIFIED: 05/30/91   BY: ram *D666*                */
/* REVISION: 6.0      LAST MODIFIED: 07/15/91   BY: WUG *D786*                */
/* REVISION: 6.0      LAST MODIFIED: 08/06/91   BY: ram *D815*                */
/* REVISION: 6.0      LAST MODIFIED: 09/18/91   BY: WUG *D858*                */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*                */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92   BY: emb *F114*                */
/* REVISION: 7.0      LAST MODIFIED: 02/05/92   BY: pma *F167*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: pma *F089*                */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F372*                */
/* REVISION: 7.0      LAST MODIFIED: 05/08/92   BY: afs *F459*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: pma *F623*                */
/* REVISION: 7.3      LAST MODIFIED: 04/26/93   BY: WUG *GA39*                */
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: ram *GE92*                */
/* REVISION: 7.3      LAST MODIFIED: 06/27/94   BY: afs *FP12*                */
/* REVISION: 7.3      LAST MODIFIED: 10/19/94   BY: pxd *FS58*                */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 04/23/95   BY: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 10/10/95   BY: bholmes *J0FY*            */
/* REVISION: 7.3      LAST MODIFIED: 04/05/96   BY: rvw *G1RZ*                */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: kxn *J0NK*                */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: GWM *J108*                */
/* REVISION: 8.5      LAST MODIFIED: 11/04/96   BY: *J17L* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 12/17/97   BY: *J252* Viswanathan        */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 09/04/99   BY: *J3KM* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 05/04/00   BY: *K25X* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/15/00   BY: *M0WG* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 11/27/00   BY: *M0WZ* Kaustubh Kulkarni  */
/* REVISION: 9.1      LAST MODIFIED: 09/23/00   BY: *N0W6* BalbeerS Rajput    */
/* Revision: 1.17.2.2      BY: Rajiv Ramaiah      DATE: 05/28/01  ECO: *M18M* */
/* Revision: 1.20          BY: Rajaneesh Sarangi  DATE: 02/21/02  ECO: *L13N* */
/* Revision: 1.21          BY: Steven Nugent      DATE: 03/22/02  ECO: *P00G* */
/* Revision: 1.24          BY: Paul Donnelly      DATE: 12/13/01  ECO: *N16J* */
/* Revision: 1.25          BY: Manisha Sawant     DATE: 04/15/02  ECO: *N1GG* */
/* Revision: 1.26          BY: Vandna Rohira      DATE: 08/01/02  ECO: *N1PV* */
/* Revision: 1.30          BY: Manisha Sawant     DATE: 09/23/02  ECO: *N1QH* */
/* Revision: 1.31          BY: K Paneesh          DATE: 11/20/02  ECO: *N205* */
/* Revision: 1.33          BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00G* */
/* Revision: 1.34          BY: Rajinder Kamra     DATE: 06/23/03  ECO  *Q003* */
/* Revision: 1.35          BY: Robin McCarthy     DATE: 04/19/04  ECO: *P15V* */
/* Revision: 1.36          BY: Alka Duseja        DATE: 12/03/04  ECO: *P2XR* */
/* Revision: 1.36.1.1      BY: Tejasvi Kulkarni   DATE: 04/08/05  ECO: *P3G9* */
/* $Revision: 1.36.1.2 $       BY: Jean Miller        DATE: 01/10/06  ECO: *Q0PD* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/*!
 *{&transtype}  ""ISS-SO"", ""RCT-PO"" etc.
 * {&site}
 * {&location}
 * {&part}
 * {&lotserial}
 * {&lotref}
 * {&quantity}   In terms of pt_um
 * {&um}         The issue or receipt um
 * {&trnbr}      Order number
 * {&trline}     WO Lot or PO line
 * {&overissue_check}      Used to control the check of overissue
 *                         when doing a SO issue where a receipt transaction
 *                         is done simultaneously, ie configured product
 *                         receipts and final assy receipts, which would
 *                         result in a net-zero issue.
 */
/* NOTE: IF QUANTITY IS ZERO NO LOT MASTER RECORD WILL BE CREATED */
/******************************************************************************/
/* NOTE: CHANGES MADE TO THIS FILE MAY NEED TO BE MADE TO ICEDIT2.I ALSO.     */

/*V8:ConvertMode=Maintenance                                                  */

{cxcustom.i "ICEDIT.I"}

/* DUMMY FORM DEFINED TO DISPLAY ld_qty_oh IN pxmsg.i */
form
   ld_qty_oh
with frame dummy_qty.

/* SS - 20081112.1 - B */
FOR FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
   AND pt_part = {&part} NO-LOCK :
END.
/* SS - 20081112.1 - E */

find first icc_ctrl where icc_domain = global_domain no-lock.
find first clc_ctrl where clc_domain = global_domain no-lock no-error.
if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl where clc_domain = global_domain no-lock.
end.

find loc_mstr
   where loc_domain = global_domain
   and   loc_site   = {&site}
   and   loc_loc    = {&location}
no-lock no-error.

find ld_det
   where ld_domain = global_domain
   and   ld_site   = {&site}
   and   ld_loc    = {&location}
   and   ld_lot    = {&lotserial}
   and   ld_ref    = {&lotref}
   and   ld_part   = {&part}
no-lock no-error.

find in_mstr
   where in_domain = global_domain
   and   in_site   = {&site}
   and   in_part   = {&part}
no-lock no-error.

find pt_mstr
   where pt_domain = global_domain
   and  pt_part = {&part}
no-lock no-error.

{icedit1.i
   &site="{&site}"
   &part="{&part}"
   &lotserial="{&lotserial}"
   &quantity="{&quantity}"
   &um="{&um}"
   &transtype="{&transtype}"}

/* ISSUE ERROR WHEN THE SERIAL EXISTS FOR THE ITEM */
if {&transtype} begins "CYC"
   and available pt_mstr
then do:

   if pt_lot_ser = "S" then do:

      for first ld_det
         fields (ld_domain ld_part ld_lot ld_site ld_loc ld_qty_oh)
         where   ld_domain = global_domain
         and    (ld_part  = {&part}
         and     ld_lot   = {&lotserial}
         and    (ld_site <> {&site}
         or      ld_loc  <> {&location}) )
         and     ld_qty_oh <> 0
       no-lock:

         /* SERIAL EXISTS AT SITE, LOCATION */
         {pxmsg.i &MSGNUM  = 79 &ERRORLEVEL = 3
                  &MSGARG1    = "ld_site + "", "" + ld_loc"}

         undo, retry.

      end. /* FOR FIRST ld_det */

   end. /* IF pt_lot_ser = "S" */

end. /* IF {&transtype} BEGINS "CYC" */

/* RESTRICTED TRANSACTION VALIDATION FOR  "RCT-WO" TO TAKE INTO */
/* ACCOUNT OF USER ENTERED STATUS IS DONE IN worcat01.p */
if {&transtype} <> "RCT-WO" then do:

   /* THE FOLLOWING CODE IS TO CHECK WHETHER INVENTORY TRANSACTION */
   /* STATUS CODE FOUND IN IN_MSTR/PT_MSTR IS DEFINED IN           */
   /* INVENTORY STATUS MASTER.                                     */
   if available in_mstr
      and {&transtype}    = "RCT-PO"
      and in_rctpo_active = yes
   then
      find is_mstr
         where is_domain = global_domain
         and   is_status = in_rctpo_status
      no-lock no-error.
   else
   if available pt_mstr
      and {&transtype}    = "RCT-PO"
      and pt_rctpo_active = yes
   then
      find is_mstr
         where is_domain = global_domain
         and   is_status = pt_rctpo_status
      no-lock no-error.
   else
      /* MAKE SURE STATUS CODE EXISTS AND TRANSTYPE ALLOWED */
   if available ld_det then
      find is_mstr
         where is_domain = global_domain
         and   is_status = ld_status
      no-lock no-error.
   else
   if available loc_mstr then
      find is_mstr
         where is_domain = global_domain
         and   is_status = loc_status
      no-lock no-error.
   else
      find is_mstr
         where is_domain = global_domain
         and   is_status = si_status no-lock no-error.
   if not available is_mstr then do:
      {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
      undo, retry.
   end.

   find isd_det
      where isd_domain = global_domain
      /* SS - 20081118.1 - B */
      /*
      and   isd_tr_type = {&transtype}
      */
      and   isd_tr_type = "rct-sor"
      /* SS - 20081118.1 - E */
      and   isd_status  = is_status
   no-lock no-error.

   if available isd_det then do:
      if batchrun            =  yes
         and isd_bdl_allowed <> yes
      then do:
         /* isd_status WILL CONTAIN THE RESTRICTED STATUS CODE */
         /* RESTRICTED TRANSACTION FOR STATUS CODE: */
         {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3
                  &MSGARG1=isd_status}
         undo, retry.
      end.

      if batchrun <> yes then do:
         /* ISD_STATUS WILL CONTAIN THE RESTRICTED STATUS CODE */
         if execname = "rcshwb.p"
            or execname = "rcshmt.p"
         then do:
            /* RESTRICTED TRANSACTION FOR STATUS CODE:      */
            {pxmsg.i &MSGNUM=373 &ERRORLEVEL=2
                     &MSGARG1=isd_status}
         end. /* IF execname = "rcshmb.p" or ... */
         else do:
            /* RESTRICTED TRANSACTION FOR STATUS CODE: */
            {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3
                      &MSGARG1=isd_status}
            undo, retry.
         end. /* IF execname <> "rcshwb.p" or ... */
      end.
   end.
end. /* IF {&transtype} <> "RCT-WO" */

/*CHECK THAT XFER ACCOUNTS ARE DEFINED IN A MULTI-SITE ENVIRONMENT*/
if si_xfer_acct  = ""
   or icc_xclr_acct = ""
then do:
   find first si_mstr
      where si_domain = global_domain
      and   si_site > {&site}
   no-lock no-error.

   if not available si_mstr then
      find last si_mstr
         where si_domain = global_domain
         and   si_site < {&site}
      no-lock no-error.

   if available si_mstr then do:
      {pxmsg.i &MSGNUM=5226 &ERRORLEVEL=3} /*inv ctrl xfer accts not defined*/
      undo, retry.
   end.

   find first si_mstr
      where si_domain = global_domain
      and   si_site = {&site}
   no-lock no-error.
end.

/*CHECK THAT SITE IS ATTACHED TO THIS DATABASE*/
if si_db <> global_db then do:
   /* Site is not assigned to this domain */
   {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}
   undo, retry.
end.

/* CHECKING FOR LOCATION */
if available pt_mstr
   and not available loc_mstr
then do:
   /* WARN IF LOCATION DOESNT EXIST */
   if {&action} + 0 = 0 then do:
      {pxmsg.i &MSGNUM=709 &ERRORLEVEL="(if si_auto_loc then 2 else 3)"}
      if si_auto_loc = no then
         undo, retry.
   end.
   else
   if not si_auto_loc then do:
      {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
      undo, retry.
   end.
end.

if ({&lotserial} <> "")
   and (clc_lotlevel <> 0)
then do:
   find lot_mstr
      where lot_domain = global_domain
      and   lot_part = {&part}
      and   lot_serial = {&lotserial}
   no-lock no-error.

   if available lot_mstr then do:
      if ({&trnbr}  <> "" and lot_nbr  <> {&trnbr})
         or ({&trline} <> "" and lot_line <> {&trline})
      then do:
         {pxmsg.i &MSGNUM=2707 &ERRORLEVEL=3}  /* WO or LINE DOES NOT MATCH */
         undo, retry.
      end.

      /* CREATING lotw_wkfl RECORDS */
      if (execname   = "sosois.p"
         or   execname   = "soivmt.p"
         or   execname   = "fsrmash.p"
         or   execname   = "rcshwb.p")
         and  pt_lot_ser = "s"
      then do:
         {gprun.i ""gplotwup.p""
                  "(input {&lotserial},
                    input {&part},
                    output trans-ok)"}

         if not trans-ok then
            undo, retry.
      end.  /* IF execname = ... */

   end. /* IF AVAILABLE LOT_MSTR */
   else
   if (({&transtype} begins "R"
      and {&quantity}    > 0)
      or  ({&transtype}  = "ISS-RMA"
      and {&quantity}    < 0))
   then do:
      {gprun.i ""gplotwup.p""
               "(input {&lotserial},
                 input {&part},
                 output trans-ok)"}
      if not trans-ok then
         undo, retry.
   end. /* ELSE IF {&TRANSTYPE} BEGINS "R" */

   /* COMPLIANCE CHECK IS NO LONGER DONE FOR KIT PARENT ITEMS */
   else
   if ((({&transtype} begins "I")
      and ({&quantity}   <> 0))
      or ({&transtype}   begins "R"
      and {&quantity}    < 0))
      and (pt_cfg_type   <> "2"
      or   execname      =  "rcshmt.p"
      or   execname      =  "fsrmash.p")
   then do:
      /* LOT/SERIAL DOES NOT EXISTS - NO ISSUE ALLOWED */
      {pxmsg.i &MSGNUM=2704 &ERRORLEVEL=3}
      undo, retry.
   end. /* ELSE IF {&TRANSTYPE} BEGINS "I" .... */
end. /* IF {&LOTSERIAL} <> "" AND */

/* CHECKING FOR ISSUES */
if ({&transtype} begins "I"
   and {&quantity}  > 0)
   or ({&transtype} begins "R"
   and {&quantity}  < 0)
   or ({&transtype} begins "CN"
   and {&quantity} <> 0)
then do:

   if available ld_det then do:

      if ld_expire < today + icc_iss_days
         and {&transtype} <> "ISS-TR"  /*do not include transfers*/
         and {&transtype} <> "ISS-CHL" /*do not include status change*/
         and {&transtype} <> "ISS-GIT" /*do not include transit issue*/
         and {&transtype} <> "ISS-DO"  /*do not include transit issue*/
         and {&transtype} <> "RCT-TR"  /*do not include transfers*/
         and {&transtype} <> "RCT-CHL" /*do not include status change*/
         and {&transtype} <> "RCT-GIT" /*do not include transit receipt*/
         and {&transtype} <> "RCT-DO"  /*do not include transit receipt*/
      then do:
         find lot_mstr
            where lot_domain = global_domain
            and   lot_part   = {&part}
            and lot_serial   = {&lotserial}
         no-lock no-error.

         if (not available lot_mstr)
            or (lot_trans <> {&transtype})
         then do:
            /* LOT/SERIAL HAS EXPIRED */
            {pxmsg.i &MSGNUM=76 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF (NOT AVAILABLE LOT_MSTR) OR ... */
      end.

      /* WARNING MESSAGE TO BE GIVEN FOR EXPIRED INVENTORY */
      /* IN CASE OF ISS-DO AND RCT-DO TRANSACTIONS         */
      if ld_expire < today + icc_iss_days
         and ({&transtype} = "ISS-DO"
         or  {&transtype}  = "RCT-DO")
      then do:
         find lot_mstr
            where lot_domain = global_domain
            and   lot_part   = {&part}
            and   lot_serial = {&lotserial}
         no-lock no-error.

         if (not available lot_mstr)
            or (lot_trans <> {&transtype})
         then do:
            /* LOT/SERIAL HAS EXPIRED */
            {pxmsg.i &MSGNUM=76 &ERRORLEVEL=2}
         end. /* IF (NOT AVAILABLE LOT_MSTR) OR ... */
      end. /* IF LD_EXPIRE < TODAY + ICC_ISS_DAYS */
   end.
   
   /* RESTRICTED TRANSACTION VALIDATION FOR  "RCT-WO" TO TAKE INTO */
   /* ACCOUNT OF USER ENTERED STATUS IS DONE IN worcat01.p */
   if {&transtype} <> "RCT-WO" then do:
      {&ICEDIT-I-TAG1}
      if not is_overissue
         {&overissue_check}
         and (not available ld_det
         or (({&transtype} begins "I" and ld_qty_oh < {&quantity})
         or  ({&transtype} begins "R" and ld_qty_oh < {&quantity} * -1)
         or  ({&transtype} begins "CN" and ld_qty_oh < {&quantity})))
      then do:
         if execname = "rcshwb.p"
            or execname = "rcshmt.p"
         then do:
            /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
            {pxmsg.i &MSGNUM=208 &ERRORLEVEL=2
                     &MSGARG1="if available ld_det then
                                  ld_qty_oh else 0,"ld_qty_oh:format" "}
         end. /* IF execname = "rcshwb.p" */
         else do:
            /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
            {pxmsg.i &MSGNUM=208 &ERRORLEVEL=3
                     &MSGARG1="if available ld_det then
                                  ld_qty_oh else 0,"ld_qty_oh:format" "}
            undo, retry.
         end.   /* ELSE DO */
      end.
      {&ICEDIT-I-TAG2}
   end. /* IF {transtype} <> "RCT-WO" */

   if {&action} + 0 = 0 then do:
      if not available ld_det then do:
         /*WARN IF RECORD DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=242 &ERRORLEVEL=2}
         if execname = "porvis.p"
            and not batchrun
         then
            pause.
      end.
      else do:
         {&ICEDIT-I-TAG3}
         if (({&transtype} begins "I" and ld_qty_oh < {&quantity})
            or  ({&transtype} begins "CN" and ld_qty_oh < {&quantity})
            or  ({&transtype} begins "R" and ld_qty_oh < {&quantity} * -1)) {&overissue_check}
            and {&transtype} <> "RCT-WO"
         then do:
            /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
            /* SS - 20080901.1 - B */
            /*
           {pxmsg.i &MSGNUM=208 &ERRORLEVEL=2
                    &MSGARG1=ld_qty_oh,"ld_qty_oh:format"}
                    */      
            /* SS - 20080901.1 - E */        
         end.
         {&ICEDIT-I-TAG4}
      end.
   end.
end.

/* CHECKING FOR RECEIPTS */
if ({&transtype} begins "R"
   and {&quantity}  > 0)
   or ({&transtype} begins "I"
   and {&quantity}  < 0)
   or ({&transtype} begins "CYC")
then do:

   if available pt_mstr
     and pt_loc_type <> ""
   then
   if ((available loc_mstr
       and loc_type <> pt_loc_type)
       or (not available loc_mstr))
   then do:
       /* INVALID LOCATION TYPE FOR ITEM */
       {pxmsg.i &MSGNUM=240 &ERRORLEVEL=3}
       undo, retry.
   end.

   if available loc_mstr
      and loc_single
   then do:
      {gprun.i ""gploc01.p""
               "(input si_site,
                 input loc_loc,
                 input {&part},
                 input {&lotserial},
                 input {&lotref},
                 input loc__qad01,   /* SINGLE LOT/SERIAL */
                 output trmsg)"}
      if trmsg <> 0 then do:
         /* SINGLE ITEM LOCATION HAS EXISTING INVENTORY */
         {pxmsg.i &MSGNUM=245 &ERRORLEVEL=3}
         undo, retry.
      end.
   end.

   /* SS - 20080901.1 - B */
   IF (AVAIL ld_det AND ld_qty_oh = 0 AND pt_pm_code <> "C") 
      OR (NOT AVAIL ld_det AND pt_pm_code <> "C" ) THEN DO:
      /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
      {pxmsg.i &MSGNUM=208 &ERRORLEVEL=2 &MSGARG1="0"}
   END.
   /* SS - 20080901.1 - E */

end.

/* CHECKING FOR DUPLICATE SERIAL NUMBER ON RECEIPTS */
if ({&transtype} begins "R"
   and {&transtype} <> "RCT-TR"
   and {&transtype} <> "RCT-DO"
   and {&transtype} <> "RCT-GIT"
   and {&quantity}  > 0)
   or  ({&transtype} begins "I"
   and {&transtype} <> "ISS-TR"
   and {&transtype} <> "ISS-DO"
   and {&transtype} <> "ISS-GIT"
   and {&quantity}  < 0)
then do:
   if available pt_mstr
      and pt_lot_ser = "S"
   then do:
      find first ld_det
         where ld_domain = global_domain
         and   ld_part   = {&part}
         and   ld_lot    = {&lotserial}
         and   ld_qty_oh > 0
      no-lock no-error.

      if available ld_det
         and ld_cust_consign_qty = 0   /* IGNORE IF RETURNING CONSIGNMENT QTY */
      then do:
         /* SERIAL EXISTS AT SITE, LOCATION */
         {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3
                  &MSGARG1="ld_site + "", "" + ld_loc"}
         undo, retry.
      end.

      if execname         = "fscarmt.p"
         or (execname     = "woworc.p"
         and {&transtype} = "RCT-WOR")
      then do:
         for first ld_det
            fields (ld_domain ld_expire ld_loc  ld_lot    ld_part
                    ld_qty_oh ld_ref    ld_site ld_status)
            where   ld_domain = global_domain
            and     ld_part   = {&part}
            and     ld_lot    = {&lotserial}
            and     ld_qty_oh < 0
         no-lock:

            /* SERIAL EXISTS AT SITE, LOCATION */
            {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3
                     &MSGARG1="ld_site + "", "" + ld_loc"}
            undo, retry.
         end. /* FOR FIRST ld_det */
      end. /* IF execname = "fscarmt.p" */

      /* DO NOT CHECK FOR LOT CONTROL FOR RMA WORK */
      /* ORDERS WITH TRANSACTION TYPE "RCT-WOR"    */
      if execname = "woworc.p"
         and {&transtype} = "RCT-WOR"
      then
         {&transtype} = "RCT-WO".
      else
         if ({&transtype} begins "R"
            and {&transtype} <> "RCT-DO"
            and {&transtype} <> "RCT-GIT"
            and execname     <> "fscarmt.p"
            and execname     <> "rsporc.p"
            and {&quantity}  > 0)
         then do:
            if clc_lotlevel = 1 then do:
               find lot_mstr
                  where lot_domain = global_domain
                  and   lot_part = {&part}
                  and   lot_serial = {&lotserial}
               no-lock no-error.

               if available lot_mstr then do:
                  /* SERIAL EXISTS AT SITE, LOCATION */
                  {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3}
                  undo, retry.
               end.
            end.
            if clc_lotlevel = 2 then do:
               find lot_mstr
                  where lot_domain = global_domain
                  and   lot_serial = {&lotserial}
               no-lock no-error.

               if available lot_mstr then do:
                  /* SERIAL EXISTS AT SITE, LOCATION */
                  {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3}
                  undo, retry.
               end.
            end.
         end.
   end.
end.
