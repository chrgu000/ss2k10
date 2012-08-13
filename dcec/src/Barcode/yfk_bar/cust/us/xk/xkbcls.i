/*last Modify by SunnyZhou on 06/20/2004*/
/*last modified by Cai Jing on 12/29/04*/
/*---------------------------------------------------
      2005-01-17, Yang Enping, 000A
          1. 性能调整
      2006-03-06, HOU *H01*
-----------------------------------------------------*/
/* Modify on 200609-05-09   禁止关闭日程单和协议单           */

/*
{mfdeclre.i}

DEFINE SHARED VARIABLE pnbr LIKE po_nbr .
DEFINE VARIABLE yn as logic.
DEFINE new shared variable po_recno as recid.
DEFINE new shared variable pod_recno  as recid.
DEFINE VARIABLE qty_ord like prh_rcvd.
DEFINE NEW SHARED VARIABLE del-yn AS LOGICAL.
 &SCOPED-DEFINE popomtf_p_2 "采购单" 
*/
/*modified by Cai Jing on 01/29/05 cj0129*/

yn = YES .

/*000A*----add no-lock ----*/
FIND FIRST xkrod_det no-lock
WHERE xkrod_nbr = pnbr AND xkrod_status = "" NO-ERROR .

IF AVAILABLE xkrod_det THEN DO:
    MESSAGE "要关闭要货单:" + pnbr + "吗? " UPDATE yn .
END.
ELSE DO:
    FIND FIRST po_mstr WHERE po_nbr = pnbr AND po_type <> 'B' AND po_sched = NO NO-LOCK NO-ERROR .
    IF AVAILABLE po_mstr THEN DO:
        FIND first pod_det no-lock 
        where pod_nbr = pnbr and pod_status = "" no-error.
        
        IF available pod_det THEN DO:
            MESSAGE "要关闭要货单:" + pnbr + "吗? "  UPDATE yn .
        END.
        ELSE DO:
            yn = yes.
        END.
    END.    
    ELSE do:
       yn = NO.
    END.
END. /*AVAILABLE xkrod_det*/

IF yn then do:
/*cj0129*/ IF NOT kb THEN DO :
    FIND first po_mstr where po_nbr = pnbr no-lock no-error.
    
    /*000A*---- add no-wait ----*/
    FIND FIRST pod_det exclusive-lock 
    WHERE pod_nbr = pnbr AND pod_status = "" 
    no-wait NO-ERROR .

/*xw0619*/
    repeat :
/*xw0619*/
       if not available pod_det then leave.
       /*000A*----consolidate to 1 statement---*/
       assign pod_status = "c" 
              pod_recno = recid(pod_det)
              po_recno = recid(po_mstr).
       
       FIND prh_hist NO-LOCK 
       WHERE prh_nbr= pod_nbr AND prh_line = pod_line NO-ERROR .
       
       IF AVAILABLE prh_hist THEN 
           qty_ord = prh_rcvd .
       ELSE
           qty_ord = 0 .
       
       del-yn = NO.
       
       {gprun.i ""gppotr.p"" "(input ""DELETE"", input pod_nbr, input pod_line)"}
       
       IF pod_type = "" THEN DO:
          {mfmrw.i "pod_det" pod_part pod_nbr string(pod_line)
           """" ? pod_due_date "0" "SUPPLY" {&popomtf_p_2}
          pod_site}
       END.

       FIND first pod_det exclusive-lock 
       where pod_nbr = pnbr and pod_status = "" 
/*xw0619*/  no-error.
    end. /*repeat*/
    
    IF not can-find(first pod_det no-lock where pod_nbr = pnbr and pod_status = "" ) then do:
       /*000A*----add no-wait ----*/
       FIND po_mstr exclusive-lock 
       WHERE po_nbr = pnbr and po_stat = ""
       no-wait no-error.
       if available po_mstr then do:
          assign po_stat = "c" 
                 po_cls_date = TODAY .
          release po_mstr .
       end .
    end.
/*cj0129*/ END . /*if not kb*/

    /*000A*---- replaced by the following code fragement----
    FIND xkro_mstr exclusive-lock 
    WHERE xkro_nbr = pnbr no-error.
    
    if available xkro_mstr then 
       xkro_status = "c" .
    
/*xw0619*/
    find first xkrod_det exclusive-lock 
    where xkrod_nbr = pnbr and xkrod_status = ""  
    no-error.
/*xw0619*/        
    REPEAT:
       if not available xkrod_det then 
          leave.
       else
          xkrod_status = "c" .
/*xw0619*/
       find first xkrod_det exclusive-lock 
       where xkrod_nbr = pnbr and xkrod_status = "" 
       no-error.
    END.
    ----*000A*/

    /*000A*----*/
    find first xkro_mstr no-lock
    where xkro_nbr = pnbr
    no-error .

    if available xkro_mstr then
    repeat:
       find first xkro_mstr exclusive-lock
       where xkro_nbr = pnbr
       no-wait no-error .

       if available(xkro_mstr) then do:
          assign xkro_status = "c" .
          release xkro_mstr .
	  message skip(2) .
	  message skip(2) .
	  leave .
       end .
       else do:
          message "要货单" + pnbr + "正在被别人操作，请等待" .
	  next .
       end .
    end .

    for each fetchXkrod no-lock
    where xkrod_nbr = pnbr 
    and xkrod_status = "":
       repeat:
          find first processXkrod exclusive-lock
          where recid(processXkrod) = recid(fetchXkrod)
          no-wait no-error .

          if available(processXkrod) then do:
             assign processXkrod.xkrod_status = "c" .
             release processXkrod .
             /*H01*****
             message skip(2) .
             message skip(2) .
             **H01****/
             leave .
          end .
          else do:
             message "要货单" + pnbr + "正在被别人操作，请等待" .
             next .
          end .
       end .
    end .
    
    /*----*000A*/

    IF kb THEN DO:

       /*000A*----replaced by the following code fragement ----

/*cj1229* /*xw0619*/          find First knbd_det WHERE knbd_user1 = pnbr exclusive-lock no-error.*/
/*cj1229*/
       FIND FIRST knbd_det  NO-LOCK 
       WHERE knbd_user1 = pnbr
       NO-ERROR .
/*repeat*/
       Repeat:                
/*xw0619*/
          IF not available knbd_det THEN 
	     leave.
          else DO :
/*cj1229*/   tempkbid = knbd_id .
/*cj1229*/   FIND knbd_det WHERE knbd_id = tempkbid EXCLUSIVE-LOCK .             
             assign
                knbd_user1 = "" 
/*xw0702*/      knbd_print_dispatch = yes.
/*cj1229*/END .    
/*cj1229* /*xw0619*/                find next knbd_det WHERE knbd_user1 = pnbr exclusive-lock no-error.*/
/*cj1229*/
          FIND NEXT knbd_det NO-LOCK 
	  WHERE knbd_user1 = pnbr NO-ERROR .  

       END.
       ----*000A*/

       /*000A*----*/
       
       for each fetchKnbd no-lock
       where knbd_user1 = pnbr:
          repeat:
             find first processKnbd exclusive-lock
	     where recid(processKnbd) = recid(fetchKnbd)
	     no-wait no-error .

	     if available(processKnbd) then do:
	        assign knbd_user1 = "" 
                       knbd_print_dispatch = yes.
		release processKnbd .
		/*H01***
		message skip(2) .
		message skip(2) .
		**H01***/
		leave .
	     end .
	     else do:
                message "看板" + string(fetchKnbd.knbd_id) + " 正在被其他人操作，请等待".
		next .
	     end .
	  end .
       end .

       /*----*000A*/
    END. /*kb*/
end. /*yn*/
