
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
df <- data.frame(y=rep(as.factor(c('Yes', 'No')), times=c(90, 10)), x1=rnorm(100), x2=rnorm(100))
smoch = smoch.gp(y = 'y', data = df, k = 5, oversampling = 100, outlier = F)
```

## Output

This function gives:

- A new dataframe with both the original and synthetic observations is
  returned, allowing the user to easily review and work with it:

  ``` r
  smoch$Newdata
  #>       y          x1           x2
  #> 1   Yes  0.35602111  0.346023290
  #> 2   Yes  2.36116644  0.762430605
  #> 3   Yes  0.53956840  1.171268703
  #> 4   Yes  0.03744168 -0.195644831
  #> 5   Yes -0.94763726  0.152599292
  #> 6   Yes  0.08189585  0.420233757
  #> 7   Yes  0.76098820 -0.125146886
  #> 8   Yes  0.45739574 -0.741090523
  #> 9   Yes -1.62358379  0.444421398
  #> 10  Yes  1.56816777 -1.197495520
  #> 11  Yes -1.23782299 -0.302069619
  #> 12  Yes -0.93974538  0.183766064
  #> 13  Yes  0.07099557 -1.326241316
  #> 14  Yes -0.03390826 -1.626309837
  #> 15  Yes -0.32365994  0.025358182
  #> 16  Yes  0.49167465 -0.560280406
  #> 17  Yes  1.25199077  0.447483068
  #> 18  Yes  1.03023415  0.467279402
  #> 19  Yes -0.18355003  0.014893943
  #> 20  Yes  0.55648956  0.618944638
  #> 21  Yes  0.63013311  0.409964045
  #> 22  Yes -1.29512913 -1.645211745
  #> 23  Yes  0.13455095 -1.586809742
  #> 24  Yes -1.00785779  0.388782571
  #> 25  Yes -0.76375668  0.411063385
  #> 26  Yes  0.28448481  2.253958051
  #> 27  Yes  1.43907359  0.924224237
  #> 28  Yes -0.78136167 -1.530883312
  #> 29  Yes  1.14885572  0.344355718
  #> 30  Yes  0.34390366  0.907112104
  #> 31  Yes -0.30518977 -1.717447813
  #> 32  Yes -0.16649791  0.411422768
  #> 33  Yes -1.98437343 -0.520076963
  #> 34  Yes -1.12899766 -0.157890981
  #> 35  Yes  0.71607973  0.068674549
  #> 36  Yes -0.61295435  1.222405691
  #> 37  Yes -0.56458973 -2.195423260
  #> 38  Yes  0.88854290  0.831055530
  #> 39  Yes -1.73053817 -1.373716198
  #> 40  Yes -0.55589960  0.859790527
  #> 41  Yes  0.21382605  1.741045977
  #> 42  Yes  0.15743399 -0.508990353
  #> 43  Yes  0.86338186 -0.534295795
  #> 44  Yes -2.37480496 -1.522025038
  #> 45  Yes -0.69441619  1.469680030
  #> 46  Yes -0.47789868  0.056400948
  #> 47  Yes -1.21284156  1.158419980
  #> 48  Yes  1.06689363 -1.350593955
  #> 49  Yes -0.59340506 -1.071817688
  #> 50  Yes  1.31279620 -0.880514967
  #> 51  Yes -0.95285041 -0.893633303
  #> 52  Yes -0.98077845 -1.119230011
  #> 53  Yes -0.51017207  0.045500689
  #> 54  Yes -0.91329497  0.233182548
  #> 55  Yes -0.95353974 -1.474753226
  #> 56  Yes -0.66961164  0.216988145
  #> 57  Yes -0.52894660  0.917945923
  #> 58  Yes  0.18580161  0.002530448
  #> 59  Yes -0.20931002  0.612977687
  #> 60  Yes -0.64752739  2.967297772
  #> 61  Yes  1.57859995  0.943198378
  #> 62  Yes -0.25846720 -0.491958387
  #> 63  Yes -1.78169888 -0.205170330
  #> 64  Yes -0.58561382 -2.266807431
  #> 65  Yes -1.06728582 -0.026727637
  #> 66  Yes  1.09271425  0.258981735
  #> 67  Yes  0.48721739  0.950101104
  #> 68  Yes  1.97874590  0.966944654
  #> 69  Yes -1.14034398  1.448291659
  #> 70  Yes -0.86863826  1.330075538
  #> 71  Yes -0.62561212  0.806987805
  #> 72  Yes -2.43570644  0.664855152
  #> 73  Yes -0.52344658  1.069819508
  #> 74  Yes  0.47079047 -0.017036953
  #> 75  Yes -0.14260180 -0.341038015
  #> 76  Yes  0.85823082  0.498024626
  #> 77  Yes -2.37058930  0.499723125
  #> 78  Yes  0.11136990 -0.043975264
  #> 79  Yes  1.43405332  0.889542447
  #> 80  Yes -0.47491707 -1.069081766
  #> 81  Yes -0.01409819  0.263875288
  #> 82  Yes -0.32638925 -0.360295750
  #> 83  Yes -1.43982898  0.101701938
  #> 84  Yes -0.59857323 -0.184278460
  #> 85  Yes -0.86812569 -0.359725605
  #> 86  Yes  0.22768381  1.228675747
  #> 87  Yes  0.20498988  0.791845445
  #> 88  Yes  1.01638925 -0.296595346
  #> 89  Yes -0.36484088 -0.770725527
  #> 90  Yes  0.75287507 -0.753364056
  #> 91   No  0.21768027 -1.017560493
  #> 92   No  0.55266385 -0.091747449
  #> 93   No  0.45842561 -2.427252167
  #> 94   No -0.46297335 -0.464748052
  #> 95   No -0.59419664  0.115476320
  #> 96   No -0.10223777 -0.206560859
  #> 97   No -1.26796446 -1.837149779
  #> 98   No  0.55130555  0.154515819
  #> 99   No -0.16266076  0.511768008
  #> 100  No -0.73558616 -0.079851485
  #> 101  No  0.12975988 -0.611506546
  #> 102  No -0.00285481 -0.277556576
  #> 103  No -0.08113878 -0.873761246
  #> 104  No -0.21447261 -0.199657827
  #> 105  No -0.06068389 -0.011591367
  #> 106  No -0.34256493  0.011980169
  #> 107  No -0.41517903 -0.524371361
  #> 108  No  0.09092143 -0.094529194
  #> 109  No -0.44082283 -0.072935588
  #> 110  No -0.11234018 -0.011166650
  ```

- A new data frame containing only the synthetic observations generated,
  making it easier to assess and study them:

  ``` r
  smoch$Synthetic_obs
  #>             x1          x2  y
  #> 1   0.12975988 -0.61150655 No
  #> 2  -0.00285481 -0.27755658 No
  #> 3  -0.08113878 -0.87376125 No
  #> 4  -0.21447261 -0.19965783 No
  #> 5  -0.06068389 -0.01159137 No
  #> 6  -0.34256493  0.01198017 No
  #> 7  -0.41517903 -0.52437136 No
  #> 8   0.09092143 -0.09452919 No
  #> 9  -0.44082283 -0.07293559 No
  #> 10 -0.11234018 -0.01116665 No
  ```

- Lastly, the function also presents information about the class
  imbalance problem in the dataset, along with the user-defined input
  parameters, making it easier and more transparent to share details of
  the procedure with peers:

  ``` r
  smoch$SMOCH_GP_info
  #> [1] "The present dataset has 100 observation, of which 10 belong to the minority class. The problem is a binary classification task, with an imbalance ratio of 9.  The value of k used for the K-nearest neighbours was 5 and the over-sampling percentage applied was 100%, corresponding to 12% of the maximum over-sampling percentage possible. Lastly outlier amplitude was not used."
  ```
