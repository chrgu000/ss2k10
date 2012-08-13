  
     {yye3rp.i}
     
     define INPUT PARAMETER i_comp like ps_comp.
     define variable comp like ps_comp.
     define variable level as integer.
     define variable maxlevel as integer format ">>>" .
     define variable eff_date as date /* column-label {&bmwuiqa_p_3} */ .
     define variable parent like ps_comp.
     define variable desc1 like pt_desc1.
     define variable um like pt_um.
     define variable phantom like mfc_logical format "yes" .
     define variable iss_pol like pt_iss_pol .
     define variable record as integer extent 100.
     define variable lvl as character format "x(7)" .
     define variable E3flag as logic.
     eff_date = today.

      define variable l_level   as integer initial 0 no-undo.
       define variable l_psrecid as recid no-undo.
        define variable l_next    like mfc_logical initial yes no-undo.
        define variable l_nextptp like mfc_logical initial no  no-undo.

        define buffer ptmstr1 for pt_mstr.
        define buffer psmstr  for ps_mstr.



        assign
           l_next    = yes
           l_nextptp = no
               level = 0
            comp      = i_comp
            parent = comp
            maxlevel  = min(maxlevel,99)
            level     = 1.

        find first ps_mstr use-index ps_comp where ps_comp = comp
        no-lock no-error.
        repeat:
           
           if not available ps_mstr then do:
          repeat:
             level = level - 1.
             if level < 1 then leave.
             find ps_mstr where recid(ps_mstr) = record[level]
             no-lock no-error.
             comp = ps_comp.
             find next ps_mstr use-index ps_comp where ps_comp = comp
             no-lock no-error.
             if available ps_mstr then leave.
          end.
           end.
           if level < 1 then leave.

           if eff_date = ? or (eff_date <> ? and
           (ps_start = ? or ps_start <= eff_date)
           and (ps_end = ? or eff_date <= ps_end)) then do:

          iss_pol = no.
          phantom = no.

          find pt_mstr where pt_part = ps_par no-lock no-error.
          if available pt_mstr then do:
             desc1 = pt_desc1.
             um = pt_um.
             iss_pol = pt_iss_pol.
             phantom = pt_phantom.
          end.
          else do:
             find bom_mstr no-lock where bom_parent = ps_par no-error.
             if available bom_mstr then
             assign um = bom_batch_um
                  desc1 = bom_desc.
             end.

          record[level] = recid(ps_mstr).
        /*
          lvl = ".......".
          lvl = substring(lvl,1,min(level - 1,6)) + string(level).
          if length(lvl) > 7 then
          lvl = substring(lvl,length(lvl) - 6,7).
*/
        
      /* update temp table */
         
         find first yye3m2 where ps_par begins yye3m2_prefix no-lock no-error.               
        
         if avail yye3m2 then do:
                
                find first pt_mstr where pt_mstr.pt_part = ps_par no-lock no-error. 
                if avail pt_mstr then do:
                   /* 有效生产状态检查 */
                
                   find first yye3m where yye3m_status = pt_status no-lock no-error.  
                   if avail yye3m then do:
                    
                        find first yypsm where yypsm_comp = i_comp no-error.
                        if not avail yypsm then create yypsm.
                        assign
                          yypsm_comp = i_comp 
                          yypsm_e3 = yes
                          yypsm_eff  = "Yes"
                          .
                          
                          leave . /*离开本程序 */
                   end.
                   else do:
                        find first yypsm where yypsm_comp = i_comp no-error.
                        if not avail yypsm then create yypsm.
                        assign
                          yypsm_comp = i_comp 
                          yypsm_e3 = yes
                          yypsm_eff  = "No"
                          .                                                    
                   end. /* yye3m */
                       .
                end. /* pt_mstr */
          end.
          /*  update end */
          
          if level < maxlevel or maxlevel = 0 then do:
             comp = ps_par.
             level = level + 1.
             find first ps_mstr use-index ps_comp where ps_comp = comp
             no-lock no-error.

               if not available ps_mstr then
               do:
                  run p-getbom.
               end. /* NOT AVAIL PS_MSTR */


          end.
          else do:
             find next ps_mstr use-index ps_comp where ps_comp = comp
             no-lock no-error.

               if not available ps_mstr then
               do:
                  run p-getbom.
               end. /* NOT AVAIL PS_MSTR */


          end.
           end.
           else do:
          find next ps_mstr use-index ps_comp where ps_comp = comp
          no-lock no-error.
           end.
        end.

    


        /* IF THE PRODUCT STRUCTURE RECORD IS NOT AVAILABLE THEN THIS  */
        /* PROCEDURE EXPLODES FURTHER USING THE PTP_DET AND PT-MSTR    */
        /* BY VERIFYING IF THE COMPONENT EXISTS AS A BOM CODE FOR ANY  */
        /* OTHER ITEMS.                                                */

        PROCEDURE p-getbom:
           if l_next = yes then do:
              for first ptp_det
                 fields(ptp_bom_code ptp_part)
                 where ptp_det.ptp_bom_code = comp
              no-lock : end. /* FOR FIRST PTP_DET */
              if available ptp_det then do:
                 l_nextptp = yes.
                 for first ptmstr1
                    fields(pt_bom_code pt_desc1 pt_desc2
                           pt_iss_pol pt_part pt_phantom)
                    where  ptmstr1.pt_part = ptp_part
                 no-lock : end. /* FOR FIRST PTMSTR1 */
              end. /* IF AVAILABLE PTP_DET */
              else
                 for first ptmstr1
                    fields(pt_bom_code pt_desc1 pt_desc2
                           pt_iss_pol pt_part pt_phantom)
                    where ptmstr1.pt_bom_code = comp
                 no-lock : end. /* FOR FIRST PTMSTR1 */

              for first psmstr
                 fields(ps_comp ps_end ps_lt_off ps_par
                        ps_ps_code ps_qty_per ps_qty_per_b
                        ps_qty_type ps_ref ps_scrp_pct ps_start)
                 where psmstr.ps_par = comp
              no-lock : end. /* FOR FIRST PSMSTR */
              if available psmstr then
                 assign
                    l_psrecid = recid(psmstr)
                    l_level = level.
           end. /* L_NEXT = YES */
           else do:
              for first psmstr
                 fields(ps_comp ps_end ps_lt_off ps_par
                        ps_ps_code ps_qty_per ps_qty_per_b
                        ps_qty_type ps_ref ps_scrp_pct ps_start)
                 where recid(psmstr) = l_psrecid
              no-lock : end. /* FOR FIRST PSMSTR */
              find next ptp_det
                 where ptp_det.ptp_bom_code = psmstr.ps_par
              no-lock no-error.
              if available ptp_det then do:
                 for first ptmstr1
                    fields(pt_bom_code pt_desc1 pt_desc2
                           pt_iss_pol pt_part pt_phantom)
                    where ptmstr1.pt_part = ptp_part
                 no-lock : end. /* FOR FIRST PTMSTR1 */
              end. /* IF AVAIL PTP_DET */
              else do:
                 if l_nextptp = yes then
                 do:
                    for first ptmstr1
                    fields(pt_bom_code pt_desc1 pt_desc2
                           pt_iss_pol pt_part pt_phantom)
                       where ptmstr1.pt_bom_code = psmstr.ps_par
                    no-lock : end. /* FOR FIRST PTMSTR1 */
                    l_nextptp = no.
                 end. /* IF L_NEXTPTP = YES */
                 else do:
                    find next ptmstr1
                       where ptmstr1.pt_bom_code = psmstr.ps_par
                       and not(can-find (first ptp_det
                               where ptp_part = pt_part and
                               ptp_bom_code = ptmstr1.pt_bom_code))
                    no-lock no-error.
                    l_nextptp = no.
                 end. /* ELSE IF L_NEXTPTP = NO */
              end. /* IF NOT AVAILABLE PTP_DET */
              if available ptmstr1 then do:
                 level = l_level.
              end. /* IF AVAILABLE PTMSTR1 */
              end. /* ELSE IF L_NEXT = NO */

              bomloop1:
              do while available ptmstr1:
                 l_next = no.
                 for first ps_mstr
                 fields(ps_comp ps_end ps_lt_off ps_par
                        ps_ps_code ps_qty_per ps_qty_per_b
                        ps_qty_type ps_ref ps_scrp_pct ps_start)
                    where ps_mstr.ps_comp = ptmstr1.pt_part use-index ps_comp
                 no-lock : end. /* FOR FIRST PS_MSTR */
                 if available ps_mstr then do:
                       comp = ptmstr1.pt_part.
                       leave bomloop1.
                 end. /* if available ps_mstr */
                 else if not available ps_mstr then do:
                    find next  ptp_det where ptp_det.ptp_bom_code = comp
                    no-lock no-error.
                       if available ptp_det then do:
                          find next ptmstr1
                             where ptmstr1.pt_part = ptp_part
                          no-lock no-error.
                       end. /* IF AVAIL PTP_DET */
                       else  do:
                          find next ptmstr1
                             where ptmstr1.pt_bom_code = comp
                          no-lock no-error.
                          if not available ptmstr1 then do:
                             for first psmstr
                                fields(ps_comp ps_end ps_lt_off ps_par
                                       ps_ps_code ps_qty_per ps_qty_per_b
                                       ps_qty_type ps_ref ps_scrp_pct ps_start)
                                where recid(psmstr) = l_psrecid
                             no-lock : end. /* FOR FIRST PSMSTR */
                             find next ptmstr1
                                where ptmstr1.pt_bom_code = psmstr.ps_par
                                and not(can-find (first ptp_det
                                        where ptp_part = pt_part and
                                        ptp_bom_code = ptmstr1.pt_bom_code))
                             no-lock no-error.
                          end. /* IF NOT AVAILABLE PTMSTR1 */
                       end. /* ELSE DO */
                 end. /* IF NOT AVAIL PS_MSTR */
              end. /* IF AVAILABLE PTMSTR BOMLOOP1 */
        END PROCEDURE. /* P-GETBOM */
