/* Creation: eB2SP11.Chui   Modified: ??    By: Davild??    *????* */
/* Revision: eB2SP11.Chui   Modified: 08/15/06      By: Kaine Zhang     *ss-20060815.1* */
/* Revision: eB2SP11.Chui   Modified: 08/23/06      By: Kaine Zhang     *ss-20060823.1* */
/* Revision: eB2SP11.Chui   Modified: 08/01/07      By: Kaine Zhang     *ss-20070801.1* */
/* Revision: eB2SP11.Chui   Modified: 09/23/2008    By: Kaine Zhang     Eco: *ss_20080923* */

loop-invdata:
repeat:
    /* assign xxshm_date = today .   samsong 20080808 */
    /*display */
    find first so_mstr where so_nbr=xxshm_orderno no-lock no-error.   /* ching xxshm_terms so_cr_terms */
    if avail so_mstr then assign xxshm_terms=so_cr_terms.   /* ching xxshm_terms so_cr_terms */

    find first ad_mstr where ad_addr = xxshm_shipto no-lock no-error.
    if avail ad_mstr then v_shiptoadd = ad_line1 .
    else v_shiptoadd = "" .

    display xxshm_orderno xxshm_shipto v_shiptoadd with frame finv.
    disp xxshm_terms with frame finv .
    
    find first ad_mstr where ad_addr = xxshm_billto no-lock no-error.
    if avail ad_mstr then v_billtoadd = ad_line1 .
    else v_billtoadd = "" .

    display xxshm_orderno xxshm_billto v_billtoadd xxshm_terms  with frame finv.

    /*ss-20060815.1*/  DISPLAY xxshm_dec[1] WITH FRAME finv.


    update
        xxshm_date
        /*xxshm_terms */
        xxshm_forwarder
        xxshm_refno
        xxshm_method
        xxshm_fc
        xxshm_vessels
        xxshm_from
        /*xxshm_seal*/
        xxshm_container
        xxshm_port
        xxshm_final
        xxshm_orderno
        xxshm_qitagang
        xxshm_notes
        xxshm_notes2
        xxshm_notes3
        /*ss-20060815.1*/  xxshm_dec[1]
        /*xxshm_billto
        xxshm_shipto*/
    WITH FRAME finv editing:
        if frame-field = "xxshm_billto" then do:
            {mfnp.i cm_mstr xxshm_billto cm_addr xxshm_billto cm_addr cm_addr}
            if recno <> ? then do:
                xxshm_billto = cm_addr.
                find first ad_mstr where ad_addr = cm_addr no-lock no-error.
                if avail ad_mstr then v_billtoadd = ad_line1 .
                else v_billtoadd = "" .
                display xxshm_billto v_billtoadd with frame finv.
            end.
            find first ad_mstr where ad_addr = input xxshm_billto no-lock no-error.
            if avail ad_mstr then do: 
                assign v_billtoadd = ad_line1 .
                display ad_addr @ xxshm_billto v_billtoadd with frame finv.
            END.
            else 
                disp "" @ v_billtoadd with frame finv .

        end.
        else if frame-field = "xxshm_shipto" then do:
            {mfnp.i cm_mstr xxshm_shipto cm_addr xxshm_shipto cm_addr cm_addr}
            if recno <> ? then do:
                xxshm_shipto = cm_addr.
                find first ad_mstr where ad_addr = cm_addr no-lock no-error.
                if avail ad_mstr then v_shiptoadd = ad_line1 .
                else v_shiptoadd = "" .
                display xxshm_shipto v_shiptoadd with frame finv.
            end.
            find first ad_mstr where ad_addr = input xxshm_shipto no-lock no-error.
            if avail ad_mstr then do: 
                assign v_shiptoadd = ad_line1 .
                display ad_addr @ xxshm_shipto v_shiptoadd with frame finv.
            end.
            else 
                disp "" @ v_shiptoadd with frame finv .
        end.
        else if frame-field = "xxshm_orderno" then do:
            status input. /* ching */
            readkey. /* ching */
            apply lastkey. /* ching */
            find first so_mstr where so_nbr = input xxshm_orderno no-lock no-error.
            if avail so_mstr then do:
                xxshm_orderno = so_nbr.
                xxshm_shipto  = so_ship .

                find first ad_mstr where ad_addr = so_ship no-lock no-error.
                if avail ad_mstr then v_shiptoadd = ad_line1 .
                else v_shiptoadd = "" .
                display xxshm_orderno xxshm_shipto v_shiptoadd with frame finv.

                xxshm_billto = so_bill .
                xxshm_terms = so_cr_terms .
                disp xxshm_terms with frame finv .
                find first ad_mstr where ad_addr = so_bill no-lock no-error.
                if avail ad_mstr then 
                    v_billtoadd = ad_line1 .
                else 
                    v_billtoadd = "" .
                display xxshm_orderno xxshm_billto v_billtoadd xxshm_terms with frame finv.
            end.
        end.
        else do:
            status input.
            readkey.
            apply lastkey.
        end.
    end.


    /* ********************ss-20070801.1 Add Beg******************** */
    FOR FIRST so_mstr
        WHERE so_nbr = xxshm_orderno
        NO-LOCK:
    END.
    IF NOT AVAILABLE so_mstr THEN DO:
        MESSAGE "Not a Valid SO, Please Re-enter.".
        UNDO, RETRY.
    END.
    
    FOR FIRST cm_mstr
        WHERE cm_addr = so_cust
        NO-LOCK:
    END.
    IF NOT AVAILABLE cm_mstr THEN DO:
        /* *ss-20070801.1* {pxmsg.i xxxx} */
        MESSAGE "No Customer, Please Re-enter.".
        UNDO, RETRY.
    END.
    
    IF cm_cr_hold THEN DO:
        MESSAGE "customer is on credit hold".
        UNDO, RETRY.
    END.
    /* ********************ss-20070801.1 Add End******************** */
    
    /* *ss_20080923* */  strShipTo = so_ship.

    /* ***********************ss-20060823.1 B Add********************** */
    PAUSE 0.
    VIEW FRAME frmKarby.
    UPDATE
        xxshm_chr[1]
        xxshm_chr[2]
        xxshm_chr[3]
        xxshm_chr[4]
        xxshm_chr[5]
    WITH FRAME frmKarby.
    HIDE FRAME frmKarby NO-PAUSE.
    /* ***********************ss-20060823.1 E Add********************** */


    /*檢測資料正確性-BEGIN*/

    /*檢測資料正確性-END*/

    /*更改產地証資料-BEGIN*/
    pause 0 .
    {xxshmt02.i}
    /*更改產地証資料-END*/
    leave loop-invdata .
end.    /*repeat loop-invdata*/
