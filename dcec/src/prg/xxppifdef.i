/*2004-08-25 21:06 create by longbo*/

{mfdeclre.i "new"}

/*G1MN*/ {gpglefv.i}
		
		define variable filename as character.	/* file name , not include path*/
		define variable filepath as character.  /* file path , not include filename*/
		define variable sourcename as character. /* path + file name*/
		
		define variable trid_begin like xxppif_tr_id. /* EACH TIME THE TRANSACTION ID BEGIN WITH*/
		
		define variable trid like xxppif_tr_id.
		
		define variable writing_data like mfc_logical.
		
		define new shared variable ps_recno as recid.
		define variable iPos as integer.
         
		define stream batchdata.
		define stream batchdata1.
		define variable linedata as character.
		define variable end_file like mfc_logical.
		define variable strTmp as character.
		define variable siteerr as integer.
		define variable bld_date as date.
		define variable old_qty like rps_qty_req.
		define variable strbldday as character format "x(5)".
		define variable iDay as integer.
		define variable dWeek as decimal format "999.9999".
		define variable sQty as character format "x(5)".
		define variable effdate as date.
		define variable newBom as logic.
		define variable ptstatus1 like pt_status.
		define variable strTmp1 as character.
		
		define variable strinputfile as char.
		define variable stroutputfile as char.
		
		define variable SITE-B as character format "x(6)" initial "DCEC-B".	/* BOM PAR - USE PART + ZZ */
		define variable SITE-C as character format "x(6)" initial "DCEC-C".	/* BOM PAR - PART */
		define variable SCD_DAY as integer  initial 3.			/* SCHEDULE WILL SEND 3 DAYS ADVANCED*/
		define variable MAX_LT as integer initial 10.			/* MAX MFG LEAD DAY */
	
		define variable runuser as char.
		define variable	runpsw  as char.
		
		
		define variable localitem like pt_part. /*用于检测是否有本地item*/
		

		


		find first usrw_wkfl where usrw_key1 = "BKFLH-CTRL" no-lock no-error.
		if not available usrw_wkfl then do:
			runuser = "mrp".
			runpsw = "mrp".		
		end.
		else do: 
			runuser = usrw_key2.
			runpsw = usrw_charfld[1].		
		end.
		
		trid_begin = 0.
		find first usrw_wkfl no-lock where
		usrw_key1 = "XX-PPIF-LASTID" no-error.
		if available usrw_wkfl then do:
			trid_begin = usrw_decfld[1].
		end.


		find first code_mstr no-lock where code_fldname = "PPIF_SO" no-error.
		if available code_mstr then do:
			filepath = trim(code_cmmt).
		end.
		
		define temp-table ttlog   /*建立康明斯的信息*/
             fields  ttlog_tr_id    like xxppif_tr_id
             fields  ttlog_act_date like xxppif_act_date
             fields  ttlog_act_time like xxppif_act_time 
             fields  ttlog_file     like xxppif_file
             fields  ttlog_tr_code  like xxppif_tr_code
             fields  ttlog_content  like xxppif_content
             fields  ttlog__log01   like xxppif__log01
             fields  ttlog__log02   like xxppif__log02.

		
