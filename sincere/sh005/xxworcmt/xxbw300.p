find first brw_mstr no-lock where brw_mstr.brw_name = 'xx300' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name  = 'xx300'.
end.
assign brw_mstr.brw_desc      = 'DOCUMENT_TYPE'.
assign brw_mstr.brw_view      = 'xdn_ctrl'
       brw_mstr.brw_filter    = 'xdn_domain = global_domain'
       brw_mstr.brw_userid    = 'mfg'
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det no-lock where brwt_det.brw_name = 'xx300' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name      = 'xx300'.
end.
assign brwt_det.brwt_seq      = 1
       brwt_det.brwt_table    = 'xdn_ctrl'
       brwt_det.brwt_userid   = 'mfg'
       brwt_det.brwt_mod_date = today.
find first brwf_det no-lock where brwf_det.brw_name = 'xx300' and brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx300'
                 brwf_det.brwf_seq        = 1.
end.
assign brwf_det.brwf_field      = 'xdn_type'
       brwf_det.brwf_datatype   = 'character'
       brwf_det.brwf_format     = ''
       brwf_det.brwf_label      = 'TYPE'
       brwf_det.brwf_table      = 'xdn_ctrl'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf__qadc01    = '2'
       brwf_det.brwf_enable     = no.
find first brwf_det no-lock where brwf_det.brw_name = 'xx300' and brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name        = 'xx300'
                 brwf_det.brwf_seq        = 2.
end.
assign brwf_det.brwf_field      = 'xdn_name'
       brwf_det.brwf_datatype   = 'character'
       brwf_det.brwf_format     = 'x(14)'
       brwf_det.brwf_label      = 'DESCRIPTION'
       brwf_det.brwf_table      = 'xdn_ctrl'
       brwf_det.brwf_select     = yes
       brwf_det.brwf_sort       = yes
       brwf_det.brwf_userid     = 'mfg'
       brwf_det.brwf_mod_date   = today
       brwf_det.brwf__qadc01    = '14'
       brwf_det.brwf_enable     = no.