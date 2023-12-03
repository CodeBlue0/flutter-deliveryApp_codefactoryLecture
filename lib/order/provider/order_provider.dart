import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/provider/pagination_provider.dart';
import 'package:codefactory/order/model/order_model.dart';
import 'package:codefactory/order/model/post_order_body.dart';
import 'package:codefactory/order/repository/order_repository.dart';
import 'package:codefactory/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderStateProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(
    ref: ref,
    repository: repo,
  );
});

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    // try {
    const uuid = Uuid();
    final id = uuid.v4();
    final state = ref.read(basketProvider);

    final resp = await repository.postOrder(
        body: PostOrderBody(
            id: id,
            products: state.map((e) {
              return PostOrderBodyProduct(
                  productId: e.product.id, count: e.count);
            }).toList(),
            totalPrice:
                state.fold(0, (p, n) => p + (n.count * n.product.price)),
            createdAt: DateTime.now().toString()));

    return true;
    // } catch (e) {
    //   return false;
    // }
  }
}
