class SliderDetails {
  final String imageUrl;
  final int id;

  SliderDetails({required this.id, required this.imageUrl});

  static SliderDetails fromJson(Map<String, dynamic> json) {
    return SliderDetails(
      id: json['id'] ?? 0,
      imageUrl: json['image'] ?? "",
    );
  }
}
