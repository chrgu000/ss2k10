/*V8:ConvertMode=FullGUIReport                                                */
define {1} shared temp-table tmp_bom
	fields tb_comp  like ps_comp
	fields tb_par   like ps_par
	fields tb_level as   integer
	fields tb_qty   like ps_qty_per
	fields tb_sn    as integer
	fields tb_pm    like pt_pm_code
	fields tb_phantom like pt_phantom
	index tb_comp_sn tb_comp tb_sn
	index tb_comp_par tb_comp tb_par
	index tb_par_comp tb_par tb_comp
	.
