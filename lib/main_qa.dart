import 'package:firebase_core/firebase_core.dart';

import 'firebase_options_qa.dart';
import 'flavors.dart';
import 'main.dart';

void main() async {
  F.appFlavor = Flavor.qa;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await mainCommon();
}
