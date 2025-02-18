test_that("smoch.gp()", {
  X <- data.frame(
    x1 = c(0,1,1,0,0,0,0,0,0,0,0,0,0,1),
    x2 = c(1,3,1,3,3,1,2,3,3,2,2,3,4,5),
    x3 = c(4,2,4,2,2,3,2,2,2,2,1,2,4,4),
    x4 = c(4,2,4,4,3,1,3,3,4,2,4,1,3,2),
    x5 = c(2,2.25,2.25,2,2.13,2.38,2.13,2.25,3.25,3.13,2.5,1.88,2,2.38),
    x6 = c(10,6.4,12.4,11,12.8,17.1,18.7,12,14.2,15.1,14.6,15.5,16.4,12.2),
    x7 = c(4,2,3.2,2.6,4,4.3,5.4,3.6,2.6,3.9,3.9,4.9,3.8,4))


  X$x1 <- as.numeric(as.character(X$x1)) # binárias
  X$x2 <- as.factor(X$x2)
  X$x3 <- as.ordered(X$x3)
  X$x4 <- as.ordered(X$x4)

  result <- smoch.gp(y='x1', x=c('x2','x3','x4','x5','x6','x7'), data=X, k=2, oversampling=100, outlier = FALSE)
  expect_equal(length(result), 3)

  expected_distances <- matrix(c(
    0.0000000, 0.6571429, 0.7095238,
    0.6571429, 0.0000000, 0.4904762,
    0.7095238, 0.4904762, 0.0000000
  ), nrow = 3, byrow = TRUE)

  # Defina as colunas e linhas de acordo com os seus dados
  colnames(expected_distances) <- c("2", "3", "14")
  rownames(expected_distances) <- c("2", "3", "14")

  expect_equal(round(result$distances,7), expected_distances)


  expected_neighbors <- list(
    `2` = c("3", "14"),
    `3` = c("14", "2"),
    `14` = c("3", "2")
  )

  expect_equal(result$nearest_neighbors, expected_neighbors)


})
