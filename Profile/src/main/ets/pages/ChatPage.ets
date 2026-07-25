import { router } from '@kit.ArkUI';
import {
  ChatMessage,
  MessageSession,
  getChatMessages,
  getMessageSessionById,
} from '../model/ProfileModel';

/**
 * 消息聊天页（由 entry 路由壳挂载）
 * 入参：router params { id: string }
 * 支持私信会话与系统/互动等通知流的统一气泡布局。
 */
@Component
export struct ChatPage {
  @State session: MessageSession | undefined = undefined;
  @State messages: ChatMessage[] = [];
  @State draft: string = '';
  private listScroller: Scroller = new Scroller();
  private inputController: TextInputController = new TextInputController();

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    this.session = getMessageSessionById(id);
    this.messages = getChatMessages(id);
  }

  private isChatSession(): boolean {
    return this.session !== undefined && this.session.type === 'chat';
  }

  /** 点击消息区 / 空白处收起输入法 */
  private dismissKeyboard(): void {
    this.inputController.stopEditing();
  }

  private sendDraft(): void {
    const text = this.draft.trim();
    if (text.length === 0) {
      return;
    }
    const next: ChatMessage = {
      id: `local_${Date.now()}`,
      isSelf: true,
      content: text,
      time: '刚刚',
    };
    const list: ChatMessage[] = [];
    for (let i = 0; i < this.messages.length; i++) {
      list.push(this.messages[i]);
    }
    list.push(next);
    this.messages = list;
    this.draft = '';
    this.dismissKeyboard();
    // 滚到最新一条
    if (list.length > 0) {
      this.listScroller.scrollToIndex(list.length - 1);
    }
  }

  @Builder
  NavBarBuilder() {
    Row() {
      Text('‹')
        .fontSize(26)
        .fontWeight(FontWeight.Lighter)
        .fontColor('#1A1A1A')
        .width(40)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => router.back())

      Text(this.session ? this.session.title : '聊天')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .letterSpacing(0.5)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 右侧占位，保持标题居中
      Row().width(40).height(40)
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 12 })
    .backgroundColor(Color.White)
  }

  @Builder
  TimeDividerBuilder(time: string) {
    Text(time)
      .fontSize(11)
      .fontColor('#B0B0B0')
      .width('100%')
      .textAlign(TextAlign.Center)
      .margin({ top: 16, bottom: 10 })
  }

  @Builder
  AvatarBuilder(char: string, color: string) {
    Column() {
      Text(char)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
    }
    .width(36)
    .height(36)
    .borderRadius(18)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(color)
  }

  @Builder
  BubbleBuilder(msg: ChatMessage) {
    if (msg.isSelf) {
      Row() {
        Blank()
        Text(msg.content)
          .fontSize(14)
          .fontColor('#1A1A1A')
          .lineHeight(20)
          .padding({ left: 12, right: 12, top: 10, bottom: 10 })
          .constraintSize({ maxWidth: '72%' })
          .borderRadius({
            topLeft: 14,
            topRight: 4,
            bottomLeft: 14,
            bottomRight: 14,
          })
          .backgroundColor('#C8F0DC')
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 12 })
    } else {
      Row() {
        this.AvatarBuilder(
          this.session ? this.session.avatarChar : '盒',
          this.session ? this.session.avatarColor : '#2BC48A'
        )

        Text(msg.content)
          .fontSize(14)
          .fontColor('#1A1A1A')
          .lineHeight(20)
          .padding({ left: 12, right: 12, top: 10, bottom: 10 })
          .constraintSize({ maxWidth: '68%' })
          .borderRadius({
            topLeft: 4,
            topRight: 14,
            bottomLeft: 14,
            bottomRight: 14,
          })
          .backgroundColor(Color.White)
          .margin({ left: 10 })

        Blank()
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 12 })
    }
  }

  @Builder
  ComposerBuilder() {
    Row() {
      TextInput({ text: this.draft, placeholder: '说点什么…', controller: this.inputController })
        .layoutWeight(1)
        .height(40)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .placeholderColor('#B0B0B0')
        .backgroundColor('#F5F5F7')
        .borderRadius(20)
        .padding({ left: 14, right: 14 })
        .onChange((v: string) => {
          this.draft = v;
        })
        .onSubmit(() => this.sendDraft())

      Text('发送')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.draft.trim().length > 0 ? '#2BC48A' : '#B0B0B0')
        .height(40)
        .padding({ left: 14, right: 4 })
        .textAlign(TextAlign.Center)
        .onClick(() => this.sendDraft())
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
  }

  @Builder
  EmptyBuilder() {
    Column() {
      Text('暂无消息')
        .fontSize(14)
        .fontColor('#999999')
      Text('稍后再来看看')
        .fontSize(12)
        .fontColor('#B0B0B0')
        .margin({ top: 8 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => this.dismissKeyboard())
  }

  build() {
    Column() {
      Row().width('100%').height(36).backgroundColor(Color.White)
      this.NavBarBuilder()

      Divider().color('#F0F0F0').strokeWidth(0.5)

      if (this.messages.length === 0) {
        this.EmptyBuilder()
      } else {
        List({ scroller: this.listScroller }) {
          ForEach(this.messages, (msg: ChatMessage) => {
            ListItem() {
              Column() {
                if (msg.showTime) {
                  this.TimeDividerBuilder(msg.time)
                }
                this.BubbleBuilder(msg)
              }
              .width('100%')
            }
          }, (msg: ChatMessage) => msg.id)

          ListItem() {
            Row().height(12)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        // 点击消息区空白 / 气泡收起输入法；滚动时同样收起
        .onClick(() => this.dismissKeyboard())
        .onScrollStart(() => this.dismissKeyboard())
      }

      if (this.isChatSession()) {
        Divider().color('#F0F0F0').strokeWidth(0.5)
        this.ComposerBuilder()
      } else {
        // 系统类会话：底部轻提示
        Text('系统消息不可回复')
          .fontSize(12)
          .fontColor('#B0B0B0')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 12, bottom: 16 })
          .backgroundColor('#F7F7F8')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F8')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
