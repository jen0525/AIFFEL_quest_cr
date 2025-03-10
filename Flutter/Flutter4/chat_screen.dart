import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color,
              size: 20
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
                Icons.refresh,
                color: theme.iconTheme.color,
                size: 26
            ),
            onPressed: () {
              provider.clearMessages(); // 새로고침 유지
              setState(() {});
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
                  color: theme.iconTheme.color,
                  size: 26,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
        title: Text(
          'DL TUTOR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFCC0000),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Provider.of<ChatProvider>(context).messages.isEmpty
                ? _buildEmptyScreen(theme)
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 30,
              ),
              itemCount: Provider.of<ChatProvider>(context).messages.length,
              itemBuilder: (_, index) {
                final msg = Provider.of<ChatProvider>(context).messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? theme.primaryColor
                          : isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(24),
                        topRight: const Radius.circular(24),
                        bottomLeft: Radius.circular(msg.isUser ? 24 : 0),
                        bottomRight: Radius.circular(msg.isUser ? 0 : 24),
                      ),
                    ),
                    child: Text(
                      msg.message,
                      style: TextStyle(
                        color: msg.isUser
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(context, theme, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildEmptyScreen(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Opacity(
          opacity: 0.2,
          child: Image.asset(
            'assets/ch_logo.png', // 이미지 경로 설정
            width: 300,
            height: 300,
            color: theme.brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ThemeData theme, bool isDarkMode) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Image.asset(
              'assets/ch_logo.png',
              color: Color(0xFFCC0000),
              width: 28,
              height: 28,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  hintText: '딥러닝에 관한 모든 것을 질문하세요!',
                  hintStyle: TextStyle(
                    color: Color(0xFFCC0000),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                Provider.of<ChatProvider>(context, listen: false).sendMessage(text);
                _controller.clear();
                _scrollToBottom();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFCC0000),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}