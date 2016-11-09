defmodule SocialParser do
  @moduledoc """
  SocialParser is used to parse out common social message commponents
  such as hashtags, mentions and urls.
  """

  @whitespace_chars [?\s, ?\t, ?\n]
  @breaking_chars [?#, ?@, ?+ | @whitespace_chars]

  @doc """
  Returns a map containing all social components found for the given `message`

  Prefixes used

  * `#` for hashtags
  * `@` or `+` for mentions
  * `http://` or `https://` for links

  Usage

      iex> SocialParser.parse("hi @you checkout http://example.com/ that +someone hosted #example")
      %{
        tags: ["#example"],
        mentions: ["@you", "+someone"],
        links: ["http://example.com/"]
      }

  """
  def parse(message) do
    message
    |> parse(%{tags: [], mentions: [], links: []})
  end

  defp parse(<<>>, state) do
    state
    |> Map.put(:tags, Enum.reverse(state[:tags]))
    |> Map.put(:mentions, Enum.reverse(state[:mentions]))
    |> Map.put(:links, Enum.reverse(state[:links]))
  end

  defp parse("http://" <> <<rest::binary>>, state),
    do: parse_component(rest, state, "//:ptth", :links)

  defp parse("https://" <> <<rest::binary>>, state),
   do: parse_component(rest, state, "//:sptth", :links)

  defp parse(<<?#::utf8, rest::binary>>, state),
   do: parse_component(rest, state, "#", :tags)

  defp parse(<<?@::utf8, rest::binary>>, state),
   do: parse_component(rest, state, "@", :mentions)

  defp parse(<<?+::utf8, rest::binary>>, state),
   do: parse_component(rest, state, "+", :mentions)

  defp parse(<<_::utf8, rest::binary>>, state),
   do: parse(rest, state)

  defp parse_component(<<c::utf8, rest::binary>>, state, value, :links)
      when c in @whitespace_chars do
    state = add_to_state(state, :links, value)
    parse(<<c>> <> rest, state)
  end
  defp parse_component(<<c::utf8, rest::binary>>, state, value, type)
      when type != :links and c in @breaking_chars do
    state = add_to_state(state, type, value)
    parse(<<c>> <> rest, state)
  end
  defp parse_component(<<c::utf8, rest::binary>>, state, value, type) do
    parse_component(rest, state, <<c>> <> value, type)
  end
  defp parse_component(<<>>, state, value, type) do
    state = add_to_state(state, type, value)
    parse(<<>>, state)
  end

  defp add_to_state(state, key, value) do
    value = String.reverse(value)
    Map.put(state, key, [value] ++ state[key])
  end
end
