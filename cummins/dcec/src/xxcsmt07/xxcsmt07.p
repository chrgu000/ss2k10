/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120222.1          */
/* $Revision: eB2.1SP5 LAST MODIFIED: 02/23/12 BY: Apple Tam *SS - 20120233.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 03/26/12 BY: Apple Tam *SS - 20120326.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 03/26/12 BY: Jordan Lin *SS - 20120328.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 03/26/12 BY: Jordan Lin *SS - 20120329.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 03/26/12 BY: Jordan Lin *SS - 20120329.2* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/05/12 BY: Jordan Lin *SS - 201200405.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/09/12 BY: Jordan Lin *SS - 201200409.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/10/12 BY: Jordan Lin *SS - 201200410.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/10/12 BY: Jordan Lin *SS - 201200411.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/10/12 BY: Jordan Lin *SS - 201200412.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/13/12 BY: Apple Tam *SS - 20120413.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/20/12 BY: Jordan Lin *SS - 20120420.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/23/12 BY: Jordan Lin *SS - 20120423.1* */
/* $Revision: eB2.1SP5 LAST MODIFIED: 04/28/12 BY: Jordan Lin *SS - 20120428.1* */


/* DISPLAY TITLE */
{mfdtitle.i "120428.1"}


define variable entity like gl_entity.
define variable basecurr like gl_base_curr.
define variable ImportFile as char format "x(40)" label "Import File Name" .
define variable NeedImportRecord as INTEGER  format ">>>,>>9" label "Need Import Record(s)" .
define variable SuccessImportRecord as INTEGER  format ">>>,>>9" label "Success Import Record(s)" .
define variable SuccessFile as char format "x(40)" label "Success File" .
define variable FailureRecord as INTEGER  format ">>>,>>9" label "Failure Record(s)" .
define variable ConfirmImport as LOGICAL  initial no label "Confirm Import" .
define variable dir_I as char format "x(40)" .
define variable dir_IS as char format "x(40)" .

define variable yn2 as logical no-undo.
define variable ifnoenoughunall as logical init no.
define variable tmpstr as char.
define new shared variable per_yr    as   character   format "x(7)"
                                                      label "Period".
define variable mc-error-number like msg_nbr      no-undo.
define variable l-glcd-clsd       as logical      no-undo.
define variable gltcurr_rndmthd like rnd_rnd_mthd     no-undo.
define variable valid_acct     like mfc_logical.
define variable type_parm like gltr_tr_type.
define variable undo_flag   like mfc_logical                 no-undo.
define variable errstr as char.
define variable usection as char format "x(16)".
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
define variable errfilepath as char format "x(40)" label "Error File Path" init "/app/mfgpro/export/unprocess/".
def var t_file as char.
define variable okfilepath as char format "x(40)"  init "/app/mfgpro/export/unprocess/".
define variable fflname    as char format "x(40)" label "Source File Path" init "/app/mfgpro/export/unprocess/".
define variable xx_acct  as char .
/*SS - 20120428.1* */ define variable Exchange_acct  like sb_sub .
/*SS - 20120428.1* */ define variable tot_amt  like glt_curr_amt .

DEFINE   temp-table tmp  /* SS - 201200405.1*/no-undo
	 field tmp_domain    like glt_domain
	 field tmp_tr_type   like gltr_tr_type
	 field tmp_effdate   like glt_effdate
	 field tmp_ref       like glt_ref
	 field tmp_line      like glt_line
	 field tmp_entity    like glt_entity
	 field tmp_acct      like glt_acct
	 FIELD tmp_sub       like glt_sub
	 field tmp_cc        like glt_cc
	 field tmp_desc      like glt_desc
/*SS - 201200410.1* -B */
/*
	 field tmp_base_curr like glt_curr
	 field tmp_amt       like glt_curr_amt
	 field tmp_curr      like glt_curr
	 field tmp_curr_amt  like glt_curr_amt
*/
/*SS - 201200410.1* -E*/
/*SS - 201200410.1* -B */
	 field tmp_curr      like glt_curr
	 field tmp_curr_amt  like glt_curr_amt
	 field tmp_base_curr like glt_curr
	 field tmp_amt       like glt_curr_amt
/*SS - 201200410.1* -E*/
	 field tmp_doc       as char
	 field tmp_project   like glt_project
	 field tmp_flag as char format "100"
	 field tmp_flag2 as char format "100"
/*SS - 20120428.1* -B 兑换后金额*/
         field tmp_ex_amt like glt_curr_amt
	 INDEX  tmp_index is PRIMARY
          tmp_domain ASCENDING
	  tmp_ref ASCENDING
	  tmp_line ASCENDING.

DEFINE   temp-table tmp2 no-undo
	 field tmp2_domain    like glt_domain
	 field tmp2_tr_type   like gltr_tr_type
	 field tmp2_effdate   like glt_effdate
	 field tmp2_ref       like glt_ref
	 field tmp2_line      like glt_line
	 field tmp2_entity    like glt_entity
	 field tmp2_acct      like glt_acct
	 FIELD tmp2_sub       like glt_sub
	 field tmp2_cc        like glt_cc
	 field tmp2_desc      like glt_desc
	 field tmp2_curr      like glt_curr
	 field tmp2_curr_amt  like glt_curr_amt
	 field tmp2_base_curr like glt_curr
	 field tmp2_amt       like glt_curr_amt
	 field tmp2_doc       as char
	 field tmp2_project   like glt_project
	 field tmp2_flag as char format "100"
	 field tmp2_flag2 as char format "100"
         field tmp2_ex_amt like glt_curr_amt.


/*SS - 20120428.1* -E */

/* SELECT FORM */
form
   entity                 colon 30
   basecurr               colon 55 skip
   ImportFile             colon 30 skip(1)
   NeedImportRecord       colon 30 skip
   SuccessImportRecord    colon 30 skip
   SuccessFile            colon 30 skip
   FailureRecord          colon 30 skip
   ConfirmImport          colon 30 skip
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

view frame a.

find FIRST  gl_ctrl  where  gl_ctrl.gl_domain = global_domain no-lock no-error .
if available gl_ctrl then
assign
   basecurr = gl_base_curr
   entity = gl_entity .
   type_parm = "JL".

display entity BaseCurr with frame a .
{xxcsmt0702.i}

repeat with frame a:

   update entity ImportFile .

      bcdparm = "".
      {mfquoter.i entity                  }
      {mfquoter.i basecurr                }
      {mfquoter.i ImportFile              }
      {mfquoter.i NeedImportRecord        }
      {mfquoter.i SuccessImportRecord     }
      {mfquoter.i SuccessFile             }
      {mfquoter.i FailureRecord           }
      {mfquoter.i ConfirmImport           }


/*SS - 20120428.1* -B */
   find FIRST  code_mstr  where  code_mstr.code_domain = global_domain
                          and Code_fldname = "PLCSPROJECT"
		          and Code_value  = "Exchange_Losses"
   no-lock no-error.
   if available code_mstr then do :
            Exchange_acct =  code_cmmt.
   end .
   else do :
      message "Error : Exchange Losses account not exists!" .
      undo , retry.
   end.

/*SS - 20120428.1* -E*/

   find FIRST  code_mstr  where  code_mstr.code_domain = global_domain
                          and Code_fldname = "PLCSPROJECT"
		         /* and Code_value  = "Import_directory" */
		          and Code_value  = "Export_directory"
   no-lock no-error.
   if available code_mstr then do :
            dir_I =  code_cmmt.
   end .
   else do :
      message "Error : Export directory not exists!" .
      undo , retry.
   end.

   if ImportFile = ? or ImportFile = "" then do:
       message "Error File Name not null! ".
       undo , retry.
   end.
   else do:
       FILE-INFO:FILE-NAME = dir_I + ImportFile .
       if not (FILE-INFO:FILE-TYPE begins("F")) or FILE-INFO:FILE-TYPE = ? then do:
             message "Error Import File not exists!".
             undo , retry.
       end.
    end. /*if dir_I = ? or dir_I = "" then do: */

   find FIRST  code_mstr  where  code_mstr.code_domain = global_domain
                          and Code_fldname = "PLCSPROJECT"
		          and Code_value  = "Import_Success_directory"
   no-lock no-error.
   if available code_mstr then do :
            dir_IS =  code_cmmt.
/*SS - 201200413.1* -B */
	    errfilepath = code_cmmt.
	    okfilepath  = code_cmmt.
	    fflname     = code_cmmt.
/*SS - 201200413.1* -E */


   end .
   else do :
      message "Error : Import Success directory not exists!" .
      undo , retry.
   end.


/*读取文件内容,判断统计出 待导入数量、已导入数量、生成输出文件*/
/*********************************************************/
   NeedImportRecord   = 0.
   SuccessImportRecord = 0.
   SuccessFile        = "".
   FailureRecord     = 0.
   t_file = "".

    /* empty temp-table tmp. */
    for each tmp:
        delete tmp.
    end.
/*SS - 20120428.1* -B */
    for each tmp2:
        delete tmp2.
    end.
/*SS - 20120428.1* -E */
   INPUT FROM  value(dir_I + ImportFile).
      Repeat:
         create tmp.
         IMPORT DELIMITER "~t" tmp .
      End.   /* end of repeat  */
    INPUT CLOSE.

    for each tmp where tmp_ref = "":
        delete tmp.
    end.

  /*错误检测   ,错误信息存于字段tmp_flag   start  */
       for each tmp break by tmp_ref by tmp_line:
	   tmpstr="".
      	   yn2 = no.
     	   ifnoenoughunall = no.

	   /*总账参考号*/

           if substring(tmp_ref,1,2) <> "JL"
           then do:

              /* CAN ONLY ADD JL TRANSACTIONS */
              run p-disp-msg(input 3007, input 3).
              tmpstr = tmpstr + "Can only add JL transactions ".
           end. /* IF substring(ref,1,2) <> "JL" */


           /* *SS - 20120328.1* -B*/
           if can-find(FIRST gltr_hist where gltr_hist.gltr_domain = global_domain and gltr_ref = tmp_ref )
	   then  tmpstr = tmpstr + "Reference already in use by a posted transaction ".

           /* *SS - 20120328.1* -E*/


           /* *SS - 20120405.1* -B*/
           if can-find(FIRST glt_det where glt_det.glt_domain = global_domain and glt_ref = tmp_ref )
	   then  tmpstr = tmpstr + "Reference already in use by a posted transaction ".

           /* *SS - 20120405.1* -E*/



	   /* 生效日期 */
           run get-gl-period-year
	      (input tmp_effdate,
	       input 0,
	       output per_yr).

	   if per_yr = ""
	   then do:

	      /* INVALID PERIOD/YEAR */
	      run p-disp-msg(input 3008, input 3).
	      tmpstr = tmpstr + "Invalid period/year ".
	   end. /* IF per_yr = "" */

         /* 币别 */
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input tmp_base_curr,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:

            run p-disp-msg(input mc-error-number, input 3).
	      tmpstr = tmpstr + "Invalid currency code ".

         end. /* IF mc-error-number <> 0 */

/*
	 /* VALIDATE DAYBOOK */
         if substring(tmp_ref,1,2)="JL"))
         then do:

            run dbk_valid.
            tmpstr = tmpstr + "Invalid daybook ".

         end. /* IF (daybooks-in-use and .... */
*/
               /* CHECK FOR CLOSED PERIODS */
               run check-closed-period
                  (input  tmp_effdate,
                  input  tmp_entity,
                  output per_yr,
                  output l-glcd-clsd).

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input tmp_curr,
                 output gltcurr_rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               /*{pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               pause 0.
               next.
               tmpstr = tmpstr + "aa ".*/
            end. /* IF mc-error-number <> 0  */
/********
   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* MESSAGE DISPLAY FROM VALIDATION PROCEDURE */
   {gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}
**************/

      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input tmp_acc,
           input tmp_sub,
           input tmp_cc,
           input tmp_project,
           output valid_acct)"}

      if valid_acct = no
      then do:
          tmpstr = tmpstr + " ".
      end. /* IF valid_acct = no  */

      /* CHECK WHETHER ENTRIES ARE ALLOWED */
      for first ac_mstr
         fields( ac_domain ac_code ac_curr ac_desc ac_modl_only ac_type)
          where ac_mstr.ac_domain = global_domain and  ac_code = tmp_acc
         no-lock:
      end. /* FOR FIRST ac_mstr */

      if available ac_mstr
      and ac_modl_only
      then do:
         /* GL ENTRIES NOT ALLOWED TO THIS ACCT */
          tmpstr = tmpstr + "General Ledger entries not allowed to this account ".
      end. /* IF AVAILABLE ac_mstr */
/*SS - 201200409.1*  -B
 *增加会计科目和成本中心的判断 */
      if not available ac_mstr then do:
          tmpstr = tmpstr + "  Invalid account ".
      end.

      if not can-find( first cc_mstr where
         cc_mstr.cc_domain = global_domain and  cc_ctr = tmp_cc )
      then do:
          tmpstr = tmpstr + "  Invalid Cost Center ".
      end.

/*SS - 201200409.1*  -E*/

         /* VALIDATE ENTITY */
         for first en_mstr
            fields( en_domain en_curr en_entity)
             where en_mstr.en_domain = global_domain and  en_entity = entity
            no-lock:
         end. /* FOR FIRST en_mstr */

         if not available en_mstr
         then do:
            /* INVALID ENTITY */
            tmpstr = tmpstr + "Invalid entity ".
         end. /* IF NOT AVAILABLE en_mstr */


         /* CHECK FOR CLOSED PERIODS */
         {glper.i tmp_effdate per_yr entity}
/* *SS - 20120329.2* */         if available glcd_det then do:
	 if glcd_yr_clsd = yes
         then do:
            /* YEAR HAS BEEN CLOSED */
            tmpstr = tmpstr + "Year has been closed ".
         end. /* IF glcd_yr_clsd = yes */

         if glcd_gl_clsd = yes
         then do:
            /* PERIOD HAS BEEN CLOSED */
            tmpstr = tmpstr + "Period has been closed ".
         end. /* IF glcd_gl_clsd = yes */
/* *SS - 20120329.2* -B*/  end.
         else do:
	    tmpstr = tmpstr + "Invalid period/year ".
	 end.  /*if available glcd_det then do:*/

/* *SS - 20120329.2* -E*/

            /* VALIDATE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
               "(input tmp_curr,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               tmpstr = tmpstr + "VALIDATE CURRENCY ".
            end. /* IF mc-error-number <> 0 */

/*SS - 201200410.1* -B *
 * 检查兑换率          */
           if tmp_curr <> basecurr then do:
/*SS - 201200411.1* 	       if  can-find(FIRST exr_rate where exr_rate.exr_domain = global_domain */
/*SS - 201200411.1* */	       if not can-find(FIRST exr_rate where exr_rate.exr_domain = global_domain
					   and exr_curr1 = basecurr
					   and exr_curr2 = tmp_curr
/*SS - 20120423.1* */			   and exr_start_date <= tmp_effdate
/*SS - 20120423.1* */			   and exr_end_date >= tmp_effdate)
	        then do:
                   tmpstr = tmpstr + basecurr + "/" + tmp_curr + " Exchange rate does not exist  ".
                end.

	   end.
/*SS - 201200410.1* -E*/


/****
            if base_curr <> ctrl_curr
            and glt_curr <> base_curr
            and glt_curr <> ctrl_curr
            then do:
               /* CURRENCY MUST BE (BASE) OR (CONTROL CURRENCY) */
               {pxmsg.i &MSGNUM=3100 &ERRORLEVEL=3
                        &MSGARG1=base_curr
                        &MSGARG2=ctrl_curr}
               tmpstr = tmpstr + "CURRENCY MUST BE (BASE) OR (CONTROL CURRENCY) ".
            end. /* IF base_curr <> ctrl_curr */
***/

/*SS - 20120428.1* -B  *
* 判断兑换差异,并圆整. */

	     if trim(tmpstr) = "" then do:
		if basecurr = trim(tmp_curr) then do:
                   IF trim(tmp_curr) <> trim(tmp_base_curr) then do:
			   tmp_ex_amt = tmp_curr_amt  .
			end.
			else do:
			   tmp_ex_amt =  tmp_amt .
		    end.
                  end.
                else do: /*if basecurr = trim(tmp_curr) then do:*/
                    find FIRST exr_rate where exr_rate.exr_domain = global_domain
			and exr_curr1 = basecurr
			and exr_curr2 = tmp_curr
			and exr_start_date <= tmp_effdate
			and exr_end_date >= tmp_effdate no-lock.
                   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
		    IF trim(tmp_curr) <> trim(tmp_base_curr) then do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input tmp_curr,
                       input basecurr,
                       input exr_rate2,
                       input exr_rate,
                       input tmp_curr_amt,
                       input true,   /* ROUND */
                       output tmp_ex_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                    find FIRST msg_mstr where msg_nbr = mc-error-number
		                        and msg_lang = "us" no-lock no-error.
		     tmpstr = tmpstr + msg_desc + "  ".
                  end. /* IF mc-error-number <> 0 */
			end.
			else do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input tmp_curr,
                       input basecurr,
                       input exr_rate2,
                       input exr_rate,
                       input tmp_amt,
                       input true,   /* ROUND */
                       output tmp_ex_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                    find FIRST msg_mstr where msg_nbr = mc-error-number
		                        and msg_lang = "us" no-lock no-error.
		     tmpstr = tmpstr + msg_desc + "  ".
		  end. /* IF mc-error-number <> 0 */
		    end.

		end. /*if basecurr = trim(tmp_curr) then do:*/
             end. /*if trim(tmpstr) = "" then do:*/

  	     ACCUMULATE tmp_ex_amt (SUB-TOTAL by tmp_ref) .
             ACCUMULATE tmp_line (SUB-MAXIMUM by tmp_ref) .
              if last-of(tmp_ref) then do:
	           tot_amt = (accum sub-total by tmp_ref  tmp_ex_amt).
                   if tot_amt <> 0 and ABSOLUTE (tot_amt) < 1 then do:
            CREATE  tmp2.
		                tmp2_domain = tmp_domain.
		                tmp2_tr_type =tmp_tr_type.
			              tmp2_effdate = tmp_effdate.
                    tmp2_ref  = tmp_ref .
                    tmp2_line  = (accum SUB-MAXIMUM by tmp_ref  tmp_line) + 1 .
                    tmp2_entity = tmp_entity .
                    tmp2_acct  = Exchange_acct.
                    tmp2_sub = "" .
                    tmp2_cc  = "" .
                    tmp2_desc = Exchange_acct.
                    tmp2_curr = basecurr .
                    tmp2_curr_amt  = - tot_amt.
                    tmp2_base_curr = basecurr.
                    tmp2_amt = - tot_amt.
                    tmp2_doc = tmp_doc.
                    tmp2_project = tmp_project.
                    tmp2_flag = tmp_flag.
                    tmp2_flag2 = tmp_flag2.
                    tmp2_ex_amt = - tot_amt.
		   end.
		end. /*if last-of(tmp_ref) then do:*/

/*SS - 20120428.1* -E */


             tmp_flag = tmpstr.
	     NeedImportRecord    = NeedImportRecord    + 1.
	     if trim(tmpstr) = "" then do:
	        SuccessImportRecord = SuccessImportRecord + 1.
	     end.
	     else do:
		  FailureRecord = FailureRecord + 1.
	     end.
	     display NeedImportRecord SuccessImportRecord FailureRecord with frame a.


	end. /*for each tmp*/

/*SS - 20120428.1* -B */
        FOR EACH tmp2:
            CREATE  tmp.
		         tmp_domain = tmp2_domain.
		         tmp_tr_type =tmp2_tr_type.
			       tmp_effdate = tmp2_effdate.
             tmp_ref  = tmp2_ref .
             tmp_line  = tmp2_line .
             tmp_entity = tmp2_entity .
             tmp_acct  = tmp2_acct.
             tmp_sub = tmp2_sub .
             tmp_cc  = tmp2_sub .
             tmp_desc = tmp2_desc .
             tmp_curr = tmp2_curr .
             tmp_curr_amt  = tmp2_curr_amt.
             tmp_base_curr = tmp2_base_curr.
             tmp_amt = tmp2_amt.
             tmp_doc = tmp2_doc.
             tmp_project = tmp2_project.
             tmp_flag = tmp2_flag.
             tmp_flag2 = tmp2_flag2.
             tmp_ex_amt = tmp2_ex_amt.
	END.


/*SS - 20120428.1* -E */
		  /*输出有误的记录,有误文件名在原来的文件基础上加_err       start  */
	         t_file = string(today,"99999999") + string(time,"999999").
		 output to value( errfilepath + t_file + ".err").

		 EXPORT DELIMITER "|"
		 "Domain"
		 "Trans Type"
		 "Effective Date"
		 "GL Ref No"
		 "GL Line"
		 "Entity"
		 "Account"
		 "Sub Account"
		 "Cost Center"
		 "Description"
		 "Currency"
		 "Currency Amt"
		 "Base Currency"
		 "Base Currency Amt"
		 "Output DOC"
		 "Message"
		 .


	       for each tmp where  tmp_flag <> "" :
	            EXPORT DELIMITER "|" tmp .

	       end.

		  export "}end}".
		  output close.
		  /*输出有误的记录,有误文件名在原来的文件基础上加_err       end  */
	       SuccessFile = t_file + ".err".

               display SuccessFile with frame a.

/*=================================================================================*/
               update ConfirmImport .

  /*如果传输导入完成则做如下内容 start */
          if ConfirmImport = yes then do:
             message "CIMLOADDING...".
	     yn2 = no.
             ifnoenoughunall = no.

/* SS - 201200405.1* -B */

           loop:
           do TRANSACTION on error undo,LEAVE :
/* SS - 201200405.1* -E */

/* *SS - 20120329.2* 	     for each tmp : */
             for each tmp where trim(tmp_flag) = "" :

			errstr="" .
			usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "gltrmt" + trim(tmp_ref) .
			output to value( trim(usection) + ".i") .

			put trim(tmp_ref) format "x(50)" skip.

/*SS - 201200409.1* 	put trim(string(tmp_effdate)) + " " + trim(tmp_base_curr) format "x(100)" skip. */
/*SS - 201200409.1*  */	put trim(string(tmp_effdate)) + " " + basecurr format "x(100)" skip.
			put trim(string(tmp_amt)) format "x(50)" skip.

			put trim(string(tmp_line)) format "x(50)" skip.
/* *SS - 20120329.1*	if trim(tmp_sub) = "" then tmp_sub = "-". */
			if trim(tmp_cc) = "" then tmp_cc =  "-".
			if trim(tmp_project) = "" then tmp_project = "-".
/* *SS - 20120329.1*	put trim(tmp_acct) + " " + trim(tmp_sub) + " " + trim(tmp_cc) + " " + trim(tmp_project) format "x(180)" skip. */
/* *SS - 20120329.1* */	put trim(tmp_acct) + " " + trim(tmp_cc) + " " + trim(tmp_project) format "x(180)" skip.
			put trim(tmp_entity) format "x(50)" skip.
/*SS - 201200409.1*  	put trim(tmp_desc) format "x(50)"   skip.  */
/*SS - 201200420.1* -B*/
/*
/*SS - 201200409.1* */	put "\"" + trim(tmp_desc) + "\"" format  "x(50)"  skip.
*/
/*SS - 201200420.1* -E*/
/*SS - 201200420.1* -B*/


/*SS - 201200409.1* */	put '"' + trim(tmp_desc) + '"' format  "x(50)"  skip.

/*SS - 201200420.1* -E*/


			put trim(tmp_curr) format "x(50)" skip.
/*SS - 201200412.1*     put tmp_curr_amt  skip. */
/*SS - 201200412.1* -B */
                        IF trim(tmp_curr) <> trim(tmp_base_curr) then do:
			   put tmp_curr_amt  skip.
			end.
			else do:
			   put tmp_amt  skip.
			end.
/*SS - 201200412.1* -E */
/*SS - 201200409.1* -B */
/*
			if trim(tmp_base_curr) <> trim(tmp_curr) then do:
			   put "-" skip.
			end.
*/
/*SS - 201200409.1* -E */
/*SS - 201200409.1* -B */
			if basecurr <> trim(tmp_curr) then do:
			   put "- -" skip.
			end.
/*SS - 201200409.1* -E */
	                /*if  ifnoenoughunall then
		        put "y" skip.*/
			put "Y" skip.
			put "." skip.
			put "." skip.

			output close.
			input from value ( usection + ".i") .
			output to  value ( usection + ".o") .
                    	batchrun = yes.
				{gprun.i ""gltrmt""}
                 	batchrun = no.
			input close.
			output close.

			ciminputfile = usection + ".i".
			cimoutputfile = usection + ".o".
			{xxcsmt0701.i}

			unix silent value ( "rm -f "  + Trim(usection) + ".i").
			unix silent value ( "rm -f "  + Trim(usection) + ".o").

		       if errstr <> "" then
		       assign  tmp_flag2 = errstr.


	        end. /*for each tmp*/
/* *SS - 20120329.2*               end.  /* if ConfirmImport = yes then do: */ */




	     /*如果传输导入未完成则输出错误文件 start */
/*SS - 20120423.1* -B*/
/*
		  /*CIM-LOAD完后检测glt_det,如果不存在，则CIM-LOAD不成功，输出到错误文件   start  */
		  for each tmp :
                  find first glt_det where glt_domain = global_domain
		                     and glt_ref = tmp_ref
		                     and glt_line = tmp_line
/*SS - 201200420.1* */		                     no-lock no-error.
/*SS - 201200420.1*             no-error.	*/

			 if not avail glt_det then do:
/* *SS - 20120329.2* 	     assign tmp_flag2 = "CIM-LOAD Error,PLS CHECK". */
/* *SS - 20120329.2* */      assign tmp_flag2 = tmp_flag2 + "  CIM-LOAD Error,PLS CHECK".
			 end.

/*SS - 201200420.1* -B*/
			 else do:
                              glt_desc = REPLACE(glt_desc,'#','"') .
			 end.
		  end.
/*SS - 201200420.1*  -E */
*/
/*SS - 20120423.1* -E */
/* SS - 201200405.1* -B */


	      if can-find(FIRST tmp where trim(tmp_flag2) <> "") then do:
	         undo loop ,LEAVE .
                 message "undo loop ,..".

	      end.
           end. /* loop: */

/* SS - 201200405.1* -E */



/* *SS - 20120329.2* */              end.  /* if ConfirmImport = yes then do: */



		  /*CIM-LOAD完后检测glt_det,如果不存在，则CIM-LOAD不成功，输出到错误文件    end  */

		  /*输出有误的记录,有误文件名在原来的文件基础上加_err       start  */


		 output to value( errfilepath + t_file + ".err").

		 EXPORT DELIMITER "|"
		 "Domain"
		 "Trans Type"
		 "Effective Date"
		 "GL Ref No"
		 "GL Line"
		 "Entity"
		 "Account"
		 "Sub Account"
		 "Cost Center"
		 "Description"
		 "Currency"
		 "Currency Amt"
		 "Base Currency"
		 "Base Currency Amt"
		 "Output DOC"
		 "Message"
		 .


/* *SS - 20120329.2* 	       for each tmp where  tmp_flag2 <> "" : */
/* *SS - 20120329.2* */	       for each tmp where  tmp_flag2 <> "" or tmp_flag <> ""  :

	            EXPORT DELIMITER "|" tmp .

	       end.

		  export "}end}".
		  output close.
		  /*输出有误的记录,有误文件名在原来的文件基础上加_err       end  */


		  /*output to the ok file with the cimload success record begin*/
                 /*output to value( okfilepath).*/
                  output to value( okfilepath + t_file + ".ok").


		 EXPORT DELIMITER "|"
		 "Domain"
		 "Trans Type"
		 "Effective Date"
		 "GL Ref No"
		 "GL Line"
		 "Entity"
		 "Account"
		 "Sub Account"
		 "Cost Center"
		 "Description"
		 "Currency"
		 "Currency Amt"
		 "Base Currency"
		 "Base Currency Amt"
		 "Output DOC"
		 "Message"
		 .



/* SS - 201200405.1* 	  for each tmp where  tmp_flag2 = "" :   */
/* SS - 201200405.1* */	  for each tmp where  tmp_flag2 = "" and tmp_flag = "":

				EXPORT DELIMITER "|" tmp .

			  end.

		  export "}end}".
		  output close.
		  /*output to the ok file with the cimload success record end*/
/*

		  /* 导入完的文件移到完成目录  start */
                  /* unix silent value ( "mv " + fflname + " "  + okfilepath). */
                    unix silent value ( "mv " + fflname + " "  + sourcepath).
		 /* 导入完的文件移到完成目录  end */
*/

/*
		else do:
                    output to value( errfilepath + t_file + ".err").
		    put "Error:The file doesn't ftp compeleted ,Pls check the original file " +  fflname  format "x(200)" skip.

		  output close.
		end.
	    /*如果传输导入未完成则输出错误文件 end */
*/
/*	        message "Finished.".*/

	/*如果传输导入完成则做如下内容 end */

/*********************************************************/


/*将数据导入数据库,生成输出文件*/

   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

 /*  {mfphead.i}*/

		 EXPORT DELIMITER "|"
		 "Domain"
		 "Trans Type"
		 "Effective Date"
		 "GL Ref No"
		 "GL Line"
		 "Entity"
		 "Account"
		 "Sub Account"
		 "Cost Center"
		 "Description"
		 "Currency"
		 "Currency Amt"
		 "Base Currency"
		 "Base Currency Amt"
		 "Output DOC"
		 "Message"
		 .
	     for each tmp:
		EXPORT DELIMITER "|" tmp .
	     end.



  {mfreset.i}


end. /* repeat with frame a: */

PROCEDURE p-disp-msg:
   define input parameter msg_number  like msg_nbr no-undo.
   define input parameter error_level as   integer no-undo.

 /*  {pxmsg.i &MSGNUM=msg_number &ERRORLEVEL=error_level}*/
END PROCEDURE. /* p-disp-msg */

PROCEDURE get-gl-period-year:
/*-----------------------------------------------------------
Purpose:      Get the GL Period and Year based on a date
Parameters:   p-date  Input Date p-peryr Period-Year
Notes:        Created with L18P to avoid action segment error
-------------------------------------------------------------*/
   define input  parameter p-date  as date    no-undo.
   define input  parameter p-iter  as integer no-undo.
   define output parameter p-peryr as character format "x(7)" no-undo.

   {glper1.i p-date p-peryr}

   if type_parm = "YA"
   then do:

      if p-iter = 1
      then do:

         p-peryr = string(year(today) - 1).

         for last glc_cal
            fields( glc_domain glc_year glc_end)
             where glc_cal.glc_domain = global_domain and  glc_year =
             integer(per_yr)
            no-lock:
         end. /* FOR LAST glc_cal */
/*
         tmp_effdate = if available glc_cal
                  then
                     glc_end
                  else
                     ?.*/
      end. /* IF p-iter = 1 */

      if p-iter = 2
      then
         p-peryr = string((if available glc_cal
                           then
                              glc_year
                           else
                              0)).
   end. /* IF type_parm = "YA" */

END PROCEDURE. /* get-gl-period-year */

/*
PROCEDURE dbk_valid:

   /* VALIDATE DAYBOOK */
   undo_flag = yes.
   if not can-find(dy_mstr  where dy_mstr.dy_domain = global_domain and
   dy_dy_code = dft-daybook)
   then do:

      /* ERROR: INVALID DAYBOOK */
      run p-disp-msg(input 1299, input 3).
      return.
   end. /* IF NOT CAN-FIND(dy_mstr WHERE dy_dy_code = dft-daybook) */
   else do:

      {gprun.i ""gldyver.p"" "(input tr_type,
                               input l_doc_type,
                               input dft-daybook,
                               input entity,
                               output daybook-error)"}
      if daybook-error
      then do:

         /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
         run p-disp-msg(input 1674, input 2).

         if not batchrun
         then
            pause.

         if keyfunction(lastkey) = "END-ERROR"
         then
            return.
      end. /* IF daybook-error */

      {gprunp.i "nrm" "p" "nr_can_dispense"
         "(input dft-daybook,
           input eff_dt)"}

      {gprunp.i "nrm" "p" "nr_check_error"
         "(output daybook-error,
           output return_int)"}

      if daybook-error
      then do:

         run p-disp-msg(input return_int, input 3).
         return.
      end. /* IF daybook-error */
   end. /* ELSE DO */
   undo_flag = no.
END PROCEDURE. /* dbk_valid */
*/

PROCEDURE check-closed-period:
/*-----------------------------------------------------------
Purpose:      Check to see if the GL Calendar is closed
Parameters:   p-date   Input Date
              p-entity Entity
              p-peryr  Period-Year
              p-error  Calendar Error Occurred
Notes:        Created with L18P to avoid action segment error
-------------------------------------------------------------*/
   define input  parameter p-date   as   date                    no-undo.
   define input  parameter p-entity like glt_det.glt_entity      no-undo.
   define output parameter p-peryr  as   character format "x(7)" no-undo.
   define output parameter p-error  as   logical                 no-undo.

   p-error = no.

   {glper.i p-date p-peryr p-entity}
/* *SS - 20120405.1* */         if available glcd_det then do:
   if glcd_yr_clsd = yes
   then do:
      /* YEAR HAS BEEN CLOSED */
    /*  {pxmsg.i &MSGNUM=3022 &ERRORLEVEL=3}*/
	      tmpstr = tmpstr + "Year has been closed ".
      p-error = yes.
   end. /* IF glcd_yr_clsd = yes */

   if glcd_gl_clsd = yes
   then do:

      /* PERIOD HAS BEEN CLOSED */
     /* {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}*/
	      tmpstr = tmpstr + "Period has been closed ".
      p-error = yes.
   end. /* IF glcd_gl_clsd = yes */
/* *SS - 20120405.1* -B*/  end.
         else do:
	    tmpstr = tmpstr + "Invalid period/year ".
	 end.  /*if available glcd_det then do:*/

/* *SS - 20120405.1* -E*/
END PROCEDURE. /* check-closed-period */
