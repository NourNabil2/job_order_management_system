import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentListViewer extends StatelessWidget {
  final List<String> attachmentLinks;

  const AttachmentListViewer({Key? key, required this.attachmentLinks}) : super(key: key);

  bool _isImage(String url) {
    return url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.png');
  }

  bool _isPDF(String url) {
    return url.endsWith('.pdf');
  }

  bool _isWord(String url) {
    return url.endsWith('.doc') || url.endsWith('.docx');
  }

  IconData _getFileIcon(String url) {
    if (_isPDF(url)) return Icons.picture_as_pdf;
    if (_isWord(url)) return Icons.description;
    return Icons.insert_drive_file;
  }

  Future<void> _openFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (attachmentLinks.isEmpty) {
      return const Text("لا توجد مرفقات.");
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attachmentLinks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final url = attachmentLinks[index];
        final fileName = url.split('/').last;

        if (_isImage(url)) {
          return GestureDetector(
            onTap: () => _openFile(url),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                url,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return ListTile(
            leading: Icon(_getFileIcon(url), size: 32, color: Colors.blue),
            title: Text(fileName, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => _openFile(url),
            ),
          );
        }
      },
    );
  }
}
