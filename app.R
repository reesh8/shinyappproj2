#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    shinyUI(navbarPage("Project2",
                       
                       tabPanel("tab1",
                                
                                # Application title
                                titlePanel("Old Faithful Geyser Data"),
                                
                                # Sidebar with a slider input for number of bins 
                                sidebarLayout(
                                    sidebarPanel(
                                        sliderInput("bins",
                                                    "Number of bins:",
                                                    min = 1,
                                                    max = 50,
                                                    value = 30)
                                    ),
                                    
                                    # Show a plot of the generated distribution
                                    mainPanel(
                                        plotOutput("distPlot")
                                    )
                                )
                                
                       ),
                       
                       tabPanel("tab2",
                                
                                # App title ----
                                titlePanel("Miles Per Gallon"),
                                
                                # Sidebar layout with input and output definitions ----
                                sidebarLayout(
                                    
                                    # Sidebar panel for inputs ----
                                    sidebarPanel(
                                        
                                        # Input: Selector for variable to plot against mpg ----
                                        selectInput("variable", "Variable:",
                                                    c("Cylinders" = "cyl",
                                                      "Transmission" = "am",
                                                      "Gears" = "gear")),
                                        
                                        # Input: Checkbox for whether outliers should be included ----
                                        checkboxInput("outliers", "Show outliers", TRUE)
                                        
                                    ),
                                    
                                    # Main panel for displaying outputs ----
                                    mainPanel(
                                        
                                        # Output: Formatted text for caption ----
                                        h3(textOutput("caption")),
                                        
                                        # Output: Plot of the requested variable against mpg ----
                                        plotOutput("mpgPlot")
                                        
                                    )
                                )
                       ),
                       
                       tabPanel("tab3",
                                fluidRow(column(12,
                                                h1("title3"),
                                                p("TextParagraph1"),
                                                br(),
                                                h4("Instructions"),
                                                p("Use the radio buttons on the left to chose 1, 2, 3."))),
                                hr(),
                                fluidRow(sidebarPanel(width = 3,
                                                      h4("1, 2, or 3"),
                                                      helpText("Chose whether you would like to see a histogram of 1, 2, 3"),
                                                      radioButtons("num", NULL,
                                                                   c("1" = "1",
                                                                     "2" = "2",
                                                                     "3" = "3")))
                                )
                       )
    )))


mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    # Compute the formula text ----
    # This is in a reactive expression since it is shared by the
    # output$caption and output$mpgPlot functions
    formulaText <- reactive({
        paste("mpg ~", input$variable)
    })
    
    # Return the formula text for printing as a caption ----
    output$caption <- renderText({
        formulaText()
    })
    
    # Generate a plot of the requested variable against mpg ----
    # and only exclude outliers if requested
    output$mpgPlot <- renderPlot({
        boxplot(as.formula(formulaText()),
                data = mpgData,
                outline = input$outliers,
                col = "#75AADB", pch = 19)
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
