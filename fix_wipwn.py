#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Convert wipwn's packed main.py into readable main_clean.py without executing it."""
import base64
import marshal
import re
import zlib

src = open("main.py", "r", encoding="utf-8", errors="replace").read()

m = re.search(r"marshal\.loads\(b'((?:[^'\\]|\\.)*)'\)", src, re.S)
if not m:
    raise SystemExit("Could not find marshal payload in main.py")

code = marshal.loads(eval("b'" + m.group(1) + "'"))
inner = zlib.decompress(code.co_consts[2]).decode("utf-8", errors="replace")

m2 = re.search(r"base64\.b64decode\(b'([^']+)'\)", inner, re.S)
if not m2:
    raise SystemExit("Could not find base64 source in inner payload")

source = base64.b64decode(m2.group(1))
open("main_clean.py", "wb").write(source)
print("[OK] wrote main_clean.py (%d bytes)" % len(source))
