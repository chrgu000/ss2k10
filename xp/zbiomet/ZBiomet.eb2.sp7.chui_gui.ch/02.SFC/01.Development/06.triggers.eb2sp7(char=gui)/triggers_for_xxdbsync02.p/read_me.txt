wo_mstr / wr_route 因有异常字符,无法dump/load,
pod_Det 因BC用户的临时目录相同,同时dump/load的xxdbsync01.d会造成读写错误** Unable to open file: xxdbsync01.d.  Errno=13. (98)

create 的trigger全部取消,没必要,放在modify时操作即可,(而且比如wo_lot尚未赋值,就用做条件,肯定不对).


最终,全部取消dump/load方式,改用最原始的assign.
