/*************************************************
** Subprogram: xgtrprt2.p,called by xgsois.p
** Author : Xiang Wenhui , AtosOrigin
** Date   : 2005-9-26
** Description: transfer shipper print
*************************************************/

DEFINE INPUT PARAMETER trshipper LIKE xgtr_shipper.
define var i2 as integer.
DEFINE VAR i1 AS INTEGER.
DEFINE VAR loc LIKE xgtr_t_loc.
DEFINE VAR locdesc LIKE loc_desc.
define var temp_string as character.
define var temp_string1 as character.
DEFINE VARIABLE desc1 LIKE pt_desc1.
DEFINE VARIABLE temp_1 AS INTEGER.
DEFINE VARIABLE temp_2 AS INTEGER.
DEFINE VARIABLE temp_3 AS INTEGER.
DEFINE VARIABLE temp_4 AS CHARACTER.
DEFINE VARIABLE temp_5 AS INTEGER.
DEFINE VARIABLE temp_6 AS INTEGER.
DEFINE VARIABLE temp_7 AS CHARACTER INITIAL "移库".
DEFINE VARIABLE temp_num AS INTEGER . /*total page*/
define variable temp_8 as character.
define variable temp_9 as character.
define variable temp_10 as decimal.
define variable temp_12 as character.
DEFINE VARIABLE head_1  AS CHARACTER INITIAL "共".
DEFINE VARIABLE head_2  AS CHARACTER INITIAL "页 第".
DEFINE VARIABLE head_3  AS CHARACTER INITIAL "页".
DEFINE VARIABLE head_4  AS INTEGER INITIAL 1.
define variable temp_cust_part as character.
DEFINE BUFFER bf_xgtr_det FOR xgtr_det.
{mfdtitle.i}
/*calc page total number*/
i2 = 0.
FOR EACH xgtr_det WHERE xgtr_shipper = trshipper NO-LOCK :
    i2 = i2 + 1.
END.
IF  (i2 MODULO 12 ) < 6 AND (i2 MODULO 12) > 0 THEN temp_num = integer(i2 / 12) + 1.
ELSE temp_num = INTEGER((i2 / 12)).
/*end calc */
FIND FIRST xgtr_det WHERE xgtr_shipper = trshipper NO-LOCK NO-ERROR.
IF AVAILABLE xgtr_det THEN DO :
    if xgtr_print = YES then
       temp_12 = "**副本**".
    else temp_12  = "".
    i1 = 0.       
END.
/* Select printer */
{mfselprt.i "printer" 132 } 

for each xgtr_det NO-LOCK WHERE xgtr_shipper = trshipper
    USE-INDEX xgtr_shipper
    break by xgtr_shipper by xgtr_part:
    IF i1 = 0 THEN DO:
       FIND FIRST loc_mstr WHERE loc_loc = xgtr_t_loc NO-LOCK NO-ERROR.
       IF AVAILABLE(loc_mstr) THEN locdesc = loc_desc.

       PUT /*HEADER */
       SKIP(3.5)      
       temp_12 at 80
       xgtr_shipper at 120   SKIP
       head_1  at 120 FORMAT "x(2)" temp_num format ">9" head_2 FORMAT "x(5)"  head_4  format ">9" head_3 FORMAT "x(2)" 
       xgtr_t_loc AT 20 FORMAT "x(30)"
       locdesc AT 87 FORMAT "x(50)" SKIP(0.5)
    /*       ABS_shipvia AT 20 FORMAT "x(16)"
       ABS_trans_mode AT 52 FORMAT "x(12)"
       ABS_veh_ref AT 87 FORMAT "x(12)"   */
       temp_7 AT 129 SKIP(4) .
    END.
    /*bagin display */  
    FIND FIRST pt_mstr WHERE pt_part = xgtr_part NO-LOCK NO-ERROR. 
    temp_cust_part = "".
    find first cp_mstr where cp_part = xgtr_part 
    and cp_cust = xgtr_cust  /*add by Lu_2*/
    no-lock no-error.
    if available cp_mstr then temp_cust_part = cp_cust_part.   
    PUT
        pt_part AT 11 FORMAT "x(13)"   ""
        temp_cust_part FORMAT "x(15)" ""
        pt_desc1 FORMAT "x(20)"       "" 
        xgtr_f_loc  format "x(6)"       " "
        "   "   format "x(3)"        " " .
        
        IF temp_1 = 0 THEN PUT "    ".
        ELSE PUT temp_1  format "999"          " ".
        IF temp_2 = 0 THEN PUT "    ".
        ELSE PUT temp_2 format "999"          " ".
        IF temp_3 = 0 THEN PUT "   ".
        ELSE PUT temp_3 format "999"           "".
        PUT pt_um format "x(3)"          " "          
        xgtr_qty   format "->>>9.99"    "    "  .
        IF temp_5 = 0 THEN PUT "    ".
        ELSE PUT temp_5    format ">>9"        " ".
        IF temp_6 = 0 THEN PUT "    ".
        ELSE PUT temp_6    format ">>9"        " ".
        PUT xgtr_lot_count FORMAT ">>9"        SKIP.
    if available pt_mstr then do:
    PUT   
        "        " AT 11 FORMAT "x(12)"   " "
        "                  " FORMAT "x(15)" " "
      /*  pt_desc2 FORMAT "x(24)" */ SKIP.     
    END.
    ELSE PUT SKIP.
    i1 = i1 + 1.
    IF i1 > 11  THEN DO: 
        PUT skip(6).
        PUT xgtr_cust AT 100 format "x(8)" .
        PUT global_userid at 15 
            year(today) at 53 format "9999"
            month(today) at 60 format "99"
            day(today) at 65 format "99" SKIP(6) .
        i1 = 0.
    
       ASSIGN head_4 = head_4 + 1.      
    END. /*if i1 > 11 then do*/

    FIND  bf_xgtr_det WHERE recid(bf_xgtr_det) = RECID(xgtr_det) EXCLUSIVE-LOCK NO-ERROR.
    bf_xgtr_det.xgtr_print = YES.
    RELEASE bf_xgtr_det.

END. /*for each xgtr_det*/
IF i1 < 12  and i1 <> 0 THEN DO:
    repeat:
         if i1 >= 12 then leave.
         i1 = i1 + 1.
         PUT  skip(2).
    end.
    PUT skip(6).
    PUT xgtr_cust AT 100 format "x(8)" .
    PUT global_userid at 15
        year(today) at 53 format "9999"
        month(today) at 60 format "99"
        day(today) at 65 format "99"  /*change SKIP(3) */  .
    /*     PUT SKIP(3).   */
                                
    PUT SKIP(6).  
    i1 = 0.
END. 

{mfreset.i}
