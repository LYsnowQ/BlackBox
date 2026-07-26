import { GameItem, gameList, getGameById } from '../../model/GameLibrary/GameLibraryModel';
import { GameLibraryRoutes } from '../../router/GameLibraryRoutes';

interface QuickNav {
  title: string;
  desc: string;
  icon: string;
  showDot?: boolean;
}

interface BannerSlide {
  title: string;
  subtitle: string;
  colors: [string, string];
  bgImg?: ResourceStr;
}

interface HotSellerItem {
  id: string;
  title: string;
  price: number;
  originalPrice?: number;
  discountPercent?: number;
  couponLabel?: string;
  coverImg: ResourceStr;
}
interface RecommendPageItem {
  id: string;
  title: string;
  price: number;
  originalPrice?: number;
  discountPercent?: number;
  couponLabel?: string;
  lowestLabel?: string;
  remainDays?: string;
  tags: string[];
  coverImg?: ResourceStr;
  gradientColors?: [string, string];
}

export interface StoreProductItem {
  id: string;
  title: string;
  category: number; // 0: 游戏, 1: 游戏道具, 2: 游戏周边
  price: number;
  originalPrice?: number;
  sales: number;
  discountPercent?: number;
  couponTag?: string;
  publisher: string;
  platform: string;
  coverImg: ResourceStr;
  tags: string[];
  stock: number;
  description: string;
}

export interface CartItem {
  product: StoreProductItem;
  quantity: number;
  selected: boolean;
}

export interface OrderItem {
  id: string;
  productTitle: string;
  productImg: ResourceStr;
  price: number;
  quantity: number;
  status: string; // '待激活' | '已完成' | '退款/售后'
  cdkey: string;
  createTime: string;
}

export interface CouponItem {
  id: string;
  title: string;
  discountDesc: string;
  minSpend: number;
  expireDate: string;
  claimed: boolean;
}

export interface CustomerFaq {
  q: string;
  a: string;
}

export interface PublisherItem {
  name: string;
  logoIcon: string;
  desc: string;
  gameCount: number;
}

@Component
export struct RecommendTab {
  @State bannerIndex: number = 0;
  @Link isForYouPageOpen: boolean;
  @Link activeNavPage: string; // '' | '黑盒商城' | '喜加一' | '赛事中心' | '黑盒语音'
  @State storeSegmentIndex: number = 0; // 0: 游戏, 1: 游戏道具, 2: 游戏周边
  @State storeSortIndex: number = 0; // 0: 销量, 1: 最高折扣, 2: 价格升序, 3: 价格降序, 4: 最新上架

  // 黑盒商城交互状态
  @State activeStoreModal: string = ''; // '' | 'search' | 'customer_service' | 'vip' | 'wallet' | 'orders' | 'coupons' | 'cart' | 'publishers' | 'product_detail'
  @State selectedStoreProduct: StoreProductItem | null = null;
  @State storeSearchQuery: string = '';
  @State storeSearchHistory: string[] = ['幻兽帕鲁', '绝地求生', '黑神话悟空', 'CS2'];
  @State selectedPublisher: string = '';
  @State orderTabFilter: string = '全部'; // '全部' | '待激活' | '已完成' | '退款/售后'
  @State walletBalance: number = 128.00;
  @State hCoinBalance: number = 52.50;
  @State rechargeAmount: number = 50;
  @State vipLevel: string = '青铜会员';
  @State vipGiftClaimed: boolean = false;
  @State storeToastMsg: string = '';
  @State showStoreToast: boolean = false;
  @State selectedPaymentMethod: string = '微信支付'; // '微信支付' | '支付宝' | 'H币支付'

  @State cartItems: CartItem[] = [
    {
      product: {
        id: 'palworld',
        title: 'Palworld / 幻兽帕鲁-标准版',
        category: 0,
        price: 103,
        originalPrice: 108,
        sales: 9820,
        discountPercent: 5,
        couponTag: '领券95折',
        publisher: 'Pocketpair',
        platform: 'Steam',
        coverImg: $r('app.media.Palworld'),
        tags: ['开放世界', '抓宠', '生存'],
        stock: 99,
        description: '在广阔的世界中收集神奇的生物“帕鲁”，派它们进行战斗、建造、做农活或者在工厂劳作！'
      },
      quantity: 1,
      selected: true
    }
  ];

  @State storeOrders: OrderItem[] = [
    {
      id: 'HB202607248810',
      productTitle: 'RESIDENT EVIL 4 生化4重制版',
      productImg: $r('app.media.resident'),
      price: 148,
      quantity: 1,
      status: '待激活',
      cdkey: 'RE4R-882K-HB99-2026',
      createTime: '2026-07-24 09:12'
    },
    {
      id: 'HB202607231204',
      productTitle: '绝地求生 10000+1200 G-coin',
      productImg: $r('app.media.pubg_gcoin'),
      price: 631,
      quantity: 1,
      status: '已完成',
      cdkey: 'PUBG-G10K-9921-ABCD',
      createTime: '2026-07-23 18:45'
    }
  ];

  @State storeCoupons: CouponItem[] = [
    { id: 'c1', title: '95折通用优惠券', discountDesc: '全场游戏可用 · 最高减¥20', minSpend: 50, expireDate: '2026-08-01', claimed: true },
    { id: 'c2', title: '满¥100减¥15大额券', discountDesc: '限游戏/道具品类', minSpend: 100, expireDate: '2026-07-31', claimed: false },
    { id: 'c3', title: '新用户首单立减¥5', discountDesc: '无门槛直减', minSpend: 0, expireDate: '2026-12-31', claimed: false },
    { id: 'c4', title: '黑盒会员专属¥10券', discountDesc: '满¥80可用', minSpend: 80, expireDate: '2026-08-15', claimed: false }
  ];

  private customerFaqs: CustomerFaq[] = [
    { q: '如何激活 Steam CDKEY？', a: '在 Steam 客户端左下角点击「添加游戏」->「在 Steam 上激活产品」，输入购买获得的 15 位兑换码即可完成激活！' },
    { q: '付款后没有收到激活码怎么办？', a: '请前往「我的订单」查看或刷新。若超过 5 分钟未发货，系统将全额退款并补偿 10 元无门槛优惠券！' },
    { q: '申请退款要求与流程是什么？', a: '未激活且未提取的 CDKEY 支持 7 天无理由退款；涉及虚拟代币道具如 G-coin，一经发送概不支持退换。' },
    { q: '人工客服服务时间与联系方式', a: '黑盒人工客服每日 09:00 - 24:00 在线为您服务，当前排队人数：0 人。' }
  ];

  private storePublishers: PublisherItem[] = [
    { name: 'Pocketpair', logoIcon: '🦙', desc: '代表作：《幻兽帕鲁》', gameCount: 4 },
    { name: 'Capcom', logoIcon: '🧟', desc: '代表作：《生化危机4》《怪物猎人》', gameCount: 18 },
    { name: 'Game Science', logoIcon: '🐒', desc: '代表作：《黑神话：悟空》', gameCount: 2 },
    { name: 'Valve', logoIcon: '🗝️', desc: '代表作：《CS2》《Dota2》饰品道具', gameCount: 42 },
    { name: 'CD PROJEKT RED', logoIcon: '🌃', desc: '代表作：《赛博朋克2077》《巫师3》', gameCount: 6 },
    { name: 'Bandai Namco', logoIcon: '⚔️', desc: '代表作：《艾尔登法环》《铁拳8》', gameCount: 15 },
    { name: 'PUBG Studio', logoIcon: '🪂', desc: '代表作：《PUBG G-coin》官方道具', gameCount: 8 },
    { name: '黑盒官方', logoIcon: '🎁', desc: '代表作：小黑娘限定周边与外设', gameCount: 12 }
  ];

  private allStoreProducts: StoreProductItem[] = [
    // 0: 游戏
    {
      id: 'palworld',
      title: 'Palworld / 幻兽帕鲁-标准版',
      category: 0,
      price: 103,
      originalPrice: 108,
      sales: 9820,
      discountPercent: 5,
      couponTag: '领券95折',
      publisher: 'Pocketpair',
      platform: 'Steam',
      coverImg: $r('app.media.Palworld'),
      tags: ['开放世界', '抓宠', '生存'],
      stock: 99,
      description: '在广阔的世界中收集神奇的生物“帕鲁”，派它们进行战斗、建造、做农活或者在工厂劳作！'
    },
    {
      id: 'storm',
      title: '风暴怕死队-标准版',
      category: 0,
      price: 57,
      originalPrice: 68,
      sales: 3400,
      discountPercent: 10,
      couponTag: '领券92折',
      publisher: 'Team17',
      platform: 'Steam',
      coverImg: $r('app.media.storm'),
      tags: ['射击', '战术', '合作'],
      stock: 50,
      description: '硬核俯视角射击游戏，与好友组队在风暴圈中求生并完成高难度反恐行动。'
    },
    {
      id: 'relink',
      title: '碧蓝幻想 Relink-无尽黄昏完整版',
      category: 0,
      price: 233,
      originalPrice: 298,
      sales: 5600,
      discountPercent: 21,
      couponTag: '领券9折',
      publisher: 'Cygames',
      platform: 'Steam',
      coverImg: $r('app.media.granblue_relink'),
      tags: ['日系ARPG', '共斗', '二次元'],
      stock: 30,
      description: '由4名角色组成小队联机共斗，使用多样化的技能与奥义击败强大的星晶兽！'
    },
    {
      id: 'chained',
      title: '链在一起-标准版 (Chained Together)',
      category: 0,
      price: 20,
      originalPrice: 25,
      sales: 8900,
      discountPercent: 20,
      couponTag: '领券9折',
      publisher: 'Aneodus',
      platform: 'Steam',
      coverImg: $r('app.media.chain'),
      tags: ['双人合作', '平台跳跃', '欢声笑语'],
      stock: 120,
      description: '与你的同伴用铁链锁在一起，从地狱深渊一路攀登至天堂顶部！'
    },
    {
      id: 're4',
      title: 'RESIDENT EVIL 4 生化4重制版',
      category: 0,
      price: 148,
      originalPrice: 198,
      sales: 12000,
      discountPercent: 25,
      couponTag: '领券9折',
      publisher: 'Capcom',
      platform: 'Steam',
      coverImg: $r('app.media.resident'),
      tags: ['恐怖生存', '经典重制', '单机神作'],
      stock: 80,
      description: '特工里昂受命前往欧洲偏远村庄营救被绑架的总统千金，重制版带来全新的沉浸体验。'
    },
    {
      id: 'wukong',
      title: '黑神话：悟空 - 数字标准版',
      category: 0,
      price: 268,
      originalPrice: 298,
      sales: 35000,
      discountPercent: 10,
      couponTag: '领券9折',
      publisher: 'Game Science',
      platform: 'Steam',
      coverImg: $r('app.media.wukong'),
      tags: ['国风西游', '动作ARPG', '年度候选'],
      stock: 200,
      description: '踏上取经之后的传奇之路，扮演天命人探索充满东方神话色彩的宏大世界。'
    },
    {
      id: 'paper_bride',
      title: '纸嫁衣 5 无间梦境',
      category: 0,
      price: 17,
      originalPrice: 22,
      sales: 4300,
      discountPercent: 22,
      couponTag: '领券减1',
      publisher: 'HeartBeat Plus',
      platform: 'Steam',
      coverImg: $r('app.media.paper_bride'),
      tags: ['中式民俗', '解谜剧情'],
      stock: 150,
      description: '中式民俗解谜续作，融入经典戏剧文化与悬疑剧情。'
    },
    {
      id: 'party_animals',
      title: '猛兽派对 Party Animals',
      category: 0,
      price: 73,
      originalPrice: 98,
      sales: 15200,
      discountPercent: 25,
      couponTag: '领券95折',
      publisher: 'Recreate Games',
      platform: 'Steam',
      coverImg: $r('app.media.party'),
      tags: ['派对对战', '萌宠搞笑'],
      stock: 100,
      description: '扮演可爱的毛绒小动物，在各种搞笑竞技场中用拳头和道具淘汰对手！'
    },

    // 1: 游戏道具
    {
      id: 'pubg_gcoin',
      title: '绝地求生 10000+1200 G-coin 兑换码',
      category: 1,
      price: 631,
      sales: 14200,
      couponTag: '领券93折',
      publisher: 'PUBG Studio',
      platform: 'Steam',
      coverImg: $r('app.media.pubg_gcoin'),
      tags: ['今日特卖', '游戏饰品'],
      stock: 500,
      description: '绝地求生官方 G-coin 充值卡，购买可获得 11200 G-coin 游戏内代币。'
    },
    {
      id: 'cs2_case',
      title: 'CS2 革命武器箱钥匙 x 5 组包',
      category: 1,
      price: 75,
      sales: 28900,
      couponTag: '秒发KEY',
      publisher: 'Valve',
      platform: 'Steam',
      coverImg: $r('app.media.cs2_key'),
      tags: ['CS2武器箱', '即时到账'],
      stock: 999,
      description: '用于开启 CS2 革命武器箱，有机会获得极品手套与手枪皮肤。'
    },
    {
      id: 'apex_coins',
      title: 'Apex 英雄 1000 金币直充礼包',
      category: 1,
      price: 58,
      sales: 9600,
      couponTag: '领券减3',
      publisher: 'EA',
      platform: 'Steam',
      coverImg: $r('app.media.apex'),
      tags: ['英雄金币', '赛季通行证'],
      stock: 300,
      description: '可用于解锁 Apex 赛季战斗通行证或购买限定英雄皮肤。'
    },
    {
      id: 'dota2_battlepass',
      title: 'Dota 2 2026 勇士令状 50 级礼包',
      category: 1,
      price: 120,
      sales: 7400,
      couponTag: '官方授权',
      publisher: 'Valve',
      platform: 'Steam',
      coverImg: $r('app.media.dota2'),
      tags: ['Dota2令状', '至高饰品'],
      stock: 200,
      description: '快速提升勇士令状等级，解锁专属不朽珍藏与地图效果。'
    },

    // 2: 游戏周边
    {
      id: 'blackbox_figure',
      title: '黑盒限定 · 小黑娘 Q版粘土人手办',
      category: 2,
      price: 199,
      originalPrice: 249,
      sales: 3200,
      discountPercent: 20,
      couponTag: '顺丰包邮',
      publisher: '黑盒官方',
      platform: '周边实体',
      coverImg: $r('app.media.blackbox_figure'),
      tags: ['黑盒限定', '精美手办'],
      stock: 45,
      description: '小黑盒官方 10 周年限定小黑娘粘土人手办，含 3 款可替换表情与黑盒小背包配件。'
    },
    {
      id: 'cyberpunk_mat',
      title: '赛博朋克 2077 官方夜之城超大锁边鼠标垫',
      category: 2,
      price: 69,
      originalPrice: 89,
      sales: 6500,
      discountPercent: 22,
      couponTag: '满50包邮',
      publisher: 'CD PROJEKT RED',
      platform: '周边实体',
      coverImg: $r('app.media.cyberpunk'),
      tags: ['官方授权', '4mm加厚'],
      stock: 88,
      description: '900x400mm 像素级天然橡胶底面，细腻布面提供精准鼠标追踪。'
    },
    {
      id: 'elden_keycaps',
      title: '艾尔登法环 符文定制 PBT 机械键盘键帽',
      category: 2,
      price: 128,
      sales: 2100,
      couponTag: '热升华',
      publisher: 'Bandai Namco',
      platform: '周边实体',
      coverImg: $r('app.media.eldenring'),
      tags: ['法环外设', '原厂高度'],
      stock: 60,
      description: '全套 138 键热升华 PBT 键帽，透光符文文字与黄金树个性图案。'
    },
    {
      id: 'controller_case',
      title: 'PS5 / Xbox 手柄防摔硬壳便携保护包',
      category: 2,
      price: 39,
      sales: 8400,
      couponTag: '买一送一',
      publisher: '黑盒官方',
      platform: '周边实体',
      coverImg: $r('app.media.controller_case'),
      tags: ['防震耐磨', '收纳配件'],
      stock: 250,
      description: 'EVA 硬壳材质有效抵御外部挤压，内部绒布防护手柄防摇杆磨损。'
    }
  ];

  showToast(msg: string) {
    this.storeToastMsg = msg;
    this.showStoreToast = true;
    setTimeout(() => {
      this.showStoreToast = false;
    }, 2200);
  }

  getFilteredProducts(): StoreProductItem[] {
    let list = this.allStoreProducts.filter((p: StoreProductItem) => {
      if (p.category !== this.storeSegmentIndex) {
        return false;
      }
      if (this.selectedPublisher !== '' && p.publisher !== this.selectedPublisher) {
        return false;
      }
      if (this.storeSearchQuery.trim() !== '') {
        const q = this.storeSearchQuery.trim().toLowerCase();
        return p.title.toLowerCase().includes(q) || p.publisher.toLowerCase().includes(q);
      }
      return true;
    });

    if (this.storeSortIndex === 0) {
      list.sort((a, b) => b.sales - a.sales);
    } else if (this.storeSortIndex === 1) {
      list.sort((a, b) => (b.discountPercent ?? 0) - (a.discountPercent ?? 0));
    } else if (this.storeSortIndex === 2) {
      list.sort((a, b) => a.price - b.price);
    } else if (this.storeSortIndex === 3) {
      list.sort((a, b) => b.price - a.price);
    } else if (this.storeSortIndex === 4) {
      list.sort((a, b) => b.id.localeCompare(a.id));
    }
    return list;
  }

  addToCart(product: StoreProductItem) {
    const existing = this.cartItems.find(item => item.product.id === product.id);
    if (existing) {
      existing.quantity += 1;
    } else {
      this.cartItems.push({
        product: product,
        quantity: 1,
        selected: true
      });
    }
    this.showToast(`已将《${product.title}》加入购物车！`);
  }

  buyProductNow(product: StoreProductItem) {
    const randomKey = 'HBKEY-' + Math.floor(1000 + Math.random() * 9000) + '-CDK-' + Math.floor(1000 + Math.random() * 9000);
    const newOrder: OrderItem = {
      id: 'HB' + Date.now(),
      productTitle: product.title,
      productImg: product.coverImg,
      price: product.price,
      quantity: 1,
      status: '待激活',
      cdkey: randomKey,
      createTime: '刚刚'
    };
    this.storeOrders.unshift(newOrder);
    this.activeStoreModal = 'orders';
    this.showToast(`购买成功！激活码已发放至「我的订单」`);
  }

  checkoutCart() {
    const selectedList = this.cartItems.filter(item => item.selected);
    if (selectedList.length === 0) {
      this.showToast('请先选择要结算的商品！');
      return;
    }

    selectedList.forEach(item => {
      const randomKey = 'HBKEY-' + Math.floor(1000 + Math.random() * 9000) + '-CDK-' + Math.floor(1000 + Math.random() * 9000);
      this.storeOrders.unshift({
        id: 'HB' + Date.now() + Math.floor(Math.random() * 100),
        productTitle: item.product.title,
        productImg: item.product.coverImg,
        price: item.product.price,
        quantity: item.quantity,
        status: '待激活',
        cdkey: randomKey,
        createTime: '刚刚'
      });
    });

    this.cartItems = this.cartItems.filter(item => !item.selected);
    this.activeStoreModal = 'orders';
    this.showToast('结算成功！订单已生成，激活码存入「我的订单」');
  }

  private bannerSlides: BannerSlide[] = [
    { title: '黑盒大促', subtitle: '夏日冲浪季', colors: ['#0F1B2B', '#7A1F1F'], bgImg: $r('app.media.background') },
    { title: '2K厂商促销', subtitle: '文明6/NBA 2K26/无主4 史低', colors: ['#0F1B2B', '#7A1F1F'] },
    { title: '独立游戏节', subtitle: '精选独立游戏 5折起', colors: ['#122A22', '#1F5C4A'] },
  ];

  private quickNavs: QuickNav[] = [
    { title: '黑盒商城', desc: '', icon: '🛍️' },
    { title: '喜加一', desc: '6款免费', icon: '🎁', showDot: true },
    { title: '赛事中心', desc: '', icon: '🏆' },
    { title: '黑盒语音', desc: '免费AI降噪', icon: '🎙️' },
  ];

  private forYouIds: string[] = [
    'palworld',
    'party-animals',
    'chained-together',
    'rise-of-tomb-raider',
    'love-choice',
    'miside',
  ];

  private forYouPageGames: RecommendPageItem[] = [
    {
      id: 'paper-bride',
      title: '纸嫁衣',
      price: 17,
      couponLabel: '领券减1',
      tags: ['大家都在玩', '解谜'],
      coverImg: $r('app.media.paper_bride'),
    },
    {
      id: 'death-and-taxes',
      title: '死亡与税赋',
      price: 7,
      originalPrice: 52,
      discountPercent: 87,
      tags: ['大家都在玩', '独立', '模拟'],
      coverImg: $r('app.media.death_taxes'),
    },
    {
      id: 'song-of-koto',
      title: '莺之歌',
      price: 5,
      originalPrice: 22,
      discountPercent: 80,
      lowestLabel: '超史低',
      tags: ['大家都在玩', '视觉小说'],
      coverImg: $r('app.media.song_koto'),
    },
    {
      id: 'pico-park-2',
      title: 'PICO PARK 2',
      price: 40,
      tags: ['大家都在玩', '动作', '休闲'],
      coverImg: $r('app.media.pico_park'),
    },
    {
      id: 'p5r',
      title: '女神异闻录5皇家版',
      price: 73,
      originalPrice: 268,
      discountPercent: 70,
      couponLabel: '领券9折',
      tags: ['大家都在玩'],
      coverImg: $r('app.media.p5r'),
    },
    {
      id: 'hungry-starving',
      title: '饿殍：明末千里行',
      price: 21,
      originalPrice: 37,
      discountPercent: 37,
      couponLabel: '领券9折',
      remainDays: '剩余 6 天',
      tags: ['大家都在玩', '剧情', '国产'],
      coverImg: $r('app.media.hungry_starving'),
    },
    {
      id: 'they-love-me-too-much',
      title: '糟糕！他们太爱我了怎么办？',
      price: 18,
      tags: ['大家都在玩', '角色扮演', '策略'],
      coverImg: $r('app.media.they_love_me'),
    },
    {
      id: 'rayman-rabbids',
      title: '雷曼4：疯狂兔子',
      price: 24,
      couponLabel: '领券95折',
      tags: ['大家都在玩'],
      coverImg: $r('app.media.rayman'),
    },
    {
      id: 'old-day-nun',
      title: '旧日女修',
      price: 23,
      originalPrice: 38,
      discountPercent: 35,
      lowestLabel: '新史低',
      couponLabel: '领券9折',
      remainDays: '剩余 6 天',
      tags: ['修仙', '角色扮演'],
      coverImg: $r('app.media.old_day_nun'),
    },
    {
      id: 'cats-together',
      title: '双喵成行',
      price: 24,
      originalPrice: 32,
      discountPercent: 20,
      couponLabel: '领券9折',
      tags: ['大家都在玩', '双人', '合作'],
      coverImg: $r('app.media.cats_together'),
    },
    {
      id: 'paper-house',
      title: '纸房子',
      price: 12,
      tags: ['解谜', '独立'],
      coverImg: $r('app.media.paper_house'),
    },
    {
      id: 'palworld',
      title: 'Palworld / 幻兽帕鲁',
      price: 72,
      originalPrice: 108,
      discountPercent: 30,
      couponLabel: '领券95折',
      lowestLabel: '新史低',
      tags: ['大家都在玩', '开放世界', '抓宠'],
      coverImg: $r('app.media.Palworld'),
    },
    {
      id: 'black-myth-wukong',
      title: '黑神话：悟空',
      price: 268,
      originalPrice: 298,
      discountPercent: 10,
      couponLabel: '领券9折',
      lowestLabel: '史低',
      tags: ['大家都在玩', '国风神作', '动作'],
      coverImg: $r('app.media.wukong'),
    },
  ];

  private steamSaleIds: string[] = [
    'overcooked2',
    'resident-evil-4',
    'monster-hunter-world',
    'monster-hunter-rise',
    'street-fighter-6',
    'nba-2k26',
  ];

  private hotSellers: HotSellerItem[] = [
    {
      id: 'palworld',
      title: 'Palworld / 幻兽帕鲁-标准版',
      price: 72,
      originalPrice: 108,
      discountPercent: 30,
      couponLabel: '领券95折',
      coverImg: $r('app.media.Palworld'),
    },
    {
      id: 'miside',
      title: '午夜值班-标准版',
      price: 32,
      originalPrice: 38,
      discountPercent: 10,
      couponLabel: '领券92折',
      coverImg: $r('app.media.mita'),
    },
    {
      id: 'tomb-raider-underworld',
      title: '绝地求生 10000+1200 G-coin',
      price: 631,
      couponLabel: '领券93折',
      coverImg: $r('app.media.pubg_gcoin'),
    },
    {
      id: 'rise-of-tomb-raider',
      title: '碧蓝航线 交叉领域',
      price: 28,
      couponLabel: '领券9折',
      coverImg: $r('app.media.azur_lane'),
    },
  ];

  private goDetail(id: string): void {
    try {
      this.getUIContext().getRouter().pushUrl({
        url: GameLibraryRoutes.GAME_DETAIL,
        params: { id },
      });
    } catch (err) {
    }
  }

  @Builder
  BannerSlideBuilder(slide: BannerSlide) {
    Stack({ alignContent: Alignment.TopStart }) {
      if (slide.bgImg) {
        Image(slide.bgImg)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      } else {
        Row()
          .width('100%')
          .height('100%')
          .linearGradient({
            angle: 100,
            colors: [[slide.colors[0], 0], [slide.colors[1], 1]],
          })
      }

      Row() {
        Text('小黑盒')
          .fontSize(9)
          .fontColor(Color.White)
          .backgroundColor('rgba(0,0,0,0.5)')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
      }
      .margin({ left: 12, top: 10 })

      Column() {
        Text(slide.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text(slide.subtitle)
          .fontSize(12)
          .fontColor('#FFD9B3')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16, top: 32 })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  QuickNavItemBuilder(item: QuickNav) {
    Column() {
      Row() {
        Text(item.title)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
        if (item.showDot) {
          Row()
            .width(5)
            .height(5)
            .borderRadius(3)
            .backgroundColor('#FF3B30')
            .margin({ left: 3 })
        }
      }
      if (item.desc !== '') {
        Text(item.desc)
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 3 })
      }
      Text(item.icon)
        .fontSize(18)
        .margin({ top: item.desc !== '' ? 6 : 14 })
    }
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)
    .height(70)
    .padding(10)
    .backgroundColor('#F5F5F7')
    .borderRadius(12)
    .onClick(() => {
      this.activeNavPage = item.title;
    })
  }

  @Builder
  SectionHeaderBuilder(title: string) {
    Row() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
      Blank()
      Text('更多 >')
        .fontSize(12)
        .fontColor('#888888')
        .onClick(() => {
          if (title === '为你推荐') {
            this.isForYouPageOpen = true;
          }
        })
    }
    .width('100%')
    .margin({ top: 20, bottom: 12 })
  }

  @Builder
  GameCoverBuilder(item: GameItem) {
    Stack({ alignContent: Alignment.TopStart }) {
      if (item.coverImg) {
        Image(item.coverImg)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      } else {
        Column() {
          Text(item.englishTitle.toUpperCase())
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('rgba(255,255,255,0.85)')
            .maxLines(2)
            .textAlign(TextAlign.Center)
            .padding({ left: 8, right: 8 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 120,
          colors: [[item.gradientColors[0], 0], [item.gradientColors[1], 1]],
        })
      }

      if (item.couponLabel) {
        Text(item.couponLabel)
          .fontSize(10)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#FFA033')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius({ topRight: 8, bottomRight: 8 })
      }
    }
    .width('100%')
    .aspectRatio(1.72)
    .borderRadius(10)
    .clip(true)
  }

  @Builder
  GameCardBuilder(item: GameItem) {
    Column() {
      this.GameCoverBuilder(item)

      Text(item.title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .width('100%')

      Row() {
        if (item.platformIcon === 'steam') {
          Text('♨')
            .fontSize(12)
            .fontColor('#1A1A1A')
            .margin({ right: 3 })
        } else {
          Text('☖')
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ right: 3 })
        }

        Text('¥')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
        Text(`${item.price}`)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ right: 4 })

        if (item.originalPrice) {
          Text(`¥${item.originalPrice}`)
            .fontSize(11)
            .fontColor('#B0B0B0')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ right: 4 })
        }

        if (item.originalPrice && item.discountPercent && item.id !== 'love-choice') {
          Text('券后价')
            .fontSize(10)
            .fontColor('#999999')
            .margin({ right: 4 })
        }

        if (item.discountPercent) {
          Text(`-${item.discountPercent}%`)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#333333')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
            .margin({ right: 4 })
        }

        if (item.lowestLabel) {
          Text(item.lowestLabel)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#2BC48A')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
        }
      }
      .width('100%')
      .margin({ top: 6 })

      Row() {
        if (item.rankBoard) {
          Text(item.rankBoard + ' >')
            .fontSize(11)
            .fontColor('#7A7A7A')
            .margin({ right: 6 })
        }
        Text(item.tags.slice(0, 3).join(' | '))
          .fontSize(11)
          .fontColor('#B0B0B0')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .onClick(() => this.goDetail(item.id))
  }

  @Builder
  SteamSaleFeaturedBuilder() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.rdr2'))
          .width('100%')
          .height(180)
          .objectFit(ImageFit.Cover)

        Text('Steam促销')
          .fontSize(11)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#2BC48A')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius({ bottomRight: 8 })
      }
      .width('100%')
      .height(180)

      Row() {
        Row() {
          Text('▶')
            .fontSize(18)
            .fontColor(Color.White)
            .margin({ left: 2 })
        }
        .width(44)
        .height(44)
        .borderRadius(22)
        .backgroundColor('rgba(0,0,0,0.45)')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height(180)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Row() {
        Image($r('app.media.rdr2'))
          .width(38)
          .height(38)
          .borderRadius(6)
          .objectFit(ImageFit.Cover)
          .margin({ right: 10 })

        Column() {
          Text('荒野大镖客：救赎2')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('开放世界 | 剧情丰富 | 西部')
            .fontSize(11)
            .fontColor('#E0E0E0')
            .margin({ top: 3 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Row() {
          Text('☖')
            .fontSize(11)
            .fontColor(Color.White)
            .margin({ right: 2 })
          Text('¥70')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('¥279')
            .fontSize(11)
            .fontColor('rgba(255,255,255,0.7)')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ left: 3, right: 3 })
          Text('-75%')
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#333333')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
            .margin({ right: 4 })
          Text('史低')
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#2BC48A')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
        }
      }
      .width('100%')
      .padding(10)
      .linearGradient({
        angle: 180,
        colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.85)', 1]]
      })
    }
    .width('100%')
    .height(180)
    .borderRadius(12)
    .clip(true)
    .margin({ bottom: 12 })
    .onClick(() => this.goDetail('rdr2'))
  }

  @Builder
  HotSellerCardBuilder(item: HotSellerItem) {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image(item.coverImg)
          .width('100%')
          .height(76)
          .objectFit(ImageFit.Cover)

        if (item.discountPercent) {
          Text(`-${item.discountPercent}%`)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('rgba(0,0,0,0.6)')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius({ bottomLeft: 4 })
            .align(Alignment.TopEnd)
        }

        if (item.couponLabel) {
          Text(item.couponLabel)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#FFA033')
            .padding({ left: 5, right: 5, top: 2, bottom: 2 })
            .borderRadius({ topRight: 6 })
            .align(Alignment.BottomStart)
        }
      }
      .width('100%')
      .height(76)
      .borderRadius(8)
      .clip(true)

      Text(item.title)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 6 })
        .width('100%')

      Row() {
        Text('¥')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
        Text(`${item.price}`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ right: 3 })
        if (item.originalPrice) {
          Text(`¥${item.originalPrice}`)
            .fontSize(10)
            .fontColor('#B0B0B0')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ right: 3 })
        }
        Text('券后价')
          .fontSize(9)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ top: 4 })
    }
    .width(135)
    .padding(8)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ right: 10 })
    .onClick(() => this.goDetail(item.id))
  }

  @Builder
  ForYouRowBuilder(item: RecommendPageItem) {
    Row() {
      // 左侧封面图片 (含折角折扣角标)
      Stack({ alignContent: Alignment.TopEnd }) {
        if (item.coverImg) {
          Image(item.coverImg)
            .width(124)
            .height(72)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
        } else {
          Column() {
            Text(item.title)
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .padding(4)
          }
          .width(124)
          .height(72)
          .borderRadius(8)
          .justifyContent(FlexAlign.Center)
          .linearGradient({
            angle: 120,
            colors: item.gradientColors ? [[item.gradientColors[0], 0], [item.gradientColors[1], 1]] : [['#3A3A3A', 0], ['#171717', 1]]
          })
        }

        if (item.discountPercent) {
          Text(`-${item.discountPercent}%`)
            .fontSize(9)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .backgroundColor('rgba(0,0,0,0.65)')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius({ topRight: 8, bottomLeft: 4 })
        }
      }
      .width(124)
      .height(72)

      // 右侧核心信息
      Column() {
        Text(item.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 价格与折扣/立减/史低标签
        Row() {
          Text('☖')
            .fontSize(10)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ right: 2 })
          Text('¥')
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text(`${item.price}`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ right: 4 })

          if (item.originalPrice) {
            Text(`¥${item.originalPrice}`)
              .fontSize(10)
              .fontColor('#B0B0B0')
              .decoration({ type: TextDecorationType.LineThrough })
              .margin({ right: 4 })
          } else {
            Text('券后价')
              .fontSize(10)
              .fontColor('#999999')
              .margin({ right: 4 })
          }

          if (item.couponLabel) {
            Text(item.couponLabel)
              .fontSize(9)
              .fontColor('#E25C00')
              .border({ width: 1, color: '#FFB280' })
              .backgroundColor('#FFF5ED')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ right: 4 })
          }

          if (item.lowestLabel) {
            Text(item.lowestLabel)
              .fontSize(9)
              .fontColor(Color.White)
              .backgroundColor(item.lowestLabel === '超史低' ? '#00B0FF' : '#2BC48A')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ right: 4 })
          }

          if (item.remainDays) {
            Blank()
            Text(item.remainDays)
              .fontSize(9)
              .fontColor('#888888')
          }
        }
        .width('100%')
        .margin({ top: 6 })

        // 分类 Chip 标签
        Row({ space: 4 }) {
          ForEach(item.tags, (tag: string) => {
            Text(tag)
              .fontSize(10)
              .fontColor('#666666')
              .backgroundColor('#F5F5F7')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
          })
        }
        .width('100%')
        .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .border({ width: { bottom: 1 }, color: '#F7F7F9' })
    .onClick(() => {
      this.goDetail(item.id);
    })
  }

  @Builder
  ForYouPageOverlayBuilder() {
    Column() {
      // 截图同款 Header: ← 为你推荐
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#1A1A1A')
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.isForYouPageOpen = false))

        Text('为你推荐')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      // 截图同款垂直游戏列表
      Scroll() {
        Column() {
          ForEach(this.forYouPageGames, (item: RecommendPageItem) => {
            this.ForYouRowBuilder(item)
          }, (item: RecommendPageItem) => item.id)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 4, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll() {
        Column() {
          // Banner 轮播
          Swiper() {
            ForEach(this.bannerSlides, (slide: BannerSlide) => {
              this.BannerSlideBuilder(slide)
            }, (slide: BannerSlide) => slide.title)
          }
          .aspectRatio(3.2)
          .width('100%')
          .borderRadius(14)
          .clip(true)
          .autoPlay(true)
          .loop(true)
          .interval(3500)
          .indicator(
            Indicator.dot()
              .itemWidth(5)
              .itemHeight(5)
              .selectedItemWidth(14)
              .selectedItemHeight(5)
              .color('rgba(255,255,255,0.4)')
              .selectedColor(Color.White)
              .left(16)
              .bottom(10)
          )
          .onChange((index: number) => (this.bannerIndex = index))

          // 快捷导航
          Row({ space: 10 }) {
            ForEach(this.quickNavs, (item: QuickNav) => {
              this.QuickNavItemBuilder(item)
            }, (item: QuickNav) => item.title)
          }
          .width('100%')
          .margin({ top: 14 })

          // 快捷导航下方的小横线指示条
          Row()
            .width(24)
            .height(3)
            .backgroundColor('#E5E5E5')
            .borderRadius(1.5)
            .margin({ top: 10, bottom: 4 })

          // 栏目一：为你推荐
          this.SectionHeaderBuilder('为你推荐')

          Grid() {
            ForEach(this.forYouIds, (id: string) => {
              GridItem() {
                if (getGameById(id)) {
                  this.GameCardBuilder(getGameById(id) as GameItem)
                }
              }
            }, (id: string) => id)
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(12)
          .rowsGap(12)
          .width('100%')

          // 栏目二：Steam促销
          this.SectionHeaderBuilder('Steam促销')

          // 大卡片（荒野大镖客2）
          this.SteamSaleFeaturedBuilder()

          // 6款促销游戏
          Grid() {
            ForEach(this.steamSaleIds, (id: string) => {
              GridItem() {
                if (getGameById(id)) {
                  this.GameCardBuilder(getGameById(id) as GameItem)
                }
              }
            }, (id: string) => id)
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(12)
          .rowsGap(12)
          .width('100%')

          // 栏目三：黑盒热销
          this.SectionHeaderBuilder('黑盒热销')

          Scroll() {
            Row() {
              ForEach(this.hotSellers, (item: HotSellerItem) => {
                this.HotSellerCardBuilder(item)
              }, (item: HotSellerItem) => item.id)
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .width('100%')
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .layoutWeight(1)

      if (this.isForYouPageOpen) {
        this.ForYouPageOverlayBuilder()
      }

      if (this.activeNavPage === '黑盒商城') {
        this.StorePageOverlayBuilder()
      } else if (this.activeNavPage === '喜加一') {
        this.FreeGamePageOverlayBuilder()
      } else if (this.activeNavPage === '赛事中心') {
        this.TournamentPageOverlayBuilder()
      } else if (this.activeNavPage === '黑盒语音') {
        this.VoicePageOverlayBuilder()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  StorePageOverlayBuilder() {
    Stack({ alignContent: Alignment.Top }) {
      Column() {
        // 1. 顶部 Header 导航栏 (截图: < H 黑盒商城 官方服务... 🔍 🎧)
        Row() {
          Text('‹')
            .fontSize(32)
            .fontColor('#1A1A1A')
            .padding({ left: 14, right: 8 })
            .onClick(() => (this.activeNavPage = ''))

          Row() {
            Text('H')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .backgroundColor('#1A1A1A')
              .width(24)
              .height(24)
              .borderRadius(6)
              .textAlign(TextAlign.Center)
          }
          .margin({ right: 8 })

          Column() {
            Text('黑盒商城')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
            Text('官方服务 · 流程便捷 · 价格实惠')
              .fontSize(10)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('🔍')
            .fontSize(18)
            .margin({ right: 14 })
            .onClick(() => (this.activeStoreModal = 'search'))
          Text('🎧')
            .fontSize(18)
            .margin({ right: 14 })
            .onClick(() => (this.activeStoreModal = 'customer_service'))
        }
        .width('100%')
        .height(52)
        .backgroundColor(Color.White)
        .border({ width: { bottom: 1 }, color: '#F5F5F7' })

        Scroll() {
          Column() {
            // 2. VIP 专属卡片 (点击可查看特权中心)
            Column() {
              Row() {
                Column() {
                  Row() {
                    Text(this.vipLevel)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#5D3012')
                    Text('VIP 进阶中')
                      .fontSize(9)
                      .fontColor('#FFFFFF')
                      .backgroundColor('#E09E74')
                      .padding({ left: 6, right: 6, top: 1, bottom: 1 })
                      .borderRadius(8)
                      .margin({ left: 6 })
                  }
                  Text('累计消费已解锁多项会员专享抵扣与特权包')
                    .fontSize(11)
                    .fontColor('#8C522B')
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text('H')
                  .fontSize(28)
                  .fontWeight(FontWeight.Bolder)
                  .fontColor('#E09E74')
              }
              .width('100%')

              Row() {
                Column() {
                  Text('⚡')
                    .fontSize(16)
                  Text('20%抵扣')
                    .fontSize(10)
                    .fontColor('#7A4523')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Column() {
                  Text('🪙')
                    .fontSize(16)
                  Text('返还H币')
                    .fontSize(10)
                    .fontColor('#7A4523')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Column() {
                  Text('🧧')
                    .fontSize(16)
                  Text('20元券包')
                    .fontSize(10)
                    .fontColor('#7A4523')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Column() {
                  Text('🚀')
                    .fontSize(16)
                  Text('3天加速器')
                    .fontSize(10)
                    .fontColor('#7A4523')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)

                Text('查看更多 >')
                  .fontSize(11)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#8C522B')
              }
              .width('100%')
              .margin({ top: 14 })
            }
            .width('100%')
            .padding(14)
            .borderRadius(12)
            .linearGradient({
              angle: 135,
              colors: [['#FFEDE3', 0], ['#FFD6C0', 1]]
            })
            .margin({ top: 12, bottom: 14 })
            .onClick(() => (this.activeStoreModal = 'vip'))

            // 3. 5 Icon 金刚位
            Row() {
              // 我的钱包
              Column() {
                Text('👛')
                  .fontSize(22)
                Text('我的钱包')
                  .fontSize(11)
                  .fontColor('#333333')
                  .margin({ top: 6 })
              }
              .layoutWeight(1)
              .onClick(() => (this.activeStoreModal = 'wallet'))

              // 我的订单
              Column() {
                Text('📋')
                  .fontSize(22)
                Text('我的订单')
                  .fontSize(11)
                  .fontColor('#333333')
                  .margin({ top: 6 })
              }
              .layoutWeight(1)
              .onClick(() => (this.activeStoreModal = 'orders'))

              // 领券中心
              Stack({ alignContent: Alignment.TopEnd }) {
                Column() {
                  Text('🧧')
                    .fontSize(22)
                  Text('领券中心')
                    .fontSize(11)
                    .fontColor('#333333')
                    .margin({ top: 6 })
                }
                Text('热')
                  .fontSize(8)
                  .fontColor(Color.White)
                  .backgroundColor('#FF3B30')
                  .padding({ left: 3, right: 3, top: 1, bottom: 1 })
                  .borderRadius(6)
              }
              .layoutWeight(1)
              .onClick(() => (this.activeStoreModal = 'coupons'))

              // 购物车
              Stack({ alignContent: Alignment.TopEnd }) {
                Column() {
                  Text('🛒')
                    .fontSize(22)
                  Text('购物车')
                    .fontSize(11)
                    .fontColor('#333333')
                    .margin({ top: 6 })
                }
                if (this.cartItems.length > 0) {
                  Text(`${this.cartItems.length}`)
                    .fontSize(9)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)
                    .backgroundColor('#FF3B30')
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(8)
                }
              }
              .layoutWeight(1)
              .onClick(() => (this.activeStoreModal = 'cart'))

              // 游戏厂商
              Column() {
                Text('🎮')
                  .fontSize(22)
                Text('游戏厂商')
                  .fontSize(11)
                  .fontColor('#333333')
                  .margin({ top: 6 })
              }
              .layoutWeight(1)
              .onClick(() => (this.activeStoreModal = 'publishers'))
            }
            .width('100%')
            .margin({ bottom: 16 })

            // 4. 3大品类切换 Tab (游戏 | 游戏道具 | 游戏周边)
            Row() {
              Row() {
                Text('游戏')
                  .fontSize(13)
                  .fontWeight(this.storeSegmentIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.storeSegmentIndex === 0 ? '#1A1A1A' : '#666666')
                  .backgroundColor(this.storeSegmentIndex === 0 ? Color.White : 'transparent')
                  .padding({ left: 24, right: 24, top: 8, bottom: 8 })
                  .borderRadius(8)
                  .onClick(() => (this.storeSegmentIndex = 0))

                Text('游戏道具')
                  .fontSize(13)
                  .fontWeight(this.storeSegmentIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.storeSegmentIndex === 1 ? '#1A1A1A' : '#666666')
                  .backgroundColor(this.storeSegmentIndex === 1 ? Color.White : 'transparent')
                  .padding({ left: 24, right: 24, top: 8, bottom: 8 })
                  .borderRadius(8)
                  .onClick(() => (this.storeSegmentIndex = 1))

                Text('游戏周边')
                  .fontSize(13)
                  .fontWeight(this.storeSegmentIndex === 2 ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.storeSegmentIndex === 2 ? '#1A1A1A' : '#666666')
                  .backgroundColor(this.storeSegmentIndex === 2 ? Color.White : 'transparent')
                  .padding({ left: 24, right: 24, top: 8, bottom: 8 })
                  .borderRadius(8)
                  .onClick(() => (this.storeSegmentIndex = 2))
              }
              .width('100%')
              .padding(3)
              .backgroundColor('#F2F3F5')
              .borderRadius(10)
            }
            .width('100%')
            .margin({ bottom: 12 })

            // 厂商筛选提示
            if (this.selectedPublisher !== '') {
              Row() {
                Text(`当前厂商筛选：${this.selectedPublisher}`)
                  .fontSize(12)
                  .fontColor('#1A1A1A')
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)

                Text('清除筛选 ✖')
                  .fontSize(11)
                  .fontColor('#FF3B30')
                  .onClick(() => (this.selectedPublisher = ''))
              }
              .width('100%')
              .padding({ left: 10, right: 10, top: 6, bottom: 6 })
              .backgroundColor('#FFF5F5')
              .borderRadius(6)
              .margin({ bottom: 10 })
            }

            // 5. 排序筛选横栏
            Row({ space: 16 }) {
              ForEach(['销量', '最高折扣', '价格升序', '价格降序', '最新上架'], (tab: string, idx: number) => {
                Column() {
                  Text(tab)
                    .fontSize(13)
                    .fontWeight(this.storeSortIndex === idx ? FontWeight.Bold : FontWeight.Normal)
                    .fontColor(this.storeSortIndex === idx ? '#1A1A1A' : '#888888')
                  Row()
                    .width(this.storeSortIndex === idx ? 16 : 0)
                    .height(3)
                    .borderRadius(1.5)
                    .backgroundColor('#1A1A1A')
                    .margin({ top: 4 })
                }
                .onClick(() => (this.storeSortIndex = idx))
              })
            }
            .width('100%')
            .margin({ bottom: 14 })

            // 6. 商品双列瀑布流 Grid (动态数据)
            Grid() {
              ForEach(this.getFilteredProducts(), (product: StoreProductItem) => {
                GridItem() {
                  Column() {
                    Stack({ alignContent: Alignment.TopStart }) {
                      Image(product.coverImg)
                        .width('100%')
                        .height(105)
                        .borderRadius({ topLeft: 10, topRight: 10 })
                        .objectFit(ImageFit.Cover)

                      if (product.couponTag) {
                        Text(product.couponTag)
                          .fontSize(9)
                          .fontColor(Color.White)
                          .backgroundColor('#FFA033')
                          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                          .borderRadius({ topRight: 8, bottomRight: 8 })
                      }
                    }

                    Text(product.title)
                      .fontSize(13)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#1A1A1A')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .margin({ top: 8, left: 8, right: 8 })

                    Row({ space: 4 }) {
                      Text(product.platform)
                        .fontSize(9)
                        .fontColor('#555555')
                        .backgroundColor('#F0F0F2')
                        .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                        .borderRadius(3)
                      Text(`销量 ${product.sales}`)
                        .fontSize(9)
                        .fontColor('#888888')
                    }
                    .margin({ top: 4, left: 8 })

                    Row() {
                      Text(`¥ ${product.price}`)
                        .fontSize(15)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#1A1A1A')

                      if (product.originalPrice) {
                        Text(`¥${product.originalPrice}`)
                          .fontSize(10)
                          .fontColor('#B0B0B0')
                          .decoration({ type: TextDecorationType.LineThrough })
                          .margin({ left: 4 })
                      }

                      Blank()

                      Text('+ 🛒')
                        .fontSize(12)
                        .fontColor('#FFFFFF')
                        .backgroundColor('#1A1A1A')
                        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                        .borderRadius(10)
                        .onClick((e?: ClickEvent) => {
                          this.addToCart(product);
                        })
                    }
                    .width('100%')
                    .padding({ left: 8, right: 8 })
                    .margin({ top: 6, bottom: 10 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .backgroundColor(Color.White)
                  .borderRadius(10)
                  .onClick(() => {
                    this.selectedStoreProduct = product;
                    this.activeStoreModal = 'product_detail';
                  })
                }
              }, (product: StoreProductItem) => product.id)
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap(10)
            .rowsGap(10)
            .width('100%')
          }
          .width('100%')
          .padding({ left: 14, right: 14, top: 4, bottom: 24 })
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')

      // 弹窗与抽屉图层
      if (this.activeStoreModal === 'search') {
        this.StoreSearchModalBuilder()
      } else if (this.activeStoreModal === 'customer_service') {
        this.StoreCustomerServiceModalBuilder()
      } else if (this.activeStoreModal === 'vip') {
        this.StoreVipModalBuilder()
      } else if (this.activeStoreModal === 'wallet') {
        this.StoreWalletModalBuilder()
      } else if (this.activeStoreModal === 'orders') {
        this.StoreOrdersModalBuilder()
      } else if (this.activeStoreModal === 'coupons') {
        this.StoreCouponsModalBuilder()
      } else if (this.activeStoreModal === 'cart') {
        this.StoreCartModalBuilder()
      } else if (this.activeStoreModal === 'publishers') {
        this.StorePublishersModalBuilder()
      } else if (this.activeStoreModal === 'product_detail') {
        this.StoreProductDetailModalBuilder()
      }

      // 悬浮 Toast 提示框
      if (this.showStoreToast) {
        Row() {
          Text(this.storeToastMsg)
            .fontSize(13)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
        .padding({ left: 18, right: 18, top: 10, bottom: 10 })
        .backgroundColor('rgba(26,26,26,0.92)')
        .borderRadius(20)
        .margin({ top: 60 })
        .shadow({ radius: 8, color: 'rgba(0,0,0,0.2)' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }

  // 1. 搜索弹窗
  @Builder
  StoreSearchModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          TextInput({ placeholder: '搜索游戏、CDKEY、游戏道具、周边...', text: this.storeSearchQuery })
            .layoutWeight(1)
            .height(40)
            .backgroundColor('#F0F0F2')
            .borderRadius(20)
            .padding({ left: 14, right: 14 })
            .onChange((val: string) => (this.storeSearchQuery = val))

          Text('取消')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 12 })
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 12 })

        Text('🔥 热门搜索')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ left: 16, top: 10, bottom: 8 })
          .width('100%')

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(['黑神话悟空', '绝地求生 G-Coin', '生化4', 'CS2钥匙', '幻兽帕鲁', '周边手办'], (tag: string) => {
            Text(tag)
              .fontSize(12)
              .fontColor('#333333')
              .backgroundColor('#F5F5F7')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .borderRadius(14)
              .margin({ right: 8, bottom: 8 })
              .onClick(() => {
                this.storeSearchQuery = tag;
              })
          })
        }
        .padding({ left: 16, right: 16, bottom: 16 })

        if (this.storeSearchQuery.trim() !== '') {
          Text('📦 搜索匹配结果')
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ left: 16, top: 10, bottom: 8 })
            .width('100%')

          Scroll() {
            Column({ space: 8 }) {
              ForEach(this.getFilteredProducts(), (item: StoreProductItem) => {
                Row() {
                  Image(item.coverImg)
                    .width(44)
                    .height(44)
                    .borderRadius(6)
                    .objectFit(ImageFit.Cover)

                  Column() {
                    Text(item.title)
                      .fontSize(13)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#1A1A1A')
                    Text(`¥ ${item.price} · ${item.platform}`)
                      .fontSize(11)
                      .fontColor('#FF3B30')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 10 })
                  .layoutWeight(1)

                  Text('查看')
                    .fontSize(12)
                    .fontColor(Color.White)
                    .backgroundColor('#1A1A1A')
                    .padding({ left: 12, right: 12, top: 5, bottom: 5 })
                    .borderRadius(12)
                    .onClick(() => {
                      this.selectedStoreProduct = item;
                      this.activeStoreModal = 'product_detail';
                    })
                }
                .width('100%')
                .padding(10)
                .backgroundColor('#FAFAFA')
                .borderRadius(8)
              })
            }
            .padding({ left: 16, right: 16, bottom: 20 })
          }
          .constraintSize({ maxHeight: 220 })
        }
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 2. 客服中心弹窗
  @Builder
  StoreCustomerServiceModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          Text('🎧 黑盒官方客服中心')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)

          Text('✖')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding(16)
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })

        Text('🤖 常见快捷问答 (点击查看解答)')
          .fontSize(12)
          .fontColor('#888888')
          .margin({ left: 16, top: 12, bottom: 8 })
          .width('100%')

        Scroll() {
          Column({ space: 10 }) {
            ForEach(this.customerFaqs, (faq: CustomerFaq) => {
              Column() {
                Text(`Q: ${faq.q}`)
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Text(`A: ${faq.a}`)
                  .fontSize(12)
                  .fontColor('#555555')
                  .margin({ top: 6 })
                  .lineHeight(18)
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
              .padding(12)
              .backgroundColor('#F8F9FA')
              .borderRadius(10)
              .onClick(() => {
                this.showToast('黑盒客服：' + faq.a);
              })
            })
          }
          .padding({ left: 16, right: 16, bottom: 20 })
        }
        .constraintSize({ maxHeight: 320 })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 3. VIP 会员中心弹窗
  @Builder
  StoreVipModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          Text('👑 青铜会员 · 专属特权中心')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#5D3012')
            .layoutWeight(1)

          Text('✖')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding(16)

        Column() {
          Row() {
            Text('等级进度')
              .fontSize(12)
              .fontColor('#5D3012')
            Blank()
            Text('青铜 (¥128/¥50已达标) -> 白银会员')
              .fontSize(11)
              .fontColor('#8C522B')
          }
          .width('100%')

          Row()
            .width('100%')
            .height(8)
            .backgroundColor('#E6C3B1')
            .borderRadius(4)
            .margin({ top: 8 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 12 })

        Text('🎁 4 大会员专享权益')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ left: 16, top: 8, bottom: 10 })
          .width('100%')

        Column({ space: 10 }) {
          Row() {
            Text('⚡ 20% H币购物抵扣')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .layoutWeight(1)
            Text('已激活')
              .fontSize(11)
              .fontColor('#2BC48A')
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#FFF8F5')
          .borderRadius(8)

          Row() {
            Text('🪙 消费订单 2% H币返还')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .layoutWeight(1)
            Text('已激活')
              .fontSize(11)
              .fontColor('#2BC48A')
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#FFF8F5')
          .borderRadius(8)

          Row() {
            Text('🧧 每月 20 元无门槛券包')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .layoutWeight(1)
            Text('已激活')
              .fontSize(11)
              .fontColor('#2BC48A')
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#FFF8F5')
          .borderRadius(8)
        }
        .padding({ left: 16, right: 16 })

        Button(this.vipGiftClaimed ? '今日礼包已领取' : '一键领取会员每日礼包 (5H币 + ¥10券)')
          .width('90%')
          .height(44)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor(this.vipGiftClaimed ? '#CCCCCC' : '#5D3012')
          .borderRadius(22)
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            if (!this.vipGiftClaimed) {
              this.vipGiftClaimed = true;
              this.hCoinBalance += 5.0;
              this.showToast('领取成功！已获得 5.0 H币与 ¥10 会员专属优惠券！');
            } else {
              this.showToast('您今日已领取过会员礼包，明天再来吧！');
            }
          })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 4. 我的钱包弹窗
  @Builder
  StoreWalletModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          Text('👛 我的钱包 & H币')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)

          Text('✖')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding(16)

        // 余额卡片
        Row() {
          Column() {
            Text('账户余额 (元)')
              .fontSize(11)
              .fontColor('rgba(255,255,255,0.8)')
            Text(`¥ ${this.walletBalance.toFixed(2)}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Column() {
            Text('H 币余额')
              .fontSize(11)
              .fontColor('rgba(255,255,255,0.8)')
            Text(`${this.hCoinBalance.toFixed(1)} 币`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFD700')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .padding(16)
        .linearGradient({
          angle: 135,
          colors: [['#1A1A1A', 0], ['#3A3A3A', 1]]
        })
        .borderRadius(12)
        .margin({ left: 16, right: 16, bottom: 16 })

        Text('💳 快捷充值余额')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ left: 16, bottom: 10 })
          .width('100%')

        Row({ space: 10 }) {
          ForEach([10, 50, 100, 200], (amt: number) => {
            Text(`¥${amt}`)
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.rechargeAmount === amt ? Color.White : '#1A1A1A')
              .backgroundColor(this.rechargeAmount === amt ? '#1A1A1A' : '#F2F3F5')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .borderRadius(8)
              .onClick(() => (this.rechargeAmount = amt))
          })
        }
        .padding({ left: 16, right: 16, bottom: 16 })

        Button(`立即充值 ¥${this.rechargeAmount}`)
          .width('90%')
          .height(44)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#1A1A1A')
          .borderRadius(22)
          .margin({ bottom: 20 })
          .onClick(() => {
            this.walletBalance += this.rechargeAmount;
            this.showToast(`充值成功！已为您的钱包充值 ¥${this.rechargeAmount}.00`);
          })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 5. 我的订单弹窗
  @Builder
  StoreOrdersModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          Text('📋 我的订单 & CDKEY 管理')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)

          Text('✖')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding(16)

        // Filter Tabs
        Row() {
          ForEach(['全部', '待激活', '已完成', '退款/售后'], (tab: string) => {
            Text(tab)
              .fontSize(12)
              .fontWeight(this.orderTabFilter === tab ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.orderTabFilter === tab ? '#1A1A1A' : '#888888')
              .backgroundColor(this.orderTabFilter === tab ? '#EFEFEF' : 'transparent')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .borderRadius(14)
              .onClick(() => (this.orderTabFilter = tab))
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 12 })

        Scroll() {
          Column({ space: 10 }) {
            ForEach(this.storeOrders.filter(o => this.orderTabFilter === '全部' || o.status === this.orderTabFilter), (order: OrderItem) => {
              Column() {
                Row() {
                  Text(`订单号: ${order.id}`)
                    .fontSize(11)
                    .fontColor('#888888')
                  Blank()
                  Text(order.status)
                    .fontSize(11)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(order.status === '待激活' ? '#FF9500' : (order.status === '已完成' ? '#2BC48A' : '#FF3B30'))
                }
                .width('100%')

                Row() {
                  Image(order.productImg)
                    .width(50)
                    .height(50)
                    .borderRadius(6)
                    .objectFit(ImageFit.Cover)

                  Column() {
                    Text(order.productTitle)
                      .fontSize(13)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#1A1A1A')
                    Text(`实付款: ¥${order.price} x ${order.quantity}`)
                      .fontSize(11)
                      .fontColor('#555555')
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 10 })
                  .layoutWeight(1)
                }
                .margin({ top: 8 })

                Row() {
                  Text(`🔑 激活码: ${order.cdkey}`)
                    .fontSize(11)
                    .fontColor('#1A1A1A')
                    .fontWeight(FontWeight.Bold)
                    .layoutWeight(1)

                  Text('一键复制')
                    .fontSize(11)
                    .fontColor(Color.White)
                    .backgroundColor('#1A1A1A')
                    .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                    .borderRadius(10)
                    .onClick(() => {
                      this.showToast(`已复制 CDKEY: ${order.cdkey}`);
                    })
                }
                .width('100%')
                .padding(8)
                .backgroundColor('#F0F0F2')
                .borderRadius(6)
                .margin({ top: 8 })
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#FAFAFA')
              .borderRadius(10)
            })
          }
          .padding({ left: 16, right: 16, bottom: 20 })
        }
        .constraintSize({ maxHeight: 360 })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 6. 领券中心弹窗
  @Builder
  StoreCouponsModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          Text('🧧 领券中心 · 福利专区')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)

          Text('✖')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding(16)

        Column({ space: 10 }) {
          ForEach(this.storeCoupons, (c: CouponItem) => {
            Row() {
              Column() {
                Text(c.title)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF3B30')
                Text(c.discountDesc)
                  .fontSize(11)
                  .fontColor('#666666')
                  .margin({ top: 4 })
                Text(`有效期至 ${c.expireDate}`)
                  .fontSize(9)
                  .fontColor('#999999')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text(c.claimed ? '已领取' : '立即领取')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(c.claimed ? '#999999' : Color.White)
                .backgroundColor(c.claimed ? '#E0E0E0' : '#FF3B30')
                .padding({ left: 14, right: 14, top: 6, bottom: 6 })
                .borderRadius(14)
                .onClick(() => {
                  if (!c.claimed) {
                    c.claimed = true;
                    this.showToast(`成功领取《${c.title}》！`);
                  }
                })
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#FFF5F5')
            .borderRadius(10)
          })
        }
        .padding({ left: 16, right: 16 })

        Button('一键全领优惠券')
          .width('90%')
          .height(44)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor('#FF3B30')
          .borderRadius(22)
          .margin({ top: 16, bottom: 20 })
          .onClick(() => {
            this.storeCoupons.forEach(c => (c.claimed = true));
            this.showToast('成功一键领取所有优惠券！');
          })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 7. 购物车弹窗
  @Builder
  StoreCartModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          Text('🛒 我的购物车')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)

          Text('✖')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding(16)

        if (this.cartItems.length === 0) {
          Column() {
            Text('🛒 购物车空空如也~')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 40, bottom: 40 })
          }
          .width('100%')
        } else {
          Scroll() {
            Column({ space: 10 }) {
              ForEach(this.cartItems, (item: CartItem) => {
                Row() {
                  Text(item.selected ? '☑' : '☐')
                    .fontSize(18)
                    .fontColor(item.selected ? '#FF3B30' : '#CCCCCC')
                    .onClick(() => (item.selected = !item.selected))

                  Image(item.product.coverImg)
                    .width(44)
                    .height(44)
                    .borderRadius(6)
                    .objectFit(ImageFit.Cover)
                    .margin({ left: 8 })

                  Column() {
                    Text(item.product.title)
                      .fontSize(13)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#1A1A1A')
                      .maxLines(1)
                    Text(`单价: ¥${item.product.price}`)
                      .fontSize(11)
                      .fontColor('#FF3B30')
                      .margin({ top: 2 })
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 8 })
                  .layoutWeight(1)

                  Row({ space: 8 }) {
                    Text('-')
                      .fontSize(14)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                      .backgroundColor('#EFEFEF')
                      .borderRadius(4)
                      .onClick(() => {
                        if (item.quantity > 1) {
                          item.quantity -= 1;
                        } else {
                          this.cartItems = this.cartItems.filter(ci => ci.product.id !== item.product.id);
                        }
                      })

                    Text(`${item.quantity}`)
                      .fontSize(13)
                      .fontWeight(FontWeight.Bold)

                    Text('+')
                      .fontSize(14)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                      .backgroundColor('#EFEFEF')
                      .borderRadius(4)
                      .onClick(() => (item.quantity += 1))
                  }
                }
                .width('100%')
                .padding(10)
                .backgroundColor('#FAFAFA')
                .borderRadius(8)
              })
            }
            .padding({ left: 16, right: 16 })
          }
          .constraintSize({ maxHeight: 260 })

          Row() {
            Text('合计: ')
              .fontSize(13)
              .fontColor('#666666')
            Text(`¥ ${this.cartItems.filter(i => i.selected).reduce((sum, item) => sum + item.product.price * item.quantity, 0)}`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF3B30')
            Blank()

            Button('去结算')
              .type(ButtonType.Normal)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .backgroundColor('#FF3B30')
              .borderRadius(20)
              .height(40)
              .padding({ left: 24, right: 24 })
              .onClick(() => this.checkoutCart())
          }
          .width('100%')
          .padding(16)
          .border({ width: { top: 1 }, color: '#F0F0F0' })
        }
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 8. 游戏厂商名册弹窗
  @Builder
  StorePublishersModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.activeStoreModal = ''))

      Column() {
        Row() {
          Text('🎮 官方合作游戏厂商馆')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)

          Text('✖')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.activeStoreModal = ''))
        }
        .width('100%')
        .padding(16)

        Grid() {
          ForEach(this.storePublishers, (pub: PublisherItem) => {
            GridItem() {
              Column() {
                Text(pub.logoIcon)
                  .fontSize(24)
                Text(pub.name)
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .margin({ top: 4 })
                Text(pub.desc)
                  .fontSize(9)
                  .fontColor('#888888')
                  .margin({ top: 2 })
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#F8F9FA')
              .borderRadius(10)
              .onClick(() => {
                this.selectedPublisher = pub.name;
                this.activeStoreModal = '';
                this.showToast(`已为您筛选 ${pub.name} 旗下所有商品`);
              })
            }
          })
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .padding({ left: 16, right: 16, bottom: 20 })
        .constraintSize({ maxHeight: 320 })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  // 9. 商品详情速览弹窗
  @Builder
  StoreProductDetailModalBuilder() {
    if (this.selectedStoreProduct) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.5)')
          .onClick(() => (this.activeStoreModal = ''))

        Column() {
          Stack({ alignContent: Alignment.TopEnd }) {
            Image(this.selectedStoreProduct.coverImg)
              .width('100%')
              .height(160)
              .borderRadius({ topLeft: 16, topRight: 16 })
              .objectFit(ImageFit.Cover)

            Text('✖')
              .fontSize(16)
              .fontColor(Color.White)
              .backgroundColor('rgba(0,0,0,0.6)')
              .padding(8)
              .borderRadius(16)
              .margin({ top: 12, right: 12 })
              .onClick(() => (this.activeStoreModal = ''))
          }

          Column() {
            Row() {
              Text(this.selectedStoreProduct.platform)
                .fontSize(10)
                .fontColor('#FFFFFF')
                .backgroundColor('#1A1A1A')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(4)

              Text(`库存: ${this.selectedStoreProduct.stock}件`)
                .fontSize(11)
                .fontColor('#2BC48A')
                .margin({ left: 8 })

              Blank()

              Text(`厂商: ${this.selectedStoreProduct.publisher}`)
                .fontSize(11)
                .fontColor('#888888')
            }
            .width('100%')

            Text(this.selectedStoreProduct.title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .margin({ top: 8 })

            Text(this.selectedStoreProduct.description)
              .fontSize(12)
              .fontColor('#666666')
              .lineHeight(18)
              .margin({ top: 8 })

            Row() {
              Text(`¥ ${this.selectedStoreProduct.price}`)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF3B30')

              if (this.selectedStoreProduct.originalPrice) {
                Text(`¥${this.selectedStoreProduct.originalPrice}`)
                  .fontSize(12)
                  .fontColor('#999999')
                  .decoration({ type: TextDecorationType.LineThrough })
                  .margin({ left: 6 })
              }

              Text(this.selectedStoreProduct.couponTag ?? '史低特惠')
                .fontSize(10)
                .fontColor('#FF9500')
                .border({ width: 1, color: '#FF9500' })
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(4)
                .margin({ left: 8 })
            }
            .margin({ top: 12 })

            Row({ space: 12 }) {
              Button('加入购物车')
                .type(ButtonType.Normal)
                .layoutWeight(1)
                .height(42)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .backgroundColor('#F0F0F2')
                .borderRadius(21)
                .onClick(() => {
                  if (this.selectedStoreProduct) {
                    this.addToCart(this.selectedStoreProduct);
                  }
                })

              Button('立即购买')
                .type(ButtonType.Normal)
                .layoutWeight(1)
                .height(42)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .backgroundColor('#FF3B30')
                .borderRadius(21)
                .onClick(() => {
                  if (this.selectedStoreProduct) {
                    this.buyProductNow(this.selectedStoreProduct);
                  }
                })
            }
            .margin({ top: 20, bottom: 20 })
          }
          .alignItems(HorizontalAlign.Start)
          .padding(16)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius({ topLeft: 16, topRight: 16 })
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  FreeGamePageOverlayBuilder() {
    Column() {
      // Header
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#1A1A1A')
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.activeNavPage = ''))

        Text('喜加一 · 限时福利发放')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      Scroll() {
        Column() {
          // 本期焦点免费大卡片
          Stack({ alignContent: Alignment.Bottom }) {
            Image($r('app.media.rise'))
              .width('100%')
              .height(180)
              .objectFit(ImageFit.Cover)
              .borderRadius(12)

            Row() {
              Column() {
                Text('🎁 本期 Epic/Steam 联合限免大作')
                  .fontSize(12)
                  .fontColor('#FFD700')
                  .fontWeight(FontWeight.Bold)
                Text('《古墓丽影：崛起》20周年纪念版')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('免费领取')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .backgroundColor('#FF3B30')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .borderRadius(16)
                .onClick(() => this.goDetail('rise-of-tomb-raider'))
            }
            .width('100%')
            .padding(14)
            .linearGradient({
              angle: 180,
              colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.85)', 1]]
            })
            .borderRadius({ bottomLeft: 12, bottomRight: 12 })
          }
          .width('100%')
          .margin({ top: 12, bottom: 16 })

          Text('🎮 正在派送中 (3款可领)')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ bottom: 12 })
            .width('100%')

          // 免费列表 Item 1
          Row() {
            Image($r('app.media.rise'))
              .width(90)
              .height(56)
              .borderRadius(6)
              .objectFit(ImageFit.Cover)

            Column() {
              Text('古墓丽影：崛起')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Row() {
                Text('¥ 0')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF3B30')
                Text('¥147')
                  .fontSize(11)
                  .fontColor('#999999')
                  .decoration({ type: TextDecorationType.LineThrough })
                  .margin({ left: 4 })
              }
              .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 10 })
            .layoutWeight(1)

            Button('一键领取')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#2BC48A')
              .borderRadius(14)
              .height(30)
              .onClick(() => this.goDetail('rise-of-tomb-raider'))
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .margin({ bottom: 10 })

          // 免费列表 Item 2
          Row() {
            Column() {
              Text('死亡与税赋 独家Key派发')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('小黑盒社区福利抽奖 1000 份发放')
                .fontSize(11)
                .fontColor('#888888')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Button('参与抽奖')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor('#1A1A1A')
              .backgroundColor('#F0F0F2')
              .borderRadius(14)
              .height(30)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .width('100%')
        .padding({ left: 14, right: 14, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }

  @Builder
  TournamentPageOverlayBuilder() {
    Column() {
      // Header
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor(Color.White)
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.activeNavPage = ''))

        Text('赛事中心 · E-Sports Hub')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor('#121314')

      Scroll() {
        Column() {
          // 直播大屏卡片
          Column() {
            Row() {
              Text('🔴 LIVE 直播中')
                .fontSize(10)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .backgroundColor('#FF3B30')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(4)
              Blank()
              Text('🔥 158.4万人 在看')
                .fontSize(11)
                .fontColor('#FFD700')
            }
            .width('100%')

            Text('CS2 2026 哥本哈根 Major 决赛')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ top: 10 })

            Row() {
              Text('小黑盒 Gaming')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text(' 14 : 12 ')
                .fontSize(20)
                .fontWeight(FontWeight.Bolder)
                .fontColor('#FF7A00')
                .margin({ left: 12, right: 12 })
              Text('欧皇 Team')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
            }
            .margin({ top: 14 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1E2022')
          .borderRadius(12)
          .margin({ top: 12, bottom: 16 })

          Text('🏆 热门赛事赛程预告')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ bottom: 12 })
            .width('100%')

          Row() {
            Column() {
              Text('街头霸王6 · 盒友杯淘汰赛')
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('明日 20:00 · BO5 抢三决赛')
                .fontSize(10)
                .fontColor('#999999')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Text('竞猜押注 >')
              .fontSize(12)
              .fontColor('#FF7A00')
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#1E2022')
          .borderRadius(10)
        }
        .width('100%')
        .padding({ left: 14, right: 14, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#121314')
  }

  @Builder
  VoicePageOverlayBuilder() {
    Column() {
      // Header
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#1A1A1A')
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.activeNavPage = ''))

        Text('黑盒语音 · AI 免费超清降噪')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      Scroll() {
        Column() {
          // AI 降噪状态面板
          Row() {
            Text('🎙️')
              .fontSize(28)
            Column() {
              Text('黑盒 AI 3.0 神经降噪已开启')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('采样率 48kHz · 延迟 <15ms · 智能过滤键盘麦噪')
                .fontSize(10)
                .fontColor('#2BC48A')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 10 })
            .layoutWeight(1)
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#E8F8F1')
          .borderRadius(12)
          .margin({ top: 12, bottom: 16 })

          Text('🔊 热门开黑组队房间')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ bottom: 12 })
            .width('100%')

          // 房间 1
          Row() {
            Column() {
              Text('【幻兽帕鲁】雪山据点四金战队缺1人')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('在线 3/4 人 · 自由麦 · 氛围融洽')
                .fontSize(11)
                .fontColor('#888888')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Button('一键进房')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#2BC48A')
              .borderRadius(14)
              .height(30)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .margin({ bottom: 10 })

          // 房间 2
          Row() {
            Column() {
              Text('【链在一起】高难跳跃 求心态好大佬')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('在线 1/2 人 · 按键说话')
                .fontSize(11)
                .fontColor('#888888')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Button('一键进房')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor('#1A1A1A')
              .backgroundColor('#F0F0F2')
              .borderRadius(14)
              .height(30)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .width('100%')
        .padding({ left: 14, right: 14, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#F8F9FA')
  }
}

