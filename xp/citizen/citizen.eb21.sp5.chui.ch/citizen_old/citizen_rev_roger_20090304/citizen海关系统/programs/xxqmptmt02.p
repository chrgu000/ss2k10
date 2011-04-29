/* xxqmptmt02.p 海关零件维护                                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/22/2008   BY: Softspeed tommy xie         */


/* DISPLAY TITLE */
{mfdtitle.i "1.0 "}

define variable new_add like mfc_logical.
define variable del-yn like mfc_logical initial no.
define var v_conv like xxccpt_um_conv initial 0 .
define var v_part like pt_part .
define var v_recno like recno .


define buffer xxccptmstr for xxccpt_mstr .

form
    xxccpt_part    colon 24 label "零件编号"
    pt_desc1       colon 24 label "公司品名"
    pt_um          colon 24 label "公司单位"
    pt_net_wt      colon 24 label "净重" space(0) pt_net_wt_um no-label

    skip(1)
    xxccpt_ln      colon 24 label "商品序号"
    xxcpt_cu_part  colon 24 label "海关商品编码"
    xxcpt_desc     colon 16 label "海关品名"        
    xxcpt_um       colon 24 label "海关单位"
    xxccpt_um_conv colon 24 label "单位转换因子"
    xxccpt_key_bom colon 24 label "海关BOM主模板"
    xxccpt_attach  colon 24 label "附属件"
    /*xxccpt_weightily  colon 24 label "共用件" */
    xxccpt_ctry    colon 24 label "产终地" space(0) xxctry_name no-label
with frame a side-labels attr-space width 80.

transloop:
repeat with frame a:
	do on error undo, retry with frame a:
	       prompt-for xxccpt_part with frame a editing:
	          if frame-field="xxccpt_part" then do:
                     {mfnp01.i xxccpt_mstr xxccpt_part xxccpt_part global_domain xxccpt_domain xxccpt_part}

                     if recno <> ? then do:
							find first pt_mstr where pt_domain = global_domain
							and pt_part = xxccpt_part no-lock no-error.

							find first xxcpt_mstr where xxcpt_domain = global_domain
							and xxcpt_ln = xxccpt_ln no-lock no-error.

							find first xxctry_mstr where xxctry_domain = global_domain
							and xxctry_code = xxccpt_ctry no-lock no-error.

							display xxccpt_part 
								pt_desc1 when available pt_mstr @ pt_desc1
								""       when not available pt_mstr @ pt_desc1
								pt_um    when available pt_mstr @ pt_um
								""       when not available pt_mstr @ pt_um
								xxccpt_ctry
								xxctry_name when available xxctry_mstr @ xxctry_name
								""          when not available xxctry_mstr @ xxctry_name
								xxccpt_ln
								xxccpt_key_bom
								xxccpt_attach /*xxccpt_weightily*/  
								xxcpt_cu_part when available xxcpt_mstr @ xxcpt_cu_part
								"" when not available xxcpt_mstr @ xxcpt_cu_part
								xxcpt_desc when available xxcpt_mstr @ xxcpt_desc
								"" when not available xxcpt_mstr @ xxcpt_desc
								pt_net_wt when available pt_mstr @ pt_net_wt
								0 when not available pt_mstr @ pt_net_wt
								pt_net_wt_um when available pt_mstr @ pt_net_wt_um
								xxcpt_um when available xxcpt_mstr @ xxcpt_um
								"" when not available xxcpt_mstr @ xxcpt_um
								xxccpt_um_conv
							with frame a.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
	       end. /*prompt-for xxccpt_part with frame a editing:*/
             
	       find first pt_mstr 
			  where pt_domain = global_domain
		      and pt_part = input xxccpt_part 
		   no-lock no-error.

           if not available pt_mstr then do:
				  message "错误：零件编号不存在，请重新输入！".
                  next-prompt xxccpt_part with frame a.
                  undo, retry.	          
	       end.
	       
	       find first xxccpt_mstr where xxccpt_part = input xxccpt_part
	              and xxccpt_domain = global_domain exclusive-lock no-error.
	       if not available xxccpt_mstr then do:
                find first pt_mstr where pt_domain = global_domain
                and pt_part = input xxccpt_part no-lock no-error.

                find first xxctry_mstr where xxctry_domain = global_domain no-lock no-error.
                
                clear frame a no-pause .

                display pt_part @ xxccpt_part 
                    pt_desc1 when available pt_mstr @ pt_desc1
                    ""       when not available pt_mstr @ pt_desc1
                    pt_um    when available pt_mstr @ pt_um
                    ""       when not available pt_mstr @ pt_um
                    
                    pt_net_wt when available pt_mstr @ pt_net_wt
                    0 when not available pt_mstr @ pt_net_wt
                    pt_net_wt_um when available pt_mstr @ pt_net_wt_um
                with frame a.


                {mfmsg.i 1 1} /*ADDING NEW RECORD */
                create xxccpt_mstr.
                assign 
                    xxccpt_domain  = global_domain
                    xxccpt_part    = input xxccpt_part
                    xxccpt_cr_date = today
                    xxccpt_ctry    = if avail xxctry_mstr then xxctry_code else ""
                    new_add = yes.

                do on error undo , retry with frame a:
                    set xxccpt_ln	with frame a editing:
                         if frame-field="xxccpt_ln" then do:
                                {mfnp01.i xxcpt_mstr xxccpt_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}                           

                            if recno <> ? then do:
                                display
                                    xxcpt_ln @ xxccpt_ln
                                    xxcpt_cu_part
                                    xxcpt_desc
                                    xxcpt_um with frame a.                           
                            end.		        
                         end.
                         else do:
                                status input ststatus.
                                readkey.
                                apply lastkey.
                         end.
                    end. /* with frame a editing:*/
                    assign xxccpt_ln .

                    find first xxcpt_mstr 
                        where xxcpt_domain = global_domain
                        and xxcpt_ln = xxccpt_ln 
                    no-lock no-error.
                    if not available xxcpt_mstr then do:
                        message "错误：商品序号不存在，请重新输入！".
                        next-prompt xxccpt_ln with frame a.
                        undo, retry.	          
                    end.
                    else do:
                        v_conv = 0 .
                        if xxcpt_um <> pt_um then do:
                            if xxcpt_um <> "KG" then do:
                                  v_part = "" .
                                  {gprun.i ""gpumcnv.p""
                                     "( pt_um, xxcpt_um ,  v_part  , output v_conv)"}
                                  if v_conv = ? then v_conv = 0.
                            end.
                            else do:
                                v_conv = pt_net_wt .
                            end.
                        end.
                        else v_conv = 1.

                        assign xxccpt_um_conv = v_conv .
                        display
                            xxcpt_ln @ xxccpt_ln
                            xxcpt_cu_part
                            xxcpt_desc
                            xxcpt_um 
                            xxccpt_um_conv 
                            with frame a. 
                    end.







                end. /*do on error undo*/


           end. /*if not available xxccpt_mstr*/
	       else do:
	          new_add = no.
			 {mfmsg.i 10 1}
	       end.

            find first xxcpt_mstr 
                where xxcpt_domain = global_domain
                and xxcpt_ln = xxccpt_ln 
            no-lock no-error.

            find first xxctry_mstr 
                where xxctry_domain = global_domain
                and xxctry_code = xxccpt_ctry 
            no-lock no-error.

	       display xxccpt_part 
					pt_desc1 when available pt_mstr @ pt_desc1
					""       when not available pt_mstr @ pt_desc1
					pt_um    when available pt_mstr @ pt_um
					""       when not available pt_mstr @ pt_um
					xxccpt_ctry
					xxctry_name when available xxctry_mstr @ xxctry_name
					""          when not available xxctry_mstr @ xxctry_name
					xxccpt_ln
					xxccpt_key_bom
					xxccpt_attach  /*xxccpt_weightily*/   
					xxcpt_cu_part when available xxcpt_mstr @ xxcpt_cu_part
					"" when not available xxcpt_mstr @ xxcpt_cu_part
					xxcpt_desc when available xxcpt_mstr @ xxcpt_desc
					"" when not available xxcpt_mstr @ xxcpt_desc
					pt_net_wt when available pt_mstr @ pt_net_wt
					0 when not available pt_mstr @ pt_net_wt
					pt_net_wt_um when available pt_mstr @ pt_net_wt_um
					xxcpt_um when available xxcpt_mstr @ xxcpt_um
					"" when not available xxcpt_mstr @ xxcpt_um
					xxccpt_um_conv
	       with frame a.

           v_recno = if avail xxccpt_mstr then recid(xxccpt_mstr) else ? .

	       do on error undo , retry with frame a:
              find xxccpt_mstr where recid(xxccpt_mstr) = v_recno no-error .

	          set       
				  xxccpt_um_conv				  
				  xxccpt_key_bom
				  xxccpt_attach
				   /*xxccpt_weightily*/   
                  xxccpt_ctry
	              go-on("F5" "CTRL-D")
                  with frame a editing:
					 if frame-field="xxccpt_ctry" then do:
							{mfnp01.i xxctry_mstr xxccpt_ctry xxctry_code global_domain xxctry_domain xxctry_code}

							if recno <> ? then do:
							   display xxctry_code @ xxccpt_ctry
									xxctry_name with frame a.
							end.
					 end.
					 else do:
							status input ststatus.
							readkey.
							apply lastkey.
					 end.
			  end. /* with frame a editing:*/

                if xxccpt_key_bom = yes then do:
                  find first xxccptmstr 
                      where xxccptmstr.xxccpt_domain = global_domain 
                      and xxccptmstr.xxccpt_ln = xxccpt_mstr.xxccpt_ln
                      and xxccptmstr.xxccpt_key_bom = yes 
                      and xxccptmstr.xxccpt_part <> xxccpt_mstr.xxccpt_part 
                  no-error .
                  if avail xxccptmstr then do:
                      message "错误:此序号海关BOM主模板零件已经设定:" + xxccptmstr.xxccpt_part .
                      find xxccpt_mstr where recid(xxccpt_mstr) = v_recno no-error .
                      next-prompt xxccpt_mstr.xxccpt_key_bom with frame a.
                      undo,retry .
                  end.
                end.

                find xxccpt_mstr where recid(xxccpt_mstr) = v_recno no-error .

                find first xxctry_mstr 
                    where xxctry_domain = global_domain
                    and xxctry_code = xxccpt_mstr.xxccpt_ctry 
                no-lock no-error.
                if not available xxctry_mstr then do:
                    message "错误：产终地不存在，请重新输入！".
                    next-prompt xxccpt_mstr.xxccpt_ctry with frame a.
                    undo, retry.	          
                end.


                if xxccpt_mstr.xxccpt_um_conv = 0 then do:
                    {mfmsg.i 7259 3}
                    next-prompt xxccpt_mstr.xxccpt_um_conv with frame a.
                    undo, retry.	          		  
                end.

                if lastkey = keycode("F5")
                or lastkey = keycode("CTRL-D")
                then do:
                    del-yn = no.            
                    {mfmsg01.i 11 1 del-yn}

                    if not del-yn then undo, retry.

                    if del-yn then do:
                        delete xxccpt_mstr.
                        clear frame a.
                        del-yn = no.
                        next.
                    end.
                end.
		end. /*do on error undo , retry with frame a:*/
	end.  /*do on error undo , retry with frame a:*/
end. /*transloop:*/