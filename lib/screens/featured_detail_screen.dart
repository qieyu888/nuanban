import 'package:flutter/material.dart';

class FeaturedDetailScreen extends StatefulWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String content;
  final String location;
  final String category;
  final bool initialIsLiked;
  final bool initialIsFollowing;

  const FeaturedDetailScreen({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.content = '',
    this.location = '未知',
    this.category = '特色精选',
    this.initialIsLiked = false,
    this.initialIsFollowing = false,
  });

  @override
  State<FeaturedDetailScreen> createState() => _FeaturedDetailScreenState();
}

class _FeaturedDetailScreenState extends State<FeaturedDetailScreen> {
  void _showReportDialog(BuildContext context) {
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
                // 顶部指示条
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // 标题
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
                // 举报选项
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
                // 取消按钮
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
        // 使用 mounted 检查确保 widget 仍然在树中
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _showReportSuccessDialog(this.context, title);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF0F0F0),
              width: 1,
            ),
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
              child: Icon(
                icon,
                color: const Color(0xFFF5222D),
                size: 22,
              ),
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

  void _showReportSuccessDialog(BuildContext context, String reason) {
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
                // 成功图标
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
                // 标题
                const Text(
                  '举报成功',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                // 提示文案
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
                // 确定按钮
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9D31FF),
                          Color(0xFFF260FF),
                        ],
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
          '特色精选',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Color(0xFF1A1A1A)),
            onPressed: () => _showReportDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContentCard(),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    // 生成内容
    final generatedContent = widget.content.isEmpty
        ? _generateContent(widget.title)
        : widget.content;

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
          // 标题
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // 用户信息
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF9D31FF).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.explore, color: Color(0xFF9D31FF)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '暖伴精选',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded,
                            size: 14, color: const Color(0xFF9D31FF)),
                        const SizedBox(width: 4),
                        Text(
                          '官方认证',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 分类标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF9D31FF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.category,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9D31FF),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 主图
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[200]),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 内容
          Text(
            generatedContent,
            style: const TextStyle(
              fontSize: 16,
              height: 1.8,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _generateContent(String title) {
    // 根据标题生成相应的内容
    if (title.contains('火锅')) {
      return '成都火锅以其麻辣鲜香而闻名天下，是川菜的代表之一。一锅红油翻滚的火锅，配上新鲜的毛肚、鸭肠、黄喉等食材，蘸上香油蒜泥，那种味道让人欲罢不能。\n\n成都人吃火锅讲究"九宫格"，不同的格子温度不同，适合涮不同的食材。老成都人还会点上一碗冰粉或者酸梅汤，解辣又解腻。\n\n来成都，不吃火锅就等于没来过。无论是街边的苍蝇馆子，还是高档的火锅店，都能让你感受到成都人对美食的热爱和执着。';
    } else if (title.contains('园林')) {
      return '苏州园林是中国古典园林的代表，被誉为"咫尺之内再造乾坤"。拙政园、留园、狮子林、沧浪亭，每一座园林都是一幅立体的山水画。\n\n漫步在园林中，移步换景，处处是景。假山、池塘、亭台、楼阁，巧妙地融合在一起，体现了中国传统文化中"天人合一"的哲学思想。\n\n春天的园林，桃红柳绿；夏天的园林，荷花满塘；秋天的园林，桂花飘香；冬天的园林，梅花傲雪。四季皆有不同的美景，让人流连忘返。';
    } else if (title.contains('古城墙')) {
      return '西安古城墙是中国现存规模最大、保存最完整的古代城垣。城墙高12米，底宽18米，顶宽15米，全长13.74公里，是明代建筑的杰作。\n\n登上城墙，可以俯瞰整个西安城。城墙上可以骑自行车环游，感受古都的历史韵味。夕阳西下时，城墙在金色的阳光下显得格外壮观。\n\n城墙见证了西安千年的历史变迁，从汉唐盛世到今日繁华，这座城市始终保持着它独特的魅力。';
    } else if (title.contains('灯会')) {
      return '平遥古城的春节灯会是中国北方最具特色的传统民俗活动之一。每年春节期间，古城内外张灯结彩，红灯笼高高挂起，整个古城沉浸在浓浓的年味中。\n\n灯会上有各种造型的花灯，有传统的宫灯、走马灯，也有现代的LED灯光秀。古城的明清街上，游人如织，热闹非凡。\n\n除了赏灯，还可以品尝平遥的特色小吃，如平遥牛肉、碗托、莜面栲栳栳等。在这里，你能感受到最地道的中国年味。';
    } else {
      return '这是一个充满魅力的地方，值得你亲自来探索和体验。每一个角落都有独特的故事，每一处风景都让人难忘。\n\n无论是美食、美景还是文化，这里都能给你带来不一样的感受。建议你花上一整天的时间，慢慢品味这里的一切。\n\n记得带上相机，记录下这些美好的瞬间。相信这次旅行会成为你难忘的回忆。';
    }
  }
}
