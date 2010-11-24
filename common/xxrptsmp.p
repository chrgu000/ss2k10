/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

DEFINE VARIABLE  part1          LIKE   tr_part         no-undo.
DEFINE VARIABLE  part2          LIKE   tr_part         no-undo.
DEFINE VARIABLE  shipdate1      LIKE   tr_ship_date    no-undo.
DEFINE VARIABLE  shipdate2      LIKE   tr_ship_date    no-undo.
DEFINE VARIABLE  site1          LIKE   tr_site         no-undo.
DEFINE VARIABLE  site2          LIKE   tr_site         no-undo.
DEFINE VARIABLE  QTY            LIKE   tr_qty_chg      no-undo.

{mfdtitle.i "b+ "}

FORM
 part1     LABEL "���к�"    COLON 15 part2     LABEL "��" COLON 40 SKIP
 shipdate1 LABEL "����"      COLON 15 shipdate2 LABEL "��" COLON 40 SKIP
 site1     LABEL "ת��"      COLON 15 site2     LABEL "��" COLON 40 SKIP
WITH FRAME A  SIDE-LABELS WIDTH 80.

   REPEAT:

        if part2 = hi_char then part2 = "".
        if shipdate1 = low_date then shipdate1 = ?.
        if shipdate2 = hi_date then shipdate2 = ?.
        if site2 = hi_char then site2 = "".

        UPDATE
            part1
            part2
            shipdate1
            shipdate2
            site1
            site2
            WITH FRAME A TITLE "Selection Criteria".

     if part2     = "" then part2     = hi_char.
     if shipdate1 = ?  then shipdate1 = low_date.
     if shipdate2 = ?  then shipdate2 =  hi_date.
     if site2     = "" then site2     = hi_char.

     FOR EACH  tr_hist NO-LOCK WHERE
             tr_part         >= part1     AND tr_part         <= part2     AND
             tr_ship_date    >= shipdate1 AND tr_ship_date    <= shipdate2 AND
             tr_site         >= site1     AND tr_site         <= site2
             break by tr_part BY tr_ship_date BY tr_site:
/*   ACCUMULATE tr_qty_chg  (TOTAL BY tr_part BY tr_ship_date BY tr_site ).  */
           DISPLAY
                 tr_part                LABEL "���к�"
                 tr_rmks                LABEL "����"
                 tr_ship_date           LABEL "����"
                 tr_qty_chg             LABEL "����"
                 tr_loc                 LABEL "��λ"
                 tr_ref_site            LABEL "ת��"
                 tr_site                LABEL "ת��"
                 WITH WIDTH 84.

      /*   IF LAST-OF(tr_site) THEN DO:
            DISPLAY QTY LABEL "��ת������:" WITH FRAME B .
           END.   */

     END.
   END.

