Mix.install([:jason])

line_to_map = fn [en, fr] ->
  %{en: String.trim(en), fr: String.trim(fr)}
end

parse_lines = fn file ->
  file
  |> File.stream!()
  |> Stream.map(&String.trim(&1))
  |> Stream.map(&String.split(&1, ~r/\t/))
  |> Stream.map(&line_to_map.(&1))
  |> Enum.to_list()
end

"flashcards"
|> File.ls!()
|> Enum.map(&Task.async(fn -> parse_lines.("flashcards/#{&1}") end))
|> Enum.flat_map(&Task.await/1)
|> Jason.encode!(pretty: true)
|> then(&File.write!("./public/flashcards.json", &1))
