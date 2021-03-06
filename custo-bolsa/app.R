####### Fontes: 
####### https://revistacantareira.files.wordpress.com/2012/09/ultimo-artigo1.pdf
####### http://cnpq.br/web/guest/noticiasviews/-/journal_content/56_INSTANCE_a6MO/10157/953956

#enc2native()

desperdicio <- function(titulo, mes, ano) {
  meses <- c('Janeiro', 'Fevereiro', 'MarÃ§o', 'Abril', 'Maio', 'Junho',
             'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro')
  
  if(titulo=="Mestrado") { aa <- 2 }
  if(titulo=="Doutorado") { aa <- 4 }
  
  x <- matrix(NA, 12, aa+1)
  row.names(x) <- meses
  colnames(x) <- (ano-aa):ano
  keymonth <- which(meses == mes)
  
  
  for(i in (ano-aa):ano) {
    for(j in 1:length(row.names(x))) {
      
      if(i < 1995) { stop("NÃ£o dispomos de dados anteriores a 1995.") }
      
      
      ### Valor das bolsas de jan/1995 a jan/2004
      if(i >= 1995 & i <= 2004) {
        
        if(j > keymonth & i == ano | i==ano-aa & j <= keymonth) { x[j,as.character(i)] <- 0 
        } else {
          if(aa==2) {x[j,as.character(i)] <- 724.52} else { x[j,as.character(i)] <- 1072.89 }
        }
      }
      
      ### Valor das bolsas de fev/2004 a jun/2006
      if(i==2004 & j>1 | i > 2004 & i <= 2006) {
        
        if(j > keymonth & i == ano | i==ano-aa & j <= keymonth) { x[j,as.character(i)] <- 0 
        } else {
          if(aa==2) {x[j,as.character(i)] <- 855} else { x[j,as.character(i)] <- 1267.89 }
        }
      }
      
      ### Valor das bolsas de jul/2006 a mai/2008
      if(i==2006 & j>6 | i > 2006 & i <= 2008) {
        
        if(j > keymonth & i == ano | i==ano-aa & j <= keymonth) { x[j,as.character(i)] <- 0 
        } else {
          if(aa==2) {x[j,as.character(i)] <- 940} else { x[j,as.character(i)] <- 1340 }
        }
      }
      
      ### Valor das bolsas de jun/2008 a jun/2012
      if(i==2008 & j>5 | i > 2008 & i <= 2012) {
        
        if(j > keymonth & i == ano | i==ano-aa & j <= keymonth) { x[j,as.character(i)] <- 0 
        } else {
          if(aa==2) {x[j,as.character(i)] <- 1200} else { x[j,as.character(i)] <- 1800 }
        }
      }
      
      ### Valor das bolsas de jul/2012 a mar/2013
      if(i==2012 & j>6 | i == 2013) {
        
        if(j > keymonth & i == ano | i==ano-aa & j <= keymonth) { x[j,as.character(i)] <- 0 
        } else {
          if(aa==2) {x[j,as.character(i)] <- 1350} else { x[j,as.character(i)] <- 2000 }
        }
      }
      
      ### Valor das bolsas de abr/2013 a mar/2013
      if(i==2013 & j>3 | i > 2013) {
        
        if(j > keymonth & i == ano | i==ano-aa & j <= keymonth) { x[j,as.character(i)] <- 0 
        } else {
          if(aa==2) {x[j,as.character(i)] <- 1500} else { x[j,as.character(i)] <- 2200 }
        }
      }
      
      
    }
    
  }
  
  ### CORRIGINDO PARA A INFLACAO NO PERIODO
  ### Indices de correcao de 23 anos jan1995-nov2017
  #IGP-M (FGV): 6.0668107
  #IGP-DI (FGV): 6.0231079
  #INPC (IBGE): 4.8867239
  #IPC-A (IBGE): 4.8157582
  #IPC-Brasil (FGV): 4.9983103
  #IPC-SP (FIPE): 4.1171686
  ##### Media: 6.066811
  
  ind <- 6.066811
  
  corr <- ((ind-1)/23)*(2017-ano) + 1
  
  total <- sum(x)
  totalcorrigido <- sum(x)*corr
  
  return(data.frame("Gasto Total"=total,"Gasto Total Corrigido Pela InflaÃ§Ã£o"=totalcorrigido, check.names = F, row.names = "R$"))
  
  
}


library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("DissertaÃ§Ã´metro: Quanto nÃ³s pagamos?"),
  
  #Input
  sidebarPanel(
    radioButtons(inputId='titulo', label=strong('TÃ�tulo obtido'), 
                 choices=c('Mestrado', 'Doutorado'), selected = 'Mestrado', inline = TRUE),
    
    selectInput(inputId='mes', label='MÃªs da Defesa', 
                choices=c('Janeiro', 'Fevereiro', 'MarÃ§o', 'Abril', 'Maio', 'Junho',
                          'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'), 
                selected = 'Janeiro'),
    
    numericInput(inputId='ano', value = 2017, min = 1995, max=2017, label="Ano da Defesa")
    
    #, checkboxInput(inputId="correcao", label="Corrigir para inflaÃ§Ã£o no perÃ�odo", value = FALSE)
    
  ),
  mainPanel(
    tableOutput("gasto")
  )
  
)

server <- function(input, output) {
  
  output$gasto <-  renderTable({
    
    desperdicio(input$titulo, input$mes, input$ano)
    
  })
}

shinyApp(ui = ui, server = server)


