import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/news_service.dart';
import '../providers/language_provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final news = await NewsService.getNews();
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('समाचार', 'News')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNews,
            tooltip: languageProvider.getText('रिफ्रेश', 'Refresh'),
          ),
        ],
      ),
      body: _buildBody(context, languageProvider),
    );
  }

  Widget _buildBody(BuildContext context, LanguageProvider languageProvider) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              languageProvider.getText(
                'समाचार लोड गर्न सकिएन',
                'Failed to load news',
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadNews,
              child: Text(
                languageProvider.getText('पुनः प्रयास गर्नुहोस्', 'Try Again'),
              ),
            ),
          ],
        ),
      );
    }

    if (_news.isEmpty) {
      return Center(
        child: Text(
          languageProvider.getText(
            'कुनै समाचार उपलब्ध छैन',
            'No news available',
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNews,
      child: ListView.builder(
        itemCount: _news.length,
        itemBuilder: (context, index) {
          final news = _news[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: news['imageUrl'] != null && news['imageUrl'].toString().isNotEmpty
                  ? Image.asset(
                      news['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.newspaper),
              title: Text(news['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    news['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        news['date'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        news['source'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // Show news detail in a dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(news['title']),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (news['imageUrl'] != null && news['imageUrl'].toString().isNotEmpty) ...[
                            Image.asset(
                              news['imageUrl'],
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 16),
                          ],
                          Text(news['description']),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                news['date'] ?? '',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                news['source'],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(languageProvider.getText('बन्द गर्नुहोस्', 'Close')),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
