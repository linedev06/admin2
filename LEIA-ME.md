# beyond admin (Flutter, Windows e celular)

Painel da Beyond para ver UpYou e keepYou em tempo real. Direção A aprovada nos mockups.
Hoje roda com dados de exemplo e eventos simulados a cada 7 segundos.

## Rodar no Windows
1. Instale o Flutter e ative o desktop: `flutter config --enable-windows-desktop`
2. Abra a pasta no Android Studio ou no terminal, dentro de `beyond_admin`:
   `flutter create --platforms=windows,android .`
   (cria as pastas windows/ e android/ sem mexer em lib/, assets/ e pubspec.yaml)
3. `flutter pub get`
4. `flutter run -d windows`

No Android Studio escolha "Windows (desktop)" no seletor de dispositivos e clique em Run.
Se a janela ficar estreita (menos de 900 px), o app muda sozinho para o layout de celular.

## Onde ligar aos dados reais
Tudo passa por `lib/data.dart`, classe `Repo`. As listas `pessoas`, `pedidos`,
`cobrancas` e `eventos` e os contadores no topo são o que as telas leem.
Para o Supabase, troque o conteúdo do `Repo` mantendo os mesmos nomes:
carregar as listas, assinar o Realtime para alimentar `eventos` e chamar
`notifyListeners()`, e fazer `aprovar`, `recusar`, `lembrar` e `pausar` gravarem no banco.
O app admin do UpYou que você já tem (api.dart e store.dart) tem as consultas prontas.

## Compilar na nuvem do GitHub (Windows e iPhone, sem Mac e sem Visual Studio)
1. Crie um repositório no GitHub e envie o conteúdo desta pasta (inclusive a pasta .github).
2. Aba Actions, workflow "Build apps", botão Run workflow (roda também a cada push na main).
3. Quando terminar (10 a 20 minutos), abra a execução e baixe em Artifacts:
   beyond-windows (pasta do app, abra o .exe de dentro dela) e beyond-ios (arquivo beyond.ipa).
4. iPhone sem pagar: instale o Sideloadly no Windows, ligue o iPhone no cabo, arraste o beyond.ipa,
   entre com um Apple ID e clique em Start. No iPhone, ative Ajustes, Privacidade e Segurança,
   Modo Desenvolvedor, e confie no perfil em Ajustes, Geral, VPN e Gerenciamento de Dispositivo.
   Com Apple ID gratuito o app vale por 7 dias; repita o passo para renovar.
