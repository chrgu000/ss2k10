/* xxqmbkmt01.i ���غ����ֲ�ά��                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/30/2008   BY: Softspeed tommy xie         */

/*
         define {&new} shared frame f-1.
*/
         form
            skip(.4)
            xxcbk_bk_nbr   colon 11   label "�ֲ���"
            xxcbk_list_nbr colon 42   label "��/���ڼƻ��嵥��"  /* "������ʽ" "1-���ؼƻ�,2-�ͻ�����", 3-Ԥ��" */

            xxcbk_end_date colon 68   label "��Ч����"
            skip
            xxcbk_comp     colon 11   label "��Ӫ��λ"
            xxcbk_fm_loc   colon 38   label "��ֵ�" space(0)
            xxctry_name    format "x(8)" no-label
            xxcbk_trade    colon 62   label "ó�׷�ʽ"
            xxctra_desc1   format "x(8)" no-label
            skip
            xxcbk_dept     colon 11   label "���ڿڰ�"
            xxdept_desc    format "x(8)" no-label
            xxcbk_stat     colon 38   label "״̬"
            xxcbk_tax_mtd  colon 62   label "��������"
            xxctax_desc1   format "x(9)" no-label
            skip
            xxcbk_doc      colon 11   label "���ĺ�"
            /*xxcbk_cust     colon 38   label "�ͻ�"*/
            xxcbk_imp_amt  colon 62   label "������ֵ"
            skip
            xxcbk_contract colon 11   label "��ͬ��"
            xxcbk_cur      colon 38   label "����"
            xxcbk_exp_amt  colon 62   label "������ֵ"
            skip
         with frame f-1 three-d side-labels width 80. 


