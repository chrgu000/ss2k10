OUTPUT TO c:\DCEC-BOP.txt.
/*FOR EACH pt_mstr WHERE pt_prod_line = "9999"  AND (pt_group = "O" OR pt_group = "PH").
    FOR EACH ps_mstr WHERE ps_par = pt_part.
        DISP ps_par pt_desc2  ps_comp ps__chr01 WITH WIDTH 180.
    END.
END.



FOR EACH pt_mstr WHERE pt_prod_line = "9999"  AND (pt_group = "O" OR pt_group = "PH") NO-LOCK.
    FOR EACH ptp_det WHERE  ptp_part = pt_part AND ptp_site = "DCEC-C" NO-LOCK.
        DISP pt_part SPACE(5) pt_desc2 SPACE(5) ptp_bom_code SPACE(5) ptp_site WITH WIDTH 180.
    END.
END.

*/


FOR EACH pt_mstr WHERE pt_prod_line = "9999"  AND (pt_group = "O" OR pt_group = "PH") NO-LOCK.
    FOR EACH bom_mstr WHERE  bom__chr02 = pt_part AND bom__chr01 = "DCEC-B" NO-LOCK.
        DISP pt_part SPACE(5) pt_desc2 SPACE(5) bom_parent SPACE(5) bom__chr01 WITH WIDTH 180.
    END.
END.
