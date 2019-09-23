"""
Import some very common, non-conflicting and not-surprising modules

"""
import base64
import csv
import datetime
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
from collections import *
from decimal import Decimal
from enum import Enum
from pprint import pprint

try: import sh
except ImportError:  pass
try: from matplotlib.pyplot import plot
except ImportError: pass  # print('matplotlib not available')
try: import pytz
except ImportError: pass
try: from dateutil.parser import parse
except: print('no dateutil.parse')
try: import mock
except ImportError: import unittest.mock as mock
try: import pandas as pd
except ImportError: pass

print('Config %r read.' % __file__)

def snake_case(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

