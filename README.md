# SocialParser

[![Join the chat at https://gitter.im/swelham/social_parser](https://badges.gitter.im/swelham/social_parser.svg)](https://gitter.im/swelham/social_parser?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/swelham/social_parser.svg?branch=master)](https://travis-ci.org/swelham/social_parser) [![Hex Version](https://img.shields.io/hexpm/v/social_parser.svg)](https://hex.pm/packages/social_parser)

A small library for parsing out common social elements such as hashtags, mentions and urls.

## Usage

Add `social_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:social_parser, "~> 1.1.0"}]
end
```

You can then parse out the social components like so:

```elixir
defmodule SocialParserTest do
  def do_social_stuff() do
    message = "hi @you checkout http://example.com/ that +someone hosted #example"

    # parse out all components into an array
    components = SocialParser.parse(message)

    IO.inspect(components)
    # [
    #   {:text, "hi ", {0, 3}},
    #   {:mention, "@you", {4, 8}},
    #   {:text, " checkout ", {9, 19}},
    #   {:link, "http://example.com/", {20, 39}},
    #   {:text, " that ", {40, 46}},
    #   {:mention, "+someone", {47, 55}},
    #   {:text, " hosted ", {56, 64}},
    #   {:hashtag, "#example", {65, 73}}
    # ]

    # extract targeted components
    some_components = SocialParser.extract(message, [:hashtags, :mentions])

    IO.inspect(some_components)
    #%{
    #   hashtags: ["#example"],
    #   mentions: ["@you", "+someone"]
    #}
  end
end
```

# TODO

* Merge the private `parse` and `parse_components` functions as there is some duplication of code
