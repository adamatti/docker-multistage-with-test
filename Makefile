.DEFAULT_GOAL := help

.PHONY: help
help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-build: ## build final image sample:latest
	docker build -t sample:latest --target runner .

docker-sh: docker-build ## enter in the final image with 'sh'
	docker run -it --rm sample:latest sh

docker-run-only:
	docker run -it --rm sample:latest

docker-run: docker-build docker-run-only ## run the program inside docker

docker-build-test: ## build test image
	docker build -t sample-test:latest --target tester .

docker-test-only:
	docker run -it --rm sample-test:latest

docker-test: docker-build-test docker-test-only ## run tests inside docker

docker-test-sh: docker-build-test ## enter in the test image with 'sh'
	docker run -it --rm sample-test:latest sh

docker-builder-sh: ## enter in the build stage with 'sh'
	docker build -t sample-builder:latest --target builder .
	docker run -it --rm sample-builder:latest sh

docker-images: ## show docker images
	docker image ls | egrep sample

docker-rmi: ## remove images
	 @docker rmi -f sample:latest 
	 @docker rmi -f sample-test:latest
	 @docker rmi -f sample-builder:latest