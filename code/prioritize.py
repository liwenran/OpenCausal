import sys,gzip
import numpy as np

def get_loci_list():
	file = open('riskloci.bed')
	file.readline()
	loci_list = {}
	count = 0
	for line in file:
		line = line.strip().split('\t')
		count += 1
		loci_list[count] = (line[0], line[1], line[2], str(count))
	file.close()
	print len(loci_list)
	return loci_list

def get_vardelta_in_loci(loci, tissue):
	#variants with delta-scores
	chrom, start, end, ID = loci
	file = open('causal_score_'+tissue+'.txt')
	var_dict = {}
	for line in file:
		line = line.strip().split('\t')
		if line[3]=='chr'+chrom and int(line[4])>=int(start) and int(line[4])<=int(end):
			var_dict['\t'.join(line[:6])] = float(line[7])
	file.close()

	fout = open(loci, 'w')
	sorted_var_dict = sorted(var_dict.items(), key=lambda d:d[1], reverse=True)
	for key in sorted_var_dict:
		fout.write(key[0]+'\t'+str(key[1])+'\n')
	fout.close()
	return

##
tissue = 'Muscle'
loci_list = get_loci_list()
for loci in loci_list:
	get_vardelta_in_loci(loci_list[loci], tissue)
print 'Done'


