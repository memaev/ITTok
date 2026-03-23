import 'package:flutter/material.dart';

class TopicColors {
  TopicColors._();

  static const Map<String, Color> _colors = {
    'docker': Color(0xFF2496ED),
    'python': Color(0xFFFFD43B),
    'kotlin': Color(0xFF7F52FF),
    'cybersecurity': Color(0xFFFF4444),
    'networking': Color(0xFF00C853),
    'git': Color(0xFFF05032),
    'linux': Color(0xFFFCC624),
    'cloud': Color(0xFFFF9900),
    'databases': Color(0xFF00758F),
    'architecture': Color(0xFF6C63FF),
    'web': Color(0xFF61DBFB),
    'reactnative': Color(0xFF61DAFB),
  };

  static Color forTopic(String topicId) {
    return _colors[topicId.toLowerCase()] ?? const Color(0xFF6C63FF);
  }

  static Color forTopicWithOpacity(String topicId, double opacity) {
    return forTopic(topicId).withValues(alpha: opacity);
  }
}
