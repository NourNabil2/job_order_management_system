import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/alert_widget.dart';
import 'package:quality_management_system/Core/components/DialogAlertMessage.dart';

class FileAttachment {
  final String fileName;
  final String filePath;
  final int fileSize;
  final dynamic fileData; // File for mobile, Uint8List for web

  FileAttachment({
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    this.fileData,
  });

  // For compatibility with existing code
  File get fileObject => kIsWeb ? throw UnsupportedError('Cannot get File object on web') : File(filePath);

  // Convert platform-specific object to bytes
  Future<Uint8List> getBytes() async {
    if (kIsWeb) {
      return fileData as Uint8List;
    } else {
      return await File(filePath).readAsBytes();
    }
  }
}

