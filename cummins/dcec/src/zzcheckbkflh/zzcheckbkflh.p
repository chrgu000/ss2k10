/* Revision: QAD2011  BY: Apple Tam         DATE: 08/15/12  ECO: *SS -20120815.1  */

{mfdtitle.i "20120815.1"}
DEFINE VAR trlot LIKE tr_lot.
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 trlot colon 22   LABEL "事务号"
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle).

/* 按事务号检查发动机回冲的数量*/

REPEAT:
     UPDATE trlot with frame a.
    {mfquoter.i trlot}
    {mfselbpr.i "printer" 132}
    PUT "事务号     零件号               事务类型         变化数量   工位       生效日期   操作日期   用户ID     运行程序" skip.
    FOR EACH tr_hist  WHERE tr_domain = global_domain and tr_lot = trlot  NO-LOCK:
        put tr_trnbr space(3) tr_part space(3) tr_type space(3) tr_qty_loc space(3) tr_loc space(3)
	tr_effdate space(3) tr_date space(3) tr_userid space(3) tr_program SKIP.
    END.
    {mfguitrl.i} 
    {mfreset.i}  
    {mfgrptrm.i}
END.
