/* pppcmt.p - PRICE LIST MAINTENANCE                                    */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*M0P3*/ /* $Revision: 1.14.1.4 $ */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 6.0      LAST MODIFIED: 11/06/91   BY: WUG *D916**/
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048**/
/* REVISION: 7.0      LAST MODIFIED: 04/24/92   BY: tjs *F425**/
/* REVISION: 7.0      LAST MODIFIED: 08/18/92   BY: tjs *F835**/
/* REVISION: 7.3      LAST MODIFIED: 10/01/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: pma *G940**/
/* REVISION: 7.4      LAST MODIFIED: 09/09/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 03/02/94   BY: cdt *H287**/
/* REVISION: 7.4      LAST MODIFIED: 05/19/94   BY: afs *FO24**/
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: afs *H502**/
/* REVISION: 7.4      LAST MODIFIED: 10/06/94   BY: afs *H554**/
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   BY: ljm *GO15**/
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: cpp *F0HN**/
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: cpp *F0HP**/
/* REVISION: 7.4      LAST MODIFIED: 03/22/95   BY: rxm *H0C6**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/95   BY: ais *H0GH**/
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS**/
/* REVISION: 7.4      LAST MODIFIED: 02/06/96   BY: rxm *G1MD**/
/* REVISION: 7.4      LAST MODIFIED: 03/11/96   BY: rxm *G1MF**/
/* REVISION: 7.4      LAST MODIFIED: 09/10/96   BY: *H0MN* Suresh Nayak */
/* REVISION: 7.4      LAST MODIFIED: 09/12/96   BY: *H0MT* Suresh Nayak */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *L020* Charles Yen  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/29/00   BY: *N0GV* Mudit Mehta      */
/* Revision: 1.14      BY: Anil Sudhakaran DATE: 04/03/01 BY: M0P3 */
/* Revision: 1.14.1.1  BY: Anil Sudhakaran  DATE: 04/09/01  BY: *N0Y0* */
/* $Revision: 1.14.1.4 $  BY: Anil Sudhakaran  DATE: 05/16/01  BY: *N0YW* */
/* $Revision: 1.14.1.4 $  BY: Ashutosh Pitre   DATE: 11/27/01  BY: *M1QZ* */
/* REVISION: 9.1      LAST MODIFIED: 05/22/03   BY: *EAS024A*  Apple Tam  */

     /* DISPLAY TITLE */
     {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0GV*------------START COMMENT----------------
 * &SCOPED-DEFINE pppcmt_p_1 " Item Master List Price:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_2 "Min Qty"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_3 "      Markup %"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_4 "Minimum Price:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_5 "         Price"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_6 "Maximum Price:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_7 "    Discount %"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_8 "(P)rice  (D)iscount%  (M)arkup%  (L)ist"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_9 "Price Table List Price:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_10 "Site:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_11 "Stock UM:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_12 "Total GL Cost:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcmt_p_13 "Total This Level GL Cost:"
 * /* MaxLen: Comment: */
 *N0GV*----------END COMMENT----------------- */

/* ********** End Translatable Strings Definitions ********* */

/*L020*/ define variable mc-error-number like msg_nbr no-undo.

     define variable del-yn        like mfc_logical initial no.
     define variable i             as integer.
     define variable qty_label     as character format "x(7)" extent 3.
     define variable amt_label     as character format "x(14)" extent 3.
         define variable list_label    as character format "x(24)"
/*N0GV*                                initial {&pppcmt_p_1}*/ .
     define variable price         as character.
     define variable discount      as character.
     define variable markup        as character.
         define variable ptable_label  as character format "x(23)".
         define variable min_label     as character format "x(14)".
         define variable max_label     as character format "x(14)".
         define variable pcamttype     like pc_amt_type.
         define variable old_db        like si_db.
         define variable err_flag      as integer.
         define variable base_curr1    like base_curr.
         define variable base_curr2    like base_curr.
         define variable glxcst_tl     like sct_cst_tot.
         define variable temp_max_price like pc_max_price
                    extent 0
                    decimals 10
                    no-undo.
/*N0GV*/ define variable disp-price-discount-markup as character no-undo
/*N0GV*/        format "x(44)".
/*N0GV*/ define variable disp-stock-um as character no-undo format "x(12)".
/*N0GV*/ define variable disp-total-this-level-gl as character no-undo
/*N0GV*/        format "x(29)".
/*N0GV*/ define variable disp-site-col as character no-undo format "x(10)".
/*N0GV*/ define variable disp-total-gl-cost as character no-undo format "x(28)".
/*eas024*/ define new shared variable cmtindx like cmt_indx.
/*eas024*/ define variable xxquo as character format "x(30)" label "Quotation No.".
/*eas024*/ define variable xxcmmt as logical initial yes label "Comments".

/*N0GV*/ assign list_label = " " + getTermLabel("ITEM_MASTER_LIST_PRICE",23)
                             + ":"
                disp-price-discount-markup =
              "P-" + getTermLabel("PRICE",7) + " " +
              "D-" + getTermLabel("DISCOUNT",10) + " " +
              "M-" + getTermLabel("MARKUP_PERCENT",10) + " " +
              "L-" + getTermLabel("LIST",6)
                disp-stock-um = getTermLabelRtColon("STOCK_UM",12)
                disp-total-this-level-gl =
                          getTermLabelRtColon("TOTAL_THIS_LEVEL_GL_COST",29)
                disp-site-col = getTermLabelRtColon("SITE",10)
                disp-total-gl-cost = getTermLabelRtColon("TOTAL_GL_COST",28).

         /* Variable added to perform delete during CIM. Record is deleted
          * Only when the value of this variable is set to "X" */
/*M0P3*/ define variable batchdelete as character format "x(1)" no-undo.

     /*VARIABLE DEFINITIONS FOR GPFIELD.I*/
         {gpfieldv.i}

     /* DISPLAY SELECTION FORM */

     form
        pc_list        colon 29
         pc_curr        colon 50
        pc_prod_line   colon 29
/*Kaine*/ xpc_supp		COLON 43 LABEL "Vendor"
/*Kaine*/ xpc_adddate	COLON 70 LABEL "Quotation Date"
        pc_part        colon 29   pt_desc1 at 52 no-label
        pc_um          colon 29   /*eas024*/ batchdelete at 52 no-label
/*N0Y0** pc_start       colon 29 */
/*N0Y0*/ pc_start      colon 29   /*eas024 batchdelete at 52 no-label*/
/*eas024        pc_expire      colon 29*/
/*eas024*/        pc_expire      colon 55
/*N0GV*     pc_amt_type    colon 29 {&pppcmt_p_8} */
/*N0GV*/    pc_amt_type    colon 29
/*N0GV*/    disp-price-discount-markup no-label
/*eas024*/ pc_user1        colon 29 format "x(30)" label "Quotation No."
/*eas024*/ xxcmmt          colon 70
     with frame a side-labels width 80 attr-space.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).

     form
/*N0GV*     list_label     to 29 pt_price base_curr {&pppcmt_p_11} to 65 pt_um*/
/*N0GV*/    list_label     to 29 pt_price base_curr
/*M1QZ** /*N0GV*/    disp-stock-um to 65 pt_um */
/*M1QZ*/    disp-stock-um to 65 pt_um at 68
/*H0C6
 * /*H502*/    "Cost:" to 29 glxcst to 46 base_curr1   "Site:"     to 65 pt_site
 *H0C6*/
/*N0GV*
 *          {&pppcmt_p_13} to 29
 *          glxcst_tl                   to 46
 *          base_curr1 {&pppcmt_p_10}          to 65 pt_site
 *          {&pppcmt_p_12}            to 29
 *N0GV*/
/*M1QZ*/    /*V8-*/
/*N0GV*/    disp-total-this-level-gl to 29
/*N0GV*/    glxcst_tl                   to 46
/*N0GV*/    base_curr1 disp-site-col    to 65 pt_site
/*N0GV*/    disp-total-gl-cost          to 29
            glxcst                      to 46 base_curr2
/*M1QZ*/    /*V8+*/ /*V8!
/*M1QZ*/    disp-total-this-level-gl at 7
/*M1QZ*/    glxcst_tl                   at 31
/*M1QZ*/    base_curr1 disp-site-col    at 57 pt_site at 68
/*M1QZ*/    disp-total-gl-cost          at 9
/*M1QZ*/    glxcst                      at 31 base_curr2 */
         /*V8-*/
        qty_label[1]   at  3 amt_label[1]
        qty_label[2]   at 29 amt_label[2]
        qty_label[3]   at 55 amt_label[3]

         /*V8+*/ /*V8!
        qty_label[1]   at  2 amt_label[1] at 11
        qty_label[2]   at 27 amt_label[2] at 36
        qty_label[3]   at 52 amt_label[3] at 61 */

        skip
         /*V8-*/
        space(2) pc_min_qty[1] pc_amt[1]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[6] pc_amt[6]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[11] pc_amt[11]
        format "->>>,>>>,>>9.9<<<<"
        skip
        space(2) pc_min_qty[2] pc_amt[2]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[7] pc_amt[7]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[12] pc_amt[12]
        format "->>>,>>>,>>9.9<<<<"
        skip
        space(2) pc_min_qty[3] pc_amt[3]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[8] pc_amt[8]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[13] pc_amt[13]
        format "->>>,>>>,>>9.9<<<<"
        skip
        space(2) pc_min_qty[4] pc_amt[4]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[9] pc_amt[9]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[14] pc_amt[14]
        format "->>>,>>>,>>9.9<<<<"
        skip
        space(2) pc_min_qty[5] pc_amt[5]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[10] pc_amt[10]
        format "->>>,>>>,>>9.9<<<<"
        space(3) pc_min_qty[15] pc_amt[15]
        format "->>>,>>>,>>9.9<<<<"
         /*V8+*/ /*V8!
        pc_min_qty[1] at 2 pc_amt[1] at 10
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[6] at 27 pc_amt[6] at 35
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[11] at 52 pc_amt[11] at 60
        format "->>>,>>>,>>9.9<<<<"
        skip
        pc_min_qty[2] at 2 pc_amt[2] at 10
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[7] at 27 pc_amt[7] at 35
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[12] at 52 pc_amt[12] at 60
        format "->>>,>>>,>>9.9<<<<"
        skip
        pc_min_qty[3] at 2 pc_amt[3] at 10
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[8] at 27 pc_amt[8] at 35
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[13] at 52 pc_amt[13] at 60
        format "->>>,>>>,>>9.9<<<<"
        skip
        pc_min_qty[4] at 2 pc_amt[4] at 10
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[9] at 27 pc_amt[9] at 35
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[14] at 52 pc_amt[14] at 60
        format "->>>,>>>,>>9.9<<<<"
        skip
        pc_min_qty[5] at 2 pc_amt[5] at 10
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[10] at 27 pc_amt[10] at 35
        format "->>>,>>>,>>9.9<<<<"
        pc_min_qty[15] at 52 pc_amt[15] at 60
        format "->>>,>>>,>>9.9<<<<"          */
        skip
     with frame b no-labels width 80 attr-space.

         form
/*N0GV*     list_label     to 29 pt_price base_curr {&pppcmt_p_11} to 65 pt_um*/
/*N0GV*/     list_label     to 29 pt_price base_curr
/*M1QZ** /*N0GV*/     disp-stock-um  to 65 pt_um */
/*M1QZ*/     disp-stock-um  to 65 pt_um at 68
/*H0C6
 * /*H502*/ "Cost:" to 29 glxcst to 46 base_curr1   "Site:"     to 65 pt_site
 *H0C6*/
 /*N0GV*
  *         {&pppcmt_p_13} to 29
  *         glxcst_tl                   to 46
  *         base_curr1 {&pppcmt_p_10}          to 65 pt_site
  *         {&pppcmt_p_12}            to 29
  *N0GV*/
/*M1QZ*/    /*V8-*/
/*N0GV*/    disp-total-this-level-gl to 29
/*N0GV*/    glxcst_tl                   to 46
/*N0GV*/    base_curr1 disp-site-col    to 65 pt_site
/*N0GV*/    disp-total-gl-cost          to 29
            glxcst                      to 46 base_curr2
            skip(1)
            ptable_label   to 29 pc_amt[1]
            min_label      to 29 pc_min_price
            max_label      to 29 temp_max_price
/*M1QZ*/    /*V8+*/ /*V8!
/*M1QZ*/    disp-total-this-level-gl at 7
/*M1QZ*/    glxcst_tl                at 31
/*M1QZ*/    base_curr1 disp-site-col at 57 pt_site at 68
/*M1QZ*/    disp-total-gl-cost       at 9
/*M1QZ*/    glxcst                   at 31 base_curr2
/*M1QZ*/    skip(1)
/*M1QZ*/    ptable_label at 12 pc_amt[1]      at 31
/*M1QZ*/    min_label    at 17 pc_min_price   at 31
/*M1QZ*/    max_label    at 17 temp_max_price at 31 */
            skip(2)
         with frame c overlay no-labels row 11 width 80 attr-space.

/*N0GV*
 *        qty_label = {&pppcmt_p_2}.
 *    price     = {&pppcmt_p_5}.
 *    markup    = {&pppcmt_p_3}.
 *    discount  = {&pppcmt_p_7}.
 *    amt_label = discount.
 *        ptable_label = {&pppcmt_p_9}.
 *        min_label    = {&pppcmt_p_4}.
 *        max_label    = {&pppcmt_p_6}.
 *N0GV*/
/*N0GV*/ assign
         qty_label = getTermLabel("MINIMUM_QUANTITY",7)
         price     = getTermLabelRt("PRICE",14)
         markup    = getTermLabelRt("MARKUP",13) + "%"
         discount  = getTermLabelRt("DISCOUNT_PERCENT",14)
         amt_label = discount
         ptable_label = getTermLabel("PRICE_TABLE_LIST_PRICE",22) + ":"
         min_label    = getTermLabelRtColon("MINIMUM_PRICE",14)
         max_label    = getTermLabelRtColon("MAXIMUM_PRICE",14).

     /* DISPLAY */
     view frame a.
/*N0GV*/ display disp-price-discount-markup with frame a.

     display base_curr @ pc_curr with frame a.

     main-loop:
     repeat with frame a:

         /* Initialize batchdelete variable */
/*M0P3*/ batchdelete = "".
/*eas024*/ xxcmmt = yes.

         prompt-for pc_list pc_curr pc_prod_line pc_part pc_um pc_start
         /* Prompt for batchdelete variable only during CIM */
/*M0P3*/ batchdelete no-label when (batchrun)
        editing:

           /* FIND NEXT/PREVIOUS RECORD */
           {mfnp.i pc_mstr pc_list pc_list pc_prod pc_prod pc_list}

           if recno <> ? then do:
          find pt_mstr where pt_part = pc_part no-lock no-error.

/*eas024*/	  if integer(pc_user2) = 0 then do:
                     xxcmmt = no.
		  end.
		  else do:
		      xxcmmt = yes.
		  END.
		  
/*Kaine*/ 		DEFINE BUFFER pc-mstr FOR pc_mstr.
/*Kaine*/ 		FIND FIRST xpc_mstr WHERE xpc_list = pc_list AND xpc_curr = pc_curr
/*Kaine*/ 					AND xpc_prod_line = pc_prod_line AND xpc_part = pc_part
/*Kaine*/ 					AND xpc_um = pc_um AND xpc_start = pc_start NO-ERROR.

/*Kaine*/ 			IF NOT AVAILABLE xpc_mstr THEN 
/*Kaine*/ 			DO:
/*Kaine*/ 				CREATE xpc_mstr.
/*Kaine*/ 				xpc_list = pc_list.
/*Kaine*/ 				xpc_curr = pc_curr.
/*Kaine*/ 				xpc_prod_line = pc_prod_line.
/*Kaine*/ 				xpc_part = pc_part.
/*Kaine*/ 				xpc_um = pc_um.
/*Kaine*/ 				xpc_start = pc_start.
/*Kaine*/ 			END.

          display pc_list pc_curr pc_prod_line pc_part pc_um
            pc_start pc_expire pc_amt_type /*eas024*/ pc_user1 xxcmmt
            				/*Kaine*/	   /*eas024b*/ xpc_supp xpc_adddate with frame a.


          if      pc_amt_type = "P" then amt_label = price.
          else if pc_amt_type = "M" then amt_label = markup.
          else if pc_amt_type = "D" then amt_label = discount.

                  /* Get item cost from default site */
                  if available pt_mstr then do:
                     find si_mstr where si_site = pt_site no-lock.
                     if si_db <> global_db then do:
                        old_db = global_db.
                        {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
                     end.
/*H0C6
 * /*H502*/          {gprun.i ""gpsct05.p""
 *                   "(pt_part, si_site, 2, output glxcst, output curcst)" }
 *H0C6*/
                     {gprun.i ""gpsct05.p""
             "(pt_part, si_site, 3, output glxcst, output curcst)" }
                     glxcst_tl = glxcst.
                     {gpsct05.i
             &part=pt_part &site=si_site &cost="sct_ovh_tl"}
                     glxcst_tl = glxcst_tl - glxcst.
                     {gprun.i ""gpsct05.p""
             "(pt_part, si_site, 1, output glxcst, output curcst)" }
                     if old_db <> global_db then do:
                        {gprun.i ""gpalias3.p"" "(old_db, output err_flag)" }
                     end.
                  end.

                  if index("PMD", pc_amt_type) <> 0 then do:
                     hide frame c.
                     view frame b.
                     clear frame b no-pause.
/*N0GV*/     display disp-stock-um
                     disp-total-this-level-gl
                     disp-site-col
                     disp-total-gl-cost with frame b.
             display list_label qty_label amt_label with frame b.
             display pc_min_qty pc_amt with frame b.

             if available pt_mstr then do:
            display pt_desc1.
                        display pt_price base_curr pt_um
                          glxcst_tl base_curr @ base_curr1 pt_site
                          glxcst base_curr @ base_curr2 with frame b.
             end.
             else do:
            display "" @ pt_desc1.
             end.
          end.
                  else do:
                     hide frame b.
                     view frame c.
                     clear frame c no-pause.
                     temp_max_price = (pc_max_price[1]
                         +  (pc_max_price[2] / 100000)).
/*N0GV*/             display disp-stock-um
                             disp-total-this-level-gl
                             disp-site-col
                             disp-total-gl-cost with frame c.
                     display list_label ptable_label
                        min_label max_label with frame c.
                     display pc_amt[1] pc_min_price temp_max_price
                        with frame c.

                     if available pt_mstr then do:
                        display pt_desc1.
                        display pt_price base_curr pt_um
                           glxcst_tl base_curr @ base_curr1 pt_site
                           glxcst base_curr @ base_curr2 with frame c.
                     end.
             else do:
            display "" @ pt_desc1.
             end.
                  end.
           end.  /* if recno <> ? */
               else if frame-field = "pc_part" then do:
                   find pt_mstr where pt_part = input pc_part no-lock no-error.
                   if available pt_mstr then display pt_desc1.
                                        else display "" @ pt_desc1.
               end. /* If recno = ? and frame-field = pc_part */

        end.

           /* VALIDATE CURRENCY CODE */
            if input pc_curr <> base_curr then do:
/*L020*        find first ex_mstr
*              where ex_curr = input pc_curr no-lock no-error.
*              if not available ex_mstr then do:
*L020*/
/*L020*/       {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                "(input input pc_curr,
                  output mc-error-number)"}
/*L020*/       if mc-error-number <> 0 then do:
/*L020*           {mfmsg.i 3109 3}  /* INVALID CURRENCY CODE */
*L020*/
/*L020*/          {mfmsg.i mc-error-number 3}  /* INVALID CURRENCY CODE */
                  next-prompt pc_curr.
                  undo main-loop, retry.
               end.
            end.

        if input pc_prod_line <> "" and input pc_part <> "" then do:
           {mfmsg.i 49 3}
           next-prompt pc_prod_line.
           undo.
        end.

        /* ADD/MOD/DELETE  */

            find first pc_mstr using pc_list and pc_curr and pc_prod_line
        and pc_part and pc_um and pc_start no-error.

        if not available pc_mstr then do:
           {mfmsg.i 1 1}  /* ADDING NEW RECORD */
           create pc_mstr.
           assign pc_list pc_curr pc_part pc_prod_line
              pc_part pc_start pc_um.
           if not can-find(pt_mstr where pt_part = pc_part)
           and pc_part <> "" then do:
          {mfmsg.i 16 2} /* ITEM NUMBER DOES NOT EXIST */
           end.
           if not can-find(pl_mstr where pl_prod_line = pc_prod_line)
           and pc_prod_line <> "" then do:
          {mfmsg.i 59 2} /* PRODUCT LINE DOES NOT EXIST */
           end.
        end.

        /* STORE MODIFY DATE AND USERID */
        pc_mod_date = today.
        pc_userid = global_userid.

         if pc_curr = "" then assign pc_curr = base_curr.
         if (pc_curr <> input pc_curr) and
         (pc_curr <> "" and input pc_curr <> "" )
        then do:
           {mfmsg.i 84 3}  /* CURRENCY CANNOT BE CHANGED */
           undo, retry.
        end.

        if      pc_amt_type = "P" then amt_label = price.
        else if pc_amt_type = "M" then amt_label = markup.
        else if pc_amt_type = "D" then amt_label = discount.

            /* Move display down after determining pc_amt_type        */

            recno = recid(pc_mstr).

        ststatus = stline[2].
        status input ststatus.
        del-yn = no.

            do on error undo, retry with frame a no-validate:

/*eas024               update pc_expire pc_amt_type go-on ("F5" "CTRL-D"). */
/*eas024*/     update pc_expire pc_amt_type pc_user1 xxcmmt go-on ("F5" "CTRL-D"). 

/*Kaine         first address                           */ 
/*Kaine*/ 		FIND FIRST xpc_mstr WHERE xpc_list = pc_list AND xpc_curr = pc_curr
/*Kaine*/ 					AND xpc_prod_line = pc_prod_line AND xpc_part = pc_part
/*Kaine*/ 					AND xpc_um = pc_um AND xpc_start = pc_start NO-ERROR.

/*Kaine*/ 			IF NOT AVAILABLE xpc_mstr THEN 
/*Kaine*/ 			DO:
/*Kaine*/ 				CREATE xpc_mstr.
/*Kaine*/ 				xpc_list = pc_list.
/*Kaine*/ 				xpc_curr = pc_curr.
/*Kaine*/ 				xpc_prod_line = pc_prod_line.
/*Kaine*/ 				xpc_part = pc_part.
/*Kaine*/ 				xpc_um = pc_um.
/*Kaine*/ 				xpc_start = pc_start.
/*Kaine*/ 			END.
/*Kaine*/          UPDATE xpc_supp xpc_adddate WITH FRAME a.

               if pc_expire <> ? and pc_start <> ?
               and pc_expire < pc_start then do:
                  {mfmsg.i 6221 2}
               end.

           /* DELETE */
           if lastkey = keycode("F5")
           or lastkey = keycode("CTRL-D")
/*N0YW*/   /* Delete record if batchdelete is set to "x" */
/*N0YW*/   or input batchdelete = "x":U
           then do:
          del-yn = yes.
          {mfmsg01.i 11 1 del-yn}
          if del-yn = no then undo, retry.
           end.

               /* MANUALLY VALIDATE PRICE LIST TYPE*/
               if index("PMDL", pc_amt_type) = 0 then do:
                  {mfmsg.i 7527 3}
                  /* VALID PRICE LIST TYPES ARE (P), (M), (D), AND (L).*/
                  next-prompt pc_amt_type with frame a.
                  undo, retry.
               end.
        end.


/*eas024***********************************************/
		/*Comments start*/
		do on error undo,leave:
	        global_lang = global_user_lang.
	        global_type = "".
	        global_ref = "".
	        if xxcmmt = yes then do:
		      hide frame a no-pause.
		      hide frame b no-pause.
		      hide frame c no-pause.
		        cmtindx = integer(pc_user2).
		        {gprun.i ""xxgpcmmt01.p"" "(input """",input ""Transaction Comments"")"}
		        pc_user2 = string(cmtindx).
		      view frame a.
/*		      view frame b.*/
		    end.
		/*Comments end*/
		end.
/*eas024***************************************************/


        if del-yn then do:
           delete pc_mstr.

           clear frame a.
           clear frame b.
               clear frame c.

               display base_curr @ pc_curr with frame a.
           display list_label qty_label amt_label with frame b.
/*N0GV*/   display disp-stock-um
                     disp-total-this-level-gl
                     disp-site-col
                     disp-total-gl-cost with frame b.

           del-yn = no.
           next main-loop.
        end.
        else do:

               /* GET ITEM COST FROM DEFAULT SITE */
               find pt_mstr where pt_part = pc_part no-lock no-error.
               if available pt_mstr then do:
                  find si_mstr where si_site = pt_site no-lock.
                  if si_db <> global_db then do:
                     old_db = global_db.
                     {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
                  end.
                  {gprun.i ""gpsct05.p""
          "(pt_part, si_site, 3, output glxcst, output curcst)" }
                  glxcst_tl = glxcst.
                  {gpsct05.i &part=pt_part &site=si_site &cost="sct_ovh_tl"}
                  glxcst_tl = glxcst_tl - glxcst.
                  {gprun.i ""gpsct05.p""
          "(pt_part, si_site, 1, output glxcst, output curcst)" }
                  if old_db <> global_db then do:
                     {gprun.i ""gpalias3.p"" "(old_db, output err_flag)" }
                  end.
               end.

           if      pc_amt_type = "P" then amt_label = price.
           else if pc_amt_type = "M" then amt_label = markup.
           else if pc_amt_type = "D" then amt_label = discount.

           /* DISCOUNT TABLE */
               if index("PMD", pc_amt_type) <> 0 then do:

                  hide frame c.
                  view frame b.
                  clear frame b no-pause.

                  display pc_list pc_curr pc_part pc_prod_line
                          pc_part pc_um pc_start.

          display list_label qty_label amt_label with frame b.
/*N0GV*/  display disp-stock-um
                     disp-total-this-level-gl
                     disp-site-col
                     disp-total-gl-cost with frame b.

          display pc_min_qty pc_amt with frame b.

                  if available pt_mstr then do:
                     display pt_desc1.
                     display pt_price base_curr pt_um
                        glxcst_tl base_curr @ base_curr1 pt_site
                        glxcst base_curr @ base_curr2 with frame b.
                  end.




          do on error undo, retry:

             set
            pc_min_qty[01] pc_amt[01] pc_min_qty[02] pc_amt[02]
            pc_min_qty[03] pc_amt[03] pc_min_qty[04] pc_amt[04]
            pc_min_qty[05] pc_amt[05] pc_min_qty[06] pc_amt[06]
            pc_min_qty[07] pc_amt[07] pc_min_qty[08] pc_amt[08]
            pc_min_qty[09] pc_amt[09] pc_min_qty[10] pc_amt[10]
            pc_min_qty[11] pc_amt[11] pc_min_qty[12] pc_amt[12]
            pc_min_qty[13] pc_amt[13] pc_min_qty[14] pc_amt[14]
            pc_min_qty[15] pc_amt[15]
            go-on ("F5" "CTRL-D")
            with frame b width 80.

             /* DELETE */
             if lastkey = keycode("F5")
             or lastkey = keycode("CTRL-D")
             then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn = no then undo, retry.
            delete pc_mstr.
            clear frame a.
            clear frame b.
            display list_label qty_label amt_label with frame b.
/*N0GV*/    display disp-stock-um
                     disp-total-this-level-gl
                     disp-site-col
                     disp-total-gl-cost with frame b.
            del-yn = no.
            next main-loop.
             end.

             do i = 1 to 15:
            if i > 1 then
            if pc_min_qty[i - 1] >= pc_min_qty[i]
            and (pc_min_qty[i] <> 0 or pc_amt[i] <> 0) then do:
               {mfmsg.i 63 3}
               /*  PLEASE RE-ENTER.".                        */
               next-prompt pc_min_qty[i] with frame b.
               undo.
            end.
                      if i > 1 then /* disallow a min qty =0 within the list */
                      if (pc_min_qty[i - 1] = 0 and pc_min_qty[i] <> 0) then do:
                        if pc_amt[i - 1] = 0 then do:
                           {mfmsg.i 63 3}
               /*  PLEASE RE-ENTER.".                        */
                           next-prompt pc_min_qty[i] with frame b.
                           undo.
                        end.
                     end.

             if pc_amt_type = "D" or pc_amt_type = "M" then do:
              if pc_amt[i] <> truncate(pc_amt[i] * 100,0) / 100 then do:
              {mfmsg02.i 99 3 "2"  }
              next-prompt pc_amt[i] with frame b.
              undo, retry.
               end.
             end.
           end.
          end. /* do on error retry */
               end. /* if p,m,d */
               else do: /* PRICE TABLE */

                  hide frame b.
                  view frame c.
                  clear frame c no-pause.

                  temp_max_price = (pc_max_price[1]
                        +  (pc_max_price[2] / 100000)).
          display pc_list pc_curr pc_part pc_prod_line
              pc_part pc_um pc_start.
          display list_label ptable_label pc_amt[1]
              min_label  pc_min_price max_label
                          temp_max_price with frame c.
          if available pt_mstr then do:
             display pt_desc1.
                     display pt_price base_curr pt_um
                        glxcst_tl base_curr @ base_curr1 pt_site
                        glxcst base_curr @ base_curr2 with frame c.
          end.

          display ptable_label pc_amt[1]
              min_label  pc_min_price max_label
                          temp_max_price with frame c.

          do on error undo, retry:

             set
                        pc_amt[1] pc_min_price temp_max_price
            go-on ("F5" "CTRL-D")
            with frame c width 80.
                     pc_max_price[1] = truncate(temp_max_price,2).
                     pc_max_price[2]
                        = (temp_max_price - pc_max_price[1]) * 100000.

             /* DELETE */
             if lastkey = keycode("F5")
             or lastkey = keycode("CTRL-D")

/*N0YW*      /* Delete record if batchdelete is set to "x" */ */
/*N0YW* /*M0P3*/     or input batchdelete = "x":U */

             then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn = no then undo, retry.
            delete pc_mstr.
            clear frame a.
            display base_curr @ pc_curr "" @ pt_desc1.
            del-yn = no.
            next main-loop.
             end.

             /* VERIFICATIONS */
                     if temp_max_price > 0 then do:
                        if pc_min_price > temp_max_price then do:
               {mfmsg.i 460 3 }
               /* MINIMUM EXCEEDS MAXIMUM */
               next-prompt pc_min_price with frame c.
               undo, retry.
            end.
             end.

             if pc_amt[1] > 0 then do:
            if pc_min_price > 0 then do:
               if pc_amt[1] < pc_min_price then do:
                          {mfmsg03.i 6208 4 pc_part
                                 "pc_amt[1], "">>>>>9.99<<<"" "
                 "pc_min_price, "">>>>>9.99<<<"" "}
                  /* LIST PRICE IS BELOW PRICE TABLE MINIMUM. */
                  next-prompt pc_amt[1] with frame c.
                  undo, retry.
               end.
            end.

                        if temp_max_price > 0 then do:
                           if pc_amt[1] > temp_max_price then do:
                      {mfmsg03.i 6209 4 pc_part
                                 "pc_amt[1], "">>>>>9.99<<<"" "
                 "temp_max_price, "">>>>>9.99<<<"" "}
                  /* LIST PRICE IS ABOVE PRICE TABLE MAXIMUM. */
                  next-prompt pc_amt[1] with frame c.
                  undo, retry.
               end.
            end.
             end.

          end. /* do on error retry */
               end.
        end.  /* else do: */

     end.

     status input.
