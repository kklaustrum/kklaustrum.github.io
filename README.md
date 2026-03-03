# MVP | Elm-based | VN, sort of
nix-shell -p elmPackages.elm

elm make src/Main.elm --optimize --output=res/elm.js

python3 -m http.server 8000
