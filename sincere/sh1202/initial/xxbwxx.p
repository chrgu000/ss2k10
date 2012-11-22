/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "120713.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

if can-find(first nr_mstr no-lock where nr_seqid = 'SHIP_TO') or
   can-find(first nrh_hist no-lock where nrh_seqid = 'SHIP_TO') then do:
  {mfmsg.i 2041 3}
pause.
end.
else do:
     create nr_mstr.
     assign nr_seqid = 'SHIP_TO'
            nr_desc = 'sh1202 SHIP TO ADDRESS'
            nr_dataset = ''
            nr_allow_discard = no
            nr_allow_void = no
            nr_next_set = no
            nr_seg_type = '4,1,'
            nr_seg_nbr = ''
            nr_segcount = 2
            nr_seg_rank = '3,2,'
            nr_seg_ini = ',0000,'
            nr_seg_min = ',0000,'
            nr_seg_max = ',9999,'
            nr_seg_reset = ',0001,'
            nr_seg_value = 'SPTO,0003,'
            nr_seg_format = ',9999,'
            nr_archived = no
            nr_internal = yes
            nr_effdate = today - 1
            nr_exp_date = ?
            nr_user1 = ''
            nr_user2 = ''
            nr__qadc01 = ''
            nr_curr_effdate = today - 1
            nr_valuemask = 'SSPPTTOO09090909'
            nr_domain = global_domain
            .
     {mfmsg.i 4171 1}
end.

if can-find(first nr_mstr no-lock where nr_seqid = 'SHIP_VD') or
   can-find(first nrh_hist no-lock where nrh_seqid = 'SHIP_VD') then do:
  {mfmsg.i 2041 3}
pause.
end.
else do:
     create nr_mstr.
     assign nr_seqid = 'SHIP_VD'
            nr_desc = 'sh1202 SHIPPER_VENDOR'
            nr_dataset = ''
            nr_allow_discard = no
            nr_allow_void = no
            nr_next_set = no
            nr_seg_type = '4,1,'
            nr_seg_nbr = ''
            nr_segcount = 2
            nr_seg_rank = '3,2,'
            nr_seg_ini = ',0000,'
            nr_seg_min = ',0000,'
            nr_seg_max = ',9999,'
            nr_seg_reset = ',0001,'
            nr_seg_value = 'spvd,0023,'
            nr_seg_format = ',9999,'
            nr_archived = no
            nr_internal = yes
            nr_effdate = today - 1
            nr_exp_date = ?
            nr_user1 = ''
            nr_user2 = ''
            nr__qadc01 = ''
            nr_curr_effdate = today - 1
            nr_valuemask = 'ssppvvdd09090909'
            nr_domain = global_domain
            .
     {mfmsg.i 4171 1}
end.
find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx100' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx100'.
end.
assign brw_mstr.brw_desc = 'LOGISTICS_VENDOR'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_domain = global_domain and usrw_key1 = "SH1202_LOGISTICS_VENDOR"'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx100' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx100'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx100' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx100'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key2'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(12)'
       brwf_det.brwf_label    = 'LOGISTICS_VENDOR_ID'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '12'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx100' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx100'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'usrw_key3'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(16)'
       brwf_det.brwf_label    = 'LOGISTICS_VENDOR'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '16'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx100' and
           brwf_det.brwf_seq = 3 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx100'
                 brwf_det.brwf_seq = 3.
end.
assign brwf_det.brwf_field    = 'usrw_key4'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(8)'
       brwf_det.brwf_label    = 'ATTENTION'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '8'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx100' and
           brwf_det.brwf_seq = 4 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx100'
                 brwf_det.brwf_seq = 4.
end.
assign brwf_det.brwf_field    = 'usrw_key5'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(12)'
       brwf_det.brwf_label    = 'TELEPHONE'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '12'
       brwf_det.brwf_enable   = no.
find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx101' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx101'.
end.
assign brw_mstr.brw_desc = 'SHIP-TO_ADDRESS'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_domain = global_domain and usrw_key1 = "SH1202_SHIP_TO_ADDRESS"'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx101' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx101'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx101' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx101'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key2'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(12)'
       brwf_det.brwf_label    = 'SHIP-TO_ID'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '12'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx101' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx101'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'usrw_key3'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(12)'
       brwf_det.brwf_label    = 'SHIP-TO_ADDRESS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '12'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx101' and
           brwf_det.brwf_seq = 3 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx101'
                 brwf_det.brwf_seq = 3.
end.
assign brwf_det.brwf_field    = 'usrw_key4'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(10)'
       brwf_det.brwf_label    = 'ATTENTION'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '10'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx101' and
           brwf_det.brwf_seq = 4 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx101'
                 brwf_det.brwf_seq = 4.
end.
assign brwf_det.brwf_field    = 'usrw_key5'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(12)_'
       brwf_det.brwf_label    = 'TELEPHONE'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '12'
       brwf_det.brwf_enable   = no.
      {mfmsg.i 4171 1}
       pause.
       return.
end.  /* DO ON ERROR UNDO, RETRY */
status input.
