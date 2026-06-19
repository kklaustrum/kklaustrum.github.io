module Structure exposing
    ( Passage, PassageArgs, Route
    , passage, withCondition, withTitle, withBody, withTrait, withRoute
    , emptyPageContent
    )

import Types exposing (PageContent, ExtraChoices, LocaleString)
import Conditions exposing (Condition(..))
import Traits exposing (Trait)
import Locale exposing (Locale)

type alias Passage =
    { fromPage   : String
    , toPage     : String
    , label      : String
    , condition  : Condition
    , grantTrait : Maybe Trait
    , secret     : Maybe PageContent
    , route      : Maybe Route
    }

type alias PassageArgs =
    { from  : String
    , to    : String
    , label : String
    }

type alias Route =
    { id    : String
    , pages : List String
    , nextLabel : LocaleString
    , backLabel : LocaleString
    }

emptyPageContent : PageContent
emptyPageContent =
    { title = "", content = "", choices = [] }

-- Label is ignored if a route exists. Always set for API consistency.
passage : Locale -> PassageArgs -> Passage
passage locale args =
    { fromPage   = args.from
    , toPage     = args.to
    , label      = args.label
    , condition  = Always
    , grantTrait = Nothing
    , route      = Nothing
    , secret     = Nothing
    }

withCondition : Condition -> Passage -> Passage
withCondition cond p = { p | condition = cond }

withTitle : String -> Passage -> Passage
withTitle title p =
    let secret = Maybe.withDefault emptyPageContent p.secret
    in { p | secret = Just { secret | title = title } }

withBody : String -> Passage -> Passage
withBody body p =
    let secret = Maybe.withDefault emptyPageContent p.secret
    in { p | secret = Just { secret | content = body } }

withTrait : Trait -> Passage -> Passage
withTrait trait p =
    { p | grantTrait = Just trait }

withRoute : Route -> Passage -> Passage
withRoute route p =
    { p | route = Just route }
