
function CriarCertificado {
    # Código para criar o certificado
  $ipv4Address = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -eq 'Dhcp' }).IPAddress

    # Comando para criar um certificado usando o endereço IPv4
    $certificateParams = @{
        NotBefore      = (Get-Date)
        NotAfter       = (Get-Date).AddYears(1)
        Subject        = "CN=$ipv4Address"
        KeyAlgorithm   = "RSA"
        KeyLength      = 2048
        HashAlgorithm  = "SHA256"
        CertStoreLocation = "Cert:\LocalMachine\My"
        KeyUsage       = "KeyEncipherment"
        FriendlyName   = "MeepPrinter HTTPS"
        TextExtension  = @("2.5.29.19={critical}{text}","2.5.29.37={critical}{text}1.3.6.1.5.5.7.3.1","2.5.29.17={critical}{text}DNS=$ipv4Address")
    }

    New-SelfSignedCertificate @certificateParams

    Write-Host "Certificado criado com sucesso."
} else {
    Write-Host "Nenhum endereço IPv4 encontrado na rede atual."
}

function CriarRegrasFirewall {
    # Código para criar regras de firewall
    New-NetFirewallRule -Name "MeepClientHost8589" -DisplayName "Meep Client Host 8589" -Enabled True -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8589
    New-NetFirewallRule -Name "MeepClientHost44340" -DisplayName "Meep Client Host 44340" -Enabled True -Direction Inbound -Action Allow -Protocol TCP -LocalPort 44340
    Write-Host "Portas Criadas"
}

function CriarServico {
    # Código para criar o serviço
    New-Service -Name MeepClientHost -BinaryPathName "C:\ClientHost\ClientHost.exe" -Description "Gateway de Impressão" -DisplayName "Meep - Gateway de Impressão" -StartupType Automatic
}

function CriarAppSettingsSemLocalId {
    # Código para criar o arquivo appsettings.json sem LocalId
    $ipv4Address = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -eq 'Dhcp' }).IPAddress
    $arquivoJson = "C:\ClientHost\appsettings.json"

    $jsonConteudo = @"
{
  "HttpServer": {
    "Endpoints": {
      "Http": {
        "Host": "$ipv4Address",
        "Topic": "",
        "Port": 8589,
        "Scheme": "http"
      },
      "Https": {
        "Host": "$ipv4Address",
        "Port": 44340,
        "Scheme": "https",
        "StoreName": "My",
        "StoreLocation": "LocalMachine"
      }
    }
  },
  "Mqtt": {
    "LocalId": "",
    "PrinterIp": ""
  },
  "Logging": {
    "LogLevel": {
      "Default": "Warning"
    }
  },
  "AllowedHosts": "*"
}
"@

    $jsonConteudo | Set-Content -Path $arquivoJson

    if (Test-Path $arquivoJson) {
        Write-Host "O arquivo appsettings.json foi criado com sucesso em C:\ClientHost"
    } else {
        Write-Host "Falha ao criar o arquivo appsettings.json."
    }
}

function CriarAppSettingsComLocalId {
    # Código para criar o arquivo appsettings.json com LocalId
    # Obtenha o endereço IPv4 do computador
    $ipv4Address = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -eq 'Dhcp' }).IPAddress

    # Defina o caminho do arquivo de destino
    $arquivoJson = "C:\ClientHost\appsettings.json"

    # Solicitar o LocalId do cliente
    $localId = Read-Host "Digite o LocalId do cliente"

    # Defina o conteúdo JSON desejado com o endereço IPv4 atual e o LocalId do cliente
    $jsonConteudo = @"
{
  "HttpServer": {
    "Endpoints": {
      "Http": {
        "Host": "$ipv4Address",
        "Topic": "",
        "Port": 8589,
        "Scheme": "http"
      },
      "Https": {
        "Host": "$ipv4Address",
        "Port": 44340,
        "Scheme": "https",
        "StoreName": "My",
        "StoreLocation": "LocalMachine"
      }
    }
  },
  "Mqtt": {
    "LocalId": "$localId",
    "PrinterIp": "$ipv4Address"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Warning"
    }
  },
  "AllowedHosts": "*"
}
"@

    # Salve o conteúdo no arquivo JSON
    $jsonConteudo | Set-Content -Path $arquivoJson

    # Verifique se o arquivo foi criado com sucesso
    if (Test-Path $arquivoJson) {
        Write-Host "O arquivo appsettings.json foi criado com sucesso em C:\ClientHost."
    } else {
        Write-Host "Falha ao criar o arquivo appsettings.json."
    }
}

function IniciarServico {
    # Código para iniciar o serviço
    try {
        Start-Service -Name "MeepClientHost"
        Write-Host "O serviço MeepClientHost foi iniciado com sucesso."
    } catch {
        Write-Host "O serviço MeepClientHost não pôde ser iniciado. Motivo: $($_.Exception.Message)"
    }
}

do {
    Clear-Host
    Write-Host "Menu Principal"
    Write-Host "1. Criar Certificado"
    Write-Host "2. Criar Regras de Firewall"
    Write-Host "3. Criar Serviço"
    Write-Host "4. Criar AppSettings (sem LocalId)"
    Write-Host "5. Criar AppSettings (com LocalId)"
    Write-Host "6. Iniciar Serviço"
    Write-Host "7. Sair"

    $escolha = Read-Host "Escolha uma opção (1-7):"

    switch ($escolha) {
        "1" { CriarCertificado }
        "2" { CriarRegrasFirewall }
        "3" { CriarServico }
        "4" { CriarAppSettingsSemLocalId }
        "5" { CriarAppSettingsComLocalId }
        "6" { IniciarServico }
        "7" { exit }
        default { Write-Host "Opção inválida. Tente novamente." }
    }

    Read-Host "Pressione Enter para continuar..."
} while ($escolha -ne "7")

Write-Host "Saindo do programa."
