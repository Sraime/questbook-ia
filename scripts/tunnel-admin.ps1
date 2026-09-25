# Ouvre le tunnel SSH qui donne acces au backoffice du VPS.
#
# Le backoffice n'est pas sur Internet : son conteneur publie sur la boucle
# locale du VPS et Caddy ne le connait pas. Ce tunnel est la seule porte.
#
#   .\questbook-ia\scripts\tunnel-admin.ps1
#
# Puis, dans un autre terminal :
#
#   cd questbook-back\admin-web ; npm run dev
#
# Ctrl+C ici referme le tunnel.
$ErrorActionPreference = "Stop"

$VpsUser = "debian"
$VpsHost = "151.80.144.246"
$VpsPort = 2222
$AdminPort = 4000
$Key = Join-Path $env:USERPROFILE ".ssh\questbook_vps_ed25519"

if (-not (Test-Path $Key)) {
    Write-Host "Cle introuvable : $Key" -ForegroundColor Red
    Write-Host "C'est la meme que pour le deploiement. La recopier depuis le gestionnaire"
    Write-Host "de mots de passe, puis relancer."
    exit 1
}

# Le garde-fou qui compte.
#
# Le front proxie vers 127.0.0.1:4000 dans les deux cas, en local comme a
# travers ce tunnel : **rien a l'ecran ne distingue le VPS de la machine**. Si
# `npm run dev:admin` tourne deja, ssh ne pourra pas prendre le port, et l'on
# se retrouverait a moderer la base de dev en croyant tenir la production --
# ou l'inverse, bien pire.
$occupe = Get-NetTCPConnection -LocalPort $AdminPort -State Listen -ErrorAction SilentlyContinue
if ($occupe) {
    Write-Host "Le port $AdminPort est deja pris sur cette machine." -ForegroundColor Red
    Write-Host ""
    Write-Host "C'est probablement l'API d'administration locale (npm run dev:admin),"
    Write-Host "ou un tunnel deja ouvert. Il faut l'arreter : le front ne fait pas la"
    Write-Host "difference entre les deux, et se tromper de base ici veut dire suspendre"
    Write-Host "un vrai compte en croyant jouer avec des donnees de dev."
    Write-Host ""
    $occupe | ForEach-Object {
        $p = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        if ($p) { Write-Host "  PID $($p.Id)  $($p.ProcessName)" }
    }
    exit 1
}

Write-Host ""
Write-Host "  ===  PRODUCTION  ===" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Ce tunnel branche http://localhost:$AdminPort sur le backoffice du VPS."
Write-Host "  Les comptes, les tables et les signalements y sont ceux des vrais"
Write-Host "  joueurs. Suspendre ou fermer depuis cet ecran a des consequences."
Write-Host ""
Write-Host "  Front : cd questbook-back\admin-web ; npm run dev"
Write-Host "  Ctrl+C pour refermer."
Write-Host ""

# -N : pas de commande distante, on ne veut qu'une redirection.
# ExitOnForwardFailure : sans cela, ssh ouvre la session meme quand le port
#   local est refuse, et laisse croire que le tunnel tient.
# ServerAliveInterval : une soiree de moderation depasse les delais d'inactivite
#   des equipements intermediaires.
ssh -i $Key -p $VpsPort -N `
    -L "${AdminPort}:127.0.0.1:${AdminPort}" `
    -o ExitOnForwardFailure=yes `
    -o ServerAliveInterval=30 `
    -o ServerAliveCountMax=3 `
    "$VpsUser@$VpsHost"
