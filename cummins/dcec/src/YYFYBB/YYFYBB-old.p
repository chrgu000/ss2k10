{mfdtitle.i "120929.1"}

DEF VAR pyear LIKE acd_year .
DEF VAR pper LIKE acd_per .

Form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 pyear colon 22 label "年"
 pper colon 22 label "月"
 
 "** 数据导出到 D:\ACD_DET **,执行完请退出界面!"       AT 10 SKIP

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

REPEAT:

    update pyear pper  with frame a.

OUTPUT TO d:\acd_det.txt.

FOR EACH acd_det NO-LOCK
        WHERE acd_det.acd_domain = "DCEC" and acd_year = pyear
        AND acd_per = pper AND acd_acc BEGINS "51":
         DISP acd_acc acd_sub acd_cc acd_amt with width 200 stream-io.      
    END.
END.
OUTPUT CLOSE.
