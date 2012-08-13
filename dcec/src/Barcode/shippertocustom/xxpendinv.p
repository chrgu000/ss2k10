{mfdtitle.i}
 DEFINE VAR cust LIKE so_cust.
DEFINE VAR cust1 LIKE so_cust.
FORM 
    skip(0.5)
    cust COLON 12 LABEL "销往"

    cust1 COLON 35 LABEL "至"
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME b
  sod_nbr AT 12 column-LABEL "订单号"
  sod_line  column-label "行号"
    sod_part  column-LABEL "零件号"
   
    sod_qty_ord   column-LABEL "订单数量"
     sod_qty_ship   column-LABEL "已结转销售成本数量"  SPACE(1.5)
    sod_qty_inv       column-LABEL "待开数量"
    WITH WIDTH 95 STREAM-IO DOWN  .
/*DEFINE FRAME c
    ABS_mstr.ABS_par_id colon 12 COLUMN-LABEL "货运单号"
 ABS_mstr.ABS_ship_qty COLUMN-LABEL "数量"
   
     WITH WIDTH 80 STREAM-IO DOWN OVERLAY NO-ATTR-SPACE .*/

REPEAT :

    do with frame a:
               SET cust cust1 EDITING:
               IF FRAME-FIELD = "cust" THEN DO:
              
                    {mfnp.i so_mstr cust so_cust cust so_cust so_cust
                       }
                IF recno <> ? THEN do:
               cust = so_cust.
               
                DISPLAY cust WITH FRAME a.
                
                
                 end.
                    
                    
                    END.
                  IF FRAME-FIELD = "cust1" THEN DO:
              
                    {mfnp.i so_mstr cust1 so_cust cust1 so_cust so_cust
                       }
                IF recno <> ? THEN do:
               cust1 = so_cust.
               
                DISPLAY cust1 WITH FRAME a.
                
                
                 end.
                    
                     
                    END.



                   END.
                END.


          {mfselbpr.i "printer" 80} 

             IF cust1 = " " THEN cust1 = hi_char.
              {mfphead.i}
             
    FOR EACH so_mstr WHERE so_cust >= cust AND so_cust <= cust1 no-lock:
      /* find first abs_mstr where abs_mstr.abs_order = so_mstr.so_nbr no-lock no-error.
        if available abs_mstr then do:*/
        FOR EACH sod_det WHERE sod_det.sod_nbr = so_mstr.so_nbr and /*sod_det.sod_qty_ship <> 0 and */ sod_det.sod_qty_inv <> 0 NO-LOCK:
           
          
            DISPLAY sod_nbr sod_line sod_part sod_qty_ord sod_qty_ship sod_qty_inv WITH FRAME b.
          /*  FOR EACH ABS_mstr WHERE ABS_mstr.abs_order = sod_det.sod_nbr and abs_mstr.abs_line = string(sod_det.sod_line) AND abs_mstr.abs_ITEM = sod_det.sod_part AND ABS_mstr.ABS_ship_qty <> 0 and sod_det.sod_qty_inv >= abs_mstr.abs_ship_qty  NO-LOCK:
                DISPLAY substr(ABS_mstr.ABS_par_id,2,50) @ ABS_mstr.ABS_par_id 
                       ABS_mstr.ABS_ship_qty WITH FRAME c.
            END.*/



        END.

  /* end.*/

    END.
    
      {mftrl080.i} 
    
    
    END.
