/* zzgtsod.p - dump soinvoice into a ascii file                           */
/*                                                                        */

/* VERSION 	LAST MODIFIED    2004-08-30 11:07    	*LB01*	LONG BO		  */


define stream   soivdat.

define new shared variable v_curr    like so_curr .

define new shared variable v_sonbr1  like so_nbr .
define new shared variable v_sonbr2  like so_nbr .
define new shared variable v_cust1   like so_cust .
define new shared variable v_cust2   like so_cust .
/*frk*/ define new shared variable v_cust3   like so_cust .
define new shared variable v_bill1   like so_bill .
define new shared variable v_bill2   like so_bill .
define new shared variable v_date1   like so_ship_date .
define new shared variable v_date2   like so_ship_date .

define new shared variable yn         as logical initial yes.


define new shared variable v_outfile    as character format "x(50)" label "数据文件名".
define new shared variable v_times      as   integer label "下载次数".
define new shared variable v_dt         as   date.
DEFINE new shared VARIABLE v_flag1      AS LOGICAL INITIAL NO.
define new shared variable i            as   integer.

define new shared variable iCount		as integer. /*LB01*/
define new shared variable sLnHeaderDesc as char.

define new shared variable strOutMstr as char format "x(600)".   /*lb01*/
define new shared variable strOutDet  as char format "x(400)".   /*lb01*/

define new shared variable sonbr	like so_nbr.

/*F348*/ define new shared variable next_inv_nbr like soc_inv.
/*G692*/ define new shared variable next_inv_pre like soc_inv_pre.
/*G047*/ define new shared variable comb_inv_nbr like so_inv_nbr.
define new shared variable so_recno as recid.
define new shared variable inv_date like ar_date.

         define variable adname like ad_name.


{zzgt002.i new}
{zzgtsodc.i "new"}
{zzgtos01.i}

find first gl_ctrl no-lock no-error.

/* DISPLAY TITLE */
{mfdtitle.i "zz "}
    
v_dt = today.

/* DISPLAY SELECTION FORM */
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A


form
	RECT-FRAME       AT ROW 1 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
	skip(1)
   v_gtaxid        colon 15  label "接口代码"  space(2) v_adname no-label skip
   v_times            colon 15  label "传出次数"   skip
   v_outfile          colon 15  label "数据文件名" skip(1)
   v_sonbr1           colon 15  label "订单"
   v_sonbr2           label {t001.i} colon 45 skip
   v_date1            colon 15	label "发货日期"
   v_date2            label {t001.i} colon 45 skip
   v_cust1            colon 15	label "销往"
   v_cust2            label {t001.i} colon 45 skip
   v_bill1            colon 15	label "票据开往"
   v_bill2            label {t001.i} colon 45 skip

	skip(1)

/*   v_flag1            LABEL "包括修正的已下载订单" colon 45 SKIP */
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


loopa:
repeat on error undo,retry:

  v_curr = "".
  
  find first gl_ctrl no-lock no-error.
  if available gl_ctrl then v_curr = gl_base_curr.
  if v_curr = "" then do:
    message "错误:本位币为空,请联系系统管理员.".
    pause 3.
    leave.
  end.
  

  find first usrw_wkfl 
       where usrw_key1 = "GOLDTAX-CTRL"
       and   lookup(global_userid,usrw_charfld[1]) <> 0
       no-lock no-error.
  if not available usrw_wkfl then do:
    message "错误:下载控制数据没有设定/没有操作权限,请联系系统管理员.".
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
      message "错误:下载控制数据错误,请联系系统管理员.".
      pause 3.
      leave.
    end.
  end.

   
  /** VAR INITIALIZATION **/
  if opsys = "unix" then do:
    if substr(v_box[1],length(v_box[1]),1) <> "/" then 
       v_box[1] = substr(v_box[1],1,length(v_box[1])) + "/".
  end.

  /* check directories exist */
  assign l_out = v_box[1] + "TMP" +
                 string(time,"99999") + "." + string(random(0,999),"999").
  {gprun.i ""zzgtosdexi.p"" "(l_out, output l_dir_ok)"}.
  if not l_dir_ok then do:
    message "警告: 不能输出到:" + trim(v_box[1]). 
    pause 3.
    leave.
  end.
        
  if v_name_date[2] <> today then v_times = 1.
                              else v_times = integer(v_name_seq[2]) + 1.

  v_outfile = substr(v_box[1],1,length(v_box[1])) 
           + "SO"
           + string(month(v_dt),"99")
           + string(day(v_dt),"99")
           + string(v_times,"9999") + ".txt".

  find first ad_mstr where ad_addr = v_companyid no-lock no-error.
  if available ad_mstr then v_adname = ad_name.
                       else v_adname = "".
  display v_gtaxid v_adname
          v_times
          v_outfile
  with frame a.

  if v_sonbr2 = hi_char then v_sonbr2 = "" .
  if v_date1 = low_date   then v_date1  = ? .
  if v_date2 = hi_date  then v_date2  = ? .
  if v_cust2 = hi_char  then v_cust2 = "" .
  if v_bill2 = hi_char then v_bill2 = "" .

  update
    v_sonbr1   v_sonbr2
    v_date1    v_date2
    v_cust1    v_cust2
    v_bill1    v_bill2
    
/*    v_flag1 */
  with frame a.


  if v_sonbr2 = "" then v_sonbr2 = hi_char .
  if v_date1 = ?   then v_date1  = low_date .
  if v_date2 = ?   then v_date2  = hi_date .
  if v_cust2 = ""  then v_cust2 = hi_char .
  if v_bill2 = "" then v_bill2 = hi_char .

  find first so_mstr
       where so_invoiced = no
       and so_to_inv = yes
       and so_curr = v_curr
       and lookup(so_site,v_sitestr) <> 0
       and (so_nbr >= v_sonbr1      and so_nbr <= v_sonbr2)
       and (so_ship_date >= v_date1 and so_ship_date <= v_date2)
       and (so_cust >= v_cust1      and so_cust <= v_cust2)
       and (so_bill >= v_bill1      and so_bill <= v_bill2)
       and (so_taxable = yes)
       no-lock no-error.
  if not available so_mstr then do:
    message "错误:所选范围没有待开发票数据!".
    undo, retry.
  end.
	
  bcdparm = "".
  {mfquoter.i v_sonbr1  }
  {mfquoter.i v_sonbr2  }
  {mfquoter.i v_date1   }
  {mfquoter.i v_date2   }
  {mfquoter.i v_cust1   }
  {mfquoter.i v_cust2   }
  {mfquoter.i v_bill1   }
  {mfquoter.i v_bill2   }
/* {mfquoter.i v_flag1   } */

  /* SELECT PRINTER  */
  {mfselbpr.i "printer" 132}
    {mfphead.i}         
  mainloop:
  do transaction on error undo, leave on endkey undo, leave:

/*lock*******************************/
    { gprun.i ""sorp10a.p"" }

/** UPDATE CONTROL FILE **/
    find first usrw_wkfl 
         where usrw_key1 = "GOLDTAX-CTRL"
         and   usrw_key2 = v_gtaxid
         exclusive-lock no-error.
    if available usrw_wkfl then do:
      overlay(usrw_charfld[7],31,6) = string(v_times,"999999").
      overlay(usrw_charfld[7],21,8) =   string(year(today),"9999") 
                                      + string(month(today),"99")
                                      + string(day(today),"99").
    end.

    for each wkgtm:
      delete wkgtm.
    end.
    for each wkgtd:
      delete wkgtd.
    end.
  
   {gprun.i ""yygtsoda.p""}   
  /*   {yygtsoda.i}  */
   
    output stream soivdat to value(v_outfile).
    {yygtsodb.i}        
    output stream soivdat close.
    
    for each wkgtm with frame bx width 180 stream-io down :
      display wkgtm_ref 
              wkgtm_bill
              wkgtm_name   format "x(28)"
              wkgtm_line
              wkgtm_totamt 
              wkgtm_msg
              .
    end. 
  end.  /*mainloop*/
  
  /* REPORT TRAILER */
  {mfrtrail.i} 
end.  /*repeat*/



