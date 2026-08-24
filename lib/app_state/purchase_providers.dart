import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/purchase_product.dart';
import 'repository_providers.dart';

final purchaseProductsStreamProvider = StreamProvider<List<PurchaseProduct>>(
  (ref) => ref.watch(purchaseRepositoryProvider).watchProducts(),
);
