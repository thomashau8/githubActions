# django-pipeline-template
CI/CD-pipeline development repo

VELKOMMEN TIL STUDENT IMPLEMENTASJON AV DEVOPS

versjon 0.5 (alpha)

Husk at betalt versjon av GitHub er nok nødvendig(?) for tilgang til codeQL 

Se gjerne gjennom koden, det er kommentarer som forteller hva som må gjøres videre og evt forbedringer. 

koden foreløpig forutser at man oppretter på forhånd i Azure:
- Miljøer
- Database server og databaser
- Blob storages (static-prod/staging/review)
- Vnet konfigurasjoner
- Container Apps Job
- Resource group

Dobbelsjekk gjerne teknologi bruken om det er den dere vil ha (de forskjellig jobbene spesifisert i actions folderen)

Deploy-manifests folder er for template konfigurasjoner til opprettelse av ny containere (eller replicas) ved kjøring.

I "run-aca-migration-job" ligger konfigurasjoner for jobben som blir endret i workflow run

Lykke til 😎👌
