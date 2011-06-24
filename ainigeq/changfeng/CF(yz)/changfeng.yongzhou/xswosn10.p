/* xswosn10.p -- */
/* Copyright 201003 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* SS - 100301.1 - RNB
[100301.1]
�����ӡ����,���Ʒ�����ӡ.
���뿪ʼ,��������,�ƻ�Ա,��wo_mstr,
[100301.1]
SS - 100301.1 - RNE */

{xsbcvariable01.i}

define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xswoi10wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
        sTitle = "[���Ʒ�����ӡ]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  �ص�[SITE]  */

    /*��ʼ����*/
    {xswosn100020.i}

    /*��������*/
    {xswosn100030.i}

    /*�ƻ�Ա*/
    {xswosn100040.i}

    /*ÿ�Ź�����ӡ��������*/
    {xswosn100050.i}

    /*��ӡ��*/
    {xswosn100060.i}

    for each pt_mstr where pt_buyer = s0040 no-lock ,
        each wo_mstr use-index wo_part_rel 
                     where wo_part  = pt_part 
                     and (wo_rel_date >= s0020 and wo_rel_date <= s0030)
                     no-lock :

        /*ʵ�ʴ�ӡ*/ 
        {xswosn100070.i}

    end.  /*for each pt_mstr*/

end. /*mainloop:*/


