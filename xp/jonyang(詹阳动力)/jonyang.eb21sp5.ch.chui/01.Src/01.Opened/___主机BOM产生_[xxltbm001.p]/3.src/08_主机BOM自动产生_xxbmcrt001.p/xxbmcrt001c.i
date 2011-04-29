    /*��鷢��״��,ZP����ָ��,ZP����ռ����ϸ��,ȷ���Ƿ���Բ�������BOM*/
    for each temp2 :
        /*������Ϻ���Ʒ����(�������)*/
        if t2_part = wo_part then do:
            message "����:���ϰ�������,��ʹ������BOM����" .
            undo mainloop, retry mainloop.
        end. /*if tr_hist.tr_part =*/

        /*���Ʒ�ķ���*/
        if t2_part begins "ZP" then do:
            find first xzp_det 
                where xzp_domain = global_domain 
                and   xzp_wolot  = t2_wolot
                and   xzp_zppart = t2_part 
            no-lock no-error .
            if not avail xzp_det then do:
                message "����:ZP��δָ�����Ʒ����".
                undo mainloop, retry mainloop.
            end.
            else do:
                /* ����Ƿ����ռ����ϸ��xused_det,û�е�Ҫ����*/
                v_ii = 0 .
                do v_ii = 1 to num-entries(xzp_zpwo,",") :
                    v_wo_tmp = entry(v_ii,xzp_zpwo,",") .   
                    find first xuse_mstr 
                        where xuse_domain = global_domain 
                        and xuse_wolot    = v_wo_tmp 
                        and xuse_zppart   = xzp_zppart
                    no-lock no-error.
                    if avail xuse_mstr then do:
                        next . 
                    end.
                    else do:
                        /* ����ռ����ϸ��xused_det from tr_hist **/
                        find first wo_mstr where wo_domain = global_domain and wo_lot = v_wo_tmp no-lock no-error .
                        if avail wo_mstr then do:                        
                                for each tr_hist 
                                    use-index tr_nbr_eff
                                    where tr_hist.tr_domain = global_domain 
                                    and   tr_hist.tr_nbr    = wo_nbr 
                                    and   tr_hist.tr_lot    = wo_lot
                                    and   (tr_hist.tr_type   = "RCT-wo" or tr_hist.tr_type   = "ISS-wo" )
                                    no-lock:

                                    if tr_hist.tr_type = "ISS-wo" then do:
                                        find first xused_det 
                                            where xused_domain = global_domain  
                                            and xused_wolot    = tr_hist.tr_lot 
                                            and xused_part     = tr_hist.tr_part 
                                        no-error.
                                        if not avail xused_det then do:
                                            create xused_det .
                                            assign xused_wolot = tr_hist.tr_lot 
                                                   xused_part  = tr_hist.tr_part
                                                   xused_wonbr = tr_hist.tr_nbr
                                                   xused_zppart = wo_part 
                                                   xused_domain = global_domain 
                                                   .
                                        end.
                                        xused_qty_iss = xused_qty_iss + (- tr_hist.tr_qty_loc) .
                                    end.
                                    else do:
                                        find first xuse_mstr 
                                            where xuse_domain = global_domain  
                                            and xuse_wolot    = tr_hist.tr_lot 
                                            and xuse_zppart     = tr_hist.tr_part 
                                        no-error.
                                        if not avail xuse_mstr then do:
                                            create xuse_mstr .
                                            assign xuse_wolot   = tr_hist.tr_lot 
                                                   xuse_zppart  = tr_hist.tr_part
                                                   xuse_wonbr   = tr_hist.tr_nbr
                                                   xuse_domain = global_domain 
                                                   .
                                        end.
                                        xuse_qty_rct = xuse_qty_rct + tr_hist.tr_qty_loc .
                                    end.
                                    
                                end . /*for each tr_hist*/
                                

                                /*����ZP�ӹ������в��ϵ������ϵ*/
                                for each xused_det 
                                        where xused_domain = global_domain  
                                        and xused_wolot    = wo_lot :

                                        if xused_qty_iss = 0 then do:
                                            delete xused_det .
                                            next.
                                        end.

                                        find first wod_det 
                                            where wod_domain = global_domain 
                                            and wod_lot  = xused_wolot
                                            and wod_part = xused_part
                                        no-lock no-error .
                                        if avail wod_det then do:
                                            xused_qty_bom = wod_bom_qty .
                                        end.

                                        find first xsub_det 
                                            use-index xsub_wolot_sub
                                            where xsub_domain  = global_domain 
                                            and   xsub_wolot   = xused_wolot
                                            and   xsub_subpart = xused_part 
                                        no-lock no-error.
                                        if not avail xsub_det then do:
                                            xused_part_by  = xused_part .
                                        end.
                                        else do:
                                            xused_part_by = xsub_part .
                                            find first xsub_det 
                                                use-index xsub_wolot_sub
                                                where xsub_domain = global_domain 
                                                and   xsub_wolot  = xused_wolot
                                                and   xsub_part   = xused_part 
                                            no-lock no-error.
                                            if avail xsub_det then xused_sub_type  = yes . /*�ҵõ��㼶�����,�����������1*/

                                            repeat :
                                                find first xsub_det 
                                                    use-index xsub_wolot_sub
                                                    where xsub_domain  = global_domain 
                                                    and   xsub_wolot   = xused_wolot
                                                    and   xsub_subpart = xused_part_by 
                                                no-lock no-error.
                                                if not avail xsub_det then leave .
                                                else do:
                                                    xused_part_by   = xsub_part .
                                                    xused_sub_type  = yes . /*�ҵõ��㼶�����,�����������2*/
                                                end.
                                            end.
                                        end.
                                end. /*for each xused_det */
                        end. /*if avail wo_mstr then */
                    end. /*else do:*/
                end.  /*do v_ii = 1 to num-entries(xzp_zpwo,",")*/
            end. /*else do: avail xzp_det */
        end. /*if t2_part begins "ZP"*/
    end . /*for each temp2*/


    /*���������������в��ϵ������ϵ*/
    for each temp2 break by t2_part :

        find first wod_det 
            where wod_domain = global_domain 
            and wod_lot  = t2_wolot
            and wod_part = t2_part
        no-lock no-error .
        if avail wod_det then do:
            t2_qty_bom = wod_bom_qty .
        end.

        find first xsub_det 
            use-index xsub_wolot_sub
            where xsub_domain  = global_domain 
            and   xsub_wolot   = t2_wolot
            and   xsub_subpart = t2_part 
        no-lock no-error.
        if not avail xsub_det then do:
            t2_part_by  = t2_part .
        end.
        else do:
            t2_part_by = xsub_part .
            find first xsub_det 
                use-index xsub_wolot_sub
                where xsub_domain = global_domain 
                and   xsub_wolot  = t2_wolot
                and   xsub_part   = t2_part 
            no-lock no-error.
            if avail xsub_det then t2_sub_type  = yes . /*�ҵõ��㼶�����,�����������1*/
            
            repeat :
                find first xsub_det 
                    use-index xsub_wolot_sub
                    where xsub_domain  = global_domain 
                    and   xsub_wolot   = t2_wolot
                    and   xsub_subpart = t2_part_by 
                no-lock no-error.
                if not avail xsub_det then leave .
                else do:
                    t2_part_by   = xsub_part .
                    t2_sub_type  = yes . /*�ҵõ��㼶�����,�����������2*/
                end.
            end.
        end.
    end . /*for each temp2*/


    /*�������Ԥ�ȷ���xpre_det��ZP�ӹ����Ƿ����*/
    for each temp1 
        break by t1_wolot by t1_part by t1_lot :

            for each xpre_det 
                where xpre_domain = global_domain 
                and xpre_part = t1_part 
                and xpre_lot  = t1_lot 
                and xpre_part <> xpre_zppart 
                no-lock break by xpre_part by xpre_lot by xpre_zppart by xpre_comp :

                if first-of(xpre_zppart) then do:
                    v_jj = 0 .
                    v_zp_wod_part = "" .
                    v_zp_wod_qty  = 0 .
                end.

                v_jj = v_jj + 1 .
                v_zp_wod_part[v_jj] = xpre_comp .
                v_zp_wod_qty[v_jj]  = xpre_qty  .

                if last-of(xpre_zppart) then do:
                    find first xzp_det 
                        where xzp_domain = global_domain 
                        and xzp_wolot    = t1_wolot 
                        and xzp_zppart   = xpre_zppart
                    no-lock no-error .
                    if avail xzp_det then do:
                        v_ii = 0 .
                        do v_ii = 1 to num-entries(xzp_zpwo,",") :
                                v_wo_tmp = entry(v_ii,xzp_zpwo,",") . 
                                v_yn = no .
                                v_kk = 0 .
                                do v_kk = 1 to v_jj :
                                    find first xused_det
                                        where xused_domain = global_domain 
                                        and xused_wolot  = v_wo_tmp 
                                        and xused_part = v_zp_wod_part[v_kk]
                                        and xused_qty_iss - xused_qty_used >= v_zp_wod_qty[v_kk] 
                                    no-lock no-error.
                                    if avail xused_det then v_yn = yes .
                                    else v_yn = no .

                                    if v_yn = no then leave .
                                end. /*do v_kk = 1 to v_jj*/

                                if v_yn = yes then do:
                                    find first xuse_mstr 
                                        where xuse_domain = global_domain 
                                        and xuse_wolot    = v_wo_tmp
                                        and xuse_zppart   = xpre_zppart
                                    no-error .
                                    if avail xuse_mstr then do:
                                        if xuse_qty_rct - xuse_qty_used <= 0 then v_yn = no .
                                    end.
                                end.
                                if v_yn = yes then leave .
                        end. /*do v_ii = 1 to num-entries(xzp_zpwo,",")*/
                        if v_yn = no then do:
                            message "����:ZP��(" xzp_zppart ")ָ���Ĺ���,�޷���������(" t1_lot ")Ҫ���ȷ�������" .
                            undo mainloop, retry mainloop.
                        end.
                        else do:
                            find first temp3 
                                where t3_wolot = t1_wolot
                                and t3_part    = t1_part 
                                and t3_lot     = t1_lot 
                                and t3_zppart  = xpre_zppart
                            no-error .
                            if not avail temp3 then do:
                                create temp3.
                                assign t3_wolot = t1_wolot
                                       t3_part    = t1_part       
                                       t3_lot     = t1_lot        
                                       t3_zppart  = xpre_zppart   
                                       t3_zpwo    = v_wo_tmp      
                                       .
                            end.
                        end.
                    end. /*if avail xzp_det*/

                end. /*if last-of(xpre_zppart) */
            end. /*for each xpre_det*/


    end. /*for each temp1*/

release xuse_mstr .
release xused_det .