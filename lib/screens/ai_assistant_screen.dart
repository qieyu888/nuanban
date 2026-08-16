import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import '../utils/coin_manager.dart';
import '../utils/user_state.dart';
import '../widgets/coin_icon.dart';
import 'wallet_recharge_screen.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  int _coinBalance = 0;
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();
  int? _speakingIndex;
  bool _isSpeaking = false;

  /// 每条用户消息消耗 1 金币
  static const bool _chargesCoins = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _refreshCoinBalance();
    _addWelcomeMessage();
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setLanguage('zh-CN');
    await _flutterTts.setSpeechRate(0.48);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(true);

    if (Platform.isIOS) {
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.spokenAudio,
      );
    }

    _flutterTts.setStartHandler(() {
      if (!mounted) return;
      setState(() => _isSpeaking = true);
    });
    _flutterTts.setCompletionHandler(() {
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
        _speakingIndex = null;
      });
    });
    _flutterTts.setCancelHandler(() {
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
        _speakingIndex = null;
      });
    });
    _flutterTts.setErrorHandler((message) {
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
        _speakingIndex = null;
      });
    });
  }

  String _textForSpeech(String content) {
    return content
        .replaceAll(RegExp(r'[\u{1F300}-\u{1FAFF}]', unicode: true), '')
        .replaceAll(RegExp(r'[💰🌍✨～]+'), '')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();
  }

  Future<void> _toggleSpeak(int index, String content) async {
    if (_speakingIndex == index && _isSpeaking) {
      await _flutterTts.stop();
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
        _speakingIndex = null;
      });
      return;
    }

    final text = _textForSpeech(content);
    if (text.isEmpty) return;

    await _flutterTts.stop();
    setState(() {
      _speakingIndex = index;
      _isSpeaking = true;
    });
    await _flutterTts.speak(text);
  }

  Future<void> _stopSpeaking() async {
    await _flutterTts.stop();
    if (!mounted) return;
    setState(() {
      _isSpeaking = false;
      _speakingIndex = null;
    });
  }

  void _refreshCoinBalance() {
    setState(() {
      _coinBalance = CoinManager.getCoins();
    });
  }

  void _addWelcomeMessage() {
    final coinHint = _chargesCoins
        ? '\n\n💰 每次对话消耗 ${CoinManager.aiMessageCost} 金币，当前余额 $_coinBalance 金币'
        : '';
    _messages.add(ChatMessage(
      content:
          '你好！我是暖伴AI旅行助手 🌍\n\n我可以帮你：\n• 规划旅行路线和行程\n• 推荐热门景点和美食\n• 解答旅行相关问题\n• 提供当地文化和习俗建议\n\n有什么旅行问题可以随时问我哦～$coinHint',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _openWallet() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletRechargeScreen()),
    );
    _refreshCoinBalance();
  }

  void _showInsufficientCoinsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CoinIcon(size: 48),
              const SizedBox(height: 16),
              const Text(
                '金币不足',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '每次 AI 对话需要 ${CoinManager.aiMessageCost} 金币\n当前余额：$_coinBalance 金币',
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
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                        Navigator.pop(context);
                        _openWallet();
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
                            '去充值',
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
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty || _isLoading) return;

    if (_chargesCoins) {
      if (_coinBalance < CoinManager.aiMessageCost) {
        _showInsufficientCoinsDialog();
        return;
      }
      final deducted = await CoinManager.deductCoins(CoinManager.aiMessageCost);
      if (!deducted) {
        _refreshCoinBalance();
        _showInsufficientCoinsDialog();
        return;
      }
      _refreshCoinBalance();
    }

    setState(() {
      _messages.add(ChatMessage(
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('https://api.deepseek.com/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer sk-b3c884433ee74890a8de4fa278006c80',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一个旅行助手，帮助用户规划旅行、推荐景点、解答旅行相关问题。请用友好、专业的方式回答。'
            },
            {'role': 'user', 'content': content}
          ],
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiResponse = data['choices'][0]['message']['content'];

        setState(() {
          _messages.add(ChatMessage(
            content: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      if (_chargesCoins) {
        await CoinManager.addCoins(CoinManager.aiMessageCost);
        _refreshCoinBalance();
      }
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          content: '抱歉，发生了错误：$e',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI旅行助手',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isSpeaking)
            IconButton(
              onPressed: _stopSpeaking,
              tooltip: '停止朗读',
              icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
            ),
          if (_chargesCoins)
            GestureDetector(
              onTap: _openWallet,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CoinIcon(size: 20, showShadow: false),
                    const SizedBox(width: 4),
                    Text(
                      '$_coinBalance',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
        ),
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index], index);
              },
            ),
          ),

          // 加载指示器
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF9D31FF),
                          Color(0xFFF260FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '正在思考中...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // 输入框
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8F8),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: _chargesCoins
                              ? '问我任何旅行问题（${CoinManager.aiMessageCost}金币/次）...'
                              : '问我任何旅行问题...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _sendMessage(_messageController.text),
                    child: Container(
                      width: 48,
                      height: 48,
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
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
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

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isSpeakingThis = _speakingIndex == index && _isSpeaking;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF9D31FF),
                    Color(0xFFF260FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? const Color(0xFF9D31FF)
                        : const Color(0xFFF7F8F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: message.isUser
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                      height: 1.5,
                    ),
                  ),
                ),
                if (!message.isUser) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _toggleSpeak(index, message.content),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSpeakingThis
                            ? const Color(0xFF9D31FF).withValues(alpha: 0.12)
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSpeakingThis
                                ? Icons.stop_rounded
                                : Icons.volume_up_rounded,
                            size: 16,
                            color: isSpeakingThis
                                ? const Color(0xFF9D31FF)
                                : const Color(0xFF666666),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isSpeakingThis ? '停止朗读' : '朗读',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSpeakingThis
                                  ? const Color(0xFF9D31FF)
                                  : const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: UserState().isFileImage
                    ? Image.file(
                        File(UserState().avatarPath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 20,
                            color: Color(0xFF666666),
                          );
                        },
                      )
                    : Image.asset(
                        UserState().avatarPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 20,
                            color: Color(0xFF666666),
                          );
                        },
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}
