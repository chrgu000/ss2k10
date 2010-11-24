/* wowoisc.p - WORK ORDER ISSUE WITH SERIAL NUMBERS - ISSUE COMPONENTS        */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */



/* Revision: 1.39          BY: ken chen     DATE: 08/06/08  ECO: *SS - 20080806.1* */

/* Revision: 1.39          BY: ken chen     DATE: 08/06/08  ECO: *SS - 20080822.1* */

/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*DISPLAY TITLE */
{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
DEFINE SHARED VARIABLE nbr LIKE wo_nbr.
DEFINE SHARED VARIABLE loc_to   LIKE loc_loc.
DEFINE SHARED VARIABLE eff_date  AS DATE.
define variable msg-arg as character format "x(12)" no-undo.
DEFINE VARIABLE v_sq_qty AS DECIMAL.
DEFINE VARIABLE part           LIKE pt_part.
DEFINE SHARED VARIABLE site           LIKE pt_site.
DEFINE SHARED VARIABLE site1          LIKE pt_site.
DEFINE SHARED VARIABLE loc_from       LIKE loc_loc.
DEFINE VARIABLE lotser_from      LIKE ld_lot.
DEFINE VARIABLE lotser_from_qty  AS DECIMAL FORMAT "->>>>>>9.9999".
DEFINE VARIABLE lotref_from         LIKE ld_ref.
DEFINE VARIABLE yn             LIKE mfc_logic.
DEFINE VARIABLE fn_i           AS CHAR .
DEFINE VARIABLE FIRSTerror     AS CHARACTER FORMAT "x(60)".
DEFINE VARIABLE v_loc_to       LIKE loc_loc.
DEFINE VARIABLE v_tr_trnbr     LIKE tr_trnbr.
DEFINE VARIABLE v_iss_trnbr    LIKE tr_trnbr.
DEFINE VARIABLE ln AS INTEGER.
DEFINE VARIABLE del-yn AS LOGICAL.

DEFINE SHARED TEMP-TABLE iss    
                  FIELD iss_part      LIKE tr_part
                  FIELD iss_site      LIKE tr_site
                  FIELD iss_loc       LIKE tr_loc
                  FIELD iss_serial    LIKE tr_serial
                  FIELD iss_ref       LIKE tr_ref
                  FIELD iss_locto     LIKE tr_loc
                  FIELD iss_loc_qty   AS DECIMAL FORMAT "->>>>>>9.9999"
                  FIELD iss_um        LIKE pt_um
                  FIELD iss_trnbr     AS INTEGER FORMAT "->9"
                  INDEX iss_part iss_part .


DEFINE SHARED TEMP-TABLE isslog    
                  FIELD isslog_part      LIKE tr_part
                  FIELD isslog_site      LIKE tr_site
                  FIELD isslog_loc       LIKE tr_loc
                  FIELD isslog_serial    LIKE tr_serial
                  FIELD isslog_ref       LIKE tr_ref
                  FIELD isslog_loc_qty   AS DECIMAL FORMAT "->>>>>>9.9999"
                  FIELD isslog_um        LIKE pt_um
                  FIELD isslog_ok        AS LOGICAL
    FIELD isslog_trnbr     AS INTEGER FORMAT "->9"  
    INDEX isslog_part isslog_part .

DEFINE VARIABLE  v_lotser_from_qty LIKE ld_qty_oh .
DEFINE VARIABLE  Success AS CHARACTER.
DEFINE SHARED VARIABLE Hash     AS DECIMAL FORMAT "->>>>>>>>.9999".

form with frame c 5 down no-attr-space width 80.
form
   ln             COLON 16
   part           colon 16
   /*SS - 20080822.1 site           colon 43*/
   /*SS - 20080822.1 loc_from       colon 56*/   
   pt_desc1       colon 16     lotser_from    COLON 56   
   lotser_from_qty  colon 16   pt_um          colon 38   lotref_from         colon 56   
with frame d
side-labels
width 80
attr-space.
setFrameLabels(frame c:handle).
setFrameLabels(frame d:handle).
pause 0.
Hash = 0.
ASSIGN
     global_site = site
     global_loc  = loc_from.
view frame c.
view frame d.
EMPTY TEMP-TABLE isslog.
pause before-hide.
mainloop:
/*SS - 20080822.1
do transaction on endkey undo,leave:
*/
do on endkey undo,leave:
   setd:
   do while true:
      /* SS - 20080822.1 B*/
      set_yn:
      do on error undo, retry:
         /* SS - 20080822.1 E*/
         /* DISPLAY DETAIL */
         select-part:
         repeat:
            clear frame c all no-pause.
            clear frame d no-pause.
            view frame c.
            view frame d.
            FOR EACH iss NO-LOCK WHERE iss_trnbr > v_iss_trnbr - 5 BY iss_trnbr:
               display
                  iss_trnbr  COLUMN-LABEL "Ln"   
                  iss_part
                  /* SS - 20080822.1         iss_site  */
                  /* SS - 20080822.1          iss_loc  */
                  iss_serial
                  iss_ref
                  iss_loc_qty  COLUMN-LABEL "Transfer Qty"
                  iss_um   
               with frame c .
          
               if frame-line(c) = frame-down(c)
               then
                  leave.          
               down 1 with frame c.
            END.         
            part = "" .
            do on error undo, retry:
            
               PROMPT-FOR               
                   ln
               with frame d
               editing:                    
                  /* FIND NEXT/PREVIOUS  RECORD */
                  {mfnp.i iss  ln  " iss_trnbr "  ln iss_trnbr iss_part}
                  if recno <> ? then do:
                        ASSIGN
                           part = iss_part
                           site = iss_site
                           loc_from = iss_loc
                           lotser_from = iss_serial
                           lotref_from = iss_ref
                           lotser_from_qty = iss_loc_qty.
                           v_iss_trnbr  = iss_trnbr.
                           ln = iss_trnbr.
                           FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = part NO-LOCK NO-ERROR.
                           IF AVAIL pt_mstr THEN
                               DISP pt_desc1 pt_um WITH FRAME d.
                           DISPLAY
                                ln
                                part
                            /*ss - 20080822.1    site */
                            /*ss - 20080822.1    loc_from */
                                lotser_from
                                lotref_from
                                lotser_from_qty WITH FRAME d .           
                  END.                                        
               end. /* SET part op WITH FRAME d EDITING */
               ASSIGN ln.

               IF ln <= 0  THEN DO:
                   MESSAGE "项次不能为空".
                   UNDO,RETRY.
               END.

               FIND FIRST iss WHERE iss_trnbr = ln NO-LOCK NO-ERROR.
               IF NOT AVAIL iss THEN DO:                              
                  PROMPT-FOR               
                      part
                  with frame d
                  editing:                    
                     /* FIND NEXT/PREVIOUS  RECORD */
                     {mfnp.i iss  part  " iss_part "  part iss_part iss_part}
                     if recno <> ? then do:
                           ASSIGN
                              part = iss_part
                              site = iss_site
                              loc_from = iss_loc
                              lotser_from = iss_serial
                              lotref_from = iss_ref
                              lotser_from_qty = iss_loc_qty.
                              v_iss_trnbr  = iss_trnbr.
                              FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = part NO-LOCK NO-ERROR.
                              IF AVAIL pt_mstr THEN
                                  DISP pt_desc1 pt_um WITH FRAME d.
                              DISPLAY
                                   part
                               /*ss - 20080822.1    site */
                               /*ss - 20080822.1    loc_from */
                                   lotser_from
                                   lotref_from
                                   lotser_from_qty WITH FRAME d .           
                     END.                                        
                  end. /* SET part op WITH FRAME d EDITING */
               END.
               ELSE DO:
                  ASSIGN
                     part = iss_part
                     site = iss_site
                     loc_from = iss_loc
                     lotser_from = iss_serial
                     lotref_from = iss_ref
                     lotser_from_qty = iss_loc_qty.
                     v_iss_trnbr  = iss_trnbr.
                     ln = iss_trnbr.
                     FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = part NO-LOCK NO-ERROR.
                     IF AVAIL pt_mstr THEN
                         DISP pt_desc1 pt_um WITH FRAME d.
                     DISPLAY
                          ln
                          part
                      /*ss - 20080822.1    site */
                      /*ss - 20080822.1    loc_from */
                          lotser_from
                          lotref_from
                          lotser_from_qty WITH FRAME d .           
               END.


               STATUS INPUT .
               ASSIGN part.            
               FIND FIRST ISS WHERE ISS_trnbr = ln NO-LOCK NO-ERROR.
               IF NOT AVAIL iss THEN DO:           
                   ASSIGN
                       lotser_from_qty = 0.00
                       lotser_from     = ""
                       lotref_from        = "".
                   display
                      /*ss - 20080822.1  loc_from */
                        lotser_from
                        lotref_from
                        lotser_from_qty WITH FRAME d .   
               END.
               ELSE DO:
                  ASSIGN
                       part = iss_part
                       site = iss_site
                       loc_from = iss_loc
                       lotser_from = iss_serial
                       lotref_from = iss_ref
                       lotser_from_qty = iss_loc_qty.
                       v_iss_trnbr  = iss_trnbr.
   
                       FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = part NO-LOCK NO-ERROR.
                       IF AVAIL pt_mstr THEN
                           DISP pt_desc1 pt_um WITH FRAME d.
   
                       display
   
                           part
                           /*ss - 20080822.1    site */
                           /*ss - 20080822.1    loc_from */
                           lotser_from
                           lotref_from
                           lotser_from_qty WITH FRAME d .           
   
               END.
     
               IF NOT CAN-FIND(FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = part) AND part <> "" THEN DO:
                    {pxmsg.i &MSGNUM=7118 &ERRORLEVEL=3}
                    UNDO,RETRY.
               END.
               FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = part NO-LOCK NO-ERROR.
               IF AVAIL pt_mstr THEN
                   DISP pt_desc1 pt_um WITH FRAME d.
   
               if part = ""
               then
                  leave.
   
                     
               GLOBAL_part = part .
   
               frame-d-loop:
               repeat:
   
                  locloop:
                  do on error undo, retry
                     on endkey undo select-part, retry:
    
                     SET
                        lotser_from_qty
                       /*ss - 20080822.1 site */
                       /*ss - 20080822.1 loc_from */
                        lotser_from
                        lotref_from
                     
                     go-on (F5 CTRL-D) with frame d
                     editing:
   
                        ASSIGN
                           global_lot  = INPUT lotser_from.
                        readkey.
                        apply lastkey.
                     end. /* UPDATE WITH FRAME d EDITING */
   
                     ASSIGN 
                        lotser_from_qty
                        lotser_from
                        lotref_from .

                   if lastkey = keycode("F5") or
                      lastkey = keycode("CTRL-D") then do:
                      del-yn = yes.
                      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}         
             	       if del-yn then do:
                          FOR EACH iss WHERE iss_trnbr = ln:
                             DELETE iss.
                          END.
                          FOR EACH usrw_wkfl WHERE usrw_domain = GLOBAL_domain
                              AND usrw_key1 = "SS-ICTR"
                              AND usrw_key2 = nbr + "-" + STRING(ln):
                              DELETE usrw_wkfl.
                          END.
   

                          LEAVE.
                      END.
                   END.


                     
   		            
                      v_sq_qty =  0.
                      FOR EACH usrw_wkfl WHERE usrw_domain = GLOBAL_domain
                             AND usrw_key1 = "SS-ICTR"
                             AND usrw_key4 <> "YES"
                             AND usrw_charfld[1] = site
                             AND usrw_charfld[3] = loc_from
                             NO-LOCK:
                             v_sq_qty = v_sq_qty + usrw_decfld[1].
                      END.
                  
                      FIND FIRST ld_det WHERE ld_domain = GLOBAL_domain AND ld_site = site AND ld_loc = loc_from 
                                           AND ld_lot = lotser_from AND ld_ref = lotref_from AND ld_part = part  no-lock no-error.
                      IF AVAILABLE ld_det then do:
                  		    IF (ld_qty_oh - v_sq_qty) < lotser_from_qty then do:                              
                  		    msg-arg = string(ld_qty_oh - v_sq_qty).
                                     {pxmsg.i &MSGNUM=208 &ERRORLEVEL=3
                                                  &MSGARG1=msg-arg}
                                      undo, retry.
                    		    end.
                  	 end.
                                    
                  
                     /*
                     FIND FIRST ld_det WHERE ld_domain = GLOBAL_domain AND ld_site = site AND ld_loc = loc_from 
                                          AND ld_part = part  no-lock no-error.
                     IF AVAILABLE ld_det then do:
                        MESSAGE("此库位不存在此物料").  
                        undo, retry.
                     end.
                     */
                      /*
                      IF lotser_from_qty < 0 THEN DO:
                         v_lotser_from_qty = 0.
                         FOR EACH ld_det WHERE ld_domain = GLOBAL_domain AND ld_loc = loc_to AND ld_part = part 
     		                        AND ld_lot = lotser_from AND ld_ref = lotref_from AND ld_site = site  NO-LOCK :
                             v_lotser_from_qty = v_lotser_from_qty + ld_qty_oh.
                         END.
   
                         IF v_lotser_from_qty + lotser_from_qty < 0 THEN DO:
                              {pxmsg.i &MSGNUM=91023 &ERRORLEVEL=3}
   			                   v_lotser_from_qty  = 0.  
                              UNDO ,RETRY.
                         END.
                      END.
                      */
                      /*
                       IF lotser_from_qty < 0 THEN DO: 
                        {pxmsg.i &MSGNUM=2969 &ERRORLEVEL=3}
                         UNDO ,RETRY.
                         
   		              END.
                     */ 
                     
      
                
                      FIND FIRST iss WHERE iss_trnbr = ln NO-ERROR.
                      IF NOT AVAIL iss THEN DO:
         
                         
                         FIND LAST iss NO-LOCK NO-ERROR.
                         IF AVAIL iss  THEN 
                            v_iss_trnbr = iss_trnbr + 1.
                         ELSE
                            v_iss_trnbr = 1.
         
                         IF v_iss_trnbr > 99 THEN DO:
                             {pxmsg.i &MSGNUM=91020 &ERRORLEVEL=3}
                             UNDO  ,RETRY.
                         END.
                         CREATE iss.
                         ASSIGN                  
                              iss_part = part
                              iss_site = site
                              iss_loc  = loc_from
                              iss_serial = lotser_from
                              iss_ref    = lotref_from
                              iss_locto  = v_loc_to
                              iss_loc_qty = lotser_from_qty
                              iss_um      = pt_um
                              iss_trnbr   = ln.
                      END.
                      ELSE DO:
                              iss_loc_qty = lotser_from_qty.
                      END.
                  end. /* locloop */
                  leave.
               end. /* frame-d-loop */
            end. /* DO ON ERROR, UNDO RETRY */
      end. /* select-part */ 

      do on endkey undo mainloop, leave mainloop:

         assign
            yn              = yes.

         {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}

	      Hash = 0.
         FOR EACH iss WHERE iss_loc_qty <> 0 NO-LOCK BY iss_trnbr :

              Hash = hash +  iss_loc_qty.
         End. 

         if yn
         then do:

            hide frame c no-pause.

            hide frame d no-pause.

            Hash = 0.
            FOR EACH iss WHERE iss_loc_qty <> 0 NO-LOCK BY iss_trnbr
            with frame dd
            width 80:

              Hash = hash +  iss_loc_qty.
                
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame dd:handle).
             DISP
                 iss_trnbr    COLUMN-LABEL "Ln" 
                 iss_part
                 iss_serial   COLUMN-LABEL "Lot/Serial"
                 iss_ref      COLUMN-LABEL "Reference"
                 iss_loc_qty  COLUMN-LABEL "Transfer Qty"
                 iss_um    COLUMN-LABEL "UM"
                 .
                   {gpwait.i &INSIDELOOP=yes &FRAMENAME=dd}
            end. 
            {gpwait.i &OUTSIDELOOP=yes}
          
         end. /* IF yn */



      end. /* DO ON ENDKEY UNDO mainloop, LEAVE mainloop */


      do on endkey undo mainloop, leave mainloop:

         yn = yes.
          MESSAGE("                                          Hash Total:" + STRING(hash,"->>>>>>9.9999")).
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}


         
         IF yn THEN DO:
            FOR EACH iss WHERE iss_loc_qty <> 0 NO-LOCK:
                FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
                   AND usrw_key1 = "SS-ICTR"
                   AND usrw_key2 = nbr + "-" + STRING(iss_trnbr)
                   NO-ERROR.
                IF NOT AVAIL usrw_wkfl THEN DO:
                   CREATE usrw_wkfl.
                   ASSIGN usrw_domain = GLOBAL_domain
                          usrw_key1 = "SS-ICTR"
                          usrw_key2 = nbr + "-" + STRING(iss_trnbr)
                          usrw_key3 = nbr
                          usrw_key5 = "ICTR"
                          usrw_intfld[1] = iss_trnbr
                          usrw_charfld[1] = iss_site
                          usrw_charfld[10] = site1
                          usrw_charfld[2] = loc_to
                          usrw_charfld[3] = iss_loc
                          usrw_charfld[4] = iss_serial
                          usrw_charfld[5] = iss_ref
                          usrw_charfld[6] = iss_part
                          usrw_decfld[1] = iss_loc_qty
                          usrw_datefld[1] = eff_date.
                END.
                ELSE DO:

                   ASSIGN 
                          usrw_key3 = nbr
                          usrw_key5 = "ICTR"
                          usrw_intfld[1] = iss_trnbr
                          usrw_charfld[1] = iss_site
                          usrw_charfld[10] = site1
                          usrw_charfld[2] = loc_to
                          usrw_charfld[3] = iss_loc
                          usrw_charfld[4] = iss_serial
                          usrw_charfld[5] = iss_ref
                          usrw_charfld[6] = iss_part
                          usrw_decfld[1] = iss_loc_qty
                          usrw_datefld[1] = eff_date.
                END.
            END.
         END.
         /*
         if yn
         then do:


            hide frame c.

            hide frame d.


          FOR EACH iss WHERE iss_loc_qty <> 0 NO-LOCK:
               fn_i = "".

           /*
	       find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "xxmcercl_DIRECTORY02" no-error.
               if available mfc_ctrl then
                  fn_i = mfc_char.
           */       
                  fn_i = "xxictrws" + STRING(TIME).



               OUTPUT TO VALUE(fn_i + ".inp" ).
 
               PUT UNFORMATTED iss_part SKIP.
               PUT UNFORMATTED iss_loc_qty  " " eff_date " "  nbr " " "- -"   SKIP.
               PUT UNFORMATTED "- - - -" SKIP.
               PUT UNFORMATTED iss_site " " iss_loc " " """" + iss_serial + """"  " " """" + iss_ref + """" SKIP.
               PUT UNFORMATTED iss_site " " loc_to " " "- -" SKIP.
               PUT UNFORMATTED "." SKIP.
               PUT UNFORMATTED "." SKIP.
               OUTPUT CLOSE .
              

               FIND LAST tr_hist WHERE tr_domain = GLOBAL_domain NO-LOCK NO-ERROR.
                v_tr_trnbr = tr_trnbr .

               batchrun = yes.
               INPUT FROM VALUE(fn_i + ".inp" ) .
               OUTPUT TO VALUE(fn_i + ".cim" ) .
               {gprun.i ""iclotr04.p""}
               INPUT CLOSE .
               OUTPUT CLOSE .

               batchrun = NO.
               
               FIND LAST tr_hist WHERE tr_domain = GLOBAL_domain 
                   AND tr_nbr = nbr 
                   AND tr_effdate = eff_date
                   AND tr_part = iss_part 
                   AND tr_loc = iss_loc 
                   AND tr_serial = iss_serial 
                   AND tr_ref = iss_ref
                   AND tr_qty_loc = - iss_loc_qty
                   AND tr_trnbr > v_tr_trnbr
                   AND tr_type = "ISS-TR" NO-LOCK NO-ERROR .
               IF AVAIL tr_hist THEN DO:

                   CREATE isslog.
                   ASSIGN isslog_site = iss_site
                          isslog_loc  = v_loc_to
                          isslog_serial = iss_serial
                          isslog_ref    = iss_ref
                          isslog_loc_qty = iss_loc_qty
			  isslog_um     = iss_um
                          isslog_part   = iss_part
                          isslog_trnbr  = iss_trnbr
                          isslog_ok     = TRUE.
               END.
               ELSE DO:

                   CREATE isslog.
                   ASSIGN isslog_site   = iss_site
                          isslog_loc    = v_loc_to
                          isslog_serial = iss_serial
                          isslog_ref    = iss_ref
                          isslog_loc_qty = iss_loc_qty
			               isslog_um     = iss_um
                          isslog_part   = iss_part
                          isslog_trnbr  = iss_trnbr
                          isslog_ok     = FALSE.

               END.


              
          END.
           

          
          UNIX SILENT VALUE("rm -rf " + TRIM(fn_i) + ".inp") .
          UNIX SILENT VALUE("rm -rf " + TRIM(fn_i) + ".cim") .
          
           

         end. /* IF yn */

         */

      end. /* DO ON ENDKEY UNDO mainloop, LEAVE mainloop */


      IF NOT yn THEN  DO:
         v_iss_trnbr = 1 .
         UNDO set_yn, RETRY.
          
      END.

      /*
      do on endkey undo mainloop, leave mainloop:

            hide frame c no-pause.

            hide frame d no-pause.
            HIDE FRAME dd NO-PAUSE.
            FOR EACH isslog NO-LOCK BY isslog_trnbr
            with frame ee
            width 80:

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame ee:handle).
             DISP
                 isslog_trnbr   COLUMN-LABEL "Ln"
                 isslog_part
                 isslog_serial  COLUMN-LABEL "Lot/Serial"
                 isslog_ref     COLUMN-LABEL "Reference"
                 isslog_loc_qty COLUMN-LABEL "Transfer Qty"
                 isslog_um         COLUMN-LABEL "UM"
                 isslog_ok      COLUMN-LABEL "Upd"
                .


               {gpwait.i &INSIDELOOP=yes &FRAMENAME=ee}
            end. 
            {gpwait.i &OUTSIDELOOP=yes}

            FIND FIRST isslog WHERE NOT isslog_ok NO-LOCK NO-ERROR.

            IF AVAIL isslog  THEN DO:

               /* MESSAGE("Error FOUND, NOT All Updated, Continue to Correct") .    20080829*/
                    {pxmsg.i &MSGNUM=4069 &ERRORLEVEL=2}
		

            END.

            leave setd.

      end. /* DO ON ENDKEY UNDO mainloop, LEAVE mainloop */
      */
       leave setd.
   /* SS - 20080822.1 B*/
      END.


   /* SS - 20080822.1 E*/
   end. /* setd */
/*
     hide frame dd  no-pause.
     hide frame ee  no-pause.
*/
end. /* mainloop */


