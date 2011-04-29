/* xxshmta.p  -- Shipping Notes Maintenance */
/* REVISION: eb SP5 create 02/10/04 BY: *EAS033A3* Apple Tam */
/* SS - 091230.1  By: Roger Xiao */
/* SS - 100222.1  By: Roger Xiao */ /*update the ext_qty ,when ctn_qty = 0 (more than one so_line in one ctn)*/
/* SS - 100413.1  By: Roger Xiao */
/* SS - 100421.1  By: Roger Xiao */ /*qty check error, when delete*/
/* SS - 100913.1  By: Roger Xiao */ /*qty fromat from .9<< to .9<<< */
/*-Revision end---------------------------------------------------------------*/


{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


define shared variable total_ctn     like sn_total_ctn    .
define shared variable total_netwt   like sn_total_netwt  .
define shared variable total_qty     like sn_total_qty    .
define shared variable total_grosswt like sn_total_grosswt.
define shared variable total_cbm     like sn_total_cbm    .

define shared variable sqnbr    as integer format ">>9".
define shared variable pltnbr   like snh_plt_nbr no-undo.
define shared variable sonbr    like so_nbr no-undo.
/* SS - 091230.1 - B */
define shared variable soline    like sod_line no-undo.
/* SS - 091230.1 - E */
define shared variable part3    like snh_part no-undo.
define shared variable desc1    like pt_desc1 no-undo.
define shared variable desc2    like pt_desc2 no-undo.
define shared variable destin   like snh_destin no-undo.
define shared variable consign  like snh_ctn_consign no-undo.
define shared variable loc      like snh_loc no-undo.
define shared variable type     like snh_type no-undo.
define shared variable ship_via as logical format "A/S" no-undo.
define shared variable po1      like snh_po no-undo.
define shared variable method   like snh_method no-undo.
define shared variable modesc   as character format "x(62)" no-undo.
define shared variable forw     like snh_forwarder no-undo.
define shared variable ref      like snh_reference no-undo.

define shared variable ctn_line      as integer format ">>9".
define shared variable ctnnbr_fm     like snd_ctnnbr_fm.
define shared variable ctnnbr_to     like snd_ctnnbr_to.
define shared variable ctn_qty       as integer format ">,>>9".       
/* SS - 091230.1 - B 
define shared variable qtyper        as integer format ">,>>>,>>9".   
   SS - 091230.1 - E */
/* SS - 091230.1 - B */
define shared variable qtyper        as integer format ">,>>>,>>9.9<".   
/* SS - 091230.1 - E */
define shared variable ext_qty       as decimal format ">,>>>,>>9.9<".
define shared variable netwt         as decimal format ">,>>9.99".    
define shared variable ext_netwt     as decimal format ">,>>>,>>9.9<".
define shared variable grosswt       as decimal format ">>,>>9.99".   
define shared variable ext_grosswt   as decimal format ">,>>>,>>9.9<".
define shared variable length        as decimal format ">>9.9".       
define shared variable height        as decimal format ">>9.9".       
define shared variable width         as decimal format ">>9.9".       
define shared variable cbm           as decimal format ">>,>>9.9<<".  

define shared variable shipto3       like snp_shipto     .
define shared variable nbr3          like snp_nbr        .
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
define shared variable ext_qty2 like snd_ext_qty no-undo.
define variable extqty3 like snd_ext_qty no-undo.
define variable extqty4 like snd_ext_qty no-undo.

/*0524*/ define new shared variable open-qty like snd_ext_qty no-undo.

define shared variable con-yn like mfc_logical initial no.
define variable del-yn2 like mfc_logical initial no.
define variable del-yn3 like mfc_logical initial no.
define variable go-yn like mfc_logical initial no.
define variable sh-yn like mfc_logical initial yes.
define shared variable shipto2 like so_ship.
define variable via as char format "x(1)".
define variable um2 like sod_um.
define shared frame aa.
define shared frame d2.
define shared frame a2.
define shared frame f.
define shared frame g.


define variable m as integer.
define variable m2 as integer.

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
               index xxln_line IS PRIMARY UNIQUE xxln_sq_nbr xxln_ctn_line ascending
                . 


define shared temp-table  xxsq_tmp
                field xxsq_sq_nbr   /* like snh_sq_nbr*/ as integer format ">>9"
                field xxsq_plt_nbr  like snh_plt_nbr
                field xxsq_so_order like snh_so_order
/* SS - 091230.1 - B */
                field xxsq_so_line  like snh_so_line
/* SS - 091230.1 - E */
                field xxsq_shipto   like snh_shipto  
                field xxsq_part     like snh_part    
                field xxsq_part_um  like snh_part_um 
/* SS - 100913.1 - B 
                field xxsq_qty_open like sod_qty_ord format ">,>>>,>>9.9<"
                field xxsq_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
   SS - 100913.1 - E */
/* SS - 100913.1 - B */
                field xxsq_qty_open like sod_qty_ord format ">>>>>>9.9<<<"
                field xxsq_qty_ship like sod_qty_ship format ">>>>>>9.9<<<"
/* SS - 100913.1 - E */
        index xxsq_nbr IS PRIMARY UNIQUE xxsq_sq_nbr ascending
               .

define shared temp-table xxsnp_tmp
                field xxsnp_shipto      like snp_shipto
                field xxsnp_nbr         like snp_nbr
                field xxsnp_ext_grosswt like snp_ext_grosswt
                field xxsnp_length      like snp_length
                field xxsnp_height      like snp_height
                field xxsnp_width       like snp_width
                field xxsnp_cbm         like snp_cbm
                field xxsnp_line        as integer format ">>9"
                index xxsnp_nbr IS PRIMARY UNIQUE xxsnp_shipto xxsnp_nbr ascending
/*                index xxsnp_nbr IS PRIMARY xxsnp_shipto ascending*/
                .
       {xxshmta.i}




lineloop:
repeat :
  clear frame d2 all no-pause.
  hide frame d2 no-pause.
  hide frame a2 no-pause.

           for each xxsq_tmp :
               delete xxsq_tmp.
           end.

           for each snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_ctn_status <> "D" no-lock:
               create xxsq_tmp.
               assign
                  xxsq_sq_nbr    = snh_sq_nbr
                   xxsq_plt_nbr   = snh_plt_nbr
                  xxsq_so_order  = snh_so_order
/* SS - 091230.1 - B */
                  xxsq_so_line   = snh_so_line
/* SS - 091230.1 - E */
                  xxsq_shipto    = snh_shipto
                  xxsq_part      = snh_part
                  xxsq_qty_open  = snh_qty_open
                  xxsq_part_um   = snh_part_um
                  xxsq_qty_ship  = snh_qty_ship
                  .
                  xxsq_qty_open = 0.
                 /* for each sod_det where sod_nbr = snh_so_order and sod_part = snh_part no-lock:
                      xxsq_qty_open = xxsq_qty_open + sod_qty_ord - sod_qty_ship.
                  end.*/
/*********************************************************/
/* SS - 091230.1 - B 
               extqty4 = 0.
           open-qty = 0.
               for each snd_ctn_det where snd_part = snh_part and snd_so_order = snh_so_order and snd_ctn_status <> "D" no-lock:
                   extqty4 = extqty4 + snd_ext_qty.
               end.
               for each sod_det where sod_nbr = snh_so_order and sod_part = snh_part no-lock:
                   open-qty = open-qty + sod_qty_ord .
               end.
           for each idh_hist where idh_part = part3 and idh_nbr = sonbr no-lock:
               find first sod_det where sod_nbr = idh_nbr and sod_line = idh_line no-lock no-error.
               if not available sod_det then do:
                  open-qty = open-qty + idh_qty_inv.
               end.
           end.
           xxsq_qty_open = open-qty - extqty4.
   SS - 091230.1 - E */
/*********************************************************/
       end.

/* SS - 091230.1 - B */
for each xxsq_tmp :
    extqty4 = 0.
    open-qty = 0.
    for each snh_ctn_hdr use-index snh_sopart where snh_so_order = xxsq_so_order and snh_so_line = xxsq_so_line and snh_part = xxsq_part and snh_ctn_status <> "D"  /* SS - 100421.1 */  no-lock :
        for each snd_ctn_det where snd_sn_nbr = snh_sn_nbr and snd_sq_nbr = snh_sq_nbr and snd_part = snh_part and snd_ctn_status <> "D"  /* SS - 100421.1 */  no-lock :
            extqty4 = extqty4 + snd_ext_qty.
        end.
    end.
    for each sod_det where sod_nbr = xxsq_so_order and sod_line = xxsq_so_line and sod_part = xxsq_part no-lock:
        open-qty = open-qty + sod_qty_ord .
    end.
    for each idh_hist where idh_nbr = xxsq_so_order and idh_line = xxsq_so_line and idh_part = xxsq_part no-lock:
        find first sod_det where sod_nbr = idh_nbr and sod_line = idh_line no-lock no-error.
        if not available sod_det then do:
            open-qty = open-qty + idh_qty_inv.
        end.
    end.
    xxsq_qty_open = open-qty - extqty4.
end.
/* SS - 091230.1 - E */

  view frame d2.
  view frame e .

  for each xxsq_tmp where xxsq_sq_nbr >= sqnbr:
    display
        xxsq_sq_nbr    
            xxsq_plt_nbr  
            xxsq_so_order 
/* SS - 091230.1 - B */
            xxsq_so_line 
/* SS - 091230.1 - E */
            xxsq_shipto   
            xxsq_part     
            xxsq_qty_open 
            xxsq_part_um  
            xxsq_qty_ship 
    with frame d2.
    if frame-line(d2) = frame-down(d2) then leave.
    down 1 with frame d2 .
end.  /*for each xxsq_tmp*/


             ststatus = stline[3].
            status input ststatus.


/*      do transaction on error undo, retry:*/
    for each xxln_tmp:
        delete xxln_tmp.
    end.
    for each snd_ctn_det where snd_sn_nbr = snnbr2:
           create xxln_tmp.
           assign
              xxln_sq_nbr      = snd_sq_nbr
              xxln_ctn_line    = snd_ctn_line
              xxln_ctnnbr_fm   = snd_ctnnbr_fm  
              xxln_ctnnbr_to   = snd_ctnnbr_to  
              xxln_ctn_qty     = snd_ctn_qty    
              xxln_qtyper      = snd_qtyper     
              xxln_ext_qty     = snd_ext_qty    
              xxln_netwt       = snd_netwt      
              xxln_ext_netwt   = snd_ext_netwt  
              xxln_grosswt     = snd_grosswt    
              xxln_ext_grosswt = snd_ext_grosswt
              xxln_length      = snd_ctn_length 
              xxln_height      = snd_ctn_height 
              xxln_width       = snd_ctn_width  
              xxln_cbm         = snd_cbm        
              .
    end.
 hide frame aa no-pause.
 view frame aa.
 run disptotal.
    
    ctn_line = 0.
    
       update 
          ctn_line    
          with frame e editing:
           {mfnp01.i xxln_tmp ctn_line xxln_ctn_line sqnbr xxln_sq_nbr xxln_line}        
               if recno <> ? then do:
                  assign
                     ctn_line    = xxln_ctn_line    
                     ctnnbr_fm   = xxln_ctnnbr_fm   
                     ctnnbr_to   = xxln_ctnnbr_to   
                     ctn_qty     = xxln_ctn_qty     
                     qtyper      = xxln_qtyper      
                     ext_qty     = xxln_ext_qty     
                     netwt       = xxln_netwt       
                     ext_netwt   = xxln_ext_netwt   
                     grosswt     = xxln_grosswt     
                     ext_grosswt = xxln_ext_grosswt 
                     length      = xxln_length      
                     height      = xxln_height      
                     width       = xxln_width       
                     cbm         = xxln_cbm .

                   display                    
                     ctn_line       
                     ctnnbr_fm     
                     ctnnbr_to     
                     ctn_qty         
                     qtyper           
                     ext_qty         
                     netwt             
                     ext_netwt     
                     grosswt         
                     ext_grosswt 
                     length           
                     height           
                     width             
                     cbm         
                     with frame e.
               
               end. /* IF RECNO <> ? */
              
/*            readkey.
            apply lastkey.*/
       end. /*editing:*/
           m = 1.
           m2 = 1.
          if ctn_line = 0 then do:
                   assign
                     ctnnbr_fm   = 0   
                     ctnnbr_to   = 0   
                     ctn_qty     = 0     
                     qtyper      = 0      
                     ext_qty     = 0     
                     netwt       = 0       
                     ext_netwt   = 0   
                     grosswt     = 0     
                     ext_grosswt = 0 
                     length      = 0      
                     height      = 0      
                     width       = 0       
                     cbm         = 0 .
          /********************/
              find first ptship_mstr where ptship_part = part3 and ptship_meas_type = "C"
                                       and ptship_via = (if ship_via  then "A" else "S") no-lock no-error.
                if available ptship_mstr then do:
                   assign
                     qtyper      = ptship_ctn_qty      
                     netwt       =  ptship_netwt       
                     grosswt     = ptship_grosswt    
                     length      = ptship_ct_length      
                     height      = ptship_ct_height
                     width       = ptship_ct_width  
                     cbm         = 0 .
                end.
          /********************/
             repeat m = 1 to 1000:
             find first snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr 
                                      and snd_ctn_line = m 
                                      no-error.
                 if not available snd_ctn_det then do:
                      m2 = m.
                      m = 1001.
                 end.
                 ctn_qty = 0.
             end.

                   display                    
                     ctn_line    
                     ctnnbr_fm   
                     ctnnbr_to   
                     ctn_qty     
                     qtyper      
                     ext_qty     
                     netwt       
                     ext_netwt   
                     grosswt     
                     ext_grosswt 
                     length      
                     height      
                     width       
                     cbm         
                     with frame e.
          end.
          else do:
             find first snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr 
                                      and snd_ctn_line = ctn_line 
                                      and snd_ctn_status = "D"
                                      no-error.
             if available snd_ctn_det then do:
                message "Error: Line already deleted.Please re-enter.".
                undo, retry.
             end.
             find first snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr 
                                      and snd_ctn_line = ctn_line 
                                      no-error.
             if available snd_ctn_det then do:
                     assign
                     ctn_line    = snd_ctn_line    
                     ctnnbr_fm   = snd_ctnnbr_fm   
                     ctnnbr_to   = snd_ctnnbr_to   
                     ctn_qty     = snd_ctn_qty     
                     qtyper      = snd_qtyper      
                     ext_qty     = snd_ext_qty     
                     netwt       = snd_netwt       
                     ext_netwt   = snd_ext_netwt   
                     grosswt     = snd_grosswt     
                     ext_grosswt = snd_ext_grosswt 
                     length      = snd_ctn_length      
                     height      = snd_ctn_height      
                     width       = snd_ctn_width       
                     cbm         = snd_cbm .
                   display                    
                     ctn_line    
                     ctnnbr_fm   
                     ctnnbr_to   
                     ctn_qty     
                     qtyper      
                     ext_qty     
                     netwt       
                     ext_netwt   
                     grosswt     
                     ext_grosswt 
                     length      
                     height      
                     width       
                     cbm         
                     with frame e.
             end.
             else do:
                   assign
                     ctn_line    = 0    
                     ctnnbr_fm   = 0   
                     ctnnbr_to   = 0   
                     ctn_qty     = 0     
                     qtyper      = 0      
                     ext_qty     = 0     
                     netwt       = 0       
                     ext_netwt   = 0   
                     grosswt     = 0     
                     ext_grosswt = 0 
                     length      = 0      
                     height      = 0      
                     width       = 0       
                     cbm         = 0 .

                   display                    
                     ctn_line    
                     ctnnbr_fm   
                     ctnnbr_to   
                     ctn_qty     
                     qtyper      
                     ext_qty     
                     netwt       
                     ext_netwt   
                     grosswt     
                     ext_grosswt 
                     length      
                     height      
                     width       
                     cbm         
                     with frame e.
                       message "Error: Invalid Line Number.Please re-enter".
                       undo,retry.
             end.
          end.
          if ctn_line = 0 then do:
               ctnnbr_fm = 1.
               ctnnbr_to = 1.
             if ext_qty2 <> 0 then do:
                via = if ship_via then "A" else "S".
                find first ptship_mstr where ptship_part = part3 and ptship_meas_type = type
                                         and ptship_via = via no-lock no-error.
                    if available ptship_mstr then do:
                       ctnnbr_fm = 1.
                       ctnnbr_to = integer(ext_qty2 / ptship_ctn_qty + 0.4).
                    end.
                    
             end. /*if ext_qty2 <> 0*/

                           find snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr 
                                      and snd_ctn_line = m2 - 1 
                                      and snd_ctn_status <> "D"
                                      no-lock no-error.
                            if available snd_ctn_det then do:
                               ctnnbr_fm = ctnnbr_fm + snd_ctnnbr_to.
                               ctnnbr_to = ctnnbr_to + snd_ctnnbr_to.
                            end.
    
             
             display ctnnbr_fm ctnnbr_to with frame e.
             ctn_line = m2.
             display ctn_line ctnnbr_fm ctnnbr_to with frame e.
          end. /*if ctn_line = 0*/

            ststatus = stline[2].
            status input ststatus.
ftloop:
 repeat on endkey undo lineloop, retry:
       update
          ctnnbr_fm   
          ctnnbr_to   
       go-on(F5 CTRL-D) with frame e.

            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
               del-yn2 = no.
               {mfmsg01.i 11 1 del-yn2}
               if del-yn2 then do:
             find first snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr 
                                      and snd_ctn_line = ctn_line
                                      no-error.
                 for each snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr 
                                      and snd_ctn_line = ctn_line :
                     snd_ctn_status = "D".
                     snd_last_date = today.
                     snd_last_user = global_userid.
                 end.

         find first snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = sqnbr no-error.
         if available snh_ctn_hdr then do:
            extqty3 = 0.
            for each snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr and snd_ctn_status <> "D":
/* SS - 100222.1 - B 
                extqty3 = extqty3 + snd_qtyper * snd_ctn_qty.
   SS - 100222.1 - E */
/* SS - 100222.1 - B */
                extqty3 = extqty3 + snd_ext_qty.
/* SS - 100222.1 - E */                
            end.         
            snh_qty_ship = extqty3.
         end.

                 find first xxln_tmp where xxln_sq_nbr = sqnbr 
                                       and xxln_ctn_line = ctn_line 
                                       no-error.
                 if available xxln_tmp then do:
                     delete xxln_tmp.
                 end.
                  clear frame e.
                  assign
                     ctn_line    = 0    
                     ctnnbr_fm   = 0   
                     ctnnbr_to   = 0   
                     ctn_qty     = 0     
                     qtyper      = 0      
                     ext_qty     = 0     
                     netwt       = 0       
                     ext_netwt   = 0   
                     grosswt     = 0     
                     ext_grosswt = 0 
                     length      = 0      
                     height      = 0      
                     width       = 0       
                     cbm         = 0 .
                   display                   
                     ctn_line    
                     ctnnbr_fm   
                     ctnnbr_to   
                     ctn_qty     
                     qtyper      
                     ext_qty     
                     netwt       
                     ext_netwt   
                     grosswt     
                     ext_grosswt 
                     length      
                     height      
                     width       
                     cbm         
                     with frame e. 
               end.
               if del-yn2 then next lineloop.
            end.

               else do: /*f5*/

                   display                   
                     ctnnbr_fm   
                     ctnnbr_to   
                     ctn_qty     
                     qtyper      
                     ext_qty     
                     netwt       
                     ext_netwt   
                     grosswt     
                     ext_grosswt 
                     length      
                     height      
                     width       
                     cbm         
                     with frame e. 
              end. /*f5*/        

        if ctnnbr_fm > ctnnbr_to then do:
           message "Error: TO is smaller than FM. Please re-enter.".
           next-prompt ctnnbr_fm with frame e.
           undo, retry.
        end.          
          ctn_qty = (ctnnbr_to - ctnnbr_fm + 1).
          display ctn_qty with frame e.

             ststatus = stline[3].
            status input ststatus.
       set
          ctn_qty     
          qtyper      
          netwt       
          grosswt     
          length      
          height      
          width       
        with frame e editing:
            ext_qty = input ctn_qty * input qtyper.
            ext_netwt = input ctn_qty * input netwt.
            ext_grosswt = input ctn_qty * input grosswt.
            cbm = (input length * input height * input width) / 1000000.
            if ctn_qty = 0 then ctn_qty = (ctnnbr_to - ctnnbr_fm + 1).
            display ext_qty ext_netwt ext_grosswt cbm with frame e.
            readkey.
            apply lastkey.
        end. /*with frame a2 editing*/
        display ctn_qty with frame e.

/* SS - 100222.1 - B */
        if ctn_qty = 0 then 
        update ext_qty with frame e .
/* SS - 100222.1 - E */
/****0524********************************************************************************************************        
        if part2 <> "" and order2 <> "" and ext_qty2 <> 0 then do:
           if part2 = part3 then do:
               extqty4 = 0.
               for each snd_ctn_det where snd_sn_nbr = snnbr2 and snd_part = part2 and snd_so_order = order2 no-lock:
                   extqty4 = extqty4 + snd_ext_qty.
               end.
/*               for each sod_det where sod_nbr = sonbr and sod_part = part3 no-lock:
                   extqty4 = extqty4 + sod_qty_ord - sod_qty_ship.
               end.*/
                   if extqty4 + ctn_qty * qtyper > ext_qty2 then do:
                   sh-yn = yes.
                   message "Warning: SO Open Qty is smaller than Qty to Ship. Over shipped:" update sh-yn.
                   if sh-yn = no then do:
                      next-prompt ctn_qty with frame e.
                      undo, retry.
                   end.
                end.
            end.
        end.
****************************************************************************************************************/        
/**0524**********************************************************************************************************/        
/* SS - 091230.1 - B 
           extqty4 = 0.
           open-qty = 0.
           for each snd_ctn_det where snd_part = part3 and snd_so_order = sonbr and snd_ctn_status <> "D" no-lock:
               extqty4 = extqty4 + snd_ext_qty.
           end.
               for each sod_det where sod_nbr = sonbr and sod_part = part3 no-lock:
                   open-qty = open-qty + sod_qty_ord .
               end.
           for each idh_hist where idh_part = part3 and idh_nbr = sonbr no-lock:
               find first sod_det where sod_nbr = idh_nbr and sod_line = idh_line no-lock no-error.
               if not available sod_det then do:
                  open-qty = open-qty + idh_qty_inv.
               end.
           end.
   SS - 091230.1 - E */
/* SS - 091230.1 - B */
            extqty4 = 0.
            open-qty = 0.
            for each snh_ctn_hdr use-index snh_sopart where snh_so_order = sonbr and snh_so_line = soline and snh_part = part3 and snh_ctn_status <> "D"  /* SS - 100421.1 */  no-lock :
                for each snd_ctn_det where snd_sn_nbr = snh_sn_nbr and snd_sq_nbr = snh_sq_nbr and snd_part = snh_part and snd_ctn_status <> "D" /* SS - 100421.1 */ no-lock :
                    extqty4 = extqty4 + snd_ext_qty.
                end.
            end.
            for each sod_det where sod_nbr = sonbr and sod_line = soline and sod_part = part3 no-lock:
                open-qty = open-qty + sod_qty_ord .
            end.
            for each idh_hist where idh_nbr = sonbr and idh_line = soline and idh_part = part3 no-lock:
                find first sod_det where sod_nbr = idh_nbr and sod_line = idh_line no-lock no-error.
                if not available sod_det then do:
                    open-qty = open-qty + idh_qty_inv.
                end.
            end.
/* SS - 091230.1 - E */

  /*         message open-qty extqty4 view-as alert-box.*/
            open-qty = open-qty - extqty4.

/* SS - 100413.1 - B 
            find first snd_ctn_det 
                where snd_sn_nbr = snnbr2 
                and snd_sq_nbr = sqnbr 
                and snd_ctn_line = ctn_line 
            no-error.
            if available snd_ctn_det then do:
                open-qty = open-qty + snd_ext_qty.
            end.
   SS - 100413.1 - E */

            if ctn_qty * qtyper > open-qty then do:
                sh-yn = yes.
                message "Error: SO Open Qty is smaller than Qty to Ship. ".
                next-prompt ctn_qty with frame e.
                undo, retry.
            end.
/****************************************************************************************************************/        


         find first snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr 
                                      and snd_ctn_line = ctn_line 
                                      no-error.
         if available snd_ctn_det then do:
            assign
                  snd_ctn_line     =  ctn_line       
                  snd_sn_nbr       =  snnbr2
                  snd_sq_nbr       =  sqnbr
                  snd_shipto       =  shipto2
                  snd_part         =  part3
                  snd_plt_nbr      =  pltnbr
                  snd_so_order     =  sonbr
                  snd_last_user    =  global_userid
                  snd_last_date    =  today
                  snd_ctnnbr_fm    =  ctnnbr_fm     
                  snd_ctnnbr_to    =  ctnnbr_to     
                  snd_ctn_qty      =  ctn_qty         
                  snd_qtyper       =  qtyper           
                  snd_ext_qty      =  ext_qty         
                  snd_netwt        =  netwt             
                  snd_ext_netwt    =  ext_netwt     
                  snd_grosswt      =  grosswt         
                  snd_ext_grosswt  =  ext_grosswt 
                  snd_ctn_length   =  length           
                  snd_ctn_height   =  height           
                  snd_ctn_width    =  width             
                  snd_cbm          =  cbm         .
         end.
         else do:
           create snd_ctn_det.
            assign
                  snd_ctn_line     =  ctn_line       
                  snd_sn_nbr       =  snnbr2
                  snd_sq_nbr       =  sqnbr
                  snd_shipto       =  shipto2
                  snd_part         =  part3
                  snd_plt_nbr      =  pltnbr
                  snd_so_order     =  sonbr
                  snd_last_user    =  global_userid
                  snd_last_date    =  today
                  snd_ctnnbr_fm    =  ctnnbr_fm     
                  snd_ctnnbr_to    =  ctnnbr_to     
                  snd_ctn_qty      =  ctn_qty         
                  snd_qtyper       =  qtyper           
                  snd_ext_qty      =  ext_qty         
                  snd_netwt        =  netwt             
                  snd_ext_netwt    =  ext_netwt     
                  snd_grosswt      =  grosswt         
                  snd_ext_grosswt  =  ext_grosswt 
                  snd_ctn_length   =  length           
                  snd_ctn_height   =  height           
                  snd_ctn_width    =  width             
                  snd_cbm          =  cbm         .
         end.
         if type = "P" then do:

         find first snp_totals where snp_shipto = shipto2 and snp_sn_nbr = snnbr2 /* SS - 091230.1 - B */ and snp_nbr = pltnbr
                                 exclusive-lock no-error.
                if available snp_totals then do:
                   assign
                      snp_sn_nbr         = snnbr2 
                      snp_shipto         = shipto2
                      snp_nbr                 = pltnbr
                      snp_sq_nbr         = sqnbr
/*                      snp_ext_grosswt         = ext_grosswt
                      snp_cbm                 = cbm 
                      snp_length         = length
                      snp_height         = height
                      snp_width                 = width*/
                      snp_last_user         = global_userid
                      snp_last_date      = today.
                      if snp_status = "D" then  snp_status =  "" . /* SS - 100421.1 */
                end.
                else do:
                   create snp_totals.
                   assign
                      snp_sn_nbr         = snnbr2 
                      snp_shipto         = shipto2
                      snp_nbr                 = pltnbr
                      snp_sq_nbr         = sqnbr
/*                      snp_ext_grosswt         = ext_grosswt
                      snp_cbm                 = cbm */
/*                      snp_length         = length
                      snp_height         = height
                      snp_width                 = width*/
                      snp_last_user         = global_userid
                      snp_last_date      = today.
          /********************/
              find first ptship_mstr where ptship_part = part3 and ptship_meas_type = type
                                       and ptship_via = (if ship_via  then "A" else "S") no-lock no-error.
                if available ptship_mstr then do:
                   assign
                     snp_length      = ptship_ct_length      
                     snp_height      = ptship_ct_height
                     snp_width       = ptship_ct_width  .
                end.
          /********************/
                end.
                release snp_totals.
         find first snp_totals where snp_shipto = shipto2 and snp_sn_nbr = snnbr2 /* SS - 091230.1 - B */ and snp_nbr = pltnbr
                                  no-lock no-error.
         end. /*if type = "P"*/
         find first snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = sqnbr no-error.
         if available snh_ctn_hdr then do:
            extqty3 = 0.
            for each snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr and snd_ctn_status <> "D":
/* SS - 100222.1 - B 
                extqty3 = extqty3 + snd_qtyper * snd_ctn_qty.
   SS - 100222.1 - E */
/* SS - 100222.1 - B */
                extqty3 = extqty3 + snd_ext_qty.
/* SS - 100222.1 - E */   
            end.         
            snh_qty_ship = extqty3.
         end.

     leave.
   end. /*repeat on endkey undo lineloop*/
  end.
 
PROCEDURE disptotal :
       assign
        total_ctn     = 0
        total_netwt   = 0
        total_qty     = 0
        total_grosswt = 0
        total_cbm     = 0.

        for each snd_ctn_det where snd_sn_nbr = snnbr2 and snd_ctn_status <> "D" no-lock :
               total_ctn     = total_ctn     + snd_ctn_qty.
               total_netwt   = total_netwt   + snd_ext_netwt.
               total_qty     = total_qty     + snd_ext_qty.
               total_grosswt = total_grosswt + snd_ext_grosswt.
/*               if snd_plt_nbr = 0 then total_grosswt = total_grosswt + snd_ext_grosswt.*/
               if snd_plt_nbr = 0 then total_cbm = total_cbm + snd_cbm * snd_ctn_qty.
        end.
        for each snp_totals use-index snp_sn_nbr  where snp_sn_nbr = snnbr2 and snp_status <> "D" no-lock:
               total_grosswt = total_grosswt + snp_ext_grosswt.
               total_cbm     = total_cbm + snp_cbm.
        end.
        clear frame aa all no-pause.
                 display
                    total_ctn    
                    total_netwt  
                    total_qty    
                    total_grosswt
                    total_cbm    
                    with frame aa.
END PROCEDURE.
