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
define shared variable con-yn like mfc_logical initial no.
define variable line3 as integer format ">>9".
define variable i as integer format ">>9".

define shared frame aa.
define shared frame d2.
define shared frame a2.
define shared frame f.
define shared frame g.


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
define temp-table xxsnp2
                field xx_shipto      like snp_shipto
                field xx_nbr         like snp_nbr
                field xx_ext_grosswt like snp_ext_grosswt
                field xx_length      like snp_length
                field xx_height      like snp_height
                field xx_width       like snp_width
                field xx_cbm         like snp_cbm
                index xx_nbr IS PRIMARY UNIQUE xx_shipto xx_nbr ascending.
/*                index xx_nbr IS PRIMARY xx_shipto ascending.*/

       {xxshmta.i}


    hide frame d2 no-pause.
    hide frame e no-pause.
    hide frame a2 no-pause.
    clear frame f all no-pause.
    hide frame f no-pause.
    view frame f.

line3 = 1.
shiploop:
repeat:

run disptotal4.
for each xxsnp2:
    delete xxsnp2.
end.
for each snp_totals use-index snp_sn_nbr  where snp_sn_nbr = snnbr2 and snp_status <> "D" no-lock:
   create xxsnp2.
   assign
   xx_shipto      = snp_shipto     
   xx_nbr         = snp_nbr        
   xx_ext_grosswt = snp_ext_grosswt
   xx_length      = snp_length     
   xx_height      = snp_height     
   xx_width       = snp_width      
   xx_cbm         = snp_cbm        .
end.

for each xxsnp_tmp:
    delete xxsnp_tmp.
end.
i = 1.
/*shipto3 = "".
nbr3 = 0.*/
for each snp_totals use-index snp_sn_nbr  where snp_sn_nbr = snnbr2 and snp_status <> "D" no-lock:
   create xxsnp_tmp.
   assign
   xxsnp_shipto      = snp_shipto     
   xxsnp_nbr         = snp_nbr        
   xxsnp_ext_grosswt = snp_ext_grosswt
   xxsnp_length      = snp_length     
   xxsnp_height      = snp_height     
   xxsnp_width       = snp_width      
   xxsnp_cbm         = snp_cbm        
   xxsnp_line = i
   .
   i = i + 1.
end.
    clear frame f all no-pause.
    hide frame f no-pause.
    view frame f.
for each xxsnp_tmp where xxsnp_line >= line3:
    display
   xxsnp_shipto      
   xxsnp_nbr         
   xxsnp_ext_grosswt 
   xxsnp_length      
   xxsnp_height      
   xxsnp_width       
   xxsnp_cbm         
    with frame f.
    if frame-line(f) = frame-down(f) then leave.
    down 1 with frame f .
end.  /*for each xxsnp_tmp*/

    view frame g.
     update 
        shipto3  
        nbr3
     with frame g editing:
/*           {mfnp.i xxsnp2 shipto3 xx_shipto shipto3 xx_shipto  xx_nbr}*/
           {mfnp01.i xxsnp2 shipto3 xx_shipto xx_nbr xx_nbr  xx_nbr}
/*           {mfnp.i xxsnp_tmp shipto3 xxsnp_shipto nbr3 xxsnp_nbr xxsnp_nbr}*/
               if recno <> ? then do:
                  assign
                    shipto3       = xx_shipto      
                    nbr3          = xx_nbr         
                    ext_grosswt3  = xx_ext_grosswt 
                    length3       = xx_length      
                    height3       = xx_height      
                    width3        = xx_width       
                    cbm3          = xx_cbm         .
                   display 
                     shipto3     
                     nbr3        
                     ext_grosswt3
                     length3     
                     height3     
                     width3      
                     cbm3        
                   with frame g.
               end. /* IF RECNO <> ? */
         end. /* EDITING */


         find first xxsnp_tmp where xxsnp_shipto = shipto3 and xxsnp_nbr = nbr3 no-error.
         if available xxsnp_tmp then do:
                  assign
                    shipto3       = xxsnp_shipto      
                    nbr3          = xxsnp_nbr         
                    ext_grosswt3  = xxsnp_ext_grosswt 
                    length3       = xxsnp_length      
                    height3       = xxsnp_height      
                    width3        = xxsnp_width       
                    cbm3          = xxsnp_cbm         .
                   display 
                     shipto3     
                     nbr3        
                     ext_grosswt3
                     length3     
                     height3     
                     width3      
                     cbm3        
                   with frame g.
         end.
         else do:
             message "Error: Invalid selection. Please re-enter.".
             undo, retry.
         end.
  
     update 
        ext_grosswt3 
        length3      
        height3      
        width3       
     with frame g editing:
         cbm3 =   (input length3 * input height3 * input width3) / 1000000.
         display cbm3 with frame g.
         readkey.
         apply lastkey.
     end.

       find first snp_totals where snp_shipto = shipto3 and snp_sn_nbr = snnbr2 /* SS - 091230.1 - B */ and snp_nbr = nbr3 exclusive-lock no-error.
       if available snp_totals then do:
                   assign
                      snp_ext_grosswt         = ext_grosswt3
                      snp_cbm                 = cbm3 
                      snp_length         = length3
                      snp_height         = height3
                      snp_width                 = width3
                      snp_last_user         = global_userid
                      snp_last_date      = today.
       end.
       release snp_totals.
       find first snp_totals where snp_shipto = shipto3 and snp_sn_nbr = snnbr2 /* SS - 091230.1 - B */ and snp_nbr = nbr3 no-lock no-error.
        line3 = xxsnp_line.

     run disptotal4.
/*    clear frame g all no-pause.*/
end. /*repeat*/


PROCEDURE disptotal4 :
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
