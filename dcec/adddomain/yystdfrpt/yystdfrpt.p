/* xxstdfrpt.p  - Inventroy Physical Count Report                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1                 Developped: 06/30/01      BY: Rao Haobin          */
/* Rev: eb2+ sp7      Last Modified: 05/06/28      BY: judy Liu         */
/* 输出系统实盘差异报表，会按照零件号汇总（即不同库位上同样零件号会汇总到一行）*/

{mfdtitle.i "120816.1"}

def var qadinv_desc like pt_desc2.
def var qadinv_abc like pt_abc.
def var qadinv_prod_line like pt_prod_line.
def var qadinv_cst like sct_cst_tot format ">>>>>9.99".
def var qadinv_rcnt_qty like tag_rcnt_qty format ">>>>>9.99".
def var qadinv_qty like tag_rcnt_qty format ">>>>>9.99".
def var qadinv_tag_nbr like tag_nbr format ">>>>9".

define variable part like pt_part.
define variable part1 like pt_part.
define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable keeper like pt_article.
define variable keeper1 like pt_article.
define variable site like pt_site.
define variable site1 like pt_site.

def var qty_varience like tag_rcnt_qty format "->>>,>>>,>>9.99".
def var py_amount_varience like tag_rcnt_qty format "->>>,>>>,>>9.99".
def var pk_amount_varience like tag_rcnt_qty format "->>>,>>>,>>9.99".
def var item_amt_var like tag_rcnt_qty format "->>>,>>>,>>9.99" label "金额差异".

qty_varience=0.
py_amount_varience=0.
pk_amount_varience=0.
item_amt_var = 0.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
       site           colon 18
       site1          label {t001.i} colon 49
       line           colon 18
       line1          label {t001.i} colon 49
       part           colon 18
       part1          label {t001.i} colon 49 skip
       keeper            label "保管员" colon 18
       keeper1           label {t001.i} colon 49
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).


    /* REPORT BLOCK */


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

       if part1 = hi_char then part1 = "".
             if line1 = hi_char then line1 = "".
       if keeper1 = hi_char then keeper1 = "".
       if site1 = hi_char then site1 = "".

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


       bcdparm = "".

       {mfquoter.i part   }
       {mfquoter.i part1   }
       {mfquoter.i keeper   }
       {mfquoter.i keeper1   }
       {mfquoter.i site   }
       {mfquoter.i site1   }
       {mfquoter.i line   }
       {mfquoter.i line1   }

       if  part1 = "" then part1 = hi_char.
       if  line1 = "" then line1 = hi_char.
       if  keeper1 = "" then keeper1 = hi_char.
       if  site1 = "" then site1 = hi_char.
       /* SELECT PRINTER */

/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}

for each ld_det where ld_domain = global_domain and ld_qty_frz <> 0,
		each pt_mstr where ld_domain = global_domain
    and pt_part = ld_part
    and pt_prod_line >= line and pt_prod_line <= line1
    and pt_part <= part1 and pt_part >= part and pt_article >= keeper
    and pt_article <= keeper1 and pt_site >= site
    and pt_site <= site1 no-lock break by ld_part:
accumulate ld_qty_frz(total by ld_part).

if last-of(ld_part) then do:
qadinv_qty = accum total by ld_part ld_qty_frz.
qadinv_desc = pt_desc2.
find in_mstr where in_domain = global_domain
 and in_part = ld_part and in_site = pt_site no-lock no-error.
if available in_mstr then do:
qadinv_abc = in_abc.
{gpsct03.i &cost=sct_cst_tot}
qadinv_cst = glxcst.
end.
else do:
qadinv_abc= pt_abc.
qadinv_cst = 0.
end.

qadinv_prod_line = pt_prod_line.

qadinv_rcnt_qty= 0.
qadinv_tag_nbr = 0.

for each tag_mstr no-lock where tag_domain = global_domain
     and tag_part = ld_part break by tag_part:
        accumulate tag_rcnt_qty(total by tag_part).
        if last-of (tag_part) then do:
        qadinv_rcnt_qty= accum total by tag_part tag_rcnt_qty.
        qadinv_tag_nbr = tag_nbr.
        end.
end.

qty_varience = qty_varience + qadinv_rcnt_qty - qadinv_qty.
item_amt_var = (qadinv_rcnt_qty - qadinv_qty) * qadinv_cst.
if item_amt_var > 0 then do:
py_amount_varience = py_amount_varience + item_amt_var.
end.
else do:
pk_amount_varience = pk_amount_varience + item_amt_var.
end.

disp
/* qadinv_tag_nbr column-label "卡号" "  "
*/
    ld_part column-label "零件号" qadinv_desc column-label "零件名称"  qadinv_prod_line column-label "产品类"
    qadinv_abc column-label "ABC分类" accum total by ld_part ld_qty_frz column-label "帐面库存"
    qadinv_rcnt_qty column-label "盘点数量" qadinv_cst column-label "标准成本"
    item_amt_var column-label "金额差异" with  STREAM-IO width 200.
end.

end.

disp qty_varience column-label "数量差异" py_amount_varience column-label "盘赢金额差异"
     pk_amount_varience column-label "盘亏金额差异"
     py_amount_varience + pk_amount_varience FORMAT "->>>,>>>,>>9.9<<<" column-label "盘点金额差异" WITH STREAM-IO.


/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
/*{mfreset.i}*/
    {mfguitrl.i}
end procedure.



/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 keeper keeper1  "} /*Drive the Report*/



