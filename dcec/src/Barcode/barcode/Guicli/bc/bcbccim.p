
{bcdeclre.i}
 DEF FRAME a
     b_bf_date COLON 15 LABEL "日期"
     b_bf_part  LABEL "零件号"
     b_bf_lot  LABEL "批/序号"
     b_bf_ref LABEL "参考号"
     b_bf_program LABEL "CIM程序"
     b_bf_site LABEL "地点"
     b_bf_loc LABEL "库位"
     WITH WIDTH 150 DOWN STREAM-IO.
 OUTPUT TO notepad.txt.
 FOR EACH b_bf_det WHERE b_bf_tocim :
     DISP b_bf_date b_bf_part b_bf_lot b_bf_ref b_bf_program b_bf_site b_bf_loc WITH FRAME a.
 END.
 OUTPUT CLOSE.

DOS SILENT VALUE('notepad notepad.txt').  

    {bcsess.i}
   
