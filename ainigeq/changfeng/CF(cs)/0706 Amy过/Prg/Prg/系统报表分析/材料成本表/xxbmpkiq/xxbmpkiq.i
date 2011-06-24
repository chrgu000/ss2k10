DEFINE {1} SHARED TEMP-TABLE tta6bmpkiq 
   field tta6bmpkiq_par_part like wo_part 
   FIELD tta6bmpkiq_part LIKE pk_part
   FIELD tta6bmpkiq_part_desc AS CHAR
   FIELD tta6bmpkiq_loc  AS CHAR
   FIELD tta6bmpkiq_qty LIKE pk_qty format "->>,>>>,>>>,>>9.9<<<<<<<<"
   FIELD tta6bmpkiq_um LIKE pt_um
   FIELD tta6bmpkiq_op as INTEGER format ">>>>>9"
   INDEX part tta6bmpkiq_par_part  tta6bmpkiq_part
   .
