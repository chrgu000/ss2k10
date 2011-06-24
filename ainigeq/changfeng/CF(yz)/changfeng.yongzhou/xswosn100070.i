define variable label_src as character format "x(100)".
define variable label_para as character format "x(100)".

procedure printloop.
    define variable labelspath as character format "x(100)" init "/app/mfgpro/bc/labels/".
    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath"no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then  labelspath = labelspath + "/".

    input from value(labelspath + "xswosn10" ).
    wsection = trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99')) + "xswosn10" + trim(string(time)) + trim(string(random(1,100))) .
    output to value( trim(wsection) + ".l") .
    do while true:

        import unformatted label_src.
/*****
            label_para = "" .
            find first pt_mstr where pt_part = wo_part  no-lock no-error.
            if available ( pt_mstr )  then label_para = trim(pt_desc1).
            if index(label_src,"$f") <> 0  then do:
                label_src = substring(label_src, 1, index(label_src , "$f") - 1) + label_para + substring( label_src , index(label_src ,"$f") + length("$f"), length(label_src) - ( index(label_src ,"$f" ) + length("$f") - 1 ) ).
            end.

            label_para = wo_part.
            if index(label_src,"$p") <> 0  then do:
                label_src = substring(label_src, 1, index(label_src , "$p") - 1) + label_para + substring( label_src , index(label_src ,"$p") + length("$p"), length(label_src) - ( index(label_src ,"$p" ) + length("$p") - 1 ) ).
            end.
*****/

        put unformatted label_src skip.            
    end.   /*do while true:*/
    input close.
    output close.

    unix silent value ("chmod 777  " + trim(wsection) + ".l").

end procedure.

run printloop .

do i = 1 to integer(s0050):
    find first prd_det where prd_dev = s0060 no-lock no-error.
    if available prd_det then do:
        unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
    end.
end.

unix silent value ( 'rm -f '  + trim(wsection) + '.l').










