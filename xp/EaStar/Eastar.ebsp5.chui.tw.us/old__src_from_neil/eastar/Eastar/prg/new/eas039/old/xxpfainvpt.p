/* xxpfainvpt.p  -- Proforma Invoice Print */
/* REVISION: eb SP5 create 06/02/04 BY: *EAS039A4* Apple Tam */

         /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}


         define new shared variable sanbr like shah_sanbr.
         define new shared variable sanbr1 like shah_sanbr.
         define new shared variable pinbr like shah_pinbr.
         define new shared variable pinbr1 like shah_pinbr.
	 define new shared variable print_yn as logical initial yes.

	 form
            sanbr            colon 30 label "Shipping Advice No."
            sanbr1           label {t001.i} colon 50
            pinbr            colon 30 label "Proforma Invoice No."
            pinbr1           label {t001.i} colon 50
	    skip(1)
	    print_yn         label "Print Company Address" colon 30
	    skip(1)
         with frame a width 80 attr-space side-labels.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         repeat:
            if sanbr1 = hi_char then sanbr1 = "".
            if pinbr1 = hi_char then pinbr1 = "".
            update sanbr sanbr1 pinbr pinbr1 print_yn
            with frame a.


            bcdparm = "".
            {mfquoter.i sanbr    }
            {mfquoter.i sanbr1   }
            {mfquoter.i pinbr    }
            {mfquoter.i pinbr1   }
            {mfquoter.i print_yn }

            if sanbr1 = "" then sanbr1 = hi_char.
            if pinbr1 = "" then pinbr1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 80}


           {gprun.i  ""xxpf01.p""}

               {mfreset.i}

         end.
