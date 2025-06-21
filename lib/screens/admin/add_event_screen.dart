import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../services/db_helper.dart';
import '../../model/event_model.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _form = GlobalKey<FormState>();
  final _title    = TextEditingController();
  final _category = TextEditingController();
  final _desc     = TextEditingController();
  final _banner   = TextEditingController();
  DateTime _date  = DateTime.now().add(const Duration(days: 1));
  bool _saving = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _saving = true);
    await DBHelper().addEvent(
      Event(
        title: _title.text.trim(),
        category: _category.text.trim(),
        description: _desc.text.trim(),
        banner: _banner.text.trim().isEmpty
            ? 'https://picsum.photos/800/300?${DateTime.now().millisecondsSinceEpoch}'
            : _banner.text.trim(),
        date: _date,
      ),
    );
    setState(() => _saving = false);

    Navigator.pop(context, true); // tell caller that something was added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(3.w),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _txt(_title, 'Title'),
              SizedBox(height: 1.5.h),
              _txt(_category, 'Category'),
              SizedBox(height: 1.5.h),
              _txt(_desc, 'Description', maxLines: 3),
              SizedBox(height: 1.5.h),
              _txt(_banner, 'Banner URL (optional)'),
              SizedBox(height: 1.5.h),
              Row(
                children: [
                  Text('Date:  ${DateFormat.yMMMd().format(_date)}',
                      style: TextStyle(fontSize: 12.sp)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Pick'),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const CircularProgressIndicator()
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _txt(TextEditingController c, String label, {int maxLines = 1}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      validator: (v) =>
      v!.trim().isEmpty ? '$label required' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w)),
      ),
    );
  }
}
