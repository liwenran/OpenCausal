import os,sys,gzip
import numpy as np


def get_delta_scores(filename):
    file = open(filename) #filename of riskloci
    delta_scores_dict = {}
    for line in file:
        line = line.strip().split('\t')
        delta_scores_dict['\t'.join(line[:8])] = line[9:]
    file.close()
    return delta_scores_dict

def ranking(filename):
    K = 10
    #WGS-based variants in each loci
    #ranking based on |beta*lamda|
    file = open(filename+'.lamda_donor_info')
    fbeta = open('beta_scores_var/'+filename+'.beta_scores_var')
    flamda= open('lamda_scores_var/'+filename+'.lamda_scores_var')
    var_new_stats = {}
    lamda_donor_info = {}
    for line in file:
        line = line.strip().split('\t')
        if np.sum(np.array(line[8:],dtype=int)!=0)>=K and np.sum(np.array(line[8:],dtype=int)==0)>0:
            beta = float(fbeta.readline().strip().split(' ')[-1])
            lamda = float(flamda.readline().strip().split(' ')[-1])
            var_new_stats['\t'.join(line[:8])] = np.abs(beta*lamda)
            lamda_donor_info['\t'.join(line[:8])] = line[8:]
    file.close()

    fout1 = open(filename+'.ranked','w')
    #fout2 = open(filename+'.delta_scores','w')
    sorted_var_new_stats = sorted(var_new_stats.items(), key=lambda d:d[1], reverse=True)
    for key in sorted_var_new_stats:
        fout1.write(key[0]+'\t'+str(key[1])+'\t'+'\t'.join(lamda_donor_info[key[0]])+'\n')
        #fout2.write(key[0]+'\t'+str(key[1])+'\t'+'\t'.join(delta_scores_dict[key[0]])+'\n')
    fout1.close()
    #fout2.close()
    return
  
