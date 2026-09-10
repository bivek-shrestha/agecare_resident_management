import 'package:flutter/material.dart';

import '../models/message.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  final AppState appState;

  const MessagesScreen({super.key, required this.appState});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String _query = '';

  List<ChatThread> get _threads {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.appState.threads;
    return widget.appState.threads.where((thread) {
      return thread.staffName.toLowerCase().contains(query) ||
          thread.role.toLowerCase().contains(query) ||
          thread.preview.toLowerCase().contains(query);
    }).toList();
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'AC';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final threads = _threads;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              fontSize: 25,
              height: 1.1,
              letterSpacing: -0.4,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search messages',
              prefixIcon: Icon(Icons.search_rounded, size: 21),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: threads.isEmpty
                ? const Center(
                    child: Text(
                      'No messages',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 760) {
                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: threads.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 520,
                            mainAxisExtent: 98,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) => _MessageCard(
                            thread: threads[index],
                            initials: _initials(threads[index].staffName),
                            onTap: () => _openThread(threads[index]),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: threads.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) => _MessageCard(
                          thread: threads[index],
                          initials: _initials(threads[index].staffName),
                          onTap: () => _openThread(threads[index]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openThread(ChatThread thread) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen(thread: thread)),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final ChatThread thread;
  final String initials;
  final VoidCallback onTap;

  const _MessageCard({
    required this.thread,
    required this.initials,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const radius = 26.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: const Color(0xFFE7EDF4)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D3557).withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F6FC),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE5ECF4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              thread.staffName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: thread.unread
                                    ? FontWeight.w900
                                    : FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            thread.time,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              thread.preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          if (thread.unread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Color(0xFFB4BFCC),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
