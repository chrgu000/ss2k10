 /* mhjit035.p  ������ת��  for barcode                                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/* REVISION: 1.1      LAST MODIFIED: 10/26/07   BY: Softspeed roger xiao   /*xp002*/ */
/*-Revision end------------------------------------------------------------          */
      
define shared variable execname as character .  execname = "mhjit035.p".
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
    field tmp_qty  like xkb_kb_qty.



find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[������ת��]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).


    V1000L:
    REPEAT:
        
        hide all no-pause .
        define variable V1000           as char format "x(40)".
        define variable L10001          as char format "x(40)".
        define variable L10002          as char format "x(40)".
        define variable L10003          as char format "x(40)".
        define variable L10004          as char format "x(40)".
        define variable L10005          as char format "x(40)".
        define variable L10006          as char format "x(40)".
        
        display dmdesc format "x(40)" skip with fram F1000 no-box.
        
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
        L10006 = "" . 
        display L10006          format "x(40)" skip with fram F1000 no-box.

        display  skip WMESSAGE NO-LABEL with fram F1000.
        
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
        v_nbr = "" .
    
        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "TR" exclusive-lock no-error.
        if avail xdn_ctrl then do:
            v_nbr  = "TR" + string(xdn_next,"999999") .
            find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
            if avail tr_hist then do:
                repeat:
                    v_nbr = "TR" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1, "999999") .
                    find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
                    if not avail tr_hist then leave .
                end.
            end.

            xdn_next = string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .   /*xp002*/

        end.
        else do:
                disp  "����:�޿��ת�Ƶ��ſ��Ƶ�"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.
        
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

    hide all no-pause .
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .



     V1100L:
     REPEAT:

        hide all no-pause .
        define variable V1100           as char format "x(40)" .
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".


        display dmdesc format "x(40)" skip with fram F1100 no-box.

        L11001 = "ת�Ƶ���: " + v_nbr .
        display L11001          skip with fram F1100 no-box.
        L11002 = "ת���λ ? " . 
        display L11002          format "x(40)" skip with fram F1100 no-box.
        L11003 = "" . 
        display L11003          format "x(40)" skip with fram F1100 no-box.
        L11004 = "" . 
        display L11004          format "x(40)" skip with fram F1100 no-box.
        L11005 = "" . 
        display L11005          format "x(40)" skip with fram F1100 no-box.
        L11006 = "" . 
        display L11006          format "x(40)" skip with fram F1100 no-box.
        
	    V1100 = "" .

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

        find first loc_mstr where loc_domain = global_domain and loc_loc = v1100 no-lock no-error .
        if not avail loc_mstr then do:
              display "��λ������,����������."  @ WMESSAGE NO-LABEL with fram F1100.
              pause 0 .
              undo ,retry .
        end.
        
        if loc_to = "" then loc_to =  v1100 .
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
    
    
    
     V1200L:
     REPEAT:

        hide all no-pause .
        define variable V1200           as date no-undo .
        define variable L12001          as char format "x(40)".
        define variable L12002          as char format "x(40)".
        define variable L12003          as char format "x(40)".
        define variable L12004          as char format "x(40)".
        define variable L12005          as char format "x(40)".
        define variable L12006          as char format "x(40)".


        display dmdesc format "x(40)" skip with fram F1200 no-box.

        L12001 = "ת�Ƶ���: " + v_nbr .
        display L12001          skip with fram F1200 no-box.
        L12002 = "ת���λ: " + loc_to .  
        display L12002          format "x(40)" skip with fram F1200 no-box.
        L12003 = "��Ч���� ?" . 
        display L12003          format "x(40)" skip with fram F1200 no-box.
        L12004 = "" . 
        display L12004          format "x(40)" skip with fram F1200 no-box.
        L12005 = "" . 
        display L12005          format "x(40)" skip with fram F1200 no-box.
        L12006 = "" . 
        display L12006          format "x(40)" skip with fram F1200 no-box.
        
 /*minth       V1200 = today.   */

	find first xef_mstr where xef_domain = global_domain and xef_date = today no-lock no-error.
        if not available xef_mstr then V1200= today .
        else V1200 = xef_eff_date .
        display V1200   WITH  fram F1200  NO-LABEL.
/*minth 08/06/02
        Update V1200   WITH  fram F1200 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1200.
           
           APPLY LASTKEY.
        END.
**********************************************************/	
	    if V1200 = ? then V1200 = today.

        display  skip WMESSAGE NO-LABEL with fram F1200.

        if v1200 < today  then do:
            display "���ڲ���С�ڽ���,����������." @ WMESSAGE NO-LABEL with fram F1200.
            pause 0  .
            undo ,retry .
        end.

        effdate = v1200 .

        display "...����...  " @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.

        display  "" @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        leave V1200L.
     END.   /* END 1200 */

     j = 0 .
    
     V1300L:
     REPEAT:

        find first tmpkb no-lock no-error .

        hide all no-pause .
        define variable V1300           as char format "x(40)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".

        display dmdesc format "x(40)" skip with fram F1300 no-box.

        L13001 = "ת�Ƶ���: " + v_nbr .
        display L13001          skip with fram F1300 no-box.
        L13002 =  "ת���λ: " + loc_to .  
        display L13002          format "x(40)" skip with fram F1300 no-box.
        L13003 = "��Ч����:" + string(effdate).
        display L13003          format "x(40)" skip with fram F1300 no-box.
        L13004 = "��������:" + string(j)  . 
        display L13004          format "x(40)" skip with fram F1300 no-box.
        L13005 = "" .  
        display L13005          format "x(40)" skip with fram F1300 no-box.
        L13006 = if avail tmpkb then "�����ˢ��,��ֱ��ȷ��ִ��" else "��ˢ����������:" .
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


              v13001 = substring(v1300,1,1) .  /* xkb_type*/
              v13002 = substring(v1300,2,length(v1300) - 4 ) .  /* xkb_part*/
              v13003 = substring(v1300,length(v1300) - 2 ,3) .    /* xkb_kb_id */

              find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                            and xkb_kb_raim_qty > 0 and xkb_status = "U" no-lock no-error .
              if not avail xkb_mstr then do:
                  disp "����:�޿����¼,����ʹ��״̬." @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0.
                  undo, retry.
              end.
              else do:
                    if (loc_to = xkb_loc) then do:
                      disp "����: �������ڴ�ת���λ" @ WMESSAGE NO-LABEL with fram F1300. 
                      pause 0.
                      undo, retry.
                    end.
                    if xkb_kb_raim_qty = 0 then do:
                          disp "ˢ��ʧ��:��������Ϊ��" @ WMESSAGE NO-LABEL with fram F1300. 
                          
/*                               for each xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 */
/*                                             and xkb_status = "U" exclusive-lock:                                                                          */
/*                               assign xkb_status = "A" xkb_upt_date = today .                                                                              */
/*                               {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"                                                    */
/*                                         &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit035.p'"                                               */
/*                                         &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr=0                                                      */
/*                                         &b_status="'U'"       &c_status="'A'"                                                                             */
/*                                         &rain_qty="xkb_kb_raim_qty"}                                                                                      */
/*                               end.                                                                                                                        */
                          
                          pause 0.
                          undo, retry.
                    end.
                    find first tmpkb no-lock no-error .
                    if not avail tmpkb then do:   /*first scan */
                        create tmpkb .
                        assign tmp_id = xkb_kb_id 
                            tmp_site  = xkb_site 
                            tmp_loc   = xkb_loc 
                            tmp_lot   = xkb_lot 
                            tmp_ref   = xkb_ref 
                            tmp_part  = xkb_part 
                            tmp_type  = v13001 
                            tmp_qty   = xkb_kb_raim_qty.
                            j = j + 1 .
                    end. /*first scan */
                    else do:  /*not first scan */

                        if (tmp_site <> xkb_site or tmp_loc <> xkb_loc) then do:
                          disp "����: ����ͬ��λ����" @ WMESSAGE NO-LABEL with fram F1300. 
                          pause 0.
                          undo, retry.
                        end.
                        else do:
                            find tmpkb where tmp_id = inte(v13003) and tmp_part = v13002 no-lock no-error .
                            if avail tmpkb then do:
                                  disp "�������Ѿ�����,�����ظ�ˢ��" @ WMESSAGE NO-LABEL with fram F1300. 
                                  pause 0.
                                  undo, retry.
                            end.


                            find tmpkb where  tmp_part <> xkb_part  no-lock no-error .
                            if avail tmpkb then do:
                                  disp "����:����ͬһ���" @ WMESSAGE NO-LABEL with fram F1300. 
                                  pause 0.
                                  undo, retry.
                            end.

                            v_qty_oh = 0 .
                            v_qty_req = xkb_kb_raim_qty .
                            for each ld_Det where ld_domain = global_domain and ld_site = xkb_site and ld_loc = xkb_loc and ld_lot = xkb_lot
                                          and ld_ref = xkb_ref and ld_part = xkb_part no-lock:
                                 v_qty_oh = v_qty_oh + ld_qty_oh .
                            end.
                            
                            for each tmpkb where tmp_part = xkb_part and tmp_site = xkb_site 
                                           and tmp_loc = xkb_loc and tmp_lot   = xkb_lot and tmp_ref   = xkb_ref   no-lock :
                                 v_qty_req = v_qty_req + tmp_qty .
                            end.

                            if v_qty_req > v_qty_oh then do:
                                  disp "ˢ��ʧ��:��治���ۼ�ת����" @ WMESSAGE NO-LABEL with fram F1300. 
                                  pause 0.
                                  undo, retry.
                            end.

                            create tmpkb .
                            assign tmp_id = xkb_kb_id 
                                tmp_site  = xkb_site 
                                tmp_loc   = xkb_loc 
                                tmp_lot   = xkb_lot 
                                tmp_ref   = xkb_ref 
                                tmp_part  = xkb_part 
                                tmp_type  = xkb_type 
                                tmp_qty   = xkb_kb_raim_qty  .  
                                j = j + 1 .
                        end.
                    end.  /*not first scan */
                    
              end.
          end. /*  if v1300 <> "" */
          else do:  /*  if v1300 = "" */

            find first tmpkb no-lock no-error .
            if not avail tmpkb then do:
                disp "����ˢ������ſ�ִ��"   @ WMESSAGE NO-LABEL with fram F1300. 
                pause 0 .
                undo ,retry .
            end.


/*                   hide all no-pause .                                                                     */
/*                   for each tmpkb no-lock break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part : */
/*                       disp tmp_type + tmp_part + string(tmp_id,"999") format "x(22)"                      */
/*                            with down frame a overlay  row 1 width 25 no-attr-space no-box .               */
/*                                                                                                           */
/*                   end.                                                                                    */
/*                   pause  before-hide .                                                                    */


                    V1400L:
                    REPEAT:

                        hide all no-pause .
                        define variable V1400           as logical  .
                        define variable L14001          as char format "x(40)".
                        define variable L14002          as char format "x(40)".
                        define variable L14003          as char format "x(40)".
                        define variable L14004          as char format "x(40)".
                        define variable L14005          as char format "x(40)".
                        define variable L14006          as char format "x(40)".

                        display dmdesc format "x(40)" skip with fram F1400 no-box.

                        L14001 = "ת�Ƶ���:" + v_nbr .
                        display L14001          skip with fram F1400 no-box.
                        L14002 = "ת���λ:" + loc_to  .
                        display L14002          format "x(40)" skip with fram F1400 no-box.
                        L14003 = "��Ч����"  +  string(effdate).
                        display L14003          format "x(40)" skip with fram F1400 no-box.
                        L14004 = "��������" + string(j).
                        display L14004          format "x(40)" skip with fram F1400 no-box.
                        L14005 = "" .
                        display L14005          format "x(40)" skip with fram F1400 no-box.
                        L14006 = "ִ�п��ת��(Y/N) ?" .
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

                              for each tmpkb where tmp_qty > 0  no-lock break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part :
                                  if first-of(tmp_part) then  assign j = 0    v_qty = 0 .

                                  v_qty = v_qty + tmp_qty.

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
                                          if avail tr_hist then  assign tr_addr = tmp_loc .
                                          find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                          if avail tr_hist then  assign tr_addr = tmp_loc .



                                      end.
                                      else do:
                                           /*disp "��Ч��治��,ת��ʧ��" @ WMESSAGE NO-LABEL with fram F1400. */
                                           /*pause 3 no-message  .                                             */
                                          run xxmsg01.p (input 0 , input  "��Ч��治��,ת��ʧ��" ,input yes )  . 
                                          undo mainloop ,retry mainloop .
                                      end.
                                  end.  /*if last-of(tmp_part) then*/
                              end. /*for each tmpkb */

                              for each tmpkb where tmp_qty > 0 break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part :

                                  find xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = tmp_type and xkb_kb_id = tmp_id and xkb_part = tmp_part  no-error .
                                  if avail xkb_mstr then do:
                                      assign xkb_loc = loc_to
                                             xkb_upt_date = today .

                                      find last tr_hist where tr_domain = global_domain and tr_type = "RCT-TR" and tr_nbr = v_nbr and tr_part = xkb_part and tr_effdate = effdate no-lock no-error.
                                      v_trnbr = if avail tr_hist then tr_trnbr else 0 .
                                      {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit035.p'"
                                                &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr="v_trnbr"
                                                &b_status="xkb_status"       &c_status="xkb_status"
                                                &rain_qty="xkb_kb_raim_qty"}

                                  end.


                              end. /*for each tmpkb */

                                    for each tmpkb:
                                          delete tmpkb .
                                    end.
                                    j = 0 .

                              leave v1300l .


                         end.  /*  if v1400 then   */
                         else do:
/*                                 L14006 = "�Ƿ�����޸�,�˳�(Y/N)?" .                                */
/*                                 display L14006          format "x(40)" skip with fram F1400 no-box. */
/*                                 Update V1400   WITH  fram F1400 no-label .                          */
                                run xxmsg02.p (input 0 , input  "�Ƿ�����޸�,�˳�(Y/N)?" ,output v1400 )  .
                                if v1400 then do:
                                    for each tmpkb:
                                          delete tmpkb .
                                    end.
                                    j = 0 .
                                    /*display "������ˢ�����п���.." @ WMESSAGE NO-LABEL with fram F1400.*/
                                    /*pause 3 no-message .*/
                                    run xxmsg01.p (input 0 , input  "������ˢ�����п���.." ,input yes )  . 
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
/*     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "TR" exclusive-lock no-error. */
/*     if avail xdn_ctrl then do:                                                                                 */
/*         find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .               */
/*         if avail tr_hist then do:                                                                              */
/*             repeat:                                                                                            */
/*                 v_nbr = "TR" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .         */
/*                 find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .        */
/*                 if not avail tr_hist then leave .                                                              */
/*             end.                                                                                               */
/*         end.                                                                                                   */
/*         xdn_next = string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) ,"999999") .                         */
/*     end.                                                                                                       */
/* end.                                                                                                  /*xp002*/          */

