/* xxivrp002.p  ��Ʊ��ӡ֮DASCom�汾                                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/07/07   BY: Softspeed roger xiao   ECO:*xp001*    */ 
/* REVISION: 1.0      LAST MODIFIED: 2008/07/08   BY: Softspeed roger xiao   ECO:*xp002*    */ /*DASCOM�����ڱ�׼�ĵط�*/
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

define  variable inv              like so_inv_nbr label "��Ʊ��".
define  variable inv1             like so_inv_nbr label {t001.i}.
define  variable cust             like so_cust.
define  variable cust1            like so_cust.
define  variable bill             like so_bill.
define  variable bill1            like so_bill.
define  variable l_increment   like mfc_logical      no-undo. /*��Ʊ������,�Ƿ������޸�*/
define  variable l_cur_tax_amt like tx2d_cur_tax_amt no-undo.
define  variable shipfrom  like abs_shipfrom .  
define  variable shipnbr  like so_nbr .  
define  var v_maitou      as char format "x(28)" .
define  var v_qty_total   like tr_qty_loc .
define  var v_amt_total   like tr_qty_loc .
define  var v_total1      as char format "x(80)" .
define  var v_total2      as char format "x(80)" .
define  var v_curr_desc   as char format "x(24)" .
define  var v_hkloc       like loc_loc .   /*xp002*/
define  var v_jj          as integer    .   /*xp002*/

find icc_ctrl where icc_domain = global_domain no-lock no-error.
shipfrom = if avail icc_ctrl then icc_site else "" .

define temp-table temp1 
    field t1_inv_nbr   as char 
    field t1_type      like sod_type   
    field t1_sod_nbr   like sod_nbr
    field t1_sod_line  like sod_line
    field t1_seq       as integer 
    field t1_part      like sod_part 
    field t1_cust_part like sod_part label "�ͻ������"
    field t1_shinbr    as char label "����ָʾ��"
    field t1_qty       like sod_qty_ord 
    field t1_price     like sod_price
    field t1_amt       like sod_price 
    field t1_maitou    as char .

define temp-table temp2
    field t2_inv_nbr     as char 
    field t2_inv_date    as date 
    field t2_billto     as char
    field t2_addr1      as char
    field t2_addr2      as char
    field t2_addr3      as char
    field t2_abs_nbr    as char
    field t2_payment    as char 
    field t2_trade      as char 
    field t2_shipfrom   as char
    field t2_shipto     as char 
    field t2_boat       as char
    field t2_etd_date   as date
    field t2_eta_date   as date
    field t2_container  as char 
    field t2_desc       as char 
    field t2_curr       like so_curr 
    field t2_total_amt  like tr_qty_loc
    field t2_total_qty  like tr_qty_loc 
    field t2_total1     as char
    field t2_total2     as char 
    .

define temp-table temp3   /*xp002*/
    field t3_inv_nbr       like so_inv_nbr
    field t3_line          like sod_line 
    field t3_part          like sod_part
    field t3_desc          like pt_desc1
    field t3_qty           like tr_qty_loc
    .






define  frame a.

form
    SKIP(.2)
   shipfrom             colon 15 
   shipnbr              colon 15
   inv                  colon 15
   inv1                 label {t001.i} colon 49 skip
   cust                 colon 15
   cust1                label {t001.i} colon 49 skip
   bill                 colon 15
   bill1                label {t001.i} colon 49 skip(1)

   skip (2)   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .

    if inv1  = hi_char then inv1 = "".
    if cust1 = hi_char then cust1 = "".
    if bill1 = hi_char then bill1 = "".

    update shipfrom shipnbr inv inv1  cust  cust1 bill  bill1   with frame a.

    if inv1  = "" then inv1 = hi_char.
    if cust1 = "" then cust1 = hi_char.
    if bill1 = "" then bill1 = hi_char.

    find first si_mstr where si_domain = global_domain and si_site = shipfrom no-lock no-error .
    if not avail si_mstr then do:
        message "��Ч�����ص�,����������." view-as alert-box.
        next-prompt shipfrom with frame a.
        undo,retry .
    end. /*xp001*/ 

    if shipnbr = "" 
       or 
       not (can-find(first abs_mstr where abs_domain = global_domain and abs_shipfrom = shipfrom and abs_id = "s" + shipnbr ))then do: 
        message "��Ч���˵���,����������." view-as alert-box .
        next-prompt shipnbr with frame a.
        undo,retry .
    end . /*xp001*/ 

    find first abs_mstr 
                where abs_mstr.abs_domain = global_domain 
                and abs_mstr.abs_shipfrom = shipfrom 
                and abs_mstr.abs_id       = "s" + shipnbr 
                and substring(abs_mstr.abs_status,2,1) = "y"
    no-lock no-error.
    if not avail abs_mstr then do:
        message "���˵�δȷ��,����������." view-as alert-box .
        next-prompt shipnbr with frame a.
        undo,retry .
    end. /*xp001*/ 



    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    
/*
PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp001" SKIP.
PUT UNFORMATTED "#def :end" SKIP.
*/

for each temp1 : delete temp1 . end.
for each temp2 : delete temp2 . end.


for each so_mstr no-lock
        where so_mstr.so_domain = global_domain 
        and   (so_inv_nbr >= inv  and    so_inv_nbr <= inv1)
        and   (so_cust >= cust    and    so_cust <= cust1)
        and   (so_bill >= bill    and    so_bill <= bill1)
        and   (so_invoiced = yes)
        and   (so_to_inv = no)
        and /*xp001*/ (can-find(first abs_mstr 
                                    where abs_mstr.abs_domain = global_domain 
                                    and abs_mstr.abs_shipfrom = shipfrom 
                                    and abs_mstr.abs_id       = "s" + shipnbr 
                                    and substring(abs_mstr.abs_status,2,1) = "y")
                        and can-find(first abs_mstr 
                                    where abs_mstr.abs_domain = global_domain 
                                    and abs_mstr.abs_par_id   = "s" + shipnbr 
                                    and abs_mstr.abs_shipfrom = shipfrom
                                    and abs_mstr.abs_order    = so_nbr )
                        )
    use-index so_invoice 
    break by so_inv_nbr by so_nbr :

    if first-of(so_inv_nbr) then do:            
        v_qty_total = 0 .
        v_amt_total = 0 .
        v_total1    = "" .
        v_total2    = "" .

        find first temp2 where t2_inv_nbr = so_inv_nbr no-error .
        if not avail temp2 then do:
            
            find first abs_mstr 
                        where abs_mstr.abs_domain = global_domain 
                        and abs_mstr.abs_shipfrom = shipfrom 
                        and abs_mstr.abs_id       = "s" + shipnbr 
                        and substring(abs_mstr.abs_status,2,1) = "y"
            no-lock no-error.
            if not avail abs_mstr then next .

            create temp2.
            assign 
            t2_inv_nbr     = so_inv_nbr
            t2_inv_date    = today 
            t2_abs_nbr     = shipnbr
            t2_trade       = abs__chr03
            t2_shipfrom    = abs__chr04
            t2_shipto      = abs__chr05
            t2_boat        = abs__chr09
            t2_etd_date    = if abs__dec03 <> 0 then date(integer(abs__dec03)) else ? 
            t2_eta_date    = if abs__dec04 <> 0 then date(integer(abs__dec04)) else ?
            t2_container   = abs__chr07
            t2_desc        = abs__chr08
            t2_curr        = caps(so_curr)
            v_hkloc       = abs__chr06 /*xp002*/
            .
            find first ct_mstr where ct_domain = global_domain and ct_code = so_cr_terms no-lock no-error .
            t2_payment     =  if avail ct_mstr then ct_desc else so_cr_terms .
            find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = so_bill no-lock no-error.
            t2_billto      = if avail ad_mstr then ad_name  else  so_bill .
            find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = so_ship no-lock no-error.
            t2_addr1       = if avail ad_mstr then ad_name  else so_ship .
            t2_addr2       = if avail ad_mstr then ad_line1 else so_ship .
            t2_addr3       = if avail ad_mstr then ad_line2 else so_ship .

            /*t2_total_amt   
            t2_total_qty 
            t2_total1    
            t2_total2  */  

        end.        
    end. /*if first-of(so_inv_nbr)*/


    for each sod_det no-lock 
        where sod_det.sod_domain = global_domain 
        and  sod_nbr = so_nbr
        and     (can-find(first abs_mstr 
                            where abs_mstr.abs_domain = global_domain 
                            and abs_mstr.abs_shipfrom = shipfrom 
                            and abs_mstr.abs_id = "s" + shipnbr 
                            and substring(abs_mstr.abs_status,2,1) = "y")
                   and (can-find(first abs_mstr 
                            where abs_mstr.abs_domain = global_domain 
                            and abs_mstr.abs_par_id   =  "s" + shipnbr 
                            and abs_mstr.abs_shipfrom = shipfrom
                            and abs_mstr.abs_order    = sod_nbr 
                            and integer(abs_mstr.abs_line)    = sod_line )
                        or 
                          (sod_type = "M" and sod_serial = shipnbr ) 
                        )
                  )
    break by sod_nbr by sod_line :
        v_qty_total = v_qty_total + ( if sod_type = "" then sod_qty_inv else 0 ).
        v_amt_total = v_amt_total + (sod_qty_inv * sod_price ) .

        if sod_type = "M" then do:
            find first temp1 where t1_inv_nbr = so_inv_nbr and t1_sod_nbr = "ZZZ" and t1_sod_line = 999 and t1_part = "TOOLING CHARGE  OR  DEBIT NOTE" no-error.
            if not avail temp1 then do:
                create temp1 .
                assign 
                    t1_inv_nbr   = so_inv_nbr
                    t1_type      = sod_type
                    t1_sod_nbr   = "ZZZ"
                    t1_sod_line  = 999
                    t1_seq       = 0
                    t1_part      = "TOOLING CHARGE  OR  DEBIT NOTE"  
                    .
            end.

            find first temp1 where  t1_inv_nbr = so_inv_nbr and t1_sod_nbr = "ZZZ" and t1_sod_line = 999 and t1_part = sod_part no-error.
            if not avail temp1 then do:
                create temp1 .
                assign 
                    t1_inv_nbr   = so_inv_nbr
                    t1_type      = sod_type
                    t1_sod_nbr   = "ZZZ"
                    t1_sod_line  = 999
                    t1_seq       = 1
                    t1_part      = caps(sod_part) 
                    t1_qty       = sod_qty_inv
                    t1_price     = sod_price
                    t1_amt       = sod_qty_inv * sod_price
                    .
            end.
        end.  /*sod_type = "M"*/
        else do: /*sod_type = ""*/
            find first temp1 where t1_inv_nbr = so_inv_nbr and t1_sod_nbr = sod_nbr and t1_sod_line = sod_line and t1_part = sod_part no-error.
            if not avail temp1 then do:
                find first abs_mstr 
                        where abs_mstr.abs_domain = global_domain 
                        and abs_mstr.abs_par_id   =  "s" + shipnbr 
                        and abs_mstr.abs_shipfrom = shipfrom
                        and abs_mstr.abs_order    = sod_nbr 
                        and integer(abs_mstr.abs_line)    = sod_line
                no-lock no-error .
                
                v_maitou = if avail abs_mstr then abs_mstr.abs__chr03 else "" .
                create temp1.
                assign 
                    t1_inv_nbr   = so_inv_nbr
                    t1_type      = sod_type
                    t1_sod_nbr   = sod_nbr
                    t1_sod_line  = sod_line
                    t1_seq       = 1
                    t1_part      = caps(sod_part)
                    t1_shinbr    = if avail abs_mstr then abs_mstr.abs__chr02 else ""
                    t1_qty       = sod_qty_inv
                    t1_price     = sod_price
                    t1_amt       = sod_qty_inv * sod_price
                    t1_maitou    = v_maitou
                    t1_cust_part = "" 
                    .
                
                v_maitou = if avail abs_mstr then abs_mstr.abs__chr04 else "" .
                find first cp_mstr where cp_domain = global_domain and cp_cust = so_cust and cp_part = sod_part no-lock no-error .
                create temp1.
                assign 
                    t1_inv_nbr   = so_inv_nbr
                    t1_type      = sod_type
                    t1_sod_nbr   = sod_nbr
                    t1_sod_line  = sod_line
                    t1_seq       = 2
                    t1_part      = if avail cp_mstr then cp_cust_part else "" 
                    t1_shinbr    = ""
                    t1_qty       = 0
                    t1_price     = 0
                    t1_amt       = 0
                    t1_maitou    = v_maitou
                    t1_cust_part = if avail cp_mstr then cp_cust_part else "" 
                    .

                v_maitou = if avail abs_mstr then abs_mstr.abs__chr05 else "" .
                if avail abs_mstr and v_maitou <> ""  then do:
                    create temp1.
                    assign 
                        t1_inv_nbr   = so_inv_nbr
                        t1_type      = sod_type
                        t1_sod_nbr   = sod_nbr
                        t1_sod_line  = sod_line
                        t1_part      = v_hkloc /*xp002*/
                        t1_seq       = 3
                        t1_maitou    = v_maitou 
                        .            
                end.

                v_maitou = if avail abs_mstr then abs_mstr.abs__chr06 else "" .
                if avail abs_mstr and v_maitou <> ""  then do:
                    create temp1.
                    assign 
                        t1_inv_nbr   = so_inv_nbr
                        t1_type      = sod_type
                        t1_sod_nbr   = sod_nbr
                        t1_sod_line  = sod_line
                        t1_seq       = 4
                        t1_maitou    = v_maitou 
                        .            
                end.

                v_maitou = if avail abs_mstr then abs_mstr.abs__chr07 else "" .
                if avail abs_mstr and v_maitou <> ""  then do:
                    create temp1.
                    assign 
                        t1_inv_nbr   = so_inv_nbr
                        t1_type      = sod_type
                        t1_sod_nbr   = sod_nbr
                        t1_sod_line  = sod_line
                        t1_seq       = 5
                        t1_maitou    = v_maitou 
                        .            
                end.
            end. /*if not avai temp1*/
        end. /*sod_type = ""*/
    end.  /*for each sod_det */
    
    if last-of(so_inv_nbr) then do:
        find first temp2 where t2_inv_nbr = so_inv_nbr no-error .
        if avail temp2 then do:
            {gprun.i ""xxtotal.p"" "(input v_amt_total,output v_total1)"}
            {gprun.i ""xxtotal.p"" "(input v_qty_total,output v_total2)"}

            find first cu_mstr where cu_curr = t2_curr no-lock no-error .
            v_curr_desc = if avail cu_mstr then cu_desc else "" .

            v_total1 = v_curr_desc + v_total1 + " ONLY***" .
            v_total2 = v_total2    + "(" + string(v_qty_total) + ") PACKAGES ONLY***" .
            assign 
                t2_total_amt   = v_amt_total
                t2_total_qty   = v_qty_total
                t2_total1      = v_total1
                t2_total2      = v_total2 
                .

            
        end.
    end. /*if last-of(so_inv_nbr) */

end. /*for each so_mstr */

v_jj = 0 .  /*xp002*/

/**/
PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxivrp002" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

for each temp2,
    each temp1 where t1_inv_nbr = t2_inv_nbr 
    break by t1_inv_nbr by t1_type by t1_sod_nbr by t1_sod_line by t1_seq :
v_jj = v_jj + 1 .   /*xp002*/
    put unformatted  t2_billto        ";" .
    put unformatted  t2_addr1         ";" .
    put unformatted  t2_addr2         ";" .
    put unformatted  t2_addr3         ";" .
    put unformatted  t2_abs_nbr         ";" .
    put unformatted  t2_payment         ";" .
    put unformatted  t2_trade         ";" .
    put unformatted  t2_shipfrom         ";" .
    put unformatted  t2_shipto         ";" .
    put unformatted  t2_inv_nbr         ";" .
    put unformatted  t2_inv_date          ";" .
    put unformatted  t2_boat          ";" .
    put unformatted  t2_etd_date          ";" .
    put unformatted  t2_eta_date          ";" .
    put unformatted  t2_container         ";" .
    put unformatted  t2_desc          ";" .
    put unformatted  t1_maitou         ";" .
    put unformatted  t1_part         ";" .
    put unformatted  t1_shinbr         ";" .
    put unformatted  t1_qty          ";" .
    put unformatted  t1_price          ";" .
    put unformatted  t1_amt         ";" .
    put unformatted  t2_curr          ";" .
    put unformatted  t2_total_qty         ";" .
    put unformatted  t2_total_amt         ";" .
    put unformatted  t2_total1         ";" .
    put unformatted  t2_total2         .
    put skip .

end . /*each temp2,each temp1*/


/*xp002*------------------------*/
put skip(50 - 1 - v_jj) . 
v_jj = 1 .
v_qty_total = 0 .

for each temp3 : delete temp3 . end.

for each temp2,
    each temp1 where t1_inv_nbr = t2_inv_nbr 
    break by t1_inv_nbr by t1_type by t1_sod_nbr by t1_sod_line by t1_seq :

    if last-of(t1_sod_nbr) then do:
        for each wo_mstr where wo_domain  = global_domain and wo_so_job = t1_sod_nbr no-lock :
            for each wod_det where wod_domain = global_domain and wod_lot = wo_lot no-lock :
                if wod_qty_iss <> 0 then do:
                    find first temp3 where t3_inv_nbr = t2_inv_nbr and t3_part = wod_part no-lock no-error .
                    if not avail temp3 then do:
                        find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error .
                        create temp3 .
                        assign 
                            t3_inv_nbr = t2_inv_nbr
                            t3_line    = v_jj 
                            t3_part    = wod_part
                            t3_desc    = if avail pt_mstr then pt_Desc1 else "" 
                            t3_qty     = wod_qty_iss 
                            v_jj       = v_jj + 1 
                            .
                    end.
                    else do:
                            t3_qty = t3_qty + wod_qty_iss .
                    end.
                    v_qty_total = v_qty_total + wod_qty_iss .
                end. /*if wod_qty_iss <> 0*/
            end. /*for each wod*/
        end. /*for each wo_mstr*/
    end. /*if last-of(t1_sod_nbr)*/
end . /*each temp2,each temp1*/

for each temp3 break by t3_inv_nbr by t3_line :
    put unformatted  "InvoiceNo. " + t3_inv_nbr + "+ AttachedSheet"     ";"   .
    put unformatted  t3_line     ";"   .
    put unformatted  t3_part     ";"   .
    put unformatted  t3_desc     ";"   .
    put unformatted  t3_qty      ";"   .
    put unformatted  v_qty_total     ";"   .
    put skip .
end. /*for each temp3*/

/*------------------------*xp002*/

for each temp1 : delete temp1 . end.
for each temp2 : delete temp2 . end.
for each temp3 : delete temp3 . end.

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



