{mfdeclre.i }
{gplabel.i} 

define input parameter v_lot   like wod_lot     no-undo.
define input parameter v_nbr   like wod_nbr     no-undo.
define input parameter v_sub   like wod_part    no-undo.
define input parameter v_part  like wod_part    no-undo.
define input parameter v_qty   like wod_bom_qty no-undo.


    define var v_bom_qty like wod_bom_qty no-undo.

    if v_qty = 0 then v_qty = 1 .

    find first xsub_det 
        use-index xsub_wolot
        where xsub_domain  = global_domain 
        and   xsub_wolot   = v_lot 
        and   xsub_part    = v_part
        and   xsub_subpart = v_sub
    no-error .
    if not avail xsub_det then do:
        create xsub_det.
        assign xsub_domain  = global_domain 
               xsub_wolot   = v_lot    
               xsub_wonbr   = v_nbr 
               xsub_part    = v_part  
               xsub_subpart = v_sub   
               .

        find first wod_det 
            where wod_domain  = global_domain 
            and   wod_lot     = v_lot 
            and   wod_part    = v_part
        no-lock no-error .
        v_bom_qty = if avail wod_det then wod_bom_qty else v_qty .

        assign xsub_qty      = v_bom_qty / v_qty 
               xsub_mod_date = today
               xsub_mod_user = global_userid 
               .

    end. /*if not avail xsub_det*/
