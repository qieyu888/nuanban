import 'package:flutter/material.dart';

class SceneDetailScreen extends StatefulWidget {
  final String title;
  final String location;
  final String imageUrl;
  final bool isAsset;

  const SceneDetailScreen({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
    this.isAsset = false,
  });

  @override
  State<SceneDetailScreen> createState() => _SceneDetailScreenState();
}

class _SceneDetailScreenState extends State<SceneDetailScreen> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() => _showTitle = false);
    }
  }

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
    final content = _getContentByLocation(widget.location);
    
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 顶部大图
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _showTitle ? Colors.transparent : Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.flag_outlined,
                    color: _showTitle ? const Color(0xFF666666) : Colors.white,
                    size: 22,
                  ),
                  onPressed: () => _showReportDialog(context),
                ),
              ),
            ],
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.isAsset
                      ? Image.asset(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[300]),
                        ),
                  // 渐变遮罩
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                  // 标题
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
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
          ),
          
          // 内容区域
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 文章内容
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 简介
                        Text(
                          content['intro']!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // 第一部分
                        _buildSection(
                          content['section1Title']!,
                          content['section1Content']!,
                        ),
                        
                        // 图片1
                        if (content['image1'] != null) ...[
                          const SizedBox(height: 20),
                          _buildImage(content['image1']!),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // 第二部分
                        _buildSection(
                          content['section2Title']!,
                          content['section2Content']!,
                        ),
                        
                        // 图片2
                        if (content['image2'] != null) ...[
                          const SizedBox(height: 20),
                          _buildImage(content['image2']!),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // 第三部分
                        _buildSection(
                          content['section3Title']!,
                          content['section3Content']!,
                        ),
                        
                        // 图片3
                        if (content['image3'] != null) ...[
                          const SizedBox(height: 20),
                          _buildImage(content['image3']!),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // 结语
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9D31FF).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF9D31FF).withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            content['conclusion']!,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.8,
                              color: Color(0xFF333333),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.8,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
      ),
    );
  }

  Map<String, String> _getContentByLocation(String location) {
    if (location.contains('新疆') || location.contains('喀纳斯')) {
      return {
        'intro': '喀纳斯，蒙古语意为"美丽而神秘的湖"，位于新疆阿勒泰地区布尔津县北部，是中国最美的湖泊之一。秋季的喀纳斯，更是美得令人窒息，金黄的白桦林、碧绿的湖水、雪白的山峰，构成了一幅绝美的画卷。',
        
        'section1Title': '秋色如画的喀纳斯湖',
        'section1Content': '每年9月中旬到10月初，是喀纳斯最美的季节。此时，山林换上了金黄、橙红、深绿等多种颜色的盛装，层林尽染，美不胜收。喀纳斯湖水在阳光的照射下，呈现出翡翠般的碧绿色，与周围的彩林形成强烈的视觉冲击。\n\n湖畔的白桦林是秋季喀纳斯的标志性景观。金黄的白桦叶在微风中沙沙作响，阳光透过树叶洒下斑驳的光影，仿佛走进了童话世界。清晨，薄雾笼罩湖面，远处的雪山若隐若现，宛如仙境。',
        'image1': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
        
        'section2Title': '神秘的图瓦人村落',
        'section2Content': '在喀纳斯湖畔，居住着一个古老的民族——图瓦人。他们是成吉思汗西征时遗留下来的部分老弱病残的士兵，在这里繁衍生息了800多年。图瓦人保持着最原始的生活方式，住木屋、放牧、打猎，过着与世无争的生活。\n\n禾木村和白哈巴村是图瓦人的主要聚居地。村落依山傍水，木屋错落有致，炊烟袅袅升起，牛羊在山坡上悠闲地吃草。秋天的清晨，整个村庄笼罩在金色的阳光中，美得像一幅油画。游客可以住在图瓦人家中，体验他们的生活，品尝奶茶、手抓肉等特色美食。',
        'image2': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80',
        
        'section3Title': '最佳旅行攻略',
        'section3Content': '前往喀纳斯，建议至少安排3-4天的行程。第一天可以游览喀纳斯湖，乘船游湖，登观鱼台俯瞰全景。第二天前往禾木村，欣赏晨雾和日出。第三天游览白哈巴村，这里被誉为"西北第一村"，是中国与哈萨克斯坦的边境。\n\n秋季的喀纳斯早晚温差大，白天气温在10-15度，晚上可能降到0度以下，需要准备厚外套。由于海拔较高（约1300-2000米），建议提前做好高原反应的准备。摄影爱好者一定要带上长焦镜头和三脚架，清晨和傍晚是拍摄的最佳时机。',
        'image3': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
        
        'conclusion': '喀纳斯的秋天，是大自然最慷慨的馈赠。这里的美，不仅仅是视觉上的震撼，更是心灵上的洗涤。在这片净土上，你可以暂时忘却城市的喧嚣，感受大自然的宁静与美好。如果你还没有去过喀纳斯，那么秋天一定是你最不应该错过的季节。',
      };
    } else if (location.contains('西藏') || location.contains('雪山')) {
      return {
        'intro': '西藏，世界屋脊，雪域高原。这里有世界上最高的山峰，最纯净的湖泊，最虔诚的信仰。雪山与圣湖，是西藏最具代表性的自然景观，也是无数旅行者心中的圣地。',
        
        'section1Title': '珠穆朗玛峰：世界之巅',
        'section1Content': '珠穆朗玛峰，藏语意为"第三女神"，海拔8848.86米，是世界第一高峰。站在珠峰大本营，仰望这座巍峨的雪山，你会感受到人类的渺小和大自然的伟大。\n\n每年4-5月和9-10月是观赏珠峰的最佳季节。此时天气晴朗，能见度高，有机会看到珠峰的真容。清晨，当第一缕阳光照射在珠峰顶上，雪山被染成金色，这就是著名的"日照金山"奇观。夜晚，在珠峰脚下仰望星空，银河清晰可见，仿佛触手可及。',
        'image1': 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800&q=80',
        
        'section2Title': '纳木错：天湖之美',
        'section2Content': '纳木错，藏语意为"天湖"，是西藏三大圣湖之一，也是世界上海拔最高的咸水湖（4718米）。湖水清澈湛蓝，在阳光下呈现出不同层次的蓝色，美得令人窒息。\n\n纳木错湖畔的念青唐古拉山终年积雪，雪山倒映在湖水中，形成了"雪山圣湖"的绝美景观。藏族人民认为纳木错是神圣的，每年都有大量信徒来此转湖朝拜。湖边的扎西半岛是观赏日出日落的最佳地点，清晨的纳木错笼罩在薄雾中，宛如仙境。',
        'image2': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800&q=80',
        
        'section3Title': '羊卓雍错：碧玉之湖',
        'section3Content': '羊卓雍错，简称羊湖，是西藏三大圣湖之一。湖水碧蓝如玉，湖岸线蜿蜒曲折，形态优美。从山口俯瞰羊湖，整个湖泊像一条蓝色的丝带，镶嵌在群山之间。\n\n羊湖的美在于它的颜色变化。在不同的时间、不同的天气下，湖水会呈现出不同的蓝色。有时是深邃的宝石蓝，有时是清澈的天空蓝，有时又是神秘的翡翠绿。湖边的藏族村落、成群的牛羊、飘扬的经幡，构成了一幅和谐的画面。\n\n前往西藏旅行，需要注意高原反应。建议提前一周开始服用红景天等抗高反药物，到达后前两天不要洗澡，多休息，避免剧烈运动。同时要尊重当地的宗教信仰和风俗习惯，不要随意拍摄寺庙内部和朝拜的信徒。',
        'image3': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
        
        'conclusion': '西藏的雪山圣湖，是大自然最壮美的杰作。这里的美，纯净而神圣，震撼而感动。每一个来到西藏的人，都会被这里的美景所折服，被这里的信仰所感染。西藏，是一生必去的地方，是心灵的归宿。',
      };
    } else if (location.contains('福建') || location.contains('土楼')) {
      return {
        'intro': '福建土楼，是世界上独一无二的山区大型夯土民居建筑，被誉为"东方古城堡"。这些圆形或方形的巨大建筑，历经数百年风雨，依然屹立不倒，见证了客家人的智慧和团结。',
        
        'section1Title': '永定土楼：客家建筑的瑰宝',
        'section1Content': '永定土楼群是福建土楼的代表，其中最著名的是承启楼，被誉为"土楼之王"。承启楼建于1709年，直径73米，高4层，共有400个房间，最多时住过800多人。整座土楼呈圆形，外墙厚达1.8米，具有极强的防御功能。\n\n土楼的建筑结构非常巧妙。外墙用生土、石灰、糯米、红糖等材料夯筑而成，坚固耐用。楼内采用木结构，冬暖夏凉。中心是一个大天井，用于采光和通风。所有房间围绕天井而建，形成一个封闭的圆形空间，体现了客家人"聚族而居"的传统。',
        'image1': 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
        
        'section2Title': '南靖土楼：田螺坑的奇观',
        'section2Content': '南靖土楼群中，最著名的是田螺坑土楼群，被称为"四菜一汤"。这里有5座土楼，1座方楼（步云楼）居中，4座圆楼（和昌楼、振昌楼、瑞云楼、文昌楼）环绕四周，从高处俯瞰，就像一桌丰盛的客家菜肴。\n\n田螺坑土楼群建在山坡上，依山就势，错落有致。清晨，薄雾笼罩山谷，土楼若隐若现，宛如仙境。傍晚，夕阳西下，土楼被染成金色，美不胜收。夜晚，土楼内灯火通明，从远处看去，就像一颗颗明珠镶嵌在山间。',
        'image2': 'https://images.unsplash.com/photo-1548919973-5cef591cdbc9?w=800&q=80',
        
        'section3Title': '客家文化与土楼生活',
        'section3Content': '土楼不仅是建筑奇迹，更是客家文化的载体。客家人是汉族的一个民系，因战乱从中原南迁至福建、广东等地。为了抵御外敌和野兽，他们建造了这些坚固的土楼，一族人聚居其中，共同生活。\n\n在土楼里，你可以体验到最原汁原味的客家生活。品尝客家菜，如梅菜扣肉、酿豆腐、盐焗鸡等。观看客家山歌表演，感受客家人的热情和豪爽。参观土楼内的祠堂，了解客家人的家族文化和祖先崇拜。\n\n游览土楼，建议安排2-3天的行程。第一天游览永定土楼群，第二天前往南靖土楼群。可以选择住在土楼内，体验土楼生活。最佳旅游季节是春秋两季，此时气候宜人，景色优美。',
        'image3': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80',
        
        'conclusion': '福建土楼，是中国传统建筑的瑰宝，是客家文化的象征。这些巨大的圆形建筑，不仅展现了古代劳动人民的智慧，也体现了客家人团结互助的精神。走进土楼，就像走进了历史，走进了一个充满温情的大家庭。',
      };
    } else if (location.contains('广西') || location.contains('漓江')) {
      return {
        'intro': '桂林山水甲天下，阳朔山水甲桂林。漓江，是桂林山水的精华所在，也是中国最美的河流之一。清澈的江水、奇特的山峰、翠绿的竹林，构成了一幅绝美的山水画卷。',
        
        'section1Title': '漓江山水：水墨画般的美景',
        'section1Content': '漓江发源于桂林东北的猫儿山，流经桂林、阳朔，全长164公里。江水清澈见底，两岸奇峰林立，形态各异。有的像骆驼，有的像大象，有的像笔架，千姿百态，令人叹为观止。\n\n乘船游漓江，是欣赏漓江山水的最佳方式。从桂林到阳朔，约4-5小时的航程，沿途可以看到九马画山、黄布倒影、兴坪佳境等著名景点。江面上，渔民撑着竹筏，鸬鹚站在船头，构成了一幅动人的画面。雨后的漓江更是美不胜收，云雾缭绕，山峰若隐若现，宛如仙境。',
        'image1': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
        
        'section2Title': '阳朔西街：东西方文化的交融',
        'section2Content': '阳朔西街，有着1400多年的历史，是阳朔最古老的街道。这里中西合璧，既有传统的青石板路、古朴的民居，又有现代的酒吧、咖啡馆。白天，西街是一个安静的小镇，游客可以逛逛特色小店，品尝桂林米粉、啤酒鱼等美食。夜晚，西街变得热闹非凡，酒吧里传出动感的音乐，街上人头攒动，充满了异国情调。\n\n西街是背包客的天堂，这里有各种价位的客栈和酒店。许多外国人在这里定居，开设酒吧、餐厅，与当地人和谐相处。在西街，你可以遇到来自世界各地的旅行者，交流旅行经验，分享旅途故事。',
        'image2': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80',
        
        'section3Title': '遇龙河：小漓江的宁静之美',
        'section3Content': '遇龙河是漓江的支流，被称为"小漓江"。与漓江相比，遇龙河更加宁静、原始。河水清澈，水流平缓，两岸田园风光秀美。乘坐竹筏漂流遇龙河，是阳朔最受欢迎的活动之一。\n\n竹筏在河面上缓缓前行，两岸青山绿水，稻田金黄，水牛悠闲地吃草，白鹭在水面上飞翔。偶尔会经过一些小村庄，古朴的民居、石桥、水车，构成了一幅田园诗画。遇龙河沿途有多个码头，可以选择不同的漂流路段，全程约2-3小时。\n\n游览桂林阳朔，建议安排3-4天的行程。第一天游览桂林市区的象鼻山、两江四湖。第二天乘船游漓江，从桂林到阳朔。第三天在阳朔游玩，漂流遇龙河，骑行十里画廊，晚上逛西街。第四天可以去龙脊梯田或者银子岩。最佳旅游季节是4-10月，此时气候宜人，景色最美。',
        'image3': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&q=80',
        
        'conclusion': '桂林山水，是大自然的杰作，是中国山水画的现实版本。漓江的美，在于它的秀丽和灵动；阳朔的美，在于它的宁静和悠闲。来到这里，你可以放慢脚步，享受慢生活，感受山水之间的诗意。桂林山水，值得你一去再去。',
      };
    }
    
    // 默认内容
    return {
      'intro': '这是一个美丽的地方，值得你来探索。',
      'section1Title': '自然风光',
      'section1Content': '这里有着独特的自然风光，四季景色各异，每个季节都有不同的美。',
      'image1': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
      'section2Title': '人文历史',
      'section2Content': '这里有着悠久的历史和深厚的文化底蕴，值得细细品味。',
      'image2': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80',
      'section3Title': '旅行建议',
      'section3Content': '建议安排充足的时间，慢慢游览，感受这里的美好。',
      'image3': 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800&q=80',
      'conclusion': '这里的美，需要你亲自来体验。期待你的到来！',
    };
  }
}
