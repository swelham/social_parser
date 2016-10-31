defmodule SocialParser do
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

  defp parse_hashtag(<<?\s::utf8, rest::binary>>, acc) do
    parse(rest, [?\s] ++ acc)
  end
  defp parse_hashtag(<<c::utf8, rest::binary>>, acc) do
      parse_hashtag(rest, [c] ++ acc)
  end
end
