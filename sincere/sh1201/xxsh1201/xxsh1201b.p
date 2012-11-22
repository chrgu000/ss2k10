/* xxsh1201b.p - sh1201 item request calc                                    */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04   QAD:eb21sp6    Interface:Character        */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxsh1201.i}
{gplabel.i}
define variable qty as decimal.
define variable qtypo as decimal.
define variable sd as date.
define variable ed as date.
define variable i as integer.
define variable vterm as character.
/* calc BOM LST temp3*/
for each xxpln_mstr no-lock break by xxpln_par:
    if first-of(xxpln_par) then do:
       run getSubQty (input xxpln_par,input today).
    end.
end.
empty temp-table xxpnd_det no-error.
for each xxpln_mstr no-lock,
    each temp3 no-lock where xxpln_par = t3_part,
    each pt_mstr fields(pt_domain pt_part pt_group pt_ship_wt pt_net_wt pt_desc1 pt_desc2)
         no-lock where pt_domain = global_domain and pt_part = t3_comp and
         lookup(pt_group ,planItems ,",") > 0
         break by t3_comp by xxpln_date:
    if first-of(xxpln_date) then do:
       assign qty = 0.
    end.
    qty = qty + xxpln_qty * t3_qty_per.
/*     display xxpln_par t3_comp xxpln_date xxpln_qty t3_qty_per.  */
    if last-of(xxpln_date) then do:
       find first xxpnd_det exclusive-lock where xxpnd_comp = t3_comp
              and xxpnd_date = xxpln_date no-error.
       if not available xxpnd_det then do:
          create xxpnd_det.
          assign xxpnd_comp = t3_comp
                 xxpnd_date = xxpln_date.
       end.
          assign xxpnd_qty = xxpnd_qty + qty.
    end.
end.

for each xxpnd_det exclusive-lock:
    find first pt_mstr no-lock where pt_domain = global_domain and
         pt_part = xxpnd_comp no-error.
    if available pt_mstr then do:
       assign xxpnd_dev_date = xxpnd_date - integer(pt_ship_wt).
    end.
    if pt_net_wt > 0 then do:
    /*
       if xxpnd_qty <= pt_net_wt then do:
          assign xxpnd_dev_qty = pt_net_wt.
       end.
       else do:
          assign xxpnd_dev_qty = xxpnd_qty + pt_net_wt - xxpnd_qty mod pt_net_wt.
       end.
    */
       if xxpnd_qty mod pt_net_wt = 0 then do:
       		assign xxpnd_dev_qty = xxpnd_qty.
       end.
       else do:
       		assign xxpnd_dev_qty = xxpnd_qty + pt_net_wt - xxpnd_qty mod pt_net_wt.
       end.
    end.
    else do:
        assign xxpnd_dev_qty = xxpnd_qty.
    end.
end.

for each xxpnd_det exclusive-lock break by xxpnd_comp:
    if first-of(xxpnd_comp) then do:
       assign qty = 0
              qtypo = 0.
       /*  calc loc qty */
       for each ld_det no-lock use-index ld_part_loc where
                ld_domain = global_domain and
                ld_part = xxpnd_comp and ld_site = site,
           each loc_mstr no-lock where loc_domain = global_domain and
                loc_site = ld_site and loc_loc = ld_loc,
           each is_mstr no-lock where is_domain = global_domain and
                is_avail and loc_status = is_status:
           assign qty = qty + ld_qty_oh.
       end.
       /* calc open po */
       for each pod_det no-lock use-index pod_part where
                pod_domain = global_domain and
                pod_part = xxpnd_comp and pod_stat <> "X" and pod_stat <> "C":
           assign qtypo = qtypo + pod_qty_ord - pod_qty_rcvd.
       end.
    end.
    assign xxpnd_qty_oh = qty
           xxpnd_qty_onpo = qtypo.
end.

if can-find(first xxpnd_det) then do:

assign sd = hi_date
       ed = low_date.
for each xxpnd_det no-lock:
    if xxpnd_dev_date < sd then assign sd = xxpnd_dev_date.
    if xxpnd_dev_date > ed then assign ed = xxpnd_dev_date.
end.
assign maxArray = ed - sd.

/* put title*/
do i = 1 to 7:
   put unformat " " "~t".
end.
do i = 0 to maxArray:
   assign vterm = getWeekTerm (sd + i).
   put unformat getTermLabel(vterm,12) "~t".
end.
put skip.
put unformat trim(getTermLabel("ITEM_NUMBER",12)) "~t"
             trim(getTermLabel("DESCRIPTION",12)) "~t"
             trim(getTermLabel("DESCRIPTION",12)) "~t"
             trim(getTermLabel("MINIMUM_ORDER",12)) "~t"
             trim(getTermLabel("PURCHASE_LEAD_TIME",12)) "~t"
             trim(getTermLabel("QUANTITY_ON_HAND",12)) "~t"
             trim(getTermLabel("PO_QTY_OPEN",12)) "~t".
do i = 0 to maxArray:
   put unformat string(sd + i,"9999-99-99") "~t".
end.
   put skip.

for each pt_mstr fields(pt_domain pt_part pt_group pt_ship_wt pt_net_wt pt_desc1 pt_desc2)
         no-lock where pt_domain = global_domain and
         lookup(pt_group ,planItems ,",") > 0
    break by pt_part:
    find first xxpnd_det no-lock where (xxpnd_comp = pt_part) no-error.
    if available xxpnd_det then do:
       put unformat '"' trim(pt_part) '"' "~t"
                    '"' trim(pt_desc1) '"' "~t"
                    '"' trim(pt_desc2) '"' "~t"
                    pt_net_wt "~t"
                    pt_ship_wt "~t"
                    xxpnd_qty_oh "~t"
                    xxpnd_qty_onpo "~t".
        do i = 0 to maxArray:
           find first xxpnd_det no-lock use-index xxpod_comp_dev_date where
                     (xxpnd_comp = pt_part and xxpnd_dev_date = sd + i) no-error.
           if available xxpnd_det then do:
              put xxpnd_dev_qty "~t".
           end.
           else do:
              put " " "~t".
           end.
        end.
        put skip.
    end.  /* if available xxpnd_det then do: */
end.   /* for each pt_mstr */

/* for each xxpnd_det no-lock,                                               */
/*     each pt_mstr fields(pt_domain pt_part pt_group pt_ship_wt             */
/*                         pt_net_wt pt_desc1 pt_desc2) no-lock              */
/*          where pt_domain = global_domain and pt_part = xxpnd_comp         */
/*     with width 320 frame f:                                               */
/*     /* SET EXTERNAL LABELS */                                             */
/*     setFrameLabels(frame f:handle).                                       */
/* display xxpnd_comp xxpnd_qty_oh xxpnd_qty_onpo xxpnd_date pt_ship_wt      */
/*         xxpnd_dev_date xxpnd_qty pt_net_wt xxpnd_dev_qty .                */
/* end.                                                                      */

end.  /* if can-find(first xxpnd_det) then do: */
