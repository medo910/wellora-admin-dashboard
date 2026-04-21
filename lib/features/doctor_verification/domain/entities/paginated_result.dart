class PaginatedResult<T> {
  final List<T> data;
  final int totalCount;
  final bool hasNextPage;
  final int currentPage;

  PaginatedResult({
    required this.data,
    required this.totalCount,
    required this.hasNextPage,
    required this.currentPage,
  });
}
