# ============================================================================
# FILE: dein.py
# AUTHOR: delphinus <delphinus@remora.cx>
# License: MIT license
# ============================================================================

from .base import Base
import re

HEADER_RE = re.compile(r'^\s*[a-zA-Z_]\w*://')
SPACE_RE = re.compile(r'^\s+')
DEIN_LOG_SYNTAX_HIGHLIGHT = [
    {'name': 'Message',  're': r'.*',            'link': 'Comment'},
    {'name': 'Progress', 're': r'(.\{-}):\s*.*', 'link': 'String'},
    {'name': 'Source',   're': r'|.\{-}|',       'link': 'Type'},
    {'name': 'URI',      're': r'-> diff URI',   'link': 'Underlined'},
    ]


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'dein/log'

    def on_init(self, context):
        context['event'] = 'async'
        context['__source_log'] = []

    def gather_candidates(self, context):
        dein_context = self.vim.call('dein#install#_get_context')
        context['is_async'] = bool(dein_context)
        if not context['is_async']:
            return []
        if context['args'] and context['args'][0] == '!':
            log_func = 'dein#install#_get_updates_log'
        else:
            log_func = 'dein#install#_get_log'
        logs = self.vim.call(log_func)

        def make_candidates(row):
            match = HEADER_RE.match(row)
            return {
                'word': ' -> diff URI' if match else row,
                'kind': 'file' if match else row,
                'action__uri': SPACE_RE.sub(row, ''),
                }

        rows = len(context['__source_log'])
        candidates = list(map(make_candidates, logs[rows:]))
        context['__source_log'] = logs
        return candidates

    def highlight(self):
        for syn in DEIN_LOG_SYNTAX_HIGHLIGHT:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'
                .format(self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {0}_{1} {2}'
                .format(self.syntax_name, syn['name'], syn['link']))
