import 'package:firebase_core/firebase_core.dart';
import 'package:imdumb/firebase_options_prod.dart';
import 'flavors.dart';
import 'main.dart';

void main() async {
  F.appFlavor = Flavor.prod;

  await Firebase.initializeApp(options: ProdFirebaseOptions.currentPlatform);

  await mainCommon();
}
