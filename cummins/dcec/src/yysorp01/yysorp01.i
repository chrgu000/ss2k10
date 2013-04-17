/*zzsorp02.i  create by longbo*/
/*cj* 08/26/05 customer type field*/

    for each zzwkso:
      delete zzwkso.
    end.
    iTotalLine = 0.

    for each idh_hist no-lock where idh_domain = global_domain
    and idh_nbr >= nbr and idh_nbr <= nbr1
    and idh_part >= part and idh_part <= part1
    and idh_cum_date[2] >= cumdate and idh_cum_date[2] <= cumdate1
    and idh_site >= site and idh_site <= site1 use-index idh_invln
    ,
    each pt_mstr no-lock
    where pt_domain = global_domain and pt_part = idh_part
    ,
    each ih_hist no-lock
    where ih_domain = global_domain and ih_nbr = idh_nbr
    and ih_cust >= cust and ih_cust <= cust1
    and (ih_slspsn[1] = slspsn or slspsn = "") use-index ih_cust
    ,
    each cm_mstr no-lock
    where cm_domain = global_domain and cm_addr = ih_cust
    and cm_region >= region and cm_region <= region1
/*cj*/  AND (cm_type = cmtype OR cmtype = "")
            use-index cm_addr
    :
      create zzwkso.
      assign
        sonbr   = ih_nbr
        sopart      = idh_part
        invqty      = idh_qty_inv
        soprice     = idh_price
        soregion    = cm_region
/*cj*/          socmtype    =   cm_type
        socust      = ih_cust
        ptline      = pt_prod_line
        soslspsn    = ih_slspsn[1]
        shipdate  = idh_cum_date[2]
        invnbr    = idh_inv_nbr
        zzsite    = idh_site
        .
      iTotalLine = iTotalLine + 1.
    end.

    for each sod_det no-lock
    where sod_domain = global_domain and sod_nbr >= nbr and sod_nbr <= nbr1
    and sod_part >= part and sod_part <= part1
      and sod_cum_date[2] >= cumdate and sod_cum_date[2] <= cumdate1
      and sod_site >= site and sod_site <= site1
      and sod_qty_inv <> 0
      use-index sod_nbrln
    ,
    each pt_mstr no-lock
    where pt_domain = global_domain and pt_part = sod_part
    ,
    each so_mstr no-lock
    where so_domain = global_domain and so_nbr = sod_nbr
    and so_cust >= cust and so_cust <= cust1
    and (so_slspsn[1] >= slspsn or slspsn = "") use-index so_cust
    ,
    each cm_mstr no-lock
    where cm_domain = global_domain and cm_addr = so_cust
    and cm_region >= region and cm_region <= region1
/*cj*/  AND (cm_type = cmtype OR cmtype = "")
            use-index cm_addr
    :
      create zzwkso.
      assign
        sonbr   = so_nbr
        sopart      = sod_part
        invqty      = sod_qty_inv
        soprice     = sod_price
        socon       = sod_consignment
        soconloc    = sod_consign_loc
        soregion    = cm_region
/*cj*/          socmtype    =   cm_type
        socust      = so_cust
        ptline      = pt_prod_line
        soslspsn    = so_slspsn[1]
        shipdate  = sod_cum_date[2]
        invnbr    = so_inv_nbr
        zzsite    = sod_site.
      iTotalLine = iTotalLine + 1.
    end.
  for each zzwkso exclusive-lock where soconloc = "":
      find first so_mstr no-lock where so_domain = global_domain
             and so_nbr = sonbr no-error.
      if available so_mstr then do:
         assign socon = so_consignment
                soconloc = so_consign_loc.
      end.
  end.

/*

    for each cm_mstr no-lock where cm_domain = global_domain and
    cm_addr >= cust and cm_addr <= cust1
    and cm_region >= region and cm_region <= region1 use-index cm_addr:

      for each ih_hist no-lock
      where ih_domain = global_domain and ih_cust = cm_addr
      and ih_nbr >= nbr and ih_nbr <= nbr1
      and (ih_slspsn[1] >= slspsn and ih_slspsn[1] <= slspsn1) use-index ih_cust
      :

        for each idh_hist no-lock
        where idh_domain = global_domain and idh_nbr = ih_nbr
        and idh_part >= part and idh_part <= part1
        and idh_cum_date[2] >= cumdate and idh_cum_date[2] <= cumdate1
        and idh_site >= site and idh_site <= site1 use-index idh_invln
        :
          find pt_mstr where pt_domain = global_domain
           and pt_part = idh_part no-lock no-error.
          if not available pt_mstr then next.
          if pt_prod_line > prodline1 or pt_prod_line < prodline then next.
          create zzwkso.
          assign
            sonbr   = ih_nbr
            sopart      = idh_part
            invqty      = idh_qty_inv
            soprice     = idh_price
            soregion    = cm_region
            socust      = ih_cust
            ptline      = pt_prod_line
            soslspsn    = ih_slspsn[1].
          iTotalLine = iTotalLine + 1.
        end.
      end.

      for each so_mstr no-lock
      where so_domain = global_domain and so_cust = cm_addr
      and  so_nbr >= nbr and so_nbr <= nbr1
      and (so_slspsn[1] >= slspsn and so_slspsn[1] <= slspsn1) use-index so_cust
      :

        for each sod_det no-lock
        where sod_domain = global_domain and sod_nbr = so_nbr
        and sod_part >= part and sod_part <= part1
          and sod_cum_date[2] >= cumdate and sod_cum_date[2] <= cumdate1
          and sod_site >= site and sod_site <= site1
          and sod_qty_inv <> 0
          use-index sod_nbrln
          :
          find pt_mstr where pt_domain = global_domain
           and pt_part = sod_part no-lock no-error.
          if not available pt_mstr then next.
          if pt_prod_line > prodline1 or pt_prod_line < prodline then next.

          create zzwkso.
          assign
            sonbr   = so_nbr
            sopart      = sod_part
            invqty      = sod_qty_inv
            soprice     = sod_price
            soregion    = cm_region
            socust      = so_cust
            ptline      = pt_prod_line
            soslspsn    = so_slspsn[1].
          iTotalLine = iTotalLine + 1.
        end.
      end.

*/
