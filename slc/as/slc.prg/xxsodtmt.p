/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100619.1 By: Kaine Zhang */


{mfdtitle.i "100619.1"}

define variable sSoNbr like so_nbr no-undo.
define variable b1 as logical no-undo.


form
    sSoNbr  colon 15    label "���۶���"
    so_cust colon 15    label "�ͻ�"
    so__dte01   colon 15    label "��ҵ����"
with frame a side-labels width 80.
setframelabels(frame a:handle).





repeat on endkey undo, leave:
    {xxfindso01.i}
    
    
    update
        so__dte01
    with frame a.
    
end.






