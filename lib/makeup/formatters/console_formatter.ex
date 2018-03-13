defmodule Makeup.Formatters.ConsoleFormatter do
  def format(tokens) do
    tokens
    |> Enum.map(&format_token/1)
    |> Enum.join("")
  end

  def format_token({tag, _meta, value}) do
    color = color_for_token_type(tag)

    {color, value}
    |> colorized()
  end

  def colorized({nil, value}), do: value

  def colorized({color, value}) do
    [color | value]
    |> IO.ANSI.format(true)
    |> IO.iodata_to_binary()
  end

  @default_colors [
    keyword: :green,
    keyword_declaration: :green,
    name: :cyan,
    name_class: :magenta,
    name_attribute: :light_blue,
    operator: :yellow,
    punctuation: :yellow,
    string_double: :red,
    string_symbol: :light_magenta,
    comment_single: :light_black
  ]

  def color_for_token_type(type) do
    Keyword.get(colors(), type)
  end

  def colors do
    Application.get_env(:makup, :console_format_colors, @default_colors)
  end
end
