/* REVISION: 9.0       09/25/13      BY: Jordan Lin   *SS-20130925.1 */

{mfdeclre.i}

/*CHAR*/   define input parameter v_pklm_nbr          like xxpklm_nbr.
/*INTE*/   define input parameter v_pklm_type         like xxpklm_type.
/*DATE*/   define input parameter v_pklm_date         like xxpklm_date.
/*CHAR*/   define input parameter v_pklm_wkctr        like xxpklm_wkctr.
/*CHAR*/   define input parameter v_xxpklm_prod_line  like xxpklm_prod_line.
/*CHAR*/   define input parameter v_xxpklm_Par        like xxpklm_Par.
/*DECI*/   define input parameter v_xxpklm_sch_qty    like xxpklm_sch_qty.

/*INTE*/   define input parameter v_xxpkld_line       like xxpkld_line.    /*(项次)*/
/*CHAR*/   define input parameter v_xxpkld_part       like xxpkld_part.
/*CHAR*/   define input parameter v_xxpkld_desc       like xxpkld_desc.
/*DECI*/   define input parameter v_xxpkld_qty_req    like xxpkld_qty_req. /*请求数量*/
/*CHAR*/   define input parameter v_xxpkld_loc_from   like xxpkld_loc_from.
/*CHAR*/   define input parameter v_xxpkld_loc_to     like xxpkld_loc_to.
/*DECI*/   define input parameter v_xxpkld_line_stk   like xxpkld_line_stk.
/*DECI*/   define input parameter v_xxpkld_main_stk   like xxpkld_main_stk.
/*CHAR*/   define input parameter v_xxpkld_c          like xxpkld_c.
/*DECI*/   define input parameter v_xxpkld_max        like xxpkld_max.
/*DECI*/   define input parameter v_xxpkld_ROP        like xxpkld_ROP.
/*CHAR*/   define input parameter v_xxpkld_location   like xxpkld_location.
/*CHAR*/   define input parameter v_xxpkld_locator    like xxpkld_locator.
/*CHAR*/   define input parameter v_xxpkld_site       like xxpklm_site.


   find first xxpklm_mstr exclusive-lock where
             xxpklm_type   = v_pklm_type and
             xxpklm_date   = v_pklm_date and
             xxpklm_wkctr  = v_pklm_wkctr no-error.
   if not available xxpklm_mstr then do :
      create xxpklm_mstr.
      assign xxpklm_nbr        = v_pklm_nbr
             xxpklm_type       = v_pklm_type
             xxpklm_date       = v_pklm_date
             xxpklm_wkctr      = v_pklm_wkctr
             xxpklm_prod_line  = v_xxpklm_prod_line
             xxpklm_Par        = v_xxpklm_Par
             xxpklm_sch_qty    = v_xxpklm_sch_qty
             xxpklm_site       = v_xxpkld_site
             xxpklm_cr_date    = today
             xxpklm_cr_user    = global_userid.
   end.

   find first xxpkld_det exclusive-lock where xxpkld_nbr = v_pklm_nbr
          and xxpkld_type = v_pklm_type and xxpkld_date = v_pklm_date
          and xxpkld_wkctr = v_pklm_wkctr and xxpkld_part = v_xxpkld_part no-error.
   if not available xxpkld_det then do :
      create xxpkld_det.
      assign xxpkld_nbr        = v_pklm_nbr
             xxpkld_type       = v_pklm_type
             xxpkld_date       = v_pklm_date
             xxpkld_wkctr      = v_pklm_wkctr
             xxpkld_part       = v_xxpkld_part.
   end.
      assign xxpkld_line       = v_xxpkld_line
             xxpkld_desc       = v_xxpkld_desc
             xxpkld_qty_req    = v_xxpkld_qty_req
             xxpkld_loc_from   = v_xxpkld_loc_from
             xxpkld_loc_to     = v_xxpkld_loc_to
             xxpkld_line_stk   = v_xxpkld_line_stk
             xxpkld_main_stk   = v_xxpkld_main_stk
             xxpkld_c          = v_xxpkld_c
             xxpkld_max        = v_xxpkld_max
             xxpkld_ROP        = v_xxpkld_ROP
             xxpkld_location   = v_xxpkld_location
             xxpkld_locator    = v_xxpkld_locator.
