defmodule SocialParserTest do
  use ExUnit.Case
  doctest SocialParser

  @test_message "@you this is a #test #message with #a few #test tags from +me"

  test "parse_hashtags should return an empty list for blank input" do
      tags = SocialParser.parse_hashtags("")

      assert tags == %{tags: []}
  end

  test "parse_hashtags should return a list of found hashtags" do
    tags = SocialParser.parse_hashtags(@test_message)

    assert tags == %{tags: ["#test", "#message", "#a", "#test"]}
  end

  test "parse_hashtags should separate joined hashtags" do
    message = "this is a #test#message"
    tags = SocialParser.parse_hashtags(message)

    assert tags == %{tags: ["#test", "#message"]}
  end

  test "parse_mentions should return a list of found mentions" do
    mentions = SocialParser.parse_mentions(@test_message)

    assert mentions == %{mentions: ["@you", "+me"]}
  end

  test "parse_hashtags should separate joined mentions" do
    message = "this is a @you@me +me+you"
    mentions = SocialParser.parse_mentions(message)

    assert mentions == %{mentions: ["@you", "@me", "+me", "+you"]}
  end
end
