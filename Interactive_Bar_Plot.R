#install.packages('rsconnect')
library(tidyverse)
library(tidyr)
library(plotly)
library(shinydashboard)
library(shiny)
library(rsconnect)




# reading in excel files
hs_comp <- read.csv("table_603.10.byAges.csv", header = TRUE)
college_comp <- read.csv("table_603.20.byAges.csv", header = TRUE)



# trimming whitespace after country name
hs_comp$Country <- trimws(hs_comp$Country, which = c("right"))
college_comp$Country <- trimws(hs_comp$Country, which = c("right"))



# transforming data to tibble
hs_comp <- as_tibble(hs_comp)
college_comp <- as_tibble(college_comp)  



# pivoting data for better readability
age_range <- c("25_64", "25_34")


hs_comp_pop <- hs_comp[,1:8] %>% filter(Ages %in% age_range) %>%
               pivot_longer(P.2000:P.2019, names_to = "year",
               names_prefix = "P."  , values_to = "pop_percent_hs") 


hs_comp_se <- hs_comp[, c(1:2, 9:12)] %>% filter(Ages %in% age_range) %>%
              pivot_longer(SE.2010:SE.2019, names_to = "year", 
              names_prefix = "SE.",values_to = "standard_error_hs") 


hs_data <- left_join(hs_comp_pop, hs_comp_se,
                     by = c("Country", "Ages", "year"))






college_comp_pop <- college_comp[, 1:8] %>% filter(Ages %in% age_range) %>%
                    pivot_longer(P.2000:P.2019, names_to = "year",
                    names_prefix = "P."  , values_to = "pop_percent_college") 


college_comp_se <- college_comp[, c(1:2, 9:12)] %>% filter(Ages %in% age_range) %>%
                   pivot_longer(SE.2010:SE.2019, names_to = "year",
                   names_prefix = "SE.",values_to = "standard_error_college")


college_data <- left_join(college_comp_pop, college_comp_se,
                          by = c("Country", "Ages", "year"))





# combining high school and college data into single data frame
bar_data <- full_join(hs_data, college_data)



# replaced NA values for hs population and postsecondary degree completion percentages
# to 0 so that data appears better in the visual

bar_data$pop_percent_hs[is.na(bar_data$pop_percent_hs)] <- 0
bar_data$pop_percent_college[is.na(bar_data$pop_percent_college)] <- 0


# factoring year
bar_data$year <- as.factor(bar_data$year)


# utilizing pivot_longer() once more for an improved visualization
vis <- bar_data[, c(1:4,6)] %>%
       pivot_longer(c(pop_percent_hs,pop_percent_college), 
       names_to = "percentage_name"  , values_to = "percentages") %>% 
       unite(age_percent, c(Ages, percentage_name))


vis2 <- bar_data[, c(1:3,5,7)] %>%  
        pivot_longer(standard_error_hs:standard_error_college,
        names_to = "error_name"  , values_to = "errors") %>% 
        unite(age_error, c(Ages, error_name))




vis_data <- cbind(vis, vis2)[, -c(5,7)]




# creating empty list to store visuals in
country_names <- unique(vis_data$Country)[-1]
visuals = list()



# for loop to create bar plot visual for each country

for(i in country_names){
  #creating base for visualization
  f <- vis_data %>% filter(Country == i) %>% plot_ly() %>%
    add_bars(x = ~unique(year), y = ~percentages[age_percent == "25_64_pop_percent_hs"],
             name = ~"High School Completion (Ages 25-64)", 
             error_y = ~list(array = errors[age_error == "25_64_standard_error_hs"],
                        color = '#000000'), color = I("orangered")) %>%
    
    add_bars(x = ~unique(year), y = ~percentages[age_percent == "25_64_pop_percent_college"],
             name = ~"Postsecondary Degree (Ages 25-64)", 
             error_y = ~list(array = errors[age_error == "25_64_standard_error_college"],
                        color = '#000000'), color = I("purple")) %>%
    
    add_bars(x = ~unique(year), y = ~percentages[age_percent == "25_34_pop_percent_hs"],
             name = ~"High School Completion (Ages 25-34)", 
             error_y = ~list(array = errors[age_error == "25_34_standard_error_hs"],
             color = '#000000'),  color = I("dodgerblue2")) %>%
    
    add_bars(x = ~unique(year), y = ~percentages[age_percent == "25_34_pop_percent_college"],
             name = ~"Postsecondary Degree (Ages 25-34)", 
             error_y = ~list(array = errors[age_error == "25_34_standard_error_college"],
             color = '#000000'), color = I("darkgreen")) %>% 
    
    add_trace(data = vis_data[1:12,] , x = ~unique(year), 
              y = ~percentages[age_percent == "25_64_pop_percent_hs"],
              name = ~"OECD Average Percent for High School Completion",
              type = "scatter", mode = "lines+markers",
              line = list(width = 3, color = "black"), visible = F) %>%
    
    add_trace(data =  vis_data[1:12,], x = ~unique(year),
              y = ~percentages[age_percent == "25_64_pop_percent_college"],
              name = ~"OECD Average Percent for Postsecondary Degree",
              type = "scatter", mode = "lines+markers", 
              line = list(width = 3, color = "black", dash = "dash"), visible = F) %>%
    
    add_trace(data =  vis_data[481:492,], x = ~unique(year), 
              y = ~percentages[age_percent == "25_34_pop_percent_hs"],
              name = ~"OECD Average Percent for High School Completion",
              type = "scatter", mode = "lines+markers",
              line = list(width = 3, color = "red"), visible = F) %>%
    
    add_trace(data =  vis_data[481:492,], x = ~unique(year),
              y = ~percentages[age_percent == "25_34_pop_percent_college"],
              name = ~"OECD Average Percent for Postsecondary Degree",
              type = "scatter", mode = "lines+markers", 
              line = list(width = 3, color = "red", dash = "dash"), visible = F) 
  
  f <- f %>% 
    layout(xaxis = list(title = "year"), 
           yaxis = list(title = "population percentage"),
           title = paste(i,"'s percent of the population that completed High School<br>vs Postsecondary Education by Age Group", sep = ""),
           updatemenus = list(
             list(
               type = "dropdown",
               active = 0,
               x = 1.3,
               #xanchor = "right",
               y = 0.60,
               #yanchor = "middle",
               buttons = list(
                 list(method =  "restyle", 
                      args = list("visible", list(TRUE, TRUE, TRUE, TRUE, FALSE, FALSE,FALSE, FALSE)),
                      label = "All Age Ranges"),
                 
                 list(method =  "restyle",
                      args = list("visible", list(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE,FALSE, FALSE)),
                      label = "Ages 25 to 64"),
                 
                 list(method = "restyle",
                      args = list("visible", list(FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE)),
                      label = "Ages 25 to 34")
               )
             )
           )
    )
  
  visuals[[i]] = f
}




# Created a basic shiny app to be able to select each country's visual

side_bar <- dashboardSidebar(
                  
                sidebarMenu(
                    
                    menuItem(
                              selectInput("selected_country",
                              "Select a Country to View", choices = names(visuals)))
                   )

  
)
  



body <- dashboardBody(

            fluidRow(box( plotlyOutput("selected_visual", width = "100%", height = 500),
                          collapsible = FALSE, collapsed = FALSE, width = "100%")
                     )
  
)




ui <- dashboardPage(
  
        dashboardHeader(title = "Explore Education Data by Country", titleWidth = '330'),
        
        side_bar,
        
        body,
        
        skin = "black"
    
)



server <- function(input, output) {
  
    output$selected_visual <- renderPlotly({
      
           all_visuals <- function(countries) {
               visuals[[countries]]
            }
      
      
           choosen_country <- input$selected_country
        
        
           all_visuals(choosen_country)
    })
  
}



shinyApp(ui, server)



















