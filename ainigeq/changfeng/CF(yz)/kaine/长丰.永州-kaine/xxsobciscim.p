/* SS - 090924.1 By: Kaine Zhang */

{mfdeclre.i}

define input parameter sSo as character no-undo. 
define input parameter dteE as date no-undo.
define input parameter iLn as integer no-undo.
define input parameter sLoc as character no-undo.
define input parameter decQty as decimal no-undo.
define output parameter bHasError as logical no-undo.

define temp-table t1_tmp no-undo
    field t1_lot as character
    field t1_qty as decimal
    .

define variable sInputFileName as character no-undo.
define variable sOutputFileName as character no-undo.
define variable sSite as character no-undo.
define variable sPart as character no-undo.
define variable iTrSeq as integer no-undo.


bHasError = no.

find first so_mstr
    where so_nbr = sSo
    no-error.
if not(available(so_mstr)) then do:
    {pxmsg.i &msgnum=609 &errorlevel=3}
    bHasError = yes.
    return.
end.
sSite = so_site.

find first sod_det
    where sod_nbr = so_nbr
        and sod_line = iLn
    no-error.
if not(available(sod_det)) then do:
    {pxmsg.i &msgnum=764 &errorlevel=3}
    bHasError = yes.
    return.
end.
sPart = sod_part.

empty temp-table t1_tmp.
for each ld_det
    no-lock
    where ld_site = so_site
        and ld_loc = sLoc
        and ld_part = sod_part
        and ld_ref = ""
        and ld_qty_oh > 0
    use-index ld_loc_p_lot
:
    create t1_tmp.
    assign
        t1_lot = ld_lot
        t1_qty = min(decQty, ld_qty_oh)
        .
    decQty = decQty - t1_qty.
    if decQty <= 0 then leave.
end.
if decQty > 0 then do:
    {pxmsg.i &msgnum=9019 &errorlevel=3}
    bHasError = yes.
    return.
end.

assign
    sInputFileName = string(year(today), "9999") + string(month(today), "99") + string(day(today), "99")
        + mfguser + "issso.in"
    sOutputFileName = string(year(today), "9999") + string(month(today), "99") + string(day(today), "99")
        + mfguser + "issso.out"
    .

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

bc-so-iss-lp:
do transaction on endkey undo, leave:
    for each t1_tmp:
        output to value(sInputFileName).
        /* ����*        */    {xxputcimvariable.i ""qq"" sSo "at 1"}
        /* ��Ч����     */    {xxputcimvariable.i ""d"" dteE}
        /* ������       */    {xxputcimvariable.i ""d"" ""N""}
        /* ������       */    {xxputcimvariable.i ""d"" ""N""}
        /* �ص�         */    {xxputcimvariable.i ""qq"" sSite}
        /* ��*          */    {xxputcimvariable.i ""d"" iLn "at 1"}
        /* ȡ��Ƿ��     */    {xxputcimvariable.i ""d"" ""N""}
        /* ����*        */    {xxputcimvariable.i ""d"" t1_qty "at 1"}
        /* �ص�         */    {xxputcimvariable.i ""qq"" sSite}
        /* ��λ         */    {xxputcimvariable.i ""qq"" sLoc}
        /* ����         */    {xxputcimvariable.i ""qq"" t1_lot}
        /* �ο�         */    {xxputcimvariable.i ""qq"" """"}
        /* ���¼       */    {xxputcimvariable.i ""d"" ""N""}
        /* �뿪F4*      */    {xxputcimvariable.i ""d"" ""."" "at 1"}
        /* ��ʾ*        */    {xxputcimvariable.i ""d"" ""N"" "at 1"}
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


        input from value(sInputFileName).
        output to  value(sOutputFileName).
        batchrun = yes.
        {gprun.i ""sosois.p""}
        batchrun = no.
        input close.
        output close.

        find first tr_hist
            where tr_trnbr > iTrSeq
                and tr_type = "ISS-SO"
                and tr_site = sSite
                and tr_loc = sLoc
                and tr_part = sPart
                and tr_serial = t1_lot
                and tr_nbr = sSo
                and tr_line = iLn
            use-index tr_trnbr
            no-error.
        if available(tr_hist) then do:
            assign
                iTrSeq = tr_trnbr
                .
        end.
        else do:
            bHasError = yes.
            os-copy value(sOutputFileName) value(sOutputFileName + ".err.log").
            {pxmsg.i &msgnum=9020 &msgarg=t1_lot &errorlevel=3}
            undo bc-so-iss-lp, leave bc-so-iss-lp.
        end.
    end.
end.


os-delete value(sInputFileName).
os-delete value(sOutputFileName).


