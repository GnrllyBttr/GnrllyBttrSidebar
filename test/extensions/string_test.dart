import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnrllybttr_sidebar/src/extensions/extensions.dart';

void main() {
  group('StringX Extension Tests', () {
    group('Code-related file types', () {
      test('should return correct icons for programming languages', () {
        expect('.dart'.fileIcon, equals(Icons.flutter_dash));
        expect('.js'.fileIcon, equals(Icons.javascript));
        expect('.html'.fileIcon, equals(Icons.html));
        expect('.css'.fileIcon, equals(Icons.css));
        expect('.json'.fileIcon, equals(Icons.data_object));
        expect('.java'.fileIcon, equals(Icons.android));
        expect('.php'.fileIcon, equals(Icons.php));
        expect('.swift'.fileIcon, equals(Icons.apple));
      });

      test('should return code icon for common programming languages', () {
        final codeFiles = [
          '.c',
          '.cpp',
          '.h',
          '.hpp',
          '.go',
          '.py',
          '.rb',
          '.rs',
          '.ts'
        ];
        for (final ext in codeFiles) {
          expect(ext.fileIcon, equals(Icons.code),
              reason: 'Failed for extension $ext');
        }
      });

      test('should return terminal icon for shell scripts', () {
        expect('.sh'.fileIcon, equals(Icons.terminal));
        expect('.bash'.fileIcon, equals(Icons.terminal));
      });

      test('should handle uppercase extensions', () {
        expect('.DART'.fileIcon, equals(Icons.flutter_dash));
        expect('.JS'.fileIcon, equals(Icons.javascript));
      });
    });

    group('Image file types', () {
      test('should return image icon for all image formats', () {
        final imageFiles = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg'];
        for (final ext in imageFiles) {
          expect(ext.fileIcon, equals(Icons.image),
              reason: 'Failed for extension $ext');
        }
      });

      test('should handle mixed case image extensions', () {
        expect('.PNG'.fileIcon, equals(Icons.image));
        expect('.Jpg'.fileIcon, equals(Icons.image));
      });
    });

    group('Document file types', () {
      test('should return PDF icon for PDF files', () {
        expect('.pdf'.fileIcon, equals(Icons.picture_as_pdf));
      });

      test('should return description icon for Word documents', () {
        expect('.doc'.fileIcon, equals(Icons.description));
        expect('.docx'.fileIcon, equals(Icons.description));
      });

      test('should return table chart icon for Excel files', () {
        expect('.xls'.fileIcon, equals(Icons.table_chart));
        expect('.xlsx'.fileIcon, equals(Icons.table_chart));
      });

      test('should return slideshow icon for PowerPoint files', () {
        expect('.ppt'.fileIcon, equals(Icons.slideshow));
        expect('.pptx'.fileIcon, equals(Icons.slideshow));
      });
    });

    group('Archive file types', () {
      test('should return archive icon for compressed files', () {
        final archiveFiles = ['.zip', '.rar', '.7z', '.tar', '.gz'];
        for (final ext in archiveFiles) {
          expect(ext.fileIcon, equals(Icons.archive),
              reason: 'Failed for extension $ext');
        }
      });
    });

    group('Audio file types', () {
      test('should return audiotrack icon for audio files', () {
        final audioFiles = ['.mp3', '.wav', '.flac', '.aac'];
        for (final ext in audioFiles) {
          expect(ext.fileIcon, equals(Icons.audiotrack),
              reason: 'Failed for extension $ext');
        }
      });
    });

    group('Video file types', () {
      test('should return video library icon for video files', () {
        final videoFiles = ['.mp4', '.avi', '.mkv', '.mov'];
        for (final ext in videoFiles) {
          expect(ext.fileIcon, equals(Icons.video_library),
              reason: 'Failed for extension $ext');
        }
      });
    });

    group('Text file types', () {
      test('should return text fields icon for txt files', () {
        expect('.txt'.fileIcon, equals(Icons.text_fields));
      });
    });

    group('Edge cases and defaults', () {
      test('should return default icon for unknown extensions', () {
        expect('.unknown'.fileIcon, equals(Icons.insert_drive_file));
        expect('.xyz'.fileIcon, equals(Icons.insert_drive_file));
      });

      test('should handle empty string', () {
        expect(''.fileIcon, equals(Icons.insert_drive_file));
      });

      test('should handle string without extension', () {
        expect('filename'.fileIcon, equals(Icons.insert_drive_file));
      });

      test('should handle extension only', () {
        expect('.'.fileIcon, equals(Icons.insert_drive_file));
      });

      test('should handle multiple dots', () {
        expect('file.tar.gz'.fileIcon, equals(Icons.archive));
        expect('archive.zip.backup'.fileIcon, equals(Icons.insert_drive_file));
      });
    });
  });
}
