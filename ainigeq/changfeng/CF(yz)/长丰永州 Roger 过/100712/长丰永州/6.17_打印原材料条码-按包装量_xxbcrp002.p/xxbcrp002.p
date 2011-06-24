/*xxbcrp002.p 按采购单收货打印材料条码                                */
/* REVISION: 1.0         Last Modified: 2010/03/05  By: Roger   ECO:*100305.1*  */
/* SS - 100701.1  By: Roger Xiao */ /*打印排序按prh_part*/
/* SS - 100706.1  By: Roger Xiao */ /*打印时直接抓取历史记录的批号*/
/* SS - 100707.1  By: Roger Xiao */ /*增加打印条件收货库位*/
/* SS - 100708.1  By: Roger Xiao */ /*增加打印格式:项次*/

/*-Revision end-----------------------------------------------------------------*/


/*逻辑同xxbcrp003.p,只是条码数量这里为 最小包装量和尾数 */


{mfdtitle.i "100708.1"} 
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
/**********************
    for each temp1 . delete temp1 .  end. 

    i = 0 .
    for each prh_hist 
        use-index prh_rcp_date
        where prh_rcp_date = effdate
        and   prh_vend     = v_vend  
        no-lock break by prh_part by prh_receiver :
        
        if first-of(prh_part) then i = 0 .

        if first-of(prh_receiver) then do:
            i = i + 1 .
            find first temp1 where t1_nbr = prh_receiver and t1_part = prh_part no-lock no-error .
            if not avail temp1 then do:
                create temp1 .
                assign t1_part = prh_part 
                       t1_nbr  = prh_receiver
                       t1_seq  = i .
            end.
        end.
    end. /*for each prh_hist*/


    for each prh_hist 
        use-index prh_rcp_date
        where prh_rcp_date = effdate
        and   prh_nbr = nbr
        no-lock break by prh_part by prh_nbr by prh_receiver :

        if first-of(prh_receiver) then assign v_qty_rct = 0 v_qty_pk = 0 v_qty_sn = 0 .

        /* SS - 100707.1 - B */
        find first tr_hist 
            use-index tr_nbr_eff
            where tr_nbr   = prh_nbr 
            and tr_effdate = prh_rcp_date 
            and tr_line    = prh_line
            and tr_type    = "RCT-PO" 
            and tr_part    = prh_part 
        no-lock no-error .
        if avail tr_hist then do:
            if tr_loc < loc or tr_loc > loc1 then next .
        end.
        /* SS - 100707.1 - E */

        v_qty_rct = v_qty_rct + prh_rcvd .
        if last-of(prh_receiver) then do:
            find first pt_mstr where pt_part = prh_part no-lock no-error .
            if avail pt_mstr then v_qty_pk = pt_ord_mult .
            if v_qty_pk = 0 then v_qty_pk = v_qty_rct .
            
            find first temp1 where t1_nbr = prh_receiver and t1_part = prh_part no-lock no-error .
            v_seq = if avail temp1 then string(t1_seq,"99") else "01" .

            v_date = substring(string(year(prh_rcp_date),"9999"),3,2) + string(month(prh_rcp_date),"99") + string(day(prh_rcp_date),"99") .            
            v_sn = prh_part + "$" + v_date + v_vend + v_seq .

            /* SS - 100706.1 - B */
            find first tr_hist 
                use-index tr_nbr_eff
                where tr_nbr   = prh_nbr 
                and tr_effdate = prh_rcp_date 
                and tr_line    = prh_line
                and tr_type    = "RCT-PO" 
                and tr_part    = prh_part 
            no-lock no-error .
            v_sn = prh_part + "$" + if avail tr_hist then tr_serial else "xxx" .
            /* SS - 100706.1 - E */


            /*实际打印: 前面的几张条码按包装量打印,最后一张按尾数打印*/ 
            do while v_qty_rct > 0:
                if v_qty_rct >= v_qty_pk then do: 
                    v_qty_sn  = v_qty_pk .
                    v_qty_rct =  v_qty_rct - v_qty_pk .
                end.
                else do:
                    v_qty_sn  = v_qty_rct .
                    v_qty_rct = 0 .
                end.

                run print (input v_sn, input v_qty_sn ).   
            end. /*do while v_qty_rct*/

        end.
        {mfrpexit.i}
    end.  /*for each prh_hist*/
**********************/

    for each prh_hist 
        use-index prh_rcp_date
        where prh_rcp_date = effdate
        and   prh_nbr = nbr
        no-lock break by prh_nbr by prh_line by prh_part by prh_receiver :

        if first-of(prh_receiver) then assign v_qty_rct = 0 v_qty_pk = 0 v_qty_sn = 0 .

        /* SS - 100707.1 - B */
        find first tr_hist 
            use-index tr_nbr_eff
            where tr_nbr   = prh_nbr 
            and tr_effdate = prh_rcp_date 
            and tr_line    = prh_line
            and tr_type    = "RCT-PO" 
            and tr_part    = prh_part 
        no-lock no-error .
        if avail tr_hist then do:
            if tr_loc < loc or tr_loc > loc1 then next .
        end.
        /* SS - 100707.1 - E */

        v_qty_rct = v_qty_rct + prh_rcvd .
        if last-of(prh_receiver) then do:
            find first pt_mstr where pt_part = prh_part no-lock no-error .
            if avail pt_mstr then v_qty_pk = pt_ord_mult .
            if v_qty_pk = 0 then v_qty_pk = v_qty_rct .
            
            find first temp1 where t1_nbr = prh_receiver and t1_part = prh_part no-lock no-error .
            v_seq = if avail temp1 then string(t1_seq,"99") else "01" .

            v_date = substring(string(year(prh_rcp_date),"9999"),3,2) + string(month(prh_rcp_date),"99") + string(day(prh_rcp_date),"99") .            
            v_sn = prh_part + "$" + v_date + v_vend + v_seq .

            /* SS - 100706.1 - B */
            find first tr_hist 
                use-index tr_nbr_eff
                where tr_nbr   = prh_nbr 
                and tr_effdate = prh_rcp_date 
                and tr_line    = prh_line
                and tr_type    = "RCT-PO" 
                and tr_part    = prh_part 
            no-lock no-error .
            v_sn = prh_part + "$" + if avail tr_hist then tr_serial else "xxx" .
            /* SS - 100706.1 - E */


            /*实际打印: 前面的几张条码按包装量打印,最后一张按尾数打印*/ 
            do while v_qty_rct > 0:
                if v_qty_rct >= v_qty_pk then do: 
                    v_qty_sn  = v_qty_pk .
                    v_qty_rct =  v_qty_rct - v_qty_pk .
                end.
                else do:
                    v_qty_sn  = v_qty_rct .
                    v_qty_rct = 0 .
                end.

                run print (input v_sn, input v_qty_sn ,input prh_line).   
            end. /*do while v_qty_rct*/

        end.
        {mfrpexit.i}
    end.  /*for each prh_hist*/



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



