#!/bin/bash
#
#SBATCH -p hpc-bio-ampere
#SBATCH --chdir=/home/alumno16
#SBATCH -J lab5-advanced
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=END
#SBATCH --mail-user=am.garciaserna@um.es

echo 'Ejecutamos archivo file-cut.sh en la cola ampere'
./file-cut.sh Sample[1-4].fastq

#exportamos variables de entorno para el make
export OMP_DIR=$SLURM_SUBMIT_DIR
export OMP_JOBID=$SLURM_JOBID

echo ${SLURMD_NODENAME} ${OMP_DIR} slurm-${OMP_JOBID}.out > parametros.txt
