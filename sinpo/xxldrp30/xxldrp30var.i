/* SS - 110801.1 By: Kaine Zhang */

{xxfoocost1.i "new shared"}
{xxfoocost2.i "new shared"}

define variable sSite like si_site no-undo.
define variable sLocA like loc_loc no-undo.
define variable sLocB like loc_loc no-undo.
define variable sProdLineA like pt_prod_line no-undo.
define variable sProdLineB like pt_prod_line no-undo.
define variable sPartA like pt_part no-undo.
define variable sPartB like pt_part no-undo.

define variable iYear as integer no-undo.
define variable iMonth as integer no-undo.
define variable sDelimiter as character initial "~t" no-undo.

define variable decPrice as decimal no-undo.

define temp-table t1_tmp no-undo
    field t1_type as character
    field t1_loc as character
    field t1_part as character
    field t1_lot as character
    field t1_qty as decimal
    field t1_cost as decimal
    field t1_price as decimal
    .

assign
    iYear = year(today - day(today))
    iMonth = month(today - day(today))
    .


