/*                                                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2007/10/20   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */
define var nbr   like po_nbr   label "采购单号" .
define var vend  like prh_vend label "供应商".
define var ps_nbr_old like prh_ps_nbr label "旧装箱单号"  format "x(20)".
define var ps_nbr_new like prh_ps_nbr  label "新装箱单号"  format "x(20)".

define var part  like pt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .

define  frame a.


/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
		"装箱单号修改"       colon 25 skip(1)

	nbr                      colon 18
    vend                     colon 18 
	ad_name						no-label 
    ps_nbr_old               colon 18 
	prh_rcp_date             colon 18 label "收货日期"
	prh_receiver             colon 18 label "收货单号"
	skip(1)
	ps_nbr_new               colon 18

skip(3)

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS 
setFrameLabels(frame a:handle). */


/* DISPLAY */
view frame a.


mainloop:
repeat with frame a:
    clear frame a no-pause .


    ststatus = stline[1].
    status input ststatus.

    prompt-for  nbr with frame a editing:

         if frame-field = "nbr" then do:
            {mfnp.i po_mstr nbr  " po_domain = global_domain and po_nbr "  nbr po_nbr  po_nbr}
             if recno <> ? then do:
					nbr = po_nbr.
					vend = po_vend.
					find first ad_mstr where ad_mstr.ad_domain = global_domain and ad_addr = vend no-lock no-error.
					if avail ad_mstr then disp ad_name with frame a .
					disp nbr vend with frame a .
             end . /* if recno <> ? then  do: */		
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign nbr vend  .


	find first po_mstr where  po_domain = global_domain and po_nbr = nbr no-lock no-error .
	if not avail po_mstr then do :
		message "错误:采购单不存在" .
		undo mainloop, retry mainloop.
	end.
	else do:
			nbr = po_nbr.
			vend = po_vend.
			disp nbr vend with frame a .
			find first ad_mstr where ad_mstr.ad_domain = global_domain and ad_addr = vend no-lock no-error.
			if avail ad_mstr then disp ad_name with frame a .
			
	end.

    oldloop:
    do on error undo ,retry :
		prompt-for ps_nbr_old  with frame a editing:

			 if frame-field = "ps_nbr_old" then do:
				{   mfnp01.i 
					prh_hist ps_nbr_old   
					" prh_domain = global_domain and prh_nbr = nbr and prh_ps_nbr " 
					vend 
					prh_vend  
					prh_ps_nbr 
				 }
				 if recno <> ? then do:
						ps_nbr_old = prh_ps_nbr.
						disp ps_nbr_old prh_receiver prh_rcp_date  with frame a .
				 end . /* if recno <> ? then  do: */		
			 end.
			 else do:
					   status input ststatus.
					   readkey.
					   apply lastkey.
			 end.
		end. /* PROMPT-FOR...EDITING */
		assign  ps_nbr_old  .

		find first prh_hist where prh_domain = global_domain 
							and prh_vend =  vend  
							and prh_ps_nbr = ps_nbr_old 
							and prh_nbr = nbr 
		no-lock no-error.
		if not avail prh_hist then do:
			message "无此装箱单" .
			undo,retry .
		end.
		else do:
						ps_nbr_old = prh_ps_nbr.
						disp ps_nbr_old prh_receiver prh_rcp_date  with frame a .			
		end.

		newloop:
		do on error undo ,retry :
			update ps_nbr_new with frame a .
			if ps_nbr_new = "" or ps_nbr_new = ps_nbr_old then do:
				message "请输入新的装箱单号." .
				undo,retry.
			end.


			for each prh_hist use-index prh_ps_nbr 
							where prh_domain = global_domain 
							and prh_vend =  vend  
							and prh_ps_nbr = ps_nbr_old 
							and prh_nbr = nbr :
				assign prh_ps_nbr = ps_nbr_new .
			end.


		end. /*  newloop: */

		

    end. /*  oldloop: */



end.   /*  mainloop: */

status input.

