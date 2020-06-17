
library(shiny)
library(shinythemes)
library(rmarkdown)


####################################
# User Interface                   #
####################################
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage("BMI & Waist to Hip Ratio Calculator:",
                           
                           tabPanel("Home",
                                    # Input values
                                    sidebarPanel(
                                      HTML("<h3>Input parameters</h4>"),
                                      numericInput("waist", 
                                                   label = "Waist Measurement in cm", 
                                                   value = 76),
                                      numericInput("hip", 
                                                   label = "Hip Measurement in cm", 
                                                   value = 97),
                                      sliderInput("height", 
                                                  label = "Height in cm", 
                                                  value = 175, 
                                                  min = 40, 
                                                  max = 250),
                                      sliderInput("weight", 
                                                  label = "Weight in kg", 
                                                  value = 70, 
                                                  min = 20, 
                                                  max = 100),
                                      
                                      actionButton("submitbutton", 
                                                   "Submit", 
                                                   class = "btn btn-primary")
                                    ),
                                    
                                    mainPanel(
                                      tags$label(h3('Status/Output')), # Status/Output Text Box
                                      verbatimTextOutput('contents'),
                                      tableOutput('tabledata'), # Results table
                                   
                                      HTML("<h4>BMI -> Body Mass Index</h4>"),
                                      HTML("<h4>WHR -> Waist to Hip Ratio</h4>"),
                                      HTML("<h5>The body mass index measurement is the calculation of your body weight in relation to your height and is commonly used as an indicator of whether you might be in a risk category for health problems caused by your weight. Using a BMI calculator such as the one on this page, you enter your weight and height measurements. Those figures are entered into the BMI formula to produce your current BMI reading.</h5>"),
                                      HTML("<h5>Waist-hip ratio or waist-to-hip ratio (WHR) is the ratio of the circumference of the waist to that of the hips. The WHR has been used as an indicator or measure of health, and the risk of developing serious health conditions.</h5>")
                                        ) # mainPanel()
                                    
                           ), #tabPanel(), Home
                           
                           tabPanel("About", 
                                    titlePanel("About"), 
                                    div(includeMarkdown("about.md"), 
                                        align="justify")
                           ) #tabPanel(), About
                           
                ) # navbarPage()
) # fluidPage()


####################################
# Server                           #
####################################
server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    BMI <- input$weight/( (input$height/100) * (input$height/100) )
    WHR <- input$waist/input$hip
    BMI <- data.frame(BMI,WHR)
    
    names(BMI[2]) <- "BMI"
    
    print(BMI)
    
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}


####################################
# Create Shiny App                 #
####################################
shinyApp(ui = ui, server = server)
