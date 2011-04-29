/* xxshad02.i  -- Shipping Advice Print */
/* REVISION: eb SP5 create 03/21/04 BY: *EAS037A* Apple Tam */

	 form
            nbr2           at 2 label "Pallet#"
	    shad_part           label "Part No."
/*	    shad_ponbr          label "P/O #"*/
	    shad_qtyper         label "QTY/CTN"         format ">>>,>>9"    
	    shad_ctn_qty        label "CTN"             format ">>>9"       
	    shad_ext_qty        label "QTY"             format ">>,>>>,>>9" 
	    shad_ctn_ext_gw     label "GW(KGS)"         format ">>,>>9.99"
	    shad_ctn_cbm        label "Meas(CBM)"       format ">9.999"
/*	    shad_plt_gw         label "GW(KGS)"         format ">>,>>9.99"  
	    shad_plt_cbm        label "Meas(CBM)"       format ">9.999"     */
            with frame c no-box width 90 down.

/*            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).
*/