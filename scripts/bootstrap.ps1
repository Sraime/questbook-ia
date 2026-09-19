# Prepare le dossier de travail qui contient ce depot : clone les depots
# produit a cote, et expose les regles a la racine. Idempotent.
$ErrorActionPreference = "Stop"

$iaDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$workspace = Split-Path $iaDir -Parent
Set-Location $workspace

foreach ($repo in "questbook-app", "questbook-back") {
    if (Test-Path (Join-Path $repo ".git")) {
        Write-Host "$repo : deja present, ignore"
    } else {
        Write-Host "$repo : clonage..."
        git clone "git@github.com:Sraime/$repo.git" $repo
    }
}

# Cursor ne documente le chargement des regles qu'a la racine du dossier
# ouvert. Un lien les y expose sans en garder ici une copie non versionnee,
# qui divergerait tot ou tard de celle du depot.
#
# Une jonction plutot qu'un lien symbolique : Windows exige des privileges
# pour le second, aucun pour la premiere.
New-Item -ItemType Directory -Path .cursor -Force | Out-Null
if (Test-Path .cursor\rules) {
    Write-Host ".cursor\rules : deja present, ignore"
} else {
    New-Item -ItemType Junction -Path .cursor\rules `
        -Target (Join-Path $iaDir ".cursor\rules") | Out-Null
    Write-Host ".cursor\rules : jonction creee vers $(Split-Path $iaDir -Leaf)"
}

Write-Host ""
Write-Host "Ouvre maintenant $workspace comme dossier de travail, pas l'un des"
Write-Host "depots : les regles se chargent depuis cette racine."
