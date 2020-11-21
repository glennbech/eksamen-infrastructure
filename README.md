[![Build Status](https://travis-ci.com/guberArmin/eksamen-infrastructure.svg?token=m6BpjWymm3UWnZ6QxDwC&branch=main)](https://travis-ci.com/guberArmin/eksamen-infrastructure)

<path d="M3 21H11V13H3M5 15H9V19H5M3 11H11V3H3M5 5H9V9H5M13 3V11H21V3M19 9H15V5H19M18 16H21V18H18V21H16V18H13V16H16V13H18Z"></path>
# Innholdsfortegnelse
- [Konfigurasjon av hemmeligheter - infrastruktur](#konfigurasjon-av-hemligheter---infrastruktur)
- [Om infrastruktur](#om-infrastruktur)
  * [Pagerduty](#pagerduty)

## Konfigurasjon av hemmeligheter - infrastruktur
- logz.io token: `travis encrypt LOGZ_TOKEN=<your-token> --add`
- statuscake key: `travis encrypt STATUSCAKE_KEY=<your-key> --add`  
- Pagerduty key: `travis encrypt PAGERDUTY_TOKEN=<your-key> --add`  
- Man kan bruke GCP service account som brukes på [applikasjon repoen](https://github.com/guberArmin/devops-exam#konfigurasjon-av-hemligheter---applikasjon).
- I `.travis.yml` endre på  `GCP_PROJECT_ID=<project-id>`

## Om infrastruktur
Terraform state lagres i google cloud bucket.

Alle hemligheter er lagret i `variables.tf`.

### Pagerduty

Her valgte jeg å opprette 4 brukere. To av dem er fra Europa og to er fra Amerika.

Da oppretter jeg 2 lag, en Europeisk og en Amerikansk.

Jeg lager schedule til hver lag. Det jeg har tenkt er at Europeisk lag skal ha ansvar for drift av applikasjon fra 07:00 til 19:00 hver dag (lokal tid).
Mens amerikansk lag skal drifte applikasjon fra 19:00 til 07:00 neste dagen (europeisk tid). Det vil si, etter
at man har tatt tidssoner i beregning, at de starter 12:00 og jobber til 00:00 lokal tid. På denne måten ingen av
lag må jobbe etter 00:00.

Til slutt lager jeg escalation policy for å håndtere måten lag skal varsles på.

For å integrere statuscake med pagerduty har je oprettet `pagerduty-statuscake-integration.tf`. Her oppretter
jeg infrastrukturen på pagerduty sin side som trenges for å integrere den med statuscake.

Integrasjon med statuscake fuflføres på følgende måten:
- Først skal vi bruke informasjon fra infrastrukturen som er opprettet av terraform
    - Loggin på [PagerDuty](https://www.pagerduty.com/)
    - Trykk på `Services`
    - Nå kommer du til å se `Eksamen web app - statuscake` service
    - Der trykker man på `More` og `View integrations` 
    - I nå varende vindu kopierer man `Integration key`
- Neste steg er konfigurering av status cake. For å gjøre det [her](https://www.pagerduty.com/docs/guides/statuscake-integration-guide/).
For å fullføre integrering med statuscake må man fullføre stegene beskrevet [her](https://www.pagerduty.com/docs/guides/statuscake-integration-guide/) 
under `In StatusCake` avsnitte.



