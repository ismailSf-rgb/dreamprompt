import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ideahub/bloc/prompt_bloc.dart';
import 'package:ideahub/bloc/prompt_event.dart';
import 'package:ideahub/bloc/prompt_state.dart';
import 'package:ideahub/model/answer.dart';
import 'package:ideahub/model/prompt.dart';

// ── Constants ────────────────────────────────────────────────────────────────

const _kModels = [
  'GPT-4 Turbo',
  'Claude 3 Opus',
  'Claude 3.5 Sonnet',
  'Gemini 1.5 Pro',
  'Llama 3',
  'Mistral Large',
];

const _kCategories = [
  'Coding',
  'Writing',
  'Analysis',
  'Creative',
  'Education',
  'Productivity',
];

const _kBg = Color(0xFF0A0A14);
const _kCard = Color(0xFF13131F);
const _kBorder = Color(0xFF252538);
const _kField = Color(0xFF1A1A28);
const _kPurple = Color(0xFF7C3AED);
const _kBlue = Color(0xFF3B82F6);

// ── Answer form data ─────────────────────────────────────────────────────────

class _AnswerForm {
  final TextEditingController contentController = TextEditingController();
  String source = _kModels.first;
  String category = _kCategories.first;

  void dispose() => contentController.dispose();
}

// ── Page ─────────────────────────────────────────────────────────────────────

class CreatePromptPage extends StatefulWidget {
  const CreatePromptPage({super.key});

  @override
  State<CreatePromptPage> createState() => _CreatePromptPageState();
}

class _CreatePromptPageState extends State<CreatePromptPage> {
  final _promptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<_AnswerForm> _answers = [];
  bool _isPosting = false;

  @override
  void dispose() {
    _promptController.dispose();
    for (final a in _answers) {
      a.dispose();
    }
    super.dispose();
  }

  void _addAnswer() {
    setState(() => _answers.add(_AnswerForm()));
  }

  void _removeAnswer(int index) {
    _answers[index].dispose();
    setState(() => _answers.removeAt(index));
  }

  void _post(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();

    final aiAnswers = _answers
        .where((a) => a.contentController.text.trim().isNotEmpty)
        .toList()
        .asMap()
        .entries
        .map(
          (e) => Answer(
            id: '${id}_a${e.key}',
            content: e.value.contentController.text.trim(),
            source: e.value.source,
            category: e.value.category,
            upvotes: 0,
            downvotes: 0,
            ownerId: 'me',
          ),
        )
        .toList();

    final prompt = Prompt(
      id: id,
      content: _promptController.text.trim(),
      ownerId: 'me',
      ownerAlias: 'me',
      ownerPictureUrl: '',
      createdDate: now,
      lastModifiedDate: now,
      aiAnswers: aiAnswers,
    );

    setState(() => _isPosting = true);
    context.read<PromptBloc>().add(AddItem(prompt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: BlocListener<PromptBloc, PromptState>(
          listener: (context, state) {
            if (!_isPosting) return;

            if (state.loadingResult.error != null) {
              setState(() => _isPosting = false);
              context.read<PromptBloc>().add(const ClearError());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  content: const Text('Failed to post prompt'),
                ),
              );
            } else if (!state.loadingResult.isInProgress) {
              GoRouter.of(context).pop();
            }
          },
          child: Column(
            children: [
              _TopBar(
                isPosting: _isPosting,
                onPost: () => _post(context),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    children: [
                      _PromptField(controller: _promptController),
                      const SizedBox(height: 24),
                      _AnswersHeader(
                        count: _answers.length,
                        onAdd: _addAnswer,
                      ),
                      const SizedBox(height: 12),
                      if (_answers.isEmpty) _EmptyAnswersHint(),
                      for (int i = 0; i < _answers.length; i++)
                        _AnswerCard(
                          key: ValueKey(i),
                          form: _answers[i],
                          index: i,
                          total: _answers.length,
                          onRemove: () => _removeAnswer(i),
                          onChanged: () => setState(() {}),
                        ),
                    ],
                  ),
                ),
              ),
              _PostButton(isPosting: _isPosting, onPost: () => _post(context)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool isPosting;
  final VoidCallback onPost;

  const _TopBar({required this.isPosting, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: Colors.white60, size: 22),
            onPressed: () => GoRouter.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'New Prompt',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ),
          if (isPosting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: _kPurple),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Prompt text field ────────────────────────────────────────────────────────

class _PromptField extends StatelessWidget {
  final TextEditingController controller;

  const _PromptField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label(text: 'Your Prompt', icon: Icons.edit_note_rounded),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.6,
          ),
          maxLines: null,
          minLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: _fieldDecoration(
            hint:
                'Describe the task, role, and behavior you want the AI to follow...',
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Prompt cannot be empty' : null,
        ),
      ],
    );
  }
}

// ── Answers section header ───────────────────────────────────────────────────

class _AnswersHeader extends StatelessWidget {
  final int count;
  final VoidCallback onAdd;

  const _AnswersHeader({required this.count, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.auto_awesome_rounded,
            size: 16, color: _kBlue),
        const SizedBox(width: 6),
        const Text(
          'AI Answers',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white70,
            letterSpacing: 0.3,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: _kBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: _kBlue),
            ),
          ),
        ],
        const Spacer(),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_kPurple, _kBlue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Add answer',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Empty hint ────────────────────────────────────────────────────────────────

class _EmptyAnswersHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_outlined,
              size: 32, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 10),
          Text(
            'No AI answers yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add responses from different models\nto enrich your prompt.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Answer card ──────────────────────────────────────────────────────────────

class _AnswerCard extends StatelessWidget {
  final _AnswerForm form;
  final int index;
  final int total;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _AnswerCard({
    super.key,
    required this.form,
    required this.index,
    required this.total,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
            child: Row(
              children: [
                _ModelDot(source: form.source),
                const SizedBox(width: 8),
                Text(
                  'Answer ${index + 1}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 18, color: Colors.white38),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),

          // Model picker
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
            child: _Label(text: 'Model', icon: null),
          ),
          _ChipPicker(
            options: _kModels,
            selected: form.source,
            colorOf: _modelColor,
            onSelected: (v) {
              form.source = v;
              onChanged();
            },
          ),

          const SizedBox(height: 10),

          // Category picker
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
            child: _Label(text: 'Category', icon: null),
          ),
          _ChipPicker(
            options: _kCategories,
            selected: form.category,
            colorOf: (_) => Colors.white24,
            selectedColor: _kPurple,
            onSelected: (v) {
              form.category = v;
              onChanged();
            },
          ),

          const SizedBox(height: 10),

          // Answer content
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
            child: _Label(text: 'Response', icon: null),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: TextFormField(
              controller: form.contentController,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, height: 1.6),
              maxLines: null,
              minLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: _fieldDecoration(
                hint:
                    'Paste or write the AI model\'s response to this prompt...',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Response cannot be empty'
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Post button ───────────────────────────────────────────────────────────────

class _PostButton extends StatelessWidget {
  final bool isPosting;
  final VoidCallback onPost;

  const _PostButton({required this.isPosting, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: _kBg,
        border: Border(
            top: BorderSide(
                color: _kBorder)),
      ),
      child: GestureDetector(
        onTap: isPosting ? null : onPost,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            gradient: isPosting
                ? null
                : const LinearGradient(
                    colors: [_kPurple, _kBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            color: isPosting ? _kBorder : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isPosting
                ? []
                : [
                    BoxShadow(
                      color: _kPurple.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: isPosting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white54),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.rocket_launch_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Post Prompt',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Chip picker ──────────────────────────────────────────────────────────────

class _ChipPicker extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Color Function(String) colorOf;
  final Color? selectedColor;
  final ValueChanged<String> onSelected;

  const _ChipPicker({
    required this.options,
    required this.selected,
    required this.colorOf,
    this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final opt = options[i];
          final isSelected = opt == selected;
          final accent = selectedColor ?? colorOf(opt);

          return GestureDetector(
            onTap: () => onSelected(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? accent.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? accent.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected && selectedColor == null) ...[
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    opt,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? accent : Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Small helpers ─────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  final IconData? icon;

  const _Label({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: Colors.white38),
          const SizedBox(width: 5),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ModelDot extends StatelessWidget {
  final String source;

  const _ModelDot({required this.source});

  @override
  Widget build(BuildContext context) {
    final color = _modelColor(source);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

InputDecoration _fieldDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.white.withValues(alpha: 0.2),
      fontSize: 14,
      height: 1.5,
    ),
    filled: true,
    fillColor: _kField,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kPurple, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(color: Color(0xFFEF4444), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(color: Color(0xFFEF4444), width: 1.5),
    ),
    errorStyle: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
  );
}

Color _modelColor(String source) {
  final s = source.toLowerCase();
  if (s.contains('gpt') || s.contains('openai')) return const Color(0xFF10B981);
  if (s.contains('claude') || s.contains('anthropic')) return const Color(0xFFF97316);
  if (s.contains('gemini') || s.contains('google')) return const Color(0xFF3B82F6);
  if (s.contains('llama') || s.contains('meta')) return const Color(0xFFA855F7);
  if (s.contains('mistral')) return const Color(0xFF06B6D4);
  return const Color(0xFF6B7280);
}
