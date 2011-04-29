{mfdeclre.i }
{gplabel.i} 

define input parameter v_lot   like wo_lot     no-undo.
define input parameter v_sub   like wo_part    no-undo.



    for each xsub_det 
        use-index xsub_wolot
        where xsub_domain  = global_domain 
        and   xsub_wolot   = v_lot 
        and   xsub_subpart = v_sub
        exclusive-lock :

        delete xsub_det .

    end. /*for each xsub_det*/
