library(rvest)
library(tidyverse)

#Other scaper is called scraper.py
#For MSISAC parse through advisory page

#Take URL and put into rvest, which is beautifulsoup equivalent. It will read the url

url <- "https://www.cisecurity.org/advisory"

#You may want to start looping through pages from here
#Equivalent of response.content
CIShtml <- read_html(url)

#Title Parser
#Equivalent of .find_all and .get text in one line
title = html_nodes(CIShtml, ".c-list-link") %>% html_text()
print(title)
#CVE Parser

for(a_tag in title){
  #gather href links for each advisory on each page
  link = html_nodes(CIShtml, ".c-list-link") %>% html_attr("href")
  linked_url <- paste0("https://www.cisecurity.org", link)
  
  
  for(link in linked_url){
    file <- file.path(link)
    #parse through each connected page
    CIShtml_2 <- read_html(file)
  
    a_tags_linked = html_nodes(CIShtml_2, ".reference-list div") %>% html_text()
    
    #find all linked pages with CVE in title of a tag
    for(a_tag_linked in a_tags_linked){
      #grepl is equivalent of x in y or contains
      if (grepl("CVE", a_tag_linked)){
      #get only substring of CVE (possibly use gregexpr)
      cvematch <- gregexpr("CVE-\\d+-\\d+", a_tags_linked)
      result <- regmatches(a_tags_linked, cvematch)
      print(result)
      } else{
        print("No CVE Found")
      }
      
  }
}
}
#Date Parser
date = html_nodes(CIShtml, ".c-list-date") %>% html_text()
print(date)
#put info into data frame
#table = data.frame(title, date, all_results, stringsAsFactors = FALSE)
#After fixing the above, the scrapper must save information to a table (possibly use data frame) and
#export to excel
#After fixing the above, the scrapper must loop through every page, save information to a table (possibly use data frame) and
#export to excel
