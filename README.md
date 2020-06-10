# Github Action wrapping jwage/changelog-generator

Github Action that wraps [jwage/changelog-generator](https://github.com/jwage/changelog-generator) and generates the changelog for the given milestone.

![Example output showing this action in action](images/output.png)

## Output

This action has only one output, namely `changelog`, container the generate changelog.

## Example

The following generates a changelog on a milestone close

```yaml
name: Create Release
on:
  milestone:
    types:
      - closed
jobs:
  generate:
    steps:
      - name: Generate changelog
        uses: WyriHaximus/github-action-jwage-changelog-generator@v1
        id: changelog
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          milestone: ${{ github.event.milestone.title }}
      - name: Show changelog
        run: echo "${CHANGELOG}"
        env:
          CHANGELOG: ${{ steps.changelog.outputs.changelog }}
```

## License ##

Copyright 2020 [Cees-Jan Kiewiet](http://wyrihaximus.net/)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
