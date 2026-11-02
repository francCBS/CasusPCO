# Uitwerking casus 1, ENR-PCO
# Franc Straetemans, november 2026



# 0. Packages en functies laden, parameters instellen

# Packages laden
library(dplyr)
library(cbsodataR)

source("functions.R")

# Ik kies deze producten (groepen/coicops): 032110 Herenschoenen, 032120 Damesschoenen
mijnproducten <- c("CPI032110", "CPI032120")



# 1. CPI-data ophalen en bewerken

# Alle CPI-data uit Statline tabel 83131
cpi_data <- cbs_get_data("83131NED")

# Dataframe met de CPI van de gekozen producten 
# toegevoegd: kwartaalnummer om op te kunnen groeperen
# gefilterd op maandcijfers (want tabel 83131 bevat ook jaarcijfers)
cpi_data_mijnproducten <- cpi_data |>
  filter(Bestedingscategorieen %in% mijnproducten) |>
  filter(substring(Perioden,5,6) == "MM") |>
  select(Bestedingscategorieen, Perioden, CPI_1) |>
  mutate(Kwartaal = paste0(substring(Perioden,1,4) , 
                           "Q" ,
                           case_when(
                             substring(Perioden,7,8) %in% c("01","02","03") ~ "1",
                             substring(Perioden,7,8) %in% c("04","05","06") ~ "2",
                             substring(Perioden,7,8) %in% c("07","08","09") ~ "3",
                             substring(Perioden,7,8) %in% c("10","11","12") ~ "4"
                           ) 
                           )
         )



# 2. CPI per kwartaal berekenen

# Per kwartaal het gemiddelde berekenen, gegroepeerd op categorie en kwartaalnummer
cpi_data_mijnproducten_kwartaal <- cpi_data_mijnproducten |>
  group_by(Bestedingscategorieen, Kwartaal) |>
  summarise(CPI = mean(CPI_1))



# 3. Vorig kwartaal en CPI vorig kwartaal toevoegen, kwartaalmutaties berekenen

# Kwartaal_1 = vorig kwartaal toevoegen aan cpi_data_mijnproducten_kwartaal
cpi_data_mijnproducten_kwartaal$Kwartaal_1 <- vorig_kwartaal(cpi_data_mijnproducten_kwartaal$Kwartaal)

# Join cpi_data_mijnproducten_kwartaal met zichzelf op de sleutels: product, en kwartaal = vorig kwartaal
# Voeg kolommen toe: CPI_1 = CPI in vorig kwartaal, kwartaalmutatie = CPI_1/CPI
# Kolommen hernoemen met transmute
CPI_kwartaalmutaties_mijnproducten <- cpi_data_mijnproducten_kwartaal |>
  left_join(cpi_data_mijnproducten_kwartaal, by = c("Bestedingscategorieen" = "Bestedingscategorieen" , "Kwartaal_1" = "Kwartaal")) |>
  transmute(Product = Bestedingscategorieen,
            Kwartaal = Kwartaal,
            Kwartaal_1 = Kwartaal_1,
            CPI = CPI.x,
            CPI_1 = CPI.y,
            Kwartaalmutatie = CPI_1/CPI )



# 4. Grafieken maken

cpi_data_product1_kwartaal <- cpi_data_mijnproducten_kwartaal |>
  filter(Bestedingscategorieen == mijnproducten[1])

cpi_data_product2_kwartaal <- cpi_data_mijnproducten_kwartaal |>
  filter(Bestedingscategorieen == mijnproducten[2])

kwartaalmutaties_product1 <- CPI_kwartaalmutaties_mijnproducten |>
  filter(Bestedingscategorieen == mijnproducten[1])

kwartaalmutaties_product2 <- CPI_kwartaalmutaties_mijnproducten |>
  filter(Bestedingscategorieen == mijnproducten[2])


# Grafieken CPI

plot(as.factor(cpi_data_product1_kwartaal$Kwartaal), cpi_data_product1_kwartaal$CPI, 
      type = "l", 
      col = "red", 
      ylim = c(min(cpi_data_product1_kwartaal$CPI, cpi_data_product2_kwartaal$CPI), 
              max(cpi_data_product2_kwartaal$CPI, cpi_data_product2_kwartaal$CPI))
      )

# Grafiek voor product2 in zelfde plot tonen
lines(as.factor(cpi_data_product2_kwartaal$Kwartaal), cpi_data_product2_kwartaal$CPI, 
      type = "l", 
      col = "blue")



# Grafieken kwartaalmutaties

plot(as.factor(kwartaalmutaties_product1$Kwartaal), kwartaalmutaties_product1$Kwartaalmutatie, 
     type = "l", 
     col = "red",
     ylim = c(0.5, 1.5)
)

# Grafiek voor product2 in zelfde plot tonen
lines(as.factor(kwartaalmutaties_product2$Kwartaal), kwartaalmutaties_product2$Kwartaalmutatie, 
      type = "l", 
      col = "blue")
