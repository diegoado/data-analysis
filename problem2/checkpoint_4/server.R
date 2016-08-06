library(dplyr, warn.conflicts = FALSE)
library(readr)
library(shiny)
library(ggplot2)

ler_gastos <- function(arquivo = "../../datasets/gastos.csv") {
  #' Lê um csv criado a partir dos dados de gastos dos deputados da
  #' Câmara e seta os tipos de colunas mais convenientemente.
  require("readr")
  require("dplyr", warn.conflicts = FALSE)
  
  gastos = read_csv(arquivo, col_types = list(datEmissao = col_datetime()))
  gastos = gastos %>%
    mutate_each(funs(as.factor), sgPartido, sgUF, txNomeParlamentar, indTipoDocumento, numMes)
  
  levels(gastos$numMes) =
    list("Janeiro"="1", "Fevereiro"="2", "Março"="3", "Abril"="4", "Maio"="5", "Junho"="6", "Julho"="7")
  
  return(gastos)
}

shinyServer(function(input, output) {
  data = ler_gastos()
  meses = c("Janeiro", "Fevereiro", "Março", "Abril", "Maio")
  
  data = data %>% 
    filter(
      !is.na(sgPartido), sgPartido != "S.PART.", numMes != "Junho", numMes != "Julho") %>%
    group_by(
      descricao = txtDescricao, partido = sgPartido, mes = numMes) %>% 
    summarise(gastos = sum(vlrDocumento)/1e+03) 
  
  data = data %>% 
    filter(partido %in% 
             c("PP", "PTB", "PSC", "PEN", "PMDB", "PT", "PSDB", "PR", "PSD", "PSB", "DEM", 
               "PRB", "PDT", "PTN", "PTdoB", "PSL", "SD", "PCdoB"))
  
  manual.colours = c("Medium Blue", "Forest Green", "Red", "Sky Blue", "Yellow Green")
  
  output$gastos = renderUI({
    valores = as.vector(unique(data$descricao))
    valores[[length(valores) + 1]] = "TODOS"
    selectInput("gasto", "Escolha o tipo de gasto:", as.list(valores), selected = "TODOS")
  })
  
  output$meses = renderUI({
    sliderInput("months", "Quantidade de meses observados:", min = 1, max = 5, value = 5)
  })
  
  output$plot = renderPlot({
    ggplot(data %>% filter(mes %in% as.vector(meses[1:input$months]), 
                           ifelse(input$gasto == "TODOS", 
                                  descricao == descricao, descricao == input$gasto)), 
           aes(y = gastos, x = partido, fill = mes)) + 
      geom_bar(stat = "identity", position = "dodge") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
      scale_fill_manual(values = manual.colours) +
      labs(fill = "Mês") +
      xlab("Partido") + ylab("Gastos (em milhares de reais)")
  })
})