#Import Data

#install.packages("dplyr")
#install.packages("ggpubr")
#install.packages("Rcmdr")

if(!require(questionr)){install.packages("questionr")}
if(!require(reshape2)){install.packages("reshape2")}
if(!require(dplyr)){install.packages("dplyr")}
if(!require(ggplot2)){install.packages("ggplot2")}
if(!require(ggpubr)){install.packages("ggpubr")}
if(!require(tidyr)){install.packages("tidyr")}
if(!require(plyr)){install.packages("plyr")}
if(!require(MASS)){install.packages("MASS")}
if(!require(lattice)){install.packages("lattice")}
if(!require(klaR)){install.packages("klaR")}
if(!require(tidyverse)){install.packages("tidyverse")}
if(!require(plotrix)){install.packages("plotrix")}
if(!require(rcompanion)){install.packages("rcompanion")}
if(!require(vcd)){install.packages("vcd")}
if(!require(psych)){install.packages("psych")}
if(!require(DescTools)){install.packages("DescTools")}
if(!require(epitools)){install.packages("epitools")}
if(!require(ordinal)){install.packages("ordinal")}
if(!require(lmtest)){install.packages("lmtest")}
if(!require(car)){install.packages("car")}
if(!require(heplots)){install.packages("heplots")}

setwd("~/Research/Github-Travis-Data-Collection/data/processed")

theme_set(theme_minimal()) # Gobal theme set for all 
printf <- function(...) invisible(print(sprintf(...))) # A useful tool that will help us in the future
blue_theme <- c('#7bccc4','#43a2ca','#0868ac')
blue_dark_theme <- c('#000000','#43a2ca','#0868ac')
max_val <- 2147483647

# Load Data
CommitData <- read.csv(file="commit_hash.csv", header=TRUE, sep=",")
PerformanceData <- read.csv(file="performance_hash.csv", header=TRUE, sep=",")
RepoData <- read.csv(file="repo_hash.csv", header=TRUE, sep=",")
Feedback <- read.csv(file="feedback_hash.csv", header=TRUE, sep=",")
Usernames<- read.csv(file="username_hash.csv", header=TRUE, sep=",")

# Rename the sections to make then understandable
PerformanceData$section <- gsub("11713", "Group 1", PerformanceData$section)
PerformanceData$section <- gsub("11714", "Group 2", PerformanceData$section)
PerformanceData$section <- gsub("11715", "Group 3", PerformanceData$section)

Usernames$section <- gsub("11713", "Group 1", Usernames$section)
Usernames$section <- gsub("11714", "Group 2", Usernames$section)
Usernames$section <- gsub("11715", "Group 3", Usernames$section)

Feedback$section <- gsub("11713", "Group 1", Feedback$section)
Feedback$section <- gsub("11714", "Group 2", Feedback$section)
Feedback$section <- gsub("11715", "Group 3", Feedback$section)

#Calculate Overall Grade
PerformanceData <- PerformanceData[-c(1,2),]
PerformanceData$overallGrade <-  (PerformanceData$lab2 + PerformanceData$lab3 + PerformanceData$lab4 + PerformanceData$project1 + PerformanceData$project2 +PerformanceData$midterm + PerformanceData$final) *100 /75
PerformanceData$labGrade  <- (PerformanceData$lab2 + PerformanceData$lab3 + PerformanceData$lab4) *100 /15
PerformanceData$testGrade <- (PerformanceData$midterm + PerformanceData$final)*100/45

# Descriptive Statistics
print("lab 2-----------------------------------------------------------------")
print("means")
mean(PerformanceData[PerformanceData$section == "Group 1",]$lab2 / 4 * 100)
mean(PerformanceData[PerformanceData$section == "Group 2",]$lab2 / 4 * 100)
mean(PerformanceData[PerformanceData$section == "Group 3",]$lab2 / 4 * 100)
print("sd")
sd(PerformanceData[PerformanceData$section == "Group 1",]$lab2 / 4 * 100)
sd(PerformanceData[PerformanceData$section == "Group 2",]$lab2 / 4 * 100)
sd(PerformanceData[PerformanceData$section == "Group 3",]$lab2 / 4 * 100)
print("lab 3--------------------------------------------------------------------")
print("means")
mean(PerformanceData[PerformanceData$section == "Group 1",]$lab3 / 8 * 100)
mean(PerformanceData[PerformanceData$section == "Group 2",]$lab3 / 8 * 100)
mean(PerformanceData[PerformanceData$section == "Group 3",]$lab3 / 8 * 100)
print("sd")
sd(PerformanceData[PerformanceData$section == "Group 1",]$lab3 / 8 * 100)
sd(PerformanceData[PerformanceData$section == "Group 2",]$lab3 / 8 * 100)
sd(PerformanceData[PerformanceData$section == "Group 3",]$lab3 / 8 * 100)
print("lab 4--------------------------------------------------------------------")
print("means")
mean(PerformanceData[PerformanceData$section == "Group 1",]$lab4 / 4 * 100)
mean(PerformanceData[PerformanceData$section == "Group 2",]$lab4 / 4 * 100)
mean(PerformanceData[PerformanceData$section == "Group 3",]$lab4 / 4 * 100)
print("sd")
sd(PerformanceData[PerformanceData$section == "Group 1",]$lab4 / 4 * 100)
sd(PerformanceData[PerformanceData$section == "Group 2",]$lab4 / 4 * 100)
sd(PerformanceData[PerformanceData$section == "Group 3",]$lab4 / 4 * 100)
print("--------------------------------------------------------------------")

# Std Deviation of overall grade by section
set.seed(1234)
dplyr::sample_n(PerformanceData, 10)
levels(PerformanceData$section)

group_by(PerformanceData, section) %>%
  summarise(
    count = n(),
    mean = mean(overallGrade, na.rm = TRUE),
    sd = sd(overallGrade, na.rm = TRUE)
  )


group_by(PerformanceData, section) %>%
  summarise(
    count = n(),
    mean = mean(labGrade, na.rm = TRUE),
    sd = sd(labGrade, na.rm = TRUE)
  )


group_by(PerformanceData, section) %>%
  summarise(
    count = n(),
    mean = mean(testGrade, na.rm = TRUE),
    sd = sd(testGrade, na.rm = TRUE)
  )


# AOV test

res.aov <- aov(overallGrade ~ section, data = PerformanceData)
plot(res.aov)
summary(res.aov)

res.aov <- aov(labGrade ~ section, data = PerformanceData)
plot(res.aov)
summary(res.aov)

#this produced significant results
res.aov <- aov(testGrade ~ section, data = PerformanceData)
plot(res.aov)
summary(res.aov)

#
# MULTIVARIANT ANALYSIS
#

# MANOVA 
res.man <- manova(cbind(lab2, lab3, lab4) ~ factor(section), data = PerformanceData)
summary(res.man,test="Wilks")

# Ad Hoc (LDA or QDA?)

# First check the normality of the distribution
ggdensity(PerformanceData$labGrade)

# First check for the heteroscedasticity of residuals
lm_stuff <- lm(cbind(lab2 + lab3 + lab4) ~ factor(section), data=PerformanceData)
plot(lm_stuff)

# The above is unclear to me so revert to statistical tests
lmtest::bptest(lm_stuff) 
car::ncvTest(lm_stuff)

# According to the statistical tests the signifcance tests were both <0.05 thus indicating we have heteroscedasticity and therefore we may not use LDA and must use QDA

qda_analysis <- function(data){

  ## Parition the data
  
  ssize <- floor(0.75 * nrow(data))
  set.seed(1337)
  train_i <- sample(seq_len(nrow(data)), size=ssize)
  
  train = data[train_i, ]
  test = data[-train_i, ]
  
  ## Perform QDA on the training
  discriminant.quad <- qda(factor(section) ~ lab2 + lab3 + lab4, data=train, method="moment")
  print(discriminant.quad)
  
  ## Get the confusion matrix from the test data
  predicted.quad <- predict(discriminant.quad, newdata=test)
  table(test$section, predicted.quad$class, dnn=c("Actual", "Predicted"))
  mean(predicted.quad$class == test$section)
  
    
}

# Perform QDA on the entirity of the data set
qda_analysis(PerformanceData)

# So the model has a 47 % accuracy at differentiating between groups lets try grouping 2 and 3 into the same and seeing how the model accuracy improves
mod_data <- PerformanceData
mod_data[mod_data$section == "Group 2", ]$section <- "Group 2_3"
mod_data[mod_data$section == "Group 3", ]$section <- "Group 2_3"
qda_analysis(mod_data)

# YAY! It went up to 80% indicating a significant different exists between group 1 and group2_3's performance. Now lets try grouping 1 and 2 together and comparing it to 3
mod_data <- PerformanceData
mod_data[mod_data$section == "Group 1", ]$section <- "Group 1_2"
mod_data[mod_data$section == "Group 2", ]$section <- "Group 1_2"
qda_analysis(mod_data)

# and grouping 1 and 3 together and seeing how it compares to 2
mod_data <- PerformanceData
mod_data[mod_data$section == "Group 1", ]$section <- "Group 1_3"
mod_data[mod_data$section == "Group 3", ]$section <- "Group 1_3"
qda_analysis(mod_data)

# and finally...remove group one and directly compare 2 and 3
mod_data <- PerformanceData
mod_data <- mod_data[mod_data$section == "Group 2" | mod_data$section == "Group 3", ]
qda_analysis(mod_data)

# directly compare 1 and 3
mod_data <- PerformanceData
mod_data <- mod_data[mod_data$section == "Group 1" | mod_data$section == "Group 3", ]
qda_analysis(mod_data)

# directly compare 1 and 2
mod_data <- PerformanceData
mod_data <- mod_data[mod_data$section == "Group 1" | mod_data$section == "Group 2", ]
qda_analysis(mod_data)


acc <- table(factor(PerformanceData$section), discriminant.linear$class)
diag(prop.table(acc,1))
sum(diag(prop.table(acc)))

discriminant.linear.values <- predict(discriminant.linear)
ldahist(discriminant.linear.values$x[,1], g=unique(PerformanceData$section))
plot(discriminant.linear)

predict(discriminant.linear, )

# Plots!!!
partimat(factor(section) ~ lab2 + lab3 + lab4,data=PerformanceData,method="lda")
pairs(PerformanceData[c("lab2", "lab3", "lab4")], main="Linear Discriminant Analysis of Lab Performance", pch=22, bg=c("red", "white", "blue")[unclass(factor(PerformanceData$section))])

#
# Box plot
# 

boxOverall  <- ggplot(PerformanceData, aes(x = section, y = overallGrade, fill = section)) +
  geom_violin(draw_quantiles = c(0.5)) + 
  geom_point(position=position_jitter(h=0.1, w=0.1),
             shape = 21, alpha = 0.5, size = 3)  +
  scale_fill_manual(values = blue_theme) + 
  ggtitle("Cumulative Grade by Section")  +
  xlab("")+
  ylab("Score")  +
  theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")
 


boxLab <- ggplot(PerformanceData, aes(x = section, y = labGrade, fill = section)) +
          geom_violin(draw_quantiles = c(0.5)) + 
          geom_point(position=position_jitter(h=0.1, w=0.1),
                     shape = 21, alpha = 0.5, size = 3)  +
          scale_fill_manual(values = blue_theme) + 
          ggtitle("Cumulative Lab Grade by Section")  +
          xlab("")+
          ylab("Average Lab Grade")  +
          theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top", panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank())

boxTest <- ggplot(PerformanceData, aes(x = section, y = testGrade, fill = section)) +
  geom_violin(draw_quantiles = c(0.5)) + 
  geom_point(position=position_jitter(h=0.1, w=0.1),
             shape = 21, alpha = 0.5, size = 3) +
  scale_fill_manual(values = blue_theme) + 
  ggtitle("Cumulative Test Grade by Section")  +
  xlab("")+
  ylab("Score")  +
  theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")


boxOverall
boxLab
boxTest




#
# Analysis of user responses to likert 4 point scale question
#
likert <- Feedback[2:3]
colnames(likert) <- c("section", "question")
likert.ctable <- table(likert)
likert.count <- count(likert)
likert.melt <- melt(likert.count)
g <- ggplot(likert.melt, aes(x=reorder(question, -value),y=value, fill=section)) + 
  geom_bar(stat="identity", width=0.5, position="dodge", colour="black") +
  xlab("") +
  scale_y_continuous(name="Response Count", seq(0,10,1)) +
  scale_fill_manual(name="", values=blue_theme) +
  theme(panel.grid = element_line(size = 0.5, linetype = 'solid', colour = "grey")) +
  ggtitle("Self Reported Use of Feedback") + 
  theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")
g

likert.performance <- merge(PerformanceData, Feedback, by="id_hash")[,c("section.y","To.what.extent.did.you.use.the.automated.feedback.on.Travis.when.you.work.on.your.labs...projects.","lab2","lab3","lab4","labGrade")]
colnames(likert.performance) <- c("section", "question", "lab2", "lab3", "lab4", "overall_lab_score")

# NOTE: This produces an error. Should I consider using logistic regression as an alternative
chisq.test(likert.ctable)
cramer.v(likert.ctable)


#
# Analysis of commits between groups 
#

# Change timestamp to POSIX
user_data <- data.frame(Usernames)
user_data <- data.frame(merge(x=user_data,y=PerformanceData,by="id_hash"))
user_data <- data.frame(merge(x=user_data,y=CommitData,by="username_hash"))

user_data$timestamp <- gsub("T"," ",user_data$timestamp)
user_data$timestamp <- gsub("Z"," ",user_data$timestamp)
user_data$timestamp = as.POSIXct(as.character(user_data$timestamp[]), format="%Y-%m-%d %H:%M:%OS")
user_data$date <- (as.Date(user_data$timestamp[]))

#
#
# Welcome to the magical land of functions....they do things and thats the nicest thing you can say about them
#
#

#
# General processing functions 
#
preprocess <- function(duration, due_date, lab, df, title){
  lab_df <- user_data[user_data$lab == lab,][c("username_hash", "id_hash","section.x", "attempt", lab, "timestamp", "comment", "changes", "tests_passed", "tests_run", "date")]
  colnames(lab_df)[3] <- "section"
  
  #Get days since lab was assigned
  #change start date for each lab
  lab_df$day<- (duration - (as.Date(due_date) - lab_df$date) ) #for lab 2
  
  # This produced strange travis results and is relativly insignificant in terms of contributions
  lab_df <- lab_df[ "Update README.md" != lab_df$comment, ]
  
  # Remove initial commis of templates
  if(lab == "lab2"){
    lab_df <- lab_df[ "add lab 2 template" != lab_df$comment, ]
    lab_df <- lab_df[ "add template" != lab_df$comment, ]
  } else if(lab == "lab3"){
    lab_df <- lab_df[ "add template" != lab_df$comment, ]
  } else if(lab == "lab4"){
    lab_df <- lab_df[ "template update" != lab_df$comment, ]
    lab_df <- lab_df[ "lab 4 template" != lab_df$comment, ]
  }
  
  # Remove the automatic commits for each of the templates
  if(lab == "lab2"){
    lab_df <- lab_df[ "add lab 2 template" != lab_df$comment, ]
    lab_df <- lab_df[ "add template" != lab_df$comment, ]
  } else if (lab == "lab3"){
    lab_df <- lab_df[ "add template" != lab_df$comment, ]
  } else if(lab == "lab4"){
    lab_df <- lab_df[ "lab 4 template" != lab_df$comment, ]
  }
  
  # Remove all commits that occured after the due date
  lab_df <- lab_df[lab_df$day <= duration,]
  lab_df <- lab_df[lab_df$day >= 0,]
  
  # Remove all those students who made no contributions to the lab (i.e likely dropped the class)
  user_changes <- lab_df[c("username_hash","changes")]
  user_changes <- aggregate(changes ~ username_hash, data = user_changes, FUN=sum)
  #lab_df <- lab_df[lab_df$users == user_changes[user_changes$changes > 0,]$users, ]
  
  return(lab_df)
  
}

#Lab 2 (1)  Due date: 2019-01-27 Duration : 16 Days
#Lab 3  (2) Due date: 2019-02-11 Duration : 17 Days
#Lab 4 (3) Due date: 2019-02-27 Duration : 14 Days ##technically due on the 24th, but students kept commit for it
lab_commit_analysis <- function(duration, due_date, lab, df, title){
  
  lab_df <- preprocess(duration, due_date, lab, df, title)
  
  # Extract all groups
  group_1 <- lab_df[lab_df$section == "Group 1", ]
  group_2 <- lab_df[lab_df$section == "Group 2", ]
  group_3 <- lab_df[lab_df$section == "Group 3", ]
  
  # Generate a plot of commits per group
  group1_tot_commits <- count(group_1$day)
  group2_tot_commits <- count(group_2$day)
  group3_tot_commits <- count(group_3$day)
  
  group1_tot_commits$section <- "Group 1"
  group2_tot_commits$section <- "Group 2"
  group3_tot_commits$section <- "Group 3"
  
  # Store and remove outlisers
  #group1_commits_out <- group1_tot_commits[which(group1_tot_commits$freq %in% boxplot(group1_tot_commits$freq)$out),]
  #group2_commits_out <- group2_tot_commits[which(group2_tot_commits$freq %in% boxplot(group2_tot_commits$freq)$out),]
  #group3_commits_out <- group3_tot_commits[which(group3_tot_commits$freq %in% boxplot(group3_tot_commits$freq)$out),]
  
  #group1_tot_commits <- group1_tot_commits[!group1_tot_commits$freq %in% group1_commits_out$freq, ]
  #group2_tot_commits <- group2_tot_commits[!group2_tot_commits$freq %in% group2_commits_out$freq, ]
  #group3_tot_commits <- group3_tot_commits[!group3_tot_commits$freq %in% group3_commits_out$freq, ]
  
  group_commits <- rbind(group1_tot_commits, group2_tot_commits, group3_tot_commits)
  #group_outliers <- rbind(group1_commits_out, group2_commits_out, group3_commits_out)
  
  colnames(group1_tot_commits) <- c("day", "commits", "section")
  colnames(group2_tot_commits) <- c("day", "commits", "section")
  colnames(group3_tot_commits) <- c("day", "commits", "section")
  colnames(group_commits) <- c("day", "commits", "section")
  
  # Anova analysis
  group_commits.aov <- aov(commits ~ factor(section), data=group_commits)
  print("")
  print("Changes ANOVA-----------------------------------------------")
  print(summary(group_commits.aov))
  print("------------------------------------------------------------")
  print("")
  
  #print("")
  #print("Outliers------------------------------------------------------")
  #print(group_outliers)
  #print("--------------------------------------------------------------")
  
  commits_vs_time <- ggplot() + 
    
    geom_line(data=group1_tot_commits, aes(colour=section, x=day, y=commits, linetype=section)) +
    geom_area(data=group1_tot_commits, aes(fill=section, x=day, y=commits), alpha=0.25) +
    geom_point(data=group1_tot_commits, aes(colour=section,x=day, y=commits, shape=section)) +
    
    geom_line(data=group2_tot_commits, aes(colour=section, x=day, y=commits, linetype=section)) +
    geom_area(data=group2_tot_commits, aes(fill=section, x=day, y=commits), alpha=0.25) +
    geom_point(data=group2_tot_commits, aes(colour=section,x=day, y=commits, shape=section)) +
    
    geom_line(data=group3_tot_commits, aes(colour=section, x=day, y=commits, linetype=section)) +
    geom_area(data=group3_tot_commits, aes(fill=section, x=day, y=commits), alpha=0.25) +
    geom_point(data=group3_tot_commits, aes(colour=section,x=day, y=commits, shape=section)) +
    
    xlab("Day") +
    ylab("Commits Per Group") +
    scale_linetype_manual(name="", values = c("twodash","longdash","solid")) +
    scale_color_manual(name="", values=blue_theme) +
    scale_fill_manual(name="", values=blue_theme) +
    scale_shape_manual(name="", values = c(16,17,18)) +
    theme(panel.grid = element_line(size = 0.5, linetype = 'solid', colour = "grey"),
          plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top") +
    ggtitle(title)
  
  return(commits_vs_time)
}

lab2_commit_g <- lab_commit_analysis(16, "2019-01-27", "lab2", user_data, "Lab 1")
lab3_commit_g <- lab_commit_analysis(17, "2019-02-10", "lab3", user_data, "Lab 2")
lab4_commit_g <- lab_commit_analysis(11, "2019-02-24", "lab4", user_data, "Lab 3")
ggarrange(lab2_commit_g, lab3_commit_g, lab4_commit_g, ncol = 3, nrow = 1 )

#
# Analysis of lab changes over time
#
lab_changes_analysis <- function(duration, due_date, lab, df, title){
  
  lab_df <- preprocess(duration, due_date, lab, df, title)
  
  # Extract all groups
  group_1 <- lab_df[lab_df$section == "Group 1", ][c("changes","day", "section")]
  group_2 <- lab_df[lab_df$section == "Group 2", ][c("changes","day", "section")] 
  group_3 <- lab_df[lab_df$section == "Group 3", ][c("changes","day", "section")] 
  
  # Get the average number of commits per section
  group1_commit_avg <- sum(group_1$changes)/length(group_1)
  group2_commit_avg <- sum(group_2$changes)/length(group_2)
  group3_commit_avg <- sum(group_3$changes)/length(group_3)
  
  printf("group 1 avg: %.3f", group1_commit_avg)
  printf("group 2 avg: %.3f", group2_commit_avg)
  printf("group 3 avg: %.3f", group3_commit_avg)
  
  # Aggregate changes made within each group for each day
  group1_changes <- aggregate(changes ~ day + section, sum, data=group_1)
  group2_changes <- aggregate(changes ~ day + section, sum, data=group_2)
  group3_changes <- aggregate(changes ~ day + section, sum, data=group_3)
  
  group_changes <- rbind(group1_changes, group2_changes, group3_changes)
  
  # Anova analysis
  group_changes.aov <- aov(changes ~ factor(section), data=group_changes)
  print("")
  print("Changes ANOVA-----------------------------------------------")
  print(summary(group_changes.aov))
  print("------------------------------------------------------------")
  print("")
  
  # Plot changes over time
  changes_vs_time <- ggplot() + 
    
    geom_line(data=group1_changes, aes(colour=section, x=day, y=changes, linetype=section)) +
    geom_area(data=group1_changes, aes(fill=section, x=day, y=changes), alpha=0.25) +
    geom_point(data=group1_changes, aes(colour=section,x=day, y=changes, shape=section)) +
    
    geom_line(data=group2_changes, aes(colour=section, x=day, y=changes, linetype=section)) +
    geom_area(data=group2_changes, aes(fill=section, x=day, y=changes), alpha=0.25) +
    geom_point(data=group2_changes, aes(colour=section,x=day, y=changes, shape=section)) +
    
    geom_line(data=group3_changes, aes(colour=section, x=day, y=changes, linetype=section)) +
    geom_area(data=group3_changes, aes(fill=section, x=day, y=changes), alpha=0.25) +
    geom_point(data=group3_changes, aes(colour=section,x=day, y=changes, shape=section)) +
    
    ylab("Changes Per Group") + 
    xlab("Day") +
    scale_color_manual(name="", values=blue_theme) +
    scale_fill_manual(name="", values=blue_theme) +
    scale_shape_manual(name="", values = c(16,17,18)) +
    scale_linetype_manual(name="", values = c("twodash","longdash","solid")) +
    theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top",
          panel.grid = element_line(size = 0.5, linetype = 'solid', colour = "grey")) +
    ggtitle(title)  
  
  return(changes_vs_time)
}

lab2_change_g <- lab_changes_analysis(16, "2019-01-27", "lab2", user_data, "Lab 1")
lab3_change_g <- lab_changes_analysis(17, "2019-02-10", "lab3", user_data, "Lab 2")
lab4_change_g <- lab_changes_analysis(11, "2019-02-24", "lab4", user_data, "Lab 3")
ggarrange(lab2_change_g, lab3_change_g, lab4_change_g, ncol = 3, nrow = 1 )


#
# Finds the number of changes bade per commit for each lab
#

commits_till_pass <- function(duration, due_date, lab, df, title, num_tests){
  
  lab_df <- preprocess(duration, due_date, lab, df, title)
  
  # Drop all rows containing commits afer each respective student's first pass of all test case
  users <- unique(lab_df$username_hash)
  users_df <- as.data.frame(users)
  users_df <- cbind(users_df, commits_to_pass=0)
  users_df <- merge(x = users_df, y = lab_df[c("section", "username_hash")], by.x = "users", by.y="username_hash", all.x = TRUE)
  users_df <- users_df[!duplicated(users_df), ]
  
  for(user in users){
    user_commits <- lab_df[lab_df$username_hash == user, ]
    user_commits <- user_commits[order(user_commits$timestamp), ]
    
    if(max_val %in% user_commits$tests_passed){
      user_commits <- lab_df[lab_df$username_hash == user, ]
      user_commits <- user_commits[order(user_commits$timestamp), ]
      i <- 1
      while(length(user_commits$tests_passed) > i & user_commits[i,]$tests_passed != max_val){
        i = i + 1 
      }
      users_df[users_df$users == user,]$commits_to_pass <- i + 1
    } else{
      users_df[users_df$users == user,]$commits_to_pass <- -1
    }
  }
  
  # Get rid of those individuals who did not pass all test cases
  failures <- users_df[users_df$commits_to_pass == -1, ] 
  users_df <- users_df[users_df$commits_to_pass != -1, ]
  
  print("Failures----------------------------------------------------")
  printf("Group 1 Fails: %f",length(failures[failures$section == "Group 1", ]$users))
  printf("Group 2 Fails: %f",length(failures[failures$section == "Group 2", ]$users))
  printf("Group 3 Fails: %f",length(failures[failures$section == "Group 3", ]$users))
  print("------------------------------------------------------------")
  
  
  
  boxplot <- ggplot(users_df, aes(x = section, y = commits_to_pass, fill = section)) +
    geom_violin(draw_quantiles = c(0.5)) + 
    geom_point(position=position_jitter(h=0.1, w=0.1),
               shape = 21, alpha = 0.5, size = 3)+ 
    scale_fill_manual(values = blue_theme) + 
    ggtitle("Commits to Pass Test Cases")  +
    xlab("")+
    ylab("")  +
    theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")
  boxplot
  
  users_df.aov <- aov(commits_to_pass ~ factor(section),data=users_df)
  print("")
  print("Changes ANOVA-----------------------------------------------")
  print(summary(users_df.aov))
  print("------------------------------------------------------------")
  print("")
  
  return(boxplot)  
}

lab2_commits_to_pass <- commits_till_pass(16, "2019-01-27", "lab2", user_data, "Lab 1", 4)
lab3_commits_to_pass <- commits_till_pass(17, "2019-02-10", "lab3", user_data, "Lab 2", 8)
lab4_commits_to_pass <- commits_till_pass(11, "2019-02-24", "lab4", user_data, "Lab 3", 4)
ggarrange(lab2_commits_to_pass, lab3_commits_to_pass, lab4_commits_to_pass, ncol = 3, nrow = 1 )

#
# Finds the number of changes bade per commit for each lab
#

changes_till_pass <- function(duration, due_date, lab, df, title, num_tests){
  
  lab_df <- preprocess(duration, due_date, lab, df, title)
  
  # Drop all rows containing commits afer each respective student's first pass of all test case
  users <- unique(lab_df$username_hash)
  users_df <- as.data.frame(users)
  users_df <- cbind(users_df, changes_to_pass=0)
  users_df <- cbind(users_df, commits_to_pass=0)
  users_df <- merge(x = users_df, y = lab_df[c("section", "username_hash")], by.x = "users", by.y="username_hash", all.x = TRUE)
  users_df <- users_df[!duplicated(users_df), ]
  
  for(user in users){
    user_commits <- lab_df[lab_df$username_hash == user, ]
    user_commits <- user_commits[order(user_commits$timestamp), ]
    
    if(max_val %in% user_commits$tests_passed){
      user_commits <- lab_df[lab_df$username_hash == user, ]
      user_commits <- user_commits[order(user_commits$timestamp), ]
      i <- 1
      tot_changes <- 0
      while(length(user_commits$tests_passed) > i & user_commits[i,]$tests_passed != max_val){
        i = i + 1 
        tot_changes = tot_changes + user_commits[i,]$changes
      }
      tot_changes = tot_changes + user_commits[i,]$changes
      users_df[users_df$users == user,]$changes_to_pass <- sum(tot_changes)
      users_df[users_df$users == user,]$commits_to_pass <- i
    } else{
      users_df[users_df$users == user,]$commits_to_pass <- -1
      users_df[users_df$users == user,]$changes_to_pass <- -1
    }
  }
  
  # Get rid of those individuals who did not pass all test cases
  failures <- users_df[users_df$changes_to_pass == -1, ] 
  users_df <- users_df[users_df$changes_to_pass != -1, ]
  
  print("Failures----------------------------------------------------")
  printf("Group 1 Fails: %f",length(failures[failures$section == "Group 1", ]$users))
  printf("Group 2 Fails: %f",length(failures[failures$section == "Group 2", ]$users))
  printf("Group 3 Fails: %f",length(failures[failures$section == "Group 3", ]$users))
  print("------------------------------------------------------------")
  
  boxplot <- ggplot(users_df, aes(x = section, y = changes_to_pass, fill = section)) +
    geom_violin(draw_quantiles = c(0.5)) + 
    geom_point(position=position_jitter(h=0.1, w=0.1),
               shape = 21, alpha = 0.5, aes(size=commits_to_pass)) + 
    scale_fill_manual(values = blue_theme) + 
    ggtitle("Changes to Pass Test Cases")  +
    xlab("")+
    ylab("")  +
    theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")
  boxplot
  
  users_df.aov <- aov(changes_to_pass ~ factor(section),data=users_df)
  print("")
  print("Changes ANOVA-----------------------------------------------")
  print(summary(users_df.aov))
  print("------------------------------------------------------------")
  print("")
  
  return(boxplot)  
}

lab2_changes_to_pass <- changes_till_pass(16, "2019-01-27", "lab2", user_data, "Lab 1", 4)
lab3_changes_to_pass <- changes_till_pass(17, "2019-02-10", "lab3", user_data, "Lab 2", 8)
lab4_changes_to_pass <- changes_till_pass(11, "2019-02-24", "lab4", user_data, "Lab 3", 4)
ggarrange(lab2_changes_to_pass, lab3_changes_to_pass, lab4_changes_to_pass, ncol = 3, nrow = 1 )

#
# Number of changes to pass test cases
#
changes_per_commit <- function(duration, due_date, lab, df, title, num_tests){
  
  lab_df <- preprocess(duration, due_date, lab, df, title)
  
  # Drop all rows containing commits afer each respective student's first pass of all test case
  users <- unique(lab_df$username_hash)
  users_df <- as.data.frame(users)
  users_df <- cbind(users_df, changes_to_commits=0)
  users_df <- merge(x = users_df, y = lab_df[c("section", "username_hash", "day")], by.x = "users", by.y="username_hash", all.x = TRUE)
  users_df <- users_df[!duplicated(users_df), ]
  
  for(user in users){
    user_commits <- lab_df[lab_df$username_hash == user, ]
    user_commits <- user_commits[order(user_commits$timestamp), ]
    i <- 1
    tot_changes <- 0
    while(length(user_commits$tests_passed) > i && user_commits[i,]$tests_passed != max_val){
      tot_changes = tot_changes + as.numeric(user_commits$changes)
      i = i + 1 
    }
    
    users_df[users_df$users == user,]$changes_to_commits <- sum(tot_changes) / i
  }
  
  
  users_df.aov <- aov(changes_to_commits ~ factor(section),data=users_df)
  print("")
  print("Changes ANOVA-----------------------------------------------")
  print(summary(users_df.aov))
  print("------------------------------------------------------------")
  print("")
  
  boxplot <- ggplot(users_df, aes(x = section, y = changes_to_commits, fill = section)) +
    geom_violin(draw_quantiles = c(0.5)) + 
    geom_point(position=position_jitter(h=0.1, w=0.1),
               shape = 21, alpha = 0.5, size = 3) + 
    scale_fill_manual(values = blue_theme) + 
    ggtitle("Changes to Pass Test Cases")  +
    xlab("")+
    ylab("")  +
    theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")
  boxplot
  return(boxplot)  
}

lab2_changes_to_commit <- changes_per_commit(16, "2019-01-27", "lab2", user_data, "Lab 1", 4)
lab3_changes_to_commit <- changes_per_commit(17, "2019-02-10", "lab3", user_data, "Lab 2", 8)
lab4_changes_to_commit <- changes_per_commit(11, "2019-02-24", "lab4", user_data, "Lab 3", 4)
ggarrange(lab2_changes_to_commit, lab3_changes_to_commit, lab4_changes_to_commit, ncol = 3, nrow = 1 )


#
# Get the distribution of how many test cases have been passed
#
tests_passed <- function(duration, due_date, lab, df, title, num_tests){
  
  lab_df <- preprocess(duration, due_date, lab, df, title)
  
  # replace the placeholder values with the actual number of tests
  lab_df[lab_df$tests_passed == max_val, ]$tests_passed <- num_tests 
  lab_df[lab_df$tests_passed == -1, ]$tests_passed <- 0 
  
  # Drop all rows containing commits afer each respective student's first pass of all test case
  users <- unique(lab_df$username_hash)
  users_df <- as.data.frame(users)
  users_df <- cbind(users_df, tests_passed=0)
  users_df <- merge(x = users_df, y = lab_df[c("section", "username_hash", "day")], by.x = "users", by.y="username_hash", all.x = TRUE)
  users_df <- users_df[!duplicated(users_df), ]
  
  for(user in users){
    user_commits <- lab_df[lab_df$username_hash == user, ]
    user_commits <- user_commits[order(user_commits$timestamp), ]
    #users_df[users_df$users == user, ]$tests_passed <- tail(user_commits, 1)$tests_passed
    users_df[users_df$users == user, ]$tests_passed <- max(user_commits$tests_passed)
  }
  
  users_df.aov <- aov(tests_passed ~ factor(section),data=users_df)
  print("")
  print("Changes ANOVA-----------------------------------------------")
  print(summary(users_df.aov))
  print("------------------------------------------------------------")
  print("")
  
  boxplot <- ggplot(users_df, aes(x = section, y = tests_passed , fill = section)) +
    geom_boxplot() + 
    geom_point(position=position_jitter(h=0.1, w=0.1),
               shape = 21, alpha = 0.5, size = 3) + 
    scale_fill_manual(values = blue_theme) + 
    ggtitle("Tests Passed Distributions")  +
    xlab("")+
    ylab("")  +
    theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")
  boxplot
  
  return(boxplot)  
}

lab2.tests_passed <- tests_passed(16, "2019-01-27", "lab2", user_data, "Lab 1", 4)
lab3.tests_passed <- tests_passed(17, "2019-02-10", "lab3", user_data, "Lab 2", 8)
lab4.tests_passed <- tests_passed(11, "2019-02-24", "lab4", user_data, "Lab 3", 8)
ggarrange(lab2.tests_passed, lab3.tests_passed, lab4.tests_passed, ncol = 3, nrow = 1 )






###########################################################################################################################################
commit_distibution <- function(duration, due_date, lab, df, title, num_tests){
  
  lab_df <- preprocess(duration, due_date, lab, df, title)
  
  # Drop all rows containing commits afer each respective student's first pass of all test case
  users <- unique(lab_df$username_hash)
  users_df <- as.data.frame(users)
  users_df <- cbind(users_df, tests_passed=0)
  users_df <- merge(x = users_df, y = lab_df[c("section", "username_hash", "day")], by.x = "users", by.y="username_hash", all.x = TRUE)
  users_df <- users_df[!duplicated(users_df), ]
  
  
  # replace the placeholder values with the actual number of tests
  lab_df[lab_df$tests_passed == max_val, ]$tests_passed <- num_tests 
  lab_df[lab_df$tests_passed == -1, ]$tests_passed <- 0 
  
  for(user in users){
    user_commits <- lab_df[lab_df$username_hash == user, ]
    print("-------------------------------------------------")
    print(user_commits)
    print("-------------------------------------------------")
    users_df[users_df$users == user, ]$tests_passed <- length(user_commits$tests_passed)
  }
  
  # Get rid of those individuals who did not pass all test cases
  density <- ggplot(users_df, aes(x = section, y = tests_passed, fill=section)) +
    geom_boxplot() +
    geom_point(position=position_jitter(h=0.1, w=0.1),
               shape = 21, alpha = 0.5, size = 3) + 
    scale_fill_manual(values = blue_theme) +    
    ggtitle("Changes to Pass Test Cases")  +
    xlab("") +
    ylab("") +
    theme(plot.title = element_text(hjust=0.5), legend.title = element_blank(), legend.position = "top")
  density
  
  return(density)  
}

lab2_commit_dist <- commit_distibution(16, "2019-01-27", "lab2", user_data, "Lab 1", 4)
lab3_commit_dist <- commit_distibution(17, "2019-02-10", "lab3", user_data, "Lab 2", 8)
lab4_commit_dist <- commit_distibution(11, "2019-02-24", "lab4", user_data, "Lab 3", 8)
ggarrange(lab2_commit_dist, lab3_commit_dist, lab4_commit_dist, ncol = 3, nrow = 1 )




















