/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/

{mfdtitle.i "dd"}
find first rqf_ctrl where rqf__log01 = yes no-lock no-error .
if not avail rqf_ctrl then do:
	message "CER模块未被启动.请到5.2.1.24里启动." view-as alert-box .
	leave .
end.
{xxcermtdefine.i "new"}
{xxcermtframe.i}

{wbrp01.i}
main-loop :
REPEAT :	
	view frame a .
	if execname begins "xxcermt2" then view frame a2 .
	if execname begins "xxcermt3" then view frame a3 .
	if execname begins "xxcermt4" then view frame a4 .
	new_order = no .
	prompt-for danju with frame a editing:
		/*上下箭移动*/
		{mfnp.i xxcer_mstr danju  "xxcer_nbr "  danju xxcer_nbr xxcer_nbr}
		if recno <> ? then do :
			assign danju = xxcer_nbr .
			display danju 
			with frame a .
			{xxcerdisp1.i}
		end.
		
	end.
	assign danju = input danju .
	
	/*物料测试表申请*/
	if execname begins "xxcermt1" then do:
		{xxcermt1.i}
	end.
	/*物料测试表检查标准维护*/
	if execname begins "xxcermt2" then do:
		{xxcermt2.i}
	end.
	/*物料检查表检查结果维护*/
	if execname begins "xxcermt3" then do:
		{xxcermt3.i}
	end.
	/*物料检查表最后判定维护*/
	if execname begins "xxcermt4" then do:
		{xxcermt4.i}
	end.
end.	/*main loop*/