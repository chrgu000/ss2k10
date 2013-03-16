/* GUI CONVERTED from yypcso.p (converter v1.78) Mon Oct 22 19:46:32 2012 */
/* yypcso.p - yypcso.p                                                       */
/*V8:ConvertMode=Report                                                      */
/* REVISION END                                                              */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121017.1"}
def var vend like pc_list.
def var part like pt_part.
def var vendpart like vp_vend_part.
def var comp like ps_comp.
def var eff_date like pc_start init today.

def temp-table item_tmp
    field item_part like pt_part
/*    field item_vend like vp_vend
    field item_vendpart like vp_vend_part
    field item_so like pt_part */
    index item_part item_part.
def temp-table sotmp
    field sotmp_comp like pt_part
    field sotmp_par like pt_part
    index indx01 sotmp_comp sotmp_par.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  vend part eff_date  with frame a WIDTH 80 /*GUI*/ THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).


repeat:
update vend part eff_date with frame a.
{mfselprt.i "terminal" 80}
empty temp-table item_tmp.
empty temp-table sotmp.
for each pt_mstr where pt_mstr.pt_domain = global_domain and (pt_part begins part) no-lock,
    each pc_mstr where pc_mstr.pc_domain = global_domain and pc_part = pt_part
		   and (pc_list = vend or pc_list = vend + "L")
                   and (pc_start <= eff_date or pc_start = ? or eff_date = ?)
                   and (pc_expire >= eff_date or pc_expire = ? or eff_date = ?)
                   no-lock:
    for first item_tmp where item_part = pc_part no-lock: end.
    if not avail item_tmp then do:
		    create item_tmp.
		    assign item_part = pc_part.
    end.
end.
for each item_tmp no-lock:
disp item_tmp WITH STREAM-IO /*GUI*/ .
end.
for each item_tmp no-lock:
    comp = item_part.
    run extent_bom(item_part).
end.

for each sotmp where  no-lock:
    disp sotmp WITH STREAM-IO /*GUI*/ .
end.
empty temp-table item_tmp.
empty temp-table sotmp.
      {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

      {mfgrptrm.i}
end.

procedure extent_bom:
    define input parameter precomp like ps_comp.
    define var up-lvl as log.
    define var input_precomp like ps_comp.
    up-lvl = no.
    input_precomp = precomp.
    for first pt_mstr where pt_mstr.pt_domain = global_domain and  pt_part = precomp no-lock: end.
    if not avail pt_mstr then do:
       for first pt_mstr where pt_domain = global_domain and pt_part + "ZZ" = precomp no-lock: end.
    end.
    if avail pt_mstr and (pt_prod_line begins "2" or pt_prod_line begins "7") then do:
       find sotmp where sotmp_comp = comp and sotmp_par = precomp no-lock no-error.
       if not avail sotmp then do:
          create sotmp.
          assign sotmp_comp = comp
                 sotmp_par  = precomp.
       end.
    end.
    for first ps_mstr where ps_mstr.ps_domain = global_domain and ps_comp = precomp and (ps_start <= eff_date or eff_date = ? or ps_start = ?)
										and (ps_end >= eff_date or eff_date = ? or ps_end = ?)  no-lock: end.
    if not avail ps_mstr then do:
       up-lvl = yes.
       /**
       find sotmp where sotmp_comp = comp and sotmp_par = precomp no-lock no-error.
       if not avail sotmp then do:
          create sotmp.
          assign sotmp_comp = comp
                 sotmp_par  = precomp.
       end.
       **/
       leave.
    end.
    if not up-lvl then
		for each ps_mstr where ps_mstr.ps_domain = global_domain and ps_comp = precomp and (ps_start <= eff_date or eff_date = ? or ps_start = ?)
													and (ps_end >= eff_date or eff_date = ? or ps_end = ?) no-lock:
		    run  extent_bom(ps_par).
		end.
		precomp = input_precomp.
end procedure.