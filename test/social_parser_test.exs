defmodule SocialParserTest do
  use ExUnit.Case
  doctest SocialParser

  test "parse_hashtags should return an empty list for blank input" do
      tags = SocialParser.parse_hashtags("")

      assert tags == []
  end

  test "parse_hashtags should return a list of found hashtags" do
    message = "this is a #test #message with #a few #test tags!"
    tags = SocialParser.parse_hashtags(message)

    assert tags == ["#test", "#message", "#a", "#test"]
  end
end
