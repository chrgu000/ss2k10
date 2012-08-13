/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{gldydef.i new}
{mfdtitle.i "1+ "}

define variable entity            like gltr_entity no-undo.
define variable entity1           like gltr_entity no-undo.
define variable ref               like glt_ref     no-undo.
define variable ref1              like glt_ref     no-undo.
define variable doc               like glt_doc     no-undo.
define variable doc1              like glt_doc     no-undo.
define variable dt                like glt_date    no-undo.
define variable dt1               like glt_date    no-undo.
define variable effdt             like glt_effdate no-undo.
define variable effdt1            like glt_effdate no-undo.
define variable btch              like glt_batch   no-undo.
define variable type              like glt_tr_type no-undo.
define variable per               as integer       no-undo.

define variable amt               like glt_amt     no-undo.
define variable account           as character format "x(22)"
                                  label "Account"  no-undo.
define variable glname            like en_name     no-undo.

define variable exrate            like glt_en_exrate. 
define variable dr_pg_amt         as decimal initial 0.
define variable cr_pg_amt         as decimal initial 0.
define variable dr_tot_amt        as decimal initial 0.
define variable cr_tot_amt        as decimal initial 0.

define variable ipage             as integer.
define variable pages             as integer.
define variable irow              as integer.
define variable rows              as integer.

define variable s_acc             as character.
define variable s_accdesc         as character.
define variable s_ccdesc          as character.
define variable i                 as integer.
define variable j                 as integer.
define variable srmb              as character.

define temp-table tt
    field tt_idx as integer
    field tt_desc like glt_desc
    field tt_acct like glt_acct
    field tt_sub like glt_sub
    field tt_cc like glt_cc
    field tt_curr like glt_curr
    field tt_amt like glt_amt
    field tt_curr_amt like glt_curr_amt                 /*外币金额*/
    field tt_exrate like glt_en_exrate
    field tt_exrate2 like glt_en_exrate2                /*外币兑换率*/
    .    

function RMBChange return character (input pDec as decimal).

    define var str as character extent 10.
    str[1] = "壹".
    str[2] = "贰".
    str[3] = "叁".
    str[4] = "肆".
    str[5] = "伍".
    str[6] = "陆".
    str[7] = "柒".
    str[8] = "捌".
    str[9] = "玖".
    str[10] = "零".

    define var str1 as character extent 11.
    str1[1] = "分".
    str1[2] = "角".
    str1[3] = "元".
    str1[4] = "拾".
    str1[5] = "佰".
    str1[6] = "仟".
    str1[7] = "万".
    str1[8] = "拾".
    str1[9] = "佰".
    str1[10] = "仟".
    str1[11] = "亿".
    
    define var stmp as character format "x(15)".
    define var i as integer.
    define var l as integer.    /*lngth*/
    define var s as character.
    define var r        as character format "x(10)".
    define var ret      as character format "x(50)".

    stmp = string(pDec, ">>>>>>>>9.99").
    stmp = replace(stmp, ".", "").
    l = length(stmp).
    
    /*disp stmp.*/
    do i = 0 to l - 1:
        s = substring(stmp, l - i, 1).
        if s = "" then do: end.
        else do:
            if int(s) = 0 then 
                r = str[10].
            else 
                r = str[int(s)].
            ret = r + str1[i + 1] + ret.
        end.
    end.
    
    return ret.
end function.


/*GET NAME OF CURRENT ENTITY*/
find en_mstr where en_entity = current_entity no-lock no-error.
if not available en_mstr then do:
   /* NO PRIMARY ENTITY DEFINED */
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3}
   if c-application-mode <> 'web' then
      pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.
assign
   entity  = current_entity
   entity1 = entity.

assign per = 20.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   entity   colon 25 label "会计单位"
   entity1  colon 50 label {t001.i}
   ref      colon 25 label "总帐参考号"   
   ref1     colon 50 label {t001.i}
   doc      colon 25 label "凭证号"   
   doc1     colon 50 label {t001.i}
   dt       colon 25 label "录入日期"
   dt1      colon 50 label {t001.i}
   effdt    colon 25 label "生效日期"
   effdt1   colon 50 label {t001.i}
   btch     colon 25 label "批处理"
   per      colon 25 label "每页打印行数"
   /*type     colon 25 label "事务类型"*/
SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80
    NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = "已过帐凭证打印".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
/*setFrameLabels(frame a:handle).*/

/*type = "JL".*/

{wbrp01.i}

/*GUI*/ {mfguirpa.i true "window" 132 " " " " " "  }


/*GUI*/ procedure p-enable-ui:

   if entity1 = hi_char then entity1 = "".
   if ref1 = hi_char then ref1 = "".
   if doc1 = hi_char then doc1 = "".
   if dt =  low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.

   if c-application-mode <> 'web' then
      run p-action-fields (input "display").
   run p-action-fields (input "enable").
end procedure. /*p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

   {wbrp06.i &command = update &fields = "   entity entity1 ref ref1 doc doc1 
       dt dt1 effdt effdt1 btch per " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      /*CREATE BATCH INPUT STRING*/
      bcdparm = "".
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i ref     }
      {mfquoter.i ref1    }
      {mfquoter.i doc     }
      {mfquoter.i doc1    }
      {mfquoter.i dt      }
      {mfquoter.i dt1     }
      {mfquoter.i effdt   }
      {mfquoter.i effdt1  }
      {mfquoter.i btch    }
      {mfquoter.i per     }
      /*{mfquoter.i type    }*/

      if entity1 = "" then entity1 = hi_char.
      if ref1 = "" then ref1 = hi_char.
      if doc1 = "" then doc1 = hi_char.
      if dt = ?  then dt = low_date.
      if dt1 = ? then dt1 = hi_date.
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.

   end.
   
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

find en_mstr where en_entity = current_entity no-lock no-error.


   for each gltr_hist where
      gltr_entity >= entity and gltr_entity <= entity1 and
      gltr_ref >= ref and gltr_ref <= ref1 and
      gltr_doc >= doc and gltr_doc <= doc1 and
      gltr_ent_dt >= dt and gltr_ent_dt <= dt1 and
      gltr_eff_dt >= effdt and gltr_eff_dt <= effdt1 and
      (gltr_batch = btch or btch = "")
      no-lock use-index gltr_ref break by gltr_ref
      with width 132 no-attr-space frame f-a no-box:

      if first-of(gltr_ref) then do:
          rows = 0.
          dr_tot_amt = 0.
          cr_tot_amt = 0.
      end.
      rows = rows + 1.
      create tt.
      assign tt_idx = rows.
      assign tt_desc = gltr_desc.
      assign tt_acct = gltr_acc.
      assign tt_sub = gltr_sub.
      assign tt_cc = gltr_ctr.
      assign tt_curr = gltr_curr.
      assign tt_amt = gltr_amt.
      assign tt_curr_amt = abs(gltr_curramt).    /*外币金额*/
      assign tt_exrate = gltr_en_exrate.
      assign tt_exrate2 = gltr_en_exrate2.       /*外币汇率*/

      /*计算表合计*/
      if gltr_amt > 0 then dr_tot_amt = dr_tot_amt + gltr_amt.
      else cr_tot_amt = cr_tot_amt + gltr_amt.

      if last-of(gltr_ref) and rows > 1 and (rows mod per > 0) then do:
          do i = 1 to per - (rows mod per):
              create tt.
              assign tt_idx = rows + i.
          end.
      end.

      if last-of(gltr_ref) then do:

          pages = truncate(rows / per, 0) + 1.  /*页数*/
          irow = 0.
          ipage = 0.
          
          for each tt no-lock:
              
              irow = irow + 1.
              /*打印表头*/
              if (irow mod per = 1) then do:
                  dr_pg_amt = 0.
                  cr_pg_amt = 0.
                  if ipage > 0 then page.
                  ipage = ipage + 1.
                  put skip.
                  put space(20).
                  put skip.
                  put space(20).
                  put skip.
                  put space(20).
                  put skip.
                  put space(78) "武汉友德公司重庆分厂" .
                  put skip.
                  put space(83) "记 帐 凭 证".
                  put skip.
                  put space(20).
                  put skip.
                  put skip.
                  put space(30).
                  put "总帐参考号:".
                  put unformat gltr_ref.
                  put space(26).
                  put unformat string(year(gltr_eff_dt), "9999") + "年" + string(month(gltr_eff_dt), ">9") + "月" + string(day(gltr_eff_dt), ">9") + "日".
                  put space(28).
                  put "会计单位:".
                  put unformat gltr_entity .
                  put skip.
                  put space(32).
                  put "批处理号:".
                  put gltr_batch format "x(8)".
                  put space(78).
                  put unformat "页号:" + string(ipage, "99") + "/" + string(pages, "99").
                  put skip.
                  put space(20).
                  put "┌─────────────┬──────────────┬────────┬──────┬────────┬─────────┐".
                  put skip.
                  put space(20).
                  put "│     摘             要    │      会  计  科  目        │    外币金额    │  兑 换 率  │ 借方金额(本币) │  贷方金额(本币)  │".
                  put skip.
                  put space(20).
                  put "├─────────────┼──────────────┼────────┼──────┼────────┼─────────┤".
                  put skip.
              end.

              /*打印表体*/
              /*----------*/
              put space(20).
              put "│".
              put tt_desc format "x(26)".
              put "│".
              s_acc = tt_acct.
              if tt_sub <> "" then s_acc = s_acc + tt_sub.
              if tt_cc <> "" then s_acc = s_acc + tt_cc.
              put s_acc format "x(28)".
              put "│".
              if tt_exrate <> tt_exrate2 then do:   /*外币*/
                  exrate = tt_exrate2 / tt_exrate.
                  put tt_curr_amt format ">,>>>,>>>,>>9.99".
                  put "│".
                  put exrate format ">,>>9.999999".
              end.
              else do:                          /*本位币*/
                  put space(16).
                  put "│".
                  put space(12).
              end.
              if tt_amt >= 0 then do:            /*借方*/
                  put "│".
                  put tt_amt format ">,>>>,>>>,>>9.99".
                  put "│".
                  put space(18).
              end.
              else do:                          /*贷方*/
                  put "│".
                  put space(16).
                  put "│".
                  put tt_amt format ">,>>>,>>>,>>9.99cr".
              end.
              put "│".
              put skip.
              /*----------*/
              put space(20).
              put "│".
              put space(26).
              put "│".
              find first ac_mstr where ac_code = tt_acct no-lock no-error.
              if available ac_mstr then 
                  put trim(ac_desc) format "x(28)".
              else
                  put space(28).
              put "│".
              put space(16).
              put "│".
              put space(12).
              put "│".
              put space(16).
              put "│".
              put space(18).
              put "│".
              put skip.
              /*----------*/
              put space(20).
              put "│".
              put space(26).
              put "│".
              find first cc_mstr where cc_ctr = tt_cc no-lock no-error.
              if available cc_mstr and tt_cc <> "" then 
                  put trim(cc_desc) format "x(28)".
              else
                  put space(28).
              put "│".
              put space(16).
              put "│".
              put space(12).
              put "│".
              put space(16).
              put "│".
              put space(18).
              put "│".

              /*计算页小计*/
              if tt_amt > 0 then dr_pg_amt = dr_pg_amt + tt_amt.
              else cr_pg_amt = cr_pg_amt + tt_amt.
              put skip.
              put space(20).
              if (irow mod per = 0) then do:
                  put "├─────────────┴──────────────┴────────┴──────┼────────┼─────────┤".
                  put skip.
                  put space(20).
                  put "│".
                  srmb = RMBChange(dr_tot_amt).
                  if ipage <> pages then do:    /*每页小计*/
                      put "合计: ".
                      put srmb format "x(82)".
                      put "│".
                      put dr_pg_amt format ">,>>>,>>>,>>9.99".
                      put "│".
                      put cr_pg_amt format ">,>>>,>>>,>>9.99cr".
                      put "│".
                  end.                      
                  else do:                      /*每页合计*/
                      put "合计: ".
                      put srmb format "x(82)".
                      put "│".
                      put dr_tot_amt format ">,>>>,>>>,>>9.99".
                      put "│".
                      put cr_tot_amt format ">,>>>,>>>,>>9.99cr".
                      put "│".
                  end.
                  put skip.
                  put space(20).
                  put "└────────────────────────────────────────────┴────────┴─────────┘".
                  put skip.
                  put space(26).
                  put "会计主管: ".
                  put space(18).
                  put "记帐: ".
                  put space(18).
                  put "审核: ".
                  put space(18).
                  put "出纳: ".
                  put space(18).
                  put "制单: ".
                  put gltr_user.
              end.
              else do:
                  put "├─────────────┼──────────────┼────────┼──────┼────────┼─────────┤".
              end.

              put skip.

          end. /*for each tt*/

          for each tt exclusive-lock:
              delete tt.
          end.

      end. /*if last-of(glt_ref)*/
        
   end. /*for each glt_det*/


/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end.  

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" entity entity1 ref ref1 doc doc1 dt dt1 effdt effdt1 btch per "} /*Drive the Report*/

