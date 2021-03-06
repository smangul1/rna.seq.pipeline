. /u/local/Modules/default/init/modules.sh
module load python/anaconda3

ls */quant.sf | awk -F "/quant.sf" '{print $1}' >samples.txt

mkdir gene_matrices

while read line
do

echo "python generate_gene_matrix.py ${line}/quant.sf ${line}" >run.generate.gene.matrix.${line}.sh

chmod u+x run.generate.gene.matrix.${line}.sh

qsub -cwd -V -N generate_gene_matrix -l h_data=16G,highp,time=24:00:00 run.generate.gene.matrix.${line}.sh

done<samples.txt

# run this file first in same level as salmon output directories. It will go inside each directory and generate a gene matrix csv for each quant file. 
# the individual gene matrices will be located inside the directory called gene_matrices
# Then run the master.merge.gene.matrices.sh script in the same location as this script to merge the csv files into one complete gene matrix.
# The final merged csv file gene matrix will be located inside of gene_matrices and called merged_gene_matrix.csv