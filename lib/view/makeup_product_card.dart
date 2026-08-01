import 'package:flutter/material.dart';

import '../model/makeup_product.dart';

class MakeupProductCard extends StatelessWidget {
  const MakeupProductCard({super.key, required this.product});

  final MakeupProduct product;

  @override
  Widget build(BuildContext context) {
    final priceLabel = product.priceSign != null && product.priceSign!.isNotEmpty
        ? '${product.priceSign}${product.price}'
        : product.price;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Image.network(
              product.imageLink.isNotEmpty
                  ? product.imageLink
                  : 'https://via.placeholder.com/300x300?text=No+Image',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.image_not_supported_outlined, size: 40),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.pink.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    priceLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (product.tagList.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: product.tagList
                          .take(3)
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
