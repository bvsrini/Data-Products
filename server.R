
library(maps)
library(mapproj)
library(openxlsx)
library(dplyr)
library(rapportools)
library(d3heatmap)

# Modified percent map from R shiny tutorials
percent_map <- function(var, regVar, color, titleVar,footerVar, legend.title) {
  
  # generate vector of fill colors for map
  shades <- colorRampPalette(c("blue", color))(4)
  fills <- shades[var+1]
  
  # plot choropleth map
  map("state", fill = TRUE, col = fills, region= regVar,
      resolution = 0, lty = 0, projection = "polyconic", 
      myborder = 0, mar = c(0,0,0,0))
  
  # overlay state borders
  map("state", col = "white", fill = FALSE, add = TRUE,
      lty = 1, lwd = 1, projection = "polyconic", 
      myborder = 0, mar = c(0,0,0,0))
  
  title(titleVar)
  mtext(side = 1, text = footerVar)
  
  legend.text <- c("No Data",
                   "Less than National Avg",
                   "Equal to National Avg",
                   "More than National Avg")
  
  legend("bottomleft", 
         legend = legend.text, 
         fill = shades, 
         title = legend.title,
         cex=0.8)
}



shinyServer(function(input, output) {
  score_mspb <- function(x,y)
  {
    ifelse(y == 0 , 0, 
           ifelse(x/y < 1,1,
                  ifelse(x/y == 1,2,3)))
    
  }
  
  mspb_claimtype <- read.xlsx("data/Medicare_Hospital_Spending_by_Claim.xlsx",sheet=1)
  colnames(mspb_claimtype)[1] <- "Hospital_Name" 
  colnames(mspb_claimtype)[2] <- "Provider_Number" 
  colnames(mspb_claimtype)[5] <- "Claim_Type" 
  colnames(mspb_claimtype)[6] <- "Avg_spend_per_episode_Hosp" 
  colnames(mspb_claimtype)[7] <- "Avg_spend_per_episode_State" 
  colnames(mspb_claimtype)[8] <- "Avg_spend_per_episode_Nation" 
  colnames(mspb_claimtype)[9] <- "Per_Spending_Hosp"
  colnames(mspb_claimtype)[10] <- "Per_Spending_State" 
  colnames(mspb_claimtype)[11] <- "Per_Spending_Nation"
  colnames(mspb_claimtype)[12] <- "Measure_Start_Date"
  colnames(mspb_claimtype)[13] <- "Measure_End_Date"
  mspb_claimtype_state <- unique(select(mspb_claimtype,State,Period,Claim_Type,Avg_spend_per_episode_State,Avg_spend_per_episode_Nation,Per_Spending_State,Per_Spending_Nation))
  mspb_claimtype_state <- mutate(mspb_claimtype_state,score_with_nation = score_mspb(Avg_spend_per_episode_State,Avg_spend_per_episode_Nation))
  mspb_claimtype <- mutate(mspb_claimtype,state_name = state.name[match(State,state.abb)])
  
  mState <- ({state.name})
  output$State <- renderUI({
    selectInput("State", label = h3("Choose a State to View the details"), 
                           choices = mState, 
                             selected = 1)
  })

  my_state = reactive({input$State})
  myPeriod <- reactive({
    switch(input$Period,
           "1" = "1 to 3 days Prior to Index Hospital Admission",
           "2" = "During Index Hospital Admission",
           "3" = "1 through 30 days After Discharge from Index Hospital Admission")
  })
 
  myClaimType <- reactive({
    switch(input$ClaimType,
            "1" = "Home Health Agency", 
            "2" = "Hospice",
            "3" = "Inpatient",
            "4" = "Outpatient",
            "5" = "Skilled Nursing Facility",
            "6" = "Durable Medical Equipment",
            "7" = "Carrier")}) 
              

  my_data <- reactive({mspb_claimtype_state[which(mspb_claimtype_state$Claim_Type == myClaimType() & 
                                          mspb_claimtype_state$Period == myPeriod()),]})
            
 cap_str <- reactive({paste("Claim Type = ",  
                    tocamel(myClaimType(),sep = " "),
                    "\n Period = ",
                    tocamel(myPeriod(),sep = " "))})
 
  output$view <- renderPlot({

    percent_map(var = my_data()$score_with_nation,my_data()$state_name,
                color = "red", "", cap_str(),legend.title = "MSPB")
  } )
  
  my_data1 <- reactive({mspb_claimtype[which(mspb_claimtype$Claim_Type == myClaimType() &
                                                   mspb_claimtype$Period == myPeriod()  &
                                                   mspb_claimtype$state_name == my_state()),]})
  
  my_data2 <- reactive({
     t <- mspb_claimtype[which(mspb_claimtype$state_name == my_state()),]
     t <- subset(t, Claim_Type != "Total",
               select = c(Hospital_Name,Claim_Type,Period,Avg_spend_per_episode_Hosp))
     colnames(t)[4] <- "AvgSp_Hosp"  
     
     if (nrow(t) != 0)
     {
         t <- aggregate(AvgSp_Hosp ~ ., data = t, max)
         w <- (reshape(t, 
                      timevar = "Claim_Type",
                      idvar = c("Hospital_Name", "Period"),
                      direction = "wide"))
          w[w$Period == "1 to 3 days Prior to Index Hospital Admission",]$Period <- "P1_3"
          w[w$Period == "During Index Hospital Admission",]$Period <- "DH"
          w[w$Period == "1 through 30 days After Discharge from Index Hospital Admission",]$Period <- "A1_30"
          w <- reshape(w,
                      timevar = "Period",
                      idvar = c("Hospital_Name"),
                      direction = "wide")
         row.names(w) <- w$Hospital_Name
         w <- select(w,-Hospital_Name)
     }
     else 
     {
        w <- data.frame(X1=0,X2=0,X3=0,X4=0,X5=0,X6=0,X7=0,X8=0,X9=0,X10=0,
                        X11=0,X12=0,X13=0,X14=0,X15=0,X16=0,X17=0,X18=0,X19=0,X20=0,X21=0)
     }
         colnames(w)[1] <- "HHA.P13.$"
         colnames(w)[2] <- "Hospice.P13.$"                   
         colnames(w)[3] <- "Inpatient.P13.$"   
         colnames(w)[4] <- "Outpatient.P13.$"
         colnames(w)[5] <- "SNF.P13.$"
         colnames(w)[6] <- "DME.P13.$"
         colnames(w)[7] <- "Carrier.P13.$"
         colnames(w)[8] <- "HHA.DH.$"
         colnames(w)[9] <- "Hospice.DH.$"                   
         colnames(w)[10] <- "Inpatient.DH.$"   
         colnames(w)[11] <- "Outpatient.DH.$"
         colnames(w)[12] <- "SNF.DH.$"
         colnames(w)[13] <- "DME.DH.$"
         colnames(w)[14] <- "Carrier.DH.$"
         colnames(w)[15] <- "HHA.A130.$"
         colnames(w)[16] <- "Hospice.A130.$"                   
         colnames(w)[17] <- "Inpatient.A130.$"   
         colnames(w)[18] <- "Outpatient.A130.$"
         colnames(w)[19] <- "SNF.A130.$"
         colnames(w)[20] <- "DME.A130.$"
         colnames(w)[21] <- "Carrier.A130.$"
   
      w
     
     
  })
  
  output$heatmapheight <- renderPrint({ nrow(my_data2())*8})
    
   
  
   output$chart <-renderPlot({
     par(mar=c(10,4,3,5))
     par(xaxt="n")
     end_point = 0.5 + 2* nrow(my_data1())-1
     barplot(my_data1()$Avg_spend_per_episode_Hosp, col="red",
             main = "",
             ylab="Avg Spending Per Hospital Per Episode in US$",
             xlim = c(0,50+nrow(my_data1())),
             ylim=c(0,5+max(my_data1()$Avg_spend_per_episode_Hosp)),
             xlab = "",
             space=1)
     lablist.x<-as.vector(my_data1()$Hospital_Name)
     axis(1, at=seq(0, 55, by=20), labels = FALSE)
     text(x = seq(1.5,end_point, by=2), par("usr")[3], labels = lablist.x, srt=60, pos = 2, xpd = TRUE,cex=0.5)
     })
  

  output$heatMap <- renderD3heatmap({
      d3heatmap(my_data2(), scale = "row",dendrogram = "none",xaxis_font_size = "8pt",
      xaxis_height = 80,
      yaxis_width = 300,yaxis_font_size = 6)
  }) 
  
    output$table <- renderDataTable(as.data.frame(my_data1()),
      options=list(page='enable',pageLength = 5, height=800,width=800)
  )


})