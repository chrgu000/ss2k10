/* zzGTSOL.P - UPLOAD INVOICE DATA GENERATE BY GOLD-TAX INTO MFG/PRO       */
/*                                                                         */
/*	LAST MODIFIED 	DAT:2004-09-01 20:04	BY: *LB01* LONG BO 			   */
/*	LAST MODIFIED 	DAT:2005-01-07 09:52	BY: *LB02* LONG BO 			   */

define new shared stream rpt .

define  new shared var v_bkbox  as char format "x(50)".
define  new shared var v_inbox  as char format "x(50)".
define new shared  var v_rpbox  as char format "x(50)".
define new shared  var v_ptbox  as char format "x(50)".  /*过账结果数据*/

define  new shared var v_bkfile as char format "x(50)".
define new shared  var v_infile as char format "x(50)".
define  new shared var v_infilex as char format "x(12)".
define  new shared var v_rpfile as char format "x(50)".
define  new shared var v_rpline as char format "x(100)".

define  new shared variable v_postfile          as character.

define  new shared var v_times  as integer.
define new shared  var v_load   as logical .
define  new shared var v_adj    as logical .
define  new shared var v_post   as logical .

define  new shared var type     as char.
define  new shared var nbr      like so_nbr.
define  new shared var v_dt       as date.
define  new shared var v_site   like so_site.
define  new shared var i        as char format "x(70)" extent 48.

DEFINE  new shared VAR savepos AS INT.
define new shared  var strdummy as char.

define  new shared var invsite  as char.
define new shared var v_totso  as integer.
define new shared  variable i3            as integer  no-undo.
define  new shared variable i2            as integer  no-undo.


define  new shared workfile giv
 field ginv              as char
 field ginvx             as char
 field gdate             like gltr_eff_dt
 field gshipdate         like gltr_eff_dt
 field gref              as char
 field gtotamt              like glt_amt
 field gtaxamt              like glt_amt
 field gnetamt              like glt_amt
 field gtaxpct           like usrw_decfld[1]
 field gcust             as   char format "x(8)"
 field gbill             as   char format "x(8)"
 field grmks             as char
 field gsite            as character
 field gnbr             as character
 field gmfgtotamt           like glt_amt
 field gmfgtaxamt           like glt_amt
 field gmfgnetamt           like glt_amt
 field gerrflag          as logical  initial no
 field gerrmsg           as character
 .

define new shared variable xsonbr like so_nbr.
define new shared workfile xinvd
	field x_ref	as char			/*lb02*/
	field xnbr	like so_nbr
	field xpart	like sod_part
	field xqty	like sod_qty_inv
 .

define  new shared temp-table wrk_var				/*lb01*/
    field wrk_sonbr  	like sod_nbr		/*lb01*/
    field wrk_line   	like sod_line		/*lb01*/
    field wrk_qty_inv  	like sod_qty_inv /*lb01*/
    field wrk_sched    	like sod_sched   /*lb01*/
    index wrk_sonbr wrk_sonbr.          /*lb01*/


{zzgtos01.i}
{zzgt002.i new}

{mfdtitle.i "a"}

/* DISPLAY SELECTION FORM */
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A


form
	RECT-FRAME       AT ROW 1 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
	skip(1)
    v_gtaxid   label "接口单位"          colon 20 space(2) v_adname no-label
    v_infile   label "上载数据文件"  colon 20
    v_bkfile   label "备份至"            colon 20
    v_rpfile   label "报告文件"          colon 20
	  v_ptbox	   label "过账结果"			 colon 20
    v_times    label "上载次数"          colon 20 skip(1)
    v_load     label "上载(Y)/预览(N)"   colon 20
    v_adj      label "调整差异"          colon 20
    v_post     label "过帐"              colon 20 skip
    v_drange   label "容差"              colon 20
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


v_infilex = "invoice.txt".

maninloop:
repeat:

  for each giv:
    delete giv.
  end.
  for each xinvd:
  	delete xinvd.
  end.

  find first usrw_wkfl where usrw_domain = global_domain
       and   usrw_key1 = "GOLDTAX-CTRL"
       and   lookup(global_userid,usrw_charfld[1]) <> 0
       no-lock no-error.
  if not available usrw_wkfl then do:
    message "错误:控制数据没有设定/没有操作权限,请联系系统管理员.".
    pause 3.
    leave.
  end.
  else do:
    {zzgt003.i}
    if v_box[1] = "" or
       v_box[2] = "" or
       v_box[3] = "" or
       v_box[4] = "" or
       v_box[5] = ""
    then do:
      message "错误:控制数据错误,请联系系统管理员.".
      pause 3.
      leave.
    end.
  end.


  v_dt = today.
  v_inbox = v_box[2].
  v_bkbox = v_box[3].
  v_rpbox = v_box[4].
  v_ptbox = v_box[5].

  if v_name_date[1] <> today then v_times = 1.
                              else v_times = v_name_seq[1] + 1.


  if opsys = "unix" then do:
    if substr(v_bkbox,length(v_bkbox),1) <> "/" then v_bkbox = substr(v_bkbox,1,length(v_bkbox)) + "/".
    if substr(v_inbox,length(v_inbox),1) <> "/" then v_inbox = substr(v_inbox,1,length(v_inbox)) + "/".
    if substr(v_rpbox,length(v_rpbox),1) <> "/" then v_rpbox = substr(v_rpbox,1,length(v_rpbox)) + "/".
    if substr(v_ptbox,length(v_ptbox),1) <> "/" then v_ptbox = substr(v_ptbox,1,length(v_ptbox)) + "/".
  end.

  /* check directories exist */
  assign l_out = v_inbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_inbox).
    pause 3.
    leave.
  end.
  assign l_out = v_bkbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_bkbox).
    pause 3.
    leave.
  end.

  assign l_out = v_rpbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_rpbox).
    pause 3.
    leave.
  end.

  assign l_out = v_ptbox + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "Warning: UNABLE TO WRITE TO:" + trim(v_ptbox).
    pause 3.
    leave.
  end.

  v_infilex = v_name_def[1].

  v_infile = substr(v_inbox,1,length(v_inbox))
             + v_infilex.

  v_bkfile = substr(v_bkbox,1,length(v_bkbox))
            + "in"
            + string(month(v_dt),"99")
            + string(day(v_dt),"99")
            + string(v_times,"99") + ".txt".

  v_rpfile = substr(v_rpbox,1,length(v_rpbox))
            + "in"
            + string(month(v_dt),"99")
            + string(day(v_dt),"99")
            + string(v_times,"99") + ".rpt".

  find first ad_mstr where ad_domain = global_domain and
  					 ad_addr = v_companyid no-lock no-error.
  if available ad_mstr then v_adname = ad_name.
                       else v_adname = "".

  display
         v_gtaxid v_adname v_infile v_bkfile v_rpfile v_times v_drange v_ptbox
  with frame a.

    assign v_adj = v_infixrd
    		v_post = v_inpost. /*2004-09-02 14:10*/
  update
        v_load
        v_adj
        v_post
  with frame a.

  if v_load = no then do:
    v_adj = no.
    v_post = no.
  end.
  else do: /*lb01*2004-09-02 09:18*/
  	if v_post and (not v_adj) then do:
  		message "准备过账，自动调节差异".
  		pause.
  	end.
  end.

  if search(v_infile) = ? then do:
      message "错误:传入文件不存在.".
      undo , retry.
  end.

  {mfselbpr.i "printer" 132}
    {mfphead.i}
  /*load data to workfile*/
  input from value(v_infile) no-echo.
  repeat:
    update i = "".
    savepos = SEEK(input).
    import delimiter "~~" i.
    if substring(i[17],1,3) = "DC@" then do:  /* this is the headline */

	  if i[1] <> "0" then         /*作废*/
	  	next.

      create giv.
      ginv = substr(i[9],1,length(i[9])).
      gdate = date(int(substr(i[13],5,2)),
                   int(substr(i[13],7,2)),
                   int(substr(i[13],1,4))).
      gref = substr(i[17],1,length(i[17])).	/*单据号*/
		/*
      gtotamt = decimal(i[19]).
      gtaxpct = decimal(i[21]).
      gtaxamt = round(gtotamt / ( 1 + gtaxpct) * gtaxpct ,2).
      gnetamt = gtotamt - gtaxamt.
		*/
      gnetamt = decimal(i[19]).
      gtaxpct = decimal(i[21]).
      gtaxamt = decimal(i[23]).
      gtotamt = gnetamt + gtaxamt.
      grmks = substr(i[41],1,length(i[41])).
      ginvx = ginv.
      gnbr = substring(gref,4,8). /*2004-09-02 11:22*/
      seek input to savepos.
      import  unformatted strdummy.

      next.
    end.
    else if (available giv)
    and (substring(i[1],1,1) = "0")
    then do:  /*发票明细行*/
    	create xinvd.
    	xnbr = substring(gref,4,8).
    	x_ref = gref.	/*lb02*/
    	xpart = substr(i[5],1,length(i[5])).
    	xqty = decimal(i[9]).
		seek input to savepos.
		import  unformatted strdummy.
    end.
    else if (available giv) and
     (substring(i[1],1,1) = "0") then do:
        gerrflag = yes.
        gerrmsg = "存在折扣项，请手工处理".
		seek input to savepos.
		import  unformatted strdummy.
    end.
  end.
  input close.

 /*
  for each giv:
  	disp giv with stream-io width 250.
  end.
  for each xinvd:
  	disp xinvd with stream-io width 250.
  end.
*/

  /*load into mfg*/
/*  {zzgtsola.i} */
	do transaction: /*2004-09-02 11:07 */
		{gprun.i ""zzgtsoll.p""}
	end.

  {mfrtrail.i}

end. /*main repeat*/

