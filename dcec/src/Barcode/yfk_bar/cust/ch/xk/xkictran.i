/*xwh0517*/ DEFINE BUFFER bf-xkprh_hist FOR xkprh_hist.
/*xwh050702*/ DEFINE VAR trbgtm LIKE tr_time.
/*xwh050702*/ DEFINE VAR tredtm LIKE tr_time. 
IF SEARCH(cimf) <> ? THEN OS-DELETE VALUE(SEARCH(cimf)) .
OUTPUT TO VALUE(cimf) APPEND .
       
IF po THEN DO :


    PUT UNFORMATTED "@@batchload poporc.p" SKIP .
    PUT UNFORMATTED "~"" pnbr "~"" SKIP .
    PUT UNFORMATTED "- - " STRING(effdate,"99/99/99") " yes no no - " SKIP .
    FOR EACH xkprhhist NO-LOCK WHERE xkprhponbr = pnbr AND xkprhinrcvd = NO AND xkprheffdate = effdate USE-INDEX xkprhinrcvd :
/*est*/ DEFINE VARIABLE lotnbr LIKE ld_lot.
/*est*/ {gprun.i ""bcltcr.p"" "(input xkprhpart, output lotnbr)"}
/*est*/ FOR EACH cot_tmp WHERE cot_part = xkprhpart:
/*est*/    cot_lot = lotnbr.
/*est*/ END.
        PUT UNFORMATTED xkprhline SKIP .
/*est*/   PUT UNFORMATTED xkprhqty " - - - - - ~"" xkprhdsite "~" ~"" xkprhdloc "~"" lotnbr " - - no no no" SKIP . 
/*est*/        /*PUT UNFORMATTED xkprhqty " - - - - - ~"" xkprhdsite "~" ~"" xkprhdloc "~" - - - no no no" SKIP .*/
    END.
    PUT UNFORMATTED "." SKIP .
    PUT UNFORMATTED "@@end" SKIP .

END. /*po transaction*/
ELSE DO :

/*est*//*    FOR EACH xkprhhist NO-LOCK WHERE xkprhponbr = pnbr AND xkprhinrcvd = NO AND xkprheffdate = effdate USE-INDEX xkprhinrcvd :*/
/*est*/      FOR EACH xkprhhist NO-LOCK, EACH t_co_mstr  WHERE xkprhpart = t_co_part AND
                                         xkprhponbr = pnbr AND xkprhinrcvd = NO AND xkprheffdate = effdate /*USE-INDEX xkprhinrcvd*/ :
        PUT UNFORMATTED "@@batchload iclotr04.p" SKIP .
        PUT UNFORMATTED "~"" xkprhpart "~"" SKIP .
/*est*/        PUT UNFORMATTED t_co_qty_cur " " STRING(effdate,"99/99/99") " ~"" xkprhponbr "~"" SKIP(1) .
/*est*/         PUT UNFORMATTED "~"" xkprhssite "~" ~"" xkprhssloc "~" ~"" t_co_lot "~"" SKIP .
/*est*/        /*PUT UNFORMATTED "~"" xkprhssite "~" ~"" xkprhssloc "~"" SKIP .*/
        PUT UNFORMATTED "~"" xkprhdsite "~" ~"" xkprhdloc "~" ~"~"" SKIP .
        PUT UNFORMATTED "." SKIP .
        PUT UNFORMATTED "." SKIP .
        PUT UNFORMATTED "@@end" SKIP .
    END.

END. /*transfer transaction*/

OUTPUT CLOSE .


/*cimload transaction*/
IF SEARCH(cimf) = ? THEN LEAVE .
trbgtm = TIME.
{gprun.i ""xgstdcim1.p"" "(input cimf ,
                          INPUT 'tttttt1.log' ,
                          OUTPUT err)"} .
IF err <> 0 THEN DO:
    MESSAGE "数据处理错误，请联系系统管理员，检查文件tttttt.cim tttttt1.log" .
    PAUSE.
    UNDO mainloop, RETRY mainloop.
END.
tredtm = TIME.

/*est*/IF po THEN DO:
/*est*/    FOR EACH cot_tmp:
              FIND FIRST b_co_mstr WHERE b_co_code = cot_code.
              ASSIGN b_co_lot = cot_lot.
           END.
/*est*/    {bcco002.i ""MAT-STOCK""}
/*est*/END.
/*est*/ELSE DO:
/*est*/    {bcco002.i ""MAT-PROD""}
/*est*/END.



/*cj01*******************add begin**************************/
/*xwh0517-------check if the inventory is changed*/
introk = YES.
FOR EACH xkprh_hist WHERE xkprh_nbr = rctnbr NO-LOCK:
    FIND LAST tr_hist WHERE tr_nbr = xkprh_po_nbr AND tr_effdate = xkprh_eff_date 
        AND tr_part = xkprh_part  
/*xwh050702*/   AND tr_time >= trbgtm AND tr_time <= tredtm 
        NO-LOCK NO-ERROR.
    IF AVAILABLE tr_hist THEN DO:
        IF tr_qty_loc <> xkprh_qty THEN DO:
            FIND bf-xkprh_hist WHERE RECID(bf-xkprh_hist) = RECID(xkprh_hist) EXCLUSIVE-LOCK NO-ERROR. 
            MESSAGE "行:" + string(xkprh_line) + ",零件号:" + xkprh_part + "收货量有误".
            bf-xkprh_hist.xkprh_qty = tr_qty_loc.
            introk = NO.
            RELEASE bf-xkprh_hist.
        END.
    END.
    ELSE DO:
        FIND bf-xkprh_hist WHERE RECID(bf-xkprh_hist) = RECID(xkprh_hist) EXCLUSIVE-LOCK NO-ERROR. 
        MESSAGE "行:" + string(xkprh_line) + ",零件号:" + xkprh_part + "没有库存收货量".
        bf-xkprh_hist.xkprh_qty = 0.
        introk = NO.
        RELEASE bf-xkprh_hist.
    END.
END.
IF NOT introk THEN DO:
    yn = NO .
    MESSAGE "收货有误，是否取消处理？" UPDATE yn .
    IF yn = YES THEN UNDO mainloop, RETRY mainloop .
END.
/*------xwh0517----------------------------*/
/*cj01*******************add end****************************/

FOR EACH xkprhhist WHERE xkprhponbr = pnbr AND xkprhinrcvd = NO AND xkprheffdate = effdate USE-INDEX xkprhinrcvd :
    xkprhinrcvd = YES .
END.
