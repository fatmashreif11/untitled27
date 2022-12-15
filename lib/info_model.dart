import 'constants.dart';

class InfoModel {
  int? id;
  String? name;
  String? email;
  String?phone;


  InfoModel({this.name,this.email,this.phone,this.id});




  InfoModel.fromDB(Map<String,dynamic>data){
    id = data[columnID];
    name = data[columnName];
    phone =data[columnPhone];
    email = data[columnEmail];

  }
  Map<String,dynamic>toDB() =>{
    columnName: name,
    columnPhone:phone,
    columnEmail:email,

  };
}