import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/model/model_with_id.dart';
import 'package:codefactory/common/provider/pagination_provider.dart';
import 'package:codefactory/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    Key? key,
    required this.provider,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
              onPressed: () {
                ref.read(widget.provider.notifier).paginate(
                      forchRefetch: true,
                    );
              },
              child: const Text('다시시도')),
        ],
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = state as CursorPagination<T>;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(widget.provider.notifier).paginate(
                  forchRefetch: true,
                );
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller,
            itemCount: cp.data.length + 1,
            itemBuilder: (_, index) {
              if (index == cp.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                    child: cp is CursorPaginationFetchingMore
                        ? const CircularProgressIndicator()
                        : const Text('마지막 데이터입니다.'),
                  ),
                );
              }

              final pitem = cp.data[index];

              return widget.itemBuilder(context, index, pitem);
            },
            separatorBuilder: (_, index) => const SizedBox(height: 16.0),
          ),
        ));
  }
}
