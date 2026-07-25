# -*- coding: utf-8 -*-
"""从 extracted/postN.json 生成 HomeModel 注入片段，并拷贝配图到 media。"""
import json
import hashlib
import shutil
from pathlib import Path

ROOT = Path(r'E:\apps\deveco\BlackBox')
EXTRACTED = ROOT / 'Home' / 'mock_raw' / 'extracted'
PIC = Path(r'C:\Users\86133\OneDrive\桌面\pic')
MEDIA = ROOT / 'entry' / 'src' / 'main' / 'resources' / 'base' / 'media'
OUT_FEED = ROOT / 'Home' / 'mock_raw' / '_feed_rs5_12.ets'
OUT_DETAILS = ROOT / 'Home' / 'mock_raw' / '_details_rs5_12.ets'

COLORS = [
    '#5B8DEF', '#3D5A80', '#C9A227', '#4EC6E8', '#E0B84A', '#6B7CFF',
    '#F7C6D8', '#B8E0D2', '#F5C16C', '#9B6B9E', '#E85A4F', '#4A5568'
]

# folder -> media 源文件
MEDIA_COPY = {
    1: [('配图.png', 'scrape_greenhell1.png')],
    2: [('配图.png', 'scrape_jiahao1.png')],
    3: [('配图.png', 'scrape_muse1.png')],
    4: [('配图.png', 'scrape_doubao1.png')],
    5: [('配图.png', 'scrape_messi1.png')],
    6: [('配图.png', 'scrape_cxmt1.png')],
    7: [('配图.png', 'scrape_wzry1.png')],
    8: [
        ('配图1.png', 'scrape_cf1.png'),
        ('配图2.png', 'scrape_cf2.png'),
        ('配图3.png', 'scrape_cf3.png'),
        ('配图4.png', 'scrape_cf4.png'),
    ],
}

DEFAULTS = {
    3: {
        'id': 'rs7', 'mediaKeys': ['scrape_muse1'], 'imageLayout': 'right',
        'heroColor': '#1A2744', 'avatarColor': '#9B6B9E', 'avatarText': 'M',
        'likeCount': 101, 'starCount': 53, 'awardCount': 0,
    },
    4: {
        'id': 'rs8', 'mediaKeys': ['scrape_doubao1'], 'imageLayout': 'right',
        'heroColor': '#4A7C59', 'avatarColor': '#5B8DEF', 'avatarText': 'C',
        'likeCount': 448, 'starCount': 22, 'awardCount': 81,
    },
    5: {
        'id': 'rs9', 'mediaKeys': ['scrape_messi1'], 'imageLayout': 'right',
        'heroColor': '#1B3A2A', 'avatarColor': '#E0B84A', 'avatarText': '腾',
        'likeCount': 16, 'starCount': 10, 'awardCount': 0,
    },
    6: {
        'id': 'rs10', 'mediaKeys': ['scrape_cxmt1'], 'imageLayout': 'right',
        'heroColor': '#0D1B2A', 'avatarColor': '#5B8DEF', 'avatarText': '月',
        'likeCount': 228, 'starCount': 58, 'awardCount': 123,
    },
}


def avatar_color(name: str) -> str:
    h = int(hashlib.md5(name.encode('utf-8')).hexdigest()[:8], 16)
    return COLORS[h % len(COLORS)]


def avatar_text(name: str) -> str:
    if not name:
        return '?'
    for ch in name:
        if ch.strip():
            return ch
    return '?'


def esc(s) -> str:
    if s is None:
        return ''
    return (
        str(s)
        .replace('\\', '\\\\')
        .replace("'", "\\'")
        .replace('\r', '')
        .replace('\n', '\\n')
    )


def circle_id(circles, guess=''):
    if guess in ('pc', 'chat', 'digital', 'steam', 'dave'):
        return guess
    text = ' '.join(circles or [])
    if '数码' in text or '硬件' in text:
        return 'digital'
    if 'Steam' in text or 'steam' in text:
        return 'steam'
    if 'PC' in text:
        return 'pc'
    if '戴夫' in text:
        return 'dave'
    return 'chat'


def tag_info(p):
    circles = p.get('circles') or []
    tags = p.get('topicTags') or circles
    hot = p.get('hotTag') or ''
    if hot and ('热' in hot or '门' in hot):
        return 'hot', hot if hot != '热门' else '热点'
    if circles:
        return 'topic', circles[0]
    if tags:
        return 'topic', tags[0]
    return 'topic', '盒友杂谈'


def load_posts():
    posts = []
    for i in range(1, 9):
        path = EXTRACTED / f'post{i}.json'
        if not path.exists():
            print('missing', path)
            continue
        p = json.loads(path.read_text(encoding='utf-8'))
        d = DEFAULTS.get(i, {})
        for k, v in d.items():
            if k not in p or p[k] in (None, '', []):
                p[k] = v
        if not p.get('id'):
            p['id'] = f'rs{i + 4}'  # rs5..
        if not p.get('mediaKeys'):
            keys = []
            for _, dest in MEDIA_COPY.get(i, []):
                keys.append(Path(dest).stem)
            p['mediaKeys'] = keys
        if not p.get('avatarColor'):
            p['avatarColor'] = avatar_color(p.get('authorName') or '')
        if not p.get('avatarText'):
            p['avatarText'] = avatar_text(p.get('authorName') or '')
        if not p.get('heroColor'):
            p['heroColor'] = '#2A3340'
        if not p.get('imageLayout'):
            p['imageLayout'] = 'grid' if len(p.get('mediaKeys') or []) > 1 else 'right'
        # defaults for counts
        if p.get('likeCount') is None:
            p['likeCount'] = 100
        if p.get('starCount') is None:
            p['starCount'] = 10
        if p.get('awardCount') is None:
            p['awardCount'] = 0
        if p.get('commentCount') is None:
            p['commentCount'] = len(p.get('comments') or [])
        posts.append(p)
    return posts


def emit_feed(p) -> str:
    rid = p['id']
    keys = p.get('mediaKeys') or ['']
    images = []
    for k in keys:
        images.append(
            f"      {{ mediaKey: '{esc(k)}', placeholderColor: '{esc(p.get('heroColor') or '#2A3340')}' }}"
        )
    images_s = ',\n'.join(images) if images else "      { mediaKey: '', placeholderColor: '#CCCCCC' }"
    tone, tag = tag_info(p)
    cid = circle_id(p.get('circles'), p.get('circleIdGuess') or '')
    title = p.get('fullTitle') or ''
    if len(title) > 36:
        title = title[:35] + '…'
    summary = p.get('summary') or ''
    if len(summary) > 48:
        summary = summary[:47] + '…'
    return f"""  {{
    id: '{esc(rid)}',
    authorId: '',
    circleId: '{esc(cid)}',
    authorName: '{esc(p.get('authorName') or '')}',
    authorAvatarColor: '{esc(p.get('avatarColor'))}',
    authorAvatarText: '{esc(p.get('avatarText'))}',
    levelLabel: '{esc(p.get('levelLabel') or '')}',
    isOfficial: {'true' if p.get('isOfficial') else 'false'},
    isFollowing: false,
    title: '{esc(title)}',
    summary: '{esc(summary)}',
    images: [
{images_s}
    ],
    imageCount: {len(keys)},
    imageLayout: '{esc(p.get('imageLayout') or 'right')}',
    tagText: '{esc(tag)}',
    tagTone: '{esc(tone)}',
    gameTag: '{esc(p.get('gameTag') or '')}',
    timeText: '{esc(p.get('publishTime') or '')}',
    commentCount: {int(p.get('commentCount') or 0)},
    likeCount: {int(p.get('likeCount') or 0)},
  }}"""


def emit_reply(rid, r, j) -> str:
    return f"""          {{
            id: '{esc(rid)}r{j}',
            authorName: '{esc(r.get('authorName') or '盒友')}',
            isAuthor: {'true' if r.get('isAuthor') else 'false'},
            content: '{esc(r.get('content') or '')}',
            timeText: '{esc(r.get('timeText') or '')}',
            region: '{esc(r.get('region') or '')}',
            replyToName: '{esc(r.get('replyToName') or '')}',
          }}"""


def emit_comment(pid, c, i) -> str:
    cid = f'{pid}c{i}'
    replies = c.get('replies') or []
    # cap replies
    replies = replies[:8]
    reply_blocks = [emit_reply(cid, r, j) for j, r in enumerate(replies) if (r.get('content') or r.get('authorName'))]
    replies_s = ',\n'.join(reply_blocks)
    lvl = c.get('levelLabel') or 'Lv.8'
    if not str(lvl).startswith('Lv'):
        lvl = 'Lv.8'
    return f"""      {{
        id: '{esc(cid)}',
        authorName: '{esc(c.get('authorName') or '盒友')}',
        authorAvatarColor: '{esc(avatar_color(c.get('authorName') or '盒友'))}',
        authorAvatarText: '{esc(avatar_text(c.get('authorName') or '盒友'))}',
        levelLabel: '{esc(lvl)}',
        isAuthor: {'true' if c.get('isAuthor') else 'false'},
        isOfficial: {'true' if c.get('isOfficial') else 'false'},
        isPinned: {'true' if c.get('isPinned') else 'false'},
        timeText: '{esc(c.get('timeText') or '')}',
        region: '{esc(c.get('region') or '')}',
        content: '{esc(c.get('content') or '')}',
        imageKey: '',
        imageColor: '',
        likeCount: {int(c.get('likeCount') or 0)},
        replyTotal: {len(replies)},
        replies: [
{replies_s}
        ],
      }}"""


def emit_detail(p) -> str:
    rid = p['id']
    keys = p.get('mediaKeys') or ['']
    hero = keys[0] if keys else ''
    paras = p.get('bodyParagraphs') or []
    para_lines = ',\n'.join([f"      '{esc(x)}'" for x in paras if x is not None])
    circles = p.get('circles') or []
    circles_s = ', '.join([f"'{esc(c)}'" for c in circles]) or "'盒友杂谈'"
    tags = p.get('topicTags') or circles
    tags_s = ', '.join([f"'{esc(t)}'" for t in tags]) or circles_s
    comments = p.get('comments') or []
    # drop empty content-only noise but keep structure
    comment_blocks = []
    for i, c in enumerate(comments):
        if not c.get('content') and not c.get('replies'):
            continue
        comment_blocks.append(emit_comment(rid, c, i))
    comments_s = ',\n'.join(comment_blocks)
    related = (p.get('fullTitle') or '')[:18]
    return f"""  {{
    id: '{esc(rid)}',
    fullTitle: '{esc(p.get('fullTitle') or '')}',
    authorName: '{esc(p.get('authorName') or '')}',
    authorAvatarColor: '{esc(p.get('avatarColor'))}',
    authorAvatarText: '{esc(p.get('avatarText'))}',
    levelLabel: '{esc(p.get('levelLabel') or '')}',
    isOfficial: {'true' if p.get('isOfficial') else 'false'},
    isFollowing: false,
    publishTime: '{esc(p.get('publishTime') or '')}',
    region: '{esc(p.get('region') or '')}',
    circles: [{circles_s}],
    hotTag: '{esc(p.get('hotTag') or '')}',
    heroMediaKey: '{esc(hero)}',
    heroColor: '{esc(p.get('heroColor') or '#2A3340')}',
    caption: '{esc((p.get('summary') or '')[:40])}',
    bodyParagraphs: [
{para_lines}
    ],
    relatedLink: '',
    authorNote: '',
    topicTags: [{tags_s}],
    relatedSearch: '{esc(related)}',
    collectionName: '',
    collectionProgress: '',
    likeCount: {int(p.get('likeCount') or 0)},
    starCount: {int(p.get('starCount') or 0)},
    awardCount: {int(p.get('awardCount') or 0)},
    commentCount: {int(p.get('commentCount') or 0)},
    comments: [
{comments_s}
    ],
  }}"""


def copy_media():
    MEDIA.mkdir(parents=True, exist_ok=True)
    for folder, pairs in MEDIA_COPY.items():
        for src_name, dest_name in pairs:
            src = PIC / str(folder) / src_name
            dest = MEDIA / dest_name
            if not src.exists():
                print('SKIP missing', src)
                continue
            shutil.copy2(src, dest)
            print('copied', src_name, '->', dest_name, dest.stat().st_size)


def inject(model_path: Path, feed: str, details: str):
    text = model_path.read_text(encoding='utf-8')
    # feed: insert before `];` that closes recommendPosts (before followPosts)
    marker_feed = "export const followPosts"
    idx = text.find(marker_feed)
    if idx < 0:
        raise SystemExit('followPosts not found')
    # find last `];` before followPosts that closes recommendPosts
    close = text.rfind('];', 0, idx)
    if close < 0:
        raise SystemExit('recommendPosts close not found')
    # avoid double inject
    if "id: 'rs5'" in text:
        print('feed rs5 already present, skip feed inject')
    else:
        # ensure comma after last item
        before = text[:close].rstrip()
        if not before.endswith(','):
            # last item ends with }, need comma
            text = before + ',\n' + feed + '\n' + text[close:]
        else:
            text = before + '\n' + feed + '\n' + text[close:]
        # recompute after edit
        print('feed injected')

    if "id: 'rs5'" in text and text.count("id: 'rs5'") >= 2:
        print('details rs5 already present, skip detail inject')
    else:
        # inject before getPostDetailById, at last ]; of postDetails
        gidx = text.rfind('export function getPostDetailById')
        if gidx < 0:
            raise SystemExit('getPostDetailById not found')
        dclose = text.rfind('];', 0, gidx)
        if dclose < 0:
            raise SystemExit('postDetails close not found')
        before = text[:dclose].rstrip()
        if not before.endswith(','):
            text = before + ',\n' + details + '\n' + text[dclose:]
        else:
            text = before + '\n' + details + '\n' + text[dclose:]
        print('details injected')

    model_path.write_text(text, encoding='utf-8')
    print('model size', model_path.stat().st_size)


def main():
    copy_media()
    posts = load_posts()
    print('loaded posts', [p['id'] for p in posts])
    feed = ',\n'.join(emit_feed(p) for p in posts)
    details = ',\n'.join(emit_detail(p) for p in posts)
    OUT_FEED.write_text(feed + '\n', encoding='utf-8')
    OUT_DETAILS.write_text(details + '\n', encoding='utf-8')
    print('wrote', OUT_FEED, OUT_FEED.stat().st_size)
    print('wrote', OUT_DETAILS, OUT_DETAILS.stat().st_size)
    model = ROOT / 'Home' / 'src' / 'main' / 'ets' / 'model' / 'HomeModel.ets'
    inject(model, feed, details)


if __name__ == '__main__':
    main()
