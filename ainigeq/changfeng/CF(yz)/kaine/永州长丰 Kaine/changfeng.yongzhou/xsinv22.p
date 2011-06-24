/* xsinv22.p -- */
/* Copyright 200906 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* UNPLANNED RECEIPT */
/* Revision: Version.ui    Modified: 06/30/2009   By: Kaine Zhang     Eco: *ss_20090630* */
/* SS - 090916.1 By: Kaine Zhang */

/* SS - 090916.1 - RNB
[090916.1]
�б���ʾ��ע˵��.
[090916.1]
SS - 090916.1 - E */

{xsbcvariable01.i}
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
/* SS - 090916.1 - B */
define variable j as integer .
define variable s1 as character extent 6 .
/* SS - 090916.1 - E */

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv22wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
repeat:

    /* START  LINE :0010  �ص�[SITE]  */
    lp0010:
    repeat on endkey undo, retry:
        hide all.
        define variable s0010           as character format "x(50)".
        define variable s0010_1           as character format "x(50)".
        define variable s0010_2           as character format "x(50)".
        define variable s0010_3           as character format "x(50)".
        define variable s0010_4           as character format "x(50)".
        define variable s0010_5           as character format "x(50)".
        
        form
            sTitle
            s0010_1
            s0010_2
            s0010_3
            s0010_4
            s0010_5
            s0010
            sMessage
        with frame f0010 no-labels no-box.
        
        {xsdefaultsite.i
            s0010_1
            s0010_2
        }
        
        s0010 = s0010_1.
        
        /* *ss_20090701* ���������� */
        sTitle = "[�ƻ������]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  �ص�[SITE]  */

    
    /* *ss_20090630* ��ע. ����.�ƻ���ԭ����� */
    {xsinv220020.i}
    
    /* *ss_20090701* �����$����� --����� */
    {xsinv220030.i}
    
    /* *ss_20090701* �����$����� --���� */
    {xsinv220040.i}
    
    /* *ss_20090701* ��λ */
    {xsinv220050.i}
    
    /* *ss_20090701* ���� */
    {xsinv220060.i}
    
    /* *ss_20090701* ȷ�� */
    {xsinv220070.i}
    
    /* *ss_20090701* cim���׹��� */
    {xsinv22trans.i}
    
    /* *ss_20090701* �Ƿ��ӡ���� */
    {xsinv220080.i}
                
end.


