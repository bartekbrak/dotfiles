"""
Import some very common, non-conflicting and not-surprising modules

"""
from __future__ import division
import os
import sys
from collections import *
import re
from datetime import datetime, timedelta
try:
    import mock
except ImportError:
    import unittest.mock as mock
try:
    import pandas as pd
except ImportError:
    print('no pandas')
from pprint import pprint
from decimal import Decimal
import json
import string
import itertools
import io
import math
try:
    import sh
except ImportError:
    print('sh not available')
import random

import subprocess
try: from matplotlib.pyplot import plot
except ImportError: print('matplotlib not available')

try: import pytz
except ImportError: pass

try: import pyperclip
except ImportError: print('no pyperclip')

try: from dateutil.parser import parse as d
except: print('no dateutil.parses')

print('Config %r read.' % __file__)

def snake_case(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


