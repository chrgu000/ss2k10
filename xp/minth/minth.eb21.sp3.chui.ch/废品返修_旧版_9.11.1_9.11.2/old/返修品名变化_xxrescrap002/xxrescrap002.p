/* xx																					     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.								         */
/* All rights reserved worldwide.  This is an unpublished work.							     */
/*V8:ConvertMode=NoConvert																	 */
/* REVISION: 1.0      Create : 02/28/2008   BY: Softspeed roger xiao      ECO:*xp001*        */
/* REVISION: 1.1   Last Modified: 2009/03/25   By: Roger   ECO:*xp011*     */ 
/*-Revision end------------------------------------------------------------*/

/*xp011* ������:�������������*/

/*********** start tx01*************
   xxkbporl.p ----> xxrebkbcmt.p      
                    xxtransbcmt.i
                    xxsetupbcmt.i
                    xxdownbcmt.i
                    xxdowntimebcmt.i
                    xxretrforbcmt.i
       

   xxrebkbcmt.p --> xxredfltbcmt.p
                      --> xxretrforbcmt.i
                    xxretrin3bcmt.p
		      --> xxretrforbcmt.i		      
		    xxreopvalbcmt.i 
		    xxrebkfli1bcmt.p
		      --> xxretrforbcmt.i
		      --> xxresrqrinbcmt.p
		    xxreisslstbcmt.p
		      --> xxicedit2bcmt.p
		            --> xxicedit2bcmt.i
		    xxrercvlstbcmt.p
		    xxreoptr1fbcmt.p
		      --> xxicedit2bcmt.p
		            --> xxicedit2bcmt.i
		    xxreceivebcmt.p
		    xxrenplfmt.p
		      --> xxretrformmt.i
		    xxreophist.p     
*********** end tx01*************/






/*************************************************************����Ϊ�汾��ʷ */  
/* ֮ǰ�汾����ͳ�� */
/* SS - 090410.1  By: Roger Xiao */
/* SS - 090622.1  By: Roger Xiao */
/* SS - 090730.1  By: Roger Xiao */
/*************************************************************����Ϊ����˵�� */

/* SS - 090410.1 - RNB
Ĭ�Ϸ�Ʒ��λ��pt_loc�޸�Ϊ(��λ˵������"�߲߱���Ʒ��"�Ŀ�λ)
SS - 090410.1 - RNE */

/* SS - 090622.1 - RNB
֮ǰ�汾: �и��������ƻ�rps_mstr,���޸�Ϊ������rps_mstr: b_qc = "qc" --> xxrebkscrap002.p --> xxreceive.p --> xxreupdscf.p --> xxreupdscb.p
SS - 090622.1 - RNE */

/* SS - 090730.1 - RNB
������������һ�ʿյļ�¼,����pdlnΪ��ʱ��ʽ������, ��������һ��У��,����Ϊ��
SS - 090730.1 - RNE */




{mfdtitle.i "090730.1"}



{gpglefv.i} /*var for eff_date check: gpglef.i*/

{xxretrforscrap002.i new} /*var for xx....*/

define var v_qty_oh like ld_qty_oh .


define new shared variable sf_entity like en_entity.
define new shared variable op_recno as recid.
define new shared variable sf_gl_amt like tr_gl_amt.
define new shared variable sf_cr_acct   like dpt_lbr_acct.
define new shared variable sf_dr_acct   like dpt_lbr_acct.
define new shared variable sf_cr_sub    like dpt_lbr_sub.
define new shared variable sf_dr_sub    like dpt_lbr_sub.
define new shared variable sf_cr_cc     like dpt_lbr_cc.
define new shared variable sf_dr_cc     like dpt_lbr_cc.
define new shared variable ref          like glt_ref.
define new shared variable opgltype     like opgl_type.



/*tx01*/ {gldydef.i new}
/*tx01*/ {gldynrm.i new}


find first icc_ctrl where icc_domain = global_domain no-lock no-error.
site = (if available icc_ctrl then icc_site else global_domain).
eff_date = today .
op = 10.


view frame a.
mainloop:
repeat with frame a:
    clear frame a no-pause .

    ststatus = stline[1].
    status input ststatus.

		/*test*********************************************
			v_part = "3301000200301001" .
			v_loc = "01020600" .
			pdln = "01010100" .
			
		*test**********************************************/
	v_part = global_part .
	desc1 = "" .
	desc2 = "" .
	v_loc = "" .
	pdln  = "" .
	v_qty_s = 0 .
	v_qty_g	= 0 .
	v_hrs = 0 .

	 disp v_part desc1 desc2 
		  v_part2 desc3 desc4 
		  v_loc  
		  v_qty_a 
		  pdln v_qty_s	v_qty_g	eff_date v_hrs   
	 with frame a.

    prompt-for v_part with frame a editing:
         if frame-field = "v_part" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp.i pt_mstr v_part  "pt_domain = global_domain and pt_part "  v_part pt_part pt_part}
             if recno <> ? then do:
                    desc1 = pt_desc1 .
                    desc2 = pt_desc2 .
					v_part = pt_part .
                    display v_part desc1 desc2 with frame a .
             end . /* if recno <> ? then  do: */

         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign v_part .


    find first pt_mstr 
		where pt_domain = global_domain 
		and pt_part = v_part 
	no-lock no-error.
    if not avail pt_mstr  then do :
        message "����: �ϼ�������" view-as alert-box .
        undo mainloop, retry mainloop.
    end.

	global_part = v_part .

    find pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error .
    desc1 = if avail pt_mstr then pt_desc1 else "" .
    desc2 = if avail pt_mstr then pt_desc2 else "" .
	v_loc = if avail pt_mstr then pt_loc   else "" .
    /* SS - 090410.1 - B */
    find first loc_mstr where loc_domain = global_domain and loc_site = site and index(loc_desc,"�߲߱���Ʒ��" ) <> 0 no-lock no-error .
    if avail loc_mstr then do:
        v_loc = loc_loc .
        display loc_loc @ v_loc  loc_desc with frame a.
    end.
    /* SS - 090410.1 - E */
	disp v_part desc1 desc2 v_loc with frame a .

	do on error undo, retry with frame a:	
		prompt-for v_loc  with frame a editing:
		   if frame-field = "v_loc" then do:
			  {mfnp.i loc_mstr v_loc  " loc_mstr.loc_domain = global_domain and loc_site = site and loc_loc "  
					  v_loc loc_loc loc_loc}
			  if recno <> ? then do:
				 display loc_loc @ v_loc  loc_desc with frame a.
			  end.
		   end. /* if frame-field */
		   else do:
			  readkey.
			  apply lastkey.
		   end.
		end. /* prompt-for */
		assign v_loc .

		find first loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = site and loc_loc = v_loc  no-lock no-error.            
		if not available loc_mstr then do:
		   message "����: ��Ʒ��λ������,����������!"   .
		   next-prompt v_loc with frame a.
		   undo, retry.	       
		end. /* IF NOT AVAILABLE ln_mstr */
		else display loc_loc @ v_loc  loc_desc with frame a.
	end.  /*do on error undo, retry with frame a: */


	do on error undo, retry with frame a:	
		v_qty_oh= 0 .
		for each ld_det where ld_domain = global_domain 
						and ld_site = site 
						and ld_loc  = v_loc
						and ld_part = v_part 
		no-lock :
			v_qty_oh = v_qty_oh + ld_qty_oh .
		end.

		update v_qty_a  with frame a .


		if v_qty_a <= 0 then do:
		   message "����: ��Ʒ������Ч,����������".
		   next-prompt v_qty_a with frame a.
		   undo, retry.	 
		end.

		if v_qty_oh < v_qty_a then do:
		   message "����: ������Ʒ��Ĵ˷�Ʒ������:" v_qty_oh ",����������".
		   next-prompt v_qty_a with frame a.
		   undo, retry.	 
		end.

		do on error undo, retry with frame a:


			prompt-for pdln v_qty_s	v_qty_g	eff_date v_hrs   with frame a editing:
			   if frame-field = "pdln" then do:
				  {mfnp.i ln_mstr pdln  " ln_mstr.ln_domain = global_domain and ln_line "  pdln ln_line ln_line }
				  if recno <> ? then do:
					 display ln_line @ pdln ln_desc  with frame a.
				  end.
			   end. /* if frame-field */
			   else do:
				  readkey.
				  apply lastkey.
			   end.
			end. /* prompt-for */
			assign pdln v_qty_s	v_qty_g	eff_date v_hrs .

            /* SS - 090730.1 - B */
            if pdln = "" then do:
               message "����: �����߲���Ϊ��,����������!"   .
               next-prompt pdln with frame a.
               undo, retry.	       
            end. 
            /* SS - 090730.1 - E */

			find first ln_mstr where ln_mstr.ln_domain = global_domain and ln_line =  pdln no-lock no-error.            
			if not available ln_mstr then do:
			   message "����: �����߲�����,����������!"   .
			   next-prompt pdln with frame a.
			   undo, retry.	       
			end. /* IF NOT AVAILABLE ln_mstr */
			else display ln_line @ pdln ln_desc  with frame a.	  
			
			if v_qty_s < 0  then do:
			   message "����: ��Ʒ������Ч,����������"   .
			   next-prompt v_qty_s with frame a.
			   undo, retry.	    
			end.
			if  v_Qty_g < 0 then do:
			   message "����: ��Ʒ������Ч,����������"   .
			   next-prompt v_qty_g with frame a.
			   undo, retry.	    
			end.
			if ( v_qty_s + v_Qty_g ) <> v_qty_a then do:
			   message "����: ����Ʒ��+��Ʒ��,�����ڷ��޲���Ʒ��,����������"   .
			   next-prompt v_qty_s with frame a.
			   undo, retry.	    
			end.

			if v_hrs < 0 then do:
			   message "����: ���޹�ʱ����Ч,����������"   .
			   next-prompt v_hrs with frame a.
			   undo, retry.	    
			end.

			find si_mstr  where si_mstr.si_domain = global_domain and  si_site = site no-lock no-error.
			if not available si_mstr then do:
				{pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
				undo , retry.	
			end.
			{gprun.i ""gpsiver.p"" "(input site, input recid(si_mstr),	output return_int)"	}
			if return_int = 0 then do:
				{pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
				undo, retry.
			end.
			{gpglef1.i  &module = ""IC""
						&entity = si_entity
						&date   = eff_date
						&prompt = "eff_date"
						&frame  = "a"
						&loop   = "mainloop"}
			disp pdln ln_desc v_qty_s v_qty_g eff_date v_hrs   with frame a.

            /*xp011***start*/
                {xxrochk01.i 
                     &line    = pdln
                     &part    = v_part
                }


            /*xp011***end*/

			/*if v_qty_g > 0 then do : *xp011*/
            if v_qty_g > 0 then do on error undo, retry with frame a: /*xp011*/

				prompt-for v_part2 with frame a editing:
					 if frame-field = "v_part2" then do:
						 /* FIND NEXT/PREVIOUS RECORD */
						 {mfnp.i pt_mstr v_part2  "pt_domain = global_domain and pt_part "  v_part2 pt_part pt_part}
						 if recno <> ? then do:
								desc3 = pt_desc1 .
								desc4 = pt_desc2 .
								v_part2 = pt_part .
								display v_part2 desc3 desc4 with frame a .
						 end . /* if recno <> ? then  do: */

					 end.
					 else do:
							   status input ststatus.
							   readkey.
							   apply lastkey.
					 end.
				end. /* PROMPT-FOR...EDITING */
				assign v_part2 .


				find first pt_mstr 
					where pt_domain = global_domain 
					and pt_part = v_part2 
				no-lock no-error.
				if not avail pt_mstr  then do :
					message "����: �ϼ�������" view-as alert-box .
					/*undo mainloop, retry mainloop.  *xp011*/
                    undo,retry .  /*xp011*/
				end.

				find pt_mstr where pt_domain = global_domain and pt_part = v_part2 no-lock no-error .
				desc3 = if avail pt_mstr then pt_desc1 else "" .
				desc4 = if avail pt_mstr then pt_desc2 else "" .
				disp v_part2 desc3 desc4 with frame a .

                /*xp011***start*/
                    {xxrochk01.i 
                         &line    = pdln
                         &part    = v_part2
                    }
                /*xp011***end*/


			end.



		end.  /*do on error undo, retry with frame a: */

	end.  /*do on error undo, retry with frame a: */

/*-�������������-------------------------------------------------------------*/
/*start����18.22.13 �������س�*********************************************************************************/	
    loopa:
    do on error undo ,retry : 	
		
		emp =  pdln .
		line = pdln .
		
        /*SS - 090622.1 - B 
		b_qc = "". 
        SS - 090622.1 - E */

        /* SS - 090622.1 - B */
		b_qc = "qc".               /* "" - ��ʾ����Ʒ, "qc" - ��ʾ����Ʒ(�����rps_mstr) */
        /* SS - 090622.1 - E */

		assign
			wkctr              = ""
			mch                = ""
			dept               = ""
			um                 = ""
			conv               = 1
			qty_rjct           = 0
			rjct_rsn_code      = ""
			rejque_multi_entry = no
			to_op              = op
			qty_scrap          = 0 
			scrap_rsn_code     = ""
			outque_multi_entry = no
			start_run          = ""
			act_run_hrs        = 0
			stop_run           = ""
			earn_code          = ""
			rsn_codes          = ""
			quantities         = 0
			scrap_rsn_codes    = ""
			scrap_quantities   = 0
			reject_rsn_codes   = ""
			reject_quantities  = 0
			act_rsn_codes      = ""
			act_hrs            = 0
			prod_multi_entry   = no
			rsn                = ""
			act_run_hrs        = 0
			move_next_op       = yes
			act_setup_hrs      = 0
			setup_rsn          = ""
			act_multi_entry    = no
			act_setup_hrs20    = 0
			down_rsn_code      = ""
			stop_multi_entry   = no
			non_prod_hrs       = 0 .
			l_stat_undo        = no. 

				   
		/*part_1: �س岻��Ʒ(�����س�),����ɲ���Ʒ��v_locת��������line = pdln*/
			/*qty_scrap = v_qty_s . */
			qty_proc    =  - v_qty_a .	
			part        = v_part.	
			v_neediss   = no .
			mod_issrc   = no .
			{gprun.i ""xxrebkscrap002.p"" }
		/*end part_1*/
		/*part_2: �س岻��Ʒ,����Ʒ;��Ʒ��汨��;���޺���Ʒ�Ŀ�����,��Ʒ�Ĳ����嵥���㹩�޸� */
			qty_proc      =  v_qty_a .
			qty_scrap     = v_qty_s . 
			part          = if v_qty_g > 0 then v_part2 else v_part.	
			act_run_hrs   = v_hrs .
			v_neediss     = yes .
			mod_issrc     = yes .
			{gprun.i ""xxrebkscrap002.p"" }
		/*end part_2*/
		message "ִ�����." .
    end. /* loopa: */
/*end ����18.22.13 �������س�*********************************************************************************/	
end.   /*  mainloop: */

status input.