{mfdeclre.i}
{gplabel.i}


    DEF INPUT PARAMETER cim_case AS CHAR.
   /* DEF INPUT PARAMETER curr_btrid LIKE b_tr_id.*/
   DEF SHARED TEMP-TABLE btrid_tmp
        FIELD btrid LIKE b_tr_id.
  
   FOR EACH btrid_tmp:
       DELETE btrid_tmp.
   END.
    CASE cim_case:
  
    WHEN 'poporc'DO:
  
   {bcrun.i ""bcmgwrfl01.p""}
    
    
    
    END.


WHEN 'iclotr02' DO:
  
    
    {bcrun.i ""bcmgwrfl02.p""}

    
    END.

WHEN 'icunis'DO:
  
     {bcrun.i ""bcmgwrfl03.p""}
    
    
    
    END.


    WHEN 'icunrc'DO:
  
     {bcrun.i ""bcmgwrfl04.p""}
    
    
    END.
  END CASE.

   
