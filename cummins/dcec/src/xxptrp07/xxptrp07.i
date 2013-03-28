/* ppptrp06.p - INVENTORY VALUATION REPORT AS OF DATE shared wkfl.           */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.              */

define {1} shared temp-table tmpld03
     fields t03_part like pt_mstr.pt_part
     fields t03_site like pt_mstr.pt_site
     fields t03_um   like pt_mstr.pt_um
     fields t03_qty  like ld_det.ld_qty_oh
     fields t03_cst  like sct_det.sct_cst_tot
     index t03_part_site is primary t03_part t03_site.
