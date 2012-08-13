{mfdeclre.i }
    {bcdeclre.i}
    
DEF INPUT PARAMETER bd_case AS CHAR.
DEF INPUT PARAMETER bd_site AS CHAR.
DEF INPUT PARAMETER bd_loc AS CHAR.
DEF INPUT PARAMETER bd_part AS CHAR.
DEF INPUT PARAMETER bd_lotser AS CHAR.
DEF INPUT PARAMETER bd_ref AS CHAR.
DEF INPUT PARAMETER bd_tr_type AS CHAR.
DEF INPUT PARAMETER bd_code AS CHAR.
DEF INPUT PARAMETER bd_ord AS CHAR.   
 DEF INPUT PARAMETER bd_line AS CHAR.
 DEF INPUT PARAMETER bd_data AS CHAR.
 DEF INPUT PARAMETER bd_op AS CHAR.
 DEF INPUT PARAMETER bd_mch AS CHAR.
DEF OUTPUT PARAMETER succ AS LOGICAL.
DEF VAR bdgpglef AS INT INITIAL 0.
DEF TEMP-TABLE bcqis
    FIELD qis_vend LIKE b_co_vend
    FIELD qis_part LIKE b_co_part
    FIELD qis_pass AS LOGICAL.
/*DEF SHARED  TEMP-TABLE iss_list
    FIELD iss_part AS CHAR
    FIELD iss_lotser AS CHAR
    FIELD iss_ref AS CHAR
    FIELD iss_um AS CHAR
    FIELD iss_qty AS DECIMAL
    FIELD iss_site AS CHAR
    FIELD iss_loc AS CHAR.
DEF SHARED  TEMP-TABLE bd_merge_list
    FIELD bd_merge_id AS CHAR
    FIELD bd_merge_part AS CHAR
    FIELD bd_merge_lotser AS CHAR
    FIELD bd_merge_ref AS CHAR
    FIELD bd_merge_qty AS decimal.*/
 DEF VAR m_tol AS DECIMAL.
succ = YES.

CASE bd_case :
    WHEN 'cust' THEN DO:
    succ = YES.
        FIND FIRST cm_mstr WHERE cm_addr = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cm_mstr THEN DO:

  succ = NO.
MESSAGE bd_data " 无效客户！" VIEW-AS ALERT-BOX ERROR.

        END.
        
        
        
        
        
        END.

        WHEN 'supp' THEN DO:
    succ = YES.
        FIND FIRST scx_ref WHERE scx_type = 2 AND scx_shipfrom = bd_data AND scx_part = bd_part NO-LOCK NO-ERROR.
        IF NOT AVAILABLE scx_ref THEN DO:

  succ = NO.
MESSAGE  bd_data " 无效供应商或该供应商没有"  bd_part "料件！" VIEW-AS ALERT-BOX ERROR.

        END.
        
        
        
        
        
        END.




    WHEN 'part' THEN DO:
 succ = YES.
    FIND FIRST pt_mstr WHERE pt_part = bd_part NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pt_mstr THEN DO:
    succ = NO.
MESSAGE "无效零件！" VIEW-AS ALERT-BOX ERROR.
        
        END.

END.

   /* WHEN 'bd_loc' THEN DO:
    succ = YES.
       FIND b_loc_mstr WHERE b_loc_code = bd_code NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b_loc_mstr THEN DO:
      
       succ = NO.
   MESSAGE "无效库位条码！" VIEW-AS ALERT-BOX ERROR.

           END.

   END.*/

    WHEN 'period' THEN DO:
     succ = YES.
     FIND FIRST gl_ctrl NO-LOCK NO-ERROR. 
      if available gl_ctrl and gl_verify = yes then do:
     FIND FIRST glc_cal WHERE glc_start <= TODAY AND glc_end >= TODAY  NO-LOCK NO-ERROR.
    IF AVAILABLE glc_cal THEN DO:
      FIND FIRST glcd_det WHERE glcd_year = year(today) AND glcd_per = glc_per  AND glcd_entity = gl_entity NO-LOCK NO-ERROR.
      IF AVAILABLE glcd_det  THEN DO:
     
      IF glcd_closed = YES OR glcd_gl_clsd = YES OR glcd_yr_clsd = YES THEN DO:
     
         succ  = NO.
       MESSAGE "会计期间已关闭！" VIEW-AS ALERT-BOX ERROR.
        END.
   
      ELSE DO:
          FIND first qad_wkfl where
      qad_key1 = "GLCD_DET" and
      qad_key2 =  string(glcd_year,"9999") + string(glcd_per, "999")
               +  gl_entity
      NO-LOCK NO-ERROR.
          IF AVAILABLE qad_wkfl THEN DO:
               IF bd_data = 'IC'  AND (qad_decfld[4] = 1) THEN succ = NO.
               IF bd_data = 'WO' AND (qad_decfld[4] = 1) THEN succ = NO .
               IF bd_data = 'SO'  AND (qad_decfld[6] = 1) THEN  succ = NO.
               IF NOT succ THEN  MESSAGE "会计期间已关闭！" VIEW-AS ALERT-BOX ERROR.
          END.
      END.
   end.
      END.
      
    ELSE DO:

        succ  = NO.
       MESSAGE "无效会计期间！" VIEW-AS ALERT-BOX ERROR.
    END.


    END.
END.

    WHEN 'si_au' THEN DO:
    
       
        
           {gprun.i ""gpsiver.p"" "(input bd_site, input recid(si_mstr), output succ)"}
             
            IF NOT succ THEN MESSAGE "无当前地点权限！" VIEW-AS ALERT-BOX ERROR.
            
           
            
            
            
            
        
        END.
         WHEN 'site' THEN DO:
    
        FIND FIRST si_mstr WHERE si_site = bd_site NO-LOCK NO-ERROR.
        IF NOT AVAILABLE si_mstr THEN  DO:
                succ = NO.
MESSAGE "无效地点！" VIEW-AS ALERT-BOX ERROR.
            
            
            END.
        
            
            
            
        
        END.
        
        
 WHEN 'loc' THEN DO:
   
        FIND FIRST loc_mstr WHERE loc_loc = bd_Loc AND loc_site = bd_site NO-LOCK NO-ERROR.
        IF NOT AVAILABLE loc_mstr THEN  DO:
                succ = NO.
MESSAGE bd_site + ' ' + bd_loc " 无效地点或库位！" VIEW-AS ALERT-BOX ERROR.
            
            
            END.
        ELSE DO:
      IF bd_data = 'rep' THEN DO:
      FIND FIRST rps_mstr WHERE rps_part = bd_part AND rps_site = bd_site NO-LOCK NO-ERROR.
      IF NOT AVAILABLE rps_mstr THEN DO:
          succ = NO.
          MESSAGE bd_site '不是该成品生产地点!' VIEW-AS ALERT-BOX.
      END.
      ELSE succ = YES.
      END.
         ELSE   succ = YES.
        END.
        END.


   
        
         WHEN 'icoverissue' THEN DO:
    
        FIND FIRST ld_det WHERE ld_site = bd_site AND ld_loc = bd_loc AND ld_part = bd_part AND ld_lot = bd_lotser AND ld_ref = bd_ref NO-LOCK NO-ERROR.
        IF  AVAILABLE ld_det THEN  DO:
                FIND FIRST IS_mstr WHERE IS_status = ld_status NO-LOCK NO-ERROR.
                IF AVAILABLE IS_mstr THEN  DO:
                  IF NOT IS_overissue THEN DO:
                  succ = NO.
                      
                  MESSAGE "不允许负库存！" VIEW-AS ALERT-BOX ERROR.

                      END.
                ELSE succ = YES.
                      
                      END.
        END.
                    END.


    WHEN 'ictr_typ' THEN DO:

FIND FIRST ld_det WHERE ld_site = bd_site AND ld_loc = bd_loc AND ld_part = bd_part AND ld_lot = bd_lotser AND ld_ref = bd_ref NO-LOCK NO-ERROR.
IF  AVAILABLE ld_det THEN  DO:
FIND FIRST IS_mstr WHERE IS_status = ld_status NO-LOCK NO-ERROR.
IF AVAILABLE IS_mstr THEN  DO:
   FIND FIRST isd_det WHERE isd_status = is_status AND isd_tr_type = bd_tr_type NO-LOCK NO-ERROR.
   IF AVAILABLE isd_det THEN DO:
       succ = NO.

    MESSAGE bd_tr_type + " 被限制！" VIEW-AS ALERT-BOX ERROR.

       
       END.
    
   ELSE succ = YES.
END.
END.
  ELSE DO:
  FIND FIRST loc_mstr WHERE loc_site = bd_site AND loc_loc = bd_loc NO-LOCK NO-ERROR.
IF AVAILABLE loc_mstr THEN DO:
    FIND FIRST IS_mstr WHERE IS_status = loc_status NO-LOCK NO-ERROR.
    IF AVAILABLE IS_mstr THEN DO:
    
    FIND FIRST isd_det WHERE isd_status = is_status AND isd_tr_type = bd_tr_type NO-LOCK NO-ERROR.
   IF AVAILABLE isd_det THEN DO:
       succ = NO.

    MESSAGE bd_tr_type + " 被限制！" VIEW-AS ALERT-BOX ERROR.

       
       END.
    
   ELSE succ = YES.
    END.
    
    END.
      ELSE do:
          succ = NO.
          MESSAGE bd_site + ' ' + bd_loc + ' 无效库位!' VIEW-AS ALERT-BOX.
      END.
      END.


END.

            
            WHEN 'bd' THEN DO:
    
        FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ IF bd_data = 'in' THEN b_co_status = 'ac' ELSE IF bd_data = 'out' THEN (b_co_status = 'rct' AND b_co_site <> '' AND b_co_loc <> '') ELSE IF bd_data = 'potr' THEN (b_co_status = 'rct' AND b_co_ref <> '' AND b_co_ord <> ''  AND b_co_site <> '' AND b_co_loc <> '' )  ELSE 
            IF bd_data = 'rep' THEN (b_co_status = 'ac' OR b_co_status = 'issln') ELSE  b_co_status <> 'ia' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b_co_mstr THEN  DO:
                succ = NO.
MESSAGE bd_code " 无效条码或已发生该业务!" VIEW-AS ALERT-BOX.
            
            
            END.
        ELSE DO: 
            
            
            
            
            succ = YES.
        
                 
                 
                 
                 END.
        
        END.
            
    WHEN 'bd_match' THEN DO:

FIND FIRST b_co_mstr WHERE b_co_code = bd_code NO-LOCK NO-ERROR.
IF  AVAILABLE b_co_mstr THEN  DO:
      FIND FIRST iss_list WHERE iss_part = b_co_part AND IF bd_lotser <> '' THEN iss_lotser = bd_lotser ELSE YES AND IF bd_ref <> '' THEN iss_ref = bd_ref ELSE YES  AND IF bd_site <> '' THEN iss_site = bd_site ELSE YES NO-LOCK NO-ERROR.
      IF NOT AVAILABLE iss_list THEN DO:
          succ = NO.
IF bd_site = '' THEN MESSAGE "条码不在列表中！" VIEW-AS ALERT-BOX ERROR.
    ELSE MESSAGE "地点不匹配！" VIEW-AS ALERT-BOX ERROR.
          
          
          
          END.
ELSE succ = YES.
  END.


END.
    WHEN 'po_qty_diff' THEN DO:
        DEF VAR po_tol_qty AS DECIMAL.
        FIND FIRST poc_ctrl NO-LOCK NO-ERROR.
    FIND FIRST pod_det WHERE pod_nbr = bd_ord AND string(pod_line) = bd_line NO-LOCK NO-ERROR.
    IF AVAILABLE pod_det THEN DO:
       FIND FIRST b_co_mstr WHERE b_co_code = bd_code NO-LOCK NO-ERROR.
     po_tol_qty = (pod_qty_ord - pod_qty_rcvd) + (pod_qty_ord * poc_tol_pct / 100).
       IF b_co_qty_cur > po_tol_qty THEN DO:
        succ = NO.
        MESSAGE '收货数量已超过容差范围!' VIEW-AS ALERT-BOX.

       END.
       ELSE succ = YES.
        
        
        
        
        END.
        
        
        
        END.

 WHEN 'bd_exp' THEN DO:
/*IF LENGTH(bd_code) = 18 THEN DO:
    succ = NO.
   
    MESSAGE "条码不符合分解原则！" VIEW-AS ALERT-BOX ERROR.

END.
    ELSE DO:*/
    
FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ (b_co_status = 'ac' OR b_co_status = 'rct') NO-LOCK NO-ERROR.
IF  AVAILABLE b_co_mstr AND b_co_qty_cur > 1  THEN  succ = YES.

  ELSE DO:

      
          succ = NO.
          MESSAGE  bd_code " 条码不符合分解原则或无效!" VIEW-AS ALERT-BOX ERROR.


          
          
          
          END.

    /*END.*/

END.



WHEN 'bd_merge' THEN DO:
DEF VAR isfirst AS LOGICAL.
DEF VAR checkstr AS CHAR.
checkstr = ''.
isfirst = YES.
 succ = YES.
 FIND FIRST b_co_mstr WHERE b_co_code = bd_code  AND /*b_co_cntst = '' AND*/ (b_co_status = 'ac' OR b_co_status = 'rct') NO-LOCK NO-ERROR.
  IF AVAILABLE b_co_mstr THEN DO:
 
 FIND FIRST bd_merge_list NO-LOCK NO-ERROR.
      IF AVAILABLE bd_merge_list THEN DO:
    
        
           IF b_co_part = bd_merge_part  AND b_co_lot = bd_merge_lot AND b_co_ref = bd_merge_pack
                AND b_co_site = bd_merge_site AND b_co_loc = bd_merge_loc AND b_co_status = bd_merge_status
               AND b_co_ord = bd_merge_ord AND b_co_line = bd_merge_line AND b_co_vend = bd_merge_vend THEN DO:
               FIND FIRST bd_merge_list WHERE bd_merge_id = b_co_code NO-LOCK NO-ERROR.
               IF NOT AVAILABLE bd_merge_list THEN DO:
              
               succ = YES. 
               CREATE bd_merge_list.
               bd_merge_sess = g_sess.  
               bd_merge_id = b_co_code.
                 bd_merge_part = b_co_part.
                IF b_co_lot <> '' THEN  bd_merge_lot = b_co_lot.
                IF b_co_ser <> 0 THEN bd_merge_lot = string(b_co_ser).
                bd_merge_pack = b_co_ref.
                 bd_merge_qty = b_co_qty_cur.
                 bd_merge_site = b_co_site.
                 bd_merge_loc = b_co_loc.
                 bd_merge_status = b_co_status.
                 bd_merge_ord = b_co_ord.
                 bd_merge_line = b_co_line.
                 bd_merge_vend = b_co_vend.
               END.
               ELSE do: 
                   succ = NO.
                   MESSAGE b_co_code " 条码已存在合并列表！" VIEW-AS ALERT-BOX.
               END.
                   END.
           ELSE DO:
           
          succ = NO.
            MESSAGE b_co_code " 条码不符合合并原则！" VIEW-AS ALERT-BOX ERROR.
    
             END.
          
  END.
 ELSE DO:
     succ = YES. 
               CREATE bd_merge_list.
            bd_merge_sess = g_sess.  
                 bd_merge_id = b_co_code.
                 bd_merge_part = b_co_part.
                IF b_co_lot <> '' THEN  bd_merge_lot = b_co_lot.
                IF b_co_ser <> 0 THEN bd_merge_lot = string(b_co_ser).
                bd_merge_pack = b_co_ref.
                 bd_merge_qty = b_co_qty_cur.
                 bd_merge_site = b_co_site.
                 bd_merge_loc = b_co_loc.
                 bd_merge_status = b_co_status.
                 bd_merge_ord = b_co_ord.
                 bd_merge_line = b_co_line.
                 bd_merge_vend = b_co_vend.


 END.
  END.
  ELSE do:
      succ = NO.
      MESSAGE bd_code " 条码无效！" VIEW-AS ALERT-BOX.
  END.
  END.

    WHEN 'po' THEN DO:
    
        FIND FIRST po_mstr WHERE po_nbr = bd_ord AND po_stat = '' NO-LOCK NO-ERROR.
        IF NOT AVAILABLE po_mstr THEN DO:
        
            succ = NO.
MESSAGE "采购单已结或不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE do:
             FIND FIRST po_mstr WHERE po_nbr = bd_ord AND po_blank = '' NO-LOCK NO-ERROR.
            IF NOT AVAILABLE po_mstr THEN DO:
             succ = NO.
MESSAGE "采购单为总括单！" VIEW-AS ALERT-BOX ERROR.
                
                
                END.
          ELSE   succ = YES.
        
        END.
    END.
 
        WHEN 'pod' THEN DO:
    
        FIND FIRST pod_det WHERE pod_nbr = bd_ord AND string(pod_line) = bd_line AND pod_stat <> 'c' AND pod_type <> 'm'  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pod_det THEN DO:
        
            succ = NO.
MESSAGE "采购单行已结或不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE succ = YES.
        
        
        END.


          WHEN 'so' THEN DO:
    
        FIND FIRST so_mstr WHERE so_nbr = bd_ord NO-LOCK NO-ERROR.
        IF NOT AVAILABLE so_mstr THEN DO:
        
            succ = NO.
MESSAGE "销售订单不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
ELSE succ = YES.
        
        
    END.

        WHEN 'sod' THEN DO:
    
        FIND FIRST sod_det WHERE sod_nbr = bd_ord AND string(sod_line) = bd_line  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE sod_det THEN DO:
        
            succ = NO.
MESSAGE "销售订单行不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE succ = YES.
        
        
        END.
WHEN 'wo' THEN DO:
    
        FIND FIRST wo_mstr WHERE wo_nbr = bd_ord NO-LOCK NO-ERROR.
       IF NOT AVAILABLE wo_mstr THEN DO:
            succ = NO.
MESSAGE "加工单不存在！" VIEW-AS ALERT-BOX ERROR.
          
           
            END.
        
        ELSE succ = YES.
        
        
    END.

         WHEN 'woid' THEN DO:
    
        FIND FIRST wo_mstr WHERE wo_nbr = bd_ord AND wo_lot = bd_line  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE wo_mstr THEN DO:
        
            succ = NO.
MESSAGE "加工标识不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
ELSE succ = YES.
         END.



             WHEN 'prod_line' THEN DO:
    
        FIND FIRST ln_mstr WHERE ln_line = bd_line  NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ln_mstr THEN DO:
        
            succ = NO.
MESSAGE "生产线不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
        ELSE succ = YES.
        
        
        END.


             WHEN 'emp' THEN DO:
    
        FIND FIRST emp_mstr WHERE emp_addr = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE emp_mstr THEN DO:
        
            succ = NO.
MESSAGE "雇员不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        ELSE succ = YES.
        
        
        
        END.

  WHEN 'route' THEN DO:
    
        FIND FIRST ro_det WHERE ro_routing = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ro_det THEN DO:
        
            succ = NO.
MESSAGE "工艺流程不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE DO:
         FIND FIRST pt_mstr WHERE pt_part = bd_part AND pt_routing = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pt_mstr THEN DO:
        
            succ = NO.
MESSAGE "不是该物料工艺流程!" VIEW-AS ALERT-BOX ERROR.

            
            
            
            END.
           ELSE succ = YES.
           
           
           
           
           
           END.
           
           
          
        
        END.
            
         WHEN 'bom' THEN DO:
    
        FIND FIRST bom_mstr WHERE bom_parent = bd_data NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ro_det THEN DO:
        
            succ = NO.
MESSAGE "物料代码不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE do:
           
           FIND FIRST pt_mstr WHERE pt_part = bd_part AND pt_bom_code = bd_data NO-LOCK NO-ERROR.
           IF NOT AVAILABLE pt_mstr THEN DO:
          
           succ = NO.
           MESSAGE "不是该物料的BOM!" VIEW-AS ALERT-BOX ERROR.
            END.
        ELSE succ = YES.
       END.
        END.    



          WHEN 'op' THEN DO:
    
        FIND FIRST ro_det WHERE ro_routing = bd_data AND string(ro_op) = bd_op AND ro_milestone NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE ro_det THEN DO:
        
            succ = NO.
MESSAGE "不是最后工序" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
            
            
          WHEN 'shift' THEN DO:
    
        FIND FIRST shop_cal WHERE shop_site  = bd_data  NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE shop_cal THEN DO:
        
            succ = NO.
MESSAGE "班次不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    


          WHEN 'dep' THEN DO:
    
        FIND FIRST dpt_mstr WHERE dpt_dept  = bd_data  NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE dpt_mstr THEN DO:
        
            succ = NO.
MESSAGE "部门不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    


          WHEN 'wkctr' THEN DO:
    
        FIND FIRST wc_mstr WHERE wc_wkctr  = bd_data  NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE wc_mstr THEN DO:
        
            succ = NO.
MESSAGE "工作中心不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
            
              WHEN 'mch' THEN DO:
    
        FIND FIRST wc_mstr WHERE wc_wkctr  = bd_data  AND wc_mch = bd_mch NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE wc_mstr THEN DO:
        
            succ = NO.
MESSAGE "机器不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
        
        
        
              WHEN 'shipper' THEN DO:
    
        FIND FIRST abs_mstr WHERE abs_id  = bd_ord   NO-LOCK NO-ERROR.
        IF  NOT AVAILABLE abs_mstr THEN DO:
        
            succ = NO.
MESSAGE "备料单不存在！" VIEW-AS ALERT-BOX ERROR.
            
            END.
        
       ELSE succ = YES.
        
        
        END.    
        
        
        
  WHEN 'acct' THEN DO:

FIND FIRST ac_mstr WHERE ac_code = bd_data NO-LOCK NO-ERROR.
IF NOT AVAILABLE ac_mstr THEN DO:

    succ = NO.
    MESSAGE "无效账户！" VIEW-AS ALERT-BOX.
    
END.
ELSE succ = YES.


  END.
    WHEN 'po_rlse' THEN DO:
        DEF VAR rec1_qty AS INT.
          
           DEF VAR umconv1 AS INT.
           DEF VAR isok AS LOGICAL. 
           rec1_qty = 0.
            succ = YES.

        FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ (b_co_status = 'ac' OR b_co_status = 'iss')  NO-LOCK NO-ERROR.
         IF NOT AVAILABLE b_co_mstr THEN DO:
               MESSAGE bd_code ' 该条码已收货，或无效条码!' VIEW-AS ALERT-BOX.
             succ = NO.

         END.
         ELSE DO:
        IF b_co_vend <> '' AND bd_ord <> '' THEN DO:
  
  FIND FIRST po_mstr WHERE po_nbr =  bd_ord  AND po_vend = b_co_vend AND po_stat = '' NO-LOCK NO-ERROR.
     IF NOT AVAILABLE po_mstr THEN DO:
          succ = NO.
          MESSAGE b_co_part '该条码供应商不匹配，或订单已结，或关闭!' VIEW-AS ALERT-BOX.
          LEAVE.
     END.
  END.
FOR EACH scx_ref WHERE scx_shipfrom = b_co_vend AND scx_part = b_co_part AND (IF bd_ord <> '' THEN scx_order = bd_ord  ELSE YES),
    FIRST pod_det WHERE pod_nbr = scx_order AND pod_line = scx_line AND pod_stat = '',
    FIRST schd_det WHERE schd_type = 4 AND schd_nbr = pod_nbr AND schd_line = pod_line AND pod_curr_rlse_id[1] = schd_rlse_id AND schd_date = DATE(bd_data)   NO-LOCK:
     isok = YES.
    lntyp = STRING(pod_line).
   part = pod_nbr.
   FIND FIRST b_po_rec WHERE b_po_recdate = DATE(bd_data) AND b_po_ponbr = schd_nbr AND b_po_poln = STRING(schd_line) AND b_po_popart = pod_part NO-LOCK NO-ERROR.
    IF AVAILABLE b_po_rec THEN rec1_qty = b_po_recqty.
            ELSE rec1_qty = 0. 
   /* FOR EACH b_tr_hist WHERE b_tr_date = TODAY AND b_tr_type = 'rct-po' AND b_tr_nbr = pod_nbr AND b_tr_line = pod_line AND b_tr_part = pod_part    NO-LOCK:
  rec1_qty = rec1_qty + b_tr_qty_loc.
 END.*/
 FIND pt_mstr WHERE pt_part = b_co_part NO-LOCK NO-ERROR.
 FIND icc_ctrl NO-LOCK NO-ERROR.
 ASSIGN
            m_tol = IF pt_abc = 'a' THEN icc_tol_a% / 100
                    ELSE IF pt_abc = 'b' THEN icc_tol_b% / 100
                      ELSE IF pt_abc = 'c' THEN icc_tol_c% / 100
                            ELSE icc_tol_o% / 100 .
umconv1 = IF pod_um_conv <> 0 THEN pod_um_conv ELSE 1.
   qty = schd_discr_qty * umconv1 .
    IF b_co_qty_cur > (schd_discr_qty * umconv1 + round(schd_discr_qty * umconv1 * m_tol,0) - rec1_qty) THEN
 DO:
     MESSAGE b_co_part ' 数量超收!' VIEW-AS ALERT-BOX.
     succ = NO.
   
 END.
    
  
END.
    IF NOT isok THEN do:
        succ = NO.
        MESSAGE '无匹配订单，或订单已结，或关闭!' VIEW-AS ALERT-BOX.
    END.     
END.

    END.


WHEN 'po_rct' THEN DO:
    DEF VAR rec_qty AS INT.
    DEF VAR chk AS LOGICAL.
   DEF VAR umconv AS INT.
    rec_qty = 0.
    succ = YES.

chk = NO.
FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ (b_co_status = 'ac' OR b_co_status = 'iss')  NO-LOCK NO-ERROR.
 IF NOT AVAILABLE b_co_mstr THEN DO:
       MESSAGE bd_code ' 该条码已收货，或无效条码!' VIEW-AS ALERT-BOX.
     succ = NO.

 END.
 ELSE DO:

       
  IF b_co_vend <> '' AND bd_ord <> '' THEN DO:
  
  FIND FIRST po_mstr WHERE po_nbr = bd_ord AND po_vend = b_co_vend AND po_stat = ''  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE po_mstr THEN DO:
          succ = NO.
          MESSAGE b_co_part '该条码供应商不匹配，或订单已结，或关闭!' VIEW-AS ALERT-BOX.
          LEAVE.
     END.
  END.

  IF bd_data = 'qis' THEN DO:
FIND FIRST CODE_mstr WHERE CODE_fldname = 'qisqath' NO-LOCK NO-ERROR.
FIND FIRST po_mstr WHERE po_nbr = bd_ord AND po_stat = '' NO-LOCK NO-ERROR.  
IF AVAILABLE po_mstr THEN DO:

FIND FIRST bcqis WHERE qis_vend = po_vend AND qis_part = b_co_part AND qis_pass NO-LOCK NO-ERROR.
IF AVAILABLE bcqis THEN
   chk = YES.

IF NOT chk THEN DO:
    MESSAGE b_co_part '零件符合QIS标准!' VIEW-AS ALERT-BOX.
    succ = NO.
    LEAVE.
END.
END.
  ELSE DO:
     succ = NO.
          MESSAGE b_co_part '该条码供应商不匹配，或订单已结，或关闭!' VIEW-AS ALERT-BOX.
          LEAVE.
  END.
END.     
    FIND FIRST pod_det WHERE pod_nbr = (IF bd_ord <> '' THEN bd_ord ELSE b_co_ord) AND pod_part = b_co_part AND pod_status = '' NO-LOCK NO-ERROR.
IF NOT AVAILABLE pod_det THEN DO:
    MESSAGE b_co_part ' 零件不匹配，或订单已结，或关闭!' VIEW-AS ALERT-BOX.
    succ = NO.

END.

ELSE
DO:
    lntyp = STRING(pod_line).
   
    /* FOR EACH b_tr_hist WHERE b_tr_date = TODAY AND b_tr_type = 'rct-po' AND b_tr_nbr = pod_nbr AND b_tr_line = pod_line AND b_tr_part = pod_part    NO-LOCK:
  rec_qty = rec_qty + b_tr_qty_loc.
 END.*/
 FIND pt_mstr WHERE pt_part = b_co_part NO-LOCK NO-ERROR.
 FIND icc_ctrl NO-LOCK NO-ERROR.
 ASSIGN
            m_tol = IF pt_abc = 'a' THEN icc_tol_a% / 100
                    ELSE IF pt_abc = 'b' THEN icc_tol_b% / 100
                      ELSE IF pt_abc = 'c' THEN icc_tol_c% / 100
                            ELSE icc_tol_o% / 100 .
umconv = IF pod_um_conv <> 0 THEN pod_um_conv ELSE 1.
 FIND FIRST schd_det WHERE schd_type = 4 AND schd_nbr = pod_nbr AND schd_line = pod_line AND schd_rlse_id = pod_curr_rlse_id[1] AND schd_date = TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE schd_det THEN DO:
    issch = YES.
   
    FIND FIRST b_po_rec WHERE b_po_recdate = TODAY AND b_po_ponbr = schd_nbr AND b_po_poln = STRING(schd_line) AND b_po_popart = pod_part NO-LOCK NO-ERROR.
    IF AVAILABLE b_po_rec THEN rec_qty = b_po_recqty.
            ELSE rec_qty = 0.
 IF b_co_qty_cur > (schd_discr_qty * umconv + round(schd_discr_qty * umconv * m_tol,0) - rec_qty) THEN
 DO:
     MESSAGE b_co_part ' 数量超收!' VIEW-AS ALERT-BOX.
     succ = NO.
 END.
  qty = schd_discr_qty * umconv  /*- rec_qty*/.
    END.
    ELSE DO:
        issch = NO.
        FIND FIRST b_po_rec WHERE b_po_recdate = pod_due_date  AND b_po_ponbr = pod_nbr AND b_po_poln = STRING(pod_line) AND b_po_popart = pod_part NO-LOCK NO-ERROR.
    IF AVAILABLE b_po_rec THEN rec_qty = b_po_recqty.
            ELSE rec_qty = 0.
IF b_co_qty_cur > (pod_qty_ord * umconv + round(pod_qty_ord * umconv * m_tol,0) - rec_qty) THEN
 DO:
     MESSAGE b_co_part ' 数量超收!' VIEW-AS ALERT-BOX.
     succ = NO.
    END.
    qty = pod_qty_ord * umconv /*- rec_qty*/.
END.
 END.
  END.
END.

        


WHEN 'po_ret' THEN DO:
    
    succ = YES.

FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ b_co_status = 'rct' NO-LOCK NO-ERROR.
 IF NOT AVAILABLE b_co_mstr THEN DO:
      MESSAGE bd_code ' 已退货或无效条码!' VIEW-AS ALERT-BOX.
     succ = NO.

 END.
 ELSE DO:
    
FIND FIRST pod_det WHERE pod_nbr = bd_ord AND pod_part = b_co_part AND (pod_qty_rcvd - pod_qty_rtn >= b_co_qty_cur) NO-LOCK NO-ERROR.
IF NOT AVAILABLE pod_det THEN DO:
    MESSAGE b_co_part ' 零件不匹配,或退货数量超出!' VIEW-AS ALERT-BOX.
    succ = NO.

END.
ELSE DO:
      lntyp = STRING(pod_line).
      
END.
  END.
END.

WHEN 'so_all' THEN DO:
    
    succ = YES.

FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ b_co_status = 'rct'  NO-LOCK NO-ERROR.
 IF NOT AVAILABLE b_co_mstr THEN DO:
      MESSAGE bd_code ' 无效条码,或已备料!' VIEW-AS ALERT-BOX.
     succ = NO.

 END.
 ELSE DO:
FIND FIRST sod_det WHERE sod_nbr = bd_ord AND sod_part = b_co_part AND sod_site = b_co_site NO-LOCK NO-ERROR.
IF NOT AVAILABLE sod_det THEN DO:
    MESSAGE b_co_part ' 零件不匹配,或地点不匹配!' VIEW-AS ALERT-BOX.
    succ = NO.

END.
 END.
END.

WHEN 'so_iss' THEN DO:
    DEF VAR qty_iss AS DECIMAL.
    DEF VAR qty_all AS DECIMAL.
    succ = YES.

FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ IF bd_data <> '' THEN b_co_status = 'all' ELSE b_co_status = 'rct' NO-LOCK NO-ERROR.
 IF NOT AVAILABLE b_co_mstr THEN DO:
     MESSAGE bd_code ' 无效条码，或已发运!' VIEW-AS ALERT-BOX.
     succ = NO.

 END.
 ELSE DO:
    
FIND FIRST sod_det WHERE sod_nbr = bd_ord AND sod_part = b_co_part AND sod_site = b_co_site NO-LOCK NO-ERROR.
IF NOT AVAILABLE sod_det THEN DO:
    MESSAGE b_co_part ' 零件不匹配,或地点不匹配!' VIEW-AS ALERT-BOX.
    succ = NO.

END.
ELSE
DO:
    lntyp = STRING(sod_line).
    qty_iss = 0.
    qty = sod_qty_ord * IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1.
    
    
     FIND FIRST b_ex_sod WHERE b_ex_so = sod_nbr AND b_ex_soln = string(sod_line) EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ex_sod THEN qty_iss = b_ex_issqty + b_ex_all.
            ELSE qty_iss = 0.
   
        IF bd_data <> '' THEN DO:
            qty_all = 0.
            FOR EACH b_shp_wkfl USE-INDEX b_shp_sort WHERE b_shp_shipper = bd_data AND b_shp_so = sod_nbr AND b_shp_line = sod_line AND b_shp_status = '' NO-LOCK:
                qty_all = qty_all + b_shp_qty.
                END.
                qty_iss = qty_iss - qty_all.
        END.
            FOR EACH b_tr_hist WHERE b_tr_type = 'iss-so' AND b_tr_nbr = sod_nbr AND b_tr_line = sod_line AND b_tr_part = sod_part AND (b_tr_lot = '' OR b_tr_lot = ?) NO-LOCK:
                qty_iss = qty_iss + b_tr_qty_loc.
                END.
            IF b_co_qty_cur > sod_qty_ord * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1) - qty_iss  THEN DO:  
                MESSAGE b_co_part ' 数量超发!' VIEW-AS ALERT-BOX.
                  succ = NO.
                END.
    

END.

  END.
END.
        
      WHEN 'so_ret' THEN DO:
    
    succ = YES.

FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND /*b_co_cntst = '' AND*/ (b_co_status = 'iss' OR b_co_status = 'ac') NO-LOCK NO-ERROR.
 IF NOT AVAILABLE b_co_mstr THEN DO:
      MESSAGE bd_code ' 无效条码，或已退货!' VIEW-AS ALERT-BOX.
     succ = NO.

 END.
 ELSE DO:
    
FIND FIRST sod_det WHERE sod_nbr = bd_ord AND sod_part = b_co_part NO-LOCK NO-ERROR.
IF NOT AVAILABLE sod_det THEN DO:
    MESSAGE b_co_part ' 零件不匹配!' VIEW-AS ALERT-BOX.
    succ = NO.

END.
ELSE
DO:
    lntyp = STRING(sod_line).
      qty = sod_qty_ord * IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1.

END.

  END.
END.
        
    WHEN 'cnt_chk' THEN DO:
  DEF VAR mqty_oh AS DECIMAL.
  mqty_oh = 0.
succ = YES.



       FIND FIRST icc_ctrl NO-LOCK NO-ERROR.
       FIND FIRST pt_mstr WHERE pt_part = bd_part NO-LOCK NO-ERROR.
      FOR EACH b_ld_det WHERE b_ld_site = bd_site AND b_ld_loc = bd_loc AND b_ld_part = bd_part  AND b_ld_qty_oh <> 0 NO-LOCK:
     mqty_oh = mqty_oh + b_ld_qty_oh.
      END.
     ASSIGN
           m_tol = IF pt_abc = 'a' THEN min(round(icc_tol_a% / 100 * DECIMAL(mqty_oh),2),icc_tol_a)
                   ELSE IF pt_abc = 'b' THEN min(round(icc_tol_b% / 100 * DECIMAL(mqty_oh),2),icc_tol_b)
                     ELSE IF pt_abc = 'c' THEN min(round(icc_tol_c% / 100 * DECIMAL(mqty_oh),2),icc_tol_c)
                           ELSE min(round(icc_tol_o% / 100 * DECIMAL(mqty_oh),2),icc_tol_o) .
     /* MESSAGE m_tol VIEW-AS ALERT-BOX.
      MESSAGE bd_data VIEW-AS ALERT-BOX.
      MESSAGE bd_op VIEW-AS ALERT-BOX.*/
          
       IF decimal(bd_data) - DECIMAL(mqty_oh)  > m_tol THEN DO:
           succ = NO.
           MESSAGE  bd_site + ' ' + bd_loc + ' ' + bd_part ' 超过容差范围，请使用重盘!' VIEW-AS ALERT-BOX.
          
       END.




   


    END.



    WHEN 'part_rlse' THEN DO:
        FIND FIRST pod_det WHERE pod_nbr = bd_ord AND pod_part = bd_part NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pod_det THEN DO:

            succ = NO.
            MESSAGE  bd_ord ' 不包含 '  bd_part ' 零件!' VIEW-AS ALERT-BOX.
        END.
       ELSE DO:
           FIND FIRST schd_det WHERE schd_type = 4 AND schd_nbr = pod_nbr  AND schd_line = pod_line AND schd_rlse_id = pod_curr_rlse_id[1] AND schd_date = TODAY NO-LOCK NO-ERROR.
             ASSIGN
                 lntyp = STRING(pod_line)
                 qty = schd_discr_qty.
           
       END.


    END.



    WHEN 'bdcnt' THEN DO:

        FIND FIRST b_co_mstr WHERE b_co_code = bd_code AND b_co_status <> 'ia' AND
            (IF b_co_status = 'rct' OR b_co_status = 'all' OR (b_co_site <> '' AND b_co_loc <> '') THEN b_co_site = bd_site AND b_co_loc = bd_loc ELSE YES) AND IF bd_data = 'cntr_p' THEN b_co_cntst <> '' /*ELSE IF bd_data = 'rcnt' THEN b_co_cntst = 'i'*/ ELSE YES NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b_co_mstr THEN DO:
             succ = NO.
             MESSAGE bd_code ' 无效，或已作初盘，重盘,不属于该盘点库位!' VIEW-AS ALERT-BOX.
        END.

    END.









END CASE.
