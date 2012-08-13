DEFINE VAR ac_num  AS CHAR FORMAT "X(32)".
DEFINE VAR ac_desc AS CHAR FORMAT " X(62)".
DEFINE VAR ac_deg AS INT FORMAT ">9".
DEFINE VAR ac_sign1 AS CHAR FORMAT "X(3)".
DEFINE VAR ac_sign1_item AS CHAR FORMAT "X(62)".
DEFINE VAR ac_type AS CHAR FORMAT "X(22)".
DEFINE VAR ac_um AS CHAR FORMAT "X(12)".
DEFINE VAR ac_cr_dr AS LOGICAL FORMAT "DR/CR". /*AS CHAR FORMAT "x(6)" .*/
DEFINE VAR ac  AS CHAR FORMAT "x(200)".
OUTPUT TO E:\inter\KJKM.TXT.
FOR EACH ac_mstr,EACH ASC_mst  WHERE ac_mstr.ac_code= asc_mstr.asc_acc :
    IF ASC_cc = "" THEN ASSIGN ac_deg = 1 ac_num = '"' + ac_mstr.ac_code +  '"'.
    ELSE 
       ASSIGN ac_num = '"' + ac_mstr.ac_code + "-" + ASC_mstr.ASC_cc + '"' ac_deg = 2.
     FIND FIRST fm_mstr WHERE  asc_mstr.asc_fpos=fm_mstr.fm_fpos . 
         
                     ASSIGN 
                                   ac_desc= '"' + ac_mstr.ac_desc +  '"'
                                   ac_sign1= '"0"'
                                   ac_sign1_item='""'
                                   ac_type ='"'+  fm_mstr.fm_desc + '"'
                                   ac_um='""'
                                   ac_cr_dr = fm_mstr.fm_dr_cr.
                         IF ac_cr_dr THEN 
                             ac= ac_num + " "+ ac_desc + " " + STRING(ac_deg) + " " + ac_sign1 + " "+ ac_sign1_item  + " "+ ac_type + " " + ac_um  + " " + '"' + "DR" + '"' .
                         ELSE
                             ac= ac_num + " "+ ac_desc + " " + STRING(ac_deg) + " " + ac_sign1 + " "+ ac_sign1_item  + " "+ ac_type + " " + ac_um  + " " +  '"' + "CR" + '"' .

   PUT SKIP. 
   PUT UNFORMAT ac.
    
END.
 

OUTPUT CLOSE.
