library(rvest)
library(tidyverse)
library(openxlsx)
library(dplyr)


#Other scaper is called scraper.py
#For MSISAC parse through advisory page

#Take URL and put into rvest, which is beautifulsoup equivalent. It will read the url

url <- "https://www.cisecurity.org/advisory"
cve_list <- list()

#You may want to start looping through pages from here
#Equivalent of response.content
CIShtml <- read_html(url)

#Title Parser
#Equivalent of .find_all and .get text in one line
title = html_nodes(CIShtml, ".c-list-link") %>% html_text()
print(title)

#Date Parser
date = html_nodes(CIShtml, ".c-list-date") %>% html_text()
print(date)

#CVE Parser

for(a_tag in title){
  #gather href links for each advisory on each page
  link = html_nodes(CIShtml, ".c-list-link") %>% html_attr("href")
  linked_url <- paste0("https://www.cisecurity.org", link)
  
  df1 <- data.frame(
    Title = title,
    Date = date,
    CVE = NA,
    stringsAsFactors = FALSE
  )
  
  for(i in seq_along(linked_url)){
    file <- file.path(linked_url[i])
    #parse through each connected page
    CIShtml_2 <- read_html(file)
  
    a_tags_linked = html_nodes(CIShtml_2, ".reference-list div") %>% html_text()
    
    #find all linked pages with CVE in title of a tag
    for(a_tag_linked in a_tags_linked){
      #grepl is equivalent of x in y or contains
      if (grepl("CVE", a_tag_linked)){
      #get only substring of individual CVE (possibly use gregexpr)
      cvematch <- gregexpr("CVE-\\d+-\\d+", a_tags_linked)
      result <- regmatches(a_tags_linked, cvematch)
      #get all results per link
      if(length(result) > 0){
       df1$CVE[i] <- paste(unlist(result), collapse = ",")
      #print(result)
      } else{
        df1$CVE[i] <- NA
      }
      
  }
}
}



}
#After fixing the above, the scrapper must save information to a table (possibly use data frame) and
#export to excel
#write.xlsx(table, file = "CVE_Test-Table.xlsx")

