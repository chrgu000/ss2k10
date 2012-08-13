/* xxreceiver.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/15/02      BY: Kang Jian          */
{mfdtitle.i}
def var linefrom like pt_prod_line label "产品类从".
def var lineto like pt_prod_line label "至" .
def var statusfrom like pt_status initial "p" label "零件状态从".
def var statusto like pt_status initial "p" label "至".
def var inspfrom like pt_insp_rqd initial no label "检验状态从".
def var inspto like pt_insp_rqd initial no label "至".
def var pageno as integer initial 1 LABEL "页码" .
def var pagelog as integer initial 1.
     
  FORM    
     skip(1)
     "零件清单" at 30
     skip
     pageno AT 40  
     skip(1)
     "零件号            零件名称               零件状态    检验件   "
     skip "---------------------------------------------------------------"
     skip(1)
  with no-box side-labels width 180 frame hh.
/*  with width 240 no-labels no-attr-space .*/
 
/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)  
   linefrom  colon 20
   lineto  colon 40 skip
   statusfrom  colon 20
   statusto  colon 40 skip
   inspfrom  colon 20 
   inspto colon 40 skip
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


/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame a:handle).
{wbrp01.i}
{mfguirpa.i true  "printer" 132 }
/*end format of query screen*/

/*start query preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
   if lineto     = hi_char  then lineto = "". 
   if statusto   = hi_char  then statusto = "". 
   run p-action-fields (input "display").
   run p-action-fields (input "enable").
   pagelog = 1 .
   pageno = 1 .
end procedure. 
/*end procefuer p-enable-ui*/
/*end query preference initialize*/

/*start procedure of p-report-quote*/
/*start receive query preference*/
procedure p-report-quote:
   bcdparm = "".
   {mfquoter.i linefrom} 
   {mfquoter.i lineto} 
   {mfquoter.i statusfrom} 
   {mfquoter.i statusto} 
   {mfquoter.i inspfrom} 
   {mfquoter.i inspto} 
/*end receive query preference*/

/*start check the validity of query preference*/
   if lineto     = ""  then lineto = hi_char. 
   if statusto     = ""  then statusto = hi_char. 
/*end check the validity of query preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end query  preference */

/*start procedure of p-report*/
/*start report out put*/

procedure p-report:
  {gpprtrpa.i  "window" 132}                               
/* 以下开始打印检验件清单" */
   
   for each pt_mstr no-lock  where pt_prod_line>=linefrom and pt_prod_line<=lineto
                            and pt_status>=statusfrom and pt_status<=statusto
                            and pt_insp_rqd>=inspfrom and pt_insp_rqd<=inspto
                            break by pt_insp_rqd by pt_status by pt_prod_line :

       if pagelog=1 then do:
           disp pageno with frame hh STREAM-IO .
           pagelog=0.
       end.
       disp pt_part pt_desc2 "  " pt_status  pt_insp_rqd with no-box no-labels width 230  FRAME c DOWN STREAM-IO.
      
       if line-counter >= (page-size - 4)  or last-of(pt_insp_rqd)  then do:
/*         disp  "-------------------------------------------------------" with no-box no-labels width 230 .                                  
           down 1.*/
           pagelog = 1.
           pageno=pageno + 1.
           PAGE.
       end.
   end.                          

 /*judy 07/05/05*/ 
  {mfgrptrm.i}
  {mfreset.i}

/*V8-*/
{wbrp04.i &frame-spec = a}
/*V8+*/

end. /*end of the procedure*/
{mfguirpb.i &flds="linefrom lineto statusfrom statusto inspfrom inspto "}

/* reset variable */
 /*judy 07/05/05*/ /* {mfreset.i}*/








