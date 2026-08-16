import 'package:flutter/material.dart';
import 'featured_detail_screen.dart';
import 'scene_detail_screen.dart';

class _FeaturedItem {
  final String title;
  final String nickname;
  final String avatarAsset;
  final String imageUrl;

  const _FeaturedItem({
    required this.title,
    required this.nickname,
    required this.avatarAsset,
    required this.imageUrl,
  });
}

/// 特色精选：亚洲面孔本地头像 + 用户风格自定义昵称
const _featuredItems = [
  _FeaturedItem(
    title: '成都火锅的麻辣诱惑',
    nickname: '小鱼爱吃辣',
    avatarAsset: 'assets/images/ms.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400&q=80',
  ),
  _FeaturedItem(
    title: '苏州园林的诗意江南',
    nickname: '江南烟雨',
    avatarAsset: 'assets/images/yl.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=400&q=80',
  ),
  _FeaturedItem(
    title: '西安古城墙的历史印记',
    nickname: '阿哲在路上',
    avatarAsset: 'assets/images/xw.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1528127269322-539801943592?w=400&q=80',
  ),
  _FeaturedItem(
    title: '平遥古城的春节灯会',
    nickname: '阿宁逛灯会',
    avatarAsset: 'assets/images/jr.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?w=400&q=80',
  ),
  _FeaturedItem(
    title: '广州早茶的精致生活',
    nickname: '小陈饮早茶',
    avatarAsset: 'assets/images/msdr.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=80',
  ),
  _FeaturedItem(
    title: '青岛海滨的浪漫时光',
    nickname: '海风里的她',
    avatarAsset: 'assets/images/hb.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1534850336045-c6c6d287f89e?w=400&q=80',
  ),
  _FeaturedItem(
    title: '重庆夜景的璀璨光影',
    nickname: '山城阿杰',
    avatarAsset: 'assets/images/yj.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=400&q=80',
  ),
  _FeaturedItem(
    title: '云南丽江的古镇风情',
    nickname: '丽江小雨',
    avatarAsset: 'assets/images/gz.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=400&q=80',
  ),
  _FeaturedItem(
    title: '北京烤鸭的传统工艺',
    nickname: '老李品京味',
    avatarAsset: 'assets/images/jc.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400&q=80',
  ),
  _FeaturedItem(
    title: '桂林山水的水墨画卷',
    nickname: '丹青绘山水',
    avatarAsset: 'assets/images/ss.jpg',
    imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400&q=80',
  ),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部图片（跟随滚动）
          SliverToBoxAdapter(
            child: _buildHeroBanner(),
          ),
          // 景色专栏标题
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '景色专栏',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          
          // 景色专栏
          SliverToBoxAdapter(
            child: Builder(
              builder: (context) => _buildSceneGrid(context),
            ),
          ),
          
          // 特色精选标题
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                '特色精选',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          
          // 特色精选网格
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: Builder(
              builder: (context) => SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.71,
                ),
                delegate: SliverChildListDelegate(
                  _featuredItems
                      .map((item) => _buildFeaturedCard(context, item))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // 纯净的图片，无遮罩和文字
            Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/syimg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 状态栏安全区域（保留半透明遮罩以确保状态栏可见）
            Container(
              height: MediaQuery.of(context).padding.top,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSceneGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧大图
          Expanded(
            flex: 212,
            child: _buildSceneCard(
              context,
              'assets/images/imgxinjiang.jpg',
              '新疆｜秋季喀纳斯',
              278,
              isAsset: true,
            ),
          ),
          const SizedBox(width: 8),
          // 右侧三张小图
          Expanded(
            flex: 132,
            child: Column(
              children: [
                _buildSceneCard(
                  context,
                  'assets/images/imgxizang.jpg',
                  '西藏｜雪山圣湖',
                  88,
                  isAsset: true,
                ),
                const SizedBox(height: 8),
                _buildSceneCard(
                  context,
                  'assets/images/imgfujian.jpg',
                  '福建｜闽南土楼',
                  88,
                  isAsset: true,
                ),
                const SizedBox(height: 8),
                _buildSceneCard(
                  context,
                  'assets/images/imgguangxi.jpg',
                  '广西｜漓江山水',
                  88,
                  isAsset: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneCard(BuildContext context, String imageUrl, String label, double height, {bool isAsset = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SceneDetailScreen(
              title: label,
              location: _extractLocation(label),
              imageUrl: imageUrl,
              isAsset: isAsset,
            ),
          ),
        );
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: isAsset ? AssetImage(imageUrl) as ImageProvider : NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _extractLocation(String label) {
    // 从标签中提取位置信息
    if (label.contains('｜')) {
      return label.split('｜')[0];
    }
    return label;
  }

  Widget _buildFeaturedCard(BuildContext context, _FeaturedItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeaturedDetailScreen(
              title: item.title,
              author: item.nickname,
              imageUrl: item.imageUrl,
              location: _getLocationFromTitle(item.title),
              category: _getCategoryFromTitle(item.title),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            // 图片 - 1:1 比例（正方形）
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 内容
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // 用户信息：本地亚洲面孔头像 + 自定义昵称
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE8E8E8),
                            width: 0.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            item.avatarAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 12, color: Color(0xFF999999)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.nickname,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocationFromTitle(String title) {
    if (title.contains('成都')) return '成都·宽窄巷子';
    if (title.contains('苏州')) return '苏州·拙政园';
    if (title.contains('西安')) return '西安·古城墙';
    if (title.contains('平遥')) return '平遥·古城';
    if (title.contains('广州')) return '广州·上下九';
    if (title.contains('青岛')) return '青岛·栈桥';
    if (title.contains('重庆')) return '重庆·洪崖洞';
    if (title.contains('丽江')) return '云南·丽江古城';
    if (title.contains('北京')) return '北京·前门大街';
    if (title.contains('桂林')) return '桂林·漓江';
    return '中国';
  }

  String _getCategoryFromTitle(String title) {
    if (title.contains('火锅') || title.contains('早茶') || title.contains('烤鸭')) return '城市美食';
    if (title.contains('园林') || title.contains('古城') || title.contains('古镇')) return '特色文化';
    if (title.contains('夜景') || title.contains('山水') || title.contains('海滨')) return '城市美景';
    if (title.contains('灯会')) return '节日活动';
    return '特色精选';
  }
}
