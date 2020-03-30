NAME = ernestas/php
VERSION = 7.4

.PHONY: build push

build:
	docker build --pull -t $(NAME):$(VERSION) --rm .

push:
	docker push $(NAME):$(VERSION)
