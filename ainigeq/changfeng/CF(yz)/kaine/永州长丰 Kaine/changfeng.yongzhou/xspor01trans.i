/* xspor01trans.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

define variable global_user_lang_dir as character format "x(40)" init "/app/mfgpro/eb2/ch/".
define shared variable global_gblmgr_handle as handle no-undo.
define variable ciminputfile   as character .
define variable cimoutputfile  as character .

run pxgblmgr.p persistent set global_gblmgr_handle.


find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if available(code_mstr) Then global_user_lang_dir = trim(code_cmmt).
if substring(global_user_lang_dir, max(length(global_user_lang_dir), 1), 1) <> "/" then
    global_user_lang_dir = global_user_lang_dir + "/".

define variable usection as char format "x(16)".

usection = string(year(TODAY), "9999")
    + string(MONTH(TODAY), "99")
    + string(DAY(TODAY), "99")
    + STRING(TIME, "99999")
    + string(RANDOM(0, 99), "99")
    + "por01"
    .

assign
    ciminputfile = usection + ".i"
    cimoutputfile = usection + ".o"
    .

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

assign
    bSucceed = yes
    sFailNbr = ""
    iFailLine = 0
    decFailQty = 0
    .

bc-po-rct-lp:
do transaction on endkey undo, leave:
    for each t1_tmp:
        output to value(ciminputfile).
        /* 采购单*        */    {xxputcimvariable.i ""qq"" t1_nbr "at 1"}
        /* 装箱单*        */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
        /* 收货单         */    {xxputcimvariable.i ""d"" ""-""}
        /* 生效日期       */    {xxputcimvariable.i ""d"" ""-""}
        /* 下道工序       */    {xxputcimvariable.i ""d"" ""n""}
        /* 全部收货       */    {xxputcimvariable.i ""d"" ""n""}
        /* 说明           */    {xxputcimvariable.i ""d"" ""n""}
        /* 发货日期       */    {xxputcimvariable.i ""d"" ""-""}
        /* 项次*          */    {xxputcimvariable.i ""d"" t1_line "at 1"}
        /* 数量*          */    {xxputcimvariable.i ""d"" t1_qty "at 1"}
        /* 装箱数量       */    {xxputcimvariable.i ""d"" ""-""}
        /* 取消欠交单     */    {xxputcimvariable.i ""d"" ""-""}
        /* 单位           */    {xxputcimvariable.i ""d"" ""-""}
        /* 工单ID         */    {xxputcimvariable.i ""d"" ""-""}
        /* 工单OP         */    {xxputcimvariable.i ""d"" ""-""}
        /* 地点           */    {xxputcimvariable.i ""qq"" s0010}
        /* 库位           */    {xxputcimvariable.i ""qq"" s0050}
        /* 批号           */    {xxputcimvariable.i ""qq"" s0030}
        /* 参考           */    {xxputcimvariable.i ""d"" ""-""}
        /* 供应商批号     */    {xxputcimvariable.i ""qq"" mfguser}
        /* 多记录         */    {xxputcimvariable.i ""d"" ""N""}
        /* 改属性         */    {xxputcimvariable.i ""d"" ""N""}
        /* 说明           */    {xxputcimvariable.i ""d"" ""N""}
        /* Leave-Key*     */    {xxputcimvariable.i ""d"" ""."" "at 1"}
        /* 是否显示信息*  */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
        /* 确认正确*      */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
        put "." at 1.
        output close.


        input from value(ciminputfile).
        output to  value(cimoutputfile).
        batchrun = yes.
        {gprun.i ""poporc.p""}
        batchrun = no.
        input close.
        output close.
        {xserrlg.i}

        find first tr_hist
            no-lock
            where tr_trnbr > iTrSeq
                and tr_type = "RCT-PO"
                and tr_site = s0010
                and tr_loc = s0050
                and tr_part = s0020
                and tr_serial = s0030
                and tr_nbr = t1_nbr
                and tr_line = t1_line
                and tr_vend_lot = mfguser
            use-index tr_trnbr
            no-error.
        if available(tr_hist) then do:
            assign
                t1_trnbr = tr_trnbr
                t1_rct_nbr = tr_lot
                iTrSeq = tr_trnbr
                .
        end.
        else do:
            assign
                bSucceed = no
                sFailNbr = t1_nbr
                iFailLine = t1_line
                decFailQty = t1_qty
                .
            undo bc-po-rct-lp, leave bc-po-rct-lp.
        end.
    end.
    
    release t1_tmp.

end.

os-delete value(ciminputfile).
os-delete value(cimoutputfile).
