FROM node:25-trixie

RUN npm install --global -- npm@latest

ENV ELM_HOME=/home/node/.elm
RUN mkdir -p "${ELM_HOME}" && chown -R node:node "${ELM_HOME}"

USER node

WORKDIR /home/node/app/

RUN npm install -- \
    elm \
    elm-format

COPY --chown=node:node elm.json ./

RUN mkdir src \
    && cat <<'EOF' > ./src/Main.elm \
    && npx elm make --output=/dev/null ./src/Main.elm
module Main exposing (main)
import Html
main = Html.text ""
EOF
