/* xsinv69.i - 物料入库优先级选择                                            */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
	 按托放的需要以整托入,按量的可以数量放
   库位放在       qad_charfld[1]
   可入托数在     qad_decfld[1]
   可入库数量放   qad_decfld[2]
------------------------------------------------------------------------------*/

define input parameter iPart like pt_part.
define variable varonhandldqty like ld_qty_oh.   /*库存数*/
define variable varpanelnumber as integer.       /*托数*/
for each qad_wkfl exclusive-lock where qad_key1 = "xsinv69.i,locstat"
     and qad_key3 = iPart:
         delete qad_wkfl.
end.
for each xxpl_ref no-lock where xxpl_part = ipart
   break by xxpl_part by xxpl_rank:
    for each ld_det no-lock where ld_part = ipart
         and ld_site = xxpl_site
         and ld_loc = xxpl_loc:
         ACCUMULATE ld_qty_oh (total).
    end.
    assign varonhandldqty = accumulate total(ld_qty_oh).
    assign varpanelnumber =
           TRUNCATE(((xxpl_cap * xxpl_panel) - varonhandldqty) / xxpl_cap,0).
    if xxpl_type = "Y" then do:
       if  varpanelnumber > 0
       then do:
       create qad_wkfl.
       assign qad_key1 = "xsinv69.i,locstat"
              qad_key2 = iPart + xxpl_rank + xxpl_loc + string(xxpl_cap)
              qad_key3 = ipart
              qad_key4 = xxpl_rank
              qad_key5 = xxpl_type
              qad_decfld[10] = xxpl_panel
              qad_decfld[11] = xxpl_cap
              qad_decfld[12] = varonhandldqty
              qad_charfld[1] = xxpl_site
              qad_charfld[2] = xxpl_loc
              qad_decfld[1] = varpanelnumber
              qad_decfld[2] = varpanelnumber * xxpl_cap.
       end.
    end.
    else do:
      if xxpl_cap - varonhandldqty > 0 then do:
         create qad_wkfl.
         assign qad_key1 = "xsinv69.i,locstat"
                qad_key2 = iPart + xxpl_rank + xxpl_loc + string(xxpl_cap)
                qad_key3 = ipart
                qad_key4 = xxpl_rank
                qad_key5 = xxpl_type
                qad_decfld[10] = xxpl_panel
                qad_decfld[11] = xxpl_cap
                qad_decfld[12] = varonhandldqty
                qad_charfld[1] = xxpl_site
                qad_charfld[2] = xxpl_loc
                qad_decfld[2] = xxpl_cap - varonhandldqty.
      end.
    end.
end.
