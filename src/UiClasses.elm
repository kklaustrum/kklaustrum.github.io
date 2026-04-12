module UiClasses exposing
    ( novelContainerCls, cornerButtonCls
    , pageTitleCls
    , paragraphCls
    , rowTagCls, statsGridCls
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
    , inventoryRowCls, infoSectionCls, infoRowsGridCls, fullWidthCellCls, sectionHeaderCls, breakWordsCls
    , gameOverCls
    , debugDividerCls
    , centeredChoiceCls
    , itemArrowCls, toggleBadgeCls, toggleRowCls
    )

type alias CssClass = String

-- ------------------------------------------------------------------
-- Общие стили (body, корневой div)
-- ------------------------------------------------------------------
bodyCls : CssClass
bodyCls =
    "bg-gritty-100 text-gritty-800 font-sans min-h-screen flex items-center justify-center px-1 md:px-8 py-4"

rootDivCls : CssClass
rootDivCls =
    -- ID‑корневой элемент, куда монтируется Elm
    ""   -- (пока ничего не требуется, но для будущих стилей)

-- ------------------------------------------------------------------
-- Контейнер книги
-- ------------------------------------------------------------------
novelContainerCls : CssClass
novelContainerCls =
    "relative w-full max-w-2xl mx-auto bg-gritty-50 rounded-lg shadow-gritty px-1 md:px-4 py-6"

cornerButtonCls : CssClass
cornerButtonCls =
    "absolute top-3 right-3 text-gritty-400 hover:text-gritty-700 transition-colors cursor-pointer text-2xl leading-none"

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

rowTagCls : CssClass
rowTagCls =
    "font-mono text-xs uppercase tracking-widest text-gritty-400 whitespace-nowrap"

statsGridCls : CssClass
statsGridCls =
    "grid grid-cols-2 sm:grid-cols-2 gap-1 mt-1"

inventoryRowCls : CssClass
inventoryRowCls =
    "contents"

infoSectionCls : CssClass
infoSectionCls =
    "mt-4 border-t-2 border-gritty-300 bg-gritty-50 shadow-inner rounded-md p-2 font-mono text-sm"

infoRowsGridCls : CssClass
infoRowsGridCls =
    "grid grid-cols-[max-content_1fr] gap-x-3 gap-y-1 mt-1 items-baseline"

fullWidthCellCls : CssClass
fullWidthCellCls =
    "col-span-2"

sectionHeaderCls : CssClass
sectionHeaderCls =
    "text-base font-light mb-1 tracking-wide"

breakWordsCls : CssClass
breakWordsCls =
    "min-w-0 break-words"

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
-- Кнопки
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

centeredChoiceCls : CssClass
centeredChoiceCls =
    "flex justify-center mt-6 gap-3"

itemArrowCls : CssClass
itemArrowCls =
    "ml-1 cursor-pointer text-gritty-400 hover:text-gritty-700 active:scale-95 transition-colors"

toggleBadgeCls : CssClass
toggleBadgeCls =
    "inline-flex items-baseline gap-0.5"

toggleRowCls : CssClass
toggleRowCls =
    "flex flex-wrap gap-x-3"

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

-- ------------------------------------------------------------------
-- Debug/Game Over
-- ------------------------------------------------------------------
gameOverCls : CssClass
gameOverCls =
    "text-2xl font-mono text-accent"

-- ------------------------------------------------------------------
-- Dividers (debug)
-- ------------------------------------------------------------------
debugDividerCls : CssClass
debugDividerCls = 
    "border-t-2 border-gritty-400 bg-gradient-to-r from-gritty-400/50 to-transparent my-2"
