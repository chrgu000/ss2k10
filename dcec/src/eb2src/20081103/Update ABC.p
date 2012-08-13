OUTPUT TO c:\dd.txt.

DEF VAR tot_cl LIKE sct_cst_tot.

FOR EACH IN_mstr WHERE IN_site = "CEBJ".
    FIND FIRST spt_det WHERE spt_site = "DCEC-C" AND spt_part = IN_part AND spt_sim = "STD2008" AND spt_element ="材料" NO-LOCK NO-ERROR.
    IF AVAILABLE spt_det THEN DO:
       tot_cl = spt_cst_tl + spt_cst_ll.
       IF tot_cl < 50 THEN ASSIGN IN_abc = "C".
       IF tot_cl >=50 AND tot_cl < 180 THEN ASSIGN IN_abc = "B".
       IF tot_cl >=180 THEN ASSIGN IN_abc = "A".
       DISP IN_part IN_site IN_abc tot_cl.
    END.
    tot_cl = 0.
END.

FOR EACH IN_mstr WHERE IN_site = "DCEC-B".
    FIND FIRST spt_det WHERE spt_site = IN_site AND spt_part = IN_part AND spt_sim = "STD2008" AND spt_element ="材料" NO-LOCK NO-ERROR.
    IF AVAILABLE spt_det THEN DO:
       tot_cl = spt_cst_tl + spt_cst_ll.
       IF tot_cl < 50 THEN ASSIGN IN_abc = "C".
       IF tot_cl >=50 AND tot_cl < 180 THEN ASSIGN IN_abc = "B".
       IF tot_cl >=180 THEN ASSIGN IN_abc = "A".
       DISP IN_part IN_site IN_abc tot_cl.
    END.
    tot_cl = 0.
END.

FOR EACH IN_mstr WHERE IN_site = "DCEC-C".
    FIND FIRST spt_det WHERE spt_site = IN_site AND spt_part = IN_part AND spt_sim = "STD2008" AND spt_element ="材料" NO-LOCK NO-ERROR.
    IF AVAILABLE spt_det THEN DO:
       tot_cl = spt_cst_tl + spt_cst_ll.
       IF tot_cl < 50 THEN ASSIGN IN_abc = "C".
       IF tot_cl >=50 AND tot_cl < 180 THEN ASSIGN IN_abc = "B".
       IF tot_cl >=180 THEN ASSIGN IN_abc = "A".
       DISP IN_part IN_site IN_abc tot_cl.
    END.
    tot_cl = 0.
END.

FOR EACH IN_mstr WHERE IN_site = "DCEC-SV".
    FIND FIRST spt_det WHERE spt_site = "DCEC-C" AND spt_part = IN_part AND spt_sim = "STD2008" AND spt_element ="材料" NO-LOCK NO-ERROR.
    IF AVAILABLE spt_det THEN DO:
       tot_cl = spt_cst_tl + spt_cst_ll.
       IF tot_cl < 50 THEN ASSIGN IN_abc = "C".
       IF tot_cl >=50 AND tot_cl < 180 THEN ASSIGN IN_abc = "B".
       IF tot_cl >=180 THEN ASSIGN IN_abc = "A".
       DISP IN_part IN_site IN_abc tot_cl.
    END.
    tot_cl = 0.
END.


FOR EACH pt_mstr.
    FIND FIRST spt_det WHERE spt_site = pt_site AND spt_part = pt_part AND spt_sim = "STD2008" AND spt_element ="材料" NO-LOCK NO-ERROR.
    IF AVAILABLE spt_det THEN DO:
       tot_cl = spt_cst_tl + spt_cst_ll.
       IF tot_cl < 50 THEN ASSIGN pt_abc = "C".
       IF tot_cl >=50 AND tot_cl < 180 THEN ASSIGN pt_abc = "B".
       IF tot_cl >=180 THEN ASSIGN pt_abc = "A".
       DISP pt_part pt_site pt_abc tot_cl.
    END.
    tot_cl = 0.

END.
