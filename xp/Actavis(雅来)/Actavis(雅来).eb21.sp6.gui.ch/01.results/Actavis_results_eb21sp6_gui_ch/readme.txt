

src_results内所有文件为必须文件,与client.*放在同一个文件夹即可,
gif_results内为相关操作截图.


重要说明:

如果出现这个138错误,要先维护table relationship!
** <file-name> record not on file. (138)

维护方式,见002_setup.gif
维护内容,见各程式用到的表的关系图见qad光盘内的entity_diagrams.pdf,
	例如:004_table_relationship.gif是cm_mstr和so_mstr的关系:
	cm_domain = so_domain and cm_addr = so_cust