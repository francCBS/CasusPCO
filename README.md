# CasusPCO
Casus 1 PCO - november 2026

Algemeen:

Dit proces berekent de kwartaalmutatie van de consumentenprijs van twee gekozen producten. Het proces bestaat uit de volgende stappen:

Stap 0: Packages en functies laden, parameters instellen

In deze stap worden packages en functies geladen. Tevens kunnen de producten worden gekozen. Deze worden opgeslagen in de vector ‘mijnproducten’.

Stap 1: CPI-data ophalen en bewerken

Met de functie cbs_get_data worden alle CPI cijfers opgehaald uit tabel 83131: Consumentenprijzen; prijsindex 2015=100, 1996-2025
Daaruit worden de maandcijfers geselecteerd, deze worden gefilterd op de gekozen producten en in het dataframe cpi_data_mijnproducten gezet. Tevens wordt bij elke maand het kwartaalnummer afgeleid, zodat daar in het vervolg op gegroepeerd kan worden.

Stap 2: CPI per kwartaal berekenen

Per kwartaal wordt het gemiddelde berekenen, gegroepeerd op product en kwartaalnummer. Het resultaat komt in cpi_data_mijnproducten_kwartaal.

Stap 3: Vorig kwartaal en CPI vorig kwartaal toevoegen, kwartaalmutaties berekenen

Bij elk kwartaal wordt het vorige kwartaal bepaald m.b.v. de functie ‘vorig_kwartaal’ (die in stap 0 is ingeladen via Casus_1_functions.R).
cpi_data_mijnproducten_kwartaal wordt gejoined met zichzelf op de sleutels product, en kwartaal = vorig kwartaal.
Deze kolommen worden toegevoegd: CPI_1 = CPI in vorig kwartaal, kwartaalmutatie = CPI_1/CPI

Stap 4: Grafieken maken

In deze stap worden grafieken getoond van de CPI en kwartaalmutaties behorende bij de gekozen producten.
