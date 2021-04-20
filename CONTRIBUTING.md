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

# Add yourself to the contributors table

The Anarchy Installer team follows the [All Contributor specification](https://allcontributors.org/docs/en/specification), which is why we consider the contribution of more than just code as extremely important for the stability and improvement of the project.
You can see the table of [emoji key](https://allcontributors.org/docs/en/emoji-key) with the different types of contributions they represent and add yourself using the emoji you consider appropriate. For that you need to install the `all-contributors-cli` tool from the [AUR](https://aur.archlinux.org/packages/all-contributors-cli), or by following the instructions on the [website](https://allcontributors.org/docs/en/cli/installation).
We recommend reading the [documentation](https://allcontributors.org/docs/en/cli/usage) from their website, but the easiest way to add yourself as a contributor is as follows:

```sh
# Add new contributor <username>, who made a contribution of type <contribution>
all-contributors add <username> <contribution>
# Example:
all-contributors add jfmengels code,doc
```

Finally the table must be generated:

`all-contributors generate`

