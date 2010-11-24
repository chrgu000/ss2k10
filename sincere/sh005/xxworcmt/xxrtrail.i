/* xxrtrail.i - REPORT TRAILER INCLUDE FILE                                  */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 101115.1 By: zhangyun                                                */

/*bo* for first xdn_ctrl no-lock where xdn_domain = global_domain            */
/*bo*       and xdn_type = v_type with frame c:                              */
/*bo*     put unformat fill("-",132).                                        */
/*bo*     put skip(1).                                                       */
/*bo*     put unformat xdn_train1 xdn_train2 at 50 xdn_train3 at 100 skip(1).*/
/*bo*     put unformat xdn_page1  xdn_page2 at 50  xdn_page3 at 100.         */
/*bo*     {mfrpchk.i}                                                        */
/*bo* end.                                                                   */
/*bo*/ put unformat fill("-",130).
/*bo*/ for first xdn_ctrl no-lock where xdn_domain = global_domain
/*bo*/       and xdn_type = v_type
/*bo*/      with frame f width 132 no-attr-space no-label no-box:
/*bo*/    display xdn_train1 format "x(40)"
/*bo*/            xdn_train2 format "x(40)"
/*bo*/            xdn_train3 format "x(40)".
/*bo*/    down 1.
/*bo*/    display xdn_page1 format "x(40)"
/*bo*/            xdn_page2 format "x(40)"
/*bo*/            xdn_page3 format "x(40)".
/*bo*/ end.
{mfreset.i}
