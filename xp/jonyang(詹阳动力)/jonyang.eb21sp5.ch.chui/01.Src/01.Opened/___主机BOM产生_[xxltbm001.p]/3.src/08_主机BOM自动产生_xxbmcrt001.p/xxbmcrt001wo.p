/*xxbmcrt001a.p 主机BOM,子程式,输入wo_lot查找WO*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100602.1  By: Roger Xiao */


{mfdeclre.i }
{gplabel.i} 

define   shared var wonbr like wo_nbr no-undo.
define   shared var wolot like wo_lot no-undo.
define   shared var vleave as logical no-undo.



define var joint_label    like lngd_translation.
define var joint_code     like wo_joint_type.

form
   wo_nbr         colon 25
   wo_lot 
   wo_part        colon 25
   pt_desc1       at 47 no-label
   wo_type        colon 25
   pt_desc2       at 47 no-label
   wo_site        colon 25
   joint_label    at 47 no-label
   skip(1)
   wo_qty_ord     colon 25
   wo_ord_date    colon 55
   wo_qty_comp    colon 25
   wo_rel_date    colon 55
   wo_qty_rjct    colon 25
   wo_due_date    colon 55
   wo_status      colon 25
   wo_so_job      colon 55
   skip(1)
   wo_rmks        colon 25
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

vleave = yes .    
    
mainloop:    
do on error undo,retry on endkey undo,leave :    
    disp 
        wonbr @ wo_nbr
        wolot @ wo_lot
    with frame a .   
    prompt-for wo_nbr wo_lot with frame a editing:
        if frame-field = "wo_nbr" then do:
            {mfnp.i wo_mstr wo_nbr  " wo_mstr.wo_domain = global_domain and wo_nbr "  wo_nbr wo_nbr wo_nbr}
        end.
        else if frame-field = "wo_lot" then do:
            {mfnp.i wo_mstr wo_lot  " wo_mstr.wo_domain = global_domain and wo_lot "  wo_nbr wo_nbr wo_lot}
        end.
        else do:
            readkey.
            apply lastkey.
        end.

        if recno <> ? then do:

            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part no-lock no-error no-wait.
            if available pt_mstr then display
                pt_desc1
                pt_desc2 with frame a.
            else display
                " " @ pt_desc1
                " " @ pt_desc2 with frame a.

            if wo_joint_type <> "" then do:
                /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE, LABEL */
                {gplngn2a.i
                    &file     = ""wo_mstr""
                    &field    = ""wo_joint_type""
                    &code     = wo_joint_type
                    &mnemonic = joint_code
                    &label    = joint_label}
            end.
            else do:
            assign
                joint_code = ""
                joint_label = "".
            end.

            display
                wo_nbr
                wo_lot
                wo_part
                wo_type
                wo_site
                joint_label
                wo_qty_ord
                wo_qty_comp
                wo_qty_rjct
                wo_ord_date
                wo_rel_date
                wo_due_date
                wo_status
                wo_so_job
                wo_rmks
            with frame a.
        end. /*if recno <> ?*/
    end. /*prompt-for*/


    if available wo_mstr then release wo_mstr.

    wonbr = "".
    wolot = "".

    if input wo_nbr <> "" and input wo_lot <> "" then
        find wo_mstr no-lock 
            use-index wo_lot
            using  wo_lot and wo_nbr 
            where wo_mstr.wo_domain = global_domain  
        no-error.

    if input wo_nbr = "" and input wo_lot <> "" then
        find wo_mstr no-lock 
            use-index wo_lot 
            using  wo_lot 
            where wo_mstr.wo_domain = global_domain  
        no-error.

    if input wo_nbr <> "" and input wo_lot = "" then
        find first wo_mstr no-lock 
            use-index wo_nbr
            using  wo_nbr 
            where wo_mstr.wo_domain = global_domain  
        no-error.

    if not available wo_mstr then
        if input wo_lot <> "" then
            find wo_mstr no-lock 
                use-index wo_lot 
                using  wo_lot 
                where wo_mstr.wo_domain = global_domain  
            no-error.

    if not available wo_mstr then do:
        {pxmsg.i &MSGNUM=503 &ERRORLEVEL=3}
        undo mainloop, retry mainloop.
    end.   /* NOT AVAILABLE WO_MSTR */
    else do:  /* else do */

        /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORKORDERS */
        if wo_fsm_type = "PRM" then do:
            {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
            /* CONTROLLED BY PRM MODULE */
            undo mainloop, retry mainloop.
        end.

        /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
        if wo_fsm_type = "FSM-RO" then do:
            {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
            /* FIELD SERVICE CONTROLLED.  */
            undo mainloop, retry mainloop.
        end.

        if wo_nbr <> input wo_nbr and input wo_nbr <> "" then do:
            {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3}
            /* LOT NUMBER ENTERED BELONGS TO DIFFERENT WORK ORDER.*/
            undo mainloop, retry mainloop.
        end.

        {gprun.i ""xxmsgcrt01.p""
                "(input global_user_lang,
                  input 90003 ,
                  input ""加工单数量未完成""
                  )"}
        if wo_qty_ord > wo_qty_comp + wo_qty_rjct then do:
            {pxmsg.i &MSGNUM=90003 &ERRORLEVEL=3} /*加工单数量未完成*/
            undo mainloop, retry mainloop.
        end.

        find pt_mstr  
            where pt_mstr.pt_domain = global_domain 
            and  pt_part = wo_part 
        no-lock no-error.

        if available pt_mstr then
            display
                pt_desc1
                pt_desc2
            with frame a.
        else
        display
            " " @ pt_desc1
            " " @ pt_desc2
        with frame a.

        if wo_joint_type <> "" then do:

            /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE & LABEL */
            {gplngn2a.i
                &file     = ""wo_mstr""
                &field    = ""wo_joint_type""
                &code     = wo_joint_type
                &mnemonic = joint_code
                &label    = joint_label}
        end.
        else do:
            assign
                joint_code = ""
                joint_label = "".
        end.

        display
            wo_nbr
            wo_lot
            wo_part
            wo_type
            wo_site
            joint_label
            wo_qty_ord
            wo_qty_comp
            wo_qty_rjct
            wo_ord_date
            wo_rel_date
            wo_due_date
            wo_status
            wo_so_job
            wo_rmks
        with frame a.
    end.  /* else do */

    wolot  = wo_lot.
    wonbr  = wo_nbr.
    vleave = no .  
end. /*mainloop*/