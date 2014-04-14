
/* a6fcmt01.p - FORECAST MASTER MAINTENANCE                             */
/*V101201.01  ë�����޸�Ϊ������*/
/**************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "101201.01" }  /*GD54*/

DEFINE  NEW  SHARED  VARIABLE  frwrd LIKE  soc_fcst_fwd .
DEFINE  NEW  SHARED  VARIABLE  bck   LIKE  soc_fcst_bck .
DEFINE  VARIABLE  fcsduedate AS  DATE .
DEFINE  VARIABLE  week AS  INTEGER .

DEFINE  NEW  SHARED  VARIABLE  fcs_recid AS  RECID .
DEFINE  NEW  SHARED  VARIABLE  fcrecid   AS  RECID .
DEFINE  NEW  SHARED  VARIABLE  nett LIKE  a6fcs_fcst_qty EXTENT  156.
DEFINE  VARIABLE  sales LIKE  a6fcs_sold_qty.
DEFINE  VARIABLE  net   LIKE  a6fcs_fcst_qty.
DEFINE  VARIABLE  i AS  INTEGER .

DEFINE  NEW  SHARED  VARIABLE  fcs_fcst LIKE  a6fcs_fcst_qty FORMAT  ">>>>,>>9".
DEFINE  NEW  SHARED  VARIABLE  old_fcs_fcst LIKE  a6fcs_fcst_qty FORMAT  ">>>>,>>9".
DEFINE  VARIABLE  del-yn LIKE  mfc_logical .
DEFINE  VARIABLE  desc1  LIKE  pt_desc1.
DEFINE  NEW SHARED VARIABLE  START  AS  DATE  EXTENT  52 .

DEFINE  VARIABLE  ptstatus LIKE  pt_status .
DEFINE  NEW  SHARED  VARIABLE  totals LIKE  fcs_fcst EXTENT  4 .
DEFINE  VARIABLE  inrecno AS  RECID  NO-UNDO .

DEFINE  VARIABLE  disp-forecast AS  CHARACTER  EXTENT  4 NO-UNDO FORMAT  "x(10)".
DEFINE  VARIABLE  disp-week     AS  CHARACTER  EXTENT  4 NO-UNDO FORMAT  "x(5)".
DEFINE  VARIABLE  disp-total    AS  CHARACTER  EXTENT  4 NO-UNDO FORMAT  "x(7)".

 
ASSIGN disp-total = getTermLabelRt("TOTAL", 7).

{fcsdate.i today fcsduedate week global_site}


ASSIGN frwrd = 0 bck = 0.

/*��ȡԤ��������á�����*/
FIND  FIRST  soc_ctrl  WHERE soc_domain = global_domain NO-LOCK  NO-ERROR .
IF  AVAILABLE  soc_ctrl THEN  DO :
   ASSIGN fcsduedate = fcsduedate - 7 * soc_fcst_bck 
          frwrd = soc_fcst_fwd
          bck = soc_fcst_bck.
END . /*IF  AVAILABLE  soc_ctrl THEN  DO :*/


/* calculate start date of forecast year */
{fcsdate1.i YEAR(TODAY) START[1]}

DO  i = 2 TO  52:
   START [i] = START [i - 1]  +  7 .
END .
 
/* DISPLAY SELECTION FORM */
FORM 
   SPACE (1)
   a6fcs_part
   a6fcs_site
   a6fcs_year
   SKIP 
   SPACE (1)
   desc1 NO-LABEL  FORMAT  "x(50)"
WITH  FRAME  a SIDE-LABELS  WIDTH  80 ATTR-SPACE .


/* SET EXTERNAL LABELS */
setFrameLabels(FRAME  a:HANDLE ) .

FORM 

   { mffsmt1a.i  1 14 27 40 }
   { mffsmt1a.i  2 15 28 41 }
   { mffsmt1a.i  3 16 29 42 }
   { mffsmt1a.i  4 17 30 43 }
   { mffsmt1a.i  5 18 31 44 }
   { mffsmt1a.i  6 19 32 45 }
   { mffsmt1a.i  7 20 33 46 }
   { mffsmt1a.i  8 21 34 47 }
   { mffsmt1a.i  9 22 35 48 }
   { mffsmt1a.i 10 23 36 49 }
   { mffsmt1a.i 11 24 37 50 }
   { mffsmt1a.i 12 25 38 51 }
   { mffsmt1a.i 13 26 39 52 }
   { mffsmt1b.i }

WITH  FRAME  b NO-LABELS  WIDTH  80 ATTR-SPACE  TITLE  COLOR  normal
 " " + getTermLabelRt("WEEK",4) + getTermLabelRt("FORECAST",11) +
                getTermLabelRt("WEEK",9) + getTermLabelRt("FORECAST",11) +
                getTermLabelRt("WEEK",9) + getTermLabelRt("FORECAST",11) +
                getTermLabelRt("WEEK",9) + getTermLabelRt("FORECAST",11) + " ".

/* DISPLAY */
VIEW  FRAME  a .

DISPLAY  YEAR (TODAY ) @ a6fcs_year global_site @ a6fcs_site WITH  FRAME  a.
CLEAR  FRAME  b .

DISPLAY  disp-total START  WITH  FRAME  b .

mainloop:
REPEAT  WITH  FRAME  a :
    ASSIGN old_fcs_fcst = 0 .
   PROMPT-FOR  a6fcs_part a6fcs_site a6fcs_year EDITING :

      IF  FRAME-FIELD  = "a6fcs_part" THEN  DO :
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i a6fcs_sum a6fcs_part a6fcs_part
         a6fcs_year "input a6fcs_year" a6fcs_yearpart}
      END .
      ELSE  IF  FRAME-FIELD  = "a6fcs_year" THEN  DO :
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i a6fcs_sum a6fcs_year a6fcs_year a6fcs_year a6fcs_year a6fcs_yearpart}
      END .
      ELSE  DO :
         READKEY .
         APPLY  LASTKEY .
      END .

      IF  recno <> ? THEN  DO :
         desc1 = "".
         FIND  pt_mstr WHERE  pt_domain = global_domain AND pt_part = a6fcs_part NO-LOCK  NO-ERROR  NO-WAIT .
         IF  AVAILABLE  pt_mstr THEN  desc1 = pt_desc1 + " " + pt_desc2.
         DISPLAY  a6fcs_part desc1 a6fcs_site a6fcs_year WITH  FRAME  a .

         IF  a6fcs_year <> YEAR (START [2]) THEN  DO :
            {fcsdate1.i a6fcs_year START[1]}

            DO  i = 2 TO  52:
               START [i] = START [i - 1] + 7.
            END .
            DISPLAY  START  WITH  FRAME  b.
         END .

         totals = 0.


      ASSIGN fcrecid = recid(a6fcs_sum).
      {gprun.i ""a6fcmt02.p""}
         
         DISPLAY  fcs_fcst totals WITH  FRAME  b.
      END .
         DO i = 1 TO 52 :
            ASSIGN   old_fcs_fcst[i] = fcs_fcst [i] .
         END.
   END .   /* PROMPT-FOR...EDITING */

  IF  AVAILABLE  si_mstr THEN  DO :
    {gprun.i ""gpsiver.p""  "(input si_site, input recid(si_mstr), output return_int)"}
  END .
  ELSE  DO :
    {gprun.i ""gpsiver.p"" "(input (input a6fcs_site), input ?, output return_int)"}
  END .
  IF  return_int = 0 THEN  DO :
    {mfmsg.i 725 3} /*USER DOES NOT HAVE ACCESS TO THIS SITE*/
     NEXT-PROMPT  a6fcs_site.
     UNDO  mainloop, RETRY .
  END .

 FIND  si_mstr WHERE si_domain = global_domain AND  si_site = INPUT  a6fcs_site NO-LOCK  NO-ERROR .
 IF  AVAILABLE  si_mstr AND  si_db <> global_db THEN  DO :
    {mfmsg.i 5421 3}
    UNDO  mainloop, RETRY .
 END .

   /* ADD/MOD/DELETE */
   desc1 = "".
   FIND  pt_mstr WHERE pt_domain = global_domain AND  pt_part = INPUT  a6fcs_part NO-LOCK  NO-ERROR  NO-WAIT .
   IF  AVAILABLE  pt_mstr THEN  desc1 = pt_desc1 + " " + pt_desc2.


   FIND  a6fcs_sum USING  a6fcs_part AND  a6fcs_site AND  a6fcs_year EXCLUSIVE-LOCK  NO-ERROR .
   IF  NOT  AVAILABLE  a6fcs_sum THEN  DO :
        ASSIGN ptstatus = pt_status 
               SUBSTRING (ptstatus,9,1) = "#".
         IF  CAN-FIND (isd_det WHERE isd_domain = global_domain AND   isd_status = ptstatus AND  isd_tr_type = "ADD-FC" ) THEN  DO :
             /*hill-temp  {mfmsg02.i 358 3 pt_status} */
             UNDO  mainloop, RETRY .
         END .

      {mfmsg.i 1 1}
      CREATE  a6fcs_sum.
      ASSIGN  
              a6fcs_part = caps(input a6fcs_part)
              a6fcs_site
              a6fcs_year
              a6fcs_domain = global_domain
               .
   END .

  IF  NOT  CAN-FIND (in_mstr WHERE in_domain = global_domain AND  in_part = a6fcs_part AND  in_site =  a6fcs_site) THEN  DO :

     /*J1PS*     pt_rctwo_status, inrecno AS THE LAST PARAMETERS.         */
     {gprun.i ""gpincr.p"" "(INPUT   yes,
                             INPUT   pt_part,
                             INPUT   si_site,
                             INPUT   si_gl_set,
                             INPUT   si_cur_set,
                             INPUT   pt_abc,
                             INPUT   pt_avg_int,
                             INPUT   pt_cyc_int,
                             INPUT   pt_rctpo_status,
                             INPUT   pt_rctpo_active,
                             INPUT   pt_rctwo_status,
                             INPUT   pt_rctwo_active,
                             OUTPUT  inrecno)" }
  END .

   ASSIGN ststatus = stline[2] .
   STATUS  INPUT  ststatus .
   del-yn = NO .
   fcs_recid = RECID (a6fcs_sum).

   /* SET GLOBAL ITEM VARIABLE */
   global_part = a6fcs_part.

   DISPLAY  desc1 WITH  FRAME  a.

   IF  a6fcs_year <> YEAR (START [2]) THEN  DO :
      {fcsdate1.i a6fcs_year START[1]}

      DO  i = 2 TO  52:
         START [i] = START [i - 1] + 7.
      END .
   END .

   totals = 0.


    fcrecid = RECID (a6fcs_sum).
    {gprun.i ""a6fcmt02.p""}

     DISPLAY  START  fcs_fcst totals WITH  FRAME  b .

   DO  ON  ERROR  UNDO , RETRY  WITH  FRAME  b:
      SET  fcs_fcst GO-ON  ("F5" "CTRL-D") WITH  FRAME  b.

      /* DELETE */
      IF  LASTKEY  = KEYCODE ("F5") OR  LASTKEY  = KEYCODE ("CTRL-D") THEN  DO :
         ASSIGN del-yn = YES .
         {mfmsg01.i 11 1 del-yn}
         IF  NOT  del-yn THEN  UNDO , RETRY .
      END .
      DO  i = 1 TO  52 :
           /*V101201.01 added */
         a6fcs_fcst_qty[i] = fcs_fcst[i] + a6fcs_sold_qty [i].
         /*IF fcs_fcst[i] = 0  THEN DO :  */
             FOR EACH a6fcd_det WHERE a6fcd_domain =  global_domain AND a6fcd_part = a6fcs_part AND a6fcd_site = a6fcs_site AND a6fcs_year = a6fcd_year AND a6fcd_week = i :
                 DELETE a6fcd_det .
             END.
      /*   END. */
      /*hill 2007-07-21 -beg 
         IF fcs_fcst[i] <> 0  THEN  DO: 
             /* IF old_fcs_fcst[i] = 0 THEN DO:  */
                 /*���ݲ�Ʒ�ṹ �������� ���ϼƻ����� ,�ֽ�ͻ�����...*/         
                     {gprun.i ""a6bommt.p"" "(
                             INPUT a6fcs_part ,
                             INPUT a6fcs_site ,
                             INPUT START[i] ,
                             INPUT ''  ,
                             INPUT i ,
                             INPUT START[i] ,
                             INPUT fcs_fcst[i]  ,
                             INPUT a6fcs_year  
                             
                         )" }
          
             END.
         hill 2007-07-21 - END  */
      END .
      IF  del-yn THEN  DO :
          a6fcs_fcst_qty = 0 .
          
          FOR EACH a6fcd_det WHERE a6fcd_domain = global_domain AND a6fcd_part = a6fcs_part AND a6fcd_site = a6fcs_site AND a6fcs_year = a6fcd_year :
                 DELETE a6fcd_det .
          END.

      END. /*IF  del-yn THEN  DO :*/
      {gprun.i ""a6fcfsre.p""}
/*
      DO  i = 1 TO  52:

          IF  i > 52 - bck THEN  DO :
            IF  START [i] - 364 < fcsduedate THEN  nett[i] = 0.
 
            {gprun1.i ""a6fmrwfs.p""
                     "(input ""fcs_sum"",
                       INPUT  a6fcs_part,
                       INPUT  STRING (a6fcs_year - 1) + a6fcs_site,
                       INPUT  STRING (i),
                       INPUT  """", 
                       INPUT  ?,
                       INPUT  (START [i] - 364),
                       INPUT  nett[i],
                       INPUT  ""DEMAND"",
                       INPUT  ""FORECAST"",
                       INPUT  a6fcs_site ,
                       INPUT  a6fcs_year
                
                )" }
           END . /* IF  i > 52 - bck THEN  DO : */

            IF START [i] < fcsduedate THEN  nett[i + 52] = 0.

            {gprun1.i ""a6fmrwfs.p""
                      "(INPUT ""fcs_sum"",
                       INPUT  a6fcs_part,
                       INPUT  STRING (a6fcs_year) + a6fcs_site,
                       INPUT  STRING (i),
                       INPUT  """",
                       INPUT  ?,
                       INPUT  START [i],
                       INPUT  nett[i + 52],
                       INPUT  ""DEMAND"",
                       INPUT  ""FORECAST"",
                       INPUT  a6fcs_site ,
                       INPUT  a6fcs_year
                )" }


         IF  i <= frwrd THEN  DO :
            IF  START [i] + 364 < fcsduedate THEN  nett[i + 104] = 0.
/*
             {gprun1.i ""a6fmrwfs.p"" 
                       "(input ""fcs_sum"",
                       INPUT  a6fcs_part,
                       INPUT  STRING (a6fcs_year + 1) + a6fcs_site,
                       INPUT  STRING (i),
                       INPUT  """",
                       INPUT  ?,
                       INPUT  (START [i] + 364),
                       INPUT  nett[i + 104],
                       INPUT  ""DEMAND"",
                       INPUT  ""FORECAST"",
                       INPUT  a6fcs_site ,
                       INPUT  a6fcs_year
                 )" }
                 */
         END . /*IF  i <= frwrd THEN  DO :*/
      END . /* DO  i = 1 TO  52: */
*/
        IF  del-yn THEN  DO :
           DO  i = 1 TO  52:
              IF  NOT  del-yn THEN  LEAVE .
              IF  a6fcs_sold_qty[i] <> 0  /* OR  fcs_abnormal[i] <> 0   OR  fcs_pr_fcst[i] <> 0  */ THEN  del-yn = NO .
           END . /*DO  i = 1 TO  52:*/

           IF  del-yn THEN  DELETE  a6fcs_sum .
               del-yn = NO .
           NEXT  mainloop.
        END .  /*IF  del-yn THEN  DO :*/
   END . /*DO  ON  ERROR  UNDO , RETRY  WITH  FRAME  b:*/

/*FR51*/ /* start of added section */

   totals = 0.


/*FR51*/ fcrecid = recid(a6fcs_sum).
       {gprun.i ""a6fcmt02.p""}

   DISPLAY  START  fcs_fcst totals WITH  FRAME  b .

/*FR51*/ /* end of added section */

END . /*mainloop:*/
status input.
