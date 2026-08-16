import 'package:flutter/material.dart';
import '../utils/follow_state.dart';
import '../utils/user_state.dart';
import '../widgets/animated_like_button.dart';
import '../widgets/animated_follow_button.dart';
import '../widgets/image_gallery_viewer.dart';
import 'user_profile_screen.dart';

class MomentDetailScreen extends StatefulWidget {
  final bool isMyMoment;
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

  const MomentDetailScreen({
    super.key,
    required this.isMyMoment,
    required this.username,
    required this.time,
    required this.location,
    required this.category,
    required this.content,
    required this.imageCount,
    this.imageUrls = const [],
    required this.likes,
    required this.comments,
    required this.initialIsLiked,
    required this.initialIsFollowing,
    required this.tagColor,
    this.avatarUrl = '',
  });

  @override
  State<MomentDetailScreen> createState() => _MomentDetailScreenState();
}

class _MomentDetailScreenState extends State<MomentDetailScreen>
    with SingleTickerProviderStateMixin {
  late bool _isLiked;
  late bool _isFollowing;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  final List<Map<String, dynamic>> _commentsList = [
    {
      'username': '旅行达人',
      'time': '5分钟前',
      'content': '太美了！我也想去这里看看 😍',
      'likes': 12,
      'avatarUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150&q=80', // 风景
    },
    {
      'username': '摄影爱好者',
      'time': '10分钟前',
      'content': '构图很棒，光线也把握得很好！',
      'likes': 8,
      'avatarUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=150&q=80', // 亚洲面孔
    },
    {
      'username': '美食探索家',
      'time': '15分钟前',
      'content': '请问具体位置在哪里呀？',
      'likes': 5,
      'avatarUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=150&q=80', // 美食
    },
  ];

  static const Map<String, String> _userSignatures = {
    '旅行摄影师小王': '用镜头记录世界，用文字分享故事 ✨',
    '美食探索家': '吃货一枚，走哪吃哪 🍜',
    '园林爱好者': '江南园林，一步一景 🏞️',
    '节日记录者': '记录每一个值得纪念的节日 🏮',
    '山水画师': '水墨丹青，江山如画 🎨',
    '京城食客': '京城味道，传统与创新 🦆',
    '古镇寻梦': '古镇小巷，梦里寻踪 🌙',
    '海边漫步': '面朝大海，春暖花开 🌊',
    '夜景猎人': '城市的夜，最懂人心 🌃',
    '美食达人': '早茶点心，广式生活 🍵',
  };

  static const Map<String, String> _userStats = {
    '旅行摄影师小王': '156|89|2.3k',
    '美食探索家': '234|123|1.8k',
    '园林爱好者': '145|98|1.5k',
    '节日记录者': '345|234|3.4k',
    '山水画师': '567|234|4.5k',
    '京城食客': '789|456|5.6k',
    '古镇寻梦': '432|321|3.2k',
    '海边漫步': '234|189|2.1k',
    '夜景猎人': '891|567|6.7k',
    '美食达人': '678|345|4.3k',
  };

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialIsLiked;
    _isFollowing = widget.initialIsFollowing;
    _syncFollowState();
    FollowState().addListener(_onFollowStateChanged);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    FollowState().removeListener(_onFollowStateChanged);
    _animationController.dispose();
    _commentController.dispose();
    _commentFocusNode.dispose();
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
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Future<void> _toggleFollow() async {
    final next = await FollowState().toggle(widget.username);
    if (!mounted) return;
    setState(() => _isFollowing = next);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(next ? '已关注 ${widget.username}' : '已取消关注'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _openUserProfile() async {
    final stats = _userStats[widget.username]?.split('|') ?? ['0', '0', '0'];
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          username: widget.username,
          avatarUrl: widget.avatarUrl,
          signature: _userSignatures[widget.username] ??
              '用镜头记录世界，用文字分享故事 ✨',
          followers: stats[0],
          following: stats[1],
          likes: stats[2],
          initialIsFollowing: _isFollowing,
        ),
      ),
    );
    if (mounted) {
      setState(() {
        _isFollowing = FollowState().isFollowing(widget.username);
      });
    }
  }

  void _showReportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '举报内容',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                _buildReportOption(
                  dialogContext,
                  Icons.warning_amber_rounded,
                  '虚假信息',
                  '内容包含虚假或误导性信息',
                ),
                _buildReportOption(
                  dialogContext,
                  Icons.block_rounded,
                  '不适当内容',
                  '包含不雅、暴力或令人不适的内容',
                ),
                _buildReportOption(
                  dialogContext,
                  Icons.copyright_rounded,
                  '侵权内容',
                  '侵犯他人版权或知识产权',
                ),
                _buildReportOption(
                  dialogContext,
                  Icons.report_gmailerrorred_rounded,
                  '垃圾广告',
                  '包含垃圾信息或广告内容',
                ),
                _buildReportOption(
                  dialogContext,
                  Icons.report_problem_rounded,
                  '其他问题',
                  '其他违规或不当内容',
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(dialogContext),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8F8),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          '取消',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _showReportSuccessDialog(title);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5222D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFF5222D), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFCCCCCC),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showReportSuccessDialog(String reason) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF52C41A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF52C41A),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '举报成功',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '感谢您的反馈，我们已收到您关于"$reason"的举报，将尽快处理。',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Center(
                      child: Text(
                        '确定',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              const SizedBox(height: 24),
              if (widget.isMyMoment) ...[
                _buildBottomSheetItem(
                  Icons.delete_outline_rounded,
                  '删除动态',
                  const Color(0xFFF5222D),
                  () {
                    Navigator.pop(context);
                    _showDeleteDialog();
                  },
                ),
              ] else ...[
                _buildBottomSheetItem(
                  Icons.block_outlined,
                  '拉黑',
                  const Color(0xFFF5222D),
                  () {
                    Navigator.pop(context);
                    _showBlockDialog();
                  },
                ),
                _buildBottomSheetItem(
                  Icons.visibility_off_outlined,
                  '屏蔽',
                  const Color(0xFFFAAD14),
                  () {
                    Navigator.pop(context);
                    _showHideDialog();
                  },
                ),
                _buildBottomSheetItem(
                  Icons.report_outlined,
                  '举报',
                  const Color(0xFFFF8A65),
                  () {
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) _showReportDialog();
                    });
                  },
                ),
              ],
              const SizedBox(height: 8),
              Container(height: 8, color: const Color(0xFFF7F8F8)),
              _buildBottomSheetItem(
                Icons.close_rounded,
                '取消',
                const Color(0xFF666666),
                () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem(
      IconData icon, String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5222D).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFF5222D),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '删除动态',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
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
              Row(
                children: [
                  Expanded(
                    child: _buildDialogButton(
                      '取消',
                      const Color(0xFFF7F8F8),
                      const Color(0xFF666666),
                      () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDialogButton(
                      '确定',
                      const Color(0xFFF5222D),
                      Colors.white,
                      () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('动态已删除')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5222D).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block_outlined,
                  color: Color(0xFFF5222D),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '拉黑用户',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '确定要拉黑 ${widget.username} 吗？\n拉黑后将不再看到对方的动态',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDialogButton(
                      '取消',
                      const Color(0xFFF7F8F8),
                      const Color(0xFF666666),
                      () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDialogButton(
                      '确定',
                      const Color(0xFFF5222D),
                      Colors.white,
                      () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已拉黑该用户')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHideDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAAD14).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.visibility_off_outlined,
                  color: Color(0xFFFAAD14),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '屏蔽动态',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '确定要屏蔽这条动态吗？\n屏蔽后将不再显示',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDialogButton(
                      '取消',
                      const Color(0xFFF7F8F8),
                      const Color(0xFF666666),
                      () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDialogButton(
                      '确定',
                      const Color(0xFFFAAD14),
                      Colors.white,
                      () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已屏蔽该动态')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton(
      String text, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  void _sendComment() {
    if (_commentController.text.trim().isEmpty) return;
    
    setState(() {
      _commentsList.insert(0, {
        'username': UserState().nickname,
        'time': '刚刚',
        'content': _commentController.text.trim(),
        'likes': 0,
        'avatarUrl': UserState().avatarPath,
        'isUserComment': true, // 标记这是用户自己的评论
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('评论发送成功'),
        duration: Duration(seconds: 1),
      ),
    );
    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '动态详情',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF1A1A1A)),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMomentCard(),
                const SizedBox(height: 16),
                _buildCommentsSection(),
              ],
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildMomentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                onTap: widget.isMyMoment ? null : _openUserProfile,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.tagColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: widget.isMyMoment
                        ? Image(
                            image: UserState().getAvatarImage(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person),
                          )
                        : (widget.avatarUrl.startsWith('assets/')
                            ? Image.asset(
                                widget.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person),
                              )
                            : Image.network(
                                widget.avatarUrl.isNotEmpty
                                    ? widget.avatarUrl
                                    : 'https://i.pravatar.cc/150?img=11',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person),
                              )),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.isMyMoment ? null : _openUserProfile,
                      child: Text(
                        widget.isMyMoment
                            ? UserState().nickname
                            : widget.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          widget.time,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.location_on_rounded,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.location,
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!widget.isMyMoment) ...[
                const SizedBox(width: 8),
                AnimatedFollowButton(
                  isFollowing: _isFollowing,
                  onTap: _toggleFollow,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  fontSize: 13,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // 分类标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.tagColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.tagColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 内容
          Text(
            widget.content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (widget.imageCount > 0) ...[
            const SizedBox(height: 16),
            _buildImageGrid(),
          ],
          const SizedBox(height: 20),
          // 分隔线
          Container(height: 1, color: const Color(0xFFF7F8F8)),
          const SizedBox(height: 16),
          // 互动按钮
          Row(
            children: [
              Expanded(
                child: AnimatedLikeButton(
                  isLiked: _isLiked,
                  onTap: _toggleLike,
                  label: widget.likes,
                  iconSize: 20,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _commentFocusNode.requestFocus(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 20,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.comments,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    if (widget.imageCount == 0 || widget.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    final urls = widget.imageUrls;
    final content = widget.content;
    final username = widget.username;

    if (widget.imageCount == 1) {
      return buildTappableGalleryImage(
        context: context,
        allUrls: urls,
        index: 0,
        imageUrl: urls[0],
        aspectRatio: 16 / 9,
        content: content,
        username: username,
      );
    } else if (widget.imageCount == 2) {
      return Row(
        children: [
          Expanded(
            child: buildTappableGalleryImage(
              context: context,
              allUrls: urls,
              index: 0,
              imageUrl: urls[0],
              aspectRatio: 1,
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
              content: content,
              username: username,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCommentsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '评论 ${_commentsList.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._commentsList.map((comment) => _buildCommentItem(comment)),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    final String avatarUrl = comment['avatarUrl'] ?? 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150&q=80';
    final bool isUserComment = comment['isUserComment'] == true;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: ClipOval(
              child: isUserComment
                  ? Image(
                      image: UserState().getAvatarImage(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 20),
                    )
                  : (avatarUrl.startsWith('assets/')
                      ? Image.asset(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 20),
                        )
                      : Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 20),
                        )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['username'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment['content'],
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                decoration: const InputDecoration(
                  hintText: '说点什么...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendComment,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9D31FF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
