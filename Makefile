PLUGIN_NAME := opentrace
MARKETPLACE := opentrace-marketplace
SCOPE := user

.PHONY: install uninstall reinstall validate list marketplace-add marketplace-remove marketplace-reinstall dev spellcheck

## Install the plugin from the marketplace
install:
	claude plugin install $(PLUGIN_NAME)@$(MARKETPLACE) --scope $(SCOPE)

## Uninstall the plugin
uninstall:
	-claude plugin uninstall $(PLUGIN_NAME)@$(MARKETPLACE) --scope $(SCOPE)

## Validate the plugin manifest
validate:
	claude plugin validate .claude-plugin

## Add the local marketplace from CWD
marketplace-add:
	claude plugin marketplace add $(CURDIR)

## Remove the marketplace
marketplace-remove:
	-claude plugin marketplace remove $(MARKETPLACE)

## Remove and re-add the marketplace from CWD
marketplace-reinstall: marketplace-remove marketplace-add

## Full dev reinstall: uninstall plugin, refresh marketplace, reinstall plugin
dev: uninstall marketplace-reinstall install

## List installed plugins
list:
	claude plugin list

## Run spell check
spellcheck:
	npx cspell --config cspell.json "**/*.{md,txt,sh,json}"
