import {
  platformList,
  getBoundAccount,
  PlatformItem,
  PlatformAccount,
  PlatformFriend,
} from '../model/ProfileModel';

/**
 * 平台绑定窗口（压缩版 · 约 2:1 宽高比）
 * 顶部导航 top ≈ 5px：steam / switch / ps / xbox / epic
 *
 * 注意：切换平台时必须同步 @State 展示字段，并对内容区加 key，
 * 否则 ArkUI 会复用同构子树，导致绑定数据 / placeholder 不刷新。
 */
@Component
export struct PlatformPanel {
  @State platformIndex: number = 0;
  /** 当前平台 id，同时作为内容区重建 key */
  @State platformId: string = platformList[0].id;
  @State inputId: string = '';
  /** 绑定输入框 placeholder，随平台切换更新 */
  @State bindPlaceholder: string = platformList[0].inputHint;
  @State newlyBoundIds: string[] = [];
  @State newlyBoundNames: string[] = [];

  // ── 当前平台展示用 @State（避免 @Builder 入参被节点复用吃掉）──
  @State isCurrentBound: boolean = getBoundAccount(platformList[0].id) !== undefined;
  @State accountNickname: string = '';
  @State accountAvatarChar: string = '';
  @State accountLevel: string = '';
  @State accountValue: string = '';
  @State accountPlayTime: string = '';
  @State accountGameCount: string = '';
  @State accountFriends: PlatformFriend[] = [];

  aboutToAppear(): void {
    this.syncPlatformView(0);
  }

  private currentPlatform(): PlatformItem {
    return platformList[this.platformIndex];
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

  /** 切换 / 绑定后：把平台与账号数据写入 @State，驱动 UI 全量刷新 */
  private syncPlatformView(index: number): void {
    const platform = platformList[index];
    this.platformIndex = index;
    this.platformId = platform.id;
    this.bindPlaceholder = platform.inputHint;
    this.inputId = '';

    const bound = this.isBound(platform.id);
    this.isCurrentBound = bound;
    if (bound) {
      const account = this.resolveAccount(platform);
      this.accountNickname = account.nickname;
      this.accountAvatarChar = account.avatarChar;
      this.accountLevel = account.level;
      this.accountValue = account.accountValue;
      this.accountPlayTime = account.playTime;
      this.accountGameCount = account.gameCount;
      // 新数组引用，确保好友 ForEach 识别变化
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
  }

  private onBind(): void {
    const id = this.inputId.trim();
    if (id.length === 0) {
      return;
    }
    const key = this.currentPlatform().id;
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
    // 绑定后刷新为已绑定卡片
    this.syncPlatformView(this.platformIndex);
  }

  private onSelectPlatform(index: number): void {
    if (index === this.platformIndex) {
      return;
    }
    this.syncPlatformView(index);
  }

  @Builder
  PlatformNavBuilder(platform: PlatformItem) {
    Row() {
      ForEach(platformList, (item: PlatformItem, index: number) => {
        Column() {
          Text(item.name)
            .fontSize(11)
            .fontWeight(this.platformIndex === index ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.platformIndex === index ? platform.textOnBg : platform.textMuted)
            .letterSpacing(0.2)

          Row()
            .width(this.platformIndex === index ? 12 : 0)
            .height(2)
            .borderRadius(1)
            .backgroundColor(platform.accent)
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
  UnboundBuilder(platform: PlatformItem) {
    Column({ space: 8 }) {
      Text(`绑定 ${platform.name.toUpperCase()} 账号`)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(platform.textOnBg)
        .width('100%')
        .textAlign(TextAlign.Center)

      Row({ space: 8 }) {
        TextInput({ placeholder: this.bindPlaceholder, text: this.inputId })
          .key(`platform_bind_input_${this.platformId}`)
          .height(32)
          .fontSize(12)
          .fontColor(platform.textOnBg)
          .placeholderColor(platform.textMuted)
          .backgroundColor(platform.surface)
          .borderRadius(8)
          .padding({ left: 10, right: 10 })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.inputId = value;
          })

        Text('绑定')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.inputId.trim().length > 0 ? '#12141A' : platform.textMuted)
          .textAlign(TextAlign.Center)
          .width(64)
          .height(32)
          .borderRadius(16)
          .backgroundColor(this.inputId.trim().length > 0 ? platform.accent : platform.surface)
          .onClick(() => this.onBind())
      }
      .width('100%')
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: 14, right: 14, top: 10, bottom: 12 })
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  BoundStatCellBuilder(value: string, label: string, platform: PlatformItem) {
    Column({ space: 1 }) {
      Text(value)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(platform.textOnBg)
      Text(label)
        .fontSize(8)
        .fontColor(platform.textMuted)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  FriendAvatarBuilder(friend: PlatformFriend) {
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

  /** 右侧跳转箭头占位，后续接页面路由 */
  @Builder
  ArrowButtonBuilder(platform: PlatformItem) {
    Text('›')
      .fontSize(18)
      .fontColor(platform.textMuted)
      .width(24)
      .height(28)
      .textAlign(TextAlign.Center)
  }

  @Builder
  BoundBuilder(platform: PlatformItem) {
    Column() {
      // 第一行：个人信息（头像 + 昵称 + 等级）
      Row() {
        Column() {
          Text(this.accountAvatarChar)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
        .width(32)
        .height(32)
        .borderRadius(7)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(platform.surface)

        Text(this.accountNickname)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor(platform.textOnBg)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: 8 })

        if (this.accountLevel.length > 0) {
          Text(this.accountLevel)
            .fontSize(10)
            .fontColor(platform.accent)
            .margin({ left: 8 })
        }

        Blank()
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Column() {
        Row() {
          Row({ space: 19 }) {
            this.BoundStatCellBuilder(this.accountValue, '账号价值', platform)
            this.BoundStatCellBuilder(this.accountPlayTime, '游戏时长', platform)
            this.BoundStatCellBuilder(this.accountGameCount, '游戏数量', platform)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)

          this.ArrowButtonBuilder(platform)
        }
        .width('100%')
        .margin({ top: 8 })
        .padding({ top: 6, bottom: 6 })
        .alignItems(VerticalAlign.Center)

        if (this.accountFriends.length > 0) {
          Row() {
            Scroll() {
              Row({ space: 6 }) {
                ForEach(this.accountFriends, (friend: PlatformFriend) => {
                  this.FriendAvatarBuilder(friend)
                }, (friend: PlatformFriend) => `${this.platformId}_${friend.id}`)
              }
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Center)
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .align(Alignment.Start)
            .layoutWeight(1)

            this.ArrowButtonBuilder(platform)
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
    .layoutWeight(1)
    .padding({ left: 12, right: 12, top: 6, bottom: 10 })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }

  build() {
    Column() {
      this.PlatformNavBuilder(this.currentPlatform())

      // key 强制内容区随平台 / 绑定态重建，杜绝同构子树复用
      Column() {
        if (this.isCurrentBound) {
          this.BoundBuilder(this.currentPlatform())
        } else {
          this.UnboundBuilder(this.currentPlatform())
        }
      }
      .width('100%')
      .layoutWeight(1)
      .key(`platform_body_${this.platformId}_${this.isCurrentBound ? 'bound' : 'free'}`)
    }
    .width('100%')
    .aspectRatio(2)
    .borderRadius(12)
    .clip(true)
    .linearGradient({
      angle: 165,
      colors: [
        [this.currentPlatform().bgTop, 0],
        [this.currentPlatform().bgBottom, 1],
      ],
    })
  }
}
