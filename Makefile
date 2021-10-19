BIN_DIR     ?= ./bin
SCRIPTS_DIR ?= ./scripts

GO_TOOLS = \

default: start

.PHONY: build
build:
	@echo "---> Building"
	$(SCRIPTS_DIR)/build.sh

.PHONY: deploy
deploy:
	@echo "---> Deploying"
	$(SCRIPTS_DIR)/build.sh --push

.PHONY: start
start: $(BIN_DIR)/gin
	@echo "---> Starting"
	TZ=UTC $(BIN_DIR)/gin --excludeDir tmp --excludeDir scripts --port 9876 --appPort 9877 --path . --build ./cmd/debug --immediate --bin $(BIN_DIR)/gin-debug run

$(BIN_DIR)/gin:
	@echo "---> Installing gin"
	go get github.com/codegangsta/gin && GOBIN=$$(pwd)/$(BIN_DIR) go install github.com/codegangsta/gin
