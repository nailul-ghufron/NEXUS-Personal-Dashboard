import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_input.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../domain/models/checklist_item.dart';
import '../providers/checklist_provider.dart';

class AddChecklistBottomSheet extends ConsumerStatefulWidget {
  const AddChecklistBottomSheet({super.key});

  @override
  ConsumerState<AddChecklistBottomSheet> createState() => _AddChecklistBottomSheetState();
}

class _AddChecklistBottomSheetState extends ConsumerState<AddChecklistBottomSheet> {
  final _titleController = TextEditingController();
  String _category = 'daily';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final newItem = ChecklistItem(
      id: const Uuid().v4(),
      userId: user.id,
      title: _titleController.text.trim(),
      category: _category,
      createdAt: DateTime.now(),
    );

    ref.read(checklistProvider.notifier).addItem(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: NexusColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Task',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: NexusColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: NexusColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlassInput(
            controller: _titleController,
            hintText: 'What needs to be done?',
            autoFocus: true,
          ),
          const SizedBox(height: 20),
          Text(
            'Category',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: NexusColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              {'label': 'Harian', 'value': 'daily'},
              {'label': 'Mingguan', 'value': 'weekly'},
              {'label': 'Custom', 'value': 'custom'},
            ].map((c) {
              final isSelected = _category == c['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(c['label']!),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _category = c['value']!);
                  },
                  backgroundColor: NexusColors.surfaceGlass,
                  selectedColor: NexusColors.accentLavender.withValues(alpha: 0.2),
                  labelStyle: GoogleFonts.inter(
                    color: isSelected ? NexusColors.accentLavender : NexusColors.textSecondary,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected ? NexusColors.accentLavender : NexusColors.glassBorder,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: NexusColors.accentLavender,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              'Add Task',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),);
  }
}
