/* SS - 090903.1 By: Neil Gao */
/* SS - 091015.1 By: Neil Gao */
/* SS - 091029.1 By: Neil Gao */

{mfdtitle.i "091029.1"}

define var remoteipaddr  as char format "x(45)".
define var localipaddr   as char format "x(45)".
define var remoteDirName as char format "x(45)".
define var localDirName  as char format "x(45)".
define var getfilename   as char format "x(45)".
define var audit_trail   as char format "x(1)".
define var BackupDir     as char format "x(45)".
define var ftpFileName   as char format "x(45)".
DEFINE var rspnbr LIKE msg_nbr.
DEFINE var rspmsg AS CHARACTER.
define var ifpass        as logical.
define var mypass        as logical.
define var ponbr  like po_nbr.
define var ponbr1 like po_nbr.
define var vend  like po_vend.
define var vend1 like po_vend.
define var buyer like po_buyer.
define var buyer1 like po_buyer.
define var xxi as int.
define var scmmsg as char format "x(45)".
define var scmtype as char format "x(45)".
define var stime   as char format "x(45)".
define var exename as char.
define TEMP-TABLE ttf
   FIELD ttf_c1 AS CHARACTER.
   .
define buffer usrwwkfl for usrw_wkfl.

/*
{xxcimcode.i ""CIM_FTP_Open"" remoteipaddr ""192.168.1.100""}
{xxcimcode.i ""CIM_FTP_Get_IP_Address"" localipaddr ""192.168.1.244""}
/*             ""CIM_FTP_User""*/
/*             ""CIM_FTP_Password""*/
{xxcimcode.i ""CIM_FTP_Get_Directory"" remoteDirName """"}
{xxcimcode.i ""CIM_Import_Directory"" localDirName ""/home/mfg""}
/*CIM_Log_Directory*/  /* ��־Ŀ¼ */
/*CIM_File_Prefix */   /* ��ʱ�ļ�ǰ׺*/
/*CIM_Delete_Options*/ /*Դ�ļ�ɾ��ѡ��*/
/*CIM_Allow_Errors */  /*�������ѡ��*/
/*CIM_Delimiter */    /*�ָ���ѡ��*/
/*CIM_Remote_Options*/ /* Զ��ѡ�� */
/*CIM_FTP_Put_Directory*/ /*Զ����־Ŀ¼*/
{xxcimcode.i ""CIM_Audit_Trail"" audit_trail ""Y""}
{xxcimcode.i ""CIM_Backup_Directory"" BackupDir ""/root/temp""}
*/
getfilename = "scmftplist".

form
	"      ��������:" colon 10 scmtype no-label
	"��Ҫ�����ļ���:" colon 10 xxi no-label
	"���ڴ����ļ���:" colon 10 ftpFileName no-label
	"  ������ʾ��Ϣ:" colon 10 scmmsg no-label
	"          ʱ��:" colon 10 stime no-label
with frame a side-label width 80 attr-space.

setFrameLabels(frame a:handle).

view frame a.

mainloop:
repeat:
    /* ���localftp�ļ�list */
	  {gprun.i ""xxscftpGetFileList.p"" "(
	  		input getfilename,
	  		output ftpFileName
	  )"}
	  
	  {gprun.i ""xxscftpGetFTPfl.p""
	  "(input getfilename,
	   input-output table ttf)"
	  }
	  
	  xxi = 0.
	  scmmsg = "".
	  ftpfilename = "".
	  scmtype = "�����ļ�����".
	  for each ttf where ttf_c1 <> "" no-lock:
	  	xxi = xxi + 1.
	  end.
	  
	  stime = string(today) + " " + string(time,"hh:mm:ss").
	  disp scmtype xxi scmmsg ftpFileName stime with frame a.
	  
  	for each ttf where ttf_c1 <> "" :
  		ftpFileName = ttf_c1.
  		stime = string(today) + " " + string(time,"hh:mm:ss").
	    disp ftpfilename stime with frame a.
  		
  		scmmsg = "�����ļ�".
  		disp scmmsg stime with frame a.
  			/* �����ļ�*/
  		{gprun.i ""xxsccomgetresponse1.p"" "(
	  			input ftpFileName,
	  			output ifpass
	  	)"}
	  		
  		find first usrw_wkfl where usrw_key1 = "scmftphist" and usrw_datefld[4] = ?  no-error.
  		if avail usrw_wkfl then do:
  				
	  		if ifpass then do:	
	  			scmmsg = "�����ļ�".
  				stime = string(today) + " " + string(time,"hh:mm:ss").
  				disp scmmsg stime with frame a.

	  			{gprun.i ""xxsccomGetFeedback.p"" "(
	  				input ftpFileName,
	  				output rspnbr,
            output rspmsg
	  			)"}
	  			
            do transaction on error undo,leave:
               for each usrwwkfl where usrwwkfl.usrw_key1 = ftpFileName:
               	if r-index(usrwwkfl.usrw_key2,".") > 1 then do:
                  find first pod_det where pod_nbr = substring(usrwwkfl.usrw_key2,1,r-index(usrwwkfl.usrw_key2,".") - 1) 
                  	and string(pod_line) = substring(usrwwkfl.usrw_key2,r-index(usrwwkfl.usrw_key2,".") + 1) no-error.
                  if not avail pod_det then do:
                     scmmsg = "д��ͬ������ʧ��".
                     stime = string(today) + " " + string(time,"hh:mm:ss").
                     disp scmmsg stime with frame a.
                     undo,leave.
                  end.
                  if rspnbr = 0 and rspmsg = "success" then do:
                     if pod_user1 = "11" then pod_user1 = "21".
                     else if pod_user1 = "12" then pod_user1 = "22".
                     else pod_user1 = "20".
                     pod_user2 = "90".
                  END.
                  ELSE DO:
                     pod_user2 = "".
                  END.
                  delete usrwwkfl.
                end.
               end.	  		

/* SS 090922.1 - B */
/*
               usrw_wkfl.usrw_datefld[4] = today.
               usrw_wkfl.usrw_decfld[4]  = time.
*/
								delete usrw_wkfl.
/* SS 090922.1 - E */

               scmmsg =  "״̬���³ɹ�".
               stime = string(today) + " " + string(time,"hh:mm:ss").
               disp scmmsg stime with frame a.
            end. /* do transaction */ 
  			end.
  			else do:
	  	  	scmmsg = "�����ļ�ʧ��".
	  	  	stime = string(today) + " " + string(time,"hh:mm:ss").
	  	  	disp scmmsg stime with frame a.
	  		end.
	  	end. /* if avail usrw_wkfl*/
	  	else do:
		  		scmmsg = "�����ļ�".
  				stime = string(today) + " " + string(time,"hh:mm:ss").
  				disp scmmsg stime with frame a.
	  			{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																								input 'function',
	  		  	                                        output rspnbr,
	  		    	                                      output exename)"}
	  			
	  			scmmsg = "�����ļ�".
  				stime = string(today) + " " + string(time,"hh:mm:ss").
  				disp scmmsg stime with frame a.
	  		  /* ����scm��Ҫ����ļ�¼ */
/* SS 090923.1 - B lambert */
          if  exename = "xxscposra.p" then do:
          	/* ���������ܾ�ͬ����������������ʧ����ظ�fail */
            /* message "�յ������ܾ���ͬ���ļ�" ftpFileName. */
            {gprun.i ""xxscredxmlrecid.p"" "(input ftpFileName,
            																 output mypass)"}
          end.
          else if  exename = "xxscposrr.p" then do:
          	/* ����ظ��ܾ�ͬ����������������ʧ����ظ�fail */
            /* message "�յ��ظ��ܾ���ͬ���ļ�" ftpFileName. */
            {gprun.i ""xxscredxmlrecid.p"" "(input ftpFileName,
            																 output mypass)"}
          end.
/* SS 090923.1 - E lambert */
/* SS 091015.1 - B */
					else if exename = "xxscposh.p" then do:
						/* ά��PO���˵� */
						{gprun.i ""xxscredshxmlrecid.p"" "(input ftpFileName,
            																 output mypass)"}
					end.
/* SS 091015.1 - E */
/* SS 091029.1 - B */
					else if exename = "xxscrspodl.p" then do:
						/* ɾ��PO���˵� */
						{gprun.i ""xxscredshdlxmlrecid.p"" "(input ftpFileName,
            																 output mypass)"}
					end.
/* SS 091029.1 - E */
          else if exename begins "xxscpo" then do:

		  			{gprun.i ""xxsccomGetFunctionValue.p"" "(input ftpFileName,
	  		                                         output rspnbr,
	  		                                         output rspmsg
	  		                                         )"}
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																								input 'poNbrB',
	  		    	                                      output rspnbr,
	  		      	                                    output ponbr)"}
	  				if ponbr <> "" then ponbr = substring(ponbr,2,length(ponbr) - 2).
	  					{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																								input 'poNbrE',
	  		    	                                      output rspnbr,
	  		      	                                    output ponbr1)"}
	  				if ponbr1 <> "" then ponbr1 = substring(ponbr1,2,length(ponbr1) - 2).
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'vendorIdB',
	  		                                          output rspnbr,
	  		                                          output vend)"}
	  				if vend <> "" then vend = substring(vend,2,length(vend) - 2).
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'vendorIdE',
	  		                                          output rspnbr,
	  		                                          output vend1)"}
	  				if vend1 <> "" then vend1 = substring(vend1,2,length(vend1) - 2).
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'buyerB',
	  		                                          output rspnbr,
	  		                                          output buyer)"}
	  				if buyer <> "" then buyer = substring(buyer,2,length(buyer) - 2).
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																								input 'buyerE',
	  		  	                                        output rspnbr,
	  		    	                                      output buyer1)"}
	  				if buyer1 <> "" then buyer1 = substring(buyer1,2,length(buyer1) - 2).
	  			
	  				{gprun.i ""xxsccomCreateFeedbackData_PO.p"" "(input ponbr,
		      				                         							input ponbr1,
		                               											input vend,
		              										                 	input vend1,
		                               											input buyer,
		                               											input buyer1,
		                               											input exename,
		                               											input-output ftpFileName)"}                                          
	 		 		end.
	 		 		else if exename begins "xxscvd" then do:
	 		 			{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'vendorIdB',
	  		                                          output rspnbr,
	  		                                          output vend)"}
	  				if vend <> "" then vend = substring(vend,2,length(vend) - 2).
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'vendorIdE',
	  		                                          output rspnbr,
	  		                                          output vend1)"}
	  				if vend1 <> "" then vend1 = substring(vend1,2,length(vend1) - 2).
	  				
	 		 			{gprun.i ""xxsccomCreateFeedbackData_VD.p"" "(input vend,
		      				                         							input vend1,
		                               											input-output ftpFileName)"}                         											
	 		 		end.
	 		 		else if exename begins "xxscpt" then do:
	 		 			{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'partB',
	  		                                          output rspnbr,
	  		                                          output vend)"}
	  				if vend <> "" then vend = substring(vend,2,length(vend) - 2).
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'partE',
	  		                                          output rspnbr,
	  		                                          output vend1)"}
	  				if vend1 <> "" then vend1 = substring(vend1,2,length(vend1) - 2).
	  				
	 		 			{gprun.i ""xxsccomCreateFeedbackData_PT.p"" "(input vend,
		      				                         							input vend1,
		                               											input-output ftpFileName)"}                         											
	 		 		end.
	 		 		else if exename begins "xxscco" then do:
	 		 			{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'partB',
	  		                                          output rspnbr,
	  		                                          output vend)"}
	  				if vend <> "" then vend = substring(vend,2,length(vend) - 2).
	  				{gprun.i ""xxsccomGetParameterValue.p"" "(input ftpFileName,
	  																							input 'partE',
	  		                                          output rspnbr,
	  		                                          output vend1)"}
	  				if vend1 <> "" then vend1 = substring(vend1,2,length(vend1) - 2).
	  				
	 		 			{gprun.i ""xxsccomCreateFeedbackData_CODE.p"" "(input vend,
		      				                         							input vend1,
		                               											input-output ftpFileName)"}                         											
	 		 		end.
	 		 		
	 		 		
	 		 		
	 		 		
	 		 			if ftpFileName <> "" then do:
	  					scmmsg = "д��ͬ������".
	  					stime = string(today) + " " + string(time,"hh:mm:ss").
	  					disp scmmsg stime with frame a.
	  					do transaction on error undo,leave:
/* SS 090909.1 - B */
/*
	  						for each usrw_wkfl where usrw_key1 = ftpFileName:
	  							find first po_mstr where po_nbr = usrw_key2 no-error.
	  							if not avail po_mstr then do:
	  								scmmsg = "д��ͬ������ʧ��".
	  								stime = string(today) + " " + string(time,"hh:mm:ss").
	  								disp scmmsg stime with frame a.
	  								undo,leave.
	  							end.
	  							po_user1 = "10".
	  							po_user2 = "".
	  						end.
*/
/* SS 090909.1 - E */
	  						{gprun.i ""xxpomt1xa2.p"" "(input ftpFileName,input '')"}.
	  					end. /* do transaction */
	  				end.
	  	end.
	  	
  	end. /* for each ttf */

   	/*ͬ���ļ�*/
   	scmtype = "�ϴ��ļ�����".
   	xxi = 0.
   	for each usrw_wkfl where usrw_key1 = "scmftphist" and usrw_datefld[3] = ? :
   		xxi = xxi + 1.
   	end.
   	stime = string(today) + " " + string(time,"hh:mm:ss").
   	disp xxi scmtype stime with frame a.
   	for each usrw_wkfl where usrw_key1 = "scmftphist" and usrw_datefld[3] = ? :
   		ftpFileName = usrw_key2.
   		scmmsg  = "�ϴ��ļ�".
   		stime = string(today) + " " + string(time,"hh:mm:ss").
   		disp ftpFileName scmmsg stime with frame a.
   		{gprun.i ""xxsccomftpput.p"" "(
	  			input usrw_key2,
	  			output ifpass
	  		)"}
   		if ifpass then do:

	  		do transaction on error undo,leave:
	  			for each usrwwkfl where usrwwkfl.usrw_key1 = ftpFileName:
	  				find first pod_det where pod_nbr = substring(usrwwkfl.usrw_key2,1,r-index(usrwwkfl.usrw_key2,".") - 1) 
             	and string(pod_line) = substring(usrwwkfl.usrw_key2,r-index(usrwwkfl.usrw_key2,".") + 1)  no-error.
	  				if not avail pod_det then do:
	  					scmmsg = "д��ͬ������ʧ��".
	  					stime = string(today) + " " + string(time,"hh:mm:ss").
	  					disp scmmsg stime with frame a.
	  					undo,leave.
	  				end.
	  				pod_user2 = "20".
	  			end.	  		
   				usrw_wkfl.usrw_datefld[3] = today.
   				usrw_wkfl.usrw_decfld[3]  = time.
   				scmmsg = "״̬���³ɹ�".
   				stime = string(today) + " " + string(time,"hh:mm:ss").
   				disp scmmsg stime with frame a.
   			end. /* do transaction */
   		end.
   		else do:
   			scmmsg = "�ϴ�ʧ��".
   			stime = string(today) + " " + string(time,"hh:mm:ss").
   			disp scmmsg stime with frame a.
   		end.
  	end.
    
    /*��ʱ����*/
    scmtype = "��ʱ�ļ�����".
    xxi = 0.
    for each usrw_wkfl where usrw_key1 = "scmftphist" and usrw_datefld[3] <> ? and usrw_datefld[4] = ? :
    	xxi = xxi + 1.
    end.
    stime = string(today) + " " + string(time,"hh:mm:ss").
    disp scmtype stime with frame a.
    for each usrw_wkfl where usrw_key1 = "scmftphist" and usrw_datefld[3] <> ? and usrw_datefld[4] = ? :
    	if ( today - usrw_datefld[3]) * 3600 * 24 + time - int(usrw_decfld[3]) < 30 then next. 
    	ftpFileName = usrw_key2.
   		stime = string(today) + " " + string(time,"hh:mm:ss").
   		disp ftpFileName stime with frame a.
   		{gprun.i ""xxsccomftpput.p"" "(
	  			input usrw_key2,
	  			output ifpass
	  		)"}
   		if ifpass then do:
   			do transaction on error undo,leave:
	  			for each usrwwkfl where usrwwkfl.usrw_key1 = ftpFileName:
	  				find first pod_det where pod_nbr = substring(usrwwkfl.usrw_key2,1,r-index(usrwwkfl.usrw_key2,".") - 1) 
            	and string(pod_line) = substring(usrwwkfl.usrw_key2,r-index(usrwwkfl.usrw_key2,".") + 1)  no-error.
	  				if not avail pod_det then do:
	  					scmmsg = "д��ͬ������ʧ��".
	  					stime = string(today) + " " + string(time,"hh:mm:ss").
	  					disp scmmsg stime with frame a.
	  					undo,leave.
	  				end.
	  				pod_user2 = "82".
	  				delete usrwwkfl.
	  			end.	  		
/* SS 090922.1 - B */
/*
   				usrw_wkfl.usrw_datefld[3] = today.
   				usrw_wkfl.usrw_decfld[3]  = time.
*/
					delete usrw_wkfl.
/* SS 090922.1 - E */
   				scmmsg =  "״̬���³ɹ�".
   				stime = string(today) + " " + string(time,"hh:mm:ss").
   				disp scmmsg stime with frame a.
   			end. /* do transaction */   			
   		end.
   		else do:
   			scmmsg = "����ʧ��".
   		end.
   		stime = string(today) + " " + string(time,"hh:mm:ss").
   		disp scmmsg stime with frame a.
  	end.
  	scmtype = "�ȴ�����".
  	xxi = 0.
  	scmmsg = "".
  	ftpFileName = "".
  	stime = string(today) + " " + string(time,"hh:mm:ss").
  	disp scmtype xxi ftpFileName stime scmmsg with frame a.
	  pause 3 no-message.
end.

procedure psleep:
	pause 3 no-message.
end.
