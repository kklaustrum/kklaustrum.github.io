module UiClasses exposing
    ( novelContainerCls
    , pageTitleCls
    , paragraphCls
    , pageContentCls
    , loadingTitleCls
    , errorTitleCls
    , choicesContainerCls
    , choiceBtnCls
    , backToHomeBtnCls
    , bodyCls
    , rootDivCls
    , headingBaseCls
    , buttonBaseCls
    , buttonHoverCls
    , buttonActiveCls
    , fadeInAnimationCls
    , pulseAnimationCls
    )

type alias CssClass = String

-- ------------------------------------------------------------------
-- Общие стили (body, корневой div)
-- ------------------------------------------------------------------
bodyCls : CssClass
bodyCls =
    "bg-gritty-100 text-gritty-800 font-sans min-h-screen flex items-center justify-center p-4"

rootDivCls : CssClass
rootDivCls =
    -- ID‑корневой элемент, куда монтируется Elm
    ""   -- (пока ничего не требуется, но для будущих стилей)

-- ------------------------------------------------------------------
-- Контейнер книги
-- ------------------------------------------------------------------
novelContainerCls : CssClass
novelContainerCls =
    "max-w-2xl mx-auto bg-gritty-50 rounded-lg shadow-gritty p-6"

-- ------------------------------------------------------------------
-- Текстовые элементы
-- ------------------------------------------------------------------
headingBaseCls : CssClass
headingBaseCls =
    "font-mono text-gritty-900"

pageTitleCls : CssClass
pageTitleCls =
    headingBaseCls ++ " text-3xl mb-4"

loadingTitleCls : CssClass
loadingTitleCls =
    "text-2xl font-bold text-gritty-800 animate-pulse"

errorTitleCls : CssClass
errorTitleCls =
    "text-2xl font-bold text-accent"

paragraphCls : CssClass
paragraphCls =
    "text-base leading-relaxed text-gritty-700 mb-4"

pageContentCls : CssClass
pageContentCls =
    "mt-4"

-- ------------------------------------------------------------------
-- Блоки выбора (список кнопок)
-- ------------------------------------------------------------------
choicesContainerCls : CssClass
choicesContainerCls =
    "mt-6 flex flex-col gap-3"

-- ------------------------------------------------------------------
-- Кнопки выбора
-- ------------------------------------------------------------------
buttonBaseCls : CssClass
buttonBaseCls =
    "font-semibold py-2 px-4 rounded shadow-sm"

buttonHoverCls : CssClass
buttonHoverCls =
    "hover:bg-gritty-700"

buttonActiveCls : CssClass
buttonActiveCls =
    "active:scale-95"

choiceBtnCls : CssClass
choiceBtnCls =
    "bg-gritty-600 text-white " ++ buttonBaseCls ++ " " ++ buttonHoverCls ++ " " ++ buttonActiveCls

-- ------------------------------------------------------------------
-- Специальные ссылки
-- ------------------------------------------------------------------
backToHomeBtnCls : CssClass
backToHomeBtnCls =
    "text-accent underline hover:text-accent-700"

-- ------------------------------------------------------------------
-- Анимации
-- ------------------------------------------------------------------
fadeInAnimationCls : CssClass
fadeInAnimationCls =
    "animate-fade-in"

pulseAnimationCls : CssClass
pulseAnimationCls =
    "animate-pulse"
