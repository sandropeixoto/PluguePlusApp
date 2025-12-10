# Plugue+ (Flutter)

Recriacao em Flutter do app Plugue+, reaproveitando a logica de categorias, servicos e carregadores do backend antigo. Agora tudo roda no cliente, com dados em memoria e estrutura simplificada.

## Estrutura
- `lib/`: codigo-fonte Dart.
  - `models/`: modelos de dominio (Category, Service, Charger).
  - `services/`: repositorio em memoria que aplica a mesma logica de criacao/listagem do backend PHP.
  - `pages/`: telas principais (Home, Servicos, Carregadores).
  - `widgets/`: componentes reutilizaveis (cards, titulos, tiles).
- `pubspec.yaml`: declaracao de dependencias.
- `.gitignore`: configurado para projetos Flutter (plataformas geradas ficam ignoradas).

## Rodando localmente
1. Certifique-se de ter o SDK Flutter instalado e no PATH.
2. (Opcional) Gere pastas de plataforma se ainda nao existirem:
   ```bash
   flutter create .
   ```
3. Instale dependencias:
   ```bash
   flutter pub get
   ```
4. Rode:
   ```bash
   flutter run -d chrome   # ou um dispositivo/simulador conectado
   ```

## Container/Docker (Cloud Run)
1. Gere os artefatos web dentro do container (a imagem faz o `flutter build web` na fase de build):
   ```bash
   docker build -t plugueplus .
   ```
2. Rode localmente:
   ```bash
   docker run -p 8080:8080 plugueplus
   ```
3. Publicar na Artifact/Container Registry e implantar no Cloud Run:
   ```bash
   docker tag plugueplus gcr.io/SEU_PROJETO/plugueplus
   docker push gcr.io/SEU_PROJETO/plugueplus
   gcloud run deploy plugueplus --image gcr.io/SEU_PROJETO/plugueplus --platform managed --region us-central1 --allow-unauthenticated
   ```
   O Nginx no container serve o build web e faz fallback de SPA para `index.html` (veja `nginx.conf`).

## Backend php-crud-api
- O app consome a API em producao via `lib/config/api_config.dart`, apontando para `https://sspeixoto.com.br/api/api-plugueplus.php`.
- Ajuste os nomes das tabelas em `ApiConfig` se divergirem (`categorias`, `servicos`, `carregadores`).
- Se a API ficar indisponivel, o app exibe um fallback com dados em memoria (`InMemoryRepository`).

## Notas de logica
- O `InMemoryRepository` em `lib/services/in_memory_repository.dart` implementa as mesmas validacoes do backend: categoria precisa existir para criar servico; carregadores guardam status, potencia, tipo de conector etc.
- Os dados sao seedados em memoria para demonstracao (categorias, servicos e carregadores ficticios).
- A navegacao usa `NavigationBar` com tres abas: Inicio (resumo), Servicos (lista) e Carregadores (lista/status).
