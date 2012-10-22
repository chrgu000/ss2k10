{mfdtitle.i}
DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.
DEF VAR iscim AS LOGICAL.
DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR mqty LIKE pod_qty_ord.
DEF VAR mamt LIKE pod_pur_cost.
DEF VAR meffdt as CHAR FORMAT "x(8)".
DEF VAR pass AS LOGICAL.
DEF VAR iserror AS LOGICAL.
DEF VAR path1 AS CHAR.
DEF TEMP-TABLE supp
    FIELD t_sup_cname AS CHAR  FORMAT "x(28)" 
    FIELD t_sup_ename AS CHAR  FORMAT "x(28)" 
    FIELD t_sup_code AS CHAR  FORMAT "x(8)" 
    FIELD t_sup_addr AS CHAR   FORMAT "x(84)" 
    FIELD t_sup_type AS CHAR 
    FIELD t_sup_country AS CHAR  FORMAT "x(3)" 
    FIELD t_sup_province AS CHAR  FORMAT "x(20)" 
    FIELD t_sup_city AS CHAR  FORMAT "x(20)" 
    FIELD t_sup_post AS CHAR  FORMAT "x(10)" 
    FIELD t_sup_contact AS CHAR  FORMAT "x(24)" 
    FIELD t_sup_tel AS CHAR  FORMAT "x(16)" 
    FIELD t_sup_tel2 AS CHAR  FORMAT "x(16)" 
    FIELD t_sup_exttel AS CHAR  FORMAT "x(4)" 
    FIELD t_sup_exttel2 AS CHAR  FORMAT "x(4)" 
    FIELD t_sup_fax AS CHAR  FORMAT "x(16)" 
    FIELD t_sup_fax2 AS CHAR  FORMAT "x(16)" 
    FIELD t_sup_email AS CHAR  FORMAT "x(24)" 
    FIELD t_sup_email2 AS CHAR  FORMAT "x(24)" 
    FIELD t_sup_currency AS CHAR  FORMAT "x(3)" 
    FIELD t_sup_paymentterm AS CHAR  FORMAT "x(8)" 
    FIELD t_sup_bank AS CHAR  FORMAT "x(2)" 
    FIELD t_sup_account AS CHAR  FORMAT "x(8)" 
    FIELD t_sup_taxcode AS CHAR   
    FIELD t_sup_tax AS CHAR  
    FIELD t_sup_shipterm AS CHAR FORMAT "x(20)" 
    FIELD t_sup_qs AS CHAR   
   FIELD t_sup_buyer AS CHAR  FORMAT "x(8)" 
    FIELD t_sup_facfounddate AS CHAR 
    FIELD t_sup_regdate AS CHAR FORMAT "x(8)"
    FIELD t_sup_status AS CHAR FORMAT "x(4)"
    FIELD t_sup_level AS CHAR
    FIELD t_sup_opflag AS CHAR.
DEF TEMP-TABLE t_error
    FIELD t_er_supcode AS CHAR FORMAT "x(18)"
    FIELD t_er_xmlfield AS CHAR FORMAT "x(10)"
    FIELD t_er_QADfield AS CHAR FORMAT "x(10)"
    FIELD t_er_mess AS CHAR FORMAT "x(30)".
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Input".
DEF VAR isgood AS LOGICAL .
DEF NEW SHARED VAR lang AS CHAR.
lang = 'en'.
DEF FRAME a
    
    SKIP(0.5)
    path COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.
REPEAT:
FOR EACH supp:
   DELETE supp.
END.
UPDATE  path WITH FRAME a.
IF path = '' THEN DO: MESSAGE "The path is empty!" VIEW-AS ALERT-BOX.
    UNDO,RETRY.
END.
 INPUT FROM VALUE(PATH).
 REPEAT:
     CREATE SUPP.
     IMPORT DELIMITER ";" T_SUP_CODE T_SUP_CNAME T_SUP_ADDR t_sup_typ T_SUP_COUNTRY
         T_SUP_PROVINCE T_SUP_CITY T_SUP_POST T_SUP_CONTACT T_SUP_TEL T_SUP_TEL2 
         T_SUP_EXTTEL T_SUP_EXTTEL2 T_SUP_FAX T_SUP_FAX2 T_SUP_EMAIL T_SUP_EMAIL2
         T_SUP_CURRENCY T_SUP_PAYMENTTERM T_SUP_BANK T_SUP_SHIPTERM T_SUP_BUYER       
         T_SUP_FACFOUNDdATE T_SUP_REGDATE T_SUP_STATUS T_SUP_LEVEL T_SUP_OPFLAG.

 END.

FOR EACH supp WHERE t_sup_code = '':
    DELETE supp .
END.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
path1 = CODE_cmmt.
iscim = NO.
OUTPUT TO value(path1 + "\log\supp_error_log.txt").
FOR EACH supp:
    pass = YES.
    
    RUN fieldcheck.
    
    IF pass THEN DO:
        iscim = YES.
        OUTPUT TO "cim.txt".
    PUT "@@batchload advnmt.p".
    PUT SKIP.
    PUT '"' .
    PUT UNFORMAT t_sup_code.
     PUT '"'.
    PUT SKIP.
    PUT '-'.
    PUT SPACE(1).
     PUT '"'.
      PUT UNFORMAT t_sup_cname.
       PUT '"'.
      PUT space(1).
       PUT '"'.
        PUT UNFORMAT SUBSTR(t_sup_addr,1,28).
         PUT '"'. 
        PUT SPACE(1).
         PUT '"'.
          PUT UNFORMAT SUBSTR(t_sup_addr,29,28).
           PUT '"'.
            PUT space(1).
             PUT '"'.
            PUT UNFORMAT SUBSTR(t_sup_addr,57,28).
             PUT '"'. 
             PUT space(1).
              
        PUT '"'.
         PUT UNFORMAT t_sup_city.
          PUT '"'.
           PUT space(1).
            /*PUT '"'.
             PUT UNFORMAT t_sup_status.
              PUT '"'.*/
           PUT '-'.
               PUT space(1).
               PUT '"'. 
               PUT UNFORMAT t_sup_post.
                 PUT '"'.
                 PUT space(1).
       PUT '-'.
         PUT space(1).
        PUT '"'.
             PUT UNFORMAT t_sup_country.
              PUT '"'.
               PUT space(1).
               PUT '"'.
             PUT UNFORMAT t_sup_province.
              PUT '"'.
               PUT space(1).
               PUT '"'.
             PUT UNFORMAT t_sup_contact.
              PUT '"'.
               PUT space(1).
               PUT '"'.
             PUT UNFORMAT t_sup_tel.
              PUT '"'.
               PUT space(1).
               PUT '"'.
             PUT UNFORMAT t_sup_exttel.
              PUT '"'.
               PUT space(1).
               PUT '"'.
             PUT UNFORMAT t_sup_fax.
              PUT '"'.
               PUT space(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '"'.
             PUT UNFORMAT t_sup_tel2.
              PUT '"'.
               PUT space(1).
               PUT '"'.
             PUT UNFORMAT t_sup_exttel2.
              PUT '"'.
               PUT space(1).
               PUT '"'.
             PUT UNFORMAT t_sup_fax2.
              PUT '"'.
               PUT space(1).
             /*  PUT '"'.
             PUT date(INTEGER(SUBSTR(t_sup_regdate,6,2)),INTEGER(SUBSTR(t_sup_regdate,9,2)),INTEGER(SUBSTR(t_sup_regdate,1,4))) .
               
              PUT '"'.*/
               PUT '-'.
               PUT space(1).
               PUT SKIP.
               PUT '-'.
               PUT SPACE(1).
              /* PUT '-'.*/
               PUT '"'.
               PUT UNFORMAT t_sup_typ.
               PUT '"'.
               PUT SPACE(1).
               IF t_sup_account = '' THEN PUT '-'.
                  ELSE DO: 
                      PUT '"'.
                  
             PUT UNFORMAT t_sup_account.
              PUT '"'.
              END.
               PUT space(1).
               PUT '-'.
               PUT SPACE(1).
                PUT '"'.
             PUT UNFORMAT t_sup_shipterm.
              PUT '"'.
               PUT space(1).
               PUT '-'.
               PUT SPACE(1).
               PUT SKIP.
                PUT '"'.
             PUT UNFORMAT t_sup_BANK.
              PUT '"'.
               PUT space(1).
                PUT '"'.
             PUT UNFORMAT t_sup_CURRENCY.
              PUT '"'.
               PUT space(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SKIP.
                PUT '"'.
             PUT UNFORMAT t_sup_BUYER.
              PUT '"'.
               PUT space(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SKIP.
                PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SKIP.
               PUT '"'.
             PUT UNFORMAT t_sup_PAYMENTTERM.
              PUT '"'.
               PUT space(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SKIP.
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SPACE(1).
               PUT '-'.
               PUT SKIP.
               PUT  '.'.
               PUT SKIP.
               PUT '.'.
               PUT SKIP.
               PUT '@@end'.
            
       



 OUTPUT CLOSE.
      
        
        
        
        
        
        
        
   

     
           RUN bdrunmfg.p(OUTPUT iserror).
     


    FIND FIRST ad_mstr  WHERE ad_addr = t_sup_code NO-LOCK NO-ERROR.
   FIND FIRST vd_mstr  WHERE vd_addr = t_sup_code NO-LOCK NO-ERROR.
        IF (NOT AVAILABLE ad_mstr) OR (NOT AVAILABLE vd_mstr) THEN DO:
            
           CREATE t_error.
         t_er_supcode = t_sup_code.
          t_er_xmlfield = ''.
              t_er_qadfield = ''.
          t_er_mess = 'This supp load failed!'.
            
            
            END.
          ELSE DO:
              IF iserror THEN DO:
                     CREATE t_error.
         t_er_supcode = t_sup_code.
          t_er_xmlfield = ''.
              t_er_qadfield = ''.
          t_er_mess = 'ERROR!'.
              END.
          END.
    END.
          END.
        /*supp*/.
                OUTPUT CLOSE.
    OUTPUT TO value( path1 + '\log\supp_check_log.txt').
    FOR EACH t_error:
        PUT SKIP.
        PUT t_er_supcode.
        PUT SPACE(1).
        PUT t_er_xmlfield.
        PUT SPACE(1).
        PUT t_er_qadfield.
        PUT SPACE(1).
        PUT t_er_mess.
        DELETE t_error.
    END.
    
    OUTPUT CLOSE.
    
    MESSAGE 'Load complete!' VIEW-AS ALERT-BOX.
    
    
    END.

PROCEDURE fieldcheck:
    /*
    FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_state'NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_state' AND CODE_value = supp.t_sup_status NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_status'.
              t_er_qadfield = 'ad_state'.
          t_er_mess = 'Please check state generalized code!'.
              END.
       END.*/
             /* FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_format' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_format' AND CODE_value = "" NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = t_sup_code.
          t_er_xmlfield = ''.
              t_er_qadfield = 'ad_format'.
          t_er_mess = 'Please check format generalized code!'.
              END.
       END.*/

     FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_type' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
       
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_type' AND CODE_value = supp.t_sup_typ NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_type'.
              t_er_qadfield = 'vd_type'.
          t_er_mess = 'Please check sup_type generalized code!'.
              END.
       END.
              FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_county' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
       
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_county' AND CODE_value = supp.t_sup_province NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_provice'.
              t_er_qadfield = 'ad_county'.
          t_er_mess = 'Please check county generalized code!'.
              END.
       END.
              FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_type' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'ad_type' AND CODE_value = '' NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = ''.
              t_er_qadfield = 'ad_type'.
          t_er_mess = 'Please check type generalized code!'.
              END.
       END.
              FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_shipvia' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
       
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_shipvia' AND CODE_value = supp.t_sup_shipterm NO-LOCK NO-ERROR.
              IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_shipterm'.
              t_er_qadfield = 'vd_shipvia'.
          t_er_mess = 'Please check shipvia generalized code!'.
              END.
       END.
              FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_buyer'NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_buyer' AND CODE_value = supp.t_sup_buyer NO-LOCK NO-ERROR.
               IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 't_sup_buyer'.
              t_er_qadfield = 'vd_buyer'.
          t_er_mess = 'Please check buyer generalized code!'.
              END.
               END.
     FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_promo'NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
      
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'vd_promo' AND CODE_value = '' NO-LOCK NO-ERROR.
               IF NOT AVAILABLE CODE_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = ''.
              t_er_qadfield = 'vd_promo'.
          t_er_mess = 'Please check promotion generalized code!'.
              END.
       END.
              
              FIND FIRST ctry_mstr WHERE ctry_ctry_code = supp.t_sup_country NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ctry_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_country'.
              t_er_qadfield = 'ad_ctry'.
          t_er_mess = 'Please check Country code!'.
              END.
    
           FIND FIRST ad_mstr WHERE ad_addr = supp.t_sup_bank NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ad_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_bank'.
              t_er_qadfield = 'vd_bank'.
          t_er_mess = 'Please check bank code!'.
              END.
    
     FIND FIRST cu_mstr WHERE cu_curr = supp.t_sup_currency NO-LOCK NO-ERROR.
              IF NOT AVAILABLE cu_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_currency'.
              t_er_qadfield = 'vd_curr'.
          t_er_mess = 'Please check Currency code!'.
              END.

           FIND FIRST ct_mstr WHERE ct_code = supp.t_sup_paymentterm NO-LOCK NO-ERROR.
              IF NOT AVAILABLE ctry_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_paymentterm'.
              t_er_qadfield = 'vd_cr_terms'.
          t_er_mess = 'Please check terms code!'.
              END.
    IF t_sup_account <> '' THEN DO:
   
          FIND FIRST ac_mstr WHERE ac_code = supp.t_sup_account NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ac_mstr THEN do:
                  pass = NO.
                 CREATE t_error.
         t_er_supcode = supp.t_sup_code.
          t_er_xmlfield = 'sup_account'.
              t_er_qadfield = 'vd_pur_acct'.
          t_er_mess = 'Please check sup account code!'.
               END.
              END.
          
          
          
          
          
          END.
