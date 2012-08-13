/* xxlbalrp.p  - Labor Allocation Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1                 Developped: 30/01/02      BY: Rao Haobin          */


{mfdtitle.i } 

define variable site like pt_site.
define variable part like pt_part.
define variable part1 like pt_part.
define variable line like tr_prod_line.
define variable line1 like tr_prod_line.
define variable date like tr_effdate.
define variable date1 like tr_effdate.
define variable labor_rate as decimal format "->,>>>,>>>,>>9.99" label "�˹�����".
define variable cost_set like spt_sim label "�ɱ���".
define variable labor_cost like spt_cst_tl format "->,>>>,>>>,>>9.99" column-label "��׼�˹�(��̨)".
define variable expense_cost like spt_cst_tl format "->,>>>,>>>,>>9.99" column-label "��ӷ���(��̨)".
define variable sum_qty_comp1 like wo_qty_comp  format "->,>>>,>>9" label "�����깤�����ϼ�" initial 0.
define variable sum_qty_comp2 like wo_qty_comp  format "->,>>>,>>9" label "�����깤�����ϼ�" initial 0.
define variable sum_qty_comp3 like wo_qty_comp  format "->,>>>,>>9" label "���Ƴ��������ϼ�" initial 0.
define variable sum_labor as decimal format "->,>>>,>>>,>>9.99" label "�˹��ϼ�".
define variable sum_expense as decimal format "->,>>>,>>>,>>9.99" label "���úϼ�".

define workfile wo_sum field ws_part like wo_part
                        /* ws_qty_comp1 �洢�ճ��Ų��깤���� */
                        field ws_qty_comp1 like wo_qty_comp  label "�����깤����"
                        /* ws_qty_comp2 �洢����iss_wo������������ */
                        field ws_qty_comp2 like wo_qty_comp  label "�����깤����"
                        field ws_qty_comp3 like wo_qty_comp label "���Ƴ���".
                        

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     site           colon 18
	     skip
	     line 	    colon 18
	     line1          label {t001.i} colon 49 skip
	     part           colon 18
	     part1          label {t001.i} colon 49 skip
             date            colon 18
             date1           label {t001.i} colon 49 skip
             labor_rate      colon 18 skip
             cost_set	     colon 18
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " ѡ������ ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame a:handle).

	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if part1 = hi_char then part1 = "".
	     if date = low_date then date = ?.
	     if date1 = hi_date then date1 = ?.
	     if line1 = hi_char then line1 = "".
	     labor_rate = 0.
	     cost_set="".
	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i part   }
	     {mfquoter.i part1   }
	     {mfquoter.i date   }
	     {mfquoter.i date1   }
	     {mfquoter.i site   }
	     {mfquoter.i line   }
	     {mfquoter.i line1   }
	     {mfquoter.i labor_rate   }
	     {mfquoter.i cost_set  }
	     
	     if  part1 = "" then part1 = hi_char.
	     if  line1 = "" then line1 = hi_char.
	     if  date = ? then date = low_date.
	     if  date1 = ? then date1 = hi_date.
	     /* if labor_rate = 0 then . */
	     
	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}


for each tr_hist no-lock where tr_type = "rct-wo"  and tr_effdate >= date and tr_effdate <= date1 and tr_prod_line >= line and tr_prod_line <= line1
    /*cj*/ AND tr_part >= part AND tr_part <= part1 USE-INDEX tr_eff_trnbr :
find first wo_sum where ws_part = tr_part no-error.
if not available wo_sum then do:
create wo_sum.
ws_part = tr_part.
end.

if tr_nbr <> "" then do:
ws_qty_comp2 = ws_qty_comp2 + tr_qty_loc.
end.
else do: 
ws_qty_comp1 = ws_qty_comp1 + tr_qty_loc.
end.
end.

for each tr_hist no-lock where (tr_type = "iss-wo") and tr_effdate >= date and tr_effdate <= date1 and tr_prod_line >= line and tr_prod_line <= line1
    /*cj*/ AND tr_part >= part AND tr_part <= part1 USE-INDEX tr_eff_trnbr :
find first wo_sum where ws_part = tr_part no-error.
if not available wo_sum then do:
create wo_sum.
ws_part = tr_part.
end.
ws_qty_comp3 = ws_qty_comp3 + tr_qty_loc.
end.

    for each wo_sum 
    , each pt_mstr where pt_part = ws_part
    , each pl_mstr where pl_prod_line = pt_prod_line BREAK by pl_prod_line:
        if pl_prod_line >= line and pl_prod_line <= line1 and ws_part >= part and ws_part <= part1 then do:
        find spt_det where spt_site = site and spt_sim = cost_set and spt_element = "ֱ���˹�" and spt_part = ws_part no-lock no-error.
        if available spt_det then do:
          labor_cost = round(spt_cst_tl,2).
        end.
        else do:
          labor_cost= 0.
        end.
        
        find spt_det where spt_site = site and spt_sim = cost_set and spt_element = "����" and spt_part = ws_part no-lock no-error.
        if available spt_det then do:
          expense_cost = round(spt_cst_tl,2).
        end.
        else do:
           expense_cost = 0.
        end.
        
        disp ws_part pt_desc2 pl_prod_line pl_desc ws_qty_comp1 ws_qty_comp2 ws_qty_comp1 + ws_qty_comp2 format "->>,>>9" column-label "  �깤�ܼ� " 
            labor_cost / labor_rate format "->,>>>,>>>,>>9.99" column-label "��׼��̨��ʱ" labor_cost / labor_rate * (ws_qty_comp1 + ws_qty_comp2) format "->,>>>,>>>,>>9.99" column-label "��׼��ʱ" 
            labor_cost  labor_cost * (ws_qty_comp1 + ws_qty_comp2) format "->,>>>,>>>,>>9.99" column-label "��׼�˹�" 
            expense_cost expense_cost * (ws_qty_comp1 + ws_qty_comp2) format "->,>>>,>>>,>>9.99" column-label "��ӷ���" 
            (labor_cost + expense_cost) * (ws_qty_comp1 + ws_qty_comp2) format "->,>>>,>>>,>>9.99" column-label "    �ϼ�    " 
             with width 256 STREAM-IO.
        
        sum_qty_comp1 = sum_qty_comp1 + ws_qty_comp1.
        sum_qty_comp2 = sum_qty_comp2 + ws_qty_comp2.
        sum_qty_comp3 = sum_qty_comp3 + ws_qty_comp3.
        sum_labor = sum_labor + labor_cost * (ws_qty_comp1 + ws_qty_comp2).
        sum_expense = sum_expense + expense_cost * (ws_qty_comp1 + ws_qty_comp2).
        
/*judy 07/05/05*/         IF LAST(pl_prod_line) THEN DO:
/*judy 07/05/05*/             display sum_qty_comp1 sum_qty_comp2 sum_labor sum_expense sum_labor + sum_expense format "->,>>>,>>>,>>9.99" column-label "    �ϼ�    " with width 132 STREAM-IO FRAME cc.
/*judy 07/05/05*/         END.
    
    end.

end.

  /*judy 07/05/05*/  /*display sum_qty_comp1 sum_qty_comp2 sum_labor sum_expense sum_labor + sum_expense format "->,>>>,>>>,>>9.99" column-label "    �ϼ�    " with width 132 */
{mfguitrl.i}


for each wo_sum no-lock:
delete wo_sum.
end.

{mfreset.i} 
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end procedure.



/*GUI*/ {mfguirpb.i &flds=" site line line1 part part1 date date1 labor_rate cost_set"} /*Drive the Report*/


