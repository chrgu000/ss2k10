/* SS - 100322.1 By: Kaine Zhang */
/* SS - 101208.1 By: Kaine Zhang */


/* SS - 101208.1 - RNB
[100322.1]
/* Create XinTian's Operation Transaction History (Complete, Reject, Rework) ... */
[100322.1]
[101208.1]
ref: XinTian, He Hongyu email by Kaine, 20101203-20101208.
1. wip = move in - comp - reject.
2. validate: input (comp + reject) <= wip.
[101208.1]
SS - 101208.1 - RNE */


{mfdeclre.i}

define input parameter sWoNbr as character.
define input parameter sWoLot as character.
define input parameter iOp as integer.
define input parameter sEmployee as character.
define input parameter sDept as character.
define input parameter bStock as logical.
define input parameter decComp as decimal.
define input parameter decReject as decimal.
define input parameter decRework as decimal.
define input parameter iTrnbr as integer.

create xop_hist.
xop_domain = global_domain.
{xxfromsequence2unique.i xxtsq_sq01 xop_seq}
assign
    xop_wo_lot      = sWoLot
    xop_wo_nbr      = sWoNbr
    xop_op          = iOp
    xop_type        = if bStock then "CompZ" else "CompX"
    xop_qty_in      = 0
    xop_qty_comp    = decComp
    xop_qty_reject  = decReject
    xop_qty_rework  = decRework
    xop_qty_xc2zzk  = 0
    xop_qty_out     = 0
    xop_date        = today
    xop_time        = time
    xop_qad_trnbr   = iTrnbr
    xop_employee    = sEmployee
    xop_department  = sDept
    .

find first xwrld_det
    where xwrld_domain = global_domain
        and xwrld_wo_lot = sWoLot
        and xwrld_op = iOp
    no-error.
if not(available(xwrld_det)) then do:
    create xwrld_det.
    assign
        xwrld_domain = global_domain
        xwrld_wo_lot = sWoLot
        xwrld_op = iOp
        xwrld_wo_nbr = sWoNbr
        .
end.
/* SS - 101208.1 - B
xwrld_qty_wip   = xwrld_qty_wip - decComp - decReject - decRework.
SS - 101208.1 - E */
/* SS - 101208.1 - B */
xwrld_qty_wip   = xwrld_qty_wip - decComp - decReject.
/* SS - 101208.1 - E */
if bStock then
    xwrld_qty_zz    = xwrld_qty_zz + decComp.
else
    xwrld_qty_xc    = xwrld_qty_xc + decComp.

assign
    xop_ld_qty_in   = xwrld_qty_in  
    xop_ld_qty_wip  = xwrld_qty_wip 
    xop_ld_qty_xc   = xwrld_qty_xc  
    xop_ld_qty_zzk  = xwrld_qty_zz  
    xop_ld_qty_outx = xwrld_qty_outx
    xop_ld_qty_outz = xwrld_qty_outz
    .
    




