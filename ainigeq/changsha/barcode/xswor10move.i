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
/* ����                 */    {xxputcimvariable.i ""quote"" sAssemblePart  "at 1"}    
/* ����                 */    {xxputcimvariable.i ""d"" 1 "at 1"}     
/* ��Ч����             */    {xxputcimvariable.i ""d"" ""-""}                
/* ����                 */    {xxputcimvariable.i ""quote"" mfguser}                
/* �ͻ���               */    {xxputcimvariable.i ""d"" ""-""}             
/* ��ע                 */    {xxputcimvariable.i ""d"" ""-""}             
/* ת�Ʊ��Ͽ��         */    {xxputcimvariable.i ""d"" ""-""   "at 1"}             
/* ���״̬��ͻ(��/��)  */    {xxputcimvariable.i ""d"" ""-""}                
/* ʹ��ȱʡ״̬         */    {xxputcimvariable.i ""d"" ""-""}
/* �µ�״̬             */    {xxputcimvariable.i ""d"" ""-""}         
/* from�ص�             */    {xxputcimvariable.i ""quote"" s0010  "at 1"}                
/* from��λ             */    {xxputcimvariable.i ""quote"" s0050}                
/* from����             */    {xxputcimvariable.i ""quote"" """"}                
/* from�ο�             */    {xxputcimvariable.i ""d"" ""-""}             
/* to�ص�               */    {xxputcimvariable.i ""quote"" s0010  "at 1"}                
/* to��λ               */    {xxputcimvariable.i ""quote"" s0060}                
/* to����               */    {xxputcimvariable.i ""quote"" """"}                
/* to�ο�               */    {xxputcimvariable.i ""d"" ""-""}                
/* ȷ��                 */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
put "." at 1.
output close.

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

input from value(ciminputfile).
output to  value(cimoutputfile).
{gprun.i ""iclotr04.p""}
input close.
output close.

/* {xserrlg.i} */
/*
os-delete value(ciminputfile).
os-delete value(cimoutputfile).
*/
