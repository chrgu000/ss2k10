{mfdtitle.i}
{bcdeclre.i NEW }
{bcini.i}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "".

DEFINE BUTTON btn_trs LABEL "移库".
DEFINE button btn_quit LABEL "退出".


DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_site1 AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "库位". 

/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE VARIABLE active AS LOGICAL.
DEFINE VARIABLE succeed AS LOGICAL.

DEFINE VARIABLE bcpart LIKE b_co_part.
DEFINE VARIABLE bcqty LIKE b_co_qty_cur.
DEFINE VARIABLE bclot LIKE b_co_lot.
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE VARIABLE locstatus LIKE loc_status.
DEFINE VARIABLE locstatus1 LIKE loc_status.


DEF FRAME a
    SKIP(.5)
    "条码:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3)
    bcpart LABEL "零件号" COLON 8 SKIP(.3) 
    bcqty  LABEL "数量" COLON 8 SKIP(.3)
    bclot  LABEL "批号" COLON 8 SKIP(.3)
    bc_site COLON 8 SKIP(.3)
    bc_loc COLON 8 SKIP(.3)
    bc_site1 COLON 8 SKIP(.3)
    bc_loc1 COLON 8 SKIP(.3)
    SKIP(1.5)
    SPACE(24)  btn_trs
    WITH  WIDTH 30 TITLE "移库操作"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'value-changed':U OF bccode 
DO:
    ASSIGN bccode.
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT bcqty,
                                          OUTPUT bc_site,
                                          OUTPUT bc_loc,
                                          OUTPUT bclot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart  bcqty bclot bc_site bc_loc WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty "" @ bclot WITH FRAME a.
        STATUS INPUT "无法识别该条码".
        RETURN.
    END.

    bc_site1 = bc_site.
    DISP bc_site1 WITH FRAME a.
    /*
    FIND FIRST ld_det NO-LOCK WHERE ld_part = bcpart AND ld_lot = bclot NO-ERROR.
    IF AVAILABLE ld_det THEN DO:
        DISP ld_site @ bc_site ld_loc @ bc_loc WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bc_site "" @ bc_loc WITH FRAME a.
        STATUS INPUT "该条码没有库存,可能未入库".
    END.
    */
    RETURN.
END.

ON 'choose':U OF btn_trs
DO:
    ASSIGN bccode
        bcpart
        bcqty
        bclot
        bc_site
        bc_loc
        bc_site1
        bc_loc1.
    IF bc_site = "" OR bc_loc = ""  THEN DO:
        MESSAGE "该条码库位信息空，不能执行,现在退出".
        RETURN.
    END.
    IF bc_site1 = "" OR bc_loc1 = ""  THEN DO:
        MESSAGE "未指定目的地点、库位，不能执行,现在退出".
        RETURN.
    END.

    FOR FIRST loc_mstr WHERE loc_loc = bc_loc: END.
    locstatus = loc_status.
    FOR FIRST loc_mstr WHERE loc_loc = bc_loc1: END.
    locstatus1 = loc_status.

    IF locstatus = "" OR locstatus1 = "" THEN DO:
        MESSAGE "库位的库存状态代码有问题,退出".
        RETURN.
    END.
    
  mainloop:
  DO ON ERROR UNDO, LEAVE:
    {bcco001.i bccode bcpart bcqty bc_site1 bc_loc1 bclot """"}


    {gprun.i ""mgwrbf.p"" "(INPUT """",
                                         INPUT """",
                                         INPUT bccode,
                                         INPUT bcpart,
                                         INPUT bclot,
                                         INPUT """",
                                         INPUT bcqty,
                                         INPUT """",
                                         INPUT TODAY,
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT bc_loc,
                                         INPUT bc_site,
                                         INPUT ""iclotr04.p"",
                                         INPUT bc_site1,
                                         INPUT bc_loc1,
                                         INPUT bclot,
                                         INPUT """",
                                         INPUT YES,
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         OUTPUT bfid)"}
          /*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
          /*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
          /*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
          /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   
           {gprun.i ""mgwrfl.p"" "(input ""iclotr04.p"", input bfid)"}
           {gprun.i ""mgecim06.p"" "(input bfid, output succeed)"} 

        IF bc_loc1 = "S001A" THEN DO: 
            {bcco002.i ""FINI-GOOD""}
        END.
        ELSE DO:
            {bcco002.i ""MAT-STOCK""}
        END.

        IF succeed = TRUE THEN STATUS INPUT "完成".
        ELSE DO:
            STATUS INPUT "出现问题,请查原因".
            UNDO, LEAVE mainloop.
        END.
  END. /*do*/
         


    RETURN.
END.


REPEAT:
    UPDATE bccode  bc_site1 bc_loc1 btn_trs WITH FRAME a.
END.
/*
ENABLE bccode  bc_site1 bc_loc1 btn_trs btn_quit WITH FRAME a.
 {bctrail.i}
*/
