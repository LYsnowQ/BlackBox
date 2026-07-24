import { preferences } from '@kit.ArkData';
import { PostComment, followPosts, recommendPosts } from './HomeModel';

const PREF_NAME = 'home_interact';
const PREF_KEY = 'post_states';
const VERSION_KEY = 'homeInteractVersion';

/** 单帖互动的可持久化快照（相对 mock 基线的用户操作结果） */
export interface PostInteractState {
  liked: boolean;
  starred: boolean;
  awarded: boolean;
  following: boolean;
  likeCount: number;
  starCount: number;
  awardCount: number;
  commentCount: number;
  extraComments: PostComment[];
}

function ensureVersionKey(): void {
  if (!AppStorage.has(VERSION_KEY)) {
    AppStorage.setOrCreate(VERSION_KEY, 0);
  }
}

function bumpVersion(): void {
  ensureVersionKey();
  const cur = AppStorage.get<number>(VERSION_KEY) as number;
  AppStorage.set(VERSION_KEY, cur + 1);
}

class HomeInteractStoreImpl {
  private ready: boolean = false;
  private map: Map<string, PostInteractState> = new Map();
  private loading: Promise<void> | undefined = undefined;

  async ensureLoaded(context: Context): Promise<void> {
    ensureVersionKey();
    if (this.ready) {
      return;
    }
    if (this.loading) {
      await this.loading;
      return;
    }
    this.loading = this.doLoad(context);
    await this.loading;
  }

  private async doLoad(context: Context): Promise<void> {
    try {
      const pref = await preferences.getPreferences(context, PREF_NAME);
      const raw = await pref.get(PREF_KEY, '{}') as string;
      if (raw.length > 2) {
        const obj = JSON.parse(raw) as Record<string, PostInteractState>;
        const keys = Object.keys(obj);
        for (let i = 0; i < keys.length; i++) {
          const id = keys[i];
          const st = obj[id];
          if (st) {
            this.map.set(id, {
              liked: !!st.liked,
              starred: !!st.starred,
              awarded: !!st.awarded,
              following: !!st.following,
              likeCount: st.likeCount ?? 0,
              starCount: st.starCount ?? 0,
              awardCount: st.awardCount ?? 0,
              commentCount: st.commentCount ?? 0,
              extraComments: st.extraComments ?? [],
            });
          }
        }
      }
    } catch (_e) {
      // mock 场景：读失败则保持空 map
    }
    this.ready = true;
    this.patchFeedPosts();
    bumpVersion();
  }

  get(postId: string): PostInteractState | undefined {
    return this.map.get(postId);
  }

  getLikeCount(postId: string, base: number): number {
    const st = this.map.get(postId);
    return st ? st.likeCount : base;
  }

  getCommentCount(postId: string, base: number): number {
    const st = this.map.get(postId);
    return st ? st.commentCount : base;
  }

  async save(context: Context, postId: string, state: PostInteractState): Promise<void> {
    this.map.set(postId, state);
    this.patchFeedPosts();
    bumpVersion();
    try {
      const pref = await preferences.getPreferences(context, PREF_NAME);
      const obj: Record<string, PostInteractState> = {};
      this.map.forEach((v: PostInteractState, k: string) => {
        obj[k] = v;
      });
      await pref.put(PREF_KEY, JSON.stringify(obj));
      await pref.flush();
    } catch (_e) {
      // 写失败时内存态仍保留，下次进入页可继续用
    }
  }

  private patchFeedPosts(): void {
    for (let i = 0; i < recommendPosts.length; i++) {
      const post = recommendPosts[i];
      const st = this.map.get(post.id);
      if (st) {
        post.likeCount = st.likeCount;
        post.commentCount = st.commentCount;
      }
    }
    for (let i = 0; i < followPosts.length; i++) {
      const post = followPosts[i];
      const st = this.map.get(post.id);
      if (st) {
        post.likeCount = st.likeCount;
        post.commentCount = st.commentCount;
      }
    }
  }
}

export const HomeInteractStore = new HomeInteractStoreImpl();
