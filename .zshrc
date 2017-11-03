# Set ZSH Theme
ZSH_THEME="cobalt2"

# Homebrew
alias brewup="brew update; brew upgrade; brew prune; brew cleanup; brew doctor"

# Docker
alias dockerclean="docker system prune -f && docker volume prune -f"

# Run Docker Containers
php() {
	docker_is_running "php" && run_local_docker "php" "$@" || start_new_docker_container "php" "$@"
}

composer() {
	docker_is_running "composer" && run_local_docker "composer" "$@" || start_new_docker_container "composer" "$@"
}

# Docker Helper Functions
docker_is_running() {
	local binary=${1}
	local container=$(docker ps | grep ${binary} | awk '{ print $1 }' | head -1)

	if [ ! -z "$container" ]; then
		return 0
	else
		return 1
	fi
}

run_local_docker() {
	local binary=${1}
	local container=$(docker ps | grep ${binary} | awk '{ print $1 }' | head -1)

	docker exec -it $container "$@"
}

start_new_docker_container() {
	local binary=${1}
	local image=""

	case ${binary} in
		php|composer)
			image="oliverlundquist/php7"
			;;
	esac

	docker run -it -v $PWD:/var/app/current $image "$@"
}
