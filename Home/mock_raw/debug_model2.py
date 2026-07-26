# -*- coding: utf-8 -*-
from pathlib import Path
import re
text = Path(r'E:/apps/deveco/BlackBox/Home/src/main/ets/model/HomeModel.ets').read_text(encoding='utf-8')
lines = text.splitlines()
for i, l in enumerate(lines, 1):
    if l.strip() == ',':
        print('lone comma at', i)
    if re.search(r',\s*,', l):
        print('double comma', i, l[:80])
for i, l in enumerate(lines):
    if "id: 'r7'" in l:
        print('r7 at', i + 1)
    if "id: 'rs1'" in l:
        print('rs1 at', i + 1)
for i, l in enumerate(lines):
    if i < 400 and "id: 'rs1'" in l:
        for j in range(i - 8, i + 3):
            print(f'{j+1}:{lines[j][:120]}')
        break
print('ok no structural issue found' if not any(l.strip()==',' for l in lines) else 'still has lone commas')
