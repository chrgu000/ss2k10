{bcdeclre.i}
DEF INPUT PARAMETER typ AS CHAR.
DEF INPUT PARAMETER ord AS CHAR.
DEF INPUT PARAMETER mLINE AS CHAR.
DEF OUTPUT PARAMETER part AS CHAR.
DEF OUTPUT PARAMETER mqty AS DECIMAL.
DEF OUTPUT PARAMETER mlntyp AS CHAR.

/*DEF SHARED  TEMP-TABLE iss_list
    FIELD iss_part AS CHAR
    FIELD iss_lotser AS CHAR
    FIELD iss_ref AS CHAR
    FIELD iss_um AS CHAR
    FIELD iss_mqty AS DECIMAL
FIELD iss_site AS CHAR
FIELD iss_loc AS CHAR.*/
part = ''.
mqty = 0.
mlntyp = ''.
FOR EACH iss_list:
    DELETE Iss_list.
END.
CASE typ:

    WHEN 'pod' THEN DO:
    FIND FIRST pod_det WHERE pod_nbr = ord AND string(pod_line) = mline NO-LOCK NO-ERROR.
    IF AVAILABLE pod_det THEN DO:
   
        ASSIGN part = pod_part
               mqty =  pod_mqty_ord  * pod_um_conv.
              mlntyp = pod_type.
               
    CREATE iss_list.
        iss_part = pod_part.
          iss_mqty = pod_mqty_ord  * pod_um_conv.
        
        END.
    END.
    
     WHEN 'sod' THEN DO:
    FIND FIRST sod_det WHERE sod_nbr = ord AND string(sod_line) = mline NO-LOCK NO-ERROR.
    IF AVAILABLE sod_det THEN DO:
   
        ASSIGN part = sod_part
                mqty = sod_mqty_ord * sod_um_conv.
        
        CREATE iss_list.
       iss_part = sod_part.
         iss_mqty = sod_mqty_ord  * sod_um_conv.

        
        END.
     END.
    
     WHEN 'wo' THEN DO:
    FIND FIRST wo_mstr WHERE wo_nbr = ord AND wo_lot = mline NO-LOCK NO-ERROR.
    IF AVAILABLE wo_mstr THEN 
        ASSIGN part = wo_part
                mqty = wo_mqty_ord.
        
        
        
        END.
    
    WHEN 'wod' THEN DO:
  FOR EACH wod_det WHERE wod_nbr = ord AND wod_lot = mline NO-LOCK :
  
   CREATE iss_list.
   iss_part = wod_part.
   iss_mqty = wod_bom_mqty * wod_mqty_req.
       
       
       
       END.



       END.

       WHEN 'shipper' THEN DO:
  FOR EACH ABS_mstr WHERE substr(abs_par_id,2,50) = ord   NO-LOCK :
  
   CREATE iss_list.
   iss_part = abs_item.
   iss_mqty = ABS_mqty * DECIMAL(ABS__qad03).
   iss_lotser = ABS_lot.
   iss_ref = ABS_ref.
   iss_site = ABS_site.
   iss_loc = ABS_loc.
   iss_um = 'ea'.    
       
       END.



       END.
    
    
    
    END CASE.
