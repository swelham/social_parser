defmodule SocialParserTest do
  use ExUnit.Case
  doctest SocialParser

  test "parse_hashtags should return an empty list for blank input" do
      tags = SocialParser.parse_hashtags("")

      assert tags == %{tags: []}
  end

  test "parse_hashtags should return a list of found hashtags" do
    message = "@you this is a #test #message with #a few #test tags!"
    tags = SocialParser.parse_hashtags(message)

    assert tags == %{tags: ["#test", "#message", "#a", "#test"]}
  end

  test "parse_hashtags should separate joined hashtags" do
    message = "this is a #test#message"
    tags = SocialParser.parse_hashtags(message)

    assert tags == %{tags: ["#test", "#message"]}
  end

  test "parse_mentions should return a list of found mentions using @" do
    message = "this is @someones #test message from @no_one"
    mentions = SocialParser.parse_mentions(message)

    assert mentions == %{mentions: ["@someones", "@no_one"]}
  end

  test "parse_mentions should return a list of found mentions using +" do
    message = "this is +someones #test message from +no_one"
    mentions = SocialParser.parse_mentions(message)

    assert mentions == %{mentions: ["+someones", "+no_one"]}
  end

  test "parse_hashtags should separate joined mentions" do
    message = "this is a @you@me +me+you"
    mentions = SocialParser.parse_mentions(message)

    assert mentions == %{mentions: ["@you", "@me", "+me", "+you"]}
  end
end
