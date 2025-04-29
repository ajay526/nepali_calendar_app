import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class AdSection extends StatelessWidget {
  final String imageUrl;
  final String? linkUrl;
  final String? description;
  final double height;

  const AdSection({
    super.key,
    required this.imageUrl,
    this.linkUrl,
    this.description,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: height,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: linkUrl != null ? () => _launchUrl(linkUrl!) : null,
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              if (description != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    description!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
