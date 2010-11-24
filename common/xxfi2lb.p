
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* DISPLAY TITLE */
{mfdtitle.i "09Y2"}

DEFINE QUERY qr1 FOR _file SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE br1
  QUERY qr1 NO-LOCK DISPLAY
      _file._FIELD-NAME FORMAT "X(18)":U
      _file._Data-type FORMAT "X(8)":U
  ENABLE
      _file._data-type
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66 BY 8.89 ROW-HEIGHT-CHARS .5 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */
   form
   br1
   with frame a side-labels width 80 attr-space.
ENABLE br1  WITH FRAME a.

WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
