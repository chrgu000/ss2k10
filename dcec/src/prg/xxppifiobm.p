/* LOAD DATA FROM PPIF INTO MFG/PRO AND EXPORT SCHEDULE FROM MFG/PRO    */
/* xxppifiobm.p - Interface between PPIF & MFG/PRO.      BOM MAINT   */
/* CREATE BY *lb01* LONG BO      ATOS ORIGIN CHINA                      */


/*************************************************************************                                                                     
    THIS PROGRAM:
    1.READ 2 FILES GENERATED FROM PPIF WHICH INCLUDE THE 
      INFOMATION OF ITEM MASTER, SHOP ORDER ITEM, ITEM & SHOP ORDER BOM.
    2.CIM LOAD THESE INFOMATION INTO MFG/PRO.
    3.WRITE LOG TO XXPPIF_LOG FOR TRACKING EVERY TRANSACTION
    4.GENERATE A FILE WHICH INCLUDE REPETITIVE SCHEDULE INFOMATION.
    
    PPIF -> MFG/PRO TRANSATIONS:
        PDIA    ITEM ADD
        PDIC    ITEM CHANGE
        PDID    ITEM DELETE
        PDSA    ITEM STRUCTURE ADD
        PDSC    ITEM STRUCTURE CHANGE
        SOIA    SHOP ORDER ITEM ADD
        SOIC    SHOP ORDER ITEM CHANGE
        SOSA    SHOP ORDER STRUCTURE ADD
        SOSC    SHOP ORDER STRUCTURE CHANGE
        
    MFG/PRO -> PPIF TRANSATTION:
        XSCD    SCHEDULE OUTPUT
    

*************************************************************************/

/* LAST MODIFIED 02 APR. 04      *LB01*         LONG BO                 */
/* LAST MODIFIED 2004-08-25 21:04      LONG BO                          */

        { xxppifdef.i }
    
        /*READING INFOMATION*/
        define buffer xxppiflog for xxppif_log.
        
/*      
        find first code_mstr no-lock where code_fldname = "PPIF-QAD-CTRL" and code_value = "SCHEDULE_DAY" no-error.
        if available code_mstr then do:
            SCD_DAY = integer(code_cmmt).
        end.
*/
        

        strinputfile    = filepath + "\" + "ppifbm.tmp".
        stroutputfile   = filepath + "\" + "ppifbm.out".        

        output stream batchdata to value(strinputfile) no-echo.    

        put stream batchdata "~"" at 1 runuser "~" ~"" runpsw "~"".
      /*tfq  put stream batchdata "~"zzbmpsmt.p~"" at 1.  */
    /*tfq*/  put stream batchdata "~"yybmpsmt.p~"" at 1.

        { xxppif05.i }

        put stream batchdata "." at 1.
        put stream batchdata "." at 1.
        put stream batchdata "~"Y~"" at 1.
        output stream batchdata close.    
        
        INPUT CLOSE.
        INPUT from value(strinputfile).
        output to value(stroutputfile).
        PAUSE 0 BEFORE-HIDE.
        RUN MF.P.
        INPUT CLOSE.
        OUTPUT CLOSE.

    /*PROCEDURE*/
    { xxppifpro.i }














