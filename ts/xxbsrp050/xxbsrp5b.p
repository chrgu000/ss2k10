/* xxbsrp5b.p - SUMMARIZED BILL OF MATERIAL COST REPORT                      */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.6.1.12 $                                                     */
/*V8:ConvertMode=FullGUIReport                                               */

{mfdeclre.i}

define input-output parameter vv_mtl AS DECIMAL.

define shared variable eff_date     as   date label "As of Date".
define shared variable site         like si_site.

define SHARED variable csset     like sct_sim     no-undo.

define variable extmtl like sct_mtl_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extlbr like sct_lbr_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extbdn like sct_bdn_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extovh like sct_ovh_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extsub like sct_sub_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable exttot like sct_cst_tot format "->>>>>>>>9.99<<<<<<<"  no-undo.

define variable level     as   integer     no-undo.
define variable part      like pt_part     no-undo.
define variable part1     like pt_part     no-undo.
define variable buyer     like pt_buyer    no-undo.
define variable buyer1    like pt_buyer    no-undo.
define variable um        like pt_um       no-undo.
define variable pmcode    like pt_pm_code  no-undo.
define variable mtl       like extmtl      no-undo.
define variable lbr       like extlbr      no-undo.
define variable bdn       like extbdn      no-undo.
define variable ovh       like extovh      no-undo.
define variable sub       like extsub      no-undo.
define variable unittot   like exttot      no-undo.
define variable item-code as   character   no-undo.
define variable get-next  as   logical     no-undo.
define variable onlybom   as   logical     no-undo.
define variable l_linked  like mfc_logical no-undo.
define variable des       as   character   format "x(27)" no-undo.
define variable sum_usage like ps_qty_per  column-label "Summarized!Usage"
   no-undo.
define variable newpage   like mfc_logical initial yes
   label  "New Page Each Parent"                              no-undo.
define variable details_printed like mfc_logical              no-undo.
define variable i               as   integer                  no-undo.
define variable l_part          as   character initial "bmpsrp05.p" no-undo.
/* SS - 20080526.1 - B */
define buffer ptmstr for pt_mstr.
define variable desc1 as   character   format "x(27)" no-undo.
define variable desc2 as   character   format "x(27)" no-undo.
define variable rmks  as   character   format "x(8)" initial "*****"  no-undo.
define variable deltot like sct_cst_tot format "->>>>>>>>9.99<<<<<<<"  no-undo.
/* SS - 20080526.1 - E */
DEF VAR v_vend AS CHAR.


for each pk_det
  fields( pk_domain pk_end pk_part pk_qty pk_start pk_user)
  no-lock
   where pk_det.pk_domain = global_domain and (  (pk_user  =
   mfguser)
    and (eff_date =  ?
     or (eff_date <> ?
    and (pk_start =  ?
     or pk_start  <= eff_date)
    and (pk_end   =  ?
     or eff_date  <= pk_end)))
  ) break by pk_user
        by pk_part
    :


  accumulate pk_qty (total by pk_part).

  if last-of(pk_part)
  then do:

     for first ptmstr
         where ptmstr.pt_domain = global_domain and
         ptmstr.pt_part = pk_part
        no-lock:
     end. /* FOR FIRST ptmstr */

     /* CHECK IF COST SIMULATION TOTAL DETAILS EXIST     */
     /* AND IF THEY DO NOT EXIST THEN CREATE THE DETAILS */
     if l_linked then do:
        if available (ptmstr) then do:
           /* FOR FIRST USED TO KEEP THE RECORD IN SCOPE */
           for first sct_det
              fields(sct_domain   sct_bdn_ll sct_bdn_tl
                     sct_cst_date sct_lbr_ll sct_lbr_tl
                     sct_mtl_ll   sct_mtl_tl sct_ovh_ll
                     sct_ovh_tl   sct_part   sct_sim
                     sct_site     sct_sub_ll sct_sub_tl)
              where sct_det.sct_domain = global_domain
              and   sct_sim            = csset
              and   sct_part           = ptmstr.pt_part
              and   sct_site           = site
           no-lock:
           end. /* FOR FIRST sct_det */
        end. /* IF AVAILABLE (ptmstr) */
        else do:
          {gpsct08.i &part = l_part
                     &set  = csset
                     &site = site}
        end. /* ELSE DO */
     end. /* IF l_linked */
     else do:
        if available (ptmstr)
        then do:
           /* FOR FIRST USED TO KEEP THE RECORD IN SCOPE */
           for first sct_det
              fields(sct_domain   sct_bdn_ll sct_bdn_tl
                     sct_cst_date sct_lbr_ll sct_lbr_tl
                     sct_mtl_ll   sct_mtl_tl sct_ovh_ll
                     sct_ovh_tl   sct_part   sct_sim
                     sct_site     sct_sub_ll sct_sub_tl)
              where sct_det.sct_domain = global_domain
              and   sct_sim            = csset
              and   sct_part           = ptmstr.pt_part
              and   sct_site           = site
           no-lock:
           end. /* FOR FIRST sct_det */
        end. /* IF AVAILABLE (ptmstr) */
        else do:
           {gpsct08.i &part = l_part
                      &set  = csset
                      &site = site}
        end. /* ELSE DO*/
     end. /* ELSE DO */
     if available sct_det then do:
        /* SS - del                assign
           sum_usage = accum total by pk_part pk_qty
           mtl       = sct_mtl_tl + sct_mtl_ll
           lbr       = sct_lbr_tl + sct_lbr_ll
           bdn       = sct_bdn_tl + sct_bdn_ll
           ovh       = sct_ovh_tl + sct_ovh_ll
           sub       = sct_sub_tl + sct_sub_ll
           unittot   = mtl + lbr + bdn + ovh + sub
           extmtl    = sum_usage * mtl
           extlbr    = sum_usage * lbr
           extbdn    = sum_usage * bdn
           extovh    = sum_usage * ovh
           extsub    = sum_usage * sub
           exttot    = sum_usage * unittot.  ****/  
           /* SS - add*/ 
           assign
           sum_usage = accum total by pk_part pk_qty
           mtl       = sct_mtl_tl
           lbr       = sct_lbr_tl
           bdn       = sct_bdn_tl
           ovh       = sct_ovh_tl
           sub       = sct_sub_tl
           unittot   = mtl + sub
           extmtl    = sum_usage * mtl
           extlbr    = sum_usage * lbr
           extbdn    = sum_usage * bdn
           extovh    = sum_usage * ovh
           extsub    = sum_usage * sub
           exttot    = sum_usage * unittot.

         /*SS - 111222.1 B*/
         IF csset = "pur-std" AND NOT can-find(FIRST ps_mstr WHERE ps_domain = GLOBAL_domain AND ps_par = ptmstr.pt_part) THEN DO:
            FOR LAST pi_mstr WHERE pi_domain = GLOBAL_domain AND pi_part_code = ptmstr.pt_part
               and   (pi_start    <= eff_date or pi_start = ?)
               and   (pi_expire   >= eff_date or pi_expire = ?)
               NO-LOCK:
            END.
            IF AVAIL pi_mstr THEN DO:
              assign
               sum_usage = accum total by pk_part pk_qty
               mtl       = pi_list_price
               lbr       = sct_lbr_tl
               bdn       = sct_bdn_tl
               ovh       = sct_ovh_tl
               sub       = sct_sub_tl
               unittot   = mtl + sub
               extmtl    = sum_usage * mtl
               extlbr    = sum_usage * lbr
               extbdn    = sum_usage * bdn
               extovh    = sum_usage * ovh
               extsub    = sum_usage * sub
               exttot    = sum_usage * unittot.

            END.
            ELSE DO:
                FOR LAST pc_mstr WHERE pc_domain = GLOBAL_domain AND pc_part = ptmstr.pt_part
                   and   (pc_start    <= eff_date or pc_start = ?)
                   and   (pc_expire   >= eff_date or pc_expire = ?)
                   NO-LOCK:
                END.
                IF AVAIL pc_mstr THEN DO:
                  assign
                   sum_usage = accum total by pk_part pk_qty
                   mtl       = pc_amt[1]
                   lbr       = sct_lbr_tl
                   bdn       = sct_bdn_tl
                   ovh       = sct_ovh_tl
                   sub       = sct_sub_tl
                   unittot   = mtl + sub
                   extmtl    = sum_usage * mtl
                   extlbr    = sum_usage * lbr
                   extbdn    = sum_usage * bdn
                   extovh    = sum_usage * ovh
                   extsub    = sum_usage * sub
                   exttot    = sum_usage * unittot.

                END.
            END.
         END.
         /*SS - 111222.1 E*/

        if sct_part = l_part
        then do:
           for each spt_det
              where spt_det.spt_domain = global_domain
              and   spt_site           = sct_site
              and   spt_sim            = sct_sim
              and   spt_part           = sct_part
              exclusive-lock:

              delete spt_det.

           end. /* FOR EACH spt_det */

           /* DELETES THE CREATED RECORD */
           delete sct_det.

        end. /* IF sct_part = l_part */

     end. /* IF AVAILABLE sct_det */
     else DO:
        assign
           sum_usage = 0
           mtl       = 0
           lbr       = 0
           bdn       = 0
           ovh       = 0
           sub       = 0
           unittot   = 0
           extmtl    = 0
           extlbr    = 0
           extbdn    = 0
           extovh    = 0
           extsub    = 0
           exttot    = 0.

        /*SS - 111222.1 B*/
        IF csset = "pur-std" AND NOT can-find(FIRST ps_mstr WHERE ps_domain = GLOBAL_domain AND ps_par = ptmstr.pt_part) THEN DO:
           FOR LAST pi_mstr WHERE pi_domain = GLOBAL_domain AND pi_part_code = ptmstr.pt_part
              and   (pi_start    <= eff_date or pi_start = ?)
              and   (pi_expire   >= eff_date or pi_expire = ?)
              NO-LOCK:
           END.
           IF AVAIL pi_mstr THEN DO:
             assign
              sum_usage = accum total by pk_part pk_qty
              mtl       = pi_list_price
              lbr       = 0
              bdn       = 0
              ovh       = 0
              sub       = 0
              unittot   = mtl + sub
              extmtl    = sum_usage * mtl
              extlbr    = sum_usage * lbr
              extbdn    = sum_usage * bdn
              extovh    = sum_usage * ovh
              extsub    = sum_usage * sub
              exttot    = sum_usage * unittot.

           END.
           ELSE DO:
               FOR LAST pc_mstr WHERE pc_domain = GLOBAL_domain AND pc_part = ptmstr.pt_part
                  and   (pc_start    <= eff_date or pc_start = ?)
                  and   (pc_expire   >= eff_date or pc_expire = ?)
                  NO-LOCK:
               END.
               IF AVAIL pc_mstr THEN DO:
                 assign
                  sum_usage = accum total by pk_part pk_qty
                  mtl       = pc_amt[1]
                  lbr       = 0
                  bdn       = 0
                  ovh       = 0
                  sub       = 0
                  unittot   = mtl + sub
                  extmtl    = sum_usage * mtl
                  extlbr    = sum_usage * lbr
                  extbdn    = sum_usage * bdn
                  extovh    = sum_usage * ovh
                  extsub    = sum_usage * sub
                  exttot    = sum_usage * unittot.

               END.
           END.
        END.
        /*SS - 111222.1 E*/

     END.
      vv_mtl =  vv_mtl + exttot.

  end. /* IF LAST-OF(pk_part) */

end. /* FOR EACH pk_det */
