/* xxbcrp006.p 按PO收货记录打印标签                                        */
/* REVISION: 1.0         Last Modified: 2008/11/29   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
按PO收货记录,查找item/lot,打印标签
不打标签的条件:
1.现在无库存的,不再打
2.今天期初有库存的,不再打
3.今天同批次打过了一张的(temp1),不再打
*/


{mfdtitle.i "1.0 "} 
define var effdate   as date .
define var effdate1  as date .
define var part      like pt_part.
define var part1     like pt_part.
define var nbr       like po_nbr.
define var nbr1      like po_nbr.
define var prodline  like pt_prod_line  .
define var prodline1 like pt_prod_line  .

define var lot       like ld_lot .
define var povend    like po_vend .
define var ponbr     like po_nbr .
define var v_qty_loc like tr_qty_loc .

define var wsection      as char . /*for barcode print*/
define var ts9130        as char . /*for barcode print*/
define var av9130        as char . /*for barcode print*/

define var vv_part2      as char . /*for xsprinthist.i */ 
define var vv_lot2       as char . /*for xsprinthist.i */ 
define var vv_qtyp2      as char . /*for xsprinthist.i */ 
define var vv_filename2  as char . /*for xsprinthist.i */
define var vv_oneword2   as char . /*for xsprinthist.i */  
define var vv_label2     as char . /*for xsprinthist.i */
define var wtm_num       as char . /*for xsprinthist.i */
wtm_num = "1" .                    /*for xsprinthist.i */


define buffer aa for tr_hist .

define temp-table temp1 
    field  t1_part like ld_part
    field  t1_lot  like ld_lot .

FORM 
    effdate     colon 20 
    effdate1    colon 49 label {t001.i} 
    nbr         colon 20
    nbr1        colon 49 label {t001.i}
    prodline    colon 20                         
    prodline1   colon 49 label {t001.i} 

    part        colon 20
    part1       colon 49 label {t001.i}
    
    skip(3)         
with frame a attr-space side-labels width 80.

effdate  = today .
effdate1 = today .

{wbrp01.i}
mainloop:
repeat:
    if part1 = hi_char then part1  = "".
    if nbr1 = hi_char then nbr1  = "".
    if prodline1     = hi_char  then prodline1     = "". /*xp002*/  

    if effdate  = low_date then effdate = ? .
    if effdate1 = hi_date  then effdate1 = ? .

    update effdate effdate1 nbr nbr1 prodline prodline1 part part1   with frame a.
    

    if part1 = "" then part1 = hi_char.
    if nbr1 = "" then nbr1 = hi_char.
    if prodline1     = "" then prodline1     = hi_char.
    if effdate  = ? then effdate = low_date .
    if effdate1 = ? then effdate1 = hi_date .

    {mfselbpr.i "printer" 80}
    
printloop:
do on error undo,retry :

    for each temp1 : delete temp1 . end. 

    for each tr_hist no-lock
            use-index tr_nbr_eff
            where tr_hist.tr_nbr >= nbr  and tr_hist.tr_nbr <= nbr1
            and tr_hist.tr_type  = "RCT-PO"
            and tr_hist.tr_effdate >= effdate and tr_hist.tr_effdate <= effdate1 
            and tr_hist.tr_part >= part  and tr_hist.tr_part <= part1
            and tr_hist.tr_qty_loc > 0,
        each pt_mstr 
            where pt_part = tr_hist.tr_part 
            and pt_prod_line >= prodline and pt_prod_line <= prodline1
    break by tr_hist.tr_effdate by tr_hist.tr_nbr by tr_hist.tr_part :
        
        find first ld_det 
            where ld_site = tr_hist.tr_site 
            and ld_part = tr_hist.tr_part 
            and ld_loc = tr_hist.tr_loc 
            and ld_lot = tr_hist.tr_serial 
            and ld_status = "normal" 
        no-lock no-error .
        if avail ld_det then do:
            
            if ld_qty_oh = 0  then next . /*目前没库存的,不打标签*/

            v_qty_loc = 0 . /*今日/item/loc/lot所有交易*/
            for each aa 
                where aa.tr_effdate  = tr_hist.tr_effdate
                and   aa.tr_part     = tr_hist.tr_part
                and   aa.tr_loc      = tr_hist.tr_loc
                and   aa.tr_serial   = tr_hist.tr_serial
                no-lock :
                v_qty_loc = v_qty_loc + tr_qty_loc .
            end.

            if ld_qty_oh - v_qty_loc <> 0 then next . /*今天收货前(即期初),有库存记录的: 不打标签*/

            find first temp1 where t1_part = tr_hist.tr_part and t1_lot = tr_hist.tr_serial no-lock no-error .
            if avail temp1 then next . /*每个料件/批号,限打一张*/
            else do:
                create  temp1.
                assign  t1_part = tr_hist.tr_part 
                        t1_lot = tr_hist.tr_serial .
            end.


            find first po_mstr where po_nbr = tr_hist.tr_nbr no-lock no-error.
            if avail po_mstr then do:         
                lot    = if pt_lot_ser <> "L" and tr_hist.tr_serial = "" then "/" else tr_hist.tr_serial .
                ponbr  = if pt_lot_ser <> "L" and tr_hist.tr_serial = "" then "/" else po_nbr .
                povend = if pt_lot_ser <> "L" and tr_hist.tr_serial = "" then "/" else po_vend .

                run print
                (input tr_hist.tr_part, input pt_desc1, input pt_desc2, input lot, input ld_qty_oh ,  input ponbr ,input povend ,
                output vv_label2, output vv_filename2, output vv_oneword2 ).      /*按打印时的实际库存打印*/      
                
                vv_part2     = tr_hist.tr_part . 
                vv_lot2      = lot .
                vv_qtyp2     = string(ld_qty_oh) .
                /*vv_filename2 =     vv_oneword2  =   vv_label2    = */
                run xsprinthist .
                
            end. /*if avail po_mstr*/
        end. /*if avail ld_det*/

        {mfrpexit.i}
    end. /*for each tr_hist*/

end. /*printloop*/



{mfreset.i}
end. /*mainloop:*/






procedure print:
    define input parameter v_part  like pt_part.
    define input parameter v_desc1 like pt_desc1.
    define input parameter v_desc2 like pt_desc2.
    define input parameter v_lot   like ld_lot.
    define input parameter v_qty   like ld_qty_oh.
    define input parameter ponbr  like po_nbr .
    define input parameter povend like po_vend .

    define output parameter v_label1    as char .
    define output parameter v_filename1 as char .
    define output parameter v_oneword1  as char .

    define variable labelspath as character format "x(100)" .

    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".
    v_label1    = labelspath + "por01" .
    wsection    = trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .
    v_filename1 = trim(wsection) + ".l" .
    v_oneword1  = "" .

    input from value(v_label1).
    output to value(v_filename1) .
       repeat:
          import unformatted ts9130.

          if index(ts9130, "$p") <> 0 then do:
             av9130 = v_part.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$p") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$p") 
                    + length("$p"), length(ts9130) - ( index(ts9130 , "$p") + length("$p") - 1 ) ).
          end.

          if index(ts9130, "$f") <> 0 then do:
             av9130 = v_desc1.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$f") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$f") 
                    + length("$f"), length(ts9130) - ( index(ts9130 , "$f") + length("$f") - 1 ) ).
          end.

          if index(ts9130, "$e") <> 0 then do:
             av9130 = v_desc2.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$e") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$e") 
                    + length("$e"), length(ts9130) - ( index(ts9130 , "$e") + length("$e") - 1 ) ).
          end.

          if index(ts9130, "$s") <> 0 then do:
             av9130 = povend .
             ts9130 = substring(ts9130, 1, index(ts9130 , "$s") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$s") 
                    + length("$s"), length(ts9130) - ( index(ts9130 , "$s") + length("$s") - 1 ) ).
          end.

          if index(ts9130, "$o") <> 0 then do:
             av9130 = ponbr .
             ts9130 = substring(ts9130, 1, index(ts9130 , "$o") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$o") 
                    + length("$o"), length(ts9130) - ( index(ts9130 , "$o") + length("$o") - 1 ) ).
          end.


          if index(ts9130, "$l") <> 0 then do:
             av9130 = v_lot.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$l") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$l") 
                    + length("$l"), length(ts9130) - ( index(ts9130 , "$l") + length("$l") - 1 ) ).
          end.

          if index(ts9130, "$q") <> 0 then do:
             av9130 = string(v_qty).
             ts9130 = substring(ts9130, 1, index(ts9130 , "$q") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$q") 
                    + length("$q"), length(ts9130) - ( index(ts9130 , "$q") + length("$q") - 1 ) ).
          end.                 

          if index(ts9130, "&b") <> 0 then do:
             av9130 = v_part + "@" + v_lot.

             ts9130 = substring(ts9130, 1, index(ts9130 , "&b") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"&b") 
                    + length("&b"), length(ts9130) - ( index(ts9130 , "&b") + length("&b") - 1 ) ).
          end.

          put unformatted ts9130 skip.
          v_oneword1 = v_oneword1 + ts9130.
       end.

    input close.
    output close.

    unix silent value ("chmod 777  " + v_filename1).

    find first prd_det where prd_dev = trim(dev) no-lock no-error.
    if available prd_det then do:
        unix silent value (trim(prd_path) + v_filename1).
        unix silent value ("rm " + v_filename1).
    end.
end. /*procedure*/




procedure  xsprinthist: 
    {xsprinthist.i} 
end procedure. 
