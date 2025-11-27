// lib/features/chat/presentation/widgets/chat_input.dart

import 'package:flutter/material.dart';
import '../controllers/chat_controller.dart';

class ChatInput extends StatefulWidget {
  final ChatController controller;

  const ChatInput({super.key, required this.controller});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  String selectedModel = "Gemini";

  @override
  void initState() {
    super.initState();

    widget.controller.messageController.addListener(() {
      setState(() {}); // Updates mic/send button
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.messageController.text.trim().isNotEmpty;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              key: const ValueKey("image"),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------
                //  SMALL MODEL SELECTOR (using showMenu for tight control)
                // ---------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Visual is small, but padding provides comfortable hit area.
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTapDown: (TapDownDetails details) async {
                        // Show the menu at the tap position (no extra padding)
                        final selected = await showMenu<String>(
                          context: context,
                          position: RelativeRect.fromRect(
                            details.globalPosition & const Size(1, 1),
                            Offset.zero & MediaQuery.of(context).size,
                          ),
                          items: const [
                            PopupMenuItem(value: "Gemini", child: Text("Gemini")),
                            PopupMenuItem(value: "Chat-GPT", child: Text("Chat-GPT")),
                          ],
                          elevation: 4,
                        );

                        if (selected != null) {
                          setState(() => selectedModel = selected);
                        }
                      },
                      child: Container(
                        // small visible chip
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedModel,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ---------------------
                //  TEXT FIELD + MIC/SEND
                // ---------------------
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.controller.messageController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Ask something…",
                            border: InputBorder.none,
                            isDense: true, // tighter vertical layout
                            contentPadding: EdgeInsets.only(bottom: 5,top: 0),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (_) => widget.controller.sendMessage(),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          if (hasText) {
                            widget.controller.sendMessage();
                          } else {
                            // mic action placeholder
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: hasText
                              ? Container(
                            key: const ValueKey("send"),
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send, color: Colors.white),
                          )
                              : Container(
                            key: const ValueKey("mic"),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.mic_none_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
