$ErrorActionPreference = "Stop"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Test-PythonVersion {
    param (
        [string]$Version
    )

    & py "-$Version" --version *> $null

    return ($LASTEXITCODE -eq 0)
}

Write-Host "Iniciando projeto Django com padrão Codex Agents..." -ForegroundColor Cyan

Write-Host ""
Write-Host "Versões Python instaladas nesta máquina:" -ForegroundColor Yellow
py -0p

Write-Host ""
$pythonVersion = Read-Host "Informe a versão Python desejada. Exemplo: 3.14, 3.12, 3.11"

Write-Host ""
Write-Host "Verificando se Python $pythonVersion está instalado..." -ForegroundColor Cyan

if (!(Test-PythonVersion -Version $pythonVersion)) {
    Write-Host ""
    Write-Host "Python $pythonVersion não está instalado nesta máquina." -ForegroundColor Red

    $installPython = Read-Host "Deseja tentar instalar o Python $pythonVersion agora? Digite S para sim ou N para não"

    if ($installPython -eq "S" -or $installPython -eq "s") {
        Write-Host ""
        Write-Host "Tentando instalar Python $pythonVersion com o Python Launcher..." -ForegroundColor Cyan
        py install $pythonVersion

        Write-Host ""
        Write-Host "Atualizando lista de versões instaladas..." -ForegroundColor Yellow
        py -0p

        Write-Host ""
        Write-Host "Validando instalação do Python $pythonVersion..." -ForegroundColor Cyan

        if (!(Test-PythonVersion -Version $pythonVersion)) {
            Write-Host ""
            Write-Host "ERRO: Não foi possível validar a instalação do Python $pythonVersion." -ForegroundColor Red
            Write-Host "Instale manualmente e rode o script novamente." -ForegroundColor Yellow
            exit 1
        }

        Write-Host "Python $pythonVersion instalado e validado com sucesso." -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "Instalação cancelada. Rode novamente escolhendo uma versão já instalada." -ForegroundColor Yellow
        exit 1
    }
}
else {
    Write-Host "Python $pythonVersion encontrado." -ForegroundColor Green
}

Write-Host ""
Write-Host "Criando ambiente virtual..." -ForegroundColor Cyan

if (Test-Path ".venv") {
    Write-Host "A pasta .venv já existe." -ForegroundColor Yellow
    $recreateVenv = Read-Host "Deseja remover e recriar a .venv? Digite S para sim ou N para não"

    if ($recreateVenv -eq "S" -or $recreateVenv -eq "s") {
        Remove-Item -Recurse -Force ".venv"
        Write-Host ".venv removida." -ForegroundColor Yellow
    }
    else {
        Write-Host "Usando .venv existente." -ForegroundColor Yellow
    }
}

if (!(Test-Path ".venv")) {
    & py "-$pythonVersion" -m venv .venv
}

if (!(Test-Path ".venv\Scripts\python.exe")) {
    Write-Host "ERRO: A venv não foi criada corretamente." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Atualizando pip dentro da venv..." -ForegroundColor Cyan
.\.venv\Scripts\python.exe -m pip install --upgrade pip

Write-Host ""
Write-Host "Instalando dependências..." -ForegroundColor Cyan

if (!(Test-Path "requirements.txt")) {
    Write-Host "ERRO: requirements.txt não encontrado na raiz do projeto." -ForegroundColor Red
    exit 1
}

.\.venv\Scripts\python.exe -m pip install -r requirements.txt

Write-Host ""
Write-Host "Verificando Django..." -ForegroundColor Cyan
.\.venv\Scripts\python.exe -m django --version

if (!(Test-Path "manage.py")) {
    Write-Host ""
    Write-Host "Criando projeto Django..." -ForegroundColor Cyan
    .\.venv\Scripts\django-admin.exe startproject config .
}
else {
    Write-Host "manage.py já existe. Pulando criação do projeto Django." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Validando projeto Django..." -ForegroundColor Cyan
.\.venv\Scripts\python.exe manage.py check

Write-Host ""
Write-Host "Projeto inicializado com sucesso!" -ForegroundColor Green

Write-Host ""
Write-Host "Para ativar a venv, use:" -ForegroundColor Yellow
Write-Host ".\.venv\Scripts\Activate.ps1"
