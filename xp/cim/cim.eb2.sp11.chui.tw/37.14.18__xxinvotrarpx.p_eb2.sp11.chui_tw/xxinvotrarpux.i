/* {xxinvotraa.i} */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 060912.1  By: Kaine */
/* SS - 090826.1  By: Roger Xiao */

/* define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/". */
define variable usection as char format "x(16)". 


/* ********************Kaine B Del*******************
 *  usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "invotr" .
 *  output to value( trim(usection) + ".i") .
 *      for each tm1mstr no-lock :
 *          display 
 *              trim(tm1_part) format "x(18)" skip
 *              trim(String(tm1_qty))     format "x(40)" skip
 *              trim(site_from) format "x(12)" if trim(loc_from) = "" then """""" else """" + trim(loc_from) + """" format "x(12)" skip
 *              trim(site_to)    format "x(12)" if trim(loc_to)    = "" then  """""" else """" + trim(loc_to) + """" format "x(12)"     skip
 *              "y"    skip
 *              ". " 
 *          with fram finput no-box no-labels width 200.
 *      end.
 *  output close.
 *  
 *  input from value ( usection + ".i") .
 *  output to  value ( usection + ".o") .
 *      {gprun.i ""iclotr02.p""}
 *  input close.
 *  output close.
 *  
 *  UNIX silent value ( "rm "  + Trim(usection) + ".i").
 *  unix silent value ( "rm "  + Trim(usection) + ".o"). 
 * ********************Kaine E Del*******************/

/* SS - 090826.1 - B */
define var v_cimload_ok as logical no-undo.
define var v_cimoutputfile as char no-undo.
/* SS - 090826.1 - E */

    /* ***********************Kaine B Add********************** */
for each tm1mstr no-lock :
  

        usection = TRIM(string(year(TODAY)) 
                    + string(MONTH(TODAY)) 
                    + string(DAY(TODAY)))
                    + trim(STRING(TIME)) 
                    + trim(string(RANDOM(1,100))) 
                    + "invotr" 
                    .
        v_cimoutputfile = Trim(usection) + ".o" .

        output to value( trim(usection) + ".i") .
        
        PUT
            "~"" AT 1
            trim(tm1_part) format "x(18)"
            "~""
            SKIP
            
            trim(String(tm1_qty)) FORMAT "x(20)"    " "
            "- - - "
            "~""
            invno
            "~""
            SKIP
            
            trim(tm1_site) format "x(12)"
            /* SS - 090826.1 - B */
                if trim(tm1_loc) = "" then ' " " ' else (' "' + trim(tm1_loc) + '" ' ) format "x(18)"
                if trim(tm1_lot) = "" then ' " " ' else (' "' + trim(tm1_lot) + '" ' ) format "x(18)"
                if trim(tm1_ref) = "" then ' " " ' else (' "' + trim(tm1_ref) + '" ' ) format "x(18)"

                SKIP
                
                trim(site_to)    format "x(12)"
                if trim(loc_to)    = "" then ' " " ' else (' "' + trim(loc_to)  + '" ') format "x(18)"     
                if trim(tm1_lot)   = "" then ' " " ' else (' "' + trim(tm1_lot) + '" ') format "x(18)"
                ' " " '  
                SKIP
                "y"    SKIP
                /*"y"    SKIP   */
                ". " 
            /* SS - 090826.1 - E */
        .
        
        OUTPUT CLOSE.
        
        input from value ( usection + ".i") .
        output to  value ( usection + ".o") .
        batchrun = YES.
        {gprun.i ""iclotr03.p""}
        batchrun = NO.
        input close.
        output close.

/* SS - 090826.1 - B */
        run dataout (input v_cimoutputfile ,output v_cimload_ok).   
        if v_cimload_ok = yes then do:
                UNIX silent value ( "rm "  + Trim(usection) + ".i").
                UNIX silent value ( "rm "  + Trim(usection) + ".o").
        end.
        else do:
                undo,leave .
        end.
/* SS - 090826.1 - E */
end.
    /* ***********************Kaine E Add********************** */
    


/* SS - 090826.1 - B */
    procedure dataout.  
            define input  parameter vv_cimoutputfile as char no-undo.
            define output parameter vv_cimload_ok as logical no-undo.
            define variable woutputstatment as character .


            vv_cimload_ok = yes.            
            input from value ( vv_cimoutputfile) .
                do while true:
                    import unformatted woutputstatment.


                    if      index (woutputstatment,"error:")   <> 0 or    /* for us */
                            index (woutputstatment,"´íÎó:")    <> 0 or    /* for ch */        
                            index (woutputstatment,"¿ù»~:")    <> 0       /* for tw */          
                    then do:
                        vv_cimload_ok = no .
                    end.
                end. /*do while true*/
            input close.
    end procedure. /*dataout*/
/* SS - 090826.1 - E */



