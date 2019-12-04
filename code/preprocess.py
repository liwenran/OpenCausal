import gzip

def GeneInfo():
	Genes = {}
	file = open('./data/hg19/EnsemblBuildV75.txt') #download from www.ensembl.org
	for line in file:
		line = line.split(',')
		Genes[line[0]] = line[5]
	print len(Genes)
	return Genes

def SampleInfo():
	file = open('matched_tissue.txt')
	matched_tissue = [line.strip() for line in file]
	file.close()

	Samples = {}
	file = open('GTEx_v7_Annotations_WGS_rnaseq.txt')
	file.readline()
	for line in file:
		line = line.split('\t')
		if line[5] in matched_tissue:
			Samples[line[0]] = line[5]
	file.close()
	return Samples

def expr():
	file = gzip.open('GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct.gz')
	file.readline()
	file.readline()

	fout = open('GTEx_rnaseq_names.txt', 'w')
	index = []
	i = 0
	for sname in file.readline().strip().split('\t'):
		if sname in Samples:
			index.append(i)
			fout.write(sname+'\t'+Samples[sname]+'\n')
		i += 1
	fout.close()
	print len(index)

	fout = open('GTEx_rnaseq.txt', 'w')
	for line in file:
		line = line.strip().split('\t')
		gene = line[0].split('.')[0]
		if gene in Genes:
			fout.write(Genes[gene]+'\t'+'\t'.join([line[i] for i in index])+'\n')
	fout.close()
	return

##MAIN
Genes = GeneInfo()
Samples = SampleInfo()
expr()

