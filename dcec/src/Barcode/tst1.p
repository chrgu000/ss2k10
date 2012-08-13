
DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.
DEF VAR iscim AS LOGICAL.
DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.

DEF VAR meffdt as CHAR FORMAT "x(8)".
DEF VAR pass AS LOGICAL.
DEF TEMP-TABLE supp
    FIELD t_sup_cname AS CHAR  FORMAT "x(28)" 
    FIELD t_sup_ename AS CHAR  FORMAT "x(28)" 
    FIELD t_sup_code AS CHAR  FORMAT "x(8)" 
    FIELD t_sup_addr AS CHAR   FORMAT "x(84)" 
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
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Output".
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




CREATE X-DOCUMENT hdoc.
 create x-noderef  hRoot.

 isgood = hdoc:LOAD('FILE', path , FALSE) no-error.
IF NOT isgood THEN DO:
MESSAGE "The XML file is error!" VIEW-AS ALERT-BOX.
    UNDO,RETRY.
    END.
hdoc:GET-DOCUMENT-ELEMENT(hroot).

RUN cycletree(hroot,NO,NO).
END.

PROCEDURE cycletree:
 DEF INPUT PARAMETER ihnode AS HANDLE .
 DEF INPUT PARAMETER isread AS LOGICAL .
 DEF INPUT PARAMETER iscreate AS LOGICAL .
DEF VAR ihchild AS HANDLE.
DEF VAR htemp AS HANDLE.
 DEF VAR a AS CHAR.
DEF  VAR i AS INT.
   CREATE X-NODEREF ihchild. 
 IF ihnode:NUM-CHILDREN = 0  THEN DO:
     IF NOT isread THEN RETURN.
     IF iscreate THEN CREATE supp.
   
     CASE ihnode:NAME:
   
       when "sup_Cname" THEN DO:
     MESSAGE ihnode:GET-ATTRIBUTE('value') VIEW-AS ALERT-BOX.
         /* t_sup_cname =  ihnode:GET-ATTRIBUTE('value').*/
           END.
        when "sup_ename" THEN DO:
         t_sup_ename =  ihnode:GET-ATTRIBUTE('value').
           END.
       
        when "sup_code" THEN DO:
         t_sup_code =  ihnode:GET-ATTRIBUTE('value').
           END.
       
        when "sup_addr" THEN DO:
         t_sup_addr =  ihnode:GET-ATTRIBUTE('value').
           END.
        when "sup_country" THEN DO:
         t_sup_country =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_province" THEN DO:
         t_sup_province =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_city" THEN DO:
         t_sup_city =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_post" THEN DO:
         t_sup_post =  ihnode:GET-ATTRIBUTE('value').
           END.
        when "sup_contact" THEN DO:
         t_sup_contact =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_tel" THEN DO:
         t_sup_tel =  ihnode:GET-ATTRIBUTE('value').
           END.
   when "sup_tel2" THEN DO:
         t_sup_tel2 =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_exttel" THEN DO:
         t_sup_exttel =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_exttel2" THEN DO:
         t_sup_exttel2 =  ihnode:GET-ATTRIBUTE('value').
           END.
   when "sup_fax" THEN DO:
         t_sup_fax =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_fax2" THEN DO:
         t_sup_fax2 =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_email" THEN DO:
         t_sup_email =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_email2" THEN DO:
         t_sup_email2 =  ihnode:GET-ATTRIBUTE('value').
           END.
  when "sup_currency" THEN DO:
         t_sup_currency =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_paymentterm" THEN DO:
         t_sup_paymentterm =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_bank" THEN DO:
         t_sup_bank =  ihnode:GET-ATTRIBUTE('value').
           END.
 when "sup_account" THEN DO:
         t_sup_account =  ihnode:GET-ATTRIBUTE('value').
           END.
 when "sup_taxcode" THEN DO:
         t_sup_taxcode =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_tax" THEN DO:
         t_sup_tax =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_shipterm" THEN DO:
         t_sup_shipterm =  ihnode:GET-ATTRIBUTE('value').
           END.
 when "sup_qs" THEN DO:
         t_sup_qs =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_buyer" THEN DO:
         t_sup_buyer =  ihnode:GET-ATTRIBUTE('value').
           END.
 when "sup_facfounddate" THEN DO:
         t_sup_facfounddate =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_regdate" THEN DO:
         t_sup_regdate =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_status" THEN DO:
         t_sup_status =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_level" THEN DO:
         t_sup_level =  ihnode:GET-ATTRIBUTE('value').
           END.
 when "sup_opflag" THEN DO:
         t_sup_opflag =  ihnode:GET-ATTRIBUTE('value').
           END.

       END CASE.
   RETURN.
    END.
   
    REPEAT i = 1 TO ihnode:NUM-CHILDREN BY 1:
  IF ihnode:NAME = 'supplier_data'THEN DO:
  isread = YES.
  
   IF i = 1 THEN  iscreate = YES.
       ELSE iscreate = NO.
            
  END.

       ihnode:GET-CHILD(ihchild,i).
        
       RUN cycletree(ihchild,isread,iscreate).
    
    
    
 END.
 RETURN.
 END.
