
smoch.gp <- function(y,x,data,k=5, oversampling=100, outlier=FALSE, out_amp=1.5){

  #descobrir classe minoritária

  min = names(which.min(table(data[[y]])))

  # Ver o valor do oversampling
  if(oversampling < 100 ){

    library(dplyr)

    n_over = oversampling/100*nrow(data[data[[y]]==min,])

    datax = original_indices <- which(data[[y]] == min)
    sampled_indices <- sample(original_indices, n_over)
    datax <- data[sampled_indices, , drop = FALSE]


    # Se não for preciso ver os outliers
    if(outlier==FALSE){

      dis <- FD::gowdis(datax, ord = c('podani'))

      dis_matrix <- as.matrix(dis)

      nearest_neighbors <- list()

      for (i in 1:nrow(dis_matrix)) {

        valid_distances <- dis_matrix[i, ]
        valid_distances[i] <- Inf

        # Obter os índices dos k menores valores
        nearest <- order(valid_distances)[1:3]

        # Armazenar os nomes dos vizinhos mais próximos (colunas)
        nearest_neighbors[[rownames(dis_matrix)[i]]] <- colnames(dis_matrix)[nearest]
      }

    } else { # quando os OUTLIERS interessam

      var_n_num <- datax[,sapply(datax, function(x){!is.numeric(x) | is.binary(x)})]
      dis_discrete <- FD::gowdis(as.data.frame(var_n_num, rownames(datax))) #distância das variáveis Não numéricas
      # rownames(datax) para obrigar a manter os index originais

      var_num <- datax[,sapply(datax, function(x) {is.numeric(x) & !is.binary(x)})]

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

    for(it in 1:1){

      new_data <- list()

      for(i in seq_along(nearest_neighbors)){
        vizinhos <- data[nearest_neighbors[[i]], ] # Obtém os vizinhos mais próximos
        vizinhos_n <- rbind(vizinhos, data[names(nearest_neighbors[[i]]),])
        # Seleciona colunas numéricas
        vizinhos_numeric <- vizinhos_n[, sapply(vizinhos_n, is.numeric), drop = FALSE]

        # Seleciona colunas discretas (não numéricas)
        vizinhos_discrete <- vizinhos[, sapply(vizinhos, Negate(is.numeric)), drop = FALSE]

        # Se não houver colunas numéricas, passa para a próxima iteração
        if (ncol(vizinhos_numeric) == 0) next

        # Gera coeficientes aleatórios normalizados para combinação convexa
        alpha.linha <- runif(nrow(vizinhos_numeric), 0, 1)
        alpha <- alpha.linha / sum(alpha.linha)

        # Cria nova observação numérica
        new_numeric <- colSums(sweep(vizinhos_numeric, 1, alpha, "*"))

        # Seleciona uma linha aleatória das variáveis discretas
        new_discrete <- apply(vizinhos_discrete, 2, function(x) sample(x,1))

        # Combina numéricos e discretos numa única linha
        new_obs <- cbind(as.data.frame(t(new_numeric)), t(new_discrete))

        # Adiciona à lista de novas observações
        new_data[[i]] <- new_obs
      }

      # Converte lista em data.frame
      new_data_df <- do.call(rbind, new_data)

      # Junta à base de dados original
      data <- rbind(data, new_data_df)

    } # fim do ciclo for

  } else {  # Quando o oversampling é maior do que 100

    # Não precisamos de colocar nenhuma restrição porque vamos usar todas as observações

    if(outlier==FALSE){


      dis <- FD::gowdis(data[data[[y]]==min,], ord = c('podani'))

      dis_matrix <- as.matrix(dis)

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


      var_n_num <- data[data[[y]]==min,sapply(data, function(x){!is.numeric(x) | is.binary(x)})]
      dis_discrete <- FD::gowdis(as.data.frame(var_n_num, rownames(data[data[[y]]==min,]))) #distância das variáveis Não numéricas

      var_num <- data[data[[y]]==min,sapply(data, function(x) {is.numeric(x) & !is.binary(x)})]

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
        vizinhos_numeric <- vizinhos_n[, sapply(vizinhos_n, is.numeric), drop = FALSE]

        # Seleciona colunas discretas (não numéricas)
        vizinhos_discrete <- vizinhos[, sapply(vizinhos, Negate(is.numeric)), drop = FALSE]

        # Se não houver colunas numéricas, passa para a próxima iteração
        if (ncol(vizinhos_numeric) == 0) next

        # Gera coeficientes aleatórios normalizados para combinação convexa
        alpha.linha <- runif(nrow(vizinhos_numeric), 0, 1)
        alpha <- alpha.linha / sum(alpha.linha)

        # Cria nova observação numérica
        new_numeric <- colSums(sweep(vizinhos_numeric, 1, alpha, "*"))

        # Seleciona uma linha aleatória das variáveis discretas
        new_discrete <- apply(vizinhos_discrete, 2, function(x) sample(x,1))

        # Combina numéricos e discretos numa única linha
        new_obs <- cbind(as.data.frame(t(new_numeric)), t(new_discrete))

        # Adiciona à lista de novas observações
        new_data[[i]] <- new_obs
      }

      # Converte lista em data.frame
      new_data_df <- do.call(rbind, new_data)

      # Junta à base de dados original
      data <- rbind(data, new_data_df)
    }

  }

  return(list(distances = dis_matrix, nearest_neighbors = nearest_neighbors, Newdata = data))
}
