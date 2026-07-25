import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { GameLibraryRoutes } from '../../../router/GameLibraryRoutes';

export interface UserPostItem {
  id: string;
  authorName: string;
  authorAvatar: ResourceStr;
  authorLevel: string;
  postTitle?: string;
  content: string;
  gameTitle?: string;
  gameCover?: ResourceStr;
  gamePrice?: string;
  gameScore?: string;
  gameLikes?: string;
  ratingStars?: number;
  tagLabel: string;
  dateStr?: string;
  commentsCount: number;
  likesCount: number;
}

export interface UserOwnedGame {
  id: string;
  title: string;
  totalHours: string;
  recentHours: string;
  achievements: string;
  coverImg: ResourceStr;
  scoreRank?: string;
  progressPercent?: number;
}

@Component
export struct UserProfilePage {
  @State username: string = '小鼠鱼';
  @State userLevel: string = 'Lv.12';
  @State bio: string = '喵喵喵？';
  @State followingCount: number = 9;
  @State followersCount: number = 15;
  @State collectCount: number = 1155;
  @State isFollowing: boolean = false;

  // 顶部 Tab: 0 = 动态, 1 = 数据
  @State topTabIndex: number = 0;
  // 动态 Tab 下的二级切页: 0 = 动态, 1 = 投稿
  @State dynamicSubTab: number = 0;
  // 数据 Tab 下二级筛选: 0 = 心愿单, 1 = 拥有游戏, 2 = 完美通关, 3 = TA的评分
  @State dataFilterTab: number = 1;
  @State searchOwnedGameQuery: string = '';

  onBackClick?: () => void;

  @State postsList: UserPostItem[] = [
    {
      id: 'post_1',
      authorName: '小鼠鱼',
      authorAvatar: $r('app.media.mita'),
      authorLevel: 'Lv.12',
      content: '好玩，不过有点手残，弹反不会，闪避只会乱躲，遇到那个限时关就会手忙脚乱然后死掉。后面武器多了以后体验大幅上升。...',
      gameTitle: '卡片魔王：只剩个头！',
      gameCover: $r('app.media.storm'),
      gamePrice: '¥44 券后价',
      gameScore: '9.4',
      gameLikes: '4.4万',
      ratingStars: 5,
      tagLabel: '卡片魔王：只剩个头！ · 游戏评价',
      commentsCount: 0,
      likesCount: 0
    },
    {
      id: 'post_2',
      authorName: '小鼠鱼',
      authorAvatar: $r('app.media.mita'),
      authorLevel: 'Lv.12',
      postTitle: '一般把什么道具丢给加盟商卖啊？',
      content: '加盟商卖东西倍率是多少？尽量给高级的还是低级道具？前期多招几个加盟商有好处吗？',
      tagLabel: '哥布林维克：窃贼大亨',
      dateStr: '05-08',
      commentsCount: 12,
      likesCount: 0
    },
    {
      id: 'post_3',
      authorName: '小鼠鱼',
      authorAvatar: $r('app.media.mita'),
      authorLevel: 'Lv.12',
      postTitle: '游戏玩到12天的才发现，抬价成功后可以加商品',
      content: '之前3倍的时候没追加商品亏麻了，还有几天没卖好爆库存了，后面有些1.4倍 2倍我都卖了，现在就是后悔非常后悔...',
      tagLabel: '黑盒玩家交流专区',
      dateStr: '05-02',
      commentsCount: 3,
      likesCount: 5
    }
  ];

  @State ownedGamesList: UserOwnedGame[] = [
    {
      id: 'divinity2',
      title: '神界：原罪2',
      totalHours: '79.6h',
      recentHours: '37h',
      achievements: '0 / 97',
      coverImg: $r('app.media.granblue_relink'),
      scoreRank: '3901'
    },
    {
      id: 'gloomhaven',
      title: '幽港迷城',
      totalHours: '199.3h',
      recentHours: '1.2h',
      achievements: '43 / 61',
      coverImg: $r('app.media.storm'),
      progressPercent: 70
    },
    {
      id: 'sunderfolk',
      title: '破碎族裔',
      totalHours: '27.5h',
      recentHours: '1.1h',
      achievements: '11 / 14',
      coverImg: $r('app.media.resident'),
      progressPercent: 78
    },
    {
      id: 'wukong',
      title: '黑神话：悟空',
      totalHours: '105.2h',
      recentHours: '8.4h',
      achievements: '81 / 81',
      coverImg: $r('app.media.wukong'),
      progressPercent: 100
    },
    {
      id: 'palworld',
      title: 'Palworld / 幻兽帕鲁',
      totalHours: '142.0h',
      recentHours: '0.0h',
      achievements: '28 / 32',
      coverImg: $r('app.media.Palworld'),
      progressPercent: 88
    }
  ];

  aboutToAppear(): void {
    try {
      const params = this.getUIContext().getRouter().getParams() as Record<string, Object>;
      if (params) {
        if (params['username']) {
          this.username = params['username'] as string;
        }
        if (params['userLevel']) {
          this.userLevel = params['userLevel'] as string;
        }
      }
    } catch (e) {
    }
  }

  private getFilteredOwnedGames(): UserOwnedGame[] {
    if (!this.searchOwnedGameQuery || this.searchOwnedGameQuery.trim() === '') {
      return this.ownedGamesList;
    }
    const q = this.searchOwnedGameQuery.trim().toLowerCase();
    return this.ownedGamesList.filter(g => g.title.toLowerCase().includes(q));
  }

  // 1. 顶部 Header 栏（Back / 动态 / 数据 / 搜索 / 更多）
  @Builder
  HeaderBarBuilder() {
    Row() {
      Text('❮')
        .fontSize(20)
        .fontColor('#1A1A1A')
        .padding({ left: 14, right: 14, top: 10, bottom: 10 })
        .onClick(() => {
          if (this.onBackClick) {
            this.onBackClick();
          } else {
            try {
              router.back();
            } catch (e) {
            }
          }
        })

      Blank()

      Row() {
        Column() {
          Text('动态')
            .fontSize(17)
            .fontWeight(this.topTabIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.topTabIndex === 0 ? '#1A1A1A' : '#999999')
          Row()
            .width(this.topTabIndex === 0 ? 24 : 0)
            .height(3)
            .borderRadius(2)
            .backgroundColor('#1A1A1A')
            .margin({ top: 4 })
        }
        .onClick(() => (this.topTabIndex = 0))

        Column() {
          Text('数据')
            .fontSize(17)
            .fontWeight(this.topTabIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.topTabIndex === 1 ? '#1A1A1A' : '#999999')
          Row()
            .width(this.topTabIndex === 1 ? 24 : 0)
            .height(3)
            .borderRadius(2)
            .backgroundColor('#1A1A1A')
            .margin({ top: 4 })
        }
        .margin({ left: 32 })
        .onClick(() => (this.topTabIndex = 1))
      }

      Blank()

      Row() {
        Text('🔍')
          .fontSize(18)
          .fontColor('#1A1A1A')
          .margin({ right: 14 })
          .onClick(() => {
            promptAction.showToast({ message: '搜索用户动态' });
          })

        Text('•••')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .padding({ left: 6, right: 14 })
          .onClick(() => {
            promptAction.showToast({ message: '更多操作' });
          })
      }
    }
    .width('100%')
    .height(48)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // 2. 用户基础名片（头像 / 昵称 / 等级 / 签名 / 粉丝数）
  @Builder
  UserCardHeaderBuilder() {
    Column() {
      Row() {
        Image($r('app.media.mita'))
          .width(64)
          .height(64)
          .borderRadius(32)
          .objectFit(ImageFit.Cover)

        Column() {
          Row() {
            Text(this.username)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')

            Text(this.userLevel)
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .backgroundColor('#AF52DE')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
              .margin({ left: 8 })
          }

          Text(this.bio)
            .fontSize(12)
            .fontColor('#888888')
            .margin({ top: 6 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 16 })
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 })

      // 统计指标：关注 / 粉丝 / 获赞与收藏
      Row() {
        Column() {
          Text(`${this.followingCount}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text('关注')
            .fontSize(11)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .onClick(() => promptAction.showToast({ message: `查看 ${this.username} 的关注列表` }))

        Column() {
          Text(`${this.followersCount + (this.isFollowing ? 1 : 0)}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text('粉丝')
            .fontSize(11)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .onClick(() => promptAction.showToast({ message: `查看 ${this.username} 的粉丝列表` }))

        Column() {
          Text(`${this.collectCount}`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text('获赞与收藏')
            .fontSize(11)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: 16, bottom: 12 })
    }
    .width('100%')
    .backgroundColor(Color.White)
  }

  // 3. 动态列表 Tab 内容 (对应截图 1)
  @Builder
  DynamicTabContentBuilder() {
    Column() {
      // 动态 / 投稿 二级切换栏
      Row() {
        Text('动态')
          .fontSize(14)
          .fontWeight(this.dynamicSubTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.dynamicSubTab === 0 ? '#1A1A1A' : '#888888')
          .onClick(() => (this.dynamicSubTab = 0))

        Text('投稿')
          .fontSize(14)
          .fontWeight(this.dynamicSubTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.dynamicSubTab === 1 ? '#1A1A1A' : '#888888')
          .margin({ left: 48 })
          .onClick(() => (this.dynamicSubTab = 1))
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      if (this.dynamicSubTab === 0) {
        Column({ space: 12 }) {
          ForEach(this.postsList, (post: UserPostItem) => {
            Column() {
              // 帖子 Header
              Row() {
                Image(post.authorAvatar)
                  .width(32)
                  .height(32)
                  .borderRadius(16)
                  .objectFit(ImageFit.Cover)

                Text(post.authorName)
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .margin({ left: 8 })

                Text(post.authorLevel)
                  .fontSize(9)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .backgroundColor('#AF52DE')
                  .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                  .borderRadius(3)
                  .margin({ left: 6 })
              }
              .width('100%')

              // 游戏评价推荐卡片 (若有)
              if (post.gameTitle) {
                Row() {
                  Image(post.gameCover)
                    .width(110)
                    .height(66)
                    .borderRadius(6)
                    .objectFit(ImageFit.Cover)

                  Column() {
                    Row() {
                      Text(post.gameTitle)
                        .fontSize(13)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#1A1A1A')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .layoutWeight(1)

                      if (post.gameScore) {
                        Text(`⯅ ${post.gameScore}`)
                          .fontSize(10)
                          .fontWeight(FontWeight.Bold)
                          .fontColor(Color.White)
                          .backgroundColor('#FF9500')
                          .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                          .borderRadius(3)
                          .margin({ left: 4 })
                      }
                    }
                    .width('100%')

                    Row() {
                      Text(post.gamePrice)
                        .fontSize(11)
                        .fontColor('#FF3B30')
                        .fontWeight(FontWeight.Bold)

                      Blank()

                      Text(`❤️ ${post.gameLikes}`)
                        .fontSize(10)
                        .fontColor('#999999')
                    }
                    .width('100%')
                    .margin({ top: 14 })
                  }
                  .margin({ left: 10 })
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .padding(8)
                .backgroundColor('#F7F8FA')
                .borderRadius(8)
                .margin({ top: 10 })
                .onClick(() => {
                  router.pushUrl({
                    url: GameLibraryRoutes.GAME_DETAIL,
                    params: { id: 'storm' }
                  });
                })
              }

              // 帖子标题
              if (post.postTitle) {
                Text(post.postTitle)
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .margin({ top: 10 })
                  .width('100%')
              }

              // 帖子正文
              Text(post.content)
                .fontSize(13)
                .fontColor('#333333')
                .lineHeight(20)
                .margin({ top: 8 })
                .width('100%')

              // 底部 Tag 与点赞评论栏
              Row() {
                if (post.ratingStars) {
                  Row() {
                    ForEach([1, 2, 3, 4, 5], (star: number) => {
                      Text('★')
                        .fontSize(12)
                        .fontColor('#FF9500')
                    })
                  }
                  .margin({ right: 6 })
                }

                Row() {
                  Text('🎮 ')
                    .fontSize(10)
                  Text(post.tagLabel)
                    .fontSize(11)
                    .fontColor('#666666')
                  if (post.dateStr) {
                    Text(`  ${post.dateStr}`)
                      .fontSize(11)
                      .fontColor('#999999')
                  }
                }
                .layoutWeight(1)

                Row({ space: 16 }) {
                  Row() {
                    Text('💬 ')
                      .fontSize(12)
                    Text(`${post.commentsCount}`)
                      .fontSize(12)
                      .fontColor('#999999')
                  }

                  Row() {
                    Text('👍 ')
                      .fontSize(12)
                    Text(`${post.likesCount}`)
                      .fontSize(12)
                      .fontColor('#999999')
                  }
                  .onClick(() => {
                    post.likesCount += 1;
                    promptAction.showToast({ message: '点赞成功！' });
                  })
                }
              }
              .width('100%')
              .margin({ top: 12 })
            }
            .width('100%')
            .padding(14)
            .backgroundColor(Color.White)
            .borderRadius(12)
          })
        }
        .padding({ left: 12, right: 12, top: 10, bottom: 20 })
      } else {
        Column() {
          Text('暂无公开投稿')
            .fontSize(13)
            .fontColor('#999999')
            .margin({ top: 40 })
        }
        .width('100%')
        .height(200)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
  }

  // 4. 数据 Tab 内容 (对应截图 2 - Steam 数据、展柜、游戏列表)
  @Builder
  DataTabContentBuilder() {
    Column() {
      // Steam / Epic 核心数据黑色卡片
      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          Row() {
            Text('♨')
              .fontSize(18)
              .fontColor(Color.White)
              .margin({ right: 6 })
            Text('EPIC')
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor('#AAAAAA')
              .border({ width: 1, color: '#AAAAAA' })
              .padding({ left: 4, right: 4 })
              .borderRadius(2)

            Blank()

            Text('›')
              .fontSize(18)
              .fontColor('#AAAAAA')
          }
          .width('100%')

          Row() {
            Image($r('app.media.mita'))
              .width(42)
              .height(42)
              .borderRadius(6)
              .objectFit(ImageFit.Cover)

            Column() {
              Row() {
                Text('匿名玩家')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                Text('17')
                  .fontSize(10)
                  .fontColor(Color.White)
                  .border({ width: 1, color: '#FFD700' })
                  .padding({ left: 4, right: 4 })
                  .borderRadius(8)
                  .margin({ left: 6 })
                Text('离线')
                  .fontSize(10)
                  .fontColor('#888888')
                  .margin({ left: 6 })
              }

              Row() {
                Text('9812')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                Text(' 账号价值 ¥  ')
                  .fontSize(10)
                  .fontColor('#AAAAAA')

                Text('3569')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                Text(' 游戏时长 h  ')
                  .fontSize(10)
                  .fontColor('#AAAAAA')

                Text('153')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                Text(' 游戏数量')
                  .fontSize(10)
                  .fontColor('#AAAAAA')
              }
              .margin({ top: 8 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 10 })
            .layoutWeight(1)
          }
          .margin({ top: 10 })

          // 徽章图标一览
          Row({ space: 6 }) {
            ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], (idx: number) => {
              Text('🏆')
                .fontSize(14)
                .backgroundColor('rgba(255,255,255,0.1)')
                .padding(4)
                .borderRadius(4)
            })
          }
          .margin({ top: 12 })
        }
        .width('100%')
        .padding(14)
        .backgroundColor('#16181C')
        .borderRadius(12)
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })

      // 三大精选游戏成就展柜卡片
      Row({ space: 8 }) {
        // 展柜卡片 1
        Column() {
          Row() {
            Image($r('app.media.mita'))
              .width(18)
              .height(18)
              .borderRadius(9)
            Text(this.username)
              .fontSize(10)
              .fontColor('#666666')
              .margin({ left: 4 })
          }
          .width('100%')

          Text('64')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ top: 8 })
          Text('胜利')
            .fontSize(10)
            .fontColor('#999999')

          Text('🗡️')
            .fontSize(32)
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .padding(10)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .alignItems(HorizontalAlign.Start)

        // 展柜卡片 2
        Column() {
          Row() {
            Image($r('app.media.mita'))
              .width(18)
              .height(18)
              .borderRadius(9)
            Text(this.username)
              .fontSize(10)
              .fontColor('#666666')
              .margin({ left: 4 })
          }
          .width('100%')

          Text('96.0')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ top: 8 })
          Text('游戏完成度')
            .fontSize(10)
            .fontColor('#999999')

          Text('⚔️')
            .fontSize(32)
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .padding(10)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .alignItems(HorizontalAlign.Start)

        // 展柜卡片 3
        Column() {
          Row() {
            Image($r('app.media.mita'))
              .width(18)
              .height(18)
              .borderRadius(9)
            Text(this.username)
              .fontSize(10)
              .fontColor('#666666')
              .margin({ left: 4 })
          }
          .width('100%')

          Text('30.0')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ top: 8 })
          Text('游戏完成度')
            .fontSize(10)
            .fontColor('#999999')

          Text('🕷️')
            .fontSize(32)
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .padding(10)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 12, right: 12, bottom: 10 })

      // 四维二级分类筛选: 心愿单 | 拥有游戏 | 完美通关 | TA的评分
      Row() {
        Text('心愿单')
          .fontSize(13)
          .fontWeight(this.dataFilterTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.dataFilterTab === 0 ? '#1A1A1A' : '#888888')
          .backgroundColor(this.dataFilterTab === 0 ? '#EFEFEF' : 'transparent')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(14)
          .onClick(() => (this.dataFilterTab = 0))

        Row() {
          Text('♨ ')
            .fontSize(11)
            .fontColor(this.dataFilterTab === 1 ? '#1A1A1A' : '#888888')
          Text('拥有游戏')
            .fontSize(13)
            .fontWeight(this.dataFilterTab === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.dataFilterTab === 1 ? '#1A1A1A' : '#888888')
        }
        .backgroundColor(this.dataFilterTab === 1 ? '#EFEFEF' : 'transparent')
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .borderRadius(14)
        .margin({ left: 6 })
        .onClick(() => (this.dataFilterTab = 1))

        Text('完美通关')
          .fontSize(13)
          .fontWeight(this.dataFilterTab === 2 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.dataFilterTab === 2 ? '#1A1A1A' : '#888888')
          .backgroundColor(this.dataFilterTab === 2 ? '#EFEFEF' : 'transparent')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(14)
          .margin({ left: 6 })
          .onClick(() => (this.dataFilterTab = 2))

        Text('TA的评分')
          .fontSize(13)
          .fontWeight(this.dataFilterTab === 3 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.dataFilterTab === 3 ? '#1A1A1A' : '#888888')
          .backgroundColor(this.dataFilterTab === 3 ? '#EFEFEF' : 'transparent')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(14)
          .margin({ left: 6 })
          .onClick(() => (this.dataFilterTab = 3))
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 6, bottom: 8 })

      // 搜索与排序下拉子工具栏
      Row() {
        Row() {
          Text('🔍 ')
            .fontSize(12)
            .fontColor('#999999')
          TextInput({ text: this.searchOwnedGameQuery, placeholder: '搜索' })
            .placeholderColor('#B0B0B0')
            .fontSize(12)
            .height(30)
            .backgroundColor(Color.Transparent)
            .onChange((v: string) => (this.searchOwnedGameQuery = v))
        }
        .layoutWeight(1)
        .height(30)
        .backgroundColor('#F2F3F5')
        .borderRadius(15)
        .padding({ left: 10, right: 10 })

        Text('总时长 ▾')
          .fontSize(11)
          .fontColor('#666666')
          .margin({ left: 10 })
          .onClick(() => promptAction.showToast({ message: '按总时长排序' }))

        Text('两周时长 ▾')
          .fontSize(11)
          .fontColor('#666666')
          .margin({ left: 10 })
          .onClick(() => promptAction.showToast({ message: '按近两周时长排序' }))

        Text('成就 ▾')
          .fontSize(11)
          .fontColor('#666666')
          .margin({ left: 10 })
          .onClick(() => promptAction.showToast({ message: '按成就解锁进度排序' }))
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 4, bottom: 8 })

      // 拥有游戏列表
      Column({ space: 10 }) {
        ForEach(this.getFilteredOwnedGames(), (game: UserOwnedGame) => {
          Row() {
            Image(game.coverImg)
              .width(90)
              .height(54)
              .borderRadius(6)
              .objectFit(ImageFit.Cover)

            Column() {
              Row() {
                Text(game.title)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Blank()
                if (game.scoreRank) {
                  Text(`● ${game.scoreRank}`)
                    .fontSize(10)
                    .fontColor('#2BC48A')
                }
              }
              .width('100%')

              Row() {
                Text(game.totalHours)
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Blank()
                Text(game.recentHours)
                  .fontSize(11)
                  .fontColor('#888888')
                Text(`  ${game.achievements}`)
                  .fontSize(11)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .margin({ left: 12 })
              }
              .width('100%')
              .margin({ top: 10 })

              // 进度条
              Row()
                .width('100%')
                .height(3)
                .backgroundColor(game.progressPercent && game.progressPercent >= 100 ? '#FF9500' : '#2BC48A')
                .borderRadius(2)
                .margin({ top: 6 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 12 })
            .layoutWeight(1)
          }
          .width('100%')
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .onClick(() => {
            router.pushUrl({
              url: GameLibraryRoutes.GAME_DETAIL,
              params: { id: game.id }
            });
          })
        })
      }
      .padding({ left: 12, right: 12, top: 4, bottom: 20 })
    }
    .width('100%')
  }

  // 5. 底部固定按钮栏 (私信 / + 关注)
  @Builder
  BottomActionBarBuilder() {
    Row({ space: 12 }) {
      Button() {
        Row() {
          Text('💬 ')
            .fontSize(14)
          Text('私信')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
        }
      }
      .type(ButtonType.Normal)
      .layoutWeight(1)
      .height(44)
      .backgroundColor('#F0F0F2')
      .borderRadius(22)
      .onClick(() => {
        promptAction.showToast({ message: `打开与 ${this.username} 的私信聊天窗口` });
      })

      Button() {
        Row() {
          Text(this.isFollowing ? '✓ ' : '＋ ')
            .fontSize(14)
            .fontColor(this.isFollowing ? '#1A1A1A' : Color.White)
          Text(this.isFollowing ? '已关注' : '关注')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isFollowing ? '#1A1A1A' : Color.White)
        }
      }
      .type(ButtonType.Normal)
      .layoutWeight(2)
      .height(44)
      .backgroundColor(this.isFollowing ? '#E0E0E0' : '#1A1A1A')
      .borderRadius(22)
      .onClick(() => {
        this.isFollowing = !this.isFollowing;
        promptAction.showToast({
          message: this.isFollowing ? `已成功关注 ${this.username}` : `已取消关注 ${this.username}`
        });
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 12 })
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: '#F0F0F0' })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        this.HeaderBarBuilder()

        Scroll() {
          Column() {
            this.UserCardHeaderBuilder()

            if (this.topTabIndex === 0) {
              this.DynamicTabContentBuilder()
            } else {
              this.DataTabContentBuilder()
            }
          }
          .width('100%')
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ bottom: 64 })
      .backgroundColor('#F7F8FA')

      this.BottomActionBarBuilder()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
