#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/SonarSource/sonar-scanner-cli"
TOOL_NAME="sonar-scanner"
TOOL_TEST="sonar-scanner --version"

fail() {
	printf "asdf-%s: %s" "${TOOL_NAME}" "$*"
	exit 1
}

KERNEL_NAME="$(uname -s)"
case "${KERNEL_NAME}" in
	Darwin) OS="macosx" ;;
	Linux) OS="linux" ;;
	*) printf "Unknown operating system: %s" "${KERNEL_NAME}"
	exit 1
esac

MACHINE="$(uname -m)"
case "${MACHINE}" in
	x86_64) ARCHITECTURE="x86_64" ;;
	aarch64|arm64) ARCHITECTURE="aarch64" ;;
	armv7l) ARCHITECTURE="arm32-vfp-hflt" ;;
	*) printf "Unknown machine architecture: %s" "${MACHINE}"
	exit 1
esac

curl_opts=(-fsSL)

# NOTE: You might want to remove this if sonar-scanner is not hosted on GitHub releases.
if [[ -n "${GITHUB_API_TOKEN:-}" ]]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token ${GITHUB_API_TOKEN}")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "${GH_REPO}" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-${OS}-${ARCHITECTURE}.zip"

	printf "* Downloading %s release %s..." "${TOOL_NAME}" "${version}"
	curl "${curl_opts[@]}" -o "${filename}" -C - "${url}" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [[ "${install_type}" != "version" ]]; then
		fail "asdf-${TOOL_NAME} supports release installs only"
	fi

	(
		mkdir -p "${install_path}"
		# shellcheck disable=SC2154  # ASDF_DOWNLOAD_PATH is set by asdf
		cp -r "${ASDF_DOWNLOAD_PATH}"/* "${install_path}"

		# TODO: Assert sonar-scanner executable exists.
		local tool_cmd
		tool_cmd="$(echo "${TOOL_TEST}" | cut -d' ' -f1)"
		test -x "${install_path}/${tool_cmd}" || fail "Expected ${install_path}/${tool_cmd} to be executable."

		printf "%s %s installation was successful!" "${TOOL_NAME}" "${version}"
	) || (
		rm -rf "${install_path}"
		fail "An error occurred while installing ${TOOL_NAME} ${version}."
	)
}
