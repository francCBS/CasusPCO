
# Hulpfunctie vorig_kwartaal. 
# Doel: bij gegeven verslagperiode (kwartaal) het voorgaande kwartaal te bepalen
# Aanname: de verslagperiode is een string van de vorm "1996Q1" (hier kan uiteraard op gecontroleerd worden)

vorig_kwartaal <- function(verslagperiode) {
  
  jaar <- as.numeric(substring(verslagperiode,1,4))
  kwartaalnummer <- as.numeric(substring(verslagperiode,6,7)) - 1
  
  jaar <- ifelse(kwartaalnummer == 0, jaar-1, jaar)
  kwartaalnummer <- ifelse(kwartaalnummer == 0, 4, kwartaalnummer)
  
  paste0(jaar , "Q", kwartaalnummer)
  
}

