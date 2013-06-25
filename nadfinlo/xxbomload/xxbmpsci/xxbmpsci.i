define {1} shared variable flhload as character format "x(60)".
define {1} shared variable cloadfile as logical initial NO.

define {1} shared temp-table tmpd_det
       fields tmpd_par like ps_par
       fields tmpd_comp like ps_comp
       fields tmpd_ref  like ps_ref
       fields tmpd_start like ps_start
       fields tmpd_sub_part like pts_sub_part
       fields tmpd_end   like ps_end
       fields tmpd_qty_per like ps_qty_per
       fields tmpd_chk as character format "x(80)".

define {1} shared temp-table xps_wkfl
       fields xps_par like ps_par
       fields xps_comp like ps_comp
       fields xps_ref  like ps_ref
       fields xps_start like ps_start
       fields xps_qty_per like ps_qty_per
       fields xps_ps_code like ps_ps_code
       fields xps_end     like ps_end
       fields xps_rmks    like ps_rmks
       fields xps_scrp_pct like ps_scrp_pct
       fields xps_lt_off   like ps_lt_off
       fields xps_op       like ps_op
       fields xps_item_no  like ps_item_no
       fields xps_fcst_pct like ps_fcst_pct
       fields xps_group like ps_group
       fields xps_process like ps_process
       fields xps_sn as integer
       fields xps_chk as character format "x(80)"
       .