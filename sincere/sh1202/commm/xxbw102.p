/* xxbw102.p - LOGISTICS_NUMBER BROWSE GENERATE                              */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

{mfdtitle.i "120606.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

find first brw_mstr no-lock where brw_mstr.brw_name = 'xx102' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name  = 'xx102'.
end.
assign brw_mstr.brw_desc      = 'LOGISTICS_NUMBER'.
assign brw_mstr.brw_view      = 'xxsh_mst'
       brw_mstr.brw_filter    = 'xxsh_domain = global_domain'
       brw_mstr.brw_userid    = 'mfg'
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det no-lock where brwt_det.brw_name = 'xx102' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name      = 'xx102'.
end.
assign brwt_det.brwt_seq      = 1
       brwt_det.brwt_table    = 'xxsh_mst'
       brwt_det.brwt_userid   = 'mfg'
       brwt_det.brwt_mod_date = today.
find first brwf_det no-lock where brwf_det.brw_name = 'xx102' and brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx102'
                 brwf_det.brwf_seq        = 1.
end.
assign brwf_det.brwf_field      = 'xxsh_nbr'
       brwf_det.brwf_datatype   = 'character'
       brwf_det.brwf_format     = ''
       brwf_det.brwf_label      = 'LOGISTICS_NUMBER'
       brwf_det.brwf_table      = 'xxsh_mst'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf_enable     = no.
find first brwf_det no-lock where brwf_det.brw_name = 'xx102' and brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx102'
                 brwf_det.brwf_seq        = 2.
end.
assign brwf_det.brwf_field      = 'xxsh_site'
       brwf_det.brwf_datatype   = 'character'
       brwf_det.brwf_format     = ''
       brwf_det.brwf_label      = 'SHIP-FROM'
       brwf_det.brwf_table      = 'xxsh_mst'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf_enable     = no.
find first brwf_det no-lock where brwf_det.brw_name = 'xx102' and brwf_det.brwf_seq = 3 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx102'
                 brwf_det.brwf_seq        = 3.
end.
assign brwf_det.brwf_field      = 'xxsh_abs_id'
       brwf_det.brwf_datatype   = 'character'
       brwf_det.brwf_format     = 'x(10)'
       brwf_det.brwf_label      = 'SHIPPER_ID'
       brwf_det.brwf_table      = 'xxsh_mst'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf_enable     = no
       brwf_det.brwf__qadc01  = '10'.
find first brwf_det no-lock where brwf_det.brw_name = 'xx102' and brwf_det.brwf_seq = 4 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx102'
                 brwf_det.brwf_seq        = 4.
end.
assign brwf_det.brwf_field      = 'xxsh_shipto'
       brwf_det.brwf_datatype   = 'character'
       brwf_det.brwf_format     = ''
       brwf_det.brwf_label      = 'SHIP-TO_ID'
       brwf_det.brwf_table      = 'xxsh_mst'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf_enable     = no.
find first brwf_det no-lock where brwf_det.brw_name = 'xx102' and brwf_det.brwf_seq = 5 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx102'
                 brwf_det.brwf_seq        = 5.
end.
assign brwf_det.brwf_field      = 'xxsh_lgvd'
       brwf_det.brwf_datatype   = 'character'
       brwf_det.brwf_format     = ''
       brwf_det.brwf_label      = 'LOGISTICS_VENDOR'
       brwf_det.brwf_table      = 'xxsh_mst'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf_enable     = no.
find first brwf_det no-lock where brwf_det.brw_name = 'xx102' and brwf_det.brwf_seq = 6 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx102'
                 brwf_det.brwf_seq        = 6.
end.
assign brwf_det.brwf_field      = 'xxsh_price'
       brwf_det.brwf_datatype   = 'decimal'
       brwf_det.brwf_format     = ''
       brwf_det.brwf_label      = 'UNIT_PRICE'
       brwf_det.brwf_table      = 'xxsh_mst'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf_enable     = no.
end.