
/* REVISION: 1.0         Last Modified: 2008/10/18   By: Roger   ECO:*xp001*  */
/*-Revision end------------------------------------------------------------*/


define variable outfile        as char format "x(40)"  no-undo.  /*for cimload*/
/*
define variable ciminputfile   as char format "x(40)"  no-undo.  /*for cimload*/
define variable cimoutputfile  as char format "x(40)"  no-undo.  /*for cimload*/
�Ѿ���ǰ��xswoi10u.i����
*/ 
ciminputfile  = "" .
cimoutputfile = "" . 

define variable v_ok      like mfc_logical initial yes no-undo.  /*for cimload*/

define var v_qty_other like ld_qty_oh .
define var v_qty_before1 like ld_qty_oh .
define var v_qty_before2 like ld_qty_oh .
define var v_qty_before3 like ld_qty_oh .
define var v_qty_need like wod_qty_req .
define var v_qty_bom like wod_bom_qty .
define var v_qty_iss like wod_qty_iss .
define var v_op like wod_op .

/*-----------�����Ƿ�ı�BOM start---------------------------------*/
define var v_chg_bom as logical .
v_chg_bom = yes .
for each wod_det where wod_lot = v1110 no-lock:
    if v_chg_bom = no then leave .
    find first pt_mstr where pt_part = wod_part no-lock no-error .
    if avail pt_mstr then do:
        if pt_prod_line <> "S000" then v_chg_bom = no.
    end.
end.
/*-----------�����Ƿ�ı�BOM end---------------------------------*/


v_op = 0     .
v_qty_need = 0 . /*δ����������*/
v_qty_bom = 0 . 
v_qty_iss = 0 .
find first wod_det where wod_lot = v1110 and wod_part = v1300 /*and wod_op = vxxxx*/ no-lock no-error .
if avail wod_det then do:
            v_op = wod_op .
            v_qty_need = wod_qty_req . /*δ����������*/
            v_qty_bom = wod_bom_qty. 
            v_qty_iss = wod_qty_iss .
end. /*if avail wod_det then do:*/

            v_qty_other = 0 . /*�������ε����б���������: ����,�ٳ�ȥ����λ�����κͲ��߿�λ�ͱ�����*/
            for each lad_det 
                where lad_dataset = "wod_det"
                and lad_nbr = v1110 
                and lad_line = string(v_op )
                and lad_part = v1300
                and lad_site = v1002
                and ( /*lad_loc  <> v1550  and*/ lad_lot  <> v1500 )
                and lad_ref  = "" 
            no-lock :
                v_qty_other = v_qty_other + (lad_qty_pick + lad_qty_all) .
            end.

            find first lad_det 
                where lad_dataset = "wod_det"
                and lad_nbr = v1110 
                and lad_line = string(v_op )
                and lad_part = v1300
                and lad_site = v1002
                and lad_loc  = v1550
                and lad_lot  = v1500
                and lad_ref  = "" 
                and ( lad_qty_all + lad_qty_pick <> 0 )
            no-lock no-error . 
            v_qty_before1 = if avail lad_det then (lad_qty_all  ) else 0 . /*���η���ǰ,�������ڱ���λ�ı�������*/
            v_qty_before2 = if avail lad_det then (lad_qty_pick ) else 0 . /*���η���ǰ,�������ڱ���λ����������*/


            /*v_qty_before3���η���ǰ,�������������߿�λ������,��������ۼ�*/
            find first lad_det 
                where lad_dataset = "wod_det"
                and lad_nbr = v1110 
                and lad_line = string(v_op )
                and lad_part = v1300
                and lad_site = v1002
                and lad_loc  = v1660
                and lad_lot  = v1500
                and lad_ref  = "" 
            no-lock no-error . 
            v_qty_before3 = if avail lad_det then (lad_qty_pick /*+ lad_qty_all������û�б�����ֻ��������*/  ) else 0 . 

            
            /*
            message "1����:" v_qty_need v_qty_iss skip 
                    "����:" v_qty_other  v_qty_before3  v_qty_before2  v_qty_before1 skip
                    "����:"  v1600 skip
                    "����:" v_qty_bom view-as alert-box. 
            */


            if v_qty_other + v_qty_iss  + v_qty_before3 + decimal(V1600) <> v_qty_need then do:
               find first wo_mstr where wo_lot = v1110 no-lock no-error .
               if v_chg_bom then do:
                   v_qty_need = v_qty_other + v_qty_iss + decimal(V1600) + v_qty_before3  .
                   v_qty_bom  = truncate(v_qty_need / wo_qty_ord,5) .
               end.
               else do:
                   if v_qty_other + v_qty_iss  + v_qty_before3 + decimal(V1600) > v_qty_need then 
                   v_qty_need = v_qty_other + v_qty_iss + decimal(V1600) + v_qty_before3  .
               end.
            end.
           
           if  v_chg_bom = no and 
               decimal(V1600) < (v_qty_before2 + v_qty_before1 ) 
           then do: /*�����BOM&REQ,�ҷ���������ԭ����������*/
               if  decimal(V1600) >= v_qty_before2 then do:
                    v_qty_before1 = v_qty_before1 - (decimal(V1600) - v_qty_before2 ) .
                    v_qty_before2 = 0 .
               end .
               else do:
                   v_qty_before1 = v_qty_before1 .
                   v_qty_before2 = v_qty_before2 -  decimal(V1600) .
               end.
           end.

            /*
            message "2����:" v_qty_need v_qty_iss skip 
                    "����:" v_qty_other  v_qty_before3  v_qty_before2  v_qty_before1 skip
                    "����:"  v1600 skip
                    "����:" v_qty_bom view-as alert-box. 
            */


            /*cimload start ---------------------------------------------------*/
            outfile = "woi10" + '-' + "wowamt.p" + '-' + substring(string(year(TODAY)),3,2) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99') + '-' + entry(1,STRING(TIME,'hh:mm:ss'),':') + entry(2,STRING(TIME,'hh:mm:ss'),':') + entry(3,STRING(TIME,'hh:mm:ss'),':') + '-' + trim(string(RANDOM(1,100)))  .

			ciminputfile = outfile + ".i" .

            output to value(ciminputfile).
				put unformatted "-   "  """" v1110 """" skip . /*wonbr,wolot*/
                put unformatted """" v1300 """" " - " skip . /*part,op*/
                put unformatted v_qty_need "   " v_qty_need . /*qty_need , qty_all */
                    /*����Ļ��ܱ�����=������,������������С����ϸ������ʱ,���Զ�����������Ϻͱ�����*/
                put unformatted "   0  Y  " .  /*qty_pick = 0 */
                put unformatted v_qty_bom . /*qty_bom*/
                put unformatted "   -  -  -  -  -  - "  skip . /*qty...*/
                
				/*-----------------detail----------------------*/
                find first lad_det 
                    where lad_dataset = "wod_det"
                    and lad_nbr = v1110 
                    and lad_line = string(v_op )
                    and lad_part = v1300
                    and lad_site = v1002
                    and lad_loc  = v1550
                    and lad_lot  = v1500
                    and lad_ref  = "" 
                    and ( lad_qty_all + lad_qty_pick <> 0 )
                no-lock no-error . 
                if avail lad_det then do:
                        put unformatted 
                            """"  trim( V1550 )  """" 
                            + "   " 
                            + ( if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """" ) 
                            + " - "  format "X(50)"
                            skip .   /*loc lot ref */

                       if  v_chg_bom = no and 
                           decimal(V1600) < (lad_qty_all + lad_qty_pick) 
                       then do: /*�����BOM&REQ,�ҷ���������ԭ����������, ��ȡ�������ε�ʣ�౸����*/
                            put unformatted 
                                trim ( string(v_qty_before1) )  format "x(20)" 
                                trim ( string(v_qty_before2) )  format "x(20)" 
                                skip .  /*qty_all ,qty_pick*/                            
                       end.
                       else do: /*����,ȡ�������ε�ʣ�౸����*/
                            put unformatted 
                                " 0 " 
                                " 0 " 
                                skip .  /*qty_all ,qty_pick*/ 
                       end.
                end.

				put unformatted 
                    """"  trim(v1660) """" 
                    +  "   " 
                    + ( if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"  ) 
                    + " - " format "X(50)"
                    skip .   /*loc lot ref */
				put unformatted 
                    " 0 "  
                    trim ( string(v_qty_before3 + decimal(V1600)) )  format "x(50)" 
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


/*{xserrlg.i}*/     /*�Ѿ���ǰ��xswoi10u.i����*/

run datain.         /*move-out-from-xserrlg.i*/
run dataout(output v_cimload_ok) .    /*move-out-from-xserrlg.i*/

if v_cimload_ok = yes then do:
    unix silent value ( "rm -f "  + ciminputfile).
    unix silent value ( "rm -f "  + cimoutputfile).
end.
            
            /*if v_ok then do:
            end. */
			if not v_ok then do:
                    hide all no-pause .
					display  "�������޸Ĳ��ɹ�," skip with fram F9000Y no-box .
                    display  "���ֹ��޸�:" skip with fram F9000Y no-box .
                    display  "ID/Pt:" + v1110 + "/" + v1300 format "x(40)" skip with fram F9000Y no-box .
                    display  "Qty/Lot:" + v1600 + "/" + v1500 format "x(40)" skip with fram F9000Y no-box .
                    display  "Loc:" + v1550  format "x(40)" skip with fram F9000Y no-box .
                    display  "..�����������.." format "x(40)" skip with fram F9000Y no-box .
                    pause  no-message .
			end.

            /*cimload end ---------------------------------------------------*/

if v_ok then do:
    for each lad_det 
        where lad_dataset = "wod_det"
        and lad_nbr = v1110 
        and lad_line = string(v_op)
        and lad_part = v1300
        and lad_site = v1002
        /*and lad_loc  = V1550 
        and lad_lot  = v1500
        and lad_ref  = "" */
        and lad_qty_all = 0 and lad_qty_pick = 0 :
            delete lad_det .
    end.

end. /*if ok then */
