import 'package:schola/barrel.dart';

import 'package:flutter/material.dart';

class EditFieldPage extends StatefulWidget {
  final String field;
  final String? currentValue;
  final User user;

  const EditFieldPage({
    super.key,
    required this.field,
    this.currentValue,
    required this.user,
  });

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveField() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSaving = true);
      try {
        final newValue = _controller.text.trim();
        User updatedUser;
        switch (widget.field) {
          case 'Username':
            updatedUser = widget.user.copyWith(displayUsername: newValue);
            break;
          case 'Schedule URL':
            updatedUser = widget.user.copyWith(
              scheduleURL: newValue.isEmpty ? "" : newValue,
            );
            break;
          default:
            updatedUser = widget.user;
        }
        await Amplify.DataStore.save(updatedUser);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Updated')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Edit ${widget.field}'),
        elevation: 0,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        actions: [
          if (widget.field == 'Schedule URL')
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupWebcal()),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  labelText: widget.field,
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF39FF14), // Green accent
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType:
                    widget.field == 'Schedule URL'
                        ? TextInputType.url
                        : TextInputType.text,
                validator: (value) {
                  if (widget.field == 'Username') {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username cannot be empty';
                    }
                    if (value.trim().length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                  }
                  if (widget.field == 'Schedule URL' &&
                      value != null &&
                      value.trim().isNotEmpty &&
                      !RegExp(
                        r'^(webcal|http|https)://',
                      ).hasMatch(value.trim())) {
                    return 'Enter a valid URL (webcal://, http://, or https://)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isSaving ? null : _saveField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[850],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
