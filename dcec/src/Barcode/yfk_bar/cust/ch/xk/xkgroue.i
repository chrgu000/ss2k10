/*Cai last modified by 05/20/2004*/

find pt_mstr where pt_part = xkgpd_part NO-LOCK .
des = pt_desc1 + pt_desc2 .
display xkgpd_part des with frame f-errs .
