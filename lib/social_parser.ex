defmodule SocialParser do
  @moduledoc """
  SocialParser is used to parse out common social message commponents
  such as hashtags, mentions and urls.
  """
  defmacro is_breaking_char(c) do
    quote do
      unquote(c) == ?\s or
      unquote(c) == ?\t or
      unquote(c) == ?\n or
      unquote(c) == ?#
    end
  end

  @doc """
  Returns a list of hashtags for the given `message`

      iex> SocialParser.parse_hashtags("some #message with #tags")
      ["#message", "#tags"]
  """
  def parse_hashtags(message) do
    message
      |> parse([])
      |> Enum.reverse()
      |> to_string()
      |> String.split()
  end

  defp parse(<<>>, acc), do: acc
  defp parse(<<?#::utf8, rest::binary>>, acc) do
    parse_hashtag(rest, [?#] ++ acc)
  end
  defp parse(<<c::utf8, rest::binary>>, acc) do
      parse(rest, acc)
  end

  defp parse_hashtag(<<c::utf8, rest::binary>>, acc) when is_breaking_char(c) do
    parse(<<c>> <> rest, [?\s] ++ acc)
  end
  defp parse_hashtag(<<c::utf8, rest::binary>>, acc) do
      parse_hashtag(rest, [c] ++ acc)
  end
  defp parse_hashtag(_, acc), do: acc
end
