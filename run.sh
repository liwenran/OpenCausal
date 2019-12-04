#Step 1: Derive the variants located in REs
##-Format of vcf file:
##-chrom position REF VAR variant_type(0/0,0/1,./.)
bedtools intersect -a REs.bed -b {variants_file_name}.vcf -wa -wb > variants.txt


#Step 2: Derive the list of TFBS for each variant
##-Extract sequences
python extract_sequence.py &
##-Homer scan (.fa based on WGS or REF genome)
findMotifs.pl var_seqs.fa fasta homer-out -find all_motif_rmdup -p 16 > find-out.txt &
##-Generate binding matrix
python generate_binding_matrix.py &


#Step 3: Preprocessing for RNA-seq data
##-This shows an example of how we prepare GTEx expr data.
python preprocessing.py &


#Step 4: Predict open score
##-Training using paired ENCODE data
##-Predict open scores for GTEx samples
matlab predict.m


#Step 5: Delta score calculation
##-Calculate FoldChange between open scores predicted based on WGS and REF
matlab causal_delta_score.m


#Step 6: Prioritize causal variants
##-Fine-mapping analysis for a given loci
python prioritize.py &
##-Regress phenotype using delta scores of top-ranked variants
python analyze.py &
matlab analyze.m &


