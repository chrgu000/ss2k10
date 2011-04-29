/*xxbcrp003.p 按采购单收货打印材料条码                                */
/* REVISION: 1.0         Last Modified: 2010/03/05  By: Roger   ECO:*100305.1*  */
/* SS - 100701.1  By: Roger Xiao */ /*打印排序按prh_part*/
/* SS - 100706.1  By: Roger Xiao */ /*打印时直接抓取历史记录的批号*/
/* SS - 100707.1  By: Roger Xiao */ /*增加打印条件收货库位*/
/* SS - 100708.1  By: Roger Xiao */ /*增加打印格式:项次*/
/* SS - 100713.1  By: Roger Xiao */ /*同一个收货单下,收错批次,退掉再收货的*/

/*-Revision end-----------------------------------------------------------------*/


/*逻辑同xxbcrp002.p,只是条码数量这里为收货数量 */

{mfdtitle.i "100713.1"} 
define var effdate   like prh_rcp_date .
define var effdate1  like prh_rcp_date  .
define var nbr     like po_nbr.
define var nbr1    like po_nbr.
define var part      like pt_part.
define var part1     like pt_part.
define var loc      like pt_loc.
define var loc1     like pt_loc.

define var wsection      as char . /*for barcode print*/
define var ts9130        as char . /*for barcode print*/
define var av9130        as char . /*for barcode print*/

define var v_qty_rct as decimal . /*收货数*/
define var v_qty_pk  as decimal . /*包装量*/
define var v_qty_sn  as integer . /*条码张数*/
define var v_vend    as char .    /*供应商代码*/
define var v_seq     as char    . /*条码流水号*/
define var v_date    as char .
define var v_sn as char format "x(30)".

define var i         as integer . 


define temp-table temp1 
       field t1_nbr      as char 
       field t1_part     as char 
       field t1_seq      as integer . 
  
define temp-table temp2
    field t2_part     like tr_part 
    field t2_nbr      like tr_nbr
    field t2_line     like tr_line 
    field t2_serial   like tr_serial 
    field t2_lot      like prh_receiver
    field t2_qty_rct  like tr_qty_loc
    .



FORM 
    skip(1)
    nbr       colon 20
    /*nbr1      colon 49 label {t001.i} */
    effdate     colon 20 
    /*effdate1    colon 49 label {t001.i} 
    part        colon 20
    part1       colon 49 label {t001.i} */

    loc         colon 20
    loc1        colon 49 label {t001.i}   

    skip(3)         
with frame a attr-space side-labels width 80.
setFrameLabels(frame a:handle).


effdate = today .
effdate1 = today .

{wbrp01.i}
mainloop:
repeat:
    if part1 = hi_char then part1  = "".
    if nbr1 = hi_char then nbr1  = "".
    if effdate  = low_date then effdate = ? .
    if effdate1 = hi_date  then effdate1 = ? .
    if loc1 = hi_char then loc1  = "".

    update nbr effdate loc loc1 /*nbr1  effdate1 part part1*/  with frame a.
    
    if loc1 = "" then loc1 = hi_char.
    if part1 = "" then part1 = hi_char.
    if nbr1 = "" then nbr1 = hi_char.
    if effdate  = ? then effdate = low_date .
    if effdate1 = ? then effdate1 = hi_date .

    find first po_mstr where po_nbr = nbr no-lock no-error .
    if not avail po_mstr then do:
        message "PO不存在,请重新输入" .
        undo,retry .
    end.
    if avail po_mstr then v_vend = po_vend .


    {mfselbpr.i "printer" 80}
    
printloop:
do on error undo,retry :

    for each temp2:  delete temp2 . end.

    for each tr_hist 
        use-index tr_nbr_eff 
        where  tr_nbr =  nbr
        and    tr_effdate = effdate
        and    tr_type    = "RCT-PO"
        and    tr_loc  >= loc and tr_loc <= loc1 
        no-lock
        break by tr_nbr by tr_line by tr_part by tr_lot by tr_serial :

        if first-of(tr_serial) then assign v_qty_rct = 0  .
        v_qty_rct = v_qty_rct + tr_qty_loc .

        if last-of(tr_serial) then do:
            if v_qty_rct <> 0 then do:
                find first temp2 
                    where t2_part = tr_part 
                    and t2_nbr    = tr_nbr 
                    and t2_line   = tr_line 
                    and t2_lot    = tr_lot
                    and t2_serial = tr_serial 
                no-error .
                if not avail temp2 then do:
                    create temp2 .
                    assign t2_part   = tr_part 
                           t2_nbr    = tr_nbr 
                           t2_line   = tr_line 
                           t2_lot    = tr_lot
                           t2_serial = tr_serial
                           .
                end.
                t2_qty_rct = t2_qty_rct + tr_qty_loc . 
            end.
        end.

    end. /*for each tr_hist*/

    for each temp2 where t2_qty_rct <> 0 
        break by t2_nbr by t2_line by t2_lot by t2_serial :

        find first pt_mstr where pt_part = t2_part no-lock no-error .
        v_qty_pk = if avail pt_mstr then pt_ord_mult else 0.
        if v_qty_pk = 0  then v_qty_pk = t2_qty_rct .

        v_qty_rct = t2_qty_rct .
        v_sn = t2_part + "$" + if t2_serial <> "" then t2_serial else "xxx" .
        v_qty_sn  = v_qty_rct .
        
        /*实际打印: 前面的几张条码按包装量打印,最后一张按尾数打印*/ 
        run print (input v_sn, input v_qty_sn ,input t2_line). 
        
        {mfrpexit.i}
    end. /*for each temp2*/


end. /*printloop*/



{mfreset.i}
end. /*mainloop:*/



procedure print:
    define input parameter vv_sn    like pt_part.
    define input parameter vv_qty   like prh_rcvd.
    define input parameter vv_line  like prh_line.

    define variable labelspath as character format "x(100)" .

    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".

    wsection    = "xsposn10" + trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .

    input from value(labelspath + "xsposn10" ).
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

          /*订单行*/
          if index(ts9130, "@n") <> 0 then do:
             av9130 = string(vv_line).
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



