
"""
Import some very common, non-conflicting and not-surprising modules

"""
from dataclasses import dataclass
from pathlib import Path
import base64
import csv
from datetime import datetime, date
import decimal
import io
import itertools
import json
import math
import os
import random
import re
import string
import subprocess
import sys
from collections import OrderedDict, defaultdict, namedtuple
from decimal import Decimal
from enum import Enum
from pprint import pprint
__failed_imports = set()
try: from dateutil.rrule import rrule
except ImportError: __failed_imports.add('rrule')
try: import sh
except ImportError: __failed_imports.add('sh')
try: from matplotlib.pyplot import plot
except ImportError: __failed_imports.add('plot')
try: import pytz
except ImportError: __failed_imports.add('pytz')
try: from dateutil.parser import parse
except ImportError: __failed_imports.add('parse')
try: import mock
except ImportError: import unittest.mock as mock
try: import pandas as pd
except ImportError: __failed_imports.add('pd')
from inspect import ismodule, isfunction, isclass


def snake_case(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

_locals = locals().items()
print(
    '\033[95mmodule:'
    + (', '.join(k for k,v in _locals if ismodule(v) and not k.startswith('__')))
    + '\n'
    + '\033[96mfunc  :'
    + (', '.join(k for k,v in _locals if isfunction(v)))
    + '\n'
#    + '\033[97mclass :'
#    + (', '.join(k for k,v in _locals if isclass(v)))
#    + '\n'
    + '\033[2;37;40mfailed:'
    + ', '.join(__failed_imports)
    + '\033[0m'
)

print('Config %r read.' % __file__)
