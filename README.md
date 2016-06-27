# GitterBoard

[![Join the chat at https://gitter.im/jnbt/gitterboard](https://badges.gitter.im/jnbt/gitterboard.svg)](https://gitter.im/jnbt/gitterboard?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Install

To install this app:

  * Clone this repository: `git clone git@github.com:jnbt/gitterboard.git`
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`

## Start

To start this Phoenix app:

  * Configure Gitter secrets (see below):
    * `export GITTER_ROOM=a-room-id`
    * `export GITTER_TOKEN=a-gitter-api-token`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Gitter API

The initial message history is loaded via the [REST API](https://developer.gitter.im/docs/rest-api), followed
by connection to the [Stream API](https://developer.gitter.im/docs/streaming-api).

### Access token

To connect to both APIs you need an API access token. The easiest way is to
sign up as a [Developer for Gitter](https://developer.gitter.im/) and use your
"Personal Access Token" from https://developer.gitter.im/apps.

### Room ID

Gitter makes it quite hard to get a single room ID. The way it worked best for
me was to load the Gitter Web interface and use the browser's developer tools
to extract the ID from the room navigation.
