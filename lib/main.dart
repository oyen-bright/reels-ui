import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reels_ui/cubit/showreelstitle_cubit.dart';
import 'package:sizedbox_extention/sizedbox_extention.dart';
import 'package:video_player/video_player.dart';

import 'cubit/opacity_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reels Ui',
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ShowreelstitleCubit>(
            create: (context) => ShowreelstitleCubit(),
          ),
          BlocProvider<OpacityCubit>(
            create: (context) => OpacityCubit(),
          ),
        ],
        child: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ScrollController scrollController;
  late final PageController pageController;
  late VideoPlayerController _controller;

  @override
  void initState() {
    scrollController = ScrollController();
    pageController = PageController();
    int currentPage = 0;

    super.initState();

    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {
          _controller.play();
        });
      });

    pageController.addListener(() {
      print(pageController.offset);

      if (pageController.page!.round() != currentPage) {
        currentPage = pageController.page!.round();
        Timer(const Duration(milliseconds: 300), () {
          if (pageController.position.userScrollDirection ==
              ScrollDirection.forward) {
            context.read<ShowreelstitleCubit>().showreelTitle(true);
          } else {
            context.read<ShowreelstitleCubit>().showreelTitle(false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                child: _controller.value.isInitialized
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 200,
                                  ),
                                ),
                                BlocBuilder<OpacityCubit, double>(
                                  builder: (context, state) {
                                    return Opacity(
                                      opacity: state,
                                      child: SizedBox(
                                        height: 350,
                                        width: 50,
                                        child: Column(
                                          children: [
                                            const SideBarWidget(
                                              icondata: FontAwesomeIcons.heart,
                                              text: "62.3k",
                                            ),
                                            20.height,
                                            const SideBarWidget(
                                              icondata:
                                                  FontAwesomeIcons.comment,
                                              text: "804",
                                            ),
                                            20.height,
                                            const SideBarWidget(
                                              icondata:
                                                  FontAwesomeIcons.paperPlane,
                                              text: "",
                                            ),
                                            15.height,
                                            const SideBarWidget(
                                              icondata: Icons.more_horiz,
                                              text: "",
                                            ),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.network(
                                                  "https://avatars.githubusercontent.com/u/35768100?s=40&v=4"),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    : Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
              Container(
                color: Colors.pink,
              )
            ],
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: BlocBuilder<ShowreelstitleCubit, bool>(
                      builder: (context, state) {
                        return Visibility(
                          visible: state,
                          child: Text(
                            "Reels",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                  const FaIcon(
                    FontAwesomeIcons.camera,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({
    super.key,
    required this.icondata,
    required this.text,
  });
  final IconData icondata;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(
          icondata,
          color: Colors.white,
          size: 30,
        ),
        5.height,
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        )
      ],
    );
  }
}
