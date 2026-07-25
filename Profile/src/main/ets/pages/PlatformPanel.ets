import {
  platformList,
  getBoundAccount,
  PlatformItem,
  PlatformAccount,
  PlatformFriend,
} from '../model/ProfileModel';

/**
 * 已绑定平台内容（独立组件 + @Prop）
 * 父级用 ForEach token 销毁重建，保证 steam ↔ ps 等同绑定态切换时数据必刷新。
 */
@Component
struct PlatformBoundBody {
  @Prop accent: string = '#66C0F4';
  @Prop textOnBg: string = '#C7D5E0';
  @Prop textMuted: string = 'rgba(199,213,224,0.55)';
  @Prop surface: string = 'rgba(255,255,255,0.08)';
  @Prop nickname: string = '';
  @Prop avatarChar: string = '';
  @Prop level: string = '';
  @Prop accountValue: string = '';
  @Prop playTime: string = '';
  @Prop gameCount: string = '';
  @Prop friends: PlatformFriend[] = [];

  @Builder
  StatCell(value: string, label: string) {
    Column({ space: 1 }) {
      Text(value)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.textOnBg)
      Text(label)
        .fontSize(8)
        .fontColor(this.textMuted)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  FriendAvatar(friend: PlatformFriend) {
    Column() {
      Text(friend.avatarChar)
        .fontSize(11)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
    }
    .width(28)
    .height(28)
    .borderRadius(6)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(friend.avatarColor)
  }

  @Builder
  ArrowBtn() {
    Text('›')
      .fontSize(18)
      .fontColor(this.textMuted)
      .width(24)
      .height(28)
      .textAlign(TextAlign.Center)
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.avatarChar)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
        .width(32)
        .height(32)
        .borderRadius(7)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.surface)

        Text(this.nickname)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.textOnBg)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: 8 })

        if (this.level.length > 0) {
          Text(this.level)
            .fontSize(10)
            .fontColor(this.accent)
            .margin({ left: 8 })
        }

        Blank()
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Column() {
        Row() {
          Row({ space: 19 }) {
            this.StatCell(this.accountValue, '账号价值')
            this.StatCell(this.playTime, '游戏时长')
            this.StatCell(this.gameCount, '游戏数量')
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)

          this.ArrowBtn()
        }
        .width('100%')
        .margin({ top: 8 })
        .padding({ top: 6, bottom: 6 })
        .alignItems(VerticalAlign.Center)

        if (this.friends.length > 0) {
          Row() {
            Scroll() {
              Row({ space: 6 }) {
                ForEach(this.friends, (friend: PlatformFriend) => {
                  this.FriendAvatar(friend)
                }, (friend: PlatformFriend) => friend.id)
              }
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Center)
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .align(Alignment.Start)
            .layoutWeight(1)

            this.ArrowBtn()
          }
          .width('100%')
          .margin({ top: 8 })
          .alignItems(VerticalAlign.Center)
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 12, right: 12, top: 6, bottom: 10 })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}

/**
 * 平台绑定窗口（压缩版 · 约 2:1 宽高比）
 * 顶部导航：steam / switch / ps / xbox / epic
 *
 * 刷新策略（针对「同绑定态平台来回切换数据不更新」）：
 * 1. 展示字段全部 @State
 * 2. 内容区 ForEach([viewToken])，token 含 platformId，切换必销毁重建
 * 3. 已绑定区拆成独立 @Component + @Prop（不走易复用的 @Builder 入参）
 */
@Component
export struct PlatformPanel {
  @State platformIndex: number = 0;
  /** ForEach 数据源：单元素，token 变化即整树重建 */
  @State viewTokens: string[] = [`${platformList[0].id}_bound`];

  @State inputId: string = '';
  @State newlyBoundIds: string[] = [];
  @State newlyBoundNames: string[] = [];

  @State isCurrentBound: boolean = true;
  @State platformName: string = platformList[0].name;
  @State inputHint: string = platformList[0].inputHint;
  @State accent: string = platformList[0].accent;
  @State textOnBg: string = platformList[0].textOnBg;
  @State textMuted: string = platformList[0].textMuted;
  @State surface: string = platformList[0].surface;
  @State bgTop: string = platformList[0].bgTop;
  @State bgBottom: string = platformList[0].bgBottom;

  @State accountNickname: string = '';
  @State accountAvatarChar: string = '';
  @State accountLevel: string = '';
  @State accountValue: string = '';
  @State accountPlayTime: string = '';
  @State accountGameCount: string = '';
  @State accountFriends: PlatformFriend[] = [];

  aboutToAppear(): void {
    this.applyPlatform(0);
  }

  private isBound(platformId: string): boolean {
    if (getBoundAccount(platformId) !== undefined) {
      return true;
    }
    return this.newlyBoundIds.indexOf(platformId) >= 0;
  }

  private resolveAccount(platform: PlatformItem): PlatformAccount {
    const existing = getBoundAccount(platform.id);
    if (existing !== undefined) {
      return existing;
    }
    let name = '已绑定用户';
    const idx = this.newlyBoundIds.indexOf(platform.id);
    if (idx >= 0 && idx < this.newlyBoundNames.length) {
      name = this.newlyBoundNames[idx];
    }
    const first = platform.name.length > 0 ? platform.name.substring(0, 1).toUpperCase() : '?';
    return {
      platformId: platform.id,
      nickname: name,
      avatarChar: first,
      level: '',
      accountValue: '—',
      playTime: '—',
      gameCount: '—',
      friends: [],
    };
  }

  private applyPlatform(index: number): void {
    const platform = platformList[index];
    const bound = this.isBound(platform.id);
    // token 必须含 platformId；同 bound 态的 steam/ps 也要不同
    const token = `${platform.id}_${bound ? 'bound' : 'free'}`;

    this.platformIndex = index;
    this.platformName = platform.name;
    this.inputHint = platform.inputHint;
    this.accent = platform.accent;
    this.textOnBg = platform.textOnBg;
    this.textMuted = platform.textMuted;
    this.surface = platform.surface;
    this.bgTop = platform.bgTop;
    this.bgBottom = platform.bgBottom;
    this.inputId = '';
    this.isCurrentBound = bound;

    if (bound) {
      const account = this.resolveAccount(platform);
      this.accountNickname = account.nickname;
      this.accountAvatarChar = account.avatarChar;
      this.accountLevel = account.level;
      this.accountValue = account.accountValue;
      this.accountPlayTime = account.playTime;
      this.accountGameCount = account.gameCount;
      const friends: PlatformFriend[] = [];
      for (let i = 0; i < account.friends.length; i++) {
        friends.push(account.friends[i]);
      }
      this.accountFriends = friends;
    } else {
      this.accountNickname = '';
      this.accountAvatarChar = '';
      this.accountLevel = '';
      this.accountValue = '';
      this.accountPlayTime = '';
      this.accountGameCount = '';
      this.accountFriends = [];
    }

    this.viewTokens = [token];
  }

  private onBind(): void {
    const id = this.inputId.trim();
    if (id.length === 0) {
      return;
    }
    const key = platformList[this.platformIndex].id;
    if (this.newlyBoundIds.indexOf(key) < 0) {
      const ids: string[] = [];
      const names: string[] = [];
      for (let i = 0; i < this.newlyBoundIds.length; i++) {
        ids.push(this.newlyBoundIds[i]);
        names.push(this.newlyBoundNames[i]);
      }
      ids.push(key);
      names.push(id);
      this.newlyBoundIds = ids;
      this.newlyBoundNames = names;
    }
    this.applyPlatform(this.platformIndex);
  }

  private onSelectPlatform(index: number): void {
    if (index === this.platformIndex) {
      return;
    }
    this.applyPlatform(index);
  }

  @Builder
  PlatformNavBuilder() {
    Row() {
      ForEach(platformList, (item: PlatformItem, index: number) => {
        Column() {
          Text(item.name)
            .fontSize(11)
            .fontWeight(this.platformIndex === index ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.platformIndex === index ? this.textOnBg : this.textMuted)
            .letterSpacing(0.2)

          Row()
            .width(this.platformIndex === index ? 12 : 0)
            .height(2)
            .borderRadius(1)
            .backgroundColor(this.accent)
            .margin({ top: 3 })
        }
        .layoutWeight(1)
        .height(28)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => this.onSelectPlatform(index))
      }, (item: PlatformItem) => item.id)
    }
    .width('100%')
    .padding({ left: 2, right: 2, top: 5, bottom: 2 })
  }

  @Builder
  UnboundBodyBuilder() {
    Column({ space: 8 }) {
      Text(`绑定 ${this.platformName.toUpperCase()} 账号`)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.textOnBg)
        .width('100%')
        .textAlign(TextAlign.Center)

      Row({ space: 8 }) {
        TextInput({ placeholder: this.inputHint, text: this.inputId })
          .height(32)
          .fontSize(12)
          .fontColor(this.textOnBg)
          .placeholderColor(this.textMuted)
          .backgroundColor(this.surface)
          .borderRadius(8)
          .padding({ left: 10, right: 10 })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.inputId = value;
          })

        Text('绑定')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.inputId.trim().length > 0 ? '#12141A' : this.textMuted)
          .textAlign(TextAlign.Center)
          .width(64)
          .height(32)
          .borderRadius(16)
          .backgroundColor(this.inputId.trim().length > 0 ? this.accent : this.surface)
          .onClick(() => this.onBind())
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({ left: 14, right: 14, top: 10, bottom: 12 })
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      this.PlatformNavBuilder()

      // 单元素 ForEach：token 变则销毁旧内容、创建新内容（含同为 bound 的 steam/ps）
      ForEach(this.viewTokens, (_token: string) => {
        Column() {
          if (this.isCurrentBound) {
            PlatformBoundBody({
              accent: this.accent,
              textOnBg: this.textOnBg,
              textMuted: this.textMuted,
              surface: this.surface,
              nickname: this.accountNickname,
              avatarChar: this.accountAvatarChar,
              level: this.accountLevel,
              accountValue: this.accountValue,
              playTime: this.accountPlayTime,
              gameCount: this.accountGameCount,
              friends: this.accountFriends,
            })
          } else {
            this.UnboundBodyBuilder()
          }
        }
        .width('100%')
        .layoutWeight(1)
      }, (token: string) => token)
    }
    .width('100%')
    .aspectRatio(2)
    .borderRadius(12)
    .clip(true)
    .linearGradient({
      angle: 165,
      colors: [
        [this.bgTop, 0],
        [this.bgBottom, 1],
      ],
    })
  }
}
