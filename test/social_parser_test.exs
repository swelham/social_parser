defmodule SocialParserTest do
  use ExUnit.Case
  doctest SocialParser

  @test_message ~S"""
  @you http://example.com/test?a=1&b=abc+123#abc
  this is a #test #message with #a few #test tags from +me
  """

  test "parse should return an empty for blank input" do
    components = SocialParser.parse("")

    assert components == []
  end

  test "parse/1 should return an array of all components" do
    components = SocialParser.parse(@test_message)

    assert components == [
      {:mention, "@you", {0, 4}},
      {:text, " ", {5, 6}},
      {:link, "http://example.com/test?a=1&b=abc+123#abc", {7, 48}},
      {:text, "\nthis is a ", {49, 60}},
      {:hashtag, "#test", {61, 66}},
      {:text, " ", {67, 68}},
      {:hashtag, "#message", {69, 77}},
      {:text, " with ", {78, 84}},
      {:hashtag, "#a", {85, 87}},
      {:text, " few ", {88, 93}},
      {:hashtag, "#test", {94, 99}},
      {:text, " tags from ", {100, 111}},
      {:mention, "+me", {112, 115}},
      {:text, "\n", {116, 117}}
    ]
  end

  test "parse/1 should split joined hashtags" do
    components = SocialParser.parse("#one#two")

    assert components == [
      {:hashtag, "#one", {0, 4}},
      {:hashtag, "#two", {5, 9}}
    ]
  end

  test "parse/1 should split joined mentions" do
    components = SocialParser.parse("@one@two+three+four")

    assert components == [
      {:mention, "@one", {0, 4}},
      {:mention, "@two", {5, 9}},
      {:mention, "+three", {10, 16}},
      {:mention, "+four", {17, 22}}
    ]
  end

  test "extract/2 should return a map containing hashtags" do
    map = SocialParser.extract(@test_message, [:hashtags])

    assert map == %{
      hashtags: ["#test", "#message", "#a", "#test"]
    }
  end

  test "extract/2 should return a map containing mentions" do
    map = SocialParser.extract(@test_message, [:mentions])

    assert map == %{
      mentions: ["@you", "+me"]
    }
  end

  test "extract/2 should return a map containing links" do
    map = SocialParser.extract(@test_message, [:links])

    assert map == %{
      links: ["http://example.com/test?a=1&b=abc+123#abc"]
    }
  end

  test "extract/2 should return a map containing text components" do
    map = SocialParser.extract(@test_message, [:text])

    assert map == %{
      text: [" ", "\nthis is a ", " ", " with ", " few ", " tags from ", "\n"]
    }
  end

  test "extract/1 should return a map containing all social components" do
    map = SocialParser.extract(@test_message)

    assert map == %{
      hashtags: ["#test", "#message", "#a", "#test"],
      mentions: ["@you", "+me"],
      links: ["http://example.com/test?a=1&b=abc+123#abc"],
      text: [" ", "\nthis is a ", " ", " with ", " few ", " tags from ", "\n"]
    }
  end
end
