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

  test "parse should return an array of all components" do
    components = SocialParser.parse(@test_message)

    assert components == [
      {:mention, "@you"},
      {:text, " "},
      {:link, "http://example.com/test?a=1&b=abc+123#abc"},
      {:text, "\nthis is a "},
      {:hashtag, "#test"},
      {:text, " "},
      {:hashtag, "#message"},
      {:text, " with "},
      {:hashtag, "#a"},
      {:text, " few "},
      {:hashtag, "#test"},
      {:text, " tags from "},
      {:mention, "+me"},
      {:text, "\n"}
    ]
  end

  test "parse should split joined hashtags" do
    components = SocialParser.parse("#one#two")

    assert components == [
      {:hashtag, "#one"},
      {:hashtag, "#two"}
    ]
  end

  test "parse should split joined mentions" do
    components = SocialParser.parse("@one@two+three+four")

    assert components == [
      {:mention, "@one"},
      {:mention, "@two"},
      {:mention, "+three"},
      {:mention, "+four"}
    ]
  end

  test "extract should return a map containing hashtags" do
    map = SocialParser.extract(@test_message, [:hashtags])

    assert map == %{
      hashtags: ["#test", "#message", "#a", "#test"]
    }
  end

  test "extract should return a map containing mentions" do
    map = SocialParser.extract(@test_message, [:mentions])

    assert map == %{
      mentions: ["@you", "+me"]
    }
  end

  test "extract should return a map containing links" do
    map = SocialParser.extract(@test_message, [:links])

    assert map == %{
      links: ["http://example.com/test?a=1&b=abc+123#abc"]
    }
  end

  test "extract should return a map containing text components" do
    map = SocialParser.extract(@test_message, [:text])

    assert map == %{
      text: [" ", "\nthis is a ", " ", " with ", " few ", " tags from ", "\n"]
    }
  end

  test "extract should return a map containing all social components" do
    map = SocialParser.extract(@test_message)

    assert map == %{
      hashtags: ["#test", "#message", "#a", "#test"],
      mentions: ["@you", "+me"],
      links: ["http://example.com/test?a=1&b=abc+123#abc"],
      text: [" ", "\nthis is a ", " ", " with ", " few ", " tags from ", "\n"]
    }
  end
end
