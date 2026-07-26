# -*- coding: utf-8 -*-
from pathlib import Path
lines = Path(r'E:/apps/deveco/BlackBox/Home/src/main/ets/model/HomeModel.ets').read_text(encoding='utf-8').splitlines()
print('total', len(lines))
# locations of key ids
for i, l in enumerate(lines):
    if "id: 'rs1'" in l or "id: 'rs4'" in l or "id: 'f2'" in l:
        print(i + 1, l.strip()[:100])

# find first rs1 after postDetails
for i, l in enumerate(lines):
    if i > 500 and "id: 'rs1'" in l:
        print('\n--- around first detail rs1 ---')
        for j in range(max(0, i - 20), min(len(lines), i + 15)):
            print(f'{j+1}: {lines[j][:160]}')
        break

# show end of file
print('\n--- file end ---')
for j in range(len(lines) - 20, len(lines)):
    print(f'{j+1}: {lines[j][:160]}')
