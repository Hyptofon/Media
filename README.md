# 📷 Робота з медіа (Camera & Gallery)

Цей проєкт є виконанням лабораторної роботи **LR15: Робота з медіа (Camera & Gallery) — Photo Gallery**.

У додатку реалізовано галерею з можливістю фотографувати, вибирати зображення з пристрою, переглядати їх на весь екран з анімацією, обрізати, ділитися та керувати колекцією (видаляти по одному або масово). Проєкт адаптовано для роботи як на мобільних пристроях (Android/iOS), так і у браузері (Web).

🌐 **Live Demo:** [https://media-fa024.web.app](https://media-fa024.web.app)

---

## 🎯 Мета роботи

Навчитись працювати з камерою та галереєю пристрою. Використовувати пакет `image_picker` для вибору фото, `permission_handler` для дозволів, та створити галерею з Hero анімаціями.

**Ключові навички:**
- Робота з `image_picker`
- Запит дозволів (Camera, Gallery)
- Відображення фото в `GridView`
- `Hero` анімація для full-screen
- Збереження фото локально
- Обробка помилок permissions
- Кросплатформна розробка (Mobile + Web)

---

## ✅ Виконані обов'язкові завдання

### 1. Налаштування packages та permissions
- Додано залежності `image_picker`, `permission_handler`, `path_provider`, `shared_preferences`.
- Налаштовано дозволи в `AndroidManifest.xml` (включаючи `READ_MEDIA_IMAGES` для Android 13+ та провайдер для обрізки).
- Налаштовано ключі в `Info.plist` для iOS (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` тощо).

### 2. Запит дозволу на камеру та галерею
- Створено `PermissionService` (та `WebPermissionService` для вебу).
- Реалізовано перевірку статусів (granted, denied, permanentlyDenied).
- Додано показ діалогу з пропозицією відкрити налаштування додатку, якщо дозвіл відхилено назавжди.

### 3. Робота з камерою та галереєю (`image_picker`)
- Реалізовано методи отримання фотографій з обох джерел.
- Використано параметри стиснення (`maxWidth`, `maxHeight`, `imageQuality`) для оптимізації розміру файлів.

### 4. BottomSheet для вибору джерела
- Створено `ImageSourceBottomSheet`, який з'являється при натисканні на кнопку додавання фото.
- Користувач може вибрати "Камера" або "Галерея".

### 5. Відображення фото в GridView
- Реалізовано `GalleryGrid` з відображенням фотографій у 3 колонки.
- Додано стан завантаження (`GalleryLoadingIndicator`) та пустий стан (`GalleryEmptyState`), якщо фотографій ще немає.

### 6. Full-screen view з Hero animation
- Створено екран детального перегляду `PhotoDetailScreen`.
- Перехід між сіткою та повноекранним режимом супроводжується плавною `Hero` анімацією.
- Реалізовано зумування (`InteractiveViewer`).

### 7. Збереження фото локально
- **Mobile:** Фото копіюються у внутрішню директорію додатку за допомогою `path_provider`, а шляхи зберігаються у `SharedPreferences`.
- **Web:** Фото стискаються через HTML Canvas і зберігаються у вигляді Base64 data-URL безпосередньо у `localStorage` браузера (щоб не перевищити ліміти пам'яті).

### 8. Видалення фото
- Можливість видалення відкритого фото з повноекранного режиму.
- Відображається діалог підтвердження перед остаточним видаленням з диска та кешу.

---

## 🌟 Додаткові завдання

У проєкті реалізовано **всі три** додаткові варіанти (A, B, C).

### Варіант A: Image Cropper (★☆☆)
- Інтегровано пакет `image_cropper`.
- Після вибору або зйомки фото відкривається редактор, де користувач може обрізати зображення (вільне співвідношення, квадрат, 16:9, 4:3).
- Обрізка доступна на Android та iOS. На Web фото зберігається відразу (через технічні обмеження бібліотеки з blob URLs у браузері).

### Варіант B: Share фото (★★☆)
- Інтегровано пакет `share_plus`.
- В повноекранному режимі перегляду додано кнопку "Поділитися" (Share).
- **Mobile:** Відкриває системний Share Sheet для надсилання файлу.
- **Web:** Декодує Base64 у віртуальний файл та дозволяє поділитися або завантажити його через Web Share API.

### Варіант C: Multiple selection (★★★)
- Реалізовано режим множинного вибору (активується довгим натисканням на фото).
- Додано анімовані чекбокси поверх фотографій.
- В режимі вибору змінюється `AppBar` — з'являється лічильник вибраних елементів та кнопка для їх **масового видалення**.

---

## 📁 Структура проєкту

```text
lib/
├── app/
│   └── app.dart                    # Кореневий віджет, DIP конфігурація
├── controllers/
│   └── gallery_controller.dart     # Керування станом галереї та виділенням
├── models/
│   ├── app_permission_status.dart
│   ├── operation_result.dart       # Sealed класи для результатів операцій
│   └── photo_source.dart
├── navigation/
│   └── app_navigator.dart
├── repositories/
│   ├── photo_repository.dart       # Мобільна імплементація збереження
│   └── web_photo_repository.dart   # Web-імплементація (Base64 + Canvas compress)
├── screens/
│   ├── home_screen.dart            # Головний екран галереї
│   └── photo_detail_screen.dart    # Екран перегляду фото
├── services/
│   ├── interfaces/
│   │   ├── i_permission_service.dart
│   │   └── i_photo_repository.dart
│   ├── cropper_service.dart        # Логіка обрізки фото
│   ├── permission_service.dart     # Запит дозволів (Mobile)
│   ├── photo_file_service.dart
│   ├── photo_preferences_service.dart
│   ├── share_service.dart          # Логіка Share (Mobile + Web)
│   └── web_permission_service.dart # Заглушки дозволів для Web
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── app_snack_bar.dart
│   ├── delete_confirmation_dialog.dart
│   ├── gallery_app_bar.dart
│   ├── gallery_empty_state.dart
│   ├── gallery_grid.dart           # Сітка фото + Selection mode
│   ├── gallery_loading_indicator.dart
│   ├── image_source_bottom_sheet.dart
│   ├── permission_settings_dialog.dart
│   ├── photo_image.dart
│   ├── photo_thumbnail.dart
│   ├── photo_viewer.dart
│   └── source_tile.dart
└── main.dart                       # Entry point
```

---

## 🧪 Тестування та Аналіз коду

- Проєкт пройшов `dart analyze` без жодного попередження чи помилки (No issues found!).
- Код відповідає принципам SOLID, зокрема Inversion of Control (IoC) / Dependency Inversion (DIP) при роботі з платформозалежним кодом.
- Написано базовий `widget_test.dart` (smoke test).
- Код повністю очищений від коментарів на вимогу.

---

## 🚀 Як запустити

1. Встановити залежності:
   ```bash
   flutter pub get
   ```

2. Запустити на мобільному пристрої або емуляторі (Android/iOS):
   ```bash
   flutter run
   ```

3. Запустити web-версію:
   ```bash
   flutter run -d chrome
   ```

---

## 👤 Автор

| Поле | Деталі |
| :--- | :--- |
| **Студент** | Войтюк Назарій |
| **Група** | КН-311 |
| **Live Demo** | [media-fa024.web.app](https://media-fa024.web.app) |
