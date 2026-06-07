import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:provider/provider.dart';
import '../models/pdf_document.dart';
import '../models/bookmark.dart';
import '../providers/pdf_provider.dart';
import '../repositories/pdf_repository.dart';

class ReaderScreen extends StatefulWidget {
  final PdfDocumentModel pdf;

  const ReaderScreen({Key? key, required this.pdf}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfRepository _repository = PdfRepository();

  int _currentPage = 0;
  int _totalPages = 0;
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    _currentPage = widget.pdf.lastPage;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.pdf.lastPage > 0) {
        _showResumeDialog();
      }
    });
  }

  void _showResumeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resume Reading'),
        content: Text('Do you want to resume from page ${widget.pdf.lastPage + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Over'),
          ),
          ElevatedButton(
            onPressed: () {
              _pdfViewerController.jumpToPage(widget.pdf.lastPage + 1);
              Navigator.pop(context);
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  _searchResult = _pdfViewerController.searchText(value);
                  _searchResult.addListener(() {
                    if (mounted) setState(() {});
                  });
                },
              )
            : Text(widget.pdf.name),
        actions: [
          if (_isSearchOpen)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearchOpen = false;
                  _searchResult.clear();
                  _searchController.clear();
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearchOpen = true),
            ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: _addBookmark,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Bookmarks'),
                onTap: _showBookmarks,
              ),
              PopupMenuItem(
                child: const Text('Horizontal Scroll'),
                onTap: () {
                  // Toggle scroll direction if supported or show message
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchResult.hasResult)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Row(
                children: [
                  Text('${_searchResult.currentInstanceIndex} of ${_searchResult.totalInstanceCount}'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: () => _searchResult.previousInstance(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.navigate_next),
                    onPressed: () => _searchResult.nextInstance(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SfPdfViewer.file(
              File(widget.pdf.path),
              key: _pdfViewerKey,
              controller: _pdfViewerController,
              onPageChanged: (PdfPageChangedDetails details) {
                setState(() {
                  _currentPage = details.newPageNumber - 1;
                });
                _updateProgress();
              },
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  _totalPages = details.document.pages.count;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text('${_currentPage + 1} / $_totalPages'),
              Expanded(
                child: Slider(
                  value: _currentPage.toDouble(),
                  min: 0,
                  max: (_totalPages > 0 ? _totalPages - 1 : 0).toDouble(),
                  onChanged: (value) {
                    _pdfViewerController.jumpToPage(value.toInt() + 1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProgress() {
    if (_totalPages > 0) {
      double progress = (_currentPage + 1) / _totalPages;
      Provider.of<PdfProvider>(context, listen: false)
          .updateProgress(widget.pdf, _currentPage, progress);
    }
  }

  Future<void> _addBookmark() async {
    final titleController = TextEditingController(text: 'Page ${_currentPage + 1}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Bookmark'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _repository.addBookmark(BookmarkModel(
                pdfId: widget.pdf.id!,
                pageNumber: _currentPage + 1,
                title: titleController.text,
                dateAdded: DateTime.now().toIso8601String(),
              ));
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBookmarks() async {
    final bookmarks = await _repository.getBookmarks(widget.pdf.id!);
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final b = bookmarks[index];
          return ListTile(
            title: Text(b.title),
            subtitle: Text('Page ${b.pageNumber}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await _repository.deleteBookmark(b.id!);
                Navigator.pop(context);
                _showBookmarks();
              },
            ),
            onTap: () {
              _pdfViewerController.jumpToPage(b.pageNumber);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
