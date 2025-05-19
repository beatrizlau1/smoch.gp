#' Synthetic Minority Ovsersampling Convex Hull - Gower's distance with Podani modification
#'
#' @description
#' This function generates synthetic observations for the minority class in a given dataset exhibiting class imbalance. It was specifically designed for mixed-type datasets—i.e., those containing heterogeneous variable types—although it is also compatible with more uniform datasets, such as those composed solely of numerical or categorical variables, for example.
#'
#'
#' @param y The name or column index of the dependent variable, which contains the imbalanced classes (require);
#' @param data  A dataset presenting class imbalance (require);
#' @param k  The number of k-nearest neighbours to consider, the default value is 5;
#' @param oversampling The oversampling ratio to apply. Accepted values must be greater than 0 and multiples of 10. If unspecified, the defaults is the maximum possible ratio for the given dataset;
#' @param outlier A boolean argument indicating whether the SMOCH-GP function should be adapted to account for potential outliers. The default value is FALSE;
#' @param out_amp  allows the user to customise the threshold from which an observation is considered an outlier. This parameter is only active when outlier = TRUE, otherwise, it is ignored. By default, an observation is considered an outlier if it lies below or above the first or third quartile by more than 1.5*Interquartile Range.
#'
#' @return
#' \bold{Newdata} - A resulting dataset consists of original minority observations, synthetic minority observations and original majority observations. A vector of their respective target classes is included in the final column.
#' @export
#'
#' @references  Alonso, H., & da Costa, J. F. P. (2025). Over-sampling methods for mixed data in imbalanced problems. \emph{Communications in Statistics: Simulation and Computation}. \url{https://doi.org/10.1080/03610918.2024.2447451}
#'

#'
#' @examples
#' df <- data.frame(y=rep(as.factor(c('Yes', 'No')), times=c(90, 10)), x1=rnorm(100), x2=rnorm(100))
#' smoch.gp(y='y', data=df, k=5, oversampling = 100, outlier = F)

smoch.gp <- function(y,data,k=5, oversampling, outlier=FALSE, out_amp=1.5){

  ## Fazer verificações
  if(missing(data) || !is.data.frame(data)) {
    stop("You must provide a valid dataset as a data frame.")
  }

  if(is.null(y)) {
    stop("The dependent variable must be defined.")
  }

  # para que o over-sampling seja o máximo
  if(is.null(oversampling)) {
    table = table(data$y)
    n.min = min(table)
    n.max = max(table)
    p = ((n.max/n.min)-1)*100
    p = floor(p/100)*100
    oversampling = p
  } else {
    if(!is.numeric(oversampling) || oversampling <=0 || oversampling %% 10 != 0) {
      stop("The over-sampling ratio value must be a positive number as a multiple of 10. ")
    }
  }

  if(!is.logical(outlier)) {
    stop("Outlier argument must be TRUE or FALSE.")
  }


  if(!is.numeric(k) || k<=0){
    stop("K-nearest neighbours must be a positive integer.")
  }

  #descobrir classe minoritária

  data <- as.data.frame(data)
  chart <- sapply(data, function(x){is.character(x)})
  data[] <- lapply(seq_along(data), function(i){
    if (chart[[i]]){
      data[[i]] <- as.factor(data[[i]])
    } else{
      data[[i]]
    }
  })

  row.names(data) = 1:nrow(data)

  min = names(which.min(table(data[[y]])))

  # Ver o valor do oversampling
  if(oversampling < 100 ){

    library(dplyr)

    n_over = oversampling/100*nrow(data[data[[y]]==min,])

    original_indices <- which(data[[y]] == min)
    sampled_indices <- sample(original_indices, n_over)
    datax <- data[sampled_indices, , drop = FALSE] #base para construir

    row.names(datax) <- 1:nrow(datax)
    datax2 <- datax
    int <- sapply(datax2, function(x){is.integer(x)})
    datax2[] <- lapply(seq_along(datax2), function(i) {
      if (int[i]) {
        as.numeric(datax2[[i]])  # Converter colunas inteiras para numéricas
      } else {
        datax2[[i]]  # Manter as outras colunas inalteradas
      }
    })

    factor <- sapply(datax2, function(x){is.factor(x) & length(levels(x))})
    datax2[] <- lapply(seq_along(datax2), function(i){
      if(factor[i]){
        c(0,1)[datax2[[i]]]
      }else{
        datax2[[i]]
      }
    })


    # Se não for preciso ver os outliers
    if(outlier==FALSE){

      dis <- FD::gowdis(datax2, ord = c('podani'))

      dis_matrix <- as.matrix(dis)
      colnames(dis_matrix) = which(datax[[y]]==min)
      rownames(dis_matrix) = which(datax[[y]]==min)

      nearest_neighbors <- list()

      for (i in 1:nrow(dis_matrix)) {

        valid_distances <- dis_matrix[i, ]
        valid_distances[i] <- Inf

        # Obter os índices dos k menores valores
        nearest <- order(valid_distances)[1:k]

        # Armazenar os nomes dos vizinhos mais próximos (colunas)
        nearest_neighbors[[rownames(dis_matrix)[i]]] <- colnames(dis_matrix)[nearest]
      }

    } else { # quando os OUTLIERS interessam

      var_n_num <- datax[,sapply(datax, function(x){!is.numeric(x) | Information::is.binary(x)})]
      dis_matrix <- FD::gowdis(as.data.frame(var_n_num, rownames(datax))) #distância das variáveis Não numéricas
      # rownames(datax) para obrigar a manter os index originais

      var_num <- datax[,sapply(datax, function(x) {is.numeric(x) & !Information::is.binary(x)})]

      # fazer o cálculo da distância APENAS SE houver variáveis numéricas


      dis_num = lapply(var_num, function(x){
        x_min <- min(x);
        q1_out <- quantile(x, 0.25)-out_amp*IQR(x);
        a1 = max(x_min, q1_out);

        x_max <- max(x);
        q3_out <- quantile(x, 0.75)+out_amp*IQR(x);
        b2 = min(x_max, q3_out);

        DF = x[x >= q1_out & x <= q3_out]

        b = max(DF)
        a= min(DF)

        Rj <- b-a;

        dis = abs(outer(x,x, "-"))/Rj


        return(dis)
      }
      )

      #Se a distância for superior a 1, dis_num deve ser igual a 1
      dis_num <- lapply(dis_num, function(x) {
        x[x > 1] <- 1
        return(x)
      })

      #Somar todas as variáveis numéricas

      if(length(dis_num) == 1){

        dis2 <- dis_num
      } else {

        dis2 <- dis_num[[1]]

        for(i in 2:length(dis_num)){

          dis2 = dis2 + dis_num[[i]]

        }
      }

      #Depois da soma total devemos dividir por m (número total de variáveis )

      dis2_fim <- dis2/ncol(data)


      # Distância final

      dis_matrix <- as.matrix(dis_matrix)*(length(var_n_num))/ncol(data) + dis2_fim

      # Procurar k vizinhos mais próximos

      nearest_neighbors <- list()

      for (i in 1:nrow(dis_matrix)) {

        valid_distances <- dis_matrix[i, ]
        valid_distances[i] <- Inf

        # Obter os índices dos k menores valores
        nearest <- order(valid_distances)[1:k]

        # Armazenar os nomes dos vizinhos mais próximos (colunas)
        nearest_neighbors[[rownames(dis_matrix)[i]]] <- colnames(dis_matrix)[nearest]
      }

    }

    for(it in 1:1){

      new_data <- list()

      for(i in seq_along(nearest_neighbors)){
        vizinhos <- datax[nearest_neighbors[[i]], ] # Obtém os vizinhos mais próximos
        vizinhos_n <- rbind(vizinhos, datax[names(nearest_neighbors[[i]]),])
        # Seleciona colunas numéricas
        vizinhos_numeric <- vizinhos_n[, sapply(vizinhos_n, function(x) {is.numeric(x) & !is.integer(x)}), drop = FALSE]

        # Seleciona colunas discretas (não numéricas)
        vizinhos_discrete <- vizinhos[, sapply(vizinhos, function(x){ is.factor(x) | is.character(x) | is.logical(x) | is.integer(x)}), drop = FALSE]

        # Se não houver colunas numéricas,
        if (ncol(vizinhos_numeric) > 0) {

          # Gera coeficientes aleatórios normalizados para combinação convexa
          alpha.linha <- runif(nrow(vizinhos_numeric), 0, 1)
          alpha <- alpha.linha / sum(alpha.linha)

          # Cria nova observação numérica
          new_numeric <- colSums(sweep(vizinhos_numeric, 1, alpha, "*"))

          # Seleciona uma linha aleatória das variáveis discretas
          new_discrete <- apply(vizinhos_discrete, 2, function(x) sample(x,1))

          # Combina numéricos e discretos numa única linha
          new_obs <- cbind(as.data.frame(t(new_numeric)), t(new_discrete))

        }else {

          # Seleciona uma linha aleatória das variáveis discretas
          new_discrete <- apply(vizinhos_discrete, 2, function(x) sample(x,1))

          # Combina numéricos e discretos numa única linha
          new_obs <- cbind(as.data.frame(t(new_discrete)))
        }

        # Adiciona à lista de novas observações
        new_data[[i]] <- new_obs
      }

      # Converte lista em data.frame
      new_data_df <- do.call(rbind, new_data)

      # Junta à base de dados original
      data <- rbind(data, new_data_df)

      #trasformar o que era interiro em inteiro novamente
      char <- sapply(data, function(x) {is.character(x)})
      data[] <- lapply(seq_along(data), function(i){
        if(char[i]==TRUE){
          as.integer(data[[i]])
        }else{
          data[[i]]
        }
      })

    } # fim do ciclo for

  } else {  # Quando o oversampling é maior do que 100

    # Não precisamos de colocar nenhuma restrição porque vamos usar todas as observações

    if(outlier==FALSE){

      data2 <- data[data[[y]]==min,]

      int <- sapply(data2, function(x){is.integer(x)})

      data2[] <- lapply(seq_along(data2), function(i) {
        if (int[i]) {
          as.numeric(data2[[i]])
        } else {
          data2[[i]]
        }
      })

      factor <- sapply(data2, function(x){is.factor(x) & length(levels(x))})
      data2[] <- lapply(seq_along(data2), function(i){
        if(factor[i]){
          c(0,1)[data2[[i]]]
        }else{
          data2[[i]]
        }
      })

      dis <- FD::gowdis(data2, ord = c('podani'))

      dis_matrix <- as.matrix(dis)

      colnames(dis_matrix) = which(data[[y]]==min)
      rownames(dis_matrix) = which(data[[y]]==min)

      nearest_neighbors <- list()

      for (i in 1:nrow(dis_matrix)) {

        valid_distances <- dis_matrix[i, ]
        valid_distances[i] <- Inf

        # Obter os índices dos k menores valores
        nearest <- order(valid_distances)[1:k]

        # Armazenar os nomes dos vizinhos mais próximos (colunas)
        nearest_neighbors[[rownames(dis_matrix)[i]]] <- colnames(dis_matrix)[nearest]
      }

    } else {

      #seleção das variáveis numéricas


      var_n_num <- data[data[[y]]==min,sapply(data, function(x){!is.numeric(x) | Information::is.binary(x)})]
      dis_discrete <- FD::gowdis(as.data.frame(var_n_num, rownames(data[data[[y]]==min,]))) #distância das variáveis Não numéricas

      var_num <- data[data[[y]]==min,sapply(data, function(x) {is.numeric(x) & !Information::is.binary(x)})]

      # fazer o cálculo da distância

      dis_num = lapply(var_num, function(x){
        x_min <- min(x);
        q1_out <- quantile(x, 0.25)-out_amp*IQR(x);
        a1 = max(x_min, q1_out);

        x_max <- max(x);
        q3_out <- quantile(x, 0.75)+out_amp*IQR(x);
        b2 = min(x_max, q3_out);

        DF = x[x >= q1_out & x <= q3_out]

        b = max(DF)
        a= min(DF)

        Rj <- b-a;

        dis = abs(outer(x,x, "-"))/Rj


        return(dis)
      }
      )

      #Se a distância for superior a 1, dis_num deve ser igual a 1
      dis_num <- lapply(dis_num, function(x) {
        x[x > 1] <- 1
        return(x)
      })

      #Somar todas as variáveis numéricas

      if(length(dis_num) == 1){

        dis2 <- dis_num
      } else {

        dis2 <- dis_num[[1]]

        for(i in 2:length(dis_num)){

          dis2 = dis2 + dis_num[[i]]

        }
      }

      #Depois da soma total devemos dividir por m (número total de variáveis )

      dis2_fim <- dis2/ncol(data)


      # Distância final

      dis_matrix <- as.matrix(dis_discrete)*(length(var_n_num))/ncol(data) + dis2_fim

      # Procurar k vizinhos mais próximos

      nearest_neighbors <- list()

      for (i in 1:nrow(dis_matrix)) {

        valid_distances <- dis_matrix[i, ]
        valid_distances[i] <- Inf

        # Obter os índices dos k menores valores
        nearest <- order(valid_distances)[1:k]

        # Armazenar os nomes dos vizinhos mais próximos (colunas)
        nearest_neighbors[[rownames(dis_matrix)[i]]] <- colnames(dis_matrix)[nearest]
      }

    }

    #Podemos querer repetir o ciclo várias vezes

    for(it in 1:(oversampling/100)){

      new_data <- list()

      for(i in seq_along(nearest_neighbors)){
        vizinhos <- data[nearest_neighbors[[i]], ]  # Obtém os vizinhos mais próximos
        vizinhos_n <- rbind(vizinhos, data[names(nearest_neighbors[[i]]),])
        # Seleciona colunas numéricas
        vizinhos_numeric <- vizinhos_n[, sapply(vizinhos_n, function(x) {is.numeric(x) & !is.integer(x)}), drop = FALSE]

        # Seleciona colunas discretas (não numéricas)
        vizinhos_discrete <- vizinhos[, sapply(vizinhos, function(x){is.factor(x) | is.character(x) | is.logical(x) | is.integer(x)}), drop = FALSE]

        # Se não houver colunas numéricas,
        if (ncol(vizinhos_numeric) > 0) {

          # Gera coeficientes aleatórios normalizados para combinação convexa
          alpha.linha <- runif(nrow(vizinhos_numeric), 0, 1)
          alpha <- alpha.linha / sum(alpha.linha)

          # Cria nova observação numérica
          new_numeric <- colSums(sweep(vizinhos_numeric, 1, alpha, "*"))

          # Seleciona uma linha aleatória das variáveis discretas
          new_discrete <- apply(vizinhos_discrete, 2, function(x) sample(x,1))

          # Combina numéricos e discretos numa única linha
          new_obs <- cbind(as.data.frame(t(new_numeric)), t(new_discrete))

        }else {

          # Seleciona uma linha aleatória das variáveis discretas
          new_discrete <- apply(vizinhos_discrete, 2, function(x) sample(x,1))

          # Combina numéricos e discretos numa única linha
          new_obs <- cbind(as.data.frame(t(new_discrete)))
        }

        # Adiciona à lista de novas observações
        new_data[[i]] <- new_obs

      }
      # Converte lista em data.frame
      new_data_df <- do.call(rbind, new_data)

      # Junta à base de dados original
      data <- rbind(data, new_data_df)

      ##trasformar o que era interiro em inteiro novamente
      char <- sapply(data, function(x) {is.character(x)})
      data[] <- lapply(seq_along(data), function(i){
        if(char[i]==TRUE){
          as.integer(data[[i]])
        }else{
          data[[i]]
        }
      })

    }
  }

  return(list(Newdata = data))
}

