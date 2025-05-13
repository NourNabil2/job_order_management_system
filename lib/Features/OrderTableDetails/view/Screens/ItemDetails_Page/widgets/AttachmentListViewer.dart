import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/FullScreenImagePage.dart';
import 'package:quality_management_system/Core/Widgets/custom_cache_image_widget.dart';
import 'package:quality_management_system/Core/Widgets/header_section.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentGridViewer extends StatelessWidget {
  final List<String> attachmentLinks;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final String title;

  const AttachmentGridViewer({
    Key? key,
    required this.attachmentLinks,
    required this.title,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.crossAxisCount = 2,
  }) : super(key: key);

  bool _isImage(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.gif');
  }

  bool _isPDF(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  bool _isWord(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.doc') || lowerUrl.endsWith('.docx');
  }

  Color _getFileColor(String url) {
    if (_isPDF(url)) return Colors.red;
    if (_isWord(url)) return Colors.blue;
    if (_isImage(url)) return Colors.green;
    return Colors.grey;
  }

  String _getFileType(String url) {
    if (_isPDF(url)) return 'PDF';
    if (_isWord(url)) return 'Word';
    if (_isImage(url)) return 'Image';
    return 'File';
  }

  IconData _getFileIcon(String url) {
    if (_isPDF(url)) return Icons.picture_as_pdf;
    if (_isWord(url)) return Icons.description;
    if (_isImage(url)) return Icons.image;
    return Icons.insert_drive_file;
  }

  Future<void> _openFile(String url, BuildContext context) async {
    try {

      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open file: ${e.toString()}')),
      );
    }
  }

  Widget _buildImageAttachment(String url, String fileName,context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder:  (context) => FullScreenImagePage(imageUrl: url),)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(url)

          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileAttachment(String url, String fileName) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getFileIcon(url),
              size: 40,
              color: _getFileColor(url),
            ),
            const SizedBox(height: 8),
            Text(
              _getFileType(url),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getFileColor(url),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              fileName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (attachmentLinks.isEmpty) {
      return const Center(
        child: Text(
          "لا توجد مرفقات",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 10,),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 1 : 4,
          ),
          itemCount: attachmentLinks.length,
          itemBuilder: (context, index) {
            final url = attachmentLinks[index];
            final fileName = url.split('/').last;

            return GestureDetector(
              onTap: () => _openFile(url, context),
              child: _isImage(url)
                  ? _buildImageAttachment(url, fileName,context)
                  : _buildFileAttachment(url, fileName),
            );
          },
        ),
      ],
    );
  }
}