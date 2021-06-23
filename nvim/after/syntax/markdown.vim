" adds syntax highlighting to yaml front matter
unlet b:current_syntax

syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml
