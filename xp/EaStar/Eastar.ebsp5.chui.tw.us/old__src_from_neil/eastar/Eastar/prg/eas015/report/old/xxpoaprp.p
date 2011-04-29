/* xxpoaprp.p - Purhase Order Approval Status Report                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 9.1      LAST MODIFIED: 03/18/03   BY: *EAS015*  Apple Tam */

/*K0PW*/ {mfdtitle.i "b+ "}    /*GG10*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp08_p_1 "Variance %"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_2 "yes/no/All"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_3 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_4 "Ext Current Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_5 "Ext Std Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


      define variable xxbuyer as character format "x(8)".
      define variable xxbuyer1 as character format "x(8)".
      define variable xxlog as character format "x(2)".
      define variable xxlog1 as character format "x(2)".
      define variable xxnbr like po_nbr.
      define variable xxnbr1 like po_nbr.
      define variable xxpart like pod_part.
      define variable xxpart1 like pod_part.
      define variable xxper_date like pod_per_date.
      define variable xxper_date1 like pod_per_date.
      define variable xxvend like po_vend.
      define variable xxvend1 like po_vend.
      define variable buyer_name like code_cmmt.

      define variable ld-printed as logical no-undo.
      define variable first-loc as logical no-undo.
      /*K0PW*/ define variable parts_printed as integer.
      /*K0PW*/ define variable locations_printed as integer.
      define variable appr_print as character label "Approved PO" format "x(1)" initial "N".

      /* SELECT FORM */
      form
         xxbuyer           colon 18 label "Buyer"
         xxbuyer1          label {t001.i} colon 49 skip
         xxlog             colon 18 label "Log No."
         xxlog1            label {t001.i} colon 49 skip
         xxnbr             colon 18 label "Purchase Order"
         xxnbr1            label {t001.i} colon 49 skip
         xxpart            colon 18 label "Item Number"
         xxpart1           label {t001.i} colon 49 skip 
         xxper_date        colon 18 label "Perfect Date"
         xxper_date1       label {t001.i} colon 49 skip
         xxvend            colon 18 label "Supplier"
         xxvend1           label {t001.i} colon 49 skip (1)
         appr_print           colon 30 
	 "Yes - Print Approved PO"    colon 45
	 "No  - Print Unapproved PO"  colon 45
	 "All - Print All PO"         colon 45 skip(1)
      with frame a side-labels width 80 attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

      /* REPORT BLOCK */

      {wbrp01.i}
repeat:

         if xxbuyer1 = hi_char then xxbuyer1 = "".
         if xxlog1 = hi_char then xxlog1 = "".
         if xxnbr1 = hi_char then xxnbr1 = "".
         if xxvend1 = hi_char then xxvend1 = "".
         if xxpart1 = hi_char then xxpart1 = "".
         if xxper_date = low_date then xxper_date = ?.
         if xxper_date1 = hi_date then xxper_date1 = ?.


 if c-application-mode <> 'web':u then
            update
	    xxbuyer
	    xxbuyer1
	    xxlog
	    xxlog1
	    xxnbr
	    xxnbr1
	    xxpart
	    xxpart1
	    xxper_date
	    xxper_date1
	    xxvend
	    xxvend1
           appr_print
         with frame a.

{wbrp06.i &command = update &fields = "  xxbuyer xxbuyer1 xxlog xxlog1
xxnbr xxnbr1 xxpart xxpart1 xxper_date xxper_date1 xxvend xxvend1 appr_print" &frm = "a"}

 if (c-application-mode <> 'web':u) or
 (c-application-mode = 'web':u and
 (c-web-request begins 'data':u)) then do:


         bcdparm = "".

         {mfquoter.i xxbuyer   }
         {mfquoter.i xxbuyer1  }
         {mfquoter.i xxlog   }
         {mfquoter.i xxlog1  }
         {mfquoter.i xxnbr    }
         {mfquoter.i xxnbr1   }
         {mfquoter.i xxpart   }
         {mfquoter.i xxpart1  }
         {mfquoter.i xxper_date    }
         {mfquoter.i xxper_date1   }
         {mfquoter.i xxvend   }
         {mfquoter.i xxvend1  }
         {mfquoter.i appr_print}

         if xxbuyer1 = "" then xxbuyer1 = hi_char.
         if xxlog1 = "" then xxlog1 = hi_char.
         if xxnbr1 = "" then xxnbr1 = hi_char.
         if xxpart1 = "" then xxpart1 = hi_char.
         if xxvend1 = "" then xxvend1 = hi_char.
         if xxper_date = ? then xxper_date = low_date.
         if xxper_date1 = ? then xxper_date1 = hi_date.


 end.
            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
         {mfphead.i}


         for each xxpoa_det no-lock where xxpoa_buyer >= xxbuyer and xxpoa_buyer <= xxbuyer1
         and xxpoa_log >= xxlog and xxpoa_log <= xxlog1
         and xxpoa_nbr >= xxnbr and xxpoa_nbr <= xxnbr1
         and xxpoa_part >= xxpart and xxpoa_part <= xxpart1 
         and xxpoa_per_date >= xxper_date and xxpoa_per_date <= xxper_date1
         and xxpoa_vend >= xxvend and xxpoa_vend <= xxvend1
	 and ((appr_print = "y" and xxpoa_appr = no) or 
	      (appr_print = "n" and xxpoa_appr = yes) or
	      (appr_print = "a" ))
         break by xxpoa_buyer by xxpoa_nbr by xxpoa_line with frame c down width 132 no-box:



        /* SET EXTERNAL LABELS */
        setFrameLabels(frame c:handle).
        if  first-of(xxpoa_buyer) then do with frame b down width 132.
           /* SET EXTERNAL LABELS */
           setFrameLabels(frame b:handle).
           if page-size - line-counter < 8 then page.
           buyer_name = "".
	   find code_mstr where code_fldname = "po_buyer" and code_value = xxpoa_buyer no-lock no-error.
	   if available code_mstr then buyer_name = code_cmmt.
	   display
              xxpoa_buyer
	      buyer_name.
           down 1.
        end. /* IF  FIRST-OF(xxpoa_buyer) */

	display 
	  xxpoa_log
	  xxpoa_appr
	  xxpoa_nbr
	  xxpoa_line
	  xxpoa_part
	  xxpoa_qty_ord
	  xxpoa_um
	  xxpoa_curr
	  xxpoa_unit_cost
	  xxpoa_last_price
	  xxpoa_quote_price
	  xxpoa_per_date
	  xxpoa_vend
	  .
	  if xxpoa_appr = yes then display "no" @ xxpoa_appr.
	  if xxpoa_appr = no then display "yes" @ xxpoa_appr.
         end. /* FOR EACH xxpoa_det ... */

         /* REPORT TRAILER */
         {mfreset.i}

      end. /* REPEAT */

 {wbrp04.i &frame-spec = a}
