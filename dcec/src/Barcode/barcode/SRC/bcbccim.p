
{bcdeclre.i}
 DEF FRAME a
     b_bf_date COLON 15 LABEL "����"
     b_bf_part  LABEL "�����"
     b_bf_lot  LABEL "��/���"
     b_bf_ref LABEL "�ο���"
     b_bf_program LABEL "CIM����"
     b_bf_site LABEL "�ص�"
     b_bf_loc LABEL "��λ"
     WITH WIDTH 150 DOWN STREAM-IO.
 OUTPUT TO notepad.txt.
 FOR EACH b_bf_det WHERE b_bf_tocim :
     DISP b_bf_date b_bf_part b_bf_lot b_bf_ref b_bf_program b_bf_site b_bf_loc WITH FRAME a.
 END.
 OUTPUT CLOSE.

DOS SILENT VALUE('notepad notepad.txt').  

    {bcsess.i}
   
