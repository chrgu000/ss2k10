/* xssorjt10trans.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

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
    + "sorjt10"
    .

assign
    ciminputfile = usection + ".i"
    cimoutputfile = usection + ".o"
    .

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

assign
    bSucceed = yes
    iFailLine = 0
    decFailQty = 0
    .

bc-so-iss-lp:
do transaction on endkey undo, leave:
    for each t1_tmp:
        output to value(ciminputfile).
        /* ����*        */    {xxputcimvariable.i ""qq"" s0020 "at 1"}
        /* ��Ч����     */    {xxputcimvariable.i ""d"" ""-""}
        /* ������       */    {xxputcimvariable.i ""d"" ""N""}
        /* ������       */    {xxputcimvariable.i ""d"" ""N""}
        /* �ص�         */    {xxputcimvariable.i ""qq"" s0010}
        /* ��*          */    {xxputcimvariable.i ""d"" t1_line "at 1"}
        /* ȡ��Ƿ��     */    {xxputcimvariable.i ""d"" ""N""}
        /* ����*        */    {xxputcimvariable.i ""d"" t1_qty "at 1"}
        /* �ص�         */    {xxputcimvariable.i ""qq"" s0010}
        /* ��λ         */    {xxputcimvariable.i ""qq"" s0050}
        /* ����         */    {xxputcimvariable.i ""qq"" s0041}
        /* �ο�         */    {xxputcimvariable.i ""qq"" """"}
        /* ���¼       */    {xxputcimvariable.i ""d"" ""N""}
        /* �뿪F4*      */    {xxputcimvariable.i ""d"" ""."" "at 1"}
        /* ��ʾ*        */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
        /* ȷ��*        */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
        /* 10*          */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
        /* 101          */    {xxputcimvariable.i ""d"" ""-""}
        /* 20           */    {xxputcimvariable.i ""d"" ""-""}
        /* 201          */    {xxputcimvariable.i ""d"" ""-""}
        /* 30           */    {xxputcimvariable.i ""d"" ""-""}
        /* 301          */    {xxputcimvariable.i ""d"" ""-""}
        /* ��˰ϸ��     */    {xxputcimvariable.i ""d"" ""N""}
        /* �������*    */    {xxputcimvariable.i ""d"" ""-"" "at 1"}
        /* ��������     */    {xxputcimvariable.i ""d"" ""-""}
        /* �ᵥ         */    {xxputcimvariable.i ""d"" ""-""}
        /* ��ע         */    {xxputcimvariable.i ""d"" ""-""}
        /* ��Ʊ��       */    {xxputcimvariable.i ""d"" ""-""}
        /* ׼����ӡ��Ʊ */    {xxputcimvariable.i ""d"" ""-""}
        /* �ѿ���Ʊ     */    {xxputcimvariable.i ""d"" ""-""}
        put "." at 1.
        output close.


        input from value(ciminputfile).
        output to  value(cimoutputfile).
        batchrun = yes.
        {gprun.i ""sosois.p""}
        batchrun = no.
        input close.
        output close.
        {xserrlg.i}

        find first tr_hist
            no-lock
            where tr_trnbr > iTrSeq
                and tr_type = "ISS-SO"
                and tr_site = s0010
                and tr_loc  = s0050
                and tr_part = s0040
                and tr_serial = s0041
                and tr_nbr    = s0020
                and tr_line   = t1_line
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
                iFailLine = t1_line
                decFailQty = t1_qty
                .
            undo bc-so-iss-lp, leave bc-so-iss-lp.
        end.
    end.
    
    release t1_tmp.

end.



os-delete value(ciminputfile).
os-delete value(cimoutputfile).
