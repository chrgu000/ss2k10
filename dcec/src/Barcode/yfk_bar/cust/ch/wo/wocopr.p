{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/

DEFINE VARIABLE tdate LIKE b_wo_date LABEL "�´�����".
DEFINE VARIABLE tline LIKE b_wo_line LABEL "������".
DEFINE VARIABLE tshift LIKE b_wo_shift LABEL "���".

DEFINE BUTTON btn_quit LABEL "�˳�".
DEFINE BUTTON btn_disp LABEL "��ʾ".
DEFINE BUTTON btn_print LABEL "��ӡ".
DEFINE BUTTON btn_prtindv LABEL "��ӡ��������".

DEFINE QUERY q_wod FOR b_wod_det.
DEFINE QUERY q_wo FOR b_wo_mstr.
DEFINE BROWSE b_wo QUERY q_wo
    DISP 
    b_wo_batch LABEL "����"
    b_wo_date LABEL "����"
    b_wo_part LABEL "���"
    b_wo_shift LABEL "���"
    b_wo_line LABEL "������"
    b_wo_qty LABEL "����"
    WITH 5 DOWN WIDTH 79
    TITLE "".
DEFINE BROWSE b_wod QUERY q_wod
    DISPLAY
     b_wod_batch LABEL "����"
     b_wod_line LABEL "������"
     b_wod_shift LABEL "���"
     b_wod_part LABEL "���"
     b_wod_code LABEL "����"
     b_wod_status LABEL "״̬"
     b_wod_printed LABEL "��ӡ״̬"
    WITH 10 DOWN WIDTH 79 
    TITLE "��Ʒ���Ʒ�����ӡ".

DEFINE FRAME a
    tdate  tshift SKIP
    b_wo SKIP(1.1)
    b_wod SKIP
     btn_print btn_prtindv btn_disp btn_quit
    WITH WIDTH 80 THREE-D SIDE-LABEL.

ON 'enter':U OF tdate
DO:
    ASSIGN tdate.
    SET tshift WITH FRAME a.
    /*OPEN QUERY q_wo FOR EACH b_wo_mstr WHERE b_wo_date = tdate.*/
    RETURN.
END.

ON 'enter':U OF tshift
DO:
    ASSIGN tdate tshift.
    OPEN QUERY q_wo FOR EACH b_wo_mstr WHERE b_wo_date = tdate AND b_wo_shift = tshift.
    RETURN.
END.

ON 'MOUSE-SELECT-CLICK':U OF b_wo
DO:
    OPEN QUERY q_wod FOR EACH b_wod_det WHERE b_wod_batch = b_wo_mstr.b_wo_batch 
        AND b_wod_part = b_wo_mstr.b_wo_part.
    RETURN.
END.

ON 'choose':U OF btn_prtindv
DO:
    {bcgetprt.i}
    {gprun.i ""bccopr.p"" "(input b_wod_det.b_wod_code, input ""FUL"", input pname, input no)"}
    DEFINE VARIABLE X LIKE b_wod_code.
    X =  b_wod_det.b_wod_code.
    FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = X NO-ERROR.
      IF b_co_status = "FINI-CRE" THEN
                                               b_co_status = "FINI-REL".
    FIND FIRST b_wod_det EXCLUSIVE-LOCK WHERE b_wod_code = X NO-ERROR.
    b_wod_det.b_wod_printed = YES.
    OPEN QUERY q_wod FOR EACH b_wod_det WHERE b_wod_batch = b_wo_mstr.b_wo_batch 
        AND b_wod_part = b_wo_mstr.b_wo_part.
    RETURN.
END.


ON 'choose':U OF btn_disp
DO:
    ASSIGN tdate  tshift.
    IF tdate = ? THEN DO:
        tdate = low_date.
        FOR EACH b_wo_mstr WHERE b_wo_date >= tdate:
            MESSAGE b_wo_date.
            OPEN QUERY q_co FOR EACH b_wod_det WHERE b_wod_batch = b_wo_batch
                   /*AND (b_wo_line >= tline) AND (b_wo_shift >= tshift)*/.
        END.
    END.
    ELSE DO:
        FOR EACH b_wo_mstr WHERE b_wo_date = tdate:
            OPEN QUERY q_co FOR EACH b_wod_det 
                   WHERE b_wod_batch = b_wo_batch AND (b_wo_line >= tline) AND (b_wo_shift >= tshift).
        END.
    END.


    RETURN.
END.

ON 'choose':U OF btn_print
DO:
   ASSIGN tdate  tshift.
   DEFINE VARIABLE X AS INTEGER.
   X = b_wo_mstr.b_wo_batch.
   IF X = ? THEN RETURN.
    FOR FIRST b_wo_mstr WHERE b_wo_date = tdate:
        STATUS INPUT "�������:" + STRING(b_wo_batch).
    END.
    {bcgetprt.i}
    DO ON ERROR UNDO:
        
       FOR EACH b_wo_mstr WHERE b_wo_date = tdate AND b_wo_shift = tshift 
           AND b_wo_batch = X:
           FOR EACH b_wod_det
                WHERE b_wod_batch = b_wo_batch AND b_wod_part = b_wo_part AND b_wod_shift = b_wo_shift
               AND b_wod_line = b_wo_line :

               IF b_wod_printed = NO THEN DO:
                   {bcco001.i b_wod_code b_wod_part "0" """" """" """" """"}
               END.
               
               {gprun.i ""bccopr.p"" "(input b_wod_code, input ""FUL"", input pname, input no)"}
          END.
       END.
        {bcask.i "��ӡ��ȷ��?"}
        IF msg = YES THEN DO:
            {bcco002.i ""FINI-REL""}
           FOR EACH b_wo_mstr WHERE b_wo_date = tdate AND b_wo_shift = tshift AND b_wo_batch = X:
             FOR EACH b_wod_det
                WHERE b_wod_batch = b_wo_batch:
                ASSIGN b_wod_printed = YES
                       b_wod_date = TODAY.
              END.
            END.
        END.   /*if msg = yes*/
        ELSE IF msg = NO THEN DO:
            RETURN.
        END.
        ELSE DO:
            RETURN.
        END.
        
    END. /*do*/
        OPEN QUERY q_wod FOR EACH b_wod_det WHERE b_wod_batch = b_wo_mstr.b_wo_batch 
        AND b_wod_part = b_wo_mstr.b_wo_part.
    RETURN.
END.

/*
REPEAT:
    UPDATE tdate  tshift
    b_wo 
    b_wod 
     btn_print btn_prtindv btn_disp btn_quit
   WITH FRAME a.
END.*/

ENABLE ALL WITH FRAME a.
WAIT-FOR CHOOSE OF btn_quit.
/*
{bctrail.i}
    */
