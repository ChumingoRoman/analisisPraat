
# Lee las tablas de un directorio que tienen solo una fila de datos
# crea una tabla de cero filas para almacenar todos los datos
# En la tabla general, general agrega una fila por cada tabla simple y
# copia todos los datos de cada tabla específica a la tabla general
# crea un directorio especial para la tabla general
# La guarda con el nombre tabla_general

# Selecciona el directorio con las tablas
directorio_tablas$ = chooseDirectory$: "Elije el directorio con las tablas"


# Crea un string con todos los archivos .Table del directorio_tablas$
strings_tablas = Create Strings as file list: "lista_tablas", directorio_tablas$ + "/*.Table"
ene_tablas = Get number of strings
tabla_general = Create Table with column names: "table", 0, { "id", "sexo", "tipoK", "picoLPC", "CoG"}

for i to ene_tablas
	select Strings lista_tablas
	tabla$ = Get string... i
	tabla = Read Table from comma-separated file... 'directorio_tablas$'/'tabla$'
	id$ = Get value: 1, "id"
	sexo$ = Get value: 1, "sexo"
	tipoK$ = Get value: 1, "tipoK"
	pico = Get value: 1, "pico"
	cOg = Get value: 1, "CoG"
	select tabla_general
	Insert row: 1
	Set string value: 1, "id", id$
	Set string value: 1, "sexo", sexo$
	Set string value: 1, "tipoK", tipoK$
	Set numeric value: 1, "picoLPC", pico
	Set numeric value: 1, "CoG", cOg
	select tabla
	Remove
endfor


select tabla_general
ene_filas = Get number of rows

tabla_f = Extract rows where column (text): "sexo", "is equal to", "f"
nfilas_f = Get number of rows
select tabla_general
tabla_m  = Extract rows where column (text): "sexo", "is equal to", "m"
nfilas_m = Get number of rows
select tabla_general
tabla_a = Extract rows where column (text): "tipoK", "is equal to", "a"
nfilas_a = Get number of rows
select tabla_general
tabla_e = Extract rows where column (text): "tipoK", "is equal to", "e"
nfilas_e = Get number of rows
select tabla_general
tabla_i = Extract rows where column (text): "tipoK", "is equal to", "i"
nfilas_i = Get number of rows

select tabla_f
f_a  = Extract rows where column (text): "tipoK", "is equal to", "a"
nfilas_f_a  = Get number of rows
select tabla_f
f_e  = Extract rows where column (text): "tipoK", "is equal to", "e"
nfilas_f_e  = Get number of rows
select tabla_f
f_i  = Extract rows where column (text): "tipoK", "is equal to", "i"
nfilas_f_i  = Get number of rows

select tabla_m
m_a  = Extract rows where column (text): "tipoK", "is equal to", "a"
nfilas_m_a  = Get number of rows
select tabla_m
m_e  = Extract rows where column (text): "tipoK", "is equal to", "e"
nfilas_m_e  = Get number of rows
select tabla_m
m_i  = Extract rows where column (text): "tipoK", "is equal to", "i"
nfilas_m_i  = Get number of rows





createFolder("'directorio_tablas$'/tabla_general")

Save as comma-separated file: "'directorio_tablas$'/tabla_general/tabla_general.Table"

writeInfoLine: "Se ha creado la tabla general con ",ene_filas, " datos"

appendInfoLine: "Con /a/ : ", nfilas_a
appendInfoLine: "Con /e/ : ", nfilas_e
appendInfoLine: "Con /i/ : ", nfilas_i

appendInfoLine: "================================================"
appendInfoLine: "n de casos   |    a     |     e     |      i"
appendInfoLine: "             |    ",nfilas_a,"     |     ", nfilas_e,  "     |      ",nfilas_i


appendInfoLine: "================================================"
appendInfoLine: "n de casos   |    f     |      m"
appendInfoLine: "                  ",nfilas_f,"     |      ",nfilas_m

appendInfoLine: "================================================"
appendInfoLine: " Vocal   |  Sexo f   |   Sexo m"
appendInfoLine: "   a     |     ",nfilas_f_a,"     |      ",nfilas_m_a
appendInfoLine: "   e     |     ",nfilas_f_e,"     |      ",nfilas_m_e
appendInfoLine: "   i     |     ",nfilas_f_i,"     |      ",nfilas_m_i


selectObject: tabla_f, tabla_m, tabla_a, tabla_e, tabla_i, f_a, f_e, f_i, m_a, m_e, m_i
Remove
