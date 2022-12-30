#!/bin/bash

#creamos variable con los nombres de los ficheros
#files=$(ls | find -type f -name '*.fastq')
files=$@

#creamos directorio para guardar los archivos cortados
mkdir fastas_cut

#creamos un bucle en el que cortamos los archivos, los renombramos y los movemos al directorio destino
for i in $files ; do
   split -n 16 $i fastas_cut/$i &
   varname=$i'aa'
   mv  fastas_cut/$varname  fastas_cut/$i
   mv fastas_cut/$i $i
done

#borramos todos los archivos creados
rm fastas_cut/*
rm fastas_cut -r
