import sys
import numpy as np

def IDs():
	ID_list = []
	file = open('temp/var_seqs.fa')
	for line in file:
		if line[0]!='>':
			continue
		line = line.strip().split('\t')
		ID_list.append('_'.join(line[:3]))
	file.close()
	return ID_list

def motifs():
	motif_dict = {}
	file = open('all_motif_rmdup')
	fout = open('motifs_col.txt', 'w')
	ind = 0
	for line in file:
		if '>'!=line[0]:
			continue
		line = line.split('\t')
		fout.write(line[1]+'\n')
		if line[1] not in motif_dict:
			motif_dict[line[1]] = ind
			ind += 1
	fout.close()
	file.close()
	return motif_dict

def TFs():
	motif_dict = motifs()
	TF_dict = {}
	file = open('motif-TF.txt')
	for line in file:
		line = line.strip().split('\t')
		if line[0] in motif_dict:
			if line[1] not in TF_dict:
				TF_dict[line[1]] = line[0]
			else:
				TF_dict[line[1]] += ' '+line[0]
	file.close()

	fout = open('TFs_col.txt', 'w')
	for tf in TF_dict:
		fout.write(tf+'\t'+TF_dict[tf]+'\n')
	fout.close()
	return TF_dict

def bind_dict():
	ID_list = IDs()
	TF_dict = TFs()
	RE_dict_score = {}
	RE_dict_count = {}
	file = open('find-out.txt')
	for line in file:
		line = line.strip().split('\t')
		if len(line)!=6 or line[0]=='PositionID':
			continue
		if (line[0],line[3]) not in RE_dict_score:
			RE_dict_score[(line[0],line[3])] = float(line[-1])
			RE_dict_count[(line[0],line[3])] = 1
		else:
			RE_dict_score[(line[0],line[3])] += float(line[-1])
			RE_dict_count[(line[0],line[3])] += 1
	file.close()

	fout = open('RE_binding_count','w')
	for ID in ID_list:
		for tf in TF_dict:
			c = 0
			for motif in TF_dict[tf].split(' '):
				if (ID, motif) in RE_dict_score:
					c += RE_dict_count[(ID, motif)]
			fout.write(str(c)+'\t')
		fout.write('\n')
	fout.close()
	return

##MAIN
bind_dict()


