# OpenCausal
A method for scoring the cell-type specific impacts of non-coding variants in personal genomes 

# Ropen: predicting chromatin accessibility scores for GTEx samples
To train a sequence-based regression model, we collected paired RNA-seq and ATAC-seq data for 42 samples of 18 tissues from the ENCODE project. The chromatin accessibility scores are calculated from ATAC-seq data. Then, we use the model trained based on ENCODE samples to predict open scores for GTEx samples. The training and predicting process is implemented by running

```
matlab predict.m
```

# Calculating delta-scores for variants
Based on the Ropen model, we can predict the chromatin accessibility score of a given region using the TF expression and genomic sequence information as input, where the TF binding sites can be derived from the sequences of the reference genome, or alternatively, it can be learned from whole-genome sequencing data. We use the change of chromatin accessibility scores before and after SNP mutation to measure the influence of a variant on an RE. To quantify this influence, we define the absolute value of log fold change between chromatin accessibility scores calculated based on the reference genome (REF) and that calculated based on whole-genome sequencing (WGS) data as the causal score for the given region. 

```
matlab causal_delta_score.m
```

# Prioritization of causal variants
For a given risk SNP identified from GWAS summary data, we define the 200kb region centering at this SNP as a risk loci. Then, we define the variant causality score (VCS) for a variant in the risk loci by simultaneously considering the influence of variants on the chromatin accessibility of REs and the relationship between REs and the given trait. Finally, by ranking the variants in this risk loci according to their VCSs, we can prioritize putative causal variants for the GWAS trait. The prioritization is implemented by running

```
python prioritize.py &
```

# Installation
Download OpenCausal by
```shell
git clone https://github.com/liwenran/OpenCausal
```

# License
This project is licensed under the MIT License - see the LICENSE.md file for details
