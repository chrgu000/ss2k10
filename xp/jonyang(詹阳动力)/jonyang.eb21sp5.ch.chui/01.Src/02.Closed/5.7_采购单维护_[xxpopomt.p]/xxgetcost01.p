/*xxgetcost01.p  查找30.9设定的总账成本集的材料成本*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100526.1  By: Roger Xiao */

{mfdeclre.i}
{gplabel.i}
{pxmaint.i}



define input  parameter v_site  like pod_site     no-undo .
define input  parameter v_part  like pod_part     no-undo . 
define input  parameter v_cost  like pod_pur_cost no-undo . 
define output parameter l_error as integer        no-undo .

define var  v_cost_gl like pod_pur_cost no-undo .

l_error   = 0 .
v_cost_gl = 0 .


{gprun.i ""xxmsgcrt01.p""
        "(input global_user_lang,
          input 90001 ,
          input ""采购成本与系统GL成本相差比例超出10%""
          )"}


getcsot:
do on error undo,leave on endkey undo,leave :
    find first si_mstr where si_domain = global_domain and si_site = v_site no-lock no-error.
    if avail si_mstr then do:
        find first sct_det 
            use-index sct_sim_pt_site
            where sct_domain = global_domain 
            and   sct_sim    = si_gl_set
            and   sct_part   = v_part 
            and   sct_site   = si_site
        no-lock no-error.
        if avail sct_det then do:
            v_cost_gl = sct_mtl_tl . /*本层物料成本*/
        end.
        else do:
            l_error = 3845. /*该地点不存在总帐成本*/
            leave getcsot.
        end.
    end.

    if (v_cost_gl = 0 and v_cost <> 0 )
       or (v_cost_gl <> 0 and abs(v_cost - v_cost_gl) / v_cost_gl > 0.1 )
    then do:
        l_error = 90001. /*采购成本与系统GL成本相差比例超出10%*/
        leave getcsot.
    end.
end. /*getcsot: do on error*/


