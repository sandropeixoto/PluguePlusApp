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

## Notas de logica
- O `InMemoryRepository` em `lib/services/in_memory_repository.dart` implementa as mesmas validacoes do backend: categoria precisa existir para criar servico; carregadores guardam status, potencia, tipo de conector etc.
- Os dados sao seedados em memoria para demonstracao (categorias, servicos e carregadores ficticios).
- A navegacao usa `NavigationBar` com tres abas: Inicio (resumo), Servicos (lista) e Carregadores (lista/status).
