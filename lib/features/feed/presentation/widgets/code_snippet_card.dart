import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';

class CodeSnippetCard extends StatelessWidget {
  const CodeSnippetCard({super.key, required this.card});

  final ContentCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.primaryAccent.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.code, size: 14, color: AppTheme.primaryAccent),
                  const SizedBox(width: 6),
                  Text(
                    (card.language ?? 'code').toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: AppTheme.primaryAccent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _CopyButton(code: card.codeSnippet ?? ''),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          card.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          card.body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
        if (card.codeSnippet != null) _CodeBlock(code: card.codeSnippet!, language: card.language ?? 'bash'),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code, required this.language});

  final String code;
  final String language;

  String _normalizeLanguage(String lang) {
    const map = {
      'dockerfile': 'dockerfile',
      'yaml': 'yaml',
      'bash': 'bash',
      'shell': 'bash',
      'python': 'python',
      'kotlin': 'kotlin',
      'javascript': 'javascript',
      'js': 'javascript',
      'typescript': 'typescript',
      'ts': 'typescript',
      'dart': 'dart',
      'http': 'http',
      'json': 'json',
      'sql': 'sql',
    };
    return map[lang.toLowerCase()] ?? 'bash';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HighlightView(
            code,
            language: _normalizeLanguage(language),
            theme: atomOneDarkTheme,
            padding: const EdgeInsets.all(16),
            textStyle: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code});
  final String code;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copy,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _copied ? Icons.check : Icons.copy,
          key: ValueKey(_copied),
          size: 18,
          color: _copied ? Colors.green : AppTheme.textSecondary,
        ),
      ),
    );
  }
}
