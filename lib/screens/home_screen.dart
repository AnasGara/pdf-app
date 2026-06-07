import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pdf_document.dart';
import '../providers/pdf_provider.dart';
import '../widgets/pdf_card.dart';
import '../widgets/section_header.dart';
import 'reader_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Reader Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<PdfProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              if (provider.recentPdfs.isNotEmpty)
                _buildContinueReading(context, provider),

              if (provider.recentPdfs.isNotEmpty)
                SliverToBoxAdapter(
                  child: SectionHeader(title: 'Recent Files'),
                ),
              if (provider.recentPdfs.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final pdf = provider.recentPdfs[index];
                      return PdfCard(
                        pdf: pdf,
                        onTap: () => _openPdf(context, pdf),
                        onFavoriteTap: () => provider.toggleFavorite(pdf),
                        onDelete: (p) => provider.deletePdf(p.id!),
                      );
                    },
                    childCount: provider.recentPdfs.length,
                  ),
                ),

              if (provider.favoritePdfs.isNotEmpty)
                SliverToBoxAdapter(
                  child: SectionHeader(title: 'Favorites'),
                ),
              if (provider.favoritePdfs.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final pdf = provider.favoritePdfs[index];
                      return PdfCard(
                        pdf: pdf,
                        onTap: () => _openPdf(context, pdf),
                        onFavoriteTap: () => provider.toggleFavorite(pdf),
                        onDelete: (p) => provider.deletePdf(p.id!),
                      );
                    },
                    childCount: provider.favoritePdfs.length,
                  ),
                ),

              if (provider.allPdfs.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('No PDFs found', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _pickFile(context, provider),
                          icon: const Icon(Icons.add),
                          label: const Text('Open PDF'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickFile(context, Provider.of<PdfProvider>(context, listen: false)),
        icon: const Icon(Icons.file_open),
        label: const Text('Open PDF'),
      ),
    );
  }

  Widget _buildContinueReading(BuildContext context, PdfProvider provider) {
    final lastPdf = provider.recentPdfs.first;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Continue Reading'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: InkWell(
                onTap: () => _openPdf(context, lastPdf),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle_outline, size: 48),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lastPdf.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: lastPdf.readingProgress,
                              backgroundColor: Colors.white24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Page ${lastPdf.lastPage + 1} of ${lastPdf.pageCount}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPdf(BuildContext context, PdfDocumentModel pdf) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReaderScreen(pdf: pdf),
      ),
    );
  }

  Future<void> _pickFile(BuildContext context, PdfProvider provider) async {
    final pdf = await provider.pickAndAddPdf();
    if (pdf != null && context.mounted) {
      _openPdf(context, pdf);
    }
  }
}
