#!/bin/ash

set -eo pipefail

if [ $(echo ${GITHUB_REPOSITORY} | wc -c) -eq 1 ] ; then
  echo -e "\033[31mRepository cannot be empty\033[0m"
  exit 1
fi

if [ $(echo ${INPUT_MILESTONE} | wc -c) -eq 1 ] ; then
  echo -e "\033[31mMilestone cannot be empty\033[0m"
  exit 1
fi

echo "<?php declare(strict_types=1); return ['changelog-generator' => (new ChangelogGenerator\ChangelogConfig())->setGitHubCredentials(new ChangelogGenerator\GitHubUsernamePassword('$(echo "${GITHUB_REPOSITORY}" | cut -d "/" -f1)', '${GITHUB_TOKEN}')),];" > config.php

changelog=$(./vendor/bin/changelog-generator generate --config=config.php --user=$(echo "${GITHUB_REPOSITORY}" | cut -d "/" -f1) --repository=${GITHUB_REPOSITORY##*/} --milestone=${INPUT_MILESTONE})
changelog="${changelog//'%'/'%25'}"
changelog="${changelog//$'\n'/'%0A'}"
changelog="${changelog//$'\r'/'%0D'}"

echo "::set-output name=changelog::$changelog"
