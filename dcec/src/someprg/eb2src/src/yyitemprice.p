/* xxitemprice.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/14/01      BY: Kang Jian          */
/* Rev: eb2+ sp7      Last Modified: 05/07/07      BY: judy Liu         */

{mfdtitle.i}
define var part like pc_part.
/*set part label "零件号".*/
define var line as integer.
define var pageno as integer.
define var prod_line_from like pt_prod_line label "产品类".
define var prod_line_to like pt_prod_line label "至".
define var part_from like pt_part label "零件号" .
define var part_to like pt_part label "至" .

define var bac_start_date as date.
define var bac_end_date as date.
define var bac_price like pc_min_price.
define var bac_list1 like pc_list. /*记录前一供应商价格单*/
define var bac_part like pc_part.

define var cur_start_date as date.
define var cur_end_date as date.
define var cur_price like pc_min_price.
define var cur_list1 like pc_list. /*记录本供应商最后生效日期价格单*/
define var cur_part like pc_part.

define var start_date as date.
define var end_date as date.
define var price like pc_min_price.
define var list1 like pc_list.

/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)  
   prod_line_from  colon 10
   prod_line_to  colon 40 skip
   part_from  colon 10
   part_to  colon 40 skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title = " 选择条件 ".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME	  
/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).


{mfguirpa.i true  "printer" 132 }
procedure p-enable-ui:
   if prod_line_to = hi_char  then prod_line_to = "". 
   if part_to = hi_char  then part_to = "". 
     
   run p-action-fields (input "display").
   run p-action-fields (input "enable").
end procedure. 
procedure p-report-quote:
   bcdparm = "".
   {mfquoter.i prod_line_from} 
   {mfquoter.i prod_line_to} 
   {mfquoter.i part_from} 
   {mfquoter.i part_to} 
   if prod_line_to   = ""  then prod_line_to = hi_char. 
   if part_to     = ""  then part_to = hi_char. 
end procedure. 

procedure p-report:
{gpprtrpa.i  "window" 132}                               
line = 1.
pageno = 1.

start_date = date(01,01,1990).
list1 = "".
cur_start_date = date(01,01,1990).
cur_list1 = "".
start_date = date(01,01,1990).
bac_list1 = "".
for each pt_mstr where (pt_prod_line <= prod_line_to)
                 and (pt_prod_line >= prod_line_from )
                 and (pt_part <= part_to)
                 and (pt_part >= part_from)
   use-index pt_part no-lock :                              
   for each pc_mstr where pc_part = pt_part
       use-index pc_list no-lock 
       break by pc_list:
       if pc_start > start_date then do:
            start_date = pc_start.
            price = pc_amt[1].
            end_date = pc_expire.
            list1 = pc_list.
            part = pc_part.
       end.
       if last-of(pc_list) then do:    
          if line = 1 then do:
              display "按照零件号排序的零件价格单报表" at 40 with width 132 stream-io .
              down 1.
              display "价格单类型  零件号                价格单号              价格  起始日期  终止日期 " with width 250 no-box frame e.
              display "------------------------------------------------------------------------------------------ " with width 250 no-box frame e1.
              line = line + 2.
          end.
          if ((substr(list1,8,1)) >= "0" and (substr(list1,8,1)) <= "9" ) then do:
            if cur_list1 = "" then do:
                 cur_part = part.
                 cur_list1 = list1.
                 cur_price = price.
                 cur_end_date = end_date.
                 cur_start_date = start_date.
            end.
            if (substr(cur_list1,1,6) = substr(list1,1,6)) 
                 and (integer(substr(list1,8,1)) > integer(substr(cur_list1,8,1))) then do:
                 cur_part = part.
                 cur_list1 = list1.
                 cur_price = price.
                 cur_end_date = end_date.
                 cur_start_date = start_date.            
            end.
            if substr(cur_list1,1,6) <> substr(list1,1,6) then do:            
                 display "            " cur_part cur_list1 cur_price "  " cur_start_date cur_end_date with width 250 no-box no-labels frame f1.            
                 line = line + 1.
                 cur_part = part.
                 cur_list1 = list1.
                 cur_price = price.
                 cur_end_date = end_date.
                 cur_start_date = start_date.            
            end.
          end.
          else do:             
               if (substr(list1,8,1)) ="Y"  then display "意向价格单  " part list1 price "  " start_date end_date with width 250 no-box no-labels frame d1.
               if (substr(list1,8,1)) ="L"  then display "临时价格单  " part list1 price "  " start_date end_date with width 250 no-box no-labels frame d2.
               if (substr(list1,8,1)) <>"Y" and (substr(list1,8,1)) <>"L" then display "不合法价单  " part list1 price "  " start_date end_date with width 250 no-box no-labels frame d3.
               line = line + 2.
          end.
          start_date = date(01,01,1990).
       end. 
   end.   
   if line = 1 then do:
       display "价格单类型  零件号                价格单号              价格  起始日期  终止日期 " with width 250 no-box frame b.
       display "------------------------------------------------------------------------------------------ " with width 250 no-box frame b1.
       line = line + 2.
   end.
   if ((substr(list1,8,1)) > "0" or (substr(list1,8,1)) < "9" ) then do:
       display "            " cur_part cur_list1 cur_price "  " cur_start_date cur_end_date with width 250 no-box no-labels frame f2.
       line = line + 1.
   end.
   if line-counter >= (page-size - 4) then do:
       display "-------------------------------------本页结束--------------------------------------------- " with width 250 no-box frame e2.
       display "页号: " pageno with width 250 no-box frame e3.
       pageno = pageno + 1.
       page.
       line = 1.
   end. 
   cur_list1 = "".
   list1 = "".
   cur_start_date = date(01,01,1990).
   start_date = date(01,01,1990).
end.
{mfgrptrm.i}
    /* reset variable */
{mfreset.i}
end. /*end of the procedure*/
{mfguirpb.i &flds="prod_line_from prod_line_to part_from part_to "}


