# Clone les depots produit dans ce dossier de travail. Idempotent : un depot
# deja present est laisse tel quel, jamais ecrase ni mis a jour de force.
$ErrorActionPreference = "Stop"

Set-Location (Join-Path $PSScriptRoot "..")

foreach ($repo in "questbook-app", "questbook-back") {
    if (Test-Path (Join-Path $repo ".git")) {
        Write-Host "$repo : deja present, ignore"
    } else {
        Write-Host "$repo : clonage..."
        git clone "git@github.com:Sraime/$repo.git" $repo
    }
}

Write-Host ""
Write-Host "Ouvre maintenant ce dossier comme dossier de travail, pas l'un des"
Write-Host "depots : les regles de .cursor/rules/ se chargent depuis cette racine."
