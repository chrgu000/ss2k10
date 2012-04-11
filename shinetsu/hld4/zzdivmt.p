/*SS - 111120.1 By Ken*/
/*SS - 111226.1 By Ken*/
/*SS - 111229.1 By Ken*/
/* SS - 120331.1 By: Kaine Zhang */

/*
history
[20120331.1]
verify location/status in accordance with DD.
*/

{mfdtitle.i "120331.1"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE NEW SHARED VARIABLE ovd_lot AS CHARACTER  FORMAT "x(18)".
DEFINE NEW SHARED VARIABLE v_part AS CHARACTER  FORMAT "x(18)".
DEFINE NEW SHARED VARIABLE v_DESC AS CHARACTER FORMAT "x(12)" .
DEFINE NEW SHARED VARIABLE v_part1 AS CHARACTER FORMAT "x(18)".

/*SS - 111229.1 B*/
DEFINE NEW SHARED VARIABLE x_part AS CHARACTER FORMAT "x(18)".
DEFINE NEW SHARED VARIABLE x_part1 AS CHARACTER FORMAT "x(18)".
/*SS - 111229.1 E*/

DEFINE NEW SHARED VARIABLE v_desc1 AS CHARACTER FORMAT "x(12)".
DEFINE NEW SHARED VARIABLE hi_weight AS DECIMAL .
DEFINE NEW SHARED VARIABLE hi_count AS DECIMAL .
DEFINE NEW SHARED VARIABLE wj_length AS DECIMAL .
DEFINE NEW SHARED VARIABLE wj_length1 AS DECIMAL .
DEFINE NEW SHARED VARIABLE yx_length AS DECIMAL .
DEFINE NEW SHARED VARIABLE yx_length1 AS DECIMAL .

DEFINE NEW SHARED VARIABLE zl_weight AS DECIMAL .
DEFINE NEW SHARED VARIABLE zl_weight1 AS DECIMAL .

DEFINE NEW SHARED VARIABLE all_defect AS CHARACTER.
DEFINE NEW SHARED VARIABLE v_select like mfc_logical format "All/Can Issue".

DEFINE BUTTON BUTTON-Search SIZE 12 BY 1 .

DEFINE BUTTON BUTTON-Back SIZE 12 BY 1 .

DEFINE NEW SHARED VARIABLE vc_r AS DECIMAL .
DEFINE NEW SHARED VARIABLE vc_r1 AS DECIMAL .
DEFINE NEW SHARED VARIABLE v_mfd AS DECIMAL .
DEFINE NEW SHARED VARIABLE v_mfd1 AS DECIMAL .
DEFINE NEW SHARED VARIABLE v0_r AS DECIMAL LABEL "λ0".

DEFINE NEW SHARED VARIABLE pxl_rate AS DECIMAL.

DEFINE BUTTON BUTTON-Exp SIZE 12 BY 1 .

DEFINE VARIABLE v_frame-down AS INTEGER.

DEFINE NEW SHARED VARIABLE sum_count AS INTEGER .
/*SS - 111126.1 B*/
DEFINE NEW SHARED VARIABLE sum_weight AS DECIMAL  FORMAT "->>,>>>,>99.99".
/*SS - 111126.1 E*/

DEFINE NEW SHARED VARIABLE sel_count AS INTEGER .

/*SS - 111126.1 B*/
DEFINE NEW SHARED VARIABLE sel_sum_weight AS DECIMAL FORMAT "->>,>>>,>99.99".
/*SS - 111126.1 E*/

DEFINE NEW SHARED VARIABLE transfer_rs AS CHARACTER .
DEFINE NEW SHARED VARIABLE transfer_rs_desc AS CHARACTER.

DEFINE NEW SHARED VARIABLE user_name AS CHARACTER.

DEFINE NEW SHARED VARIABLE vv_loc AS CHARACTER.
DEFINE NEW SHARED VARIABLE vv_locto AS CHARACTER.


DEF VAR l-focus AS WIDGET-HANDLE NO-UNDO. 
define variable w-frame as widget-handle no-undo.

define variable i as integer no-undo.
DEFINE VARIABLE v_lot AS CHARACTER.

DEF VAR yn AS LOG .
DEF VAR ko AS LOG .
DEF VAR kpart AS CHAR .
DEFINE VARIABLE defect_desc AS CHARACTER FORMAT "x(15)".
DEFINE VARIABLE vv_part AS CHARACTER.
DEFINE VARIABLE v_a AS DECIMAL.
DEFINE VARIABLE v_b AS DECIMAL.
DEFINE VARIABLE v_defect_code AS CHARACTER.
DEFINE VARIABLE SUM_defect_length  AS DECIMAL.
DEFINE VARIABLE v_efflength AS DECIMAL.
DEFINE VARIABLE v_insp_dia AS DECIMAL.
DEFINE VARIABLE v_decimal AS DECIMAL.
DEFINE VARIABLE y_length AS DECIMAL.
DEFINE VARIABLE v_status AS CHARACTER.
DEFINE VARIABLE BUTTON-Rework_status AS CHARACTER.
DEFINE VARIABLE BUTTON-Print_status AS CHARACTER.
DEFINE VARIABLE o_result AS LOGICAL.
DEFINE VARIABLE i_lotno like zzsellot_lotno.
DEFINE VARIABLE i_rwknum AS CHARACTER.
DEFINE VARIABLE i_part like pt_part.

DEFINE VARIABLE v_ttld_zpc AS DECIMAL.
DEFINE VARIABLE jsyc_dec AS DECIMAL.
DEFINE VARIABLE qtyc_dec AS DECIMAL.




define VARIABLE iv_ovdlotno AS CHARACTER no-undo.
define VARIABLE iv_part AS CHARACTER no-undo.
define VARIABLE iv_length AS DECIMAL no-undo.
define VARIABLE iv_kubun AS CHARACTER no-undo.
define VARIABLE iv_ap1 AS DECIMAL no-undo.
define VARIABLE iv_ap2 AS DECIMAL no-undo.
define VARIABLE iv_ap3 AS DECIMAL no-undo.
define VARIABLE iv_ap4 AS DECIMAL no-undo.
define VARIABLE iv_ap5 AS DECIMAL no-undo.
define VARIABLE iv_ap6 AS DECIMAL no-undo.
define VARIABLE iv_size1 AS DECIMAL no-undo.
define VARIABLE iv_size2 AS DECIMAL no-undo.
define VARIABLE iv_size3 AS DECIMAL no-undo.
define VARIABLE iv_size4 AS DECIMAL no-undo.
define VARIABLE iv_size5 AS DECIMAL no-undo.
define VARIABLE iv_size6 AS DECIMAL no-undo.
define VARIABLE iv_type1 AS CHARACTER no-undo.
define VARIABLE iv_type2 AS CHARACTER no-undo.
define VARIABLE iv_type3 AS CHARACTER no-undo.
define VARIABLE iv_type4 AS CHARACTER no-undo.
define VARIABLE iv_type5 AS CHARACTER no-undo.
define VARIABLE iv_type6 AS CHARACTER no-undo.

define VARIABLE ov_result AS CHARACTER no-undo.
 


/* SS - 20120331.1 - B */
define variable s_ZZ_DIVERSION_FRSTS_1 as character no-undo.
define variable s_ZZ_DIVERSION_FRSTS_2 as character no-undo.
/* SS - 20120331.1 - E */

ASSIGN
   ALL_defect = "All"
   defect_desc = "All/Some/None".

DEFINE BUTTON BUTTON-Select-All SIZE 12 BY 1 . 
DEFINE BUTTON BUTTON-Cancel-All SIZE 12 BY 1 . 
DEFINE BUTTON BUTTON-Print SIZE 12 BY 1 . 
DEFINE BUTTON BUTTON-Rework SIZE 12 BY 1 . 

                        /*
                        ttld_mfd = zzsellot_insp_mfd
                        ttld_rc = zzsellot_insp_cutoff
                        ttld_r0 = zzsellot_insp_zdw
                        ttld_wj = zzsellot_insp_dia
                        ttld_zzl = zzsellot_insp_diviedweight
                        ttld_rn  = zzsellot_insp_dn
                        ttld_pxl = zzsellot_insp_ecc
                        ttld_bow = zzsellot_insp_bow
                        ttld_fy  = zzsellot_insp_noncirc
                        ttld_qp = zzsellot_insp_bubble
                        ttld_D_core = zzsellot_insp_dc
                        ttld_slope = zzsellot_insp_slope
                        ttld_D1285 = zzsellot_insp_d1285
                            */

DEFINE NEW SHARED  TEMP-TABLE ttld_det 
    FIELD ttld_sel AS LOGICAL       
    FIELD ttld_lot AS CHARACTER    FORMAT "x(18)"
    FIELD ttld_part AS CHARACTER     FORMAT "x(18)"
    FIELD ttld_check AS CHARACTER      FORMAT "x(8)"
    FIELD ttld_mfd AS DECIMAL 
    FIELD ttld_rc AS DECIMAL  
    FIELD ttld_r0 AS DECIMAL 
    FIELD ttld_wj AS DECIMAL 
    FIELD ttld_yxc AS DECIMAL 
    FIELD ttld_zzl AS DECIMAL 
    FIELD ttld_jszl AS DECIMAL 
    FIELD ttld_jbd AS DECIMAL 
    FIELD ttld_rn AS DECIMAL  
    FIELD ttld_pxl AS DECIMAL 
    FIELD ttld_bow AS DECIMAL 
    FIELD ttld_fy AS DECIMAL 
    FIELD ttld_qp AS CHARACTER 
    FIELD ttld_D_core AS DECIMAL 
    FIELD ttld_slope AS DECIMAL 
    FIELD ttld_D1285 AS DECIMAL 
    FIELD ttld_defect AS CHARACTER  FORMAT "x(8)"
    FIELD ttld_part1 AS CHARACTER    FORMAT "x(18)"
    FIELD ttld_site AS CHARACTER
    FIELD ttld_loc   AS CHARACTER    FORMAT "x(8)"
    FIELD ttld_ref   AS CHARACTER
    FIELD ttld_loc_to AS CHARACTER   FORMAT "x(8)"
    FIELD ttld_qty_oh AS DECIMAL
    FIELD ttld_ok  AS CHARACTER
    FIELD ttld_sum_weight AS DECIMAL
    FIELD ttld_count AS INTEGER
    INDEX index1 ttld_lot.


FORM
    v_part COLON 15  v_desc NO-LABEL
    v_part1   v_desc1 NO-LABEL
    ovd_lot 
    SKIP
    hi_weight COLON 15 
    hi_count  COLON 52 SKIP
    wj_length COLON 15
    wj_length1 LABEL "To"
    yx_length COLON 52
    yx_length1 LABEL "To" SKIP
    zl_weight  COLON 15
    zl_weight1 LABEL "To"
    ALL_defect      COLON 52 defect_desc NO-LABEL
    v_select           SKIP
    vc_r COLON 15
    vc_r1 LABEL {t001.i}
    v_mfd COLON 52
    v_mfd1 LABEL {t001.i}
    v0_r 
    pxl_rate
WITH FRAME b SIDE-LABELS  WIDTH 300 .
setFrameLabels(FRAME b:HANDLE). 


FORM 
   BUTTON-Search AT 10
   BUTTON-Exp AT 30
   BUTTON-Back AT 50
WITH FRAME f-button SIDE-LABELS WIDTH 300 .
setFrameLabels(FRAME f-button:HANDLE). 


PROCEDURE ip-button1:

      
      enable ALL with frame f-button.

      l-focus = BUTTON-Search:HANDLE IN FRAME f-button .

      ststatus = stline[2].
      status input ststatus.

      on choose of BUTTON-Search
      do:
                    
          FOR EACH ttld_det WHERE ttld_ok = "no":
             DELETE ttld_det.
          END.

          v_decimal = 0.
          i = 0 .
          FOR EACH ttld_det :
             v_decimal = v_decimal + ttld_zzl.
             i = i + 1.
             ttld_sum_weight = v_decimal.
             ttld_count = i.
          END.

          FOR EACH ttld_det WHERE ttld_sum_weight > hi_weight AND hi_weight <> 0 OR ttld_count > hi_count AND hi_count <> 0 :
              DELETE ttld_det.
          END.

          SUM_count = 0.
          sum_weight = 0.
          FOR EACH ttld_det :
             sum_count = sum_count + 1.
             sum_weight = sum_weight + ttld_zzl.
          END.

          FIND FIRST ttld_det NO-LOCK NO-ERROR.
          IF NOT AVAIL ttld_det THEN DO:
             v_status = "None".
             yn = NO.

          END.
          ELSE DO:
             yn = NO .    
             v_status = "OK".
          END.
      
          l-focus        = self:handle.
          RETURN .
      end. /* ON CHOOSE OF b-update */

      on choose of BUTTON-Exp
      do:

          BUTTON-Rework_status = "ok".

          FOR EACH ttld_det WHERE ttld_ok = "ok":
             DELETE ttld_det.
          END.

          v_decimal = 0.
          i = 0 .

          FOR EACH ttld_det :
             v_decimal = v_decimal + ttld_zzl.
             i = i + 1.
             ttld_sum_weight = v_decimal.
             ttld_count = i.
          END.

          FOR EACH ttld_det WHERE ttld_sum_weight > hi_weight AND hi_weight <> 0 OR ttld_count > hi_count AND hi_count <> 0 :
              DELETE ttld_det.
          END.


          SUM_count = 0.
          sum_weight = 0.
          FOR EACH ttld_det :
             sum_count = sum_count + 1.
             sum_weight = sum_weight + ttld_zzl.
          END.

          FIND FIRST ttld_det NO-LOCK NO-ERROR.
          IF NOT AVAIL ttld_det THEN DO:
             v_status = "None".
             yn = NO.

          END.
          ELSE DO:
             yn = NO .    
             v_status = "OK".
          END.

          l-focus        = self:handle.
          RETURN.

      end. /* ON CHOOSE OF b-add */
      ON CHOOSE OF BUTTON-Back 
      DO:
          v_status = "Back".
          yn = NO.
          l-focus        = self:handle.
          RETURN.
      END.

      REPEAT:

          wait-for
             go of FRAME f-button or
             window-close of current-window or
             choose of
            BUTTON-Search,
            BUTTON-Exp,
            BUTTON-Back
             focus
             l-focus.
          IF yn = NO THEN LEAVE.
      END.
      DISABLE ALL with frame f-button.
      HIDE FRAME f-button NO-PAUSE . 
      hide message no-pause.
END PROCEDURE. /* ip-button */


    

FORM
ttld_sel                 
ttld_lot                 
ttld_part                
ttld_check               
ttld_mfd                 
ttld_rc                  
ttld_r0                  
ttld_wj                  
ttld_yxc                 
ttld_zzl                 
ttld_jszl                
ttld_jbd                 
ttld_rn                  
ttld_pxl                 
ttld_bow                 
ttld_fy                  
ttld_qp                  
ttld_D_core              
ttld_slope               
ttld_D1285               
ttld_defect              
ttld_part1               

with frame a 6 DOWN scroll 1 width 300 NO-BOX .
setFrameLabels(frame a:handle).

v_frame-down = 6.


FORM
    SUM_count AT 1
    SUM_weight AT 25
    sel_count AT 60
    sel_sum_weight AT 90
    transfer_rs AT 120
    transfer_rs_desc NO-LABEL
    User_name
WITH FRAME f-sum SIDE-LABELS WIDTH 220 .
setFrameLabels(FRAME f-sum:HANDLE).

FORM
BUTTON-Select-All AT 1  
BUTTON-Cancel-All AT 20 
BUTTON-Print AT 40 
BUTTON-Rework AT 55 
WITH FRAME c SIDE-LABELS WIDTH 220 .
setFrameLabels(FRAME c:HANDLE).

ststatus = stline[2].
status input ststatus.

ON CHOOSE OF BUTTON-Select-All 
DO:

      /*
      {pxmsg.i &MSGNUM=3 &ERRORLEVEL=4}
      MESSAGE "BUTTON-Select-All".
      */


     sel_count = SUM_count.
     sel_sum_weight = SUM_weight.


     DISP     SUM_count 
              SUM_weight 
              sel_count 
              sel_sum_weight 
              transfer_rs 
              transfer_rs_desc
              USER_name  WITH FRAME f-sum.


      FOR EACH ttld_det :
          ttld_sel = YES.
      END.
        
      CLEAR FRAME a ALL NO-PAUSE .  
      FIND FIRST ttld_det NO-LOCK NO-ERROR .
      i = 0.        
      do while i < v_frame-down and available ttld_det:
          v_lot = ttld_lot .
          display 
              ttld_sel                 
              ttld_lot                 
              ttld_part                
              ttld_check               
              ttld_mfd                 
              ttld_rc                  
              ttld_r0                  
              ttld_wj                  
              ttld_yxc                 
              ttld_zzl                 
              ttld_jszl                
              ttld_jbd                 
              ttld_rn                  
              ttld_pxl                 
              ttld_bow                 
              ttld_fy                  
              ttld_qp                  
              ttld_D_core              
              ttld_slope               
              ttld_D1285                    

              ttld_defect
              ttld_part1
              with frame a.      
          i = i + 1.        
          if i < v_frame-down then down 1 WITH FRAME a .
          find next ttld_det  no-lock no-error.
      end.

      l-focus        = BUTTON-Select-All:HANDLE IN FRAME C.
      RETURN .
END.

ON CHOOSE OF BUTTON-Cancel-All 
DO:


        sel_count = 0.
    sel_sum_weight = 0.



    DISP     SUM_count 
             SUM_weight 
             sel_count 
             sel_sum_weight 
             transfer_rs 
             transfer_rs_desc
             USER_name  WITH FRAME f-sum.


    FOR EACH ttld_det :
        ttld_sel = NO.
    END.

    CLEAR FRAME a ALL NO-PAUSE .  
    FIND FIRST ttld_det NO-LOCK NO-ERROR .
    i = 0.        
    do while i < v_frame-down and available ttld_det:
        v_lot = ttld_lot .
        display 
            ttld_sel                 
            ttld_lot                 
            ttld_part                
            ttld_check               
            ttld_mfd                 
            ttld_rc                  
            ttld_r0                  
            ttld_wj                  
            ttld_yxc                 
            ttld_zzl                 
            ttld_jszl                
            ttld_jbd                 
            ttld_rn                  
            ttld_pxl                 
            ttld_bow                 
            ttld_fy                  
            ttld_qp                  
            ttld_D_core              
            ttld_slope               
            ttld_D1285                    

            ttld_defect
            ttld_part1
            with frame a.      
        i = i + 1.        
        if i < v_frame-down then down 1 WITH FRAME a .
        find next ttld_det  no-lock no-error.
    end.
    l-focus        = BUTTON-Cancel-All:HANDLE IN FRAME C.
    RETURN.
END.
ON CHOOSE OF BUTTON-Print
DO:
  IF BUTTON-Print_status = "complete" THEN DO:
     {pxmsg.i &MSGNUM=32012 &ERRORLEVEL=1}
  END.
  ELSE DO:

      IF BUTTON-Rework_status = "ok" THEN DO:
         {pxmsg.i &MSGNUM=32010 &ERRORLEVEL=4}
      END.
      ELSE DO:


          /*打印指示书&倒退分解*/         
         {gprun.i ""zzdivmt01.p""}  
         
         FOR EACH ttld_det NO-LOCK:
             FIND FIRST zzsellot_mstr WHERE zzsellot_domain = GLOBAL_domain
                 AND zzsellot_lotno = ttld_lot 
                 AND zzsellot_final = "1"
                  NO-ERROR.
             IF AVAIL zzsellot_mstr THEN DO:
                ASSIGN
                    zzsellot_partchg_time = STRING(TIME,"HH:MM:SS")
                    zzsellot_partchg_dt = STRING(TODAY)
                    zzsellot_partchg_userid = GLOBAL_userid
                    zzsellot_partchg_partto = x_part
                    zzsellot_partchg_partfrom = x_part1
                    zzsellot_partchg_reason = transfer_rs
                    zzsellot_part = x_part
                    zzsellot_extralen_tech =  jsyc_dec
                    zzsellot_extralen_other = qtyc_dec
                    zzsellot_insp_efflength = ttld_yxc.

             END.
         END.

        {pxmsg.i &MSGNUM=32013 &ERRORLEVEL=1}
        
        /* SS - 20120331.1 - B */
        /* todo (or not) ???? search lot_mstr, and set lot__chr02 = s_ZZ_DIVERSION_FRSTS_xxx */
        /* SS - 20120331.1 - E */
            
         yn = NO.
         BUTTON-Print_status = "complete".
      END.
            
  END.

  l-focus = BUTTON-Print:HANDLE IN FRAME C.
  RETURN.
END.
ON CHOOSE OF BUTTON-Rework
DO:

    IF BUTTON-Rework_status = "complete" THEN DO:
       {pxmsg.i &MSGNUM=32012 &ERRORLEVEL=1}
    END.
    ELSE DO:
        IF BUTTON-Rework_status <> "ok" THEN DO:
           {pxmsg.i &MSGNUM=32011 &ERRORLEVEL=4}
        END.
        ELSE DO:

           {gprun.i ""zzdivmt02.p""}
           {pxmsg.i &MSGNUM=32014 &ERRORLEVEL=1}
           BUTTON-Rework_status = "complete".
           
           /* SS - 20120331.1 - B */
           /* todo (or not) ???? search lot_mstr, and set lot__chr02 = s_ZZ_DIVERSION_FRSTS_xxx */
           /* SS - 20120331.1 - E */
           
           yn = NO.
        END.
    END.

  l-focus        = BUTTON-Rework:HANDLE IN FRAME C.
  RETURN.
END.
on CURSOR-DOWN, F10 anywhere
do:
    IF ko  THEN
    APPLY "go" TO FRAME c .
END.
on CURSOR-UP, F9 anywhere
do:
    IF ko  THEN
    APPLY "go" TO FRAME c .
END.
ON GO OF FRAME c
DO:         

    IF SUM_count > v_frame-down THEN DO:
       IF lastkey = keycode("F10") OR lastkey = keycode("cursor-DOWN") 
          then do :
            FIND FIRST ttld_det WHERE ttld_lot = v_lot NO-LOCK  NO-ERROR.
            FIND NEXT ttld_det NO-LOCK NO-ERROR .
            IF AVAIL ttld_det THEN DO :
                /*
                MESSAGE v_lot "-down" ttld_lot.
                */
    
                v_lot = ttld_lot.
                down 1 WITH FRAME a .
                display 
                    ttld_sel                 
                    ttld_lot                 
                    ttld_part                
                    ttld_check               
                    ttld_mfd                 
                    ttld_rc                  
                    ttld_r0                  
                    ttld_wj                  
                    ttld_yxc                 
                    ttld_zzl                 
                    ttld_jszl                
                    ttld_jbd                 
                    ttld_rn                  
                    ttld_pxl                 
                    ttld_bow                 
                    ttld_fy                  
                    ttld_qp                  
                    ttld_D_core              
                    ttld_slope               
                    ttld_D1285                 
    
                    ttld_defect
                    ttld_part1
                    with frame a.        
            END. 
       END.
    
       IF lastkey = keycode("F9") OR lastkey = keycode("CURSOR-UP") 
          then do :
    
            FIND LAST ttld_det WHERE ttld_lot = v_lot NO-LOCK NO-ERROR .
            FIND PREV ttld_det NO-LOCK NO-ERROR .
            IF AVAIL ttld_det THEN DO :
                /*
                MESSAGE v_lot "-up" ttld_lot.
                */
                v_lot = ttld_lot.
                UP 1 WITH FRAME a .
                display 
                    ttld_sel                 
                    ttld_lot                 
                    ttld_part                
                    ttld_check               
                    ttld_mfd                 
                    ttld_rc                  
                    ttld_r0                  
                    ttld_wj                  
                    ttld_yxc                 
                    ttld_zzl                 
                    ttld_jszl                
                    ttld_jbd                 
                    ttld_rn                  
                    ttld_pxl                 
                    ttld_bow                 
                    ttld_fy                  
                    ttld_qp                  
                    ttld_D_core              
                    ttld_slope               
                    ttld_D1285                 
    
                    ttld_defect
                    ttld_part1
                    with frame a.        
            END. 
       END.
    
    END.

    RETURN.

END.
      

/*intial setup begin*/

      w-frame = frame c:handle.

      assign
        frame c:centered = true
        frame c:row      = 20.

/*intial setup end*/




v_status = "".

REPEAT:

    HIDE FRAME f-sum NO-PAUSE .   
    /*
    HIDE FRAME f-button NO-PAUSE.
    */    
    HIDE FRAME c NO-PAUSE .        
    hide frame a no-pause.
    pause before-hide.

    DISP ALL_defect defect_desc WITH FRAME b.
    view FRAME b.

    BUTTON-Rework_status = "".
    BUTTON-Print_status = "".
    SUM_count = 0.
    SUM_weight = 0.
    sel_count = 0.
    sel_sum_weight = 0. 
    transfer_rs = "".
    transfer_rs_desc = "".
    hi_count = 0.
    hi_weight = 0.
    X_part = "".
    X_part1 = "".

    USER_name = GLOBAL_userid.


    setb:
    do on error undo, retry:

        HIDE FRAME f-sum NO-PAUSE .   
        /*
        HIDE FRAME f-button NO-PAUSE.
        */    
        HIDE FRAME c NO-PAUSE .        
        hide frame a no-pause.
        pause before-hide.

        DISP ALL_defect defect_desc WITH FRAME b.
        view FRAME b.
        vv_part = "".
        /*    .
        PROMPT-FOR
        */
        SET
            v_part 
            v_part1 
            ovd_lot 
            WITH FRAME b        
        editing:

               if frame-field = "part" then do:
                   v_part = INPUT v_part.
                  IF v_part <> vv_part THEN DO:
                     FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                        AND pt_part = INPUT v_part NO-LOCK NO-ERROR.
                     IF AVAIL pt_mstr THEN DO:
                      ASSIGN
                        v_part = pt_part
                        vv_part = pt_part 
                        v_desc = pt_desc1.
               
                     END.
                     ELSE DO:
                        v_desc = "Not Avail Item".
                     END.

                     DISP v_part v_desc
                          WITH FRAME b .
                  END.


                  {mfnp.i pt_mstr v_part  " pt_mstr.pt_domain = global_domain and
                       pt_part " v_part pt_part pt_part}

                  if recno <> ?
                  then do:
                    ASSIGN
                     v_part = pt_part
                     v_desc = pt_desc1.
                     DISP v_part v_desc
                          WITH FRAME b .
                  END.
               end.
               ELSE IF frame-field = "part1" THEN DO:

                     v_part1 = INPUT v_part1.
                   IF v_part1 <> vv_part THEN DO:
                      FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                         AND pt_part = INPUT v_part1 NO-LOCK NO-ERROR.
                      IF AVAIL pt_mstr THEN DO:
                         v_part1 = pt_part.
                         vv_part = pt_part .
                         v_desc1 = pt_desc1.

                      END.
                      ELSE DO:
                         v_desc1 = "Not Avail Item".
                      END.

                      DISP v_desc1
                           WITH FRAME b .
                   END.

                   {mfnp.i pt_mstr v_part1  " pt_mstr.pt_domain = global_domain and
                        pt_part " v_part1 pt_part pt_part}

                   if recno <> ?
                   then do:
                      ASSIGN
                      v_part1 = pt_part
                      v_desc1 = pt_desc1.
                      DISP v_part1 v_desc1
                           WITH FRAME b .
                   END.
               END.
               ELSE DO:
                   readkey.
                   apply lastkey.
               END.
        END.
        

        /*
        ASSIGN v_part = INPUT v_part 
               v_part1 = INPUT v_part1 
               ovd_lot = INPUT ovd_lot.
        */       


        IF v_part = v_part1 THEN DO:
            {pxmsg.i &MSGNUM=32008 &ERRORLEVEL=4}.
            next-prompt v_part with frame b.
            undo, retry setb.
        END.

        /* SS - 20120331.1 - B
        /*判断通用代码是否有定义*/
        FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "ZZ_OVD_SHIP_LOC" NO-LOCK NO-ERROR.
        IF NOT AVAIL CODE_mstr THEN DO:
            {pxmsg.i &MSGNUM=32006 &ERRORLEVEL=3}.
            next-prompt v_part with frame b.
            undo, retry setb.
        END.
        ELSE DO:
           FIND FIRST loc_mstr WHERE loc_domain = GLOBAL_domain AND loc_loc = CODE_value NO-LOCK NO-ERROR.
           IF NOT AVAIL loc_mstr THEN DO:
               {pxmsg.i &MSGNUM=32007 &ERRORLEVEL=3}.
               next-prompt v_part with frame b.
               undo, retry setb.
           END.
           ELSE DO:
               vv_loc = CODE_cmmt.
           END.
        END.

        FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "ZZ_OVD_SHIP_LOCTO" NO-LOCK NO-ERROR.
        IF NOT AVAIL CODE_mstr THEN DO:
            {pxmsg.i &MSGNUM=32006 &ERRORLEVEL=3}.
            next-prompt v_part with frame b.
            undo, retry setb.
        END.
        ELSE DO:
           FIND FIRST loc_mstr WHERE loc_domain = GLOBAL_domain AND loc_loc = CODE_value NO-LOCK NO-ERROR.
           IF NOT AVAIL loc_mstr THEN DO:
               {pxmsg.i &MSGNUM=32007 &ERRORLEVEL=3}.
               next-prompt v_part with frame b.
               undo, retry setb.
           END.
           ELSE DO:
               vv_locto = CODE_cmmt.
           END.
        END.
        SS - 20120331.1 - E */
        
        
        /* SS - 20120331.1 - B */
        for first code_mstr
            no-lock
            use-index code_fldval
            where code_domain = global_domain
                and code_fldname = "ZZ_DIVERSION_FRLOC"
                and code_value = ""
        :
        end.
        if not(available(code_mstr)) then do:
            {pxmsg.i &msgnum=32006 &errorlevel=3}
            next-prompt v_part with frame b.
            undo, retry setb.
        end.
        
        for first loc_mstr
            no-lock
            where loc_domain = global_domain
                /* and loc_site = ?? */
                and loc_loc = code_cmmt
        :
        end.
        if not(available(loc_mstr)) then do:
            {pxmsg.i &msgnum=32007 &errorlevel=3}
            next-prompt v_part with frame b.
            undo, retry setb.
        end.
        
        assign
            vv_loc = code_cmmt
            vv_locto = vv_loc
            .
        
        for first code_mstr
            no-lock
            use-index code_fldval
            where code_domain = global_domain
                and code_fldname = "ZZ_DIVERSION_FRSTS"
                and code_value = "01"
        :
        end.
        if not(available(code_mstr)) then do:
            /* ZZ_DIVERSION_FRSTS not setup */
            /* todo confirm no. 31023 */
            {pxmsg.i &msgnum=31023 &errorlevel=3}
            next-prompt v_part with frame b.
            undo, retry setb.
        end.
        s_ZZ_DIVERSION_FRSTS_1 = code_cmmt.
        
        for first code_mstr
            no-lock
            use-index code_fldval
            where code_domain = global_domain
                and code_fldname = "ZZ_DIVERSION_FRSTS"
                and code_value = "02"
        :
        end.
        if not(available(code_mstr)) then do:
            /* ZZ_DIVERSION_FRSTS not setup */
            /* todo confirm no. 31023 */
            {pxmsg.i &msgnum=31023 &errorlevel=3}
            next-prompt v_part with frame b.
            undo, retry setb.
        end.
        s_ZZ_DIVERSION_FRSTS_2 = code_cmmt.
        /* SS - 20120331.1 - E */


        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = v_part NO-LOCK NO-ERROR.
        IF NOT AVAIL pt_mstr THEN DO:
            {pxmsg.i &MSGNUM=32001 &ERRORLEVEL=3}.
            next-prompt v_part with frame b.
            undo, retry setb.
        END.

        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = v_part1 NO-LOCK NO-ERROR.
        IF NOT AVAIL pt_mstr THEN DO:
            {pxmsg.i &MSGNUM=32002 &ERRORLEVEL=3}.
            next-prompt v_part1 with frame b.
            undo, retry setb.
        END.
    

        /*check part + "-05" begin*/

        /*SS - 111229.1 B*/
        x_part = v_part + "-05".
        x_part1 = v_part1 + "-05".


        FIND FIRST ld_det WHERE ld_domain = GLOBAL_domain AND ld_part = x_part1 AND ld_loc = vv_loc 
            AND (ld_lot = ovd_lot OR ovd_Lot = "") AND ld_qty_oh > 0 NO-LOCK NO-ERROR.
        IF NOT AVAIL ld_det  THEN DO:
            {pxmsg.i &MSGNUM=8593 &ERRORLEVEL=3}.
            next-prompt ovd_lot with frame b.
            undo, retry setb.
        END.


        FOR EACH mpd_det WHERE mpd_domain = GLOBAL_domain AND mpd_nbr = ("X7" + x_part) NO-LOCK:
                if mpd_type = "00014" then do:	
                   wj_length = decimal(mpd_tol) .
                end.
                
                if mpd_type = "00013" then do:
                   wj_length1 = decimal(mpd_tol) .
                end.
                
                if mpd_type = "00012" then do:
                   yx_length = decimal(mpd_tol).
                end.
                
                if mpd_type = "00011" then do:
                  yx_length1 = decimal(mpd_tol).
                end.
                
                if mpd_type = "00016" then do:
                   zl_weight = decimal(mpd_tol).
                end.
                if mpd_type = "00015" then do:
                   zl_weight1 = decimal(mpd_tol).
                end.
                
                if mpd_type = "00018" then do:
                   vc_r = decimal(mpd_tol).
                end.
                
                if mpd_type = "00017" then do:
                   vc_r1 = decimal(mpd_tol).
                end.
                
                if mpd_type = "00020" then do:
                   v_mfd = decimal(mpd_tol).
                end.
                
                if mpd_type = "00019" then do:
                   v_mfd1 = decimal(mpd_tol).
                end.
                
                if mpd_type = "00023" then do:
                   v0_r = decimal(mpd_tol).
                end.
                
                if mpd_type = "00027" then do:
                   pxl_rate = decimal(mpd_tol).
                end.

                IF mpd_type = "00041" THEN DO:
                   jsyc_dec = decimal(mpd_tol).
                END.

                IF mpd_type = "00042" THEN DO:
                   qtyc_dec = decimal(mpd_tol).
                END.

        END.

       DISP

           hi_weight 
           hi_count 
           wj_length
           wj_length1
           yx_length 
           yx_length1 
           zl_weight
           zl_weight1 
           ALL_defect
           v_select
           vc_r 
           vc_r1 
           v_mfd 
           v_mfd1
           v0_r 
           pxl_rate                        
           WITH FRAME b .

        setb-1:
        do on error undo, retry:
            SET             
                hi_weight 
                hi_count 
                wj_length
                wj_length1
                yx_length 
                yx_length1 
                zl_weight
                zl_weight1 
                ALL_defect
                v_select
                vc_r 
                vc_r1 
                v_mfd 
                v_mfd1
                v0_r 
                pxl_rate                        
                WITH FRAME b .
               
                IF ALL_defect <> "all" AND ALL_defect <> "Some" AND ALL_defect <> "None" THEN DO:
                    {pxmsg.i &MSGNUM=32003 &ERRORLEVEL=3}.
                    next-prompt ALL_defect with frame b.
                    undo, retry setb-1.
                END.

                /*如果转换后的品名不允许有defect <1标识不允许有缺陷,则all_defect不允许选择all*/
                IF ALL_defect = "all" THEN DO:
                   FIND FIRST mpd_det WHERE mpd_domain = GLOBAL_domain AND mpd_nbr = ("X7" + x_part) AND mpd_type = "00036"
                       AND DECIMAL(mpd_tol) < 1 NO-LOCK NO-ERROR.
                   IF AVAILABLE mpd_det THEN DO:
                       {pxmsg.i &MSGNUM=32005 &ERRORLEVEL=3}.
                       next-prompt ALL_defect with frame b.
                       undo, retry setb-1.
                   END.

                END.


                EMPTY TEMP-TABLE ttld_det.
                FOR EACH ld_det WHERE ld_domain = GLOBAL_domain AND ld_part = x_part1 AND ld_loc = vv_loc 
                    AND (ld_lot = ovd_lot OR ovd_Lot = "") AND ld_qty_oh > 0 NO-LOCK:

                    /*
                    MESSAGE v_select.
                    */

                    
                    /*v_select = yes 表示只显示可出库的记录*/
                    IF v_select = YES THEN DO:
                        FIND FIRST lot_mstr WHERE lot_domain = GLOBAL_domain AND 
                            lot_serial = ld_lot AND lot_part = "zzlot1" NO-LOCK NO-ERROR.
                         /*批号记录不存在*/
                        IF NOT AVAIL lot_mstr THEN DO:
                            NEXT.
                        END.
                        ELSE DO:
                            /*批号状态为空,其他炉芯管Status、盐素Status、检查Status、OHStatus全为"1"*/
                           IF lot__chr02 <> "" OR lot__chr03 <> "1" OR lot__chr04 <> "1" OR lot__chr05 <> "1" OR lot__chr06 <> "1" THEN DO:
                               NEXT.
                           END.           
                        END.

                        /*规格内判断 wait */
                        i_lotno = ld_lot.
                        i_rwknum = "".
                        i_part = ld_part.
                        o_result = NO.
                        
                        {gprun.i ""zzspechk.p"" "(input i_lotno,input i_rwknum,input i_part,output o_result)"}
                        
                        IF o_result = NO THEN DO:
                            NEXT.
                        END.                                                
                    END.



                    
                    FIND FIRST lot_mstr WHERE lot_domain = GLOBAL_domain AND 
                        lot_serial = ld_lot AND lot_part = "zzlot2" NO-LOCK NO-ERROR.
                    /*批号记录不存在*/
                    IF NOT AVAIL lot_mstr THEN DO:
                        NEXT.
                    END.
                    ELSE DO:
                       /* SS - 20120331.1 - B
                       /*工程进度Status为"210"或"220"*/
                       IF lot__chr02 <> "210" AND lot__chr02 <> "220" THEN DO:
                           NEXT.
                       END.
                       SS - 20120331.1 - E */
                       
                        /* SS - 20120331.1 - B */
                        /* verify ZZ_DIVERSION_FRSTS */
                        if lot__chr02 <> s_ZZ_DIVERSION_FRSTS_1 and lot__chr02 <> s_ZZ_DIVERSION_FRSTS_2 then do:
                            next.
                        end.
                        /* SS - 20120331.1 - E */
                    END.
                    
                    

                    /*判断是否有defect,如果有重新做defect检查*/     
                    
                    FIND FIRST zzsellot_mstr WHERE zzsellot_domain = GLOBAL_domain
                        AND zzsellot_lotno = ld_lot 
                        AND zzsellot_final = "1"
                        NO-LOCK NO-ERROR.
                    IF AVAIL zzsellot_mstr THEN DO:
                        IF zzsellot_insp_defect = "*" THEN DO:
                            /*
                            MESSAGE "xxx".
                            */

                            ASSIGN
                                iv_ovdlotno = ld_lot
                                iv_part = ld_part
                                iv_length = zzsellot_insp_efflength
                                iv_kubun = "2"
                                iv_ap1 = 0
                                iv_ap2 = 0
                                iv_ap3 = 0
                                iv_ap4 = 0
                                iv_ap5 = 0
                                iv_ap6 = 0
                                iv_size1 = 0
                                iv_size2 = 0
                                iv_size3 = 0
                                iv_size4 = 0
                                iv_size5 = 0
                                iv_size6 = 0
                                iv_type1 = ""
                                iv_type2 = ""
                                iv_type3 = ""
                                iv_type4 = ""
                                iv_type5 = ""
                                iv_type6 = ""
                                ov_result = "".
                            {gprun.i ""zzdefect.p"" "(input iv_ovdlotno,
                                                      input iv_part,
                                                      input i_part,
                                                      INPUT iv_length,
                                                      INPUT iv_kubun,
                                                      INPUT iv_ap1,
                                                      INPUT iv_ap2,
                                                      INPUT iv_ap3,
                                                      INPUT iv_ap4,
                                                      INPUT iv_ap5,
                                                      INPUT iv_ap6,
                                                      INPUT iv_size1,
                                                      INPUT iv_size2,
                                                      INPUT iv_size3,
                                                      INPUT iv_size4,
                                                      INPUT iv_size5,
                                                      INPUT iv_size6,
                                                      INPUT iv_type1,
                                                      INPUT iv_type2,
                                                      INPUT iv_type3,
                                                      INPUT iv_type4,
                                                      INPUT iv_type5,
                                                      INPUT iv_type6,
                                                      output ov_result)"}


                            /*如果转换后的品名不允许有defect <1 标识不允许有缺陷,如果有缺陷则排除在外*/
                            FIND FIRST mpd_det WHERE mpd_domain = GLOBAL_domain AND mpd_nbr = ("X7" + x_part) AND mpd_type = "00036"
                               AND DECIMAL(mpd_tol) < 1 NO-LOCK NO-ERROR.
                            IF AVAILABLE mpd_det THEN DO:
                                IF ov_result <> "ok" THEN DO:
                                    NEXT.
                                END.
                            END.

                        END.
                    END.
                    
                    



                    /*创建记录*/
                    CREATE ttld_det.
                    ASSIGN 
                          ttld_sel = NO
                          ttld_lot = ld_lot
                          ttld_part = x_part
                          ttld_check = ""
                          ttld_part1 = ld_part
                          ttld_site = ld_site
                          ttld_loc = ld_loc  
                          ttld_qty_oh = ld_qty_oh
                          ttld_loc_to = vv_locto
                          ttld_ref = ld_ref.
                        .

                    FIND FIRST zzsellot_mstr WHERE zzsellot_domain = GLOBAL_domain
                        AND zzsellot_lotno = ld_lot 
                        AND zzsellot_final = "1"
                        NO-LOCK NO-ERROR.
                    IF AVAIL zzsellot_mstr THEN DO:
                        ASSIGN
                            ttld_mfd = zzsellot_insp_mfd
                            ttld_rc = zzsellot_insp_cutoff
                            ttld_r0 = zzsellot_insp_zdw
                            ttld_wj = zzsellot_insp_dia
                            ttld_zzl = zzsellot_insp_diviedweight
                            ttld_rn  = zzsellot_insp_dn
                            ttld_pxl = zzsellot_insp_ecc
                            ttld_bow = zzsellot_insp_bow
                            ttld_fy  = zzsellot_insp_noncirc
                            ttld_qp = zzsellot_insp_bubble
                            ttld_D_core = zzsellot_insp_dc
                            ttld_slope = zzsellot_insp_slope
                            ttld_D1285 = zzsellot_insp_d1285.

                           /*转换前有效长,和外径*/
                           v_efflength = zzsellot_insp_efflength.
                           v_insp_dia = zzsellot_insp_dia.
                    END.
                    ELSE DO:
                        ASSIGN
                            ttld_mfd = 0
                            ttld_rc = 0
                            ttld_r0 = 0
                            ttld_wj = 0
                            ttld_zzl = 0
                            ttld_rn  = 0
                            ttld_pxl = 0
                            ttld_bow = 0
                            ttld_fy  = 0
                            ttld_qp = ""
                            ttld_D_core = 0
                            ttld_slope = 0
                            ttld_D1285 = 0.
                            v_efflength = 0.
                             v_insp_dia = 0.
                    END.

                    /*计算系数a,b*/
                    
                    FIND FIRST mpd_det WHERE mpd_domain = GLOBAL_domain AND 
                        mpd_nbr = ("X7" + ld_part) AND mpd_type = "00037" AND mpd_tol <> "" NO-LOCK NO-ERROR.
                    IF AVAIL mpd_det THEN DO:
                        v_defect_code = mpd_tol.
                       FIND FIRST mpd_det WHERE mpd_domain = GLOBAL_domain AND 
                           mpd_nbr = ("XQ" + v_defect_code) AND mpd_type = "00023"
                           NO-LOCK NO-ERROR.
                       IF AVAIL mpd_det THEN DO:
                           v_a = DECIMAL(mpd_tol).
                       END.
                       ELSE DO:
                           v_a = 0.
                       END.


                       FIND FIRST mpd_det WHERE mpd_domain = GLOBAL_domain AND 
                           mpd_nbr = ("XQ" + v_defect_code) AND mpd_type = "00022"
                           NO-LOCK NO-ERROR.
                       IF AVAIL mpd_det THEN DO:
                           v_b = DECIMAL(mpd_tol).
                       END.
                       ELSE DO:
                           v_b = 0.
                       END.

                    END.
                    ELSE DO:
                        FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "ZZ_DEF_PARA_A" NO-LOCK NO-ERROR.
                        IF AVAIL CODE_mstr THEN DO:
                            v_a = decimal(CODE_cmmt).
                        END.
                        ELSE DO:
                            v_a = 0.
                        END.

                        FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "ZZ_DEF_PARA_B" NO-LOCK NO-ERROR.
                        IF AVAIL CODE_mstr THEN DO:
                            v_b = decimal(CODE_cmmt).
                        END.
                        ELSE DO:
                            v_b = 0.
                        END.
                    END.
                    

                    /*转用前总defect长*/
                    
                    SUM_defect_length = 0.
                    FOR EACH qc_mstr WHERE qc_domain = GLOBAL_domain AND qc_part = ld_part AND
                        qc_serial = ld_lot NO-LOCK,EACH mph_hist WHERE mph_domain = GLOBAL_domain 
                        AND mph_lot = qc_lot AND mph_procedure = "INS_DEF" AND mph_routing = "210"
                        AND mph_op = 10
                        AND INDEX(mph_test,"BAD_SIZE") > 0
                        NO-LOCK:
                        SUM_defect_length = SUM_defect_length + (DECIMAL(mph_rsult) * v_a + v_b ).
                    END.
                    

                    /*转用前余长*/
                    y_length = 0.
                    FOR EACH mpd_det WHERE mpd_domain = GLOBAL_domain AND mpd_nbr = ("X7" + ld_part) AND (mpd_type = "00041" OR mpd_type = "00042") NO-LOCK:
                       y_length = y_length + DECIMAL(mpd_tol).
                    END.


                    /*制品长 = 有效长 + 余长 + 总defect长*/

                    ASSIGN
                       v_ttld_zpc = v_efflength + Y_length + SUM_defect_length .


                    /*新有效长 = 制品长度 - 余长 - 总Defect长度*/

                    /*转用后总defect长*/
                    
                    SUM_defect_length = 0.
                    FOR EACH qc_mstr WHERE qc_domain = GLOBAL_domain AND qc_part = ld_part AND
                        qc_serial = ld_lot NO-LOCK,EACH mph_hist WHERE mph_domain = GLOBAL_domain 
                        AND mph_lot = qc_lot AND mph_procedure = "INS_DEF" AND mph_routing = "210"
                        AND mph_op = 10
                        AND INDEX(mph_test,"BAD_SIZE") > 0
                        NO-LOCK:
                        SUM_defect_length = SUM_defect_length + (DECIMAL(mph_rsult) * v_a + v_b ).
                    END.
                    

                    /*转用后余长*/
                    y_length = 0.
                    FOR EACH mpd_det WHERE mpd_domain = GLOBAL_domain AND mpd_nbr = ("X7" + ld_part) AND (mpd_type = "00041" OR mpd_type = "00042") NO-LOCK:
                       y_length = y_length + DECIMAL(mpd_tol).
                    END.

                    ttld_yxc = v_ttld_zpc - SUM_defect_length - y_length.



                    /*计算重量 = 外径 * 外径 * 3.14 / 4 * 2.2 * 有效长度 / 1000 */
                    ASSIGN
                       ttld_jszl =  v_insp_dia *  v_insp_dia * 3.14 / 4 * 2.2 * ttld_yxc / 1000.

                    

                        /*
                        ttld_jbd 
                        ttld_defect 
                        */

                END.


                FOR EACH ttld_det :
                    IF (
                        ttld_wj >= wj_length AND ttld_wj <= wj_length1 AND 
                        ttld_yxc >= yx_length AND ttld_yxc <= yx_length1 AND
                        ttld_zzl >= zl_weight AND ttld_zzl <= zl_weight1 AND
                        ttld_rc >= vc_r AND ttld_rc <= vc_r1 AND 
                        ttld_mfd >= v_mfd AND ttld_mfd <= v_mfd1 AND 
                        ttld_r0 <= v0_r AND
                        ttld_pxl <= pxl_rate ) THEN DO:
                        ttld_ok = "ok".
                    END.
                    ELSE DO:
                        ttld_ok = "no".
                    END.
                END.

                YN = YES.
                v_status = "".
                RUN ip-button1.
        
                IF v_status = "None" THEN DO:
                       {pxmsg.i &MSGNUM=32004 &ERRORLEVEL=3}.
                       next-prompt ALL_defect with frame b.
                       undo, retry setb-1.
                END.


                IF v_status = "Back" THEN DO:
                    next-prompt ALL_defect with frame b.
                    undo, retry setb-1.
                END.
        END.    

        IF v_status <> "OK" THEN DO:
           undo, retry.
        END.

        pause 0.
        mainloop:  
        do transaction with frame a:
            clear frame a all no-pause.
            VIEW FRAME a .

            FIND FIRST ttld_det NO-LOCK NO-ERROR.
            IF NOT AVAIL ttld_det THEN LEAVE.

            i = 0.
            do while i < v_frame-down and available ttld_det:
                display 
                    ttld_sel                 
                    ttld_lot                 
                    ttld_part                
                    ttld_check               
                    ttld_mfd                 
                    ttld_rc                  
                    ttld_r0                  
                    ttld_wj                  
                    ttld_yxc                 
                    ttld_zzl                 
                    ttld_jszl                
                    ttld_jbd                 
                    ttld_rn                  
                    ttld_pxl                 
                    ttld_bow                 
                    ttld_fy                  
                    ttld_qp                  
                    ttld_D_core              
                    ttld_slope               
                    ttld_D1285             

                    ttld_defect
                    ttld_part1
                    with frame a.        
                i = i + 1.        
                /*
                MESSAGE "11111-" i.
                */
                if i < v_frame-down then down 1  .
                find next ttld_det 
                no-lock no-error.
            end.


            up i   .
            PAUSE 0.
            /*
            FIND first ttld_det NO-LOCK NO-ERROR.
            pause before-hide.
            UPDATE  ttld_sel go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
            pause 0.        

            PAUSE 10000.
            */



            FIND first ttld_det NO-LOCK NO-ERROR.                                
            detail-loop:
            repeat with frame a:                                
                display 
                    ttld_sel                 
                    ttld_lot                 
                    ttld_part                
                    ttld_check               
                    ttld_mfd                 
                    ttld_rc                  
                    ttld_r0                  
                    ttld_wj                  
                    ttld_yxc                 
                    ttld_zzl                 
                    ttld_jszl                
                    ttld_jbd                 
                    ttld_rn                  
                    ttld_pxl                 
                    ttld_bow                 
                    ttld_fy                  
                    ttld_qp                  
                    ttld_D_core              
                    ttld_slope               
                    ttld_D1285 
                    ttld_defect
                    ttld_part1
                    with frame a.  

                pause before-hide.
                UPDATE  ttld_sel go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                pause 0.        

                ASSIGN ttld_sel.
                IF ttld_sel THEN DO:
                   MESSAGE "Select Lot:" ttld_lot.
                   sel_count = sel_count + 1.
                   sel_sum_weight = sel_sum_weight + ttld_zzl.
                END.
                ELSE DO:
                    IF sel_count > 0 THEN DO:
                       sel_count = sel_count - 1.
                       sel_sum_weight = sel_sum_weight - ttld_zzl.
                    END.

                END.



                do while lastkey    = keycode("F9")
                OR lastkey = keycode("CURSOR-UP")
                or lastkey = keycode("F10")
                or lastkey = keycode("CURSOR-DOWN")
                or lastkey = keycode("RETURN")
                or keyfunction(lastkey) = "GO" 
                on endkey undo , leave detail-loop:

                    if  lastkey = keycode("F9") OR lastkey = keycode("CURSOR-UP") then do:
                        find prev ttld_det NO-LOCK no-error.                    
                        if available ttld_det then do:
                            up 1 with frame a.
                        end. 
                        else do:
                            FIND first ttld_det NO-LOCK NO-ERROR .
                            bell.
                        end.                      
                    end.
                    else IF lastkey = keycode("F10") OR lastkey = keycode("CURSOR-DOWN") 
                        or lastkey = keycode("RETURN")
                        or keyfunction(lastkey) = "GO" then do:
                        find next ttld_det NO-LOCK no-error.                
                        if available ttld_det then do:
                            down 1 with frame a.
                        end.                 
                        else do:
                            find last ttld_det NO-LOCK NO-ERROR.
                            bell.
                        end.                 
                    end.                 

                    display 
                        ttld_sel                 
                        ttld_lot                 
                        ttld_part                
                        ttld_check               
                        ttld_mfd                 
                        ttld_rc                  
                        ttld_r0                  
                        ttld_wj                  
                        ttld_yxc                 
                        ttld_zzl                 
                        ttld_jszl                
                        ttld_jbd                 
                        ttld_rn                  
                        ttld_pxl                 
                        ttld_bow                 
                        ttld_fy                  
                        ttld_qp                  
                        ttld_D_core              
                        ttld_slope               
                        ttld_D1285          
                        ttld_defect
                        ttld_part1
                        with frame a.  

                    pause before-hide.
                    UPDATE  ttld_sel go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                    pause 0.        

                    ASSIGN ttld_sel.
                    IF ttld_sel THEN DO:
                       MESSAGE "Select Lot:" ttld_lot.
                       sel_count = sel_count + 1.
                       sel_sum_weight = sel_sum_weight + ttld_zzl.
                    END.
                    ELSE DO:
                        IF sel_count > 0 THEN DO:
                           sel_count = sel_count - 1.
                           sel_sum_weight = sel_sum_weight - ttld_zzl.
                        END.

                    END.
                end. 

                if keyfunction(lastkey) = "END-ERROR" then do:
                    undo detail-loop,LEAVE detail-loop.
                end.                                                                     
            end. /* END OF REPEAT WITH FRAME a: Detail loop */

        END.

        CLEAR FRAME a ALL NO-PAUSE .  
        FIND FIRST ttld_det NO-LOCK NO-ERROR .
        i = 0.        
        do while i < v_frame-down and available ttld_det:
            v_lot = ttld_lot .
            display 
                ttld_sel                 
                ttld_lot                 
                ttld_part                
                ttld_check               
                ttld_mfd                 
                ttld_rc                  
                ttld_r0                  
                ttld_wj                  
                ttld_yxc                 
                ttld_zzl                 
                ttld_jszl                
                ttld_jbd                 
                ttld_rn                  
                ttld_pxl                 
                ttld_bow                 
                ttld_fy                  
                ttld_qp                  
                ttld_D_core              
                ttld_slope               
                ttld_D1285                  

                ttld_defect
                ttld_part1
                with frame a.  

            i = i + 1.        
            if i < v_frame-down then down 1 WITH FRAME a .
            find next ttld_det  no-lock no-error.
        end. 


        f-sum-loop:
        do on error undo, retry:  
           DISP     SUM_count 
                    SUM_weight 
                    sel_count 
                    sel_sum_weight 
                    transfer_rs 
                    transfer_rs_desc
                    USER_name  WITH FRAME f-sum.

           IF BUTTON-Rework_status <> "ok" THEN DO:     
               UPDATE transfer_rs WITH FRAME f-sum.
               FIND FIRST mpd_det WHERE mpd_domain = GLOBAL_domain AND mpd_nbr = "XC" + transfer_rs AND mpd_type = "00025" AND mpd_tol = "1" NO-LOCK NO-ERROR.
               IF NOT AVAIL mpd_det THEN DO:
                   {pxmsg.i &MSGNUM=32009 &ERRORLEVEL=3}.
                   next-prompt transfer_rs with frame f-sum.
                   undo, retry f-sum-loop.
               END.
               ELSE DO:
                   FIND FIRST mp_mstr WHERE mp_domain = GLOBAL_domain AND mp_nbr = transfer_rs NO-LOCK NO-ERROR.
                   IF AVAIL mp_mstr THEN DO:
                      transfer_rs_desc = mp_desc.
                      DISP transfer_rs_desc WITH FRAME f-sum.
                   END.
               END.
           END.
           ENABLE ALL WITH FRAME c .
           yn = YES.
           l-focus = BUTTON-Select-All:HANDLE IN FRAME c .
           ko = YES .        
           REPEAT:
               WAIT-FOR GO OF FRAME c
                   OR CHOOSE OF BUTTON-Select-All, BUTTON-Cancel-All, BUTTON-Print ,BUTTON-Rework FOCUS l-focus .
               IF yn = NO THEN LEAVE .
           END.

        END.

        HIDE FRAME f-sum NO-PAUSE .        
        HIDE FRAME c NO-PAUSE .        
        hide frame a no-pause.
        pause before-hide.    

    END.

END.
