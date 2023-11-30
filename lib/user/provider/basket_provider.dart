import 'package:codefactory/product/model/product_model.dart';
import 'package:codefactory/user/model/basket_item_model.dart';
import 'package:codefactory/user/model/patch_basket_body.dart';
import 'package:codefactory/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketProvider(repository: repository);
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
        body: PatchBasketBody(
            basket: state
                .map((e) => PatchBasketBodyBasket(
                    productId: e.product.id, count: e.count))
                .toList()));
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1) 아직 장바구닝에 해당되는 상품이 없다면
    //    장바구니에 상품을 추가한다.
    // 2) 장바구니에 해당되는 상품이 있다면
    //    수량을 증가시킨다.

    final exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (exists) {
      state = state.map((e) {
        if (e.product.id == product.id) {
          return e.copyWith(count: e.count + 1);
        } else {
          return e;
        }
      }).toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        )
      ];
    }
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false,
  }) async {
    // 1) 장바구니에 상품이 존재할 때
    //    1) 상품의 카운트가 1보다 크면 -1한다.
    //    2) 상품의 카운트가 1이면 장바구니에서 제거한다.
    // 2) 장바구니에 상품이 존재하지 않을 때
    //    아무것도 하지 않는다.

    final exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (!exists) {
      return;
    }

    final existiongProduct =
        state.firstWhere((element) => element.product.id == product.id);

    if (existiongProduct.count == 1 || isDelete) {
      state =
          state.where((element) => element.product.id != product.id).toList();
    } else {
      state = state.map((e) {
        if (e.product.id == product.id) {
          return e.copyWith(count: e.count - 1);
        } else {
          return e;
        }
      }).toList();
    }
    await patchBasket();
  }
}
