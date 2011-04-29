/*                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/04/23   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var par_ln    like xxcpt_ln .
define var comp_ln   like xxcpt_ln .
define var comp  like pt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var desc3 like pt_desc1.
define var v_wt_um like pt_um initial "KG" .
define var par_um like pt_um .

define var del-yn  like mfc_logical initial yes.




define  frame a.


/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    par_ln                       colon 24 label "父商品序"
    pt_part                      colon 24 label "父零件"
    pt_desc1                     colon 24 label "公司品名"
	pt_um                        colon 24 label "公司单位"
	pt_net_wt                    colon 24 label "单件净重" space(0) pt_net_wt_um no-label
    xxcps_cu_par                 colon 24 label "父商品编码" 
    desc3                        colon 24 label "海关品名"
    par_um                       colon 24 label "海关单位"
    skip(1)
    comp_ln                      colon 24  label "子商品序"
    comp                         colon 24  label "子零件"
    desc1                        colon 24  label "公司品名"  
    xxcps_um                     colon 24 label "公司单位"
    xxcps_wt                     colon 24 label "单件净重" space(0) v_wt_um no-label

    xxcps_cu_comp                colon 24 label "子商品编码"  
    desc2                        colon 24 label "海关品名"       
    xxcps_cu_um                  colon 24 label "海关单位" 
    xxcps_cu_qty_per             colon 24 label "用量"      

    


with frame a  side-labels width 80 attr-space.

/*setFrameLabels(frame a:handle).*/


view frame a.


mainloop:
repeat with frame a:
    clear frame a no-pause .


    ststatus = stline[1].
    status input ststatus.

    prompt-for par_ln with frame a editing:
         if frame-field = "par_ln" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp01.i xxcps_mstr par_ln xxcps_par_ln  xxcps_domain  global_domain xxcps_cu_ln}

             if recno <> ? then do:
                    find first pt_mstr where pt_domain = global_domain and pt_part = xxcps_par  no-lock no-error.
                    if avail pt_mstr then do:
                        find first xxcpt_mstr 
                            where xxcpt_domain = global_domain
                            and xxcpt_ln = xxcps_par_ln 
                        no-lock no-error .
                        desc3 =  if avail xxcpt_mstr then xxcpt_desc else "" .  
                        par_um =  if avail xxcpt_mstr then xxcpt_um else "" . 
                        
                        display xxcps_par_ln @ par_ln pt_part pt_desc1 pt_um pt_net_wt pt_net_wt_um xxcps_cu_par desc3 par_um  with frame a .
                    end.                    
             end . /* if recno <> ? then  do: */

         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign par_ln .

    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = par_ln  no-lock no-error.
    if not avail xxcpt_mstr  then do :
        message "父零件不存在"  .
        undo mainloop, retry mainloop.
    end.

    find first xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = par_ln  no-error .
    if not avail xxcps_mstr then do:
        message "父零件不存在"  .
        undo mainloop, retry mainloop.
    end.
    find first xxcpt_mstr 
        where xxcpt_domain = global_domain
        and xxcpt_ln = xxcps_par_ln 
    no-lock no-error .
    desc3 =  if avail xxcpt_mstr then xxcpt_desc else "" .  
    par_um =  if avail xxcpt_mstr then xxcpt_um else "" . 
    
    find first pt_mstr where pt_domain = global_domain and pt_part = xxcps_par  no-lock no-error.

    disp par_ln pt_part pt_desc1 pt_um pt_net_wt pt_net_wt_um  xxcps_cu_par desc3 par_um with frame a .

    comploop:
    do on error undo ,retry :

        prompt-for comp_ln with frame a editing:
             if frame-field = "comp_ln" then do:
                 /* FIND NEXT/PREVIOUS RECORD */
                 {mfnp01.i xxcps_mstr comp_ln xxcps_comp_ln  par_ln "xxcps_domain = global_domain and xxcps_par_ln" xxcps_cu_ln}

                 if recno <> ? then do:
                        find first pt_mstr where pt_domain = global_domain and pt_part = xxcps_comp  no-lock no-error.
                        if avail pt_mstr then do:
                            desc1 =  if avail pt_mstr then pt_desc1 else "" . 
                            comp  =  if avail pt_mstr then pt_part else "" . 
                            find first xxcpt_mstr 
                                where xxcpt_domain = global_domain
                                and xxcpt_ln = xxcps_comp_ln
                            no-lock no-error .
                            desc2 =  if avail xxcpt_mstr then xxcpt_desc else "" .  
        
                            display xxcps_comp_ln @ comp_ln comp desc1 xxcps_cu_comp   desc2  
                                    v_wt_um  xxcps_um  
                                    xxcps_cu_qty_per xxcps_cu_um 
                                    xxcps_wt     with frame a .
                        end.                    
                 end . /* if recno <> ? then  do: */

             end.
             else do:
                       status input ststatus.
                       readkey.
                       apply lastkey.
             end.
        end. /* PROMPT-FOR...EDITING */
        assign comp_ln .

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = comp_ln  no-lock no-error.
        if not avail xxcpt_mstr  then do :
            message "子零件不存在"  .
            undo , retry .
        end.


        find first xxcps_mstr where xxcps_domain = global_domain and xxcps_comp_ln = comp_ln  no-error .
        if not avail xxcps_mstr then do:
            message "子零件不存在"  .
            undo , retry .
        end.
        find first xxcpt_mstr 
            where xxcpt_domain = global_domain
            and xxcpt_ln = xxcps_comp_ln 
        no-lock no-error .

        find first pt_mstr where pt_domain = global_domain and pt_part = xxcps_comp  no-lock no-error.
        comp  =  if avail pt_mstr then pt_part else "" . 
        desc1 =  if avail pt_mstr then pt_desc1 else "" . 
        desc2 =  if avail xxcpt_mstr then xxcpt_desc else "" .  

        display comp_ln comp desc1 xxcps_cu_comp   desc2  
                v_wt_um xxcps_um  
                xxcps_cu_qty_per xxcps_cu_um 
                xxcps_wt    with frame a .

        setloop:
        do on error undo ,retry :
            

            update                  
                xxcps_cu_qty_per  
            go-on ("F5" "CTRL-D") with frame a editing :
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        del-yn = no.            
                        {mfmsg01.i 11 1 del-yn}

                        if not del-yn then undo, retry.
                        if del-yn then do:
                            delete xxcps_mstr.
                            clear frame a.
                            del-yn = no.
                            next.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
            end. /* update ...EDITING */
        end. /*  setloop: */
    end. /*comploop:*/
end.   /*  mainloop: */

status input.
