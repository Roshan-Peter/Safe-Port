import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../parts/VulnerablePasswords.dart';
import '../parts/section_header.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  double _passwordLength = 12;
  String _generatedPassword = '';
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSpecialChars = true;

  @override
  void dispose() {
    super.dispose();
  }

  String _generatePassword() {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (_includeUppercase) chars += uppercase;
    if (_includeLowercase) chars += lowercase;
    if (_includeNumbers) chars += numbers;
    if (_includeSpecialChars) chars += specialChars;

    if (chars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one character type')),
      );
      return '';
    }

    int length = _passwordLength.toInt();
    final random = Random();
    String password = '';

    // Keep generating until we get a non-vulnerable password
    do {
      password = List.generate(
        length,
            (index) => chars[random.nextInt(chars.length)],
      ).join();
    } while (VulnerablePasswords.isVulnerable(password));

    return password;
  }

  void _copyToClipboard() {
    if (_generatedPassword.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? colorScheme.surface
          : colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Password Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generated Password Display
            Container(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text(
                        //   'Generated Password',
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.grey,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        Text(
                          _generatedPassword.isEmpty
                              ? ''
                              : _generatedPassword,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'monospace',
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 24),
                  if (_generatedPassword.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _copyToClipboard();
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy Password'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),

            const Divider(),
            const SizedBox(height: 24),


            SectionHeader(title: "Password Length",),
            // Password Length Slider

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _passwordLength,
                    min: 1,
                    max: 100,
                    divisions: 99,
                    label: _passwordLength.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _passwordLength = value;
                        setState(() {
                          _generatedPassword = _generatePassword();
                        });
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    _passwordLength.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Character Type Options

            Divider(),
            SectionHeader(title: "Include Characters",),

            const SizedBox(height: 12),


            //CheckBox

            Padding(padding: EdgeInsetsGeometry.all(15),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Uppercase (A-Z)'),
                    value: _includeUppercase,
                    onChanged: (value) {
                      setState(() => _includeUppercase = value ?? true);
                      setState(() {
                        _generatedPassword = _generatePassword();
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Lowercase (a-z)'),
                    value: _includeLowercase,
                    onChanged: (value) {
                      setState(() => _includeLowercase = value ?? true);
                      setState(() {
                        _generatedPassword = _generatePassword();
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Numbers (0-9)'),
                    value: _includeNumbers,
                    onChanged: (value) {
                      setState(() => _includeNumbers = value ?? true);
                      setState(() {
                        _generatedPassword = _generatePassword();
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Special Characters (!@#\$%^&*)'),
                    value: _includeSpecialChars,
                    onChanged: (value) {
                      setState(() => _includeSpecialChars = value ?? true);
                      setState(() {
                        _generatedPassword = _generatePassword();
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),


            const SizedBox(height: 18),


            Divider(),

            const SizedBox(height: 18),
            // Generate Button
            Padding(padding: EdgeInsetsGeometry.all(15),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _generatedPassword = _generatePassword();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Generate Password'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
