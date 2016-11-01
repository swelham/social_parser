defmodule SocialParser do
  @moduledoc """
  SocialParser is used to parse out common social message commponents
  such as hashtags, mentions and urls.
  """
  
  defmacrop is_breaking_char(c) do
    quote do
      unquote(c) == ?\s or
      unquote(c) == ?\t or
      unquote(c) == ?\n or
      unquote(c) == ?# or
      unquote(c) == ?@ or
      unquote(c) == ?+
    end
  end

  @doc """
  Returns a list of hashtags for the given `message`

      iex> SocialParser.parse_hashtags("some #message with #tags")
      %{tags: ["#message", "#tags"]}
  """
  def parse_hashtags(message) do
    message
    |> parse(%{tags: []}, :tags)
  end

  @doc """
  Returns a list of mentions for the given `message` using either the
  `@name` or `+name` identifiers

      iex> SocialParser.parse_mentions("hello @john its +me")
      %{mentions: ["@john", "+me"]}
  """
  def parse_mentions(message) do
    message
    |> parse(%{mentions: []}, :mentions)
  end

  defp parse(<<>>, state, type) do
    Map.put(state, type, Enum.reverse(state[type]))
  end
  defp parse(<<?#::utf8, rest::binary>>, state, type) do
    parse_component(rest, state, "#", type)
  end
  defp parse(<<?@::utf8, rest::binary>>, state, type) do
    parse_component(rest, state, "@", type)
  end
  defp parse(<<?+::utf8, rest::binary>>, state, type) do
    parse_component(rest, state, "+", type)
  end
  defp parse(<<c::utf8, rest::binary>>, state, type) do
    parse(rest, state, type)
  end

  defp parse_component(<<c::utf8, rest::binary>>, state, value, type) when is_breaking_char(c) do
    state = add_to_state(state, type, value)
    parse(<<c>> <> rest, state, type)
  end
  defp parse_component(<<c::utf8, rest::binary>>, state, value, type) do
    parse_component(rest, state, <<c>> <> value, type)
  end
  defp parse_component(<<>>, state, value, type) do
    state = add_to_state(state, type, value)
    parse(<<>>, state, type)
  end

  defp add_to_state(state, key, value) do
    value = String.reverse(value)
    Map.put(state, key, [value] ++ state[key])
  end
end
