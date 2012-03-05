DEFINE VARIABLE qad09 LIKE pod__qad09.
DEFINE VARIABLE qad02 LIKE pod__qad02.

FOR EACH pod_det
   :
   if ((pod__qad02 = 0 or pod__qad02 = ?) and (pod__qad09 = 0 or pod__qad09 = ?)) THEN DO:
      /*
      ext_cost = qty_ord * pur_cost * (1 - (pod_disc_pct / 100)).
      */
      NEXT.
   END.
   /*
   else DO:
      ext_cost = pod_qty_ord * (pod__qad09 + pod__qad02 / 100000).
   END.
   */

   qad09 = pod_pur_cost * (1 - (pod_disc_pct / 100)).
   qad02 = (pod_pur_cost * (1 - (pod_disc_pct / 100)) - pod__qad09) * 100000.
   IF pod__qad09 = qad09 AND pod__qad02 = qad02 THEN DO:
      NEXT.
   END.

   /*
   DISP pod_nbr pod_line pod__qad09 pod__qad02 pod_pur_cost pod_disc_pct pur_cost * (1 - (pod_disc_pct / 100)).
   */

   DISP pod_nbr pod_line pod_pur_cost pod_disc_pct round(pod_pur_cost * (1 - (pod_disc_pct / 100)),2).

   /*
   pod__qad09 = pod_pur_cost * (1 - (pod_disc_pct / 100)).
   pod__qad02 = (pod_pur_cost * (1 - (pod_disc_pct / 100)) - pod__qad09) * 100000.
   */

END.

