/*By: Neil Gao 08/12/02 ECO: *SS 20081202* */

{mfdeclre.i}  
{gplabel.i} 


define shared temp-table xxtt1 
	field xxtt1_f1 as char format "x(6)"
	field xxtt1_f2 like ps_comp
	field xxtt1_f3 like pt_desc1
	field xxtt1_f4 like ps_qty_per
	field xxtt1_f5 like pt_um
	field xxtt1_f6 like pt_phantom
	field xxtt1_f7 like pt_pm_code
	field xxtt1_f8 like pt_iss_pol.


form
	xxtt1_f1 column-label "层级"
	xxtt1_f2 column-label "组件"
	xxtt1_f3 column-label "说明"
	xxtt1_f4 column-label "每件需求量"
	xxtt1_f5 column-label "UM"
	xxtt1_f6 column-label "虚"
	xxtt1_f7 column-label "PM"
	xxtt1_f8 column-label "发"
with frame e width 80 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).


for each xxtt1 no-lock:
	disp xxtt1 with frame e.
	down with frame e.
end.