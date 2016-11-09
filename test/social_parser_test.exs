defmodule SocialParserTest do
  use ExUnit.Case
  doctest SocialParser

  @test_message ~S"""
  @you http://example.com/test?a=1&b=abc+123#abc
  this is a #test #message with #a few #test tags from +me
  """

  test "parse should return an empty for blank input" do
      components = SocialParser.parse("")

      assert components == %{tags: [], mentions: [], links: []}
  end

  test "parse should split joined hashtags" do
      components = SocialParser.parse("#one#two")

      assert components.tags == ["#one", "#two"]
  end

  test "parse should split joined mentions" do
      components = SocialParser.parse("@one@two +three+four")

      assert components.mentions == ["@one", "@two", "+three", "+four"]
  end

  test "parse should return all social components" do
    components = SocialParser.parse(@test_message)

    assert components == %{
      tags: ["#test", "#message", "#a", "#test"],
      mentions: ["@you", "+me"],
      links: ["http://example.com/test?a=1&b=abc+123#abc"]
    }
  end
end
