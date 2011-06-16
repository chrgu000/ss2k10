/* $Revision: eb2sp4    BY: Micho Yang     DATE: 06/07/06   ECO: *SS - Micho - 20060607*      */
/* $Revision: eb2sp4    BY: Micho Yang     DATE: 02/19/08   ECO: *SS - Micho - 20080219*      */

/* SS - 20080219.1 - B */
/*
25.18.2 ��������� a6glrp01.p    ����ָ����Χ ��140501����
25.18.3 ƾ֤��ӡ a6apvorp.p      ����ָ����Χ ��140501������6001����

�»��׼�����˻�����仯��
  �����Ʒԭ�� 12431 �� 12432 ���� �֣� 140501    
  ��Ӫҵ������ԭ�� 5101 ���� �֣� 6001
*/
/* SS - 20080219.1 - B */
                                                         
/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "GLUTRRP.P"}
               
define variable ref               like glt_ref     no-undo.
define variable ref1              like glt_ref     no-undo.
define variable dt                like glt_date    no-undo.
define variable dt1               like glt_date    no-undo.
define variable effdt             like glt_effdate no-undo.
define variable effdt1            like glt_effdate no-undo.
define variable btch              like glt_batch   no-undo.
define variable btch1             like glt_batch   no-undo.
define variable unb               like glt_unb label "Unbalanced Only" no-undo.
define variable type              like glt_tr_type no-undo.
define variable type1             like glt_tr_type no-undo.
define variable glname            like en_name     no-undo.
define variable entity            like gltr_entity no-undo.
define variable entity1           like gltr_entity no-undo.

DEF VAR v_post AS LOGICAL INIT YES .
DEF VAR v_print AS LOGICAL INIT NO.
DEF VAR v_user LIKE gltr_user .
DEF VAR i AS INTEGER .
DEF VAR v_username AS CHAR.
DEF VAR v_username1 AS CHAR.
DEF VAR v_line AS CHAR.
DEF VAR v_line1 AS CHAR.

DEF VAR v_tot_dr_amt AS DECIMAL.
DEF VAR v_tot_cr_amt AS DECIMAL.
DEF VAR v_curr LIKE ac_curr.
DEF VAR v_desc LIKE ac_desc .
DEF VAR v_desc111 LIKE ac_desc .
DEF VAR v_asc  AS CHAR.
DEF VAR v_dr_amt AS DECIMAL.
DEF VAR v_cr_amt AS DECIMAL.
DEF VAR v_acct1  AS CHAR.
DEF VAR v_amt    AS DECIMAL.
DEF VAR v_get_amt AS CHAR.
DEF TEMP-TABLE tt 
    FIELD tt_ref  LIKE gltr_ref 
    FIELD tt_line LIKE gltr_line
    FIELD tt_desc LIKE gltr_desc
    FIELD tt_asc  AS CHAR
    FIELD tt_asc_desc AS CHAR
    FIELD tt_asc_desc111 AS CHAR
    FIELD tt_ex_rate AS CHAR 
    FIELD tt_acct1 AS CHAR
    FIELD tt_affix AS CHAR
    FIELD tt_effdate AS CHAR
    FIELD tt_dr_amt AS DECIMAL
    FIELD tt_cr_amt AS DECIMAL
    FIELD tt_amt AS DECIMAL
    FIELD tt_curramt AS DECIMAL
    FIELD tt_page AS CHAR
    INDEX ref_line tt_ref tt_line
    .

DEF BUFFER gltrhist FOR gltr_hist .
DEF BUFFER gltdet FOR glt_det.


FUNCTION xxgetpage RETURNS CHARACTER ( INPUT j AS INTEGER ) .
if j < 4 then do:
   RETURN string(truncate(  j / 4 , 0 ) + 1) .
end.
else if ( j mod 4 ) = 0 then do:
          RETURN string(j / 4) .
     end.
     else do:
          RETURN string(truncate( j / 4,0) + 1) .
     end.
END FUNCTION .


Function xxGetAmtCap returns character (input num1 as decimal).
        define variable strMoneyMod as character extent 10 initial ["��","Ҽ","��","��","��","��","½","��","��","��"].
        define variable strMod as character extent 16 initial ["��","��","��","","Ԫ","ʰ","��","Ǫ","��","ʰ","��","Ǫ","��","ʰ","��","Ǫ"].
        define variable numChar as character.                /* ԭСд���*/
        define variable strMoney as character.                /* �����Ĵ�д���*/
        define variable item as character.                /* ��ȡ�ĵ�������*/
        define variable i as integer initial 1.                /* ѭ��ָ��        */
        define variable n as integer.                /* ��λΪ��ʱ����ǰ�жϵ���ʼλ        */
        DEFINE variable m as integer.                /* ��λΪ��ʱ����ǰ�жϵ�λ��        */

        numChar = Trim (String (num1,">>>>>>>>>>>>.99")).        
        if Length (numChar) > 15 or num1 * 100 = 0 then return ("").
        else do:
                repeat while i <= Length (numChar):        /* С��λΪ 0 ʱ�������λҲΪ 0���� "Ԫ��"������� "Ԫ" */
                        if i = 1 and Integer (Substring (numChar, Index (numChar, ".") + 1)) = 0 then do:
                                if Substring (numChar, Index (numChar, ".") - 1, 1) = "0" then
                                        strMoney = "Ԫ��".
                                else
                                        strMoney = "��".
                                i = 3.
                        end.                        
                        if i <> 3 then do:

                                /* message "1. item:" + item + "---" + "i:" + string(i) view-as alert-box. */

                                if not (Substring (numChar, Length (numChar) - i + 1, 1) = "0" and item = "0") or i = 8 or i = 12 then do:
                                        item = Substring (numChar, Length (numChar) - i + 1, 1).
                                        /* message "2. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                        if item = "0" and i <> 1 then do:        /* ����ȡ�ĵ�λ����Ϊ 0 ʱ�Ĵ�����λΪ 0 ʱ���� */
                                                /* message "3. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                                case i:
                                                        when 8 then do: /* ��λ��Ϊ 0 ʱ�����ж�������λ�Ƿ�Ϊ 0���粻����ֱ�Ӽ� "��" ��  */
                                                                case Length (numChar) - (i + 2):        /* ����λ��߲�����λ�����м�λȡ��λ�����ж��Ƿ�Ϊ 0 */
                                                                        when -1 then do:
                                                                                n = 1.
                                                                                m = 1.
                                                                        end.
                                                                        when 0 then do:
                                                                                n = 1.
                                                                                m = 2.
                                                                        end.
                                                                        otherwise do:
                                                                                n = Length (numChar) - (i + 2).
                                                                                m = 3.
                                                                        end.
                                                                end case.
                                                                if Integer (Substring (numChar, n, m)) > 0 then 
                                                                        strMoney = "��" + strMoney.
                                                        end.
                                                        when 12 then strMoney = "��" + strMoney.        /* ��λ��Ϊ 0 ʱֱ�Ӽ� "��" �� */
                                                        when 4 then                        /* ��λ��Ϊ 0 ʱ����������������һ�� "Ԫ" �� */

                                                                /******************** SS - 20060914.1 - B ********************/
                                                                  /*
                                                                if Index (strMoney, "��") = 0 then 
                                                                        strMoney = strMoneyMod [Integer(item) + 1] + "Ԫ".
                                                                    */    
                                                                
                                                                if Index (strMoney, "��") = 0 then DO:
                                                                   IF INTEGER(ITEM) = 0 THEN strMoney = "Ԫ" + strMoney .
                                                                   ELSE strMoney = strMoneyMod [Integer(item) + 1] + "Ԫ" + strMoney.
                                                                END.
                                                                /******************** SS - 20060914.1 - B ********************/
                                                        otherwise        /* ����λΪ 0 ʱ����������ұ�һλ�����㣬���һ�� "��" �� */
                                                                if Substring (numChar, Length (numChar) - i + 2, 1) <> "0" then 
                                                                        strMoney = "��" + strMoney.
                                                end case.
                                                /* message "1. " + strMoney view-as alert-box. */
                                        end.
                                        else do:        /* ��Ϊ���λֱ��ȡ���ִ�д����λ��д */
                                                /* message "4. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                                strMoney = strMod[i + 1] + strMoney.
                                                strMoney = strMoneyMod [Integer(item) + 1] + strMoney.
                                                /* message "2. " + strMoney view-as alert-box. */
                                        end.
                                        
                                end.
                        end.
                        i = i + 1.
                end.
                return (strMoney).
        end.
End Function.


/* GET NAME OF CURRENT ENTITY */
find en_mstr where en_entity = current_entity no-lock no-error.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
   if c-application-mode <> 'web' then
      pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.
assign
   entity  = current_entity
   entity1 = entity.

/* SELECT FORM */
form
   entity   colon 25    entity1 colon 50 label {t001.i}
   ref      colon 25    ref1    colon 50 label {t001.i}
   dt       colon 25    dt1     colon 50 label {t001.i}
   effdt    colon 25    effdt1  colon 50 label {t001.i}
   btch     colon 25    btch1   COLON 50 LABEL {t001.i}
   type     colon 25    type1   COLON 50 LABEL {t001.i}
   v_user   COLON 25
   unb      colon 25
   v_post   COLON 25
  /* v_print  COLON 25 */
with frame a side-labels attr-space width 80
   title color normal glname.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

repeat:
   if ref1 = hi_char then ref1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.
   if entity1 = hi_char then entity1 = "".
   IF btch1 = hi_char   THEN btch1 = "" .
   IF type1 = hi_char   THEN type1 = "" .

   if c-application-mode <> 'web' then
      update
         entity entity1
         ref ref1
         dt dt1
         effdt effdt1
         btch  btch1
         TYPE type1
         v_user
         unb
         v_post
         /* v_print */
      with frame a.

   {wbrp06.i &command = update &fields = "   entity entity1 ref ref1 dt dt1
        effdt effdt1 btch btch1 TYPE type1 v_user unb v_post
        /* v_print */ " &frm = "a"}

   {&GLUTRRP-P-TAG19}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {&GLUTRRP-P-TAG20}
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i ref     }
      {mfquoter.i ref1    }
      {mfquoter.i dt      }
      {mfquoter.i dt1     }
      {mfquoter.i effdt   }
      {mfquoter.i effdt1  }
      {mfquoter.i btch    }
      {mfquoter.i btch1   }
      {mfquoter.i TYPE    }
      {mfquoter.i type1   }
      {mfquoter.i v_user  }
      {mfquoter.i unb     }
      {mfquoter.i v_post  }
      /* {mfquoter.i v_print  }*/

      if ref1 = "" then ref1 = hi_char.
      if dt = ?  then dt = low_date.
      if dt1 = ? then dt1 = hi_date.
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.
      if entity1 = "" then entity1 = hi_char.
      IF btch1 = ""   THEN btch1 = hi_char .
      IF type1 = ""   THEN type1 = hi_char .

   end.

   /* OUTPUT DESTINATION SELECTION */
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
               
   {xxmfphead1.i}  

   FOR EACH tt :
       DELETE tt.
   END.

   IF v_post = YES THEN DO:
      v_tot_dr_amt = 0.
      v_tot_cr_amt = 0.
      v_curr = "" .
      v_desc = "" .
      v_asc = "" .
      v_desc111 = "" .
      FOR EACH gltr_hist NO-LOCK WHERE gltr_ref >= ref 
                                   AND gltr_ref <= ref1 
                                   AND gltr_entity >= entity 
                                   AND gltr_entity <= entity1
                                   AND gltr_ent_dt >= dt
                                   AND gltr_ent_dt <= dt1
                                   AND gltr_eff_dt >= effdt
                                   AND gltr_eff_dt <= effdt1
                                   AND gltr_batch >= btch
                                   AND gltr_batch <= btch1
                                   AND gltr_tr_type >= TYPE
                                   AND gltr_tr_type <= type1
                                   AND gltr_unb = unb
                                   AND (gltr_user = v_user OR v_user = "" ) BREAK BY gltr_ref :
          FIND LAST gltrhist WHERE gltrhist.gltr_ref = gltr_hist.gltr_ref NO-LOCK NO-ERROR.
          IF AVAIL gltrhist THEN v_line = xxgetpage(gltrhist.gltr_line) .

          FIND FIRST ac_mstr WHERE ac_code = gltr_hist.gltr_acc NO-LOCK NO-ERROR.
          IF AVAIL ac_mstr AND ac_code <> "" THEN do:
              v_curr = ac_curr .
              v_desc = ac_desc .
              v_asc  = gltr_hist.gltr_acc .
          END.
          FIND FIRST sb_mstr WHERE sb_sub = gltr_hist.gltr_sub NO-LOCK NO-ERROR.
          IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
              v_desc = v_desc + "-" + sb_desc .
              v_asc  = v_asc + "-" + gltr_hist.gltr_sub .
          END.
          ELSE do:
              v_desc = v_desc .
              v_asc  = v_asc  .
          END.

          FIND FIRST cc_mstr WHERE cc_ctr = gltr_hist.gltr_ctr NO-LOCK NO-ERROR.
          IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
              v_desc111 = cc_desc.
              /*v_asc111  = v_asc111 + "-" + gltr_hist.gltr_ctr .*/
          END.
          FIND FIRST pj_mstr WHERE pj_project = gltr_hist.gltr_project NO-LOCK NO-ERROR.
          IF AVAIL pj_mstr AND pj_project <> "" THEN DO:
              v_desc111 = v_desc111 + "-" + pj_desc .
              /*v_asc111  = v_asc111 + "-" + gltr_hist.gltr_project .*/
          END.
          ELSE do:
              v_desc111 = v_desc111 .
              /*v_asc111 = v_asc111 .*/
          END.
          
          v_dr_amt = 0.
          v_cr_amt = 0.
          if (gltr_hist.gltr_amt >= 0 AND gltr_hist.gltr_correction = false) or
             (gltr_hist.gltr_amt <  0 AND gltr_hist.gltr_correction = true)
          then
             assign v_dr_amt = gltr_hist.gltr_amt
                    v_cr_amt = 0.
          else
             assign v_cr_amt = - gltr_hist.gltr_amt
                    v_dr_amt = 0.

          v_acct1 = "" .
          v_amt   = 0.
          IF (substring(gltr_hist.gltr_acc,1,4) = '1001' OR SUBSTRING(gltr_hist.gltr_acc,1,4) = '1002' OR 
              SUBSTRING(gltr_hist.gltr_acc,1,4) = '1009' ) THEN DO:
              FIND FIRST glta_det WHERE glta_ref = gltr_hist.gltr_ref 
                                    AND glta_line = gltr_hist.gltr_line NO-LOCK NO-ERROR.
              IF AVAIL glta_det THEN DO:
                  FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_acct1' 
                                         AND CODE_value = glta_acct1 
                                             NO-LOCK NO-ERROR.
                  IF AVAIL CODE_mstr THEN DO:
                      v_acct1 = glta_acct1 + " " + CODE_cmmt .
                  END.
                  ELSE v_acct1 = glta_acct1.
              END.
          END.

          /* SS - 20080219.1 - B */
          /*
          IF (SUBSTRING(gltr_hist.gltr_acc,1,4) = '1243' 
              OR SUBSTRING(gltr_hist.gltr_acc,1,4) = '5101') THEN DO:
              */
          IF (SUBSTRING(gltr_hist.gltr_acc,1,5) = '140501' 
              OR SUBSTRING(gltr_hist.gltr_acc,1,4) = '6001') THEN DO:
          /* SS - 20080219.1 - B */
              FIND FIRST glta_det WHERE glta_ref = gltr_hist.gltr_ref 
                                    AND glta_line = gltr_hist.gltr_line NO-LOCK NO-ERROR.
              IF AVAIL glta_det THEN DO:
                  v_amt = glta_amt .
              END.
          END.
                                                 
          v_line1 = xxgetpage(gltr_hist.gltr_line) .

          CREATE tt .
          ASSIGN
              tt_ref = gltr_hist.gltr_ref 
              tt_line = gltr_hist.gltr_line
              tt_effdate = string(year(gltr_hist.gltr_eff_dt)) + "." +  STRING(MONTH(gltr_hist.gltr_eff_dt)) + "." +  string(DAY(gltr_hist.gltr_eff_dt))
              tt_desc = gltr_hist.gltr_desc 
              tt_asc  = v_asc
              tt_asc_desc = v_desc
              tt_asc_desc111 = v_desc111
              tt_dr_amt = v_dr_amt  /* �跽 */
              tt_cr_amt = v_cr_amt  /* ���� */
              tt_affix  = gltr_hist.gltr_user2 /* ���� */
              tt_acct1 = v_acct1 /* �ʽ��� */
              tt_amt = v_amt /* ���� */
              tt_page = v_line1 + "/" + v_line 
              .
               
          IF upper(v_curr) <> "RMB" THEN DO:
              tt_curramt = abs(gltr_hist.gltr_curramt) .
              tt_ex_rate = v_curr + "��" + string(gltr_hist.gltr_ex_rate2 / gltr_hist.gltr_ex_rate ) .
          END.

          v_tot_dr_amt = v_tot_dr_amt + v_dr_amt .
          v_tot_cr_amt = v_tot_cr_amt + v_cr_amt .
          IF LAST-OF(gltr_hist.gltr_ref) THEN DO:
              v_get_amt = xxgetamtcap(ABS(v_tot_dr_amt)) .
              FIND FIRST usr_mstr WHERE usr_userid = gltr_hist.gltr_user NO-LOCK NO-ERROR.
              IF AVAIL usr_mstr THEN do:
                  v_username1 = "��֤:          ���:          ����:          ����: " + usr_name + "   ����:          �������:          ǩ��:       ".
              END.

              FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
              IF AVAIL USr_mstr THEN DO:
                 v_username = "�� " + usr_name + " ��ӡ " + 
                  "(����: " + string(year(today)) + "." + string(month(today)) + 
                  "." + string(day(today)) + ", " + "ʱ��: " +
                   STRING(TIME,"HH:MM:SS") + ")" .
              END.
                                
              CREATE tt .
              ASSIGN 
                  tt_ref = gltr_hist.gltr_ref 
                  tt_desc = v_get_amt
                  tt_affix = gltr_hist.gltr_user2
                  tt_asc = v_username1 
                  tt_asc_desc = v_username 
                  tt_amt = abs(v_tot_dr_amt)
                  tt_effdate = string(year(gltr_hist.gltr_eff_dt)) + "." +  STRING(MONTH(gltr_hist.gltr_eff_dt)) + "." +  string(DAY(gltr_hist.gltr_eff_dt))
                  .
              v_tot_dr_amt = 0.
              v_tot_cr_amt = 0.
          END.

          v_curr = "" .
          v_desc = "" .
          v_asc = "" .
          v_desc111 = "" .

      END. /* for each gltr_hist */
   END. /* v_post = yes */
   ELSE DO:
      v_tot_dr_amt = 0.
      v_tot_cr_amt = 0.
            v_curr = "" .
      v_desc = "" .
      v_asc = "" .
      v_desc111 = "" .
      FOR EACH glt_det NO-LOCK WHERE glt_ref >= ref 
                                AND glt_ref <= ref1 
                                AND glt_entity >= entity 
                                AND glt_entity <= entity1
                                AND glt_date >= dt
                                AND glt_date <= dt1
                                AND glt_effdate >= effdt
                                AND glt_effdate <= effdt1
                                AND glt_batch >= btch
                                AND glt_batch <= btch1
                                AND glt_tr_type >= TYPE
                                AND glt_tr_type <= type1
                                AND glt_unb = unb 
                                AND (glt_userid = v_user OR v_user = "" )BREAK BY glt_ref :

          FIND LAST gltdet WHERE gltdet.glt_ref = glt_det.glt_ref NO-LOCK NO-ERROR.
          IF AVAIL gltdet THEN v_line = xxgetpage(gltdet.glt_line) .

          FIND FIRST ac_mstr WHERE ac_code = glt_det.glt_acc NO-LOCK NO-ERROR.
          IF AVAIL ac_mstr AND ac_code <> ""  THEN do:
              v_curr = ac_curr .
              v_desc = ac_desc .
              v_asc  = glt_det.glt_acc .
          END.
          ELSE DO:
              v_curr = "".
              v_desc = "".
              v_asc = "".
          END.
          FIND FIRST sb_mstr WHERE sb_sub = glt_det.glt_sub NO-LOCK NO-ERROR.
          IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
              v_desc = v_desc + "-" + sb_desc .
              v_asc  = v_asc + "-" + glt_det.glt_sub .
          END.
          ELSE do:
              v_desc = v_desc .
              v_asc  = v_asc  .
          END.

          FIND FIRST cc_mstr WHERE cc_ctr = glt_det.glt_cc NO-LOCK NO-ERROR.
          IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
              v_desc111 = cc_desc.
              /*v_asc111  = v_asc111 + "-" + glt_det.glt_cc .*/
          END.
          FIND FIRST pj_mstr WHERE pj_project = glt_det.glt_project NO-LOCK NO-ERROR.
          IF AVAIL pj_mstr AND pj_project <> "" THEN DO:
              v_desc111 = v_desc111 + "-" + pj_desc .
              /*v_asc111  = v_asc111 + "-" + glt_det.glt_project .*/
          END.
          ELSE do:
              v_desc111 = v_desc111 .
              /*v_asc111 = v_asc111 .*/
          END.
          
          v_dr_amt = 0.
          v_cr_amt = 0.
          if (glt_det.glt_amt >= 0 AND glt_det.glt_correction = false) or
             (glt_det.glt_amt <  0 AND glt_det.glt_correction = true)
          then
             assign v_dr_amt = glt_det.glt_amt
                    v_cr_amt = 0.
          else
             assign v_cr_amt = - glt_det.glt_amt
                    v_dr_amt = 0.

          v_acct1 = "" .
          v_amt   = 0.
          IF (substring(glt_det.glt_acc,1,4) = '1001' OR SUBSTRING(glt_det.glt_acc,1,4) = '1002' OR 
              SUBSTRING(glt_det.glt_acc,1,4) = '1009' ) THEN DO:
              FIND FIRST glta_det WHERE glta_ref = glt_det.glt_ref 
                                    AND glta_line = glt_det.glt_line NO-LOCK NO-ERROR.
              IF AVAIL glta_det THEN DO:
                  FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_acct1' 
                                         AND CODE_value = glta_acct1 
                                             NO-LOCK NO-ERROR.
                  IF AVAIL CODE_mstr THEN DO:
                      v_acct1 = glta_acct1 + " " + CODE_cmmt .
                  END.
                  ELSE v_acct1 = glta_acct1.
              END.
          END.

          /* MESSAGE glt_det.glt_acc + ";" + glt_det.glt_acc VIEW-AS ALERT-BOX. */

          /* SS - 20080219.1 - B */
          /*
          IF (SUBSTRING(glt_det.glt_acc,1,4) = '1243' 
              OR SUBSTRING(glt_det.glt_acc,1,4) = '5101') THEN DO:
            */
          IF (SUBSTRING(glt_det.glt_acc,1,5) = '140501' 
              OR SUBSTRING(glt_det.glt_acc,1,4) = '6001') THEN DO:
          /* SS - 20080219.1 - B */

              FIND FIRST glta_det WHERE glta_ref = glt_det.glt_ref 
                                    AND glta_line = glt_det.glt_line NO-LOCK NO-ERROR.
              IF AVAIL glta_det THEN DO:
                  
                  v_amt = glta_amt .
              END.
          END.
          
          v_line1 = xxgetpage(glt_det.glt_line) .

          CREATE tt .
          ASSIGN
              tt_ref = glt_det.glt_ref 
              tt_line = glt_det.glt_line
              tt_effdate = string(year(glt_det.glt_effdate)) + "." + string(MONTH(glt_det.glt_effdate)) + "." + string(DAY(glt_det.glt_effdate)) 
              tt_desc = glt_det.glt_desc 
              tt_asc  = v_asc
              tt_asc_desc = v_desc 
              tt_asc_desc111 = v_desc111 
              tt_dr_amt = v_dr_amt  /* �跽 */
              tt_cr_amt = v_cr_amt  /* ���� */
              tt_affix  = glt_det.glt_user2 /* ���� */
              tt_acct1 = v_acct1 /* �ʽ��� */
              tt_amt = v_amt /* ���� */
              tt_page = v_line1 + "/" + v_line 
              .
               
          IF upper(v_curr) <> "RMB" THEN DO:
              tt_curramt = abs(glt_det.glt_curr_amt) .
              tt_ex_rate = v_curr + "��" + string(glt_det.glt_ex_rate2 / glt_det.glt_ex_rate ) .
          END.

          v_tot_dr_amt = v_tot_dr_amt + v_dr_amt .
          v_tot_cr_amt = v_tot_cr_amt + v_cr_amt .
          IF LAST-OF(glt_det.glt_ref) THEN DO:
              v_get_amt = xxgetamtcap(ABS(v_tot_dr_amt)) .
              FIND FIRST usr_mstr WHERE usr_userid = glt_det.glt_userid NO-LOCK NO-ERROR.
              IF AVAIL usr_mstr THEN do:
                  v_username1 = "��֤:          ���:          ����:          ����: " + usr_name + "   ����:          �������:          ǩ��:       ".
              END.

              FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
              IF AVAIL USr_mstr THEN DO:
                 v_username = "�� " + usr_name + " ��ӡ " + 
                  "(����: " + string(year(today)) + "." + string(month(today)) + 
                  "." + string(day(today)) + ", " + "ʱ��: " +
                   STRING(TIME,"HH:MM:SS") + ")" .
              END.

              CREATE tt .
              ASSIGN 
                  tt_ref = glt_det.glt_ref 
                  tt_desc = v_get_amt /* �ϼƴ�д��� */                     
                  tt_asc = v_username1
                  tt_affix = glt_det.glt_user2
                  tt_asc_desc = v_username
                  tt_amt = abs(v_tot_dr_amt)
                  tt_effdate = string(year(glt_det.glt_effdate)) + "." + string(MONTH(glt_det.glt_effdate)) + "." + string(DAY(glt_det.glt_effdate)) 
                  .
              v_tot_dr_amt = 0.
              v_tot_cr_amt = 0.
          END.     
          v_curr = "" .
          v_desc = "" .
          v_asc = "" .
          v_desc111 = "" .
      END. /* for each glt_det */
   END. /* v_post = no */

/* �����BI */
PUT UNFORMATTED "#def REPORTPATH=$/����/BI����/a6apvor1" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

                         /*
    PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
    PUT UNFORMATTED "ExcelFile" ";" "a6apvorp" SKIP.
    PUT UNFORMATTED "SaveFile" ";" "ƾ֤" SKIP.
    PUT UNFORMATTED "CenterHeader" ";" "�����Ѻ������㲿�����޹�˾" SKIP.
    PUT UNFORMATTED "CenterHeader" ";" "����ƾ֤" SKIP.
    PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
    PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
    PUT UNFORMATTED "Format" ";" "yes" SKIP.
    PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.
                           */

/*
IF v_print = NO THEN DO:
    PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
    PUT UNFORMATTED "ExcelFile" ";" "a6apvorp1" SKIP.
    PUT UNFORMATTED "SaveFile" ";" "ƾ֤��ӡ" SKIP.
    PUT UNFORMATTED "CenterHeader" ";" "�����Ѻ������㲿�����޹�˾" SKIP.
    PUT UNFORMATTED "CenterHeader" ";" "����ƾ֤" SKIP.
    PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
    PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
    PUT UNFORMATTED "Format" ";" "yes" SKIP.
    PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.
END.

ELSE DO:
    PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
    PUT UNFORMATTED "ExcelFile" ";" "a6apvorp2" SKIP.
    PUT UNFORMATTED "SaveFile" ";" "ƾ֤��ӡ" SKIP.
    PUT UNFORMATTED "CenterHeader" ";" "�����Ѻ������㲿�����޹�˾" SKIP.
    PUT UNFORMATTED "CenterHeader" ";" "����ƾ֤" SKIP.
    PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
    PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
    PUT UNFORMATTED "Format" ";" "yes" SKIP.
    PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.
END.
*/
   /*
   PUT UNFORMATTED "TextColumn".
   i = 0.
   REPEAT:
      i = i + 1.
      PUT UNFORMATTED ";" STRING(i) .
      IF i = 8 THEN DO:
         LEAVE.
      END.
   END.
   i = 13 .
   REPEAT:
      i = i + 1.
      PUT UNFORMATTED ";" STRING(i) .
      IF i = 15 THEN DO:
         LEAVE.
      END.
   END.
   PUT SKIP.
     */

/*
PUT UNFORMATTED "ƾ֤���" ";" "���" ";" "ժҪ" ";" "��Ŀ���" ";"
                "��Ŀ����" ";" "�һ���" ";" "�ʽ���" ";" "����" ";" 
                "����" ";" "�跽���" ";" "�������" ";" "����" ";" 
                "ԭ��" ";" "ҳ��" ";" "�ɱ�����"  SKIP.
  */

FOR EACH tt :
    EXPORT DELIMITER ";" tt_ref tt_line tt_desc tt_asc tt_asc_desc tt_ex_rate tt_acct1 tt_affix tt_effdate tt_dr_amt tt_cr_amt tt_amt tt_curramt tt_page tt_asc_desc111 .
END.

   /* REPORT TRAILER  */
   {a6mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
