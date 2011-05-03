/* SS - 090910.1 By: Neil Gao */

{mfdeclre.i}
{gplabel.i}

define input parameter ponbr like po_nbr.
define input parameter ponbr1 like po_nbr.
define input parameter vend like po_vend.
define input parameter vend1 like po_vend.
define input parameter buyer like po_buyer.
define input parameter buyer1 like po_buyer.
define input parameter functionName AS CHARACTER.


for each po_mstr USE-INDEX po_buyer
	where po_nbr >= ponbr and po_nbr <= ponbr1 
	and po_vend >= vend and po_vend <= vend1 
	and po_buyer >= buyer and po_buyer <= buyer1 no-lock,	
	each ad_mstr where ad_addr = po_vend no-lock:
  
   IF functionName = "xxscposi.p" THEN DO:
      IF po_user1 <> "10" AND po_user1 <> "" THEN DO:
         NEXT.
      END.
   END.
   ELSE IF functionName = "xxscposu.p" THEN DO:
      IF po_user1 <> "11" AND po_user1 <> "" THEN DO:
         NEXT.
      END.
   END.
   ELSE IF functionName = "xxscposc.p" THEN DO:
      IF po_user1 <> "12" AND po_user1 <> "" THEN DO:
         NEXT.
      END.
   END.
   ELSE IF functionName = "xxscpost.p" THEN DO:
      IF po_user2 <> "90" AND po_user2 <> "" THEN DO:
         NEXT.
      END.
   END.  
  
  for each pod_det where pod_nbr = po_nbr no-lock,
	each pt_mstr where pt_part = pod_part no-lock 
	with frame c width 200 down:
	
	setframelabels(frame c:handle).
	
	    IF functionName = "xxscposi.p" THEN DO:
         IF pod_user1 <> "10" AND pod_user1 <> "" THEN DO:
            NEXT.
         END.
      END.
      ELSE IF functionName = "xxscposu.p" THEN DO:
         IF pod_user1 <> "11" AND pod_user1 <> "" THEN DO:
            NEXT.
         END.
      END.
      ELSE IF functionName = "xxscposc.p" THEN DO:
         IF pod_user1 <> "12" AND pod_user1 <> "" THEN DO:
            NEXT.
         END.
      END.
      ELSE IF functionName = "xxscpost.p" THEN DO:
         IF pod_user2 <> "90" AND pod_user2 <> "" THEN DO:
            NEXT.
         END.
      END.
	
	
	disp po_nbr po_vend ad_name po_ord_date pod_part pt_desc1 pod_qty_ord with frame c.
	down with frame c.
 end. /* for each pod_det */
end. /* for each po_mstr */

