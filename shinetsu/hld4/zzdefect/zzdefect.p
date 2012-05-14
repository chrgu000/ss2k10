/*111123.1 by ken*/
/*111222.1 by ken*/
/* SS - 120219.1 By: Kaine Zhang */
/* SS - 120306.1 By: Kaine Zhang */
/* SS - 120307.1 By: Kaine Zhang */

/*
history
[20120307.1]
1. HLD(jp).line.911.   condition wk_chk_kbnI = '1' change to wk_kizu_kbnI[v_count] <> '1'
[20120306.1]
1. re-write block -- if i_kubun = "2" then do: ... end.
1.1. loop2, I array fix.
1.2. other detail...
2. ng1_2 condition. (add condition: ... and (wk_seihin_kei_max + wk_seihin_kei_min) / 2  < wk_def_kazu_size2).
3. ng4_x loop condition. (do .. = 1 to wk_rowsF) ----> (do .. = 1 to wk_rowsI)
4. ng5 condition. (wk_Length < wk_seihin_len_min) ----> (wk_Length < wk_z)
5. add wk_def_len_min_kbn := '1'.  (ref: HLD.line.748.)
6. ng2_1, ng2_2, ng2_3. logical struct -- side by side.
[20120219.1]
NG deatil message update.
 */

{mfdeclre.i}
{gplabel.i}
define input  parameter i_ovdlotno AS CHARACTER no-undo.
define input  parameter i_part AS CHARACTER no-undo.
define input  parameter i_length AS DECIMAL no-undo.
define input  parameter i_kubun AS CHARACTER no-undo.
define input  parameter i_ap1 AS DECIMAL no-undo.
define input  parameter i_ap2 AS DECIMAL no-undo.
define input  parameter i_ap3 AS DECIMAL no-undo.
define input  parameter i_ap4 AS DECIMAL no-undo.
define input  parameter i_ap5 AS DECIMAL no-undo.
define input  parameter i_ap6 AS DECIMAL no-undo.
define input  parameter i_size1 AS DECIMAL no-undo.
define input  parameter i_size2 AS DECIMAL no-undo.
define input  parameter i_size3 AS DECIMAL no-undo.
define input  parameter i_size4 AS DECIMAL no-undo.
define input  parameter i_size5 AS DECIMAL no-undo.
define input  parameter i_size6 AS DECIMAL no-undo.
define input  parameter i_type1 AS CHARACTER no-undo.
define input  parameter i_type2 AS CHARACTER no-undo.
define input  parameter i_type3 AS CHARACTER no-undo.
define input  parameter i_type4 AS CHARACTER no-undo.
define input  parameter i_type5 AS CHARACTER no-undo.
define input  parameter i_type6 AS CHARACTER no-undo.

define output parameter o_result AS CHARACTER no-undo.

DEFINE VARIABLE wk_seihin_kei_max AS DECIMAL . /*制品径上限*/
DEFINE VARIABLE wk_seihin_kei_min AS DECIMAL . /*制品径下限*/
DEFINE VARIABLE wk_seihin_len_max AS DECIMAL . /*制品长上限*/
DEFINE VARIABLE wk_seihin_len_min AS DECIMAL . /*制品长下限*/
DEFINE VARIABLE wk_def_kikaku_cd AS CHARACTER. /*defect规格code*/

/*Defect区分*/
/*Defect size*/
/*Defect size 以下*/
/*伤处分区*/
/* Defect内部*表面区分*/
DEFINE VARIABLE wk_def_chk_kbn AS CHARACTER.
DEFINE VARIABLE wk_def_size_cho AS DECIMAL.
DEFINE VARIABLE wk_def_size_ika AS DECIMAL .
DEFINE VARIABLE wk_def_kizu_kbn AS CHARACTER.
DEFINE VARIABLE wk_defect_io_kbn AS CHARACTER.

DEFINE VARIABLE wk_rowsF AS INTEGER.
DEFINE VARIABLE wk_apF  AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_sizeF AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_bad_cdF AS CHARACTER EXTENT 20.
DEFINE VARIABLE wk_chk_kbnF AS CHARACTER EXTENT 20.
DEFINE VARIABLE wk_size_choF AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_size_ikaF AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_kizu_kbnF AS CHARACTER EXTENT 20.

DEFINE VARIABLE wk_rowsI AS INTEGER.
DEFINE VARIABLE wk_apI AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_sizeI AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_bad_cdI AS CHARACTER EXTENT 20.
DEFINE VARIABLE wk_chk_kbnI AS CHARACTER EXTENT 20.
DEFINE VARIABLE wk_size_choI AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_size_ikaI AS DECIMAL EXTENT 20.
DEFINE VARIABLE wk_kizu_kbnI AS CHARACTER EXTENT 20.


DEFINE VARIABLE wk_def_kazu_size1 AS DECIMAL.
DEFINE VARIABLE wk_def_kazu_size2 AS DECIMAL.
DEFINE VARIABLE wk_def_kazu_su1 AS DECIMAL.
DEFINE VARIABLE wk_def_kazu_su2 AS DECIMAL.
DEFINE VARIABLE wk_def_kazu_su3 AS DECIMAL.
DEFINE VARIABLE wk_def_kazu_su1_i AS DECIMAL.
DEFINE VARIABLE wk_def_kazu_su2_i AS DECIMAL.
DEFINE VARIABLE wk_def_kazu_su3_i AS DECIMAL.
DEFINE VARIABLE wk_def_len_sa AS DECIMAL.
DEFINE VARIABLE wk_def_iti_kei1 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_kei2 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_kei3 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_kei4 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_len1 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_len2 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_len3 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_len4 AS DECIMAL.
DEFINE VARIABLE wk_def_iti_len5 AS DECIMAL.
DEFINE VARIABLE wk_def_aida_kei AS DECIMAL.
DEFINE VARIABLE wk_def_aida_len1 AS DECIMAL.
DEFINE VARIABLE wk_def_aida_len2 AS DECIMAL.
DEFINE VARIABLE wk_def_chosei_size AS DECIMAL.
DEFINE VARIABLE wk_def_chosei_keisu AS DECIMAL.


DEFINE VARIABLE wk_def_len_min_kbn AS CHARACTER.
DEFINE VARIABLE wk_def_kazu_su_all AS DECIMAL.

DEFINE VARIABLE wk_x AS DECIMAL.
DEFINE VARIABLE wk_y AS DECIMAL.
DEFINE VARIABLE wk_z AS DECIMAL.
DEFINE VARIABLE wk_w AS DECIMAL.
DEFINE VARIABLE wk_Length AS DECIMAL.

DEFINE VARIABLE i AS INTEGER.




/* SS - 20120306.1 - B */
define temp-table tbadcd_tmp            no-undo
    field tbadcd_seq as character
    field tbadcd_mpdlabel   like mpd_label
    field tbadcd_mphrsult   like mph_rsult
    .
    
define temp-table tinspectclass_tmp     no-undo
    field tinspectclass_seq as character
    field tinspectclass_mpdlabel   like mpd_label
    field tinspectclass_mphrsult   like mph_rsult
    .

define temp-table tap_tmp               no-undo
    field tap_seq as character
    field tap_mpdlabel   like mpd_label
    field tap_mphrsult   like mph_rsult
    field tap_mpdtype    like mpd_type
    .

define temp-table tbadsize_tmp          no-undo
    field tbadsize_seq as character
    field tbadsize_mpdlabel   like mpd_label
    field tbadsize_mphrsult   like mph_rsult
    .
/* SS - 20120306.1 - E */




DEFINE VARIABLE w_count AS INTEGER.
DEFINE VARIABLE v_count AS INTEGER.

FUNCTION ceil RETURNS DECIMAL (val AS DECIMAL):
    IF TRUNCATE(val,0) < val THEN DO:
        RETURN (TRUNCATE(val,0) + 1).
    END.
    ELSE DO:
        RETURN TRUNCATE(val,0).
    END.
END.


 o_result = "ok".

 wk_seihin_kei_max = 0.
 wk_seihin_kei_min = 0.
 wk_seihin_len_max = 0.
 wk_seihin_len_min = 0.
 wk_def_kikaku_cd = "".


 wk_def_chk_kbn = "".
 wk_def_size_cho = 0 .
 wk_def_size_ika = 0.
 wk_def_kizu_kbn = "".
 wk_defect_io_kbn = "".

 wk_rowsF = 0.
 wk_rowsI = 0.

 DO i = 1 TO 20:
     wk_apF[i]  = 0.
     wk_sizeF[i] = 0.
     wk_bad_cdF[i] = "".
     wk_chk_kbnF[i] = "".
     wk_size_choF[i] = 0.
     wk_size_ikaF[i] = 0.
     wk_kizu_kbnF[i] = "".

     wk_apI[i] = 0.
     wk_sizeI[i] = 0.
     wk_bad_cdI[i] = "".
     wk_chk_kbnI[i] = "".
     wk_size_choI[i] = 0.
     wk_size_ikaI[i] = 0.
     wk_kizu_kbnI[i] = "".
 END.


 wk_def_kazu_size1 = 0.
 wk_def_kazu_size2 = 0.
 wk_def_kazu_su1 = 0.
 wk_def_kazu_su2 = 0.
 wk_def_kazu_su3 = 0.
 wk_def_kazu_su1_i = 0.
 wk_def_kazu_su2_i = 0.
 wk_def_kazu_su3_i = 0.
 wk_def_len_sa = 0.
 wk_def_iti_kei1 = 0.
 wk_def_iti_kei2 = 0.
 wk_def_iti_kei3 = 0.
 wk_def_iti_kei4 = 0.
 wk_def_iti_len1 = 0.
 wk_def_iti_len2 = 0.
 wk_def_iti_len3 = 0.
 wk_def_iti_len4 = 0.
 wk_def_iti_len5 = 0.
 wk_def_aida_kei = 0.
 wk_def_aida_len1 = 0.
 wk_def_aida_len2 = 0.
 wk_def_chosei_size = 0.
 wk_def_chosei_keisu = 0.


 wk_def_len_min_kbn = "".
 wk_def_kazu_su_all = 0.

 wk_x = 0.
 wk_y = 0.
 wk_z = 0.
 wk_Length = 0.


/*step1 读取品名规格 MasterA基础数据*/
/*
00013   DIA_MAX
00014   DIA_MIN
00011   LEN_MAX
00012   LEN_MIN
00037   CD_DEFECT_SPEC
*/

/*SS - 111222.1 B*/
/*末尾如有"-99"的话，就去除之。例如：JFLW8J-05时为JFLW8J*/
IF INDEX("-",SUBSTRING(i_part,LENGTH(i_part) - 3 + 1,1)) > 0
   AND INDEX("0123456789",SUBSTRING(i_part,LENGTH(i_part) - 2 + 1,1)) > 0
   AND INDEX("0123456789",SUBSTRING(i_part,LENGTH(i_part) - 1 + 1,1)) > 0
   THEN DO:
    i_part = SUBSTRING(i_part,1,LENGTH(i_part) - 3).
END.
/*SS - 111222.1 E*/



FOR EACH mpd_det WHERE mpd_domain = GLOBAL_domain AND mpd_nbr = "X7" + i_part
    AND (mpd_type = "00013" OR mpd_type = "00014" OR mpd_type = "00011"
         OR mpd_type = "00012" OR mpd_type = "00037")
    NO-LOCK:

    IF mpd_type = "00011" THEN DO:
       wk_seihin_len_max = DECIMAL(mpd_tol).
    END.
    IF mpd_type = "00012" THEN DO:
       wk_seihin_len_min = DECIMAL(mpd_tol).
    END.
    IF mpd_type = "00013" THEN DO:
       wk_seihin_kei_max = DECIMAL(mpd_tol).
    END.
    IF mpd_type = "00014" THEN DO:
       wk_seihin_kei_min = DECIMAL(mpd_tol).
    END.
    IF mpd_type = "00037" THEN DO:
       wk_def_kikaku_cd  = mpd_tol.
    END.

END.

/*step1 根据区分不同读取不同数据*/
/* SS - 20120305.1 - B */
IF i_kubun = "1" THEN DO:
    if i_type1 <> "" then do:
        {zzdefectikbn1.i
            i_type1
            i_ap1
            i_size1
        }
    end.

    if i_type2 <> "" then do:
        {zzdefectikbn1.i
            i_type2
            i_ap2
            i_size2
        }
    end.

    if i_type3 <> "" then do:
        {zzdefectikbn1.i
            i_type3
            i_ap3
            i_size3
        }
    end.

    if i_type4 <> "" then do:
        {zzdefectikbn1.i
            i_type4
            i_ap4
            i_size4
        }
    end.

    if i_type5 <> "" then do:
        {zzdefectikbn1.i
            i_type5
            i_ap5
            i_size5
        }
    end.

    if i_type6 <> "" then do:
        {zzdefectikbn1.i
            i_type6
            i_ap6
            i_size6
        }
    end.
END.
/* SS - 20120305.1 - E */
else IF i_kubun = "2" THEN DO:

    /* SS - 20120306.1 - B */
    empty temp-table tbadcd_tmp.
    empty temp-table tinspectclass_tmp.
    empty temp-table tap_tmp.
    empty temp-table tbadsize_tmp.
    /* empty temp-table t1_tmp. */

    for each qc_mstr
        no-lock
        /* use-index what ? */
        where qc_domain = global_domain
            and qc_serial = i_ovdlotno
        ,
    each mpd_det
        no-lock
        use-index mpd_nbr
        where mpd_domain = qc_domain
            and mpd_nbr = "INS_DEF"
            and substring(mpd_label, 5, 6) = "BAD_CD"
        ,
    each mph_hist
        no-lock
        use-index mph_lot
        where mph_domain = mpd_domain
            and mph_lot = qc_lot
            and mph_procedure = mpd_nbr
            and mph_test = mpd_label
    :
        create tbadcd_tmp.
        assign
            tbadcd_mpdlabel = mpd_label
            tbadcd_mphrsult = mph_rsult
            tbadcd_seq = substring(tbadcd_mpdlabel, 1, 4)
            .
    end.

    for each qc_mstr
        no-lock
        /* use-index what ? */
        where qc_domain = global_domain
            and qc_serial = i_ovdlotno
        ,
    each mpd_det
        no-lock
        use-index mpd_nbr
        where mpd_domain = qc_domain
            and mpd_nbr = "INS_DEF"
            and substring(mpd_label, 5, 13) = "INSPECT_CLASS"
        ,
    each mph_hist
        no-lock
        use-index mph_lot
        where mph_domain = mpd_domain
            and mph_lot = qc_lot
            and mph_procedure = mpd_nbr
            and mph_test = mpd_label
            and mph_rsult <> "1"
    :
        create tinspectclass_tmp.
        assign
            tinspectclass_mpdlabel = mpd_label
            tinspectclass_mphrsult = mph_rsult
            tinspectclass_seq = substring(tinspectclass_mpdlabel, 1, 4)
            .
    end.

    w_count = 0.
    for each tbadcd_tmp
        no-lock
        where can-find
            (first mpd_det
                no-lock
                where mpd_domain = global_domain
                    and substring(mpd_nbr, 1, 4) = "XC" + tbadcd_mphrsult
            )
        ,
    each tinspectclass_tmp
        no-lock
        where tinspectclass_seq = tbadcd_seq
    :
        /*
         * create t1_tmp.
         * assign
         *     t1_seq = tbadcd_seq
         *     t1_badcd_mpdlabel = tbadcd_mpdlabel
         *     t1_badcd_mphrsult = tbadcd_mphrsult
         *     t1_inspectclass_mpdlabel = tinspectclass_mpdlabel
         *     t1_inspectclass_mphrsult = tinspectclass_mphrsult
         *     .
         */
        
        w_count = w_count + 1.
    end.

    if w_count = 0 then do:
        o_result = "NG0_1".
        run convertResult(input o_result, output o_result).
        return.
    end.


    for each qc_mstr
        no-lock
        /* use-index what ? */
        where qc_domain = global_domain
            and qc_serial = i_ovdlotno
        ,
    each mpd_det
        no-lock
        use-index mpd_nbr
        where mpd_domain = qc_domain
            and mpd_nbr = "INS_DEF"
            and substring(mpd_label, 5, 2) = "AP"
        ,
    each mph_hist
        no-lock
        use-index mph_lot
        where mph_domain = mpd_domain
            and mph_lot = qc_lot
            and mph_procedure = mpd_nbr
            and mph_test = mpd_label
    :
        create tap_tmp.
        assign
            tap_mpdlabel = mpd_label
            tap_mphrsult = mph_rsult
            tap_seq = substring(tap_mpdlabel, 1, 4)
            tap_mpdtype = mpd_type
            .
    end.

    for each qc_mstr
        no-lock
        /* use-index what ? */
        where qc_domain = global_domain
            and qc_serial = i_ovdlotno
        ,
    each mpd_det
        no-lock
        use-index mpd_nbr
        where mpd_domain = qc_domain
            and mpd_nbr = "INS_DEF"
            and substring(mpd_label, 5, 8) = "BAD_SIZE"
        ,
    each mph_hist
        no-lock
        use-index mph_lot
        where mph_domain = mpd_domain
            and mph_lot = qc_lot
            and mph_procedure = mpd_nbr
            and mph_test = mpd_label
    :
        create tbadsize_tmp.
        assign
            tbadsize_mpdlabel = mpd_label
            tbadsize_mphrsult = mph_rsult
            tbadsize_seq = substring(tbadsize_mpdlabel, 1, 4)
            .
    end.


    /* loop1++ F array */
    for each tap_tmp
        no-lock
        ,
    each tbadsize_tmp
        no-lock
        where tbadsize_seq = tap_seq
        ,
    each tbadcd_tmp
        no-lock
        where tbadcd_seq = tap_seq
            and can-find
                (first mpd_det
                    no-lock
                    where mpd_domain = global_domain
                        and mpd_label = 'DEFECT_IN_OUT'
                        and mpd_tol = "1"
                        and substring(mpd_nbr, 1, 4) = "XC" + tbadcd_mphrsult
                )
        ,
    each tinspectclass_tmp
        no-lock
        where tinspectclass_seq = tap_seq
        break
        by tap_mpdtype
    :
        assign
            wk_rowsF = wk_rowsF + 1
            wk_apF[wk_rowsF] = decimal(tap_mphrsult)
            wk_sizeF[wk_rowsF] = decimal(tbadsize_mphrsult)
            wk_bad_cdF[wk_rowsF] = tbadcd_mphrsult
            no-error
            .

        if wk_def_kikaku_cd = "" then do:
            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "UNDER_TYPE"
            :
            end.
            if available(mpd_det) then do:
                wk_def_chk_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG13_1".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "DEFECT_SIZE_OVER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_cho = decimal(mpd_tol) no-error.
                /* if wk_def_size_cho = 0 then wk_def_size_cho = 1. */   /* need this statement ???? */
            end.
            else do:
                o_result = "NG13_2".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "DEFECT_SIZE_UNDER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_ika = decimal(mpd_tol) no-error.
            end.
            else do:
                o_result = "NG13_3".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "SCRATCH"
            :
            end.
            if available(mpd_det) then do:
                wk_def_kizu_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG13_4".
                run convertResult(input o_result, output o_result).
                return.
            end.
        end.
        else do:
            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "UNDER_TYPE"
            :
            end.
            if available(mpd_det) then do:
                wk_def_chk_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG14_1".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "DEFECT_SIZE_OVER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_cho = decimal(mpd_tol) no-error.
                /* if wk_def_size_cho = 0 then wk_def_size_cho = 1. */   /* need this statement ???? */
            end.
            else do:
                o_result = "NG14_2".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "DEFECT_SIZE_UNDER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_ika = decimal(mpd_tol) no-error.
            end.
            else do:
                o_result = "NG14_3".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdF[wk_rowsF]
                    and mpd_label = "SCRACH"
            :
            end.
            if available(mpd_det) then do:
                wk_def_kizu_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG14_4".
                run convertResult(input o_result, output o_result).
                return.
            end.
        end.

        assign
            wk_chk_kbnF[wk_rowsF]  =  wk_def_chk_kbn
            wk_size_choF[wk_rowsF] =  wk_def_size_cho
            wk_size_ikaF[wk_rowsF] =  wk_def_size_ika
            wk_kizu_kbnF[wk_rowsF] =  wk_def_kizu_kbn
            .
    end.
    /* loop1-- F array */


    /* loop2++ I array */
    for each tap_tmp
        no-lock
        ,
    each tbadsize_tmp
        no-lock
        where tbadsize_seq = tap_seq
        ,
    each tbadcd_tmp
        no-lock
        where tbadcd_seq = tap_seq
            and can-find
                (first mpd_det
                    no-lock
                    where mpd_domain = global_domain
                        and mpd_label = 'DEFECT_IN_OUT'
                        and mpd_tol <> "1"
                        and substring(mpd_nbr, 1, 4) = "XC" + tbadcd_mphrsult
                )
        ,
    each tinspectclass_tmp
        no-lock
        where tinspectclass_seq = tap_seq
        break
        by tap_mpdtype
    :
        assign
            wk_rowsI = wk_rowsI + 1
            wk_apI[wk_rowsI] = decimal(tap_mphrsult)
            wk_sizeI[wk_rowsI] = decimal(tbadsize_mphrsult)
            wk_bad_cdI[wk_rowsI] = tbadcd_mphrsult
            no-error
            .

        if wk_def_kikaku_cd = "" then do:
            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "UNDER_TYPE"
            :
            end.
            if available(mpd_det) then do:
                wk_def_chk_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG15_1".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "DEFECT_SIZE_OVER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_cho = decimal(mpd_tol) no-error.
                /* if wk_def_size_cho = 0 then wk_def_size_cho = 1. */   /* need this statement ???? */
            end.
            else do:
                o_result = "NG15_2".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "DEFECT_SIZE_UNDER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_ika = decimal(mpd_tol) no-error.
            end.
            else do:
                o_result = "NG15_3".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XC" + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "SCRATCH"
            :
            end.
            if available(mpd_det) then do:
                wk_def_kizu_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG15_4".
                run convertResult(input o_result, output o_result).
                return.
            end.
        end.
        else do:
            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "UNDER_TYPE"
            :
            end.
            if available(mpd_det) then do:
                wk_def_chk_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG16_1".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "DEFECT_SIZE_OVER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_cho = decimal(mpd_tol) no-error.
                /* if wk_def_size_cho = 0 then wk_def_size_cho = 1. */   /* need this statement ???? */
            end.
            else do:
                o_result = "NG16_2".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "DEFECT_SIZE_UNDER"
            :
            end.
            if available(mpd_det) then do:
                wk_def_size_ika = decimal(mpd_tol) no-error.
            end.
            else do:
                o_result = "NG16_3".
                run convertResult(input o_result, output o_result).
                return.
            end.

            for first mpd_det
                no-lock
                use-index mpd_nbr
                where mpd_domain = global_domain
                    and mpd_nbr = "XR" + wk_def_kikaku_cd + wk_bad_cdI[wk_rowsI]
                    and mpd_label = "SCRACH"
            :
            end.
            if available(mpd_det) then do:
                wk_def_kizu_kbn = mpd_tol.
            end.
            else do:
                o_result = "NG16_4".
                run convertResult(input o_result, output o_result).
                return.
            end.
        end.

        assign
            wk_chk_kbnI[wk_rowsI]  =  wk_def_chk_kbn
            wk_size_choI[wk_rowsI] =  wk_def_size_cho
            wk_size_ikaI[wk_rowsI] =  wk_def_size_ika
            wk_kizu_kbnI[wk_rowsI] =  wk_def_kizu_kbn
            .
    end.
    /* loop2-- I array */
    /* SS - 20120306.1 - E */

END. /*IF i_kubun = "2" THEN DO:*/
/* SS - 20120219.1 - B
IF i_kubun <> "1" OR i_kubun <> "2" THEN DO:
SS - 20120219.1 - E */
/* SS - 20120219.1 - B */
else DO:
/* SS - 20120219.1 - E */
   /* SS - 20120219.1 - B
   o_result = "NG".
   SS - 20120219.1 - E */
   /* SS - 20120219.1 - B */
   o_result = "NG0_2".
   run convertResult(input o_result, output o_result).
   /* SS - 20120219.1 - E */
   RETURN.
END.

IF wk_def_kikaku_cd = "" THEN DO:
    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_DIA_NUM1' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_size1 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_DIA_NUM2' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_size2 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_NUM_SURFACE1' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_su1 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_NUM_SURFACE2' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_su2 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_NUM_SURFACE3' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_su3 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_NUM_INTERNAL1' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_su1_i = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_NUM_INTERNAL2' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_su2_i = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_NUM_INTERNAL3' no-lock no-error.
    if avail code_mstr then do:
       wk_def_kazu_su3_i = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_LEN_ADJUST' no-lock no-error.
    if avail code_mstr then do:
       wk_def_len_sa = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_DIA_POS1' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_kei1 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_DIA_POS2' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_kei2 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_DIA_POS3' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_kei3 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_DIA_POS4' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_kei4 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_RANGE_POS1' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_len1 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_RANGE_POS2' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_len2 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_RANGE_POS3' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_len3 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_RANGE_POS4' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_len4 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_RANGE_POS5' no-lock no-error.
    if avail code_mstr then do:
       wk_def_iti_len5 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_DIA_INTERVAL' no-lock no-error.
    if avail code_mstr then do:
       wk_def_aida_kei = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_INTERVAL1' no-lock no-error.
    if avail code_mstr then do:
       wk_def_aida_len1 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_INTERVAL2' no-lock no-error.
    if avail code_mstr then do:
       wk_def_aida_len2 = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_PARA_B' no-lock no-error.
    if avail code_mstr then do:
       wk_def_chosei_size = decimal(code_cmmt).
    end.

    find first code_mstr where code_domain = global_domain and code_fldname = 'ZZ_DEF_PARA_A' no-lock no-error.
    if avail code_mstr then do:
       wk_def_chosei_keisu = decimal(code_cmmt).
    end.
    
    
    /* SS - 20120306.1 - B */
    wk_def_len_min_kbn = "1".
    /* SS - 20120306.1 - E */
END.
ELSE DO:
    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00001" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_size1 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00002" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_size2 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00003" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_su1 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00004" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_su2 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00005" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_su3 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00006" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_su1_i = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00007" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_su2_i = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00008" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_su3_i = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00009" no-lock no-error.
    if avail mpd_det then do:
       wk_def_len_sa = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00010" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_kei1 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00011" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_kei2 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00012" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_kei3 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00013" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_kei4 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00014" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_len1 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00015" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_len2 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00016" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_len3 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00017" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_len4 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00018" no-lock no-error.
    if avail mpd_det then do:
       wk_def_iti_len5 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00019" no-lock no-error.
    if avail mpd_det then do:
       wk_def_aida_kei = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00020" no-lock no-error.
    if avail mpd_det then do:
       wk_def_aida_len1 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00021" no-lock no-error.
    if avail mpd_det then do:
       wk_def_aida_len2 = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00022" no-lock no-error.
    if avail mpd_det then do:
       wk_def_chosei_size = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00023" no-lock no-error.
    if avail mpd_det then do:
       wk_def_chosei_keisu = decimal(mpd_tol).
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00024" no-lock no-error.
    if avail mpd_det then do:
       wk_def_len_min_kbn = mpd_tol.
    end.

    find first mpd_det where mpd_domain = global_domain and mpd_nbr = "XQ" + wk_def_kikaku_cd and mpd_type = "00025" no-lock no-error.
    if avail mpd_det then do:
       wk_def_kazu_su_all = decimal(mpd_tol).
    end.
END.

/*Defect数量的检查 1表面+内部*/

IF wk_def_kazu_su_all <> 0  THEN DO:
    IF wk_def_kazu_su_all < wk_rowsF + wk_rowsI THEN DO:
        /* SS - 20120219.1 - B
        o_result = "NG".
        SS - 20120219.1 - E */
        /* SS - 20120219.1 - B */
        o_result = "NG0_3".
        run convertResult(input o_result, output o_result).
        /* SS - 20120219.1 - E */
        RETURN.
    END.
END.
ELSE DO:
    IF (wk_seihin_kei_max + wk_seihin_kei_min) / 2  <  wk_def_kazu_size1 THEN DO:
        IF wk_def_kazu_su1 < wk_rowsF THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG1_1".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.

    IF wk_def_kazu_size1 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 
        and (wk_seihin_kei_max + wk_seihin_kei_min) / 2  < wk_def_kazu_size2
    THEN DO:
        IF wk_def_kazu_su2 < wk_rowsF THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG1_2".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.

    IF wk_def_kazu_size2 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 THEN DO:
        IF wk_def_kazu_su3 < wk_rowsF THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG1_3".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.

    /*SS - 111222.1 B*/
    /*
    IF (wk_seihin_kei_max + wk_seihin_kei_min) / 2  <  wk_def_kazu_size1 THEN DO:
        IF wk_def_kazu_su1_i < wk_rowsI THEN DO:
            o_result = "NG".
            RETURN.
        END.
    END.

    IF (wk_def_kazu_size1 <= ((wk_seihin_kei_max + wk_seihin_kei_min) / 2) ) AND ((wk_seihin_kei_max + wk_seihin_kei_min) / 2 < wk_def_kazu_size2) THEN DO:
        IF wk_def_kazu_su2_i < wk_rowsI THEN DO:

            o_result = "NG".
            RETURN.
        END.
    END.

    IF wk_def_kazu_size2 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 THEN DO:
        IF wk_def_kazu_su3_i < wk_rowsI THEN DO:

            o_result = "NG".
            RETURN.
        END.
    END.

    DO v_count = 1 TO wk_rowsI:
        IF wk_chk_kbnI[v_count] = '1' THEN DO:
            IF (wk_size_choI[v_count] >= wk_sizeI[v_count]) OR (wk_sizeI[v_count] > wk_size_ikaI[v_count]) THEN DO:

                o_result = "NG".
                RETURN.
            END.
        END.

        IF wk_chk_kbnI[v_count] = '2' THEN DO:
            IF wk_sizeI[v_count] > wk_size_ikaI[v_count] THEN DO:
                o_result = "NG".
                RETURN.
            END.
        END.
    END.


    DO v_count = 1 TO wk_rowsF:
        IF wk_chk_kbnF[v_count] = '1' THEN DO:
            IF (wk_size_choF[v_count] >= wk_sizeF[v_count]) OR (wk_sizeF[v_count] > wk_size_ikaF[v_count]) THEN DO:

                o_result = "NG".
                RETURN.
            END.
        END.

        IF wk_chk_kbnF[v_count] = '2' THEN DO:
            IF wk_sizeF[v_count] > wk_size_ikaF[v_count] THEN DO:
                o_result = "NG".
                RETURN.
            END.
        END.
    END.
    */
    /*SS - 111222.1 E*/

/*SS - 111222.1 B*/
/*End if -对应2.2的最开始的if文*/
/*
END.
*/
/*SS - 111222.1 E*/

    /*Defect数量的检查 2 内部*/
    /*
     * ss_20120306
     * so confused!!!
     * colleague, please align your code. what's your logic, structure.
     */
    IF (wk_seihin_kei_max + wk_seihin_kei_min) / 2  <  wk_def_kazu_size1 THEN DO:
        IF wk_def_kazu_su1_i < wk_rowsI THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG2_1".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    end.

    IF (wk_def_kazu_size1 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2) AND (((wk_seihin_kei_max + wk_seihin_kei_min) / 2) < wk_def_kazu_size2) THEN DO:
       IF wk_def_kazu_su2_i < wk_rowsI THEN DO:
           /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG2_2".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
           RETURN.
       END.
    END.

    IF wk_def_kazu_size2 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 THEN DO:
        IF wk_def_kazu_su3_i < wk_rowsI THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG2_3".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.

/*SS - 111222.1 B*/
/*End if -对应2.2的最开始的if文*/
END.
/*SS - 111222.1 E*/

/*Defect数据的检查*/
DO v_count = 1 TO wk_rowsI:
    IF wk_chk_kbnI[v_count] = '1' THEN DO:
        IF (wk_size_choI[v_count] >= wk_sizeI[v_count]) OR (wk_sizeI[v_count] > wk_size_ikaI[v_count]) THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG3_1".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.

    IF wk_chk_kbnI[v_count] = '2' THEN DO:
        IF wk_sizeI[v_count] > wk_size_ikaI[v_count] THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG3_2".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.
END.

DO v_count = 1 TO wk_rowsF:
    IF wk_chk_kbnF[v_count] = '1' THEN DO:
        IF (wk_size_choF[v_count] >= wk_sizeF[v_count]) OR (wk_sizeF[v_count] > wk_size_ikaF[v_count]) THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG4_1".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.

    IF wk_chk_kbnF[v_count] = '2' THEN DO:
        IF wk_sizeF[v_count] > wk_size_ikaF[v_count] THEN DO:
            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG4_2".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
            RETURN.
        END.
    END.
END.

/*Defect长度的检查*/
wk_length = i_length.
IF wk_def_len_min_kbn = '1' THEN DO:
    wk_x = 1.0 * (wk_seihin_len_max + wk_seihin_len_min) / 2.0.
    wk_y = (wk_seihin_len_max - wk_def_len_sa).
    wk_z = min(wk_x, wk_y).
    IF wk_z < wk_seihin_len_min THEN DO:
        wk_z = wk_seihin_len_min.
    END.

    if wk_length < wk_z THEN DO:
        /* SS - 20120219.1 - B
        o_result = "NG".
        SS - 20120219.1 - E */
        /* SS - 20120219.1 - B */
        o_result = "NG5".
        run convertResult(input o_result, output o_result).
        /* SS - 20120219.1 - E */
        RETURN.
    END.
END.

/*Defect位置的检查*/
DO v_count = 1 TO wk_rowsI:
    /* SS - 20120307.1 - B
    IF wk_chk_kbnI[v_count] = '1' THEN DO:
    SS - 20120307.1 - E */
    /* SS - 20120307.1 - B */
    IF wk_kizu_kbnI[v_count] <> '1' THEN DO:
    /* SS - 20120307.1 - E */
        wk_w = wk_w + CEIL(wk_sizeI[v_count]).
    END.
END.

DO v_count = 1 TO wk_rowsF:
    IF wk_kizu_kbnF[v_count] <> '1' THEN DO:
        wk_w = wk_w + CEIL(wk_sizeF[v_count]).
    END.
END.

wk_w = wk_Length + ((wk_rowsF + wk_rowsI) * wk_def_chosei_size) + (wk_def_chosei_keisu * wk_w).

IF (wk_seihin_kei_max + wk_seihin_kei_min) / 2 < wk_def_iti_kei1 THEN DO:
   DO v_count = 1 TO wk_rowsI:
       IF wk_kizu_kbnI[v_count] <> '1' THEN DO:
           IF ((wk_w - wk_def_iti_len1) < wk_apI[v_count]) OR (wk_apI[v_count] < wk_def_iti_len1) THEN DO:
               /* SS - 20120219.1 - B
               o_result = "NG".
               SS - 20120219.1 - E */
               /* SS - 20120219.1 - B */
               o_result = "NG6_1".
               run convertResult(input o_result, output o_result).
               /* SS - 20120219.1 - E */
               RETURN.
           END.
       END.
   END.

   DO v_count = 1 TO wk_rowsF:
       IF wk_kizu_kbnF[v_count] <> '1' THEN DO:
           IF ((wk_w - wk_def_iti_len1) < wk_apF[v_count]) OR (wk_apF[v_count] < wk_def_iti_len1) THEN DO:
               /* SS - 20120219.1 - B
               o_result = "NG".
               SS - 20120219.1 - E */
               /* SS - 20120219.1 - B */
               o_result = "NG6_2".
               run convertResult(input o_result, output o_result).
               /* SS - 20120219.1 - E */
               RETURN.
           END.
       END.
   END.
END.

IF (wk_def_iti_kei1 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2) AND ((wk_seihin_kei_max + wk_seihin_kei_min) / 2 < wk_def_iti_kei2) THEN DO:
    DO v_count = 1 TO wk_rowsI:
       IF wk_kizu_kbnI[v_count] <> '1' THEN DO:
           IF ((wk_w - wk_def_iti_len2) < wk_apI[v_count]) OR (wk_apI[v_count] < wk_def_iti_len2) THEN DO:
               /* SS - 20120219.1 - B
               o_result = "NG".
               SS - 20120219.1 - E */
               /* SS - 20120219.1 - B */
               o_result = "NG7_1".
               run convertResult(input o_result, output o_result).
               /* SS - 20120219.1 - E */
               RETURN.
           END.
       END.
    END.


    DO v_count = 1 TO wk_rowsF:
       IF wk_kizu_kbnF[v_count] <> '1' THEN DO:
           IF ((wk_w - wk_def_iti_len2) < wk_apF[v_count]) OR (wk_apF[v_count] < wk_def_iti_len2) THEN DO:
               /* SS - 20120219.1 - B
               o_result = "NG".
               SS - 20120219.1 - E */
               /* SS - 20120219.1 - B */
               o_result = "NG7_2".
               run convertResult(input o_result, output o_result).
               /* SS - 20120219.1 - E */
               RETURN.
           END.
       END.
    END.
END.

IF wk_def_iti_kei2 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 AND (wk_seihin_kei_max + wk_seihin_kei_min) / 2 < wk_def_iti_kei3 THEN DO:
    DO v_count = 1 TO wk_rowsI:
        IF wk_kizu_kbnI[v_count] <> '1' THEN DO:
            IF ((wk_w - wk_def_iti_len3) < wk_apI[v_count]) OR (wk_apI[v_count] < wk_def_iti_len3) THEN DO:
                /* SS - 20120219.1 - B
                o_result = "NG".
                SS - 20120219.1 - E */
                /* SS - 20120219.1 - B */
                o_result = "NG8_1".
                run convertResult(input o_result, output o_result).
                /* SS - 20120219.1 - E */
                RETURN.
            END.
        END.
    END.

    DO v_count = 1 TO wk_rowsF:
        IF wk_kizu_kbnF[v_count] <> '1' THEN DO:
            IF ((wk_w - wk_def_iti_len3) < wk_apF[v_count]) OR (wk_apF[v_count] < wk_def_iti_len3) THEN DO:
                /* SS - 20120219.1 - B
                o_result = "NG".
                SS - 20120219.1 - E */
                /* SS - 20120219.1 - B */
                o_result = "NG8_2".
                run convertResult(input o_result, output o_result).
                /* SS - 20120219.1 - E */
                RETURN.
            END.
        END.
    END.

END.

IF wk_def_iti_kei3 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 AND (wk_seihin_kei_max + wk_seihin_kei_min) / 2 < wk_def_iti_kei4 THEN DO:
    DO v_count = 1 TO wk_rowsI:
        IF wk_kizu_kbnI[v_count] <> '1' THEN DO:
            IF (wk_w - wk_def_iti_len4) < wk_apI[v_count] OR wk_apI[v_count] < wk_def_iti_len4 THEN DO:
                /* SS - 20120219.1 - B
                o_result = "NG".
                SS - 20120219.1 - E */
                /* SS - 20120219.1 - B */
                o_result = "NG9_1".
                run convertResult(input o_result, output o_result).
                /* SS - 20120219.1 - E */
                RETURN.
            END.
        END.
    END.

    DO v_count = 1 TO wk_rowsF:
        IF wk_kizu_kbnF[v_count] <> '1' THEN DO:
            IF (wk_w - wk_def_iti_len4) < wk_apF[v_count] OR wk_apF[v_count] < wk_def_iti_len4 THEN DO:
                /* SS - 20120219.1 - B
                o_result = "NG".
                SS - 20120219.1 - E */
                /* SS - 20120219.1 - B */
                o_result = "NG9_2".
                run convertResult(input o_result, output o_result).
                /* SS - 20120219.1 - E */
                RETURN.
            END.
        END.
    END.

END.

IF wk_def_iti_kei4 <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 THEN DO:
    DO v_count = 1 TO wk_rowsI:
       IF wk_kizu_kbnI[v_count] <> '1' THEN DO:
           IF ((wk_w - wk_def_iti_len5) < wk_apI[v_count]) OR (wk_apI[v_count] < wk_def_iti_len5) THEN DO:

              /* SS - 20120219.1 - B
              o_result = "NG".
              SS - 20120219.1 - E */
              /* SS - 20120219.1 - B */
              o_result = "NG10_1".
              run convertResult(input o_result, output o_result).
              /* SS - 20120219.1 - E */
               RETURN.
           END.
       END.
    END.

    DO v_count = 1 TO wk_rowsF:
       IF wk_kizu_kbnF[v_count] <> '1' THEN DO:
           IF ((wk_w - wk_def_iti_len5) < wk_apF[v_count]) OR (wk_apF[v_count] < wk_def_iti_len5) THEN DO:
              /* SS - 20120219.1 - B
              o_result = "NG".
              SS - 20120219.1 - E */
              /* SS - 20120219.1 - B */
              o_result = "NG10_2".
              run convertResult(input o_result, output o_result).
              /* SS - 20120219.1 - E */
               RETURN.
           END.
       END.
    END.

END.

/*Defect间隔的检查*/
IF (wk_seihin_kei_max + wk_seihin_kei_min) / 2 < wk_def_aida_kei  THEN DO:
    IF wk_rowsI > 1 THEN DO:
        IF ABS(wk_apI[2] - wk_apI[1]) < wk_def_aida_len1 THEN DO:

            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG11_1".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
             RETURN.
        END.
    END.

    IF wk_rowsI > 2 THEN DO:
        IF ABS(wk_apI[3] - wk_apI[2]) < wk_def_aida_len1 THEN DO:

            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG11_2".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
             RETURN.
        END.
    END.
END.

IF wk_def_aida_kei <= (wk_seihin_kei_max + wk_seihin_kei_min) / 2 THEN DO:
    IF wk_rowsI > 1 THEN DO:
        IF ABS(wk_apI[2] - wk_apI[1]) < wk_def_aida_len2 THEN DO:

            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG12_1".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
             RETURN.
        END.
    END.

    IF wk_rowsI > 2 THEN DO:
        IF ABS(wk_apI[3] - wk_apI[2]) < wk_def_aida_len2 THEN DO:

            /* SS - 20120219.1 - B
            o_result = "NG".
            SS - 20120219.1 - E */
            /* SS - 20120219.1 - B */
            o_result = "NG12_2".
            run convertResult(input o_result, output o_result).
            /* SS - 20120219.1 - E */
             RETURN.
        END.
    END.

END.





/* SS - 20120219.1 - B */
procedure convertResult:
    define input parameter i_sCode as character no-undo.
    define output parameter o_sMsg as character no-undo.

    o_sMsg = i_sCode.

    find first code_mstr no-lock
        where code_domain = global_domain
            and code_fldname = "shinetsu_defect_ng_message"
            and code_value = i_sCode
        no-error.
    if available(code_mstr) then
        o_sMsg = code_cmmt.
end procedure.
/* SS - 20120219.1 - E */





