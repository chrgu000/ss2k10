/* gpcmtprt.i - INCLUDE FILE TO PRINT COMMENTS                          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0     LAST MODIFIED: 07/02/90    BY: WUG */
/* REVISION: 6.0     LAST MODIFIED: 08/13/90    BY: RAM *D030**/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718**/
/* REVISION: 9.1     LAST MODIFIED: 08/14/00    BY: *N0L1* Mark Brown   */
/*!
*/
/*!
Parameters:
&type       Identifies what document is printing:
        QO = Sales Quote
        SO = Sales Order
        IN = Invoice
        PA = Sales Order Packing List
        PO = Purchase Order
/*G718*/    RC = Purchase Receipt
        RV = Return to Vendor
        RP = Other non-mailout report (always printed)

&id         Identifies comment records, e.g. so_cmtindx for Sales Orders
&pos        Print position
&command    Command to perform after doing the page command,
        e.g. "down 1.".  This is to optionally prevent comment
        lines being printed between a page header and a column header.
*/
/*eas001a delete***************************************
for each cmt_det no-lock where cmt_indx = {&id}
and (lookup("{&type}",cmt_print) > 0 or "{&type}" = "RP"):
   do i = 1 to 15:
      if cmt_cmmt[i] <> "" then do:
     if page-size - line-count < 1 then do:
        page.
        {&command}
     end.
     put cmt_cmmt[i] at {&pos} skip.
      end.
   end.
end.
*eas001a delete*******************************************/
/*eas001a add**********************************************/
for each cmt_det no-lock where cmt_indx = {&id}
and (lookup("{&type}",cmt_print) > 0 or "{&type}" = "RP"):
   do i = 1 to 15:
      if cmt_cmmt[i] <> "" then do:
          if page-size - line-counter < 15 then do:
          put "----------------------------------------------------------------------------------------------------------" at 1.
	  put skip(5).
	  put "EASTAR(H.K.)LIMITED" at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "CONFIRMED & ACCEPTED BY" at 1.
	  put "AUTHORIZED SIGNATURE(S)" at 75.
	  page.
	  page_yn = yes.
	  end.
          if page_yn  then do:
	      display cmmt1# po_curr curr2# with frame phead-det.
	       page_yn = no.
               {&command}
          end.
          put cmt_cmmt[i] at 9 skip.
          line_yn = yes.
      end.
   end.
end.
/*eas001a add**********************************************/
