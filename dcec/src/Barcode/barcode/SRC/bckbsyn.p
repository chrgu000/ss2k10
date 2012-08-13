{bcdeclre.i "new" "global"}
{mfdeclre.i}
   g_user = GLOBAL_userid .
DEF INPUT PARAMETER po AS LOGICAL.

DEF VAR bcid AS CHAR.

define  shared temp-table xkprhhist
             field xkprhnbr      as char format "x(8)"
             field xkprhponbr    as char format "x(8)"
             field xkprhline     as integer format ">,>>>,>>9"
             field xkprhpart     as char format "x(18)"
             field xkprhrctdate  as date format "99/99/99"
             field xkprheffdate  as date format "99/99/99"
             field xkprhqty      as decimal format ">>,>>9.99"
             field xkprhvend     as char format "x(8)"
             field xkprhdsite    as char format "x(8)"
             field xkprhdloc     as char format "x(18)"
             field xkprhssite    as char format "x(18)"
             field xkprhssloc    as char format "x(18)"       
             field xkprhinrcvd   as logical 
             field xkprhregion   as char format "x(8)"
             field xkprhkbid     as char format "x(20)"
             index  xkprhinrcvd xkprhinrcvd xkprhponbr xkprheffdate.
   

DEF TEMP-TABLE bc_prt_fail FIELD
    bc_prt_fail_id AS CHAR FORMAT "x(18)".


FOR EACH xkprhhist NO-LOCK:

  /*FIND FIRST xkprh_hist WHERE xkprh_hist.xkprh_nbr = xkprhhist.xkprhnbr AND xprh_hist.xprh_qty <> 0 NO-LOCK NO-ERROR.
   IF AVAILABLE xprh_hist THEN DO:*/
  IF po THEN do:
      RUN pobccr(INPUT xprhhist.xprhpart,INPUT xprhhist.xprhqty,INPUT xprhhist.xprhqty,INPUT '',INPUT '',OUTPUT bcid).
      FIND FIRST pod_det WHERE pod_nbr = xprhhist.xprhponbr AND pod_line = xprhhist.xprhline NO-LOCK NO-ERROR.
      RUN porec(INPUT xprhhist.xprhponbr,INPUT xprhhist.xprhline,INPUT pod_qty_ord ,INPUT bcid,INPUT xprhhist.xprhdsite,INPUT xprhhist.xprhdloc).
      END.
    ELSE DO:
     



    END.
 /*END.*/


END.
  OUTPUT TO c:\bc_fail_prt.txt.           
FOR EACH bc_prt_fail NO-LOCK:
    PUT SKIP.
    PUT bc_prt_fail_id.
END.
OUTPUT CLOSE.


PROCEDURE pobccr:
    DEF INPUT PARAMETER bc_part AS CHAR.
    DEF INPUT PARAMETER bc_qty AS DECIMAL.
    DEF INPUT PARAMETER bc_qty_std AS DECIMAL.
    DEF INPUT PARAMETER bc_lot AS CHAR.
    DEF INPUT PARAMETER bc_ref AS CHAR.
    DEF OUTPUT PARAMETER b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
               FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
               IF b_ct_nrm = '' THEN b_ct_nrm = 'seq'.
               IF b_ct_nrm = 'seq' THEN  DO:
                   m_fmt = 'seq'.
                   FIND LAST b_co_mstr WHERE b_co_format = 'seq'  NO-LOCK  NO-ERROR.
                   IF AVAILABLE b_co_mstr  THEN
                       IF b_co_code <> '999999999999999' THEN
                       b_id = string(integer(b_co_code) + 1 , "999999999999999").
                       ELSE DO:
                            MESSAGE '流水码已占满!' VIEW-AS ALERT-BOX.
                           LEAVE.
                       END.
                   ELSE b_id = '000000000000000'.
                   
                   

                   
                   
                   
                   
                   
                   END.
               ELSE
                   IF b_ct_nrm = 'ymd' THEN DO:
                       m_fmt = 'ymd'.
                       FIND LAST b_co_mstr WHERE b_co_format = 'ymd' AND b_co_code BEGINS SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99')
                         NO-LOCK  NO-ERROR.
                   IF AVAILABLE b_co_mstr  THEN
                       IF  SUBSTR(b_co_code,7,9) <> '999999999' THEN
                   b_id = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99')
                       + STRING(integer(SUBSTR(b_co_code,7,9)) + 1,"999999999").
                       ELSE DO:  
                      
                           MESSAGE '当日流水码已占满!' VIEW-AS ALERT-BOX.
                           LEAVE.
                       END.
                   ELSE b_id = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99')
                        + '000000000'.
                       
                       END.
                       bc_id = b_id.
                       DISP bc_id WITH FRAME bc.
                       CREATE b_co_mstr.
               ASSIGN 
                   b_co_code = b_id
                   b_co_part = bc_part
                   b_co_lot = bc_lot
                   b_co_ref = bc_ref
                   b_co_qty_ini = bc_qty
                   b_co_qty_cur = bc_qty
                   b_co_qty_std = bc_qty_std
                   b_co_um = 'ea'
                   b_co_status = 'actived'
                   b_co_format = m_fmt.


               
               {bcusrhist.i }
                   

 FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.
    IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '本系统暂不支持除了ipl,zpl类型的条码打印机!' VIEW-AS ALERT-BOX ERROR.
       CREATE bc_prt_fail.
       bc_prt_fail_id = b_id.
        LEAVE.
        END.
 OUTPUT TO VALUE(b_usr_printer).
  
 {bclabel.i "b_usr_prt_typ" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" }
     
     
     
     
     MESSAGE '打印完毕！' VIEW-AS ALERT-BOX INFORMATION. 
     
     
     
     
   
            
               END.




  PROCEDURE porec:
  DEF INPUT PARAMETER bc_po_nbr AS CHAR.
  DEF INPUT PARAMETER bc_po_line AS CHAR.
  DEF INPUT PARAMETER bc_po_qty AS CHAR.
  DEF INPUT PARAMETER bc_id AS CHAR.
   DEF INPUT PARAMETER bc_site AS CHAR.
   DEF INPUT PARAMETER bc_loc AS CHAR.
       FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
          b_co_status = 'received'.
          
           FIND FIRST b_ld_det WHERE b_ld_code = b_co_code AND b_ld_site = bc_site AND b_ld_loc = bc_loc  EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ld_det THEN 
               ASSIGN b_ld_qty_oh = b_co_qty_cur.
           ELSE DO:
           CREATE b_ld_det.
         b_ld_code = b_co_code.
         b_ld_loc = bc_loc.
         b_ld_site = bc_site.
         b_ld_part = b_co_part.
         b_ld_lot = b_co_lot.
         /*b_ld_ser = b_co_ser.*/
       /*  b_ld_ref = b_co_ref.*/
       
         b_ld_qty_oh = b_co_qty_cur.
           END.
         {bctrcr.i
         &ord=bc_po_nbr
         &mline=bc_po_line
         &b_code=b_co_code
         &b_part=b_co_part
         &b_lot=b_co_lot
         &b_ser=b_co_ser
         &b_qty_ord=bc_po_qty
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-po"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user}
           
             {bcusrhist.i }
      
      
      
      
        
     MESSAGE '条码同步更新完毕！' VIEW-AS ALERT-BOX INFORMATION. 
      
      
      
      
      
      
      
      
      
      
      END.
