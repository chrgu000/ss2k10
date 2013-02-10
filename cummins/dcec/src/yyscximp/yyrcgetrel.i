/* GUI CONVERTED from yyrcgetrel.i (converter v1.78) Thu Dec  6 14:46:56 2012 */
/* rcgetrel.i - Release Management Customer Schedules                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.12 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92      BY: WUG *G462*               */
/* REVISION: 7.3    LAST MODIFIED: 05/06/93      BY: WUG *GA72*               */
/* REVISION: 7.3    LAST MODIFIED: 06/21/93      BY: WUG *GC53*               */
/* REVISION: 7.3    LAST MODIFIED: 11/01/94      BY: ame *GN84*               */
/* REVISION: 7.4    LAST MODIFIED: 12/29/97      BY: jpm *H1HV*               */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98      BY: *K1Q4* Alfred Tan        */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00      BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00      BY: *N0KP* Mark Brown        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.4.1.3       BY: Jean Miller         DATE: 03/22/01 ECO: *P008* */
/* Revision: 1.4.1.4       BY: Jean Miller         DATE: 02/28/02 ECO: *N1BB* */
/* Revision: 1.4.1.8       BY: Patrick Rowan       DATE: 04/11/02 ECO: *P05G* */
/* Revision: 1.4.1.10      BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00K* */
/* Revision: 1.4.1.11      BY: Deepali Kotavadekar DATE: 08/04/03 ECO: *N2GJ* */
/* $Revision: 1.4.1.12 $   BY: Mercy Chittilapilly DATE: 10/21/03 ECO: *N2KL* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DEFAULTING THE ACTIVE RELEASE ID AS THE LOOKUP ON RELEASE ID    */
/* FIELD WAS NOT FUNCTIONING CORRECTLY IN DESKTOP 2 WITH THE LOGIC */
/* OF PATCH N2DB. ALSO, REMOVED THE LOGIC PERTAINING TO GLOBAL     */
/* VARIABLES (global_site) INTRODUCED BY PATCH N2GJ                */

define variable l_sch_rlseid like sch_rlse_id no-undo.

/* GETS A SCHEDULED ORDER SCHEDULE RECORD (sch_mstr) */

find sod_det  where sod_det.sod_domain = global_domain and
     sod_nbr = scx_order and
     sod_line = scx_line
exclusive-lock no-error.

find so_mstr  where so_mstr.so_domain = global_domain and  so_nbr = sod_nbr
no-lock no-error.

/* FOR PASSING PARAMETER VALUES TO LOOKUP IN DT2 ENVIRONMENT */
/* RECOMMENDED GLOBAL VARIABLES ARE TO BE USED INSTEAD OF    */
/* DEFINING NEW SHARED VARIABLES.                            */
/* IN DT2 ENVIRONMENT, THE MAPPING FOR GLOBAL VARIABLES      */
/* ARE LIMITED, HENCE WE NEED TO USE THE GLOBAL VARIABLE     */
/* global_site FOR SCHEDULE RELEASE TYPE.                    */
assign
   sod_psd_pat    = substring(sod_sch_data,1,2)
   sod_psd_time   = substring(sod_sch_data,3,2)
   sod_ssd_pat    = substring(sod_sch_data,5,2)
   sod_ssd_time   = substring(sod_sch_data,7,2)
   sodcmmts       = (sod_cmtindx <> 0 or (new sod_det and soc_lcmmts))
   so_cumulative  = (substring(so_conrep,14,1) = "y")
   global_schtype = schtype.

{gpbrparm.i &browse=gplu544.p &parm=c-brparm3 &val="string(global_schtype)"}

run get_active_rlseid(output l_sch_rlseid).

display l_sch_rlseid @ sch_rlse_id with frame a.

do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


   prompt-for
      sch_rlse_id
   with frame a no-validate editing:

      {mfnp05.i sch_mstr sch_tnlr
         " sch_mstr.sch_domain = global_domain and sch_type  = schtype and
         sch_nbr = scx_order
                and sch_line = scx_line"
         sch_rlse_id "input sch_rlse_id"}

      if recno <> ? then do:
         display
            sch_rlse_id
         with frame a.
      end.

   end. /* prompt-for */

   if input sch_rlse_id = "" then do:

      if can-find(sch_mstr  where sch_mstr.sch_domain = global_domain and
                  sch_type = schtype and
                  sch_nbr = scx_order and
                  sch_line = scx_line and
                  sch_rlse_id = sod_curr_rlse_id[schtype])
      then do:
         display
            sod_curr_rlse_id[schtype] @ sch_rlse_id
         with frame a.
      end.

      else do:
         /* NO ACTIVE SCHED EXISTS, ENTRY REQRD */
         {pxmsg.i &MSGNUM=8107 &ERRORLEVEL=3}
         undo, retry.
      end.

   end. /* if input sch_rlse_id = "" */

   find sch_mstr  where sch_mstr.sch_domain = global_domain and
        sch_type = schtype
    and sch_nbr = scx_order
    and sch_line = scx_line
    and sch_rlse_id = input sch_rlse_id
   exclusive-lock no-error.

   if available sch_mstr then do:
      if sch_rlse_id <> sod_curr_rlse_id[schtype] then do:
         if sod_curr_rlse_id[schtype] <> "" then do:
            /* NO ACTIVE RELEASE, ACTIVE RELEASE IS */
            {pxmsg.i &MSGNUM=6005 &ERRORLEVEL=2
                     &MSGARG1=sod_curr_rlse_id[schtype]}
         end.
      end.
      else do:
         /* MODIFYING THE ACTIVE SCHED RELEASE */
         {pxmsg.i &MSGNUM=6006 &ERRORLEVEL=1}
      end.
   end. /* if available sch_mstr */

   else do:

      /* Adding new record */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

      create sch_mstr. sch_mstr.sch_domain = global_domain.
      assign
         sch_type = schtype
         sch_nbr = scx_order
         sch_line = scx_line
         sch_rlse_id.

      if recid(sch_mstr) = -1 then .

      /* PICK UP SOME DATA ITEMS FROM PRIOR SCHEDULE */
      if sod_curr_rlse_id[schtype] > "" then do:

         /* COPY DATA FROM ACTIVE SCHEDULE? */
         if batchrun then do:
         	  assign yn = no.
         end.
         else do:
         		{pxmsg.i &MSGNUM=6007 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}
				 end.
         if yn then do for prev_sch_mstr:

            find prev_sch_mstr  where prev_sch_mstr.sch_domain = global_domain
            and
                      sch_type = sch_mstr.sch_type
                  and sch_nbr = sch_mstr.sch_nbr
                  and sch_line = sch_mstr.sch_line
                  and sch_rlse_id = sod_curr_rlse_id[schtype]
            no-lock.

            {gprun.i ""rcsinit.p""
               "(input recid(prev_sch_mstr),
                 input recid(sch_mstr),
                 input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* if yn then do */

      end. /* if sod_curr_rlse */

      assign
         sch_cr_date = today
         sch_cr_time = time
         sch_ship = so_ship
         sch_eff_start = today
         sch_eff_end = ?
         sch_cumulative = so_cumulative
         sch_sd_pat  = if sch_type = 1 then
                          sod_psd_pat
                       else if sch_type = 2 then
                          sod_ssd_pat
                       else ""
         sch_sd_time = if sch_type = 1 then
                          sod_psd_time
                       else if sch_type = 2 then
                          sod_ssd_time
                       else "".

   end. /* else do (ADDING NEW REC) */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo */

/* GET ACTIVE RELEASE ID */
PROCEDURE get_active_rlseid:

   define buffer soddet  for sod_det.
   define buffer schmstr for sch_mstr.

   define output parameter o_sch_rlseid like sch_rlse_id no-undo.

   for first soddet
      where soddet.sod_domain  = global_domain
      and   soddet.sod_nbr     = l_order
      and   soddet.sod_line    = l_line
      no-lock:

      for first schmstr
         where schmstr.sch_domain  = global_domain
         and   schmstr.sch_type    = global_schtype
         and   schmstr.sch_nbr     = l_order
         and   schmstr.sch_line    = l_line
         and   schmstr.sch_rlse_id = soddet.sod_curr_rlse_id[global_schtype]
         no-lock:

         o_sch_rlseid = schmstr.sch_rlse_id.

      end. /* FOR FIRST schmstr */

   end. /* FOR FIRST soddet */

END PROCEDURE.
