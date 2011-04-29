/* xxqmbkmt01.i 海关海关手册维护                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/30/2008   BY: Softspeed tommy xie         */

/*
         define {&new} shared frame f-1.
*/
         form
            skip(.4)
            xxcbk_bk_nbr   colon 11   label "手册编号"
            xxcbk_list_nbr colon 42   label "进/出口计划清单号"  /* "产生方式" "1-海关计划,2-客户订单", 3-预测" */

            xxcbk_end_date colon 68   label "有效日期"
            skip
            xxcbk_comp     colon 11   label "经营单位"
            xxcbk_fm_loc   colon 38   label "起抵地" space(0)
            xxctry_name    format "x(8)" no-label
            xxcbk_trade    colon 62   label "贸易方式"
            xxctra_desc1   format "x(8)" no-label
            skip
            xxcbk_dept     colon 11   label "进口口岸"
            xxdept_desc    format "x(8)" no-label
            xxcbk_stat     colon 38   label "状态"
            xxcbk_tax_mtd  colon 62   label "征免性质"
            xxctax_desc1   format "x(9)" no-label
            skip
            xxcbk_doc      colon 11   label "批文号"
            /*xxcbk_cust     colon 38   label "客户"*/
            xxcbk_imp_amt  colon 62   label "进口总值"
            skip
            xxcbk_contract colon 11   label "合同号"
            xxcbk_cur      colon 38   label "货币"
            xxcbk_exp_amt  colon 62   label "出口总值"
            skip
         with frame f-1 three-d side-labels width 80. 


