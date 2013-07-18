/* a6cawkdt.i - CALCULATE NON-HOLIDAY DUE OR RELEASE DATE FOR GIVEN DATE       */
/*!
   {1} duedate
   {2} 1 = forwards   -1 = backwards
   {3} site
   {4} interval(saty_time qa_lt lt)
   {5} calculate mode (1/2)
*/



FOR FIRST shop_cal FIELDS (shop_site shop_wdays) WHERE shop_site  =  {3} AND shop_wkctr  =  "" AND shop_mch =  "" NO-LOCK : END.

IF  NOT  AVAILABLE  shop_cal THEN
    FOR FIRST  shop_cal FIELDS (shop_site shop_wdays) WHERE shop_site  = ""  AND  shop_wkctr = "" AND shop_mch = "" NO-LOCK: END .

IF  {1}  <>  ? AND  AVAILABLE  shop_cal  THEN  DO :

   ASSIGN i = 1 .

   IF {5} = "p" THEN DO :
    ASSIGN {1} = {1} + interval * {2} .
    REPEAT :
      IF ( NOT CAN-FIND ( hd_mstr WHERE  hd_site = shop_site AND hd_date = {1} )) AND shop_wdays[WEEKDAY ({1})] = YES THEN LEAVE .
      DO  WHILE  CAN-FIND ( hd_mstr WHERE  hd_site = shop_site AND hd_date = {1} ) OR  shop_wdays[WEEKDAY ({1})] = NO :
        {1} = {1} + {2}.
      END . /*DO  WHILE  CAN-FIND ( hd_mstr WHERE  hd_site = shop_site AND hd_date = {1} ) OR  shop_wdays[WEEKDAY ({1})] = NO :*/
    END. /*REPEAT :*/
   END. /*IF {5} = "1" THEN DO : */
   ELSE DO :
    REPEAT :
      IF i > interval THEN DO :
        ASSIGN {1} = {1} + interval * {2} .
        LEAVE .
      END. /*IF i > interval THEN DO :*/

      DO  WHILE  CAN-FIND ( hd_mstr WHERE  hd_site = shop_site AND hd_date = ( {1} - i) ) OR  shop_wdays[WEEKDAY ({1} - i )] = NO :
        ASSIGN interval = interval + 1  i = i + 1 .
      END . /*DO  WHILE  CAN-FIND ( hd_mstr WHERE  hd_site = shop_site AND hd_date = {1} ) OR  shop_wdays[WEEKDAY ({1})] = NO :*/
      ASSIGN i = i + 1 .
    END. /*REPEAT : */
   END. /*ELSE DO :*/

END . /*IF  {1}  <>  ? AND  AVAILABLE  shop_cal  THEN  DO :*/
