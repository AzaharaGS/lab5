directorio_pacioli=~/pacioli
parametros_pacioli=~/pacioli/parametros.txt
directorio_ampere=$(patsubst %/pacioli,%/ampere, $(directorio_pacioli))
parametros_ampere=$(patsubst %/pacioli/parametros.txt, %/ampere/parametros.txt, $(parametros_pacioli))
directorio_lejeune=$(patsubst %/pacioli, %/lejeune, $(directorio_pacioli))
parametros_lejeune=$(patsubst %/pacioli/parametros.txt, %/lejeune/parametros.txt, $(parametros_pacioli))

archivo=kmer-solution_alumno16.ipynb
archivo_slurm=file-cut.sh
cola=pacioli


#nodo_trabajo=$(shell cat $(parametros) | cut -d ' ' -f 1)
ifeq ($(cola),pacioli)
directorio=$(shell cat $(parametros_pacioli) | cut -d ' ' -f 2)
id=$(shell cat $(parametros_pacioli) | cut -d ' ' -f 3)
else ifeq  ($(cola),ampere)
directorio=$(shell cat $(parametros_ampere) | cut -d ' ' -f 2)
id=$(shell cat $(parametros_ampere) | cut -d ' ' -f 3)
else ifeq  ($(cola),lejeune)
directorio=$(shell cat $(parametros_lejeune) | cut -d ' ' -f 2)
id=$(shell cat $(parametros_lejeune) | cut -d ' ' -f 3)
else
echo 'No se enctró el archivo'
endif


archivo_copiar?=$(id)


.PHONY : ayuda
ayuda :
	@echo 'Este programa está diseñado para el envío de trabajos a los nodos del cluster y la recuperación de los archivos.'
	@echo 'Por defecto, el programa manda el archivo a la cola de pacioli. Si desea enviarlo a otra cola, especifique la cola en el argumento -cola-'
	@echo 'Indique el archivo que desea lanzar a ejecución con el argumento -archivo- y con el argumento -archivo_slurm- el archivo que contiene las instrucciones para el gestor de colas.'
	@echo "cola_pacioli : envía el archivo indicado a ejecutarse en la cola de pacioli."
	@echo "cola_ampere : envía el archivo indicado.ipynb a ejecutarse en la cola de ampere."
	@echo "cola_lejeune : envía el archivo indicado a ejecutarse en la cola de lejeune."
	@echo "copiar : copia el output generado por slurm del nodo de trabajo selecionado al directorio actual."


.PHONY : cola_pacioli
cola_pacioli : $(archivo_slurm) $(archivo)
	cp $^ $(directorio_pacioli)/.
	sbatch $<

.PHONY : cola_ampere
cola_ampere : $(archivo_slurm) $(archivo)
	cp $^ $(directorio_ampere)/.
	sbatch $<

.PHONY : cola_lejeune
cola_lejeune : $(archivo_slurm) $(archivo)
	cp $^ $(directorio_lejeune)/.
	sbatch $<



.PHONY : copiar
copiar :
ifeq ($(cola),pacioli)
	cp $(directorio_pacioli)/$(id) $(directorio_ampere)/$(archivo_copiar) $(directorio)/.
else ifeq  ($(cola),ampere)
	cp $(directorio_ampere)/$(id) $(directorio_ampere)/$(archivo_copiar)  $(directorio)/.
else ifeq  ($(cola),lejeune)
	cp $(directorio_lejeune)/$(id) $(directorio_ampere)/$(archivo_copiar)  $(directorio)/.
else
	@echo 'nada'
endif

.PHONY : clear
clear :
ifeq ($(cola),pacioli)
	rm $(directorio_pacioli)/parametros.txt
else ifeq  ($(cola),ampere)
	rm $(directorio_ampere)/parametros.txt
else ifeq  ($(cola),lejeune)
	rm $(directorio_lejeune)/parametros.txt
else
        @echo 'nada'
endif
