import(httr)
import(jsonlite)
import(dplyr)
import(tibble)
import(modules)
import(magrittr)



fetch <- function() {
  r <- GET(
    "https://www.vinbudin.is/addons/origo/module/ajaxwebservices/search.asmx/DoSearch?&skip=0&count=10000000",
    content_type_json()
  )
  
  data <- r$content %>%
    rawToChar() %>%
    fromJSON() %>%
    paste() %>%
    fromJSON(flatten = T)
  
  data <- data$data %>%
    as_tibble()
  
  data <- data %>%
    select(ProductName, ProductBottledVolume, ProductAlchoholVolume, ProductCategory.name, ProductPrice) %>%
    rename("ProductCategory" = ProductCategory.name, "ProductAlcoholVolume" = ProductAlchoholVolume) %>%
    mutate(ProductCategory = factor(ProductCategory), ProductAlcoholVolume = ProductAlcoholVolume/100) %>%
    relocate(ProductName, ProductBottledVolume, ProductAlcoholVolume, ProductPrice, ProductCategory) %>%
    mutate(AlcoholPricePer_mL = ProductPrice / (ProductBottledVolume * ProductAlcoholVolume))
  
  return(data)
}