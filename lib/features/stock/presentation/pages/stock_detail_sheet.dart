import 'package:flutter/material.dart';
import 'package:stocker/core/theme/app_colors.dart';
import 'package:stocker/features/stock/domain/entities/stock_entity.dart';

class StockDetailSheet extends StatelessWidget {
  final StockEntity item;

  const StockDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 HANDLE
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            // 🔹 HEADER
            Row(
              children: [
                Icon(Icons.analytics, color: colors.primary),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                Text(
                  "Código: ${item.productCode}",
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.left,
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(color: AppColors.darkSecondaryText),

            const SizedBox(height: 8),

            // 🔹 LISTA (ESTILO EXTRATO)
            ...item.locations.map((loc) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DEPÓSITO
                    Text(
                      loc.deposit,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    if (loc.derivation.isNotEmpty)
                      Text(
                        "Derivação: ${loc.derivation}",
                        style: theme.textTheme.bodySmall,
                      ),

                    Text(
                      "Empresa: ${loc.companyCode}",
                      style: theme.textTheme.bodySmall,
                    ),

                    const SizedBox(height: 10),

                    // 🔹 GRID DE VALORES
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _metric("Disponível", loc.available, context),
                        _metric("Reservado", loc.reserved, context),
                        _metric("Bloqueado", loc.blocked, context),
                        _metric("Consig. Cliente", loc.consignClient, context),
                        _metric("Consig. Forn.", loc.consignSupplier, context),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, double value, BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.darkSecondaryText,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: ${value.toStringAsFixed(2)}",
        style: TextStyle(fontSize: 12, color: colors.inversePrimary),
      ),
    );
  }
}
