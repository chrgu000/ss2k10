/*  yycost.p - 发动机成本对比报表                           */
/* REVISION: eB2    LAST MODIFIED: 09/09/07 BY: * Jack Huang *       */

         define  SHARED variable part like pt_part label "机型".
         define  SHARED variable start1 as date label "开始日期".
         define  SHARED variable end1 like start1.
         define  SHARED variable start2 like start1.
         define  SHARED variable end2 like end1.

         define  SHARED variable start3 like start1.
         define  SHARED variable end3   like end1.

         define  SHARED variable site like si_site label "地点".
         define  SHARED variable selection_yn as logic label "是否选择全部".
         define  SHARED variable outfile# as char label "输出文件" format 
"x(60)".
         define  SHARED variable timeline as int.

         /* exp */
         define  SHARED variable part_qty1 as deci init 0.
         define  SHARED variable part_qty2 like part_qty1.
         define  SHARED variable comp_avg_cost1 like sct_cst_tot.
         define  SHARED variable comp_avg_cost2 like sct_cst_tot.
         define  SHARED variable comp_amt1 as deci.
         define  SHARED variable comp_amt2 like comp_amt1.
         define  SHARED variable diff_qty like part_qty1.

         /* total var */
         define SHARED variable tlt_qty1 as deci init 0.
         define SHARED variable  tlt_qty2 like tlt_qty1.
         define SHARED variable  tlt_qty3 like tlt_qty1.
         define SHARED variable  tlt_qty4 like tlt_qty1.
         define SHARED variable  tlt_qty5 like tlt_qty1.
         define SHARED variable  tlt_qty6 like tlt_qty1.
         define SHARED variable  tlt_qty7 like tlt_qty1.



         define SHARED temp-table wocomp
               field  wocomp_id    like tr_lot
               field  wocomp_comp  like tr_part
               field  wocomp_qty1   like tr_qty_chg
               field  wocomp_qty2   like tr_qty_chg
               field  wocomp_cost   like sct_cst_tot
               /* field  wocomp_timeline like timeline  */
         .



      for each wocomp break by wocomp_comp with frame rpt-frame width 156 
STREAM-IO:

          assign
              comp_avg_cost1 = if part_qty1 <> 0 then ((wocomp_qty1 * 
wocomp_cost ) / part_qty1 ) else 0
              comp_avg_cost2 =  if part_qty2 <> 0 then ((wocomp_qty2 * 
wocomp_cost ) / part_qty2) else 0
              comp_amt1      = comp_avg_cost1 * wocomp_qty1
              comp_amt2      = comp_avg_cost2 * wocomp_qty2
              diff_qty = comp_amt1 - comp_amt2
              .
           if diff_qty = 0 and (selection_yn  = no) then next.
          disp
                wocomp_comp           Column-label "零件号"
               wocomp_qty1          Column-label "{1}"  format 
"->>,>>>,>>>,>>9.99"
               comp_avg_cost1       Column-label "平均成本"   format 
"->>,>>>,>>>,>>9.99"
               comp_amt1            Column-label  "金额"        format 
"->>,>>>,>>>,>>9.99"
               wocomp_qty2          Column-label  "{2}"       format 
"->>,>>>,>>>,>>9.99"
               comp_avg_cost2       Column-label "平均成本"     format 
"->>,>>>,>>>,>>9.99"
               comp_amt2            Column-label  "金额"    format 
"->>,>>>,>>>,>>9.99"
               diff_qty             Column-label  "差异"     format 
"->>,>>>,>>>,>>9.99"


               with frame rpt-frame .

                /* down 1 with frame rpt-frame.   */
          assign
             tlt_qty1 =  tlt_qty1 + wocomp_qty1
             tlt_qty2 = tlt_qty2 + comp_avg_cost1
             tlt_qty3 = tlt_qty3 + comp_amt1
             tlt_qty4 = tlt_qty4 + wocomp_qty2
             tlt_qty5 = tlt_qty5 + comp_avg_cost2
             tlt_qty6 = tlt_qty6 + comp_amt2
             tlt_qty7 = tlt_qty7 + diff_qty
      .

      end.





        put
           "       ----------- ------------------ ------------------ 
------------------ ------------------ ------------------ ------------------ 
------------------"
            skip
            "合计"     to 18
            /*
           tlt_qty1 format "->>,>>>,>>>,>>9.99" to 33
           tlt_qty2     format "->>,>>>,>>>,>>9.99" to  48
           tlt_qty3    format "->>,>>>,>>>,>>9.99" to    63
           tlt_qty4    format "->>,>>>,>>>,>>9.99" to    78
           tlt_qty5    format "->>,>>>,>>>,>>9.99" to    93
           tlt_qty6    format "->>,>>>,>>>,>>9.99" to    108
           tlt_qty7    format "->>,>>>,>>>,>>9.99" to    123

           */

           space(1)
           tlt_qty1    format "->>,>>>,>>>,>>9.99"
           space(1)
           tlt_qty2    format "->>,>>>,>>>,>>9.99"
           space(1)
           tlt_qty3    format "->>,>>>,>>>,>>9.99"
           space(1)
           tlt_qty4    format "->>,>>>,>>>,>>9.99"
           space(1)
           tlt_qty5    format "->>,>>>,>>>,>>9.99"
           space(1)
           tlt_qty6    format "->>,>>>,>>>,>>9.99"
           space(1)
           tlt_qty7    format "->>,>>>,>>>,>>9.99"


           skip.


