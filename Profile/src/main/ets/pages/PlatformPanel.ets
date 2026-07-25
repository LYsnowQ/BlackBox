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
 */
@Component
export struct PlatformPanel {
  @State platformIndex: number = 0;
  @State inputId: string = '';
  /** 绑定输入框 placeholder，随平台切换更新（避免 TextInput 复用残留） */
  @State bindPlaceholder: string = platformList[0].inputHint;
  @State newlyBoundIds: string[] = [];
  @State newlyBoundNames: string[] = [];

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
    this.inputId = '';
  }

  private onSelectPlatform(index: number): void {
    this.platformIndex = index;
    this.inputId = '';
    this.bindPlaceholder = platformList[index].inputHint;
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
        // key + @State placeholder：避免 TextInput 复用导致一直显示上一平台提示
        TextInput({ placeholder: this.bindPlaceholder, text: this.inputId })
          .key(`platform_bind_${platform.id}`)
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
  BoundBuilder(platform: PlatformItem, account: PlatformAccount) {
    // 内容区统一左内边距；账号数据 / 好友列表共用同一视觉左缘（contentLeft）
    Column() {
      // 第一行：个人信息（头像 + 昵称 + 等级）— 保持不变
      Row() {
        Column() {
          Text(account.avatarChar)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
        .width(32)
        .height(32)
        .borderRadius(7)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(platform.surface)

        Text(account.nickname)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor(platform.textOnBg)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: 8 })

        if (account.level.length > 0) {
          Text(account.level)
            .fontSize(10)
            .fontColor(platform.accent)
            .margin({ left: 8 })
        }

        Blank()
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 第二、三行共用同一左缘：账号价值… 与 好友头像 视觉左对齐
      Column() {
        // 账号数据行：数据区左顶格 + 右侧箭头
        Row() {
          Row({ space: 19 }) {
            this.BoundStatCellBuilder(account.accountValue, '账号价值', platform)
            this.BoundStatCellBuilder(account.playTime, '游戏时长', platform)
            this.BoundStatCellBuilder(account.gameCount, '游戏数量', platform)
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

        // 好友列表：头像流左顶格，与上方「账号价值」数字同左缘
        if (account.friends.length > 0) {
          Row() {
            Scroll() {
              Row({ space: 6 }) {
                ForEach(account.friends, (friend: PlatformFriend) => {
                  this.FriendAvatarBuilder(friend)
                }, (friend: PlatformFriend) => friend.id)
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

      if (this.isBound(this.currentPlatform().id)) {
        this.BoundBuilder(this.currentPlatform(), this.resolveAccount(this.currentPlatform()))
      } else {
        this.UnboundBuilder(this.currentPlatform())
      }
    }
    .width('100%')
    .aspectRatio(2) // 约 2:1 宽高比
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
