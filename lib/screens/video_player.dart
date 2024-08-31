

// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPortfolioScreen extends StatefulWidget {
//   const VideoPortfolioScreen({super.key});

//   @override
//   State<VideoPortfolioScreen> createState() => _VideoPortfolioScreenState();
// }

// class _VideoPortfolioScreenState extends State<VideoPortfolioScreen> {
//   late VideoPlayerController _controller;
//   late ChewieController _chewieController;
//   // late Future<void> _initializePlayer;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _controller.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }

//   void initController() async {
//     _controller = VideoPlayerController.network(
//         'https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data_7MB_MP4.mp4');
//     await _controller.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     initController();
//     _chewieController = ChewieController(
//         videoPlayerController: _controller, autoPlay: true, looping: true);
//     return Scaffold(
//         body: SafeArea(
//             child: Center(
//       child: AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: Chewie(
//             controller: _chewieController,
//           )),
//     )));
//   }
// }





import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPortfolioScreen extends StatefulWidget {
 

  const VideoPortfolioScreen({ Key? key})
      : super(key: key);

  @override
  _VideoPortfolioScreenState createState() => _VideoPortfolioScreenState();
}

class _VideoPortfolioScreenState extends State<VideoPortfolioScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
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
              Text('hehe'),
            Center(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                progressColors: ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
                onReady: () {
                 
                },
                onEnded: (_) {
                  // Add any custom logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


