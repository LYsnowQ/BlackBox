# -*- coding: utf-8 -*-
from pathlib import Path

model = Path(r'E:\apps\deveco\BlackBox\Home\src\main\ets\model\HomeModel.ets')
text = model.read_text(encoding='utf-8')
feed = Path(r'E:\apps\deveco\BlackBox\Home\mock_raw\_feed.ets').read_text(encoding='utf-8').rstrip() + '\n'
details = Path(r'E:\apps\deveco\BlackBox\Home\mock_raw\_details.ets').read_text(encoding='utf-8').rstrip() + '\n'

marker_feed = """    likeCount: 188,
  },
];

export const followPosts"""
if marker_feed not in text:
    raise SystemExit('feed marker not found')
if "id: 'rs1'" in text:
    print('feed already injected')
else:
    repl_feed = """    likeCount: 188,
  },
""" + feed + """];

export const followPosts"""
    text = text.replace(marker_feed, repl_feed, 1)
    print('feed injected')

if "id: 'rs1'" in text and text.count("id: 'rs1'") >= 2:
    print('details already present')
else:
    idx = text.rfind('export function getPostDetailById')
    if idx < 0:
        raise SystemExit('getPostDetail not found')
    close_idx = text.rfind('];', 0, idx)
    if close_idx < 0:
        raise SystemExit('close not found')
    text = text[:close_idx] + ',\n' + details + text[close_idx:]
    print('details injected at', close_idx)

model.write_text(text, encoding='utf-8')
print('done size', model.stat().st_size)
