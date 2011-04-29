
/* REVISION: 1.0         Last Modified: 2008/10/18   By: Roger   ECO:*xp001*  */
/*-Revision end------------------------------------------------------------*/


define variable outfile        as char format "x(40)"  no-undo.  /*for cimload*/
/*
define variable ciminputfile   as char format "x(40)"  no-undo.  /*for cimload*/
define variable cimoutputfile  as char format "x(40)"  no-undo.  /*for cimload*/
已经在前面xswoi10u.i定义
*/ 
ciminputfile  = "" .
cimoutputfile = "" . 

define variable v_ok      like mfc_logical initial yes no-undo.  /*for cimload*/

define var v_qty_other like ld_qty_oh .
define var v_qty_before like ld_qty_oh .
define var v_qty_need like wod_qty_req .
define var v_qty_bom like wod_bom_qty .

/*-----------决定是否改变BOM start---------------------------------*/
define var v_chg_bom as logical .
v_chg_bom = yes .
for each wod_det where wod_lot = v1110 no-lock:
    if v_chg_bom = no then leave .
    find first pt_mstr where pt_part = wod_part no-lock no-error .
    if avail pt_mstr then do:
        if pt_prod_line <> "S000" then v_chg_bom = no.
    end.
end.
/*-----------决定是否改变BOM end---------------------------------*/

find first wod_det where wod_lot = v1110 and wod_part = v1300 /*and wod_op = vxxxx*/ no-lock no-error .
if avail wod_det then do:

            find first lad_det 
                where lad_dataset = "wod_det"
                and lad_nbr = wod_lot 
                and lad_line = string(wod_op)
                and lad_part = wod_part
                and lad_site = wod_site
                and lad_loc  = v1400
                and lad_lot  = v1500
                and lad_ref  = "" 
            no-lock no-error . 
            v_qty_before = if avail lad_det then lad_qty_pick else 0 . /*本次发料前,该批次在生产线库位的数量,用于最后累加*/


            v_qty_need = wod_qty_req . /*原始需求量*/

            v_qty_bom = wod_bom_qty . /*原始用量*/

            find first wo_mstr where wo_lot = wod_lot no-lock no-error .
            if  v_chg_bom then do :
                v_qty_need = wod_qty_req - decimal(v1600)  . /*未来的需求量*/
                v_qty_bom  = truncate(v_qty_need / wo_qty_ord,5) .  /*未来的单位用量 =  未来需求量/批量 */
            end.
            else do:
                if wod_qty_req - decimal(v1600) > wod_qty_req then v_qty_need = wod_qty_req - decimal(v1600)  . /*未来的需求量*/
            end.


           


            /*cimload start ---------------------------------------------------*/
            outfile = "woi12" + '-' + "wowamt.p" + '-' + substring(string(year(TODAY)),3,2) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99') + '-' + entry(1,STRING(TIME,'hh:mm:ss'),':') + entry(2,STRING(TIME,'hh:mm:ss'),':') + entry(3,STRING(TIME,'hh:mm:ss'),':') + '-' + trim(string(RANDOM(1,100)))  .

            ciminputfile = outfile + ".i" .

			output to value(ciminputfile).
				put unformatted "-   "  """" v1110 """" skip . /*wonbr,wolot*/
                put unformatted """" v1300 """" " - " skip . /*part,op*/
                put unformatted v_qty_need . /*qty_need*/
                put unformatted "   0   -  Y  " .  /*qty_all = 0 */
                put unformatted v_qty_bom . /*qty_bom*/
                put unformatted "   -  -  -  -  -  - "  skip . /*qty...*/
                
				/*-----------------detail----------------------*/


				put unformatted 
                    """" trim(v1400) """" 
                    +  "   " 
                    + ( if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"  ) 
                    + " - " format "X(50)"
                    skip .   /*loc lot ref */
				put unformatted 
                    " 0 "  
                    trim ( string(v_qty_before - decimal(V1600)) )  format "x(50)" 
                    skip . /*qty_all ,qty_pick*/ 
                put "." skip.
                /*-----------------detail----------------------*/
                put "." skip .
                put "." skip .


			output close.

			cimoutputfile  = outfile + ".o".
			input from value(ciminputfile).
			output to  value (cimoutputfile) .
			    {gprun.i ""wowamt.p""} 
			input close.
			output close.


/*{xserrlg.i}*/    /*已经在前面xswoi10u.i定义*/

run datain.        /*move-out-from-xserrlg.i*/
run dataout(output v_cimload_ok) .    /*move-out-from-xserrlg.i*/

if v_cimload_ok = yes then do:
    unix silent value ( "rm -f "  + ciminputfile).
    unix silent value ( "rm -f "  + cimoutputfile).
end.
			if not v_ok then do:
                    hide all no-pause .
					display  "备料数修改不成功," skip with fram F9000Y no-box .
                    display  "请手工修改:" skip with fram F9000Y no-box .
                    display  "ID/Pt:" + v1110 + "/" + v1300 format "x(40)" skip with fram F9000Y no-box .
                    display  "Qty/Lot:" + v1600 + "/" + v1500 format "x(40)" skip with fram F9000Y no-box .
                    display  "Loc:" + v1400  format "x(40)" skip with fram F9000Y no-box .
                    display  "..按任意键继续.." format "x(40)" skip with fram F9000Y no-box .
                    pause  no-message .
			end.

            /*cimload end ---------------------------------------------------*/

if v_ok then do:
    for each lad_det 
        where lad_dataset = "wod_det"
        and lad_nbr = wod_lot 
        and lad_line = string(wod_op)
        and lad_part = wod_part
        and lad_site = wod_site
        and lad_loc  = V1400 
        and lad_lot  = v1500
        and lad_ref  = "" 
        and lad_qty_all = 0 and lad_qty_pick = 0 :
            delete lad_det .
    end.

end. /*if ok then */

end. /*if avail wod_det then do:*/










