
/*a6simmt.p �͑���؛������Ӌ��.*/

{mfdtitle.i "130718.1"}

/*���x׃��....*/
DEFINE  VARIABLE site      LIKE  a6rq_site   .
DEFINE  VARIABLE part      LIKE  pt_part     .
DEFINE  VARIABLE desc1     LIKE  pt_desc1    .
DEFINE  VARIABLE proc_flag AS    CHAR FORMAT "x(8)" .
DEFINE  VARIABLE qty_oh    AS DECIMAL FORMAT ">>>>>,>>9.<<".
DEFINE  VARIABLE past_date LIKE wo_rel_date .
DEFINE  VARIABLE lt_date   LIKE wo_rel_date .
DEFINE  VARIABLE sfty_date LIKE wo_rel_date .
DEFINE  VARIABLE  interval AS INTEGER INIT 0 .
DEFINE  VARIABLE sfty_time LIKE pt_sfty_time .
DEFINE  VARIABLE insp_lead LIKE pt_insp_lead .
DEFINE  VARIABLE leadtime  LIKE pt_pur_lead .
DEFINE  VARIABLE insp_rqd  LIKE pt_insp_rqd .
DEFINE  VARIABLE curr_pono LIKE a6rq_custpono .
DEFINE  VARIABLE curr_poln AS INTEGER .
DEFINE  VARIABLE curr_cust LIKE a6rq_cust .
DEFINE  VARIABLE SHORT_qty LIKE a6rqd_short_qty INIT 0  .
DEFINE  VARIABLE rel_date  LIKE wo_rel_date .
DEFINE  VARIABLE due_date  LIKE wo_rel_date .
DEFINE  VARIABLE i         AS INTEGER INIT 1 .
DEFINE  VARIABLE rrd_sort  AS INTEGER INIT 0 .
DEFINE  VARIABLE starttime AS CHAR FORMAT 'x(10)' .
DEFINE  VARIABLE currtime  AS CHAR FORMAT 'x(10)'  .
DEFINE  VARIABLE taskname  AS CHAR FORMAT 'x(40)' .
DEFINE  VARIABLE itemno    LIKE pt_part  .
DEFINE  VARIABLE AV_STOCK  LIKE  a6rqd_short_qty INIT 0  .
DEFINE VARIABLE hour AS INTEGER.

DEFINE VARIABLE minute AS INTEGER.

DEFINE VARIABLE sec AS INTEGER.
        DEFINE VARIABLE timeleft AS INTEGER.


/*���x�R�r���...*/
DEFINE TEMP-TABLE tpart_det
       FIELD tpart_site  LIKE wo_site
       FIELD tpart_part  LIKE mrp_part
       FIELD tpart_past_date   LIKE wo_rel_date
       FIELD tpart_lt_date   LIKE wo_rel_date
       FIELD tpart_sfty_date LIKE wo_rel_date
       FIELD tpart_qty_oh   AS DECIMAL FORMAT "->>>>>>>,>>9.<<"
       FIELD tpart_sfty_time  LIKE pt_sfty_time
       FIELD tpart_insp_lead  LIKE pt_insp_lead
       FIELD tpart_leadtime   LIKE pt_pur_lead
       FIELD tpart_pmcode     LIKE a6rqd_pmcode
       .

DEFINE TEMP-TABLE tmrp_det
       FIELD tmrp_site  LIKE wo_site
       FIELD tmrp_part   LIKE mrp_part
       FIELD tmrp_qty    AS  DECIMAL FORMAT ">>>>>,>>9.<<"
       FIELD tmrp_type   AS CHAR FORMAT 'x(8)'
       FIELD tmrp_sim    AS CHAR FORMAT 'x(1)'
       FIELD tmrp_rel_date LIKE wo_rel_date
       FIELD tmrp_due_date LIKE wo_due_date
       FIELD tmrp_due_date1 LIKE wo_due_date
       FIELD tmrp_ord_type AS CHAR FORMAT 'x(12)'
       FIELD tmrp_ord_nbr  LIKE wo_nbr
       FIELD tmrp_ord_id   LIKE wo_lot
       FIELD tmrp_cust     LIKE a6rq_cust
       INDEX mrppart tmrp_part tmrp_due_date tmrp_sim ASCENDING .
FUNCTION getMsg RETURNS character(inbr as integer) forward.
/*���xFrames... */
FORM
   site      COLON 30
WITH FRAME a WIDTH 80 SIDE-LABELS ATTR-SPACE .
/* SET EXTERNAL LABELS */
setFrameLabels(FRAME  a:HANDLE ) .
/*
FORM
   part   AT 20
   desc1  AT 40
   proc_flag  AT 60
WITH FRAME b WIDTH 80 SIDE-LABELS ATTR-SPACE .
*/
FORM
    taskname   COLON 30
    /* starttime COLON 10  .
    itemno    COLON 10  .
    currtime  COLON 10  .
    */
WITH FRAME b WIDTH 80 SIDE-LABELS ATTR-SPACE .
setFrameLabels(FRAME  b:HANDLE ) .

/* setFrameLabels( FRAME  b: HANDLE ) . */
empty temp-table tpart_det no-error.
empty temp-table tmrp_det no-error.
REPEAT  WITH  FRAME  a :
    /*CLEAR FRAME b NO-PAUSE . */

    SET site  .
    /*��ȡ���ƙn....*/
    FIND a6rc_cot NO-LOCK NO-ERROR .



    ASSIGN taskname = getmsg(7802). /* '������ȡ�����������...' . */
    DISP taskname   WITH FRAME b .

    /*��ȡ�����������..*/
    FOR EACH a6rqd_det WHERE a6rqd_site = site AND a6rqd_run = YES NO-LOCK
             USE-INDEX itemdate BREAK BY a6rqd_part :
        IF FIRST-OF(a6rqd_part) THEN DO:
           /*��ȡ����Ӌ������...*/
           ASSIGN interval = 0 sfty_time = 0 insp_rqd = NO insp_lead = 0 leadtime = 0 past_date = ? LT_Date = ? sfty_date = ? .
           FIND  ptp_det  WHERE  ptp_part = a6rqd_part AND  ptp_site = site NO-LOCK NO-ERROR .
           IF AVAILABLE  ptp_det THEN
                 ASSIGN  sfty_time = ptp_sfty_tme
                         insp_rqd  = ptp_ins_rqd
                         insp_lead = ptp_ins_lead
                         leadtime  = IF a6rqd_pmcode = 'p' THEN ptp_pur_lead
                                                          ELSE ptp_mfg_lead.
           ELSE  DO:
                FIND pt_mstr NO-LOCK WHERE pt_part =  a6rqd_part NO-ERROR .
                IF AVAILABLE pt_mstr THEN
                      ASSIGN sfty_time = pt_sfty_time
                             insp_rqd  = pt_insp_rqd
                             insp_lead = pt_insp_lead
                             leadtime  = IF a6rqd_pmcode = 'p' THEN pt_pur_lead
                                                               ELSE pt_mfg_lead.
           END. /*IF AVAILABLE  ptp_det THEN ..ELSE  ...*/

           /*Ӌ���^����������...*/
           ASSIGN  past_date = TODAY  interval = a6rc_past_offset .
             {a6cawkdt.i past_date  1 site  interval  'M' }

           /*Ӌ��Σ�U����*/
           ASSIGN  lt_date = past_date  interval = leadtime  .
             {a6cawkdt.i lt_date  1 site  interval  a6rqd_pmcode }

         /*Ӌ�㰲ȫ����*/
           ASSIGN  sfty_date = lt_date    .
           IF a6rc_safty_type = 'N' THEN interval = 0 .
           ELSE DO:
           IF a6rc_safty_type = 'D' THEN interval = a6rc_safty_offset .
           IF a6rc_safty_type = 'P' THEN interval = leadtime * ( 1 + a6rc_safty_offset / 100 ) .
           IF a6rc_safty_type = 'S' THEN interval = sfty_time .
           IF insp_rqd THEN ASSIGN interval = interval + insp_lead .
           {a6cawkdt.i sfty_date  1 site  interval  'M' }
           END.  /*ELSE DO:....*/

         /*��ȡԓ����֮��ǰ���...*/
             ASSIGN qty_oh = 0 .
             FIND in_mstr WHERE in_part = a6rqd_part AND in_site = site NO-LOCK NO-ERROR.
             IF AVAILABLE IN_mstr THEN  qty_oh = in_qty_oh .

           /*���������������..*/
           CREATE tpart_det .
           ASSIGN tpart_site      =  site
                  tpart_part      =  a6rqd_part
                  tpart_past_date =  past_date
                  tpart_lt_date   =  LT_date
                  tpart_sfty_date =  sfty_date
                  tpart_qty_oh    = qty_oh
                  tpart_sfty_time = sfty_time
                  tpart_insp_lead =  IF  insp_rqd THEN  insp_lead ELSE  0
                  tpart_leadtime  = leadtime
                  tpart_pmcode    = a6rqd_pmcode
               .

        END.  /*IF FIRST-OF(a6rqd_part) THEN DO:*/
    END. /*FOR EACH a6rqd_det WHERE a6rqd_site = site AND ...*/

    ASSIGN taskname = getmsg(7803). /* '�������ݔ����ρ�...' . */
    DISP taskname  WITH FRAME b .

    /*�������ݔ��ݺϲ�..*/
    FOR EACH tpart_det WHERE tpart_site = site NO-LOCK :
        /*���ѽ����ڵ��Y������ȡ....*/
        FOR EACH a6rqd_det WHERE a6rqd_site = site AND a6rqd_part = tpart_part NO-LOCK :
               IF ( (NOT a6rqd_run)  AND a6rqd_due_date <= tpart_sfty_date ) OR (a6rqd_run)   THEN DO:
                CREATE tmrp_det .
                ASSIGN
                              tmrp_site       = site
                              tmrp_part       = a6rqd_part
                              tmrp_qty        = a6rqd_rq_qty
                              tmrp_type       = 'DEMAND'
                              tmrp_sim        = IF a6rqd_run  THEN '2' ELSE '1'
                              tmrp_rel_date   = a6rqd_rel_date
                              tmrp_due_date   = a6rqd_rq_date
                              tmrp_due_date1  = a6rqd_due_date
                              tmrp_ord_type   = 'CPO'
                              tmrp_ord_nbr    = a6rqd_custpono
                              tmrp_ord_id     = STRING(a6rqd_custpoln)
                              tmrp_cust       = a6rqd_cust
                    .
                 END.
        END. /*FOR EACH a6rqd_det WHERE a6rqd_site = site AND a6rqd_part = tpart_part..*/

        /*�Į�ǰ����Ӌ�����Y������ȡ....*/
        FOR EACH mrp_det WHERE mrp_part = tpart_part AND
                               mrp_due_date <= tpart_sfty_date AND
                               mrp_site = site NO-LOCK USE-INDEX mrp_partdate :
                 CREATE tmrp_det .
                 ASSIGN
                               tmrp_site       = site
                               tmrp_part       = mrp_part
                               tmrp_qty        = mrp_qty
                               tmrp_type       = mrp_type
                               tmrp_sim        = '1'
                               tmrp_rel_date   = mrp_rel_date
                               tmrp_due_date   = mrp_due_date
                               tmrp_ord_type   = mrp_dataset
                               tmrp_ord_nbr    = mrp_nbr
                               tmrp_ord_id     = STRING(mrp_line)
                               tmrp_cust       = ''.

        END. /*FOR EACH mrp_det WHERE   mrp_part = tpart_part ....*/

    END.  /*FOR EACH tpart_det WHERE tpart_site = site NO-LOCK :*/

    ASSIGN taskname = getmsg(7804). /* '��ʼ�������P���...' . */
    DISP taskname  WITH FRAME b .

    /*��ʼ�������P���.. */
    FOR EACH a6rq_mstr WHERE a6rq_site = site  AND a6rq_run NO-LOCK :
       FOR EACH a6rrd_det WHERE a6rrd_site = a6rq_site AND a6rrd_cust = a6rq_cust AND a6rrd_custpono = a6rq_custpono AND a6rrd_custpoln = a6rq_custpoln :
             DELETE a6rrd_det .
       END. /* FOR EACH a6rrd_det WHERE a6rrd_site = a6rq_site AND a6rrd_custpono = a6rq_custpono AND a6rrd_custpoln = a6rq_custpoln : */
    END. /*FOR EACH a6rq_mstr WHERE a6rq_site = site AND a6rq_status = 's' NO-LOCK :*/



    ASSIGN taskname = getmsg(7800). /* '�������������M��.....' . */
    DISP taskname  WITH FRAME b .

            /*�͑���������Ӌ��...�^��...*/
    FOR EACH tpart_det WHERE tpart_site  = site NO-LOCK :

          ASSIGN taskname = STRING(tpart_part) + getmsg(7801). /* ' ����Ӌ����......' . */
          DISP taskname   WITH FRAME b .

        /*��ȡ�AӋ��ǰ�Ď��...*/
        ASSIGN qty_oh = tpart_qty_oh  .
        FOR EACH tmrp_det WHERE tmrp_part = tpart_part AND  tmrp_due_date <= tpart_past_date AND tmrp_sim = '1' AND tmrp_site = site   NO-LOCK :
            IF tmrp_type = 'DEMAND' THEN ASSIGN qty_oh = qty_oh - tmrp_qty .
            ELSE ASSIGN qty_oh = qty_oh + tmrp_qty .
        END.
          /* DISP tpart_det . */
        /*�_ʼ����...*/
        IF qty_oh < 0 THEN qty_oh = 0 .
        FOR EACH tmrp_det WHERE tmrp_part = tpart_part AND tmrp_site = site NO-LOCK BY tmrp_due_date  BY tmrp_sim     :

           /* DISP tmrp_Det . */
            /*̎��ģ�M����..*/
               IF tmrp_sim = '2' THEN DO:
                   ASSIGN qty_oh = qty_oh - tmrp_qty .
                   IF qty_oh < 0 THEN DO:
                       ASSIGN AV_STOCK  = 0 .
                      IF tmrp_due_date1 <= tpart_past_date  THEN DO:
                          /*Hill-added.......�����^�ڔ���..a6rqd_det*/
                          IF ABS (qty_oh) <> tmrp_qty THEN ASSIGN curr_pono = tmrp_ord_nbr curr_cust = tmrp_cust curr_poln = INT (tmrp_ord_id)  .
                          ASSIGN   SHORT_qty = ABS (qty_oh)   qty_oh = 0 .
                      {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 2  tmrp_cust AV_STOCK }
                      END.
                      ELSE IF  tmrp_due_date1 <= tpart_lt_date  THEN DO:
                          IF ABS (qty_oh) <> tmrp_qty THEN ASSIGN  curr_pono = tmrp_ord_nbr curr_cust = tmrp_cust curr_poln = INT (tmrp_ord_id)  .
                          ASSIGN  SHORT_qty = ABS (qty_oh) qty_oh = 0  .
                               /*Hill-added.......����Ƿ�υ^����..a6rqd_det*/
                               {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 4  tmrp_cust  AV_STOCK }
                          END.
                      ELSE IF tmrp_due_date1 <= tpart_sfty_date  THEN DO:
                          IF ABS (qty_oh) <> tmrp_qty THEN ASSIGN curr_pono = tmrp_ord_nbr curr_cust = tmrp_cust curr_poln = INT (tmrp_ord_id)  .
                          ASSIGN  SHORT_qty = ABS (qty_oh) qty_oh = 0 .
                               /*Hill-added.......����Ƿ�υ^����..a6rqd_det*/
                               {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 6 tmrp_cust AV_STOCK }
                           END.
                      ELSE DO:
                               /*Hill-added.......����Ƿ�υ^����..a6rqd_det*/
                               {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 7  tmrp_cust AV_STOCK }
                           END.

                   END.  /*��治��*/
                   ELSE  DO:
                       ASSIGN  SHORT_qty =  0  AV_STOCK  =  qty_oh .
                       IF tmrp_due_date1 <= tpart_past_date  THEN DO:
                           /*Hill-added.......�����^�ڔ���..a6rqd_det*/
                       {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 1  tmrp_cust AV_STOCK }
                       END.
                       ELSE IF  tmrp_due_date1 <= tpart_lt_date  THEN DO:
                                /*Hill-added.......����Ƿ�υ^����..a6rqd_det*/
                                {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 3 tmrp_cust AV_STOCK }
                            END.
                       ELSE IF tmrp_due_date1 <= tpart_sfty_date  THEN DO:
                                /*Hill-added.......����Ƿ�υ^����..a6rqd_det*/
                                {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 5 tmrp_cust AV_STOCK }
                            END.
                       ELSE DO:
                                /*Hill-added.......����Ƿ�υ^����..a6rqd_det*/
                                {a6rqddet.i tmrp_ord_nbr int(tmrp_ord_id) tpart_part 7 tmrp_cust AV_STOCK }
                            END.
                   END.  /*������*/
               END.
               ELSE DO:
                   IF tmrp_due_date > tpart_past_date  THEN DO:

                       IF tmrp_type = 'DEMAND'THEN  DO:
                          ASSIGN qty_oh = qty_oh - tmrp_qty AV_STOCK =  qty_oh .
                          IF qty_oh < 0 THEN DO:
                              ASSIGN  SHORT_qty = ABS (qty_oh) qty_oh = 0   AV_STOCK = 0 .

                              IF tmrp_ord_type = 'CPO' THEN DO:
                                  /*Ӌ��wo_due_date*/
                                  ASSIGN rel_date = tmrp_due_date1  interval =  tpart_leadtime  .
                                  {a6cawkdt.i rel_date -1 site interval  'm' }
                                  IF tmrp_due_date1 <= tpart_past_date THEN DO:
                                        /*hill-added....����...a6rrd_det..*/
                                        {a6rrddet.i curr_pono curr_poln tpart_part 2  curr_cust AV_STOCK }
                                  END.
                                  ELSE IF  tmrp_due_date1 <= tpart_lt_date  THEN DO:
                                        /*hill-added....����...a6rrd_det..*/
                                        {a6rrddet.i curr_pono curr_poln tpart_part 4 curr_cust AV_STOCK }

                                        END.
                                        ELSE IF tmrp_due_date1 <= tpart_sfty_date  THEN DO:
                                             /*hill-added....����...a6rrd_det..*/
                                             {a6rrddet.i curr_pono curr_poln tpart_part 6 curr_cust AV_STOCK }
                                             END.

                              END.
                              ELSE DO:
                                        /*Ӌ��wo_due_date*/
                                       ASSIGN due_date = tmrp_due_date  interval =  tpart_sfty_time +  tpart_insp_lead .
                                       {a6cawkdt.i due_date -1 site interval  'm' }

                                      /*Ӌ��wo_rel_date*/
                                       ASSIGN  rel_date = due_date interval = tpart_leadtime  .
                                       {a6cawkdt.i rel_date -1 site interval  tpart_pmcode }

                                       IF  due_date <= tpart_past_date  THEN DO:
                                          /*hill-added....����...a6rrd_det..*/
                                          {a6rrddet.i curr_pono curr_poln tpart_part 2 curr_cust AV_STOCK }
                                       END.
                                       ELSE IF  due_date <= tpart_lt_date  THEN DO:
                                       /*hill-added....����...a6rrd_det..*/
                                       {a6rrddet.i curr_pono curr_poln tpart_part 4 curr_cust AV_STOCK }
                                      END.
                                      ELSE IF due_date <= tpart_sfty_date  THEN DO:
                                       /*hill-added....����...a6rrd_det..*/
                                       {a6rrddet.i curr_pono curr_poln tpart_part 6 curr_cust AV_STOCK }
                                      END.

                              END.  /*ELSE ...*/
                          END. /*��治��*/
                       END.
                       ELSE ASSIGN qty_oh = qty_oh + tmrp_qty .
                   END.  /*��Ч�A�y�^��*/

               END.


        END.  /*FOR EACH tmrp_det WHERE tmrp_part = tpart_part NO-LOCK BY tmrp_due_date :*/

    END. /*FOR EACH tpart_det WHERE tpart_site  = site NO-LOCK :*/

     ASSIGN taskname = getmsg(7805). /* '��������Ӌ��...���! ' . */
     DISP taskname  WITH FRAME b .


END.  /*REPEAT  WITH  FRAME  a :*/

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = "CH" and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return string(inbr).
  end.
END FUNCTION. /*FUNCTION getMsg*/
