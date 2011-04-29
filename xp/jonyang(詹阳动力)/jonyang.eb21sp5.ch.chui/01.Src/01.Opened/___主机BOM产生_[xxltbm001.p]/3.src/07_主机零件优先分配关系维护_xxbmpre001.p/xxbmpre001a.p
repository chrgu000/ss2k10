{mfdeclre.i }
{gplabel.i} 

define input parameter i-part  like ld_part no-undo .
define input parameter i-lot   like ld_lot  no-undo .
define input parameter i-wolot like wo_lot  no-undo .

define var v_ii     as integer .
define var v_lot    like ld_lot  no-undo.
define var v_zppart like pt_part no-undo .
define var v_part   like pt_part no-undo .
define var desc1    like pt_desc1 .
define var desc2    like pt_desc2 .
define var v_include as logical no-undo.
define var v_wo_tmp like wo_lot no-undo .

define temp-table temp2 no-undo
    field t2_part     like wo_part     
    field t2_lot      like ld_lot       
    field t2_qty      like wod_qty_req
    field t2_wolot    as char format "x(40)"
    index t2_lot  t2_part t2_lot 
    index t2_part t2_part 
    .


form
    SKIP(.2)
    i-lot               label "主机号"
    i-part              label "料号"
    i-wolot             label "工单ID"
with frame a  side-labels width 80 attr-space.


form
    SKIP(.2)
    v_zppart         colon 10 label "ZP料号"
    /*v_lot            colon 10 label "批序号" */
    t2_qty           colon 10 label "发料数"
    t2_wolot         colon 10 label "ZP工单"
                     skip(1)
    v_part           colon 10 label "指定子件" 
    desc1            colon 35 label "说明"
    xpre_qty         colon 10 label "指定用量"
    desc2            colon 35 no-label 
    xpre_sn          colon 10 label "序列号"
    

with frame b side-labels width 80 attr-space .  

view frame a .
view frame b .


for each temp2 : delete temp2 . end. 

find first wo_mstr
    where wo_domain = global_domain 
    and wo_lot = i-wolot
no-lock no-error .
    
for each tr_hist
        use-index tr_nbr_eff
        where tr_domain = global_domain
        and   tr_nbr    = wo_nbr 
        and   tr_lot    = wo_lot
        and   tr_type   = "ISS-WO"
    no-lock:
        
    find first temp2 
        where t2_part = tr_part 
        /*and   t2_lot  = tr_serial*/
    no-error .
    if not avail temp2 then do:
        create temp2 .
        assign t2_part = tr_part 
               /*t2_lot  = tr_serial*/
               t2_qty  = - tr_qty_loc .
    end.
    else t2_qty  = t2_qty + (- tr_qty_loc) .

end. /* for each tr_hist */

for each temp2:
    for each  xzp_det 
        use-index xzp_wolot
        where xzp_domain = global_domain 
        and xzp_wolot    = i-wolot
        and xzp_zppart   = t2_part 
        /*and xzp_zplot    = t2_lot */
    no-lock :
        t2_wolot =  xzp_zpwo + "," + t2_wolot .
    end.
end. /* for each temp2 */




mainloop:
repeat:
    clear frame a no-pause .
    clear frame b no-pause .

    disp i-lot   
         i-part  
         i-wolot 
    with frame a. 

    disp v_zppart /*v_lot*/ with frame b .
    
    prompt-for 
        v_zppart
        /*v_lot*/
    with frame b editing:
          if frame-field = "v_zppart" then do:
             {mfnp.i temp2 v_zppart  t2_part  v_zppart t2_part t2_part}
             if recno <> ? then do:
                disp 
                    /*t2_lot  @ v_lot*/
                    t2_part @ v_zppart
                    t2_qty
                    t2_wolot
                with frame b .
             end . 
         end.
         /*else if frame-field = "v_lot" then do:
             {mfnp01.i temp2 v_lot  t2_lot  v_zppart  t2_part t2_lot}
             if recno <> ? then do:
                disp 
                    t2_lot  @ v_lot
                    t2_part @ v_zppart
                    t2_qty
                    t2_wolot
                with frame b .
             end . 
         end. */
         else do:
               status input ststatus.
               readkey.
               apply lastkey.
         end.        
    end. /*editing:*/
    assign v_zppart /*v_lot*/ .

    if v_zppart <> "" then do:
        find first pt_mstr
            where pt_domain = global_domain 
            and pt_part     = v_zppart 
        no-lock no-error.
        if not avail pt_mstr then do:
            message "错误:无效物料编号,请重新输入" .
            undo,retry.
        end.

    
        find first temp2 where t2_part = v_zppart /*and t2_lot = v_lot*/ no-lock no-error .
        if not avail temp2 then do:
            message "错误:无效ZP件,请重新输入" .
            undo,retry .
        end.
        disp 
            /*t2_lot  @ v_lot*/
            t2_part @ v_zppart
            t2_qty
            t2_wolot
        with frame b .

        if v_zppart begins "ZP" and t2_wolot = "" then do:
            message "错误:ZP件未指定加工单" .
            undo,retry .        
        end.

        if not v_zppart begins "ZP" then v_zppart = wo_part .
    end.
    else v_zppart = wo_part .

    disp v_zppart with frame b .


    comp-loop:
    repeat :

        if v_zppart begins "ZP" then do:
            update v_part with frame b editing:
                {mfnp.i pt_mstr v_part  "pt_domain = global_domain and pt_part "  v_part pt_part pt_part}
                if recno <> ? then do:
                    desc1 = pt_desc1 .
                    desc2 = pt_desc2 .
                    display pt_part @ v_part desc1 desc2 with frame b.
                end . 
            end.  /*editing:*/

            find first pt_mstr
                where pt_domain = global_domain 
                and pt_part     = v_part 
            no-lock no-error.
            if not avail pt_mstr then do:
                message "错误:无效物料编号,请重新输入" .
                undo,retry.
            end.

            desc1 = pt_desc1 .
            desc2 = pt_desc2 .
            display pt_part @ v_part desc1 desc2 with frame b.

            v_ii      = 0 .
            v_include = no .
            do v_ii = 1 to num-entries(t2_wolot,",") :

                if v_include = yes then next .

                v_wo_tmp = entry(v_ii,t2_wolot,",") .                               
                if v_wo_tmp > "" then do:
                    find first wod_det where wod_domain = global_domain and wod_lot = v_wo_tmp and wod_part = v_part no-lock no-error. 
                    if avail wod_Det then v_include = yes .
                end.
            end. /*do v_ii = 1 to num-entries*/

            if v_include = no then do:
                message "错误:ZP件指定工单的物料清单上,不包含此零件" .
                undo,retry.
            end.
        end. /*if v_zppart begins "ZP"*/
        else do: /*if v_zppart not begins "ZP"*/
            update v_part with frame b editing:
                {mfnp.i temp2 v_part  t2_part  v_part t2_part t2_part}
                if recno <> ? then do:
                    find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error.
                    if avail pt_mstr then do:
                        desc1 = pt_desc1 .
                        desc2 = pt_desc2 .
                        display pt_part @ v_part desc1 desc2 with frame b.
                    end.
                end . 
            end.  /*editing:*/

            if v_part begins "zp" then do:
                message "错误:材料限非ZP件" .
                undo,retry .                
            end.

            find first pt_mstr
                where pt_domain = global_domain 
                and pt_part     = v_part 
            no-lock no-error.
            if not avail pt_mstr then do:
                message "错误:无效物料编号,请重新输入" .
                undo,retry.
            end.

            desc1 = pt_desc1 .
            desc2 = pt_desc2 .
            display pt_part @ v_part desc1 desc2 with frame b.

            find first temp2 where t2_part = v_part /*and t2_lot = v_lot*/ no-lock no-error .
            if not avail temp2 then do:
                message "错误:非ZP件必须是本工单材料,请重新输入" .
                undo,retry .
            end.
        end .  /*if v_zppart not begins "ZP"*/
    
        qtyloop:
        do on error undo,retry on endkey undo ,leave :
            find first xpre_det 
              where xpre_domain = global_domain 
                and xpre_part     = i-part
                and xpre_lot      = i-lot
                and xpre_zppart   = v_zppart 
                /*and xpre_zplot    = v_lot*/
                and xpre_comp     = v_part
            exclusive-lock no-error.
            if not avail xpre_det then do:
                message "新增记录" .
                create xpre_det.
                assign xpre_domain = global_domain   
                       xpre_part     = i-part        
                       xpre_lot      = i-lot         
                       xpre_zppart   = v_zppart      
                       /*xpre_zplot    = v_lot*/       
                       xpre_comp     = v_part        
                       .
            end.
            else message "修改记录" .

            update 
                xpre_qty xpre_sn 
            with frame b .

            assign xpre_mod_date = today 
                   xpre_mod_user = global_userid .

        end. /*qtyloop:*/

    end. /*comp-loop: */

end. /*mainloop*/
