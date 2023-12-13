import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umt_timetable/constants/onboarding_data.dart';
import 'package:umt_timetable/model/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currPage = 0;
  late PageController _controller;
  List<OnboardingModel> items = OnboardingData.data;

  onPageChange(int page) {
    currPage = page;
    setState(() {});
  }

  _gotoNext() {
    if (currPage < items.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, '/'); //TODO: Change this
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: PageView.builder(
                onPageChanged: onPageChange,
                itemCount: items.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            //TODO: Add image
                            child: Lottie.asset(
                              items[index].animUrl,
                              repeat: false,
                              reverse: false,
                              animate: false,
                              // frameRate: FrameRate(60),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                items[index].title,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  items[index].description,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: currPage == items.length - 1,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            child: Text('Get Started'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < items.length; i++)
                    if (i == currPage)
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.black,
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.grey,
                        ),
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
