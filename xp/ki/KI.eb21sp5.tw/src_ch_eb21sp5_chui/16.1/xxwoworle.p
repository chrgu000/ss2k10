/* woworle.p - SCHEDULE WORK ORDER OPERATIONS                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0     LAST MODIFIED: 06/18/86    BY: EMB                       */
/* REVISION: 2.0     LAST MODIFIED: 09/01/87    BY: EMB *A85*                 */
/* REVISION: 4.0     LAST MODIFIED: 01/05/89    BY: EMB *A584*                */
/* REVISION: 5.0     LAST MODIFIED: 01/23/90    BY: EMB *B527*                */
/* REVISION: 6.0     LAST MODIFIED: 05/11/90    BY: RAM *D018*                */
/* REVISION: 7.0     LAST MODIFIED: 04/03/92    BY: RAM *F355*                */
/* REVISION: 7.0     LAST MODIFIED: 05/24/95    BY: qzl *F0S4*                */
/* REVISION: 7.4     LAST MODIFIED: 12/20/97    BY: *H1HK* Felcy D'Souza      */
/* REVISION: 8.6     LAST MODIFIED: 02/27/98    BY: *J23R* Santhosh Nair      */
/* REVISION: 8.6E    LAST MODIFIED: 08/05/98    BY: *H1H4* Dana Tunstall      */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11  BY: Manisha Sawant DATE: 04/03/01 ECO: *P008* */
/* $Revision: 1.13 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */


/* xxwoworle.p - SCHEDULE WORK ORDER OPERATIONS                         */
/* 1. If wo_rel_date = ? or calculate_rel_date then find ptp_det         */
/*    if avail ptp_det and ptp_mfg_lead <> 0 then rel_date = due - MfgLT */
/*    else wo_rel_date = wo_due_date, warning message will be prompted   */
/* REVISION: 8.5     LAST MODIFIED: 03/18/03    BY: hkm *030318*         */
/* 1. If rel_dt = ?, wo_rel_date = input wo_due_date - (ptp_fmg_lead + 1)*/



/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090917.1  By: Roger Xiao */ /*把85g挪到eb21,逻辑不变*/


/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define new shared variable last_due as date.
define new shared variable last_op like wr_op.
define new shared variable allow_queue as integer.

define shared variable wo_recno as recid.

define new shared temp-table temp-wr_route no-undo like wr_route
   use-index wr_lot.

define variable any-routings like mfc_logical initial no no-undo.
define variable leadtime     like pt_mfg_lead no-undo.
/* SS - 090917.1 - B */
define variable cal-rel-date as logical initial no.
/* SS - 090917.1 - E */

{mfdatev.i}

for first wo_mstr
fields( wo_domain wo_due_date wo_lot wo_rel_date wo_part wo_site)
where recid(wo_mstr) = wo_recno no-lock:
end.

if not available wo_mstr then
   leave.

assign
   allow_queue = 1
   last_op = 999999.

for each wr_route
fields( wr_domain wr_lot wr_op wr_status)
no-lock  where wr_route.wr_domain = global_domain and  wr_lot = wo_lot
by wr_lot descending by wr_op descending:

   any-routings = yes.

   if wr_status = "C" then
      leave.
   last_op = wr_op.

end.

/* IF THE ORDER HAS NO ROUTING RECORDS AND EITHER THE RELEASE   */
/* OR THE DUE DATE IS UNKNOWN, THE SPREAD IS CALCULATED BETWEEN */
/* THE RELEASE AND DUE DATE BY USING THE MANUFACTURING LEAD TIME*/
/* OF THE ITEM/SITE INSTEAD OF SCHEDULING THE OPERATIONS.       */

if any-routings = no and
   (wo_rel_date = ? or wo_due_date = ?)
then do:

   for first ptp_det
   fields( ptp_domain ptp_mfg_lead ptp_part ptp_site)
    where ptp_det.ptp_domain = global_domain and  ptp_part = wo_part
     and ptp_site = wo_site
   no-lock: end.

   if available ptp_det then
      leadtime = ptp_mfg_lead.

   else do:

      for first pt_mstr
      fields( pt_domain pt_mfg_lead pt_part)
       where pt_mstr.pt_domain = global_domain and  pt_part = wo_part no-lock:
      end.

      if available pt_mstr then
         leadtime = pt_mfg_lead.

   end. /* IF NOT AVAILABLE ptp_det */

/* SS - 090917.1 - B */
    if wo_rel_date = ? then cal-rel-date = yes.
/* SS - 090917.1 - E */
   {mfdate.i wo_rel_date wo_due_date leadtime wo_site}

end. /*IF any-routings */

/* INSTEAD OF RESCHEDULING THE DB TABLES THEMSELVES,        */
/* CREATE TEMP-TABLE IMAGES OF wr_route FOR THE SCHEDULING  */
/* SUBROUTINES TO WORK AGAINST.  WHEN DONE, THE DB TABLES   */
/* WILL NEED TO BE RE-SYNCHRONIZED AGAINST THE RESCHEDULED  */
/* TEMP-TABLES (IN woworleb.p).                             */
if any-routings = yes then do:
   {gprun.i ""woworlea.p"" "(input wo_lot)"}
end.

if wo_due_date <> ? then do:

   last_due = wo_due_date.

   /* SCHEDULE BACKWARDS FROM WORK ORDER DUE DATE */
   {gprun.i ""woworle1.p""
      "(input wo_lot,
        input wo_site,
        input last_op,
        input-output last_due)"}

/* SS - 090917.1 - B 
   if wo_rel_date = ? then
      wo_rel_date = last_due.
   SS - 090917.1 - E */
/* SS - 090917.1 - B */
   if wo_rel_date = ? or cal-rel-date = yes then do:
        find first ptp_det no-lock where ptp_part = wo_part 
                           and ptp_site = wo_site no-error.
        if available ptp_det then do:
          if ptp_mfg_lead <> 0 then
               wo_rel_date = wo_due_date - ptp_mfg_lead - 1.
          else do:
             message "警告: 料品-厂别计划前置时间不存在 - 在1.4.17中设定.".
             pause.
             wo_rel_date = wo_due_date.
          end.
        end.
        else do:
           message "警告: 料品-厂别计划记录不存在 - 在1.4.17中设定.". 
           pause.
           wo_rel_date = wo_due_date.
        end.
   end.
/* SS - 090917.1 - E */
end.
else do:

   last_due = wo_rel_date.

   /* SCHEDULE FORWARDS FROM WORK ORDER RELEASE DATE */
   {gprun.i ""woworle2.p""
      "(input wo_lot,
        input wo_site,
        input last_op,
        input-output last_due)"}

   if wo_due_date = ? then
      wo_due_date = last_due.

end.

/* RE-SYNCHRONIZE THE DB TABLES AGAINST THE RESCHEDULED TEMP-TABLES. */
if any-routings = yes then do:
   {gprun.i ""woworleb.p"" "(input wo_lot)"}
end.
