/* xxsoivrp001a.p  include file of xxsoivrp001.p                                                      */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 create By: Roger Xiao */


{mfdeclre.i}

define input parameter vv_inv_nbr like ih_inv_nbr .
define shared var v_sign           as logical format "Yes/No" .


define var currdesc as character.
define var i as integer.
define var stringtotal as character format "x(160)".
define var stringtotal1 as character format "x(79)".
define var stringtotal2 as character format "x(79)".
define var ttl_amt as decimal decimals 2.

/*var for xxsoivrp001amt.p*/
define new shared variable socurr like so_curr.
define new shared variable decimal_dollar_amt as decimal.
define new shared variable string_dollar_amt as character format "x(100)".

/*var for xxsoivrp001date.i */
define variable tmp_date as date.
define variable dd as character.
define variable mm as integer.
define variable yy as character.
define variable str_mm as character.


define temp-table temp1 
    field t1_customername        like ad_name
    field t1_address1            like ad_line1
    field t1_address2            like ad_line2
    field t1_address3            like ad_line3
    field t1_city                like ad_city
    field t1_state               like ad_state 
    field t1_zip                 like ad_zip
    field t1_country             like ad_country
    field t1_attention           like ad_attn
    field t1_shipvia             like ih_shipvia
    field t1_fromship            like ih__chr04
    field t1_toship              like ih__chr05
    field t1_shipdate            like ih_ship_date
    field t1_shiptoname          like ad_name
    field t1_shiptoaddress1      like ad_line1
    field t1_shiptoaddress2      like ad_line2
    field t1_inv_date            like ih_inv_date
    field t1_inv_nbr             like ih_inv_nbr
    field t1_fob                 like ih_fob
    field t1_lcno                like ih__chr01
    field t1_issuingbank1        like ih__chr02
    field t1_issuingbank2        like ih__chr03
    field t1_paymentterms        like ct_desc
    field t1_curr                like ih_curr
    field t1_po                  like ih_po
    field t1_bol                 like ih_bol
    field t1_line                like idh_line
    field t1_part                like idh_part
    field t1_desc                like pt_desc1
    field t1_draw                like pt_draw
    field t1_cmmt1               like cmt_cmmt[1]
    field t1_cmmt2               like cmt_cmmt[1]
    field t1_cmmt3               like cmt_cmmt[1]
    field t1_qty                 like idh_qty_inv
    field t1_price               like idh_price
    field t1_linetotal           like idh_price
    field t1_invoicetotal2       like ad_name
    field t1_companyname         like ad_name
    field t1_customerpart        like pt_part
    field t1_invoicetotal        like idh_price
    field t1_invcmmt1            like cmt_cmmt[1]
    field t1_invcmmt2            like cmt_cmmt[1]
    field t1_invcmmt3            like cmt_cmmt[1]
    field t1_invtype             like pt_part
    field t1_usr                 like pt_part
    field t1_sgn                 like pt_part
    field t1_nbr                 like ih_nbr 
        index temp1  is unique primary 
        t1_inv_nbr asc t1_nbr asc  t1_line asc 
    .





for each temp1 : delete temp1 . end .

for each ih_hist  where ih_inv_nbr = vv_inv_nbr  no-lock,
    each idh_hist where idh_inv_nbr = ih_inv_nbr and idh_nbr = ih_nbr and idh_qty_inv <> 0 no-lock,
    each pt_mstr  where pt_part = idh_part no-lock
    break by idh_inv_nbr by idh_nbr by idh_line :

    find first temp1 
        where t1_inv_nbr = idh_inv_nbr 
        and t1_nbr  = idh_nbr 
        and t1_line = idh_line 
    no-error .
    if not avail temp1 then do:
        create temp1 .
        assign 
            t1_inv_nbr             = idh_inv_nbr  
            t1_line                = idh_line    
            t1_nbr                 = idh_nbr     
            t1_qty                 = idh_qty_inv 
            t1_price               = idh_price   
            t1_part                = idh_part    
            t1_curr                = ih_curr     
            t1_po                  = "PO : " + ih_po       
            t1_fob                 = ih_fob      
            t1_bol                 = ih_bol      
            t1_shipvia             = ih_shipvia 
            t1_inv_date            = ih_inv_date
            t1_shipdate            = ih_ship_date
            t1_lcno                = ih__chr01   
            t1_issuingbank1        = ih__chr02   
            t1_issuingbank2        = ih__chr03   
            t1_fromship            = ih__chr04   
            t1_toship              = ih__chr05   
            t1_desc                = if pt_desc1 <> "" then pt_desc1 else pt_desc2   
            t1_draw                = pt_draw  
            t1_usr                 = global_userid     
            t1_sgn                 = if v_sign then global_userid else ""  
            t1_invtype             = "" 
            t1_companyname         = if substring(ih_cust,1,2) = "11"      then "Karrie Industrial Co., Ltd." 
                                     else if substring(ih_cust,1,2) = "22" then "Karrie Technologies Co., Ltd." 
                                     else "" 
            t1_linetotal           = idh_price * idh_qty_inv   
            t1_invoicetotal2       = ""  
            t1_invoicetotal        = 0           
            .


        find first cp_mstr 
            where cp_part = idh_part 
            and (cp_cust = "" or cp_cust = ih_cust)
        no-lock no-error.   
        if available cp_mstr then t1_customerpart = cp_cust_part. 

        find first cmt_det where cmt_indx = idh_cmtindx no-lock no-error.
        if available cmt_det then
        assign 
            t1_cmmt1               = cmt_cmmt[1] 
            t1_cmmt2               = cmt_cmmt[2] 
            t1_cmmt3               = cmt_cmmt[3]
            .
        find first cmt_det where cmt_indx = ih_cmtindx no-lock no-error.
        if available cmt_det then
        assign 
            t1_invcmmt1            = cmt_cmmt[1] 
            t1_invcmmt2            = cmt_cmmt[1] 
            t1_invcmmt3            = cmt_cmmt[1] 
            .



        find first ct_mstr where ct_code = ih_cr_terms no-lock no-error.
        if avail ct_mstr then t1_paymentterms  = ct_desc .


        find first ad_mstr where ad_addr = ih_bill no-lock no-error.
        if avail ad_mstr then 
            assign 
                t1_customername        = ad_name     
                t1_address1            = ad_line1    
                t1_address2            = ad_line2    
                t1_address3            = ad_line3    
                t1_city                = ad_city     
                t1_state               = ad_state    
                t1_zip                 = ad_zip      
                t1_country             = ad_country  
                t1_attention           = ad_attn    
                t1_shiptoname          = ad_name  /*优先級2*/   
                t1_shiptoaddress1      = ad_line1    
                t1_shiptoaddress2      = ad_line2                
                .
        find first ad_mstr where ad_addr = ih_ship and ad_type = "ship-to" no-lock no-error.
        if available ad_mstr then 
            assign 
                t1_shiptoname          = ad_name   /*优先級1*/      
                t1_shiptoaddress1      = ad_line1    
                t1_shiptoaddress2      = ad_line2
                .
    end. /*if not avail temp1*/

    if first-of(idh_inv_nbr) then do:
        socurr = ih_curr.
        decimal_dollar_amt = 0.
        ttl_amt   = 0.
    end. /*if first-of(idh_inv_nbr)*/
    
    ttl_amt = ttl_amt + idh_price * idh_qty_inv.   	

    if last-of(idh_inv_nbr) then do:
            decimal_dollar_amt = ttl_amt.
            {gprun.i ""xxivamtus.p""}            
            find first ex_mstr where ex_curr = ih_curr no-lock no-error.
            currdesc = if available ex_mstr then ex_desc else "".
            trim(currdesc).
            trim(string_dollar_amt).
            stringtotal = "Total say " + currdesc + string_dollar_amt + " only".
                /*新bi格式可自動換行,這里不需調整*
                i = 78.
                stringtotal1 = "".
                stringtotal2 = "".

                repeat:
                    if (substring(stringtotal,i,1) = " "    and 
                        substring(stringtotal,i,2) <> "  ") or
                        substring(stringtotal,i,1) = "-"    or
                        i = 0 
                    then leave.
                    i = i - 1.
                end.

                stringtotal1 = substring(stringtotal,1,i).
                stringtotal2 = substring(stringtotal,i + 1,79).  
                */
            for each temp1 where t1_inv_nbr = ih_inv_nbr break by t1_inv_nbr by t1_nbr by t1_line :
                if not first-of(t1_nbr) then 
                assign  t1_po = "" t1_bol = "" .

                assign t1_invoicetotal  = decimal_dollar_amt
                       t1_invoicetotal2 = stringtotal
                       .
            end.
    end. /*if last-of(idh_inv_nbr)*/
end. /*for each ih_hist*/




{xxmfselbpr.i "printer" 100  }  /*{xxmfselbpr.i "printer" 100 } 与{mfreset.i}一定要配對使用*/ 
    put UNFORMATTED "#def REPORTPATH=$/KI/xxsoivrp001" SKIP.
    put UNFORMATTED "#def EXPORTNAME=" + vv_inv_nbr + ".pdf" skip . 
    put UNFORMATTED "#def :end" SKIP.
    put UNFORMATTED "Customer Name|Address 1|Address 2|Address 3|City|State|Zip|Country|Attention|Ship Via|From Ship|To Ship|Ship Date|Shipto Name|Shipto Address1|shipto Address2|Invoice Date|Invoice No.|FOB|LC No.|Issuing Bank1|Issuing Bank2|Payment Terms|Currency|Purchase Nbr|BOL|Line|Part|Description|Drawing|Line Comment 1|Line Comment 2|Line Comment 3|Quantity|Price|Line Total|Invoice Total 2|Company Name|Customer Part|Invoice Total|Invoive Comment 1|Invoice Comment 2|Invoice Comment 3|Invoice Type|usr|sgn" skip .
    


for each temp1 break by t1_inv_nbr by t1_nbr by t1_line :
    put UNFORMATTED 
        t1_customername      "|"
        t1_address1          "|"
        t1_address2          "|"
        t1_address3          "|"
        t1_city              "|"
        t1_state             "|"
        t1_zip               "|"
        t1_country           "|"
        t1_attention         "|"
        t1_shipvia           "|"
        t1_fromship          "|"
        t1_toship            "|"
        string(year(t1_shipdate)) + "-" + string(month(t1_shipdate)) + "-" + string(day(t1_shipdate))          "|"
        t1_shiptoname        "|"
        t1_shiptoaddress1    "|"
        t1_shiptoaddress2    "|"
        string(year(t1_inv_date)) + "-" + string(month(t1_inv_date)) + "-" + string(day(t1_inv_date))          "|"
        t1_inv_nbr           "|"
        t1_fob               "|"
        t1_lcno              "|"
        t1_issuingbank1      "|"
        t1_issuingbank2      "|"
        t1_paymentterms      "|"
        t1_curr              "|"
        t1_po                "|"
        t1_bol               "|"
        t1_line              "|"
        t1_part              "|"
        t1_desc              "|"
        t1_draw              "|"
        t1_cmmt1             "|"
        t1_cmmt2             "|"
        t1_cmmt3             "|"
        t1_qty               "|"
        t1_price             "|"
        t1_linetotal         "|"
        t1_invoicetotal2     "|"
        t1_companyname       "|"
        t1_customerpart      "|"
        t1_invoicetotal      "|"
        t1_invcmmt1          "|"
        t1_invcmmt2          "|"
        t1_invcmmt3          "|"
        t1_invtype           "|"
        t1_usr               "|"
        t1_sgn               
                             
        skip .                



end. /*for each temp1*/

{mfreset.i} /*{xxmfselbpr.i "printer" 100 } 与{mfreset.i}一定要配對使用*/

/*------------------------------------end---------------------------------------------------------------*/
    /* 
    {xxmfselbpr.i "printer" 100  }
    put UNFORMATTED "#def REPORTPATH=$/KI/xxsoivrp001" SKIP.
    put UNFORMATTED "#def EXPORTNAME=" + vv_inv_nbr + ".pdf" skip . 
    put UNFORMATTED "#def :end" SKIP.
    define var v_aaa as char format "x(1000)" .
    input from value("/new/xxsoivrp001.txt") .
        repeat :
            v_aaa = "" .
            import unformatted v_aaa .
            put unformatted v_aaa skip .        
        end.
    input close .
    {mfreset.i}
    */
    


