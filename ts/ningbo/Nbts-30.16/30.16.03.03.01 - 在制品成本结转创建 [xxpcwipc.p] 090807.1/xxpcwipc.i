/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB
[090807.1]

¹²Ïí

[090807.1]

SS - 090807.1 - RNE */

DEFINE {1} SHARED TEMP-TABLE ttsp
   FIELD ttsp_site LIKE xxpcinb_site
   FIELD ttsp_part LIKE xxpcinb_part
   FIELD ttsp_qty LIKE xxpcinb_qty
   INDEX ttsp_site_part ttsp_site ttsp_part
   .

DEFINE {1} SHARED TEMP-TABLE ttwoc
   FIELD ttwoc_element LIKE xxpcwoc_element
   FIELD ttwoc_cst LIKE xxpcwoc_cst
   INDEX ttwoc_element ttwoc_element
   .

DEFINE {1} SHARED TEMP-TABLE ttwipc
   FIELD ttwipc_site LIKE xxpcwipc_site
   FIELD ttwipc_par LIKE xxpcwipc_par
   FIELD ttwipc_element LIKE xxpcwipc_element
   FIELD ttwipc_cst LIKE xxpcwipc_cst
   INDEX ttwipc_site_par_element ttwipc_site ttwipc_par ttwipc_element
   .
