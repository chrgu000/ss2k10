/*xxbmcrt001.p 主机BOM产生程式,按每个零件的批号产生BOM*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100602.1  By: Roger Xiao */

/***************
程式逻辑说明:
限制:当工单入库数(含报废数) >= 工单批量时,才可产生 主机BOM,
每台主机,产生一个主机BOM,
每个主机BOM,用主机的批次号命名
BOM内容,为16.13.1工单发料表的内容,不继续展开到下层
"返修工单(类型=R)的BOM,要展开作为材料的主机,
按原来产生的本批次BOM展开,并按批次替换原BOM"
替代料,需先在16.13.1加入,并维护需求数,
分摊材料数量,按材料的类型(产品线)决定是否拆分成小数均摊

***************/


/* DISPLAY TITLE */
{mfdtitle.i "100602.1"}



define var wonbr like wo_nbr no-undo.
define var wolot like wo_lot no-undo.
define var joint_label    like lngd_translation.
define var joint_code     like wo_joint_type.
define var v_retry   as logical .
define var v_ii as integer .
define var v_qty_left as decimal .
define var v_qty_bom  as decimal .

define temp-table temp1 
    field t1_wolot like wo_lot 
    field t1_part  like tr_part
    field t1_lot   like tr_serial
    field t1_qty   like tr_qty_loc 
    .

define temp-table temp2 
    field t2_wolot     like wo_lot 
    field t2_part      like tr_part
    field t2_qty_iss   like tr_qty_loc 
    field t2_qty_bom   like tr_qty_loc 
    field t2_part2     like tr_part  /*替代料*/
    field t2_type      as char       /*物料类型*/
    .

define temp-table temp3 
    field t3_lot       like tr_serial
    field t3_par       like tr_part
    field t3_type      as char       /*物料类型*/
    field t3_comp      like tr_part
    field t3_comp2     like tr_part  /*替代料*/
    field t3_qty_bom   like tr_qty_loc 
    .



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



mainloop:
repeat:
for each temp1 : delete temp1. end .
for each temp2 : delete temp2. end .
for each temp3 : delete temp3. end .

   
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

    wolot = wo_lot.
    wonbr = wo_nbr.

hide all no-pause .
output to "/new/1.txt" .
    for each tr_hist 
        use-index tr_nbr_eff
        where tr_domain = global_domain 
        and   tr_nbr    = wonbr 
        and   tr_lot    = wolot
        and   tr_type   = "rct-wo"
        no-lock:

        disp tr_trnbr tr_effdate tr_qty_loc tr_lot tr_site tr_loc tr_type with frame xaa width 200 down .
    end .

put skip(3) .

    for each tr_hist 
        use-index tr_nbr_eff
        where tr_domain = global_domain 
        and   tr_nbr    = wonbr 
        and   tr_lot    = wolot
        and   tr_type   = "iss-wo"
        no-lock:

        disp tr_trnbr tr_effdate tr_part (- tr_qty_loc) tr_lot tr_site tr_loc tr_type with frame xbb width 200 down .
    end .

output close.



end.  /* mainloop */


