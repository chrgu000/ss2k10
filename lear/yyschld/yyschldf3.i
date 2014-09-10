put stream bf unformat '"" "" "" "" "" "" "' entry(4,xsd_data) '" ' xsd_line skip.
/*  6007 自有效日程复制数据   */
find sod_det where sod_det.sod_domain = global_domain and
     sod_nbr = entry(4,xsd_data) and sod_line = xsd_line no-lock no-error.
if sod_curr_rlse_id[cate] > "" then do:
   put stream bf unformat 'No' skip.
end.
put stream bf unformat '"' entry(3,xsd_data) '"' skip.
put stream bf unformat 'No '.
if inc_sum then do:
   put stream bf unformat '- '.
end.
else do:
   put stream bf unformat '0 '.
end.
put stream bf unformat effdate skip.
do i = 5 to MaxEntry:
   put stream bf unformat entry(i,vdtelst,",") skip.
   put stream bf unformat entry(i,xsd_data,",") ' P No No' skip.
end.
put stream bf "." skip.
put stream bf 'Yes' skip.           
