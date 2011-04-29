/*xxworp003.p 自动产生加工单    */
/* REVISION: 101028.1   Created On: 20101028   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101028.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "101028.1"}

define new shared variable dev as character format "x(8)" label "输出".
define new shared temp-table tt no-undo field tt_rec as recid .

define var part         like pt_part label "车型代码" no-undo.
define var v_qty_ord    like wo_qty_ord no-undo.
define var rel_date     as date label "发放日期" no-undo.
define var due_date     as date label "截止日期" no-undo.
define var v_type       as char format "x(1)"  no-undo.
define var v_type_list  as char format "x(10)" no-undo .

define var v_ii          as integer .
define var v_jj          as integer .

define var v_file_name   as char .
define var v_file_from   as char .
define var v_file_to     as char .

define var v_site        like wo_site .
define var v_wonbr       like wo_nbr  .
define var v_prenbr      like wo_nbr  .
define var v_seqnbr      as integer  .

define var v_desc1      like pt_desc1 format "x(48)" .
define var v_start      as char format "x(10)".
define var v_fldname    like code_fldname no-undo.
define var v_yn as logical initial no .
define var v_key1  as char no-undo .

v_fldname = "pt_wo_type".
v_key1    = mfguser + "-pt_wo_bom" .
rel_date  = today .
due_date  = today .
v_type    = "L" .

find icc_ctrl where icc_domain = global_domain no-lock no-error.
v_site = if avail icc_ctrl then icc_site else "10000" .


form
    SKIP(.2)
    part                    colon 18 label "车型代码"
    pt_desc1                colon 18 label "车型名称"
    v_qty_ord               colon 18 label "数量"
    rel_date                colon 18 label "发放日期"
    due_date                colon 18 label "截止日期"
    v_type                  colon 18 label "物料类型" 
                                     "(L-批次,S-排程,T-通用,空-所有)" 
    skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
mainloop:
repeat:

    update  part with frame a editing:
         {mfnp.i pt_mstr part  "pt_domain = global_domain and pt_part "  part pt_part pt_part}
         if recno <> ? then do:
                display 
                    pt_part  @ part 
                    pt_desc1 
                with frame a .
         end . /* if recno <> ? then  do: */    
    end. /*update ...editing */
    
    find first pt_mstr 
        where pt_domain = global_domain 
        and pt_part = part
    no-lock no-error.
    if not avail pt_mstr then do:
        message "错误:车型代码不存在,请重新输入".
        next-prompt part with frame a .
        undo,retry.
    end.
    disp pt_desc1 with frame a .

    setloop:
    do on error undo, retry on endkey undo, leave :                    
        update v_qty_ord rel_date due_date v_type with frame a .
        if v_qty_ord <= 0 then do:
            message "错误:数量仅限正数,请重新输入".
            next-prompt v_qty_ord with frame a .
            undo,retry.
        end.

        if rel_date < today or rel_date = ? then do:
            message "错误:发放日期不可小于今天,请重新输入".
            next-prompt rel_date with frame a .
            undo,retry.
        end.

        if due_date < today or due_date = ? then do:
            message "错误:截止日期不可小于今天,请重新输入".
            next-prompt due_date with frame a .
            undo,retry.
        end.

        find first code_mstr 
            where code_domain = global_domain 
            and code_fldname  = v_fldname 
        no-lock no-error.
        if not avail code_mstr then do:
            message "错误:物料类型通用代码(pt_wo_type)未维护".
            undo,retry.
        end.
        else do:
            if v_type <> "" then do:
                find first code_mstr 
                    where code_domain = global_domain 
                    and code_fldname  = v_fldname 
                    and code_value    = v_type
                no-lock no-error.
                if not avail code_mstr then do:
                    message "错误:无效类型,请重新输入".
                    next-prompt v_type with frame a .
                    undo,retry.
                end.
                v_type_list = v_type .
            end.
            else do:
                v_type_list = "" .
                for each code_mstr 
                    where code_domain = global_domain 
                    and code_fldname  = v_fldname 
                no-lock:
                v_type_list = code_value + "," + v_type_list.   
                end.
            end.
        end.

        /*车型展开BOM*/
        run bom_down (input part, input rel_date).

        find first usrw_wkfl 
            where usrw_domain = global_domain 
            and  usrw_key1    = v_key1
        no-lock no-error.
        if not avail usrw_wkfl then do:
            message "警告:车型展开后,指定类型的物料不存在" .
            undo mainloop, retry mainloop.
        end.

        printerloop:
        do on error undo , retry:
            if dev = "" then do:
                if can-find(prd_det where prd_dev = "printer") then   dev = "printer".
                else do:
                    find last prd_det where prd_path <> "terminal" and prd_dev <> "terminal" no-lock no-error.
                    if available prd_det then dev = prd_dev.
                    else dev = "printer".
                end.
            end.
            display dev to 77  with frame a.
            set dev with frame a editing:
                if frame-field = "dev" then do:
                    {mfnp05.i prd_det prd_dev "yes" prd_dev "input dev"}
                    if recno <> ? then do:
                        dev = prd_dev.
                        display dev with frame a.
                    end.
                end.
            end.
            if not can-find(first prd_det where prd_dev = dev) then do:
                {mfmsg.i 34 3}
                undo,retry.
            end.        
        end. /*printerloop:*/



        p1-loop: 
        do on error undo, retry on endkey undo, leave :                   
            {gprun.i ""xxworp003p1.p"" 
                     "(input part,
                       input v_qty_ord ,
                       input rel_date  ,
                       input due_date  ,
                       input v_type_list   ,
                       input v_key1 )"}
        end. /* p1-loop: */

        message "           确认产生加工单?            " view-as alert-box question buttons yes-no title "" update v_yn .
        if v_yn then do:
            v_file_name = "worp003-" 
                          + "-" + global_userid 
                          + string(year(today),"9999") 
                          + string(month(today),"99") 
                          + string(day(today),"99") 
                          + "-" + substring(string(time,"hh:mm:ss"),1,2)
                          + substring(string(time,"hh:mm:ss"),4,2)
                          + substring(string(time,"hh:mm:ss"),7,2)
                          + "-" + mfguser   .
            v_file_from = v_file_name + ".i" .
            v_file_to   = v_file_name + ".o" .
            output to value(v_file_from) .
                for each usrw_wkfl 
                    where usrw_domain = global_domain 
                    and  usrw_key1    = v_key1 
                    break by usrw_key4 by usrw_key3:

                    if first-of(usrw_key4) then do:
                        v_wonbr  = "" .
                        v_prenbr = usrw_key4 + substring(string(year(rel_date),"9999"),3,2) + string(month(rel_date),"99") + string(day(rel_date),"99") .
                        v_seqnbr = 0 .
                        for each wo_mstr 
                            use-index wo_nbr
                            where wo_domain = global_domain 
                            and wo_nbr begins v_prenbr 
                            no-lock 
                            break by wo_domain by wo_nbr:
                            
                            if last-of(wo_domain) then do:
                                if length(wo_nbr) = 10 then do:
                                    v_seqnbr = integer(substring(wo_nbr,8,3)) no-error.
                                    if error-status:error then v_seqnbr = 0 .
                                end.
                            end.
                        end. /* for each wo_mstr */

                        v_wonbr = v_prenbr + string(v_seqnbr + 1,"999") .                        
                    end. /*if first-of(usrw_key4)*/

                    put unformatted '"' v_wonbr '"' space 
                                    ' " " '
                                    skip.
                    put unformatted '"' usrw_key3 '"' space 
                                    " - " space  
                                    '"' v_site  '"' 
                                    skip.
                    put unformatted usrw_decfld[1] space 
                                    today    space 
                                    rel_date space 
                                    due_date space 
                                    '"R" - - - ' space 
                                    '"' v_site '"'  space 
                                    ' - - - N Y' space 
                                    skip.
                    put unformatted '"No"' 
                                    skip.
                    put unformatted '-' 
                                    skip.
                    put unformatted '- - - - - - - - - - - - - - - - - - - - - - ' 
                                    skip .

                end . /*for each usrw_wkfl*/
            output close .


            for each tt : delete tt . end .
            /*取得wo_mstr记录ID*/
            on create of wo_mstr do:
                find first tt where tt_rec = recid(wo_mstr) no-lock no-error.
                if not available tt then do:
                    create tt. tt_rec = recid(wo_mstr).
                end.
            end.

            input from value(v_file_from) .
            output to value(v_file_to).
                {gprun.i ""xxwowomt-cim.p"" }
            output close .
            input close.


            find first tt no-error.
            if not avail tt then message "警告:未产生加工单.".
            else do:

                p2-loop: 
                do on error undo, retry on endkey undo, leave :                   
                    {gprun.i ""xxworp003p2.p"" 
                             "(input part,
                               input v_qty_ord ,
                               input v_type_list   )"}
                end. /* p2-loop: */            



                v_ii = 0 .
                for each usrw_wkfl 
                    where usrw_domain = global_domain 
                    and  usrw_key1    = v_key1
                    no-lock:
                    v_ii = v_ii + 1 .
                end.
                v_jj = 0 .
                for each tt no-lock:
                    v_jj = v_jj + 1 .
                end.
                if v_jj = v_ii then do:
                    /*删除历史记录*/
                    if opsys = "unix" then do:
                        unix silent value ( 'rm -f '  + v_file_from).
                        unix silent value ( 'rm -f '  + v_file_to).
                    end.
                    else if opsys = "win32" then do:
                        dos silent value ( 'del /q '  + v_file_from).
                        dos silent value ( 'del /q '  + v_file_to).
                    end.
                end.
            end. /*else do:*/
            {pxmsg.i &MSGNUM=3120 &ERRORLEVEL=1}
        end. /*if v_yn then do:*/
    end. /*setloop*/


    for each usrw_wkfl 
        where usrw_domain = global_domain 
        and  usrw_key1    = v_key1
        :  
        delete usrw_wkfl .  
    end .

end.  /* mainloop */
{wbrp04.i &frame-spec = a}

/*------------------------------------- procedure define below -------------------------------------------------------------*/
procedure bom_down:
    define input  parameter vv_part     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    
    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.


    for each usrw_wkfl 
        where usrw_domain = global_domain 
        and  usrw_key1    = v_key1
        :  
        delete usrw_wkfl .  
    end .

    assign vv_level = 1 
           vv_comp  = vv_part
           vv_save_qty = 0 
           vv_qty      = 1 .

    
    find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error .
    repeat:        
           if not avail ps_mstr then do:                        
                 repeat:  
                    vv_level = vv_level - 1.
                    if vv_level < 1 then leave .                    
                    find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                    vv_comp  = ps_par.  
                    vv_qty = vv_save_qty[vv_level].            
                    find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and  ps_par = vv_comp  no-lock no-error.
                    if avail ps_mstr then leave .               
                end.
            end.  /*if not avail ps_mstr*/
        
            if vv_level < 1 then leave .
            vv_record[vv_level] = recid(ps_mstr).                
            
            
            if (ps_end = ? or vv_eff_date <= ps_end) then do :
                    vv_save_qty[vv_level] = vv_qty.

                    find first pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error.
                    if avail pt_mstr and pt_ship_wt_um <> "" and index(v_type_list,pt_ship_wt_um) <> 0 then do: /*不再继续展开*/
                        v_start = if ps_start = ? then "" else string(ps_start) . /*直接用string(ps_start)会出问题*/
                        find first usrw_wkfl 
                            where usrw_domain  = global_domain 
                            and   usrw_key1    = v_key1 
                            and   usrw_key2    = vv_part + "|" + ps_comp + "|" + ps_ref + "|" + string(v_start)
                        no-error.
                        if not available usrw_wkfl then do:
                            create usrw_wkfl.
                            assign
                                usrw_domain  = global_domain                                                    
                                usrw_key1    = v_key1                                              
                                usrw_key2    = vv_part + "|" + ps_comp + "|" + ps_ref + "|" + string(v_start)   
                                usrw_key3    = ps_comp
                                usrw_key4    = pt_ship_wt_um
                                usrw_decfld[1] = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                                .
                        end.
                        else usrw_decfld[1] =  usrw_decfld[1] + vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)) .

                        find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                    end.  /*不再继续展开*/
                    else do:  /*继续展开*/
                        vv_comp  = ps_comp .
                        vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                        vv_level = vv_level + 1.

                        find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.     
                    end.  /*继续展开*/
            end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
            else do:
                  find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
            end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
    end. /*repeat:*/   

end procedure. /*bom_down*/



/*取工单编号**
        v_wonbr  = "" .
        v_prenbr = v_type + substring(string(year(eff_date),"9999"),3,2) + string(month(eff_date),"99") + string(day(eff_date),"99") .
        v_seqnbr = 0 .
        for each wo_mstr 
            use-index wo_nbr
            where wo_domain = global_domain 
            and wo_nbr begins v_prenbr 
            no-lock 
            break by wo_domain by wo_nbr:
            
            if last-of(wo_domain) then do:
                if length(wo_nbr) = 10 then do:
                    v_seqnbr = integer(substring(wo_nbr,8,3)) no-error.
                    if error-status:error then v_seqnbr = 0 .
                end.
            end.
        end. 
        v_wonbr = v_prenbr + string(v_seqnbr + 1,"999") .
*/
