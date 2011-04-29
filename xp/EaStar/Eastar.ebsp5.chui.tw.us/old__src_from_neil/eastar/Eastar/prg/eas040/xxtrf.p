/* xxshloctrf.p  -- Shipping Location Transfer */
/* REVISION: eb SP5 create 02/10/04 BY: *EAS040A1* Ricky Ho */

{mfdtitle.i "sp5 "}
{gldydef.i new}
{gldynrm.i new}
/*F0FH*/ {gpglefdf.i}

define new shared variable sanbr like shah_sanbr.
define new shared variable pinbr like shah_pinbr.
define new shared variable snnbr like sn_nbr no-undo.
define variable m as char format "x(9)".
define variable m2 as char format "x(4)".
define variable k as integer.
define variable del-yn like mfc_logical initial no.
define new shared variable con-yn like mfc_logical initial no.
define new shared variable total_ctn     like shah_ttl_ctn    .
define new shared variable total_plt     like shah_ttl_plt  .
define new shared variable total_qty     like sn_total_qty    .
define new shared variable total_grosswt like sn_total_grosswt.
define new shared variable total_cbm     like sn_total_cbm    .

define new shared variable sqnbr    as integer format ">>9".
define new shared variable pltnbr   like snh_plt_nbr.
define new shared variable sonbr    like so_nbr.
define new shared variable part3    like snh_part.
define new shared variable desc1    like pt_desc1.
define new shared variable desc2    like pt_desc2.
define new shared variable destin   like snh_destin.
define new shared variable consign  like snh_ctn_consign.
define new shared variable loc      like snh_loc.
define new shared variable type     like snh_type.
define new shared variable ship_via as logical format "A/S".
define new shared variable po1      like snh_po.
define new shared variable method   like snh_method.
define new shared variable modesc   as character format "x(62)".
define new shared variable forw     like snh_forwarder.
define new shared variable ref      like snh_reference.

define new shared variable ctnnbr_fm     like snd_ctnnbr_fm.
define new shared variable ctnnbr_to     like snd_ctnnbr_to.
define new shared variable ctn_qty       as integer format ">,>>9".       
define new shared variable qtyper        as integer format ">,>>>,>>9".   
define new shared variable ext_qty       as decimal format ">,>>>,>>9.9<".
define new shared variable netwt         as decimal format ">,>>9.99".    
define new shared variable ext_netwt     as decimal format ">,>>>,>>9.9<".
define new shared variable grosswt       as decimal format ">>,>>9.99".   
define new shared variable ext_grosswt   as decimal format ">,>>>,>>9.9<".
define new shared variable length        as decimal format ">>9.9".       
define new shared variable height        as decimal format ">>9.9".       
define new shared variable width         as decimal format ">>9.9".       
define new shared variable cbm           as decimal format ">>,>>9.9<<".  
define new shared variable p_ext_grosswt   as decimal format ">,>>>,>>9.9<".
define new shared variable p_length        as decimal format ">>9.9".       
define new shared variable p_height        as decimal format ">>9.9".       
define new shared variable p_width         as decimal format ">>9.9".       
define new shared variable p_cbm           as decimal format ">>,>>9.9<<".  


define new shared variable shipto3       like snp_shipto     .
define new shared variable nbr3          like snp_nbr        .
define new shared variable ext_grosswt3  like snp_ext_grosswt.
define new shared variable length3       like snp_length     .
define new shared variable height3       like snp_height     .
define new shared variable width3        like snp_width      .
define new shared variable cbm3          like snp_cbm        .


define new shared variable snnbr2 like sn_nbr no-undo.
define new shared variable sndate2 like sn_date no-undo.
define new shared variable sntime2 like sn_time no-undo.
define new shared variable snwk2  like sn_ship_wk no-undo.
define new shared variable part2 like snd_part no-undo.
define new shared variable order2 like snd_so_order no-undo.
define new shared variable ext_qty2 like snd_ext_qty no-undo.
define variable i as integer.

define new shared temp-table xxln_tmp
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


define new shared temp-table  xxsq2_tmp
		field xxsq2_flag		as character format "x(1)" 
		field xxsq2_sel		as character format "x(1)" 
        field xxsq2_sq_nbr   /* like snh_sq_nbr*/ as integer format ">>9"
		field xxsq2_plt_nbr  like snh_plt_nbr
		field xxsq2_shipto   like snh_shipto  
		field xxsq2_ponbr	like shad_ponbr
		field xxsq2_part     like snh_part    
		field xxsq2_ctnnbr_fm like shad_ctnnbr_fm
		field xxsq2_ctnnbr_to like shad_ctnnbr_to
		field xxsq2_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
        index xxsq2_nbr IS PRIMARY UNIQUE xxsq2_sq_nbr ascending
		.
define new shared temp-table  xxsq_tmp
        field xxsq_sanbr    like shad_sanbr
        field xxsq_sq      /* like snh_sq_nbr*/ as integer format ">>9"
        field xxsq_ctn_line like shad_ctn_line
		field xxsq_plt_nbr  like snh_plt_nbr
		field xxsq_so_order like snh_so_order
        field xxsq_ponbr    like shad_ponbr
		field xxsq_shipto   like snh_shipto  
		field xxsq_part     like snh_part    
		field xxsq_qty_open like sod_qty_ord format ">,>>>,>>9.9<"
		field xxsq_part_um  like snh_part_um 
		field xxsq_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
		field xxsq_ext_qty  like sod_qty_ship format ">,>>>,>>9.9<"
		field xxsq_trf_qty  like sod_qty_ship format ">,>>>,>>9.9<"
        field xxsq_select   like mfc_logical
        field xxsq_shploc   like shad_shploc
        field xxsq_ctnnbr_fm like shad_ctnnbr_fm
        field xxsq_ctnnbr_to like shad_ctnnbr_to
        index xxsq_nbr IS PRIMARY UNIQUE xxsq_sanbr xxsq_sq xxsq_ctn_line ascending
		.

DEFINE VARIABLE doc_recid as recid.
DEFINE new shared VARIABLE fm_site    like si_site .
DEFINE new shared VARIABLE fm_loc     like loc_loc .
DEFINE new shared VARIABLE to_site    like si_site .
DEFINE new shared VARIABLE to_loc     like loc_loc .
define new shared variable fm_lotser like sr_lotser.
define new shared variable fm_lotref like ld_ref.  
define new shared variable to_lotser like sr_lotser.
define new shared variable to_lotref like ld_ref.  

DEFINE VARIABLE select_all like mfc_logical init no.
DEFINE VARIABLE method_desc as CHARACTER format "x(58)".
/*DEFINE VARIABLE fm_lotser like ld_lot init "".
DEFINE VARIABLE fm_lotref like ld_ref init "".
DEFINE VARIABLE to_lotser like ld_lot init "".
DEFINE VARIABLE to_lotref like ld_ref init "".*/
define variable sa_sq like shad_sq.
define variable plt_nbr like shad_plt_nbr.
define variable ctn_line like shad_ctn_line.
define variable sa_recid as recid.
define variable err_seq as integer initial 0.



form
   sanbr	  at 1 label "SA"
   shah_shipto at 14 label "Ship To"
   ad_name      at 33 no-label
   shah_etdhk   at 65 label "ETD-HK"
   fm_site      at 1 label "Fm site" format "x(4)"
   fm_loc       label "Fm Loc" at 15
   to_site      label "To Site" format "x(4)" at 32
   to_loc       label "To Loc" at 46
   select_all   label "Select ALL" at 64
   shah_method  at 1 label "Method"
   method_desc  no-label at 19
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form with frame b 7 down width 80 .
/*setFrameLabels(frame b:handle).*/

Form 
    sa_sq           at 1 label "SQ"
    plt_nbr    label "PLT"
    ctn_line   label "Line"
    xxsq_ctnnbr_fm  label "CTN Fm"
    xxsq_ctnnbr_to  label "CTN To"
    xxsq_ponbr      label "PO"
    skip
    xxsq_part       label "Item"
    xxsq_ext_qty    label "Qty Open"
    xxsq_trf_qty    label "Transfer"
    with frame c attr-space side-labels width 80.

setFrameLabels(frame c:handle).


	   sanbr = "".

    mainloop:
    repeat on error undo, retry:  
        view frame a.
        assign fm_site = "EAST" to_site = "EAST".
       i = 1.
       update 
          sanbr 
        with frame a editing:
           {mfnp.i shah_hdr sanbr shah_sanbr sanbr shah_sanbr shah_sanbr}
             if recno <> ? then do:
                assign

		   sanbr     = shah_sanbr.
           FIND first shah_hdr where shah_sanbr = sanbr no-lock 
           	NO-ERROR.
            if available shah_hdr then assign fm_loc = shah_chr01 to_loc = shah_chr02.
            else assign fm_loc = "" to_loc = "".
		   find ad_mstr where ad_addr = shah_shipto no-lock no-error.
           find ship_mt_mstr where ship_mt_code = shah_method no-lock no-error.
           IF available ship_mt_mstr THEN method_desc = ship_loc_seq1 + ship_loc_seq2 + ship_loc_seq3 + ship_loc_seq4 + ship_loc_seq5 + ship_loc_seq6 + ship_loc_seq7 + ship_loc_seq8 + ship_loc_seq9 + ship_loc_seq10.
           else method_desc = "".
        display 
		    sanbr
            shah_shipto
            ad_name when available ad_mstr   
            shah_etdhk 
            fm_site    
            fm_loc     
            to_site    
            to_loc     
            select_all 
            shah_method
            method_desc
            with frame a.
	     end. /* if recno<>? */
	end.  /*with frame a eiting:*/
            
        find first shah_hdr where shah_sanbr = sanbr no-error.
            if available shah_hdr then do:
               find ad_mstr where ad_addr = shah_shipto no-lock no-error.
               find ship_mt_mstr where ship_mt_code = shah_method no-lock no-error.
               IF available ship_mt_mstr THEN do:
               /*method_desc = ship_loc_seq1 + ship_loc_seq2 + ship_loc_seq3 + ship_loc_seq4 + ship_loc_seq5 + ship_loc_seq6 + ship_loc_seq7 + ship_loc_seq8 + ship_loc_seq9 + ship_loc_seq10.*/
                    method_desc = ship_loc_seq1.
                    if ship_loc_seq2 <> "" then method_desc = method_desc + ">" + ship_loc_seq2.
                    if ship_loc_seq3 <> "" then method_desc = method_desc + ">" + ship_loc_seq3.
                    if ship_loc_seq4 <> "" then method_desc = method_desc + ">" + ship_loc_seq4.
                    if ship_loc_seq5 <> "" then method_desc = method_desc + ">" + ship_loc_seq5.
                    if ship_loc_seq6 <> "" then method_desc = method_desc + ">" + ship_loc_seq6.
                    if ship_loc_seq7 <> "" then method_desc = method_desc + ">" + ship_loc_seq7.
                    if ship_loc_seq8 <> "" then method_desc = method_desc + ">" + ship_loc_seq8.
                    if ship_loc_seq9 <> "" then method_desc = method_desc + ">" + ship_loc_seq9.
                    if ship_loc_seq10 <> "" then method_desc = method_desc + ">" + ship_loc_seq10.
                   assign fm_loc = if can-find(first shloc_hist where shloc_sanbr = sanbr) then shah_chr01 else ship_loc_seq1
                          to_loc = if can-find(first shloc_hist where shloc_sanbr = sanbr) then shah_chr02 else "".
               end.
               else assign method_desc = "" 
                           fm_loc = if can-find(first shloc_hist where shloc_sanbr = sanbr) then shah_chr01 else ""  
                           to_loc = if can-find(first shloc_hist where shloc_sanbr = sanbr) then shah_chr02 else "".           
               .
            display 
                sanbr
                shah_shipto
                ad_name    
                shah_etdhk 
                fm_site    
                fm_loc     
                to_site    
                to_loc     
                select_all 
                shah_method
                method_desc
                with frame a.
	    end.
		
		
	    if not available shah_hdr then do:
	        message "Error: Invalid SA Number.Please re-enter".
			undo, retry.
	    end.

        from-loop:
        repeat on endkey undo mainloop,retry:
        update fm_site fm_loc to_site to_loc select_all with frame a.

/*J034*/          find si_mstr where si_site = fm_site no-lock no-error.
/*J034*/          if not available si_mstr then do:
/*J034*/             {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
/*J034*/             next-prompt fm_site with frame a.
/*G1FP*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
                   "(input si_site, input recid(si_mstr), output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             next-prompt fm_site with frame a.
/*J034*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J2JV*/          /* OPEN PERIOD VALIDATION FOR THE ENTITY OF FROM SITE */
/*J2JV*/          {gpglef02.i &module = ""IC""
                              &entity = si_entity
                              &date   = today
                              &prompt = "fm_site"
                              &frame  = "a"
                              &loop   = "from-loop"}

/*F0D2*/          find si_mstr where si_site = fm_site no-lock no-error.
/*F0D2*/          find loc_mstr where loc_site = fm_site
/*F0D2*/                          and loc_loc = fm_loc no-lock no-error.

/*F0D2*/          if not available si_mstr then do:
/*F0D2*/             /* site does not exist */
/*F0D2*/             {mfmsg.i 708 3}
/*G1FP*/             undo from-loop, retry from-loop.
/*F0D2*/ /*G1FP*           undo xferloop, retry xferloop. */
/*F0D2*/          end.
/*F0D2*/          if not available loc_mstr then do:
/* ricky /*F0D2*/             if not si_auto_loc then do:*/
/*F0D2*/                /* Location/lot/item/serial does not exist */
/*F0D2                {mfmsg.i 305 3}*/
                        message "Error: Invalid From Location Code".
/*G1FP*/                next-prompt fm_loc with frame a.
/*G1FP*/                   undo from-loop, retry from-loop.
/*F0D2*/             end.
/*ricky
/*F0D2*/             else do:
/*F0D2*/                find is_mstr where is_status = si_status
/*F0D2*/                no-lock no-error.
/*F0D2*/                if available is_mstr and is_overissue then do:
/*F0D2*/                end.
/*F0D2*/                else do:
/*F0D2*/                   /* quantity available in site loc for lot serial */
/*F0D2*/                   {mfmsg02.i 208 3 0}
/*F0D2*/                   undo mainloop, retry mainloop.
/*F0D2*/                end.
/*F0D2*/             end.
                    end.*/

/*J034*/          find si_mstr where si_site = to_site no-lock no-error.
/*J034*/          if not available si_mstr then do:
/*J034*/             {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
/*J034*/             next-prompt to_site with frame a.
/*G1FP*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
                   "(input si_site, input recid(si_mstr), output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             next-prompt to_site with frame a.
/*J034*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J2JV*/          /* OPEN PERIOD VALIDATION FOR THE ENTITY OF FROM SITE */
/*J2JV*/          {gpglef02.i &module = ""IC""
                              &entity = si_entity
                              &date   = today
                              &prompt = "to_site"
                              &frame  = "a"
                              &loop   = "from-loop"}

/*F0D2*/          find si_mstr where si_site = to_site no-lock no-error.
/*F0D2*/          find loc_mstr where loc_site = to_site
/*F0D2*/                          and loc_loc = to_loc no-lock no-error.

/*F0D2*/          if not available si_mstr then do:
/*F0D2*/             /* site does not exist */
/*F0D2*/             {mfmsg.i 708 3}
/*G1FP*/             undo from-loop, retry from-loop.
/*F0D2*/ /*G1FP*           undo xferloop, retry xferloop. */
/*F0D2*/          end.
/*F0D2*/          if not available loc_mstr then do:
/*ricky /*F0D2*/             if not si_auto_loc then do: */
/*F0D2*/                /* Location/lot/item/serial does not exist */
/*F0D2                {mfmsg.i 305 3}*/
                        message "Error: Invalid To Location code".
/*G1FP*/                next-prompt to_loc with frame a.
/*G1FP*/                   undo from-loop, retry from-loop.
/*F0D2*/             end.
/* @@@@@@@@ /*F0D2*/             else do:
/*F0D2*/                find is_mstr where is_status = si_status
/*F0D2*/                no-lock no-error.
/*F0D2*/                if available is_mstr and is_overissue then do:
/*F0D2*/                end.
/*F0D2*/                else do:
/*F0D2*/                   /* quantity available in site loc for lot serial */
/*F0D2*/                   {mfmsg02.i 208 3 0}
/*F0D2*/                   undo mainloop, retry mainloop.
/*F0D2*/                end. 
/*F0D2*/             end.
                    end.*/
                    IF fm_site = to_site and fm_loc = to_loc THEN
                    DO:
                        message "Error: Invalid To Location code".
/*G1FP*/                next-prompt to_loc with frame a.
/*G1FP*/                   undo from-loop, retry from-loop.
                    END.
               find ship_mt_mstr where ship_mt_code = shah_method no-lock no-error.
               IF available ship_mt_mstr THEN do:
                    if index(ship_loc_seq1 +  ";" + ship_loc_seq2 +  ";" + ship_loc_seq3 +  ";" + ship_loc_seq4
                     +  ";" + ship_loc_seq5 +  ";" + ship_loc_seq6 +  ";" + ship_loc_seq7 +  ";" + ship_loc_seq8
                      +  ";" + ship_loc_seq9 +  ";" + ship_loc_seq10,to_loc) <= 0 then do:
                      message "Error: To Location Code MUST be on the list of Method's Location".
                      next-prompt to_loc with frame a.
                      undo,retry.
                    end.
               end.
               else do:
                    message "Error: Invalid Method code".
                    undo,retry.
               end.

/*F0D2*/    leave.
        end. /* from-loop*/

        sa_sq = 0.
        detail-loop:
        repeat:
        FOR EACH xxsq_tmp:
        	delete xxsq_tmp.
        END.
        clear frame b all no-pause.
        FOR EACH shad_det where shad_sanbr = sanbr and shad_sq >= sa_sq and shad_ctn_line <> 0 /*and shad_shploc = fm_loc*/:
            find shloc_hist where shloc_sanbr = shad_sanbr and shloc_sq = shad_sq and shloc_ctn_line = shad_ctn_line
                 and shloc_site = fm_site and shloc_loc = fm_loc no-lock no-error.
            create xxsq_tmp.
            assign xxsq_sanbr    = sanbr
                   xxsq_sq       = shad_sq
                   xxsq_ctn_line = shad_ctn_line
                   xxsq_plt_nbr  = shad_plt_nbr
                   xxsq_so_order = shad_so_nbr
                   xxsq_ponbr    = shad_po
                   xxsq_part     = shad_part
                   xxsq_ext_qty  = if not available shloc_hist then shad_ext_qty else shloc_open_qty
                   xxsq_trf_qty  = if select_all then xxsq_ext_qty else 0
                   xxsq_select   = if select_all then yes else no
                   xxsq_shploc   = if not available shloc_hist then shad_shploc else shloc_loc
                   xxsq_ctnnbr_fm = shad_ctnnbr_fm
                   xxsq_ctnnbr_to = shad_ctnnbr_to.
        end.
        for each xxsq_tmp where xxsq_sq >= sa_sq with frame b:
        	display xxsq_sq         at 1 label "SQ"          
                    xxsq_plt_nbr    at 5 label "PLT"         
                    xxsq_ctn_line   at 9 label "Ln"          
                    xxsq_ponbr      at 13 label "PO No."     
                    xxsq_part       at 26 label "Item No."   
                    xxsq_ext_qty    format ">,>>>,>>9.9<" at 45  label "Ext Qty"
                    xxsq_trf_qty    format ">,>>>,>>9.9<" at 58 label "Trf Qty"
                    xxsq_shploc     at 71 label "Loc".
               if frame-line(b) = frame-down(b) then leave.
               down 1 with frame b.
            if xxsq_shploc <> fm_loc or xxsq_ext_qty = 0 then do:
                delete xxsq_tmp.
                next.
            end.

        END.
        
        IF not can-find(first xxsq_tmp) THEN
        DO:
        	message "SA not under this from Loation, please re-enter".
            undo mainloop,retry.
        END.
        rq-loop:
        repeat:
            
            view frame c.
            set sa_sq plt_nbr ctn_line with frame c editing:
                IF frame-field = "sa_sq" THEN
                DO:
                	{mfnp01.i xxsq_tmp sa_sq xxsq_sq sanbr xxsq_sanbr xxsq_nbr }
                    IF recno <> ? THEN
                    DO:
                        assign sa_sq = xxsq_sq
                                plt_nbr = xxsq_plt_nbr
                                ctn_line = xxsq_ctn_line.

                        DISPLAY
                            xxsq_sq @ sa_sq           
                            xxsq_plt_nbr @ plt_nbr    
                            xxsq_ctn_line @ ctn_line
                            xxsq_ctnnbr_fm  
                            xxsq_ctnnbr_to  
                            xxsq_ponbr      
                            xxsq_part       
                            xxsq_ext_qty    
                            xxsq_trf_qty    
                            with frame c attr-space side-labels width 80.
                    END.

                END.
                else do:
                    status input.
                    readkey.
                    apply lastkey.
                end.

            end.
            if sa_sq = 0 then leave.

            FIND xxsq_tmp where xxsq_sanbr = sanbr and xxsq_sq = sa_sq and xxsq_ctn_line = ctn_line and xxsq_plt_nbr = plt_nbr no-error.
            IF not available xxsq_tmp THEN
            DO:
            	message "Error: Invalid SQ + PLT + Ln Number, please re-enter".
                next-prompt sa_sq with frame c.
                undo,retry.
            END.    
            sa_recid = recid(xxsq_tmp).

            clear frame b all no-pause.
            for each xxsq_tmp where xxsq_sq >= sa_sq with frame b:
                display xxsq_sq         at 1 label "SQ"
                        xxsq_plt_nbr    at 5 label "PLT"
                        xxsq_ctn_line   at 9 label "Ln"
                        xxsq_ponbr      at 13 label "PO No."
                        xxsq_part       at 26 label "Item No."
                        xxsq_ext_qty    format ">,>>>,>>9.9<" at 45  label "Ext Qty"
                        xxsq_trf_qty    format ">,>>>,>>9.9<" at 58 label "Trf Qty"
                        xxsq_shploc     at 71 label "Loc".
                   if frame-line(b) = frame-down(b) then leave.
                   down 1 with frame b.

            END.
            find xxsq_tmp where recid(xxsq_tmp) = sa_recid no-error.
            DISPLAY
                xxsq_sq @ sa_sq           
                xxsq_plt_nbr @ plt_nbr    
                xxsq_ctn_line @ ctn_line
                xxsq_ctnnbr_fm  
                xxsq_ctnnbr_to  
                xxsq_ponbr      
                xxsq_part       
                xxsq_ext_qty    
                xxsq_trf_qty    
                with frame c attr-space side-labels width 80.
            repeat on endkey undo,leave:
            update xxsq_trf_qty with frame c.
            IF xxsq_trf_qty > xxsq_ext_qty THEN
            DO:
            	message "Error: Transfer Qty > Open Qty, please re-enter".
                xxsq_trf_qty = 0.
                next-prompt xxsq_trf_qty with frame c.
                undo, retry.
            END.

            find first shah_hdr where shah_sanbr = sanbr no-lock no-error.
            find loc_mstr where loc_site = fm_site and loc_loc = fm_loc no-lock no-error.
            IF available loc_mstr THEN
            DO:
            	IF loc_type = "FG" then assign fm_lotser = "" fm_lotref = "".
                else assign fm_lotser = sanbr fm_lotref = if available shah_hdr then string(shah_etdhk) else "".
            END.
            find loc_mstr where loc_site = to_site and loc_loc = to_loc no-lock no-error.
            IF available loc_mstr THEN
            DO:
            	IF loc_type = "FG" then assign to_lotser = "" to_lotref = "".
                else assign to_lotser = sanbr to_lotref = if available shah_hdr then string(shah_etdhk) else "".
            END.

            find ld_det where ld_part = xxsq_part and ld_site = fm_site and ld_loc = fm_loc and ld_lot = fm_lotser and ld_ref = fm_lotref no-lock no-error.
            IF not available ld_det THEN
            DO:
            	message "Error: Transfer Qty > Location balance, please re-enter".
                xxsq_trf_qty = 0.
                next-prompt xxsq_trf_qty with frame c.
                undo, retry.
            END.
            else IF ld_qty_oh < xxsq_trf_qty THEN
            DO:
            	message "Error: Transfer Qty > Location balance, please re-enter".
                xxsq_trf_qty = 0.
                next-prompt xxsq_trf_qty with frame c.
                undo, retry.
            END.
            if xxsq_trf_qty = 0 then xxsq_select = no.
            else xxsq_select = yes.
            leave.
            end.
            clear frame b all no-pause.
            for each xxsq_tmp where xxsq_sq >= sa_sq with frame b:
                display xxsq_sq         at 1 label "SQ"
                        xxsq_plt_nbr    at 5 label "PLT"
                        xxsq_ctn_line   at 9 label "Ln"
                        xxsq_ponbr      at 13 label "PO No."
                        xxsq_part       at 26 label "Item No."
                        xxsq_ext_qty    format ">,>>>,>>9.9<" at 45  label "Ext Qty"
                        xxsq_trf_qty    format ">,>>>,>>9.9<" at 58 label "Trf Qty"
                        xxsq_shploc     at 71 label "Loc".
                   if frame-line(b) = frame-down(b) then leave.
                   down 1 with frame b.

            END.
        end. /*sq-loop*/
        leave.
        end. /*detail-loop*/
        DEFINE VARIABLE yn as logical.
        yn = yes.
        message "Display the SQ being Transfered ?" update yn.
        IF yn THEN
        DO:
        	yn = no.
            FOR EACH xxsq_tmp where xxsq_select and xxsq_trf_qty > 0 with frame d:
                display xxsq_sq         at 1 label "SQ"
                        xxsq_plt_nbr    at 5 label "PLT"
                        xxsq_ctn_line   at 9 label "Ln"
                        xxsq_ponbr      at 13 label "PO No."
                        xxsq_part       at 26 label "Item No."
                        xxsq_ext_qty    format ">,>>>,>>9.9<" at 45  label "Ext Qty"
                        xxsq_trf_qty    format ">,>>>,>>9.9<" at 58 label "Trf Qty"
                        xxsq_shploc     at 71 label "Loc".
                        down.
                FIND shloc_hist where shloc_sanbr = xxsq_sanbr and shloc_sq = xxsq_sq and shloc_ctn_line = xxsq_ctn_line
/*@@@@@@@@                     and shloc_site = fm_site and shloc_loc = fm_loc no-lock*/
/*@@@@@@@@*/                     and shloc_site = fm_site and shloc_loc = fm_loc no-lock
        			NO-ERROR.
/*@@@@@@@@                 IF available shloc_hist and shloc_open_qty > 0 and not yn THEN*/
/*@@@@@@@@*/                 IF available shloc_hist and shloc_ext_qty - shloc_trf_qty > 0 and not yn THEN
                DO:
                	message "Oustanding SA details exist, Exit continue?" update yn.
                    IF not yn THEN
                    DO:
                    	undo mainloop,retry.
                    END.
                END.
        	END.
        END.
        yn = yes.
        message "Confirm Transfer?" update yn.
        err_seq = 1.
        IF yn THEN
        DO:
            find first shah_hdr where shah_sanbr = sanbr no-lock no-error.
            find loc_mstr where loc_site = fm_site and loc_loc = fm_loc no-lock no-error.
            IF available loc_mstr THEN
            DO:
            	IF loc_type = "FG" then assign fm_lotser = "" fm_lotref = "".
                else assign fm_lotser = sanbr fm_lotref = if available shah_hdr then string(shah_etdhk) else "".
            END.
            find loc_mstr where loc_site = to_site and loc_loc = to_loc no-lock no-error.
            IF available loc_mstr THEN
            DO:
            	IF loc_type = "FG" then assign to_lotser = "" to_lotref = "".
                else assign to_lotser = sanbr to_lotref = if available shah_hdr then string(shah_etdhk) else "".
            END.
            {gprun.i ""xxshloctrfa.p"" "(output err_seq)"}
        END.
        IF err_seq = 0 THEN
        DO:
            FIND first shah_hdr where shah_sanbr = sanbr 
            	NO-ERROR.
            IF available shah_hdr THEN assign shah_chr01 = fm_loc shah_chr02 = to_loc.
        	FOR EACH xxsq_tmp where xxsq_select and xxsq_trf_qty > 0 :

                find shad_det where shad_sanbr = sanbr and shad_sq = xxsq_sq and shad_ctn_line = xxsq_ctn_line no-error.
                IF available shad_det THEN
                DO:
                	assign shad_trf_qty = xxsq_trf_qty.
                END.

                FIND shloc_hist where shloc_sanbr = xxsq_sanbr and shloc_sq = xxsq_sq and shloc_ctn_line = xxsq_ctn_line
                    and shloc_site = fm_site and shloc_loc = fm_loc
        			NO-ERROR.
                IF not available shloc_hist THEN
                DO:
                	create shloc_hist.
                    assign shloc_sanbr = xxsq_sanbr
                           shloc_sq = xxsq_sq
                           shloc_ctn_line = xxsq_ctn_line
                           shloc_plt_nbr = xxsq_plt_nbr
                           shloc_site = fm_site
                           shloc_loc = fm_loc
                           shloc_ext_qty = shad_ext_qty
                           shloc_open_qty = shad_ext_qty.
                END.
                assign /*shloc_ext_qty = shloc_ext_qty + xxsq_trf_qty*/
                       shloc_trf_qty = shloc_trf_qty + xxsq_trf_qty
                       shloc_open_qty = shloc_open_qty - xxsq_trf_qty .


        		FIND shloc_hist where shloc_sanbr = xxsq_sanbr and shloc_sq = xxsq_sq and shloc_ctn_line = xxsq_ctn_line
                    and shloc_site = to_site and shloc_loc = to_loc
        			NO-ERROR.
                IF not available shloc_hist THEN
                DO:
                	create shloc_hist.
                    assign shloc_sanbr = xxsq_sanbr
                           shloc_sq = xxsq_sq
                           shloc_ctn_line = xxsq_ctn_line
                           shloc_plt_nbr = xxsq_plt_nbr
                           shloc_site = to_site
                           shloc_loc = to_loc.
                END.
                assign shloc_ext_qty = shloc_ext_qty + xxsq_trf_qty
                       /*shloc_trf_qty = shloc_trf_qty + xxsq_trf_qty*/
                       shloc_open_qty = shloc_open_qty + xxsq_trf_qty.
        	END.
        END.
end. /*mainloop*/

  
           status input.
