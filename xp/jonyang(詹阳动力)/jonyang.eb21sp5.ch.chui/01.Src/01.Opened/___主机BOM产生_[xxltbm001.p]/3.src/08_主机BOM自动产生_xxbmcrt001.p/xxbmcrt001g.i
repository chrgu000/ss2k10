    v_retry = No .

    /*检查是否已经产生过主机BOM,*/
    for each temp1 break by t1_lot :
        find first xbm_mstr 
            use-index xbm_wolot
            where xbm_domain = global_domain 
            and xbm_lot      = t1_lot 
            /*
            and xbm_part     = t1_part
            and xbm_wolot    = t1_wolot
            and xbm_status   = "" */
        no-lock no-error .
        if avail xbm_mstr then do:
            message "此工单ID已产生过主机BOM,是否删除并重新产生? " update v_retry .
            if v_retry = no then do:
                undo mainloop, retry mainloop.
            end.
        end.
        if v_retry = yes then leave .
    end.
    
/****************************************************************************************************
找BOM是否被修改过,复制过,等,
**************************/
    



delete-old:  /*删除此工单之前产生的BOM*/
do on error undo,leave on endkey undo,leave :
    for each temp1 break by t1_wolot by t1_part by t1_lot:
        for each xbm_mstr
            where xbm_domain = global_domain 
            and xbm_lot  = t1_lot 
            exclusive-lock:

            for each xbmd_Det 
                where xbmd_domain = global_domain 
                and xbmd_lot = xbm_lot
                exclusive-lock 
                break by xbmd_lot by  xbmd_comp :
                
                for each xbmzp_det
                    where xbmzp_domain = global_domain
                    and xbmzp_lot = xbmd_lot
                    and xbmzp_zppart = xbmd_comp
                    exclusive-lock
                    break by xbmzp_lot by xbmzp_zppart by xbmzp_comp :

                    find first xused_det 
                        where xused_domain = global_domain 
                        and xused_wolot    = xbmzp_zpwo
                        and xused_part     = xbmzp_comp
                    no-error.
                    if avail xused_det then do:
                        xused_qty_used = max(0,xused_qty_used - xbmzp_qty_bom) .                            
                    end.


                    if last-of(xbmzp_zppart) then do:
                        find first xuse_mstr 
                            where xuse_domain = global_domain 
                            and xuse_wolot    = xbmzp_zpwo
                            and xuse_zppart   = xbmzp_zppart 
                        no-error.
                        if avail xuse_mstr then do:
                            xuse_qty_used = max(0,xuse_qty_used - xbmd_qty_bom) .                            
                        end.
                    end.

                    delete xbmzp_det .
                end. /*for each xbmzp_det*/

                delete xbmd_det.
            end. /*for each xbmd_Det*/

            delete xbm_mstr.
        end. /*for each xbm_mstr*/
    end. /*for each temp1*/

end. /*delete-old*/   
