NAME = ernestas/php
VERSION = debug

.PHONY: all

all: build

build:
	docker build --pull -t $(NAME):$(VERSION) --rm .

