/* rsgetrel.i - Release Management Supplier Schedules                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.9 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92           BY: WUG *G462*          */
/* REVISION: 7.3    LAST MODIFIED: 05/06/93           BY: WUG *GA72*          */
/* REVISION: 7.3    LAST MODIFIED: 06/21/93           BY: WUG *GC53*          */
/* REVISION: 7.3    LAST MODIFIED: 11/01/94           BY: ame *GN88*          */
/* REVISION: 7.4    LAST MODIFIED: 12/29/97           BY: jpm *H1HV*          */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98           BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* Mark Brown         */
/* REVISION: 9.1    LAST MODIFIED: 08/29/00     BY: *N0PM* Arul Victoria      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.4.1.5       BY: Jean Miller         DATE: 02/27/02 ECO: *N1BB* */
/* Revision: 1.4.1.6       BY: Deirdre O'Brien     DATE: 10/18/02 ECO: *N13P* */
/* Revision: 1.4.1.8       BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.4.1.9 $     BY: Mercy Chittilapilly DATE: 10/21/03 ECO: *N2KL* */

/*-Revision end---------------------------------------------------------------*/

/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* GETS A SCHEDULED ORDER SCHEDULE RECORD (sch_mstr) */
/* {1}="poApi" indicating that this file is being called in poApi mode */

define variable c-msgarg     as   character   no-undo.
define variable l_sch_rlseid like sch_rlse_id no-undo.

for first pod_det  where pod_det.pod_domain = global_domain and  pod_nbr =
scx_order
   and pod_line = scx_line
   exclusive-lock:
end.

for first po_mstr  where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
   no-lock:
end.

global_schtype = schtype.
{gpbrparm.i &browse=gplu539.p &parm=c-brparm3 &val="string(global_schtype)"}

run get_active_rlseid(output l_sch_rlseid).

if c-application-mode <> "API" then
display l_sch_rlseid @ sch_rlse_id with frame a.

do on error undo, retry:
   /* Do not retry when processing API request */
   if retry and c-application-mode = "API" then
      undo, return error.

   if c-application-mode <> "API" then
   do:
      prompt-for sch_rlse_id with frame a no-validate editing:
         {mfnp05.i sch_mstr sch_tnlr
         " sch_mstr.sch_domain = global_domain and sch_type  = schtype and
         sch_nbr = scx_order
         and sch_line = scx_line"
         sch_rlse_id "input sch_rlse_id"}

         if recno <> ? then do:
            display sch_rlse_id with frame a.
         end.
      end. /* prompt-for */
   end.        /*if c-application-mode <> "API" */

   if c-application-mode <> "API" and input sch_rlse_id = "" then do:
      if can-find(sch_mstr  where sch_mstr.sch_domain = global_domain and
                  sch_type = schtype and
                  sch_nbr = scx_order and
                  sch_line = scx_line and
                  sch_rlse_id = pod_curr_rlse_id[schtype - 3])
      then do:
         display
            pod_curr_rlse_id[schtype - 3] @ sch_rlse_id
         with frame a.
      end.
      else do:
         /* NO ACTIVE SCHED EXISTS, ENTRY REQRD */
         {pxmsg.i &MSGNUM=8175 &ERRORLEVEL=3}
         if c-application-mode <> "API" then do:
            bell.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else
            undo ,return error.
      end.
   end. /* if input sch_rlse_id = "" */

   if c-application-mode <> "API" then
      for first sch_mstr  where sch_mstr.sch_domain = global_domain and
         sch_type = schtype
         and sch_nbr = scx_order
         and sch_line = scx_line
         and sch_rlse_id = input sch_rlse_id
         exclusive-lock:
      end.
   else do:
      &IF "{1}" = "poApi" &THEN
         for first sch_mstr  where sch_mstr.sch_domain = global_domain and
            sch_type = schtype
            and sch_nbr = scx_order
            and sch_line = scx_line
            and sch_rlse_id = ttScheduleOrder.rlseId
            exclusive-lock:
         end.
      &ENDIF
   end. /* c-application-mode <> "API" */

   if available sch_mstr then do:
      if sch_rlse_id <> pod_curr_rlse_id[schtype - 3] then do:
         if pod_curr_rlse_id[schtype - 3] <> "" then do:
            c-msgarg = pod_curr_rlse_id[schtype - 3].
            /* NO ACTIVE RELEASE, ACTIVE RELEASE IS */
            {pxmsg.i &MSGNUM=6005 &ERRORLEVEL=2 &MSGARG1=c-msgarg}
         end.
      end.
      else do:
         /* MODIFYING THE ACTIVE SCHED RELEASE */
         {pxmsg.i &MSGNUM=6006 &ERRORLEVEL=1}
      end.
   end. /* if available sch_mstr */
   else do:

      /* ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

      create sch_mstr. sch_mstr.sch_domain = global_domain.
      assign
         sch_type = schtype
         sch_nbr = scx_order
         sch_line = scx_line.

      if c-application-mode <> "API" then do:
         assign sch_rlse_id.
      end. /* c-application-mode <> "API" */
      else do:
         &IF "{1}" = "poApi" &THEN
            assign sch_rlse_id = ttScheduleOrder.rlseId.
         &ENDIF
      end. /* c-application-mode = "API" */

      if recid(sch_mstr) = -1 then .
			yn = no.
      /* PICK UP SOME DATA ITEMS FROM PRIOR SCHEDULE */
      if pod_curr_rlse_id[schtype - 3] > "" then do:
         if c-application-mode <> "API" then do:
            /* COPY DATA FROM ACTIVE SCHEDULE? 
            {pxmsg.i &MSGNUM=6007 &ERRORLEVEL=1 &CONFIRM=yn}
            */
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            yn = no.

         if yn then do for prev_sch_mstr:
            for first prev_sch_mstr  where prev_sch_mstr.sch_domain =
            global_domain and
               sch_type = sch_mstr.sch_type
               and sch_nbr = sch_mstr.sch_nbr
               and sch_line = sch_mstr.sch_line
               and sch_rlse_id = pod_curr_rlse_id[schtype - 3]
               no-lock:
            end.

            /* ss lambert 20101108.1 */
            /*
            {gprun.i ""rcsinit.p""
            "(input recid(prev_sch_mstr),
              input recid(sch_mstr),
              input yes)"}
              */
            {gprun.i ""xxrcsinit.p""
            "(input recid(prev_sch_mstr),
              input recid(sch_mstr),
              input yes)"}
            /* ss lambert 20101108.1 */
         end. /* if yn then do */
      end. /* if pod_curr_rlse */

      assign
         sch_cr_date = today
         sch_cr_time = time
         sch_ship = po_ship
         sch_eff_start = today
         sch_eff_end = ?
         sch_sd_pat = pod_sd_pat.

   end. /* else do (ADDING NEW REC) */

end. /* do on error undo */

/* GET ACTIVE RELEASE ID */
PROCEDURE get_active_rlseid:

   define buffer poddet  for pod_det.
   define buffer schmstr for sch_mstr.

   define output parameter o_sch_rlseid like sch_rlse_id no-undo.

   for first poddet
      where poddet.pod_domain = global_domain
      and   poddet.pod_nbr    = global_order
      and   poddet.pod_line   = global_line
      no-lock:

      for first schmstr
         where schmstr.sch_domain  = global_domain
         and   schmstr.sch_type    = global_schtype
         and   schmstr.sch_nbr     = poddet.pod_nbr
         and   schmstr.sch_line    = poddet.pod_line
         and   schmstr.sch_rlse_id
                               = poddet.pod_curr_rlse_id[schmstr.sch_type - 3]
         no-lock:

         o_sch_rlseid = schmstr.sch_rlse_id.

      end. /* FOR FIRST schmstr */

   end. /* FOR FIRST poddet */

END PROCEDURE.
