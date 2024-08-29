install.packages("rvest")
install.packages("tidyverse")

#Other scaper is called scraper.py
#For MSISAC parse through advisory page

#Take URL and put into rvest, which is beautifulsoup equivalent. It will read the url

url <- "https://www.cisecurity.org/advisory"

#Equivalent of response.content (I believe)
CIShtml <- read.html(url)

#Title Parser
#Equivalent of .find_all and .get text in one line
title = html_nodes(CIShtml, .c-list-link) %>% html_text()

#CVE Parser

for(a_tag in title){
  #gather href links for each advisory on each page
  link = title %>% html_attr("href")
  linked_url <- file.path(url, link)

  #parse through connected page
  CIShtml_2 <- read.html(linked_url)

  #find all linked pages with CVE in title of a tag
  }


#Date Parser
date = html_nodes(CIShtml, .c-list-date) %>% html_text()
