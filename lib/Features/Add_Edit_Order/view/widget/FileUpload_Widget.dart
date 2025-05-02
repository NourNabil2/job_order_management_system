import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/alert_widget.dart';
import 'package:quality_management_system/Core/components/DialogAlertMessage.dart';

class FileUploadWidget extends StatefulWidget {
  final List<FileAttachment> attachments;
  final Function(List<FileAttachment>) onAttachmentsChanged;

  const FileUploadWidget({
    Key? key,
    required this.attachments,
    required this.onAttachmentsChanged,
  }) : super(key: key);

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: Theme.of(context).textTheme.titleMedium,
        ),
         SizedBox(height: SizeApp.s8),
        _buildDropZone(),
         SizedBox(height: SizeApp.s16),
        if (widget.attachments.isNotEmpty) _buildAttachmentsList(),
      ],
    );
  }

  Widget _buildDropZone() {
    return GestureDetector(
      onTap: _pickFiles,
      child: DragTarget<List<File>>(
        onWillAccept: (_) {
          setState(() => _isDragging = true);
          return true;
        },
        onAccept: (files) {
          setState(() => _isDragging = false);
          _handleDroppedFiles(files);
        },
        onLeave: (_) {
          setState(() => _isDragging = false);
        },
        builder: (context, candidateData, rejectedData) {
          return DottedBorder(
            color: _isDragging ? ColorApp.mainLight : Colors.grey,
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: const [8, 4],
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(SizeApp.defaultPadding),
              decoration: BoxDecoration(
                color: _isDragging
                    ? ColorApp.mainLight.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: _isDragging ? ColorApp.mainLight : Colors.grey,
                  ),
                   SizedBox(height: SizeApp.s16),
                  Text(
                    'Drag and drop files here',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                   SizedBox(height: SizeApp.s8),
                  Text(
                    'or',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                   SizedBox(height: SizeApp.s8),
                  ElevatedButton(
                    onPressed: _pickFiles,
                    child: const Text('Browse Files'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttachmentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Files (${widget.attachments.length})',
          style: Theme.of(context).textTheme.titleSmall,
        ),
         SizedBox(height: SizeApp.s8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.attachments.length,
          itemBuilder: (context, index) {
            final attachment = widget.attachments[index];
            return Card(
              margin: EdgeInsets.only(bottom: SizeApp.s8),
              child: ListTile(
                leading: _getFileIcon(attachment.fileName),
                title: Text(
                  attachment.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _formatFileSize(attachment.fileSize),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeAttachment(index),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final newAttachments = result.files.map((file) {
          final path = file.path;
          if (path == null) {
            throw Exception('File path is null');
          }

          return FileAttachment(
            fileName: file.name,
            filePath: path,
            fileSize: file.size,
            file: File(path),
          );
        }).toList();

        // Check file size limit (10MB)
        for (var attachment in newAttachments) {
          if (attachment.fileSize > 10 * 1024 * 1024) {
            showCustomOptionsDialog(
              title: 'Wrong',
              content: 'File ${attachment.fileName} exceeds 10MB limit',
              onConfirm: () {},
              context: context, confirmText: 'OK',
            );
            return;
          }
        }

        final updatedAttachments = [...widget.attachments, ...newAttachments];
        widget.onAttachmentsChanged(updatedAttachments);
      }
    } catch (e) {
      log('$e');
      showCustomOptionsDialog(
        title: 'Wrong',
        content: 'Error picking files: $e',
        onConfirm: () {},
        context: context, confirmText: 'OK',
      );
    }
  }

  void _handleDroppedFiles(List<File> files) {
    final newAttachments = files.map((file) {
      return FileAttachment(
        fileName: file.path.split('/').last,
        filePath: file.path,
        fileSize: file.lengthSync(),
      );
    }).toList();

    final updatedAttachments = [...widget.attachments, ...newAttachments];
    widget.onAttachmentsChanged(updatedAttachments);
  }

  void _removeAttachment(int index) {
    final updatedAttachments = List<FileAttachment>.from(widget.attachments);
    updatedAttachments.removeAt(index);
    widget.onAttachmentsChanged(updatedAttachments);
  }

  Widget _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    IconData iconData;

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        iconData = Icons.image;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }

    return Icon(iconData, color: ColorApp.mainLight);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

class FileAttachment {
  final String fileName;
  final String filePath;
  final int fileSize;
  final File? file;

  FileAttachment({
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    this.file,
  });

  // Getter to access the file object
  File get path => File(filePath);
}