/* xxshmta.p  -- Shipping Notes Maintenance */
/* REVISION: eb SP5 create 02/10/04 BY: *EAS033A3* Apple Tam */
/* SS - 091230.1  By: Roger Xiao */
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
define shared variable soline    like sod_line  no-undo.
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

define shared variable con-yn like mfc_logical initial no.
define variable del-yn2 like mfc_logical initial no.
define variable del-yn3 like mfc_logical initial no.
define variable go-yn like mfc_logical initial no.
define variable sh-yn like mfc_logical initial yes.
define new shared variable shipto2 like so_ship.
define variable via as char format "x(1)".
define variable um2 like sod_um.
define shared frame aa.
define shared frame d2.
define shared frame a2.
define shared frame f.
define shared frame g.

define variable m as integer.
define variable m2 as integer.
define variable sq3    as integer format ">>9".

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

clear frame d2 all no-pause.
hide frame d2 no-pause.
hide frame a2 no-pause.
hide frame f no-pause.
hide frame e no-pause.
view frame d2.
view frame a2.
view frame aa.

sq3 = 1.
if order2 = "" and part2 <> "" then do:
   find first xxsq_tmp where xxsq_part = part2 no-error.
   if available xxsq_tmp then do:
       sq3 = xxsq_sq_nbr.
   end.
end.

for each xxsq_tmp where xxsq_sq_nbr >= sq3:
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

run disptotal3.

   do transaction on error undo, retry:
   sqloop:
   repeat:

      sqnbr = 0.
         update sqnbr with frame a2
         editing:
           {mfnp.i xxsq_tmp sqnbr xxsq_sq_nbr sqnbr xxsq_sq_nbr xxsq_nbr}
          
               if recno <> ? then do:
                  find first snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = xxsq_sq_nbr no-lock.
                  if available snh_ctn_hdr then do:
                  assign
                   sqnbr       = snh_sq_nbr
                   pltnbr      = snh_plt_nbr
                   sonbr       = snh_so_order
/* SS - 091230.1 - B */
                   soline      = snh_so_line
/* SS - 091230.1 - E */
                   part3       = snh_part
                   destin      = snh_destin
                   consign     = snh_ctn_consign
                   loc         = snh_loc
                   type        = snh_type
                   ship_via    = if snh_ship_via = "A" then yes else no
                   po1         = snh_po
                   method      = snh_method
                   forw        = snh_forwarder
                   ref         = snh_reference.
                             run dispdesc.
                   end.
                   else do:
/*                   assign
                   pltnbr      = 0
                   sonbr       = ""
                   part3       = ""
                   destin      = ""
                   consign     = ""
                   loc         = ""
                   type        = ""
                   ship_via    = yes
                   po1         = ""
                   method      = ""
                   forw        = ""
                   ref         = "" .*/
                   end.

                   display                    
                       sqnbr
                       pltnbr    
                       sonbr     
/* SS - 091230.1 - B */ 
                       soline
/* SS - 091230.1 - E */
                       part3     
                       destin    
                       consign   
                       loc       
                       type      
                       ship_via  
                       method    
                       po1       
                       forw      
                       ref   
                       desc1
                       desc2
                       modesc
                       with frame a2.
               
               end. /* IF RECNO <> ? */

         end. /* EDITING */



           m = 1.
           m2 = 1.
          if sqnbr = 0 then do:
             repeat m = 1 to 1000:
                 find first snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = m no-error.
                 if not available snh_ctn_hdr then do:
                      m2 = m.
                      m = 1001.
                 end.
             end.
/*                   assign
                   pltnbr      = 0
                   sonbr       = ""
                   part3       = ""
                   destin      = ""
                   consign     = ""
                   loc         = ""
                   type        = ""
                   ship_via    = yes
                   po1         = ""
                   method      = ""
                   forw        = ""
                   ref         = "" .
*/
            if order2 <> "" then sonbr = order2.
            if part2 <> "" then part3 = part2.
                   display                    
                       pltnbr    
                       sonbr     
/* SS - 091230.1 - B */ 
                       soline
/* SS - 091230.1 - E */                       
                       part3     
/*                       destin    
                       consign   
                       loc       
                       type      
                       ship_via  
                       po1       
                       method    
                       forw      
                       ref   
                       desc1
                       desc2
                       modesc*/
                       with frame a2.
          end.
          else do:
             find first snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = sqnbr and snh_ctn_status = "D" no-error.
             if available snh_ctn_hdr then do:
                message "Error: SQ already deleted.Please re-enter.".
                undo, retry.
             end.
             find first snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = sqnbr no-error.
             if available snh_ctn_hdr then do:
                  assign
                   sqnbr       = snh_sq_nbr
                   pltnbr      = snh_plt_nbr
                   sonbr       = snh_so_order
/* SS - 091230.1 - B */
                   soline      = snh_so_line
/* SS - 091230.1 - E */
                   part3       = snh_part
                   destin      = snh_destin
                   consign     = snh_ctn_consign
                   loc         = snh_loc
                   type        = snh_type
                   ship_via    = if snh_ship_via = "A" then yes else no
                   po1         = snh_po
                   method      = snh_method
                   forw        = snh_forwarder
                   ref         = snh_reference.
                   display                    
                       sqnbr
                       pltnbr    
                       sonbr
/* SS - 091230.1 - B */
                       soline
/* SS - 091230.1 - E */                       
                       part3     
                       destin    
                       consign   
                       loc       
                       type      
                       ship_via  
                       method    
                       po1       
                       forw      
                       ref   
                       desc1
                       desc2
                       modesc
                       with frame a2.
             end.
             else do:
/*                   assign
                   pltnbr      = 0
                   sonbr       = ""
                   part3       = ""
                   destin      = ""
                   consign     = ""
                   loc         = ""
                   type        = ""
                   ship_via    = yes
                   po1         = ""
                   method      = ""
                   forw        = ""
                   ref         = "" .

                   display                    
                       sqnbr
                       pltnbr    
                       sonbr     
                       part3     
                       destin    
                       consign   
                       loc       
                       type      
                       ship_via  
                       po1       
                       method    
                       forw      
                       ref   
                       desc1
                       desc2
                       modesc
                       with frame a2.*/
                       message "Error: Invalid SQ Number.Please re-enter".
                       undo,retry.
             end.
          end.
          if sqnbr = 0 then do:
                      find first so_mstr where so_nbr = sonbr no-lock no-error.
                      if available so_mstr then do:
                         find first custship_mstr where custship_code = so_ship no-lock no-error.
                         if available custship_mstr then do:
                             method = custship_method.
                             run dispdesc.
                         end.
                         else do:
                             method = "".
                         end.
                      end.
              sqnbr = m2.
          end.
                   display                    
                       sqnbr
                       pltnbr    
                       sonbr 
/* SS - 091230.1 - B */
                       soline 
/* SS - 091230.1 - E */                       
                       part3     
                       destin    
                       consign   
                       loc       
                       type      
                       ship_via  
                       method    
                       po1       
                       forw      
                       ref   
                       desc1
                       desc2
                       modesc
                       with frame a2.
 
             ststatus = stline[2].
            status input ststatus.

sqloop2:
 repeat on endkey undo sqloop, retry:
     set 
        pltnbr  
        sonbr   
/* SS - 091230.1 - B */
        soline
/* SS - 091230.1 - E */
        part3   
        destin  
        consign 
        loc     
        type    
        ship_via
        po1     
        method  
        forw    
        ref     
     go-on(F5 CTRL-D) with frame a2 editing:
                      find first pt_mstr where pt_part = input part3 no-lock no-error.
                      if available pt_mstr then do:
                         desc1 = pt_desc1.
                         desc2 = pt_desc2.
                      end.
                      else do:
                         desc1 = "".
                         desc2 = "".
                      end.
                      
                      if frame-field = "sonbr" and method = "" then do:
                      find first so_mstr where so_nbr = input sonbr no-lock no-error.
                      if available so_mstr then do:
                         shipto2 = so_ship.
                         find first custship_mstr where custship_code = so_ship no-lock no-error.
                         if available custship_mstr then do:
                             method = custship_method.
                         end.
                         else do:
                             method = "".
                         end.
                      end.
                        display method with frame a2.
                      end.
                      
                      find first ship_mt_mstr where ship_mt_code = input method no-lock no-error.
                      if available ship_mt_mstr then do:
                         if trim(ship_rout_seq1) <> "" then do:
                            modesc = trim(ship_rout_seq1).
                         end.
                         if trim(ship_rout_seq2) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq2).
                         end.
                         if trim(ship_rout_seq3) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq3).
                         end.
                         if trim(ship_rout_seq4) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq4).
                         end.
                         if trim(ship_rout_seq5) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq5).
                         end.
                         if trim(ship_rout_seq6) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq6).
                         end.
                         if trim(ship_rout_seq7) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq7).
                         end.
                         if trim(ship_rout_seq8) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq8).
                         end.
                         if trim(ship_rout_seq9) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq9).
                         end.
                         if trim(ship_rout_seq10) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq10).
                         end.
                      end.
                      else do:
                         modesc = "".
                      end.
                      if input pltnbr <> 0 then do:
                         type = "P" .
                       end.
                       else do:
                           type = "C".
                       end.
/*                       find first ptship_mstr where ptship_part = input part3 and ptship_meas_type = input type no-lock no-error.
                       if available ptship_mstr then do:
                          if ptship_via = "A" then ship_via = yes .
                          if ptship_via = "S" then ship_via = no.
                       end.
*/
                    display desc1 desc2 modesc /*method*/ type /*ship_via*/ with frame a2.
            
            readkey.
            apply lastkey.
     end. /*with frame a2 editing*/
                      if pltnbr <> 0 then do:
                         find first snh_ctn_hdr where snh_sn_nbr = snnbr2  and snh_plt_nbr = pltnbr no-error.
                         if available snh_ctn_hdr then do:
/*                            if snh_sq_nbr <> sqnbr then do:*/
/*                            if snh_sq_nbr <> sqnbr and snh_part = part3 then do:
                            message "Error: Duplicated Pallet Number.Please re-enter".
                             next-prompt pltnbr with frame a2.
                            undo, retry.
                            end.*/
                         end. 
                         type = "P".
                         display type with frame a2.
                      end.

                      find first so_mstr where so_nbr = sonbr no-lock no-error.
                      if available so_mstr then do:
                         shipto2 = so_ship.
                         find first custship_mstr where custship_code = so_ship no-lock no-error.
                        /* if available custship_mstr then do:
                             method = custship_method.
                             run dispdesc.                             
                         end.
                         else do:
                             method = "".
                         end.*/
                             display method modesc with frame a2.
/* SS - 091230.1 - B 
                         find first sod_det where sod_nbr = so_nbr and sod_part = part3 no-lock no-error.
   SS - 091230.1 - E */
/* SS - 091230.1 - B */
                         if soline = 0 then do:
                            message "Error: SO Line Not in this Sales Order.Please re-enter".
                            next-prompt soline with frame a2.
                            undo , retry .
                         end.
                         find first sod_det where sod_nbr = so_nbr and sod_line = soline and sod_part = part3 no-lock no-error.
/* SS - 091230.1 - E */
                         um2 = "".
                         if not available sod_det then do:
                            message "Error: Item not in this Sales Order.Please re-enter".
                             if part2 <> "" then do:
                               next-prompt sonbr with frame a2.
                            end.
                            else do:
                               next-prompt part3 with frame a2.
                            end.
                            undo, retry.
                         end.
                         else do:
                            um2 = sod_um.
                         end.
                      end.
                      else do:
                         shipto2 = "".
                         message "Error: Invalid Sales Order.Please re-enter.". 
                         next-prompt sonbr with frame a2.
                         undo, retry.
                      end.
                      
                      if method <> "" then do:
                         find first custship_mstr where custship_code = shipto2 and custship_method = method no-lock no-error.
                         if not available custship_mstr then do:
                         message "Error: Invalid Ship Method.Please re-enter.". 
                         next-prompt method with frame a2.
                         undo, retry.
                         end.
                      end.

                      if consign = "" or consign = "C" or consign = "N" then do: 
                      end.
                      else do:
                         message "Error: Invalid Consignment code.Please re-enter.".
                         next-prompt consign with frame a2.
                         undo, retry.
                      end.
                      if loc = "" or loc = "DC" or loc = "MAIN" then do:
                      end. 
                      else do:
                         message "Error: Invalid DC/Main code.Please re-enter.".
                         next-prompt loc with frame a2.
                         undo,retry.
                      end.
                      if type = "C" and pltnbr <> 0 then do:
                         message "Error: Invalid Type.Please re-enter.".
                         next-prompt type with frame a2.
                         undo,retry.
                      end.
                      if type = "C" or type = "P" then do:
                      end.
                      else do:
                         message "Error: Invalid Type.Please re-enter.".
                         next-prompt type with frame a2.
                         undo,retry.
                      end.

            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
               del-yn2 = no.
               {mfmsg01.i 11 1 del-yn2}
               if del-yn2 then do:
                 for each snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = sqnbr:
                     snh_ctn_status = "D".
                     snh_last_date = today.
                     snh_last_user = global_userid.
                 end.
                 for each snd_ctn_det where snd_sn_nbr = snnbr2 and snd_sq_nbr = sqnbr:
                     snd_ctn_status = "D".
                     snd_last_date = today.
                     snd_last_user = global_userid.
                 end.
                 for each snp_totals use-index snp_sn_nbr  where snp_sn_nbr = snnbr2 and snp_sq_nbr = sqnbr exclusive-lock:
                     snp_status = "D".
                     snp_last_date = today.
                     snp_last_user = global_userid.
                 end.
                 for each snp_totals use-index snp_sn_nbr  where snp_sn_nbr = snnbr2 and snp_sq_nbr = sqnbr no-lock:
                 end.
                 find first xxsq_tmp where xxsq_sq_nbr = sqnbr no-error.
                 if available xxsq_tmp then do:
                     delete xxsq_tmp.
                 end.
                  clear frame a2.
                  assign
                   pltnbr      = 0
                   sonbr       = ""
/* SS - 091230.1 - B */
                   soline      = 0
/* SS - 091230.1 - E */
                   part3       = "" 
                   destin      = ""
                   consign     = ""
                   loc         = ""
                   type        = ""
                   ship_via    = yes
                   po1         = ""
                   method      = ""
                   forw        = ""
                   ref         = "" .
                   display                   
                       sqnbr
                       with frame a2.
                       run disptotal3.
               end.
               if del-yn2 then next sqloop.
            end.

                   display                   
/*                       sqnbr*/
                       pltnbr    
                       sonbr     
/* SS - 091230.1 - B */
                       soline
/* SS - 091230.1 - E */
                       part3     
                       destin    
                       consign   
                       loc       
                       type      
                       ship_via  
                       method    
                       po1       
                       forw      
                       ref   
                       desc1
                       desc2
                       modesc
                       with frame a2.


               extqty3 = 0.
/* SS - 091230.1 - B 
               for each sod_det where sod_nbr = sonbr and sod_part = part3 no-lock:
   SS - 091230.1 - E */
/* SS - 091230.1 - B */
               for each sod_det where sod_nbr = sonbr and sod_line = soline and sod_part = part3 no-lock:
/* SS - 091230.1 - E */
                   extqty3 = extqty3 + sod_qty_ord - sod_qty_ship.
               end.
         
         find first snh_ctn_hdr where snh_sn_nbr = snnbr2 and snh_sq_nbr = sqnbr no-error.
         if available snh_ctn_hdr then do:
            assign
            snh_sn_nbr      = snnbr2
            snh_part_desc1  = desc1
            snh_part_desc2  = desc2
            snh_last_user   = global_userid
            snh_last_date   = today
            snh_shipto      = shipto2
            snh_part_um     = um2
            snh_qty_open    = extqty3
            snh_sq_nbr      = sqnbr     
            snh_plt_nbr     = pltnbr    
            snh_so_order    = sonbr     
/* SS - 091230.1 - B */
            snh_so_line     = soline   
/* SS - 091230.1 - E */
            snh_part        = part3     
            snh_destin      = destin    
            snh_ctn_consign = consign   
            snh_loc         = loc       
            snh_type        = type      
            snh_ship_via    = if ship_via then "A" else "S"
            snh_po          = po1       
            snh_method      = method    
            snh_forwarder   = forw      
            snh_reference   = ref       .
         end.
         else do:
            create snh_ctn_hdr.
            assign
            snh_sn_nbr      = snnbr2
            snh_part_desc1  = desc1
            snh_part_desc2  = desc2
            snh_last_user   = global_userid
            snh_last_date   = today
            snh_shipto      = shipto2
            snh_part_um     = um2
            snh_qty_open    = extqty3
            snh_sq_nbr      = sqnbr     
            snh_plt_nbr     = pltnbr    
            snh_so_order    = sonbr     
/* SS - 091230.1 - B */
            snh_so_line     = soline   
/* SS - 091230.1 - E */
            snh_part        = part3     
            snh_destin      = destin    
            snh_ctn_consign = consign   
            snh_loc         = loc       
            snh_type        = type      
            snh_ship_via    = if ship_via  then "A" else "S"
            snh_po          = po1       
            snh_method      = method    
            snh_forwarder   = forw      
            snh_reference   = ref       .
         end.


  clear frame d2 all no-pause.
  hide frame d2 no-pause.
  hide frame a2 no-pause.

       leave.
    end. /*repeat sqloop*/
             {gprun.i ""xxshmtc.p""}
   end.  /*repeat lineloop*/
     end. /*do transaction*/


PROCEDURE dispdesc :
                      find first pt_mstr where pt_part = part3 no-lock no-error.
                      if available pt_mstr then do:
                         desc1 = pt_desc1.
                         desc2 = pt_desc2.
                      end.
                      find first ship_mt_mstr where ship_mt_code = method no-lock no-error.
                      if available ship_mt_mstr then do:
                         if trim(ship_rout_seq1) <> "" then do:
                            modesc = trim(ship_rout_seq1).
                         end.
                         if trim(ship_rout_seq2) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq2).
                         end.
                         if trim(ship_rout_seq3) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq3).
                         end.
                         if trim(ship_rout_seq4) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq4).
                         end.
                         if trim(ship_rout_seq5) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq5).
                         end.
                         if trim(ship_rout_seq6) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq6).
                         end.
                         if trim(ship_rout_seq7) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq7).
                         end.
                         if trim(ship_rout_seq8) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq8).
                         end.
                         if trim(ship_rout_seq9) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq9).
                         end.
                         if trim(ship_rout_seq10) <> "" then do:
                            modesc = modesc + ">" + trim(ship_rout_seq10).
                         end.
                      end.

END PROCEDURE.

PROCEDURE disptotal3 :
       assign
        total_ctn     = 0
        total_netwt   = 0
        total_qty     = 0
        total_grosswt = 0
        total_cbm     = 0.

        for each snd_ctn_det where snd_sn_nbr = snnbr2 and snd_ctn_status <> "D" no-lock:
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
