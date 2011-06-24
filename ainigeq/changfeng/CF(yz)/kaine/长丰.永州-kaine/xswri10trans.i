/* xswri10trans.i -- */
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
    + "wri10"
    .

assign
    ciminputfile = usection + ".i"
    cimoutputfile = usection + ".o"
    .

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

assign
    bSucceed = yes
    sFailPart = ""
    sFailLot = ""
    decFailQty = 0
    .


bc-wo-rctiss-lp:
do transaction on endkey undo, leave:
    for each t1_tmp:
        output to value(ciminputfile).
        /* ����*      */   {xxputcimvariable.i ""qq"" """"  "at 1"}
        /* ��         */   {xxputcimvariable.i ""qq"" s0020}
        /* ��         */   {xxputcimvariable.i ""d"" ""0""}
        /* ��Ч����   */   {xxputcimvariable.i ""d"" ""-""}
        /* ���ű���   */   {xxputcimvariable.i ""d"" ""N""}
        /* ��������   */   {xxputcimvariable.i ""d"" ""N""}
        /* ����*      */   {xxputcimvariable.i ""qq"" t1_part   "at 1"}
        /* ��         */   {xxputcimvariable.i ""d"" t1_op}
        /* ����*      */   {xxputcimvariable.i ""d"" dec0060 "at 1"}
        /* ���Ŵ���Ʒ */   {xxputcimvariable.i ""d"" ""N""}
        /* ȡ��Ƿ��   */   {xxputcimvariable.i ""d"" ""N""}
        /* �ص�       */   {xxputcimvariable.i ""qq"" s0010}
        /* ��λ       */   {xxputcimvariable.i ""qq"" s0050}
        /* ����       */   {xxputcimvariable.i ""qq"" t1_lot}
        /* �ο�       */   {xxputcimvariable.i ""qq"" """"}
        /* ���¼     */   {xxputcimvariable.i ""d"" ""N""}
        /* �뿪F4*    */   {xxputcimvariable.i ""d"" ""."" "at 1"}
        /* ��ʾ��Ϣ*  */   {xxputcimvariable.i ""d"" ""Y"" "at 1"}
        /* ȷ��*      */   {xxputcimvariable.i ""d"" ""Y"" "at 1"}
        put "." at 1.
        output close.


        input from value(ciminputfile).
        output to  value(cimoutputfile).
        batchrun = yes.
        {gprun.i ""wowois.p""}
        batchrun = no.
        input close.
        output close.
        {xserrlg.i}

        find first tr_hist
            no-lock
            where tr_trnbr > iTrSeq
                and tr_type = "ISS-WO"
                and tr_site = s0010
                and tr_loc = s0050
                and tr_part = t1_part
                and tr_serial = t1_lot
                and tr_lot = s0020
            use-index tr_trnbr
            no-error.
        if available(tr_hist) then do:
            assign
                t1_trnbr = tr_trnbr
                iTrSeq = tr_trnbr
                .
        end.
        else do:
            assign
                bSucceed = no
                sFailPart = t1_part
                sFailLot = t1_lot
                decFailQty = t1_qty
                .
            undo bc-wo-rctiss-lp, leave bc-wo-rctiss-lp.
        end.
    end.
    
    release t1_tmp.

end.

os-delete value(ciminputfile).
os-delete value(cimoutputfile).
