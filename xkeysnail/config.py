# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# [Global modemap] Change modifier keys as in xmodmap
define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL
    })

define_multipurpose_modmap({
    # SandS
    Key.SPACE: [Key.SPACE, Key.LEFT_SHIFT],
    })
