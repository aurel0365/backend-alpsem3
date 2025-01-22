import 'package:flutter/material.dart';
import 'package:flutter_pete/pov_customer/screen/LayarLogo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Ukuran desain (sesuaikan dengan kebutuhan)
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LogoScreen(), // Mulai dengan LogoScreen
        );
      },
    );
  }
}