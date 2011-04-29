/* REVISION: eb SP5 create 04/20/04 BY: *EAS036A* Apple Tam */
/* SS - 091230.1  By: Roger Xiao */

define shared variable sanbr like shah_sanbr.
define shared variable pinbr like shah_pinbr.
define shared variable snnbr like sn_nbr no-undo.
define new shared variable sqnbr3     as integer format ">>9"   .

define shared variable total_ctn     like shah_ttl_ctn    .
define shared variable total_plt     like shah_ttl_plt  .
define shared variable total_qty     like sn_total_qty    .
define shared variable total_grosswt like sn_total_grosswt.
define shared variable total_cbm     like sn_total_cbm    .

define shared variable sqnbr    as integer format ">>9".
define shared variable pltnbr   like snh_plt_nbr.
define shared variable sonbr    like so_nbr.
define shared variable part3    like snh_part.
define shared variable desc1    like pt_desc1.
define shared variable desc2    like pt_desc2.
define shared variable destin   like snh_destin.
define shared variable consign  like snh_ctn_consign.
define shared variable loc      like snh_loc.
define shared variable type     like snh_type.
define shared variable ship_via as logical format "A/S".
define shared variable po1      like snh_po format "x(20)".
define shared variable method   like snh_method.
define shared variable modesc   as character format "x(62)".
define shared variable forw     like snh_forwarder format "(28)".
define shared variable ref      like snh_reference.

define shared variable ctn_line      as integer format ">>9".
define shared variable ctnnbr_fm     like snd_ctnnbr_fm.
define shared variable ctnnbr_to     like snd_ctnnbr_to.
define shared variable ctn_qty       as integer format ">,>>9".       
define shared variable qtyper        as integer format ">,>>>,>>9".   
define shared variable ext_qty       as decimal format ">,>>>,>>9.9<".
define shared variable netwt         as decimal format ">,>>9.99".    
define shared variable ext_netwt     as decimal format ">,>>>,>>9.9<".
define shared variable grosswt       as decimal format ">>,>>9.99".   
define shared variable ext_grosswt   as decimal format ">,>>>,>>9.9<".
define shared variable length        as decimal format ">>9.9".       
define shared variable height        as decimal format ">>9.9".       
define shared variable width         as decimal format ">>9.9".       
define shared variable cbm           as decimal format ">>,>>9.9<<".  
define shared variable p_ext_grosswt   as decimal format ">,>>>,>>9.9<".
define shared variable p_length        as decimal format ">>9.9".       
define shared variable p_height        as decimal format ">>9.9".       
define shared variable p_width         as decimal format ">>9.9".       
define shared variable p_cbm           as decimal format ">>,>>9.9<<".  

define shared variable shipto3       like snp_shipto     .
/*define shared variable nbr3          like snp_nbr        .
define shared variable ext_grosswt3  like snp_ext_grosswt.
define shared variable length3       like snp_length     .
define shared variable height3       like snp_height     .
define shared variable width3        like snp_width      .
define shared variable cbm3          like snp_cbm        .

define shared variable snnbr2 like sn_nbr no-undo.
define shared variable sndate2 like sn_date no-undo.
define shared variable sntime2 like sn_time no-undo.
define shared variable snwk2  like sn_ship_wk no-undo.
define shared variable part2 like snd_part no-undo.
define shared variable order2 like snd_so_order no-undo.
define shared variable ext_qty2 like snd_ext_qty no-undo.*/

define shared variable con-yn like mfc_logical initial no.
define variable del-yn2 like mfc_logical initial no.
define variable del-yn3 like mfc_logical initial no.
define variable go-yn like mfc_logical initial no.
define variable sh-yn like mfc_logical initial yes.
define variable via as char format "x(1)".
define variable um2 like sod_um.
define variable fm2 like shad_ctnnbr_fm.
define variable to2 like shad_ctnnbr_to.
define variable qty2 like shad_ext_qty.


define variable m as integer.
define variable m2 as integer.
define variable jj as integer.
define variable cbm# like shad_plt_cbm.

define new shared variable sq3    as integer format ">>9".

define shared temp-table xxln_tmp
                field xxln_sq_nbr        as integer format ">>9"
                field xxln_ctn_line      as integer format ">>9"
                field xxln_ctnnbr_fm     like snd_ctnnbr_fm 
                field xxln_ctnnbr_to     like snd_ctnnbr_to     
                field xxln_ctn_qty       like snd_ctn_qty      
                field xxln_qtyper        like snd_qtyper        
                field xxln_ext_qty       like snd_ext_qty       
                field xxln_netwt         like snd_netwt        
                field xxln_ext_netwt     like snd_ext_netwt     
                field xxln_grosswt       like snd_grosswt      
                field xxln_ext_grosswt   like snd_ext_grosswt   
                field xxln_length        like snd_ctn_length    
                field xxln_height        like snd_ctn_height    
                field xxln_width         like snd_ctn_width     
                field xxln_cbm           like snd_cbm
                field xxln_pext_grosswt   like snd_ext_grosswt   
                field xxln_plength        like snd_ctn_length    
                field xxln_pheight        like snd_ctn_height    
                field xxln_pwidth         like snd_ctn_width     
                field xxln_pcbm           like snd_cbm
               index xxln_line IS PRIMARY UNIQUE xxln_sq_nbr xxln_ctn_line ascending
                . 

/* SS - 091230.1 - B */
define shared variable soline    like sod_line no-undo.
/* SS - 091230.1 - E */
define shared temp-table  xxsq_tmp
        field xxsq_sq_nbr   /* like snh_sq_nbr*/ as integer format ">>9"
                field xxsq_plt_nbr  like snh_plt_nbr
                field xxsq_so_order like snh_so_order
/* SS - 091230.1 - B */
                field xxsq_so_line  like snh_so_line
/* SS - 091230.1 - E */
                field xxsq_shipto   like snh_shipto  
                field xxsq_part     like snh_part    
                field xxsq_qty_open like sod_qty_ord format ">,>>>,>>9.9<"
                field xxsq_part_um  like snh_part_um 
                field xxsq_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
               index xxsq_nbr IS PRIMARY UNIQUE xxsq_sq_nbr ascending
               .

define shared temp-table  xxsq2_tmp
                field xxsq2_flag                as character format "x(1)" 
                field xxsq2_sel                as character format "x(1)" 
        field xxsq2_sq_nbr   /* like snh_sq_nbr*/ as integer format ">>9"
                field xxsq2_plt_nbr  like snh_plt_nbr
                field xxsq2_shipto   like snh_shipto  
                field xxsq2_ponbr        like shad_ponbr
                field xxsq2_part     like snh_part    
                field xxsq2_ctnnbr_fm like shad_ctnnbr_fm
                field xxsq2_ctnnbr_to like shad_ctnnbr_to
                field xxsq2_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
        index xxsq2_nbr IS PRIMARY UNIQUE xxsq2_sq_nbr ascending
                .
define temp-table xxplt_tmp
                  field xxplt_snnbr   like shad_snnbr
                  field xxplt_plt_nbr like shad_plt_nbr
                  field xxplt_sq      like shad_sq
                  field xxplt_sanbr   like shad_sanbr
        index xxplt_nbr IS PRIMARY UNIQUE xxplt_plt_nbr ascending
                  .
define variable sel_old_value like xxsq2_sel.
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable global_userid like usr_userid.
define buffer xxshad_buff for shad_det.

                {gplabel.i}
                
                
                FORM 
                        xxsq2_flag                        no-label  format "x(1)" space(1)
                        xxsq2_sel                label "Sel " format "x(1)" space(1)
                        xxsq2_sq_nbr           label "SQ" format ">>9" space(1)
                        xxsq2_plt_nbr          label "PLT" format ">>9" space(1)
                        xxsq2_shipto           label "Ship TO" format "x(8)" space(1)                
                        xxsq2_ponbr                label "PO No." format "x(8)"                 space(1)        
                        xxsq2_part             format "x(18)" space(1)
                        xxsq2_ctnnbr_fm        label "FM" format ">>>9" space(1)                        
                        xxsq2_ctnnbr_to        label "To" format ">>>9"                 space(1)        
                        xxsq2_qty_ship         label "To Ship QTY" format ">,>>>,>>9.9<"
                                with frame w /*SIDE-LABELS*/
           /* row 6
            column 6*/
            scroll 1
            6 down 
           /* OVERLAY */
            no-validate
            attr-space
            TITLE ""
            WIDTH 80 .

                setFrameLabels(frame w:handle).

                for each xxsq2_tmp:
                    delete xxsq2_tmp.
                end.

                        fm2 = 0.
                        to2 = 0.
                        qty2 = 0.
                        for each shad_det where shad_sanbr = sanbr 
                                            and shad_snnbr = snnbr 
                                            and shad_line > 0
                                            break by shad_sq:
/*                                                                  and shad_sq = snd_sq_nbr :*/
                           if first-of(shad_sq) then fm2 = shad_ctnnbr_fm.
                           qty2 = qty2 + shad_ext_qty.
                           if last-of(shad_sq) then do:
                                create xxsq2_tmp.
                                assign
                                        xxsq2_sel                = "Y"
                                        xxsq2_sq_nbr                = shad_sq
                                        xxsq2_plt_nbr        = shad_plt_nbr
                                        xxsq2_shipto                = shad_shipto
                                        xxsq2_ponbr                = shad_ponbr
                                        xxsq2_part                = shad_part
                                        xxsq2_ctnnbr_fm        = fm2
                                        xxsq2_ctnnbr_to        = shad_ctnnbr_to
                                        xxsq2_qty_ship        = qty2.
                           fm2 = 0.
                           qty2 = 0.
                           end.
                        END.

                FOR EACH snd_ctn_det where snd_sn_nbr = snnbr and snd_ctn_status <> "D" and 
                                (snd_sanbr = "" or snd_sanbr = sanbr) no-lock break by snd_sq_nbr :
                        FIND first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = snd_sq_nbr and snh_ctn_status <> "D" NO-ERROR.
                                FIND first xxsq2_tmp where xxsq2_sq_nbr = snd_sq_nbr NO-ERROR.
                                if not available xxsq2_tmp then do:
                                   if first-of(snd_sq_nbr) then fm2 = snd_ctnnbr_fm.
                                   if available snh_ctn_hdr then qty2 = qty2 + snh_qty_ship.
                                   if last-of(snd_sq_nbr) then do:
                                        create xxsq2_tmp.
                                        assign 
                                                xxsq2_sel                = " "
                                                xxsq2_sq_nbr                = snd_sq_nbr
                                                xxsq2_plt_nbr        = snd_plt_nbr
                                                xxsq2_shipto                = snd_shipto
                                                xxsq2_ponbr                = snh_po when available snh_ctn_hdr
                                                xxsq2_part                = snd_part
                                                xxsq2_ctnnbr_fm  = fm2 /*snd_ctnnbr_fm*/
                                                xxsq2_ctnnbr_to        = snd_ctnnbr_to
                                                xxsq2_qty_ship   = qty2 /*snh_qty_ship when available snh_ctn_hdr*/ .
                                      qty2 = 0.
                                      fm2 = 0.
                                   end.
                                end.

                END.

            pause 0.
            view frame w.
            pause before-hide.
            
            find first xxsq2_tmp no-error.
            if not available xxsq2_tmp then leave.

            do:  
               {windo1u.i
               xxsq2_tmp 
               "
                           xxsq2_flag
                           xxsq2_sel                
                           xxsq2_sq_nbr   
                           xxsq2_plt_nbr when xxsq2_plt_nbr > 0  
                           xxsq2_shipto   
                           xxsq2_ponbr                
                           xxsq2_part     
                           xxsq2_ctnnbr_fm
                           xxsq2_ctnnbr_to
                           xxsq2_qty_ship 
                           "
               "xxsq2_flag"
               "use-index xxsq2_nbr" 
               yes
                           " "
                           " "
               }
            

               if keyfunction(lastkey) = "RETURN" then do:
                  find xxsq2_tmp
                  where recid(xxsq2_tmp) = recidarray[frame-line(w)].
                                  sel_old_value = xxsq2_sel.
                  /*update statement*/
                  UPDATE  
                      xxsq2_sel        validate ( input xxsq2_sel = "" or index(" YE",input xxsq2_sel) > 0, "Error: Invalid selection code. Please re-enter." )         
                                          .
                  if xxsq2_sel <> "" then do:
                        xxsq2_sel = upper(xxsq2_sel).
                        display xxsq2_sel.
                  end.

                IF xxsq2_sel = "E" and sel_old_value = "Y" THEN
                DO:
                        message "Error: SQ being selected. Please un-select before editing" view-as alert-box.
                        xxsq2_sel = "Y".
                        display xxsq2_sel.
                END.
                if xxsq2_sel = "E" then do:
                   hide frame w no-pause.
                   sqnbr = xxsq2_sq_nbr.
                   {gprun.i ""xxshadmte.p""}
                   view frame w.
                        xxsq2_sel = "Y".
                        display xxsq2_sel.
                end.
                if xxsq2_sel = "" and sel_old_value = "Y" then do:
                        for each shad_det where shad_sanbr = sanbr and shad_sq = xxsq2_sq_nbr :
                            delete shad_det.
                        end.
/**********
                        FIND first shah_hdr where shah_sanbr = sanbr NO-ERROR.
                        if available shah_hdr then do:
                             sqnbr3 = xxsq2_sq_nbr.
                            /* run satotal.*/
                                   assign                   
                                   total_ctn     = 0       
                                   total_plt    = 0        
                                   total_qty     = 0       
                                   total_grosswt = 0       
                                   total_cbm     = 0.      
                                   for each shad_det where shad_sanbr = sanbr and shad_plt_nbr > 0 break by shad_plt_nbr:
                                       if last-of(shad_plt_nbr) then total_plt = total_plt + 1.
                                   end.
                                   for each shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_line > 0:
                                                         total_ctn = total_ctn + shad_ctnnbr_to - shad_ctnnbr_fm + 1.
                                                         total_qty     = total_qty     + shad_ext_qty.
                                                         total_grosswt = total_grosswt + shad_ctn_ext_gw.
                                                         total_cbm = total_cbm + shad_ctn_cbm * shad_ctn_qty.
                                   end.
                             assign
                                   shah_ttl_plt   = total_plt
                                   shah_ttl_ctn   = total_ctn
                                   shah_ttl_qty   = total_qty
                                   shah_ttl_gw    = total_grosswt
                                   shah_ttl_cmb   = total_cbm
                                   .
                        end.
***************************/
/***************************************************/
                                       FIND first shah_hdr where shah_sanbr = sanbr  NO-ERROR.
                                       if available shah_hdr then do:
                                               sqnbr3 = xxsq2_sq_nbr.
                                           assign                   
                                           total_ctn     = 0       
                                           total_plt    = 0        
                                           total_qty     = 0       
                                           total_grosswt = 0       
                                           total_cbm     = 0.  
                                           jj = 0.
                                           cbm# = 0.
                                           for each xxplt_tmp:
                                               delete xxplt_tmp.
                                           end.

                                           for each shad_det where shad_sanbr = sanbr and shad_plt_nbr > 0 break by shad_plt_nbr:
                                               if last-of(shad_plt_nbr) then do:
                                                   jj = 0.
                                                   cbm# = 0.
                                                  for each snh_ctn_hdr where snh_sn_nbr = snnbr and snh_plt_nbr = shad_plt_nbr and snh_ctn_status <> "D" no-lock:
                                                      jj = jj + 1.
                                                  end.                                          
                                                  if jj = 1 then do:
                                                     find first snp_totals where snp_sn_nbr = snnbr and snp_nbr = shad_plt_nbr and snp_status <> "D" no-lock no-error.
                                                     if available snp_totals then total_cbm = total_cbm + snp_cbm.
                                                  end.
                                                  else do:
                                                      create xxplt_tmp.
                                                      assign
                                                            xxplt_sanbr = shad_sanbr
                                                            xxplt_snnbr = snnbr
                                                            xxplt_plt_nbr = shad_plt_nbr
                                                            xxplt_sq = shad_sq.

                                                  end.                                                  
                                               end.
                                           end.
                                           for each xxplt_tmp:
                                               for each shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_plt_nbr = xxplt_plt_nbr and shad_line > 0:
                                                      total_cbm = total_cbm + shad_ctn_cbm * shad_ctn_qty.
                                               end.
                                           end.
                                           for each shad_det where shad_sanbr = sanbr and shad_plt_nbr > 0 break by shad_plt_nbr:
                                               if last-of(shad_plt_nbr) then total_plt = total_plt + 1.
                                           end.
                                              for each shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_line > 0:
                                                                          total_ctn = total_ctn + shad_ctnnbr_to - shad_ctnnbr_fm + 1.
                                                                          total_qty     = total_qty     + shad_ext_qty.
                                                                          total_grosswt = total_grosswt + shad_ctn_ext_gw.
/*                                                                          total_cbm = total_cbm + shad_ctn_cbm * shad_ctn_qty.*/
                                              end.
                                              for each shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_plt_nbr = 0 and shad_line > 0:
                                                                          total_cbm = total_cbm + shad_ctn_cbm * shad_ctn_qty.
                                              end.
                                               assign
                                                   shah_ttl_plt   =  total_plt
                                                   shah_ttl_ctn   =  total_ctn
                                                   shah_ttl_qty   =  total_qty
                                                   shah_ttl_gw    =  total_grosswt
                                                   shah_ttl_cmb   =  total_cbm
                                                   .
                                       end.
/***************************************************/
                        FOR EACH snd_ctn_det where snd_sn_nbr = snnbr and snd_sq_nbr = xxsq2_sq_nbr :
                               snd_sanbr = "".
                        end.
                end.

                 if xxsq2_sel = "Y" then do:
                          find first shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr no-error.
                          if available shad_det then do: 
                           FIND first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = xxsq2_sq_nbr and snh_ctn_status <> "D" no-lock NO-ERROR.
                           IF available snh_ctn_hdr then do:
                                if shad_forwarder <> snh_forwarder or shad_method <> snh_method or shad_shipvia <> snh_ship_via or shad_consign <> snh_ctn_consign then do:
                                  message "Error: Un-match common data.Please remove SA details changes.".
                                  xxsq2_sel = "".
                                  display xxsq2_sel.
                                end.
                           end.
                          end.
                end. 
                 /*if xxsq2_sel = "Y" then do:
                          find first shah_hdr where shah_sanbr = sanbr and shah_snnbr = snnbr no-error.
                          if available shah_hdr then do: 
                           FIND first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = xxsq2_sq_nbr and snh_ctn_status <> "D" no-lock NO-ERROR.
                           IF available snh_ctn_hdr then do:
                                if shah_forwarder <> snh_forwarder or shah_method <> snh_method or shah_shipvia <> snh_ship_via or shah_consig <> snh_ctn_consign then do:
                                  message "Error: Un-match common data.Please remove SA details changes.".
                                  xxsq2_sel = "".
                                  display xxsq2_sel.
                                end.
                           end.
                          end.
                end. */

                if xxsq2_sel = "Y" /*and sel_old_value <> "Y"*/ then do:
                        
                        FIND first shah_hdr where shah_sanbr = sanbr NO-ERROR.
                        IF not available shah_hdr THEN do:
                                create shah_hdr.
                                assign shah_sanbr        = sanbr
                                       shah_pinbr        = pinbr
                                           shah_snnbr        = snnbr.
/*0824*/                 end.
                             find first sn_hdr where sn_nbr = snnbr no-lock no-error.
                             if available sn_hdr then do:
                                           shah_container = sn_container.
                             end.
                                assign
                                           shah_shipto        = xxsq2_shipto
                                           shah_notify  = xxsq2_shipto.
/*0824                        end.*/
                             find first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = xxsq2_sq_nbr and snh_ctn_status <> "D" no-lock no-error.
                             if available snh_ctn_hdr then do:
                                           shah_forwarder = snh_forwarder.
                                           shah_shipvia   = snh_ship_via.
                                           shah_consig    = snh_ctn_consign.
                                           shah_loc       = snh_loc .
                                           shah_method        = snh_method.
                                assign
                                           shah_last_user = global_userid
                                           shah_last_date = today.
                             end.
                                find first ship_mt_mstr where ship_mt_code = shah_method no-lock no-error.
                                if available ship_mt_mstr then do:
                                   shah_loc_seq1 = ship_loc_seq1.
                                end.


                        FIND first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = xxsq2_sq_nbr and snh_ctn_status <> "D" NO-ERROR.
                        IF available snh_ctn_hdr THEN
                        DO:
                                FIND first shad_det where shad_sanbr = sanbr and shad_sq = xxsq2_sq_nbr and shad_line = 0 NO-ERROR.
                                IF not available shad_det THEN
                                DO:
                                        create shad_det.
                                        assign shad_sanbr        = sanbr
                                                   shad_sq        = xxsq2_sq_nbr
                                                   shad_ctn_line = 0
                                                   shad_line        = 0.
                                END.
                                        assign
                                        shad_snnbr                = snnbr  
                                        shad_plt_nbr        = snh_plt_nbr                                
                                        shad_so_nbr            = snh_so_order                                                              
                                        shad_part              = snh_part       
                                        shad_destin            =        snh_destin                        
                                        shad_consign           =        snh_ctn_consign                
                                        shad_loc               =        snh_loc                                
                                        shad_type              =        snh_type                        
                                        shad_shipvia           =        snh_ship_via                
                                        shad_ponbr             =        snh_po                                
                                        shad_shipto            =        snh_shipto                        
                                        shad_method            =        snh_method                        
                                        shad_forwarder         =        snh_forwarder                
                                        shad_ref               =        snh_reference                
                                        shad_ctn_status        = snh_ctn_status
                                        shad_last_user         = global_userid
                                        shad_last_date         = today
                                        .
                                           find first ship_mt_mstr where ship_mt_code = shad_method no-lock no-error.
                                           if available ship_mt_mstr then do:
                                              shad_shploc = ship_loc_seq1.
                                           end.
                                                                        
                                if snh_type = "P" then do:
                                        FIND first snp_totals where snp_sn_nbr = snnbr and snp_nbr = shad_plt_nbr  /*snp_sq_nbr = xxsq2_sq_nbr*/ no-lock NO-ERROR.
                                        IF available snp_totals and snp_status <> "D" THEN
                                                
                                        assign              
                                        shad_plt_gw            =        snp_ext_grosswt                                            
                                        shad_plt_length        =        snp_length                                                    
                                        shad_plt_height        =   snp_height                                
                                        shad_plt_width         =   snp_width                                
                                        shad_plt_cbm        = snp_cbm                          
                                        shad_ctn_status        = snh_ctn_status            
                                        .                 
                                end.

                        END.


                                FOR EACH snd_ctn_det where snd_sn_nbr = snnbr and snd_sq_nbr = xxsq2_sq_nbr and snd_ctn_status <> "D":
                                    find first shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_sq = xxsq2_sq_nbr and shad_line = snd_ctn_line no-error.
                                    if not available shad_det then do:
                                        create shad_det.
                                        assign 
                                        shad_sanbr = sanbr
                                        shad_sq                = xxsq2_sq_nbr
                                        shad_line        = snd_ctn_line
                                        shad_snnbr      = snnbr .
                                    end.
                                    assign
                                        shad_qtyper            = snd_qtyper                                                
                                        shad_ctn_qty           = snd_ctn_qty                                                
                                        shad_ext_qty           = snd_ext_qty                                                
                                        shad_netwt             = snd_netwt                                                      
                                        shad_ctn_line          = snd_ctn_line                                                   
                                        shad_ctnnbr_fm         = snd_ctnnbr_fm                                                  
                                        shad_ctnnbr_to         = snd_ctnnbr_to                                                  
                                        shad_ext_netwt         = snd_ext_netwt                                                  
                                        shad_ctn_gw            = snd_grosswt                                                    
                                        shad_ctn_ext_gw        = snd_ext_grosswt                                                
                                        shad_ctn_length        = snd_ctn_length                                                 
                                        shad_ctn_height        = snd_ctn_height                                                 
                                        shad_ctn_width         = snd_ctn_width                                                  
                                        shad_ctn_cbm           = snd_cbm                                                        
                                        shad_ctn_status        = snd_ctn_status
                                        shad_last_user         = global_userid
                                        shad_last_date         = today
                                        .
                                     FIND first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = xxsq2_sq_nbr and snh_ctn_status <> "D" NO-ERROR.
                                     IF available snh_ctn_hdr THEN
                                     DO:
                                        assign
                                        shad_plt_nbr        = snh_plt_nbr                                
                                        shad_so_nbr            = snh_so_order                                                              
                                        shad_part              = snh_part       
                                        shad_destin            =         snh_destin                        
                                        shad_consign           =        snh_ctn_consign                
                                        shad_loc               =        snh_loc                                
                                        shad_type              =        snh_type                        
                                        shad_shipvia           =        snh_ship_via                
                                        shad_ponbr             =        snh_po                                
                                        shad_shipto            =        snh_shipto                        
                                        shad_method            =        snh_method                        
                                        shad_forwarder         =        snh_forwarder                
                                        shad_ref               =        snh_reference.                
                                     end.        
                                           find first ship_mt_mstr where ship_mt_code = shad_method no-lock no-error.
                                           if available ship_mt_mstr then do:
                                              shad_shploc = ship_loc_seq1.
                                           end.
/**************/
                                       FIND first shah_hdr where shah_sanbr = sanbr  NO-ERROR.
                                       if available shah_hdr then do:
                                               sqnbr3 = xxsq2_sq_nbr.
                                           assign                   
                                           total_ctn     = 0       
                                           total_plt    = 0        
                                           total_qty     = 0       
                                           total_grosswt = 0       
                                           total_cbm     = 0.  
                                           jj = 0.
                                           cbm# = 0.
                                           for each xxplt_tmp:
                                               delete xxplt_tmp.
                                           end.

                                           for each shad_det where shad_sanbr = sanbr and shad_plt_nbr > 0 break by shad_plt_nbr:
                                               if last-of(shad_plt_nbr) then do:
                                                   jj = 0.
                                                   cbm# = 0.
                                                  for each snh_ctn_hdr where snh_sn_nbr = snnbr and snh_plt_nbr = shad_plt_nbr and snh_ctn_status <> "D" no-lock:
                                                      jj = jj + 1.
                                                  end.                                          
                                                  if jj = 1 then do:
                                                     find first snp_totals where snp_sn_nbr = snnbr and snp_nbr = shad_plt_nbr and snp_status <> "D" no-lock no-error.
                                                     if available snp_totals then total_cbm = total_cbm + snp_cbm.
                                                  end.
                                                  else do:
                                                      create xxplt_tmp.
                                                      assign
                                                            xxplt_sanbr = shad_sanbr
                                                            xxplt_snnbr = snnbr
                                                            xxplt_plt_nbr = shad_plt_nbr
                                                            xxplt_sq = shad_sq.

                                                  end.                                                  
                                               end.
                                           end.
                                           for each xxplt_tmp:
                                               for each shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_plt_nbr = xxplt_plt_nbr and shad_line > 0:
                                                      total_cbm = total_cbm + shad_ctn_cbm * shad_ctn_qty.
                                               end.
                                           end.
                                           for each shad_det where shad_sanbr = sanbr and shad_plt_nbr > 0 break by shad_plt_nbr:
                                               if last-of(shad_plt_nbr) then total_plt = total_plt + 1.
                                           end.
                                              for each shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_line > 0:
                                                                          total_ctn = total_ctn + shad_ctnnbr_to - shad_ctnnbr_fm + 1.
                                                                          total_qty     = total_qty     + shad_ext_qty.
                                                                          total_grosswt = total_grosswt + shad_ctn_ext_gw.
/*                                                                          total_cbm = total_cbm + shad_ctn_cbm * shad_ctn_qty.*/
                                              end.
                                              for each shad_det where shad_sanbr = sanbr and shad_snnbr = snnbr and shad_plt_nbr = 0 and shad_line > 0:
                                                                          total_cbm = total_cbm + shad_ctn_cbm * shad_ctn_qty.
                                              end.
                                               assign
                                                   shah_ttl_plt   =  total_plt
                                                   shah_ttl_ctn   =  total_ctn
                                                   shah_ttl_qty   =  total_qty
                                                   shah_ttl_gw    =  total_grosswt
                                                   shah_ttl_cmb   =  total_cbm
                                                   .
                                       end.
/******************/

                                     snd_sanbr = sanbr.
                                                
                                END.                                                
                                end.
               end.
               else 
               if keyfunction(lastkey) = "GO" then do:
/*                                  message "leave" view-as alert-box.
                                  leave .*/
                  find xxsq2_tmp
                  where recid(xxsq2_tmp) = recidarray[frame-line(w)].
                                  shipto3 = xxsq2_shipto.
                          hide frame w no-pause.
                          {gprun.i ""xxshadmtp.p""}
                          leave.
               end.
               {windo1u1.i xxsq2_flag}
            
            end.
                        clear frame w all no-pause.

PROCEDURE satotal :
       assign
        total_ctn     = 0
        total_plt    = 0
        total_qty     = 0
        total_grosswt = 0
        total_cbm     = 0.

        for each snd_ctn_det where snd_sn_nbr = snnbr and snd_sq_nbr = sqnbr3 and snd_ctn_status <> "D" no-lock:
               /*if snd_plt_nbr = 0 then total_ctn     = total_ctn     + snd_ctn_qty.*/
               if snd_plt_nbr <> 0 then total_plt = 1. /*+ snd_ctn_qty.*/
               total_ctn = total_ctn + snd_ctnnbr_to - snd_ctnnbr_fm + 1.
               total_qty     = total_qty     + snd_ext_qty.
               total_grosswt = total_grosswt + snd_ext_grosswt.
               /*if snd_plt_nbr = 0 then*/ total_cbm = total_cbm + snd_cbm * snd_ctn_qty.
        end.
        /*for each snp_totals where snp_sn_nbr = snnbr and snp_nbr = sqnbr3 and snp_status <> "D" no-lock:
               /*total_grosswt = total_grosswt + snp_ext_grosswt.*/
               total_cbm     = total_cbm + snp_cbm.
        end.*/
END PROCEDURE.
