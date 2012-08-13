
DEFINE TEMP-TABLE xx_prod
     FIELD xp_line LIKE pl_prod_line
    FIELD xp_desc LIKE pl_desc.

INPUT FROM E:\Client_Project\copper\product_line.txt .

REPEAT:
   CREATE xx_prod.
   IMPORT xx_prod .
END.

OUTPUT CLOSE .

OUTPUT TO E:\Client_Project\copper\prodline.cim .

PUT "@@batchload ppplmt.p" SKIP   .
FOR EACH xx_prod:
    
    EXPORT xp_line .
    EXPORT xp_desc  .
    PUT "-" SKIP. 
    PUT "-" SKIP. 
    PUT "-" SKIP. 
    PUT "-" SKIP. 
    PUT "-" SKIP. 
    PUT "-" SKIP. 
    PUT "-" SKIP. 
    PUT "." SKIP .
    PUT   "@@END"  SKIP . 
    PUT "@@batchload ppplmt.p" SKIP   .

END.
OUTPUT CLOSE .


