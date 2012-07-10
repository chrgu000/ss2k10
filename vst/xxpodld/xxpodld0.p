/* xxpodld.p - popomt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxpodld.i}

DEFINE VARIABLE v_i AS INTEGER.
define variable vnbr like pod_nbr.
define variable vline like pod_line.
define variable vdue as character format "x(10)".
define variable vstat like pod_status.

DEFINE TEMP-TABLE tt1
       FIELD tt1_field1 AS CHARACTER.

   /* check data & cimload */
   FOR EACH xxpod_det:
       DELETE xxpod_det.
   END.

   FOR EACH tt1:
       DELETE tt1.
   END.

   v_flag = "1".

   INPUT FROM VALUE(flhload) .
   REPEAT:
      CREATE tt1 .
      IMPORT UNFORMATTED tt1.
   END.
   INPUT CLOSE.

   v_i = 0.
   for each tt1 where tt1_field1 > "":
       v_i = v_i + 1.
       IF v_i > 1 THEN DO:
       		assign vnbr = trim(ENTRY(1,tt1_field1))
       					 vline = INTEGER(trim(ENTRY(2,tt1_field1)))
       					 vdue = trim(entry(3,tt1_field1))
       					 vstat = trim(entry(4,tt1_field1)) NO-ERROR.
       	  find first xxpod_det exclusive-lock where xxpod_nbr = vnbr and xxpod_line = vline no-error.
       	  if not available xxpod_det then do:
					   CREATE xxpod_det.
					   assign xxpod_nbr = vnbr
					   			 xxpod_line = vline.
					end.
					if vnbr <> "" and vline <> 0 then do:
				  	 find first pod_det no-lock where pod_nbr = vnbr and pod_line = vline no-error.
				     if available pod_det then do:
				     	  assign xxpod_odue = pod_due_date
				     	 	 			 xxpod_ostat = pod_status.
				     	  if vdue = "-" then do:
				     	  		assign xxpod_due_date = pod_due_date.
				     	  end.
				     	  else if vdue = "" then do:
				     	  		assign xxpod_due_date = ?.
				        end.
				     	  else do:
				     	  		assign xxpod_due_date = date(integer(substring(vdue,1,2)),
				     	  																 integer(substring(vdue,4,2)),
				     	  													2000 + integer(substring(vdue,7,2))) no-error.
				     	  		 IF ERROR-STATUS:ERROR THEN DO:
                      /* Invalid date format */
                       ASSIGN xxpod_chk =getMsg(1494) + getTermLabel("DUE_DATE",12).
                    END.
				        end.
				     	  if vstat = "-" then do:
				     	  		assign xxpod_stat = pod_stat.
				     	  end.
				     	  else do:
				        		assign xxpod_stat = vstat.
				        end.
				        if (pod_status = "c" or pod_status = "x") then do:
				           assign xxpod_chk = getMsg(2395).
				        end.
				     end.
				     else do:
				     		  assign xxpod_chk = getmsg(2329).
				     end.
				  end.
				  else do:
				  		 assign xxpod_chk = getmsg(2329).
				  end.
       end.
   end.
