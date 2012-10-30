/*-----------------------------------------------------------------------------*/       
        /***********************************************************
        ************************************************************
        **                                                        **
        **     1. PROCEDURE: OPEN_DELIVER_FILE                    **
        **                                                        **
        **        OPEN DELIVER FILE AND READ INFOMATION           **
        **                                                        **
        **        PPIF_WHICH : PPIF_ITEM                          **
        **                     PPIF_SO                            **
        **                                                        **
        **                                                        **
        ************************************************************
        ***********************************************************/
        /*Last Modified BY Li Wei , Date:2005-12-6*/

        PROCEDURE OPEN_DELIVER_FILE:
            
            define input parameter PPIF_WHICH as char.
            
            define var vbkfile as char.

            
            
            find first code_mstr no-lock where code_fldname = PPIF_WHICH no-error.
            if not available code_mstr then do:
                find last xxppif_log no-lock no-error.
                trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
                create xxppif_log.
                assign  xxppif_tr_id    = trid
                        xxppif_act_date = today
                        xxppif_act_time = string(time, "HH:MM:SS")
                        xxppif_err      = 2
                        xxppif_msg      = "CODE_MSTR NOT DEFINE " + PPIF_WHICH
                        xxppif_tr_code  = "XSYS".
            end.
            else do:
                filename = trim(code_value).
                filepath = trim(code_cmmt).
                sourcename = trim(code_cmmt) + "\" + trim(code_value).
                vbkfile = filepath + "\bak\" + string(year(today),"9999")
                                             + string(month(today),"99")
                                             + string(day(today),"99")
                                             + string(time)
                                             + ppif_which 
                                             + ".txt".
                if search(sourcename) = ? then do:
                /*CAN NOT FIND THE FILE */
                    find last xxppif_log no-lock no-error.
                    trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
                    create xxppif_log.
                    assign  xxppif_tr_id    = trid
                            xxppif_act_date = today
                            xxppif_act_time = string(time, "HH:MM:SS")
                            xxppif_err      = 2
                            xxppif_msg      = "NOT FOUND " + sourcename 
                            xxppif_tr_code  = "XSYS".
                end.
                else do:  /* FIND THE FILE AND LOAD INFOMATION INTO XXPPIF_LOG */
                    RUN READ_FILE_INFO.
                    /*2004-09-06 11:39 BACK UP FILE*/
                    DOS SILENT move value(sourcename) value(vbkfile).
                end.
            end.
        END PROCEDURE.          




        /***********************************************************
        ************************************************************
        **                                                        **
        **     2. PROCEDURE: READ_FILE_INFO                       **
        **                                                        **
        **        READ INFO & IMPORT TO FILE XXPPIF_LOG           **
        **                                                        **
        **                                                        **
        ************************************************************
        ***********************************************************/

        PROCEDURE READ_FILE_INFO:
            
            input stream batchdata from value(search(sourcename)) no-echo.
            
            writing_data = no.
            
            linedata = "".
            readkey stream batchdata.
            do while lastkey <> keycode("RETURN") and lastkey >= 0:
                linedata = linedata + chr(lastkey).
                readkey stream batchdata.
            end.

            end_file = no.
            read_and_create:
            do while lastkey >= 0 or lastkey = -2:
                if end_file then 
                    leave read_and_create.
                if lastkey = -2 then 
                end_file = yes.
/*******************************************************************************
 * MJH007                /*ADD TO XXPPIF_LOG*/
 * MJH007               find last xxppif_log no-lock no-error.
 * MJH007               trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
 * MJH007               create xxppif_log.
 * MJH007               assign  xxppif_tr_id    = trid
 * MJH007                       xxppif_act_date = today
 * MJH007                       xxppif_act_time = string(time, "HH:MM:SS")
 * MJH007                       xxppif_file     = filename
 * MJH007                       xxppif_tr_code  = substring(linedata,1,4)
 * MJH007                       xxppif_content  = linedata.
 *****************************************************************************/
                /*ADD INFO END */           
/*MJH007*/      /*判断是否有本地item MJH007 for PDIA PDIC SOIA SOIC*/
/*MJH007*/      /*ADD TO XXPPIF_LOG*/
/*MJH007*/      if  substring(linedata,1,4) = "pdia" 
/*MJH007*/       or substring(linedata,1,4) = "soia" then do:

/*MJH007*/         localitem = substring(linedata,81,18). 
/*MJH007*/         if trim(localitem) <> "" then do:
/*MJH007*/            find last ttlog no-lock no-error. /*建立本地信息*/
/*MJH007*/            trid = if available ttlog then (ttlog_tr_id + 1) else 1.
/*MJH007*/            create ttlog.
/*MJH007*/            assign  ttlog_tr_id    = trid
/*MJH007*/                    ttlog_act_date = today
/*MJH007*/                    ttlog_act_time = string(time, "HH:MM:SS")
/*MJH007*/                    ttlog_file     = filename
/*MJH007*/                    ttlog_tr_code  = substring(linedata,1,4)
/*MJH007*/                    ttlog_content  = linedata.

/*MJH007*/         end. 
                   else do:
/*MJH007*/           find last ttlog no-lock no-error.  /*建立康明斯的信息*/
/*MJH007*/           trid = if available ttlog then (ttlog_tr_id + 1) else 1.
/*MJH007*/           create ttlog.
/*MJH007*/           assign  ttlog_tr_id    = trid
/*MJH007*/                   ttlog_act_date = today
/*MJH007*/                   ttlog_act_time = string(time, "HH:MM:SS")
/*MJH007*/                   ttlog_file     = filename
/*MJH007*/                   ttlog_tr_code  = substring(linedata,1,4)
/*MJH007*/                   ttlog_content  = substring(linedata,1,80).

                   end.
/*MJH007*/      end. /*end of if  substring(linedata,1,4)*/

/*MJH007*/      if  substring(linedata,1,4) = "pdic"
/*MJH007*/       or substring(linedata,1,4) = "soic" then do:

/*MJH007*/         find last ttlog no-lock no-error.  /*建立康明斯的信息*/
/*MJH007*/         trid = if available ttlog then (ttlog_tr_id + 1) else 1.
/*MJH007*/         create ttlog.
/*MJH007*/         assign  ttlog_tr_id    = trid
/*MJH007*/                 ttlog_act_date = today
/*MJH007*/                 ttlog_act_time = string(time, "HH:MM:SS")
/*MJH007*/                 ttlog_file     = filename
/*MJH007*/                 ttlog_tr_code  = substring(linedata,1,4)
/*MJH007*/                 ttlog_content  = substring(linedata,1,80).


/*MJH007*/         localitem = substring(linedata,81,18). 
/*MJH007*/         if trim(localitem) <> "" then do:
/*MJH007*/            find last ttlog no-lock no-error. /*建立本地信息*/
/*MJH007*/            trid = if available ttlog then (ttlog_tr_id + 1) else 1.
/*MJH007*/            create ttlog.
/*MJH007*/            assign  ttlog_tr_id    = trid
/*MJH007*/                    ttlog_act_date = today
/*MJH007*/                    ttlog_act_time = string(time, "HH:MM:SS")
/*MJH007*/                    ttlog_file     = filename
/*MJH007*/                    ttlog_tr_code  = substring(linedata,1,4)
/*MJH007*/                    ttlog_content  = linedata.

/*MJH007*/         end. 
/*MJH007*/      end. /*end of if  substring(linedata,1,4)*/

/*MJH007*/      /*判断是否有本地item MJH007 for PDSA or PDSC SOSA or SOSC 结构变动*/
/*MJH007*/      /*ADD TO XXPPIF_LOG*/
/*MJH007*/      if  substring(linedata,1,4) = "PDSA" or substring(linedata,1,4) = "PDSC"
/*MJH007*/       or substring(linedata,1,4) = "SOSA" or substring(linedata,1,4) = "SOSC" then do:


                 find first ttlog no-lock where substring(ttlog_content,12,12) = substring(linedata,12,12)
                                            and substring(ttlog_content,24,12) = substring(linedata,24,12)
                                            and ttlog__log01 = yes
                                            no-error. /*保证本次康明斯件只产生一次*/
                   if not available ttlog  then do:
/*MJH007*/            find last ttlog no-lock no-error.
/*MJH007*/            trid = if available ttlog then (ttlog_tr_id + 1) else 1.
/*MJH007*/            create ttlog.
/*MJH007*/            assign  ttlog_tr_id    = trid
/*MJH007*/                    ttlog_act_date = today
/*MJH007*/                    ttlog_act_time = string(time, "HH:MM:SS")
/*MJH007*/                    ttlog_file     = filename
/*MJH007*/                    ttlog_tr_code  = substring(linedata,1,4)
/*MJH007*/                    /*ttlog_content  = substring(linedata,1,66) lw01*/
                              ttlog_content  = linedata.
                   end.
                   	

/*MJH007*/         localitem = substring(linedata,67,18). /*local parent item*/
/*MJH007*/         if trim(localitem) <> ""  or  
                      trim(substring(linedata,85,18)) /*local component item*/ <> "" then do:

/*MJH007*/            if  trim(substring(linedata,85,18)) <> "" then do:
/*MJH007*/                assign ttlog__log01   = yes . /*对于结构来说，有本地子件存在*/
/*MJH007*/            end.

                      if trim(localitem) <> "" then do:
                         assign ttlog__log02 = yes.   /*对于结构来说，有本地父件存在*/ 
                      end.

/**** lw01 *********
/*MJH007*/            find last ttlog no-lock no-error.
/*MJH007*/            trid = if available ttlog then (ttlog_tr_id + 1) else 1.
/*MJH007*/            create ttlog.
/*MJH007*/            assign  ttlog_tr_id    = trid
/*MJH007*/                    ttlog_act_date = today
/*MJH007*/                    ttlog_act_time = string(time, "HH:MM:SS")
/*MJH007*/                    ttlog_file     = filename
/*MJH007*/                    ttlog_tr_code  = substring(linedata,1,4)
/*MJH007*/                    ttlog_content  = linedata.
****** lw01 ********/

/*MJH007*/         end. 


/*MJH007*/      end. /*end of if  substring(linedata,1,4)*/
                
                


                /* 2005-01-19 13:00
                if trid_begin = 0 then
                    trid_begin = trid.
                    */

                linedata = "".
                readkey stream batchdata.
                do while lastkey <> keycode("RETURN") and lastkey >= 0:
                    linedata = linedata + chr(lastkey).
                    readkey stream batchdata.
                end.
            end.

            input stream batchdata close.

/*
            find first usrw_wkfl exclusive-lock where
            usrw_key1 = "XX-PPIF-LASTID" no-error.
            if available usrw_wkfl then
                qad_decfld[2] = trid_begin .
            else do:
                create qad_wkfl.
                assign
                    qad_key1 = "XX-PPIF-LASTID"
                    qad_decfld[1] = trid_begin .
            end.
*/      
        END PROCEDURE.


        /***********************************************************
        ************************************************************
        **                                                        **
        **     3. PROCEDURE: SET_TRAN_DATE                        **
        **                                                        **
        **        ACCRODING TO XXPPIF_CONTENT, SET XXPPIF_TR_DATE **
        **                                                        **
        **        YYMMDD                                          **
        ************************************************************
        ***********************************************************/
        PROCEDURE SET_TRAN_DATE:
        
            define input parameter datePosStart as integer.
            define variable y as integer. /*YEAR*/
            define variable m as integer. /*MONTH*/
            define variable d as integer. /*DAY*/
            define variable iPos as integer.
            
            if not available xxppif_log then return.
            
            iPos = 0.
            do while iPos < 6:
                if index("0123456789",substring(xxppif_content,datePosStart + iPos,1)) = 0 then
                    iPos = 10.
                iPos = iPos + 1.
            end.
            if iPos >= 10 then do:
                xxppif_tr_date = ?.
                return.
            end.
            y = INTEGER(SUBSTRING(xxppif_content,datePosStart,2)) + 2000.                   
            m = INTEGER(SUBSTRING(xxppif_content,datePosStart + 2,2)).                  
            d = INTEGER(SUBSTRING(xxppif_content,datePosStart + 4,2)).                  
            if m < 1 or m > 12 then do:
                xxppif_tr_date = ?.
                return.
            end.
            if d < 1 then do:
                xxppif_tr_date = ?.
                return.
            end.
            if (m = 1 or m = 3 or m = 5 or m = 7 or m = 8 or m = 10 or m = 12)
            and  d > 31 then do:
                xxppif_tr_date = ?.
                return.
            end.
            if (m = 4 or m = 6 or m = 9 or m = 11)
            and d > 30 then do:
                xxppif_tr_date = ?.
                return.
            end.
            if (m = 2) and ((y mod 4) = 0)
            and d > 29 then do:
                xxppif_tr_date = ?.
                return.
            end.        
            if (m = 2) and ((y mod 4) <> 0)
            and d > 28 then do:
                xxppif_tr_date = ?.
                return.
            end.        
            
            xxppif_tr_date = date(m,d,y).
            
        END PROCEDURE.

        /***********************************************************
        ************************************************************
        **                                                        **
        **     4. PROCEDURE: SET_ADD_DATE                         **
        **                                                        **
        **        ACCRODING TO XXPPIF_CONTENT, SET XXPPIF__DTE01  **
        **                                                        **
        **        YYMMDD                                          **
        ************************************************************
        ***********************************************************/
        PROCEDURE SET_ADD_DATE:
        
            define input parameter datePosStart as integer.
            define variable y as integer. /*YEAR*/
            define variable m as integer. /*MONTH*/
            define variable d as integer. /*DAY*/
            define variable iPos as integer.
            
            if not available xxppif_log then return.
            
            iPos = 0.
            do while iPos < 6:
                if index("0123456789",substring(xxppif_content,datePosStart + iPos,1)) = 0 then
                    iPos = 10.
                iPos = iPos + 1.
            end.
            if iPos >= 10 then do:
                xxppif__dte01 = ?.
                return.
            end.
            y = INTEGER(SUBSTRING(xxppif_content,datePosStart,2)) + 2000.                   
            m = INTEGER(SUBSTRING(xxppif_content,datePosStart + 2,2)).                  
            d = INTEGER(SUBSTRING(xxppif_content,datePosStart + 4,2)).                  
            if m < 1 or m > 12 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if d < 1 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if (m = 1 or m = 3 or m = 5 or m = 7 or m = 8 or m = 10 or m = 12)
            and  d > 31 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if (m = 4 or m = 6 or m = 9 or m = 11)
            and d > 30 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if (m = 2) and ((y mod 4) = 0)
            and d > 29 then do:
                xxppif__dte01 = ?.
                return.
            end.        
            if (m = 2) and ((y mod 4) <> 0)
            and d > 28 then do:
                xxppif__dte01 = ?.
                return.
            end.        
            
            xxppif__dte01 = date(m,d,y).
            
        END PROCEDURE.

        /***********************************************************
        ************************************************************
        **                                                        **
        **     5. PROCEDURE: SET_EFF_DATE                         **
        **                                                        **
        **        ACCRODING TO XXPPIF_CONTENT, SET XXPPIF__DTE01  **
        **                                                        **
        **        MMDDYY                                          **
        ************************************************************
        ***********************************************************/
        PROCEDURE SET_EFF_DATE:
        
            define input parameter datePosStart as integer.
            define variable y as integer. /*YEAR*/
            define variable m as integer. /*MONTH*/
            define variable d as integer. /*DAY*/
            define variable iPos as integer.
            
            if not available xxppif_log then return.
            
            iPos = 0.
            do while iPos < 6:
                if index("0123456789",substring(xxppif_content,datePosStart + iPos,1)) = 0 then
                    iPos = 10.
                iPos = iPos + 1.
            end.
            if iPos >= 10 then do:
                xxppif__dte01 = ?.
                return.
            end.
            y = INTEGER(SUBSTRING(xxppif_content,datePosStart,2)) + 2000.                   
            m = INTEGER(SUBSTRING(xxppif_content,datePosStart + 2,2)).                  
            d = INTEGER(SUBSTRING(xxppif_content,datePosStart + 4,2)).                  
            if m < 1 or m > 12 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if d < 1 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if (m = 1 or m = 3 or m = 5 or m = 7 or m = 8 or m = 10 or m = 12)
            and  d > 31 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if (m = 4 or m = 6 or m = 9 or m = 11)
            and d > 30 then do:
                xxppif__dte01 = ?.
                return.
            end.
            if (m = 2) and ((y mod 4) = 0)
            and d > 29 then do:
                xxppif__dte01 = ?.
                return.
            end.        
            if (m = 2) and ((y mod 4) <> 0)
            and d > 28 then do:
                xxppif__dte01 = ?.
                return.
            end.        
            
            xxppif__dte01 = date(m,d,y).
            
        END PROCEDURE.
