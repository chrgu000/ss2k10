/* GUI CONVERTED from gltrrp.p (converter v1.69) Thu Oct 16 12:23:27 1997 */
/* gltrrp3.p - Posted Voucher Print  TRANSACTION REGISTER                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert gltrrp.p (converter v1.00) Fri Oct 10 13:57:12 1997 */
/* web tag in gltrrp.p (converter v1.00) Mon Oct 06 14:17:33 1997 */
/*F0PN*/ /*K11L*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 03/04/87   BY: JMS                 */
/*                                   02/26/88   By: JMS                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG   *A175*        */
/*                                   03/21/88   BY: JMS                 */
/*                                   09/09/88   by: jms   *A421*        */
/*                                   10/14/88   by: jms   *A489*        */
/* REVISION: 5.0      LAST MODIFIED: 04/04/89   by: jms   *B066*        */
/*                                   03/04/90   by: pml   *B648*        */
/* REVISION: 6.0      LAST MODIFIED: 07/08/90   by: jms   *D034*        */
/*                                   02/20/91   by: jms   *D366*        */
/* REVISION: 7.0      LAST MODIFIED: 11/05/91   by: jms   *F058*        */
/*                                   02/18/92   by: jms   *F212*        */
/*                                                 (major re-write)     */
/*                                   05/29/92   by: jjs   *F550*        */
/* REVISION: 7.3      LAST MODIFIED  10/16/92   by: mpp   *G479*        */
/*                                   02/19/93   by: jms   *G703*        */
/*                                   02/14/94   by: jms   *GI70*        */
/*                                                 (backs out G479)     */
/*                                   01/16/96   by: mys   *G1K3*        */
/* REVISION: 8.6      LAST MODIFIED  10/16/97   by: bvm   *K11L*        */
/*By: Neil Gao 09/02/06 ECO: *SS 20090206* */

      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*G703*/  {mfdtitle.i "b+ "}

      define variable glname like en_name.
      define variable ref like gltr_ref.
      define variable ref1 like gltr_ref.
      define variable dt like gltr_ent_dt.
      define variable dt1 like gltr_ent_dt.
      define variable effdt like gltr_eff_dt.
      define variable effdt1 like gltr_eff_dt.
      DEFINE VARIABLE PZH LIKE GLTR_USER1.
      DEFINE VARIABLE PZH1 LIKE GLTR_USER1.
      define variable drtot as decimal format "->>,>>>,>>>,>>>.99".
      define variable crtot as decimal format "->>,>>>,>>>,>>>.99cr".
      define variable crtot1 like crtot.

      define variable type like gltr_tr_type.
      define variable type1 like gltr_tr_type.
      define variable entity like gltr_entity.
      define variable entity1 like gltr_entity.
      define variable project like gltr_project.
      define variable project1 like gltr_project.
      define variable xamt like gltr_curramt.
      define variable curr like gltr_curr.
      define variable account as character format "x(14)" label "帐户".
      define variable fenye  as logical  initial yes label "打印是否分页" .
      define variable n1 as integer.
      define variable n2 as integer.
      define variable i as integer.
      DEFINE VARIABLE N3 AS INTEGER. 
     /* define variable miaoshu  as character  .*/
      define variable a like gltr_user.
      define variable b like gltr_ref.
      define variable c like gltr_user1.
      define variable curramt like gltr_curramt initial 0.
      define variable cramt like gltr_curramt initial 0.
      
/*"打印是否分页"no-label*/
/*GI70*/ /*
./*G479*/  define variable rpt_curr like en_curr label "Report Currency".
./*G479*/  define variable supp_zero like mfc_logical initial no
.             label "Suppress zero amounts".
/*GI70*/ */

      /* GET NAME OF CURRENT ENTITY */
      find en_mstr where en_entity = current_entity 
/*SS 20090206 - B*/
				and en_domain = global_domain 
/*SS 20090206 - E*/      
      no-lock no-error.
      if not available en_mstr then do:
         {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
    
/*K11L*/     if c-application-mode <> 'web':u then
             pause.
         leave.
      end.
      else do:
         glname = en_name.

/*GI70*/ /*
./*G479*/     rpt_curr = en_curr.
/*GI70*/ */

         release en_mstr.
      end.
/*G703*//*entity = current_entity.
/*G703*/  entity1 = entity.     */

      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
entity   colon 30  LABEL "会计单位" entity1  colon 50 label {t001.i}
      ref colon 30 LABEL "总帐参考号"
/*G1K3*/        view-as fill-in size 14 by 1   
      ref1 colon 50 label {t001.i}
/*G1K3*/        view-as fill-in size 14 by 1   
      PZH      COLON 30   LABEL "凭证号" PZH1       COLON 50 LABEL {t001.i}
      dt       colon 30   LABEL "录入日期" dt1      colon 50 label {t001.i}
      effdt    colon 30   LABEL "生效日期" effdt1   colon 50 label {t001.i}
      type     colon 30   LABEL "会计帐务类型" type1    colon 50 label {t001.i}
      project  colon 30   LABEL "项目" project1 colon 50 label {t001.i}
      fenye       colon 30 

with frame a side-labels attr-space width 80.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

repeat:

      /* REPORT BLOCK */
    
/*K11L*/  {wbrp01.i}

         if ref1 = hi_char then ref1 = "".
         IF PZH1 = HI_CHAR THEN PZH1 = "".
         if dt = low_date then dt = ?.
         if dt1 = hi_date then dt1 = ?.
         if effdt = low_date then effdt = ?.
         if effdt1 = hi_date then effdt1 = ?.
         if type1 = hi_char then type1 = "".
         if project1 = hi_char then project1 = "".
         if entity1 = hi_char then entity1 = "".

         /* INPUT VARIABLES */

				update entity entity1 ref ref1 PZH PZH1 dt dt1
          effdt effdt1   type type1 project project1 with frame a.

/*K11L*/ if (c-application-mode <> 'web':u) or
/*K11L*/ (c-application-mode = 'web':u and
/*K11L*/ (c-web-request begins 'data':u)) then do:


         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i entity  }
         {mfquoter.i entity1 }
         {mfquoter.i ref     }
         {mfquoter.i ref1    }
         {mfquoter.i PZH     }
         {mfquoter.i PZH1    }
         {mfquoter.i dt      }
         {mfquoter.i dt1     }
         {mfquoter.i effdt   }
         {mfquoter.i effdt1  }
         {mfquoter.i type    }
         {mfquoter.i type1   }
         {mfquoter.i project }
         {mfquoter.i project1}

/*GI70*/ /*
./*G479*/     {mfquoter.i rpt_curr}
./*G479*/     {mfquoter.i supp_zero}
/*GI70*/ */
			end.
         if ref1 = "" then ref1 = hi_char.
         IF PZH1 = "" THEN PZH1 = HI_CHAR.
         if dt = ?  then dt = low_date.
         if dt1 = ? then dt1 = hi_date.
         if effdt = ? then effdt = low_date.
         if effdt1 = ? then effdt1 = hi_date.
         if type1 = "" then type1 = hi_char.
         if entity1 = "" then entity1 = hi_char.
         if project1 = "" then project1 = hi_char.
    
             
					{mfselbpr.i "printer" 132}

/*SS 20090206 - E*/

find en_mstr where en_entity = current_entity 
/*SS 20090206 - B*/
	and en_domain = global_domain
/*SS 20090206 - E*/
no-lock no-error.

define buffer g1 for gltr_hist.


        /* {mfphead1.i}*/

         crtot = 0.
         drtot = 0.

         find first gl_ctrl no-lock no-error.
          
          /* PRINT REPORT */
         for each gltr_hist where gltr_entity >= entity and
/*SS 20090206 - B*/
											gltr_domain = global_domain and
/*SS 20090206 - E*/
                      gltr_entity <= entity1 and
                      gltr_ref >= ref and gltr_ref <= ref1 and
                      GLTR_USER1 >= PZH AND
                      GLTR_USER1 <= PZH1 AND
                      gltr_tr_type >= type and
                      gltr_tr_type <= type1 and
                      gltr_project >= project and
                      gltr_project <= project1 and
                      gltr_ent_dt >= dt and
                      gltr_ent_dt <= dt1 and
                      gltr_eff_dt >= effdt and
                      gltr_eff_dt <= effdt1 and
                      gltr_tr_type >= type and
                      gltr_tr_type <= type1
                      no-lock  use-index gltr_ref 
                      break by gltr_user1 with width 132:
                    

/*G703*/        if gltr_entity = "" and gltr_line = 0 then do:
                 /*{mfphead.i}*/
                   if page-size - line-count < 16 then page.
/*G703*/           display    
/*G703*/                   /*"生效日期" @*/ gltr_eff_dt column-LABEL "生效日期"
/*G703*/                   gltr_ent_dt   LABEL "录入日期"
/*G703*/                  /* gltr_user     LABEL "制单人" */
/*G703*/                   "" @ gltr_batch  LABEL "批处理"
                          /* gltr_ref   LABEL "总帐参考号"  at 110 */
/*G703*/                   with down /*frame b */STREAM-IO /*GUI*/ .
               /*  display gltr_ref LABEL "总帐参考号" at 85  with down /*frame b */STREAM-IO /*GUI*/ .*/
/*G703*/           next.
/*G703*/        end.

/*GI70*/ /*
./*G479*/        find en_mstr where en_entity = gltr_entity no-lock no-error.
./*G479*/        if first-of(gltr_ref) and (rpt_curr = en_curr or rpt_curr = "")
/*GI70*/ */
                 /*GI70*/        if first-of(gltr_user1) then do:
               /*  message  page-size  view-as alert-box.
              message 100000 + line-counter view-as alert-box.*/
         if 1 < LINE-COUNTER and  LINE-COUNTER <= 23 then do:
           n1 = 25.
           /*if LINE-COUNTER + n1 < page-size then*/
           n2 = /*page-size -*/ n1 - LINE-COUNTER.
         /*  message 110000 + n2 view-as alert-box.*/

  
           
            repeat i = 1 to n2 :
           put skip(1).                 
            end.
           end.
          /*   message 200000 + line-counter view-as alert-box.*/

           if  27 < LINE-COUNTER and LINE-COUNTER <=46 then do:
       /*     message 500000 + line-counter view-as alert-box.*/

           n1 = 51.
           /*if LINE-COUNTER + n1 < page-size then */
           n2 = /*page-size - */ n1 - LINE-COUNTER.
         /*   message 220000 + n2 view-as alert-box.*/

                repeat i = 1 to n2 :
           put skip(1).                 
            end.

           end.
           
                 

                   
       /*  MESSAGE N3 VIEW-AS ALERT-BOX.*/
          if fenye = yes then page.
/*SS 20090206 - B*/
/*
          {xxmfphead.i}
*/
          {mfphead.i}
/*SS 20090206 - E*/
          a = gltr_user.
          b = gltr_ref.
          c = gltr_user1 .
       

/*******
         display 
              gltr_eff_dt  LABEL "生效日期" 
               gltr_ent_dt  LABEL "录入日期"
             /*  gltr_user  LABEL "制单" */
               gltr_batch   LABEL "批处理"    
              /* gltr_ref LABEL "总帐参考号" at 110*/
                with  /*down frame b */STREAM-IO /*GUI*/ .
*********/
             put "生效日期: " at 6 gltr_eff_dt .
             put "总帐参考号:" at 60 .  
             put b.
             put "凭证号:" at 90 .
             put c.
             put  "             附件：   张".

               
           for each g1 where g1.gltr_ref = gltr_hist.gltr_ref 
/*SS 20090206 - B*/
							and g1.gltr_domain = global_domain
/*SS 20090206 - E*/           
           no-lock
                     with frame c width 132:
              /*   find ac_mstr where ac_code = g1.gltr_acc no-lock no-error.                */
              /* COMBINE ACCT, SUB-ACCT, AND CC INTO SINGLE STRING */
              {glacct.i &acc=g1.gltr_acc &sub=g1.gltr_sub
             &cc=g1.gltr_ctr &acct=account}
    /*GI70
* /*G479*/              if not(supp_zero) or (supp_zero
* /*G479*/                 and (g1.gltr_amt <> 0
* /*G479*                  or g1.gltr_curramt <> 0  */
* /*G479*/                 or g1.gltr_ecur_amt <> 0)) then do:
*GI70*/
           
                 
             display space(5)
                   g1.gltr_line label "序号"
                   account format "x(26)"                  
                   g1.gltr_project label "项目" 
                   /* g1.gltr_entity column-label "单位" */
                   g1.gltr_desc format "x(28)" label "摘要"
/*F550*/                     WITH STREAM-IO /*GUI*/ .

             curramt = abs(gltr_curramt).
             cramt = abs(gltr_amt).
             if gltr_curr <> gl_base_cur then 
                display gltr_curr column-label "货币"  format "x(4)"  
                        curramt column-label "外币金额"  format ">,>>>,>>9.99"  
                        gltr_ex_rate2 format ">>9.99999" column-label "汇率" .
             else 
                display " " @ gltr_curr column-label "货币"  format "x(4)"  
                        " " @ curramt column-label "外币金额"  format ">,>>>,>>9.99" 
                        " " @ gltr_ex_rate2 column-label "汇率"  format ">>9.99999".

             if g1.gltr_amt < 0 then           
                display
                  "" @ g1.gltr_amt column-label "借方金额" 
                  absolute(g1.gltr_amt) column-label "贷方金额"  format ">,>>>,>>9.99" 
                  /* ABSOLUTE(g1.gltr_curramt) format ">>,>>>,>>>,>>>.99" column-label "贷方金额"  steven */
                 WITH STREAM-IO .
                            
             else if g1.gltr_amt > 0 then 
               display
                 g1.gltr_amt column-label "借方金额" format ">,>>>,>>>.99" /* steven */
                 /*  "" @ g1.gltr_curramt column-label "贷方金额"  */
                 WITH STREAM-IO .            

/*GI70*
* /*G479*/                    find en_mstr where en_entity = g1.gltr_entity
* /*G479*/                       no-lock no-error.
* /*G479*/                    if g1.gltr_ecur_amt <> 0 then
* /*G479*/                       display
* /*G479*/                         g1.gltr_ecur_amt column-label "Entity Amount"
* /*G479*/                         en_curr column-label "Ent!Cur".
* /*G479*/                    else
* /*G479*/                       display
* /*G479*/                         "" @ g1.gltr_ecur_amt column-label
*                                  "Entity Amount"
* /*G479*/                         "" @ en_curr column-label "Ent!Cur".
*GI70*/
/********                
              display /* g1.gltr_addr column-label "   地址" */
                g1.gltr_doc_typ   column-label "   T"       
                /* g1.gltr_doc column-label "   单据" */ WITH STREAM-IO /*GUI*/ .
***********/
/*GI70*
* /*G479*/            end.
                     
                                           
*GI70*/        /* display  ac_desc  at 10 no-labels  WITH STREAM-IO .*/
            /*  find ac_mstr where ac_code = g1.gltr_acc no-lock no-error.*/
            find ac_mstr where ac_code = g1.gltr_acc 
/*SS 20090206 - B*/
								and ac_domain = global_domain
/*SS 20090206 - E*/            
            no-lock no-error.
           
              put  ac_desc at 10 .
                              
              if available ac_mstr and ac_type <> "M" and ac_type <> "S"
             then do: 
             if g1.gltr_amt < 0 then do:
             
              /*  ACCUMULATE   g1.gltr_amt(total by gltr_hist.gltr_ref).  
                   crtot =(accum total by  gltr_hist.gltr_ref g1.gltr_amt).*/
                 crtot= crtot + g1.gltr_amt.
                 end .
            else do:
            /* if g1.gltr_amt > 0 then do:*/
            /* ACCUMULATE   g1.gltr_amt(sub-total by gltr_hist.gltr_ref).  */
                  /*drtot =(accum total by  gltr_hist.gltr_ref g1.gltr_amt).*/
               
               drtot = drtot + g1.gltr_amt.
              end.
              
             end.

/*SS 20090206 - B*/
/*
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
*/
{mfrpexit.i}
/*SS 20090206 - E*/           
           end.
            put skip(.1) "     ---------------------------------------------------------------------------------------------------------------------------" .
            put   "合计:" at 47 .                  
      
            put drtot format ">,>>>,>>9.99" at 104.
            put absolute(crtot) format ">,>>>,>>>.99" at 117 skip(2).
/* put substring(string(crtot),1,length(string(crtot)) - 2,"CHARACTER") at 70.*/

            put /*skip(1)*/ "会计主管:" at 13 "记帐:" at 49 "审核:" at 85  "制单:" at 113 a  skip(2).
            
            
            crtot=0.
            drtot =0.
         end.
       
         end.

         /* PRINT DEBIT AND CREDIT TOTALS */
         /*yy   put skip(2) "借方合计:" at 25 drtot space(1) base_curr
             "贷方合计:" a 75 crtot space(1) base_curr.
         ******/
         /* REPORT TRAILER  */

 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


      end.



