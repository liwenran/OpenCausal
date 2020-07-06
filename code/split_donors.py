import sys,os
import random

def donors_info():
	file = open('heights.txt')
	height_info = {}
	sex_info = {}
	for line in file:
		line = line.strip().split('\t')
		height_info[line[0]] = line[1]
		if line[3]=='2':
			sex_info[line[0]] = '0'
		else:
			sex_info[line[0]] = '1'
	file.close()
	return height_info, sex_info

def donors_index():
	index_dict = {}
	file = open('Muscle_index.txt')
	for line in file:
		line = line.strip().split('\t')
		index_dict[line[0]] = line[1:]
	file.close()
	return index_dict

def random_split(k):
	height_info, sex_info = donors_info()
	index_dict = donors_index()

	donors = index_dict.keys()
	K = len(donors)/k #k-fold
	print K
	random.seed(K)
	random.shuffle(donors)
	fout1 = open('donors_for_beta.txt','w')
	fout2 = open('donors_for_lamda.txt','w')
	for donor in donors[:K]:
		fout1.write('\t'.join([donor,height_info[donor],sex_info[donor]]+index_dict[donor])+'\n')
	for donor in donors[K:]:
		fout2.write('\t'.join([donor,height_info[donor],sex_info[donor]]+index_dict[donor])+'\n')
	fout1.close()
	fout2.close()
	return
##
random_split(5)



