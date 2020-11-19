[![Build Status](https://travis-ci.com/guberArmin/eksamen-infrastructure.svg?token=m6BpjWymm3UWnZ6QxDwC&branch=main)](https://travis-ci.com/guberArmin/eksamen-infrastructure)

## Konfigurasjon av hemligheter - infrastruktur
- logz.io token: `travis encrypt LOGZ_TOKEN=<your-token> --add`
- statuscake key: `travis encrypt STATUSCAKE_KEY=<your-key> --add`  
- opsgenie key: `travis encrypt OPSGENIE_KEY=<your-key> --add`  
    - For å hente opsgenie nøkkel må man gjøre følgende
        - Opprette [ny konto](https://www.atlassian.com/software/opsgenie)
        - Opp til høyre trykk på profil (sirkel med initialer av bruker navn)
        - Velg profil settings
        - API key managment
        - Add new API key
        - Velg navn
        - `Read`, `Create and Update`, `Delete`, `Configuration Access` for api key må vøre på
- Man kan bruke GCP service account som brukes på [applikasjon repoen](https://github.com/guberArmin/devops-exam#konfigurasjon-av-hemligheter---applikasjon).
- I `.travis.yml` endre på  `GCP_PROJECT_ID=<project-id>`

## Om infrastruktur
Terraform state lagres i google cloud bucket.

Alle hemligheter er lagret i `variables.tf`.

### Opsgenie

Her valgte jeg å opprette 4 brukere. To av dem er fra Europa og to er fra USA.

Da oppretter jeg 2 lag, en Europeisk og en Amerikansk.

Jeg bruker `opsgenie_alert_policy` for å oprette varsling policy for begge lag.
Europeisk lag har hoved ansvar og må være tillgjenlije fra mandag til fredag når som helst. Og lørdager og søndager i en vis periode.

Amerikansk lag er uerfarene utviklere, som skal bare være en støtte lag ti europeisk.
De får alerts bare fra 08:00 til 23:00 hver dag. Da kan de eventuelt avlaste europeisk lag (hovedsaklig i 
veldig sene tidspunkter for europeisk lag), hvis det handler om en mindre avorlig situasjon 
og de kan løse den.
Dessvere `opsgenie_alert_policy` er en betalt funksjonalitet som jeg har skjønt litt for seint.
Men jeg valgte å beholde infrastrukturen jeg har laget. Fordi terraform klare å bygge uten å feile, selv om
det handler om betalt funksjonalitet.

Også bruker jeg `opsgenie_notification_policy` for europeisk lag med en delay, slik at Amerikansk lag får 
tid til å prøve å fixe

