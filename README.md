# MyTestApp

Додаток для перегляду стрічки постів та деталей обраного посту. Дані завантажуються з зовнішнього API у форматі JSON.

## Вимоги

- **iOS 17+**
- **Портретна орієнтація**
- **Swift**, **UIKit**, **Auto Layout** (інтерфейс без Storyboard для основних екранів)

## Структура проєкту

| Папка | Призначення |
| **FeedView/** | Екран стрічки: `FeedViewController`, `FeedViewModel`, `PostCell` |
| **DetailsView/** | Екран деталей посту: `DetailsViewController`, `DetailsViewModel`, `DetailPostCell` |
| **Models/** | Моделі даних: `PostModel`, `FeedPosts`, `DetailPostModel`, `DetailPosts`, `PostItemModel` |
| **Services/** | Мережевий шар: протокол `NetworkService`, реалізація `NetworkServiceImpl` |
| **Coordinator/** | Навігація: `AppCoordinator` (протокол `Coordinator`) |
| **DIContainer/** | Збірка залежностей (Dependency Injection) |

## Архітектура та прийняті рішення

### MVVM

- Логіка та стан у **ViewModel** (`FeedViewModel`, `DetailsViewModel`): завантаження даних, збереження стану «розгорнуто/згорнуто» для комірок.
- **View** (ViewController) підписується на оновлення через замикання: `onPostUpdated`, `onLoadingChanged`, `onError`.
- Мережеві виклики виконуються в ViewModel через `async/await`.

### Coordinator

- Навігація винесена в **AppCoordinator**: показ стрічки та переход на екран деталей посту за `postId`.
- ViewController не створює інші екрани сам — лише викликає callback `onPostSelected(postId)`.

### Dependency Injection

- **DIContainer** створює сервіси (наприклад, `NetworkService`) та збирає ViewModel і ViewController з потрібними залежностями.
- ViewModel отримує `NetworkService` через ініціалізатор, без жорсткої прив'язки до конкретної реалізації.

### Стрічка постів

- **UICollectionView** з **UICollectionViewDiffableDataSource** та **UICollectionViewCompositionalLayout**.
- Короткий опис посту: до двох рядків — повністю; понад два — обрізання з кнопками «Розгорнути» / «Згорнути». Стан розгорнуто/згорнуто зберігається в `FeedViewModel` (`expandedPostIds`) і не втрачається при скролі.
- Натискання на комірку відкриває екран деталей обраного посту.

### Екран деталей

- Відображаються: зображення посту, заголовок, повний текст, кількість лайків, дата (форматування через розширення `Int.timeAgoString` в `ExtensionForDate`).
- Зображення завантажується асинхронно по URL з відповіді API.

## API

- **Стрічка постів:**  
  `https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json`  

- **Деталі посту за ID:**  
  `https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/[id].json`  

## Технічний стек

- Мова: **Swift**
- UI: **UIKit**, **Auto Layout**, **UICollectionView**
- Дані: **URLSession**, **Codable** (JSONDecoder)
- Асинхронність: **async/await**
- Архітектура: **MVVM**, **Coordinator**, **DI**