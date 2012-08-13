{mfdtitle.i}
DEFINE VAR entity LIKE acd_entity.
DEFINE VAR mperiod LIKE acd_per.
DEFINE VAR myear AS INT FORMAT "9999".

DEFINE VAR it AS CHAR FORMAT "x(600)".
DEFINE VAR dr_base_amount as decimal INITIAL "0.00".
DEFINE VAR cr_base_amount as decimal INITIAL "0.00".
DEFINE VAR dr_base_tot_amt as decimal INITIAL "0.00".
DEFINE VAR cr_base_tot_amt as decimal INITIAL "0.00".
DEFINE VAR curr_amount as decimal INITIAL "0.00".
define var mdesc as char format "x(30)".
DEFINE VAR mgltref LIKE glt_ref.
DEFINE VAR mcount AS INT.
DEFINE VAR totcount AS INT.
DEFINE VAR ipage AS INT.
DEFINE VAR pages AS INT.
define var mdate as char format "x(50)".
define var mpage as char format "x(50)".
define var mrmb as char format "x(50)".
DEFINE VAR MACC AS CHAR FORMAT "X(10)".
DEFINE VAR Msub AS CHAR FORMAT "X(10)".
DEFINE VAR MCC AS CHAR FORMAT "X(10)".

function RMBChange return character (input pDec as decimal).

    define var str as character extent 10.
    str[1] = "Ҽ".
    str[2] = "��".
    str[3] = "��".
    str[4] = "��".
    str[5] = "��".
    str[6] = "½".
    str[7] = "��".
    str[8] = "��".
    str[9] = "��".
    str[10] = "��".
    
    define var str1 as character extent 11.
    str1[1] = "��".
    str1[2] = "��".
    str1[3] = "Ԫ".
    str1[4] = "ʰ".
    str1[5] = "��".
    str1[6] = "Ǫ".
    str1[7] = "��".
    str1[8] = "ʰ".
    str1[9] = "��".
    str1[10] = "Ǫ".
    str1[11] = "��".
    
    define var stmp as character format "x(15)".
    define var i as integer.
    define var l as integer.    /*lngth*/
    define var s as character.
    define var r        as character format "x(10)".
    define var ret      as character format "x(50)".

    stmp = string(pDec, ">>>>>>>>9.99").
    stmp = replace(stmp, ".", "").
    l = length(stmp).
    
    /*disp stmp.*/
    do i = 0 to l - 1:
        s = substring(stmp, l - i, 1).
        if s = "" then do: end.
        else do:
            if int(s) = 0 then 
                r = str[10].
            else 
                r = str[int(s)].
            ret = r + str1[i + 1] + ret.
        end.
    end.
    
    return ret.
end function.


FORM
    SKIP(0.5)
    entity COLON 12 
   /* mperiod COLON 35 LABEL "Period"
    myear COLON 50 LABEL "Year" */
    mgltref COLON 35 LABEL "ƾ֤��"
    WITH FRAME a  WIDTH 80 THREE-D SIDE-LABELS.
ASSIGN /*sys_date = TODAY*/
          myear = YEAR(TODAY).
 FIND FIRST gl_ctrl NO-LOCK NO-ERROR.  
 entity = gl_entity.
 FIND FIRST glc_cal WHERE glc_start <= TODAY AND glc_end >= TODAY NO-LOCK NO-ERROR.
 mperiod = glc_per.
 DISPLAY myear WITH FRAME a.     
REPEAT:

UPDATE entity    WITH FRAME a.
/* IF FRAME-FIELD = "entity" THEN DO:*/
      IF entity = '' THEN do:
          entity = gl_entity.
        DISPLAY entity WITH FRAME a.
      END.
      /*  END.*/
      update mgltref with frame a editing:
       {mfnp.i glt_det mgltref glt_ref mgltref glt_ref glt_ref}
                       
                IF recno <> ? THEN do:
               mgltref = glt_ref.
               
                DISPLAY mgltref WITH FRAME a.
      
      
      end.
      end.    
        IF mgltref = '' THEN DO:
      
          MESSAGE "ƾ֤�Ų���Ϊ��!" VIEW-AS ALERT-BOX BUTTON OK.
          NEXT-PROMPT mgltref WITH FRAME a.
          UNDO,RETRY.
          
          END.
   find first glt_det where glt_ref = mgltref AND glt_entity = entity no-lock no-error.
     if not available glt_det then do:
    MESSAGE "��Чƾ֤��!" VIEW-AS ALERT-BOX BUTTON OK.
          NEXT-PROMPT mgltref WITH FRAME a.
          UNDO,RETRY.

    
    
     end.
     /* {mfselbpr.i "printer" 80} */
     output to c:\1.txt.
          put space(10).          put skip.
          PUT SKIP.
          PUT SKIP.
          PUT SKIP.
          mcount = 0.
           FIND FIRST gl_ctrl NO-LOCK NO-ERROR.
      totcount = 0.
    
      FOR EACH glt_det WHERE glt_ref = mgltref AND glt_entity = entity /*BY glt_effdate glt_ref glt_line*/ NO-LOCK :
          totcount = totcount + 1.
          END.
          ipage = 0.
          pages = truncate(totcount / 5,0) + 1. 
         mcount = 0.
      FOR EACH glt_det WHERE glt_ref = mgltref AND glt_entity = entity /*month(glt_eff_dt) = mperiod AND glt_entity = entity*/  /*BY   glt_line*/ NO-LOCK :
      dr_base_amount = 0.
      cr_base_amount = 0.
    
        IF glt_amt > 0 THEN  dr_base_amount = glt_amt.
           ELSE cr_base_amount = abs(glt_amt).
        
        
        
       
          curr_amount = abs(glt_curr_amt).
               
                       
   dr_base_tot_amt = dr_base_tot_amt + dr_base_amount .
    cr_base_tot_amt = cr_base_tot_amt + cr_base_amount.
                     IF (mcount MOD 5 = 1 and mcount <> 1) or ipage = 0 THEN DO:
                 if ipage > 0 then PAGE.
                  ipage = ipage + 1.     
                 put skip.
              put space(78) "�人�ѵ¹�˾����ֳ�" .
              put skip.
              put space(83) "�� �� ƾ ֤".
              put skip.
              put skip.
              put space(30).
              put "���ʲο���:" .
              put unformat glt_ref.
              put space(26).
              mdate = string(year(today), "9999") + "��" + string(month(today), ">9") + "��" + string(day(today), ">9") + "��".
              put unformat mdate.
              put space(28).
              put "��Ƶ�λ:".
               put unformat glt_entity .
              put skip.
              put space(32).
              put "�������:".
              put  glt_batch .
              put space(78).
             mpage = "ҳ��:" + string(iPage, ">9") + "/" + string(Pages, ">9").
              put unformat mpage.
              put skip.
              put space(10).               put "�����������������������������Щ����������������������������Щ����������������Щ������������Щ����������������Щ�������������������".
              put skip.
              put space(10).              put "��     ժ             Ҫ    ��      ��  ��  ��  Ŀ        ��    ��ҽ��    ��  �� �� ��  �� �跽���(����) ��  �������(����)  ��".
               PUT SKIP.
                  put space(10).                      put "�����������������������������੤���������������������������੤���������������੤�����������੤���������������੤������������������".
                    PUT SKIP.
                     
                   
                      
                      
                      
                      
                      
                      
                      
                      
                      END.
                   put space(10).                 
              mdesc = glt_desc .
           
          
           
          put "��".

         
                   PUT UNFORMAT TRIM(mdesc).
                 put space(26 - length(TRIM(mDESC))).
                 put "��".
             
           
             
              if glt_sub <> '' then msub = '-' + glt_sub.
              if glt_cc <> '' then mcc = '-' + glt_cc.
               macc = trim(glt_acc) + trim(msub) + trim(mcc).
                 PUT unformat  TRIM(macc).
                 PUT SPACE(28 - LENGTH(trim(macc))).
               
                 PUT  "��".
              
                 put unformat string(curr_amount).
                 PUT SPACE(16 - LENGTH(STRING(curr_amount))).
                 
                 PUT  "��".
             

               

                 PUT unformat string(glt_ex_rate).
                 PUT SPACE(12 - LENGTH(STRING(glt_ex_rate))).
                
                 PUT  "��".
              

                

                
            
              
              
              
              
               
              PUT unformat string(dr_base_amount).
                PUT SPACE(16 - LENGTH(STRING(dr_base_amount))).
            

                 
                 PUT  "��".
               
               

                 PUT unformat string(cr_base_amount).
             
                  PUT SPACE(18 - LENGTH(STRING(cr_base_amount))).

                
                 PUT  "��".
               

             
             
               mcount = mcount + 1.
              put skip.
                 put space(10).                    
               
                 if mcount < totcount then do:
                   if mcount mod 5 <> 0 then 
                   put "�����������������������������੤���������������������������੤���������������੤�����������੤���������������੤������������������".
                     else
                         put "�������������������������������������������������������������������������������������������ة����������������ة�������������������".
.                  end.
                     else
                       put "�����������������������������ة����������������������������ة����������������ة������������੤���������������੤������������������".
                   
                    PUT SKIP.
              
                 
                
                 
                 
                 IF mcount <> totcount and mcount MOD 5 = 0 and mcount <> 0 AND  ipage < pages THEN DO:
                  put space(10).  
                   put "�������: ".

                     put space(10).
                    put "����: ".
                  put space(10).

                    put "���:".

                   put space(10).
                   put "����:".

                   put space(10).
                     put "�Ƶ�:".

                     
                     
                     
                     END.
 
      END.
 put space(10).                 
 PUT "��" .
                   PUT   "�ϼ�: " .
                    mrmb = rmbchange(dr_base_tot_amt).
                     
                      PUT unformat mrmb.
                 PUT SPACE(82 - length(trim(mrmb)) - 6  ).
                 PUT  "��".
                 PUT unformat string(dr_base_tot_amt).
                 PUT SPACE(16 - LENGTH(STRING(dr_base_tot_amt)) ).
                 PUT  "��".
                 PUT unformat string(cr_base_tot_amt).
                 PUT SPACE(18 - LENGTH(STRING(cr_base_tot_amt)) ).
                 PUT  "��".
                
               PUT SKIP.
                  put space(10).                      put "�������������������������������������������������������������������������������������������ة����������������ة�������������������".
                    PUT SKIP.
                     put space(25).
                      put "�������: ".

                      put space(10).
                     put "����: ".
                  put space(10).

                   put "���:".

                    put space(10).
                    put "����:".

                    put space(10).
                      put "�Ƶ�:".
       
       
        /* {mftrl080.i}  */ output close.
         end.             
