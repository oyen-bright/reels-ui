import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
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

List<String> reelsUrl = [
  "https://assets.mixkit.co/videos/preview/mixkit-man-under-colored-lights-1241-large.mp4",
  "https://assets.mixkit.co/videos/preview/mixkit-silhouette-of-urban-dancer-in-smoke-33898-large.mp4",
  "https://assets.mixkit.co/videos/preview/mixkit-cheerful-man-moves-forward-dancing-in-the-middle-of-nature-32746-large.mp4",
  "https://assets.mixkit.co/videos/preview/mixkit-man-runs-past-ground-level-shot-32809-large.mp4"
];

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

  @override
  void initState() {
    scrollController = ScrollController();
    pageController = PageController();
    int currentPage = 0;

    super.initState();

    pageController.addListener(() {
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
      color: Colors.transparent,
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: List.generate(reelsUrl.length,
                (index) => ReelWidget(videoUrl: reelsUrl[index])),
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

class ReelWidget extends StatefulWidget {
  const ReelWidget({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<ReelWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Image.network(
                                          "https://avatars.githubusercontent.com/u/35768100?s=40&v=4"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text("swimming_pictures",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                  ),
                                  Container(
                                    height: 25,
                                    alignment: Alignment.center,
                                    width: 65,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.white,
                                        )),
                                    child: Text(
                                      "Follow",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              10.height,
                              SizedBox(
                                width: double.infinity,
                                child: AutoSizeText(
                                  "I know it looks scary but because of there things and all ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              10.height,
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.music,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text("swimming_pictures",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: Colors.white)),
                                  ),
                                  Container(
                                    height: 2,
                                    width: 2,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text("Original audio",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          ),
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SideBarWidget(
                                    icondata: FontAwesomeIcons.heart,
                                    text: "62.3k",
                                  ),
                                  20.height,
                                  const SideBarWidget(
                                    icondata: FontAwesomeIcons.comment,
                                    text: "804",
                                  ),
                                  20.height,
                                  const SideBarWidget(
                                    icondata: FontAwesomeIcons.paperPlane,
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
                                            BorderRadius.circular(10)),
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
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black26])),
                )
              ],
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
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
