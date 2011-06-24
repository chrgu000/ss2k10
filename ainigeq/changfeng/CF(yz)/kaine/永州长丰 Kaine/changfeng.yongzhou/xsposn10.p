/* xsposn10.p -- */
/* Copyright 201003 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* SS - 100301.1 - RNB
[100301.1]
条码打印程序,采购收货条码打印.
输入采购单号,收货日期,收货单号显示,条码打印张数,打印机选择,实际打印
[100301.1]
SS - 100301.1 - RNE */

{xsbcvariable01.i}

define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xswoi10wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

    
mainloop:
repeat:

    /* START  LINE :0010  地点[SITE]  */
    lp0010:
    repeat on endkey undo, retry:
        hide all.
        
        {xsvarform0010.i}
        
        {xsdefaultsite.i
            s0010_1
            s0010_2
        }
        
        s0010 = s0010_1.
        
        /* *ss_20090701* 标题行内容 */
        sTitle = "[采购收货条码打印]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /*采购单号,*/
    {xsposn100020.i}

    /*收货日期*/
    {xsposn100030.i}

    /*收货单号显示*/
    {xsposn100040.i}

    /*每张工单打印条码张数*/
    {xsposn100050.i}

    /*打印机*/
    {xsposn100060.i}

    define var v_qty_rct as decimal . /*收货数*/
    define var v_qty_pk  as decimal . /*包装量*/
    define var v_qty_sn  as integer . /*条码张数*/
    define var v_sn_seq  as char    . /*条码流水号*/
    define var v_vend    as char .

    define temp-table temp1 
           field t1_nbr      as char 
           field t1_part     as char 
           field t1_seq      as integer . 
    find first po_mstr where po_nbr = s0020 no-lock no-error .
    if avail po_mstr then v_vend = po_vend .
    
    for each temp1 . delete temp1 .  end. 

    i = 0 .
    for each prh_hist 
        use-index prh_rcp_date
        where prh_rcp_date = s0030
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
        where prh_rcp_date = s0030
        and   prh_nbr = s0020 
        no-lock break by prh_nbr by prh_receiver by prh_part:

        if first-of(prh_part) then assign v_qty_rct = 0 v_qty_pk = 0 v_qty_sn = 0 .
        v_qty_rct = v_qty_rct + prh_rcvd .
        if last-of(prh_part) then do:
            find first pt_mstr where pt_part = prh_part no-lock no-error .
            if avail pt_mstr then v_qty_pk = pt_ord_mult .
            if v_qty_pk = 0 then v_qty_pk = v_qty_rct .
            
            v_qty_sn = if truncate(v_qty_rct / v_qty_pk , 0 ) * v_qty_pk < v_qty_rct then truncate(v_qty_rct / v_qty_pk , 0 ) + 1 else truncate(v_qty_rct / v_qty_pk , 0 ) .
            v_qty_sn = v_qty_sn * s0050 .
            
            find first temp1 where t1_nbr = prh_receiver and t1_part = prh_part no-lock no-error .
            v_sn_seq = if avail temp1 then string(t1_seq,"99") else "01" .

            /*实际打印*/ 
            {xsposn100070.i}


        end.
    end.  /*for each prh_hist*/


end. /*mainloop:*/


