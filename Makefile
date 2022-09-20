.PHONY: push

push:
	elixir flashcards.exs
	npm run build
	git add dist -f
