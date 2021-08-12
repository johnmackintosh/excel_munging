suppressPackageStartupMessages(library(rio))
suppressPackageStartupMessages(library(readxl))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(data.table))


files <- dir(pattern = "*.xlsx")  # in case anything else sneaks into folder

# base R for the lo-fi crew
method_lapply <- lapply(files, read_excel)
method_lapply <- do.call(rbind, Map(data.frame, method_lapply))
head(method_lapply)

# purrr for the tidyverts

method_purrr <- map_dfr(files, read_excel, sheet = "Manchester")
str(method_purrr)


method_purrr2 <- map_dfr(files, read_excel, sheet = "London", .id = "source_wb")
method_purrr2 %>% select(source_wb) %>% distinct()
method_purrr2

# use set_names
method_purrr3 <- files %>% 
set_names() %>% 
map_dfr(read_excel, sheet = "Manchester",.id = "source_wb")
str(method_purrr3)
method_purrr3 %>% select(source_wb) %>% distinct()

# for loop and data.table for the hardcore

filecount <- as.numeric(length(files))  
temp_list <- list()

for (i in seq_along(files)) {
  filename <- files[i] 
  df <- read_excel(path = filename, sheet = "Manchester")
  df$source_wb <- filename
  temp_list[[i]] <- df
  rm(df)
 method_datatable <- data.table::rbindlist(temp_list, fill = TRUE) 
} 
rm(temp_list)
str(method_datatable)



# rio 

method_rio <-  import_list(files, rbind = TRUE, sheet = "Manchester")
str(method_rio)

method_rio2 <-  import_list(files, rbind = TRUE, rbind_label = "source_wb", sheet = "London")
str(method_rio2)


