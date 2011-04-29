/* xxpf02.i  -- Proforma Invoice Print */
/* REVISION: eb SP5 create 06/02/04 BY: *EAS039A4* Apple Tam */

	 form
            shad_ponbr          at 1 /*label "CUSTOMER PO"*/
	    shad_part         /*  column-label "PART NO!DESCRIPTION"*/
	    ext_qty           /* label "QTY"  */       format ">,>>>,>>>,>>9.99"    
	    um                /*  label "U/M"             */
	    price             /*  label "U/PRICE(CUR)"  */       format ">>>>,>>9.9999"
	    amount        /*label "AMOUNT(CUR)"  */     format ">>>,>>9.9999"
            with frame c no-box no-labels width 90 down.

/*            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).
*/