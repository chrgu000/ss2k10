/* mhjit050.p  ��Ʒ�������  for barcode                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/2007   BY: Softspeed roger xiao   ECO:*xp001* */
/* REVISION: 1.1      LAST MODIFIED: 10/26/2007   BY: Softspeed roger xiao   ECO:*xp002* */
/* REVISION: 1.2      LAST MODIFIED: 2009/01/07   BY: Softspeed roger xiao   ECO:*xp003* */ /*�ɹ������ɺ�Ҳ��ʾ*/
/* ss-090319.1 by jack */
/* ss-090327.1 by jack */
/* ss - 09090717.1 by: jack */
/* SS - 090827.1  By: Roger Xiao */ /*ȡ���߼��޸�*/

/*-Revision end------------------------------------------------------------          */
      
define shared variable execname as character .  execname = "mhjit050.p".
define shared variable global_site as char .
define shared variable global_domain like dom_domain.
define shared variable global_userid like usr_userid.
define shared variable mfguser as character.
define shared variable global_part as character.
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable batchrun like mfc_logical.
define variable dmdesc like dom_name.
define variable WMESSAGE as char format "x(80)" init "".
define variable wtimeout as integer init 99999 .
define variable undo-input like mfc_logical.
define var loc_to like loc_loc .
define var effdate as date .
define var site like xkb_site .
define var v_yn as logical format "Y/N" initial yes .
define var v_nbr like xdn_next .
define var v_qty like xkb_kb_qty .
define var v_qty_req like xkb_kb_qty .
define var v_qty_oh like ld_qty_oh .
define var v_raim_qty  like xkb_kb_raim_qty .

define variable i as integer .
define variable j as integer .
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var stat_from as char  .
define var stat_to as char .

define variable from_expire like ld_expire.
define variable from_date like ld_date.
define variable from_status like ld_status no-undo.
define variable from_assay like ld_assay no-undo.
define variable from_grade like ld_grade no-undo.
define variable glcost like sct_cst_tot.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
define new shared variable transtype as character format "x(7)" initial "ISS-TR".

/* ss-090327.1 -b */
define variable p-type like xdn_type.    /*xp001*/  
define variable p-prev like xdn_prev.    /*xp001*/  
define variable p-next like xdn_next.    /*xp001*/  
define variable m2 as char format "x(8)".    /*xp001*/  
define variable k as integer.    /*xp001*/  
define var v_entity  like si_entity .    /*xp001*/  
define var v_module  as char initial "IC" .    /*xp001*/  
define var v_result  as integer initial 0.    /*xp001*/  
define var v_msg_nbr as integer initial 0.    /*xp001*/  
define var v_qty_sn like tr_qty_loc . /*xp001*/  
define var need_sn  as logical . /*xp001*/  




{gldydef.i new}
{gldynrm.i new}


define buffer xkbhhist for xkbh_hist.

define temp-table tmpkb 
    field tmp_id   like xkb_kb_id
    field tmp_type like xkb_type
    field tmp_site like xkb_site
    field tmp_loc  like xkb_loc
    field tmp_lot  like xkb_lot
    field tmp_ref  like xkb_ref 
    field tmp_part like xkb_part 
    field tmp_qty  like xkb_kb_qty
      /*xp001*/  field tmp_sn as logical . /* ss-090327.1 */



find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[����ת�����]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).


    V1000L:
    REPEAT:
        hide all no-pause.
        define variable V1000           as date no-undo .
        define variable L10001          as char format "x(40)".
        define variable L10002          as char format "x(40)".
        define variable L10003          as char format "x(40)".
        define variable L10004          as char format "x(40)".
        define variable L10005          as char format "x(40)".
        define variable L10006          as char format "x(40)".
        
        display dmdesc format "x(40)" skip with fram F1000 no-box.
        
        v1000 = ? .

        L10001 = "" .
        display L10001          skip with fram F1000 no-box.
        L10002 = "" . 
        display L10002          format "x(40)" skip with fram F1000 no-box.
        L10003 = "" . 
        display L10003          format "x(40)" skip with fram F1000 no-box.
        L10004 = "" . 
        display L10004          format "x(40)" skip with fram F1000 no-box.
        L10005 = "" . 
        display L10005          format "x(40)" skip with fram F1000 no-box.
        L10006 = "��Ч���� ? " . 
        display L10006          format "x(40)" skip with fram F1000 no-box.

/*minth      V1000 = today.  */
        
	find first xef_mstr where xef_domain = global_domain and xef_date = today no-lock no-error.
        if not available xef_mstr then V1000= today .
        else V1000 = xef_eff_date .
	display V1000   WITH  fram F1000 NO-LABEL.
/*minth 08/06/02        Update V1000   WITH  fram F1000 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if lastkey = 404 then  Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1000.
           
           APPLY LASTKEY.
        END.
 *************************************************/
 
        if V1000 = ? then V1000 = today.

        display  skip WMESSAGE NO-LABEL with fram F1000.

        if v1000 < today  then do:
            display "���ڲ���С�ڽ���,����������." @ WMESSAGE NO-LABEL with fram F1000.
            pause 0  .
            undo ,retry .
        end.

        effdate = v1000 .
        
        find icc_ctrl where icc_domain = global_domain no-lock no-error.
        site = if avail icc_ctrl then icc_site else global_site .
    
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                disp  "����ģ��û�п���" @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
            end.
        end.
    
        /* v_nbr */
    
/* SS - 090827.1 - B 
        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "MI" exclusive-lock no-error.
        if avail xdn_ctrl then do:
            v_nbr  = "MI" + string(xdn_next,"999999")  .
            find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
            if avail tr_hist then do:
                repeat:
                    v_nbr = "MI" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .
                    find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
                    if not avail tr_hist then leave .
                end.
            end.
             xdn_next = string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") . 
        end.
        else do:
                disp  "����:����ⵥ�ſ��Ƶ�"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.
   SS - 090827.1 - E */

/* SS - 090827.1 - B */
        /*----------------start:get nbr---------------------------*/
        v_nbr  = "" .
        p-type = "MI" .
        p-prev = "" .
        p-next = "" .
        m2 = "".
        k  = 0 .



        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type no-lock no-error.
        if available xdn_ctrl then do:
            p-prev = xdn_prev.
            p-next = xdn_next.
        end. 
        else do:
                disp  "����:�޿��ת�Ƶ��ſ��Ƶ�"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.

        do transaction on error undo, retry:
            find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type exclusive-lock no-error.
            if available xdn_ctrl then do:
                k = integer(p-next) .
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                v_nbr = trim(p-prev) + trim(m2).
                k = integer(p-next) + 1.
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                xdn_next = m2.
            end.
            if recid(xdn_ctrl) = ? then .
            release xdn_ctrl.
        end. /*do transaction*/
        /*----------------end:get nbr---------------------------*/
/* SS - 090827.1 - E */
        


        display "...����...  " @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        
        display  "" @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        leave V1000L.
    END.  /* END 1000    */


loc_to = "" .
/* ÿ��ֻ�������һ����λ */

MAINLOOP:
REPEAT: 


    for each tmpkb:
        delete tmpkb .
    end.

    hide all no-pause.
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .



     V1100L:
     REPEAT:

        hide all no-pause.
        define variable V1100           as char format "x(40)" .
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".


        display dmdesc format "x(40)" skip with fram F1100 no-box.

        L11001 = "��ⵥ��: " + v_nbr .
        display L11001          skip with fram F1100 no-box.
        L11002 = "��Ч����:" + string(effdate). 
        display L11002          format "x(40)" skip with fram F1100 no-box.
        L11003 = "" . 
        display L11003          format "x(40)" skip with fram F1100 no-box.
        L11004 = "" . 
        display L11004          format "x(40)" skip with fram F1100 no-box.
        L11005 = "" . 
        display L11005          format "x(40)" skip with fram F1100 no-box.
        L11006 = "ת���λ ? " . 
        display L11006          format "x(40)" skip with fram F1100 no-box.
        
	    V1100 = loc_to .

    	Update V1100     WITH  fram F1100 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
           
           APPLY LASTKEY.
        END.

        display  skip WMESSAGE NO-LABEL with fram F1100.

        if v1100 = "e" then leave mainloop.

         find first loc_mstr where loc_domain = global_domain and loc_loc = v1100  /*and loc_user1 = "1"*/ no-lock no-error . 
        if not avail loc_mstr then do:
              display "����:��λ������."  @ WMESSAGE NO-LABEL with fram F1100.
              pause 0 .
              undo ,retry .
        end.
	/* ss - 090717.1 -b */
	else do :
	   if loc_Loc = "" then do :
	     display "��λ����Ϊ��."  @ WMESSAGE NO-LABEL with fram F1100.
              pause 2 .
              undo ,retry .	    
	   end .
	end .
	/* ss - 090717.1 -e */
        
        if loc_to = "" then loc_to = v1100 .
        else do:
            if v1100 <> loc_to then do:
                  display "��λ�仯,�����½�������µ���" @ WMESSAGE NO-LABEL with fram F1100.
                  pause 0 .
                  undo ,retry .                
            end.
        end.

        display "...����...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
        
     END.   /* END 1100 */    
    
     j = 0 .
    
     V1300L:
     REPEAT:

        find first tmpkb no-lock no-error .

        hide all no-pause.
        define variable V1300           as char format "x(40)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".

        display dmdesc format "x(40)" skip with fram F1300 no-box.

        L13001 = "��ⵥ��: " + v_nbr .
        display L13001          skip with fram F1300 no-box.
        L13002 =  "��Ч����:" + string(effdate)  .  
        display L13002          format "x(40)" skip with fram F1300 no-box.
        L13003 = "ת���λ: " + loc_to.
        display L13003          format "x(40)" skip with fram F1300 no-box.
        L13004 = "��������:" + string(j) . 
        display L13004          format "x(40)" skip with fram F1300 no-box.
        L13005 =  "" .  
        display L13005          format "x(40)" skip with fram F1300 no-box.
        L13006 = if avail tmpkb then "�����ˢ��,��ֱ��ȷ��ִ��" else "��ˢ����������" .
        display L13006          format "x(40)" skip with fram F1300 no-box.
        
        v1300 = "" .

    	Update V1300   WITH  fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
           
           APPLY LASTKEY.
        END.

        display  skip WMESSAGE NO-LABEL with fram F1300.

        
        if v1300 <> "" then do:
            if v1300 = "e" then leave mainloop.
	     /* ss-090319.1 -b */
	     if substring(v1300,1,1) = "z" then do :
	        find first xbcm_mstr where xbcm_domain = global_domain and xbcm_nbr = v1300 no-lock no-error .
		 if available xbcm_mstr then do :
		   if xbcm_type <> "M" then do :
		    disp "�����������ʹ���" @ WMESSAGE NO-LABEL with fram F1300. 
                     pause 0.
                     undo, retry.
		   end .
		 end .

		 for each xbcm_mstr where xbcm_domain = global_domain and xbcm_nbr = v1300 no-lock :
		   find first xkb_mstr where xkb_domain = global_domain and xkb_type = xbcm_type 
		    and xkb_kb_id = xbcm_id and xkb_part = xbcm_part and ( xkb_status <> "u" or xkb_kb_raim_qty <= 0 )no-lock no-error .
		     if available xkb_mstr then do :
		     disp "���������п��������б仯" @ WMESSAGE NO-LABEL with fram F1300. 
                     pause 0.
                     undo, retry.
		     end .
		 end .
		 

		 for each xbcm_mstr where xbcm_domain = global_domain and xbcm_nbr = v1300 no-lock :
		   find first xkb_mstr where xkb_domain = global_domain and xkb_type = xbcm_type and 
		    xkb_kb_id = xbcm_id and xkb_part = xbcm_part no-lock no-error .
		    if available xkb_mstr then do :
		        if loc_to  = xkb_loc  then do:
                      disp "����:�������ڸÿ�λ" @ WMESSAGE NO-LABEL with fram F1300. 
                      pause 0 .
                      undo, retry.
                    end.                    
                   
                    
                    v_qty_oh = 0 .
                    v_qty_req = xkb_kb_raim_qty .
                    for each ld_Det where ld_domain = global_domain and ld_site = xkb_site and ld_loc = xkb_loc and ld_lot = xkb_lot
                              and ld_ref = xkb_ref and ld_part = xkb_part no-lock:
                         v_qty_oh = v_qty_oh + ld_qty_oh .
			 /* ss-090327.1 -b */
			 if ld_expire <> ? and ld_expire < today then do: /*xp001*/  
                            disp "ˢ��ʧ��:����ѹ���" @ WMESSAGE NO-LABEL with fram F1300. 
                            pause 0.
                            undo, retry.
                         end . /*xp001*/ 
			 /* ss-090327.1 -e */
                    end.

                    for each tmpkb where tmp_site = xkb_site and tmp_loc = xkb_loc and tmp_part = xkb_part and tmp_lot = xkb_lot and tmp_ref = xkb_ref no-lock :
                        v_qty_req = v_qty_req + tmp_qty . 
                    end.

                    if v_qty_req > v_qty_oh then do:
                          disp "��Ч��治��,��ȷ��" @ WMESSAGE NO-LABEL with fram F1300. 
                          pause 0.
                          undo, retry.
                    end.
                     
		    /* ss-090327.1 -b */
		    /*xp001***begin*/
                    find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                    if not avail pt_mstr then do:
                        disp "����:���������" @ WMESSAGE NO-LABEL with fram F1300.
                        pause 0 .
                        undo,retry .
                    end.
                    need_sn = no .
                    if pt__chr08 = "Y" then do:
                        find first xsn_mstr where xsn_domain = global_domain and xsn_kb = xkb_type + xkb_part + string(xkb_kb_id,"999") and xsn_stat = "U" no-lock no-error .
                        if avail xsn_mstr then do:
                            v_qty_sn = 0 .
                            for each xsn_mstr where xsn_domain = global_domain and xsn_kb = xkb_type + xkb_part + string(xkb_kb_id,"999") and xsn_stat = "U" no-lock :
                                if xsn_site <> xkb_site 
                                or xsn_loc  <> xkb_loc
                                or xsn_lot  <> xkb_lot 
                                or xsn_ref  <> xkb_ref 
                                then do:
                                    disp "����:�������λ�����в���" @ WMESSAGE NO-LABEL with fram F1300.
                                    pause 0 .
                                    undo,retry .
                                end.
                                v_qty_sn = v_qty_sn + xsn_Qty_end .
                            end.
                            if xkb_kb_raim_qty <> v_qty_sn then do:
                                disp "����:�����������в���" @ WMESSAGE NO-LABEL with fram F1300.
                                pause 0 .
                                undo,retry .
                            end.
                            need_sn = yes .
                        end.
                    end.

                    /*xp001***end*/  
		    /* ss-090327.1 -e */


                    find first tmpkb no-lock no-error .
                    if not avail tmpkb then do:   /*first scan */

		     /* ss - 090717.1 -b */
		    if xkb_Loc = "" then do:
		       disp "�����λ����Ϊ��" @ WMESSAGE NO-LABEL with fram F1300. 
                               pause 2.
                               undo, retry.
		    end .
		    /* ss - 090717.1 -e */
                        create tmpkb .
                        assign tmp_id = xkb_kb_id 
                            tmp_site  = xkb_site 
                            tmp_loc   = xkb_loc 
                            tmp_lot   = xkb_lot 
                            tmp_ref   = xkb_ref 
                            tmp_part  = xkb_part 
                            tmp_type  = xkb_type 
                            tmp_qty   = xkb_kb_raim_qty
			    /* ss-090327.1 -b */
			    tmp_sn    = need_sn . 
			    /* ss-090327.1 -e */
                            j = j + 1 .
                    end. /*first scan */
                    else do:  /*not first scan */
                            find tmpkb where tmp_id = xkb_kb_id and tmp_part = xkb_part no-lock no-error .
                            if avail tmpkb then do:
                                  disp "�������Ѿ�����,�����ظ�ˢ��" @ WMESSAGE NO-LABEL with fram F1300. 
                                  pause 0.
                                  undo, retry.
                            end.

			     /* ss - 090717.1 -b */
			    if xkb_Loc = "" then do:
			       disp "�����λ����Ϊ��" @ WMESSAGE NO-LABEL with fram F1300. 
				       pause 2.
				       undo, retry.
			    end .
			    /* ss - 090717.1 -e */

                            create tmpkb .
                            assign tmp_id = xkb_kb_id 
                                tmp_site  = xkb_site 
                                tmp_loc   = xkb_loc 
                                tmp_lot   = xkb_lot 
                                tmp_ref   = xkb_ref 
                                tmp_part  = xkb_part 
                                tmp_type  = xkb_type 
                                tmp_qty   = xkb_kb_raim_qty  
				 /* ss-090327.1 -b */
			        tmp_sn    = need_sn . 
			        /* ss-090327.1 -e */
                                j = j + 1 .
                       
                    end.  /*not first scan */
		    end .
		 end .

	     end .
	     else do :
	     /* ss-090319.1 -e */

              v13001 = substring(v1300,1,1) .  /* xkb_type*/
              v13002 = substring(v1300,2,length(v1300) - 4 ) .  /* xkb_part*/
              v13003 = substring(v1300,length(v1300) - 2 ,3) .    /* xkb_kb_id */

              if v13001 <> "M"  then do:
                  disp "������������,����ˢ��" @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0 .
                  undo, retry.
              end.

              find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                            and (xkb_status = "U" and xkb_kb_raim_qty > 0) no-lock no-error .
              if not avail xkb_mstr then do:
                  disp "����:�޿����¼,����ʹ��״̬." @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0.
                  undo, retry.
              end.
              else do:


                    if loc_to  = xkb_loc  then do:
                      disp "����:�������ڸÿ�λ" @ WMESSAGE NO-LABEL with fram F1300. 
                      pause 0 .
                      undo, retry.
                    end.                    
                   

                    v_qty_oh = 0 .
                    v_qty_req = xkb_kb_raim_qty .
                    for each ld_Det where ld_domain = global_domain and ld_site = xkb_site and ld_loc = xkb_loc and ld_lot = xkb_lot
                              and ld_ref = xkb_ref and ld_part = xkb_part no-lock:
                         v_qty_oh = v_qty_oh + ld_qty_oh .
			 /* ss-090327.1 -b */
			 if ld_expire <> ? and ld_expire < today then do: /*xp001*/  
                            disp "ˢ��ʧ��:����ѹ���" @ WMESSAGE NO-LABEL with fram F1300. 
                            pause 0.
                            undo, retry.
                         end . /*xp001*/ 
			 /* ss-090327.1 -e */
                    end.

                    for each tmpkb where tmp_site = xkb_site and tmp_loc = xkb_loc and tmp_part = xkb_part and tmp_lot = xkb_lot and tmp_ref = xkb_ref no-lock :
                        v_qty_req = v_qty_req + tmp_qty . 
                    end.

                    if v_qty_req > v_qty_oh then do:
                          disp "��Ч��治��,��ȷ��" @ WMESSAGE NO-LABEL with fram F1300. 
                          pause 0.
                          undo, retry.
                    end.

		    /* ss-090327.1 -b */
		    /*xp001***begin*/
                    find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                    if not avail pt_mstr then do:
                        disp "����:���������" @ WMESSAGE NO-LABEL with fram F1300.
                        pause 0 .
                        undo,retry .
                    end.
                    need_sn = no .
                    if pt__chr08 = "Y" then do:
                        find first xsn_mstr where xsn_domain = global_domain and xsn_kb = v1300 and xsn_stat = "U" no-lock no-error .
                        if avail xsn_mstr then do:
                            v_qty_sn = 0 .
                            for each xsn_mstr where xsn_domain = global_domain and xsn_kb = v1300 and xsn_stat = "U" no-lock :
                                if xsn_site <> xkb_site 
                                or xsn_loc  <> xkb_loc
                                or xsn_lot  <> xkb_lot 
                                or xsn_ref  <> xkb_ref 
                                then do:
                                    disp "����:�������λ�����в���" @ WMESSAGE NO-LABEL with fram F1300.
                                    pause 0 .
                                    undo,retry .
                                end.
                                v_qty_sn = v_qty_sn + xsn_Qty_end .
                            end.
                            if xkb_kb_raim_qty <> v_qty_sn then do:
                                disp "����:�����������в���" @ WMESSAGE NO-LABEL with fram F1300.
                                pause 0 .
                                undo,retry .
                            end.
                            need_sn = yes .
                        end.
                    end.

                    /*xp001***end*/  
		    /* ss-090327.1 -e */



                    find first tmpkb no-lock no-error .
                    if not avail tmpkb then do:   /*first scan */
		    /* ss - 090717.1 -b */
		    if xkb_Loc = "" then do:
		       disp "�����λ����Ϊ��" @ WMESSAGE NO-LABEL with fram F1300. 
                               pause 2.
                               undo, retry.
		    end .
		    /* ss - 090717.1 -e */
                        create tmpkb .
                        assign tmp_id = xkb_kb_id 
                            tmp_site  = xkb_site 
                            tmp_loc   = xkb_loc 
                            tmp_lot   = xkb_lot 
                            tmp_ref   = xkb_ref 
                            tmp_part  = xkb_part 
                            tmp_type  = xkb_type 
                            tmp_qty   = xkb_kb_raim_qty
			    /* ss-090327.1 -b */
			     tmp_sn    = need_sn
			    /* ss-090327.1 -e */.  
                            j = j + 1 .
                    end. /*first scan */
                    else do:  /*not first scan */
                            find tmpkb where tmp_id = inte(v13003) and tmp_part = v13002 no-lock no-error .
                            if avail tmpkb then do:
                                  disp "�������Ѿ�����,�����ظ�ˢ��" @ WMESSAGE NO-LABEL with fram F1300. 
                                  pause 0.
                                  undo, retry.
                            end.

			     /* ss - 090717.1 -b */
			    if xkb_Loc = "" then do:
			       disp "�����λ����Ϊ��" @ WMESSAGE NO-LABEL with fram F1300. 
				       pause 2.
				       undo, retry.
			    end .
			    /* ss - 090717.1 -e */

                            create tmpkb .
                            assign tmp_id = xkb_kb_id 
                                tmp_site  = xkb_site 
                                tmp_loc   = xkb_loc 
                                tmp_lot   = xkb_lot 
                                tmp_ref   = xkb_ref 
                                tmp_part  = xkb_part 
                                tmp_type  = xkb_type 
                                tmp_qty   = xkb_kb_raim_qty 
				 /* ss-090327.1 -b */
			        tmp_sn    = need_sn . 
			        /* ss-090327.1 -e */
                                j = j + 1 .
                       
                    end.  /*not first scan */
                    
              end.
	    /* ss-090319.1 -b */
	    end . /* <> "z" */
	   /* ss-090319.1 -e */
          end. /*  if v1300 <> "" */
          else do:  /*  if v1300 = "" */

            find first tmpkb no-lock no-error .
            if not avail tmpkb then do:
                disp "����ˢ������ſ�ִ��"   @ WMESSAGE NO-LABEL with fram F1300. 
                pause 0 .
                undo ,retry .
            end.



                    V1400L:
                    REPEAT:
                        
                        hide all no-pause.
                        define variable V1400           as logical  .
                        define variable L14001          as char format "x(40)".
                        define variable L14002          as char format "x(40)".
                        define variable L14003          as char format "x(40)".
                        define variable L14004          as char format "x(40)".
                        define variable L14005          as char format "x(40)".
                        define variable L14006          as char format "x(40)".
                        
                        display dmdesc format "x(40)" skip with fram F1400 no-box.
                        
                        L14001 = "��ⵥ��: " + v_nbr  .
                        display L14001          skip with fram F1400 no-box.
                        L14002 = "��Ч����:" + string(effdate) . 
                        display L14002          format "x(40)" skip with fram F1400 no-box.
                        L14003 = "ת���λ: " + loc_to.
                        display L14003          format "x(40)" skip with fram F1400 no-box.
                        L14004 = "��������:" + string(j) .  
                        display L14004          format "x(40)" skip with fram F1400 no-box.
                        L14005 = "" . 
                        display L14005          format "x(40)" skip with fram F1400 no-box.
                        L14006 = "ִ�п������?" . 
                        display L14006          format "x(40)" skip with fram F1400 no-box.
                        


                        Update V1400   WITH  fram F1400 no-label EDITING:
                            readkey pause wtimeout.
                            if lastkey = -1 then quit.
                            if LASTKEY = 404 Then Do: /* DISABLE F4 */
                                pause 0 before-hide.
                                undo, retry.
                            end.
                            display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
                            APPLY LASTKEY.
                        END.
                        display skip WMESSAGE NO-LABEL with fram F1400.

                        if v1400 then do:



                              for each tmpkb no-lock break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part :
                                  if first-of(tmp_part) then  assign j = 0    v_qty = 0 .

                                  v_qty = v_qty + tmp_qty .
      
        
                                  if last-of(tmp_part) then do:
                                      v_qty_oh = 0 .
                                      j = j + 1 .
                                      for each ld_Det where ld_domain = global_domain and ld_site = tmp_site and ld_loc = tmp_loc and ld_lot = tmp_lot
                                                      and ld_ref = tmp_ref and ld_part = tmp_part no-lock:
                                          v_qty_oh = v_qty_oh + ld_qty_oh .
                                      end.

 
                                      if v_qty <= v_qty_oh then do:
        
        
                                          for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                              delete sr_wkfl.
                                          end.
        
        
        
                                          create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                          assign sr_userid = mfguser
                                                sr_lineid = string(j) + "::" + tmp_part
                                                sr_site = tmp_site
                                                sr_loc = tmp_loc
                                                sr_lotser = tmp_lot
                                                sr_qty = v_qty 
                                                sr_ref = tmp_ref
                                                sr_user1 = v_nbr.
                                                sr_rev = loc_to.
                                                sr_user2 = tmp_part.
                                          if recid(sr_wkfl) = -1 then .
        
        
                                            from_expire = ?.
                                            from_date = ?.
                                            from_assay = 0.
                                            from_grade = "".
                                            global_part = tmp_part .
        
                                            find ld_det where ld_det.ld_domain = global_domain and  ld_part = tmp_part
                                                        and ld_site = tmp_site and ld_loc = tmp_loc and ld_lot = tmp_lot and ld_ref = tmp_ref  no-lock no-error.
                                            if available ld_det then do:
                                            assign
                                                from_status = ld_status
                                                from_expire = ld_expire
                                                from_date = ld_date
                                                from_assay = ld_assay
                                                from_grade = ld_grade.
                                            end.
        
                                            find ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = tmp_part
                                                        and ld_site = tmp_site and ld_loc = loc_to and ld_lot = tmp_lot and ld_ref = tmp_ref no-error.
                                            if not available ld_det then do:
                                                create ld_det. ld_det.ld_domain = global_domain.
                                                assign
                                                ld_site = tmp_site
                                                ld_loc = loc_to
                                                ld_part = tmp_part
                                                ld_lot = sr_lotser
                                                ld_ref = sr_ref.
                                                if recid(ld_det) = -1 then .
        
                                                find loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and loc_site = ld_site  and loc_loc = ld_loc no-error.
                                                if available loc_mstr then ld_status = loc_status.
                                                else do:
                                                    find si_mstr no-lock  where si_mstr.si_domain = global_domain and si_site = ld_site no-error.
                                                    if available si_mstr then ld_status = si_status.
                                                end.
                                            end. /* not available ld_det */
        
                                            if from_expire <> ? then ld_expire = from_expire.
                                            if from_date <> ? then ld_date = from_date.
                                            ld_assay = from_assay.
                                            ld_grade = from_grade.

                                          find pt_mstr where pt_domain = global_domain and pt_part = tmp_part no-lock no-error.
                                          {gprun.i ""icedit.p""
                                                   "(""RCT-TR"",
                                                     tmp_site,
                                                     loc_to,
                                                     pt_part,
                                                     tmp_lot,
                                                     tmp_ref,
                                                     v_qty,
                                                     pt_um,
                                                     v_nbr,
                                                     j,
                                                     output undo-input)"}
						     
                                          if undo-input then undo , retry.
					 

                                          {gprun.i ""icedit.p""
                                                   "(""ISS-TR"",
                                                     tmp_site,
                                                     tmp_loc,
                                                     pt_part,
                                                     tmp_lot,
                                                     tmp_ref,
                                                     v_qty,
                                                     pt_um,
                                                     v_nbr,
                                                     j,
                                                     output undo-input)"}
                                          
					  
                                          if undo-input then undo , retry.        
        
                                          {gprun.i ""icxfer.p""
                                             "("""",
                                               sr_lotser,
                                               sr_ref,
                                               sr_ref,
                                               sr_qty,
                                               v_nbr,
                                               """",
                                               """",
                                               """",
                                               effdate,
                                               tmp_site,
                                               tmp_loc,
                                               tmp_site,
                                               loc_to,
                                               no,
                                               """",
                                               ?,
                                               """",
                                               0,
                                               """",
                                               output glcost,
                                               output iss_trnbr,
                                               output rct_trnbr,
                                               input-output from_assay,
                                               input-output from_grade,
                                               input-output from_expire)"
                                             }
        
                                          find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
                                          if avail tr_hist then  assign tr_addr = tmp_loc .  /*д��ת����λ*/
                                          find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                          if avail tr_hist then  assign tr_addr = tmp_loc .   /*д��ת����λ*/
        
                                         /*    leave v1300l . */
        
                                      end.
                                      else do:
                                          run xxmsg01.p (input 0 , input  "��Ч��治��,ת��ʧ��" ,input yes )  . 
                                          undo mainloop ,retry mainloop .
                                      end.
                                  end.  /*if last-of(tmp_part) then*/
                              end. /*for each tmpkb */

                              for each tmpkb no-lock break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part :
                                  
                                  find xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = tmp_type and xkb_kb_id = tmp_id and xkb_part = tmp_part  no-error .
                                  if avail xkb_mstr then do:
				              assign xkb_loc = loc_to
                                             xkb_upt_date = today  .
                                      find last tr_hist where tr_domain = global_domain and tr_type = "RCT-TR" and tr_nbr = v_nbr and tr_part = xkb_part and tr_effdate = effdate no-lock no-error.
                                      v_trnbr = if avail tr_hist then tr_trnbr else 0 .
                                      {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit035.p'"
                                                &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr="v_trnbr"
                                                &b_status="xkb_status"       &c_status="xkb_status"
                                                &rain_qty="xkb_kb_raim_qty"}
        
                                  end.
                              end.
			      /* ss-090327.1 -b */
			         /*xp001*********begin*/
                                for each tmpkb where tmp_sn :
                                      for each xsn_mstr 
                                          where xsn_domain = global_domain 
                                          and xsn_kb = tmp_type + tmp_part + string(tmp_id ,"999")
                                          and xsn_stat = "U":
                                          assign 
                                            xsn_loc  = loc_to 
                                            xsn_lot  = tmp_lot
                                            xsn_ref  = tmp_ref   
                                            xsn_mod_date = today .
                                      end.
                                end.

                                hide all no-pause .
                                v_yn = yes .
                                form  
                                    v_yn label "�����,����?"                
                                with frame snsn4 side-labels overlay row 3 width 30 no-attr-space  .
                                view frame snsn4 .
                                update v_yn with frame snsn4. 
                                hide frame snsn4 no-pause .
                                if not v_yn then leave mainloop . 
                                /*xp001***********end*/ 
			      /* ss-090327.1 -e */

                              for each tmpkb:
                                  delete tmpkb .
                              end.

                              j = 0 .

                              run xxmsg01.p (input 0 , input  "��������" ,input yes )  .  /*xp003*/

                         end.  /*  if v1400 then   */
                         else do:
                                L14006 = "�Ƿ��˳�?" . 
                                display L14006          format "x(40)" skip with fram F1400 no-box.
                                Update V1400   WITH  fram F1400 no-label .
                                if v1400 then do:
                                    for each tmpkb:
                                          delete tmpkb .
                                    end.
                                    run xxmsg01.p (input 0 , input  "������ˢ�����п���.." ,input yes )  . 
                                    undo mainloop ,retry mainloop.
                                end.
                                else do :
                                    run xxmsg01.p (input 0 , input  "�����ˢ��.." ,input yes )  . 
                                    undo v1300l,retry v1300l .
                                end.

                         end.
                    
                        display "...����...  " @ WMESSAGE NO-LABEL with fram F1400.
                        pause 0.
                        
                        display  "" @ WMESSAGE NO-LABEL with fram F1400.
                        pause 0.
                        leave V1400L.
                    END.  /* END 1400    */   


                  
          end.   /*  if v1300 = "" */       


        display "...����...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.

     END.  /* END 1300   */
end. /**MAINLOOP**/

/* if v_nbr > ""  then do:                                                                                        */
/*     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "MI" exclusive-lock no-error. */
/*     if avail xdn_ctrl then do:                                                                                 */
/*         find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .               */
/*         if avail tr_hist then do:                                                                              */
/*             repeat:                                                                                            */
/*                 v_nbr = "MI" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .         */
/*                 find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .        */
/*                 if not avail tr_hist then leave .                                                              */
/*             end.                                                                                               */
/*         end.                                                                                                   */
/*     xdn_next =  (substring(v_nbr , 3 , length(v_nbr) - 2 )) .                                                  */
/*     end.                                                                                                       */
/*                                                                                                                */
/* end.              /*xp002*/                                                                                             */


