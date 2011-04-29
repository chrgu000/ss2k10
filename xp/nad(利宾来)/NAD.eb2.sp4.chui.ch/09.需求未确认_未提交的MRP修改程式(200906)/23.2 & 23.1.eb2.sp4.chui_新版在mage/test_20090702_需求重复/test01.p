
define var site1 like loc_site.
define var site2 like loc_site.
site1 = "" .
site2 = "zzzzzz" .


define  buffer absmstr for abs_mstr.
define new shared  temp-table pln_det no-undo  /*原始需求 from schd_det , by date by order by line */
   field  pln_site      like pt_site
   field  pln_part      like pt_part
   field  pln_nbr       like so_nbr
   field  pln_line      like sod_line
   field  pln_date      like pod_due_date
   field  pln_due_date  like pod_due_date
   field  pln_rel_date  like pod_due_date
   field  pln_qty_ord   like seq_qty_req 
   field  pln_cum_req   like seq_qty_req 
   field  pln_cum_rcvd  like pod_qty_ord
   field  pln_um        like pod_um
   index  plan1 is primary  unique   
     pln_site ascending  
     pln_part ascending  
     pln_date ascending 
     pln_nbr  ascending  
     pln_line ascending .

 
define temp-table temp1 /*需求 : 按Due_date日期汇总的需求*/
   field  t1_site      like pod_site
   field  t1_part      like  pt_part
   field  t1_date      like pod_due_date
   field  t1_qty_ord   like seq_qty_req 
   field  t1_qty_shp   like seq_qty_req 
   index  temp1 is primary  unique   
     t1_site ascending  
     t1_part ascending  
     t1_date ascending 
     .

 
define temp-table temp2 /*供给: 未删除掉的工单 */
   field  t2_site      like wo_site
   field  t2_nbr       like wo_nbr 
   field  t2_lot       like wo_lot
   field  t2_part      like wo_part
   field  t2_date      like wo_due_date
   field  t2_qty_ord   like wo_qty_ord 
   index  temp2 is primary  unique   
     t2_site ascending  
     t2_lot  ascending
     t2_part ascending  
     .

define temp-table temp3  /*供给: 本次需产生的新工单*/
   field  t3_site      like wo_site
   field  t3_part      like wo_part
   field  t3_date      like wo_due_date
   field  t3_qty_ord   like wo_qty_ord 
   index  temp2 is primary  unique   
     t3_site ascending  
     t3_part ascending  
     t3_date ascending 
     .

for each temp1 :   delete temp1 .  end.
for each temp2 :   delete temp2 .  end. 
for each temp3 :   delete temp3 .  end. 
for each pln_det:  delete pln_det. end.

/*计算上个星期六的日期*/
def var last-sta as date .
def var ix  as integer.
def var abv_qty like abs_qty.
def  var shipid like abs_id .

do ix = 1 to 7 :
 if weekday(today - ix) = 7 then do:
     last-sta = today - ix.
     leave.
     end.
    else last-sta = today.
    end.

/*计算上个星期六的日期*/
 for each pln_det : delete pln_det . end. 

/*查找原始需求*/
 if  length(string(month(today - 10 ))) = 2 then 
             shipid = "s" + substring(string(year(today - 10)),3,2) + string(month(today - 10 )).
	     else shipid = "s" + substring(string(year(today - 10)),3,2) + "0" +  string(month(today - 10 )).

      

for each scx_ref
            fields(scx_line scx_order scx_part scx_po scx_shipfrom scx_shipto 
            scx_type scx_custref scx_modelyr  )
            where scx_type      = 1  
            and scx_part = "NP436-01-2C03"
            no-lock,
    each pt_mstr  
            fields(pt_part pt_run_seq2) 
            where pt_part = scx_part 
            and pt_run_seq2 = "sp-mrp"  /*限指定类型*/
            no-lock,
    each sod_det
            fields( sod_cmtindx  sod_contr_id sod_cum_qty sod_curr_rlse_id
                  sod_custpart sod_dock  sod_line    sod_nbr sod_site sod_consignment
                  sod_ord_mult sod_part  sod_pkg_code sod_um sod_start_eff[1] sod_end_eff[1])
            where sod_nbr   = scx_order
            and   sod_line  = scx_line
            and   sod_site  >= site1 and sod_site <= site2
            no-lock,
    each so_mstr
            fields( so_cmtindx so_cum_acct so_cust so_nbr so_ship_cmplt)
            where so_nbr    = sod_nbr
            no-lock,
    each sch_mstr
            fields( sch_cmtindx sch_line sch_nbr sch_pcr_qty sch_rlse_id sch_type)
            where sch_type   = scx_type
            and sch_nbr      = sod_nbr
            and sch_line     = sod_line
            and sch_rlse_id  = sod_curr_rlse_id[1]
            no-lock,
    each schd_det
            fields( schd_cmtindx   schd_cum_qty  schd_date
            schd_discr_qty schd_line     schd_nbr  schd_reference
            schd_rlse_id   schd_ship_qty schd_time schd_type)
            where schd_type    = sch_type
            and schd_nbr       = sch_nbr 
            and schd_line      = sch_line
            and schd_rlse_id   = sch_rlse_id
            and (schd_discr_qty >= schd_ship_qty  and not schd__log01 ) /*客户日程未出货完成,且未审核*/
            no-lock
    break
        by scx_shipfrom
        by scx_shipto
        by scx_order
        by scx_line 
        by schd_date
        by schd_time
        by schd_rlse_id
        by schd_reference /*
        by sod_part
        by sod_contr_id
        by scx_custref
        by scx_modelyr */
        :
      if first-of(scx_line) then do:
         abv_qty = 0.

         for each abs_mstr no-lock where abs_shipfrom = scx_shipfrom and abs_shipto = scx_shipto 
	     and abs_id >= shipid
	     and abs_arr_date > last-sta and substring(abs_status,2,1) = "y"  use-index abs_shipto,
	     each absmstr no-lock where absmstr.abs_shipfrom = abs_mstr.abs_shipfrom and
	     absmstr.abs_par_id = abs_mstr.abs_id and absmstr.abs_item = sod_part use-index abs_par_id:
	     abv_qty = abv_qty + absmstr.abs_qty.
         end.
       end.
       
       if schd_discr_qty > abv_qty then do: 
        find first pln_det 
             where pln_site = sod_site 
             and pln_nbr    = sod_nbr 
             and pln_line   = sod_line 
             and pln_part   = sod_part 
             and pln_date   = schd_date 
        no-error.
        if not available pln_det then do:
            create pln_det .
            assign pln_site   = sod_site  
                   pln_nbr    = sod_nbr
                   pln_line   = sod_line
                   pln_part   = sod_part
                   pln_date   = schd_date
                   pln_um     = sod_um
                   pln_cum_rcvd = sod_cum_qty[1]  /*这个什么时候用???*/
                   .
        end.

        assign  pln_qty_ord  = pln_qty_ord  + schd_discr_qty - schd_ship_qty - abv_qty.

        if pln_cum_req < schd_cum_qty then  assign pln_cum_req = schd_cum_qty.   /*这个什么时候用???*/
	abv_qty = 0.
       end. /*if schd_discr_qty > abv_qty then do: */
       else do:
       abv_qty = abv_qty -  schd_discr_qty .
       end.
end. /* FOR EACH scx_ref */

output to "roger20090702-001.txt" .
for each pln_det  with frame x0 width 300:
    disp  
    pln_site 
    pln_nbr  
    pln_line 
    pln_part 
    pln_date 
    pln_um   
    pln_qty_ord
    pln_cum_req
    pln_cum_rcvd 
    with frame x0 .
end.
output close.

/*查找原始需求*

        for each pln_det : delete pln_det . end. 
         

        for each scx_ref
                    fields(scx_line scx_order scx_part scx_po scx_shipfrom scx_shipto 
                    scx_type scx_custref scx_modelyr  )
                    where scx_type      = 1  
                    and scx_part = "NP436-01-2C03"
                    no-lock,
            each pt_mstr  
                    fields(pt_part pt_run_seq2) 
                    where pt_part = scx_part 
                    and pt_run_seq2 = "sp-mrp" 
                    no-lock,
            each sod_det
                    fields( sod_cmtindx  sod_contr_id sod_cum_qty sod_curr_rlse_id
                          sod_custpart sod_dock  sod_line    sod_nbr sod_site sod_consignment
                          sod_ord_mult sod_part  sod_pkg_code sod_um sod_start_eff[1] sod_end_eff[1])
                    where sod_nbr   = scx_order
                    and   sod_line  = scx_line
                    and   sod_site  >= site1 and sod_site <= site2
                    no-lock,
            each so_mstr
                    fields( so_cmtindx so_cum_acct so_cust so_nbr so_ship_cmplt)
                    where so_nbr    = sod_nbr
                    no-lock,
            each sch_mstr
                    fields( sch_cmtindx sch_line sch_nbr sch_pcr_qty sch_rlse_id sch_type)
                    where sch_type   = scx_type
                    and sch_nbr      = sod_nbr
                    and sch_line     = sod_line
                    and sch_rlse_id  = sod_curr_rlse_id[1]
                    no-lock,
            each schd_det
                    fields( schd_cmtindx   schd_cum_qty  schd_date
                    schd_discr_qty schd_line     schd_nbr  schd_reference
                    schd_rlse_id   schd_ship_qty schd_time schd_type)
                    where schd_type    = sch_type
                    and schd_nbr       = sch_nbr 
                    and schd_line      = sch_line
                    and schd_rlse_id   = sch_rlse_id
                    and (schd_discr_qty >= schd_ship_qty  and not schd__log01 ) 
                    no-lock
            break
                by scx_shipfrom
                by scx_shipto
                by scx_order
                by scx_line 
                by schd_date
                by schd_time
                by schd_rlse_id
                by schd_reference 
                :

                find first pln_det 
                     where pln_site = sod_site 
                     and pln_nbr    = sod_nbr 
                     and pln_line   = sod_line 
                     and pln_part   = sod_part 
                     and pln_date   = schd_date 
                no-error.
                if not available pln_det then do:
                    create pln_det .
                    assign pln_site   = sod_site  
                           pln_nbr    = sod_nbr
                           pln_line   = sod_line
                           pln_part   = sod_part
                           pln_date   = schd_date
                           pln_um     = sod_um
                           pln_cum_rcvd = sod_cum_qty[1] 
                           .
                end.

                assign  pln_qty_ord  = pln_qty_ord  + schd_discr_qty - schd_ship_qty.
                if pln_cum_req < schd_cum_qty then  assign pln_cum_req = schd_cum_qty.  
          
        end.




        output to "roger20090702-001.txt" append .
        put skip(5) "--------------------------------------------------------------------------------------" skip .
        for each pln_det with frame x1 width 300:
            disp  
            pln_site 
            pln_nbr  
            pln_line 
            pln_part 
            pln_date 
            pln_um   
            pln_qty_ord
            pln_cum_req
            pln_cum_rcvd 
            with frame x1 .
        end.
        output close.

*/



output to "roger20090702-001.txt" append .
put skip(5) "--------------------------------------------------------------------------------------" skip .
for each ld_det where ld_part = "NP436-01-2C03" no-lock with frame x3 width 300:
disp ld_part ld_site ld_loc ld_lot ld_ref ld_qty_oh with frame x3.
end.


put skip(5) "--------------------------------------------------------------------------------------" skip .
for each pln_det ,
    each wo_mstr 
    where wo_site = pln_site 
    and wo_part = pln_part 
    and index("XC",wo_status) = 0 
    and wo_qty_ord > wo_qty_comp 
    no-lock  with frame x2 width 300:

disp wo_site wo_lot wo_nbr wo_part wo_due_date  wo_qty_ord wo_qty_comp wo__chr05  with frame x2 .

end.
output close.

  