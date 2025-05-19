
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smoch.gp

<!-- badges: start -->
<!-- badges: end -->

Class imbalance is a common issue in medical datasets and compromises
the performance of predictive models. Currently, over a hundred methods
have been proposed to address this limitation, with the Synthetic
Minority Over-sampling Technique and Synthetic Minority Over-sampling
Technique for Nominal and Continuous variables (SMOTE-NC) being the most
widely implemented over-sampling techniques in the medical domain.
However, none of the methods developed to date take into account the
heterogeneity of variables typically found in clinical data, which often
results in the generation of synthetic observations without biological
plausibility. The Synthetic Minority Over-sampling Convex Hull - Gower
Podani (SMOCH-GP) method was proposed to address this gap in the
literature.

By employing the Gower distance with the Podani modification, the method
ensures that the distances between observations are more reliable and
reflective of real-world similarities. This approach also guarantees
that the generation of new observations respects the nature of each
variable type. For instance, if a variable is quantitative discrete, the
resulting synthetic observations will also be integers rather than
continuous values—a common issue observed in other over-sampling
methods.

## Installation

You can install the development version of smoch.gp from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("beatrizlau1/smoch.gp")
```

## Example

This is a basic example which shows you how to apply to a imbalanced
dataset:

``` r
library(smoch.gp)
#> Loading required package: FD
#> Loading required package: ade4
#> Loading required package: ape
#> Loading required package: geometry
#> Loading required package: vegan
#> Loading required package: permute
#> 
#> Attaching package: 'permute'
#> The following object is masked from 'package:devtools':
#> 
#>     check
#> Loading required package: lattice
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following object is masked from 'package:ape':
#> 
#>     where
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
df <- data.frame(y=rep(as.factor(c('Yes', 'No')), times=c(90, 10)), x1=rnorm(100), x2=rnorm(100))
smoch.gp(y='y', x=c('x1','x2'), data=df, k=5, oversampling = 100, outlier = F)
#> $distances
#>            91         92        93         94        95         96         97
#> 91  0.0000000 0.22009032 0.4495292 0.28095764 0.1332181 0.22143145 0.23276762
#> 92  0.2200903 0.00000000 0.2822791 0.06086731 0.1154142 0.05418140 0.06551758
#> 93  0.4495292 0.28227913 0.0000000 0.28850725 0.3976934 0.22809773 0.21676156
#> 94  0.2809576 0.06086731 0.2885072 0.00000000 0.1477396 0.08664457 0.07463514
#> 95  0.1332181 0.11541422 0.3976934 0.14773958 0.0000000 0.16959563 0.18093180
#> 96  0.2214315 0.05418140 0.2280977 0.08664457 0.1695956 0.00000000 0.01200944
#> 97  0.2327676 0.06551758 0.2167616 0.07463514 0.1809318 0.01200944 0.00000000
#> 98  0.3740396 0.15394931 0.3044776 0.09308200 0.2408216 0.17972657 0.16771714
#> 99  0.3332474 0.16599739 0.1162817 0.17222550 0.2814116 0.11181598 0.10047981
#> 100 0.5264873 0.30639693 0.3573169 0.24552962 0.3932692 0.33217419 0.32016476
#>            98        99       100
#> 91  0.3740396 0.3332474 0.5264873
#> 92  0.1539493 0.1659974 0.3063969
#> 93  0.3044776 0.1162817 0.3573169
#> 94  0.0930820 0.1722255 0.2455296
#> 95  0.2408216 0.2814116 0.3932692
#> 96  0.1797266 0.1118160 0.3321742
#> 97  0.1677171 0.1004798 0.3201648
#> 98  0.0000000 0.1881959 0.1524476
#> 99  0.1881959 0.0000000 0.3233313
#> 100 0.1524476 0.3233313 0.0000000
#> 
#> $nearest_neighbors
#> $nearest_neighbors$`91`
#> [1] "95" "92" "96" "97" "94"
#> 
#> $nearest_neighbors$`92`
#> [1] "96" "94" "97" "95" "98"
#> 
#> $nearest_neighbors$`93`
#> [1] "99" "97" "96" "92" "94"
#> 
#> $nearest_neighbors$`94`
#> [1] "92" "97" "96" "98" "95"
#> 
#> $nearest_neighbors$`95`
#> [1] "92" "91" "94" "96" "97"
#> 
#> $nearest_neighbors$`96`
#> [1] "97" "92" "94" "99" "95"
#> 
#> $nearest_neighbors$`97`
#> [1] "96" "92" "94" "99" "98"
#> 
#> $nearest_neighbors$`98`
#> [1] "94"  "100" "92"  "97"  "96" 
#> 
#> $nearest_neighbors$`99`
#> [1] "97" "96" "93" "92" "94"
#> 
#> $nearest_neighbors$`100`
#> [1] "98" "94" "92" "97" "99"
#> 
#> 
#> $Newdata
#>       y           x1          x2
#> 1   Yes -1.101454787 -1.31995262
#> 2   Yes  1.105676917 -0.13801352
#> 3   Yes  0.579824168 -0.37645153
#> 4   Yes -0.095046982 -0.61849606
#> 5   Yes -0.956503937 -0.76423157
#> 6   Yes  0.086185651  0.04928959
#> 7   Yes -2.268071124 -0.54546180
#> 8   Yes -0.386244605 -0.54391834
#> 9   Yes -0.762848835  0.34767499
#> 10  Yes -0.624855121 -0.87858138
#> 11  Yes -0.019550603  0.12426712
#> 12  Yes -1.548125416 -0.19609640
#> 13  Yes  0.218074619 -1.54050089
#> 14  Yes -0.389773482  0.30233466
#> 15  Yes -0.984434646  1.42631033
#> 16  Yes  1.798581399 -0.55163228
#> 17  Yes  0.800168333  0.34350040
#> 18  Yes -0.105403763 -1.57083905
#> 19  Yes  0.357102222 -1.54351049
#> 20  Yes  0.342936180 -0.80575978
#> 21  Yes  0.518465510  0.08257558
#> 22  Yes  0.490599035 -0.18112886
#> 23  Yes  1.061517015 -0.16730245
#> 24  Yes -0.971086460 -0.41226050
#> 25  Yes -0.480735638 -0.04577509
#> 26  Yes  1.059719228  1.09696150
#> 27  Yes  0.441121710  1.00727790
#> 28  Yes  0.199362110 -1.42778630
#> 29  Yes  0.890639092 -2.19372949
#> 30  Yes -0.362063512 -0.71666195
#> 31  Yes  1.422871200  0.54229805
#> 32  Yes -1.441313421 -0.57912925
#> 33  Yes -0.347902581 -0.02902298
#> 34  Yes -1.982349489  0.20613308
#> 35  Yes  0.682557739  0.77282211
#> 36  Yes -0.479075762  0.61391083
#> 37  Yes -1.108113491  1.23813637
#> 38  Yes  1.687465803 -0.29237060
#> 39  Yes  2.119907046  0.17629560
#> 40  Yes -0.347790741  0.75587086
#> 41  Yes -1.798662800  0.44405440
#> 42  Yes  0.352575341 -0.87301428
#> 43  Yes -1.046764645 -0.20417727
#> 44  Yes  0.132951191  1.94461864
#> 45  Yes  1.521457560  0.97519145
#> 46  Yes -0.389792671  1.55729136
#> 47  Yes  0.476654465 -0.31785243
#> 48  Yes  0.051799275  0.63666251
#> 49  Yes  0.880273681  1.28057949
#> 50  Yes -0.447740977 -0.13164272
#> 51  Yes  0.786166634  0.24182638
#> 52  Yes  0.250280728  0.48780773
#> 53  Yes  2.638064531 -0.20770337
#> 54  Yes -0.049458993  0.08514156
#> 55  Yes  0.965826556  1.48099877
#> 56  Yes  0.245489280 -0.74135109
#> 57  Yes  0.985179054  0.20011315
#> 58  Yes -0.299387042 -0.44501651
#> 59  Yes  0.844085280  0.07263087
#> 60  Yes -1.363234576 -0.32079432
#> 61  Yes  0.393873200 -1.25261684
#> 62  Yes -0.688656062  1.68832728
#> 63  Yes -0.705745922 -0.64465143
#> 64  Yes -1.654271374 -1.93131497
#> 65  Yes -0.025183606 -0.10551533
#> 66  Yes  1.194987483  0.68911246
#> 67  Yes  1.170445760 -0.04677957
#> 68  Yes -0.993779616  0.35310238
#> 69  Yes -0.311461114 -1.33232550
#> 70  Yes  0.335476216  1.28417726
#> 71  Yes -1.535715001 -2.19620369
#> 72  Yes  0.760049345 -0.85047520
#> 73  Yes  0.004871873  2.03222990
#> 74  Yes  0.870172353 -1.14460955
#> 75  Yes -0.466050803  0.54946174
#> 76  Yes  0.238619236 -0.19757532
#> 77  Yes  0.506531054 -1.33563411
#> 78  Yes  1.712543191  0.38609433
#> 79  Yes -0.534360252  0.20491515
#> 80  Yes  0.085927882 -0.27686675
#> 81  Yes  1.252615128 -0.11712503
#> 82  Yes  1.324769999 -0.67108061
#> 83  Yes  0.209577591  0.58983422
#> 84  Yes -1.281870395  0.69255317
#> 85  Yes -1.275304870 -0.70228427
#> 86  Yes -1.012183486  0.59949353
#> 87  Yes  0.283420843 -1.48392087
#> 88  Yes -0.897947490 -0.30080397
#> 89  Yes  1.228475283 -1.69340053
#> 90  Yes  0.226574219  0.83423561
#> 91   No  0.118057029 -2.54736390
#> 92   No -0.118344133 -0.67886701
#> 93   No  1.157750098  0.66857919
#> 94   No -0.418521156 -0.41529217
#> 95   No -0.246037478 -1.65467977
#> 96   No  0.239381514 -0.54184785
#> 97   No  0.236369406 -0.42923063
#> 98   No -0.906408706 -0.04331239
#> 99   No  0.700071181  0.04020007
#> 100  No -1.824837987  0.43718990
#> 101  No  0.035019053 -0.68111158
#> 102  No -0.249559148 -0.68156615
#> 103  No -0.008602555 -0.41911870
#> 104  No -0.161805829 -0.47953641
#> 105  No  0.014148732 -0.94112090
#> 106  No  0.139937217 -0.74055850
#> 107  No -0.287552552 -0.34911965
#> 108  No -0.269548248 -0.37283295
#> 109  No  0.043315620 -0.48941640
#> 110  No -0.343281097 -0.26267154
```
