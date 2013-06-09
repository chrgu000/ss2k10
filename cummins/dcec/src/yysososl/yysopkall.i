/* sopkall.i - SALES ORDER PICK LIST HARD ALLOCATIONS                   */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */

/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: MLB **D024**/
/* REVISION: 6.0      LAST MODIFIED: 05/30/90   BY: emb */
/* REVISION: 6.0     LAST MODIFIED: 10/05/91    BY: SMM *D887*/
/* REVISION: 7.3     LAST MODIFIED: 12/15/94    BY: pxd *F09X*/
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.0     LAST MODIFIED: 10/30/98    BY: *M00D* Robert Jensen*/
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan   */
/* REVISION: 9.0     LAST MODIFIED: 05/04/00    BY: *M0MC* Ashwini G.   */
/* REVISION: 9.1     LAST MODIFIED: 09/05/00    BY: *N0RF* Mark Brown   */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.16         BY: Russ Witt          DATE: 06/04/01   ECO: *P00J* */
/* Revision: 1.18         BY: Paul Donnelly (SB) DATE: 06/28/03   ECO: *Q00L* */
/* Revision: 1.19         BY: Salil Pradhan      DATE: 10/05/04   ECO: *P2MT* */
/* Revision: 1.20         BY: Priya Idnani       DATE: 10/31/05   ECO: *P46V* */
/* Revision: 1.20.1.1     BY: Mochesh Chandran   DATE: 04/10/07   ECO: *P5FK* */
/* Revision: 1.20.1.2     BY: Prajakta Patil     DATE: 16/10/07   ECO: *P69R* */
/* $Revision: 1.20.1.3 $  BY: Prajakta Patil     DATE: 18/10/07   ECO: *P6B4* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/***********************************************************/
/* &sort1 = field           &sort2 = "" or descending      */
/***********************************************************/
/* Note: This routine completely rewritten by ECO *P00J*   */
/*V8:ConvertMode=Maintenance                                            */

/* LOAD ALL CUSTOMERS TO BE CHECKED INTO ARRAY  */
i = i + 1.

if i <= 3
then do:
   cust-to-allocate[i] = so_ship.

   if so_cust <> so_ship then do:
     i = i + 1.
     cust-to-allocate[i] = so_cust.
   end.

   if so_bill <> so_ship and so_bill <> so_cust then do:
     i = i + 1.
     cust-to-allocate[i] = so_bill.
   end.
end. /* IF i <= 3 */

allocate-proc:
do i = 1 to 3:
  if cust-to-allocate[i] <> "" then do:

     /* CLEAR TEMP FILE THAT STORES RESERVED LOCATIONS   */
     /*FOR THIS ADDRESS                                  */
     for each tt_resv_loc exclusive-lock:
        delete tt_resv_loc.
     end.

     /* LOAD LOCATIONS TO TEMP TABLE                     */
     for each locc_det
     fields( locc_domain locc_site locc_loc locc_primary_loc locc_addr)
      where locc_det.locc_domain = global_domain and  locc_site = sod_site
     and locc_addr = cust-to-allocate[i]
     no-lock:
        create tt_resv_loc.
        assign
           tt_loc         = locc_loc
           tt_primary_loc = locc_primary_loc.
     end.   /* FOR EACH LOCC_DET */

     /* BEGIN ALLOCATIONS NOW */
     /* FIRST CHECK FOR PRIMARY RESERVED LOCATION */
     for each tt_resv_loc where tt_primary_loc = yes:
        for each ld_det
        fields( ld_domain  ld_site ld_part ld_loc ld_qty_oh ld_qty_all
                ld_expire ld_lot ld_ref ld_status ld_date)
         where ld_det.ld_domain = global_domain and (  ld_site = sod_site
        and ld_part = sod_part
        and ld_loc = tt_loc
/*1*/   and ld_loc >= loc and ld_loc <= loc1
        and ld_qty_oh - ld_qty_all > 0
        and (ld_expire > today + icc_ctrl.icc_iss_days
        or ld_expire = ?)
        ) exclusive-lock
        by {&sort1} {&sort2}:
           if (this_lot <> ? and ld_lot <> this_lot) or
           (this_ref <> ? and ld_ref <> this_ref)
           then next.
           run detail-allocate.

           if qty_to_all = 0
           then do:
              l_iterate  = no.
              leave allocate-proc.
           end. /* IF qty_to_all = 0 */

           if available tt_resv_loc
           then
              delete tt_resv_loc.
        end. /*FOR EACH LD_DET*/
     end.  /* FOR EACH TT_PRIMARY_LOC... */

     /* NOW CHECK FOR ALL NON-PRIMARY RESERVED LOCATIONS */
     for each ld_det
     fields( ld_domain  ld_site ld_part ld_loc ld_qty_oh ld_qty_all
             ld_expire ld_lot ld_ref ld_status ld_date)
      where ld_det.ld_domain = global_domain and (  ld_site = sod_site
     and ld_part = sod_part
/*1*/  and ld_loc >= loc and ld_loc <= loc1
     and can-find(tt_resv_loc where tt_loc = ld_loc)
     and ld_qty_oh - ld_qty_all > 0
     and (ld_expire > today + icc_iss_days
     or ld_expire = ?)
     ) exclusive-lock
     by {&sort1} {&sort2}:
        if (this_lot <> ? and ld_lot <> this_lot) or
        (this_ref <> ? and ld_ref <> this_ref)
        then next.
        run detail-allocate.

        if qty_to_all = 0
        then do:
           l_iterate  = no.
           leave allocate-proc.
        end. /* IF qty_to_all = 0 */

     end. /*FOR EACH LD_DET*/

  end. /* cust-to-allocate[i] <> 0 */

end. /* allocate-proc block */

/* NOW CHECK FOR NON-RESERVED LOCATIONS         */
if qty_to_all <> 0
then do:
   if not can-find (first ld_det
      where ld_domain = global_domain
      and   ld_site   = sod_det.sod_site
      and   ld_part   = sod_part
      and can-find(is_mstr
                   where is_domain = global_domain
                   and   is_status = ld_status
                   and   is_avail    = yes)
      and ld_qty_oh  - ld_qty_all > 0
      and (   ld_expire > today + icc_iss_days
           or ld_expire = ?) )
      then do :
         assign
            qty_to_all = 0
            l_iterate  = no.
      end.
   loop:
   for each ld_det
      fields( ld_domain  ld_site ld_part ld_loc ld_qty_oh ld_qty_all
              ld_expire ld_lot ld_ref ld_status ld_date)
   where ld_det.ld_domain = global_domain
   and (  ld_site = sod_det.sod_site
/*1*/   and ld_loc >= loc and ld_loc <= loc1
   and ld_part = sod_part
   and can-find(is_mstr
                where is_mstr.is_domain = global_domain
                and (  is_status = ld_status
                and is_avail = yes))
   and ld_qty_oh - ld_qty_all > 0
   and (ld_expire > today + icc_iss_days
   or ld_expire = ?))
   exclusive-lock
   by {&sort1} {&sort2}:
      if (    this_lot  <> ?
          and ld_lot    <> this_lot)
      or (    this_ref  <> ?
          and ld_ref    <> this_ref)
      then next.
      run detail-allocate.

      if (     l_flag         = yes
           and alloc_cont     = yes
           and l_alloc_status = yes )
      then do:
        alloc_cont =  no.
        leave.
      end.  /* IF l_flag */

      if (    l_flag         = yes
          and alloc_cont     = no
          and l_alloc_status = yes )
      then
         l_iterate =  no.

      if qty_to_all = 0
      then
         l_iterate  = no.

      if     l_restart
         and alloc_cont
      then do:
         l_restart = no.
         leave.
      end. /* l_restart */

      if l_alloc_status  = no
      then
         l_iterate  = no.
    end. /*FOR EACH LD_DET*/
end. /* IF qty_to_all ... */
