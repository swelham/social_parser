# SocialParser

[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/social_parser/lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/swelham/social_parser.svg?branch=master)](https://travis-ci.org/swelham/social_parser)

A small library for parsing out common social elements such as hashtags, mentions and urls.

## Usage

Install by adding `social_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:social_parser, "~> 1.0.0"}]
end
```

And then run the mix task to download and compile social_parser:

```shell
mix deps.get
```

Once installed you can parse out the social components like so:

```elixir
defmodule SocialParserTest do
  def do_social_stuff() do
    message = "hi @you checkout http://example.com/ that +someone hosted #example"

    components = SocialParser.parse(message)

    IO.inspect(components)
    # [
    #   {:text, "hi "},
    #   {:mention, "@you"},
    #   {:text, " checkout "},
    #   {:link, "http://example.com/"},
    #   {:text, " that "},
    #   {:mention, "+someone"},
    #   {:text, " hosted "},
    #   {:hashtag, "#example"}
    # ]
  end
end
```

# TODO

* Merge the private `parse` and `parse_components` functions as there is some duplication of code
* Add new public parse function that takes an array of tuples used to filter the result
