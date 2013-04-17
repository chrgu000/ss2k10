/* xxicrcin.i - 物料入库优先级选择                                            */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
 *
 *         {xsinv23.i
 *            &REC_PART = Recive part number
 *            &REC_SITE = Recive Site
 *            &REC_QTY  = Recive qty
 *          }
 *
 *----------------------------------------------------------------------------*/

define input parameter rec_part like pt_part.
define input parameter rec_site like pt_site.
define input parameter rec_qty  like ld_qty_oh.

define output parameter avail_loc like loc_loc.
define output parameter avail_qty like ld_qty_oh.

for each qad_wkfl exclusive-lock where qad_key1 = "xxicrcin.i"
     and qad_key3 = rec_part:
     delete qad_wkfl.
end.

for each xxpl_ref no-lock where xxpl_part = rec_part and
         xxpl_site = rec_site
   break by xxpl_rank by xxpl_loc descendin:
    for each ld_det no-lock where ld_site = xxpl_site and  ld_loc = xxpl_loc
         and ld_part = xxpl_part:
            ACCUM ld_qty_oh(TOTAL).
    end.
    if xxpl_type = "Y" then do:
       if (accum total ld_qty_oh) = 0 and xxpl_cap > rec_qty then do:
           create qad_wkfl.
           assign qad_key1 = "xxicrcin.i"
                  qad_key2 = xxpl_loc
                  qad_key3 = xxpl_part
                  qad_decfld[1] = rec_qty
                  qad_decfld[2] = (accum total ld_qty_oh)

                  avail_loc = xxpl_loc
                  avail_qty = rec_qty.
       end.
    end.
    else do:
       if xxpl_cap - (accum total ld_qty_oh) > 0 then do:
           create qad_wkfl.
           assign qad_key1 = "xxicrcin.i"
                  qad_key2 = xxpl_loc
                  qad_key3 = xxpl_part
                  qad_decfld[1] = min(rec_qty , xxpl_cap - (accum total ld_qty_oh))
                  qad_decfld[2] = (accum total ld_qty_oh)

                  avail_loc = xxpl_loc
                  avail_qty = min(rec_qty , xxpl_cap - (accum total ld_qty_oh)).

       end.
    end.
end.
