DEFINE INPUT PARAMETER trshipper LIKE b_trs_shipper.

define var i2 as integer.
DEFINE VAR i1 AS INTEGER.
DEFINE VAR loc LIKE b_trs_t_loc.
DEFINE VAR locdesc LIKE loc_desc.
DEFINE VARIABLE cust LIKE ad_addr.
DEFINE VARIABLE custname LIKE ad_name.
DEFINE VARIABLE custaddr LIKE ad_line1.
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
DEFINE BUFFER bf_b_trs_det FOR b_trs_det. 

{mfdeclre.i}
{gplabel.i}


DEFINE VARIABLE dh AS CHARACTER.

        FIND FIRST b_trs_det WHERE b_trs_shipper = trshipper NO-LOCK NO-ERROR.
        IF AVAILABLE b_trs_det THEN DO:

            temp_7 = b_trs_type.
    
            /*calc page total number*/
            i2 = 0.
            FOR EACH b_trs_det WHERE b_trs_shipper = trshipper NO-LOCK :
            i2 = i2 + 1.
            END.
            IF  (i2 MODULO 12 ) < 6 AND (i2 MODULO 12) > 0 THEN temp_num = integer(i2 / 12) + 1.
            ELSE temp_num = INTEGER((i2 / 12)).
            /*end calc */
            FIND FIRST b_trs_det WHERE b_trs_shipper = trshipper NO-LOCK NO-ERROR.
            IF AVAILABLE b_trs_det THEN DO:
                if b_trs_print = YES then
                temp_12 = "**副本**".
                else temp_12  = "".
                i1 = 0.       
            END.

            FIND FIRST ABS_mstr NO-LOCK WHERE ABS_id = "s" + b_trs_shipper NO-ERROR.
            IF AVAILABLE ABS_mstr THEN
                ASSIGN dh = substring(ABS__qad01,61,20).

            /* Select printer */
            {mfselprt.i "printer" 132 } 
             
            for each b_trs_det NO-LOCK WHERE b_trs_shipper = trshipper
            USE-INDEX b_trs_shipper
            break by b_trs_shipper by b_trs_part:
                IF i1 = 0 THEN DO:
                    IF b_trs_type NE "销售" THEN DO:
                        FIND FIRST loc_mstr WHERE loc_loc = b_trs_t_loc NO-LOCK NO-ERROR.
                        IF AVAILABLE(loc_mstr) THEN locdesc = loc_desc.
                        FIND FIRST ad_mstr WHERE ad_addr = b_trs_cust NO-LOCK NO-ERROR.
                        IF AVAILABLE(ad_mstr) THEN custname = ad_name.
                        PUT /*HEADER */
                        SKIP(3.5)      
                        temp_12 at 80
                        b_trs_shipper at 120   SKIP
                        head_1  at 120 FORMAT "x(2)" temp_num format ">9" head_2 FORMAT "x(5)"  head_4  format ">9" head_3 FORMAT "x(2)" 
                        b_trs_t_loc AT 20 FORMAT "x(30)"
                        locdesc AT 87 FORMAT "x(50)" SKIP(0.5)
                     /*       ABS_shipvia AT 20 FORMAT "x(16)"
                        ABS_trans_mode AT 52 FORMAT "x(12)"
                        ABS_veh_ref AT 87 FORMAT "x(12)"   */
                        /*dh AT 52 FORMAT "x(10)"*/
                        temp_7 AT 129 SKIP(4) .
                    END.
                    ELSE DO:
                        FIND FIRST loc_mstr WHERE loc_loc = b_trs_t_loc NO-LOCK NO-ERROR.
                        IF AVAILABLE(loc_mstr) THEN locdesc = loc_desc.
                        FIND FIRST ad_mstr WHERE ad_addr = b_trs_cust NO-LOCK NO-ERROR.
                        IF AVAILABLE(ad_mstr) THEN do:
                            custname = ad_name.
                            custaddr = ad_line1.
                        END.
                        PUT /*HEADER */
                        SKIP(3.5)      
                        temp_12 at 80
                        b_trs_shipper at 120   SKIP
                        head_1  at 120 FORMAT "x(2)" temp_num format ">9" head_2 FORMAT "x(5)"  head_4  format ">9" head_3 FORMAT "x(2)" 
                        custname AT 20 FORMAT "x(30)"
                        custaddr AT 87 FORMAT "x(50)" SKIP(0.5)
                     /*       ABS_shipvia AT 20 FORMAT "x(16)"
                        ABS_trans_mode AT 52 FORMAT "x(12)"
                        ABS_veh_ref AT 87 FORMAT "x(12)"   */
                        dh AT 52 FORMAT "x(10)"
                        temp_7 AT 129 SKIP(4) .
                    END.
                END.
                /*bagin display */  
                FIND FIRST pt_mstr WHERE pt_part = b_trs_part NO-LOCK NO-ERROR. 
                temp_cust_part = "".
                find first cp_mstr where cp_part = b_trs_part AND cp_cust = b_trs_cust no-lock no-error.
                if available cp_mstr then temp_cust_part = cp_cust_part.   
                PUT
                    pt_part AT 11 FORMAT "x(14)"   ""
                    temp_cust_part FORMAT "x(15)" ""
                    pt_desc1 FORMAT "x(20)"       "" 
                    b_trs_f_loc  format "x(6)"       " "
                    "   "   format "x(3)"        " " .
                    
                    IF temp_1 = 0 THEN PUT "    ".
                    ELSE PUT temp_1  format "999"          " ".
                    IF temp_2 = 0 THEN PUT "    ".
                    ELSE PUT temp_2 format "999"          " ".
                    IF temp_3 = 0 THEN PUT "   ".
                    ELSE PUT temp_3 format "999"           "".
                    PUT pt_um format "x(3)"          " "          
                    b_trs_qty   format "->>>9.99"    "    "  .
                    IF temp_5 = 0 THEN PUT "    ".
                    ELSE PUT temp_5    format ">>9"        " ".
                    IF temp_6 = 0 THEN PUT "    ".
                    ELSE PUT temp_6    format ">>9"        " ".
                    PUT b_trs_lot_count FORMAT ">>9"        SKIP.
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
                    PUT b_trs_cust AT 100 format "x(8)" .
                    PUT global_userid at 15 
                        year(today) at 53 format "9999"
                        month(today) at 60 format "99"
                        day(today) at 65 format "99" SKIP(6) .
                    i1 = 0.
                
                   ASSIGN head_4 = head_4 + 1.      
                END. /*if i1 > 11 then do*/
           
                FIND  bf_b_trs_det WHERE recid(bf_b_trs_det) = RECID(b_trs_det) EXCLUSIVE-LOCK NO-ERROR.
                bf_b_trs_det.b_trs_print = YES.
                RELEASE bf_b_trs_det.
            
            END. /*for each b_trs_det*/
            IF i1 < 12  and i1 <> 0 THEN DO:
                repeat:
                     if i1 >= 12 then leave.
                     i1 = i1 + 1.
                     PUT  skip(2).
                end.
                PUT skip(6).
                PUT b_trs_cust AT 100 format "x(8)" .
                PUT global_userid at 15
                    year(today) at 53 format "9999"
                    month(today) at 60 format "99"
                    day(today) at 65 format "99"  /*change SKIP(3) */  .
                /*     PUT SKIP(3).   */
                                            
                PUT SKIP(6).  
                i1 = 0.
            END. 
        END. /*end for if available b_trs_det then do*/
        ELSE DO:
           find first abs_mstr no-lock WHERE abs_id  = "s" + trshipper
                                         no-error.
            if  available abs_mstr then do:
                /*print out-door-document
                {gprun.i ""xxship02p.p"" "(input recid(abs_mstr))"}
                */
                {gprun.i ""xgicshprt2.p"" "(input recid(abs_mstr))"}
            end.
        END.
     {mfreset.i}
     {mfgrptrm.i}
