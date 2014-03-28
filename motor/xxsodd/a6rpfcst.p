/* woworp.p - WORK ORDER REPORT                                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                         */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0     LAST MODIFIED: 04/15/86    BY: pml                       */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                       */
/* REVISION: 2.1     LAST MODIFIED: 10/19/87    BY: wug *A94*                 */
/* REVISION: 2.1     LAST MODIFIED: 12/29/87    BY: emb                       */
/* REVISION: 4.0     LAST MODIFIED: 02/16/88    BY: flm *A175*                */
/* REVISION: 4.0     LAST MODIFIED: 03/23/88    BY: rl  *A171*                */
/* REVISION: 5.0     LAST MODIFIED: 04/10/89    BY: mlb *B096*                */
/* REVISION: 5.0     LAST MODIFIED: 10/26/89    BY: emb *B357*                */
/* REVISION: 5.0     LAST MODIFIED: 01/24/90    BY: ftb *B531*                */
/* REVISION: 5.0     LAST MODIFIED: 02/13/91    BY: emb *B893*                */
/* REVISION: 6.0     LAST MODIFIED: 01/22/91    BY: bjb *D248*                */
/* REVISION: 7.3     LAST MODIFIED: 11/19/92    BY: jcd *G348*                */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*                */
/* REVISION: 7.3     LAST MODIFIED: 09/23/94    BY: cpp *FQ88*                */
/* REVISION: 7.5     LAST MODIFIED: 10/07/94    BY: TAF *J035*                */
/* REVISION: 7.4     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 8.6     LAST MODIFIED: 10/13/97    BY: ays *K0WH*                */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 01/21/99    BY: *M066* Patti Gaultney     */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown         */
/* REVISION: 9.1     LAST MODIFIED: 11/06/00    BY: *N0TN* Jean Miller        */
/* Revision: 1.13       BY: Jyoti Thatte        DATE: 04/03/01 ECO: *P008*    */
/* $Revision: 1.16 $    BY: Vivek Gogte         DATE: 04/30/01 ECO: *P001*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

define variable v_year      like a6fcs_year.
define variable v_week      like a6fcd_week.
define variable v_week1     like a6fcd_week.
define variable v_part1      like a6fcs_part label "机型".
define variable v_part2     like a6fcs_part.
define variable v_part3     like a6fcs_part.
define variable v_part4     like a6fcs_part.
define variable v_site      like a6fcs_site.
define variable v_site1     like a6fcs_site.
/*
   define variable.
*/

form
   v_year      colon 15 label "年" skip
   v_week      label "周" colon 15   
   v_week1     label {t001.i} colon 49 skip
   v_site        colon 15
   v_site1       label {t001.i} colon 49 skip
   v_part1        label "机型" colon 15
   v_part2       label {t001.i} colon 49 skip
   v_part3       label "材料"  colon 15
   v_part4       label  {t001.i} colon 49 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat on error undo, retry:
   v_year=year(today).
   if v_week1 = 0 then v_week1 = 52.
   if v_site1 = hi_char then v_site1 = "".
   if v_part2 = hi_char then v_part2 = "".
   if v_part4 = hi_char then v_part4 = "".
   if c-application-mode <> "WEB" then
   update
      v_year    
      v_week   v_week1
      v_site   v_site1
      v_part1   v_part2
      v_part3  v_part4  
   with frame a.

   {wbrp06.i &command = update &fields = "  v_year v_week v_week1 v_site v_site1 v_part1 v_part2
         v_part3 v_part4"
         &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i v_year  }
      {mfquoter.i v_week  }
      {mfquoter.i v_week1 }
      {mfquoter.i v_site    }
      {mfquoter.i v_site1   }
      {mfquoter.i v_part1    }
      {mfquoter.i v_part2   }
      {mfquoter.i v_part3   }
      {mfquoter.i v_part4   } 
      
      if v_week1 = 0 then v_week1 = 52.
      if v_site1 = "" then v_site1 = hi_char.
      if v_part2 = "" then v_part2 = hi_char.
      if v_part4 = "" then v_part4 = hi_char.


   end.

   /* SELECT PRINTER */
   {gpselout.i
       &printType = "printer"
       &printWidth = 132
       &pagedFlag = " "
       &stream = " "
       &appendToFile = " "
       &streamedOutputToTerminal = " "
       &withBatchOption = "yes"
       &displayStatementType = 1
       &withCancelMessage = "yes"
       &pageBottomMargin = 6
       &withEmail = "yes"
       &withWinprint = "yes"
       &defineVariables = "yes"}

   {mfphead.i}

   /* FIND AND DISPLAY */
   for each a6fcs_sum where a6fcs_domain = global_domain AND a6fcs_year = v_year and a6fcs_site >= v_site and a6fcs_site <=v_site1 
   and a6fcs_part >= v_part1 and a6fcs_part <= v_part2
   no-lock
   ,each a6fcd_det WHERE a6fcd_domain = global_domain AND  a6fcd_year=a6fcs_year and
     a6fcd_part=a6fcs_part and a6fcd_site=a6fcs_site and a6fcd_week>=v_week and a6fcd_week <= v_week1 
     and a6fcd_pur_part >= v_part3 and a6fcd_pur_part <= v_part4
     no-lock:
        disp a6fcs_year COLUMN-LABEL "年度"  
             a6fcd_week COLUMN-LABEL "周"
             a6fcs_site COLUMN-LABEL "地点"
             a6fcs_part COLUMN-LABEL "零件"
  a6fcs_fcst_qty[a6fcd_week] COLUMN-LABEL "预测数量" 
	a6fcs_sold_qty[a6fcd_week] COLUMN-LABEL "销售抵冲数量"
	(a6fcs_fcst_qty[a6fcd_week] - a6fcs_sold_qty[a6fcd_week]) COLUMN-LABEL "成品净需求"
	            a6fcd_pur_part COLUMN-LABEL "采购物料"
 	            a6fcd_pur_qty  COLUMN-LABEL "预测数量"
INT(a6fcd_pur_qty * a6fcs_sold_qty[a6fcd_week] / a6fcs_fcst_qty[a6fcd_week] ) COLUMN-LABEL "销售抵冲数量"
	INT(a6fcd_pur_qty * (1 - a6fcs_sold_qty[a6fcd_week] / a6fcs_fcst_qty[a6fcd_week])) COLUMN-LABEL  "备料净需求"
	with STREAM-IO  width 133.
   end.


   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
