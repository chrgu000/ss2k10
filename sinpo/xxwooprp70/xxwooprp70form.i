/* SS - 110801.1 By: Kaine Zhang */

form
    sParent     colon 15    label "Parent"
    sSite       colon 15    label "Site"
    dteEffect   colon 15    label "Effect"
    skip(1)
    dteA        colon 15    label "Wo Date"
    dteB        colon 45    label "To"
    sWoNbrA     colon 15    label "����"
    sWoNbrB     colon 45    label "��"
    sPartA      colon 15    label "���"
    sPartB      colon 45    label "��"
    bIncludeCloseWO colon 15    label "�����ѹع���"
    skip(1)
    dteDue      colon 15    label "����ͳ������"
    sViewLevel   colon 15    label "��ʾ��"
    "1 -- ��Ʒ"     at 15
    "2 -- ����"     at 15
    "3 -- ����"     at 15
    "4 -- Ա��"     at 15
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).



