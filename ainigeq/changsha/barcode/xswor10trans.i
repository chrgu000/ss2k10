/* xswor02trans.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */



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
/* ����*     */  {xxputcimvariable.i ""quote"" """"  "at 1"}
/* ��        */  {xxputcimvariable.i ""quote"" s0020}
/* ��Ч����  */  {xxputcimvariable.i ""d"" ""-""}
/* ����*     */  {xxputcimvariable.i ""d"" 1 "at 1"}
/* ��λ      */  {xxputcimvariable.i ""d"" ""-""}
/* ����      */  {xxputcimvariable.i ""d"" ""-""}
/* ��Ʒ      */  {xxputcimvariable.i ""d"" ""-""}
/* ��λ      */  {xxputcimvariable.i ""d"" ""-""}
/* ����      */  {xxputcimvariable.i ""d"" ""-""}
/* �ص�      */  {xxputcimvariable.i ""quote"" s0010}
/* ��λ      */  {xxputcimvariable.i ""quote"" s0050}
/* ����      */  {xxputcimvariable.i ""quote"" """"}
/* �ο�      */  {xxputcimvariable.i ""quote"" """"}
/* ���¼    */  {xxputcimvariable.i ""d"" ""N""}
/* ��������  */  {xxputcimvariable.i ""d"" ""N""}
/* ��ע*     */  {xxputcimvariable.i ""quote"" mfguser "at 1"}
/* ����      */  {xxputcimvariable.i ""d"" ""N""}
/* ��ʾ��Ϣ* */  {xxputcimvariable.i ""d"" ""N"" "at 1"}
/* ȷ��*     */  {xxputcimvariable.i ""d"" ""Y"" "at 1"}
put "." at 1.
output close.

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

input from value(ciminputfile).
output to  value(cimoutputfile).
{gprun.i ""woworc.p""}
input close.
output close.

{xserrlg.i}
/*
os-delete value(ciminputfile).
os-delete value(cimoutputfile).
*/
