import 'package:flutter/material.dart';

class EarthView extends StatefulWidget {
  const EarthView({Key? key}) : super(key: key);

  @override
  State<EarthView> createState() => _EarthViewState();
}

class _EarthViewState extends State<EarthView> {
  bool _bigger = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           GestureDetector(
             onTap: () {
               setState(() {
                 _bigger = !_bigger;
               });
             },
             child: AnimatedContainer(
               height: _bigger ? 100 : 500,
               alignment: Alignment.center,
               curve: Curves.fastOutSlowIn,
               color: Colors.transparent,
               duration: const Duration(milliseconds: 500),
               child: TweenAnimationBuilder(
                   tween: Tween<double>(
                     begin: 0,
                     end:  1000),
                 duration: const Duration(seconds: 1000),
                   builder: (context,double value, child) {
                     return Transform.rotate(
                         angle: value,
                         child: Image.asset("assets/images/earth.png"));
                   },
               ),
             ),
           )
            ],
          ),
        ),
      ),
    );
  }
}
