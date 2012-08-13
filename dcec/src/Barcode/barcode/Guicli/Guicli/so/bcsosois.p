
{mfdeclre.i}
{bcdeclre.i NEW}
{bcwin01.i}

DEFINE VARIABLE sonbr LIKE so_nbr.
DEFINE VARIABLE site LIKE so_site.
DEFINE VARIABLE LINE LIKE sod_line LABEL "行数".
DEFINE VARIABLE bfqty AS DECIMAL LABEL "数量".
DEFINE VARIABLE bfdate AS DATE LABEL "日期".
DEFINE VARIABLE bfpart AS CHARACTER LABEL "零件号".

DEFINE BUTTON btn_quit LABEL "退出".
DEFINE BUTTON btn_exec LABEL "回冲".

DEFINE FRAME a
    sonbr SKIP
    site SKIP
    LINE SKIP
    bfqty SKIP
    bfdate SKIP
    btn_exec SPACE(10) btn_quit
    WITH  SIZE 30 BY 18.5 TITLE "销售发运"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ON 'choose':U OF btn_exec 
DO:
   ASSIGN sonbr
       site
       LINE
       bfqty
       bfdate.

   FIND FIRST sod_det NO-LOCK WHERE sod_nbr = sonbr AND sod_line = LINE NO-ERROR.
   IF AVAILABLE sod_det THEN DO:
        bfpart = sod_part.
   END.
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
        {bcrun.i ""bcmgwrbf.p""  "(INPUT sonbr,
              INPUT LINE,
              INPUT """",
              INPUT bfpart,
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT bfqty,
              INPUT """",
              INPUT TODAY,
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT """",
              INPUT site,
              INPUT ""sosois.p"",
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
              INPUT """")"}

    {bcrun.i ""bcmgwrfl.p"" "(input ""sosois.p"")"}
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



