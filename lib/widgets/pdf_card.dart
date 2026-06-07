import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pdf_document.dart';

class PdfCard extends StatelessWidget {
  final PdfDocumentModel pdf;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final Function(PdfDocumentModel)? onDelete;

  const PdfCard({
    Key? key,
    required this.pdf,
    required this.onTap,
    required this.onFavoriteTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.picture_as_pdf,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          pdf.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${pdf.size} • ${DateFormat.yMMMd().format(DateTime.parse(pdf.lastOpened))}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                pdf.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: pdf.isFavorite ? Colors.red : null,
              ),
              onPressed: onFavoriteTap,
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  _showOptions(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('File Information'),
                onTap: () {
                  Navigator.pop(context);
                  _showDetails(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete from History', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete!(pdf);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('File Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Name', pdf.name),
              _detailRow('Size', pdf.size),
              _detailRow('Pages', pdf.pageCount.toString()),
              _detailRow('Path', pdf.path),
              _detailRow('Added', DateFormat.yMMMd().add_jm().format(DateTime.parse(pdf.dateAdded))),
              _detailRow('Last Opened', DateFormat.yMMMd().add_jm().format(DateTime.parse(pdf.lastOpened))),
              _detailRow('Progress', '${(pdf.readingProgress * 100).toStringAsFixed(1)}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
