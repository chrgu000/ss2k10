/* sosle01.p - CREATE TEMP RECORDS FOR STAGE LIST                             */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.5      LAST MODIFIED: 01/02/96         BY: GWM *J049*          */
/* REVISION: 8.5      LAST MODIFIED: 04/17/96         BY: mzh *J0JH*          */
/* REVISION: 8.5      LAST MODIFIED: 07/03/96         BY: GWM *J0XM*          */
/* REVISION: 8.5      LAST MODIFIED: 11/15/96         BY: vrn *K003*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dana Tunstall      */
/* REVISION: 9.1      LAST MODIFIED: 06/15/99   BY: *N004* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0K6* Rajinder Kamra     */
/* Revision: 1.8.3.4  BY: Kirti Desai        DATE: 05/22/01 ECO: *N0Y4* */
/* Revision: 1.8.3.6  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.8.3.7  BY: Rajinder Kamra     DATE: 06/23/03  ECO *Q003*  */
/* $Revision: 1.8.3.7.1.1 $ BY: Mochesh Chandran   DATE: 04/10/07  ECO *P5FK*  */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=NoConvert                                              */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* INPUT PARAMETERS */
define input parameter alc_nbr like sod_nbr.
define input parameter alc_line like sod_line.
define input parameter alloc_cont as logical.
define input parameter so_db like si_db.
define input parameter shipgrp like sg_grp no-undo.
define input parameter inv_mov like abs_inv_mov no-undo.
define input parameter nrseq like abs_preship_nr_id no-undo.
define input parameter cons_ship like abs_cons_ship no-undo.
define input parameter l_create_um like mfc_logical  no-undo.

/* OUTPUT PARAMETERS */
define output parameter tot_qty_all like lad_qty_all.
define output parameter abnormal_exit as logical.

/* LOCAL VARIABLES */
define variable err_flag as integer no-undo.
define variable qty_all like lad_qty_all no-undo.
define variable alt_found as logical no-undo.
define variable i as integer no-undo.
define variable site_db like si_db no-undo.
define variable qty_um like pt_um no-undo.
define variable l_um_conv like sod_um_conv no-undo.

/* SHARED VARIABLES FOR CUSTOMER SEQUENCE SCHEDULES */
{sosqvars.i}

/* BUFFERS */
define buffer ship_line for abs_mstr.

{sotmpdef.i}

/* WORKFILES */
define workfile wkfl_lad like lad_det.

site_db = global_db.

find sod_det  where sod_det.sod_domain = global_domain and  alc_nbr = sod_nbr
   and alc_line = sod_line no-lock.

find so_mstr  where so_mstr.so_domain = global_domain and  so_nbr = sod_nbr
no-lock.

/*FIND NEW ALLOCATION DETAIL*/
ALLOC_LINE:
for each lad_det  where lad_det.lad_domain = global_domain and  lad_dataset =
"sod_det"
      and lad_nbr = alc_nbr
      and integer(lad_line) = alc_line exclusive-lock:

   /* t_all_data ALREADY CREATED IN sopkall.i FOR PARTIAL DETAIL */
   /* ALLOCATIONS HENCE DO NOT RECREATE                          */

   if not can-find(first t_all_data
      where t_sod_nbr     = sod_nbr
        and t_sod_line    = sod_line
        and t_lad_dataset = lad_dataset
        and t_lad_site    = lad_site
        and t_lad_loc     = lad_loc
        and t_lad_lot     = lad_lot
        and t_lad_ref     = lad_ref
        and t_lad_part    = lad_part)
   then do:

      /* t_ld_all IS NOT POPULATED AS ALLOCATED QUANTITIES ARE */
      /* ALREADY REFLECTED IN ld_qty_all                       */

      create t_all_data.
      assign
         t_sod_nbr     = sod_nbr
         t_sod_line    = sod_line
         t_sod_all     = sod_qty_all
         t_sod_pick    = sod_qty_pick
         t_lad_dataset = lad_dataset
         t_lad_site    = lad_site
         t_lad_loc     = lad_loc
         t_lad_lot     = lad_lot
         t_lad_ref     = lad_ref
         t_lad_part    = lad_part
         t_lad_all     = lad_qty_all
         t_lad_pick    = lad_qty_pick
         t_det_all     = yes.

   end. /* IF NOT CAN-FIND(FIRST t_all_data ... */

   assign
      qty_all      = lad_qty_all
      lad_qty_pick = lad_qty_pick + lad_qty_all
      tot_qty_all  = tot_qty_all + lad_qty_all
      lad_qty_all  = 0.

   /* MOVE LAD_DET DATA TO WORKFILE TO ACCOMODATE MULTI DOMAIN */

   find first wkfl_lad  where wkfl_lad.lad_domain = global_domain no-error.
   if not available wkfl_lad then do:  create wkfl_lad. wkfl_lad.lad_domain =
   global_domain. end.
   if recid(wkfl_lad) = -1 then.
   assign
      wkfl_lad.lad_line = lad_det.lad_line
      wkfl_lad.lad_loc  = lad_det.lad_loc
      wkfl_lad.lad_lot  = lad_det.lad_lot
      wkfl_lad.lad_nbr  = lad_det.lad_nbr
      wkfl_lad.lad_part = lad_det.lad_part
      wkfl_lad.lad_ref  = lad_det.lad_ref
      wkfl_lad.lad_site = lad_det.lad_site.

   {gprun.i ""gpalias3.p""
      "(input so_db,
        output err_flag)"}

   if err_flag <> 0 and err_flag <> 9 then do:

      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i
         &MSGNUM     = 6137
         &ERRORLEVEL = 4
         &MSGARG1    = getTermLabel(""FOR_SALES_ORDERS"",25)
         }
      abnormal_exit = true.
      return.

   end.

   /* ALLOCATE CONTAINERS */

   if alloc_cont then do:

      /* Added shipgrp, inv_mov, nrseq, cons_ship */
      {gprun.i ""sosle02.p""
         "(input wkfl_lad.lad_site,
           input wkfl_lad.lad_part,
           input wkfl_lad.lad_loc,
           input wkfl_lad.lad_lot,
           input wkfl_lad.lad_ref,
           input wkfl_lad.lad_nbr,
           input wkfl_lad.lad_line,
           input shipgrp,
           input inv_mov,
           input nrseq,
           input cons_ship,
           input-output qty_all)"}
   end.

   /* ALLOCATE LOOSE PIECES */
   if qty_all > 0 then do:

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wkfl_lad.lad_part no-lock no-error.
      l_um_conv =  1.
      if l_create_um then
      assign
         qty_um    = sod_um
         l_um_conv = sod_um_conv.
      else
         if available pt_mstr then qty_um = pt_um.

      else qty_um = sod_um.

      /* Added shipgrp, inv_mov, nrseq, cons_ship, sod_site */
      /* CHANGED INPUT UM CONVERSION FROM 1 TO L_UM_CONV */
      {gprun.i ""sosle03.p""
         "(input mfguser + global_db + 'stage_list',
           input wkfl_lad.lad_nbr + wkfl_lad.lad_line +
                 wkfl_lad.lad_loc +
                 wkfl_lad.lad_lot + wkfl_lad.lad_ref,
           input qty_all,
           input wkfl_lad.lad_site,
           input wkfl_lad.lad_part,
           input wkfl_lad.lad_loc,
           input wkfl_lad.lad_lot,
           input wkfl_lad.lad_ref,
           input so_ship,
           input wkfl_lad.lad_nbr,
           input string(wkfl_lad.lad_line,'9999'),
           input '',
           input qty_um,
           input l_um_conv,
           input shipgrp,
           input inv_mov,
           input nrseq,
           input cons_ship,
           input sod_site)"}

   end.

   /* SWITCH TO THE SITE DOMAIN */
   {gprun.i ""gpalias3.p""
      "(input site_db,
        output err_flag)"}

   if err_flag <> 0 and err_flag <> 9 then do:

      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i
         &MSGNUM     = 6137
         &ERRORLEVEL = 4
         &MSGARG1    = getTermLabel(""FOR_REMOTE_INVENTORY"",25)
         }
      abnormal_exit = true.
      return.

   end.
end. /* ALLOC_LINE */

for each lad_det
   where lad_det.lad_domain = global_domain
   and   lad_dataset        = "sod_det"
   and   lad_nbr            = alc_nbr
   and   integer(lad_line)  = alc_line
   and   lad_part           = sod_part
   and   lad_site           = sod_site
   and   lad_qty_pick       = 0
   and   lad_qty_all        = 0
   exclusive-lock:
   delete lad_det.
end.
