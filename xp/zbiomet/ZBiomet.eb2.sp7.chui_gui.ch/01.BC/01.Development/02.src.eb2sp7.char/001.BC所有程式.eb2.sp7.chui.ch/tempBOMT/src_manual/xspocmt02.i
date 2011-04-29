define var v_cmt_ht as char format "x(40)" .   v_cmt_ht   = "" .

for each usrw_wkfl 
    where usrw_key1 = v1105 and usrw_charfld[3] <> "0" 
    break by usrw_key1 by usrw_key2 :
    if last-of(usrw_key1) then do:

        find first xsj_hist use-index xsj_nbr where xsj_nbr = v1050 no-lock no-error.
        v_cmt_ht = if available (xsj_hist) then xsj_ht else "". /*合同号*/

        if v_cmt_ht <> "" then do:

            v_cmt_ht = "合同号:" + v_cmt_ht .
            find first po_mstr where po_nbr = v1100 no-error .
            if avail po_mstr then do:
                if po_cmtindx = 0 then do:
                    po_cmtindx = next-value(cmt_sq01) .
                    if po_cmtindx = 0 then po_cmtindx = next-value(cmt_sq01) .

                    create  cmt_det .
                    assign  cmt_indx      = po_cmtindx 
                            cmt_seq       = 0 
                            cmt_print     = ",QO,SO,IN,PA,PO,SH,BL,DO,IS"
                            cmt_cmmt[01]  = v_cmt_ht
                            .
                end.
                else do:
                    find first cmt_det where cmt_indx = po_cmtindx no-error .
                    if avail cmt_Det then do:
                        assign 
                            cmt_cmmt[15] = cmt_cmmt[14] + cmt_cmmt[15] 
                            cmt_cmmt[14] = cmt_cmmt[13] 
                            cmt_cmmt[13] = cmt_cmmt[12] 
                            cmt_cmmt[12] = cmt_cmmt[11] 
                            cmt_cmmt[11] = cmt_cmmt[10] 
                            cmt_cmmt[10] = cmt_cmmt[09] 
                            cmt_cmmt[09] = cmt_cmmt[08] 
                            cmt_cmmt[08] = cmt_cmmt[07] 
                            cmt_cmmt[07] = cmt_cmmt[06] 
                            cmt_cmmt[06] = cmt_cmmt[05] 
                            cmt_cmmt[05] = cmt_cmmt[04] 
                            cmt_cmmt[04] = cmt_cmmt[03] 
                            cmt_cmmt[03] = cmt_cmmt[02] 
                            cmt_cmmt[02] = cmt_cmmt[01] 
                            cmt_cmmt[01] = v_cmt_ht
                            .
                    end.
                end.
            end. /*if avail po_mstr*/
        end.  /*if v_cmt_ht <> ""*/
    end. /*if last-of(usrw_key1)*/
end. /*for each usrw_wkfl */