/*YYtlupldsi.p        --         Transfer Order Building Accoording To BOM        */
/*Revision: Eb2 + sp7       Last modified: 07/28/2005             By: Judy Liu */
 
/*display the title*/
{mfdtitle.i "b+"}

DEFINE VARIABLE xxsite like si_site.
DEFINE VARIABLE xxsite1 LIKE si_site.
DEFINE VARIABLE  xxsidesc like si_desc.
DEFINE VARIABLE xxsidesc1 LIKE si_desc.
DEFINE VARIABLE  effdate LIKE tr_effdate.
DEFINE VARIABLE xxnbr LIKE tr_nbr.
DEFINE VARIABLE xxpart LIKE tr_part.
DEFINE VARIABLE xxqty AS INTEGER .
DEFINE VARIABLE xxentity LIKE si_entity.
DEFINE VARIABLE xxentity1 LIKE si_entity.
DEFINE VARIABLE xxloc LIKE loc_loc.
DEFINE VARIABLE xxloc1 LIKE loc_loc.
DEFINE VARIABLE rmks AS CHAR FORMAT  "x(30)".
DEFINE VARIABLE xxqtyreq LIKE tr_qty_loc FORMAT "->>>,>>>,>>9.99".
DEFINE VARIABLE msg-nbr as inte.
DEFINE VARIABLE ok_yn as logic.
DEFINE VARIABLE  xxpart1 LIKE pt_part.
DEFINE VARIABLE part LIKE ps_par INITIAL "88-200" .
DEFINE  VARIABLE site1 like in_site .
DEFINE VARIABLE pkerr AS CHAR FORMAT "x(50)".
DEFINE VARIABLE i AS INTE.

DEFINE new shared VARIABLE transtype as character format "x(4)".
DEFINE new shared VARIABLE errmsg as integer .


DEFINE VARIABLE eff_date LIKE ps_start INITIAL TODAY .
DEFINE NEW shared workfile pkdet no-undo
            field pkpart like ps_comp
            field pkop as integer
                          format ">>>>>9"
            field pkstart like pk_start
            field pkend like pk_end
            field pkqty like pk_qty
            field pkbombatch like bom_batch
            field pkltoff like ps_lt_off. 
 
FOR EACH pkdet:
    DELETE pkdet.
END.

{gpglefv.i}
{gprunpdf.i "gpglvpl" "p"}

FORM /*GUI*/ 
    SKIP(.4)        
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.2)  /*GUI*/
 xxsite  colon 22 xxsidesc NO-LABEL 
 xxsite1 COLON 22  xxsidesc1 NO-LABEL SKIP(1)
 effdate COLON 22
   xxnbr COLON 22
    xxpart COLON 22
    xxqty COLON 50
          SKIP(.5)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
 setFrameLabels(frame a:handle) .

 mainloop:
REPEAT:
        effdate = TODAY.
        DISP effdate WITH FRAME a.

        /*input issue site*/
          UPDATE  xxsite  WITH   FRAME  a EDITING :
                IF  frame-field = "xxsite" then DO :
                      {mfnp.i si_mstr xxsite si_site xxsite si_site si_site}
                      IF  recno <> ? then do:
                         disp si_site @ xxsite si_desc @ xxsidesc with frame a.    
                      END .
                 END .
                 ELSE  DO :
                     READKEY.
                    APPLY  LASTKEY .
                END .
          END .       
              
       /*verify the input site*/ 
       find si_mstr no-lock where si_site = xxsite no-error.
       if not available si_mstr or (si_db <> global_db) then do:
           IF  not available si_mstr then msg-nbr = 708.
           else msg-nbr = 5421.
           {pxmsg.i &MSGNUM=msg-nbr &ERRORLEVEL=3}    
           undo, retry.
       end.
            
            if available si_mstr then disp si_site @ xxsite si_desc @ xxsidesc with frame a.
             xxentity = si_entity.      
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if return_int = 0 then do:
                      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
                  undo,retry.
             end.  

             /*input receipt site*/
             UPDATE  xxsite1  WITH   FRAME  a EDITING :
                    IF  frame-field = "xxsite1" then DO :
                          {mfnp.i si_mstr xxsite1 si_site xxsite1 si_site si_site}
                          IF  recno <> ? then do:
                             disp si_site @ xxsite1 si_desc @ xxsidesc1 with frame a.    
                          END .
                     END .
                     ELSE  DO :
                         READKEY.
                        APPLY  LASTKEY .
                    END .
              END .       

           /*verify the input site*/ 
           find si_mstr no-lock where si_site = xxsite1 no-error.
           if not available si_mstr or (si_db <> global_db) then do:
               IF  not available si_mstr then msg-nbr = 708.
               else msg-nbr = 5421.
               {pxmsg.i &MSGNUM=msg-nbr &ERRORLEVEL=3}    
               undo, retry.
           end.

                if available si_mstr then disp si_site @ xxsite1 si_desc @ xxsidesc1 with frame a.
                   xxentity1 = si_entity. 
                    {gprun.i ""gpsiver.p""
                    "(input si_site, input recid(si_mstr), output return_int)"}
    /*GUI*/ if global-beam-me-up then undo, leave.

                      if return_int = 0 then do:
                          {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
                      undo,retry.
                 end.  
    
                 seta:
                 DO on endkey undo mainloop, retry mainloop on error undo, retry
                 with frame a:
    
                     UPDATE  effdate  xxnbr xxpart validate(can-find(first pt_mstr
                           where pt_part = INPUT xxpart),  "零件不存在") 
                          xxqty  validate(INPUT xxqty > 0, "台份不能小于0") WITH   FRAME  a .
                     /*validate effdate*/ 
                     {gpglef1.i
                                    &module = ""IC"" 
                                    &entity = xxentity
                                    &date = effdate
                                    &prompt = "effdate"
                                    &frame = "a"
                                    &loop = "seta"}
         
                          {gpglef1.i
                                               &module = ""IC""
                                               &entity = xxentity1
                                               &date = effdate
                                               &prompt = "effdate"
                                               &frame = "a"
                                               &loop = "seta"}
                     /*validate transfer order nbr*/                          
                     FIND FIRST tr_hist WHERE tr_nbr = xxnbr USE-INDEX tr_nbr_eff NO-LOCK NO-ERROR.
                     IF AVAIL tr_hist  THEN DO:
                          MESSAGE "订单已存在" VIEW-AS  ALERT-BOX ERROR.
                         UNDO, RETRY.
                     END.
                     FIND FIRST xxtl_det WHERE xxtl_nbr = xxnbr NO-LOCK NO-ERROR.
                     IF AVAIL xxtl_det THEN DO:
                         MESSAGE "订单已存在" VIEW-AS  ALERT-BOX ERROR.
                         UNDO, RETRY.
                     END.
     
                 
                     /*validate part */
                     FIND FIRST ptp_det WHERE ptp_part = xxpart AND ptp_site = xxsite NO-LOCK NO-ERROR.
                     IF AVAIL ptp_det  THEN DO:
                         IF ptp_bom_code <> ""  THEN DO:
                             FIND FIRST ps_mstr WHERE ps_par = ptp_bom_code AND ps__chr01 = xxsite NO-LOCK NO-ERROR.
                             IF NOT AVAIL ps_mstr  THEN DO:
                                 MESSAGE "机型在移出地点不存在BOM" VIEW-AS  ALERT-BOX ERROR.
                                 UNDO, RETRY.
                             END.
                         END.
                         ELSE IF ptp_bom_code = "" THEN DO:
                         
                             FIND FIRST ps_mstr WHERE ps_par = xxpart AND ps__chr01 = xxsite  AND  ps_comp <> "" NO-LOCK NO-ERROR.
                             IF NOT AVAIL ps_mstr  THEN DO:
                                 MESSAGE "机型在移出地点不存在BOM" VIEW-AS  ALERT-BOX ERROR.
                                 UNDO,RETRY.
                             END.
                         END.
                     END.
                     ELSE IF NOT AVAIL ptp_det THEN DO:
                          FIND FIRST ps_mstr WHERE ps_par = xxpart AND ps__chr01 = xxsite  AND ps_comp <> "" NO-LOCK NO-ERROR.
                             IF NOT AVAIL ps_mstr  THEN DO:
                                 MESSAGE "机型在移出地点不存在BOM" VIEW-AS  ALERT-BOX ERROR.
                                 UNDO,RETRY.
                             END.
                     END.
                    
                     /**
                     /*validate DEFINEault loc*/
                     FIND FIRST in_mstr WHERE in_site = xxsite AND in_part = xxpart  NO-LOCK  NO-ERROR.
                     IF NOT AVAIL in_mstr THEN DO: 
                         MESSAGE "机型在地点" + Xxsite + "中没有定义(1.4.16)缺省库位" VIEW-AS  ALERT-BOX ERROR.
                         UNDO, RETRY.
                     END.
                     IF AVAIL in_mstr  THEN DO:
                         FIND FIRST loc_mstr WHERE loc_site = xxsite AND loc_loc = in_user1 NO-LOCK NO-ERROR.
                         IF NOT AVAIL loc_mstr  THEN DO:
                                MESSAGE "机型在地点" + Xxsite + "中定义(1.4.16)的缺省库位不存在" VIEW-AS  ALERT-BOX ERROR.
                                UNDO,RETRY.
                         END.
                         xxloc = IN_user1.
                     END.

                     FIND FIRST in_mstr WHERE in_site = xxsite1 AND in_part = xxpart  NO-LOCK  NO-ERROR .
                     IF NOT AVAIL in_mstr THEN DO:
                         MESSAGE "机型在地点" + Xxsite1 + "中没有定义(1.4.16)缺省库位" VIEW-AS  ALERT-BOX ERROR.
                         UNDO, RETRY.
                     END.
                     IF AVAIL in_mstr  THEN DO:
                         FIND FIRST loc_mstr WHERE loc_site = xxsite1 AND loc_loc = in_user1 NO-LOCK NO-ERROR.
                         IF NOT AVAIL loc_mstr  THEN DO:
                                MESSAGE "机型在地点" + Xxsite1 + "中定义(1.4.16)的缺省库位不存在" VIEW-AS  ALERT-BOX ERROR.
                                UNDO, RETRY.
                         END.
                         xxloc1 = IN_user1.
                     END.   **/   
                     
           END. /*end of seta */
          
            {mfselprt.i "printer" 80} 
        i = 0.
        FOR EACH ptp_det WHERE ptp_part = xxpart AND ptp_site = xxsite NO-LOCK:
           /* MESSAGE ptp_part.
            PAUSE .*/
            IF ptp_bom_code <> ""  THEN xxpart1 = ptp_bom_code.
            ELSE xxpart1 = xxpart.   
            {gprun.i ""yybmpkiqa.p"" "(input xxpart1,
                                           INPUT xxsite,
                                           INPUT effdate)"}
             pkerr = "". 
             xxqtyreq = 0.
             FOR EACH pkdet NO-LOCK:

                 IF xxsite <> xxsite1 THEN DO:
                   
                     FIND FIRST in_mstr WHERE in_site = xxsite AND in_part = pkpart  NO-LOCK  NO-ERROR.
                         IF NOT AVAIL in_mstr THEN DO:   
                         
                             pkerr = "机型在地点" + Xxsite + "中没有定义(1.4.16)缺省库位".
                             
                         END.
                         ELSE IF AVAIL in_mstr  THEN DO:
                             FIND FIRST loc_mstr WHERE loc_site = xxsite AND loc_loc = in_user1 NO-LOCK NO-ERROR.
                             IF NOT AVAIL loc_mstr  THEN DO:
                                pkerr =  "机型在地点" + Xxsite + "中定义(1.4.16)的缺省库位不存在".
                                 
                             END.
                             ELSE xxloc = IN_user1.
                         END.
    
                       FIND FIRST in_mstr WHERE in_site = xxsite1 AND in_part = pkpart  NO-LOCK  NO-ERROR .
                         IF NOT AVAIL in_mstr THEN DO: 
                            
                            /*pkerr =  "机型在地点" + Xxsite1 + "中没有定义(1.4.16)缺省库位" . */
                             FIND FIRST CODE_mstr WHERE CODE_fldname = "transfer_des_loc" AND TRIM(CODE_value) =  xxsite1 NO-LOCK NO-ERROR.
                             IF AVAIL CODE_mstr THEN DO:
                                 FIND loc_mstr WHERE loc_site = xxsite1 AND loc_loc = TRIM(CODE_cmmt) NO-LOCK NO-ERROR.
                                 IF AVAIL loc_mstr THEN  xxloc1 = TRIM(CODE_cmmt).
                                 ELSE pkerr = "在通用代码中维护的移入库位不存在".
                             END.  
                        END.
                             
                         ELSE IF AVAIL in_mstr  THEN DO:
                             FIND FIRST loc_mstr WHERE loc_site = xxsite1 AND loc_loc = in_user1 NO-LOCK NO-ERROR.
                             IF NOT AVAIL loc_mstr  THEN DO:
                                /*pkerr =  "机型在地点" + Xxsite1 + "中定义(1.4.16)的缺省库位不存在".*/
    
                                 FIND FIRST CODE_mstr WHERE CODE_fldname = "transfer_des_loc" AND TRIM(CODE_value) =  xxsite1 NO-LOCK NO-ERROR.
                                 IF AVAIL CODE_mstr THEN DO:
                                     FIND loc_mstr WHERE loc_site = xxsite1 AND loc_loc = TRIM(CODE_cmmt) NO-LOCK NO-ERROR.
                                     IF AVAIL loc_mstr THEN  xxloc1 = TRIM(CODE_cmmt).
                                     ELSE pkerr = "在通用代码中维护的移入库位不存在".
                                 END.  
                                   
                              END.
                                  
                             ELSE xxloc1 = IN_user1.
                         END. 
                 END.
                 ELSE IF xxsite = xxsite1 THEN DO:
                      FIND FIRST in_mstr WHERE in_site = xxsite AND in_part = pkpart  NO-LOCK  NO-ERROR.
                         IF NOT AVAIL in_mstr THEN DO:   
                         
                             pkerr = "机型在地点" + Xxsite + "中没有定义(1.4.16)缺省库位".
                             
                         END.
                         ELSE IF AVAIL in_mstr  THEN DO:
                             FIND FIRST loc_mstr WHERE loc_site = xxsite AND loc_loc = in_user1 NO-LOCK NO-ERROR.
                             IF NOT AVAIL loc_mstr  THEN DO:
                                pkerr =  "机型在地点" + Xxsite + "中定义(1.4.16)的缺省库位不存在".
                                 
                             END.
                             ELSE xxloc = IN_user1.
                         END.
                         FIND FIRST CODE_mstr WHERE CODE_fldname = "transfer_des_loc" AND TRIM(CODE_value) =  xxsite1 NO-LOCK NO-ERROR.
                         IF AVAIL CODE_mstr THEN DO:
                             FIND loc_mstr WHERE loc_site = xxsite1 AND loc_loc = TRIM(CODE_cmmt) NO-LOCK NO-ERROR.
                             IF AVAIL loc_mstr THEN  xxloc1 = TRIM(CODE_cmmt).
                             ELSE pkerr = "在通用代码中维护的移入库位不存在".
                         END.  
                         IF xxloc = xxloc1 THEN pkerr = "移出库位与移入库位致".

                 END.

                   /*DISP xxnbr pkpart xxsite xxloc xxsite1 xxloc1 pkqty * xxqty LABEL "需求量"  pkerr WITH WIDTH 320 STREAM-IO.*/   
                   
                 IF pkerr = "" THEN DO:
               
                     FIND FIRST xxtl_det WHERE xxtl_nbr = xxnbr AND xxtl_part = pkpart NO-LOCK NO-ERROR.
                     IF NOT AVAIL xxtl_det  THEN DO:
                        IF pkqty > 0 THEN DO:
                            CREATE  xxtl_det.
                            ASSIGN  xxtl_nbr = xxnbr 
                                        xxtl_part = pkpart
                                        xxtl_site = xxsite
                                        xxtl_site1 = xxsite1
                                        xxtl_model = xxpart
                                        xxtl_effdate = effdate
                                        xxtl_loc_fr = xxloc
                                        xxtl_loc_to = xxloc1
                                        xxtl_qty_req = pkqty  *  xxqty
                                        xxtl_qty_pick = pkqty  *  xxqty  
                                        xxtl_type = "D".
                        END.
                        IF pkqty < 0 THEN  pkerr = "需求量小于0,未生成记录".
                        xxqtyreq = pkqty * xxqty.
                     END.
                 END.  /*end of pkerr = ""*/
                 
                 DISP xxnbr xxsite xxsite1 effdate pkpart  
                        xxloc  LABEL "移出库位"
                        xxloc1 LABEL "移入库位"
                        xxqtyreq LABEL "需求量"  pkerr    WITH FRAM c WIDTH 200 STREAM-IO DOWN.
                .
                    setFrameLabels(frame c:handle) .
                   pkerr = "".
                   xxqtyreq = 0.
            END. /*for each pkdet*/
       END.  /*end of for each ptp_det*/
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
     
   END.
 
  
