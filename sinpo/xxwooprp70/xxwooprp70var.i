/* SS - 110801.1 By: Kaine Zhang */

{xxsummarybomtable.i "new shared"}

define variable sParent like ps_par no-undo.
define variable sSite like pt_site no-undo.
define variable dteEffect as date no-undo.

define variable dteA as date no-undo.
define variable dteB as date no-undo.

define variable sWoNbrA     like wo_nbr no-undo.
define variable sWoNbrB     like wo_nbr no-undo.
define variable sPartA      like pt_part no-undo.
define variable sPartB      like pt_part no-undo.
define variable dteDue      as date no-undo.
define variable sViewLevel as character format "x" initial "4" no-undo.
define variable bIncludeCloseWO as logical no-undo.

define variable sDelimiter as character initial "~t" no-undo.



define temp-table t1_tmp no-undo
    field t1_part as character
    field t1_wo_lot as character
    field t1_op as integer
    field t1_employee as character
    field t1_qty_wip as decimal
    .

define temp-table t2_tmp no-undo
    field t2_part as character
    field t2_wo_lot as character
    field t2_op as integer
    field t2_qty_xc as decimal
    field t2_qty_zz as decimal
    .

define temp-table t3_tmp no-undo
    field t3_part as character
    field t3_wo_lot as character
    field t3_op as integer
    field t3_employee as character
    field t3_qty_wip as decimal
    field t3_qty_xc as decimal
    field t3_qty_zz as decimal
    .



assign
    dteEffect = today
    dteDue = today
    sSite = global_site
    .

if sSite = "" then do:
    find first icc_ctrl
        no-lock
        where icc_domain = global_domain
        no-error.
    if available(icc_ctrl) then sSite = icc_site.
end.

