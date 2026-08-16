import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'web_view_screen.dart';
import '../utils/legal_urls.dart';
import 'edit_profile_screen.dart';
import 'help_feedback_screen.dart';
import 'feedback_screen.dart';
import 'about_screen.dart';
import 'delete_account_screen.dart';
import 'my_moments_screen.dart';
import 'wallet_recharge_screen.dart';
import '../utils/app_config.dart';
import '../utils/coin_manager.dart';
import '../utils/user_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _coinBalance = 0;

  @override
  void initState() {
    super.initState();
    UserState().addListener(_onAvatarChanged);
    _refreshCoinBalance();
  }

  void _refreshCoinBalance() {
    if (!mounted) return;
    final balance = CoinManager.getCoins();
    if (_coinBalance != balance) {
      setState(() => _coinBalance = balance);
    }
  }

  @override
  void dispose() {
    UserState().removeListener(_onAvatarChanged);
    super.dispose();
  }

  void _onAvatarChanged() {
    setState(() {});
  }

  void _openLegalPage(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url, title: title),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                // 标题
                const Text(
                  '退出账号',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                // 提示文案
                const Text(
                  '是否退出当前账号？\n退出登录后需要重新登录',
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
                          Navigator.of(context).pop();
                          // 重置头像为默认头像
                          UserState().resetToDefault();
                          // 跳转到启动页，清除所有路由栈
                          Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SplashScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                            ),
                            (route) => false,
                          );
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF9D31FF),
                                Color(0xFFF260FF),
                                Color(0xFFFF609F),
                              ],
                            ),
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshCoinBalance());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 状态栏 + 标题
          SliverAppBar(
            expandedHeight: 0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF9D31FF),
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
                    '我的',
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
          
          // 个人信息头部
          SliverToBoxAdapter(
            child: _buildProfileHeader(context),
          ),
          
          // 菜单列表
          SliverToBoxAdapter(
            child: _buildMenuSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
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
                  child: Image(
                    image: UserState().getAvatarImage(),
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
                          UserState().nickname,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  '编辑资料',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (AppConfig.showSignature) ...[
                      const SizedBox(height: 8),
                      Text(
                        UserState().signature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ],
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
              _buildStatItemSimple('18', '粉丝'),
              Container(
                width: 1,
                height: 20,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItemSimple('12', '关注'),
              Container(
                width: 1,
                height: 20,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItemSimple('86', '获赞'),
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

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMenuItemNoBorder(
            Icons.account_balance_wallet_outlined,
            '我的钱包',
            '$_coinBalance',
            const Color(0xFFFAAD14),
            (context) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WalletRechargeScreen(),
                ),
              );
              _refreshCoinBalance();
            },
            context,
          ),
          const SizedBox(height: 8),
          // 内容管理 - 无边框样式
          _buildMenuItemNoBorder(
            Icons.image_outlined,
            '我的动态',
            '3条',
            const Color(0xFF9D31FF),
            (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyMomentsScreen(),
                ),
              );
            },
            context,
          ),
          const SizedBox(height: 8),
          // 帮助与反馈
          _buildMenuItemNoBorder(
            Icons.help_outline,
            '帮助反馈',
            null,
            const Color(0xFF1890FF),
            (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpFeedbackScreen(),
                ),
              );
            },
            context,
          ),
          const SizedBox(height: 8),
          _buildMenuItemNoBorder(
            Icons.chat_bubble_outline,
            '问题反馈',
            null,
            const Color(0xFFF260FF),
            (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackScreen(),
                ),
              );
            },
            context,
          ),
          const SizedBox(height: 8),
          // 关于与设置
          _buildMenuItemNoBorder(
            Icons.description_outlined,
            '用户须知',
            null,
            const Color(0xFF52C41A),
            (context) {
              _openLegalPage(context, LegalUrls.userAgreement, '用户协议');
            },
            context,
          ),
          const SizedBox(height: 8),
          _buildMenuItemNoBorder(
            Icons.shield_outlined,
            '隐私协议',
            null,
            const Color(0xFFFF609F),
            (context) {
              _openLegalPage(context, LegalUrls.privacyPolicy, '隐私政策');
            },
            context,
          ),
          const SizedBox(height: 8),
          _buildMenuItemNoBorder(
            Icons.info_outline,
            '关于我们',
            'v1.0.0',
            const Color(0xFFFAAD14),
            (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
            context,
          ),
          const SizedBox(height: 24),
          // 注销账号
          _buildMenuItemNoBorder(
            Icons.person_off_outlined,
            '注销账号',
            null,
            const Color(0xFFF5222D),
            (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeleteAccountScreen(),
                ),
              );
            },
            context,
          ),
          const SizedBox(height: 8),
          // 退出登录
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Color(0xFFF5222D), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '退出登录',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF5222D),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMenuItemNoBorder(
    IconData icon,
    String title,
    String? subtitle,
    Color color,
    Function(BuildContext) onTap,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            if (subtitle != null) ...[
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}
