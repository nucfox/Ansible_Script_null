#
##ssh\_keygen Roles
需要ansible hosts文件,定义inventory变量<br />
示例在inventory目录,ssh\_keygen文件<br />
ssh\_keygen\_private变量为yes,向目标推送私钥<br />
ssh\_keygen\_pub变量为yes,向目标推送公钥<br />

###生成密钥用于roles ssh\_keygen
ssh-keygen -t rsa -f ../roles/ssh\_keygen/files/id\_rsa<br />
###note:
密钥要生成在roles/ssh\_keygen/files目录下<br />
