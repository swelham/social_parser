# SocialParser

A small library for parsing out common social elements such as hashtags, mentions and urls.

# Todo

* Support for parsing out http links
* Review use cases to define final public interface

## Usage

Install by adding `social_parser` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:social_parser, "~> 0.2.0"}]
  end
  ```

And then run the mix task to download and compile social_parser:

  ```shell
  mix deps.get
  ```

Once installed you can find hashtags and mentions like so:
  
  ```elixir
  defmodule SocialParserTest do
    def do_social_stuff() do
        message = "Hi @you this a #test message from @me"

        tags = SocialParser.parse_hashtags(message)

        mentions = SocialParser.parse_mentions(message)

        IO.inspect(tags)       # %{tags: ["#test"]}
        IO.inspect(mentions)   # %{mentions: ["@you", "@me"]}
    end
  end
  ```
