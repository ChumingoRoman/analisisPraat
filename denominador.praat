directorio_origen$ = chooseDirectory$: "Elije el directorio CON los audios"

createFolder("'directorio_origen$'/nuevos_audios")


# Crea un string con todos los archivos .wav del directorio_origen$

strings1 = Create Strings as file list: "lista_audios", directorio_origen$ + "/*.wav"

select strings1

# Cuenta el número de archivos cuyos nombres están el el objeto strings1

ene_audios = Get number of strings

for i to ene_audios
	select Strings lista_audios
	audio$ = Get string... i
	audio = Read from file... 'directorio_origen$'/'audio$'
	iniciales$ = left$(audio$, 3)
	sexo$ = mid$(audio$, 5,3)

	if sexo$ = "Fem"
		sexo2$ = "f"
	elif sexo$ = "Mas"
		sexo2$ = "m"
	else
		appendInfoLine: audio$, " raro en sexo"
	endif

	numero$ = string$(i)

	largo_numero = length(numero$)

	if largo_numero == 1
		primer_digito$ = "0"
	else
		primer_digito$ = ""
	endif

	bloqueId$ = primer_digito$ + numero$


	Save as WAV file: "'directorio_origen$'/nuevos_audios/'primer_digito$''numero$''iniciales$''sexo2$'.wav"

	select audio
	Remove
endfor


select strings1
Remove


writeInfoLine: "Se guardaron ", ene_audios," archivos."
