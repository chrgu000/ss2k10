/* mgmemt.p - MENU MAINTENANCE                                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.2.6 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 01/03/86   BY: EMB                       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                 */
/* REVISION: 4.0     LAST EDIT: 12/30/87    BY: WUG *A138* */
/* REVISION: 4.0     LAST EDIT: 03/17/89    BY: WUG *B070* */
/* REVISION: 6.0     LAST EDIT: 08/22/90    BY: WUG *D054* */
/* REVISION: 6.0     LAST EDIT: 06/03/91    BY: WUG *D675* */
/* REVISION: 7.0     LAST EDIT: 10/09/91    BY: WUG *7.0** */
/* REVISION: 7.0     LAST EDIT: 09/19/94    BY: ljm *FR42* */
/* REVISION: 7.3     LAST EDIT: 08/08/95    BY: str *G0TQ* */
/* REVISION: 8.5     LAST EDIT: 11/22/95    BY: *J094* Tom Vogten             */
/* REVISION: 8.5     LAST EDIT: 04/10/97    BY: *J1NV* Jean Miller            */
/* REVISION: 8.6     LAST EDIT: 05/20/98    BY: *K1Q4* Alfred Tan             */
/* REVISION: 9.1     LAST EDIT: 02/25/00    BY: *M0K8* Pat Pigatti            */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00  BY: *N0KR* Mark Brown          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00  BY: *N0W9* Mudit Mehta         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.2.6 $   BY: Jean Miller        DATE: 05/10/02  ECO: *P05V*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/* ss - 100610.1 by: jack */  /* 按日期选择开单 */
/* ss - 100612.1 by: jack */
/* ss - 100622.1 by: jack */
/* ss - 100623.1 by: jack */
/* ss - 100630.1 by: jack */  /* 工作中心*/
/* ss - 100707.1 by: jack */  /* 零件怎加上下键，不控制物料清单*/
/* ss - 100714.1 by: jack */
/* ss - 100809.1 by: jack */
/* ss - 100827.1 by: jack */  /* 维护时增加新增功能 */
/******************************************************************************/

/* DISPLAY TITLE */
/*
{mfdtitle.i "100714.1 "}
*/
/*
{mfdtitle.i "100809.1 "}
*/
{mfdtitle.i "100827.1 "}

{cxcustom.i "MGMEMT.P"}

define variable del-yn like mfc_logical initial no.
define variable newrec like mfc_logical.
define variable newxic like mfc_logical initial no .

 {xxmicrtvar6.i new}
define variable yn like mfc_logical initial yes.
define variable m as integer.
define variable m2 as char format "x(8)".
define variable k as integer.

DEFINE VARIABLE inv_recid as recid.
define buffer  xicdet for xxrt_det .
DEFINE VAR rel AS DATE .
DEFINE VAR rel1 AS DATE .
DEFINE VAR nbr LIKE wo_nbr .
DEFINE VAR nbr1 LIKE wo_nbr .
DEFINE VAR v_line AS INT .
DEFINE BUFFER xxrtdet FOR xxrt_det .
DEFINE VAR v_method AS CHAR FORMAT "x(24)" .

/* ss - 100623.1 -b */
DEFINE VAR v_rsn AS CHAR .
DEFINE VAR v_method1 AS CHAR .
/* ss - 100623.1 -e */
/* ss - 100630.1 - b*/
DEFINE VAR v_wkctr LIKE  ro_wkctr .
DEFINE VAR v_routing LIKE wo_routing . 
/* ss - 100630.1 - e*/
DEFINE VAR v_desc2 AS CHAR FORMAT "x(2)" .
/* ss - 100827.1 -b */
DEFINE VAR v_add AS LOGICAL .   /* 修改记录时新增项次*/
/* ss - 100827.1 -e */

form
   site          colon 5  label "地点"
   p-type      colon 35 label "单号类型"
   rcvno       colon 60 label "单号"
  
 
with frame a attr-space side-labels width 80.



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
site = global_site.
 p-type = "RN" .
/*
repeat:
*/
   
    DO TRANSACTION :
   
       FOR EACH usrw_wkfl WHERE usrw_domain = global_domain AND usrw_key1 = "xxwo" AND usrw_key2 BEGINS "xxwo" + GLOBAL_userid +  rcvno  :
           DELETE usrw_wkfl .
       END.
         /* ss - 100809. 1  -b */
            FOR EACH usrw_wkfl WHERE usrw_domain = global_domain AND usrw_key1 = "xxwopart" AND usrw_key2 BEGINS "xxwopart" + GLOBAL_userid +  rcvno  :
           DELETE usrw_wkfl .
       END.
       /* ss - 100809.1 -e */
       RELEASE usrw_wkfl .
    END.

  

     update
          site
           p-type
          rcvno 

         with frame a editing:

            /* FIND NEXT/PREVIOUS RECORD */
         /* FIND NEXT/PREVIOUS RECORD */
         IF FRAME-FIELD = "rcvno" THEN DO:
     
                 {mfnp05.i xxrt_det xxrt_nbr  " xxrt_det.xxrt_domain = global_domain and xxrt_type = p-type  "   xxrt_nbr   " input rcvno" }
            
                    if recno <> ? then do:
            	   display xxrt_nbr @ rcvno  with frame a.
            	   rcvno = xxrt_nbr.
            	end. /* if recno<>? */
          END.
          ELSE DO:
              READKEY .
              APPLY LASTKEY .
          END.
     end.  /*with frame a editing**/   
	newxic = no.

    find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type no-lock no-error.
	if available xdn_ctrl then do:
	   p-prev = xdn_prev.
	   p-next = xdn_next.
	end. 
	else do:
	   message "错误：单号类型不存在，请重新输入".
	   undo, retry.
	end.

	if rcvno = "" then do:
           do transaction on error undo, retry:
	            find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type exclusive-lock no-error.
        	        if available xdn_ctrl then do:
                		   k = integer(p-next) .
                		   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                		   rcvno = trim(p-prev) + trim(m2).
                		   k = integer(p-next) + 1.
                		   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                		   xdn_next = m2.
                		   newxic = yes.
        		    end.
                         if recid(xdn_ctrl) = ? then .
            		     release xdn_ctrl.
           end. /*do transaction*/
   end. 
   else do: 
             find first xxrt_det no-lock where xxrt_det.xxrt_domain = global_domain and xxrt_nbr = rcvno no-error.
             if not available xxrt_det then do:
                 message "不允许手工编号!!!　请重新输入!!" .
                 undo, retry.
             end.
           else  do:
           
                if xxrt_flag then do:
        	       message "单据已确认!!!　不允许修改!!" .
                  undo, retry.
               end.
           END.
            /* ss - 100827.1 -b */
           v_rsn = xxrt_rsn .
           v_method1 = xxrt_method .
           /* ss - 100827.1 -e */

     end. 
 
        find first si_mstr where si_mstr.si_domain = global_domain and si_site = site no-lock no-error.
            if not available si_mstr then do:  
	    message "错误：地点不存在，请重新输入".
     
	    undo, retry.
	end.  

   GLOBAL_site = site .


if newxic then do:
  
    
      FORM           
           rel   COLON 15
           rel1  COLON 45
           nbr  COLON 15
           nbr1 COLON 45
          /* ss - 100623.1 -b */
          v_rsn COLON 15  LABEL "原因"
          v_method1 COLON 45               LABEL "方法"   
          v_desc2  COLON 50 LABEL  "处理方法: 1 领料冲红 2 转仓报废 3 来料退回"
          /* ss - 100623.1 -e */

		  with frame aa   ROW 8   centered overlay SIDE-LABELS WIDTH 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame aa:handle).

           rel = TODAY .
            rel1 = TODAY .
            DISPLAY rel rel1 WITH FRAME aa .


      DO ON ERROR UNDO :
 
      SET rel  rel1 nbr nbr1  /* ss - 100623.1 -b */   v_rsn v_method1  /* ss - 100623.1 -e */  WITH FRAME aa  EDITING :
          readkey.
         apply lastkey.
      END. 
     IF rel = ? THEN DO:
         /*
         MESSAGE "日期不能为空"  .
            NEXT-PROMPT  rel  WITH FRAME aa .
         UNDO ,RETRY .
         */
         rel = low_date .
     END.

        
     IF rel1 = ? THEN DO:
         /*
         MESSAGE "日期不能为空"  .
            NEXT-PROMPT  rel1 WITH FRAME aa.
         UNDO ,RETRY .
         */
         rel1 = hi_date .
     END.

     /* ss - 100623.1 -b
       IF nbr = "" THEN DO:
           
         MESSAGE "工单不能为空"  .
            NEXT-PROMPT  nbr WITH FRAME aa.
         UNDO ,RETRY .
         
     END.
      ss - 100623.1  -e */

      IF nbr1 = "" THEN DO:
          /* ss - 100623.1 -b
         MESSAGE "工单不能为空"  .
            NEXT-PROMPT  nbr1  WITH FRAME aa.
         UNDO ,RETRY .
         ss - 100623.1 -e */
          /* ss - 100623.1 - b */
          nbr1 = hi_char .
          /* ss - 100623.1 -e */
     END.

      /* ss - 100623.1 -b */
   IF v_method1 <> "1"  AND v_method1 <> "2" AND v_method1 <> "3"  THEN DO:
       MESSAGE "退料方法错误" .
       NEXT-PROMPT v_method1 WITH FRAME aa .
       UNDO ,RETRY .
   END.
   /* ss - 100623.1 -e */
   END.  /* do on error undo */

  

   /* 创建usrw_wkfl 记录*/
           /* ss - 100809.1 -b
   FOR EACH wo_mstr WHERE wo_domain = GLOBAL_domain AND (wo_nbr >= nbr AND wo_nbr <= nbr1) AND (wo_rel_date >= rel AND wo_rel_date <= rel1 )  AND wo_status = "r" NO-LOCK ,
            EACH wod_det WHERE wod_domain = wo_domain AND wod_lot = wo_lot NO-LOCK :
       ss - 100809.1 -e */
   /* ss - 100809.1 -b */
   FOR EACH wo_mstr WHERE wo_domain = GLOBAL_domain AND (wo_nbr >= nbr AND wo_nbr <= nbr1) AND (wo_rel_date >= rel AND wo_rel_date <= rel1 )  AND wo_status = "r" NO-LOCK ,
         EACH wod_det WHERE wod_domain = wo_domain AND wod_lot = wo_lot NO-LOCK BREAK BY wo_lot :
/* ss - 100809.1 -e */

       /* ss - 100809.1 -b */
       IF FIRST-OF(wo_lot) THEN DO:
           FIND FIRST usrw_wkfl WHERE usrw_domain = wo_domain AND usrw_key1 = "xxwopart" AND usrw_key2 = "xxwopart" + GLOBAL_userid + rcvno + wo_lot NO-ERROR .
           IF NOT AVAILABLE usrw_wkfl  THEN DO:
               CREATE usrw_wkfl .
         ASSIGN
             usrw_domain = GLOBAL_domain 
             usrw_key1 = "xxwopart"
             usrw_key2 =  "xxwopart" + GLOBAL_userid +   rcvno + wo_lot
             usrw_key3 = wo_nbr
             usrw_key4 = wo_lot
             usrw_key5 = wo_part
             usrw_decfld[1]  = wo_qty_ord
             .
         FIND FIRST pt_mstr WHERE pt_domain = wo_domain AND pt_part = wo_part NO-LOCK NO-ERROR .
         IF AVAILABLE pt_mstr THEN
             ASSIGN
                       usrw_charfld[2] = pt_desc1 
                       usrw_charfld[3] = pt_desc2 
             .


           END.
       END.
       /* ss - 100809.1 -e */



       FIND FIRST usrw_wkfl WHERE usrw_domain = wo_domain AND usrw_key1 = "xxwo" AND usrw_key2 = "xxwo"  + GLOBAL_userid +  rcvno + wod_lot + wod_part NO-ERROR .  /* 类型 + 单号+工单+*零件 */

       IF NOT AVAILABLE usrw_wkfl THEN  DO:
           CREATE usrw_wkfl .
           ASSIGN
               usrw_domain = GLOBAL_domain 
               usrw_key1 = "xxwo"
               usrw_key2 =  "xxwo" + GLOBAL_userid +   rcvno + wod_lot + wod_part
               usrw_key3 = wo_nbr
               usrw_key4 = wo_lot
               usrw_key5 = wo_part
               usrw_key6 = wod_part  
               usrw_decfld[1] = wod_qty_iss
               usrw_charfld[1] = rcvno
               .

             /* ss - 100809.1 -b */
               FIND FIRST pt_mstr WHERE pt_domain = wo_domain AND pt_part = wod_part NO-LOCK NO-ERROR .
             IF AVAILABLE pt_mstr THEN
                 ASSIGN
                       usrw_charfld[2] = pt_desc1 
                       usrw_charfld[3] = pt_desc2 
             .
           /* ss - 100809.1 -e */

       END.
   END.
   /* 创建usrw_wkfl 记录*/

    /* ss - 100623.1 -b */
   v_line = 1 .
   /* ss - 100623.1 -e */
   

end. /*if newxic *********************/
else do: 
   /* ss - 100623.1 -b */
   v_line = xxrt_line .
   /* ss - 100623.1 -e */

end. /*if not newxic***************/

   display  p-type rcvno  with frame a.

      seta:
      repeat with frame b:

         FORM           
            xxrt_line        label "项"
            xxrt_wonbr    LABEL "工单" FORMAT "x(10)"
            xxrt_wodpart LABEL "子件"  FORMAT "x(14)"
            xxrt_relqty LABEL "发料数"
			xxrt_qty_from    label "退料数"  FORMAT "->>,>>>,>9.9<"
            /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */   FORMAT "x(8)"        LABEL "批号"
            xxrt_method   LABEL "方法"  FORMAT "x(4)"
            pt_desc1   no-label    space(1)
             pt_desc2  NO-LABEL
           v_method NO-LABEL 
         with frame b 	
                         5 down 
                  /*     OVERLAY  */
                        no-validate
	       width 80   attr-space.
     
      
       
         /* SET EXTERNAL LABELS */
        setFrameLabels(frame b:handle). 

          /* ss - 100827.1 -b */
        v_add = NO .
        /* ss - 100827.1 -e */

           /* ss - 100623.1 -b */
  
            DISPLAY  v_line @ xxrt_line WITH FRAME b .
           /* ss - 100623.1 -e */

         prompt-for xxrt_line
         editing:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i xxrt_det xxrt_line
               "xxrt_domain = global_domain and xxrt_nbr = rcvno and xxrt_type = p-type" xxrt_line "input xxrt_line"}

            if recno <> ? then do:
        	    display xxrt_line xxrt_wonbr  xxrt_wodpart xxrt_qty_from     /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */  xxrt_method  with frame b.               
        	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = xxrt_wodpart no-error.
                       if available pt_mstr then
                          display  pt_desc1 pt_desc2 with frame b .
                       else
                          display "" @ pt_desc1  "" @ pt_desc2 with frame b .

                    FIND  FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = xxrt_wopart NO-LOCK NO-ERROR .
                    IF AVAILABLE pt_mstr THEN DO:
                        MESSAGE   xxrt_wolot xxrt_wopart   pt_desc1   pt_desc2  . 
                    END.

                    FIND FIRST CODE_mstr WHERE CODE_domain  = GLOBAL_domain   AND CODE_fldname = "xxrt" AND CODE_value = xxrt_method NO-LOCK NO-ERROR .
                    IF AVAILABLE CODE_mstr THEN
                        DISPLAY CODE_cmmt @ v_method WITH FRAME b .
                    ELSE
                        DISPLAY "" @ v_method WITH FRAME b .
             end.
         end.
       
         /* ADD/MOD/DELETE  */
         find xxrt_det where xxrt_domain = global_domain and xxrt_site_from = site 
	      and  xxrt_nbr = rcvno and xxrt_type = p-type and
                            xxrt_line = input xxrt_line
         no-error.

         newrec = no.
         if not available xxrt_det then do:
            create xxrt_det.
            assign 
                      xxrt_line
                      xxrt_nbr = rcvno
	                  xxrt_domain = global_domain
	            	   xxrt_site_from  = site
	                  xxrt_type = p-type.
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
            newrec = yes.
            /* ss- 100623.1 -b */
            v_line = xxrt_line + 1 .
            /* ss - 100623.1 -e */
             /* ss - 100827.1 -b */
            IF newxic = NO THEN
                v_add = YES .
            /* ss - 100827.1 -e */
         end. 
	 else do:
	    display xxrt_line xxrt_wonbr xxrt_wodpart xxrt_qty_from  
	                /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */  xxrt_method  with frame b.               
            find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain 
	         and pt_part = xxrt_wodpart no-error.
               if available pt_mstr then
                  display  pt_desc1 pt_desc2 with frame b .
               else
                  display "" @ pt_desc1  "" @ pt_desc2 with frame b .
      
          FIND  FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = xxrt_wopart NO-LOCK NO-ERROR .
            IF AVAILABLE pt_mstr THEN DO:
                  MESSAGE  xxrt_wolot  xxrt_wopart   pt_desc1   pt_desc2 . 
            END.
           
            FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain  AND CODE_fldname = "xxrt" AND CODE_value = xxrt_method NO-LOCK NO-ERROR .
                    IF AVAILABLE CODE_mstr THEN
                        DISPLAY CODE_cmmt @ v_method WITH FRAME b .
                    ELSE 
                       
                        DISPLAY "" @ v_method WITH FRAME b .
   end.

         recno = recid(xxrt_det).
         del-yn = no.
      
         ststatus = stline[2].
         status input ststatus.
         

       display xxrt_line  xxrt_wonbr     xxrt_wodpart xxrt_relqty xxrt_qty_from   /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */  xxrt_method with frame b .               

   setb:  
   do on error undo, retry:
        
      IF newrec  THEN  DO:
        
             /* ss - 100827.1 -b */
          IF v_add = NO THEN DO:
         /* ss - 100827.1 -e */
           PROMPT-FOR xxrt_wonbr   WITH FRAME b .
            
           /* ss - 100622.1 -b
            FIND FIRST xxrt_det WHERE xxrt_domain = GLOBAL_domain AND xxrt_type = p-type  AND xxrt_nbr = rcvno  AND xxrt_wonbr = INPUT xxrt_wonbr NO-ERROR .
            IF NOT AVAILABLE xxrt_det THEN DO:
            ss - 100622.1 -e */
                          /* ss - 100622.1 -b
                       find xxrt_det where xxrt_domain = global_domain and xxrt_site_from = site  and  xxrt_nbr = rcvno and xxrt_type = p-type and  xxrt_line = input xxrt_line   no-error.
                         ss - 100622.1 -e */

                        FIND FIRST usrw_wkfl WHERE  usrw_domain = GLOBAL_domain AND usrw_key1 = "xxwo"   AND usrw_key2 BEGINS "xxwo"  + GLOBAL_userid +  rcvno AND usrw_key3 = INPUT xxrt_wonbr NO-LOCK NO-ERROR .
                        IF AVAILABLE usrw_wkfl  THEN DO:
                        
                            
                            ASSIGN
                                xxrt_wonbr
                                xxrt_wolot = usrw_key4
                               
                                xxrt_wopart = usrw_key5
                                 /* ss - 100622.1 -b
                                xxrt_wodpart = usrw_key6
                                xxrt_relqty = usrw_decfld[1]
                                ss - 100622.1 -e */
                                /* ss - 100623.1 -b */
                                xxrt_rsn = v_rsn 
                                xxrt_method = v_method1
                                /* ss - 100623.1 -e */
                                .
                        
                                    /* ss - 100630.1 -b */
                            FIND FIRST wo_mstr WHERE wo_domain = GLOBAL_domain AND /* ss - 100827.1 -b  wo_nbr = xxrt_nbr ss - 100827.1 -e */
                                /* ss - 100827.1 -b */ wo_nbr = xxrt_wonbr /* ss  - 100827.1 -e */  AND wo_lot = usrw_key4  NO-LOCK NO-ERROR .
                            IF AVAILABLE wo_mstr  AND wo_routing <> "" THEN DO:
                                v_routing = wo_routing .

                            END.
                            ELSE 
                                v_routing = usrw_key5 .

                                FIND FIRST ro_det WHERE  ro_domain = GLOBAL_domain AND ro_routing = v_routing  AND ro_start <= TODAY NO-LOCK NO-ERROR .
                                IF AVAILABLE ro_det THEN
                                    xxrt_wkctr = ro_wkctr .
                                ELSE 
                                    xxrt_wkctr = "" .


                        /* ss - 100630.1 -e  */
                        END.
                        ELSE DO:
                            MESSAGE "选择的工单不在范围之内，不能新增" .
                            NEXT-PROMPT xxrt_wonbr .
                            UNDO ,RETRY .
                        END.
                        
                        ASSIGN xxrt_wonbr .
                        /* ss - 100714.1 -b */
                        GLOBAL_part =   xxrt_wonbr .
                        /* ss - 100714.1 -e */

             /* ss - 100622.1 - b */
                        DO ON ERROR UNDO :
                      /* ss - 100707.1 -b
                           PROMPT-FOR xxrt_wodpart WITH FRAME b  .
                           ss - 100707.1 -e */
                            /* ss - 100707.1 -b */
                        PROMPT-FOR xxrt_wodpart WITH FRAME b  EDITING:
                               
                              {mfnp05.i usrw_wkfl   usrw_index1  " usrw_domain = global_domain and usrw_key1 = 'xxwo'  AND usrw_key2 BEGINS 'xxwo'  + GLOBAL_userid +  rcvno + xxrt_wolot  and usrw_key3 = xxrt_wonbr and usrw_key4 = xxrt_wolot "   usrw_key6   " input xxrt_wodpart" }
            
                                    if recno <> ? then do:
                                        xxrt_wodpart =  usrw_key6 .
                            	      display  xxrt_wodpart  with frame b .
                            	 
                                	end. /* if recno<>? */
                        END.
                            /* ss - 100707.1 -e */
                        ASSIGN xxrt_wodpart .

                        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = xxrt_wodpart NO-LOCK NO-ERROR .
                        IF NOT AVAILABLE pt_mstr  THEN DO:
                            MESSAGE "零件不存在" .
                            UNDO ,RETRY .
                        END.

                           FIND FIRST usrw_wkfl  NO-LOCK WHERE usrw_domain = global_domain AND usrw_key1 = "xxwo" AND usrw_key2 BEGINS "xxwo"  + GLOBAL_userid +  rcvno + xxrt_wolot 
                               AND usrw_key3 =   xxrt_wonbr  AND usrw_key4 = xxrt_wolot AND usrw_key6 = INPUT xxrt_wodpart  NO-ERROR  .
                           IF NOT AVAILABLE usrw_wkfl  THEN DO:
                               /* ss - 100707.1 -b
                               MESSAGE "零件不属于对应工单" .
                               UNDO , RETRY .  
                               ss - 100707.1 -e */
                               /* ss - 100707.1 -b */
                                     ASSIGN
                                   
                                     xxrt_relqty =  0
                                   .
                               /* ss - 100707.1 -e */
                           END.
                           ELSE DO:
                               ASSIGN
                                     /* ss - 100707.1 -b
                                     xxrt_wopart = usrw_key5
                                    xxrt_wodpart = usrw_key6    ss - 100707.1 -e */
                                     xxrt_relqty = usrw_decfld[1]
                                   .

                           END.


                       END.
             /* ss - 100622.1 -e */
               
                        /* ss - 100622.1 -b
                         FIND LAST xxrt_det WHERE xxrt_domain = GLOBAL_domain AND xxrt_type = p-type  AND xxrt_nbr = rcvno   NO-ERROR .
                         IF AVAILABLE xxrt_det THEN
                             v_line = xxrt_Line .
                         ELSE 
                             v_line = 1 .
                        
                             FOR EACH usrw_wkfl WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = "xxwo" AND usrw_key3 = INPUT xxrt_wonbr NO-LOCK :
                                   FIND FIRST xxrt_det WHERE xxrt_domain = GLOBAL_domain AND xxrt_type = p-type  AND xxrt_nbr = rcvno  AND xxrt_wonbr = usrw_key3 AND xxrt_wolot = usrw_key4 AND xxrt_wodpart = usrw_key6  NO-ERROR .
                                     IF NOT AVAILABLE xxrt_det THEN DO:
                                         v_line = v_line + 1 .
                                         CREATE xxrt_det .
                                         ASSIGN
                                              xxrt_nbr = rcvno
	                                          xxrt_domain = global_domain
                                              xxrt_site_from  = site
		                                      xxrt_type = p-type
                                             xxrt_line = v_line
                                             xxrt_wonbr = usrw_key3
                                             xxrt_wolot = usrw_key4
                                             xxrt_wopart = usrw_key5
                                             xxrt_wodpart = usrw_key6
                                             xxrt_relqty = usrw_decfld[1]
                                              .
                                            
                                     END.
                             END.
                           ss - 100622.1 -e */  
             /* ss - 100622.1 -b           
               END.
               ss - 100622.1 -e */

             find xxrt_det where xxrt_domain = global_domain and xxrt_site_from = site  and  xxrt_nbr = rcvno and xxrt_type = p-type AND xxrt_line = input xxrt_line  no-error.
             IF AVAILABLE xxrt_det THEN DO:
                    DISPLAY  xxrt_line  xxrt_wonbr    xxrt_wodpart xxrt_relqty xxrt_qty_from   /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */  xxrt_method with frame b .     
                     
             END.

               /* ss - 100827.1 -b */
          END.    /* v_add = no */
          ELSE DO:
                       
              PROMPT-FOR xxrt_wonbr       WITH FRAME b .
            
                    /* ss - 100630.1 -b */
                        FIND FIRST wo_mstr WHERE wo_domain = GLOBAL_domain AND wo_nbr = INPUT  xxrt_wonbr  NO-LOCK NO-ERROR .
                        IF AVAILABLE wo_mstr   THEN DO:
                            v_routing = wo_routing .
                            xxrt_wolot = wo_lot .
                            xxrt_wopart = wo_part .
                        END.
                        ELSE DO:
                            MESSAGE "工单不存在"  .
                            UNDO ,RETRY .
                        END.
                     

                        FIND FIRST ro_det WHERE  ro_domain = GLOBAL_domain AND ro_routing = v_routing  AND ro_start <= TODAY NO-LOCK NO-ERROR .
                        IF AVAILABLE ro_det THEN
                            xxrt_wkctr = ro_wkctr .
                        ELSE 
                            xxrt_wkctr = "" .


             
                         
                            
                            ASSIGN
                                xxrt_wonbr
                                xxrt_rsn = v_rsn 
                                xxrt_method = v_method1
                              
                                .
 
             /* ss - 100622.1 - b */
                        DO ON ERROR UNDO :
                      
                           PROMPT-FOR xxrt_wodpart WITH FRAME b .

                           FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part =  INPUT xxrt_wodpart NO-LOCK NO-ERROR .
                           IF NOT AVAILABLE pt_mstr  THEN DO:
                               MESSAGE "零件不存在" .
                               UNDO ,RETRY .
                           END.
                           
                              FIND FIRST wod_det WHERE wod_domain = GLOBAL_domain AND wod_lot = xxrt_wolot AND wod_part = INPUT xxrt_wodpart NO-LOCK NO-ERROR .
                                IF AVAILABLE wod_det  THEN
                                  xxrt_relqty = wod_qty_iss .
                              

                               ASSIGN
                                 
                                     xxrt_wodpart .

                             
                          

                       END.
           

             find xxrt_det where xxrt_domain = global_domain and xxrt_site_from = site  and  xxrt_nbr = rcvno and xxrt_type = p-type AND xxrt_line = input xxrt_line  no-error.
             IF AVAILABLE xxrt_det THEN DO:
                    DISPLAY  xxrt_line  xxrt_wonbr    xxrt_wodpart xxrt_relqty xxrt_qty_from   /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */  xxrt_method with frame b .     
                     
             END.
          END. /* v_add */
          /* ss - 10027.1 -e */

         END.   /* newrec*/

         setd:
         DO ON ERROR UNDO,RETRY:
        
             PROMPT-FOR xxrt_qty_from  /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */  xxrt_method GO-ON(F5 CTRL-D ) WITH FRAM b .
             /* ss - 100707.1 -b
             IF INPUT xxrt_qty_from > xxrt_relqty THEN DO:
                 MESSAGE "退料数量大于发料数量"  .
                 NEXT-PROMPT xxrt_qty_from .
                 UNDO ,RETRY .
             END.
             ss - 100707.1 -e */
       /* ss - 100714.1 -b
           IF INPUT xxrt_rsn = "" THEN  DO:
                MESSAGE "退料原因不能为空"  .
                NEXT-PROMPT xxrt_rsn .
                UNDO ,RETRY .
            END.
            ss - 100714.1 -e */

              FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain  AND CODE_fldname = "xxrt" AND CODE_value = INPUT xxrt_method NO-LOCK NO-ERROR .
               IF NOT  AVAILABLE CODE_mstr THEN DO:
                     MESSAGE "处理方法不存在" .
                     NEXT-PROMPT xxrt_method .
                     UNDO ,RETRY .
               END.
               ELSE 
                DISPLAY CODE_cmmt @ v_method WITH FRAME b .

        END.  /* setd */
     assign  xxrt_qty_from   /* ss - 100714.1 - b */   /* xxrt_rsn */   xxrt_lot_from   /* ss - 100714.1 -e */  xxrt_method .

        /* DELETE */
        if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
        then do:
           del-yn = yes.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           if del-yn then do:
              delete xxrt_det.
              clear frame b.
              del-yn = no.
              next.
           end.
        end.


   end.  /* setb:   */

  

 END .  /* seta */

  /* ss - 100809.1 -b */
   DO TRANSACTION :
   
       FOR EACH usrw_wkfl WHERE usrw_domain = global_domain AND usrw_key1 = "xxwo" AND usrw_key2 BEGINS "xxwo" + GLOBAL_userid +  rcvno  :
           DELETE usrw_wkfl .
       END.

    
            FOR EACH usrw_wkfl WHERE usrw_domain = global_domain AND usrw_key1 = "xxwopart" AND usrw_key2 BEGINS "xxwopart" + GLOBAL_userid +  rcvno  :
           DELETE usrw_wkfl .
       END.
   
       
       RELEASE usrw_wkfl .
    END.
 /* ss - 100809.1 -e */
HIDE FRAME a NO-PAUSE .
CLEAR FRAME a NO-PAUSE .
 {gprun.i ""xxricrt22.p"" "(input rcvno)"}
     /*
 END .  /* repeat d */
 */
status input.
