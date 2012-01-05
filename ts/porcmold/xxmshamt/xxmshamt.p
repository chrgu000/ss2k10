
/* xxmshamt.p  mould cost share maintain		*/
/*by ken chen SS - 111113.1*/
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "111113.1"}
&GLOBAL-DEFINE KeyWord	 	"XXMSHAMT_"
&GLOBAL-DEFINE Key				USRW_KEY1
&GLOBAL-DEFINE Vend				usrw_wkfl.USRW_KEY2
&GLOBAL-DEFINE Part				usrw_wkfl.USRW_KEY3
&GLOBAL-DEFINE Expense			usrw_wkfl.USRW_DECFLD[1]
&GLOBAL-DEFINE Price			  usrw_wkfl.USRW_DECFLD[2]
&GLOBAL-DEFINE StartDate		usrw_wkfl.USRW_DATEFLD[1]
&GLOBAL-DEFINE ShareQty			usrw_wkfl.USRW_DECFLD[3]
&GLOBAL-DEFINE ShareExpense		usrw_wkfl.USRW_DECFLD[4]
&GLOBAL-DEFINE ShareStatus		usrw_wkfl.USRW_CHARFLD[1]
&GLOBAL-DEFINE BalanceStatus	usrw_wkfl.USRW_CHARFLD[2]

define variable vdname as char format "x(30)".
define variable ptdesc as char format "x(30)" .
define variable del-yn like mfc_logical initial no.
define variable addr like ad_addr.

/* DISPLAY SELECTION FORM */

form

 {&Vend}			  colon 25 label "供应商" vdname no-label	skip
 {&Part}			  colon 25 label "ERP号" format "x(18)"  ptdesc no-label	skip
 {&Expense}			colon 25 label "模具总费用" format "->>,>>>,>>>.9999"
 {&Price}			  label "分摊单价" format "->>,>>>,>>>.9999"		skip
 {&StartDate}		colon 25 label "开始收货日期"	skip
 {&ShareQty}		colon 25 label "已分摊数量"	 format "->>,>>>,>>>.9999"	skip
 {&ShareExpense}	colon 25 label "已分摊金额" format "->>,>>>,>>>.9999"		skip
 {&ShareStatus}		colon 25 label "分摊状态" format "x(1)"		skip
 {&BalanceStatus}	colon 25 label "结算状态" format "x(1)"
with frame a side-labels width 80 attr-space .
setFrameLabels(frame a:handle).

view frame a.
mainloop:
repeat:

   prompt-for {&Vend} with frame a editing:

	  /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i usrw_wkfl usrw_index1 " usrw_wkfl.usrw_domain = global_domain
      and {&KEY} = "{&KeyWord}"" {&Vend} "input {&Vend}" }
      if recno <> ? then do:
			find first ad_mstr where ad_domain = global_domain and ad_type = "Supplier" and ad_addr = {&Vend} no-lock no-error.
			if available ad_mstr then vdname = ad_name.
								 else vdname = "".
			find first pt_mstr where pt_domain = global_domain and pt_part = {&Part} no-lock no-error.
			if available pt_mstr then ptdesc = pt_desc1 + pt_desc2.
								 else ptdesc = "".

			display
			{&Vend}
			vdname
			{&Part}
			ptdesc
			{&Expense}
			{&Price}
			{&StartDate}
			{&ShareQty}
			{&ShareExpense}
			{&ShareStatus}
			{&BalanceStatus}
			with frame a
			.
	  end. /* if recno <> ? */
   end. /* prompt-for {&Vend} */

	/*add/modify/delete*/
   do on error undo, retry:
		   find first ad_mstr where ad_domain = global_domain and ad_type = "Supplier" and ad_addr = input {&Vend} no-lock no-error.
		   if not available ad_mstr then do:
				{pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
				undo,retry.
		   end.

		   if available ad_mstr then vdname = ad_name.
								else vdname = "".
		   find first pt_mstr where pt_domain = global_domain and pt_part = input {&Part} no-lock no-error.
		   if available pt_mstr then ptdesc = pt_desc1 + pt_desc2.
							 else ptdesc = "".
		   find first usrw_wkfl where usrw_wkfl.usrw_domain = global_domain
								   and {&Key} = {&KeyWord}
								   and {&Vend} = input {&Vend}
								   exclusive-lock no-error.
		   if not available usrw_wkfl then do:
			  {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
			  create usrw_wkfl.
			  assign usrw_wkfl.usrw_domain = global_domain
					 {&Key} = {&KeyWord}
					 {&vend} = input {&vend}
					 {&Part} = input {&part}
					 {&expense} = input {&expense}
					 {&price} = input {&price}
					 {&startdate} = input {&startdate}
					 {&shareqty} = input {&shareqty}
					 {&shareexpense} = input {&shareexpense}
					 {&sharestatus} = input {&sharestatus}
					 {&balancestatus} = input {&balancestatus}
					 .

		   end. /* if not available usrw_wkfl then do: */

		   if available usrw_wkfl then
		   	display
			{&Vend}
			vdname
			{&Part}
			ptdesc
			{&Expense}
			{&Price}
			{&StartDate}
			{&ShareQty}
			{&ShareExpense}
			{&ShareStatus}
			{&BalanceStatus}
			with frame a.
		   else do:

				display
		        {&Vend}
			    vdname
				with frame a.

		   end.

			set
				{&Part}
				{&Expense}
				{&Price}
				{&StartDate}
				{&ShareQty}
				{&ShareExpense}
				{&ShareStatus}
				{&BalanceStatus}
				   go-on(F5 CTRL-D)
			with frame a.

			   find first pt_mstr where pt_domain = global_domain and pt_part = input {&Part} no-lock no-error.
			   if not available pt_mstr then do:
					{pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
					undo,retry.
			   end.
			   if available pt_mstr then ptdesc = pt_desc1 + pt_desc2.
								 else ptdesc = "".

               if input {&ShareStatus} <> "C" or input {&ShareStatus} <> "O" then do:
					message "错误:状态必须为C或O".
					undo,retry.
			   end.
               if input {&BalanceStatus} <> "C" or input {&BalanceStatus} <> "O" then do:
					message "错误:状态必须为C或O".
					undo,retry.
			   end.

			   /* Delete to be executed if batchdelete is set or
				* F5 or CTRL-D pressed */
			   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")

			   then do:

				  del-yn = yes.

				  /* Please confirm delete */
				  {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

				  if del-yn then do:
					 delete usrw_wkfl.
					 clear frame a.
				  end. /* if del-yn then do: */

			   end. /* then do: */
   end. /*do on error undo,retry*/
end. /*main-loop*/

