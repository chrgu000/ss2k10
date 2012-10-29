/** yyppifbm01.p 13.1.2 **/
/***xxppif__chr01 1:���ϼ��� 2:Item ADD 3:Item Change 4:BOM ADD 5:BOM Change 6:BOM Code Create 7:Item Del **/
/*** item_type   1.�������ܳ�
								 2.�˴��(���Ƽ�)
								 3.��Ż����
								 4.Э���(�ɹ���)
								 5.����(F��)
								 6.�����
								 7.�׼�(C��) ***********/
/* Last change by Jean 04/10/2007  For SOSA SOSC local components change *J002*/
/* Last change by wilber 03/27/2008 For check the ptp_pm_code  change *W001*/
/* Last change by wilber 03/31/2008 For input the comment of 13.1.2 from pt_desc2  change *W002*/
/* Last change by wilber 04/02/2008 for item_type = 2 don't maintanence the bom-code  *W003*/
/* session:date-format = 'ymd'.                                 */
/* {mfdeclre.i "new global"}                                    */
/* {mf1.i "new global"}                                         */
/*                                                              */
/* base_curr = "RMB".                                           */
/* IF global_userid = "" THEN global_userid = "MFG".            */
/* mfguser="".                                                  */
/* global_user_lang = "ch".                                     */
/* global_user_lang_dir = "ch/".                                */
/* global_domain = "DCEC".                                      */

{ xxppifdef.i }
def var item_type as char.
def var item_status as char.
def var item_phantom as char.
def var item_pm_code as char.
def var cummins_par  as char.
def var cummins_child as char.
def var local_par  as char.
def var local_child as char.
def var exec_par as char.
def var exec_child as char.
/*J001*/ def var i_exec as integer.
        strinputfile    = filepath + "\" + "ppifb01.tmp".
        stroutputfile   = filepath + "\" + "ppifbout01.tmp".

/*W001 begin*/
        /*process the cimload record one by one */


        output stream batchdata to value(strinputfile) no-echo.

        put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"".            
        put stream batchdata unformatted "-" at 1 skip.
        put stream batchdata unformatted "~"yybmmamt2.p~"" at 1.   /*13.1.2*/
        		for each xxppif_log where xxppif_domain = global_domain
        				 and lookup(xxppif_tr_code,"PDSA,SOSA,PDSC,SOSC") > 0
                 and xxppif_err <> 2
                 and substr(xxppif__chr01,1,1) = "1"
                 and substr(xxppif__chr01,6,1) = "0":


  /*output stream batchdata to value(strinputfile) no-echo.
        for each xxppif_log where xxppif_domain = global_domain
             and lookup(xxppif_tr_code,"PDSA,SOSA,PDSC,SOSC") > 0
             and xxppif_err <> 2
             and substr(xxppif__chr01,1,1) = "1"
             and substr(xxppif__chr01,6,1) = "0":



                /*no-error proceed*/
                IF ERROR-STATUS:ERROR THEN DO:
                    OUTPUT STREAM batchdata CLOSE .
                    output stream batchdata to value(strinputfile) NO-ECHO .
                END.
                put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"".
                put stream batchdata unformatted "~"yybmmamt2.p~"" at 1.   /*13.1.2*/

*/
/*W001 end */


/*J001*/				cummins_par = trim(substring(xxppif_content,12,12)).
/*J001*/				cummins_child = trim(substring(xxppif_content,24,12)).
/*J001*/				local_par = "".
/*J001*/				local_child = "".
/*J001*/				exec_par = cummins_par.
/*J001*/				exec_child = cummins_child.
/*J002* /*J001*/				if lookup(xxppif_tr_code,"PDSA,PDSC") > 0 then do: */
/*J001*/						local_par = trim(substring(xxppif_content,67,16)).
/*J001*/						local_child = trim(substring(xxppif_content,85,16)).
/*J001*/						if local_par <> "" then exec_par = local_par.
/*J001*/						if local_child <> "" then exec_child = local_child.
/*J002* /*J001*/				end.	*/
/*J001**				strTmp = trim(substring(xxppif_content,12,12)).
    						/*  �ж��Ƿ��б��ص�par item,����еĻ����ʹ��������˹��*/
    					  if trim(substring(xxppif_content,67,16)) <> "" then do :
    					     strTmp = trim(substring(xxppif_content,67,16)).
     					  end.
**J001*/
/*J001*/				i_exec = 1.
/*J001*/				do i_exec = 1 to 2:
/*J001*/			     strTmp = (if i_exec = 1 then exec_par else exec_child).
        		    /** Check exist Item error**/
        		    find pt_mstr where pt_domain = global_domain and
        		    		 pt_part = strTmp no-lock no-error.
        		    if not avail pt_mstr then do:
        		       xxppif_msg = "2015-" + strTmp.
                   xxppif_err = 1.
        		       next.
        		    end.
        		/** site-c **/
								find first ptp_det no-lock where ptp_domain = global_domain and
												   ptp_part = strTmp and ptp_site = SITE-C no-error. /*SITE-B MJH007*/

            find first ptp_det no-lock where ptp_domain = global_domain and
            				   ptp_part = strTmp and ptp_site = SITE-C no-error. /*SITE-B MJH007*/
            find first code_mstr no-lock where code_domain = global_domain and
            				   code_fldname = "so site" and
                       code_value = substring(strTmp,1,3)
            use-index code_fldval no-error.
            /*if substring(strTmp,1,3) = "SO1" or (available ptp_det and ptp_phantom = yes) then do:*/
            if (not available code_mstr) and substring(strTmp,1,2)= "SO" then do:
               xxppif_err = 1.
               xxppif_msg = "2010-" + strTmp.
               next.
            end.
            if avail code_mstr then do:
               find ptp_det where ptp_domain = global_domain and
               		  ptp_part = strTmp and ptp_site = code_cmmt no-lock no-error.
               if not avail ptp_det then do:
                  xxppif_err = 1.
                  xxppif_msg = "2016-" + strTmp.
                  next.
               end.
               else do:
              if ptp_pm_code <> "m" then do:
 /*W002                    xxppif_err = 1.
                     xxppif_msg = "2012-" + strTmp.
       */
                     next.
                  end.

               end.
               if lookup(code_cmmt,"DCEC-B,DCEC-C") = 0 then do:
                  	 xxppif_err = 1.
                     xxppif_msg = "2011-" + strTmp.
                     next.
               end.

                    put stream batchdata unformatted "~"" at 1 strTmp  "~"" skip.
/*W002               put stream batchdata unformatted "-" at 1 skip.*/
                    put stream batchdata unformatted "DCEC-B" at 1 skip.

/*W002                    put stream batchdata unformatted "-" at 1 skip.         */
/*W002*/                 put stream batchdata unformatted "- " .
/*W002*/            FIND pt_mstr WHERE pt_domain = global_domain and
												 pt_part = strTmp NO-LOCK NO-ERROR .
/*W002*/                    PUT STREAM batchdata UNFORMATTED pt_desc1 SKIP.

            end.
            else do:
               find first ptp_det where ptp_domain = global_domain and
               					  ptp_part = strTmp and ptp_site = site-c no-lock no-error.
               if not avail ptp_det then do:
                  xxppif_err = 1.
                  xxppif_msg = "2016-" + strTmp.
                  next.
               end.
               else do:
           if ptp_pm_code <> "M" then do:
         /*W002             xxppif_err = 1.
                     xxppif_msg = "2012-" + strTmp.
         W002*/
                     next.
                  end.

                  find first ptp_det where ptp_domain = global_domain and
                  					 ptp_part = strTmp and ptp_site = site-B no-lock no-error.
                  if avail ptp_det and ptp_pm_code <> "M" then do:
        /*W002             xxppif_err = 1.
                     xxppif_msg = "2012-" + strTmp.
           W002*/
                     next.

                  end.



/*W003*/        if avail ptp_det THEN DO:

    /*W003*/            find pt_mstr where pt_domain = global_domain and
    												 pt_part = strTmp no-lock no-error.
    /*W003*/            if lookup(pt_group,"RAW,M") = 0 and ptp_pm_code <> "P" then do:

                            put stream batchdata unformatted "~"" at 1 strTmp "~"" skip.
        /*W002               put stream batchdata unformatted "-" at 1 skip.*/
                            put stream batchdata unformatted "DCEC-B" at 1 skip.

         /*W002                    put stream batchdata unformatted "-" at 1 skip.         */
        /*W002*/                 put stream batchdata unformatted "- " .
        /*W002*/            FIND pt_mstr WHERE pt_domain = global_domain and
        												 pt_part = strTmp NO-LOCK NO-ERROR .
        /*W002*/                    PUT STREAM batchdata UNFORMATTED pt_desc1 SKIP.
    /*W003*/            END. /*lookup(pt_group,"RAW,M") = 0*/
/*W003*/          END.

                  find first ptp_det where ptp_domain = global_domain and
                  				   ptp_part = strTmp and ptp_site = site-c no-lock no-error.
                  if avail ptp_det then do:
                    find pt_mstr where pt_domain = global_domain and
                    		 pt_part = strTmp no-lock no-error.
                    if lookup(pt_group,"RAW,M") = 0 and ptp_pm_code <> "P" then do:
                   		put stream batchdata unformatted "~"" at 1 strTmp "~"" skip.

/*W002               put stream batchdata unformatted "-" at 1 skip.*/
                    put stream batchdata unformatted "DCEC-B" at 1 skip.

/*W002                    put stream batchdata unformatted "-" at 1 skip.         */
/*W002*/                 put stream batchdata unformatted "- " .
/*W002*/            FIND pt_mstr WHERE pt_domain = global_domain and
												 pt_part = strTmp NO-LOCK NO-ERROR .
/*W002*/                    PUT STREAM batchdata UNFORMATTED pt_desc1 SKIP.

                    end.
                  end.
               end.
            end.
/*J001*/		end. /*do i_exec = 1 to 2 */
                if xxppif_err = 99 then xxppif_err = 0.
                substr(xxppif__chr01,6,1) = "1".

/*W001 begin*/
        /*process the cimload record one by one */
        /*move down */
        		end. /*end of for each xxppif_log */

        put stream batchdata unformatted  "." at 1.
        put stream batchdata unformatted "." at 1.
        put stream batchdata unformatted "~"Y~"" at 1.

        /*W001 begin*/
        /*process the cimload record one by one */

    /*  end.     end of for each xxppif_log */

        output stream batchdata  close.

        output to value(stroutputfile) .

        INPUT from value(strinputfile).

        PAUSE 0 BEFORE-HIDE.
        RUN MF.P.

        INPUT CLOSE.
        OUTPUT CLOSE.




