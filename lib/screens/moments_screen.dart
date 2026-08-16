import 'package:flutter/material.dart';
import 'create_moment_screen.dart';
import 'moment_detail_screen.dart';
import 'user_profile_screen.dart';
import '../utils/follow_state.dart';
import '../widgets/animated_like_button.dart';
import '../widgets/animated_follow_button.dart';
import '../widgets/image_gallery_viewer.dart';

class MomentsScreen extends StatelessWidget {
  const MomentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 动态列表（添加顶部安全区域）
          SliverPadding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 100,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                MomentCard(
                  username: '旅行摄影师小王',
                  time: '2分钟前',
                  location: '杭州·西湖',
                  category: '城市美景',
                  content: '清晨的西湖，薄雾笼罩，宛如仙境。断桥残雪的美景让人流连忘返，这就是江南的诗意生活 🌅',
                  imageCount: 3,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=800&q=80', // 西湖美景
                    'https://images.unsplash.com/photo-1580837119756-563d608dd119?w=800&q=80', // 西湖断桥
                    'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=800&q=80', // 西湖晨雾
                  ],
                  likes: '18',
                  comments: '5',
                  initialIsLiked: true,
                  initialIsFollowing: false,
                  tagColor: const Color(0xFF9D31FF),
                  avatarUrl: 'assets/images/xw.jpg',
                  userFollowers: '156',
                  userFollowing: '89',
                  userLikes: '2.3k',
                ),
                MomentCard(
                  username: '美食探索家',
                  time: '15分钟前',
                  location: '成都·宽窄巷子',
                  category: '城市美食',
                  content: '成都的火锅真的太绝了！麻辣鲜香，每一口都是享受。推荐大家一定要试试鸳鸯锅，既能吃辣又能品尝清汤的鲜美 🍲🔥',
                  imageCount: 1,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800&q=80', // 火锅
                  ],
                  likes: '15',
                  comments: '4',
                  initialIsLiked: false,
                  initialIsFollowing: true,
                  tagColor: const Color(0xFFFF609F),
                  avatarUrl: 'assets/images/ms.jpg',
                  userFollowers: '234',
                  userFollowing: '123',
                  userLikes: '1.8k',
                ),
                MomentCard(
                  username: '园林爱好者',
                  time: '1小时前',
                  location: '苏州·拙政园',
                  category: '特色文化',
                  content: '苏州园林的精致与雅致，每一处都是艺术。移步换景，亭台楼阁、假山池沼，处处皆画。江南园林的韵味，在这里展现得淋漓尽致 🏞️🌸',
                  imageCount: 2,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1548919973-5cef591cdbc9?w=800&q=80', // 苏州园林
                    'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80', // 园林建筑
                  ],
                  likes: '12',
                  comments: '3',
                  initialIsLiked: false,
                  initialIsFollowing: false,
                  tagColor: const Color(0xFFF260FF),
                  avatarUrl: 'assets/images/yl.jpg',
                  userFollowers: '145',
                  userFollowing: '98',
                  userLikes: '1.5k',
                ),
                MomentCard(
                  username: '节日记录者',
                  time: '3小时前',
                  location: '平遥·古城',
                  category: '节日活动',
                  content: '平遥古城的春节灯会真的太震撼了！红灯笼高高挂起，整个古城都沉浸在浓浓的年味中。传统与现代的碰撞，让这个春节格外难忘 🏮✨',
                  imageCount: 0,
                  imageUrls: const [],
                  likes: '20',
                  comments: '5',
                  initialIsLiked: true,
                  initialIsFollowing: true,
                  tagColor: const Color(0xFFFF609F),
                  avatarUrl: 'assets/images/jr.jpg',
                  userFollowers: '345',
                  userFollowing: '234',
                  userLikes: '3.4k',
                ),
                MomentCard(
                  username: '山水画师',
                  time: '5小时前',
                  location: '桂林·漓江',
                  category: '城市美景',
                  content: '桂林山水甲天下，漓江的美真的无法用言语形容。乘着竹筏漂流，两岸青山绿水，宛如一幅流动的水墨画 🎨🏞️',
                  imageCount: 3,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1527004013197-933c4bb611b3?w=800&q=80', // 桂林山水
                    'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&q=80', // 漓江竹筏
                    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', // 山水倒影
                  ],
                  likes: '16',
                  comments: '4',
                  initialIsLiked: false,
                  initialIsFollowing: false,
                  tagColor: const Color(0xFF9D31FF),
                  avatarUrl: 'assets/images/ss.jpg',
                  userFollowers: '567',
                  userFollowing: '234',
                  userLikes: '4.5k',
                ),
                MomentCard(
                  username: '京城食客',
                  time: '6小时前',
                  location: '北京·前门大街',
                  category: '城市美食',
                  content: '北京烤鸭，皮脆肉嫩，配上甜面酱和葱丝，简直是人间美味！来北京一定要尝尝正宗的全聚德烤鸭 🦆😋',
                  imageCount: 2,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1625937286074-9ca519d5d9df?w=800&q=80', // 烤鸭
                    'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800&q=80', // 北京美食
                  ],
                  likes: '19',
                  comments: '5',
                  initialIsLiked: true,
                  initialIsFollowing: true,
                  tagColor: const Color(0xFFFF609F),
                  avatarUrl: 'assets/images/jc.jpg',
                  userFollowers: '789',
                  userFollowing: '456',
                  userLikes: '5.6k',
                ),
                MomentCard(
                  username: '古镇寻梦',
                  time: '8小时前',
                  location: '云南·丽江古城',
                  category: '特色文化',
                  content: '丽江古城的夜晚格外迷人，石板路上灯火通明，酒吧街传来悠扬的歌声。在这里，时间仿佛慢了下来 🌙🎶',
                  imageCount: 1,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80', // 丽江古城夜景
                  ],
                  likes: '14',
                  comments: '3',
                  initialIsLiked: false,
                  initialIsFollowing: false,
                  tagColor: const Color(0xFFF260FF),
                  avatarUrl: 'assets/images/gz.jpg',
                  userFollowers: '432',
                  userFollowing: '321',
                  userLikes: '3.2k',
                ),
                MomentCard(
                  username: '海边漫步',
                  time: '10小时前',
                  location: '青岛·栈桥',
                  category: '城市美景',
                  content: '青岛的海风带着咸咸的味道，栈桥上看日落，海鸥在身边飞舞。这座城市的浪漫，藏在每一个海边的瞬间 🌊🌅',
                  imageCount: 2,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', // 海边日落
                    'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800&q=80', // 栈桥海鸥
                  ],
                  likes: '11',
                  comments: '2',
                  initialIsLiked: false,
                  initialIsFollowing: true,
                  tagColor: const Color(0xFF9D31FF),
                  avatarUrl: 'assets/images/hb.jpg',
                  userFollowers: '234',
                  userFollowing: '189',
                  userLikes: '2.1k',
                ),
                MomentCard(
                  username: '夜景猎人',
                  time: '12小时前',
                  location: '重庆·洪崖洞',
                  category: '城市美景',
                  content: '重庆的夜景真的太美了！洪崖洞的灯光璀璨夺目，嘉陵江畔的夜色让人沉醉。这座8D魔幻城市，每一个角度都是惊喜 🌃✨',
                  imageCount: 3,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1548919973-5cef591cdbc9?w=800&q=80', // 重庆夜景
                    'https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=800&q=80', // 城市灯光
                    'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800&q=80', // 江边夜色
                  ],
                  likes: '17',
                  comments: '4',
                  initialIsLiked: true,
                  initialIsFollowing: false,
                  tagColor: const Color(0xFF9D31FF),
                  avatarUrl: 'assets/images/yj.jpg',
                  userFollowers: '891',
                  userFollowing: '567',
                  userLikes: '6.7k',
                ),
                MomentCard(
                  username: '美食达人',
                  time: '1天前',
                  location: '广州·上下九',
                  category: '城市美食',
                  content: '广州早茶文化真的太精致了！虾饺、烧卖、叉烧包，每一样都是艺术品。一盅两件，慢慢品味，这就是广式生活 🍵🥟',
                  imageCount: 3,
                  imageUrls: const [
                    'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=800&q=80', // 点心
                    'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=800&q=80', // 茶具
                    'https://images.unsplash.com/photo-1583037189850-1921ae7c6c22?w=800&q=80', // 早茶
                  ],
                  likes: '13',
                  comments: '3',
                  initialIsLiked: false,
                  initialIsFollowing: false,
                  tagColor: const Color(0xFFFF609F),
                  avatarUrl: 'assets/images/msdr.jpg',
                  userFollowers: '678',
                  userFollowing: '345',
                  userLikes: '4.3k',
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateMomentScreen(),
            ),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9D31FF),
                Color(0xFFF260FF),
                Color(0xFFFF609F),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9D31FF).withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class MomentCard extends StatefulWidget {
  final String username;
  final String time;
  final String location;
  final String category;
  final String content;
  final int imageCount;
  final List<String> imageUrls;
  final String likes;
  final String comments;
  final bool initialIsLiked;
  final bool initialIsFollowing;
  final Color tagColor;
  final String avatarUrl;
  final String userFollowers;
  final String userFollowing;
  final String userLikes;

  const MomentCard({
    super.key,
    required this.username,
    required this.time,
    required this.location,
    required this.category,
    required this.content,
    required this.imageCount,
    required this.imageUrls,
    required this.likes,
    required this.comments,
    required this.initialIsLiked,
    required this.initialIsFollowing,
    required this.tagColor,
    required this.avatarUrl,
    required this.userFollowers,
    required this.userFollowing,
    required this.userLikes,
  });

  @override
  State<MomentCard> createState() => _MomentCardState();
}

class _MomentCardState extends State<MomentCard> {
  late bool _isLiked;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialIsLiked;
    _isFollowing = widget.initialIsFollowing;
    _syncFollowState();
    FollowState().addListener(_onFollowStateChanged);
  }

  @override
  void dispose() {
    FollowState().removeListener(_onFollowStateChanged);
    super.dispose();
  }

  Future<void> _syncFollowState() async {
    await FollowState().ensureLoaded();
    if (!mounted) return;
    setState(() {
      _isFollowing = FollowState().isFollowing(widget.username);
    });
  }

  void _onFollowStateChanged() {
    if (!mounted) return;
    setState(() {
      _isFollowing = FollowState().isFollowing(widget.username);
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  Future<void> _toggleFollow() async {
    await FollowState().toggle(widget.username);
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
                  },
                ),
                _buildBottomSheetItem(
                  context,
                  Icons.report_outlined,
                  '举报',
                  const Color(0xFFFAAD14),
                  () {
                    Navigator.pop(context);
                  },
                ),
                _buildBottomSheetItem(
                  context,
                  Icons.visibility_off_outlined,
                  '屏蔽',
                  const Color(0xFF666666),
                  () {
                    Navigator.pop(context);
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MomentDetailScreen(
              isMyMoment: false,
              username: widget.username,
              time: widget.time,
              location: widget.location,
              category: widget.category,
              content: widget.content,
              imageCount: widget.imageCount,
              imageUrls: widget.imageUrls,
              likes: widget.likes,
              comments: widget.comments,
              initialIsLiked: _isLiked,
              initialIsFollowing: _isFollowing,
              tagColor: widget.tagColor,
              avatarUrl: widget.avatarUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
            // 用户信息
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          username: widget.username,
                          avatarUrl: widget.avatarUrl,
                          signature: '用镜头记录世界，用文字分享故事 ✨',
                          followers: widget.userFollowers,
                          following: widget.userFollowing,
                          likes: widget.userLikes,
                          initialIsFollowing: _isFollowing,
                        ),
                      ),
                    );
                    if (mounted) {
                      setState(() {
                        _isFollowing =
                            FollowState().isFollowing(widget.username);
                      });
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: ClipOval(
                      child: widget.avatarUrl.startsWith('assets/')
                          ? Image.asset(
                              widget.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person),
                            )
                          : Image.network(
                              widget.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 12, color: Color(0xFF999999)),
                          const SizedBox(width: 4),
                          Text(
                            widget.time,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF999999)),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.location_on,
                              size: 12, color: Color(0xFF999999)),
                          const SizedBox(width: 4),
                          Text(
                            widget.location,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF999999)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedFollowButton(
                  isFollowing: _isFollowing,
                  onTap: _toggleFollow,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: widget.tagColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: widget.tagColor,
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
                // 更多按钮（最左侧）
                GestureDetector(
                  onTap: () => _showMoreOptions(context),
                  child: Row(
                    children: [
                      const Icon(Icons.more_vert,
                          size: 18, color: Color(0xFF999999)),
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
                    const Icon(Icons.chat_bubble_outline,
                        size: 18, color: Color(0xFF999999)),
                    const SizedBox(width: 6),
                    Text(
                      widget.comments,
                      style:
                          const TextStyle(fontSize: 14, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(int count) {
    if (count == 0 || widget.imageUrls.isEmpty) return const SizedBox.shrink();

    final urls = widget.imageUrls;
    final content = widget.content;
    final username = widget.username;

    if (count == 1) {
      return buildTappableGalleryImage(
        context: context,
        allUrls: urls,
        index: 0,
        imageUrl: urls[0],
        aspectRatio: 16 / 9,
        borderRadius: 8,
        content: content,
        username: username,
      );
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(
            child: buildTappableGalleryImage(
              context: context,
              allUrls: urls,
              index: 0,
              imageUrl: urls[0],
              aspectRatio: 1,
              borderRadius: 8,
              content: content,
              username: username,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildTappableGalleryImage(
              context: context,
              allUrls: urls,
              index: 1,
              imageUrl: urls.length > 1 ? urls[1] : urls[0],
              aspectRatio: 1,
              borderRadius: 8,
              content: content,
              username: username,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: buildTappableGalleryImage(
              context: context,
              allUrls: urls,
              index: 0,
              imageUrl: urls[0],
              aspectRatio: 1,
              borderRadius: 8,
              content: content,
              username: username,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildTappableGalleryImage(
              context: context,
              allUrls: urls,
              index: 1,
              imageUrl: urls.length > 1 ? urls[1] : urls[0],
              aspectRatio: 1,
              borderRadius: 8,
              content: content,
              username: username,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildTappableGalleryImage(
              context: context,
              allUrls: urls,
              index: 2,
              imageUrl: urls.length > 2 ? urls[2] : urls[0],
              aspectRatio: 1,
              borderRadius: 8,
              content: content,
              username: username,
            ),
          ),
        ],
      );
    }
  }
}
