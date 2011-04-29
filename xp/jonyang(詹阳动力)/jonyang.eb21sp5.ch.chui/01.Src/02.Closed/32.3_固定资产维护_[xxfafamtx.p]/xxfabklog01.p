/* xxfabklog01.p 记录定期费用faba_acctype = "3" 账户和成本中心的更改情况                              */
/* REVISION: 100810.1   Created On: 20100810   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100810.1  By: Roger Xiao */  /*土地资产,使用了分摊代码,不能使用这个程式 */
/*-Revision end---------------------------------------------------------------*/




{mfdeclre.i}
{gplabel.i} 

{gprunpdf.i "gpglvpl" "p"}


define input parameter v_id     like fa_id     no-undo .

define var l-acct-seq    as integer format "999999999"   initial 0 no-undo.

define var v_acct   like faba_acct no-undo .
define var v_sub    like faba_sub  no-undo .
define var v_cc     like faba_cc   no-undo .
define var v_start   as char format "999999"  no-undo .
define var v_expire  as char format "999999"  no-undo .



form
    SKIP(.2)

    skip(1)
    v_acct       colon 12 label "旧账户"                      
    faba_acct    colon 40 label "新账户"        
    v_sub        colon 12 label "旧明细账户"                  
    faba_sub     colon 40 label "新明细账户"    
    v_cc         colon 12 label "旧成本中心"                  
    faba_cc      colon 40 label "新成本中心"    
    v_expire     colon 12 label "终止期间"                    
    v_start      colon 40 label "开始期间"      
    skip(1)   

    skip(.2)
with frame x  
width 60 side-labels
overlay centered 
title  "定期费用账户历史记录"
attr-space.


    
view frame x .



for first fabk_mstr
    fields( fabk_domain fabk_id fabk_post)
     where fabk_mstr.fabk_domain = global_domain 
     and  fabk_post = yes
     and  fabk_id > ""
no-lock: end.
if not available fabk_mstr then do:
    message "错误:未设定固定资产过账账目,请先设定" view-as alert-box.
    leave .
end.

for first fa_mstr no-lock
   where fa_domain = global_domain
   and fa_id = v_id:
end.  /* FOR FIRST fa_mstr no-lock */

for last faba_det no-lock
   where faba_domain = global_domain
   and  faba_fa_id = v_id
   use-index faba_fa_id:
l-acct-seq = faba_glseq.
end.  /* FOR LAST faba_det */


for last xfa_hist 
    where xfa_domain = global_domain 
    and   xfa_id     = fa_id 
no-lock:
end.
if avail xfa_hist then do:
    assign 
    v_expire = xfa_expire 
    v_start  = if substring(xfa_expire,5,2) = "12" then string(integer(substring(xfa_expire,1,4)) + 1 ,"9999") + "01" 
               else string(integer(xfa_expire) + 1 ,"999999") 
    v_acct   = xfa_acct
    v_sub    = xfa_sub
    v_cc     = xfa_cc 
    .
end.
else do: /*new*/
    for last fabd_det
        where fabd_det.fabd_domain = global_domain 
        and fabd_fa_id     = fa_id
        and fabd_fabk_id   = fabk_id
        and fabd_post      = yes
    no-lock:
    end. /* for last fabd_det */
    v_expire = if available fabd_det then fabd_yrper else "".

    for first fabd_det
        where fabd_det.fabd_domain = global_domain 
        and fabd_fa_id     = fa_id
        and fabd_fabk_id   = fabk_id
        and fabd_post      = no
    no-lock:
    end. /* for last fabd_det */
    v_start = if available fabd_det then fabd_yrper else "".
   
    disp v_start v_expire  with frame x .

    find first faba_det 
        where faba_domain  = global_domain 
        and   faba_fa_id   = fa_id
        and   faba_acctype = "3" 
        and   faba_glseq   = l-acct-seq 
    no-lock no-error .
    if avail faba_det then do:
        disp faba_acct  faba_sub  faba_cc  with frame x . 

        find first faba_det 
            where faba_domain  = global_domain 
            and   faba_fa_id   = fa_id
            and   faba_acctype = "3" 
            and   faba_glseq   = max(0,l-acct-seq - 1) 
        no-lock no-error .
        if avail faba_det then assign  v_acct = faba_acct v_sub = faba_sub v_cc = faba_cc .
        disp v_acct  v_sub  v_cc  with frame x . 
    end.
end.  /*new*/


mainloop:
repeat:
    find first faba_det 
        where faba_domain  = global_domain 
        and   faba_fa_id   = fa_id
        and   faba_acctype = "3" 
        and   faba_glseq   = l-acct-seq 
    no-lock no-error .
    if avail faba_det then disp faba_acct  faba_sub  faba_cc with frame x . 

    disp v_start v_expire with frame x .

    update v_acct  v_sub  v_cc with frame x . 

    find first faba_det 
        where faba_domain  = global_domain 
        and   faba_fa_id   = fa_id
        and   faba_acctype = "3" 
        and   faba_acct = v_acct 
        and   faba_sub  = v_sub 
        and   faba_cc   = v_cc 
    no-lock no-error .
    if not avail faba_det then do:
        message "错误:并未使用过此组合:账户/明细账户/成本中心" .
        undo,retry.
    end.


    dtloop:
    do on error undo,retry :
        find first xfa_hist 
            where xfa_domain = global_domain 
            and   xfa_id     = fa_id 
            and   xfa_acct   = v_acct 
            and   xfa_sub    = v_sub 
            and   xfa_cc     = v_cc 
        no-error.
        if not avail xfa_hist then do:
            message "新增记录" .
            create  xfa_hist  .                 
            assign  xfa_domain = global_domain  
                    xfa_id     = fa_id          
                    xfa_acct   = v_acct         
                    xfa_sub    = v_sub          
                    xfa_cc     = v_cc       
                    .
        end.
        else do:
            message "修改记录".
            v_expire = xfa_expire .
        end.

        update v_expire 
                go-on ("F5" "CTRL-D") with frame x editing :
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    message "确认删除?" view-as alert-box question buttons yes-no title "" update choice as logical.
                    if choice then do :
                        find first xfa_hist 
                            where xfa_domain = global_domain 
                            and   xfa_id     = fa_id 
                            and   xfa_acct   = v_acct 
                            and   xfa_sub    = v_sub 
                            and   xfa_cc     = v_cc 
                        no-error.
                        if avail xfa_hist  then do:
                            delete xfa_hist .
                            next mainloop .
                        end.
                    end.
                end. /*   "F5" "CTRL-D" */
                else apply lastkey.
        end. /* update ...EDITING */

        find first fabd_det
            use-index fabd_fa_id
            where fabd_det.fabd_domain = global_domain 
            and fabd_fa_id     = fa_id
            and fabd_fabk_id   = fabk_id
            and fabd_post      = yes
            and fabd_yrper     = v_expire 
        no-lock no-error.
        if not available fabd_det then do:
            message "无效'固定资产已提折旧期间',请重新输入" .
            undo,retry.
        end.


        assign xfa_expire   = v_expire 
               xfa_mod_date = today
               xfa_mod_user = global_userid 
               .

        assign v_start      = if substring(xfa_expire,5,2) = "12" then string(integer(substring(xfa_expire,1,4)) + 1 ,"9999") + "01" 
                              else string(integer(xfa_expire) + 1 ,"999999") .

    end. /*dtloop:*/
end. /*mainloop:*/

hide frame x no-pause.