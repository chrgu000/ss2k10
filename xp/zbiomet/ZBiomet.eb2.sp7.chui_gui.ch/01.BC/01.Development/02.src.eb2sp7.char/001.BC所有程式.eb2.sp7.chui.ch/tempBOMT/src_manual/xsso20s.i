/*
define shared variable batchrun as logical .
define shared variable global_user_lang_dir as char format "x(40)" .
define shared variable global_gblmgr_handle as handle no-undo.
run pxgblmgr.p persistent set global_gblmgr_handle.
*/

find first code_mstr 
    where code_fldname = "barcode" 
    and code_value ="global_user_lang_dir" 
no-lock no-error.
if available(code_mstr) then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1) <> "/" then global_user_lang_dir = global_user_lang_dir + "/".
/**/


define variable ausection as char format "x(16)".
define variable ciminputfile   as char .
define variable cimoutputfile  as char .

define var v_msg as char format "x(28)" .
define variable v_qty_old     like lad_qty_pick.    



v_qty_old = 0 .           
find first lad_det 
    where lad_dataset = "sod_det" 
    and lad_nbr = v_nbr 
    and lad_line = string(v_line) 
    and lad_site = v1002
    and lad_loc  = v1510
    and lad_part = v1300
    and lad_lot  = v1500
no-error .
if avail lad_det then do:
    v_qty_old = v_qty_old + lad_qty_pick .
    
    /*本次如果是修改已有记录:扣除之前此箱的数量*/
    find first xpkd_det 
      where xpkd_nbr = v1005 
        and xpkd_sonbr = v_nbr 
        and xpkd_soline = v_line 
        and xpkd_site = v1002 
        and xpkd_lot = v1500 
        and xpkd_loc = v1510 
        and xpkd_box = integer(v1006)
    no-error.
    if avail xpkd_det then do:
        v_qty_old = max(0,v_qty_old - xpkd_qty_pk) .
    end.
end.  
	                                  
ausection = "so20" + '-' + "sosoal.p" + '-' + substring(string(year(TODAY)),3,2) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99') + '-' + entry(1,STRING(TIME,'hh:mm:ss'),':') + entry(2,STRING(TIME,'hh:mm:ss'),':') + entry(3,STRING(TIME,'hh:mm:ss'),':') + '-' + trim(string(RANDOM(1,100)))  .
output to value(trim(ausection) + ".i") .
     put unformatted trim (v_nbr) + " " + trim (v1002) format "x(50)"  skip .
     put unformatted "n y - n" format "x(50)" skip.
     put unformatted trim(string(v_line)) format "x(50)" skip.
     put unformatted "0 0 y" skip.
     put unformatted trim (v1510) + " " + trim(v1500) + "   - " format "x(50)" skip.
     put unformatted " - "   + string ( decimal(v1600) + v_qty_old ) format "x(50)" skip.
     put unformatted "." skip .
     put unformatted "." skip .
     put unformatted "." skip .
output close.
        
batchrun = yes.        
input from value (trim(ausection) + ".i") .
output to  value (trim(ausection) + ".o") .
    {gprun.i ""sosoal.p""}
input close.
output close.

ciminputfile = trim(ausection) + ".i".
cimoutputfile = trim(ausection) + ".o".
{xserrlg.i}


/*
1.需找得到库位批号备料记录lad,且数量正确的,算成功(本次清零或备料都是)
2.找不到记录的,且本次备料数量等于0,算成功
3.其他失败
*/
         
find first lad_det 
    where lad_dataset = "sod_det" 
    and lad_nbr = v_nbr 
    and lad_line = string(v_line) 
    and lad_site = v1002
    and lad_loc  = v1510
    and lad_part = v1300
    and lad_lot  = v1500
no-error .
if avail lad_det then do:
    if lad_qty_pick = decimal(v1600) + v_qty_old then do:
        v_msg = "装箱成功." .
        
        find first xpk_mstr 
          where xpk_nbr = v1005 
            and xpk_sonbr = v_nbr 
            and xpk_soline = v_line 
            and xpk_site = v1002 
            and xpk_lot = v1500 
            and xpk_loc = v1510 
        no-error.
        if not avail xpk_mstr then do:
                /*按批号精确匹配不到的,按Sonbr+soline模糊匹配*/
                find first xpk_mstr 
                  where xpk_nbr = v1005 
                    and xpk_sonbr = v_nbr 
                    and xpk_soline = v_line 
                no-error.
        end.

        /*最终必须有一笔xpk_mstr才可以备料*/
        if avail xpk_mstr then do:
            xpk_stat = "A" .
            find first xpkd_det 
              where xpkd_nbr = v1005 
                and xpkd_sonbr = v_nbr 
                and xpkd_soline = v_line 
                and xpkd_site = v1002 
                and xpkd_lot = v1500 
                and xpkd_loc = v1510 
                and xpkd_box = integer(v1006)
            no-error.
            if avail xpkd_det then do:
                xpkd_qty_pk = decimal(v1600) .
            end.
            else do:
                find first sod_det where sod_nbr = v_nbr and sod_line = v_line no-lock no-error .

                create xpkd_det .
                assign 
                    xpkd_nbr = v1005     
                    xpkd_sonbr = v_nbr   
                    xpkd_soline = v_line 
                    xpkd_site = v1002    
                    xpkd_lot = v1500     
                    xpkd_loc = v1510     
                    xpkd_box = integer(v1006) 
                    xpkd_part = v1300 
                    xpkd_shipto = xpk_shipto
                    xpkd_pk_date = today 
                    xpkd_pk_time = time
                    xpkd_user1   = global_userid
                    xpkd_category = if avail sod_Det then sod_order_category else "" 
                    xpkd_qty_pk  = decimal(v1600) .
            end.
        end.
    end.
    else v_msg =  "装箱失败." .
end.
else if decimal(v1600) = 0 then do:
    v_msg = "装箱成功." .
        find first xpk_mstr 
          where xpk_nbr = v1005 
            and xpk_sonbr = v_nbr 
            and xpk_soline = v_line 
            and xpk_site = v1002 
            and xpk_lot = v1500 
            and xpk_loc = v1510 
        no-error.
        if not avail xpk_mstr then do:
                /*按批号精确匹配不到的,按Sonbr+soline模糊匹配*/
                find first xpk_mstr 
                  where xpk_nbr = v1005 
                    and xpk_sonbr = v_nbr 
                    and xpk_soline = v_line 
                no-error.
        end.

        /*最终必须有一笔xpk_mstr才可以备料*/
        if avail xpk_mstr then do:
            xpk_stat = "A" .
            find first xpkd_det 
              where xpkd_nbr = v1005 
                and xpkd_sonbr = v_nbr 
                and xpkd_soline = v_line 
                and xpkd_site = v1002 
                and xpkd_lot = v1500 
                and xpkd_loc = v1510 
                and xpkd_box = integer(v1006)
            no-error.
            if avail xpkd_det then do:
                xpkd_qty_pk = decimal(v1600) .
            end.
            else do:
                find first sod_det where sod_nbr = v_nbr and sod_line = v_line no-lock no-error .

                create xpkd_det .
                assign 
                    xpkd_nbr = v1005     
                    xpkd_sonbr = v_nbr   
                    xpkd_soline = v_line 
                    xpkd_site = v1002    
                    xpkd_lot = v1500     
                    xpkd_loc = v1510     
                    xpkd_box = integer(v1006) 
                    xpkd_part = v1300 
                    xpkd_shipto = xpk_shipto
                    xpkd_pk_date = today 
                    xpkd_pk_time = time
                    xpkd_user1   = global_userid
                    xpkd_category = if avail sod_Det then sod_order_category else "" 
                    xpkd_qty_pk  = decimal(v1600) .
            end.
        end.

end.
else do:
    v_msg = "装箱失败!" .
end.


if v_msg = "装箱成功." then do:
    unix silent value ( "rm -f "  + ciminputfile  ).
    unix silent value ( "rm -f "  + cimoutputfile ).    
end .


v_qty_old = 0 .           
for each lad_det 
    where lad_dataset = "sod_det" 
    and lad_site = v1002
    and lad_loc  = v1510
    and lad_part = v1300
    and lad_lot  = v1500
no-lock :
    v_qty_old = v_qty_old + lad_qty_pick .
end.
find first ld_det 
    where ld_site = v1002 
    and ld_loc    = v1510
    and ld_part   = v1300
    and ld_lot    = v1500
    and ld_ref    = "" 
no-lock no-error .
if avail ld_det then v_qty_old = max(0,ld_qty_oh - v_qty_old) .
else v_qty_old = 0 .

hide all no-pause .
form  
    v_msg           no-label  skip 
    v1300     label "料号" format "x(20)" skip
    v1500     label "批号" format "x(20)" skip
    v1510     label "库位" format "x(20)" skip
    v_qty_old label "本批剩余"                  skip
    "...按任意键继续..." 
with frame snsn1 side-labels overlay 
row 1 width 30 no-attr-space no-box .
view frame snsn1 .

disp v_msg v1300 v1500 v1510 v_qty_old with frame snsn1.
pause no-message .
