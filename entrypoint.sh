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

echo "Creating changelog for:"
echo "User: $(echo "${GITHUB_REPOSITORY}" | cut -d "/" -f1)"
echo "Repository: ${GITHUB_REPOSITORY##*/}"
echo "Milestone: ${INPUT_MILESTONE}"

if [ $(echo ${INPUT_LABELS} | wc -c) -eq 1 ] ; then
  echo "<?php declare(strict_types=1); return ['changelog-generator' => (new ChangelogGenerator\ChangelogConfig())->setGitHubCredentials(new ChangelogGenerator\GitHubOAuthToken('${GITHUB_TOKEN}')),];" > /workdir/config.php
else
  echo "<?php declare(strict_types=1); return ['changelog-generator' => (new ChangelogGenerator\ChangelogConfig())->setGitHubCredentials(new ChangelogGenerator\GitHubOAuthToken('${GITHUB_TOKEN}'))->setLabels(explode(',', '${INPUT_LABELS}')),];" > /workdir/config.php
fi

cat /workdir/config.php

changelog=$(/workdir/vendor/bin/changelog-generator generate --config=/workdir/config.php --user="$(echo "${GITHUB_REPOSITORY}" | cut -d "/" -f1)" --repository="${GITHUB_REPOSITORY##*/}" --milestone="${INPUT_MILESTONE}" -vvv)

echo "Changelog generated:"
echo "${changelog}"

changelog="${changelog//'%'/'%25'}"
changelog="${changelog//$'\n'/'%0A'}"
changelog="${changelog//$'\r'/'%0D'}"

echo "changelog=$changelog" >> $GITHUB_OUTPUT
