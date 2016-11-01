# SocialParser

A small library for parsing out common social elements such as hashtags, mentions and urls.

# Todo

* Support for parsing out mentions (including `@name` and `+name`)
* Support for parsing out http links
* Review use cases to define final public interface

## Installation (not on hex yet!)

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `social_parser` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:social_parser, "~> 0.1.0"}]
    end
    ```

  2. Ensure `social_parser` is started before your application:

    ```elixir
    def application do
      [applications: [:social_parser]]
    end
    ```
