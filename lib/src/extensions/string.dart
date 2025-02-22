import 'package:flutter/material.dart';

extension StringX on String {
  IconData get fileIcon {
    switch (split('.').last.toLowerCase()) {
      // Code-related file types
      case 'dart':
        return Icons.flutter_dash;
      case 'js':
        return Icons.javascript;
      case 'html':
        return Icons.html;
      case 'css':
        return Icons.css;
      case 'json':
        return Icons.data_object;
      case 'java':
        return Icons.android;
      case 'c':
      case 'cpp':
      case 'h':
      case 'hpp':
      case 'go':
      case 'py':
      case 'rb':
      case 'rs':
      case 'ts':
        return Icons.code;
      case 'php':
        return Icons.php;
      case 'swift':
        return Icons.apple;
      case 'sh':
      case 'bash':
        return Icons.terminal;

      // Image file types
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'svg':
        return Icons.image;

      // Document file types
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;

      // Archive file types
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return Icons.archive;

      // Audio file types
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
        return Icons.audiotrack;

      // Video file types
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov':
        return Icons.video_library;

      // Text file types
      case 'txt':
        return Icons.text_fields;

      // Default fallback icon
      default:
        return Icons.insert_drive_file;
    }
  }
}
