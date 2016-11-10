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
end
