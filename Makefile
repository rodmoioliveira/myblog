#!make

build: ## Build blog
	@fd -e bibtex --full-path './content' | xargs npx bibtex-tidy --curly --align --sort=author,title,year --align=20 --tidy-comments --remove-empty-fields --space=2 --duplicates --no-escape && \
	zola build --output-dir docs && \
	fd -e html --full-path './docs' | xargs npx prettier --write --loglevel=silent

dev: ## Serve blog
	@zola serve

changelog: ## Autogenerate CHANGELOG.md
	@docker run -t -v "$(shell pwd)":/app/ orhunp/git-cliff:latest --config cliff.toml --output CHANGELOG.md

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; \
	{printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}' | \
	sort

.PHONY: changelog help build dev

