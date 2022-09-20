Mix.install([:jason])

json =
  "flashcards.tsv"
  |> File.stream!()
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, ~r/\t/))
  |> Stream.map(fn [en, fr] -> %{en: en, fr: fr} end)
  |> Enum.to_list()
  |> Jason.encode!(pretty: true)

File.write!("./public/flashcards.json", json)
