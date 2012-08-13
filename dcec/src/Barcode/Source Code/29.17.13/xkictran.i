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
        PUT UNFORMATTED xkprhline SKIP .
        PUT UNFORMATTED xkprhqty " - - - - - ~"" xkprhdsite "~" ~"" xkprhdloc "~" - - - no no no" SKIP . 
    END.
    PUT UNFORMATTED "." SKIP .
    PUT UNFORMATTED "@@end" SKIP .

END. /*po transaction*/
ELSE DO :

    FOR EACH xkprhhist NO-LOCK WHERE xkprhponbr = pnbr AND xkprhinrcvd = NO AND xkprheffdate = effdate USE-INDEX xkprhinrcvd :
        PUT UNFORMATTED "@@batchload iclotr04.p" SKIP .
        PUT UNFORMATTED "~"" xkprhpart "~"" SKIP .
        PUT UNFORMATTED xkprhqty " " STRING(effdate,"99/99/99") " ~"" xkprhponbr "~"" SKIP(1) .
        PUT UNFORMATTED "~"" xkprhssite "~" ~"" xkprhssloc "~"" SKIP .
        PUT UNFORMATTED "~"" xkprhdsite "~" ~"" xkprhdloc "~"" SKIP .
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
    MESSAGE "���ݴ����������ϵϵͳ����Ա������ļ�tttttt.cim tttttt1.log" .
    PAUSE.
    UNDO mainloop, RETRY mainloop.
END.
tredtm = TIME.

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
            MESSAGE "��:" + string(xkprh_line) + ",�����:" + xkprh_part + "�ջ�������".
            bf-xkprh_hist.xkprh_qty = tr_qty_loc.
            introk = NO.
            RELEASE bf-xkprh_hist.
        END.
    END.
    ELSE DO:
        FIND bf-xkprh_hist WHERE RECID(bf-xkprh_hist) = RECID(xkprh_hist) EXCLUSIVE-LOCK NO-ERROR. 
        MESSAGE "��:" + string(xkprh_line) + ",�����:" + xkprh_part + "û�п���ջ���".
        bf-xkprh_hist.xkprh_qty = 0.
        introk = NO.
        RELEASE bf-xkprh_hist.
    END.
END.
IF NOT introk THEN DO:
    yn = NO .
    MESSAGE "�ջ������Ƿ�ȡ������" UPDATE yn .
    IF yn = YES THEN UNDO mainloop, RETRY mainloop .
END.
/*------xwh0517----------------------------*/
/*cj01*******************add end****************************/

FOR EACH xkprhhist WHERE xkprhponbr = pnbr AND xkprhinrcvd = NO AND xkprheffdate = effdate USE-INDEX xkprhinrcvd :
    xkprhinrcvd = YES .
END.
