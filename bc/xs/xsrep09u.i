/* Create MFG/PRO Execte File Path  START */
/* define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/ch/". */
/* define shared variable global_gblmgr_handle as handle no-undo. */
/* ss - 111008.1 by: jack */
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
run pxgblmgr.p persistent set global_gblmgr_handle.
/* Create MFG/PRO Execte File Path   END  */

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if AVAILABLE(code_mstr) Then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1) <> "/" then 
 global_user_lang_dir = global_user_lang_dir + "/".
/* Create LOGIN MFG/PRO USER ID START */
/* Create LOGIN MFG/PRO USER ID END */
/* Create Section Variable START */
/*
DEFINE SHARED variable usection as char format "x(16)".
*/
/* Create Section Variable END */

IF DEC(v1600) = DEC(v1601) AND v1600 = string(0) THEN DO:
    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "rep09" .
    output to value( trim(usection) + ".i") .
    display 
        /* ss - 111008.1 -b
    trim(V1100)  format "x(50)" skip
    ss - 111008.1 -e */
        /* ss - 111008.1 -b */
         trim(v_line)  format "x(50)" skip
        /* ss - 111008.1 -e */
    trim(V1203) + " - " + trim ( V1002 )  format "x(50)" skip
    """" + trim(V1300) + """" + " " + trim ( V1310 ) + " " + trim ( V1100 ) format "x(50)" skip
    "-" skip
    "-" skip
    "-" SKIP
    " " skip
    "." skip
    "Y" skip
    "."
         with fram finput no-box no-labels width 200.
    OUTPUT CLOSE .

    input from value ( usection + ".i") .
    output to  value ( usection + ".o") .
            {gprun.i ""xxrebkfl.p""}
    input close.
    output close.
END.
ELSE IF DEC(v1600) = DEC(v1601) THEN DO:
    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "rep09" .
    output to value( trim(usection) + ".i") .
    display 
   /* ss - 111008.1 -b
    trim(V1100)  format "x(50)" skip
    ss - 111008.1 -e */
        /* ss - 111008.1 -b */
         trim(v_line)  format "x(50)" skip
        /* ss - 111008.1 -e */
    trim(V1203) + " - " + trim ( V1002 )  format "x(50)" skip
    """" + trim(V1300) + """" + " " + trim ( V1310 ) + " " + trim ( V1100 ) format "x(50)" skip
    "-" skip
    "-" skip
    "- " + V1600 + " - - " + v1601  format "x(50)" skip
    " " skip
    "." skip
    "." skip
    "Y" skip
    "Y" skip
    "Y" skip
    "."
         with fram finput1 no-box no-labels width 200.
    OUTPUT CLOSE .

    input from value ( usection + ".i") .
    output to  value ( usection + ".o") .
            {gprun.i ""xxrebkfl.p""}
    input close.
    output close.
END.
ELSE DO:
    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "rep09" .
    output to value( trim(usection) + ".i") .
            display 
    /* ss - 111008.1 -b
    trim(V1100)  format "x(50)" skip
    ss - 111008.1 -e */
        /* ss - 111008.1 -b */
         trim(v_line)  format "x(50)" skip
        /* ss - 111008.1 -e */
    trim(V1203) + " - " + trim ( V1002 )  format "x(50)" skip
    """" + trim(V1300) + """" + " " + trim ( V1310 ) + " " + trim ( V1100 ) format "x(50)" skip
    "-" skip
    "-" skip
    "- " + V1600 + " - - " + V1601  format "x(50)" skip
    " " skip
    "." skip
    "." skip
    "Y" skip
    "Y" skip
    string(DEC(V1600) - DEC(v1601)) + " - - " + V1002 + " " + V1510 + " " + V1500 format "x(50)" skip
    "Y" skip
    "Y" skip
    "."
         with fram finput2 no-box no-labels width 200.
    OUTPUT CLOSE .

    input from value ( usection + ".i") .
    output to  value ( usection + ".o") .
            {gprun.i ""xxrebkfl.p""}
    input close.
    output close.
END.

    ciminputfile = usection + ".i".
    cimoutputfile = usection + ".o".
    {xserrlg.i}

    /*
    unix silent value ( "rm -f "  + Trim(usection) + ".i").
    unix silent value ( "rm -f "  + Trim(usection) + ".o").
      */
