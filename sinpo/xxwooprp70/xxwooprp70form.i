/* SS - 110801.1 By: Kaine Zhang */

form
    sParent     colon 15    label "Parent"
    sSite       colon 15    label "Site"
    dteEffect   colon 15    label "Effect"
    skip(1)
    dteA        colon 15    label "Wo Date"
    dteB        colon 45    label "To"
    sWoNbrA     colon 15    label "工单"
    sWoNbrB     colon 45    label "至"
    sPartA      colon 15    label "零件"
    sPartB      colon 45    label "至"
    bIncludeCloseWO colon 15    label "包括已关工单"
    skip(1)
    dteDue      colon 15    label "报表统计日期"
    sViewLevel   colon 15    label "显示至"
    "1 -- 产品"     at 15
    "2 -- 工单"     at 15
    "3 -- 工序"     at 15
    "4 -- 员工"     at 15
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).



