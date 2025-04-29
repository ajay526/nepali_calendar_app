import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/forex_service.dart';

class ForexScreen extends StatefulWidget {
  const ForexScreen({Key? key}) : super(key: key);

  @override
  _ForexScreenState createState() => _ForexScreenState();
}

class _ForexScreenState extends State<ForexScreen> {
  List<Map<String, dynamic>> _exchangeRates = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
  }

  Future<void> _loadExchangeRates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rates = await ForexService.getExchangeRates();
      setState(() {
        _exchangeRates = rates;
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
        title: Text(languageProvider.getText('विदेशी मुद्रा', 'Forex')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExchangeRates,
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
                'विदेशी मुद्रा दर लोड गर्न सकिएन',
                'Failed to load exchange rates',
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadExchangeRates,
              child: Text(
                languageProvider.getText('पुनः प्रयास गर्नुहोस्', 'Try Again'),
              ),
            ),
          ],
        ),
      );
    }

    if (_exchangeRates.isEmpty) {
      return Center(
        child: Text(
          languageProvider.getText(
            'कुनै विदेशी मुद्रा दर उपलब्ध छैन',
            'No exchange rates available',
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadExchangeRates,
      child: ListView.builder(
        itemCount: _exchangeRates.length,
        itemBuilder: (context, index) {
          final currency = _exchangeRates[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Text(
                currency['flag'],
                style: const TextStyle(fontSize: 24),
              ),
              title: Text('${currency['currency']} - ${currency['country']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        languageProvider.getText('खरिद:', 'Buy:'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ForexService.formatRate(currency['buyRate']),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        languageProvider.getText('बिक्री:', 'Sell:'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ForexService.formatRate(currency['sellRate']),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        languageProvider.getText('परिवर्तन:', 'Change:'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currency['change'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ForexService.getChangeColor(currency['change']),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
