/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "130113.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx401' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx401'.
end.
assign brw_mstr.brw_desc = 'BOOK_TYPE'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_key1 = "XXBK_BOOKTYPE"'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx401' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx401'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx401' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx401'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key2'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(10)'
       brwf_det.brwf_label    = 'BOOK_TYPE'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '10'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx401' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx401'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'usrw_key3'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(30)'
       brwf_det.brwf_label    = 'COMMENTS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '30'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx401' and
           brwf_det.brwf_seq = 3 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx401'
                 brwf_det.brwf_seq = 3.
end.
assign brwf_det.brwf_field    = 'usrw_intfld[01]'
       brwf_det.brwf_datatype = 'integer'
       brwf_det.brwf_format   = '>9'
       brwf_det.brwf_label    = 'EXPIRATION_DAYS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '2'
       brwf_det.brwf_enable   = no.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'xxbk_type' and
           flh_mstr.flh_call_pgm = '' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'xxbk_type'
                 flh_call_pgm = ''.
end.
assign flh_mstr.flh_desc = ""
       flh_mstr.flh_exec = "xxlu401.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = global_userid
       flh_mstr.flh_mod_date = today.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'xxbl_bkid' and
           flh_mstr.flh_call_pgm = '' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'xxbl_bkid'
                 flh_call_pgm = ''.
end.
assign flh_mstr.flh_desc = ""
       flh_mstr.flh_exec = "xxlu401.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = global_userid
       flh_mstr.flh_mod_date = today.
find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx402' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx402'.
end.
assign brw_mstr.brw_desc = 'BOOK_STATUS'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_key1 = "XXBK_BOOKSTAT"'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx402' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx402'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx402' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx402'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key2'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(8)'
       brwf_det.brwf_label    = 'BOOK_STATUS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '8'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx402' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx402'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'usrw_key3'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(30)'
       brwf_det.brwf_label    = 'COMMENTS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '30'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx402' and
           brwf_det.brwf_seq = 3 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx402'
                 brwf_det.brwf_seq = 3.
end.
assign brwf_det.brwf_field    = 'usrw_logfld[01]'
       brwf_det.brwf_datatype = 'logical'
       brwf_det.brwf_format   = 'YES/NO'
       brwf_det.brwf_label    = 'ALLOW_BORROW_BOOK'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '6'
       brwf_det.brwf_enable   = no.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'xxbk_stat' and
           flh_mstr.flh_call_pgm = '' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'xxbk_stat'
                 flh_call_pgm = ''.
end.
assign flh_mstr.flh_desc = ""
       flh_mstr.flh_exec = "xxlu402.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = global_userid
       flh_mstr.flh_mod_date = today.
find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx403' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx403'.
end.
assign brw_mstr.brw_desc = 'BORROW_CARD_TYPE'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_key1 = "XXBK_BCRDTYPE"'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx403' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx403'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx403' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx403'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key2'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(8)'
       brwf_det.brwf_label    = 'BORROW_CARD_TYPE'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '8'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx403' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx403'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'usrw_key3'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(30)'
       brwf_det.brwf_label    = 'COMMENTS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '30'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx403' and
           brwf_det.brwf_seq = 3 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx403'
                 brwf_det.brwf_seq = 3.
end.
assign brwf_det.brwf_field    = 'usrw_decfld[01]'
       brwf_det.brwf_datatype = 'decimal'
       brwf_det.brwf_format   = '>>9'
       brwf_det.brwf_label    = 'DEPOSIT'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '5'
       brwf_det.brwf_enable   = no.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'xxbc_type' and
           flh_mstr.flh_call_pgm = '' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'xxbc_type'
                 flh_call_pgm = ''.
end.
assign flh_mstr.flh_desc = ""
       flh_mstr.flh_exec = "xxlu403.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = global_userid
       flh_mstr.flh_mod_date = today.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'xxbl_bcid' and
           flh_mstr.flh_call_pgm = '' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'xxbl_bcid'
                 flh_call_pgm = ''.
end.
assign flh_mstr.flh_desc = ""
       flh_mstr.flh_exec = "xxlu403.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = global_userid
       flh_mstr.flh_mod_date = today.
find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx404' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx404'.
end.
assign brw_mstr.brw_desc = 'BORROW_CARD_STATUS'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_key1 = "XXBK_BCRDSTAT"'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx404' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx404'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx404' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx404'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key2'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(8)'
       brwf_det.brwf_label    = 'BORROW_CARD_STATUS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '8'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx404' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx404'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'usrw_key3'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(30)'
       brwf_det.brwf_label    = 'COMMENTS'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '30'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx404' and
           brwf_det.brwf_seq = 3 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx404'
                 brwf_det.brwf_seq = 3.
end.
assign brwf_det.brwf_field    = 'usrw_logfld[01]'
       brwf_det.brwf_datatype = 'logical'
       brwf_det.brwf_format   = 'YES/NO'
       brwf_det.brwf_label    = 'ALLOW_BORROW_BOOK'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '6'
       brwf_det.brwf_enable   = no.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'xxbc_stat' and
           flh_mstr.flh_call_pgm = '' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'xxbc_stat'
                 flh_call_pgm = ''.
end.
assign flh_mstr.flh_desc = ""
       flh_mstr.flh_exec = "xxlu404.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = global_userid
       flh_mstr.flh_mod_date = today.
      {mfmsg.i 4171 1}
       pause.
       return.
end.  /* DO ON ERROR UNDO, RETRY */
status input.
