/* sopkall.p - SALES ORDER PICK LIST HARD ALLOCATIONS                   */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */

/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: MLB **D021**/
/* REVISION: 6.0      LAST MODIFIED: 06/23/90   BY: pml */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 05/12/92   BY: tjs *F444**/
/* REVISION: 7.2      LAST MODIFIED: 01/31/94   BY: afs *FL83*   (rev only) */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 10/30/98   BY: *M00D* Robert Jensen*/
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.14  BY: Russ Witt           DATE: 06/01/01   ECO: *P00J*       */
/* Revision: 1.15  BY: Russ Witt           DATE: 07/10/01   ECO: *P011*       */
/* Revision: 1.16  BY: Kirti Desai         DATE: 05/22/01   ECO: *N0Y4*       */
/* Revision: 1.18  BY: Paul Donnelly (SB)  DATE: 06/28/03   ECO: *Q00L*       */
/* Revision: 1.19  BY: Subramanian Iyer    DATE: 08/14/03   ECO: *P0ZR*       */
/* Revision: 1.20  BY: Tejasvi Kulkarni    DATE: 02/14/05   ECO: *P36W*       */
/* Revision: 1.20.1.2 BY: Mochesh Chandran DATE: 04/10/07   ECO: *P5FK*       */
/* $Revision: 1.20.1.3 $ BY: Ruma Bibra       DATE: 12/20/07   ECO: *Q1FY*       */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                            */
{mfdeclre.i}
{sotmpdef.i}

define input parameter alloc_cont as logical no-undo.
{yysososlv.i}
define variable tot_lad_qty like sod_qty_all.
define variable qty_to_all like sod_qty_all.
define variable all_this_loc like sod_qty_all.
define shared variable sod_recno as recid.
define variable this_lot like ld_lot.
define variable this_ref like ld_ref initial ? no-undo.
define shared variable alc_sod_nbr like sod_nbr.
define shared variable alc_sod_line like sod_line.
define shared variable tot_qty_all like lad_qty_all.
define variable cust-to-allocate like so_cust extent 3 no-undo.
define variable i as integer no-undo.
define variable ret-flag as integer no-undo.

define variable l_accum_total  like sod_qty_all    no-undo.
define variable l_temp_pick_qty like  abs_qty      no-undo .
define variable l_flag          like  mfc_logical  no-undo .
define variable l_restart       like  mfc_logical  no-undo .
define variable l_restparid as  Character format "x(40)" no-undo .
define variable l_rej_id    as  Character format "x(40)" no-undo .
define variable l_next          like  mfc_logical  no-undo .
define variable l_alloc_status  like  mfc_logical  no-undo .
define variable l_do_not_cons   like  mfc_logical  no-undo .
define variable l_iterate       like  mfc_logical  no-undo initial yes .

l_alloc_status  = alloc_cont .

/*DEFINE TEMP TABLE USED IN RESERVED LOCATION ALLOCATIONS */
define temp-table tt_resv_loc
   field tt_loc             like ld_loc
   field tt_primary_loc     like locc_primary_loc
   index tt_loc is unique primary
   tt_loc.

/* DEFINE TEMP TABLE TO STORE THE CONTAINERS CREATED FOR ITEM */
define temp-table t_cont_data no-undo
   field t_cont_abs_parid like abs_par_id
   field t_cont_abs_id    like abs_id
   field t_cont_abs_item  like abs_item
   field t_cont_abs_site  like abs_site
   field t_cont_abs_loc   like abs_loc
   field t_cont_abs_lot   like abs_lot
   field t_cont_abs_ref   like abs_ref
   field t_cont_abs_qty   like abs_qty
   field t_cont_abs_order like abs_order
   field t_cont_accum     like abs_qty
   field t_cont_canuse    like mfc_logical
   field t_cont_marked    like mfc_logical
   index t_cont_abs_id is unique primary t_cont_abs_id .

define temp-table tt_temp no-undo
   field tt_parid like  abs_par_id
   field tt_absid like  abs_id
   field tt_order like  abs_order
   field tt_ldlot  like abs_lot
   index tt_absid is unique primary tt_absid.

define temp-table t_rej_cont  no-undo
   field t_rej_parid like  abs_par_id
   field t_rej_absid like  abs_id
   index t_rej_parid is unique primary t_rej_parid.

define buffer buff_cont for t_cont_data.
define buffer babsmstr  for abs_mstr .

find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock.

for first so_mstr fields( so_domain so_nbr
                          so_fsm_type
                          so_bill
                          so_ship
                          so_cust)
 where so_mstr.so_domain = global_domain and  so_nbr = alc_sod_nbr no-lock:
 end.

find sod_det  where sod_det.sod_domain = global_domain and  sod_nbr =
alc_sod_nbr
and sod_line = alc_sod_line no-lock.

empty temp-table t_cont_data .
empty temp-table t_rej_cont .
empty temp-table tt_temp .

if alloc_cont
then
   run get-cont-list (input  alc_sod_nbr ,
                      input  alc_sod_line ).

this_lot = ?.
tot_lad_qty = 0.

for first sod_det
   fields (sod_domain sod_line sod_nbr sod_part sod_qty_all sod_qty_ord
           sod_qty_pick sod_qty_ship sod_site sod_um_conv )
   where sod_domain = global_domain
   and   sod_nbr    = alc_sod_nbr
   and   sod_line   = alc_sod_line no-lock:
end.
for each lad_det  where lad_det.lad_domain = global_domain and  lad_dataset =
"sod_det" and lad_nbr = sod_nbr
and lad_line = string(sod_line) and lad_part = sod_part no-lock:
    tot_lad_qty = tot_lad_qty + lad_qty_all.
    if this_lot = ? and lad_qty_all > 0 then this_lot = lad_lot.
end.

qty_to_all = sod_qty_all * sod_um_conv - tot_lad_qty.

/* Search for all the containers that have been created for the item */
/* or the item/so combination   and store in the  temptable and store in the  temptable  */

if alloc_cont
then do:
   assign
      l_flag           = no
      l_restart        = no
      l_iterate        = yes
      l_do_not_cons    = no.

   for each sod_det
      fields (sod_domain sod_line sod_nbr sod_part sod_qty_all sod_qty_ord
              sod_qty_pick sod_qty_ship sod_site sod_um_conv )
      where sod_domain = global_domain
      and   sod_nbr    = alc_sod_nbr
      and   sod_line   = alc_sod_line
   no-lock:

     for each abs_mstr
        where abs_domain   = global_domain
        and   abs_shipfrom = sod_site
        and   abs_item     = sod_part
        and   abs_id begins ("ic")
        and   abs_type     = "s" no-lock :


        if can-find (first t_rej_cont
                        where t_rej_cont.t_rej_parid = abs_mstr.abs_par_id )
        then do:
           next.
        end . /* IF CAN-FIND .. */

        {absupack.i  "abs_mstr" 3 22 "l_temp_pick_qty"}

        /* IF ABS_MSTR ALREADY PICKED THEN  IGNORE */
        if  l_temp_pick_qty > 0
        then do:
           if can-find (first t_rej_cont
                        where t_rej_cont.t_rej_parid = abs_mstr.abs_par_id )
           then
              next.
        end. /* IF l_temp_pick .. */

        if can-find (first ld_det
                        where ld_domain = global_domain
                        and   ld_site   = abs_site
                        and   ld_part   = abs_item
                        and   ld_loc    = abs_loc
                        and   ld_lot    = abs_lot
                        and   ld_ref    = abs_ref
                        and   (ld_qty_oh - ld_qty_all <= 0 ))
        then
           if can-find (first t_rej_cont
                        where t_rej_cont.t_rej_parid = abs_mstr.abs_par_id )
           then
              next.


        create t_cont_data  .
        assign
           t_cont_abs_parid = abs_par_id
           t_cont_abs_id    = abs_id
           t_cont_abs_item  = abs_item
           t_cont_abs_site  = abs_site
           t_cont_abs_loc   = abs_loc
           t_cont_abs_lot   = abs_lot
           t_cont_abs_ref   = abs_ref
           t_cont_abs_qty   = abs_qty
           t_cont_canuse    = yes
           t_cont_abs_order = abs_order  .


      end.  /* FOR EACH */
   end. /* FOR EACH sod_det */
end.  /* IF alloc_cont */


for each t_cont_data
   where t_cont_data.t_cont_canuse = yes
   break by  t_cont_abs_parid :

   if first-of (t_cont_data.t_cont_abs_parid )
   then
      l_accum_total  = 0.

    l_accum_total  =  l_accum_total +  t_cont_abs_qty  .
    if last-of (t_cont_data.t_cont_abs_parid )
    then do :
       for  each buff_cont
         where buff_cont.t_cont_canuse     = yes
         and   buff_cont.t_cont_abs_item   =  t_cont_data.t_cont_abs_item
         and   buff_cont.t_cont_abs_parid  =  t_cont_data.t_cont_abs_parid
       exclusive-lock  :

         buff_cont.t_cont_accum  = l_accum_total  .
       end. /* for each buff_cont */

    end . /* IF LAST-OF  .. */
end. /* FOR EACH */

for first sod_det
   fields (sod_domain sod_line sod_nbr sod_part sod_qty_all sod_qty_ord
           sod_qty_pick sod_qty_ship sod_site sod_um_conv )
   where sod_domain = global_domain
   and   sod_nbr    = alc_sod_nbr
   and sod_line   = alc_sod_line no-lock:
end.
if  qty_to_all = 0
then
   leave .

do  while   l_iterate =  yes :
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   sod_part no-lock no-error.

   if pt_sngl_lot = no then this_lot = ?.

   if icc_ascend then do:
      if xxlot then do:
         {sopkall.i &sort1 = " ld_lot "}
      end.
      else do:
           if icc_pk_ord <= 2 then do:
              {sopkall.i &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)" }
           end.
           else do:
              {sopkall.i &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)" }
           end.
      end.
   end.
   else do:
      if xxlot then do:
         {sopkall.i &sort1 = " ld_lot "}
      end.
      else do:
           if icc_pk_ord <= 2 then do:
              {sopkall.i &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)"
              &sort2 = "descending"}
           end.
           else do:
              {sopkall.i &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)"
              &sort2 = "descending"}
           end.
      end.
   end.
end.  /* if qty_to_all > 0 */

/*       I N T E R N A L      P R O C E D U R E S         */

PROCEDURE detail-allocate:
   define buffer lddet for ld_det.
/*1*/   define variable q_mult like pt_ord_mult.

   allocate-proc:
   do:

      /* BYPASS ALLOCATION IS THIS IS A RESTRICTED TRANSACTION   */
      for first isd_det fields( isd_domain isd_status isd_tr_type
      isd_bdl_allowed)
       where isd_det.isd_domain = global_domain and  isd_status =
       ld_det.ld_status and isd_tr_type = "ISS-SO"
      no-lock:
        if batchrun = no or (batchrun = yes and isd_bdl_allowed = no)
        then leave allocate-proc.
      end.

      /* BYPASS ALLOCATION IS THIS IS RESERVED BY ANOTHER CUSTOMER   */
      run checkReservedLocation.
      if ret-flag = 0 then leave allocate-proc.

/*1*/ assign q_mult = 1.
/*1*/ find first ptp_det no-lock where ptp_domain = global_domain
/*1*/        and ptp_part = ld_part and ptp_site = ld_site no-error.
/*1*/ if available ptp_det and ptp_ord_mult <> 0 then do:
/*1*/    assign q_mult = ptp_ord_mult.
/*1*/ end.
/*1*/ else do:
/*1*/      find first pt_mstr no-lock where pt_domain = global_domain
/*1*/             and pt_part = ld_part no-error.
/*1*/      if available pt_mstr and pt_ord_mult <> 0 then do:
/*1*/         assign q_mult = pt_ord_mult.
/*1*/      end.
/*1*/ end.

      if qty_to_all < ld_qty_oh - ld_qty_all
      then all_this_loc = qty_to_all.
      else all_this_loc = ld_qty_oh - ld_qty_all.
/*1   if xxlog then do:                                                      */
/*1     assign all_this_loc = all_this_loc - all_this_loc mod q_mult.        */
/*1   end.                                                                   */

      if pt_mstr.pt_sngl_lot and all_this_loc < qty_to_all
      and this_lot = ?
      then do for lddet:
         for each lddet
         fields( ld_domain ld_site ld_part ld_lot ld_ref ld_status ld_expire
                 ld_qty_oh ld_qty_all)
          where lddet.ld_domain = global_domain and (
             lddet.ld_site = sod_det.sod_site
         and lddet.ld_part = sod_part
         and lddet.ld_lot = ld_det.ld_lot
         and lddet.ld_ref = ld_det.ld_ref
         and can-find(is_mstr  where is_mstr.is_domain = global_domain and (
         is_status = lddet.ld_status
         and is_avail = yes))
         and (ld_expire > today or ld_expire = ?)
         and lddet.ld_qty_oh - lddet.ld_qty_all > 0
         ) no-lock:
            accum (lddet.ld_qty_oh - lddet.ld_qty_all) (total).
         end.

         if (accum total lddet.ld_qty_oh - lddet.ld_qty_all) >= qty_to_all
         then this_lot = ld_det.ld_lot.
      end.   /* do for lddet */

      /*IF ALL AVAILABLE TO ALLOCATE OR NOT SINGLE LOT THEN CREATE LAD_DET*/
      if ( all_this_loc = qty_to_all or pt_sngl_lot = no
         or (
         ((this_lot  = ? and this_ref <> ? )       or
         (this_lot  <> ? and ld_lot    = this_lot)) and
         ((this_ref  = ? and this_lot <> ? )       or
         (this_ref  <> ? and ld_ref    = this_ref))
          ) )
         and all_this_loc <> 0

      then do:

         /* IF USE CONTAINERS IS SET TO YES THEN SEARCH FOR  CONTAINERS */
         /* ALREADY CREATED FOR THE ITEM */

         if     alloc_cont
            and not can-find (first t_cont_data
                              where t_cont_data.t_cont_abs_item =  ld_part
                              and   t_cont_data.t_cont_canuse   = yes )
         then do:
            l_flag     = yes.
            leave allocate-proc .
         end . /* IF alloc_cont ... */

         l_do_not_cons = no .

         if l_alloc_status =  yes
         then do:
            for first abs_mstr
               fields (abs_domain abs_id abs_item abs_loc abs_lotser abs_order
                       abs_par_id abs_qty abs_ref abs_shipfrom abs_site
                       abs_type abs__qad10)
               where abs_domain   = global_domain
               and   abs_shipfrom = ld_site
               and   abs_item     = ld_part
               and   abs_loc      = ld_loc
               and   abs_lot      = ld_lot
               and   abs_ref      = ld_ref
               and   abs_id begins ("ic")
               and   abs_type     = "s"
               no-lock:
            end. /* for first abs_mstr .. */

            if available  abs_mstr
            then do:
               if can-find (first t_rej_cont
                            where t_rej_cont.t_rej_parid = abs_mstr.abs_par_id )
               then do:
                  l_do_not_cons  = yes .
                  leave allocate-proc .
               end .
            end.  /* if available abs_mstr */
         end. /* IF l_alloc_status */

         if     alloc_cont
            and can-find (first t_cont_data
                          where t_cont_data.t_cont_abs_item =  ld_part )
         then do:

         /* FIRST CONSUME THE CONTAINERS CREATED VIA SO CONTAINER MAINTENANCE */
            if can-find (first t_cont_data
                            where t_cont_data.t_cont_abs_order = sod_nbr
                            and   t_cont_data.t_cont_abs_item  =  ld_part )
            then do:
               run short-list (input  sod_nbr ,
                               input  ld_part ,
                               input  ld_site,
                               input  ld_loc,
                               input  ld_lot,
                               input  ld_ref ,
                               output l_next ) .

               if l_next
               then
                  next.

            end.  /* IF CAN-FIND ..*/
            else do:
            /* NOW CONSUME  THE CONTAINERS CREATED VIA CONTAINER WORKBENCH  */
               if can-find (first t_cont_data
                               where t_cont_data.t_cont_abs_order = ""
                               and   t_cont_data.t_cont_abs_item  = ld_part )
               then do:
                  run short-list (input  "" ,
                                  input  ld_part ,
                                  input  ld_site,
                                  input  ld_loc,
                                  input  ld_lot,
                                  input  ld_ref ,
                                  output l_next ) .

                 if l_next
                 then
                    next.
               end.   /* IF CAN-FIND .. */
            end. /* ELSE DO */

         end.  /* IF alloc_cont */

         for first lad_det
            fields( lad_domain lad_dataset lad_nbr lad_line lad_part lad_site
                    lad_loc lad_lot lad_ref lad_qty_all)
            where lad_det.lad_domain = global_domain
            and   lad_dataset = "sod_det"
            and   lad_nbr  = sod_nbr
            and   lad_line = string(sod_line)
            and   lad_part = sod_part
            and   lad_site = sod_site
            and   lad_loc  = ld_loc
            and   lad_lot  = ld_lot
            and   lad_ref  = ld_ref
            exclusive-lock:
         end.

         /*IF SNGL LOT AND LAD EXISTS THEN ALLOCATE ALL */
         /* TO EXISTING LAD_DET                         */
         if not available lad_det
         then do:
            create lad_det. lad_det.lad_domain = global_domain.
            assign
               lad_dataset = "sod_det"
               lad_nbr  = sod_nbr
               lad_line = string(sod_line)
               lad_site = sod_site
               lad_loc  = ld_loc
               lad_part = sod_part
               lad_lot  = ld_lot
               lad_ref  = ld_ref.
         end.  /* if not available lad_det */

         /* CREATE THE TEMP-TABLE TO STORE THE VALUES OF lad_det, ld_det */
         /* AND sod_det BEFORE THEY ARE UPDATED BY NEW VALUES            */

         if execname = "yysososl.p"
         then do:
            create t_all_data.
            assign
               t_sod_nbr     = sod_nbr
               t_sod_line    = sod_line
               t_sod_all     = sod_qty_all
               t_sod_pick    = sod_qty_pick
               t_ld_all      = all_this_loc
               t_lad_dataset = lad_dataset
               t_lad_site    = lad_site
               t_lad_loc     = lad_loc
               t_lad_lot     = lad_lot
               t_lad_ref     = lad_ref
               t_lad_part    = lad_part
               t_lad_all     = lad_qty_all
               t_lad_pick    = lad_qty_pick.
         end. /* IF execname  = "sososl.p" */

         if     alloc_cont
            and (can-find (t_cont_data
                           where (    (t_cont_data.t_cont_abs_order = sod_nbr
                                       and t_cont_abs_order <> "" )
                                   or (t_cont_abs_order  =  "" ))
                             and t_cont_data.t_cont_abs_item = ld_part
                             and t_cont_data.t_cont_abs_site = ld_site
                             and t_cont_data.t_cont_abs_lot  = ld_lot
                             and t_cont_data.t_cont_abs_ref  = ld_ref
                             and t_cont_data.t_cont_abs_loc  = ld_loc ))
         then do:

            find first t_cont_data
               where  (   ( t_cont_data.t_cont_abs_order      <> ""
                            and  t_cont_data.t_cont_abs_order = sod_nbr )
                       or (t_cont_data.t_cont_abs_order = "" ))
               and    t_cont_data.t_cont_abs_item = ld_part
               and    t_cont_data.t_cont_abs_site = ld_site
               and    t_cont_data.t_cont_abs_lot  = ld_lot
               and    t_cont_data.t_cont_abs_ref  = ld_ref
               and    t_cont_data.t_cont_abs_loc  = ld_loc
              exclusive-lock no-error.

              if available t_cont_data
              then  do:
                 find first tt_temp
                    where tt_temp.tt_parid = t_cont_data.t_cont_abs_parid
                    and   tt_temp.tt_absid = t_cont_data.t_cont_abs_id
                 exclusive-lock no-error .
                 if available tt_temp
                 then do:
                    delete tt_temp .
                 end. /* IF AVAILABLE tt_temp.. */

                 delete  t_cont_data .

              end. /* if available t_cont_data */
         end. /* if alloc-cont ..*/

         qty_to_all = qty_to_all - all_this_loc.
         ld_qty_all = ld_qty_all + all_this_loc.
         lad_qty_all = lad_qty_all + all_this_loc.

      end.  /* if all_this_loc... */

      find first tt_temp no-lock no-error.
      if     not available tt_temp
         and alloc_cont
      then do:
         l_restart =  yes .
         leave allocate-proc .
      end . /* IF NOT AVAILABLE tt_temp */

   end. /* do block */
END PROCEDURE.    /* detail-allocate  */

/* DETERMINE IF LOC TO BE USED IS VALID     */
PROCEDURE checkReservedLocation:

   define variable l_det-flag like mfc_logical no-undo.

   assign
      ret-flag   = 2
      l_det-flag = no.

   /* BYPASS CHECKING SSM ORDERS */
   if so_mstr.so_fsm_type = ""
   then do:
      {gprun.i ""sorlchk1.p""
         "(input so_mstr.so_ship,
           input so_mstr.so_bill,
           input so_mstr.so_cust,
           input ld_det.ld_site,
           input ld_det.ld_loc,
           output ret-flag,
           output l_det-flag)"}
   end. /* IF so_mstr.so_fsm_type = "" */
END PROCEDURE.  /*  PROCEDURE checkReservedLocation */

PROCEDURE get-cont-list:

   define  input  parameter  i_sod_nbr  like sod_nbr   no-undo.
   define  input  parameter  i_sod_line like sod_line  no-undo.

   define variable l_list         as character  no-undo.
   define variable l_contitem_qty like abs_qty  no-undo.

   define  buffer absmstr for abs_mstr .


   for first sod_det
      fields (sod_domain sod_line sod_nbr sod_part sod_qty_all sod_qty_ord
              sod_qty_pick sod_qty_ship sod_site sod_um_conv )
      where sod_domain = global_domain
      and   sod_nbr    =  i_sod_nbr
      and   sod_line   =  i_sod_line  no-lock:

   loop1:
      for each abs_mstr
         fields (abs_domain abs_id abs_item abs_loc abs_lotser abs_order
                 abs_par_id abs_qty abs_ref abs_shipfrom abs_site abs_type
                 abs__qad10)
         where abs_domain    = global_domain
         and   abs_shipfrom  = sod_site
         and   abs_item      = sod_part
         and   abs_id begins ("ic")
         and   abs_type      = "s"
         no-lock:

         /* IF CONTAINER CREATED  WITH A  DIFFERENT SALES ORDER THEN  IGNORE */

         if     abs_order   <> ""
            and abs_order <> sod_nbr
         then do:
                 if not can-find (first t_rej_cont
                          where  t_rej_cont.t_rej_parid = abs_mstr.abs_par_id)
            then do:
               create t_rej_cont .
               t_rej_cont.t_rej_parid = abs_mstr.abs_par_id.
               next loop1.
             end. /* IF NOT CAN-FIND ..*/
         end. /* IF abs_order <> ""  */


         /* IF CONTAINER IS INSIDE ANOTHER CONTAINER THEN IGNORE THE CONTAINER*/

         if can-find (absmstr
                     where absmstr.abs_domain = global_domain
                     and   absmstr.abs_id     = abs_mstr.abs_par_id
                     and   absmstr.abs_shipfrom = abs_mstr.abs_shipfrom
                     and   absmstr.abs_par_id <> "" )

         then do:
            if not can-find (first t_rej_cont
               where  t_rej_cont.t_rej_parid = abs_mstr.abs_par_id)
            then do:
               create t_rej_cont .
               t_rej_cont.t_rej_parid = abs_mstr.abs_par_id  .
               next loop1.
            end. /* IF NOT CAN-FIND ..*/
         end.  /* IF CAN-FIND absmstr */

         /* IF CONTAINER HAS ALREADY BEEN USED THEN REJECT CONTAINER */
         if can-find ( first qad_wkfl
                       where qad_domain = global_domain
                       and   qad_key1   = mfguser + global_db + "stage_list"
                       and   qad_charfld[9]  = abs_mstr.abs_par_id)
         then do:
            if not can-find (first t_rej_cont
               where t_rej_cont.t_rej_parid = abs_mstr.abs_par_id)
            then do:
               create t_rej_cont .
               t_rej_cont.t_rej_parid = abs_mstr.abs_par_id  .
               next loop1.
            end. /* if not can-find ..*/

         end . /* IF CAN-FIND ...*/

         /* IF CONTAINER CONTAINS AN ITEM OTHER THAN THE SOD_LINE ITEM IN */
         /* QUESTION THEN IGNORE THE CONTAINER */
         if can-find (absmstr
                     where absmstr.abs_domain   = global_domain
                     and   absmstr.abs_par_id   = abs_mstr.abs_par_id
                     and   absmstr.abs_shipfrom = abs_mstr.abs_shipfrom
                     and   absmstr.abs_item     <>  sod_part )
         then do:
            if not can-find (first t_rej_cont
                          where t_rej_cont.t_rej_parid = abs_mstr.abs_par_id)
            then do:
               create t_rej_cont .
               assign t_rej_cont.t_rej_parid = abs_mstr.abs_par_id  .
               next loop1.
            end. /* IF NOT CAN-FIND ..*/
         end.  /* IF CAN-FIND absmstr ... */

         /* IF THE CONTAINER QTY EXCEEDS THE UNCONTAINERIZED SALES ORDRE LINE */
         /* QTY THEN IGNORE THE CONTAINER */

         l_contitem_qty =  0 .
         for each absmstr
             where absmstr.abs_domain   = global_domain
             and   absmstr.abs_par_id   = abs_mstr.abs_par_id
             and   absmstr.abs_item     = abs_mstr.abs_item
             and   absmstr.abs_shipfrom = abs_mstr.abs_shipfrom no-lock:

             l_contitem_qty =  l_contitem_qty +  absmstr.abs_qty .

         end. /* FOR EACH absmstr */

         if      (sod_qty_ord  - sod_qty_pick - sod_qty_ship ) >  0
             and ( sod_qty_ord - sod_qty_pick - sod_qty_ship ) < l_contitem_qty
         then do:

                 if not can-find (first t_rej_cont
                          where  t_rej_cont.t_rej_parid = abs_mstr.abs_par_id)
            then do:
               create t_rej_cont .
               assign t_rej_cont.t_rej_parid = abs_mstr.abs_par_id  .
               next loop1.
            end. /* IF NOT CAN-FIND ..*/
         end. /* if sod_qty_ord .. */
      end. /* FOR each abs_mstr ...loop1 */
   end. /* FOR FIRST sod_det */
END PROCEDURE.  /* PROCEDURE get-cont-list */

PROCEDURE short-list:

   define  input  parameter  i_sod_nbr  like sod_nbr  no-undo.
   define  input  parameter  i_ld_part  like ld_part  no-undo.
   define  input  parameter  i_ld_site  like ld_site  no-undo.
   define  input  parameter  i_ld_loc   like ld_loc   no-undo.
   define  input  parameter  i_ld_lot   like ld_lot   no-undo.
   define  input  parameter  i_ld_ref   like ld_ref   no-undo.
   define  output parameter o_next  like mfc_logical  no-undo.

   if not (can-find (first t_cont_data
                        where  t_cont_data.t_cont_abs_order = i_sod_nbr
                        and    t_cont_data.t_cont_abs_item  = i_ld_part
                        and    t_cont_data.t_cont_abs_site  = i_ld_site
                        and    t_cont_data.t_cont_abs_lot   = i_ld_lot
                        and    t_cont_data.t_cont_abs_ref   = i_ld_ref
                        and    t_cont_data.t_cont_abs_loc   = i_ld_loc  ))
   then do :
      o_next = yes .
      return .

   end.  /* IF NOT can-find .. */

   find first t_cont_data
      where t_cont_data.t_cont_abs_order = i_sod_nbr
      and   t_cont_data.t_cont_marked    = no
      and   t_cont_data.t_cont_accum     > qty_to_all
   no-lock no-error .
   if available t_cont_data
   then do:
      if not can-find (first t_rej_cont
                where  t_rej_cont.t_rej_parid = t_cont_data.t_cont_abs_parid)
      then do:
         create t_rej_cont .
         t_rej_cont.t_rej_parid = t_cont_data.t_cont_abs_parid .
      end. /* if not can-find ..*/

      for each t_cont_data
         where t_cont_data.t_cont_abs_order = i_sod_nbr
         and   t_cont_data.t_cont_marked    = no
         and   t_cont_data.t_cont_accum     > qty_to_all
      exclusive-lock:
        delete t_cont_data .
      end. /* for each ..*/

      o_next = yes  .
      return.
   end.  /* IF AVAILABLE t_cont_data */

   /* POPULATE THE  TEMP-TABLE WITH DETAILS OF THE SHORT LISTED */
   /* CONTAINER                                                 */

   find first t_cont_data
      where t_cont_data.t_cont_abs_order = i_sod_nbr
      and   t_cont_data.t_cont_abs_item  = i_ld_part
      and   t_cont_data.t_cont_abs_site  = i_ld_site
      and   t_cont_data.t_cont_abs_lot   = i_ld_lot
      and   t_cont_data.t_cont_abs_ref   = i_ld_ref
      and   t_cont_data.t_cont_abs_loc   = i_ld_loc
   no-lock no-error .
   if  available  t_cont_data
   then do:
      find first tt_temp no-lock no-error .

      if not available tt_temp
      then do :
         for each buff_cont
            where buff_cont.t_cont_abs_item   =
                      t_cont_data.t_cont_abs_item
            and   buff_cont.t_cont_abs_parid  =
                      t_cont_data.t_cont_abs_parid
         exclusive-lock:

            create  tt_temp.
            assign
               tt_temp.tt_parid = buff_cont.t_cont_abs_parid
               tt_temp.tt_absid = buff_cont.t_cont_abs_id
               tt_temp.tt_ldlot = buff_cont.t_cont_abs_lot
               tt_temp.tt_order = buff_cont.t_cont_abs_order .
               buff_cont.t_cont_marked  = yes .
         end . /* FOR EACH */
      end. /* IF NOT AVAILABLE... */

   end. /* IF AVAILABLE  t_cont_data*/

   if not (can-find (tt_temp
                 where t_cont_data.t_cont_abs_id  = tt_temp.tt_absid
                 and   t_cont_data.t_cont_abs_id  = tt_temp.tt_absid))
   then do:
      o_next = yes.
      return .
   end.  /* IF NOT CAN-FIND .. */

END PROCEDURE.  /* PROCEDURE short list */
