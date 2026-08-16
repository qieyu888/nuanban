import 'package:flutter/material.dart';
import '../utils/user_state.dart';
import 'moment_detail_screen.dart';

class MyMomentsScreen extends StatefulWidget {
  const MyMomentsScreen({super.key});

  @override
  State<MyMomentsScreen> createState() => _MyMomentsScreenState();
}

class _MyMomentsScreenState extends State<MyMomentsScreen> {
  @override
  void initState() {
    super.initState();
    UserState().addListener(_onAvatarChanged);
  }

  @override
  void dispose() {
    UserState().removeListener(_onAvatarChanged);
    super.dispose();
  }

  void _onAvatarChanged() {
    setState(() {});
  }

  final List<Map<String, dynamic>> _moments = [
    {
      'time': '30分钟前',
      'location': '厦门·鼓浪屿',
      'category': '城市美景',
      'content': '鼓浪屿的午后时光，阳光洒在红砖老别墅上，海风轻拂。漫步在小巷中，每个转角都是惊喜，这座小岛真的太治愈了 🏝️☀️',
      'imageCount': 3,
      'imageUrls': const [
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
        'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&q=80',
        'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800&q=80',
      ],
      'likes': '15',
      'comments': '4',
      'isLiked': true,
      'tagColor': const Color(0xFF9D31FF),
    },
    {
      'time': '2天前',
      'location': '南京·夫子庙',
      'category': '特色文化',
      'content': '夫子庙的夜市热闹非凡，秦淮河畔灯火辉煌。品尝着鸭血粉丝汤，感受着六朝古都的韵味，历史与现代在这里交融 🏮🌃',
      'imageCount': 2,
      'imageUrls': const [
        'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=800&q=80',
        'https://images.unsplash.com/photo-1583037189850-1921ae7c6c22?w=800&q=80',
      ],
      'likes': '12',
      'comments': '3',
      'isLiked': false,
      'tagColor': const Color(0xFFF260FF),
    },
    {
      'time': '4天前',
      'location': '长沙·橘子洲',
      'category': '城市美景',
      'content': '站在橘子洲头，湘江两岸风光尽收眼底。毛主席雕像巍然屹立，让人心生敬意。长沙的活力和热情，在这里展现得淋漓尽致 🎆',
      'imageCount': 1,
      'imageUrls': const [
        'https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=800&q=80',
      ],
      'likes': '10',
      'comments': '2',
      'isLiked': true,
      'tagColor': const Color(0xFF9D31FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的动态',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
        ),
      ),
      body: _moments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '还没有发布动态',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _moments.length,
              itemBuilder: (context, index) {
                return _buildMomentCard(_moments[index], index);
              },
            ),
    );
  }

  Widget _buildMomentCard(Map<String, dynamic> moment, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MomentDetailScreen(
              isMyMoment: true,
              username: UserState().nickname,
              time: moment['time'],
              location: moment['location'],
              category: moment['category'],
              content: moment['content'],
              imageCount: moment['imageCount'],
              imageUrls: moment['imageUrls'] ?? [],
              likes: moment['likes'],
              comments: moment['comments'],
              initialIsLiked: moment['isLiked'],
              initialIsFollowing: false,
              tagColor: moment['tagColor'],
            ),
          ),
        );
      },
      child: Container(
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
          // 用户信息
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: ClipOval(
                  child: Image(
                    image: UserState().getAvatarImage(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserState().nickname,
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
                          moment['time'],
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF999999)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on,
                            size: 12, color: Color(0xFF999999)),
                        const SizedBox(width: 4),
                        Text(
                          moment['location'],
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF999999)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: moment['tagColor'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              moment['category'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: moment['tagColor'],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 内容
          Text(
            moment['content'],
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (moment['imageCount'] > 0) ...[
            const SizedBox(height: 12),
            _buildImageGrid(moment['imageCount']),
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
              // 删除按钮（最左侧）
              GestureDetector(
                onTap: () => _showDeleteDialog(index),
                child: _buildActionButton(
                    Icons.delete_outline, '删除', const Color(0xFFF5222D)),
              ),
              const Spacer(),
              // 点赞和评论（右侧）
              _buildActionButton(
                moment['isLiked'] ? Icons.favorite : Icons.favorite_border,
                moment['likes'],
                moment['isLiked']
                    ? const Color(0xFFFF609F)
                    : const Color(0xFF999999),
              ),
              const SizedBox(width: 24),
              _buildActionButton(Icons.chat_bubble_outline,
                  moment['comments'], const Color(0xFF999999)),
            ],
          ),
        ],
      ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5222D).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFF5222D),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                // 标题
                const Text(
                  '删除动态',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                // 提示文案
                const Text(
                  '确定要删除这条动态吗？\n删除后将无法恢复',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // 按钮
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8F8),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Center(
                            child: Text(
                              '取消',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _moments.removeAt(index);
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('动态已删除')),
                          );
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5222D),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Center(
                            child: Text(
                              '确定',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildImageGrid(int count) {
    if (count == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            'https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=800&q=80',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[200]),
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
                  'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[200]),
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
                  'https://images.unsplash.com/photo-1583037189850-1921ae7c6c22?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[200]),
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
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[200]),
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
                  'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[200]),
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
                  'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[200]),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color),
        ),
      ],
    );
  }
}
