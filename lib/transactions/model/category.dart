class Category{
  String? icon;
  String? name;


  Category({this.icon, this.name});

  Category.fromJson(Map<String,dynamic> json) {
    icon = json['icon'];
    name = json['name'];
  }

  Map<String,dynamic> toJson() {
    return {
      if(name != null) 'name':name,
      if(icon != null) 'icon':icon,
    };
  }
}