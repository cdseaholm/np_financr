import 'package:fluttertoast/fluttertoast.dart';

Future showToast(String message) async {
  await Fluttertoast.cancel();

  await Fluttertoast.showToast(
    msg: message,
    fontSize: 18,
  );
}
