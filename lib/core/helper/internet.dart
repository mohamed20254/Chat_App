import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnection {
  InternetConnection._();
  static final InternetConnection instance = InternetConnection._();
  Future<bool> checkInternet() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }

  //   // open link
  //   Future<void> mylaunchUrl(final String url, final context) async {
  //     try {
  //       if (url.trim().isNotEmpty) {
  //         if (!await launchUrl(Uri.parse(url))) {
  //           ScaffoldMessenger.of(
  //             context,
  //           ).showSnackBar(const SnackBar(content: Text('Could not launch ')));
  //         }
  //       } else {
  //         ScaffoldMessenger.of(
  //           context,
  //         ).showSnackBar(const SnackBar(content: Text('empty')));
  //       }
  //     } on Exception catch (e) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(e.toString())));
  //     }
  //   }
}
