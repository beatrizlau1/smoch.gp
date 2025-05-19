#' @title Acute Myocardial Infarction Dataset
#'
#' @description A simulated dataset generated to model the risk of experiencing an acute myocardial infarction, exhibiting class imbalance. The dataset includes a heterogeneous mix of variable types—such as demographic, clinical, and behavioural features—that are typically associated with cardiovascular risk. The minority class represents individuals who experienced acute myocardial infarction, while the majority class comprises those who did not.
#'
#' @format A data frame with 4018 rows and 13 variables:
#' \describe{
#'   \item{age}{The age of each patient.}
#'   \item{sex}{The sex of each patient.}
#'   \item{myocardial_infar}{Dependent variable. It defines whether or not a myocardial infarction has occurred.}
#'   \item{coronary_arterio}{Define which patient has had coronary arteriosclerosis diagnosis.}
#'   \item{smoking_hab}{It presents the smoking habits of each patient. It can be "smoker", "ex-smoker" or "no smoker"}
#'   \item{IMC}{A variable that defines the body mass index of each patient.}
#'   \item{Htension}{Define which patient has had hypertension diagnosis.}
#'   \item{diabetes}{Define which patient has had diabetes diagnosis.}
#'   \item{dyslipi}{Define which patient has had dyslipidaemia diagnosis.}
#'   \item{family_history}{A variable that defines whether there is a family history of acute myocardial infarction, and if so, the degree of kinship.}
#'    }




## code to prepare `DATASET` dataset goes here

load("data.RData")
data$age <- as.integer(data$age)
data$sex <- as.factor(data$sex)
data$myocardial_infar <- as.factor(data$myocardial_infar)
data$coronary_arterio <- as.factor(data$coronary_arterio)
data$smoking_hab <- as.factor(data$smoking_hab)
data$IMC <- as.integer(data$IMC)
data$Htension <- as.factor(data$Htension)
data$diabetes <- as.factor(data$diabetes)
data$dyslipi <- as.factor(data$dyslipi)
data$family_history <- as.ordered(data$family_history)

usethis::use_data(data, overwrite = TRUE)
