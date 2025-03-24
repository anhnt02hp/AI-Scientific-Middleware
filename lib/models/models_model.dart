class ModelsModel {
  final String id;
  final String name;
  final int created;

  ModelsModel({
    required this.id,
    required this.name,
    required this.created,
  });

  factory ModelsModel.fromJson(Map<String, dynamic> json){
    return ModelsModel(
      id: json["id"],
      name: json["name"],
      created: json["created"],
    );
  }

  static List<ModelsModel> modelsFromSnapshot (List modelSnapshot) {
    return modelSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }
}