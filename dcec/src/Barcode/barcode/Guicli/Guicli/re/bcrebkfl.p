{mfdeclre.i}
{bcdeclre.i NEW}
{bcwin01.i}

DEFINE VARIABLE employee AS CHARACTER FORMAT "x(8)" LABEL "��Ա".
DEFINE VARIABLE bfsite AS CHARACTER LABEL "�ص�".
DEFINE VARIABLE bfdate AS DATE LABEL "�س�����".
DEFINE VARIABLE bfop AS CHARACTER LABEL "����".
DEFINE VARIABLE bfpart LIKE pt_part LABEL "���".
DEFINE VARIABLE bfqty AS DECIMAL LABEL "����".
DEFINE VARIABLE prodline AS CHARACTER LABEL "������".
DEFINE BUTTON btn_quit LABEL "�˳�".
DEFINE BUTTON btn_exec LABEL "�س�".

DEFINE FRAME a
    employee SKIP
    bfsite SKIP
    bfdate SKIP
    bfpart SKIP
    bfop SKIP
    prodline SKIP
    bfqty SKIP
    btn_exec SPACE(10) btn_quit
    WITH  SIZE 30 BY 18.5 TITLE "�ظ������س�"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ON 'choose':U OF btn_exec 
DO:
    FIND FIRST emp_mstr NO-LOCK WHERE emp_addr = employee:SCREEN-VALUE NO-ERROR.
    IF NOT AVAILABLE emp_mstr THEN DO:
        MESSAGE employee:SCREEN-VALUE + "������" VIEW-AS ALERT-BOX.
        RETURN.
    END.

    ASSIGN employee
        bfsite
        bfdate
        bfpart
        bfop
        prodline
        bfqty.
   /* {bcrun.i ""bcmgwrbf.p""  "(INPUT ""po1067"",
          INPUT 3,
          INPUT """",
          INPUT ""10-00"",
          INPUT ""L90"",
          INPUT ""1000"",
          INPUT """",
          INPUT 60,
          INPUT ""EA"",
          INPUT TODAY,
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT ""100"",
          INPUT ""11000"",
          INPUT ""poporc.p"",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """",
          INPUT """")"}*/
        {bcrun.i ""bcmgwrbf.p""  "(INPUT """",
              INPUT """",
              INPUT """",
              INPUT bfpart,
              INPUT """",
              INPUT """",
              INPUT prodline,
              INPUT bfqty,
              INPUT """",
              INPUT bfdate,
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT bfsite,
              INPUT ""rebkfl.p"",
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT bfop,
              INPUT employee,
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT """")"}

    {bcrun.i ""bcmgwrfl.p"" "(input ""rebkfl.p"")"}
     ENABLE ALL WITH FRAME a.
    RETURN.
END.

ON 'choose':U OF btn_quit 
DO:
    DELETE WIDGET C-win.
    RETURN.
END.


        ON WINDOW-CLOSE OF c-win /* <insert window title> */
   DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO c-win.
  RETURN NO-APPLY.

        END.

CURRENT-WINDOW = C-win.
ENABLE ALL WITH FRAME a.
{bctrail.i}




