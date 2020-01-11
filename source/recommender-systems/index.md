---
title: Recommender Systems(RS)
date: 2019-07-05 12:02:09
---

Recommender Systems (RS)

```
recommender systems
├── collaborative filtering
│   ├── model-based
│   └── neighborhood-based
│       ├── item-based
│       └── user-based
├── content-based
└── hybrid
    ├── loosely coupled
    └── tightly coupled
```

### Classic

#### Collaborative Filtering

##### Neighbor-based

ItemCF

SLIM

FISM

HOSLIM

##### Model-based

* SVD, Billsus D, Pazzani M J. Learning Collaborative Information Filters[J]. 1998. [[PDF](https://www.ics.uci.edu/~pazzani/Publications/MLC98.pdf)]
* FunkSVD (Latent Factor Model, LFM), S. Funk, "Netflix Update: Try This at Home," Dec. 2006; http://sifter.org/~simon/journal/20061211.html
* PMF, Salakhutdinov R . Probabilistic matrix factorization[C]// International Conference on Neural Information Processing Systems. Curran Associates Inc. 2007. [[PDF](https://papers.nips.cc/paper/3208-probabilistic-matrix-factorization.pdf)]
* BiasSVD, Koren Y et al . Matrix Factorization Techniques for Recommender Systems[J]. Computer, 2009, 42(8):30-37. [[PDF](http://www.columbia.edu/~jwp2128/Teaching/E4903/papers/ieeecomputer.pdf)]
* SVD++, Yehuda Koren. 2008. Factorization meets the neighborhood: a multifaceted collaborative filtering model. In *Proceedings of the 14th ACM SIGKDD international conference on Knowledge discovery and data mining* (KDD '08). ACM, New York, NY, USA, 426-434. DOI: https://doi.org/10.1145/1401890.1401944 
* Koren Y . Factor in the Neighbors: Scalable and Accurate Collaborative Filtering[J]. Acm Transactions on Knowledge Discovery from Data, 2010, 4(1):1-24. [[PDF](http://citeseer.ist.psu.edu/viewdoc/download;jsessionid=7D39AC8B65F13FAB6AEED8A64FFA13C8?doi=10.1.1.218.1675&rep=rep1&type=pdf)]
* timeSVD, Koren, Yehuda. Collaborative filtering with temporal dynamics[J]. Communications of the ACM, 2010, 53(4):89.

### Deep Learning based

CDAE

NCF

DMF

NAIS

DeepICF

JNCF

NGCF

NFM 

AFM

DeepFM

xDeepFM

### Industry

youtube dnn

wide&deep

Deep Interest Network (DIN)

Deep Interest Evolution Network (DIEN)

