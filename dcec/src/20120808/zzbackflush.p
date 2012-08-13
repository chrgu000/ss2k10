/* xxTransfer.p Item transfer report                   */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1   Developped: 03/28/01   BY: Zhang weihua */

 
/* 反映库存转移量的报表 */

{mfdtitle.i } 
def var flushdate like tr_effdate . /*format "99/99/9999".*/
def var flushdate1 like tr_effdate. /* format "99/99/9999".*/
def var effdate  like tr_effdate.  /* format "99/99/9999".*/
def var effdate1 like tr_effdate.  /*format "99/99/9999".*/
def var site like tr_site .
def var bktotal as integer .
def var bkall as integer.


    
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     flushdate           label "回冲操作的时间"colon 18
	     flushdate1          label {t001.i} colon 49 skip
	     effdate             label "生效日期"colon 18
	     effdate1            label {t001.i} colon 49 skip

	     site                label "地点"  colon 18 
	              
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
	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }  /*该包含文件非常重要，若没有该包含文件，则系统会出错，该文件的作用是启用输出的选项和功能 */

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if site  = hi_char then site = "".
	     if effdate = low_date then effdate = ?.
	     if effdate1 = hi_date then effdate1 = ?.
      	     if flushdate = low_date then flushdate = ?.
	     if flushdate1 = hi_date then flushdate1 = ?.


	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:  /*用来对输入的变量进行有效性检测*/


          /*  {mfquoter.i keeper   }*/
	     {mfquoter.i site  }
     	     {mfquoter.i flushdate    }
     	     {mfquoter.i flushdate1   }
     	     {mfquoter.i effdate  }
     	     {mfquoter.i effdate1 }
	     if  site = "" then site = hi_char.
	     if  effdate =? then effdate  = low_date.
	     if  effdate1=? then effdate1 = hi_date.
	     if  flushdate =? then flushdate  = low_date.
	     if  flushdate1=? then flushdate1 = hi_date.

	     

	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:
        {gpprtrpa.i "printer" 132}/*-------该包含文件与该国成结束前的mfgrptrm.i文件配合使用，可将信息输入到windows*/
                /*{mfphead.i}. */   /*该包含文件是否用来显示一些固有的表头格式信息的，例如菜单名称，页号。对于要显示页号的可使用次包含文件*/
   bktotal =0.
            bkall =0.
            FOR EACH tr_hist  where (tr_date >= flushdate and tr_date <= flushdate1) and (tr_effdate >= effdate and tr_date <= effdate1) and tr_type ="rct-wo"  and tr_userid ="MRP"  and tr_site = site  break by tr_part :
                bktotal = bktotal + tr_qty_loc.
                if last-of(tr_part) then  do:
                    find pt_mstr no-lock where pt_part = tr_part and pt_part_type ='58' no-error. 
                       if available pt_mstr  then do:
                           bkall = bkall + bktotal.
                           display  tr_part label "发动机型号"  pt_desc2 label "发动机描述"  bktotal label "回冲总数量" tr_site label " 地点" tr_loc label " 库位" tr_effdate label "生效日期" tr_date label "操作日期"  bkall with width 120 stream-io.
                       end.
                       bktotal =0.
                end.         
             END.
        /*     disp bkall.          */
         /*{mfguitrl.i}*/ 
        /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
        end procedure.

/*GUI*/ {mfguirpb.i &flds="  flushdate flushdate1 effdate effdate1 site "} /*Drive the Report*/ /*---该包含文件激活条件字段的可编辑状态----*/


 {mfreset.i}





