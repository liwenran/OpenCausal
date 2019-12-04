import numpy as np
import sys,os

def get_vardelta(tissue):
	#variants with delta-scores
	fpos = open('RE.bed')
	file = open('causal_score_'+tissue+'.txt')
	causal_var_dict = {}
	for scores in file:
		line = fpos.readline().strip().split('\t')
		scores = [i for i in scores.strip().split(' ') if i!='']
		causal_var_dict['\t'.join(line[:3])] = scores
	file.close()
	fpos.close()
	return causal_var_dict

def extract_x(tissue, lociname):
    #x:delta scores of variants
	file = open(lociname)
	fout = open('x/'+lociname+'.x','w')
	for line in file:
		line = line.strip().split('\t')
		scores = causal_var_dict['\t'.join(line[:3])]
		fout.write('\t'.join(scores)+'\n')
	fout.close()
	file.close()

def extract_y(tissue):
    #y:phenotype
	file = open('heights.txt')
	heights = {}
	for line in file:
		line = line.strip().split('\t')
		heights[line[0]] = line[1]
	file.close()

	file = open(tissue+'_index.txt')
	fout = open('y_heights.txt', 'w')
	for line in file:
		line = line.strip().split('\t')
		fout.write(heights[line[0]]+'\n')
	fout.close()
	file.close()

##MAIN
causal_var_dict = get_vardelta(tissue)
extract_x(tissue, lociname)



