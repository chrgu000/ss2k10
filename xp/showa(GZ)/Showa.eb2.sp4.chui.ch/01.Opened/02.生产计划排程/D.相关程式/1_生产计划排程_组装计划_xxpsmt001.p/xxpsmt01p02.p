/* xxpsmt01p02.p */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110330.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/
{mfdeclre.i}
{gplabel.i} 
{pxmaint.i}
{pxpgmmgr.i}

define input  parameter i_site      like lnd_site no-undo .
define input  parameter i_line      like lnd_line no-undo .

{xxpsmt01var.i}

define var v_ii            as integer .
define var v_jj            as integer .
define var v_seq_char      as char  no-undo .
define var v_part          as char .


mainloop:
repeat:
    v_ii = 0 .
    for each xln_det 
        where xln_site = i_site 
        and   xln_line = i_line
        and   xln_used = yes /***限:已排程的机种,*/
        no-lock :
        v_ii  = v_ii + 1.
    end.

    /* 系统顺序1/固定顺序2 */
    if v_sortby = 1 then do: 

        v_seq_char = "" . 
        {gprun.i ""xxpsmt01p02p01.p""  
                 "(  input i_site, 
                     input i_line, 
                     input v_ii,
                     input v_seq_char )"}


        /*确保最终ttemp2(create from ttemp1)包含所有排程机种*/
        find first ttemp1 
            where tt1_site = i_site
            and   tt1_line = i_line 
        no-error.
        if avail ttemp1 then do:
            for each ttemp2    
                where tt2_site   = i_site 
                and   tt2_line   = i_line
                : 
                delete ttemp2. 
            end.

            v_jj = 0 .
            do v_jj = 1 to num-entries(tt1_partlist)  :
            
                v_part = entry(v_jj,tt1_partlist) .
            
                if v_part = "" then next .

                find first ttemp2
                    where tt2_site = i_site
                    and   tt2_line = i_line
                    and   tt2_part = v_part 
                no-error.
                if not avail ttemp2 then do:
                    create ttemp2 .
                    assign tt2_site = i_site 
                           tt2_line = i_line 
                           tt2_part = v_part   
                           .
                end.
                assign  tt2_seq = v_jj .
                
            end.
        end. /*if avail ttemp1*/

    end. /*if v_sortby = 1*/
    else if v_sortby = 2 then do:

        for each xln_det 
            where xln_site = i_site 
            and   xln_line = i_line
            and   xln_used = yes /*限:已排程的机种,*/
        no-lock :
            find first ttemp2
                where tt2_site = xln_site
                and   tt2_line = xln_line
                and   tt2_part = xln_part 
            no-lock no-error.
            if not avail ttemp2 then do:
                create ttemp2 .
                assign tt2_site = i_site 
                       tt2_line = i_line 
                       tt2_part = v_part   
                       tt2_seq  = 999999999
                       .
            end.
            
            find first xxpsq_det
                use-index xxpsq_line_part
                where xxpsq_site = xln_site 
                and   xxpsq_line = xln_line
                and   xxpsq_part = xln_part
            no-lock no-error.
            if avail xxpsq_det then assign tt2_seq = xxpsq_seq .

        end. /* for each xln_det */


        v_jj = 0 .
        for each ttemp2 
            where tt2_site = i_site
            and   tt2_line = i_line
            and   tt2_seq  = 999999999
            no-lock
            break by tt2_part descending :
            tt2_seq  = tt2_seq  - v_jj .
            v_jj = v_jj + 1 .
        end.


    end. /*else if v_sortby = 2*/


    
    leave .
end. /* mainloop */

