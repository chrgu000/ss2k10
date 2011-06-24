/* xswri10.p -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 090702.1 By: Kaine Zhang */

/* SS - 090702.1 - RNB
[090702.1]
�������,������׼�س�.
[090702.1]
SS - 090702.1 - RNE */

{xsbcvariable01.i}

define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
{xswri10deftemptable.i}

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xswri10wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

    
mainloop:
repeat:

    /* START  LINE :0010  �ص�[SITE]  */
    lp0010:
    repeat on endkey undo, retry:
        hide all.
        
        {xsvarform0010.i}
        
        {xsdefaultsite.i
            s0010_1
            s0010_2
        }
        
        s0010 = s0010_1.
        
        /* *ss_20090701* ���������� */
        sTitle = "[������׼�س�]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  �ص�[SITE]  */

    /* *ss_20090630* ����ID */
    {xswri100020.i}
    
        
    /* *ss_20090701* �����$����� --���� */
    {xswri100030.i}
    
    /* *ss_20090701* �����$����� --���� */
    {xswri100040.i}
    
    /* *ss_20090701* ��λ */
    {xswri100050.i}
    
    /* *ss_20090701* ���� */
    {xswri100060.i}
    
    /* *ss_20090701* ȷ�� */
    {xswri100070.i}
    
    /* *ss_20090701* cim���׹��� */
    {xswri10trans.i}
    
    /* *ss_20090701* ��ʾ������Ϣ */
    {xswri100080.i}
end.


