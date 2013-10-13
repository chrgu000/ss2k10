/* xxrtrail.i - REPORT TRAILER INCLUDE FILE                                  */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 101115.1 By: zhangyun                                                */
put unformat fill("-",130).
for first xdn_ctrl no-lock where xdn_domain = global_domain
      and xdn_type = "{1}":
   if xdn_train5 <> "" or xdn_page5 <> "" then do:
       display xdn_train1 format "x(24)"
               xdn_train2 format "x(24)"
               xdn_train3 format "x(24)"
               xdn_train4 format "x(24)"
               xdn_train5 format "x(24)"
               with frame ft5 width 132 no-attr-space no-label no-box.
        down 1 with frame ft5.
        display xdn_page1 @ xdn_train1 format "x(24)"
                xdn_page2 @ xdn_train2 format "x(24)"
                xdn_page3 @ xdn_train3 format "x(24)"
                xdn_page4 @ xdn_train4 format "x(24)"
                xdn_page5 @ xdn_train5 format "x(24)"
                with frame ft5 width 132 no-attr-space no-label no-box.
   end.
   else if xdn_train4 <> "" or xdn_page4 <> "" then do:
         display xdn_train1 format "x(30)"
                 xdn_train2 format "x(30)"
                 xdn_train3 format "x(30)"
                 xdn_train4 format "x(30)"
                 with frame ft4 width 132 no-attr-space no-label no-box.
        down 1 with frame ft4.
        display xdn_page1 @ xdn_train1 format "x(30)"
                xdn_page2 @ xdn_train2 format "x(30)"
                xdn_page3 @ xdn_train3 format "x(30)"
                xdn_page4 @ xdn_train4 format "x(30)"
                with frame ft4 width 132 no-attr-space no-label no-box.
   end.
   else if xdn_train3 <> "" or xdn_page3 <> "" then do:
        display xdn_train1 format "x(40)"
                xdn_train2 format "x(40)"
                xdn_train3 format "x(40)"
                with frame ft3 width 132 no-attr-space no-label no-box.
        down 1 with fram ft3.
        display xdn_page1 @ xdn_train1 format "x(40)"
                xdn_page2 @ xdn_train2 format "x(40)"
                xdn_page3 @ xdn_train3 format "x(40)"
                with frame ft3 width 132 no-attr-space no-label no-box.
   end.
   else if xdn_train2 <> "" or xdn_page2 <> "" then do:
        display xdn_train1 format "x(62)"
                xdn_train2 format "x(62)"
                with frame ft2 width 132 no-attr-space no-label no-box.
        down 1 with frame ft2.
        display xdn_page1 @ xdn_train1 format "x(62)"
                xdn_page2 @ xdn_train2 format "x(62)"
                with frame ft2 width 132 no-attr-space no-label no-box.
   end.
end.
{mfreset.i}
