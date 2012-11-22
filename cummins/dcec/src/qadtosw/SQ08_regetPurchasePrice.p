{mfdeclre.i}
DEFINE VAR x_data AS CHAR EXTENT 6 FORMAT "X(20)".
DEFINE VAR listfile AS CHAR.
DEFINE VAR flpath AS CHAR FORMAT "X(30)".
DEFINE VAR SQ07_name AS CHAR FORMAT "X(30)".
DEFINE VAR v_pur_price LIKE prh_pur_cost.
DEFINE VAR v_date_string AS CHAR.
DEFINE VAR mfile  AS CHAR.
DEFINE VAR desc2 LIKE pt_desc2.

DEFINE VAR filename1 AS CHAR.
DEFINE WORKFILE list
    FIELD filename2 AS CHAR FORMAT "x(40)".

DEFINE STREAM src.
DEFINE STREAM mfile.
DEFINE TEMP-TABLE xx_wkfl
    FIELD receip LIKE  prh_receiver
    FIELD re_line LIKE prh_receiver
    FIELD part LIKE prh_part
    FIELD desc2 LIKE pt_desc2.


flpath = "\\dcecssy142\QAD\SQ07\".

FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = 'srmpath1' NO-LOCK NO-ERROR.
listfile = flpath + "list.txt".

mfile  = "SQ08\SQ08_" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"999999") + ".txt".



DOS SILENT VALUE("dir /b " + flpath + " > " + listfile).

INPUT STREAM mfile FROM VALUE(listfile).
REPEAT:
    IMPORT STREAM mfile DELIMITER "," FILENAME1.
    CREATE list.
    ASSIGN list.FILENAME2 = FILENAME1.

END.

FOR EACH list WHERE SUBSTRING(list.filename2,1,5) = "SQ07_".
    SQ07_name = list.filename2.
END.

/*
DISP SQ07_name.*/


FOR EACH xx_wkfl.
    DELETE xx_wkfl.
END.
OUTPUT CLOSE.

flpath = flpath + SQ07_name.


INPUT STREAM src FROM VALUE(flpath).

REPEAT:
    IMPORT STREAM src DELIMITER "|" x_data.
    CREATE xx_wkfl.
    ASSIGN receip = x_data[1]
           re_line = x_data[2]
           part = x_data[3]
           desc2 = x_data[4].
END.


INPUT STREAM src CLOSE.


OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET "UTF-8" SOURCE 'GB2312'.
FOR EACH xx_wkfl.
    FIND FIRST prh_hist WHERE prh_domain = global_domain and prh_receiver = receip AND prh_line = INT(re_line) NO-LOCK NO-ERROR.
    IF AVAIL prh_hist THEN DO:

       FIND LAST pc_mstr WHERE pc_domain = global_domain and pc_part = prh_part AND pc_list = prh_vend AND pc_start <> 01/01/01 AND (pc_expire >= prh_rcp_date  OR pc_expire = ?) NO-LOCK NO-ERROR.
       IF AVAIL pc_mstr  THEN v_pur_price = pc_amt[1].  /*prh_pur_cost*/
       ELSE v_pur_price = 0.

       v_date_string = STRING(YEAR(prh_rcp_date),"9999") + "-" + STRING(MONTH(prh_rcp_date),"99") + "-" +  STRING(DAY(prh_rcp_date),"99").


      FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = prh_part NO-LOCK NO-ERROR.
      IF AVAIL pt_mstr THEN desc2 = pt_desc2.
      ELSE  desc2 = "". 

      PUT UNFORMATTED UPPER(prh_receiver) "|".
      PUT UNFORMATTED prh_line "|".
      PUT UNFORMATTED UPPER(prh_part) "|".
      PUT UNFORMATTED UPPER(desc2) "|".
      PUT UNFORMATTED prh_rcvd "|".
      PUT UNFORMATTED v_date_string "|".
      PUT UNFORMATTED v_pur_price "|".
      PUT UNFORMATTED prh_rcvd * v_pur_price "|".
      PUT UNFORMATTED UPPER(prh_curr) SKIP.
   END.

END.


DOS SILENT VALUE("del  " + flpath ).
QUIT.
