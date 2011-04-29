define var v_ii as integer.
define var v_fldname as char format "x(30)" .



form 
    skip
    v_fldname colon 20 label "通用代码字段名" 
    skip(1)
with frame a with side-labels width 80 .


repeat:

    update v_fldname with frame a .

    v_ii = 0 .
    for each code_mstr where code_fldname = v_fldname no-lock:
        v_ii =  v_ii + 1 .
    end.

    message 
           "字段名称:"  v_fldname
           skip 
           "总记录数:" v_ii 
    view-as alert-box .

end.