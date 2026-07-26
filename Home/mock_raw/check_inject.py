# -*- coding: utf-8 -*-
from pathlib import Path
t = Path(r'E:\apps\deveco\BlackBox\Home\src\main\ets\model\HomeModel.ets').read_text(encoding='utf-8')
for k in ['rs1', 'rs2', 'rs3', 'rs4']:
    print(k, t.count("id: '%s'" % k))
rec = t[t.find('recommendPosts'):t.find('followPosts')]
print('recommend has rs1', "id: 'rs1'" in rec)
print('recommend has rs4', "id: 'rs4'" in rec)
det_start = t.find('postDetails')
print('details has rs1', t.find("id: 'rs1'", det_start) > 0)
print('details has rs4', t.find("id: 'rs4'", det_start) > 0)
print('getPostDetail', 'getPostDetailById' in t)
print('scrape media keys in model', t.count('scrape_'))
