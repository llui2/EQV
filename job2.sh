#!/bin/bash

# Job name:
#$ -N job-name

# Output log file:
#$ -o $JOB_NAME-$JOB_ID.log

# One needs to tell the queue system to use the current directory as the working directory
# Or else the script may fail as it will execute in your top level home directory /home/username
#$ -cwd
#$ -o output-$JOB_NAME-$JOB_ID.log
#$ -e error-$JOB_NAME-$JOB_ID.err

mkdir $TMPDIR/$JOB_NAME

# Now comes the commands to be executed
# Copy files to the local disk on the node
cp input.txt $TMPDIR/$JOB_NAME
cp -r quantum $TMPDIR/$JOB_NAME
cp -r r1279 $TMPDIR/$JOB_NAME

# Change to the execution directory
cd $TMPDIR/$JOB_NAME

# Compile the code
# SAMPLE
gfortran -c r1279/r1279.f90 r1279/ran2.f quantum/model.f quantum/metropolis.f
chmod +x metropolis.o model.o r1279.o ran2.o
gfortran metropolis.o model.o r1279.o ran2.o -o metropolis.out
# OBSERVABLE
gfortran -c r1279/r1279.f90 r1279/ran2.f quantum/model.f quantum/observables.f
chmod +x observables.o model.o r1279.o ran2.o
gfortran observables.o model.o r1279.o ran2.o -o observables.out

# Execute the code
./metropolis.out
./observables.out

# Finally, we copy back all important output to the working directory
scp -r results $SGE_O_WORKDIR/results-$JOB_NAME