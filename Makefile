.PHONY: download-openapi

download-openapi:
	curl -L -o Sandbox-MultiModule-Library/Sources/Core/Infra/openapi.yml https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.yaml
