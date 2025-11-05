import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String? message;
  final String? imageUrl;
  final bool isMe;

  const ChatBubble({
    super.key,
    this.message,
    this.imageUrl,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: imageUrl != null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.blue
              : (imageUrl != null
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: isMe ? const Radius.circular(20.0) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(20.0),
          ),
        ),
        child: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  placeholder: (context, url) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.white.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            : Text(
                message ?? '',
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
