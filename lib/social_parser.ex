defmodule SocialParser do
  @moduledoc """
  SocialParser is used to parse out common social message commponents
  such as hashtags, mentions and urls.
  """

  @whitespace_chars [?\s, ?\t, ?\n]
  @breaking_chars [?#, ?@, ?+ | @whitespace_chars]

  @doc """
  Returns an array of tuples containing all components found for the given `message`

  Prefixes used

  * `#` for hashtags
  * `@` or `+` for mentions
  * `http://` or `https://` for links

  Usage

      iex> SocialParser.parse("hi @you checkout http://example.com/ that +someone hosted #example")
      [
        {:text, "hi "},
        {:mention, "@you"},
        {:text, " checkout "},
        {:link, "http://example.com/"},
        {:text, " that "},
        {:mention, "+someone"},
        {:text, " hosted "},
        {:hashtag, "#example"}
      ]

  """
  def parse(message) do
    message
    |> parse([])
    |> Enum.reverse
  end

  @doc """
  Returns a map of all components for a given `message`

  Usage

      iex> SocialParser.extract("hi @you checkout http://example.com/ that +someone hosted #example")
      %{
        hashtags: ["#example"],
        mentions: ["@you", "+someone"],
        links: ["http://example.com/"],
        text: ["hi ", " checkout ", " that ", " hosted "]
      }

  """
  def extract(message) do
    message
    |> parse
    |> Enum.group_by(&map_key(elem(&1, 0)), &elem(&1, 1))
  end

  @doc """
  Returns a map of all components for a given `message` filtered by a list of
  atoms specified in the `components`

  The available atoms are, `:hashtags`, `:mentions`, `:links` and `:text`

  Usage

      iex> SocialParser.extract("hi @you checkout http://example.com/", [:mentions, :links])
      %{
        mentions: ["@you"],
        links: ["http://example.com/"],
      }

  """
  def extract(message, components) do
    message
    |> extract
    |> Map.take(components)
  end

  defp map_key(:hashtag), do: :hashtags
  defp map_key(:mention), do: :mentions
  defp map_key(:link), do: :links
  defp map_key(key), do: key

  defp parse(<<>>, acc),
    do: acc

  defp parse("http://" <> <<rest::binary>>, state),
    do: parse_component(rest, state, "//:ptth", :link)

  defp parse("https://" <> <<rest::binary>>, state),
    do: parse_component(rest, state, "//:sptth", :link)

  defp parse(<<?#::utf8, rest::binary>>, acc),
    do: parse_component(rest, acc, "#", :hashtag)

  defp parse(<<?@::utf8, rest::binary>>, acc),
    do: parse_component(rest, acc, "@", :mention)

  defp parse(<<?+::utf8, rest::binary>>, acc),
    do: parse_component(rest, acc, "+", :mention)

  defp parse(<<c::utf8, rest::binary>>, acc),
    do: parse_component(rest, acc, <<c>>, :text)

  defp parse_component("http://" <> <<rest::binary>>, acc, value, type) do
    acc = add_to_acc(acc, type, value)
    parse_component(rest, acc, "//:ptth", :link)
  end
  defp parse_component("https://" <> <<rest::binary>>, acc, value, type) do
    acc = add_to_acc(acc, type, value)
    parse_component(rest, acc, "//:sptth", :link)
  end
  defp parse_component(<<c::utf8, rest::binary>>, acc, value, :link)
      when c in @whitespace_chars do
    acc = add_to_acc(acc, :link, value)
    parse(<<c>> <> rest, acc)
  end
  defp parse_component(<<c::utf8, rest::binary>>, acc, value, :text)
      when c in @whitespace_chars do
    parse_component(rest, acc, <<c>> <> value, :text)
  end
  defp parse_component(<<c::utf8, rest::binary>>, acc, value, type)
      when type != :link and c in @breaking_chars do
    acc = add_to_acc(acc, type, value)
    parse(<<c>> <> rest, acc)
  end
  defp parse_component(<<c::utf8, rest::binary>>, acc, value, type) do
    parse_component(rest, acc, <<c>> <> value, type)
  end
  defp parse_component(<<>>, acc, value, type) do
    add_to_acc(acc, type, value)
  end

  defp add_to_acc(acc, key, value) do
    value = String.reverse(value)
    [{key, value}] ++ acc
  end
end
