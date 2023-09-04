# From here: https://gitlab.com/jgkamat/dotfiles/blob/master/qutebrowser/.config/qutebrowser/pyconfig/redirectors.py#L35

import operator, re, typing
from urllib.parse import urljoin

from qutebrowser.api import interceptor, message
from PyQt5.QtCore import QUrl

# Any return value other than a literal 'False' means we redirected
REDIRECT_MAP = {
	"reddit.com": operator.methodcaller('setHost', 'old.reddit.com'),
	"www.reddit.com": operator.methodcaller('setHost', 'old.reddit.com'),
} # type: typing.Dict[str, typing.Callable[..., typing.Optional[bool]]]

def int_fn(info: interceptor.Request):
	"""Block the given request if necessary."""
	if (info.resource_type != interceptor.ResourceType.main_frame or
			info.request_url.scheme() in {"data", "blob"}):
		return

	url = info.request_url
	redir = REDIRECT_MAP.get(url.host())

	if redir is not None and redir(url) is not False:
		message.info("Redirecting to " + url.toString())
		info.redirect(url)

interceptor.register(int_fn)

