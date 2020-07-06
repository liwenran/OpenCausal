import sys
import numpy as np

def extract_sequence():
    num_donor = 635
    region_list = [[] for i in range(num_donor)]
    fasta_sequence_dict = SeqIO.to_dict(SeqIO.parse(open('hg19.fa'), 'fasta'))
    file = open('variants.txt')
    count = 0
    for line in file:
        line = line.strip().split('\t')
        count += 1
        ref_seq = str(fasta_sequence_dict[line[0]].seq[int(line[1]):int(line[2])])
        for i in range(num_donor):
            if line[8+i]=='0/0':
                continue
            if line[8+i]=='1/1' or line[8+i]=='1/0' or line[8+i]=='0/1':
                var_pos = int(line[4])-int(line[1])
                var_seq = ref_seq[:var_pos]+line[7]+ref_seq[var_pos+len(line[6]):]
            elif line[8+i]=='./.':
                var_pos = int(line[4])-int(line[1])
                var_seq = ref_seq[:var_pos]+ref_seq[var_pos+len(line[6]):]
            else:
                print line[8+i]
            region_list[i].append('>'+'_'.join(line[:6])+'\n'+var_seq) #same for ref_seq
    file.close()

    for i in range(num_donor):
        fout = open('temp/var_seqs.donor'+str(i)+'.fa', 'w')
        fout.write('\n'.join(region_list[i]))
        fout.close()
    return
##
extract_sequence()

