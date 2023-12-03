import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/model/model_with_id.dart';
import 'package:codefactory/common/model/pagination_params.dart';
import 'package:codefactory/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져오기
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading
    bool forchRefetch = false,
  }) async {
    // try {
    // 5가지 가능성
    // State의 상태
    // [상태가]
    // 1) CursorPagination - 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
    // 3) CursorPaginationError - 데이터 로딩중 에러가 발생한 상태
    // 4) CursorPaginationRefetching - 데이터를 다시 로딩중인 상태 (현재 캐시 있음)
    // 5) CursorPaginationFetchingMore - 추가 데이터를 가져오는 상태

    // 바로 반환하는 상황
    // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
    // 2) 로딩중 - fetchMore = true
    //   fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.

    if (state is CursorPagination && !forchRefetch) {
      final pState = state as CursorPagination<T>;

      if (!pState.meta.hasMore) {
        return;
      }
    }

    final isLoading = state is CursorPaginationLoading;
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFetchingMore;

    // 2번 반환 상황
    if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
      return;
    }

    // PaginationParams 생성
    PaginationParams paginationParams = PaginationParams(
      count: fetchCount,
    );

    // fetchMore
    // 데이터를 추가로 더 가져오는 상황
    if (fetchMore) {
      final pState = state as CursorPagination<T>;

      state = CursorPaginationFetchingMore<T>(
        meta: pState.meta,
        data: pState.data,
      );

      paginationParams = paginationParams.copyWith(after: pState.data.last.id);
    }
    // 데이터를 처음부터 가져오는 상황
    else {
      // 만약에 데이터가 있는 상황이라면
      // 기존 데이터를 보존한 채로 Fetch (API 요청)을 진행
      if (state is CursorPagination && !forchRefetch) {
        final pState = state as CursorPagination<T>;
        state =
            CursorPaginationRefetching<T>(meta: pState.meta, data: pState.data);
      }
      // 나머지 상황
      else {
        state = CursorPaginationLoading();
      }
    }

    final resp = await repository.paginate(
      paginationParams: paginationParams,
    );
    if (state is CursorPaginationFetchingMore) {
      final pState = state as CursorPaginationFetchingMore<T>;
      state = resp.copyWith(data: [
        ...pState.data,
        ...resp.data,
      ]);
    } else {
      state = resp;
    }
    // } catch (e) {
    //   print("error!!! $e");
    //   state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    // }
  }
}
