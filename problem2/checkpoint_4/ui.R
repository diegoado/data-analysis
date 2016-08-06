library(shiny)

shinyUI(fluidPage(
  titlePanel(HTML("<center>Gastos de Parlamentares em 2016</center>")),
  
  h3("Introdução"),
  p("Os dados deste relatório foram coletados do site de transparência da câmara dos deputados. 
    Esses dados contém todos os gastos de nossos deputados em 2016 de Janeiro a Maio, 
    usando a sua cota para exercício da atividade parlamentar."),
  
  h3("Apresentação dos Dados"),
  p("Os dados abaixo mostram a distribuição dos gastos dos parlamenteres agrupados por partido 
    e pelo tipo do gasto. Cada barro no gráfico representa a soma de dos gastos, em milhares de reais, 
    de todos os parlamentares de um partido X em ao longo dos cincos meses observados."),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("gastos"),
      uiOutput("meses")
      
    ),
    # Show a plot of the user chooses
    mainPanel(
      plotOutput("plot")
    )
  )
))
