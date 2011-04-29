/* sopiprn2.i - PRINT DISCOUNT SUMMARY ON SALES ORDERS AND INVOICES      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*V8:ConvertMode=Report                                                  */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                  */
/* REVISION: 8.5      LAST MODIFIED: 04/19/95   BY: afs *J042*           */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: DAH *J0T0*           */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */

     /* This include file prints summary discount information for an */
     /* entire sales quote, sales order or invoice line.  This       */
     /* information is printed from a workfile defined in sodiscwk.i */
     /* and created/updated in sopiprn1.i.                           */

     /* There are no parameters because this include just dumps the  */
     /* discount workfile if it exists.                              */

for each disc_wkfl exclusive-lock break by disc_prilist:

/* SS - 100726.1 - B 
    if first(disc_prilist) and page-size - line-counter < 4 then
       page.
   SS - 100726.1 - E */

        find first lngd_det where lngd_dataset = "pi_mstr"
                  and lngd_field   = "pi_amt_type"
                  and lngd_lang    = global_user_lang
                  and lngd_key1    = disc_amt_type
                no-lock no-error.
        if available(lngd_det) then amt_type = lngd_translation.
                   else amt_type = "".

        if disc_sum_key = "3" then      
            prnt_sum_disc_amt = disc_disc_amt.
        else if disc_sum_key = "2" then  
            prnt_sum_disc_amt = if disc_extamt <> 0 then
                            (disc_disc_amt / disc_extamt) * 100
                            else
                            0.

/* SS - 100726.1 - B 
        if page-size - line-counter < 1 then
               page.

        hdl_sum_disc_lbl:label = disc_prnt_label.


        setFrameLabels(frame disc_sum_print:handle).
        display 
            disc_desc
            amt_type
            prnt_sum_disc_amt
        with frame disc_sum_print.
        down 1 with frame disc_sum_print.
   SS - 100726.1 - E */

        delete disc_wkfl.

/* SS - 100726.1 - B 
        if last(disc_prilist) then
        down 1 with frame disc_sum_print.
   SS - 100726.1 - E */
     end.  /* for each */
