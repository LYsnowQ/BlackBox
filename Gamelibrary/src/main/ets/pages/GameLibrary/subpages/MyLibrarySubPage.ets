import { GameItem, gameList, mockSteamAccount, WishlistManager } from '../../../model/GameLibrary/GameLibraryModel';
import { GameLibraryRoutes } from '../../../router/GameLibraryRoutes';
import { GameCard } from '../../../components/GameCard';
import { UserProfilePage } from './UserProfilePage';
import router from '@ohos.router';

@Component
export struct MyLibrarySubPage {
  @State activeTab: number = 0; // 0: 愿望单, 1: 最近游玩, 2: 全部游戏
  @State wishlistIds: string[] = WishlistManager.getWishlist();
  @State showUserProfile: boolean = false;

  private getDisplayGames(): GameItem[] {
    if (this.activeTab === 0) {
      return gameList.filter(g => this.wishlistIds.includes(g.id));
    } else if (this.activeTab === 1) {
      return gameList.slice(0, 3);
    } else {
      return gameList;
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        // 1. Steam / Epic 账号名片
        Column() {
          Row() {
            Image(mockSteamAccount.avatar)
              .width(50)
              .height(50)
              .borderRadius(25)
              .objectFit(ImageFit.Cover)
              .onClick(() => {
                this.showUserProfile = true;
              })

            Column() {
              Row() {
                Text(mockSteamAccount.username)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .onClick(() => {
                    this.showUserProfile = true;
                  })
                Text('已绑定 Steam')
                  .fontSize(10)
                  .fontColor('#4CAF50')
                  .backgroundColor('#1B5E20')
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  .borderRadius(4)
                  .margin({ left: 8 })
              }

              Text(`Steam ID: ${mockSteamAccount.steamId}`)
                .fontSize(11)
                .fontColor('#B0B0B0')
                .margin({ top: 4 })
            }
            .margin({ left: 12 })
            .alignItems(HorizontalAlign.Start)

            Blank()
          }
          .width('100%')

          // 统计指标
          Row() {
            Column() {
              Text(`${mockSteamAccount.totalGames}`)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('拥有游戏')
                .fontSize(11)
                .fontColor('#B0B0B0')
                .margin({ top: 2 })
            }
            .layoutWeight(1)

            Column() {
              Text(`${mockSteamAccount.recentHours}h`)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFD54F')
              Text('近2周游玩')
                .fontSize(11)
                .fontColor('#B0B0B0')
                .margin({ top: 2 })
            }
            .layoutWeight(1)

            Column() {
              Text(`${mockSteamAccount.totalHours}h`)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('总游戏时长')
                .fontSize(11)
                .fontColor('#B0B0B0')
                .margin({ top: 2 })
            }
            .layoutWeight(1)

            Column() {
              Text(`${Math.round((mockSteamAccount.unlockedAchievements / mockSteamAccount.totalAchievements) * 100)}%`)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#4FC3F7')
              Text('成就完成率')
                .fontSize(11)
                .fontColor('#B0B0B0')
                .margin({ top: 2 })
            }
            .layoutWeight(1)
          }
          .width('100%')
          .margin({ top: 16 })
          .padding({ top: 12 })
          .border({ width: { top: 1 }, color: '#333333' })
        }
        .width('92%')
        .padding(16)
        .margin({ top: 12, bottom: 12 })
        .backgroundColor('#1E232A')
        .borderRadius(12)

        // 2. Tab 切换栏
        Row() {
          Text(`愿望单 (${this.wishlistIds.length})`)
            .fontSize(14)
            .fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.activeTab === 0 ? '#1A1A1A' : '#888888')
            .padding({ bottom: 6 })
            .border({ width: { bottom: this.activeTab === 0 ? 2 : 0 }, color: '#1A1A1A' })
            .margin({ right: 20 })
            .onClick(() => {
              this.activeTab = 0;
              this.wishlistIds = WishlistManager.getWishlist();
            })

          Text('最近游玩')
            .fontSize(14)
            .fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.activeTab === 1 ? '#1A1A1A' : '#888888')
            .padding({ bottom: 6 })
            .border({ width: { bottom: this.activeTab === 1 ? 2 : 0 }, color: '#1A1A1A' })
            .margin({ right: 20 })
            .onClick(() => {
              this.activeTab = 1;
            })

          Text('全部库藏')
            .fontSize(14)
            .fontWeight(this.activeTab === 2 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.activeTab === 2 ? '#1A1A1A' : '#888888')
            .padding({ bottom: 6 })
            .border({ width: { bottom: this.activeTab === 2 ? 2 : 0 }, color: '#1A1A1A' })
            .onClick(() => {
              this.activeTab = 2;
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 4, bottom: 8 })

        // 3. 游戏列表
        Scroll() {
          Column() {
            ForEach(this.getDisplayGames(), (game: GameItem) => {
              Column() {
                GameCard({
                  game: game,
                  onCardClick: () => {
                    router.pushUrl({
                      url: GameLibraryRoutes.GAME_DETAIL,
                      params: { id: game.id, gameId: game.id }
                    });
                  }
                })
              }
              .padding({ left: 12, right: 12, bottom: 8 })
            })

            if (this.getDisplayGames().length === 0) {
              Column() {
                Text('暂无相关游戏')
                  .fontSize(14)
                  .fontColor('#999999')
                  .margin({ top: 40 })
              }
              .width('100%')
              .height(150)
              .justifyContent(FlexAlign.Center)
            }
          }
        }
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F8F8F8')

      if (this.showUserProfile) {
        UserProfilePage({ onBackClick: () => { this.showUserProfile = false; } })
      }
    }
    .width('100%')
    .height('100%')
  }
}
