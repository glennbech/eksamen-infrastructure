[![Build Status](https://travis-ci.com/guberArmin/eksamen-infrastructure.svg?token=m6BpjWymm3UWnZ6QxDwC&branch=main)](https://travis-ci.com/guberArmin/eksamen-infrastructure)


# Innholdsfortegnelse
- [Konfigurasjon av hemmeligheter - infrastruktur](#konfigurasjon-av-hemmeligheter---infrastruktur)
- [Om infrastruktur](#om-infrastruktur)
  * [Pagerduty](#pagerduty)
  * [Kjente bugs](#kjente-bugs)

## Konfigurasjon av hemmeligheter - infrastruktur
- logz.io token: `travis encrypt LOGZ_TOKEN=<your-token> --add`
- statuscake key: `travis encrypt STATUSCAKE_KEY=<your-key> --add`  
- Pagerduty key: `travis encrypt PAGERDUTY_TOKEN=<your-key> --add`  
    - For å opprette nøkkelen til pagerduty må man gjøre følgende:
        - Man trykker på `API access` under ikonet ![Addon ikone](./doc/addon_img.png "Addon ikonet")
        - `Create new API key`
        - Velge navn for nøkkelen
        - Trykk på `Create Key`
- Man kan bruke GCP service account som brukes på [applikasjon repoen](https://github.com/guberArmin/devops-exam#konfigurasjon-av-hemmeligheter---applikasjon).
- I `.travis.yml` endre på  `GCP_PROJECT_ID=<project-id>`

## Om infrastruktur
Terraform state lagres i google cloud bucket.

Alle hemligheter fra `travis` lagres i `variables.tf`, i løpe av bygge prossesen, ved å bruke `export TF_VAR...`.

### Pagerduty

Terraform doukmentasjon finner man [her](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs)

Her valgte jeg å opprette 4 brukere. To av dem er fra Europa og to er fra Amerika.

Da oppretter jeg 2 lag, en Europeisk og en Amerikansk og legger inn i de tilsvarende brukere.

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
- Neste steg er konfigurering av status cake.
For å fullføre integrering med statuscake må man fullføre stegene beskrevet [her](https://www.pagerduty.com/docs/guides/statuscake-integration-guide/) 
under `In StatusCake` avsnitte.

### Kjente bugs

Jeg har testet alt grundig og fant ikke noen feil med infrastrukturen.

Jeg har, en gang i starten av utvikling av dette prosjektet, fått melding 
`terraform multiple providers trying to lock state file` i travis.
Det viste seg at hvis man gjør flere push i kort tidsperiode og travis har de i 
qø kan det hende at `lock state` blir ikke ryddet opp før neste bygg starter. 
Hvis dette oppstår da kan man bruke 
[force-unlock -force](https://www.terraform.io/docs/commands/force-unlock.html)
eller i `eksamen-terraform-state` bucket på google cloud console slette lock filen manuelt.


