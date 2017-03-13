import sys, os

# Add any Sphinx extension module names here, as strings. They can be extensions
# coming with Sphinx (named 'sphinx.ext.*') or your custom ones.
extensions = ['sphinx.ext.mathjax', 'sphinx.ext.todo', 'sphinx.ext.autodoc']

# General information about the project.
project = u'VariationalInequality -- Julia for Variational Inequalities'
AUTHORS = u"Changhyun Kwon"
copyright = u'2016--, '+AUTHORS


# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

primary_domain = 'jl'
highlight_language = 'julia'
