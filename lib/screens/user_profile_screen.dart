import 'package:flutter/material.dart';
import '../utils/follow_state.dart';
import '../widgets/animated_follow_button.dart';
import '../widgets/animated_like_button.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  final String avatarUrl;
  final String signature;
  final String followers;
  final String following;
  final String likes;
  final bool initialIsFollowing;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.avatarUrl,
    this.signature = '这个人很懒，什么都没有留下~',
    this.followers = '0',
    this.following = '0',
    this.likes = '0',
    this.initialIsFollowing = false,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late bool _isFollowing;
  late String _followersDisplay;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.initialIsFollowing;
    _followersDisplay = _formatFollowersCount(widget.followers, _isFollowing);
    _loadFollowState();
    FollowState().addListener(_onFollowStateChanged);
  }

  @override
  void dispose() {
    FollowState().removeListener(_onFollowStateChanged);
    super.dispose();
  }

  Future<void> _loadFollowState() async {
    await FollowState().ensureLoaded();
    if (!mounted) return;
    setState(() {
      _isFollowing = FollowState().isFollowing(widget.username);
      _followersDisplay = _formatFollowersCount(widget.followers, _isFollowing);
    });
  }

  void _onFollowStateChanged() {
    if (!mounted) return;
    final following = FollowState().isFollowing(widget.username);
    setState(() {
      _isFollowing = following;
      _followersDisplay = _formatFollowersCount(widget.followers, following);
    });
  }

  int _parseFollowersCount(String raw) {
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.endsWith('k')) {
      final base = double.tryParse(trimmed.replaceAll('k', '')) ?? 0;
      return (base * 1000).round();
    }
    return int.tryParse(trimmed) ?? 0;
  }

  String _formatFollowersCount(String raw, bool isFollowing) {
    final base = _parseFollowersCount(raw);
    final adjusted = base -
        (widget.initialIsFollowing ? 1 : 0) +
        (isFollowing ? 1 : 0);
    if (adjusted >= 1000) {
      final k = adjusted / 1000;
      return k == k.roundToDouble() ? '${k.toInt()}k' : '${k.toStringAsFixed(1)}k';
    }
    return '$adjusted';
  }

  Future<void> _toggleFollow() async {
    final next = await FollowState().toggle(widget.username);
    if (!mounted) return;
    setState(() {
      _isFollowing = next;
      _followersDisplay = _formatFollowersCount(widget.followers, next);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(next ? '已关注 ${widget.username}' : '已取消关注'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                _buildBottomSheetItem(
                  context,
                  Icons.block_outlined,
                  '拉黑',
                  const Color(0xFFF5222D),
                  () {
                    Navigator.pop(context);
                    _showConfirmDialog(
                      context,
                      '拉黑用户',
                      '确定要拉黑该用户吗？拉黑后将不再看到对方的动态',
                      () {},
                    );
                  },
                ),
                _buildBottomSheetItem(
                  context,
                  Icons.report_outlined,
                  '举报',
                  const Color(0xFFFAAD14),
                  () {
                    Navigator.pop(context);
                    _showReportDialog(context);
                  },
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  color: const Color(0xFFF7F8F8),
                ),
                _buildBottomSheetItem(
                  context,
                  Icons.close,
                  '取消',
                  const Color(0xFF666666),
                  () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '举报原因',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _buildReportOption('垃圾广告'),
                _buildReportOption('色情低俗'),
                _buildReportOption('违法违规'),
                _buildReportOption('侵权'),
                _buildReportOption('其他'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportOption(String text) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('举报已提交，我们会尽快处理')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5222D),
                        ),
                        child: const Text('确定'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF9D31FF),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context, _isFollowing),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () => _showMoreOptions(context),
                ),
              ),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF9D31FF),
                    Color(0xFFF260FF),
                    Color(0xFFFF609F),
                  ],
                ),
              ),
              child: const SafeArea(
                child: Center(
                  child: Text(
                    '用户主页',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 用户信息头部
          SliverToBoxAdapter(
            child: _buildProfileHeader(),
          ),

          // 用户动态列表
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _getUserMoments(widget.username),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9D31FF),
            Color(0xFFF260FF),
            Color(0xFFFF609F),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        children: [
          // 用户信息
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.avatarUrl.startsWith('assets/')
                      ? Image.asset(
                          widget.avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.white,
                            child: const Icon(Icons.person, size: 40),
                          ),
                        )
                      : Image.network(
                          widget.avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.white,
                            child: const Icon(Icons.person, size: 40),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedFollowButton(
                          isFollowing: _isFollowing,
                          onTap: _toggleFollow,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          fontSize: 13,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.signature,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 统计数据 - 简洁文字样式
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItemSimple(_followersDisplay, '粉丝'),
              Container(
                width: 1,
                height: 20,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItemSimple(widget.following, '关注'),
              Container(
                width: 1,
                height: 20,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItemSimple(widget.likes, '获赞'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItemSimple(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _getUserMoments(String username) {
    // 根据用户名返回不同的动态内容
    final momentsData = _getMomentsDataByUsername(username);
    return momentsData.map((moment) => _buildMomentCard(
      moment['time']!,
      moment['location']!,
      moment['category']!,
      moment['content']!,
      moment['imageCount'] as int,
      moment['likes']!,
      moment['comments']!,
      moment['isLiked'] as bool,
    )).toList();
  }

  List<Map<String, dynamic>> _getMomentsDataByUsername(String username) {
    // 为不同用户定义不同的动态内容
    switch (username) {
      case '旅行摄影师小王':
        return [
          {
            'time': '3小时前',
            'location': '张家界·天门山',
            'category': '城市美景',
            'content': '天门山的玻璃栈道，脚下是万丈深渊，云雾缭绕，惊险刺激又美不胜收！🏔️',
            'imageCount': 3,
            'likes': '892',
            'comments': '67',
            'isLiked': false,
          },
          {
            'time': '1天前',
            'location': '黄山·迎客松',
            'category': '城市美景',
            'content': '黄山归来不看岳，迎客松的姿态真的太优雅了。日出时分，云海翻腾，美得像仙境 ☁️🌄',
            'imageCount': 2,
            'likes': '1.2k',
            'comments': '89',
            'isLiked': true,
          },
        ];
      case '美食探索家':
        return [
          {
            'time': '2小时前',
            'location': '上海·南京路',
            'category': '城市美食',
            'content': '上海小笼包，皮薄馅大，汤汁鲜美。一口咬下去，满满的幸福感 🥟😋',
            'imageCount': 2,
            'likes': '756',
            'comments': '54',
            'isLiked': false,
          },
          {
            'time': '5小时前',
            'location': '武汉·户部巷',
            'category': '城市美食',
            'content': '热干面配豆皮，武汉的早餐文化真的太丰富了！每一口都是地道的武汉味道 🍜',
            'imageCount': 1,
            'likes': '623',
            'comments': '41',
            'isLiked': true,
          },
          {
            'time': '2天前',
            'location': '长沙·坡子街',
            'category': '城市美食',
            'content': '长沙臭豆腐，闻着臭吃着香！配上辣椒酱，简直绝配。来长沙必吃 🌶️',
            'imageCount': 2,
            'likes': '834',
            'comments': '72',
            'isLiked': false,
          },
        ];
      case '文化行者':
        return [
          {
            'time': '4小时前',
            'location': '洛阳·龙门石窟',
            'category': '特色文化',
            'content': '龙门石窟的佛像雕刻精美绝伦，每一尊都承载着千年的历史。站在这里，感受到文化的厚重 🙏',
            'imageCount': 3,
            'likes': '945',
            'comments': '63',
            'isLiked': true,
          },
          {
            'time': '1天前',
            'location': '敦煌·莫高窟',
            'category': '特色文化',
            'content': '莫高窟的壁画色彩依然鲜艳，飞天的姿态优美动人。丝绸之路的文化瑰宝 🎨',
            'imageCount': 2,
            'likes': '1.1k',
            'comments': '78',
            'isLiked': false,
          },
        ];
      case '园林爱好者':
        return [
          {
            'time': '5小时前',
            'location': '扬州·瘦西湖',
            'category': '特色文化',
            'content': '瘦西湖的柳树依依，小桥流水，亭台楼阁。江南园林的精致与雅致在这里展现得淋漓尽致 🌿',
            'imageCount': 2,
            'likes': '678',
            'comments': '45',
            'isLiked': false,
          },
          {
            'time': '2天前',
            'location': '无锡·寄畅园',
            'category': '特色文化',
            'content': '寄畅园虽小，但布局精巧，移步换景。每一处都是精心设计，体现了造园艺术的高超 🏞️',
            'imageCount': 3,
            'likes': '523',
            'comments': '38',
            'isLiked': true,
          },
        ];
      case '节日记录者':
        return [
          {
            'time': '6小时前',
            'location': '凤凰·古城',
            'category': '节日活动',
            'content': '凤凰古城的夜晚，沱江两岸灯火辉煌，吊脚楼倒映在水中，美得如诗如画 🏮✨',
            'imageCount': 2,
            'likes': '1.3k',
            'comments': '92',
            'isLiked': true,
          },
          {
            'time': '1天前',
            'location': '哈尔滨·冰雪大世界',
            'category': '节日活动',
            'content': '冰雪大世界的冰雕艺术太震撼了！五彩斑斓的灯光照射下，冰雕晶莹剔透 ❄️🎆',
            'imageCount': 3,
            'likes': '1.5k',
            'comments': '108',
            'isLiked': false,
          },
        ];
      case '山水画师':
        return [
          {
            'time': '4小时前',
            'location': '九寨沟·五花海',
            'category': '城市美景',
            'content': '五花海的水色变幻莫测，蓝绿交织，清澈见底。大自然的调色板，美得不真实 💙💚',
            'imageCount': 2,
            'likes': '1.8k',
            'comments': '134',
            'isLiked': true,
          },
          {
            'time': '2天前',
            'location': '张掖·丹霞地貌',
            'category': '城市美景',
            'content': '张掖丹霞的色彩层次分明，红黄绿相间，像是上帝打翻的调色盘。震撼人心 🎨🏔️',
            'imageCount': 3,
            'likes': '2.1k',
            'comments': '156',
            'isLiked': false,
          },
        ];
      case '京城食客':
        return [
          {
            'time': '3小时前',
            'location': '北京·簋街',
            'category': '城市美食',
            'content': '簋街的小龙虾，麻辣鲜香，配上冰啤酒，夏天的夜晚就该这样度过 🦞🍺',
            'imageCount': 2,
            'likes': '967',
            'comments': '73',
            'isLiked': false,
          },
          {
            'time': '1天前',
            'location': '北京·护国寺小吃',
            'category': '城市美食',
            'content': '老北京小吃，豆汁儿、焦圈、炒肝，每一样都是童年的味道。地道的京味儿 🥘',
            'imageCount': 3,
            'likes': '834',
            'comments': '61',
            'isLiked': true,
          },
        ];
      case '古镇寻梦':
        return [
          {
            'time': '5小时前',
            'location': '周庄·古镇',
            'category': '特色文化',
            'content': '周庄的小桥流水，白墙黛瓦，乌篷船缓缓划过。江南水乡的韵味，在这里得到完美诠释 🚣',
            'imageCount': 2,
            'likes': '1.1k',
            'comments': '85',
            'isLiked': true,
          },
          {
            'time': '2天前',
            'location': '乌镇·西栅',
            'category': '特色文化',
            'content': '乌镇西栅的夜景美得让人窒息，灯光倒映在水面上，古镇焕发出别样的魅力 🌙',
            'imageCount': 3,
            'likes': '1.4k',
            'comments': '97',
            'isLiked': false,
          },
        ];
      case '海边漫步':
        return [
          {
            'time': '4小时前',
            'location': '三亚·亚龙湾',
            'category': '城市美景',
            'content': '亚龙湾的海水清澈见底，沙滩细腻柔软。躺在沙滩上晒太阳，听海浪声，太惬意了 🏖️☀️',
            'imageCount': 2,
            'likes': '1.2k',
            'comments': '89',
            'isLiked': false,
          },
          {
            'time': '1天前',
            'location': '厦门·鼓浪屿',
            'category': '城市美景',
            'content': '鼓浪屿的小巷深处，藏着许多文艺小店。海风拂面，时光在这里变得很慢 🌊🎵',
            'imageCount': 3,
            'likes': '1.5k',
            'comments': '112',
            'isLiked': true,
          },
        ];
      case '夜景猎人':
        return [
          {
            'time': '3小时前',
            'location': '上海·外滩',
            'category': '城市美景',
            'content': '外滩的夜景璀璨夺目，东方明珠塔灯光闪烁，黄浦江上游船穿梭。魔都的魅力 🌃✨',
            'imageCount': 2,
            'likes': '1.6k',
            'comments': '123',
            'isLiked': true,
          },
          {
            'time': '1天前',
            'location': '香港·维多利亚港',
            'category': '城市美景',
            'content': '维港的夜景是世界三大夜景之一，高楼林立，灯火辉煌。每次看都震撼 🏙️',
            'imageCount': 3,
            'likes': '1.9k',
            'comments': '145',
            'isLiked': false,
          },
        ];
      case '美食达人':
        return [
          {
            'time': '2小时前',
            'location': '杭州·河坊街',
            'category': '城市美食',
            'content': '杭州的龙井虾仁，茶香与虾的鲜美完美融合。还有西湖醋鱼，酸甜可口 🍤🐟',
            'imageCount': 2,
            'likes': '876',
            'comments': '68',
            'isLiked': false,
          },
          {
            'time': '1天前',
            'location': '南京·夫子庙',
            'category': '城市美食',
            'content': '南京的鸭血粉丝汤，汤鲜味美，鸭血嫩滑。配上鸭肠、鸭肝，满满一碗幸福 🍜',
            'imageCount': 1,
            'likes': '734',
            'comments': '52',
            'isLiked': true,
          },
        ];
      default:
        // 默认动态
        return [
          {
            'time': '2小时前',
            'location': '未知地点',
            'category': '城市美景',
            'content': '分享生活中的美好瞬间 ✨',
            'imageCount': 1,
            'likes': '123',
            'comments': '12',
            'isLiked': false,
          },
        ];
    }
  }

  Widget _buildMomentCard(
    String time,
    String location,
    String category,
    String content,
    int imageCount,
    String likes,
    String comments,
    bool initialIsLiked,
  ) {
    return _UserMomentCard(
      time: time,
      location: location,
      category: category,
      content: content,
      imageCount: imageCount,
      likes: likes,
      comments: comments,
      initialIsLiked: initialIsLiked,
      onMoreTap: () => _showMoreOptions(context),
    );
  }
}

class _UserMomentCard extends StatefulWidget {
  final String time;
  final String location;
  final String category;
  final String content;
  final int imageCount;
  final String likes;
  final String comments;
  final bool initialIsLiked;
  final VoidCallback onMoreTap;

  const _UserMomentCard({
    required this.time,
    required this.location,
    required this.category,
    required this.content,
    required this.imageCount,
    required this.likes,
    required this.comments,
    required this.initialIsLiked,
    required this.onMoreTap,
  });

  @override
  State<_UserMomentCard> createState() => _UserMomentCardState();
}

class _UserMomentCardState extends State<_UserMomentCard> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialIsLiked;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 时间和位置
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: Color(0xFF999999)),
              const SizedBox(width: 4),
              Text(
                widget.time,
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.location_on, size: 12, color: Color(0xFF999999)),
              const SizedBox(width: 4),
              Text(
                widget.location,
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF9D31FF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.category,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9D31FF),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 内容
          Text(
            widget.content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (widget.imageCount > 0) ...[
            const SizedBox(height: 12),
            _buildImageGrid(widget.imageCount),
          ],
          const SizedBox(height: 12),
          // 分隔线
          Container(
            height: 1,
            color: const Color(0xFFF7F8F8),
          ),
          const SizedBox(height: 12),
          // 互动按钮
          Row(
            children: [
              // 拉黑举报按钮（最左侧）
              GestureDetector(
                onTap: widget.onMoreTap,
                child: Row(
                  children: [
                    const Icon(Icons.more_vert, size: 18, color: Color(0xFF999999)),
                    const SizedBox(width: 6),
                    const Text(
                      '更多',
                      style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 点赞和评论（右侧）
              AnimatedLikeButton(
                isLiked: _isLiked,
                onTap: _toggleLike,
                label: widget.likes,
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF999999)),
                  const SizedBox(width: 6),
                  Text(
                    widget.comments,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(int count) {
    if (count == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&q=80',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
          ),
        ),
      );
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://images.unsplash.com/photo-1528127269322-539801943592?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://images.unsplash.com/photo-1548919973-5cef591cdbc9?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200]),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
