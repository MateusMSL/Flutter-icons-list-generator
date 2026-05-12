// generate_icons.dart

import 'dart:io';

void main() async {
  final flutterPath = Platform.environment['FLUTTER_ROOT'];

  if (flutterPath == null) {
    print('FLUTTER_ROOT not found');
    return;
  }

  final iconsFile = File(
    '$flutterPath/packages/flutter/lib/src/material/icons.dart',
  );

  if (!iconsFile.existsSync()) {
    print('icons.dart not found');
    return;
  }

  final content = await iconsFile.readAsString();

  final regex = RegExp(
    r'static const IconData (\w+) = IconData',
  );

  final matches = regex.allMatches(content);

  final buffer = StringBuffer();

  buffer.writeln(
    "import 'package:flutter/material.dart';",
  );

  buffer.writeln();

  buffer.writeln('class AppIcons {');

  buffer.writeln(
    '  static const IconData fallback = Icons.help_outline;',
  );

  buffer.writeln();

  buffer.writeln(
    '  static final Map<String, IconData> map = {',
  );

  for (final match in matches) {
    final name = match.group(1)!;

    buffer.writeln(
      "    '$name': Icons.$name,",
    );
  }

  buffer.writeln('  };');

  buffer.writeln();

  buffer.writeln('  static IconData get(');

  buffer.writeln('    String? name, {');

  buffer.writeln(
    '      IconData? placeholder,',
  );

  buffer.writeln('  }) {');

  buffer.writeln(
    '    if (name == null || name.isEmpty) {',
  );

  buffer.writeln(
    '      return placeholder ?? fallback;',
  );

  buffer.writeln('    }');

  buffer.writeln();

  buffer.writeln(
    '    return map[name] ?? placeholder ?? fallback;',
  );

  buffer.writeln('  }');

  buffer.writeln('}');

  final output = File(
    'app_icons.dart',
  );

  await output.writeAsString(
    buffer.toString(),
  );

  print(
    'File generatede with ${matches.length} icons',
  );
}

//dart run generate_icons.dart