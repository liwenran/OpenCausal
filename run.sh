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
##-Predict RE-level GTEx_open_score based on REF&WGS (reference genome+whole-genome sequencing data)
#Generate RE_index for variants
cat REs.bed|awk 'BEGIN{OFS="\t";id=1}{print $1,$2,$3,id++}'> RE_index.bed 
bedtools intersect -a variants.txt -b RE_index.bed -f 0.99 -wa -wb|cut -f 13 > RE_idx #Only use top 9 columns of variants.txt
#Calculate RE-level open scores
#O_RE = O_RE_ref + sigma(O_var_WGS-O_var_REF)
matlab RE_level_opn_server.m


#Step 5: Delta score calculation
##-Calculate FoldChange between open scores predicted based on WGS and REF
matlab causal_delta_score.m


#Step 6: Prioritize causal variants
##-Fine-mapping analysis for a given loci
##(1)Split donors
python split_donors.py &
##(2)Calculate lamda scores (Given the info of riskloci as input)
python prepare_for_lamda.py &
matlab calculate_lamda.m
##(3)Calculate beta scores (Given the info of riskloci as input)
matlab calculate_beta.m
##(4)Prioritization and analysis
python prioritize.py &



