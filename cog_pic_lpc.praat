# Román, Domingo y Flores, Nicolás
# 2023
# Laboratorio de Fonética USACH
# Julio 2023
# cog_pic_lpc.praat (v. 07)
# Script para Praat probado en la versión 6.3.12
# El código se encuentra disponible en...
# https://github.com/DomingoRomanMontesDeOca/analisisPraat/blob/main/cog_pic_lpc.praat
# o puede ser solicitado directamente a los creadores a sus correos electrónicos
# domingo.roman@usach.cl 
# nicolas.flores.n@usach.cl
###########################################################
# Este script es software libre: puede ser distribuido
# y/o modificado bajo los términos de la licencia
# GNU General Public License publicada por la Free Software
# Foundation, ya sea en su versión 3 o (según se prefiera)
# cualquier versión posterior.
# Este script se distribuye con la intención de que sea útil,
# pero SIN GARANTÍA ALGUNA; ni siquiera con la garantía
# implícita de COMERCIABILIDAD o de PROPIEDAD PARA UN FIN
# PARTICULAR. Más detalles pueden encontrarse en el texto de
# la GNU General Public License.
# El script debió haber sido distribuido con una copia de la
# GNU General Public License. Si no, este puede encontrarse en
# <http://www.gnu.org/licenses/>.
#
# Copyright 2023, Domingo Román y Nicolás Flores
#################################################
# Identifica el centro de gravedad en una ventana de 10 ms y el pico frecuencial...
# ... más alto en el análisis LPC en esa misma ventana

# Las cuatro líneas de  # Elección de directorios se pueden cambiar por unas que indiquen la ruta...
# ...precisa de los directorios

### directorio_origen$ es el directorio donde se encuentran los audios...
### ...con las oraciones

### directorio_destino$ es donde van los audios que ya fueron etiquetados...
### ...a este directorio van los audios y los TextGrid

### al mismo tiempo, los audios ya estiquetados se eliminan del directorio_origen$...
### ...Esto permite no duplicar trabajo ni tener que estar seleccionando...
### ...los audios para etiquetar. Todo audio que esté en directorio_origen$ debe ser etiquetado...
### ...y todo audio etiquetado estará en directorio_destino$ con su respectivo TextGrid (estos son audios con una sola frase)...
### ... en directorio_destino_audios_largos$ están los archivos .wav y TextGrid de los audios originales


# Elección de directorios
directorio_origen$ = chooseDirectory$: "Elije el directorio CON los audios"
directorio_destino$ = chooseDirectory$: "Elije el directorio PARA los audios procesados"
directorio_destino_audios_largos$ = chooseDirectory$: "Elije el directorio PARA los audios largos"
directorio_tablas$ = chooseDirectory$: "Elije el directorio PARA las tablas"


####################################



form enepicos
	real enepicos 5
endform


# Crea un string con todos los archivos .wav del directorio_origen$

strings1 = Create Strings as file list: "lista_audios", directorio_origen$ + "/*.wav"

select strings1

# Cuenta el número de archivos cuyos nombres están el el objeto strings1

ene_audios = Get number of strings


# Comando for global: En este comando 
#	se leen los archivos de origen
#	se almacena el nombre (sin ".wav)
#	se filtran entre 0 y 100 Hz
#	se amplifica su amplitud
#	se guarda en directorio de destino
#	se crea el TextGrid con etiquetaje automático y ...
#	... se permite editar junto con el audio para poner...
#	... el número de la frase (de "1" a "6")
#	se sustituyen las etiquetas que no son número
#	Extrae los segmentos marcados y crea un textGrid ahdoc
#	Propone una marca en el inicio de la oclusiva
#	Permite ajustar la posición de la marca
#	Crea la ventana de análisis y detecta el CoG y el pico más elevado del LPC
#	Guarda una tabla con id, sexo, la frase, los valores en Hz del CoG y del pico de LPC



for i to ene_audios	

	select Strings lista_audios

	audio$ = Get string... i

	nombre_audio$ = left$(audio$, 6)

	audio = Read from file... 'directorio_origen$'/'audio$'

	audio_filtrado = Filter (stop Hann band): 0, 100, 100

	audio_filtrado$ = selected$("Sound")

	Scale peak: 0.99

	select audio_filtrado

	Save as WAV file: "'directorio_destino_audios_largos$'/'nombre_audio$'.wav"

	tg = To TextGrid (silences): 75, 0, -38, 0.3, 0.1, "0", "Frase"

	ene_intervalos = Get number of intervals: 1

	select audio_filtrado
	plus tg

	View & Edit

	pauseScript: "Edite..."

# si la etiqueta es "0" o si la etiqueta es "Frase" se cambia a "F"

	select tg
	Replace interval texts: 1, 1, 0, "Frase", "F", "literals"
	Replace interval texts: 1, 1, 0, "0", "F", "literals"


# Guarda el TextGrid en el mismo directorio de los audios
# Este TextGrid permite obtener los valores relevantes

	Save as text file: "'directorio_destino_audios_largos$'/'nombre_audio$'.TextGrid"


# Cuenta los intervalos que tienen etiqueta diferente a "F"

	ene_no_F = Count intervals where: 1, "does not contain", "F"

# Crea una tabla provisoria con las etiquetas

	tabla_etiquetas = Create Table with column names: "table",ene_intervalos, { "etiq" }

#
	for iint to ene_intervalos
		select tg
		etiqueta$ = Get label of interval: 1, iint
		if etiqueta$ <> "F"
			select tabla_etiquetas
			Set string value: iint, "etiq", etiqueta$
			select tg
			tiempo_inicio_intervalo = Get start time of interval: 1, iint
			Insert boundary: 1, tiempo_inicio_intervalo - 0.3
			Remove boundary at time: 1, tiempo_inicio_intervalo
		endif
	endfor

	select tabla_etiquetas

	tabla_valida = Extract rows where column (text): "etiq", "is not equal to", ""
	select tabla_etiquetas
	Remove

	select tabla_valida

	select tg
	plus audio_filtrado

	Extract intervals where: 1, "no", "is not equal to", "F"

	seleccionados = numberOfSelected("Sound")

	objetos_en_vector# = selected#("Sound")

	for iobj to seleccionados
		objeto'iobj' = selected ("Sound", iobj)
	endfor

	for iobj to seleccionados
		select tabla_valida
		oracion$ = Get value: iobj, "etiq"
		select objeto'iobj'
		Rename: audio$+"_"+oracion$
		id$ = left$(audio$, 2)
		sexo$ = mid$(audio$,6,1)
		tg_2 = To TextGrid: "A", ""
		Insert boundary: 1, 0.31
		plus objeto'iobj'
		View & Edit
		pauseScript: "..."
		select tg_2
		tiempo_inicio_sonido = Get start time of interval: 1, 2
		fin_ventana = tiempo_inicio_sonido + 0.010
		select objeto'iobj'
		ventana = Extract part: tiempo_inicio_sonido, fin_ventana, "Hamming", 1, "no"

		fft_ventana = To Spectrum: "yes"
		cogravedad = Get centre of gravity: 2
		lpc_fft_ventana = LPC smoothing: enepicos, 50
		tier_picos = To SpectrumTier (peaks)
		tabla_picos = Down to Table
		pico_maximo_dB_Hz = Get maximum: "pow(dB/Hz)"
		tabla_con_pico_frecuencial = Extract rows where column (number): "pow(dB/Hz)", "equal to", pico_maximo_dB_Hz
		pico_frecuencial_Hz = Get value: 1, "freq(Hz)"
		tabla_con_data = Create Table with column names: "table", 1, { "id", "sexo", "tipoK", "pico", "CoG" }

		if oracion$ == "1" or oracion$ == "4"
			tipoK$ = "a"
		elif oracion$ == "2" or oracion$ == "5"
			tipoK$ = "e"
		elif oracion$ == "3" or oracion$ == "6"
			tipoK$ = "i"
		endif	
		
		Set string value: 1, "id", id$
		Set string value: 1, "sexo", sexo$
		Set string value: 1, "tipoK", tipoK$
		Set numeric value: 1, "pico", pico_frecuencial_Hz
		Set numeric value: 1, "CoG", cogravedad	

		Save as comma-separated file: "'directorio_tablas$'/'id$''sexo$''oracion$'.Table"
		select objeto'iobj'
		Save as WAV file: "'directorio_destino$'/'id$''sexo$''oracion$'.wav"

		select tg_2

		Save as text file: "'directorio_destino$'/'id$''sexo$''oracion$'.TextGrid"


		selectObject: objeto'iobj', tg_2, ventana, fft_ventana, tier_picos, tabla_picos, 
			...lpc_fft_ventana, tabla_con_pico_frecuencial, tabla_con_data
		Remove

	endfor

	deleteFile: "'directorio_origen$'/'audio$'"

	selectObject: audio, audio_filtrado, tg

	Remove
endfor
