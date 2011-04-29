/* xxrescrap011.p  */
/* REVISION: 1.0   Last Modified: 2009/09/08   By: Roger   No ECO     */ 
/*-Revision end------------------------------------------------------------*/


{mfdeclre.i}
{gplabel.i}

define input parameter vv_qc_loc              like pt_loc      no-undo.  
define input parameter vv_part                like pt_part     no-undo.
define input parameter vv_qty_qc              like tr_qty_loc  no-undo.
define input parameter vv_qty_scrap           like tr_qty_loc  no-undo.
define input parameter vv_qty_ok              like tr_qty_loc  no-undo.
define output parameter vv_undo_stat          like mfc_logical no-undo.
define output parameter vv_effdate            as date          no-undo.
define output parameter vv_hrs                as decimal       no-undo.
define output parameter vv_prdline            as char          no-undo.

vv_undo_stat = no .



{gpglefv.i} /*var for eff_date check: gpglef.i*/
{xxretrforscrap001.i new} /*var for xx....*/
define var v_qty_oh like ld_qty_oh .
define new shared variable sf_entity like en_entity.
define new shared variable op_recno as recid.
define new shared variable sf_gl_amt like tr_gl_amt.
define new shared variable sf_cr_acct   like dpt_lbr_acct.
define new shared variable sf_dr_acct   like dpt_lbr_acct.
define new shared variable sf_cr_sub    like dpt_lbr_sub.
define new shared variable sf_dr_sub    like dpt_lbr_sub.
define new shared variable sf_cr_cc     like dpt_lbr_cc.
define new shared variable sf_dr_cc     like dpt_lbr_cc.
define new shared variable ref          like glt_ref.
define new shared variable opgltype     like opgl_type.
{gldydef.i new}
{gldynrm.i new}


find first icc_ctrl where icc_domain = global_domain no-lock no-error.
site = (if available icc_ctrl then icc_site else global_domain).
op   = 10.

view frame a.
mainloop:
repeat with frame a:
    clear frame a no-pause .

    ststatus = stline[1].
    status input ststatus.
    
    v_loc     = vv_qc_loc .
    v_part    = vv_part .
    v_qty_a   = vv_qty_qc .
    v_qty_s   = vv_qty_scrap .
    v_qty_g   = vv_qty_ok .
    find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
    desc1     = if avail pt_mstr then pt_desc1 else "" .
    desc2     = if avail pt_mstr then pt_desc2 else ""  .

    eff_date  = today .
    pdln      = "" .
    v_hrs     = 0 .

    disp 
        v_part desc1 desc2 
        v_loc  
        v_qty_a 
        pdln v_qty_s    v_qty_g    eff_date v_hrs   
    with frame a.

    do on error undo, retry with frame a:
        prompt-for pdln  eff_date v_hrs   with frame a editing:
           if frame-field = "pdln" then do:
              {mfnp.i ln_mstr pdln  " ln_mstr.ln_domain = global_domain and ln_line "  pdln ln_line ln_line }
              if recno <> ? then do:
                 display ln_line @ pdln ln_desc  with frame a.
              end.
           end. /* if frame-field */
           else do:
              readkey.
              apply lastkey.
           end.
        end. /* prompt-for */
        assign pdln v_qty_s    v_qty_g    eff_date v_hrs .

        if pdln = "" then do:
           message "错误: 生产线不可为空,请重新输入!"   .
           next-prompt pdln with frame a.
           undo, retry.           
        end. 

        v_qty_oh = 0 .
        for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = v_part and ld_loc = v_loc no-lock:
            v_qty_oh = v_qty_oh + ld_qty_oh .
        end. /*for each ld_det*/
        if v_qty_oh < v_qty_a then do:
            message "错误:不良品库存(" v_qty_oh ")不足本次返修" v_qty_a .
            undo,retry .
        end.

        find first ln_mstr where ln_mstr.ln_domain = global_domain and ln_line =  pdln no-lock no-error.            
        if not available ln_mstr then do:
           message "错误: 生产线不存在,请重新输入!"   .
           next-prompt pdln with frame a.
           undo, retry.           
        end. /* IF NOT AVAILABLE ln_mstr */
        else display ln_line @ pdln ln_desc  with frame a.      
        
        if v_hrs < 0 then do:
           message "错误: 返修工时数无效,请重新输入"   .
           next-prompt v_hrs with frame a.
           undo, retry.        
        end.

        find si_mstr  where si_mstr.si_domain = global_domain and  si_site = site no-lock no-error.
        if not available si_mstr then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
            undo , retry.    
        end.
        {gprun.i ""gpsiver.p"" "(input site, input recid(si_mstr),    output return_int)"    }
        if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            undo, retry.
        end.
        {gpglef1.i  &module = ""IC""
                    &entity = si_entity
                    &date   = eff_date
                    &prompt = "eff_date"
                    &frame  = "a"
                    &loop   = "mainloop"}
        disp pdln ln_desc v_qty_s v_qty_g eff_date v_hrs   with frame a.

        {xxrochk01.i 
             &line    = pdln
             &part    = v_part
        } /*check op*/

    end.  /*do on error undo, retry with frame a: */
        
/*-以上输入各参数-------------------------------------------------------------*/
/*start调用18.22.13 进行入库回冲*********************************************************************************/    
    loopa:
    do on error undo ,retry :     
        
        emp =  pdln .
        line = pdln .
        part = v_part.    
        b_qc = "qc".               /* "" - 表示正常品, "qc" - 表示不良品(不变更rps_mstr) */
        assign
            wkctr              = ""
            mch                = ""
            dept               = ""
            um                 = ""
            conv               = 1
            qty_rjct           = 0
            rjct_rsn_code      = ""
            rejque_multi_entry = no
            to_op              = op
            qty_scrap          = 0 
            scrap_rsn_code     = ""
            outque_multi_entry = no
            start_run          = ""
            act_run_hrs        = 0
            stop_run           = ""
            earn_code          = ""
            rsn_codes          = ""
            quantities         = 0
            scrap_rsn_codes    = ""
            scrap_quantities   = 0
            reject_rsn_codes   = ""
            reject_quantities  = 0
            act_rsn_codes      = ""
            act_hrs            = 0
            prod_multi_entry   = no
            rsn                = ""
            act_run_hrs        = 0
            move_next_op       = yes
            act_setup_hrs      = 0
            setup_rsn          = ""
            act_multi_entry    = no
            act_setup_hrs20    = 0
            down_rsn_code      = ""
            stop_multi_entry   = no
            non_prod_hrs       = 0 .
            l_stat_undo        = no. 

                   
        /*part_1: 回冲不良品(负数回冲),库存由不良品仓v_loc转到生产线line = pdln*/
            /*qty_scrap = v_qty_s . */
            qty_proc    =  - v_qty_a .            
            v_neediss   = no .
            mod_issrc   = no .
            {gprun.i ""xxrebkscrap001.p"" }
        /*end part_1*/
        /*part_2: 回冲不良品,报废品;废品库存报废;返修后良品的库存入库,良品的材料清单清零供修改 */
            qty_proc      =  v_qty_a .
            qty_scrap     = v_qty_s . 
            act_run_hrs   = v_hrs .
            v_neediss     = yes .
            mod_issrc     = yes .
            {gprun.i ""xxrebkscrap001.p"" }
        /*end part_2*/
    end. /* loopa: */
/*end 调用18.22.13 进行入库回冲*********************************************************************************/   

vv_undo_stat = yes .
vv_effdate   = eff_date .
vv_hrs       = v_hrs .
vv_prdline   = pdln  .
leave mainloop.
end.   /*  mainloop: */

hide all no-pause .