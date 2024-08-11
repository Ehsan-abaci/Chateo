import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../../model/user.dart';

var di = GetIt.instance;

 Future<void> initAppModule() async {
  final dir = await path.getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [UsersSchema],
    directory: dir.path,
  );

  di.registerLazySingleton(() => isar);
}
