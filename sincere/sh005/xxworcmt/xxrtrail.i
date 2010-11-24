/* xxrtrail.i - REPORT TRAILER INCLUDE FILE                                  */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 101115.1 By: zhangyun                                                */

for first xdn_ctrl no-lock where xdn_domain = global_domain
      and xdn_type = v_type with frame c: 
    put unformat fill("-",132).     
    put skip(1).
    put unformat xdn_train1 xdn_train2 at 50 xdn_train3 at 100 skip(1).
    put unformat xdn_page1  xdn_page2 at 50  xdn_page3 at 100.
    {mfrpchk.i}
end.
{mfreset.i}
