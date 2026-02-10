import 'package:flutter/material.dart';

class StepperConfig {
  static final Map<int, Map<String, dynamic>> stepConfigs = {
    0: {
      'title': 'Personal Details',
      'icon': Icons.person_outline,
      'labels': ['Personal', 'Skills', 'Details', 'Assignment', 'Documents', 'Availability'],
    },
    1: {
      'title': 'Skills & Profile',
      'icon': Icons.psychology_outlined,
      'labels': ['Personal', 'Skills', 'Details', 'Assignment', 'Documents', 'Availability'],
    },
    2: {
      'title': 'Other Details',
      'icon': Icons.language_outlined,
      'labels': ['Personal', 'Skills', 'Details', 'Assignment', 'Documents', 'Availability'],
    },
    3: {
      'title': 'Assignment',
      'icon': Icons.work_outline,
      'labels': ['Personal', 'Skills', 'Details', 'Assignment', 'Documents', 'Availability'],
    },
    4: {
      'title': 'Documents',
      'icon': Icons.school_outlined,
      'labels': ['Personal', 'Skills', 'Details', 'Assignment', 'Documents', 'Availability'],
    },
    5: {
      'title': 'Availability',
      'icon': Icons.folder_open_rounded,
      'labels': ['Personal', 'Skills', 'Details', 'Assignment', 'Documents', 'Availability'],
    },
  };
}