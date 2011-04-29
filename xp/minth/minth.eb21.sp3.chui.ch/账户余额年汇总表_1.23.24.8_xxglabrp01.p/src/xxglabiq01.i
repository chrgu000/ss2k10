DEFINE {1} SHARED TEMP-TABLE tta6glabiq
    FIELD tta6glabiq_acc LIKE gltr_acc
    FIELD tta6glabiq_curr LIKE ac_curr
    FIELD tta6glabiq_beg LIKE gltr_amt
    FIELD tta6glabiq_dr LIKE gltr_amt
    FIELD tta6glabiq_cr LIKE gltr_amt
    FIELD tta6glabiq_end LIKE gltr_amt
    INDEX index1 IS UNIQUE tta6glabiq_acc tta6glabiq_curr
    INDEX index2 tta6glabiq_acc
    .