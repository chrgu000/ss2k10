OUTPUT TO sod.txt.
FOR EACH so_mstr NO-LOCK WHERE so_nbr = "A2121201":
    FOR EACH sod_det NO-LOCK WHERE sod_nbr = so_nbr WITH WIDTH 600:

    DISPLAY so_nbr so_cust so_bill so_ship so_ord_date so_req_date so_site
            sod_line sod_part sod_site sod_qty_ord sod_um sod_list_pr sod_price 
            sod_loc sod_acct sod_sub sod_req_date sod_due_date sod_per_date 
    WITH STREAM-IO.
            
    END.
END.