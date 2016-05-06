require(shiny)
library(d3heatmap)

myD3heatmapOutput <- function (outputId, width = "100%", height = "400px") 
{ 

  htmlwidgets::shinyWidgetOutput(outputId, "d3heatmap", width,height, package = "d3heatmap")
}

shinyUI(fluidPage(
  headerPanel("Medicare Spending Per Episode"),
  sidebarPanel(
    
    selectInput("Period", label = h3("Choose a Period"), 
                choices = list("1 to 3 days Prior to Index Hospital Admission" = 1, 
                               "During Index Hospital Admission" = 2,
                    "1 through 30 days After Discharge from Index Hospital Admission" = 3), 
                    selected = 1),
   
    helpText("Choose the appropirate period to display the medicare expense by episode"),
    br(),
    selectInput("ClaimType", label = h3("Choose a Claim Type"), 
                choices = list("Home Health Agency" = 1, 
                               "Hospice" = 2,
                               "Inpatient" = 3,
                               "Outpatient" = 4,
                               "Skilled Nursing Facility" =5,
                               "Durable Medical Equipment" =6,
                               "Carrier" =7), 
                               selected = 1),
    
    helpText("Choose a Claim Type to display the medicare expense by episode"),
    br(),
    uiOutput("State"),
    helpText("Choose a State to  display the 'Medicare Data' or 
'Detail Heat Map' of medicare expense by episode in the respective tabs")
    
    ),
    mainPanel(
      div(class="span12",height=2000,
      tabsetPanel(
        tabPanel("Summary",h4("State Vs.Nation comparison of Medicare Spending"),plotOutput("view")),
      tabPanel("Medicare Data", h4("Medicare Spending Data display for the selected criteria"),dataTableOutput("table")),
      tabPanel("Detail Heat Map",h4("Heat Map Medicare Spending by Hospitals for a State"),
               myD3heatmapOutput("heatMap",height = "2000px")),
      tabPanel("ReadMe", includeMarkdown("coursera.md"))
      )
     )
    )
))


