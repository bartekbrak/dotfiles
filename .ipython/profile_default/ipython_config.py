c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.display_completions = 'readlinelike'
c.TerminalInteractiveShell.highlight_matching_brackets = False
# This will create horror when matplotlib isn't installed:
#c.InteractiveShellApp.matplotlib = "inline"
print('Config %r read.' % __file__)
