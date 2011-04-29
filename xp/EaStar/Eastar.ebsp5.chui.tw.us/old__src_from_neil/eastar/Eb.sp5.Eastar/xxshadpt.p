/* xxshadpt.p  -- Shipping Advice Print */
/* REVISION: eb SP5 create 04/19/04 BY: *EAS037A* Apple Tam */

         /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}


         define new shared variable sanbr like shah_sanbr.
         define new shared variable sanbr1 like shah_sanbr.
	 define new shared variable print_yn as logical initial yes.

	 form
            sanbr            colon 30
            sanbr1           label {t001.i} colon 50
	    print_yn         label "Print Company Address" colon 30
	    skip(1)
         with frame a width 80 attr-space side-labels.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         repeat:
            if sanbr1 = hi_char then sanbr1 = "".
            update sanbr sanbr1 print_yn
            with frame a.


            bcdparm = "".
            {mfquoter.i sanbr    }
            {mfquoter.i sanbr1   }
            {mfquoter.i print_yn }

            if sanbr1 = "" then sanbr1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 80}


           {gprun.i  ""xxshad01.p""}

               {mfreset.i}

         end.
