/* xssoiss10trans.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */



run pxgblmgr.p persistent set global_gblmgr_handle.



usection = string(year(TODAY), "9999")
    + string(MONTH(TODAY), "99")
    + string(DAY(TODAY), "99")
    + STRING(TIME, "99999")
    + string(RANDOM(0, 99), "99")
    + "wor02"
    .

assign
    ciminputfile = usection + ".i"
    cimoutputfile = usection + ".o"
    .

output to value(ciminputfile).
/* ����*        */    {xxputcimvariable.i ""quote"" s0020 "at 1"}
/* ��Ч����     */    {xxputcimvariable.i ""d"" ""-""}
/* ������       */    {xxputcimvariable.i ""d"" ""N""}
/* ������       */    {xxputcimvariable.i ""d"" ""N""}
/* �ص�         */    {xxputcimvariable.i ""quote"" s0010}
/* ��*          */    {xxputcimvariable.i ""d"" i0060 "at 1"}
/* ȡ��Ƿ��     */    {xxputcimvariable.i ""d"" ""N""}
/* ����*        */    {xxputcimvariable.i ""d"" 1 "at 1"}
/* �ص�         */    {xxputcimvariable.i ""quote"" s0010}
/* ��λ         */    {xxputcimvariable.i ""quote"" s0050}
/* ����         */    {xxputcimvariable.i ""quote"" """"}
/* �ο�         */    {xxputcimvariable.i ""quote"" """"}
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

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

input from value(ciminputfile).
output to  value(cimoutputfile).
{gprun.i ""sosois.p""}
input close.
output close.

{xserrlg.i}
/*
os-delete value(ciminputfile).
os-delete value(cimoutputfile).
*/
