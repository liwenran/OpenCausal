import os,sys,gzip
import numpy as np

def tissue_index_info():
    donorsID = open('GTEx_WGS_635Ind_PASSQC_donorID.txt').readline().strip().split('\t')[9:]
    file = open('donors_for_lamda.txt')
    samplesID = {}
    for line in file:
        line = line.strip().split('\t')
        samplesID[line[0]]=line[3]
    file.close()

    index = []
    selected_donors_emum = []
    num = 0
    for ID in donorsID:
        if ID in samplesID:
            index.append(num)
            selected_donors_emum.append(samplesID[ID])
        num += 1
    return index, selected_donors_emum

def vars_line_info(filename):
	file = open(filename+'.lamda_donor_info')
	vars_nline = {}
	count = 0
	for line in file:
		line = line.strip().split('\t')
		count += 1
		vars_nline['\t'.join(line[:8])] = str(count)
	file.close()
	return vars_nline

def extract_vars_for_each_donor(filename):
	file = open(filename+'.lamda_donor_info')
	donor_vars_list = [[] for i in range(len(selected_donors_emum))]
	for line in file:
		line = line.strip().split('\t')
		i = 0
		for t in line[8:]:
			if t!='0':
				donor_vars_list[i].append(line[:8])
			i += 1
	return donor_vars_list

def get_index_from_vardict(filename):
	donor_vars_list = extract_vars_for_each_donor(filename)
	vars_nline = vars_line_info(filename)

	donor_vars_nline = [{} for i in range(len(selected_donors_emum))]
	for i in range(len(selected_donors_emum)):
		file = open('var_binding_count.donor'+selected_donors_emum[i])
		count = 0
		nline = 0
		print len(donor_vars_list[i])
		for line in file:
			line = line.strip().split('\t')
			nline += 1
			if line[:8] in donor_vars_list[i]:
				count += 1
				donor_vars_nline[i]['\t'.join(line[:8])] = str(nline)
			if count==len(donor_vars_list[i]):
				break
		print i
		fout = open('temp/'+filename+'.lamda_donorvar_index.donor'+selected_donors_emum[i],'w')
		for var in donor_vars_nline[i]:
			fout.write(var+'\t'+donor_vars_nline[i][var]+'\t'+vars_nline[var]+'\n')
		fout.close()
	return

def match_var_to_RE(filename):
	file = open('RE_index_alldonors/'+filename+'.RE_index')
	RE_count_dict = {}
	count = 0
	for line in file:
		count += 1
		line = line.strip().split('\t')
		RE_count_dict['\t'.join(line[:3])] = str(count)
	file.close()

	file = open(filename+'.lamda_donor_info')
	fout = open(filename+'.match_RE_var', 'w')
	for line in file:
		line = line.strip().split('\t')
		fout.write('\t'.join(line[:8])+'\t'+RE_count_dict['\t'.join(line[:3])]+'\n')
	file.close()
	fout.close()
	return


##

index,selected_donors_emum = tissue_index_info()

filelist = os.listdir('riskloci/') #given the filenames of riskloci

NUM = 635 #total number of donors
for i in range(NUM):
    filename = filelist[i]
    index,selected_donors_emum = tissue_index_info()
    get_index_from_vardict(filename)
    match_var_to_RE(filename)
print 'Done'





