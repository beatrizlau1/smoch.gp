
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
smoch.gp(y = 'y', data = df, k = 5, oversampling = 100, outlier = F)
#> $Newdata
#>       y            x1          x2
#> 1   Yes  0.2240643804 -0.07685497
#> 2   Yes  0.7900997639  0.41933112
#> 3   Yes  1.2261821322 -0.92653710
#> 4   Yes  1.2135571537 -0.58555565
#> 5   Yes -0.1708002248  0.84266013
#> 6   Yes  1.9578962317  0.66153773
#> 7   Yes -1.9781017553  0.97436808
#> 8   Yes  0.4557649943  0.18708139
#> 9   Yes  0.5296708979 -0.43631668
#> 10  Yes -0.6633828727 -0.55812641
#> 11  Yes -1.5804844338 -0.12059488
#> 12  Yes  0.8400533361  0.11054539
#> 13  Yes -0.5557125912 -1.64354391
#> 14  Yes  0.6772463114  0.71347808
#> 15  Yes  1.2967266817 -0.71787302
#> 16  Yes  1.1879861821 -0.83727045
#> 17  Yes  0.4735928693 -0.24077794
#> 18  Yes  0.6836267765 -0.12798936
#> 19  Yes  0.4174204907 -0.41911662
#> 20  Yes -1.3828207665  0.36120430
#> 21  Yes -3.1433602279 -0.55532496
#> 22  Yes -0.1758920214  0.20379944
#> 23  Yes -0.1318262788  0.48465324
#> 24  Yes  1.5058228117  1.43675588
#> 25  Yes -0.0202292144  0.24878473
#> 26  Yes -0.8335280083  0.49586054
#> 27  Yes  0.0956465489 -0.54094976
#> 28  Yes  0.2643397885 -0.98231773
#> 29  Yes -1.0678095280 -1.62474873
#> 30  Yes -0.1291722173  0.78367598
#> 31  Yes -1.4431731191  0.60525839
#> 32  Yes -0.9779350102  0.65182205
#> 33  Yes -0.7989114584  1.00930029
#> 34  Yes  1.2746805995 -1.17315786
#> 35  Yes -1.6193823419 -1.11499560
#> 36  Yes -0.4730154431 -0.44192492
#> 37  Yes  0.0348412450  0.51905070
#> 38  Yes -0.0008529178 -1.25194545
#> 39  Yes -0.0777179219  1.00282227
#> 40  Yes  0.5316580146  0.92403044
#> 41  Yes  0.5217683548  1.97951999
#> 42  Yes  0.1512377943 -0.52914278
#> 43  Yes  1.0177055615  3.06519499
#> 44  Yes -1.4217847815  0.79566929
#> 45  Yes  3.1528269222  0.62018020
#> 46  Yes  0.3405313060  0.03905988
#> 47  Yes -1.2308805743  0.27242716
#> 48  Yes  0.2811509290  1.91879168
#> 49  Yes -1.9391518740 -0.35886287
#> 50  Yes -1.1169418691 -0.42593037
#> 51  Yes  0.9581055843 -1.13985349
#> 52  Yes  0.5042325419 -1.49787811
#> 53  Yes -1.1791039485  0.36687137
#> 54  Yes -0.4590559285 -1.92894773
#> 55  Yes -0.2736136435 -0.45073880
#> 56  Yes  0.2094246374  1.06820588
#> 57  Yes -0.3429802012  1.48104000
#> 58  Yes  0.0141277496 -1.39315857
#> 59  Yes  1.5681357903  0.47122821
#> 60  Yes  0.6544238505 -0.77030792
#> 61  Yes  0.0683716491  0.06575659
#> 62  Yes  1.1956834359 -0.81132986
#> 63  Yes -0.3912708498 -0.81260191
#> 64  Yes  1.2716524587 -1.06130178
#> 65  Yes -1.5854986609  3.28092695
#> 66  Yes -0.8519970948  1.61494981
#> 67  Yes -0.1005845323  1.30209734
#> 68  Yes -0.1646459963 -1.07631750
#> 69  Yes -0.4332999472 -1.59632244
#> 70  Yes -0.7685193841  0.50472961
#> 71  Yes -1.1164152117 -1.18330612
#> 72  Yes -1.3200326973  0.27673970
#> 73  Yes  1.6994091686  0.05122798
#> 74  Yes -0.1771238190  0.96347979
#> 75  Yes  0.9117750370  1.67368265
#> 76  Yes -0.0782612564  0.99075786
#> 77  Yes -1.5670794649  1.20237241
#> 78  Yes  1.4477989564 -0.81883972
#> 79  Yes  0.0666531865 -1.25305339
#> 80  Yes  0.6871398452  0.50752271
#> 81  Yes  0.4450470390 -0.79977552
#> 82  Yes -1.4418725370  0.90669578
#> 83  Yes  1.6974861499  1.31716575
#> 84  Yes -1.5472048968 -1.60883802
#> 85  Yes -0.7451366666  0.61962236
#> 86  Yes -0.8226511821  1.42264547
#> 87  Yes  1.0311399125 -0.52403382
#> 88  Yes  0.1181350365  0.10893686
#> 89  Yes  0.7585239030  2.53149171
#> 90  Yes -1.6337620331 -1.13110518
#> 91   No -0.5988721327 -1.29276122
#> 92   No  0.1778822897  0.01160715
#> 93   No -2.0056969858 -1.15461634
#> 94   No  0.3944718063 -1.12936906
#> 95   No  0.1642702616 -0.21775034
#> 96   No -1.0365428117  0.82717684
#> 97   No  1.4946889572  0.96132075
#> 98   No  0.3946028931  0.58721712
#> 99   No  2.2731175500 -0.10690569
#> 100  No -0.0933054140 -0.25897378
#> 101  No -0.4761663671 -0.50757650
#> 102  No  0.4077054281 -0.44691927
#> 103  No -0.1758186682 -0.60658031
#> 104  No -0.3264264031 -0.51197444
#> 105  No  0.4269395436 -0.34331189
#> 106  No  0.6295320549  0.42448809
#> 107  No  0.7339514399  0.18800586
#> 108  No  0.0802015385  0.05366845
#> 109  No  0.6062213222  0.40710096
#> 110  No  0.2238220401 -0.31861520
```
