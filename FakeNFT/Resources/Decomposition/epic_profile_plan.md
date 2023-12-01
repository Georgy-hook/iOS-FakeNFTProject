# ТЗ профиль

## Методология оценки сложности задачи

- `1 поинт` - 1 час 
- `2 поинта` - 2-3 часа 
- `3 поинта` - 6 часов 
- `4 поинта` - 1 день 
- `5 поинтов` - 2-3 дня 

**Экран профиля**

Экран показывает информацию о пользователе.
- фото пользователя `1 поинт` ✅ в действительности: `3 поинта`
- имя пользователя `1 поинт` ✅ в действительности: `1 поинт` 
- описание пользователя `2 поинта` ✅ в действительности: `2 поинта`
- таблицу (UITableView) с ячейками Мои NFT (ведет на экран NFT пользователя), Избранные NFT (ведет на экран с избранными NFT), Сайт пользователя (открывает в вебвью сайт пользователя). `4 поинта` ✅ в действительности: `4 поинта`

В правом верхнем углу экрана находится кнопка редактирования профиля. Нажав на нее, пользователь видит всплывающий экран, на котором может отредактировать имя пользователя, описание, сайт и ссылку на изображение. Загружать само изображение через приложение не нужно, обновляется только ссылка на изображение. `2 поинта` ✅ в действительности: `3 поинта` 

**Экран Мои NFT**

Представляет собой таблицу (UITableView):
- иконку NFT `3 поинта` ✅ в действительности: `4 поинта`
- название NFT `3 поинта` ✅ в действительности: `3 поинта`
- автора NFT `3 поинта` ✅ в действительности: `4 поинта`
- цену NFT в ETH `3 поинта` ✅ в действительности: `3 поинта`

Сверху на экране есть кнопка сортировки, при нажатии на которую пользователю предлагается выбрать один из доступных способов сортировки. Содержимое таблицы упорядочивается согласно выбранному способу. `2 поинта` ✅ в действительности: `2 поинта`
В случае отсутствия NFT показывается соответствующая надпись. `2 поинта` ✅ в действительности: `2 поинта`

**Экран Избранные NFT**

Содержит коллекцию (UICollectionView) c NFT, добавленными в избранное (лайкнутыми)
- иконка `1 поинт` ✅ в действительности: `1 поинт`
- сердечко `3 поинта` ✅ в действительности: `3 поинта`
- название `2 поинта` ✅ в действительности: `3 поинта`
- рейтинг `2 поинта` ✅ в действительности: `2 поинта`
- цена в ETH `1 поинт` ✅ в действительности: `2 поинта`

Нажатие на сердечко удаляет NFT из избранного, содержимое коллекции при этом обновляется. `3 поинта` ✅ в действительности: `3 поинта`
В случае отсутствия избранных NFT показывается соответствующая надпись. `2 поинта` ✅ в действительности: `3 поинта`

# Сортировка данных

**Значение сортировки по умолчанию:**
- экран «Мои NFT» — по рейтингу `5 поинтов` ✅ в действительности: `5 поинтов`


# Profile

## Methodology for assessing the complexity of the task

- `1 story point` - 1 hour 
- `2 story points` - 2-3 hours 
- `3 story points` - 6 hours 
- `4 story points` - 1 day 
- `5 story points` - 2-3 days 

**Profile Screen**

The screen shows information about the user.
- photo of the user `1 story point`  ✅ real: `3 story points`
- username `1 story point` ✅ real: `1 story point`
- user description `2 story points` ✅ real: `2 story points`
- table (UITableView) with My NFT cells (leads to the user's NFT screen), NFT Favorites (leads to the screen with NFT favorites), User's website (opens the user's website in the webview). `4 story points` ✅ real: `4 story points`

There is a profile editing button in the upper right corner of the screen. By clicking on it, the user sees a pop-up screen on which he can edit the user's name, description, website and link to the image. There is no need to download the image itself through the application, only the link to the image is updated. `2 story points` ✅ real: `3 story points`

**My Screen NFT**

It is a table (UITableView):
- icon NFT `3 story points` ✅ real: `4 story points`
- title NFT `3 story points` ✅ real: `3 story points`
- author NFT `3 story points` ✅ real: `4 story points`
- price of NFT in ETH `3 story points` ✅ real: `3 story points`

There is a sort button on the top of the screen, when clicked, the user is prompted to choose one of the available sorting methods. The contents of the table are ordered according to the selected method. `2 story points` ✅ real: `2 story points`
If there is no NFT, the corresponding label is displayed. `2 story points` ✅ real: `2 story points`

**Favorites Screen NFT**

Contains a collection (UICollectionView) with NFTs added to favorites (liked)
- icon `1 story point` ✅ real: `1 story point`
- heart `3 story points` ✅ real: `3 story points`
- title `2 story points` ✅ real: `3 story points`
- title `2 story points` ✅ real: `2 story points`
- price of NFT in ETH `1 story point` ✅ real: `2 story points`

Clicking on the heart removes the NFT from favorites, the contents of the collection are updated at the same time. `3 story points` ✅ real: `3 story points`
In case of absence of the selected NFT, the corresponding inscription is shown. `2 story points` ✅ real: `3 story points`

# Sorting data

**Default sorting value:**
- My NFT screen — по рейтингу `5 story points` ✅ real: `5 story points`
