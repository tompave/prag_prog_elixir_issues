# My own version of the table formatter.
# It works :-), but the rest of the chapter (test, etc)
# relies on the code matching the example from the book
#
defmodule Issues.MyTableFormatter do
  def print_table_for_columns(raw_rows, headers) do
    rows = filtered_rows(raw_rows, headers)

    widths = widths_of_columns(rows)
    format = format_for(widths)

    print_row(headers, format)
    print_separator(widths)
    Enum.each(rows, &print_row(&1, format))
  end

  defp filtered_rows(entries, headers) do
    for entry <- entries do
      for head <- headers do
        printable entry[head]
      end
    end
  end


  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)


  defp widths_of_columns(rows) do
    rows
    |> List.zip() # columns as tuples
    |> Enum.map(fn (col) ->
      col
      |> Tuple.to_list
      |> Enum.map(&String.length/1)
      |> Enum.max
    end)
  end


  defp format_for(widths) do
    Enum.map_join(
      widths,
      " | ",
      fn(w) -> "~-#{w}s" end
    ) <> "~n"
  end


  defp print_separator(widths) do
    Enum.map_join(
      widths,
      "-+-",
      &String.duplicate("-", &1)
    )
    |> IO.puts
  end


  defp print_row(list_of_values, format) do
    :io.format(format, list_of_values)
  end
end
