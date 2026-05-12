Write-Host "Iniciando projeto Django com padrão Codex Agents..." -ForegroundColor Cyan

Write-Host "Versões Python disponíveis:"
py -0p

$pythonVersion = Read-Host "Informe a versão Python desejada. Exemplo: 3.14, 3.12, 3.11"

Write-Host "Criando ambiente virtual..."
py -$pythonVersion -m venv .venv

Write-Host "Ativando ambiente virtual..."
& .\.venv\Scripts\Activate.ps1

Write-Host "Atualizando pip..."
python -m pip install --upgrade pip

Write-Host "Instalando dependências..."
pip install -r requirements.txt

if (!(Test-Path "manage.py")) {
    Write-Host "Criando projeto Django..."
    django-admin startproject config .
} else {
    Write-Host "manage.py já existe. Pulando criação do projeto Django."
}

Write-Host "Validando Django..."
python manage.py check

Write-Host "Projeto inicializado com sucesso!" -ForegroundColor Green