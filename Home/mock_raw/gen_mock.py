# -*- coding: utf-8 -*-
import json
import re
import hashlib
from pathlib import Path

posts = json.loads(Path(r'E:\apps\deveco\BlackBox\Home\mock_raw\good_posts.json').read_text(encoding='utf-8'))

COLORS = [
    '#5B8DEF', '#3D5A80', '#C9A227', '#4EC6E8', '#E0B84A', '#6B7CFF',
    '#F7C6D8', '#B8E0D2', '#F5C16C', '#9B6B9E', '#E85A4F', '#4A5568'
]


def avatar_color(name: str) -> str:
    h = int(hashlib.md5(name.encode('utf-8')).hexdigest()[:8], 16)
    return COLORS[h % len(COLORS)]


def avatar_text(name: str) -> str:
    if not name:
        return '?'
    for ch in name:
        if ch.strip():
            return ch
    return name[0]


def esc(s: str) -> str:
    if s is None:
        return ''
    return (
        str(s)
        .replace('\\', '\\\\')
        .replace("'", "\\'")
        .replace('\r', '')
        .replace('\n', '\\n')
    )


def circle_id(circles):
    text = ' '.join(circles or [])
    if '数码' in text or '手机' in text or '荣耀' in text:
        return 'digital'
    if 'Steam' in text:
        return 'steam'
    if 'PC' in text:
        return 'pc'
    if '戴夫' in text:
        return 'dave'
    return 'chat'


def tag_tone(circles, title):
    text = ' '.join(circles or []) + (title or '')
    if '百科' in text:
        return 'wiki', '百科知识'
    if '热点' in text:
        return 'hot', '热点'
    if circles:
        return 'topic', circles[0]
    return 'topic', '盒友杂谈'


def media_for(pid):
    m = {
        '186486748': ('scrape_fields1', 'scrape_fields2', '#1E3A5F'),
        '186450866': ('scrape_honor1', 'scrape_honor2', '#2A3340'),
        '186442922': ('scrape_tom1', '', '#E8D5C4'),
        '186501566': ('scrape_gf1', '', '#F0C8D8'),
    }
    return m.get(pid, ('', '', '#CCCCCC'))


feed_items = []
detail_items = []
for i, p in enumerate(posts):
    rid = f'rs{i + 1}'
    author = p.get('authorName') or '匿名'
    level = p.get('levelLabel') or ''
    title = p.get('fullTitle') or ''
    summary = p.get('summary') or ''
    if len(summary) > 90:
        summary = summary[:90] + '…'
    paras = [x for x in (p.get('bodyParagraphs') or []) if x and x != title]
    if not paras and summary:
        paras = [summary]
    body = []
    for para in paras:
        para = str(para).strip()
        if not para or para in body:
            continue
        body.append(para)
    body = body[:12]
    circles = [c for c in (p.get('circles') or []) if c and '查看' not in c][:3]
    cid = circle_id(circles)
    tone, tag = tag_tone(circles, title)
    m1, m2, color = media_for(p['id'])
    images = []
    if m1:
        images.append((m1, color))
    if m2:
        images.append((m2, color))
    image_count = max(len(images), 1)
    layout = 'right' if len(images) == 1 else 'grid'
    like = int(p.get('likeCount') or 0)
    if like == 0 and p['id'] == '186486748':
        like = 114
    star = int(p.get('starCount') or 0)
    if star == 0:
        star = max(1, like // 8)
    ccount = int(p.get('commentCount') or len(p.get('comments') or []))
    publish = p.get('publishTime') or ''
    region = p.get('region') or ''
    if region and re.search(r'前|昨天|刚刚', region):
        publish, region = region, publish

    comments = []
    for ci, c in enumerate((p.get('comments') or [])[:20]):
        cname = c.get('authorName') or '盒友'
        ccontent = (c.get('content') or '').strip()
        if not ccontent:
            continue
        ccontent = ccontent.replace('\nCharlotte', '').strip()
        ctime = c.get('timeText') or ''
        creg = c.get('region') or ''
        if ctime and len(ctime) <= 8 and not re.search(r'前|昨天|刚刚|\d', ctime) and not creg:
            creg, ctime = ctime, creg
        if creg and re.search(r'前|昨天|刚刚', creg) and (not ctime or len(ctime) <= 8):
            ctime, creg = creg, ctime
        replies = []
        for ri, r in enumerate((c.get('replies') or [])[:6]):
            rname = (r.get('authorName') or '').strip()
            rcontent = (r.get('content') or '').strip()
            if not rname or not rcontent:
                continue
            replies.append({
                'id': f'{rid}c{ci}r{ri}',
                'authorName': rname,
                'isAuthor': bool(r.get('isAuthor')),
                'content': rcontent,
                'timeText': r.get('timeText') or '',
                'region': r.get('region') or '',
                'replyToName': (r.get('replyToName') or '').replace(':', ''),
            })
        comments.append({
            'id': f'{rid}c{ci}',
            'authorName': cname,
            'authorAvatarColor': avatar_color(cname),
            'authorAvatarText': avatar_text(cname),
            'levelLabel': c.get('levelLabel') or '',
            'isAuthor': bool(c.get('isAuthor')),
            'isOfficial': False,
            'isPinned': bool(c.get('isPinned')) and ci < 2,
            'timeText': ctime,
            'region': creg,
            'content': ccontent,
            'imageKey': '',
            'imageColor': '',
            'likeCount': int(c.get('likeCount') or 0),
            'replyTotal': max(int(c.get('replyTotal') or 0), len(replies)),
            'replies': replies,
        })

    feed_items.append({
        'id': rid,
        'circleId': cid,
        'authorName': author,
        'authorAvatarColor': avatar_color(author),
        'authorAvatarText': avatar_text(author),
        'levelLabel': level,
        'title': title,
        'summary': summary,
        'images': images,
        'imageCount': image_count,
        'imageLayout': layout,
        'tagText': tag,
        'tagTone': tone,
        'commentCount': ccount,
        'likeCount': like,
    })
    detail_items.append({
        'id': rid,
        'fullTitle': title,
        'authorName': author,
        'authorAvatarColor': avatar_color(author),
        'authorAvatarText': avatar_text(author),
        'levelLabel': level,
        'publishTime': publish or '今天',
        'region': region or '未知',
        'circles': circles or ['盒友杂谈'],
        'heroMediaKey': m1 or '',
        'heroColor': color,
        'caption': body[0] if body else summary,
        'bodyParagraphs': body[1:] if len(body) > 1 else (body[:1] if body else [summary]),
        'topicTags': circles[:4] if circles else ['盒友杂谈'],
        'relatedSearch': title[:16],
        'likeCount': like,
        'starCount': star,
        'awardCount': max(0, like // 50),
        'commentCount': ccount,
        'comments': comments,
    })


def emit_images(imgs):
    if not imgs:
        return '[]'
    parts = [f"      {{ mediaKey: '{k}', placeholderColor: '{col}' }}" for k, col in imgs]
    return '[\n' + ',\n'.join(parts) + '\n    ]'


def emit_feed(item):
    return f"""  {{
    id: '{item['id']}',
    authorId: '',
    circleId: '{item['circleId']}',
    authorName: '{esc(item['authorName'])}',
    authorAvatarColor: '{item['authorAvatarColor']}',
    authorAvatarText: '{esc(item['authorAvatarText'])}',
    levelLabel: '{esc(item['levelLabel'])}',
    isOfficial: false,
    isFollowing: false,
    title: '{esc(item['title'])}',
    summary: '{esc(item['summary'])}',
    images: {emit_images(item['images'])},
    imageCount: {item['imageCount']},
    imageLayout: '{item['imageLayout']}',
    tagText: '{esc(item['tagText'])}',
    tagTone: '{item['tagTone']}',
    gameTag: '',
    timeText: '',
    commentCount: {item['commentCount']},
    likeCount: {item['likeCount']},
  }}"""


def emit_reply(r):
    return f"""          {{
            id: '{r['id']}',
            authorName: '{esc(r['authorName'])}',
            isAuthor: {'true' if r['isAuthor'] else 'false'},
            content: '{esc(r['content'])}',
            timeText: '{esc(r['timeText'])}',
            region: '{esc(r['region'])}',
            replyToName: '{esc(r['replyToName'])}',
          }}"""


def emit_comment(c):
    if c['replies']:
        replies = ',\n'.join(emit_reply(r) for r in c['replies'])
        replies_block = f"[\n{replies}\n        ]"
    else:
        replies_block = '[]'
    return f"""      {{
        id: '{c['id']}',
        authorName: '{esc(c['authorName'])}',
        authorAvatarColor: '{c['authorAvatarColor']}',
        authorAvatarText: '{esc(c['authorAvatarText'])}',
        levelLabel: '{esc(c['levelLabel'])}',
        isAuthor: {'true' if c['isAuthor'] else 'false'},
        isOfficial: false,
        isPinned: {'true' if c['isPinned'] else 'false'},
        timeText: '{esc(c['timeText'])}',
        region: '{esc(c['region'])}',
        content: '{esc(c['content'])}',
        imageKey: '',
        imageColor: '',
        likeCount: {c['likeCount']},
        replyTotal: {c['replyTotal']},
        replies: {replies_block},
      }}"""


def emit_detail(d):
    paras = ',\n'.join(f"      '{esc(p)}'" for p in d['bodyParagraphs'])
    circles = ', '.join(f"'{esc(c)}'" for c in d['circles'])
    tags = ', '.join(f"'{esc(t)}'" for t in d['topicTags'])
    comments = ',\n'.join(emit_comment(c) for c in d['comments'])
    return f"""  {{
    id: '{d['id']}',
    fullTitle: '{esc(d['fullTitle'])}',
    authorName: '{esc(d['authorName'])}',
    authorAvatarColor: '{d['authorAvatarColor']}',
    authorAvatarText: '{esc(d['authorAvatarText'])}',
    levelLabel: '{esc(d['levelLabel'])}',
    isOfficial: false,
    isFollowing: false,
    publishTime: '{esc(d['publishTime'])}',
    region: '{esc(d['region'])}',
    circles: [{circles}],
    hotTag: '',
    heroMediaKey: '{d['heroMediaKey']}',
    heroColor: '{d['heroColor']}',
    caption: '{esc(d['caption'])}',
    bodyParagraphs: [
{paras}
    ],
    relatedLink: '',
    authorNote: '',
    topicTags: [{tags}],
    relatedSearch: '{esc(d['relatedSearch'])}',
    collectionName: '',
    collectionProgress: '',
    likeCount: {d['likeCount']},
    starCount: {d['starCount']},
    awardCount: {d['awardCount']},
    commentCount: {d['commentCount']},
    comments: [
{comments}
    ],
  }}"""


feed_code = ',\n'.join(emit_feed(i) for i in feed_items)
detail_code = ',\n'.join(emit_detail(i) for i in detail_items)
out = Path(r'E:\apps\deveco\BlackBox\Home\mock_raw\generated_mock_fragment.ets')
out.write_text('// FEED\n' + feed_code + '\n\n// DETAILS\n' + detail_code + '\n', encoding='utf-8')
print('feed', len(feed_items), 'details', len(detail_items))
print('written', out, out.stat().st_size)
for i in feed_items:
    print(i['id'], i['title'][:40], 'c', i['commentCount'], 'img', len(i['images']))
