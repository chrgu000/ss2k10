/* ss - 100423.1 by: jack */
/* ss - 100604.1 by: jack */
{mfdeclre.i}
{gplabel.i}

DEFINE INPUT PARAMETER v_addr LIKE vd_addr .
 DEFINE INPUT PARAMETER v_name LIKE ad_name.
 DEFINE OUTPUT PARAMETER v_ok AS LOGICAL .
 /* ss - 100604.1 -b */
 DEFINE OUTPUT PARAMETER v_addr1 LIKE ad_addr .
 /* ss - 100604.1 -e */

/* ss - 100604.1 -b 
   FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr <> v_addr AND ad_name = v_name NO-LOCK NO-ERROR .
   ss - 100604. 1-e */
 /* ss - 100604.1 -b */
 FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain  AND ad_type = "customer" AND ad_addr <> v_addr AND ad_name = v_name NO-LOCK NO-ERROR .
/* ss -100604.1 -e */
   IF AVAILABLE ad_mstr THEN DO:

       v_ok = NO .
        v_addr1 =  ad_addr .
   END.
   ELSE DO:
   
       v_ok = YES .
        v_addr1 = "" .
    END.

    
		
	



