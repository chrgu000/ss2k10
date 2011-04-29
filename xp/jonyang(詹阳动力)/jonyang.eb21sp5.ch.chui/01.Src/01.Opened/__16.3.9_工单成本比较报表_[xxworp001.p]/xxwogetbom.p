{mfdeclre.i}
{gplabel.i}

{gpxpld01.i "new shared"}


define input  parameter i-part     like pt_part .
define input  parameter i-site     like pt_site .
define input  parameter i-eff_date as date  .


define shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty format "->>>,>>>,>>9.9<<<<<<<<"
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

define new shared variable comp     like ps_comp.
define new shared variable eff_date as   date   label "As of".
define new shared variable qty      like pt_batch  label "Quantity".
define new shared variable net_oh like mfc_logical initial no   label "Net OH".
define new shared variable use_up like mfc_logical initial No   label "Use up Ph".
define new shared variable site like in_site   no-undo.
define new shared variable op as integer label "Op" format ">>>>>9".
define new shared variable phantom like mfc_logical initial yes.
define new shared variable transtype as character format "x(4)".

transtype = "BM".
use_up    = No  .
site      = i-site .
eff_date  = i-eff_date .


mainloop:
repeat:
    for first bom_mstr
     fields( bom_domain bom_batch_um bom_desc bom_parent)
      where bom_mstr.bom_domain = global_domain and  bom_parent = i-part
    no-lock:
    end. /* FOR FIRST bom_mstr */

    for first pt_mstr
     fields( pt_domain pt_bom_code   pt_desc1   pt_desc2
             pt_joint_type pt_loc     pt_ord_qty
             pt_part       pt_phantom pt_um)
      where pt_mstr.pt_domain = global_domain and  pt_part = i-part
    no-lock:
    end. /* FOR FIRST pt_mstr */

    for first ptp_det
      fields( ptp_domain ptp_bom_code ptp_joint_type ptp_ord_qty
              ptp_part     ptp_phantom    ptp_site)
       where ptp_det.ptp_domain = global_domain and   ptp_part = i-part
         and ptp_site = site
    no-lock:
    end. /* FOR FIRST ptp_det */

    for first si_mstr
     fields( si_domain si_site)
      where si_mstr.si_domain = global_domain and  si_site = site
    no-lock:
    end. /* FOR FIRST si_mstr */


    comp = i-part.

    if available ptp_det
    then do:
        if index("1234",ptp_joint_type) > 0
        then leave .

        if ptp_bom_code > ""
        then
            comp = ptp_bom_code.
    end. /* IF AVAILABLE ptp_det */
    else
    if available pt_mstr
    then do:
        if index("1234",pt_joint_type) > 0
        then leave .

        if pt_bom_code > ""
        then
            comp = pt_bom_code.
    end. /* IF AVAILABLE pt_mstr */


    
    /* explode i-part by standard picklist logic */
    if use_up  /* 优先使用虚零件(phantom)的库存 */
    then do:
        {gprun.i ""bmpkcca.p""}
    end. /* IF use-up */
    else do:
        {gprun.i ""woworla2.p""}
    end. /* ELSE DO */

/**********
    for each pkdet
         where eff_date = ? or (eff_date <> ?
         and (pkstart = ? or pkstart <= eff_date)
         and (pkend = ? or eff_date <= pkend)
         and ((pkop = op) or (op = 0))) no-lock
         break by pkpart by pkop :

    end. 
************/
leave .
end. /* REPEAT*/
