#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ui.R
# R shiny basic demo ----
# R Code Club 10 November 2022
# Isabella Tortora Brayda
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## BASIC UI (No bells or whistles) ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ui <- fluidPage(
# 
#   # HEADINGS for Dashboard
#    h1("Cancer Incidence from 2000 to 2020"), # h1 is the biggest title
# 
#    h3("This is a demo dashboard providing cancer incidence from 2000 to 2020 for three main cancer types:
#    Breast, Lung and Prostate."),
# 
# 
# 
#   # BUTTONS
# 
#   # We want to give the users the option to select to view multiple cancer types, so we'll create a select drop down with the following code:
# 
#   selectInput("cancersite_plot1", label = "Select cancer type", choices = unique(cancer00_20$cancer_site),selected = "Breast", multiple = TRUE),
# 
# 
# 
# 
#   #PLOTS
#   # Now we'll call the first plot we created in server. R (which we called cancerplot).
# 
#   plotlyOutput("cancerplot"),
# 
#   #If we wanted to add text interpretation under the plot, we could do this next using p(),
# 
#   p("Cancer data interpretation could go here. Notice the font is smaller"),
# 
#   # Underneath this, we want to see the data table output that we created called scot data.
#   dataTableOutput("scot_data"),
# 
# 
# 
#   # HEADINGS
# 
#   # We're just stacking everything in this UI output, so underneath, here's the next heading.
#   # This time we're using h3 which is a smaller heading
#   h3("Now lets plot only the health board data"),
# 
# 
# 
# 
#   #BUTTONS
# 
#   # For this next plot we want the user to be able to select both healthboard and cancer type, so we have two select options:
#   radioButtons("healthboard_plot2", label = "Select NHS Board", choices = unique(cancer00_20$hb)),
#   checkboxGroupInput("cancersite_plot2", label = "Select cancer type", choices = unique(cancer00_20$cancer_site),selected = "Breast"),
# 
# 
# 
#   #PLOT
# 
#   # And then we'll generate the plotly output below.
#   plotlyOutput("hbplot")
# 
# )

## Lets organise the UI better: -----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# We can arrange space using columns and breaks.
# We can group things and accentuate them using wellPanels

# NB: Brackets start to get confusing once wellPanels and columns come into play. It's good practise to label these for reference. 

ui <- fluidPage(
  
  # HEADINGS for Dashboard
  wellPanel(h1("Cancer Incidence from 2000 to 2020"),
            
            h3("This is a demo dashboard providing cancer incidence from 2000 to 2020 for three main cancer types: Breast, Lung and Prostate.")
  ), #wellPanel bracket
  br(),
  
  column(12,h3(strong("Cancer incidence at Scotland level"))
  ),#column bracket
  
  #BUTTONS
  
  fluidRow(column(3),
           column(6,wellPanel(selectInput("cancersite_plot1", label = "Select Cancer Type", choices = unique(cancer00_20$cancer_site),selected = "Breast", multiple = TRUE)
           ) #wellPanel bracket
           ), #middle column bracket
           column(3)
  ), #fluidRow bracket
  
  # PLOT AND TABLE output:
  
  fluidRow(column(8, plotlyOutput("cancerplot")),
           column(4, dataTableOutput("scot_data"))
  ), # fluidRow bracket
  
  br(),
  br(),
  br(),
  
  ## HEADING
  column(12,h3(strong("Now lets plot only the health board data"))),
  
  #BUTTONS
  
  fluidRow(
    column(3),
    column(3,wellPanel(radioButtons("healthboard_plot2", label = "Select NHS Board", choices = unique(cancer00_20$hb)))),
    column(3,wellPanel(checkboxGroupInput("cancersite_plot2", label = "Select cancer type", choices = unique(cancer00_20$cancer_site),selected = "Breast"))
    )
  ),# fluidRow bracket
  
  # PLOT
  
  plotlyOutput("hbplot")
  
)

## What about tabs? ----
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# # Lets say that we want one tab for cancer incidence at Scotland level and another for the healthboard data.
# # To achieve this, we are introducing tabPanels!
# # There are 3 types of tabs: tabsetPanel, navlistPanel and navbarPage. We're using tabsetPanel in this example
# 
# ui <- fluidPage(
# 
#   ## create a box around the main title for the dashboard. Make it bold and the biggest heading size
#   wellPanel(h1(strong("CASES R Shiny Dashboard Demo"))),
# 
# 
#   # tabset panel dictates what kind of tabs we use
#   tabsetPanel(
# 
#   # using tab panel creates the first tab - put all the code you want to appear in the first tab within this tabPanel function
#     tabPanel("Scotland incidence",
#              
#              br(),
#           # Introductory text
#           wellPanel(h1("Cancer Incidence from 2000 to 2020"),
# 
#                     h3("This is a demo dashboard providing cancer incidence from 2000 to 2020 for three main cancer types: Breast, Lung and Prostate."),
#                     style = "background:white"
#           ), #wellPanel bracket
#           br(),
# 
# 
#           # TITLE
#           column(12,h3(strong("Cancer incidence at Scotland level"))
#           ),#column bracket
# 
#           
#           
#           #Fluid row for all user inputs
#         
#           fluidRow(column(3),
#                    column(6,wellPanel(selectInput("cancersite_plot1", label = "Select Cancer Type", choices = unique(cancer00_20$cancer_site),selected = "Breast", multiple = TRUE)
#                    ) #wellPanel bracket
#                    ), #middle column bracket,
#                    column(3)
#           ), #fluidRow bracket,
# 
#           
#           
#           # Plot and data output in their own fluid row :
# 
#           fluidRow(column(8, plotlyOutput("cancerplot")),
#                    column(4, dataTableOutput("scot_data"))
#           ) # fluidRow bracket
#     ), #tabPanel bracket
# 
#     
#     ## Start of the next tab:
#     
#   tabPanel("Healthboard panel",
#            br(),
#            
#            
#   #Title for top of tab
#   column(12,wellPanel(h3(strong("Now lets plot only the health board data"))
#                       )#wellPanel
#          ),
# 
#   # Fluid row for user inputs
#   fluidRow(
#     column(3),
#     column(3,wellPanel(radioButtons("healthboard_plot2", label = "Select NHS Board", choices = unique(cancer00_20$hb)))),
#     column(3,wellPanel(checkboxGroupInput("cancersite_plot2", label = "Select cancer type", choices = unique(cancer00_20$cancer_site),selected = "Breast"))
#     )
#   ),# fluidRow bracket
# 
#   
#   # Fluid row for plotly output
#   plotlyOutput("hbplot")
#   ) #tabPanel bracket
#   ) #tabsetPanel bracket
# 
# ) # fluidPage bracket
