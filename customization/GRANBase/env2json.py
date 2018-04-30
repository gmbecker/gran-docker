#!/usr/bin/env python
# Dinakar Kulkarni <kulkard2@gene.com>
# Convert an environment file to JSON

import json
import sys

try:
    env_file = sys.argv[1]
except IndexError as e:
    env_file = '.Renviron'

with open(env_file, 'r') as f:
    content = f.readlines()

content = [x.strip().replace("'", "").split('=') for x in content if '=' in x]
print('repoparams = ' + json.dumps(dict(content), indent = 4, sort_keys=True))