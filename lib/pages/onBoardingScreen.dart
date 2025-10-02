import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen({
    super.key,

    });

  

  State<OnBoardingScreen> createState()=> _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>{
  late PageController _pageController;

  @override
  void initState(){
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index)=> OnBoardContent(
                text1: '1 Страница', 
                text2: '2 Страница'
              ),
            )),
            SizedBox(
              height: 60,
              width: 60,
              child: ElevatedButton(onPressed: (){
                _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
              }, child: Icon(Icons.arrow_right_alt_outlined)),
            )
          ],
        )), 
    );
  }
}

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.text1,
    required this.text2,
  });

  final String  text1, text2;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(text1),
            const Spacer(),
            Text(text2),
          ],
        )
        ),
    );
  }
  
}