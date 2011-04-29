/*xxbcrp005.p 按库存交易记录打印标签                                         */
/* REVISION: 1.0         Last Modified: 2008/11/29   By: Roger   ECO:*xp001*  */
/*-Revision end------------------------------------------------------------*/

{mfdtitle.i "1.0 "} 
define var effdate   as date .
define var effdate1  as date .
define var part      like pt_part.
define var part1     like pt_part.
define var loc       like loc_loc.
define var loc1      like loc_loc.
define var lot       like ld_lot.
define var lot1      like ld_lot.


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



FORM 
    effdate     colon 20 
    effdate1    colon 49 label {t001.i} 
    part        colon 20
    part1       colon 49 label {t001.i} 
    loc         colon 20
    loc1        colon 49 label {t001.i} 
    lot         colon 20
    lot1        colon 49 label {t001.i} 
    
    skip(3)         
with frame a attr-space side-labels width 80.


effdate = today .
effdate = today .

{wbrp01.i}
mainloop:
repeat:
    if part1 = hi_char then part1  = "".
    if loc1 = hi_char then loc1  = "".
    if lot1 = hi_char then lot1  = "".
    if effdate  = low_date then effdate = ? .
    if effdate1 = hi_date  then effdate1 = ? .

    update effdate effdate1 part part1 loc loc1 lot lot1   with frame a.
    

    if part1 = "" then part1 = hi_char.
    if loc1 = "" then loc1 = hi_char.
    if lot1 = "" then lot1 = hi_char.
    if effdate  = ? then effdate = low_date .
    if effdate1 = ? then effdate1 = hi_date .

    {mfselbpr.i "printer" 80}
    
printloop:
do on error undo,retry :
    for each tr_hist no-lock
        use-index tr_type
        where tr_type  = "RCT-WO"
        and tr_effdate >= effdate and tr_effdate <= effdate1 
        and tr_part >= part  and tr_part <= part1
        and (tr_loc begins "HAP" or tr_loc begins "JAP" )
        and tr_loc >= loc    and tr_loc <= loc1
        and tr_serial >= lot and tr_serial <= lot1
        and tr_qty_loc > 0
    break by tr_type by tr_effdate by tr_loc by tr_part by tr_serial :

        find first pt_mstr where pt_part = tr_part no-lock no-error.
        if available pt_mstr and (pt_prod_line = "FS00" or pt_prod_line = "FP00") then do:

            run print
            (input tr_part, input pt_desc1, input pt_desc2, input tr_serial, input tr_qty_loc, 
            output vv_label2, output vv_filename2, output vv_oneword2 ).            
            
            vv_part2     = tr_part . 
            vv_lot2      = tr_serial .
            vv_qtyp2     = string(tr_qty_loc) .
            /*vv_filename2 =     vv_oneword2  =   vv_label2    = */
            run xsprinthist .

        end.

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
    define output parameter v_label1    as char .
    define output parameter v_filename1 as char .
    define output parameter v_oneword1  as char .

    define variable labelspath as character format "x(100)" .

    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".
    v_label1    = labelspath + "lap08" .
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
