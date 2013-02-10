/* xxreceiver.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/14/01      BY: Kang Jian          */
{mfdtitle.i}
define var i as integer.
define workfile comtwo field bom1_par as char format "x(20)"  
                         field bom1_com like ps_comp
                         field bom1_date like ps_start
                         field bom1_qty like ps_qty_per
                         field bom2_par like ps_par
                         field bom2_com like ps_comp
                         field bom2_date like ps_start
                         field bom2_qty like ps_qty_per
                         field bom_log as logical.
define variable so_bom1 like ps_par label "BOM1的值 ".
define variable so_so_date1 like ps_start label "bom1的生效日期 " initial today.
define variable so_bom2 like ps_par label "BOM2的值 ".
define variable so_so_date2 like ps_start label "bom2的生效日期 " initial today.
define var pageno as integer.
     
/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)  
   so_bom1  colon 20
   so_so_date1 colon 60 skip
   so_bom2  colon 20
   so_so_date2 colon 60 skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title = " 输入条件 ".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME	  
/*judy 05/08/05*/ /* SET EXTERNAL LABELS */
/*judy 05/08/05*/  setFrameLabels(frame a:handle).

{mfguirpa.i true  "printer" 132 }
/*end format of query screen*/

/*start query preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
   if so_bom1     = hi_char  then so_bom1 = "". 
   if so_bom2     = hi_char  then so_bom2 = "". 
   if so_so_date1  = low_date then so_so_date1 = ?. 
   if so_so_date2  = low_date then so_so_date2 = ?. 
     
   run p-action-fields (input "display").
   run p-action-fields (input "enable").
end procedure. 
/*end procefuer p-enable-ui*/
/*end query preference initialize*/

/*start procedure of p-report-quote*/
/*start receive query preference*/
procedure p-report-quote:
   bcdparm = "".
   {mfquoter.i so_bom1} 
   {mfquoter.i so_so_date1} 
   {mfquoter.i so_bom2} 
   {mfquoter.i so_so_date2} 
/*end receive query preference*/

/*start check the validity of query preference*/
   if so_bom1     = ""  then so_bom1 = hi_char. 
   if so_bom2     = ""  then so_bom2 = hi_char. 
   if so_so_date1  = ?   then so_so_date1 = low_date. 
   if so_so_date2  = ?   then so_so_date2 = low_date. 
/*end check the validity of query preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end query  preference */

/*start procedure of p-report*/
/*start report out put*/
procedure p-report:
  {gpprtrpa.i  "window" 132}                               
   pageno = 1.
   i = 1.
   for each ps_mstr  no-lock WHERE ps_domain = "DCEC" AND  ps_par = so_bom1 and 
       ((ps_start <= so_so_date1 and ps_end >= so_so_date1 ) 
       or (ps_start = ?  and ps_end >= so_so_date1)
       or (ps_start <= so_so_date1 and ps_end = ?)
       or (ps_start = ? and ps_end = ?)) 
        use-index ps_comp
        with frame b width 132 no-attr-space:       
/*REPEAT:
  INSERT order WITH 1 COLUMN.
  REPEAT:
    CREATE order-line.
    order-line.order-num = order.order-num.
    UPDATE line-num order-line.item-num qty price.
    FIND item OF order-line.
  END.
END.*/
               create comtwo.                    
                bom1_com = ps_comp.
                bom1_date = so_so_date1.
                bom1_qty=ps_qty_per.
                bom_log = no.
                bom2_com="无此组号".
   end.
   for each ps_mstr no-lock  WHERE ps_domain = "DCEC" AND  ps_par = so_bom2 and 
       ((ps_start <= so_so_date2 and ps_end >= so_so_date2 ) 
       or (ps_start = ?  and ps_end >= so_so_date2)
       or (ps_start <= so_so_date2 and ps_end = ?)
       or (ps_start = ? and ps_end = ?))  use-index ps_comp
        with frame b4 width 132 no-attr-space :       
            find first comtwo where (bom1_com = ps_comp ) no-error.
            if available comtwo then do:
                if bom1_qty=ps_qty_per then do:
                bom2_com = ps_comp.
                bom2_date = so_so_date2.
                bom2_qty=ps_qty_per.
                bom_log = Yes.
                end.
                else do:                
                   bom2_com = ps_comp.
                   bom2_qty=ps_qty_per.
                   bom2_date = so_so_date2.
                   bom_log = no.
                end.
            end.
            else do:
                create comtwo.
                bom2_com = ps_comp.
                bom2_qty=ps_qty_per.
                bom2_date = so_so_date2.
                bom_log = no.
                bom1_com="无此组号".
            end.
   end.
  form  "ＢＯＭ 对比清单 "  font 14 at 22 skip(1)
      so_bom1 format "x(18)"  at 1
      so_so_date1  at 20
      so_bom2 format "x(18)" at 32
      so_so_date2  at 52 
 	with STREAM-IO no-labels no-attr-space frame heading width 130.
   display so_bom1 so_so_date1 so_bom2 so_so_date2  WITH STREAM-IO frame heading.
   for each comtwo where bom_log = no and (bom1_com <> ""  or bom2_com  <> ""):
       if i = 1 then do:
          i = i + 2.       
       end.
       display bom1_com column-label "零件号  " bom1_qty format "->>>" column-label "每机件" space(8)  bom2_com column-label "零件号  " bom2_qty format "->>>" column-label  "每机件  " WITH WIDTH 130 stream-io. 
       /* NO-LABELS no-attr-space NO-BOX frame CONTENT.*/
       if line-counter  >= (page-size - 4)  then do:
                 page.
                 i = 1.
       end.
   end.
   
  for each comtwo :
     delete comtwo.
  end.

/* reset variable */
{mfreset.i}
  {mfgrptrm.i}
  

end. /*end of the procedure*/
{mfguirpb.i &flds="so_bom1 so_so_date1 so_bom2 so_so_date2 "}




