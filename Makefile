# ==============================================================================
# define the default goal
#

.DEFAULT_GOAL := help

## all: Run tidy, gen, add-copyright, format, lint, cover, build ✨
.PHONY: all
all: tidy gen add-copyright verify lint cover restart

# ==============================================================================
# Build set

ROOT_PACKAGE=github.com/OpenIMSDK/openim-docker
# TODO: This is version control for the future https://github.com/OpenIMSDK/Open-IM-Server/issues/574
VERSION_PACKAGE=github.com/OpenIMSDK/Open-IM-Server/pkg/version

# ==============================================================================
# Includes

include scripts/make-rules/common.mk	# make sure include common.mk at the first include line
include scripts/make-rules/golang.mk
include scripts/make-rules/copyright.mk
include scripts/make-rules/gen.mk
include scripts/make-rules/dependencies.mk
include scripts/make-rules/tools.mk
include scripts/make-rules/release.mk
include scripts/make-rules/swagger.mk

# ==============================================================================
# Usage

define USAGE_OPTIONS

Options:

  DEBUG            Whether or not to generate debug symbols. Default is 0.

  BINS             Binaries to build. Default is all binaries under cmd.
                   This option is available when using: make {build}(.multiarch)
                   Example: make build BINS="openim-api openim-cmdutils".

  PLATFORMS        Platform to build for. Default is linux_arm64 and linux_amd64.
                   This option is available when using: make {build}.multiarch
                   Example: make multiarch PLATFORMS="linux_s390x linux_mips64
                   linux_mips64le darwin_amd64 windows_amd64 linux_amd64 linux_arm64".

  V                Set to 1 enable verbose build. Default is 0.
endef
export USAGE_OPTIONS

# ==============================================================================
# Targets

## init: Initialize openim server project ✨
.PHONY: init
init:
	@$(MAKE) gen.init

## demo: Run demo get started with Makefiles quickly ✨
.PHONY: demo
demo:
	@$(MAKE) go.demo

## build: Build binaries by default ✨
.PHONY: build
build:
	@$(MAKE) go.build

## start: Start openim ✨
.PHONY: start
start:
	@$(MAKE) go.start

## stop: Stop openim ✨
.PHONY: stop
stop:
	@$(MAKE) go.stop

## restart: Restart openim ✨
.PHONY: restart
restart: clean stop build init start

## multiarch: Build binaries for multiple platforms. See option PLATFORMS. ✨
.PHONY: multiarch
multiarch:
	@$(MAKE) go.build.multiarch

## verify: execute all verity scripts. ✨
.PHONY: verify
verify:
	@$(MAKE) go.verify

## install: Install deployment openim ✨
.PHONY: install
install:
	@$(MAKE) go.install

## check: Check OpenIM deployment ✨
.PHONY: check
check:
	@$(MAKE) go.check

## check-component
.PHONY: check-component
check-component:
	@$(MAKE) go.check-component

## tidy: tidy go.mod ✨
.PHONY: tidy
tidy:
	@$(GO) mod tidy

## vendor: vendor go.mod ✨
.PHONY: vendor
vendor:
	@$(GO) mod vendor

## style: code style -> fmt,vet,lint ✨
.PHONY: style
style: fmt vet lint

## fmt: Run go fmt against code. ✨
.PHONY: fmt
fmt:
	@$(GO) fmt ./...

## vet: Run go vet against code. ✨
.PHONY: vet
vet:
	@$(GO) vet ./...

## lint: Check syntax and styling of go sources. ✨
.PHONY: lint
lint:
	@$(MAKE) go.lint

## format: Gofmt (reformat) package sources (exclude vendor dir if existed). ✨
.PHONY: format
format:
	@$(MAKE) go.format

## test: Run unit test. ✨
.PHONY: test
test:
	@$(MAKE) go.test

## cover: Run unit test and get test coverage. ✨
.PHONY: cover
cover:
	@$(MAKE) go.test.cover

## updates: Check for updates to go.mod dependencies. ✨
.PHONY: updates
	@$(MAKE) go.updates

## imports: task to automatically handle import packages in Go files using goimports tool. ✨
.PHONY: imports
imports:
	@$(MAKE) go.imports

## clean: Remove all files that are created by building. ✨
.PHONY: clean
clean:
	@$(MAKE) go.clean

## tools: Install dependent tools. ✨
.PHONY: tools
tools:
	@$(MAKE) tools.install

## gen: Generate all necessary files. ✨
.PHONY: gen
gen:
	@$(MAKE) gen.run

## swagger: Generate swagger document. ✨
.PHONY: swagger
swagger:
	@$(MAKE) swagger.run

## serve-swagger: Serve swagger spec and docs. ✨
.PHONY: swagger.serve
serve-swagger:
	@$(MAKE) swagger.serve

## verify-copyright: Verify the license headers for all files. ✨
.PHONY: verify-copyright
verify-copyright:
	@$(MAKE) copyright.verify

## add-copyright: Add copyright ensure source code files have license headers. ✨
.PHONY: add-copyright
add-copyright:
	@$(MAKE) copyright.add

## advertise: Project introduction, become a contributor ✨
.PHONY: advertise
advertise:
	@$(MAKE) copyright.advertise

## release: release the project ✨
.PHONY: release
release: release.verify release.ensure-tag
	@scripts/release.sh

## help: Show this help info. ✨
.PHONY: help
help: Makefile
	$(call makehelp)

## help-all: Show all help details info. ✨
.PHONY: help-all
help-all: go.help copyright.help tools.help dependencies.help gen.help release.help swagger.help help
	$(call makeallhelp)
