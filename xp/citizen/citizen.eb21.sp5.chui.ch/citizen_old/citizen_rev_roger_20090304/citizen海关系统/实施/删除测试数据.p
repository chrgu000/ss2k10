/*****************************************�������ݵ�ɾ��*/


/*****************************************���*/
for each xxcpt_mstr :
delete xxcpt_mstr.
end.
for each xxccpt_mstr :
delete xxccpt_mstr.
end.

/*****************************************BOM*/
for each xxcps_mstr :
delete xxcps_mstr.
end.

for each xxps_mstr :
delete xxps_mstr.
end.

/*****************************************���ڼƻ�*/
for each xxepl_mstr :
delete xxepl_mstr.
end.

for each xxepld_det :
delete xxepld_det.
end.


/*****************************************�������嵥*/
for each xxcpl_mstr :
delete xxcpl_mstr.
end.
for each xxcpld_det :
delete xxcpld_det.
end.


/*****************************************�����ֲ�*/
for each xxcbkd_Det :
delete xxcbkd_Det .
end.
for each xxcbk_mstr :
delete xxcbk_mstr.
end.
for each xxcbkps_mstr :
delete xxcbkps_mstr.
end.


/*****************************************�ط�*/
for each xxsl_mstr :
delete xxsl_mstr.
end.
for each xxsld_det :
delete xxsld_det.
end.


/*****************************************����*/
for each xximp_mstr :
delete xximp_mstr.
end.
for each xximpd_det :
delete xximpd_det.
end.

for each xxipr_mstr :
delete xxipr_mstr.
end.
for each xxiprd_det :
delete xxiprd_det.
end.

/*****************************************����*/
for each xxexp_mstr :
delete xxexp_mstr.
end.

for each xxexpd_det :
delete xxexpd_det.
end.


/*****************************************��ת����*/
for each xxtrh_hist  :
delete xxtrh_hist.
end.



/*****************************************prh*/
for each prh_hist :
assign prh__dec01 = 0 .
end.

