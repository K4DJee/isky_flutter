// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Isky';

  @override
  String get menuTitle => 'Меню';

  @override
  String get yourFolders => 'Ваши папки';

  @override
  String get mainPage => 'Главная';

  @override
  String get synchronizationPage => 'Синхронизация';

  @override
  String get statisticsPage => 'Статистика';

  @override
  String get educationAnki => 'Обучающие карточки';

  @override
  String get settingsPage => 'Настройки';

  @override
  String get showBottomSheetChange => 'Изменить';

  @override
  String get addFolderTooltip => 'Добавить папку';

  @override
  String get addWordTooltip => 'Добавить слово';

  @override
  String get closeButton => 'Закрыть';

  @override
  String get addWordButton => 'Добавить слово';

  @override
  String get addWordModal => 'Добавление слова';

  @override
  String get deleteConfirmation => 'Вы точно хотите это сделать?';

  @override
  String get wordInput => 'Слово';

  @override
  String get translateInput => 'Перевод';

  @override
  String get exampleInput => 'Пример';

  @override
  String get createNewFolder => 'Создание новой папки';

  @override
  String get selectFolder => 'Выберите папку';

  @override
  String get nameFolder => 'Название папки';

  @override
  String get createFolderButton => 'Создать папку';

  @override
  String get folderNameHint => 'Введите название папки';

  @override
  String get wordHint => 'Введите слово';

  @override
  String get translateHint => 'Перевод';

  @override
  String get exampleHint => 'Пример (необязательно)';

  @override
  String get wordsInFolder => 'Слов: ';

  @override
  String get selectedFolderTitle => 'Папка:';

  @override
  String get folderAbsent => 'Нет папки';

  @override
  String get wordActionsTitle => 'Редактирование слова';

  @override
  String get localSync => 'Локальная синхронизация';

  @override
  String get globalSync => 'Глобальная синхронизация';

  @override
  String get privacyPolicyTitle => 'Политика конфиденциальности';

  @override
  String get privacyPolicyHeader => 'Политика конфиденциальности приложения Isky';

  @override
  String get privacyPolicyLastUpdated => 'Дата последнего обновления: 23 октября 2025 года';

  @override
  String get privacyPolicyWelcome => 'Добро пожаловать в политику конфиденциальности приложения Isky (\"Приложение\"). Эта политика описывает, как мы собираем, используем, храним и защищаем вашу личную информацию при использовании Приложения. Приложение Isky разработано студией K4DJE Studio (разработчик: K4DJE, Мищенко Дмитрий) и доступно на платформах MacOS, Linux, Windows, Android и iOS. Мы стремимся к максимальной прозрачности и защите вашей конфиденциальности.';

  @override
  String get privacyPolicyAgreement => 'Используя Приложение, вы соглашаетесь с условиями этой политики. Если вы не согласны, пожалуйста, не используйте Приложение.';

  @override
  String get privacyPolicySection1Title => '1. Информация, которую мы собираем';

  @override
  String get privacyPolicySection1Description => 'Приложение Isky предназначено для создания словарей, организации слов в папки, экспорта и импорта данных через JSON-файлы, а также синхронизации данных между устройствами. Мы минимизируем сбор личных данных и не храним их на наших серверах без необходимости.';

  @override
  String get privacyPolicySection1_1Title => '1.1. Данные, предоставляемые пользователем';

  @override
  String get privacyPolicySection1_1DictionaryContent => '- Содержимое словарей: Слова, папки и связанные данные, которые вы вводите в Приложение. Эти данные хранятся локально на вашем устройстве.';

  @override
  String get privacyPolicySection1_1SyncData => '- Данные для синхронизации: При локальной синхронизации (через Wi-Fi в одной сети) или глобальной синхронизации (через сервер-посредник) передаются только ваши данные словарей. Сервер не сохраняет эти данные; он выступает исключительно как временный посредник для передачи между устройствами.';

  @override
  String get privacyPolicySection1_2Title => '1.2. Автоматически собираемые данные';

  @override
  String get privacyPolicySection1_2TechnicalInfo => '- Техническая информация: IP-адрес, тип устройства, версия ОС, уникальный идентификатор устройства (для синхронизации и отладки ошибок).';

  @override
  String get privacyPolicySection1_2UsageData => '- Данные об использовании: Информация о взаимодействии с Приложением, такая как частота использования функций, для улучшения продукта (анонимизировано).';

  @override
  String get privacyPolicySection1_2AdData => '- Рекламные данные: Приложение интегрирует рекламу через Yandex Ads. Yandex может собирать данные для персонализации рекламы, включая идентификаторы устройства, местоположение (примерное, на основе IP) и поведение в Приложении. Мы не имеем доступа к этим данным; они обрабатываются Yandex в соответствии с их политикой конфиденциальности.';

  @override
  String get privacyPolicyNoSensitiveData => 'Мы не собираем чувствительную информацию, такую как биометрические данные, финансовые сведения или данные о здоровье.';

  @override
  String get privacyPolicySection2Title => '2. Как мы используем вашу информацию';

  @override
  String get privacyPolicySection2Services => '- Для предоставления услуг: Хранение и синхронизация ваших данных словарей между устройствами.';

  @override
  String get privacyPolicySection2Improvement => '- Для улучшения Приложения: Анализ анонимизированных данных об использовании для выявления ошибок и оптимизации функций.';

  @override
  String get privacyPolicySection2Ads => '- Для рекламы: Yandex Ads использует собранные данные для показа релевантной рекламы. Мы не участвуем в этом процессе напрямую.';

  @override
  String get privacyPolicySection2Legal => '- Для соблюдения законов: В случае необходимости, для выполнения юридических обязательств, таких как ответ на запросы органов власти.';

  @override
  String get privacyPolicyNoSellingData => 'Мы не продаем вашу личную информацию третьим сторонам.';

  @override
  String get privacyPolicySection3Title => '3. Раскрытие информации третьим сторонам';

  @override
  String get privacyPolicySection3YandexAds => '- Yandex Ads: Для интеграции рекламы мы делимся минимальными техническими данными (например, идентификаторами устройства) с Yandex. Подробности обработки данных Yandex доступны в их политике конфиденциальности[](https://yandex.com/legal/confidential/).';

  @override
  String get privacyPolicySection3SyncServers => '- Серверы синхронизации: При глобальной синхронизации данные передаются через наши серверы, но не сохраняются на них. Мы можем использовать облачные провайдеры (например, AWS или аналогичные) для хостинга, которые обязуются соблюдать стандарты безопасности.';

  @override
  String get privacyPolicySection3OtherCases => '- Другие случаи: Мы можем раскрыть информацию, если это требуется по закону, для защиты наших прав или в случае слияния/приобретения студии K4DJE Studio.';

  @override
  String get privacyPolicySection4Title => '4. Хранение и безопасность данных';

  @override
  String get privacyPolicySection4LocalStorage => '- Локальное хранение: Большинство данных хранится на вашем устройстве. Мы рекомендуем использовать пароли и шифрование устройства для защиты.';

  @override
  String get privacyPolicySection4Sync => '- Синхронизация: Данные передаются в зашифрованном виде (используя HTTPS). Сервер не хранит данные после передачи.';

  @override
  String get privacyPolicySection4Retention => '- Срок хранения: Мы не храним ваши данные на серверах. Локальные данные удаляются при деинсталляции Приложения или по вашему запросу.';

  @override
  String get privacyPolicySection4Security => '- Меры безопасности: Мы применяем стандартные меры, такие как шифрование, firewalls и регулярные аудиты, для защиты от несанкционированного доступа. Однако никакая система не является полностью безопасной, и мы не можем гарантировать абсолютную защиту.';

  @override
  String get privacyPolicySection5Title => '5. Ваши права';

  @override
  String get privacyPolicySection5RightsIntro => 'В зависимости от вашего местоположения (например, в соответствии с GDPR в ЕС или Федеральным законом РФ \"О персональных данных\"), вы имеете права:';

  @override
  String get privacyPolicySection5Access => '- Доступ к вашим данным.';

  @override
  String get privacyPolicySection5Correction => '- Исправление или обновление данных.';

  @override
  String get privacyPolicySection5Deletion => '- Удаление данных (например, через экспорт и очистку в Приложении).';

  @override
  String get privacyPolicySection5OptOut => '- Отказ от обработки (включая отключение рекламы, если возможно).';

  @override
  String get privacyPolicySection5Complaint => '- Жалоба в надзорный орган.';

  @override
  String get privacyPolicySection5Contact => 'Для行使 этих прав свяжитесь с нами по контактам ниже.';

  @override
  String get privacyPolicySection6Title => '6. Данные детей';

  @override
  String get privacyPolicySection6Children => 'Приложение не предназначено для детей младше 13 лет (или эквивалентного возраста по местному законодательству). Мы не собираем данные от детей сознательно. Если вы родитель и считаете, что ваш ребенок предоставил нам данные, свяжитесь с нами для удаления.';

  @override
  String get privacyPolicySection7Title => '7. Изменения в политике';

  @override
  String get privacyPolicySection7Changes => 'Мы можем обновлять эту политику. Изменения будут опубликованы в Приложении или на нашем сайте. Продолжение использования Приложения после обновления означает согласие с изменениями.';

  @override
  String get privacyPolicySection8Title => '8. Контакты';

  @override
  String get privacyPolicySection8Questions => 'Если у вас есть вопросы или запросы, свяжитесь с нами:';

  @override
  String get privacyPolicySection8Developer => '- Разработчик: Мищенко Дмитрий (K4DJE)';

  @override
  String get privacyPolicySection8Email => '- Email: k4djexfullstack@gmail.com';

  @override
  String get privacyPolicySection8Studio => '- Студия: K4DJE Studio';

  @override
  String get privacyPolicyThanks => 'Спасибо за использование Isky! Мы ценим ваше доверие.';

  @override
  String get stillInDevelopment => 'Ещё в разработке';

  @override
  String get incompletePage => 'Незавершённая страница';

  @override
  String get skipBtn => 'Пропустить';

  @override
  String get onboardingSubtitle5 => 'Передавайте данные по WI-FI или сохраняйте их в JSON файле';

  @override
  String get onboardingTitle5 => 'Делитесь словарём без интернета';

  @override
  String get onboardingSubtitle4 => 'С помощью статистики данных вы можете видеть ваш рост';

  @override
  String get onboardingTitle4 => 'Следите за своим прогрессом';

  @override
  String get onboardingSubtitle3 => 'Обучающие карточки и другие мини игры помогут вам запоминать иностранные слова';

  @override
  String get onboardingTitle3 => 'Учите слова играя';

  @override
  String get onboardingSubtitle2 => 'Группируйте слова по темам, уровням или языкам - как удобно вам';

  @override
  String get onboardingTitle2 => 'Создавайте папки и добавляйте слова';

  @override
  String get onboardingSubtitle1 => 'Это приложение специализируется в улучшении процесса изучения слов иностранных языков';

  @override
  String get onboardingTitle1 => 'Добро пожаловать в приложение Isky';

  @override
  String get errorTitle => 'Ошибка:';

  @override
  String get importError => 'Произошла ошибка при импорте данных';

  @override
  String get importCanceled => 'Импорт данных был отменён';

  @override
  String get importSuccess => 'Импорт данных завершён';

  @override
  String get importLoad => 'Происходит импорт данных';

  @override
  String get selectFileTitle => 'Выбрать файл';

  @override
  String get selectFileForImport => 'Выберите файл с расширением .json, который хотите импортировать:';

  @override
  String get filePathAfterEport => 'Файл был сохранён по пути:';

  @override
  String get exportError => 'Произошла ошибка при экспорте данных';

  @override
  String get exportCanceled => 'Экспорт данных был отменён';

  @override
  String get exportSuccess => 'Экспорт данных завершён';

  @override
  String get exportLoad => 'Происходит экспорт данных';

  @override
  String get exportAndImportTitle => 'При импорте данных все предыдущие данные будут безвозвратно удалены.';

  @override
  String get importingDataTile => 'Импорт данных';

  @override
  String get exportingDataTile => 'Экспорт данных';

  @override
  String get exportAndImportPage => 'Экспорт и импорт данных';

  @override
  String get receiveData => 'Получение данных';

  @override
  String get selectAction => 'Выберите действие:';

  @override
  String get receivingBtn => 'Получение';

  @override
  String get sendingBtn => 'Отправка';

  @override
  String get dataReceiveSuccess => 'Данные успешно получены';

  @override
  String get dataReceiveLoad => 'Идёт получение данных';

  @override
  String get cancelSend => 'Отменить';

  @override
  String get retrySend => 'Повторить';

  @override
  String get dataFailedSent => 'Не удалось отправить данные';

  @override
  String get exitBtn => 'Выйти';

  @override
  String get dataSentSuccessfully => 'Данные успешно отправлены!';

  @override
  String get sendingDataToRecipent => 'Отправка данных получателю';

  @override
  String get sendData => 'Отправить данные';

  @override
  String get receiverIpAddress => 'IP адрес получителя';

  @override
  String get qrScanTitle => 'QR-сканер доступен только на мобильных устройствах';

  @override
  String get scanRecipientQRCode => 'Отсканируйте QR-код получателя';

  @override
  String get sendDataToLocalServerTitle => 'Отправить данные на IP:';

  @override
  String get localServerStatus2 => 'Сервер включён';

  @override
  String get localServerStatus1 => 'Сервер выключен';

  @override
  String get urQRCodeTitle => 'Ваш QR-код для передачи по IP';

  @override
  String get stopReceivingData => 'Прекратить получение данных';

  @override
  String get receiveTitle => 'Нажмите «Получить», чтобы сгенерировать QR-код';

  @override
  String get receive => 'Получить';

  @override
  String get minutes => 'мин';

  @override
  String get selectTimeForWorkout => 'Выберите время, за которое будете проходить тренировку';

  @override
  String get timePageTitle => 'Написание слова по переводу на время';

  @override
  String get wordInFlashcard => 'Слово:';

  @override
  String get translateInFlashcard => 'Перевод:';

  @override
  String get noMoreWords => 'Слов больше нету';

  @override
  String get highDifficulty => 'Сложно';

  @override
  String get mediumDifficulty => 'Средне';

  @override
  String get lowDifficulty => 'Легко';

  @override
  String get nextWord => 'Следующее слово';

  @override
  String get showAnswer => 'Показать ответ';

  @override
  String get totalNumberAnswers => 'Общее количество ответов';

  @override
  String get numberIncorrectAnswers => 'Количество неправильных ответов:';

  @override
  String get numberCorrectAnswers => 'Количество правильных ответов:';

  @override
  String get averageNumberTitle => 'Среднее количество ответов в день:';

  @override
  String get wordsLearned => 'Изучено слов:';

  @override
  String get searchWords => 'Поиск слов';

  @override
  String get noWords => 'Слов нету';

  @override
  String get noWordsDescription => 'Слов для обучающих карточек нету, добавьте новые слова или дождитесь слов';

  @override
  String get showExitDialogTitle => 'Вы точно хотите завершить тренировку?';

  @override
  String get yesAction => 'Да';

  @override
  String get noAction => 'Нет';

  @override
  String get globalSyncDescription => 'Передача папок со словами происходит через сервер, который служит посредником между двумя устройствами. Сервер не хранит никакие данные, он только переотправляет базу данных';

  @override
  String get localSyncDescription => 'Как происходит локальная синхронизация? Вы можете передавать все свои папки на другое устройство через точку доступа Wi-Fi или когда оба устройства подключены к одному и тому же Wi-Fi';

  @override
  String get renameFolder => 'Переименовать';

  @override
  String get deleteFolder => 'Удалить';

  @override
  String get folderActionsPage => 'Управление папками';

  @override
  String get allFlashcards => 'Все слова';

  @override
  String get timePage => 'На время';

  @override
  String get noWordsFound => 'Слова не найдены';

  @override
  String get day => 'день';

  @override
  String get daysGenitive => 'дня';

  @override
  String get days => 'дней';

  @override
  String get deleteWord => 'Удалить';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get bgColor => 'Цвет фона';

  @override
  String get interfaceAppColor => 'Цвет интерфейса приложения';

  @override
  String get deletingAFolder => 'Удаление папки';

  @override
  String get exportAndImportFoldersInExcel => 'Экспорт и импорт папки в Excel';

  @override
  String get removeAds => 'Убрать рекламу';

  @override
  String get language => 'Язык';

  @override
  String get shareApp => 'Поделиться приложением';

  @override
  String get rateUs => 'Оцените нас';

  @override
  String get feedback => 'Обратная связь';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get appVersion => 'Версия 1.00';
}
