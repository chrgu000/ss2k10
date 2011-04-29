/* icedit2.i - INCLUDE FILE TO EDIT INVENTORY TRANS INPUT                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* REVISION: 6.0      LAST MODIFIED: 09/17/91   BY: WUG *D858*                */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*                */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92   BY: emb *F114*                */
/* REVISION: 7.0      LAST MODIFIED: 02/05/92   BY: pma *F167*                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: pma *F089*                */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F372*                */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: pma *F623*                */
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: ram *GE92*                */
/* REVISION: 7.3      LAST MODIFIED: 06/27/94   BY: afs *FP12*                */
/* REVISION: 7.3      LAST MODIFIED: 09/10/94   BY: dpm *FR01*                */
/* REVISION: 8.5      LAST MODIFIED: 10/04/94   BY: MWD *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 04/23/95   BY: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 10/10/95   BY: Bholmes *J0FY*            */
/* REVISION: 7.3      LAST MODIFIED: 04/05/96   BY: rvw *G1RZ*                */
/* REVISION: 8.5      LAST MODIFIED: 04/23/95   BY: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: kxn *J0NK*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *G1ZV* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J108* Gary W. Morales    */
/* REVISION: 8.5      LAST MODIFIED: 11/04/96   BY: *J17L* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 17/24/97   BY: *J1XL* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 12/17/97   BY: *J252* Viswanathan        */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 09/04/99   BY: *J3KM* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *N0W6* Mudit Mehta        */
/* Revision: 1.15       BY: Rajaneesh Sarangi     DATE: 02/21/02  ECO: *L13N* */
/* Revision: 1.16       BY: Paul Donnelly         DATE: 12/13/01  ECO: *N16J* */
/* Revision: 1.17       BY: Jean Miller           DATE: 05/22/02  ECO: *P074* */
/* Revision: 1.19       BY: Paul Donnelly (SB)    DATE: 06/26/03  ECO: *Q00G* */
/* Revision: 1.20       BY: Rajinder Kamra        DATE: 06/23/03  ECO  *Q003* */
/* $Revision: 1.21 $    BY: Robin McCarthy        DATE: 04/19/04  ECO: *P15V* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/************************************************************************/
/*                                                                      */
/* {&transtype}  ""ISS-SO"", ""RCT-PO"" etc.                            */
/* {&site}                                                              */
/* {&location}                                                          */
/* {&part}                                                              */
/* {&lotserial}                                                         */
/* {&lotref} /*D887*/                                                   */
/* {&quantity}   In terms of pt_um                                      */
/* {&um}         The issue or receipt um                                */
/* {&trnbr}                                                             */
/* {&trline}                                                            */
/*                                                                      */
/************************************************************************/
/* THIS VERSION IS THE SAME AS ICEDIT.I, JUST WITH ALL THE              */
/* MESSAGES AND WARNING-ONLY LOGIC REMOVED.  IT IS USED BY THE          */
/* PROGRAMS DOING AUTOMATIC ISSUE-ALL OR RECEIVE-ALL.                   */
/************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{cxcustom.i "ICEDIT2.I"}

find first icc_ctrl where icc_domain = global_domain no-lock.
find first clc_ctrl where clc_domain = global_domain no-lock no-error.

if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl where clc_domain = global_domain no-lock.
end.

find loc_mstr
   where loc_domain = global_domain
   and   loc_site = {&site}
   and   loc_loc = {&location}
no-lock no-error.

find ld_det
   where ld_domain = global_domain
   and   ld_site = {&site}
   and   ld_loc = {&location}
   and   ld_lot = {&lotserial}
   and   ld_part = {&part}
   and   ld_ref = {&lotref}
no-lock no-error.

find in_mstr
   where in_domain = global_domain
   and   in_site = {&site}
   and  in_part = {&part}
no-lock no-error.

find pt_mstr
   where pt_domain = global_domain
   and   pt_part = {&part}
no-lock no-error.

find si_mstr
   where si_domain = global_domain
   and   si_site = {&site}
no-lock no-error.

/* MAKE SURE LOT/SERIAL ENTERED FOR LOT OR SERIAL-CONTROLLED PARTS */
if available pt_mstr
   and index("LS",pt_lot_ser) > 0
   and {&quantity} <> 0
   and {&lotserial} = ""
then
   undo, retry.

/* MAKE SURE UM = PT_UM IF SERIAL-CONTROLLED PARTS */
if available pt_mstr
   and pt_lot_ser = "S"
   and pt_um <> {&um}
then
   undo, retry.

/* MAKE SURE QTY IS 1, 0, OR -1 FOR SERIAL-CONTROLLED PARTS */
if available pt_mstr and pt_lot_ser = "S"
   and {&quantity} <> 1
   and {&quantity} <> -1
   and {&quantity} <> 0
then
   undo, retry.

/* MAKE SURE THE SELECTED SITE EXISTS */
if not available si_mstr then
   undo, retry.

/* VALIDATE SITE FOR AUTHORIZED USER GROUP */
{gprun.i ""gpsiver.p""
         "(input si_site,
           input recid(si_mstr),
           output return_int)"}

if return_int = 0 then
   undo, retry.

/* MOVED RESTRICTED TRANSACTION VALIDATION TO worcat01.p FOR        */
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
   /* MAKE SURE INVENTORY STATUS CODE EXISTS AND TRANSTYPE ALLOWED */
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
         and   is_status = si_status
      no-lock no-error.

   if not available is_mstr then
      undo, retry.

   find isd_det
      where isd_domain = global_domain
      and   isd_tr_type = {&transtype}
      and   isd_status  = is_status
   no-lock no-error.

   if available isd_det
   then do:

      if batchrun = yes
         and isd_bdl_allowed <> yes
      then do:
         /* ISD_STATUS WILL CONTAIN THE RESTRICTED STATUS CODE */
         /* RESTRICTED TRANSACTION FOR STATUS CODE: */
         {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3 &MSGARG1=isd_status}
         undo,retry.
      end.

      if batchrun <> yes
      then do:
         /* RESTRICTED TRANSACTION FOR STATUS CODE: XXXXXX */
         /* ISD_STATUS WILL CONTAIN THE RESTRICTED STATUS CODE */
         /* RESTRICTED TRANSACTION FOR STATUS CODE: */
         {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3 &MSGARG1=isd_status}
         undo, retry.
      end.

   end.

end. /* IF {&trantype} <> "RCT-WO" */

/* MAKE SURE THAT ITEM STATUS ALLOWS TRANSTYPE */
if available pt_mstr then
   if can-find(first isd_det
               where isd_domain = global_domain
               and   isd_status = string(pt_status,"x(8)") + "#"
               and   isd_tr_type = {&transtype})
   then
      undo, retry.

/*CHECK THAT TRANSFER ACCTS ARE DEFINED IN A MULTI-SITE ENVIRONMENT*/
if si_xfer_acct = ""
   or icc_xclr_acct = ""
then do:

   find first si_mstr
      where si_domain = global_domain
      and  si_site > {&site}
   no-lock no-error.

   if not available si_mstr then
      find last si_mstr
         where si_domain = global_domain
         and   si_site < {&site}
      no-lock no-error.

   if available si_mstr then
      undo, retry.

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
then
   /* WARN IF LOCATION DOESNT EXIST */
   if si_auto_loc = no then
      undo, retry.

if ({&lotserial} <> "")
   and (clc_lotlevel <> 0)
then do:

   find lot_mstr
      where lot_domain = global_domain
      and   lot_part = {&part}
      and   lot_serial = {&lotserial}
   no-lock no-error.

   if available lot_mstr then do:

      if ({&trnbr} <> "" and lot_nbr <> {&trnbr})
         or
         ({&trline} <> "" and lot_line <> {&trline})
      then
         /* WO or LINE DOES NOT MATCH */
         undo, retry.

      /* CREATING lotw_wkfl RECORDS */
      if (execname      = "sosois.p"
         or  execname   = "fsrmash.p")
         and pt_lot_ser = "s"
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
   if (({&transtype} begins "R" and {&quantity} > 0)
      or
      ({&transtype} = "ISS-RMA" and {&quantity} < 0))
   then do:
      {gprun.i ""gplotwu2.p""
               "(input {&lotserial},
                 input {&part},
                 output trans-ok)"}

      if not trans-ok then
         undo, retry.
   end. /* ELSE IF {&TRANSTYPE} BEGINS "R" */
   else
   if ((({&transtype} begins "I") and ({&quantity} <> 0))
      or
      ({&transtype} begins "R" and {&quantity} < 0))
   then
      /* LOT/SERIAL DOES NOT EXISTS - NO ISSUE ALLOWED */
      undo, retry.

end. /* IF PT_LOT_SER > "" */

/* CHECKING FOR ISSUES */
if ({&transtype} begins "I" and {&quantity} > 0)
   or ({&transtype} begins "R" and {&quantity} < 0)
then do:

   if available ld_det then do:

      if ld_expire < today + icc_iss_days
         and {&transtype} <> "ISS-TR"        /*do not include transfers*/
         and {&transtype} <> "ISS-CHL"       /*do not include status change */
         and {&transtype} <> "ISS-GIT"       /*do not include transit issue*/
         and {&transtype} <> "ISS-DO"        /*do not include transit issue*/
         and {&transtype} <> "RCT-TR"        /*do not include transfers*/
         and {&transtype} <> "RCT-CHL"       /*do not include status change*/
         and {&transtype} <> "RCT-GIT"       /*do not include transit receipt*/
         and {&transtype} <> "RCT-DO"        /*do not include transit receipt*/
      then do:
         find lot_mstr
            where lot_domain = global_domain
            and   lot_part = {&part}
            and   lot_serial = {&lotserial}
         no-lock no-error.

         if (not available lot_mstr)
            or (lot_trans <> {&transtype})
         then
            undo, retry.
      end.

   end.

   /* VALIDATION FOR NEGATIVE RECEIPTS IN worcat01.p */
   /* FOR TRANSACTION TYPE "RCT-WO"                  */
   if {&transtype} <> "RCT-WO"
   then do:

/*tx01* {&ICEDIT2-I-TAG1}  
      if not is_overissue
         and (not available ld_det
         or (({&transtype} begins "I" and ld_qty_oh < {&quantity})
         or  ({&transtype} begins "R" and ld_qty_oh < {&quantity} * -1)))
      then do:
	 {&ICEDIT2-I-TAG2}
         /* MAKE SURE SUFFICIENT QTY */
         undo, retry.
      end.
*tx01*/
   end. /* IF {transtype} <> "RCT-WO" */

end.  /* (IF &TRANSTYPE BEGINS "I"...) */

/* CHECKING FOR RECEIPTS */
if ({&transtype} begins "R"
   and {&quantity} > 0)
   or ({&transtype} begins "I"
   and {&quantity} < 0)
   or ({&transtype} begins "CYC")
then do:

   /* DO NOT CHECK LOCATION TYPES FOR WAREHOUSING INTERFACE */
   if not can-find(whl_mstr
      where whl_domain = global_domain
      and   whl_site = {&site}
      and   whl_loc = {&location})
   then
      if available pt_mstr
         and pt_loc_type <> ""
      then
         if ((available loc_mstr and loc_type <> pt_loc_type)
            or (not available loc_mstr))
         then
            undo, retry.

   if available loc_mstr
      and loc_single
   then do:
      {gprun.i ""gploc01.p""
               "(input si_site,
                 input loc_loc,
                 input {&part},
                 input {&lotserial},
                 input {&lotref},
                 input loc__qad01,
                 output trmsg)"}

      if trmsg <> 0 then
         undo, retry.
   end.

end.

/* CHECKING FOR DUPLICATE SERIAL NUMBER ON RECEIPTS */
if ({&transtype} begins "R"
   and {&transtype} <> "RCT-TR"
   and {&transtype} <> "RCT-DO"
   and {&transtype} <> "RCT-GIT"
   and {&quantity} > 0)
   or ({&transtype} begins "I"
   and {&transtype} <> "ISS-TR"
   and {&transtype} <> "ISS-DO"
   and {&transtype} <> "ISS-GIT"
   and {&quantity} < 0)
then do:

   if available pt_mstr
      and pt_lot_ser = "S"
   then do:

      find first ld_det
         where ld_domain = global_domain
         and   ld_part = {&part}
         and   ld_lot = {&lotserial}
         and   ld_qty_oh > 0
      no-lock no-error.

      if available ld_det
         and ld_cust_consign_qty = 0   /* IGNORE IF RETURNING CONSIGNMENT QTY */
      then do:
         msg-arg = ld_site + ", " + ld_loc.
         /* SERIAL EXISTS AT SITE, LOCATION */
         {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3 &MSGARG1=msg-arg}
         undo, retry.
      end.

      if ({&transtype} begins "R"
         and {&transtype} <> "RCT-TR"
         and {&transtype} <> "RCT-DO"
         and {&transtype} <> "RCT-GIT"
         and {&quantity} > 0)
      then do:

         if clc_lotlevel = 1 then do:

            find lot_mstr
               where lot_domain = global_domain
               and   lot_part = {&part}
               and   lot_serial = {&lotserial}
            no-lock no-error.
            if available lot_mstr then do:
               {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3}  /* SERIAL EXISTS */
               undo, retry.
            end.
         end.

         if clc_lotlevel = 2 then do:
            find lot_mstr
               where lot_domain = global_domain
               and   lot_serial = {&lotserial}
            no-lock no-error.

	    if available lot_mstr then do:
               {pxmsg.i &MSGNUM=79 &ERRORLEVEL=3}  /* SERIAL EXISTS */
               undo, retry.
            end.
         end.

      end.

   end.

end.