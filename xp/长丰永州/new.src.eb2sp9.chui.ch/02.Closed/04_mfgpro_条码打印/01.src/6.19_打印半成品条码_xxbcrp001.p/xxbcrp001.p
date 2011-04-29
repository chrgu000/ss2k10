/*xxbcrp001.p 按半成品工单下达日期打印半成品条码                                */
/* REVISION: 1.0         Last Modified: 2010/03/05  By: Roger                   */
/* SS - 100623.1  By: Roger Xiao */ /*打印时,加上工单ID*/
/* SS - 100701.1  By: Roger Xiao */ /*打印排序按wo_lot*/
/*-Revision end-----------------------------------------------------------------*/

{mfdtitle.i "100701.1"} 
define var effdate   like wo_rel_date .
define var effdate1  like wo_rel_date  .
define var part      like pt_part.
define var part1     like pt_part.
define var wolot     like wo_lot.
define var wolot1    like wo_lot.
define var buyer     like pt_buyer .

define var wsection      as char . /*for barcode print*/
define var ts9130        as char . /*for barcode print*/
define var av9130        as char . /*for barcode print*/


define var v_seq  as integer .
define var v_date as char .
define var v_sn as char format "x(30)".

define temp-table temp1 
       field t1_lot      as char 
       field t1_date     as date 
       field t1_seq      as integer . 
  


FORM 
    skip(1)
    buyer       colon 20 
    effdate     colon 20 
    effdate1    colon 49 label {t001.i} 
    part        colon 20
    part1       colon 49 label {t001.i} 
    wolot       colon 20
    wolot1      colon 49 label {t001.i} 
    
    skip(3)         
with frame a attr-space side-labels width 80.
setFrameLabels(frame a:handle).


effdate = today .
effdate1 = today .

{wbrp01.i}
mainloop:
repeat:
    if part1 = hi_char then part1  = "".
    if wolot1 = hi_char then wolot1  = "".
    if effdate  = low_date then effdate = ? .
    if effdate1 = hi_date  then effdate1 = ? .

    update buyer effdate effdate1 part part1 wolot wolot1   with frame a.
    

    if part1 = "" then part1 = hi_char.
    if wolot1 = "" then wolot1 = hi_char.
    if effdate  = ? then effdate = low_date .
    if effdate1 = ? then effdate1 = hi_date .

    {mfselbpr.i "printer" 80}
    
printloop:
do on error undo,retry :

    for each temp1 : delete temp1 . end .
    v_seq = 0 .

    /*找日期范围内,每天的所有工单,排序,以产生下达流水号*/
    for each pt_mstr where pt_buyer = buyer 
                     and   pt_part >= part and pt_part <= part1 
                     no-lock ,
        each wo_mstr use-index wo_part_rel 
                     where wo_part  = pt_part 
                     and (wo_rel_date >= effdate and wo_rel_date <= effdate1)
                     and wo_status = "R"
                     no-lock break by wo_part by wo_rel_date:
        if first-of(wo_rel_date) then v_seq = 0 .

        v_seq = v_seq + 1 .

        find first temp1 where t1_lot = wo_lot no-lock no-error.
        if not avail temp1 then do:
            create temp1 .
            assign t1_lot  = wo_lot 
                   t1_date = wo_rel_date
                   t1_seq  = v_seq 
                   .
        end.
        
        {mfrpexit.i}
    end.  /*for each pt_mstr*/




    for each temp1   no-lock ,
        each wo_mstr where wo_lot = t1_lot 
                     and wo_lot >= wolot and wo_lot <= wolot1  
                     no-lock break by wo_lot  by wo_part by wo_rel_date:
        
            v_date = substring(string(year(wo_rel_date),"9999"),3,2) + string(month(wo_rel_date),"99") + string(day(wo_rel_date),"99") .
            v_sn   = wo_part + "$" + v_date + string(t1_seq,"99") .

            /*实际打印*/ 
            run print (input v_sn ,input wo_qty_ord ,input wo_lot ).            

        
        {mfrpexit.i}
    end.  /*for each pt_mstr*/
    


end. /*printloop*/



{mfreset.i}
end. /*mainloop:*/



procedure print:
    define input parameter vv_sn    like pt_part.
    define input parameter vv_qty   like wo_qty_ord.
    define input parameter vv_wolot like wo_lot.



    define variable labelspath as character format "x(100)" .

    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".

    wsection    = "xswosn10" + trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .

    input from value(labelspath + "xswosn10" ).
    output to value(trim(wsection) + ".l") .
       repeat:
          import unformatted ts9130.
          
          /*条码和条码下文字*/
          if index(ts9130, "@b") <> 0 then do:
             av9130 = vv_sn.
             ts9130 = substring(ts9130, 1, index(ts9130 , "@b") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"@b") 
                    + length("@b"), length(ts9130) - ( index(ts9130 , "@b") + length("@b") - 1 ) ).
          end.
          
          /*数量*/
          if index(ts9130, "@q") <> 0 then do:
             av9130 = string(vv_qty).
             ts9130 = substring(ts9130, 1, index(ts9130 , "@q") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"@q") 
                    + length("@q"), length(ts9130) - ( index(ts9130 , "@q") + length("@q") - 1 ) ).
          end.

          /*工单标志*/
          if index(ts9130, "@n") <> 0 then do:
             av9130 = vv_wolot.
             ts9130 = substring(ts9130, 1, index(ts9130 , "@n") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"@n") 
                    + length("@n"), length(ts9130) - ( index(ts9130 , "@n") + length("@n") - 1 ) ).
          end.

          put unformatted ts9130 skip.
       end.

    input close.
    output close.

    unix silent value ("chmod 777  " + trim(wsection) + ".l").

    find first prd_det where prd_dev = trim(dev) no-lock no-error.
    if available prd_det then do:
        unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
        unix silent value ("rm " + trim(wsection) + ".l").
    end.
end. /*procedure*/



