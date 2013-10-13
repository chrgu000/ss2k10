/* zzdivmt.p - Diversion Maintenance                                         */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* SS - 120706.1 By: Kaine Zhang */
/* SS - 120808.1 By: Kaine Zhang */
/* REVISION END                                                              */
/*120411 查mpd_det时用无-05后缀的料号，其他情况用有-05后缀的料号             */

/*
history:
[20120808.1]
CR-#79. status must be code_cmmt(ZZ_DIVERSION_FRSTS).
[20120706.1]
1. CR-#24.
*/

/*120424 1.转用原因做浏览
         2.规格外抽出作用于v_part1 v_part = "" and v_part1 <> ""
         3.Search必须v_part <> "" and v_part1 <> ""
*/

{mfdtitle.i "120808.1"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{zzdivmt.i "new"}
&SCOPED-DEFINE zzdivmt_form_1 "Searche Item"
&SCOPED-DEFINE zzdivmt_form_2 "Issue able"
&SCOPED-DEFINE zzdivmt_form_3 "summer counter"
&SCOPED-DEFINE zzdivmt_form_4 "summer weight"
&SCOPED-DEFINE zzdivmt_form_5 "transfer user"
&SCOPED-DEFINE zzdivmt_form_6 "Defect Statue"
&SCOPED-DEFINE zzdivmt_form_7 "selectd counter"
&SCOPED-DEFINE zzdivmt_form_8 "selectd weight"

DEFINE NEW SHARED VARIABLE ovd_lot AS CHARACTER FORMAT "x(18)".
DEFINE NEW SHARED VARIABLE v_part AS CHARACTER FORMAT "x(8)".
DEFINE NEW SHARED VARIABLE v_DESC AS CHARACTER FORMAT "x(20)".
DEFINE NEW SHARED VARIABLE v_part1 AS CHARACTER FORMAT "x(8)".
DEFINE NEW SHARED VARIABLE v_desc1 AS CHARACTER FORMAT "x(20)".

DEFINE NEW SHARED VARIABLE hi_weight AS DECIMAL FORMAT ">>>>>>>>>9".
DEFINE NEW SHARED VARIABLE hi_count AS integer FORMAT ">>9".
DEFINE NEW SHARED VARIABLE wj_length AS DECIMAL.
DEFINE NEW SHARED VARIABLE wj_length1 AS DECIMAL.
DEFINE NEW SHARED VARIABLE yx_length AS DECIMAL.
DEFINE NEW SHARED VARIABLE yx_length1 AS DECIMAL.
DEFINE NEW SHARED VARIABLE zl_weight AS DECIMAL.
DEFINE NEW SHARED VARIABLE zl_weight1 AS DECIMAL.
DEFINE NEW SHARED VARIABLE vc_r AS DECIMAL.
DEFINE NEW SHARED VARIABLE vc_r1 AS DECIMAL.
DEFINE NEW SHARED VARIABLE v_mfd AS DECIMAL.
DEFINE NEW SHARED VARIABLE v_mfd1 AS DECIMAL.
DEFINE NEW SHARED VARIABLE v0_r AS DECIMAL LABEL "λ0".
DEFINE NEW SHARED VARIABLE pxl_rate AS DECIMAL.

DEFINE NEW SHARED VARIABLE wj_lengthd AS DECIMAL.
DEFINE NEW SHARED VARIABLE wj_length1d AS DECIMAL.
DEFINE NEW SHARED VARIABLE yx_lengthd AS DECIMAL.
DEFINE NEW SHARED VARIABLE yx_length1d AS DECIMAL.
DEFINE NEW SHARED VARIABLE zl_weightd AS DECIMAL.
DEFINE NEW SHARED VARIABLE zl_weight1d AS DECIMAL.
DEFINE NEW SHARED VARIABLE vc_rd AS DECIMAL.
DEFINE NEW SHARED VARIABLE vc_r1d AS DECIMAL.
DEFINE NEW SHARED VARIABLE v_mfdd AS DECIMAL.
DEFINE NEW SHARED VARIABLE v_mfd1d AS DECIMAL.
DEFINE NEW SHARED VARIABLE v0_rd AS DECIMAL LABEL "λ0".
DEFINE NEW SHARED VARIABLE pxl_rated AS DECIMAL.
DEFINE NEW SHARED VARIABLE all_defect AS CHARACTER
       format "x(12)".  /*浏览 zz032.p*/
DEFINE NEW SHARED VARIABLE v_select like mfc_logical format "Can_Issue/All".

DEFINE BUTTON BUTTON-SEARCH LABEL "Search" size 12 By 1.
DEFINE BUTTON BUTTON-BACK LABEL "BACK" SIZE 12 BY 1.
DEFINE BUTTON BUTTON-EXP label "EXP" SIZE 12 BY 1.
DEFINE VARIABLE v_frame-down AS INTEGER initial 6.
DEFINE NEW SHARED VARIABLE sum_count AS INTEGER.
DEFINE NEW SHARED VARIABLE sum_weight AS DECIMAL FORMAT "->>,>>>,>99.99".
DEFINE NEW SHARED VARIABLE sel_count AS INTEGER.
DEFINE NEW SHARED VARIABLE sel_sum_weight AS DECIMAL FORMAT "->>,>>>,>99.99".
DEFINE NEW SHARED VARIABLE transfer_rs_desc AS CHARACTER format "x(40)".
DEFINE NEW SHARED VARIABLE user_name AS CHARACTER.
DEFINE NEW SHARED VARIABLE vv_loc AS CHARACTER.
/*[再加工] Lot退回至"OVD外观检查完成"库位。*/
DEFINE NEW SHARED VARIABLE vv_locto AS CHARACTER.
DEF VAR l-focus AS WIDGET-HANDLE NO-UNDO.
define variable w-frame as widget-handle no-undo.
define variable i as integer no-undo.
DEFINE VARIABLE v_lot AS CHARACTER.
DEFINE VARIABLE yn AS LOGICAL.
DEFINE VARIABLE ko AS LOGICAL.
DEFINE VARIABLE kpart AS CHARACTER.
DEFINE VARIABLE vv_part AS CHARACTER.
DEFINE VARIABLE v_a AS DECIMAL.
DEFINE VARIABLE v_b AS DECIMAL.
DEFINE VARIABLE v_defect_code AS CHARACTER.
DEFINE VARIABLE sum_defect_length  AS DECIMAL.
DEFINE VARIABLE v_efflength AS DECIMAL.
DEFINE VARIABLE v_insp_dia AS DECIMAL.
DEFINE VARIABLE v_decimal AS DECIMAL.
DEFINE VARIABLE y_length AS DECIMAL.
DEFINE VARIABLE v_status AS CHARACTER.
DEFINE VARIABLE BUTTON-REWORK_STATUS AS CHARACTER.
DEFINE VARIABLE BUTTON-PRINT_STATUS AS CHARACTER.
DEFINE VARIABLE o_result AS LOGICAL.
DEFINE VARIABLE i_lotno like zzsellot_lotno.
DEFINE VARIABLE i_rwknum AS CHARACTER.
DEFINE VARIABLE i_part like pt_part.
DEFINE VARIABLE v_ttld_zpc AS DECIMAL.
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
define VARIABLE v_printer as CHARACTER format "x(12)".
define VARIABLE s_ZZ_DIVERSION_FRSTS_1 as CHARACTER no-undo.
define VARIABLE s_ZZ_DIVERSION_FRSTS_2 as CHARACTER no-undo.
define VARIABLE v_disppart as CHARACTER no-undo.
define VARIABLE v_engcode  as CHARACTER no-undo.
define VARIABLE v_defstat   as LOGICAL no-undo.

/*****************************************************************************
  code_mstr: code_fldname = "ZZ_ALL_DEFECT" and CODE_CMMT = GLOBAL_USER_LANG
             code_value = 1.ALL
             code_value = 2.SOME
             code_value = 3.NONE
******************************************************************************/

find first code_mstr no-lock where code_domain = global_domain
       and code_fldname = "ZZ_ALL_DEFECT" and substring(code_value,1,1) = "1"
       and code_cmmt = global_user_lang no-error.
if available code_mstr then do:
   assign all_defect = code_value.
end.

DEFINE BUTTON BUTTON-Select-All label "Select-All" SIZE 12 BY 1.
DEFINE BUTTON BUTTON-Cancel-All label "Cancel-All" SIZE 12 BY 1.
DEFINE BUTTON BUTTON-Print label "Print" SIZE 12 BY 1.
DEFINE BUTTON BUTTON-Rework label "Rework" SIZE 12 BY 1.

define variable v_caniss as logical.   /* 品质检验状态 */
define variable v_engstat as logical.  /* 工程状态 */
define variable v_enable_defect as logical initial NO.   /*是否允许Defect*/

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

FORM
    v_part COLON 15 space(0) v_desc NO-LABEL space(0)
    v_part1 label {&zzdivmt_form_1} space(0) v_desc1 NO-LABEL space(0)
    ovd_lot
    SKIP
    hi_weight COLON 15
    hi_count space(0)
    sum_count label {&zzdivmt_form_3}
    sum_weight label {&zzdivmt_form_4}
    wj_length COLON 15
    wj_length1 LABEL {t001.i}
    yx_length COLON 58
    yx_length1 LABEL {t001.i}
/*    sum_count label {&zzdivmt_form_3}  */
    SKIP
    zl_weight  COLON 15
    zl_weight1 LABEL {t001.i}
    all_defect COLON 58 label {&zzdivmt_form_6}
    v_select label {&zzdivmt_form_2}
/*    sum_weight label {&zzdivmt_form_4}  */
    SKIP
    vc_r COLON 15
    vc_r1 LABEL {t001.i}
    v_mfd COLON 58
    v_mfd1 LABEL {t001.i}
    v0_r
    pxl_rate
WITH FRAME b SIDE-LABELS  WIDTH 300.
setFrameLabels(FRAME b:HANDLE).

FORM
     ttld_sel label "S"
     ttld_lot label "lot"
     ttld_mfd label "mfd"
     ttld_rc label "rc"
     ttld_r0 label "r0"
     ttld_wj label "wj"
     ttld_yxc label "yxc"   /*有效长*/
     ttld_zzl label "zzl"
     ttld_jszl label "jszl"
     ttld_jbd label "jdb"
     ttld_rn label "rn"
     ttld_pxl label "pxl"
     ttld_bow label "bow"
     ttld_fy label "fy"
     ttld_qp label "qp"
     ttld_D_core label "d"
     ttld_slope label "slope"
     ttld_D1285 label "D1285"
     ttld_part1 label "part1"
with frame a 6 DOWN scroll 1 width 300 NO-BOX.
setFrameLabels(frame a:handle).

/* v_frame-down = 6. */
FORM
    sel_count AT 10 label {&zzdivmt_form_7} space(0)
    sel_sum_weight space(0)
    user_name label {&zzdivmt_form_5} space(0)
    transfer_rs space(0)
    transfer_rs_desc NO-LABEL
WITH FRAME f-sum SIDE-LABELS WIDTH 300.
setFrameLabels(FRAME f-sum:HANDLE).

FORM
    BUTTON-Select-All AT 1
    BUTTON-Cancel-All AT 20
    BUTTON-Print AT 40
    BUTTON-Rework AT 55
WITH FRAME c SIDE-LABELS WIDTH 220 no-box.
setFrameLabels(FRAME c:HANDLE).

FORM
    BUTTON-SEARCH AT 10
    BUTTON-Exp AT 30
    BUTTON-Back AT 50
WITH FRAME f-button SIDE-LABELS WIDTH 300 no-box.
setFrameLabels(FRAME f-button:HANDLE).

form
    v_printer
with centered overlay Frame f-print side-labels width 30.
setFrameLabels(Frame f-print:HANDLE).


ON LEAVE of v_part in FRAME b DO:
   assign v_part.
   FIND FIRST pt_mstr WHERE pt_domain = global_domain
          AND (pt_part = v_part and v_part <> "") NO-LOCK NO-ERROR.
       IF AVAIL pt_mstr THEN DO:
         ASSIGN v_desc = pt_desc1.
       end.
       display v_part v_desc with frame b.
end.

ON LEAVE of v_part1 in FRAME b DO:
   assign v_part1.
   FIND FIRST pt_mstr WHERE pt_domain = global_domain
          AND pt_part = v_part1 NO-LOCK NO-ERROR.
       IF AVAIL pt_mstr THEN DO:
         ASSIGN v_desc1 = pt_desc1.
       end.
       ELSE DO:
         if v_part1 = "" then assign v_desc1 = "".
                         else assign v_desc1 = "Not Avail Item".
       END.
       display v_part1 v_desc1 with frame b.
end.

PROCEDURE ip-button1:
      enable all with frame f-button.
      l-focus = button-search:HANDLE IN FRAME f-button.

      on choose of button-search
      do:
        if v_part = "" or v_part1 = "" then do:
           {mfmsg.i 7127 3}
           undo,retry.
        end.
        run getTtldDet.

        /* 删除选择条件以外的资料 */
        FOR EACH ttld_det exclusive-lock:
             IF (ttld_wj >= wj_length AND ttld_wj <= wj_length1 AND
                 ttld_yxc >= yx_length AND ttld_yxc <= yx_length1 AND
                 ttld_zzl >= zl_weight AND ttld_zzl <= zl_weight1 AND
                 ttld_rc >= vc_r AND ttld_rc <= vc_r1 AND
                 ttld_mfd >= v_mfd AND ttld_mfd <= v_mfd1 AND
                 ttld_r0 <= v0_r AND
                 ttld_pxl <= pxl_rate)
             THEN DO:
                 ttld_ok = "OK".
             END.
             ELSE DO:
                  delete ttld_det.
             END.
         END.  /*  FOR EACH ttld_det:   */

/*若转用后零件号为不可有Defect的零件号时，只有不为Defect的Lot才做为处理对象*/
        for each ttld_det exclusive-lock:
            if v_enable_defect = no and ttld_defstat THEN DO:
                delete ttld_det.
            end.
        end.

         /*删除Some 或 NONE */
         if substring(all_defect,1,1) = "2" Then DO: /* SOME */
            FOR EACH ttld_det exclusive-lock where ttld_defstat = NO:
                delete ttld_det.
            end.
         end.
         else if substring(all_defect,1,1) = "3" then do:
            for each ttld_det exclusive-lock where ttld_defstat:
                delete ttld_det.
            end.
         end.

         /* can-issue control */
         if v_select then do:
            for each ttld_det exclusive-lock where ttld_caniss = no:
                delete ttld_det.
            end.
         end.

          v_decimal = 0.
          i = 0.
          FOR EACH ttld_det :
             v_decimal = v_decimal + ttld_zzl.
             i = i + 1.
             ttld_sum_weight = v_decimal.
             ttld_count = i.
          END.

          run getHidata(input hi_count,input hi_weight).

          SUM_count = 0.
          sum_weight = 0.
          FOR EACH ttld_det :
             sum_count = sum_count + 1.
             sum_weight = sum_weight + ttld_zzl.
          END.
          display sum_count sum_weight with frame B.
          FIND FIRST ttld_det NO-LOCK NO-ERROR.
          IF NOT AVAIL ttld_det THEN DO:
             v_status = "None".
             yn = NO.
          END.
          ELSE DO:
             yn = NO.
             v_status = "OK".
          END.

          l-focus        = self:handle.
          RETURN.
      end. /* on choose of BUTTON-SEARCH */

      on choose of button-exp do:
/****************************************************************************
  HLD:
  5 按下规格外零件号检索  在LD中取出v_part1相关Lot
    从出货检查完成和品质保证部判定完成中检索出规格外Lot信息，
    在明细行中显示
    ※规格外的判断与出货重量准备处理中的规格外的判断相同

  DD:
    按下“规格外抽出”按钮，系统会列出不符合规格条件的OVDLotNo（必须有库存），
    即检索品名在规格条件之外的LotNo，把它们在明细行中显示，等待进一步处理；
****************************************************************************/
       button-rework_status = "ok".
       if v_part <> "" then do:
          /*转用后品名必须置空*/
          {pxmsg.i &MSGNUM=32017 &ERRORLEVEL=3}
          undo ,retry.
       end.
         run getTtldDet.

        /* 规格外抽出 */
        for each ttld_det exclusive-lock where ttld_inspec:
            delete ttld_det.
        end.

          v_decimal = 0.
          i = 0.

          FOR EACH ttld_det no-lock:
             v_decimal = v_decimal + ttld_zzl.
             i = i + 1.
             ttld_sum_weight = v_decimal.
             ttld_count = i.
          END.

          sum_count = 0.
          sum_weight = 0.
          FOR EACH ttld_det :
             sum_count = sum_count + 1.
             sum_weight = sum_weight + ttld_insp_good_weight.
          END.

          display sum_count sum_weight with frame B.
          FIND FIRST ttld_det NO-LOCK NO-ERROR.
          IF NOT AVAIL ttld_det THEN DO:
             v_status = "None".
             yn = NO.
          END.
          ELSE DO:
             yn = NO.
             v_status = "OK".
          END.

          l-focus        = self:handle.
          RETURN.

      end. /* ON CHOOSE OF button-exp */

      ON CHOOSE OF button-back
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
             BUTTON-SEARCH,
             BUTTON-Exp,
             BUTTON-Back
             focus
             l-focus.
          IF yn = NO THEN LEAVE.
      END.
      DISABLE ALL with frame f-button.
      HIDE FRAME f-button NO-PAUSE.
      hide message no-pause.
END PROCEDURE. /* ip-button */

ON CHOOSE OF BUTTON-Select-All
DO:

     sel_count = sum_count.
     sel_sum_weight = sum_weight.

     DISPLAY  sel_count
              sel_sum_weight
              transfer_rs
              transfer_rs_desc
              USER_name WITH FRAME f-sum.

      FOR EACH ttld_det :
          ttld_sel = yes.
      END.

      CLEAR FRAME a ALL NO-PAUSE.
      FIND FIRST ttld_det NO-LOCK NO-ERROR.
      i = 0.
      do while i < v_frame-down and available ttld_det:
          v_lot = ttld_lot.
          {zzdispttld.i}
          i = i + 1.
          if i < v_frame-down then down 1 WITH FRAME a.
          find next ttld_det  no-lock no-error.
      end.

      l-focus = BUTTON-Select-All:HANDLE IN FRAME C.
      RETURN.
END.

ON CHOOSE OF BUTTON-Cancel-All
DO:
    sel_count = 0.
    sel_sum_weight = 0.

    DISPLAY  sel_count
             sel_sum_weight
             transfer_rs
             transfer_rs_desc
             user_name  WITH FRAME f-sum.

    FOR EACH ttld_det :
        ttld_sel = no.
    END.

    CLEAR FRAME a ALL NO-PAUSE.
    FIND FIRST ttld_det NO-LOCK NO-ERROR.
    i = 0.
    do while i < v_frame-down and available ttld_det:
        v_lot = ttld_lot.
        {zzdispttld.i}
        i = i + 1.
        if i < v_frame-down then down 1 WITH FRAME a.
        find next ttld_det  no-lock no-error.
    end.
    l-focus = BUTTON-Cancel-All:HANDLE IN FRAME C.
    RETURN.
END.
ON CHOOSE OF BUTTON-Print
DO:
  IF BUTTON-Print_status = "complete" THEN DO:
     {pxmsg.i &MSGNUM=32012 &ERRORLEVEL=1}
  END.
  ELSE DO:

      IF button-rework_status = "ok" THEN DO:
         {pxmsg.i &MSGNUM=32010 &ERRORLEVEL=4}
      END.
      ELSE DO:
      /*打印专用指示书Key: OVDLOTNBR*/
      view frame f-print.
      display v_printer with frame f-print.
      pt-loop:
      do on error undo, retry:
         find first code_mstr no-lock where code_domain = global_domain
                and code_fldname = "API_PRINTER" no-error.
         if available code_mstr then do:
            assign v_printer = code_value.
            display v_Printer with frame f-print.
         end.
         update v_printer with frame f-print.
         assign v_printer.
         find first code_mstr where code_domain = global_domain
                and code_fldname = "API_PRINTER"
                and code_value = v_printer no-lock no-error.
         if not avail code_mstr then do :
                /*the printer is not defined*/
                {pxmsg.i &msgnum=4676 &errorlevel=3}
                pause.
                undo, retry pt-loop.
         end.
      end. /* on error undo,retry */

      hide frame f-print.
          /*打印指示书&倒退分解*/
          FOR EACH ttld_det where ttld_sel = yes:
              /*Print Division Sheet*/
             {gprun.i ""zzdivprt.p"" "(v_printer, ttld_lot)"}
          END.

         {gprun.i ""zzdivmt01.p""}

        {pxmsg.i &MSGNUM=32013 &ERRORLEVEL=1}

  /* SS - 20120331.1 - B */
  /* todo (or not) ???? search lot_mstr,
     and set lot__chr02 = s_ZZ_DIVERSION_FRSTS_xxx */
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

    IF button-rework_status = "complete" THEN DO:
       {pxmsg.i &MSGNUM=32012 &ERRORLEVEL=1}
    END.
    ELSE DO:
        IF button-rework_status <> "ok" THEN DO:
           {pxmsg.i &MSGNUM=32011 &ERRORLEVEL=4}
        END.
        ELSE DO:

           {gprun.i ""zzdivmt02.p""}
           {pxmsg.i &MSGNUM=32014 &ERRORLEVEL=1}
           button-rework_status = "complete".

           yn = NO.
        END.
    END.

  l-focus        = BUTTON-Rework:HANDLE IN FRAME C.
  RETURN.
END.

      w-frame = frame c:handle.
      assign frame c:centered = true
             frame c:row      = 20.

v_status = "".

REPEAT:
    HIDE FRAME f-print no-pause.
    HIDE FRAME f-sum NO-PAUSE.
    /*
    HIDE FRAME f-button NO-PAUSE.
    */
    HIDE FRAME c NO-PAUSE.
    hide frame a no-pause.
    pause before-hide.
    assign v_select = no.
    DISP all_defect WITH FRAME b.
    view FRAME b.

    button-rework_status = "".
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
    v_desc = "".
    v_desc1 = "".
    user_name = global_userid.

    setb:
    do on error undo, retry:

        HIDE FRAME f-sum NO-PAUSE.
        /*
        HIDE FRAME f-button NO-PAUSE.
        */
        HIDE FRAME c NO-PAUSE.
        hide frame a no-pause.
        pause before-hide.
        v_desc = "".
        v_desc1 = "".
        DISP v_part v_part1 v_desc v_desc1 all_defect WITH FRAME b.
        view FRAME b.
        vv_part = "".
      update
            v_part
            v_part1
            ovd_lot
            WITH FRAME b.

        /* SS - 20120706.1 - B */
        if ovd_lot <> "" and v_part1 = "" then do:
            for first code_mstr
                no-lock
                use-index code_fldval
                where code_domain = global_domain
                    and code_fldname = "ZZ_DIVERSION_FRLOC"
                    and code_value = "":
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
                    and loc_loc = code_cmmt :
            end.
            if not(available(loc_mstr)) then do:
                {pxmsg.i &msgnum=32007 &errorlevel=3}
                next-prompt v_part with frame b.
                undo, retry setb.
            end.
            assign
                vv_loc = code_cmmt.   /* from location */

            find first ld_det
                use-index ld_loc_p_lot
                where ld_domain = global_domain
                    and ld_loc = vv_loc
                    and ld_lot = ovd_lot
                    and ld_qty_oh > 0
                no-lock no-error.
            if available(ld_det) then do:
                v_part1 = ld_part.
                if index(v_part1, "-") > 0 then
                    v_part1 = entry(1, v_part1, "-").
            end.

            display v_part1 with frame b.
        end.
        /* SS - 20120706.1 - E */

          FIND FIRST pt_mstr WHERE pt_domain = global_domain
                 AND pt_part = INPUT v_part1 NO-LOCK NO-ERROR.
              IF AVAIL pt_mstr THEN DO:
                assign v_desc1 = pt_desc1.
              END.
              ELSE DO:
                 if v_part1 = "" then assign v_desc1 = "".
                                 else assign v_desc1 = "Not Avail Item".
              END.
          FIND FIRST pt_mstr WHERE pt_domain = global_domain
                 AND pt_part = v_part and v_part <> "" NO-LOCK NO-ERROR.
              IF AVAIL pt_mstr THEN DO:
                ASSIGN v_desc = pt_desc1.
              end.
/*            ELSE DO:                                                     */
/*              if v_part = "" then assign v_desc = "".                    */
/*                             else assign v_desc = "Not Avail Item".      */
/*            END.                                                         */

         display v_part v_desc v_part1 v_desc1 with frame b.

         IF v_part = v_part1 THEN DO:
            {pxmsg.i &MSGNUM=32008 &ERRORLEVEL=4}.
            next-prompt v_part with frame b.
            undo, retry setb.
         END.

/* SS - 20120331.1 - B      判断通用代码是否有定义                          */
        for first code_mstr
            no-lock
            use-index code_fldval
            where code_domain = global_domain
                and code_fldname = "ZZ_DIVERSION_FRLOC"
                and code_value = "":
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
                and loc_loc = code_cmmt :
        end.
        if not(available(loc_mstr)) then do:
            {pxmsg.i &msgnum=32007 &errorlevel=3}
            next-prompt v_part with frame b.
            undo, retry setb.
        end.
        assign
            vv_loc = code_cmmt.   /* from location */

        for first code_mstr
            no-lock
            use-index code_fldval
            where code_domain = global_domain
                and code_fldname = "ZZ_DIVERSION_OVDVISINSPCOMP_LOC"
                and code_value = "":
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
                and loc_loc = code_cmmt :
        end.
        if not(available(loc_mstr)) then do:
            {pxmsg.i &msgnum=32007 &errorlevel=3}
            next-prompt v_part with frame b.
            undo, retry setb.
        end.
        assign
            vv_locto = code_cmmt.  /**Lot退回至"OVD外观检查完成库位(160)"。**/

        for first code_mstr
            no-lock
            use-index code_fldval
            where code_domain = global_domain
                and code_fldname = "ZZ_DIVERSION_FRSTS"
                and code_value = "01":
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
                and code_value = "02":
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
        if v_part <> "" then do:
           FIND FIRST pt_mstr NO-LOCK WHERE pt_domain = global_domain AND
                      pt_part = v_part NO-ERROR.
           IF NOT AVAIL pt_mstr THEN DO:
               {pxmsg.i &MSGNUM=32001 &ERRORLEVEL=3}
               next-prompt v_part with frame b.
               undo, retry setb.
           END.
           else do:
             /* 转换后料号需做校验 */
             if (pt_part begins "zzlot" or length(pt_part) <> 6) then do:
                 /* Configured item not allowed */
                 {pxmsg.i &MSGNUM=225 &ERRORLEVEL=3}.
                 next-prompt v_part with frame b.
                 undo, retry setb.
             end.
           end.
        end. /*if v_part <> "" then do:*/

        FIND FIRST pt_mstr WHERE pt_domain = global_domain AND
                   pt_part = v_part1 and v_part1 <> "" NO-LOCK NO-ERROR.
        IF NOT AVAIL pt_mstr THEN DO:
            {pxmsg.i &MSGNUM=32002 &ERRORLEVEL=3}.
            next-prompt v_part1 with frame b.
            undo, retry setb.
        END.
        /*check part + "-05" begin*/
        /*SS - 111229.1 B*/
        if v_part <> "" then do:
            assign x_part = v_part + "-05".
        end.
        else do:
            assign x_part = "".
        end.
        assign x_part1 = v_part1 + "-05".

 /* 如果转换后的品名不允许有defect < 1  标识不允许有缺陷,如果有缺陷则排除在外 */
       assign v_enable_defect = no
              hi_weight = 0
              hi_count = 0
              wj_length = 0
              wj_length1 = 0
              yx_length = 0
              yx_length1 = 0
              sum_count = 0
              zl_weight = 0
              zl_weight1 = 0
              sum_weight = 0
              vc_r = 0
              vc_r1 = 0
              v_mfd = 0
              v_mfd1 = 0
              v0_r = 0
              pxl_rate = 0.
/*如果 v_part = "" 条件框默认值明细时显示转换前，否则显示转换后*/
          if v_part = "" then do:
             assign v_disppart = v_part1.
          end. /* if v_part <> "" then do:*/
          else do:
             assign v_disppart = v_part.
          end.
          FIND FIRST mpd_det WHERE mpd_domain = global_domain
                 AND mpd_nbr = ("X7" + v_disppart)
                 AND mpd_type = "00036" NO-LOCK NO-ERROR.
          if available mpd_det AND trim(mpd_tol) = "1" then do:
             assign v_enable_defect = yes.
          end.

          FIND FIRST ld_det WHERE ld_domain = global_domain AND
                     ld_part = x_part1 AND ld_loc = vv_loc AND
                    (ld_lot = ovd_lot OR ovd_Lot = "") AND ld_qty_oh > 0
               NO-LOCK NO-ERROR.
          IF NOT AVAIL ld_det  THEN DO:
              {pxmsg.i &MSGNUM=32016 &ERRORLEVEL=3}.
              next-prompt ovd_lot with frame b.
              undo, retry setb.
          END.
          FOR EACH mpd_det WHERE mpd_domain = global_domain AND
                   mpd_nbr = ("X7" + v_disppart) NO-LOCK:
                  if mpd_type = "00014" then do:
                     wj_length = decimal(mpd_tol).
                     wj_lengthd = decimal(mpd_tol).
                  end.

                  if mpd_type = "00013" then do:
                     wj_length1 = decimal(mpd_tol).
                     wj_length1d = decimal(mpd_tol).
                  end.

                  if mpd_type = "00012" then do:
                     yx_length = decimal(mpd_tol).
                     yx_lengthd = decimal(mpd_tol).
                  end.

                  if mpd_type = "00011" then do:
                     yx_length1 = decimal(mpd_tol).
                     yx_length1d = decimal(mpd_tol).
                  end.

                  if mpd_type = "00016" then do:
                     zl_weight = decimal(mpd_tol).
                     zl_weightd = decimal(mpd_tol).
                  end.
                  if mpd_type = "00015" then do:
                     zl_weight1 = decimal(mpd_tol).
                     zl_weight1d = decimal(mpd_tol).
                  end.

                  if mpd_type = "00018" then do:
                     vc_r = decimal(mpd_tol).
                     vc_rd = decimal(mpd_tol).
                  end.

                  if mpd_type = "00017" then do:
                     vc_r1 = decimal(mpd_tol).
                     vc_r1d = decimal(mpd_tol).
                  end.

                  if mpd_type = "00020" then do:
                     v_mfd = decimal(mpd_tol).
                     v_mfdd = decimal(mpd_tol).
                  end.

                  if mpd_type = "00019" then do:
                     v_mfd1 = decimal(mpd_tol).
                     v_mfd1d = decimal(mpd_tol).
                  end.

                  if mpd_type = "00023" then do:
                     v0_r = decimal(mpd_tol).
                     v0_rd = decimal(mpd_tol).
                  end.

                  if mpd_type = "00027" then do:
                     pxl_rate = decimal(mpd_tol).
                     pxl_rated = decimal(mpd_tol).
                  end.

                  IF mpd_type = "00041" THEN DO:
                     jsyc_dec = decimal(mpd_tol).
                  END.

                  IF mpd_type = "00042" THEN DO:
                     qtyc_dec = decimal(mpd_tol).
                  END.
          END.
       DISPLAY hi_weight
               hi_count
               wj_length
               wj_length1
               yx_length
               yx_length1
               sum_count
               zl_weight
               zl_weight1
               all_defect
               v_select
               sum_weight
               vc_r
               vc_r1
               v_mfd
               v_mfd1
               v0_r
               pxl_rate
               WITH FRAME b.
        setb-1:
        do on error undo, retry:
            set hi_weight
                hi_count
                wj_length
                wj_length1
                yx_length
                yx_length1
                zl_weight
                zl_weight1
                all_defect
                v_select
                vc_r
                vc_r1
                v_mfd
                v_mfd1
                v0_r
                pxl_rate
                WITH FRAME b.
         if wj_length < wj_lengthd then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt wj_length with frame b.
            undo, retry setb-1.
         end.
         if wj_length1 > wj_length1d then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt wj_length1 with frame b.
            undo, retry setb-1.
         end.
         if yx_length < yx_lengthd then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt yx_length with frame b.
            undo, retry setb-1.
         end.
         if yx_length1 > yx_length1d then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt yx_length1 with frame b.
            undo, retry setb-1.
         end.
         if zl_weight < zl_weightd then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt zl_weight with frame b.
            undo, retry setb-1.
         end.
         if zl_weight1 > zl_weight1d then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt zl_weight1 with frame b.
            undo, retry setb-1.
         end.
         if vc_r < vc_rd then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt vc_r with frame b.
            undo, retry setb-1.
         end.
         if vc_r1 > vc_r1d then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt vc_r1 with frame b.
            undo, retry setb-1.
         end.
         if v_mfd < v_mfdd then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt v_mfd with frame b.
            undo, retry setb-1.
         end.
         if v_mfd1 > v_mfd1d then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt v_mfd1 with frame b.
            undo, retry setb-1.
         end.
         if v0_r > v0_rd and v0_rd <> 0 then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt v0_r with frame b.
            undo, retry setb-1.
         end.
         if pxl_rate > pxl_rated and pxl_rated <> 0 then do:
            {pxmsg.i &MSGNUM=2925 &ERRORLEVEL=3}
            next-prompt pxl_rate with frame b.
            undo, retry setb-1.
         end.
      IF not can-find(first code_mstr no-lock where
                            code_domain = global_domain and
                            code_fldname = "ZZ_ALL_DEFECT" and
                            code_value = all_defect and
                            code_cmmt = global_user_lang) THEN DO:
          {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
          next-prompt all_defect with frame b.
          undo, retry setb-1.
      END.

 /*  如果转换后的品名不允许有defect < 1标识不允许有缺陷,                   */
 /*  则all_defect不允许选择all                                             */
 /*  FIND FIRST mpd_det WHERE mpd_domain = global_domain AND               */
 /*             mpd_nbr = ("X7" + v_part) AND                              */
 /*             mpd_type = "00036" AND                                     */
 /*             DECIMAL(mpd_tol) < 1 NO-LOCK NO-ERROR.                     */
 /*  IF AVAILABLE mpd_det THEN DO:                                         */
    if v_enable_defect = no and v_part <> "" then do:
         find first code_mstr no-lock where
                    code_domain = global_domain and
                    code_fldname = "ZZ_ALL_DEFECT" and
                    substring(code_value,1,1) = "1" and
                    code_cmmt = global_user_lang no-error.
         if available code_mstr then do:
            {pxmsg.i &MSGNUM=32005 &ERRORLEVEL=3}.
            next-prompt all_defect with frame b.
            undo, retry setb-1.
         end.
     END.
            YN = YES.
            v_status = "".
            RUN ip-button1.
            IF v_status = "None" THEN DO:
                   {pxmsg.i &MSGNUM=32004 &ERRORLEVEL=3}.
                   next-prompt hi_weight with frame b.
                   undo, retry setb-1.
            END.

            IF v_status = "Back" THEN DO:
                next-prompt all_defect with frame b.
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
            VIEW FRAME a.

            FIND FIRST ttld_det NO-LOCK NO-ERROR.
            IF NOT AVAIL ttld_det THEN LEAVE.

            i = 0.
            do while i < v_frame-down and available ttld_det:
                {zzdispttld.i}
                i = i + 1.
                /*
                MESSAGE "11111-" i.
                */
                if i < v_frame-down then down 1.
                find next ttld_det
                no-lock no-error.
            end.

            up i.
            PAUSE 0.
           {zzselect.i}

        END.
/*
        CLEAR FRAME a ALL NO-PAUSE.
        FIND FIRST ttld_det NO-LOCK NO-ERROR.
        i = 0.
        do while i < v_frame-down and available ttld_det:
            v_lot = ttld_lot.
            {zzdispttld.i}
            i = i + 1.
            if i < v_frame-down then down 1 WITH FRAME a.
            find next ttld_det  no-lock no-error.
        end.
*/
        f-sum-loop:
        do on error undo, retry:
            assign sel_count = 0
                   sel_sum_weight = 0.
            for each ttld_det no-lock where ttld_sel = yes:
                assign sel_count = sel_count + 1
                       sel_sum_weight = sel_sum_weight + ttld_zzl.
            end.
            DISPLAY sel_count
                    sel_sum_weight
                    transfer_rs
                    transfer_rs_desc
                    USER_name  WITH FRAME f-sum.

           IF button-rework_status <> "ok" THEN DO:
               UPDATE transfer_rs WITH FRAME f-sum.
               FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                          mpd_nbr = "XC" + transfer_rs AND
                          mpd_type = "00025" AND
                          mpd_tol = "1" NO-LOCK NO-ERROR.
               IF NOT AVAIL mpd_det THEN DO:
                   {pxmsg.i &MSGNUM=32009 &ERRORLEVEL=3}.
                   next-prompt transfer_rs with frame f-sum.
                   undo, retry f-sum-loop.
               END.
               assign transfer_rs_desc = "".
               FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                          mpd_nbr = "XC" + transfer_rs and
                          mpd_type = "00001" NO-LOCK NO-ERROR.
               IF AVAIL mpd_det THEN DO:
                  assign transfer_rs_desc = mpd_tol.
                  DISPlay transfer_rs_desc WITH FRAME f-sum.
               END.
           END.
           ENABLE ALL WITH FRAME c.
           yn = YES.
           l-focus = BUTTON-Select-All:HANDLE IN FRAME c.
           ko = YES.
           REPEAT:
               WAIT-FOR GO OF FRAME c
                   OR CHOOSE OF BUTTON-Select-All, BUTTON-Cancel-All,
                                BUTTON-Print ,BUTTON-Rework FOCUS l-focus.
               IF yn = NO THEN LEAVE.
           END.
        END.

        HIDE FRAME f-sum NO-PAUSE.
        HIDE FRAME c NO-PAUSE.
        hide frame a no-pause.
        pause before-hide.
    END.
END.

PROCEDURE getTtldDet:
/* -----------------------------------------------------------
   Purpose: get temp-table ttld_det data.
   Parameters:
   Notes:
 -------------------------------------------------------------*/

     EMPTY TEMP-TABLE ttld_det.
     FOR EACH ld_det WHERE ld_domain = global_domain AND
              ld_part = x_part1 AND ld_loc = vv_loc AND
             (ld_lot = ovd_lot OR ovd_Lot = "") AND
              ld_qty_oh > 0 NO-LOCK:

/***************************************************************************
 可出库：转用前品名必须有可用库存，
         属于规格内（参照"出货重量准备"的规格外判定逻辑），
         也必须是Lot Master中出货禁止的状态为空的；
         并且该批次的炉芯管Status、盐素Status、检查Status、OHStatus全为"1"
***************************************************************************/

          assign v_caniss = no
                 o_result = no.
          FIND FIRST lot_mstr WHERE lot_domain = global_domain AND
                     lot_serial = ld_lot AND lot_part = "zzlot1"
               NO-LOCK NO-ERROR.
           /* 批号记录不存在 */
          IF AVAIL lot_mstr THEN DO:
             IF lot__chr02 = "" AND lot__chr03 = "1" AND
                lot__chr04 = "1" AND lot__chr05 = "1" AND
                lot__chr06 = "1" THEN DO:
                   assign v_caniss = yes.  /*can-issue 的判断条件*/
             END.
          END.
         {gprun.i ""zzspechk.p"" "(ld_lot, '', v_part1, output o_result)"}

             assign v_engstat = no
                    v_engcode = "".
             FIND FIRST lot_mstr WHERE lot_domain = global_domain AND
                        lot_serial = ld_lot AND lot_part = "zzlot2"
             NO-LOCK NO-ERROR.
             IF AVAIL lot_mstr THEN DO:
                assign v_engcode = lot__chr02.
                /*工程进度Status为"210"或"220"*/
                if can-find(first code_mstr no-lock where
                                  code_domain = global_domain and
                                  code_fldname = "ZZ_DIVERSION_FRSTS" and
                                  /* SS - 20120808.1 - B */
                                  (code_value = "01" or code_value = "02") and
                                  /* SS - 20120808.1 - E */
                                  code_cmmt = lot__chr02)
                then do:
                     assign v_engstat = yes.
                end.
                /* SS - 20120808.1 - B */
                else do:
                    next.
                end.
                /* SS - 20120808.1 - E */
             END. /*IF AVAIL LOT_MSTR THEN DO:*/
             /* SS - 20120808.1 - B */
             else do:
                next.
             end.
             /* SS - 20120808.1 - E */
/* 判断是否有为defect品,如果有是新做defect检查(是否符合defect规范) */
             assign v_defstat = no
                    ov_result = "".

             FIND FIRST zzsellot_mstr WHERE
                        zzsellot_domain = global_domain AND
                        zzsellot_lotno = ld_lot AND
                        zzsellot_final = "1"
                 NO-LOCK NO-ERROR.
             IF AVAIL zzsellot_mstr THEN DO:
                 IF zzsellot_insp_defect = "*" THEN DO:
                     assign v_defstat = yes.  /*是defect品*/
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
                END.     /* IF zzsellot_insp_defect = "*" THEN DO: */
            END.         /* IF AVAIL zzsellot_mstr THEN DO:        */
/*/* 如果转换后的品名不允许有defect <1 标识不允许有缺陷,如果有缺陷则排除在外*/*/
/*             FIND FIRST mpd_det WHERE mpd_domain = global_domain        */
/*                    AND mpd_nbr = ("X7" + v_part)                       */
/*                    AND mpd_type = "00036"                              */
/*                    AND DECIMAL(mpd_tol) < 1 NO-LOCK NO-ERROR.          */
/*             IF AVAILABLE mpd_det THEN DO:                              */
/*                 IF ov_result <> "ok" THEN DO:                          */
/*                     NEXT.                                              */
/*                 END.                                                   */
/*             END. /* if available mpd_det then do:          */          */
          /*创建记录*/
          CREATE ttld_det.
          ASSIGN
                ttld_sel = no
                ttld_lot = ld_lot
                ttld_part = x_part
                ttld_check = (if ov_result = "ok" then "合格" else "")
                ttld_part1 = ld_part
                ttld_site = ld_site
                ttld_loc = ld_loc
                ttld_qty_oh = ld_qty_oh
                ttld_loc_to = vv_locto
                ttld_ref = ld_ref
                ttld_inspec = o_result
                ttld_defstat = v_defstat
                ttld_qastat = v_caniss
                ttld_engstat = v_engstat
                ttld_engcode = v_engcode
                ttld_caniss = (if o_result and v_caniss then yes else no)
                .

          FIND FIRST zzsellot_mstr WHERE
                     zzsellot_domain = global_domain and
                     zzsellot_lotno = ld_lot and
                     zzsellot_final = "1"
               NO-LOCK NO-ERROR.
          IF AVAIL zzsellot_mstr THEN DO:
              ASSIGN
                  ttld_mfd = zzsellot_insp_mfd
                  ttld_rc = zzsellot_insp_cutoff
                  ttld_r0 = zzsellot_insp_zdw
                  ttld_wj = zzsellot_insp_dia
                  ttld_zzl = zzsellot_insp_diviedweight
                  ttld_insp_good_weight = zzsellot_insp_goodweight
                  ttld_rn  = zzsellot_insp_dn
                  ttld_pxl = zzsellot_insp_ecc
                  ttld_bow = zzsellot_insp_bow
                  ttld_fy  = zzsellot_insp_noncirc
                  ttld_qp = if zzsellot_insp_bubble = ? then ""
                          else zzsellot_insp_bubble
                  ttld_D_core = zzsellot_insp_dc
                  ttld_slope = zzsellot_insp_slope
                  ttld_D1285 = zzsellot_insp_d1285.

                 /*转换前有效长,和外径*/
                 v_efflength = zzsellot_insp_efflength.
                 v_insp_dia = zzsellot_insp_dia.
                 find first zzovdsublot_mstr where
                            zzovdsublot_domain = zzsellot_domain and
                            zzovdsublot_lotno = zzsellot_ovdsublotno
                 no-lock no-error.
                 if available zzovdsublot_mstr then do:
                    assign ttld_pa_date = zzovdsublot_pa_date.
                 end.
                 else do:
                    assign ttld_pa_date = ?.
                 end.
          END.
          ELSE DO:
              ASSIGN ttld_mfd = 0
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
       /* 计算转换前物料系数a,b*/
          FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                     mpd_nbr = ("X7" + v_part1) AND
                     mpd_type = "00037" AND
                     mpd_tol <> "" NO-LOCK NO-ERROR.
          IF AVAIL mpd_det THEN DO:
              v_defect_code = mpd_tol.
             FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                        mpd_nbr = ("XQ" + v_defect_code) AND
                        mpd_type = "00023"
                  NO-LOCK NO-ERROR.
             IF AVAIL mpd_det THEN DO:
                 v_a = DECIMAL(mpd_tol).
             END.
             ELSE DO:
                 v_a = 0.
             END.
             FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                        mpd_nbr = ("XQ" + v_defect_code) AND
                        mpd_type = "00022"
                 NO-LOCK NO-ERROR.
             IF AVAIL mpd_det THEN DO:
                 v_b = DECIMAL(mpd_tol).
             END.
             ELSE DO:
                 v_b = 0.
             END.
          END.
          ELSE DO:
              FIND FIRST CODE_mstr WHERE
                         CODE_domain = global_domain AND
                         CODE_fldname = "ZZ_DEF_PARA_A"
                   NO-LOCK NO-ERROR.
              IF AVAIL CODE_mstr THEN DO:
                  v_a = decimal(CODE_cmmt).
              END.
              ELSE DO:
                  v_a = 0.
              END.

              FIND FIRST CODE_mstr WHERE
                         CODE_domain = global_domain AND
                         CODE_fldname = "ZZ_DEF_PARA_B"
                   NO-LOCK NO-ERROR.
              IF AVAIL CODE_mstr THEN DO:
                  v_b = decimal(CODE_cmmt).
              END.
              ELSE DO:
                  v_b = 0.
              END.
          END.
          /* 转用前总defect=∑(缺陷长×a ＋ b) */
          sum_defect_length = 0.
          FOR EACH qc_mstr WHERE qc_domain = global_domain AND
                   qc_part = ld_part AND
                   qc_serial = ld_lot NO-LOCK,
              EACH mph_hist WHERE mph_domain = global_domain AND
                   mph_lot = qc_lot AND mph_procedure = "INS_DEF" AND
                   mph_routing = "210" AND mph_op = 10 AND
                   INDEX(mph_test,"BAD_SIZE") > 0
              NO-LOCK:
              sum_defect_length = sum_defect_length
                                + (DECIMAL(mph_rsult) * v_a + v_b).
          END.

          /*转用前余长 = 技术余长00041 + 其他余长00042*/
          y_length = 0.
          FOR EACH mpd_det WHERE mpd_domain = global_domain AND
                   mpd_nbr = ("X7" + v_part1) AND
                  (mpd_type = "00041" OR mpd_type = "00042") NO-LOCK:
             y_length = y_length + DECIMAL(mpd_tol).
          END.

   /*制品长(转用前) = 有效长(转用前) + 余长(转用前) + 总defect长(转用前)*/
           ASSIGN v_ttld_zpc = v_efflength + Y_length + sum_defect_length.

   /* 计算转换后物料系数a,b虽然缺陷长不变由于系数变化引起转用后总长变化 */

           FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                      mpd_nbr = ("X7" + v_part) AND
                      mpd_type = "00037" AND
                      mpd_tol <> "" NO-LOCK NO-ERROR.
           IF AVAIL mpd_det THEN DO:
               v_defect_code = mpd_tol.
              FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                         mpd_nbr = ("XQ" + v_defect_code) AND
                         mpd_type = "00023"
                   NO-LOCK NO-ERROR.
              IF AVAIL mpd_det THEN DO:
                  v_a = DECIMAL(mpd_tol).
              END.
              ELSE DO:
                  v_a = 0.
              END.

              FIND FIRST mpd_det WHERE mpd_domain = global_domain AND
                         mpd_nbr = ("XQ" + v_defect_code) AND
                         mpd_type = "00022"
                  NO-LOCK NO-ERROR.
              IF AVAIL mpd_det THEN DO:
                  v_b = DECIMAL(mpd_tol).
              END.
              ELSE DO:
                  v_b = 0.
              END.
           END.
           ELSE DO:
               FIND FIRST CODE_mstr WHERE
                          CODE_domain = global_domain AND
                          CODE_fldname = "ZZ_DEF_PARA_A"
                    NO-LOCK NO-ERROR.
               IF AVAIL CODE_mstr THEN DO:
                   v_a = decimal(CODE_cmmt).
               END.
               ELSE DO:
                   v_a = 0.
               END.

               FIND FIRST CODE_mstr WHERE
                          CODE_domain = global_domain AND
                          CODE_fldname = "ZZ_DEF_PARA_B"
                    NO-LOCK NO-ERROR.
               IF AVAIL CODE_mstr THEN DO:
                   v_b = decimal(CODE_cmmt).
               END.
               ELSE DO:
                   v_b = 0.
               END.
           END.
           /*   转用后总defect长   */
           sum_defect_length = 0.
           FOR EACH qc_mstr WHERE qc_domain = global_domain AND
                    qc_part = ld_part AND
                    qc_serial = ld_lot NO-LOCK,
               EACH mph_hist WHERE mph_domain = global_domain AND
                    mph_lot = qc_lot AND mph_procedure = "INS_DEF" AND
                    mph_routing = "210" AND mph_op = 10 AND
                    INDEX(mph_test,"BAD_SIZE") > 0
               NO-LOCK:
               sum_defect_length = sum_defect_length
                                 + (DECIMAL(mph_rsult) * v_a + v_b ).
           END.

          /*转用后余长*/
          y_length = 0.
          FOR EACH mpd_det WHERE mpd_domain = global_domain AND
                   mpd_nbr = ("X7" + v_part) AND
                  (mpd_type = "00041" OR mpd_type = "00042") NO-LOCK:
             y_length = y_length + DECIMAL(mpd_tol).
          END.
 /* 有效长度 = 制品长度(转用前) – 余长(转用后) – 总Defect长度(转用后)  */
          ASSIGN ttld_yxc = v_ttld_zpc - y_length - sum_defect_length.

  /*计算重量 = 外径 * 外径 * 3.14 / 4 * 2.2 * 有效长度 / 1000 */
          ASSIGN ttld_jszl = v_insp_dia * v_insp_dia * 3.14 / 4
                           * 2.2 * ttld_yxc / 1000.
      END.      /* FOR EACH ld_det */

END PROCEDURE. /* PROCEDURE getTtldDet*/

PROCEDURE getHidata:
/* -----------------------------------------------------------
   Purpose: 库存的排列顺序改为按照PA测定日期的升序排列
            显示的总重量不可以超过HI_WEIGHT，笔数不可大于HI_COUNT.
   Parameters:
   Notes:
 -------------------------------------------------------------*/
      define input parameter maxCnt as integer.
      define input parameter maxWeight as decimal.
      define variable iCnt as integer.
      define variable iWeight as decimal.
      define variable vdel as logical.
      assign vdel = no.
      for each ttld_det exclusive-lock break by ttld_pa_date:
          assign iCnt = iCnt + 1
                 iWeight = iWeight + ttld_zzl.
          if iWeight > maxWeight and iCnt <> maxCnt and
             maxWeight > 0 then do:
             assign vdel = yes.
          end.
          if iCnt > maxCnt and maxCnt > 0 then do:
             assign vdel = yes.
          end.
          if vdel then do:
             delete ttld_det.
          end.
      end.

END PROCEDURE. /* PROCEDURE getHidata*/
