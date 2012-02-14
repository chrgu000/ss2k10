/* xsinv22trans.i -- */
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
    + "inv22"
    .
    
assign
    ciminputfile = usection + ".i"
    cimoutputfile = usection + ".o"
    .
    
output to value(ciminputfile).
/* �����       */    {xxputcimvariable.i ""qq"" s0030 "at 1"}    
/* ����         */    {xxputcimvariable.i ""d"" dec0060 "at 1"}     
/* ������λ     */    {xxputcimvariable.i ""d"" ""-""}                
/* Conversion   */    {xxputcimvariable.i ""d"" ""-""}                
/* �ص�         */    {xxputcimvariable.i ""qq"" s0010}             
/* ��λ         */    {xxputcimvariable.i ""qq"" s0050}             
/* ��/��        */    {xxputcimvariable.i ""qq"" s0040}             
/* �ο�         */    {xxputcimvariable.i ""d"" ""-""}                
/* ���¼       */    {xxputcimvariable.i ""d"" ""-""}
/* ����         */    {xxputcimvariable.i ""d"" ""-"" "at 1"}         
/* ��           */    {xxputcimvariable.i ""d"" ""-""}                
/* �ͻ���/����  */    {xxputcimvariable.i ""d"" ""-""}                
/* ��ַ         */    {xxputcimvariable.i ""d"" ""-""}                
/* ��ע         */    {xxputcimvariable.i ""qq"" s0020}             
/* ��Ч����     */    {xxputcimvariable.i ""d"" ""-""}                
/* �����ʻ�     */    {xxputcimvariable.i ""d"" ""-""}                
/* �ӿ�Ŀ       */    {xxputcimvariable.i ""d"" ""-""}                
/* �ɱ�����     */    {xxputcimvariable.i ""d"" ""-""}                
/* ��Ŀ         */    {xxputcimvariable.i ""d"" ""-""}
/* ȷ��         */    {xxputcimvariable.i ""d"" ""Y"" "at 1"}
put "." at 1.

output close.

find last tr_hist use-index tr_trnbr.
iTrSeq = if available tr_hist then tr_trnbr else 0.

input from value(ciminputfile).
output to  value(cimoutputfile).
{gprun.i ""icunrc.p""}
input close.
output close.

{xserrlg.i}

os-delete value(ciminputfile).
os-delete value(cimoutputfile).