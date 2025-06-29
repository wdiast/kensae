class VDataItem {
  final Map<String, dynamic> data;
  VDataItem({required this.data});

  factory VDataItem.fromJson(Map<String, dynamic> json) => VDataItem(data: json);
}
