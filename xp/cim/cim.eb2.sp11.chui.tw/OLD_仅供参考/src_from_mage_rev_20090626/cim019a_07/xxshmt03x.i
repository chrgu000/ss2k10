/* Revision: eB2SP11.Chui   Modified: 09/18/06      By: Kaine Zhang     *ss-20060918.1* */
/* Revision: eB2SP11.Chui   Modified: 07/18/07      By: Kaine Zhang     *ss-20070718.1* */
/* Revision: eB2SP11.Chui   Modified: 06/30/08      By: Kaine Zhang     *ss_20080630* */

loop-detail:
repeat:
    if invcode <> "CS" then v_so_nbr = xxshm_orderno .
    else v_so_nbr =  xxshm_orderno .  /* ching */
    sonbrstr="".
    for each xxshd_det 
        WHERE xxshd_inv_no =invno 
        no-lock 
        break 
        by   xxshd_so_nbr:
        if last-of( xxshd_so_nbr) then do:
            sonbrstr=sonbrstr + ' ' + xxshd_so_nbr.
        end.
    end.
    disp 
        substring(trim(sonbrstr),1,62) at 20  format "x(62)"  no-label 
        substring(trim(sonbrstr),63) at 20 format "x(62)"  no-label 
    with frame fdet.
    
    update 
        v_so_nbr 
    go-on(F5 CTRL-D) 
    with frame fdet editing:
        status input .
        readkey.
        /*Sam Song Add Delete Whole SO START */

        /* *ss_20080630* FIND FIRST xxshd_det WHERE xxshd_so_nbr = v_so_nbr and xxshd_log[2] = yes NO-ERROR. */
        /* *ss_20080630* */ FIND FIRST xxshd_det WHERE xxshd_inv_no = xxshm_inv_no and xxshd_log[2] = yes NO-ERROR.
        IF AVAIL xxshd_det then do:
            message "THE SHIPPER ALREADY ISSUE ".
        END.
        ELSE DO:
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")  then do:
                del-yn = yes.
                {mfmsg01.i 11 1 del-yn}
                if del-yn then do:
                    for each xxshd_det where xxshd_so_nbr = v_so_nbr :
                        delete xxshd_det.
                    end.
                    /* clear frame fdet. */
                end.
            end.
        END.

        /*Sam Song Add Delete Whole SO END */

        apply lastkey .
    end.



    FIND first so_mstr where so_nbr=v_so_nbr no-lock no-error.
    
    /* *ss-20070718.1* */
    if not available so_mstr then do:
        message "Not Valit SO, Please Re-enter".
        undo, retry.
    end.
    
    if so_stat = "HD" then do:
        message "Not Valit SO, Please Re-enter".
        undo, retry.
    end.
    /* *ss-20070718.1* */
    
    /*ss - 20060918.1*  IF invice belongs TO "CS", THEN dose NOT CHECK terms.  */
    /*ss - 20060918.1*/  IF invcode <> "CS" THEN DO:
        if xxshm_terms<>so_cr_terms then do:
            message 'one invoice two cr terms error' .
            v_so_nbr="".
            next .
        end.
        
        /* ************** *ss_20080923* Add *Begin* *************** */
        if so_ship <> strShipTo then do:
            {pxmsg.i &msgnum=9008}
            undo, retry.
        end.
        /* ************** *ss_20080923* Add *end* ***************** */
    /*ss - 20060918.1*/  END.
    

    /*檢查SO是否同屬一家客戶-BEGIN*/
    /*CO CP單才要驗証客戶是否為一個*/
    if invcode <> "CS" then do:
        /*打SO_CUST放入xxshm_cust*/
        if xxshm_cust = "" then do:
            find first so_mstr where so_nbr = v_so_nbr no-lock no-error.
            if avail so_mstr then assign xxshm_cust = so_cust .
        END.
        else do:
            find first so_mstr where so_nbr = v_so_nbr no-lock no-error.
            if avail so_mstr then do:
                if so_cust <> xxshm_cust then do:
                    message "Error. 輸入的SO NBR對應的客戶不是 " + xxshm_cust .
                    next .
                END.
            end.
        END.
    end.
    /*檢查SO是否同屬一家客戶-END*/



    /********取所有此SO的其它項-BEGIN*/

    /*把原來有的先放到臨時表TMP中，再把SO內容(xxshd_det中沒有的)放到臨時表中--BEGIN*/
    {xxshmt0301x.i}
    /*把原來有的先放到臨時表TMP中，再把SO內容(xxshd_det中沒有的)放到臨時表中--END*/

    /*可通過上下箭頭選擇並修改--BEGIN*/
    hide all no-pause.
    view frame a .
    /*run e:\temp\xxshmta.p .*/
    {gprun.i ""xxshmtax.p"" }

    /*把選中的TMP資料存入XXSHD_DET表中--BEGIN*/
    {xxshmt0302x.i}
    /*把選中的TMP資料存入XXSHD_DET表中--END*/
    hide all no-pause.
    view frame a .
    /*可通過上下箭頭選擇並修改--BEGIN*/

    /********取所有此SO的其它項-END*/

    /*問還要不要增加其它SO-BEGIN*/
    /*    sonbrstr="".
    
    for each xxshd_det WHERE xxshd_inv_no =invno no-lock break by   xxshd_so_nbr:
    if last-of( xxshd_so_nbr) then do:
    
    sonbrstr=sonbrstr + ' ' + xxshd_so_nbr.
    end.
    end.
    disp substring(trim(sonbrstr),1,62) at 20  format "x(62)"  no-label  substring(trim(sonbrstr),63) at 20 format "x(62)" no-label with frame fdet.
    */
    update 
        v_continue 
    with frame fdet editing:
        READKEY .
        pause 0 before-hide.
        if lastkey = 27 OR LASTKEY = 404 THEN do:
            READKEY.
        END.
        ELSE DO:
            APPLY LASTKEY .
        END.
    end.

    if v_continue = no then leave loop-detail .
    /*問還要不要增加其它SO-END*/
end.
