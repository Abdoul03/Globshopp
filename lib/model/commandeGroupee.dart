import 'dart:ffi';

class CommandeGroupee {
  final Long? id;
  CommandeGroupee({this.id});

  factory CommandeGroupee.fromJson(Map<String, dynamic> json) {
    return CommandeGroupee(id: json['id']);
  }

  Map<String, dynamic> toJson() => {'id': id};
}
