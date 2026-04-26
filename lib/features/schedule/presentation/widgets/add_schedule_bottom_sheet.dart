import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_input.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../domain/models/schedule_item.dart';
import '../providers/schedule_provider.dart';

class AddScheduleBottomSheet extends ConsumerStatefulWidget {
  final ScheduleItem? item;
  const AddScheduleBottomSheet({super.key, this.item});

  @override
  ConsumerState<AddScheduleBottomSheet> createState() => _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends ConsumerState<AddScheduleBottomSheet> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));
  String _type = 'campus';
  int _selectedDay = DateTime.now().weekday - 1; // 0=Mon, 6=Sun

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _locationController.text = widget.item!.location ?? '';
      _selectedDay = widget.item!.dayOfWeek;
      _type = widget.item!.type;
      
      // Parse times
      try {
        final startParts = widget.item!.startTime.split(':');
        final now = DateTime.now();
        _startTime = DateTime(now.year, now.month, now.day, int.parse(startParts[0]), int.parse(startParts[1]));
        
        if (widget.item!.endTime != null) {
          final endParts = widget.item!.endTime!.split(':');
          _endTime = DateTime(now.year, now.month, now.day, int.parse(endParts[0]), int.parse(endParts[1]));
        }
      } catch (e) {
        debugPrint('Error parsing time: $e');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
    );

    if (pickedTime != null) {
      setState(() {
        final now = DateTime.now();
        final newDate = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
        if (isStart) {
          _startTime = newDate;
          if (_endTime.isBefore(_startTime)) {
            _endTime = _startTime.add(const Duration(hours: 1));
          }
        } else {
          _endTime = newDate;
        }
      });
    }
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    if (widget.item != null) {
      final updatedItem = widget.item!.copyWith(
        title: _titleController.text.trim(),
        dayOfWeek: _selectedDay,
        startTime: DateFormat('HH:mm').format(_startTime),
        endTime: DateFormat('HH:mm').format(_endTime),
        type: _type,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      );
      ref.read(scheduleProvider.notifier).updateSchedule(updatedItem);
    } else {
      final newItem = ScheduleItem(
        id: const Uuid().v4(),
        userId: user.id,
        title: _titleController.text.trim(),
        dayOfWeek: _selectedDay,
        startTime: DateFormat('HH:mm').format(_startTime),
        endTime: DateFormat('HH:mm').format(_endTime),
        type: _type,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      );
      ref.read(scheduleProvider.notifier).addSchedule(newItem);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: NexusColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'New Schedule',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: NexusColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GlassInput(
            controller: _titleController,
            hintText: 'Activity Title',
            autoFocus: true,
          ),
          const SizedBox(height: 12),
          GlassInput(
            controller: _locationController,
            hintText: 'Location (Optional)',
            prefixIcon: const Icon(Icons.location_on, color: NexusColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Text(
            'Hari',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: NexusColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'
              ].asMap().entries.map((entry) {
                final isSelected = _selectedDay == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedDay = entry.key);
                    },
                    backgroundColor: NexusColors.surfaceGlass,
                    selectedColor: NexusColors.accentLavender.withValues(alpha: 0.2),
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? NexusColors.accentLavender : NexusColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTimePicker('Start Time', _startTime, () => _pickTime(true)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimePicker('End Time', _endTime, () => _pickTime(false)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Type',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: NexusColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              {'label': 'Kampus', 'value': 'campus'},
              {'label': "Ma'had", 'value': 'mahad'},
              {'label': 'Lainnya', 'value': 'other'},
            ].map((t) {
              final isSelected = _type == t['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(t['label']!),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _type = t['value']!);
                  },
                  backgroundColor: NexusColors.surfaceGlass,
                  selectedColor: NexusColors.accentLavender.withValues(alpha: 0.2),
                  labelStyle: GoogleFonts.inter(
                    color: isSelected ? NexusColors.accentLavender : NexusColors.textSecondary,
                    fontSize: 13,
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
            ),
            child: Text(
              widget.item != null ? 'Update Schedule' : 'Add to Schedule',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, DateTime time, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: NexusColors.textSecondary),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: NexusColors.surfaceGlass,
              border: Border.all(color: NexusColors.glassBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: NexusColors.accentLavender),
                const SizedBox(width: 8),
                Text(
                  DateFormat('HH:mm').format(time),
                  style: GoogleFonts.inter(color: NexusColors.textPrimary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
