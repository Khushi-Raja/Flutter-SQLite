import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/event_model.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final banner = event.banner;
    final isLocal = banner.startsWith('/'); // crude file path check

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLocal
              ? Image.file(
            File(banner),
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          )
              : Image.network(
            banner,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 140,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(DateFormat('MMM d, yyyy – h:mm a').format(event.date),
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Text(event.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
