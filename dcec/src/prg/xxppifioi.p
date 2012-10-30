 /* LOAD DATA FROM PPIF INTO MFG/PRO AND EXPORT SCHEDULE FROM MFG/PRO    */
/* xxppifioi.p - Interface between PPIF & MFG/PRO.      ITEM MAINT     */
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

        
/*      
        find first code_mstr no-lock where code_fldname = "PPIF-QAD-CTRL" and code_value = "SCHEDULE_DAY" no-error.
        if available code_mstr then do:
            SCD_DAY = integer(code_cmmt).
        end.
*/
    /*  trid_begin = 0. 2005-01-19 13:01*/

        /*2004-9-29 10:58*/
        find last xxppif_log no-lock no-error.
        trid_begin = if available xxppif_log then (xxppif_tr_id + 1) else 1.
        
        /*2005-01-19 14:09*/
        find first usrw_wkfl exclusive-lock where
        usrw_key1 = "XX-PPIF-LASTID" no-error.
        if not available usrw_wkfl then do:
            create usrw_wkfl.
            usrw_key1 = "XX-PPIF-LASTID".
        end.
        usrw_decfld[1] = trid_begin.
        
        for each ttlog:
            delete ttlog.
        end.
        
 
        /*GET DATA FROM INTERFACE FILES, WIRTE TO DB */     
        run OPEN_DELIVER_FILE("PPIF_ITEM").
        
        run OPEN_DELIVER_FILE("PPIF_SO").
        /*对临时表进行排序并且create xxppif_log*/
        
        
        /*
        define temp-table ttlog no-lock no-error.  /*建立康明斯的信息*/
             fields  ttlog_tr_id    like xxppif_tr_id
             fields  ttlog_act_date like xxppif_act_date
             fields  ttlog_act_time like xxppif_act_time 
             fields  ttlog_file     like xxppif_file
             fields  ttlog_tr_code  like xxppif_tr_code
             fields  ttlog_content  like xxppif_content.
        依照以下顺序产生记录
        PDIA/SOIA
        PDIC/SOSC
        PDID
        PDSAO/SOSAO
        PDSAI/SOSAI
        PDSC /SOSC

        */
        find last xxppif_log no-lock no-error.
        trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
        
        for each ttlog no-lock where substring(ttlog_content,1,4)="PDIA"
                                  or substring(ttlog_content,1,4)="SOIA":
            create xxppif_log.
            assign  xxppif_tr_id    = trid
                    xxppif_act_date = ttlog_act_date
                    xxppif_act_time = ttlog_act_time
                    xxppif_file     = ttlog_file
                    xxppif_tr_code  = ttlog_tr_code
                    xxppif_content  = ttlog_content
                    xxppif__log01   = ttlog__log01
                    xxppif__log02   = ttlog__log02.
            assign trid = trid + 1.
        end.
        
                
        for each ttlog no-lock where substring(ttlog_content,1,4)="PDIC"
                                  or substring(ttlog_content,1,4)="soic":
            create xxppif_log.
            assign  xxppif_tr_id    = trid
                    xxppif_act_date = ttlog_act_date
                    xxppif_act_time = ttlog_act_time
                    xxppif_file     = ttlog_file
                    xxppif_tr_code  = ttlog_tr_code
                    xxppif_content  = ttlog_content
                    xxppif__log01   = ttlog__log01
                    xxppif__log02   = ttlog__log02.
            assign trid = trid + 1.
        end.
        
                
        for each ttlog no-lock where substring(ttlog_content,1,4)="PDID":
            create xxppif_log.
            assign  xxppif_tr_id    = trid
                    xxppif_act_date = ttlog_act_date
                    xxppif_act_time = ttlog_act_time
                    xxppif_file     = ttlog_file
                    xxppif_tr_code  = ttlog_tr_code
                    xxppif_content  = ttlog_content
                    xxppif__log01   = ttlog__log01
                    xxppif__log02   = ttlog__log02.
            assign trid = trid + 1.
        end.
        
                
        for each ttlog no-lock where substring(ttlog_content,1,5)="PDSAO"
                                  or substring(ttlog_content,1,5)="SOSAO":
            create xxppif_log.
            assign  xxppif_tr_id    = trid
                    xxppif_act_date = ttlog_act_date
                    xxppif_act_time = ttlog_act_time
                    xxppif_file     = ttlog_file
                    xxppif_tr_code  = ttlog_tr_code
                    xxppif_content  = ttlog_content
                    xxppif__log01   = ttlog__log01
                    xxppif__log02   = ttlog__log02.
            assign trid = trid + 1.
        end.
        
                
        for each ttlog no-lock where substring(ttlog_content,1,5)="PDSAI"
                                  or substring(ttlog_content,1,5)="SOSAI":
            create xxppif_log.
            assign  xxppif_tr_id    = trid
                    xxppif_act_date = ttlog_act_date
                    xxppif_act_time = ttlog_act_time
                    xxppif_file     = ttlog_file
                    xxppif_tr_code  = ttlog_tr_code
                    xxppif_content  = ttlog_content
                    xxppif__log01   = ttlog__log01
                    xxppif__log02   = ttlog__log02.
            assign trid = trid + 1.
        end.
        
        for each ttlog no-lock where substring(ttlog_content,1,5)="PDSC"
                                  or substring(ttlog_content,1,5)="SOSC":
            create xxppif_log.
            assign  xxppif_tr_id    = trid
                    xxppif_act_date = ttlog_act_date
                    xxppif_act_time = ttlog_act_time
                    xxppif_file     = ttlog_file
                    xxppif_tr_code  = ttlog_tr_code
                    xxppif_content  = ttlog_content
                    xxppif__log01   = ttlog__log01
                    xxppif__log02   = ttlog__log02.
            assign trid = trid + 1.
        end.
        
        
        
        
        
        
        
        
        
        
        

        strinputfile    = filepath + "\" + "ppifi.tmp".
        stroutputfile   = filepath + "\" + "ppifiout.tmp".      

        output stream batchdata to value(strinputfile) no-echo.    

        put stream batchdata "~"" at 1 runuser "~" ~"" runpsw "~"".
        put stream batchdata "~"yyppptmt04-2.p~"" at 1.   /*1.4.3*/

        { xxppif01.i }
        
        put stream batchdata "." at 1.
        put stream batchdata "~"yypppsmt02-1.p~"" at 1.  /*1.4.17*/
        
        { xxppif02.i }
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














