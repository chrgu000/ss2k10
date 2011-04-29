define {1} shared var wonbr      like wo_nbr.
define {1} shared var wonbr1     like wo_nbr.
define {1} shared var lot        like wo_lot .
define {1} shared var lot1       like wo_lot .
define {1} shared var part       like pt_part .
define {1} shared var part1      like pt_part .
define {1} shared var line       like pt_prod_line.
define {1} shared var line1      like pt_prod_line .
define {1} shared var rdate      as date .
define {1} shared var rdate1     as date .
define {1} shared var cdate      as date .
define {1} shared var cdate1     as date .
define {1} shared var v_all      as integer format "9" initial 1.
define {1} shared var v_from     as integer format "9" initial 2.

define {1} shared var v_qty_wip like wo_qty_ord .

define {1} shared workfile pkdet no-undo
   field pkpart     like ps_comp
   field pkop       as integer format ">>>>>9"
   field pkstart    like pk_start
   field pkend      like pk_end
   field pkqty      like pk_qty format "->>>,>>>,>>9.9<<<<<<<<"
   field pkbombatch like bom_batch
   field pkltoff    like ps_lt_off.


