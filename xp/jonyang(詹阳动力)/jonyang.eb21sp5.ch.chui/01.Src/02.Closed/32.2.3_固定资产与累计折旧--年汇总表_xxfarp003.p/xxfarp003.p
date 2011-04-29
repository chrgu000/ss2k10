/* xxfarp003.p 固定资产与累计折旧汇总表                                    */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/26   BY: Apple Tam            */
/* REVISION: 1.0      LAST MODIFIED: 2011/03/29   BY: Apple Tam            */
/*-Revision end------------------------------------------------------------*/

{mfdtitle.i "110329.1"}

define variable v_rptdate as date.
v_rptdate = date(month(today),01,year(today)) - 1. /*上月最后一天*/

define variable l-facode  like fa_code    no-undo.
define variable l-facode1 like fa_code    no-undo.
define variable l-entity  like fa_entity  no-undo.
define variable l-entity1 like fa_entity  no-undo.
define variable l-asset   like fa_id      no-undo.
define variable l-asset1  like fa_id      no-undo.
define variable l-yrper   like fabd_yrper no-undo.
define variable l-yrper1  like fabd_yrper no-undo.
define variable l-loc     like fa_faloc_id no-undo.
define variable l-loc1    like fa_faloc_id no-undo.
define variable l-class   like fa_facls_id no-undo.
define variable l-class1  like fa_facls_id no-undo.
define variable l_error   as   integer      no-undo.

define var v_ii   as integer label "序号" .
define var v_acct like faba_acct.
define var v_sub  like faba_sub .
define var v_cc   like faba_cc  .
define var v_desc   like facls_desc  .
define var last-yrper   like fabd_yrper no-undo.

define new shared temp-table temp_fa no-undo
   field temp_facls_id  like facls_id
   field temp_fa_id    like fa_id
   field temp_fabk_id  like fabk_id
   field temp_desc     like facls_desc
   field temp_yrper    like fabd_yrper
   field temp_sub      like faba_sub
   field temp_disp_dt   like fa_disp_dt
   field temp_mod_date   like fa_disp_dt
   field temp_amt10    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt11    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt12    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt13    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt14    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt15    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt21    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt22    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt23    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt24    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_amt25    as decimal format "->>,>>>,>>>,>>9.99<"
   field temp_total    as decimal format "->>,>>>,>>>,>>9.99<"
   index temp_facls_id is primary temp_facls_id           .

define new shared temp-table temp2_fabd no-undo
   field temp2_fa_id  like fa_id
   field temp2_yrper     like fabd_yrper
   field temp2_peramt   like fabd_peramt
   field temp2_accamt   like fabd_accamt
   field temp2_nbv       as decimal format "->>>,>>>,>>9.99<"
   field temp2_faloc_id like fabd_faloc_id
   field temp2_post      like fabd_post
   index temp2_yrper  is unique primary temp2_yrper           .


form
    SKIP(.2)

   l-entity  colon 25
   l-entity1 colon 42      label {t001.i}
   l-class   colon 25
   l-class1  colon 42      label {t001.i}
   /*l-yrper   colon 25*/
   l-yrper1  colon 25      label "年度/期间"

   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

/* ASSIGN l-yrper TO GL PERIOD FOR v_rptdate'S DATE */
{gprunp.i "fapl" "p" "fa-get-per"
  "(input  v_rptdate,
    input  """",
    output l-yrper1,
    output l_error)"}

  /* ASSIGN yrPeriod TO v_rptdate'S DATE */
if l_error <> 0 then  l-yrper1 = string(year(v_rptdate), "9999") + string(month(v_rptdate), "99").

{wbrp01.i}
repeat:
    if l-entity1 = hi_char then l-entity1 = "".
    if l-yrper1  = hi_char then l-yrper1  = "".
    if l-class1  = hi_char then l-class1  = "".


    update  
        l-entity
        l-entity1
        l-class
        l-class1
        l-yrper1
    with frame a.

       
    if l-yrper1      = ""  
       or length(l-yrper1) <> 6 
    then do:
        message "错误:无效年度/期间,请重新输入" .
        undo,retry .
    end. /* IF l-yrper = "" */
    

    if l-entity1 = ""       then l-entity1 = hi_char.
    if l-entity1 < l-entity then l-entity1 = l-entity.
    if l-yrper1  = ""       then l-yrper1  = hi_char.
    if l-yrper1  < l-yrper  then l-yrper1  = l-yrper.
    if l-class1  = ""       then l-class1  = hi_char.
    if l-class1  < l-class  then l-class1  = l-class.



    /* PRINTER SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = "nopage"
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    


    PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp003" SKIP.
    PUT UNFORMATTED "#def :end" SKIP.

v_ii = 0 .
l-yrper = string(integer(substring(l-yrper1,1,4)) - 1).

if integer(substring(l-yrper1,5,2)) = 12 then do:
   last-yrper = string(integer(substring(l-yrper1,1,4)) + 1) + "01".
end.
else do:
   last-yrper = string(integer(l-yrper1) + 1).
end.

/*if substring(last-yrper,5,2)) = 00 then 
last-yrper = l-yrper + "12".*/

for each temp_fa:
    delete temp_fa.
end.
for each fa_mstr 
        where fa_domain    = global_domain 
          and fa_entity   >= l-entity and  fa_entity <= l-entity1
          and fa_facls_id >= l-class  and fa_facls_id <= l-class1
          and (fa_disp_dt = ? or string(year(fa_disp_dt), "9999") >= substring(l-yrper1,1,4))
    no-lock
    break by fa_id :
    
    v_acct = "" .
    v_sub  = "" .
    v_cc   = "" .

    /*找资产账户acctype = "1"*/
    define var l-acct-seq like faba_glseq no-undo .
    l-acct-seq = 0 .
    for last faba_det use-index faba_fa_id where faba_domain = global_domain and  faba_fa_id = fa_id no-lock:
        l-acct-seq = faba_glseq.
    end.  
    find first faba_det 
        where faba_domain  = fa_domain 
        and   faba_fa_id   = fa_id
        and   faba_acctype = "1" 
        and   faba_glseq   = l-acct-seq 
    no-lock no-error .
    if avail faba_det then  assign  v_acct = faba_acct v_sub = faba_sub v_cc = faba_cc .

    v_desc = "".
    find first facls_mstr
        where facls_domain = global_domain
        and facls_id = fa_facls_id
    no-lock no-error.
    v_desc = if available facls_mstr then facls_desc else fa_facls_id .

    create temp_fa.
    assign
        temp_fa_id    = fa_id
        temp_facls_id = fa_facls_id
        temp_desc     = v_desc
        temp_sub      = v_sub 
        .

    
    find first fabk_mstr where fabk_domain = global_domain and fabk_post = yes no-lock no-error.
    if available fabk_mstr then do:
            for each fab_det 
                where fab_domain = global_domain
                and fab_fa_id = fa_id
                and fab_fabk_id = fabk_id 
            no-lock:
                find first temp_fa where temp_fa_id = fa_id no-error.
                if available temp_fa then do:
                    /*当年增加*/
                    if string(year(fa_startdt), "9999") = substring(l-yrper1,1,4) 
                        and string(month(fa_startdt), "99") <= substring(l-yrper1,5,2) 
                        and fab_resrv = 0 
                    then do:
                        temp_amt12    = temp_amt12 + fab_amt.
                    end.

                    /*当年报废*/
                    if fa_disp_dt <> ? then do:
                        if string(year(fa_disp_dt), "9999") = substring(l-yrper1,1,4) 
                            and string(month(fa_disp_dt), "99") <= substring(l-yrper1,5,2) 
                            and fab_resrv = 0 
                        then do:
                            temp_amt13    =  temp_amt13 + fab_amt.
                            temp_disp_dt = fa_disp_dt .
                        end.
                    end.

                    /*当年-调帐*/
                    if string(year(fab_mod_date), "9999") = substring(l-yrper1,1,4)
                        and string(month(fab_mod_date), "99") <= substring(l-yrper1,5,2) 
                        and fab_resrv > 0 
                    then do:
                        temp_amt14 = temp_amt14 + fab_amt.
                    end.
                 /*ss-20100727*/       temp_amt14 = 0.

                    /*年初数 temp_amt10 + temp_amt11*/
                    if string(year(fa_startdt), "9999") < substring(l-yrper1,1,4) then do:
                        if fab_resrv = 0 then do:
                            temp_amt10 = fab_amt.
                        end.
                        if fab_resrv > 0 then do:
                            temp_amt11 = temp_amt11 + fab_amt.
                        end.
                    end.

                    /*之前年度-调账*/
                    /*SS - 100527.1*
                    if string(year(fab_mod_date), "9999") < substring(l-yrper1,1,4) and fab_resrv > 0 then do:
                        temp_amt11 = temp_amt11 + fab_amt.
                    end.*/

                    /*年末数 temp_amt10 + temp_amt11 + temp_amt14*/
                    if fa_disp_dt <> ? then do:
                        if string(year(fa_disp_dt), "9999") + string(month(fa_disp_dt), "99") <= l-yrper1 then do:
                            temp_amt15 = 0.
                        end.
                    end.

                end. /*if available temp_fa then do*/
            end. /*for each fab_det*/

/******************/
         /* Clean up */
         for each temp2_fabd exclusive-lock:
           delete temp2_fabd.
         end.

         for each fabd_det
             fields( fabd_domain fabd_yrper fabd_fa_id fabd_fabk_id
                     fabd_faloc_id
                     fabd_peramt
                     fabd_accamt fabd_seq fabd_post) no-lock  where
                     fabd_det.fabd_domain = global_domain and
             fabd_fa_id = fa_id and
             fabd_fabk_id = fabk_id
             break by fabd_yrper:
            if first-of(fabd_yrper) then do:
               create temp2_fabd.
               /* Need to assing key before calling get-perdep */
               assign
                  temp2_fa_id    = fa_id
                  temp2_yrper    = fabd_yrper
                  temp2_faloc_id = fabd_faloc_id
                  temp2_post     = fabd_post.
             
               {gprunp.i "fapl" "p" "fa-get-perdep"
                         "(input  fa_id,
                           input  fabk_id,
                           input  fabd_yrper,
                           output temp2_peramt)"}

               {gprunp.i "fapl" "p" "fa-get-accdep"
                         "(input  fa_id,
                           input  fabk_id,
                           input  fabd_yrper,
                           output temp2_accamt)"}
               
               {gprunp.i "fapl" "p" "fa-get-cost"
                         "(input  fa_id,
                           input  fabk_id,
                           output temp2_nbv)"}

               temp2_nbv = temp2_nbv - temp2_accamt.  

             end.  /* if first-of ... */
         end.  /* for each fabd_det */
         
/*         for each temp2_fabd:
             disp
               temp2_fa_id   
               temp2_yrper   
               temp2_post  
               temp2_peramt
               temp2_accamt
               temp2_nbv.
         end.
*/
         for each faadj_mstr where faadj_domain = global_domain 
                               and faadj_fa_id = fa_id 
                               and faadj_yrper = l-yrper1
                               no-lock:
/*                     if string(year(faadj_mod_date), "9999") = substring(l-yrper1,1,4)
                       and string(month(faadj_mod_date), "99") = substring(l-yrper1,5,2) 
                       then do:
                       temp_mod_date = faadj_yrper.
                     end.*/
                       temp_yrper = faadj_yrper.
         end. /*for each faadj_mstr*/

             for each temp2_fabd where /*temp2_post = yes*/ break by temp2_yrper:    
                
                /*累计折旧-年末数*/
             if fa_disp_dt <> ? then do:
             if string(year(fa_disp_dt), "9999") = substring(l-yrper1,1,4) 
                and string(month(fa_disp_dt), "99") > substring(l-yrper1,5,2) then do: 
                if substring(temp2_yrper,1,4) = substring(l-yrper1,1,4) 
                   and temp2_yrper <= l-yrper1 
                   then do:

                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa then do:
                      temp_amt25 = temp2_accamt.
                   end.

                    end. /*if substring(temp2_yrper,1,4) = substring(l-yrper1,1,4)*/
             end. /*if string(year(fa_disp_dt), "9999")*/
             end.
             if fa_disp_dt = ? then do:
                if substring(temp2_yrper,1,4) = substring(l-yrper1,1,4) 
                   and  temp2_yrper <= l-yrper1 
                   then do:

                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa then do:
                      temp_amt25 = temp2_accamt.
                   end.

                    end. /*if substring(temp2_yrper,1,4) = substring(l-yrper1,1,4)*/
             end.

                /*累计折旧-年初数*/
/*ss-20110329                if substring(temp2_yrper,1,4) = l-yrper*/
/*ss-20110329*/                if substring(temp2_yrper,1,4) <= l-yrper
                   then do:
                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa then do:
                      temp_amt21 = temp2_accamt.
                   end.
                end.
                /*累计折旧-当年减少*/
                if fa_disp_dt <> ? then do:
                     if string(year(fa_disp_dt), "9999") = substring(l-yrper1,1,4)
                       and string(month(fa_disp_dt), "99") <= substring(l-yrper1,5,2) then do:
                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa then do:
                       temp_amt23 = temp2_accamt.
                   end.
                     end.
                end.

             /*累计折旧-当年增加*/
                if substring(temp2_yrper,1,4) = substring(l-yrper1,1,4) 
                   and temp2_yrper <= l-yrper1 
                   then do:
                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa then do:
                    temp_amt22 = temp_amt22 + temp2_peramt.
                   end.
                end.

/*             /*净值*/
             if temp2_yrper = l-yrper1 then
                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa then do:
                      temp_total = temp2_nbv.
                   end.

*/
             end.  /*for each temp2_fabd*/          
             
           
               /*累计折旧-调帐*/
               
                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa and temp_yrper = l-yrper1 then do:
                      find first temp2_fabd where temp2_fa_id = fa_id 
                      and temp2_yrper = l-yrper1 /*and temp2_post = yes*/ no-error.
                      if available temp2_fabd then do:
                         temp_amt24 = temp2_peramt.
                      end.
                      find first temp2_fabd where temp2_fa_id = fa_id 
                      and temp2_yrper = last-yrper /*and temp2_post = yes*/ no-error.
                      if available temp2_fabd then do:
                         temp_amt24 = temp_amt24 - temp2_peramt.
                      end.
                   end.
 
/*           find first temp2_fabd where temp2_fa_id = fa_id 
                and temp2_yrper = l-yrper1
                                  no-error.
                if available temp2_fabd then do:
                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa and temp_yrper = l-yrper1 then do:
                         temp_amt24 = temp2_peramt.
                      end.
                 end.
           find first temp2_fabd where temp2_fa_id = fa_id 
                and temp2_yrper = last-yrper
                                  no-error.
                if available temp2_fabd then do:
                   find first temp_fa where temp_fa_id = fa_id no-error.
                   if available temp_fa then do:
                         temp_amt24 = temp_amt24 - temp2_peramt.
                      end.
                 end.
*/
    end. /*if available fabk_mstr then do*/
    
    


end. /*for each fa_mstr*/

    for each temp_fa:
             /*年初数 temp_amt10 + temp_amt11*/
             temp_amt11 = temp_amt11 + temp_amt10.

             /*年末数 temp_amt11 + temp_amt14*/
             /*temp_amt15 = temp_amt11 + temp_amt14.*/
             temp_amt15 = temp_amt11 + temp_amt12 - temp_amt13.
             if temp_disp_dt <> ? then do:
                if string(year(temp_disp_dt), "9999") + string(month(temp_disp_dt), "99") <= l-yrper1 then do:
                   temp_amt15 = 0.
                end.
             end.

             /*SS - 100527.1*/ temp_amt24 = 0 . 
             /*SS - 100527.1*/ if l-yrper1 begins "2010" then do:
                                    temp_amt22 = temp_amt22 + temp_amt21 . 
                                    temp_amt21 = 0 .
                               end.

            /*累计折旧-年末数*/
            temp_amt25 = temp_amt21 + temp_amt22 - temp_amt23.
            /*净值*/
            temp_total = temp_amt15 - temp_amt25.

    end.

     for each temp_fa break by temp_facls_id:

      /*    export  delimiter ";"

           temp_facls_id
           temp_fa_id   
           temp_desc    
          /* temp_yrper   
           temp_sub     
           temp_disp_dt 
           temp_amt10   */
           temp_amt11   
           temp_amt12   
           temp_amt13   
           temp_amt14   
           temp_amt15   
           temp_amt21   
           temp_amt22   
           temp_amt23   
           temp_amt24   
           temp_amt25   
           temp_total 
           ""
           l-yrper1
           .
*/
        accum temp_amt10 (total by temp_facls_id).
        accum temp_amt11 (total by temp_facls_id).
        accum temp_amt12 (total by temp_facls_id).
        accum temp_amt13 (total by temp_facls_id).
        accum temp_amt14 (total by temp_facls_id).
        accum temp_amt15 (total by temp_facls_id).
        accum temp_amt21 (total by temp_facls_id).
        accum temp_amt22 (total by temp_facls_id).
        accum temp_amt23 (total by temp_facls_id).
        accum temp_amt24 (total by temp_facls_id).
        accum temp_amt25 (total by temp_facls_id).
        accum temp_total (total by temp_facls_id).

        accum temp_amt10 (total).
        accum temp_amt11 (total).
        accum temp_amt12 (total).
        accum temp_amt13 (total).
        accum temp_amt14 (total).
        accum temp_amt15 (total).
        accum temp_amt21 (total).
        accum temp_amt22 (total).
        accum temp_amt23 (total).
        accum temp_amt24 (total).
        accum temp_amt25 (total).
        accum temp_total (total).
       if last-of(temp_facls_id) then do:
          export  delimiter ";"

         /*  temp_facls_id
           temp_fa_id   
           temp_yrper   
           temp_disp_dt */
           temp_desc    
           temp_sub     
           accum total by temp_facls_id temp_amt11   
           accum total by temp_facls_id temp_amt12   
           accum total by temp_facls_id temp_amt13   
           accum total by temp_facls_id temp_amt14   
           accum total by temp_facls_id temp_amt15   
           accum total by temp_facls_id temp_amt21   
           accum total by temp_facls_id temp_amt22   
           accum total by temp_facls_id temp_amt23   
           accum total by temp_facls_id temp_amt24   
           accum total by temp_facls_id temp_amt25   
           accum total by temp_facls_id temp_total 
           ""
           l-yrper1
           .
        end.
     end.
          export  delimiter ";"

/*           temp_facls_id
           temp_fa_id   
           temp_desc    
           temp_yrper   
           temp_sub     
           temp_disp_dt */
           "合计"
           " "
           accum total temp_amt11   
           accum total temp_amt12   
           accum total temp_amt13   
           accum total temp_amt14   
           accum total temp_amt15   
           accum total temp_amt21   
           accum total temp_amt22   
           accum total temp_amt23   
           accum total temp_amt24   
           accum total temp_amt25   
           accum total temp_total 
           ""
           l-yrper1
           .

end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



