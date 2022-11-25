#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# server.R
# R shiny basic demo ----
# R Code Club 10 November 2022
# Isabella Tortora Brayda
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# This dashboard is going to show the incidence of 3 main cancer types in Scotland, for individuals age 50-70. We will have three main outputs:
#   1) Line graph of cancer incidence by 3 cancer types (breast, lung and prostate) at scotland level,
#   2) Data table for the data used to produce the first output.
#   3) Bar chart of cancer incidence by cancer type, and healthboard (4 selected healthboards),

library(shiny)
library(ggplot2)
library(ggplotify)
library(plotly)
library(here)


## Read in extract created in dataprep.R. ----
## Keeping the majority of data prep separate from the shiny apps speeds up the internal loading of the app
cancer <- read.csv("cancer_data.csv")

## We will need a couple of different extracts for the 2 plots:

# 1) Scotland level data

scotland <- cancer %>%
  filter(hb == "Scotland") %>% 
  group_by(year,hb, cancer_site) %>% 
  summarise(count = sum(count)) %>% 
  ungroup()

# 2) Data by cancer and healthboard
hb <- cancer %>%
  group_by(year,hb,cancer_site) %>% 
  summarise(count = sum(count)) %>% 
  ungroup()


### THIS IS THE ACTUAL SERVER PART!

server <- function(input, output) {
  
  
  ### Each plot that you create needs to have output$ in front of the name,
  ### so that the UI knows that it needs to be called in
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # CREATING OUTPUT 1: Line graph of Scotland level data ----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$cancerplot <- renderPlotly({
    
    plotdata <- scotland %>% filter(cancer_site %in% c(input$cancersite_plot1))
    
    (plot<- ggplot(plotdata, aes(x = year, y = count, colour = cancer_site,
                                 text = paste("Number of registrations:", count,'\n',
                                              "Year:",year)))+
        geom_point()+
        geom_line(aes(group = 1))+
        ylab("Number of cancer registrations")+
        xlab("Year")+
        scale_colour_manual(values = col_palette)+
        # guides(colour=guide_legend(title="Legend"))+
        theme_bw()+
        theme(panel.border = element_blank()))
    
    # convert ggplot to plotly and add y axis title
    #~~~~~~~~~~~~~~~~~
    plot <- ggplotly(plot, tooltip = "text")# %>%
    # layout(showlegend = TRUE ) %>%
    # config(displayModeBar = F)
    #
  })
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # CREATING OUTPUT 2:  Datatable of Scotland level data ----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$scot_data <- renderDataTable(
    (scotland %>% filter(cancer_site %in% c(input$cancersite_plot1))),
    options = list(pageLength = 5)
  )
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # CREATING OUTPUT 3:  Datatable of Scotland level data ----
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$hbplot <- renderPlotly({
    
    plotdata <- hb %>% filter(cancer_site %in% c(input$cancersite_plot2), hb == input$healthboard_plot2)
    
    
    (plot2<- ggplot(plotdata, aes(x = year, y = count, fill = cancer_site,
                                  text = paste("Number of registrations:", count,'\n',
                                               "Year:",year)))+
        geom_bar(position = "dodge", stat = "identity")+
        ylab("Number of cancer registrations")+
        xlab("Year")+
        scale_fill_manual(values = col_palette, aesthetics = "fill")+
        # guides(colour=guide_legend(title="Legend"))+
        theme_bw()+
        theme(panel.border = element_blank()))
    
    # convert ggplot to plotly and add y axis title
    #~~~~~~~~~~~~~~~~~
    plot2 <- ggplotly(plot2, tooltip = "text")# %>%
    # layout(showlegend = TRUE ) %>%
    # config(displayModeBar = F)
    #
  })
  
}
