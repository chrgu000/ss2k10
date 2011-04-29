/* xxsobi12.p - SO Invoice report for BI (UNPOSTED INVOICE)            */
/* xxsobi10.p - SO Invoice report for BI                               */
/* COPYRIGHT KARRIE. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION 8.5      LAST MODIFIED: 05/09/07   BY: Ken *070509*        */
/* 1. Output SO Invoive into BI Format                                 */
/* REVISION 8.5      LAST MODIFIED: 08/08/07   BY: Ken *070808*        */
/* 1. Allow cp_cust = ""                                               */
/* 2. Change from Customer's address to Bill-To's Address              */
/* REVISION 8.5      LAST MODIFIED: 11/15/07   BY: Philip *071115*     */
/* 1. add line comment = 3 row to 8 row                                */
/* 2. add invoice comment = 3 row to 6 row                             */
/* 3. get 7.15 so_inv_date                                             */
/* REVISION: 8.5     LAST MODIFIED: 05/21/08   BY: SHL *080521*           */
/* 1. Add new variable to keep line sub-total with 'decimals 2' attribute */
/* 2. Rename BI path                                                      */


define variable invnbr like ih_inv_nbr.
define variable invdate as date label "Invoice Date".
define variable desc1 like pt_desc1 format "x(49)".
define variable ptdraw like pt_draw format "x(28)".
define variable print_trailer like mfc_logical label "Print Trailer".
define variable lineno like sod_line.
define variable companyname as character format "x(50)".
define variable tmp_date as date.
define variable dd as character.
define variable mm as integer.
define variable yy as character.
define variable str_mm as character.
define new shared variable inv_date_us as character format "x(13)".
define new shared variable ship_date_us as character format "x(13)".
define variable shipadd1 like ad_name.
define variable shipadd2 like ad_line1.
define variable shipadd3 like ad_line2.
define variable shipadd as logical.
define variable socmt1 like cmt_cmmt[1].
define variable socmt2 like cmt_cmmt[2].
define variable socmt3 like cmt_cmmt[3].
/*071115*/define variable socmt4 like cmt_cmmt[4].
/*071115*/define variable socmt5 like cmt_cmmt[5].
/*071115*/define variable socmt6 like cmt_cmmt[6].
define variable sodcmt1 like cmt_cmmt[1].
define variable sodcmt2 like cmt_cmmt[2].
define variable sodcmt3 like cmt_cmmt[3].
/*071115*/define variable sodcmt4 like cmt_cmmt[4].
/*071115*/define variable sodcmt5 like cmt_cmmt[5].
/*071115*/define variable sodcmt6 like cmt_cmmt[6].
/*071115*/define variable sodcmt7 like cmt_cmmt[7].
/*071115*/define variable sodcmt8 like cmt_cmmt[8].
define variable currdesc as character.
define variable custpart like cp_cust_part.
define variable i as integer.
define new shared variable numchar as integer.
define new shared variable socurr like so_curr.
define new shared variable decimal_dollar_amt as decimal.
define new shared variable string_dollar_amt as character format "x(100)".
define variable stringtotal as character format "x(160)".
define variable stringtotal1 as character format "x(79)".
define variable stringtotal2 as character format "x(79)".
/*080521*/ define variable ext_price like sod_price format "->>>,>>>,>>9.99".
/*080521*/ define variable ttl_amt as decimal decimals 2.

/*071115**  invdate = today. **/

/* DISPLAY TITLE */
{mfdtitle.i "a"}

/* SELECT FORM */
form
   invnbr colon 20 
/*071115**  invdate colon 50  **/ skip
   "*This Report will show 8 lines of Comments" at 10 skip
with frame a side-label width 80.

/*071115** display so_inv_date with frame a.  **/
REPEAT:
   update
      invnbr
   with frame a.

   bcdparm = "".                 
   {mfquoter.i invnbr   }
   
   {mfselbpr.i "printer" 100 }     

   find first so_mstr where so_inv_nbr = invnbr no-lock no-error.
   if available so_mstr and invnbr <> "" then do:
/*080521** put UNFORMATTED "#def REPORTPATH=$/Philip/invprint02" SKIP. */
/*080521*/ put UNFORMATTED "#def REPORTPATH=$/invprint/invprint02" SKIP.
      put UNFORMATTED "#def :end" SKIP.
      put     "Company Name" "|"
              "Customer Name" "|"
              "Address 1" "|"
              "Address 2" "|"
              "Address 3" "|"
              "City" "|"
              "State" "|"
              "Zip" "|"
              "Country" "|"
              "Attention" "|"
              "Ship Via" "|"
              "From Ship" "|"
              "To Ship" "|"
              "Ship Date" "|"
              "Ship-to Name" "|"
              "Ship-to Address1" "|"
              "ship-to Address2" "|"                     
              "Invoice Date" "|"
              "Invoice No." "|"
              "FOB" "|"
              "L/C No." "|"
              "Issuing Bank1" "|"
              "Issuing Bank2" "|"
              "Payment Terms" "|"
              "Currency" "|"
              "Purchase Nbr" "|"
              "BOL" "|"
              "Line" "|"
              "Part" "|"
              "Description" "|"
              "Drawing" "|"
              "Customer Part" "|"
              "Line Comment 1" "|"
              "Line Comment 2" "|"
              "Line Comment 3" "|"
/*071115*/    "Line Comment 4" "|"
/*071115*/    "Line Comment 5" "|"
/*071115*/    "Line Comment 6" "|"
/*071115*/    "Line Comment 7" "|"
/*071115*/    "Line Comment 8" "|"
              "Quantity" "|"                      
              "Price" "|"
              "Line Total" "|"
              "Total Currency" "|"
              "Invoice Total 1" "|"
              "Invoice Total 2" "|"
              "Invoice Total 3" "|"
              "Invoice Comment 1" "|"
              "Invoice Comment 2" "|"
              "Invoice Comment 3" "|"
/*071115*/    "Invoice Comment 4" "|"
/*071115*/    "Invoice Comment 5" "|"
/*071115*/    "Invoice Comment 6" "|"
              "Invoice type" skip.
        
      for each so_mstr where so_inv_nbr = invnbr 
      no-lock,each sod_det where sod_nbr = so_nbr and
                                 sod_qty_inv <> 0 and
                                 so_invoiced = yes and  
                                 so_to_inv = no          
      no-lock break by so_inv_nbr by sod_nbr by sod_line:
/*071115*/      invdate = so_inv_date.
         if first-of(so_inv_nbr) then do:
            socurr = so_curr.
            lineno = 1.
            decimal_dollar_amt = 0.
/*080521*/  ttl_amt = 0.
/*080521*/  ext_price = 0.
            if substring(so_cust,1,2) = "11" then
               companyname = "Karrie Industrial Co., Ltd.".
            else if substring(so_cust,1,2) = "22" then
                    companyname = "Karrie Technologies Co., Ltd.".
            else
               companyname = "".  
         end.    
         else
            lineno = lineno + 1.
/*080521**      
.        decimal_dollar_amt =  decimal_dollar_amt + sod_price * sod_qty_inv.*/
/*080521*/ ext_price = sod_price * sod_qty_inv.
/*080521*/ ttl_amt = ttl_amt + ext_price.
         shipadd = no.
         find first ct_mstr where ct_code = so_cr_term no-lock no-error.
         find first ad_mstr where ad_addr = so_ship and
                                  ad_type = "ship-to"
         no-lock no-error.
         if available ad_mstr then do:
            shipadd1 = ad_name.
            shipadd2 = ad_line1.
            shipadd3 = ad_line2.
            shipadd = yes.
         end.
/*070808        find first ad_mstr where ad_addr = so_cust no-lock no-error. */
/*070808*/ find first ad_mstr where ad_addr = so_bill no-lock no-error.
         if shipadd = no then do:
            shipadd1 = ad_name.
            shipadd2 = ad_line1.
            shipadd3 = ad_line2.
         end.
         find first pt_mstr where pt_part = sod_part no-lock no-error.
         if available pt_mstr then do:
            ptdraw = pt_draw.
            if pt_desc1 <> "" then
               desc1 = pt_desc1.
            else
               desc1 = pt_desc2. 
         end.
         else do: 
            desc1 = "".
            ptdraw = "".
            desc1 = sod_desc.
         end.  

/*070808*  find first cp_mstr where cp_cust = so_cust and cp_part = sod_part */ 
/*070808*/ find first cp_mstr where cp_part = sod_part and
/*070808*/                          (cp_cust = "" or cp_cust = so_cust)
         no-lock no-error.   
         if available cp_mstr then 
            custpart = cp_cust_part.
         else 
            custpart = "".
      
         find first cmt_det where cmt_indx = so_cmtindx no-lock no-error.
         if available cmt_det then do:
            socmt1 = cmt_cmmt[1].
            socmt2 = cmt_cmmt[2].
            socmt3 = cmt_cmmt[3].
/*071115*/  socmt4 = cmt_cmmt[4].
/*071115*/  socmt5 = cmt_cmmt[5].
/*071115*/  socmt6 = cmt_cmmt[6].
         end.
         else do:
            socmt1 = "".
            socmt2 = "".
            socmt3 = "".
/*071115*/  socmt4 = "".
/*071115*/  socmt5 = "".
/*071115*/  socmt6 = "".
         end.
         
         find first cmt_det where cmt_indx = sod_cmtindx no-lock no-error.
         if available cmt_det then do:
            sodcmt1 = cmt_cmmt[1].
            sodcmt2 = cmt_cmmt[2].
            sodcmt3 = cmt_cmmt[3].
/*071115*/  sodcmt4 = cmt_cmmt[4].
/*071115*/  sodcmt5 = cmt_cmmt[5].
/*071115*/  sodcmt6 = cmt_cmmt[6].
/*071115*/  sodcmt7 = cmt_cmmt[7].
/*071115*/  sodcmt8 = cmt_cmmt[8].
         end.
         else do:
            sodcmt1 = "".
            sodcmt2 = "".
            sodcmt3 = "".
/*071115*/  sodcmt4 = "".
/*071115*/  sodcmt5 = "".
/*071115*/  sodcmt6 = "".
/*071115*/  sodcmt7 = "".
/*071115*/  sodcmt8 = "".
         end.   
       
/**071115**       {xxdateus.i &c_date=invdate &p=inv_date_us}  **/
/*071115*/   {xxdateus.i &c_date=so_inv_date &p=inv_date_us}
       {xxdateus.i &c_date=so_ship_date &p=ship_date_us}

         if first-of(so_inv_nbr) then do:
            put companyname "|"
                ad_name "|"
                ad_line1 "|"
                ad_line2 "|"
                ad_line3 "|"
                ad_city "|"
                ad_state "|"
                ad_zip "|"  
                ad_country "|"
                ad_attn format "x(24)" "|"
                so_shipvia "|"
                so__chr04 format "x(30)" "|"
                so__chr05 format "x(30)" "|"
                ship_date_us "|"
                shipadd1 "|"
                shipadd2 "|"
                shipadd3 "|"
                inv_date_us "|"
                so_inv_nbr "|"
                so_fob "|"
                so__chr01 format "x(30)" "|"
                so__chr02 format "x(30)" "|"
                so__chr03 format "x(30)" "|"         
                ct_desc "|"
                so_curr "|".
         end.
         else
/*071115*/            put "|||||||||||||||||||||||||".

         if first-of(sod_nbr) then do:
            if so_po = "" then
               put "|".
            else 
               put "PO : " so_po "|".
            if so_bol = "" then
               put "|".
            else
               put "BOL : " so_bol "|".
         end.       
         else put "||".       
         
         put lineno "|"
             sod_part "|"
             desc1 "|"
             ptdraw "|"
             custpart "|"
             sodcmt1 "|"
             sodcmt2 "|"
             sodcmt3 "|"
/*071115*/   sodcmt4 "|"
/*071115*/   sodcmt5 "|"
/*071115*/   sodcmt6 "|"
/*071115*/   sodcmt7 "|"
/*071115*/   sodcmt8 "|"
             sod_qty_inv "|"
             sod_price "|"
/*080521**   sod_qty_inv * sod_price "|". */
/*080521*/   ext_price "|".
         if last-of(so_inv_nbr) then do:
/*080521*/  decimal_dollar_amt = ttl_amt.
            {gprun.i ""xxsodollar1.p""}
            put UNFORMATTED "TOTAL: " so_curr "|".
/*080521**  put UNFORMATTED decimal_dollar_amt format "->,>>>,>>9.99" "|".*/
/*080521*/  put UNFORMATTED decimal_dollar_amt format "->,>>>,>>>,>>9.99" "|".
            find first ex_mstr where ex_curr = so_curr no-lock no-error.
            if available ex_mstr then currdesc = ex_desc.
            else currdesc = "".
            trim(currdesc).
            trim(string_dollar_amt).
            stringtotal = "Total say " + currdesc + string_dollar_amt + 
                          " only".
            i = 78.
            stringtotal1 = "".
            stringtotal2 = "".
                         
            repeat:
               if (substring(stringtotal,i,1) = " " and 
                   substring(stringtotal,i,2) <> "  ") or
                  substring(stringtotal,i,1) = "-" or
                  i = 0 then leave.
               i = i - 1.
            end.
            stringtotal1 = substring(stringtotal,1,i).
            stringtotal2 = substring(stringtotal,i + 1,79).
            put stringtotal1 "|".
            put stringtotal2 "|".           
         end.
         else put "||||".
         if first-of(so_inv_nbr) then
            put socmt1 "|"
                socmt2 "|"
                socmt3 "|"
/*071115*/      socmt4 "|"
/*071115*/      socmt5 "|"
/*071115*/      socmt6 "|"                
                skip.
         else
            put "||||||" skip.
      end.
   end.
   {mfreset.i}
end.
