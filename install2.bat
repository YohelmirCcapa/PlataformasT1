echo Instalador de la base de datos Universidad
echo Autor: Yohelmir Ccapa Espinoza
echo 10 de agosto de 2022
sqlcmd -SYOHELMIRCP\SQLEXPRESS -E -i BDUniversidad.sql
sqlcmd -SYOHELMIRCP\SQLEXPRESS -E -i BDUniversidadPA.sql
sqlcmd -SYOHELMIRCP\SQLEXPRESS -E -i BDUniversidadPA2.sql
echo Se ejecuto correctamente la base de datos
pause