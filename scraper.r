library(rvest)
library(tidyverse)
library(openxlsx)
library(dplyr)

# MSISAC parse through advisory page

# Take URL and put into rvest, which is beautifulsoup equivalent
url <- "https://www.cisecurity.org/advisory"
cve_list <- list()

# Read the HTML from the advisory page
CIShtml <- read_html(url)

# Title Parser
title <- html_nodes(CIShtml, ".c-list-link") %>% html_text()
print(title)

# Date Parser
date <- html_nodes(CIShtml, ".c-list-date") %>% html_text()
print(date)

# Gather href links for each advisory on the main page
link <- html_nodes(CIShtml, ".c-list-link") %>% html_attr("href")
linked_url <- paste0("https://www.cisecurity.org", link)

# Create a data frame to store the Title, Date, and CVE information
df1 <- data.frame(
  Title = title,
  Date = date,
  CVE = NA,  # Placeholder for CVEs
  stringsAsFactors = FALSE
)

# Loop through each advisory link
for (i in seq_along(linked_url)) {
  file <- file.path(linked_url[i])
  
  # Parse through each connected advisory page
  CIShtml_2 <- read_html(file)
  
  # Extract all div elements in the reference list that may contain CVE info
  a_tags_linked <- html_nodes(CIShtml_2, ".reference-list div") %>% html_text()
  
  # Initialize a placeholder to collect CVEs for the current advisory
  cve_collected <- c()
  
  # Find all text that contains CVEs
  for (a_tag_linked in a_tags_linked) {
    if (grepl("CVE", a_tag_linked)) {
      # Get the substring of the individual CVE
      cvematch <- gregexpr("CVE-\\d+-\\d+", a_tag_linked)
      result <- regmatches(a_tag_linked, cvematch)
      
      # Append CVEs to the collected list if found
      if (length(result) > 0) {
        cve_collected <- c(cve_collected, unlist(result))
      }
    }
  }
  
  # If CVEs were found, add them to the data frame, else mark as NA
  if (length(cve_collected) > 0) {
    df1$CVE[i] <- paste(cve_collected, collapse = ",")
  } else {
    df1$CVE[i] <- NA
  }
}

# Print the final data frame
print(df1)

# Export the data to an Excel file
write.xlsx(df1, file = "CVE_Test-Table.xlsx")
