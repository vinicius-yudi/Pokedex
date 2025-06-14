# Equipe
* Giordano Serafini
* Victor Gabriel
* Vinicius Yudi

# Aplicativo Pokedex
Este aplicativo Pokedex permite aos usuários navegar por uma lista de Pokémon, visualizar seus detalhes e gerenciar a autenticação de usuários (login e registro). 
O aplicativo apresenta uma interface de usuário limpa construída com SwiftUI e utiliza SwiftData para persistência de dados local, especificamente para autenticação de usuário. Os dados dos Pokémon são obtidos da PokeAPI.

# Escolha da API: PokeAPI
Justificativa: A PokeAPI (https://pokeapi.co/) foi escolhida por seus dados abrangentes e gratuitamente disponíveis sobre Pokémon. Ela fornece uma vasta quantidade de informações, incluindo nomes, imagens, tipos, habilidades e estatísticas dos Pokémon, tornando-a ideal para um aplicativo Pokedex. 
Sua natureza RESTful e as respostas JSON bem estruturadas simplificam o consumo de dados.

# Arquitetura do Aplicativo: MVVM
O aplicativo segue o padrão de arquitetura Model-View-ViewModel (MVVM), que promove uma clara separação de responsabilidades, tornando o código mais fácil de manter, testar e escalar.
![image alt](https://github.com/vinicius-yudi/Pokedex/blob/main/Diagrama%20MVVM.png?raw=true)



# Dados Utilizados

### Lista de Pokémon (/api/v2/pokemon)
* name: 
* url:
  
### Detalhes do Pokémon (/api/v2/pokemon/{id}/)
* id: 
* height: 
* weight: 
* sprites.front_default: 
* types:
* abilities: 
* stats: 

# Implementação do SwiftData
SwiftData é usado para persistência de dados local, especificamente para gerenciar contas de usuário e, potencialmente, futuras funcionalidades como Pokémon favoritos.

### Modelo de Dados:
### Usuario (User): Representa um usuário do aplicativo.
* id: Identificador único (UUID).
* nomeDeUsuario: O nome de usuário.
* email: O email do usuário, marcado como único.
* passwordHash: Uma versão hash da senha do usuário para armazenamento seguro.
* favoritos: Um relacionamento com uma lista de objetos Favorito

### Favorito (Favorite): Representa um Pokémon favorito de um usuário específico.
* id: Identificador único (UUID).
* pokemonId: O ID do Pokémon favoritado.
* pokemonName: O nome do Pokémon favoritado.
* pokemonImageUrl: A URL da imagem do Pokémon favoritado (opcional).
* usuario: Um relacionamento de volta ao Usuario que favoritou o Pokémon.

### Como os Dados são Salvos e Buscados:
* ModelContainer é configurado em PokedexApp.swift para gerenciar os esquemas Usuario e Favorito. Este contêiner garante que os dados sejam armazenados persistentemente (não apenas em memória).

### Salvando Dados (DataManager.swift):
* Quando um novo usuário é criado através da função criarUsuario, um novo objeto Usuario é inserido no modelContext e então salvo.
### Buscando Dados (DataManager.swift):
* A autenticação de usuário (autenticarUsuario) e a verificação de usuários existentes (usuarioExiste) envolvem a busca de objetos Usuario do modelContext usando FetchDescriptor e Predicate.

# Implementação dos Design Tokens
Os Design Tokens são implementados em DesignTokens.swift para centralizar e padronizar as escolhas de design, garantindo consistência em todo o aplicativo e tornando mais fácil gerenciar e atualizar a UI.

### Definição e Uso:
O arquivo DesignTokens.swift define vários enums para categorizar e organizar os valores de design:

* AppColors: Define uma paleta de constantes Color para vários elementos da UI, incluindo cores de fundo, cores de texto, cores de botão e cores específicas para cada tipo de Pokémon.
* AppFonts: Fornece métodos estáticos para retornar estilos de Font predefinidos para diferentes elementos de texto, garantindo consistência tipográfica.
* AppSpacing: Define constantes CGFloat para preenchimento e espaçamento consistentes em todos os layouts.
* AppCornerRadius: Especifica valores CGFloat para raios de canto de elementos da UI, como cards e botões.
* AppShadow: Define structs RadiusShadow para efeitos de sombra consistentes.


# Item de Criatividade: Recursos Aprimorados de Experiência do Usuário (UX)
Para aprimorar a experiência do usuário e demonstrar implementação criativa, os seguintes recursos foram integrados:

### Cache de Imagens (ImageCacheManager.swift e CachedImageView.swift):
* Propósito: Melhorar o desempenho e reduzir a carga de rede armazenando em cache as imagens de Pokémon na memória após o primeiro download.
* Implementação: ImageCacheManager é um singleton que usa NSCache para armazenar objetos UIImage, indexados pela string de sua URL. CachedImageView é uma View SwiftUI personalizada que busca imagens usando ImageCacheManager. Ela exibe um ProgressView durante o carregamento e um ícone de fallback se a imagem não carregar.

### Rolagem Infinita com Paginação (PokedexListViewModel.swift e ContentView.swift):
* Propósito: Carregar eficientemente grandes conjuntos de dados (como todos os Pokémon) sem sobrecarregar o usuário ou a rede. Novos Pokémon são carregados dinamicamente à medida que o usuário rola para baixo.
* Implementação: PokedexListViewModel gerencia os estados currentPage, itemsPerPage, isLoadingMorePokemon e canLoadMorePokemon. A função loadMorePokemon busca um novo lote de Pokémon da API usando um offset e limit. Em ContentView, uma view Color.clear no final da LazyVGrid atua como um gatilho para chamar loadMorePokemon quando ela aparece na tela.

### Fundo Gradiente Animado (ContentView.swift):
* Propósito: Adicionar um elemento visual sutil e dinâmico à tela principal da lista da Pokedex, aprimorando o apelo estético do aplicativo.
* Implementação: A struct AnimatedGradientBackground cria um LinearGradient com UnitPoints gradientStart e gradientEnd. Um Timer é usado para atualizar periodicamente esses UnitPoints com valores aleatórios, criando uma animação suave e contínua do gradiente.

### Barra de Pesquisa no Aplicativo (ContentView.swift):
* Propósito: Permitir que os usuários encontrem rapidamente Pokémon específicos pelo nome dentro da lista.
* Implementação: ContentView usa um modificador searchable vinculado à propriedade searchText do PokedexListViewModel. Uma SearchBarView é exibida condicionalmente, controlada por um estado isSearching, que pode ser alternado por um botão na barra de ferramentas. A propriedade computada filteredPokemon no PokedexListViewModel filtra dinamicamente a pokemonList com base no searchText.

