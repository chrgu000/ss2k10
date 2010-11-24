/** 根据TR推算指定日期的库存  by ZY  08-06-10                               **/

/* temp table for save locaton information */
DEFINE temp-table tmpsto no-undo
    field tmp_part    like pt_part
    field tmp_site    like loc_site
    field tmp_loc     like loc_loc
    field tmp_qty     like ld_qty_oh
    field tmp_rct_qty like ld_qty_oh
    INDEX tmp_site_loc tmp_part tmp_site tmp_loc.

/** Main Procedure **/
procedure getGivenDaySto :
    define input  parameter cxdate1  as date.
    define input  parameter part     like pt_part.
    define output parameter qty      like ld_qty_oh.
    define output parameter rctpoqty like ld_qty_oh.

    DEFINE VARIABLE endbalance LIKE tr_qty_loc no-undo.
    define variable rctqty     like tr_qty_loc no-undo.
    empty temp-table tmpsto no-error.
    FOR EACH ld_det NO-LOCK use-index ld_part_loc
             where ld_part = part BREAK BY ld_site by ld_loc:
        if first-of (ld_loc) then do:
            ASSIGN endbalance = ld_qty_oh .
        end.
        else do:
            ASSIGN endbalance = endbalance + ld_qty_oh.
        end.
        if LAST-OF(ld_loc) then do:
            create tmpsto.
            ASSIGN tmp_part  = ld_part
                   tmp_site  = ld_site
                   tmp_loc   = ld_loc
                   tmp_qty   = endbalance.
        end.
    END.

    for each tr_hist where tr_part = part and tr_effdate > cxdate1
/*
        and tr_ship_type <> "M"
        AND (tr_type <> "ISS-PRV" OR tr_ship_type <> "s")
        and (tr_type <> "RCT-PO" OR tr_ship_type <> "s")
*/
      use-index tr_part_eff no-lock
      break by tr_site by tr_loc:
      if first-of(tr_loc) then do:
         ASSIGN endbalance   = 0
            rctqty       = 0.
      end.
      endbalance = endbalance - tr_qty_loc.
      if tr_type = "RCT-PO" then
          assign rctqty = rctqty + tr_qty_loc.
      if LAST-OF(tr_loc) then do:
         find first tmpsto exclusive-lock where tmp_part = tr_part
                and tmp_site = tr_site and tmp_loc = tr_loc no-error.
         if avail tmpsto then do:
             ASSIGN tmp_qty = tmp_qty + endbalance
                    tmp_rct_qty = tmp_rct_qty + rctqty.
         end.
         else do:
             create tmpsto.
             ASSIGN tmp_part    = tr_part
                    tmp_site    = tr_site
                    tmp_loc     = tr_loc
                    tmp_qty     = endbalance
                    tmp_rct_qty = rctqty.
         end.
      end.
    end.
    ASSIGN endbalance = 0
           rctqty = 0.
    FOR EACH tmpsto exclusive-LOCK WHERE tmp_part = part:
      assign endbalance = endbalance + tmp_qty
             rctqty =  rctqty + tmp_rct_qty.
    END.
    assign qty = endbalance
           rctpoqty = rctqty.
end procedure.


/* define variable qtyloc like ld_qty_oh.                                       */
/* define variable qtyrct like ld_qty_oh.                                       */
/* run getGivenDaySto(input TODAY - 1,input "001",output qtyloc,OUTPUT qtyrct). */
/* display qtyloc qtyrct COLUMN-LABEL "QtyRC-TPO" qtyloc + qtyrct.              */
/*                                                                              */
