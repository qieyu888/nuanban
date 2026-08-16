import 'package:flutter/material.dart';

class HelpFeedbackScreen extends StatelessWidget {
  const HelpFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '帮助反馈',
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQItem(
            '如何发布动态？',
            '在动态页面点击右上角的"+"按钮，选择照片或视频，添加文字描述后即可发布。',
          ),
          _buildFAQItem(
            '如何修改个人资料？',
            '进入"我的"页面，点击"编辑资料"按钮，即可修改头像、昵称、性别、年龄等信息。',
          ),
          _buildFAQItem(
            '如何使用AI助手？',
            '点击底部导航栏的"AI助手"，输入旅行问题即可获得建议。每次对话消耗 1 金币，金币不足时可在「我的钱包」充值。',
          ),
          _buildFAQItem(
            '如何充值金币？',
            '进入「我的」页面，点击「我的钱包」，选择 ¥8/¥28/¥58 充值档位，通过 Apple 内购完成支付后即可获得对应金币。',
          ),
          _buildFAQItem(
            '如何关注其他用户？',
            '在动态页面或用户主页，点击"关注"按钮即可关注该用户，关注后可以在动态页面看到对方的最新动态。',
          ),
          _buildFAQItem(
            '如何收藏喜欢的内容？',
            '在动态详情页面，点击右下角的收藏图标即可收藏该内容，收藏的内容可以在"我的收藏"中查看。',
          ),
          _buildFAQItem(
            '如何搜索景点或城市？',
            '在首页顶部的搜索框中输入景点或城市名称，即可搜索相关内容和推荐。',
          ),
          _buildFAQItem(
            '如何删除已发布的动态？',
            '进入"我的动态"，找到要删除的动态，长按或点击右上角的菜单按钮，选择"删除"即可。',
          ),
          _buildFAQItem(
            '如何反馈问题？',
            '如果您遇到任何问题或有建议，可以通过"问题反馈"功能向我们反馈，我们会尽快处理。',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
