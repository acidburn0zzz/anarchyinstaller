# Contributing guide

Anarchy manages images using `git-lfs`, so to properly clone the Anarchy repository make sure you have the `git-lfs`
package installed first.
Then you can help contribute to Anarchy in the following ways.

## Writing code

- Follow shell scripting best practices (e.g. like in
  [Google's shell style guide](https://google.github.io/styleguide/shellguide.html))
- Use `"${variable}"` instead of `$variable`
- Constants (and global variables) should be in `UPPER_CASE`, other variables should be in `lower_case`
- Write comments where needed (e.g. explaining functions)
- Scripts should be named `setup-<function>`, be executable and should not have an extension
- Libraries should always have a `.sh` extension and should not be executable
- Use `shellcheck` to error-check your code
- Always **test your code**
- Write **informative commit messages**

## Updating existing translations

Anarchy supports multiple languages, most of which need maintainers:

- Make sure you use the UTF-8 encoding
- Don't change the variable names (e.g. `intro_msg=`)
- Don't remove any occurrence of `\n` or `\n\n` (new lines)
- Don't remove or edit any variables (e.g. `$a`) or quotes
- If you intend to maintain the translation, add yourself as a maintainer
  at the top of the file (example below)
- If there are existing maintainers, add yourself on a new line below theirs

Example of maintainer info:

```sh
# Maintainer: John Doe <contact@john.doe>
# Current Maintainer: Jane Doe <contact@jane.doe>
```

## Translating Anarchy to new languages

- Copy the `english.conf` file and rename it to your language's english
  name (e.g. `portuguese.conf` or `spanish.conf`)
- Update the LANG variable to your language's UTF-8 locale (e.g. `sl_SI.UTF-8`)
- Read the previous recommendations for existing Anarchy translations
