import 'package:windows_app/models/listy_model.dart';
import 'package:uuid/uuid.dart';

//? default listy list
List<ListyModel> defaultListyList = [
  ListyModel(
    id: const Uuid().v4(),
    title: 'Favorite',
    icon: 'assets/icons/favorite.png',
    createdAt: DateTime.now(),
  ),
];
