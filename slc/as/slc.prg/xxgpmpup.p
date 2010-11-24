/* gpmpup.p - Recalculate Materials Plan - Net Change, Regen, Selective       */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13.1.25 $                                                     */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.2       LAST EDIT: 01/25/95   MODIFIED BY: *F0GM* Evan Bishop  */
/* REVISION: 7.3       LAST EDIT: 05/30/96   MODIFIED BY: *G1WY* Evan Bishop  */
/* REVISION: 7.3       LAST EDIT: 06/21/96   MODIFIED BY: *G1YJ* Evan Bishop  */
/* REVISION: 7.4       LAST EDIT: 01/09/97   MODIFIED BY: *H0R2* Russ Witt    */
/* REVISION: 7.3       LAST EDIT: 07/16/96   MODIFIED BY: *G29B* Evan Bishop  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/06/98   BY: *J23R* Sandesh Mahagaokar */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 02/17/99   BY: *J3B7* Mugdha Tambe       */
/* REVISION: 9.1      LAST MODIFIED: 03/01/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 10/11/99   BY: *J3LH* Prashanth Narayan  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 12/13/00   BY: *M0Y2* Vandna Rohira      */
/* Revision: 1.13.1.10     BY: Irine D'Mello       DATE: 09/10/01 ECO: *M164* */
/* Revision: 1.13.1.11     BY: Anitha Gopal        DATE: 11/12/01 ECO: *N164* */
/* Revision: 1.13.1.14     BY: Saurabh Chaturvedi  DATE: 12/19/01 ECO: *M1SJ* */
/* Revision: 1.13.1.16     BY: Tony Brooks         DATE: 05/02/02 ECO: *P05X* */
/* Revision: 1.13.1.18     BY: Tony Brooks         DATE: 07/23/02 ECO: *P0BY* */
/* Revision: 1.13.1.19     BY: Tony Brooks         DATE: 10/31/02 ECO: *P0JR* */
/* Revision: 1.13.1.21     BY: Paul Donnelly (SB)  DATE: 06/26/03 ECO: *Q00F* */
/* Revision: 1.13.1.22     BY: Mercy Chittilapilly DATE: 12/18/03 ECO: *P1GB* */
/* Revision: 1.13.1.23    BY: Vinodkumar M. Date: 10/24/05 ECO: *P45W* */
/* Revision: 1.13.1.24    BY: Shridhar Mangalore Date: 11/23/05 ECO: *P490* */
/* $Revision: 1.13.1.25 $    BY: Rafiq S.  Date: 11/23/05 ECO: *P4F1* */
/* By: Neil Gao Date: 07/11/05 ECO: * ss 20071105 * */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:NonStreamIoFrame=audit */

/* CODE MODIFIED TO PREVENT INFINITE LOOPING AFTER PROCESSING            */
/* 1000 IN_MRP RECORDS AT SAME LOW LEVEL CODE FOR WHICH IN_MRP           */
/* FLAG HAS NOT BEEN CHANGED FORM YES TO NO                              */

{mfglobal.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gpmpup_p_1 "Elapsed!Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_2 "Planned!Orders!Processed"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_4 "Process Started"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_5 "Process Stopped"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_6 "Order!Count"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpmpup_p_9 "Items!Processed"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* Define the shared variables used here and in called subroutines */
{gpmpvar2.i "shared" }

define new shared variable reldays like mrpc_reldays.
define new shared variable frwrd like soc_fcst_fwd.
define new shared variable mrfsup1_frwrd like soc_fcst_fwd no-undo.
define new shared variable bck    like soc_fcst_bck.
define new shared variable in_recid as recid.
define new shared variable horizon as integer no-undo.
define new shared variable wo_recid as recid.
define new shared variable comp as character.
define new shared variable qty as decimal.
define new shared variable eff_date as date.
define new shared variable part as character.
define new shared variable site as character.
define new shared variable increment as integer.
define new shared variable numorders as integer
   format "->>>,>>>,>>>"
   column-label {&gpmpup_p_2}.
define new shared variable use-op-yield as logical no-undo.

define shared variable mfguser as character.
define shared variable dtitle as character.
define shared variable batchrun like mfc_logical.
/*V8!    define shared variable execname as character. */
define shared variable hi_date as date.
define shared variable low_date as date.

define variable pt_recid as recid no-undo.
define variable z as integer column-label {&gpmpup_p_9}
   format ">,>>>,>>9" no-undo.
define variable z1 as integer format ">>>>>>9" no-undo.
define variable low_level as integer no-undo.
define variable max_level as integer no-undo.
define variable min_level as integer no-undo.
define variable audit like mfc_logical initial yes no-undo.
define variable part_orders as integer column-label {&gpmpup_p_6}
   format ">>>>9" no-undo.
define variable start_time as integer extent 3 no-undo.
define variable start_date as date extent 2 no-undo.
define variable elapsed as integer column-label {&gpmpup_p_1}
   format ">>>>>,>>>" no-undo.

define stream audit.

define variable started as character format "x(20)"
   label {&gpmpup_p_4} no-undo.
define variable stopped as character format "x(20)"
   label {&gpmpup_p_5} no-undo.
define variable last_flag as logical no-undo.
define variable dblcol as character initial "::" no-undo.
define variable qad-recno as recid no-undo.
define variable qadmrpkey as character initial "mrp/drp" no-undo.
define variable qadkey2 as character no-undo.
define variable save_mrp_req as logical no-undo.
define variable path as character no-undo.
define variable last_part as character no-undo.
define variable last_site as character no-undo.
define variable ptp_recid as recid no-undo.
define variable n_items_proc as integer no-undo.
define variable prev_part  like in_part  no-undo.
define variable prev_level like in_level no-undo.
define variable l_pmcode like pt_pm_code no-undo.

define buffer qadwkfl for qad_wkfl.

define new shared buffer gl_ctrl for gl_ctrl.
define new shared buffer in_mstr for in_mstr.
define new shared buffer pt_mstr for pt_mstr.
define new shared buffer ptp_det for ptp_det.

define new shared temp-table tt-routing-yields no-undo
   field tt-op         like ro_op
   field tt-start      like ro_start
   field tt-end        like ro_end
   field tt-yield-pct  like ro_yield_pct
   index tt-op is unique primary
   tt-op
   tt-start.


/* AppServer MultiThread vars*/

{mtdef.i}

define variable app-string as character no-undo.
define variable last-time as integer no-undo.
define variable item-count as integer no-undo.
define variable last-rowid as rowid no-undo.
define variable req-tot as integer no-undo.
define variable tmp-desc1 like pt_desc1 no-undo.
define variable elap-time as integer no-undo.
define variable open-date as date no-undo.
define variable open-time as integer no-undo.
define variable mrppl as handle no-undo.
define variable oracle-db as logical no-undo.
define variable mrppl-tot as integer no-undo.

assign oracle-db = dbtype("qaddb") = "ORACLE".

define temp-table tt_rep no-undo
   field tt_part like in_part
   field tt_site like in_site
   field tt_desc like pt_desc1
   field tt_orders as integer
   field tt_time as integer
   field tt_mrpyn like mfc_logical
   index main tt_part tt_site.

define temp-table tt_req_sub no-undo
       field tt_part like in_part
       field tt_site like in_site
       field tt_desc like pt_desc1
       field tt_orders as integer
       field tt_inc as integer
       field tt_etime as integer
       field tt_mrpyn like mfc_logical .

define temp-table tt_back no-undo
       field tt_part like in_part
       field tt_site like in_site
       field tt_desc like pt_desc1
       field tt_orders as integer
       field tt_inc as integer
       field tt_etime as integer
       field tt_mrpyn like mfc_logical .

define variable req-sub-count as integer no-undo.
define variable temp-table-depth as integer no-undo.


/* Connect to AppServer */
if apps_threads > 0 then do:

   for first aps_mstr
             fields(aps_name aps_appservice_name aps_host_name aps_port_nbr)
             where aps_name = apps-name
             no-lock: end.


   if not available(aps_mstr) then do:
      /*Cannot connect to AppServer #*/
      {pxmsg.i &MSGNUM=3888 &ERRORLEVEL=3 &MSGARG1="(2)"}
      pause.
      return.
   end.

   assign app-string = "-AppService " + aps_appservice_name + " -H " +
                       aps_host_name + " -S " + aps_port_nbr.

   {mtinit.i &threads=apps_threads &appserver=app-string}

end.

{mfphead2.i "stream log" "(log)"}

form
   z1 no-label
   in_mstr.in_site
   pt_mstr.pt_part
   pt_mstr.pt_desc1 format "x(19)"
   in_mstr.in_level format "->>>9"
   part_orders
   elapsed
with frame log down no-attr-space width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame log:handle).

form
   started z numorders elapsed stopped
with frame log-audit width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame log-audit:handle).

form
   started z numorders elapsed stopped
with frame audit width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame audit:handle).

assign
   path = local-path
   save_mrp_req = mrp_req.

/**************************************************************
The variable 'increment' is the template for the order number
for planned orders created in the MRP/DRP calculations.  All
planned orders created in the calculations will have an order
number based on this variable.  As each order is created, this
variable will be incremented by 1 (one), checking first to see
that the resulting number is not already in use by some other
order. Note that if enough orders are created in this run, that
the order number may not be recognizable as being of the form
"MMDD0001", which is the initial format, ie., starting with an
increment value of '01250001' and creating 100,000 planned orders
will result in planned order numbers of the form "01350001".
****************************************************************/

increment =   integer(string(month(today),"99")
            + string(day(today),"99") + "0001").

for first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock:
end.  /* FOR FIRST gl_ctrl NO-LOCK */


horizon = ?.

for first mrpc_ctrl
   fields( mrpc_domain mrpc_horizon mrpc_reldays mrpc_op_yield)
 where mrpc_ctrl.mrpc_domain = global_domain no-lock:
end. /* FOR FIRST mrpc_ctrl */

if available mrpc_ctrl
then
   assign
      reldays = mrpc_reldays
      horizon = mrpc_horizon.

do for soc_ctrl:
   for first soc_ctrl
       fields( soc_domain soc_fcst_fwd soc_fcst_bck)
        where soc_ctrl.soc_domain = global_domain no-lock:
   end. /* for first soc_ctrl */

   if available soc_ctrl
   then
   assign
      frwrd = soc_fcst_fwd
      mrfsup1_frwrd = soc_fcst_fwd
      bck = soc_fcst_bck.
end.


/* Initinalized vars on AppServer */

if apps_threads > 0 then do:

   for each tt_threads no-lock:

       {gprun.i ""gpmpup02.p""
             "(frwrd, bck, horizon, reldays, drp, mrp, ms, non_ms, buyer,
               vendor, pm_code, prod_line, ptgroup, part_type,
           tt_threads.tt_thread)"
             "on tt_thread_handle"}
   end.
end.

if batchrun
then
   audit = no.

assign
   start_time = integer(time)
   start_date = today.

if audit
then do:

   output stream audit to terminal.

   display stream audit
      string(start_date[1]) + " " +
      string(start_time[1],"HH:MM:SS AM") @ started
   with frame audit.
end.  /* IF audit */

if lowlevel
   and (can-find (first in_mstr  where in_mstr.in_domain = global_domain and (
   in_level = 99999))
   or  can-find (first in_mstr  where in_mstr.in_domain = global_domain and (
   in_level = 88888)))
then do:

   /* Update low-level codes (in_mstr.in_level) */
   {gprun.i ""gpmpupa.p"" "(sync_code)"}

   /* VALUE OF FOURTH PARAMETER CHANGED FROM {&gpmpup_p_7} */
   /* TO getTermLabel("LOW_LEVEL_CODE_UPDATE",23)          */

   {gpmplog.i
      &item-count = """"
      &site-code = """"
      &item-code = """"
      &log-description = getTermLabel(""LOW_LEVEL_CODE_UPDATE"",23)
      &level = """"
      &part-orders = """"
      &tot-orders = """"
      }

end.  /* IF lowlevel AND ... */

if mrp_req = no
   and (sync_calc or sync_code <> "")
then do:

   /* Synchronized regeneration calculation
   -- update mrp required flags (in_mstr.in_mrp) */
   {gprun.i ""gpmpupb.p"" "(sync_code)"}

   /* VALUE OF FOURTH PARAMETER CHANGED FROM {&gpmpup_p_10} */
   /* TO getTermLabel("UPDATE_MRP/DRP_FLAGS",23)           */

   {gpmplog.i
      &item-count = """"
      &site-code = """"
      &item-code = """"
      &log-description = getTermLabel(""UPDATE_MRP/DRP_FLAGS"",23)
      &level = """"
      &part-orders = """"
      &tot-orders = """"
      }

   /* Make the calculation now behave like a net change */
   mrp_req = yes.
end.  /* IF mrp_req = NO ... */

/* LOOP THROUGH ALL PARTS NETTING SUPPLY AGAINST DEMAND */
max_level = 0.
for last in_mstr
   fields( in_domain in_level in_mrp in_part in_site)
    where in_mstr.in_domain = global_domain and  in_level >= -99999999 and
    in_mrp >= no
   and in_part >= "" and in_site >= ""
   use-index in_level no-lock
   query-tuning(no-index-hint hint "INDEX_DESC(T0 IN_MSTR##IN_LEVEL)"):
end. /* FOR LAST in_mstr */

if available in_mstr
then
   max_level = in_level.

min_level = 0.
for first in_mstr
   fields( in_domain in_level in_mrp in_part in_site)
    where in_mstr.in_domain = global_domain and  in_level >= -99999999 and
    in_mrp >= no
     and in_part  >= "" and in_site >= ""

   use-index in_level no-lock:
end. /* FOR FIRST in_mstr */

if available in_mstr
then
   min_level = in_level.

assign
   prev_part  = part1
   prev_level = min_level.

   if dbtype("qaddb") = "PROGRESS"
   then do:
      for each qadwkfl
         where qadwkfl.qad_key1 = qadmrpkey
      no-lock:
         find qad_wkfl
            where recid(qad_wkfl) = recid(qadwkfl)
         exclusive-lock no-wait no-error.
         if available qad_wkfl
         then
            delete qad_wkfl.
      end. /* FOR EACH qadwkfl */
   end. /* IF DBTYPE("qaddb") = "PROGRESS" */

mainloop:
do low_level = min_level to max_level
      on error undo, retry:

   if retry then .

   if prev_level <> low_level
   then
      assign
         prev_part = part1
         prev_level = low_level
         last-rowid = ?.

   if not can-find (first in_mstr  where in_mstr.in_domain = global_domain and
   in_level = low_level)
   then do:

      for first in_mstr
         fields( in_domain in_level)
      no-lock  where in_mstr.in_domain = global_domain and  in_level >
      low_level:
      end. /* FOR FIRST in_mstr */

      if available in_mstr
      then
         low_level = in_level.
      else
         leave.
   end. /* IF NOT CAN-FIND( FIRST in_mstr ... */

   /***********************************************************
   Multi-threaded calculation coordination logic -- qad_wkfl is
   used to register this calculation's activity so that other
   synchronized calculations can react in an appropriate and
   consistent manner.
   ***********************************************************/
   do transaction:

      find first qad_wkfl exclusive-lock
          where qad_wkfl.qad_domain = global_domain and  qad_key3 = qadmrpkey
          and qad_key4 = mfguser no-error.

      if not available qad_wkfl
      then
         find qad_wkfl exclusive-lock
             where qad_wkfl.qad_domain = global_domain and  qad_key1 = qadmrpkey
              and qad_key2 = mfguser + dblcol + qadmrpkey no-error.

      if not available qad_wkfl
      then do:

         create qad_wkfl. qad_wkfl.qad_domain = global_domain.
         assign
            qad_key1 = qadmrpkey
            qad_key2 = mfguser + dblcol + qadmrpkey
            qad_key3 = qadmrpkey
            qad_key4 = mfguser
            qad_key5 = qadmrpkey + sync_code
            qad_key6 = string(low_level).

         if recid(qad_wkfl) = -1 then.

      end. /* IF NOT AVAILABLE qad_wkfl */
      else
         qad_key6 = string(low_level).

      assign
         qad_charfld[1] = global_userid
         qad_datefld[1] = today
         qad_decfld[1] = time.
   end. /* DO TRANSACATION */

   define query q_in_mstr for in_mstr
      fields( in_domain in_mrp in_level in_part in_site) SCROLLING.

   if mrp_req = no
   then
      open query q_in_mstr
      for each in_mstr
         no-lock use-index in_level
          where in_mstr.in_domain = global_domain and  in_level = low_level
           and (in_part >= part1 and in_part <= part2)
           and (in_site >= site1 and in_site <= site2).
   else
      open query q_in_mstr
      for each in_mstr
         no-lock use-index in_level
          where in_mstr.in_domain = global_domain and  in_level = low_level
           and in_mrp = yes
           and (in_part >= prev_part and in_part <= part2)
           and (in_site >= site1 and in_site <= site2).

   if mrp_req = no and last-rowid <> ? then
      reposition q_in_mstr to rowid last-rowid.


   hide message no-pause.

   /* Reset Queue Depth to 4 */
   assign n_items_proc = 0
          queue-depth = 4
          temp-table-depth = 1
          open-date = today
          open-time = time.

   /*Current/maximum level: */
   {pxmsg.i &MSGNUM=1106 &ERRORLEVEL=1
            &MSGARG1="string(low_level) + ' / ' + string(max_level)"}


   blocka:
   repeat:

      assign n_items_proc = n_items_proc + 1.

      get next q_in_mstr no-lock.

      if not available in_mstr
      then
         leave blocka.


      if n_items_proc > 10000
      then do:
         assign elapsed = (today - open-date) * 86400 + time - open-time.

         if elapsed > 900
         then do:
            if in_part <> prev_part then do:
               assign last-rowid = rowid(in_mstr).
               undo mainloop, retry mainloop.
            end.
         end.
         else assign n_items_proc = 0.
      end.

      assign
         prev_part  = in_part
         prev_level = low_level
         part = in_part
         site = in_site
         last_part = in_part
         last_site = in_site
         qadkey2 = dblcol + part + dblcol + site + dblcol
         in_recid = recid(in_mstr)
         last_flag = in_mrp.


      if apps_threads = 0 then do:
         /**********************************************************
         Look in the qad_wkfl table for possible conflicts with
         other calculations and if not a conflict, register the item
         and site and low-level code this calculation is processing
         to give the appropriate visibility to other calculations.
         ***********************************************************/
         multi-thread:
         do transaction:

            find first qad_wkfl exclusive-lock
                where qad_wkfl.qad_domain = global_domain and  qad_key3 =
                qadmrpkey
                 and qad_key4 = mfguser no-error.

            assign
               qad_charfld[1] = global_userid
               qad_datefld[1] = today
               qad_decfld[1] = time
               qad_key2 = qadkey2 no-error.

            if not error-status:error
            then
               validate qad_wkfl no-error.

            if error-status:error
            then
               CASE error-status:get-number(1):
                  when (1443) /*Duplicate unique key in db table*/ or
                  when (1502) /*same as error 1443, for 8.2C+*/ or
                  when (132)  /*table already exists with key*/
                  then undo, next blocka.
                  otherwise do:
                     message error-status:get-message(1) view-as alert-box.
                     undo, next blocka.
                  end. /* OTHERWISE DO */
               end. /* CASE */

            if mrp_req = yes
            then do:
               if not can-find
                  (in_mstr  where in_mstr.in_domain = global_domain and
                  in_mstr.in_level = low_level
                  and in_mstr.in_mrp   = yes
                  and in_mstr.in_part  = part
                  and in_mstr.in_site  = site)
                  then undo, next blocka.
            end. /* IF mrp_req = yes THEN DO */
         end. /* DO TRANSACTION */

         repeat:

            for first qadwkfl
               fields( qad_domain qad_charfld qad_datefld qad_decfld qad_key1
                       qad_key2 qad_key3 qad_key4 qad_key5 qad_key6)
               no-lock
                where qadwkfl.qad_domain = global_domain and  qadwkfl.qad_key5
                = qadmrpkey + sync_code
                 and integer(qadwkfl.qad_key6) < in_level:
            end. /* FOR FIRST qadwkfl */

            if not available qadwkfl
            then
               leave.

            if dbtype("qaddb") = "PROGRESS"
            then do:

               qad-recno = recid(qadwkfl).

               find qadwkfl exclusive-lock
               where recid(qadwkfl) = qad-recno
               no-wait no-error.

               if available qadwkfl
               then do:
                  delete qadwkfl.
                  next.
               end. /* IF AVAILABLE qadwkfl   */
            end.  /* IF DBTYPE("qaddb") = ... */

            hide message no-pause.
            /*Waiting for synchronized calculation to reach level*/
            {pxmsg.i &MSGNUM=972 &ERRORLEVEL=1
               &MSGARG1="string(low_level) + '.'"}

            repeat:
               pause 2 no-message.
               leave.
            end. /* REPEAT */

            /*Current/maximum level: */
            {pxmsg.i &MSGNUM=1106 &ERRORLEVEL=1
                  &MSGARG1="string(low_level) + ' / ' + string(max_level)"}

         end.


         create tt_rep.
         assign tt_rep.tt_part = in_part
                tt_rep.tt_site = in_site.

/* ss 20071105 */
/*
         {gprunp.i "mrppl" "p" "gpmpup01"
*/
         {gprunp.i "xxmrppl" "p" "gpmpup01"
                                "(input tt_part, input tt_site,
                                input-output increment,
                                output tt_orders, output tt_time,
                                output tt_desc, output tt_mrpyn)"}
/* ss 20071105 */
         if tt_mrpyn
     then do:
            assign req-tot = req-tot + 1
                   mrppl-tot = mrppl-tot + 1
                   part_orders = tt_rep.tt_orders
                   numorders = numorders + part_orders.
         end.
     else
        delete tt_rep.
    
         if oracle-db and mrppl-tot > max-requests then do:
         {gpdelp.i "mrppl" "p"}
         assign mrppl-tot = 0.
         end.

         if audit and time <> last-time then
            run disptot.
      end.
      else do:

         create tt_req_sub.

         assign tt_req_sub.tt_part = in_part
                tt_req_sub.tt_site = in_site
                tt_req_sub.tt_inc = increment
                req-sub-count = req-sub-count + 1.

         /* Could not pass the standards checker with out this */
         /* Even if it is a temp table */

         if recid(tt_req_sub) = -1 then .

         if req-sub-count < temp-table-depth then next blocka.

         {mtrun.i &data=in_part &info=in_site}
         {gprun.i ""gpmpup04.p""
             "(input-output table tt_req_sub)"
             "on tt_thread_handle asynchronous set tt_request_handle
              event-procedure 'mtthreadisdone'"}

         empty temp-table tt_req_sub.
         assign tt_num_requests = tt_num_requests + req-sub-count
        req-sub-count = 0.

         if oracle-db and
        can-find(first tt_threads where tt_num_requests > max-requests)
        then do:

            {mtwait.i}
        run delproc.

            for each tt_threads exclusive-lock:

               {gprun.i ""gpmpup02.p""
                "(frwrd, bck, horizon, reldays, drp, mrp, ms, non_ms, buyer,
                  vendor, pm_code, prod_line, ptgroup, part_type,
              tt_threads.tt_thread)"
                "on tt_thread_handle"}

            assign tt_num_requests = 0.
            end.
         end.

      end.

   end. /* REPEAT */

   find first tt_req_sub no-lock no-error.

   if available(tt_req_sub) then do:

         {mtrun.i &data=tt_req_sub.tt_part &info=tt_req_sub.tt_site}
         {gprun.i ""gpmpup04.p""
             "(input-output table tt_req_sub)"
             "on tt_thread_handle asynchronous set tt_request_handle
              event-procedure 'mtthreadisdone'"}

         empty temp-table tt_req_sub.
         assign tt_num_requests = tt_num_requests + req-sub-count
                req-sub-count = 0.

   end.
   {mtwait.i}
   run writereport.

end. /* DO low_level = min_level TO max_level */

hide message no-pause.

/* Delete the qad_wkfl record used by this calculation to
register its calculation activity */
do transaction:
   find first qad_wkfl exclusive-lock
       where qad_wkfl.qad_domain = global_domain and  qad_wkfl.qad_key3 =
       qadmrpkey
        and qad_wkfl.qad_key4 = mfguser no-error.
   if available qad_wkfl
   then
      delete qad_wkfl.
end.  /* DO TRANSACATION */

assign elapsed = (today - start_date[1]) * 86400 + time - start_time[1]
       z = req-tot.

display stream log
   string(start_date[1]) + " " +
   string(start_time[1],"HH:MM:SS AM")
   @ started
   z numorders
   string(truncate((elapsed / 3600),0),">>9:")
   + string(truncate(((elapsed -
   truncate((elapsed / 3600),0) * 3600) / 60),0),"99:")
   + string(((elapsed -
   truncate((elapsed / 60),0) * 60)),"99") format "x(9)"
   @ elapsed
   string(today) + " " +
   string(start_time[1] + elapsed,"HH:MM:SS AM")
   @ stopped
with frame log-audit.

if audit
then do with frame audit:
   display stream audit
      string(truncate((elapsed / 3600),0),">>9:")
      + string(truncate(((elapsed -
      truncate((elapsed / 3600),0) * 3600) / 60),0),"99:")
      + string(((elapsed -
      truncate((elapsed / 60),0) * 60)),"99") format "x(9)"
      @ elapsed
      string(today) + " " +
      string(start_time[1] + elapsed,"HH:MM:SS AM")
      @ stopped.
end. /* IF audit THEN DO WITH ... */

output stream audit close.

if apps_threads > 0 then
   run delproc.
else do:

/* ss 20071105 - b */
/*
   {gpdelp.i "mrppl" "p"}
*/
   {gpdelp.i "xxmrppl" "p"}
/* ss 20071105 - e */

end.

{mtclean.i}

/* In case we flipped it internally in this subroutine */
mrp_req = save_mrp_req.

hide frame audit no-pause.

/******************************************************************/

/*   I N T E R N A L    P R O C E D U R E S     */

/******************************************************************/

PROCEDURE mtthreadisdone:

/* Event Procedure for Async AppServer call */

define input parameter table for tt_back.

    find first tt_req where tt_request_handle = self
                        exclusive-lock no-error.
    find first tt_threads where tt_threads.tt_thread = tt_req.tt_thread
                            exclusive-lock no-error.

    assign tt_threads.tt_depth = tt_threads.tt_depth - 1
           tt_isdone = yes.

    if self:error or self:stop then do:
      /*An error occurred with an AppServer request*/
      {pxmsg.i &MSGNUM=5272 &ERRORLEVEL=3}
      return.
    end.

    for each tt_back:
        if tt_back.tt_mrpyn = no
        then
       next.
        assign increment = max(tt_inc,increment)
               req-tot = req-tot + 1
               part_orders = tt_back.tt_orders
               numorders = numorders + part_orders.

        create tt_rep.
        assign tt_rep.tt_part = tt_back.tt_part
               tt_rep.tt_site = tt_back.tt_site
               tt_rep.tt_desc = tt_back.tt_desc
               tt_rep.tt_order = tt_back.tt_orders
               tt_rep.tt_time = tt_back.tt_etime
               tt_rep.tt_mrpyn = tt_back.tt_mrpyn.

    end.

    if audit and time <> last-time then
       run disptot.

empty temp-table tt_back.

END PROCEDURE.


PROCEDURE writereport:

/* Procedure that writes the report after each level */

define variable tot-parts as integer no-undo.
define variable tot-planned as integer no-undo.

   for each tt_rep no-lock:

       assign item-count = item-count + 1
              tot-parts = tot-parts + 1
              tot-planned = tot-planned + tt_orders.

       display stream log
          item-count @ z1
          tt_site @ in_mstr.in_site
          tt_part @ pt_mstr.pt_part
          tt_desc @ pt_mstr.pt_desc1 format "x(19)"
          low_level @ in_mstr.in_level
          tt_orders @ part_orders
          tt_time @ elapsed
          getTermLabel("MILLISECONDS",2)
          with frame log down no-attr-space width 132.

       if page-size(log) - line-counter(log) = 0 then page stream log.
       else down stream log 1 with frame log.


   end.

   display stream log
         "(" + string(tot-parts) + ")" @ in_mstr.in_site
         "*** " + caps(getTermLabel("SUBTOTAL",10)) + " ***" @ pt_mstr.pt_part
         tot-planned @ pt_mstr.pt_desc1
         low_level @ in_mstr.in_level

         string(truncate ((elapsed / 3600),0),">>9:")
         + string(truncate (((elapsed -
         truncate
         ((elapsed / 3600),0) * 3600) / 60),0),"99:")
         + string(((elapsed -
         truncate ((elapsed / 60),0) * 60)),"99")
         format "x(9)" @ elapsed
         with frame log no-attr-space.

   if page-size(log) - line-counter(log) = 0 then page stream log.
      else down stream log 1 with frame log.


   empty temp-table tt_rep.
END PROCEDURE.


PROCEDURE disptot:

/* Procedure that displays the status on the screen */

   if audit = no then return.

   assign last-time = time
          elapsed = (today - start_date[1]) * 86400 + time - start_time[1].

   display stream audit
          req-tot @ z
          numorders @ numorders
          string(truncate ((elapsed / 3600),0),">>9:")
          + string(truncate (((elapsed -
          truncate ((elapsed / 3600),0) * 3600) / 60),0),"99:")
          + string(((elapsed -
          truncate ((elapsed / 60),0) * 60)),"99") format "x(9)"
          @ elapsed
       with frame audit width 80 no-attr-space.


END PROCEDURE.


PROCEDURE delproc:

/* This procedure runs gpmpup03.p on the AppServer to delete the persistent */
/* procedure mrppl.p */

   for each tt_threads exclusive-lock:
      {gprun.i ""gpmpup03.p"" "on tt_thread_handle"}
   end.


END PROCEDURE.
