"""
prompt that starts ojn a separate line and does not icnclude ... for continuation.
"""
from IPython.terminal.prompts import Prompts, Token as IPythonToken  # to avoid conflicts with rest_framework.authtoken.models.Token

class MyPrompt(Prompts):
    def in_prompt_tokens(self):
        return [
            (IPythonToken.Prompt, self.vi_mode()),
            (IPythonToken.Prompt, 'In ['),
            (IPythonToken.PromptNum, str(self.shell.execution_count)),
            (IPythonToken.Prompt, ']:\n'),
        ]

    def out_prompt_tokens(self):
        return [
            (IPythonToken.OutPrompt, 'Out['),
            (IPythonToken.OutPromptNum, str(self.shell.execution_count)),
            (IPythonToken.OutPrompt, ']:\n'),
        ]

    def continuation_prompt_tokens(self, width=None):
        if width is None:
            width = self._width()
        return [
            (IPythonToken.Prompt, (' ' * (width - 5)) + ''),
        ]


class MyPrompt(Prompts):
    def in_prompt_tokens(self):
        return []

    def out_prompt_tokens(self):
        return []

    def continuation_prompt_tokens(self, width=None):
        if width is None:
            width = self._width()
        return [
            (IPythonToken.Prompt, (' ' * (width - 5)) + ''),
        ]

ip = get_ipython()  # noqa
ip.prompts = MyPrompt(ip)
print('Config %r read.' % __file__)
