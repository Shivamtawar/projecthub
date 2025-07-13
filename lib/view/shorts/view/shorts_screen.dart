import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:projecthub/view/shorts/provider/reels_providel.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/view/shorts/model/reel_model.dart';
import 'package:projecthub/view/app_navigation_bar/app_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final PageController _pageController = PageController();
  List<String> videoIds = [];
  List<ReelModel> reels = [];
  int _currentPage = 0;
  bool _isLoading = true;

  // Sample YouTube video IDs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVideos(true);
      _pageController.addListener(() {
        if (_pageController.position.pixels ==
            _pageController.position.maxScrollExtent) {
          fetchMoreReel();
        }
      });
    });
  }

  Future<void> _fetchVideos([bool isFirstCall = false]) async {
    setState(() => _isLoading = true);
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    final reelProvider = Provider.of<ReelsProvider>(context, listen: false);
    if (isFirstCall) {
      reelProvider.reset();
    }
    await reelProvider.fetchReels(userProvider.user!.userId);
    setState(() {
      _isLoading = false;
    });
  }

  fetchMoreReel() async {
    final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
    final reelProvider = Provider.of<ReelsProvider>(context, listen: false);
    await reelProvider.fetchReels(userProvider.user!.userId);
  }

  void _onRefresh() async {
    await _fetchVideos();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const AppNavigationScreen(),
            transition: Transition
                .leftToRightWithFade); // Replace with your actual home screen
        return false;
      },
      child: Scaffold(
          body: Consumer<ReelsProvider>(builder: (context, provider, child) {
        if (_isLoading) {
          return _buildShimmerLoader();
        }
        if (provider.errorMassage != null) {
          return Center(
            child: Text(provider.errorMassage!),
          );
        }
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: provider.reels!.length + 3,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              if (index + 1 < provider.reels!.length) {
                // Preload next video
                final nextId =
                    extractVideoId(provider.reels![index + 1].youtubeLink!);
                YoutubePlayerController tempController =
                    YoutubePlayerController(
                  initialVideoId: nextId,
                  flags: const YoutubePlayerFlags(autoPlay: false),
                );
                tempController.load(nextId);
                Future.delayed(
                    const Duration(seconds: 1), () => tempController.dispose());
              }
              if (index == provider.reels!.length - 2) {
                //   fetchMoreReel();
              }
            },
            itemBuilder: (context, index) {
              if (index >= provider.reels!.length) {
                if (provider.isLoading) {
                  return _buildShimmerLoader();
                }
                return _buildShimmerLoader();
              }
              return VideoItem(
                isCurrent: index == _currentPage,
                reel: provider.reels![index],
              );
            },
          ),
        );
      })),
    );
  }

  Widget _buildShimmerLoader() {
    return Stack(
      children: [
        // Full background placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 33, 33, 33),
        ),
        // Bottom-left: Title and Description
        Positioned(
          left: 16,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 200,
                  height: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 150,
                  height: 14,
                  color: const Color.fromARGB(255, 98, 97, 97),
                ),
              ),
            ],
          ),
        ),
        // Bottom-right: Like, Comment, Share buttons
        Positioned(
          right: 16,
          bottom: 120,
          child: Column(
            children: [
              _shimmerIconBox(), // Like
              const SizedBox(height: 20),
              _shimmerIconBox(), // Comment
              const SizedBox(height: 20),
              _shimmerIconBox(), // Share
              const SizedBox(height: 20),
              _shimmerIconBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerIconBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: const Color.fromARGB(255, 89, 89, 89),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 65, 64, 64),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final ReelModel reel;
  final bool isCurrent;

  const VideoItem({
    required this.isCurrent,
    required this.reel,
    super.key,
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _showControls = false;
  bool _showHeart = false;

  bool isPaying = false;
  double _descriptionHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _descriptionHeight = Get.height * 0.08;
    _controller = YoutubePlayerController(
      initialVideoId: extractVideoId(widget.reel.youtubeLink!),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
        enableCaption: false,
        disableDragSeek: true,
        loop: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && !_controller.value.isFullScreen) {
      if (_controller.value.playerState == PlayerState.ended) {
        _controller.seekTo(Duration.zero);
      }
    }
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reel != widget.reel) {
      _controller.load(extractVideoId(widget.reel.youtubeLink!));
    }
    if (widget.isCurrent && !_controller.value.isPlaying) {
      _controller.play();
    } else if (!widget.isCurrent && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
      },
      onDoubleTap: () {
        Provider.of<ReelsProvider>(context, listen: F).toggleLike(
            widget.reel,
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
            true);
        setState(() {
          _showHeart = true;
        });
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() => _showHeart = false);
        });
      },
      child: Stack(
        children: [
          // YouTube Player
          Positioned.fill(
            child: YoutubePlayer(
              controller: _controller,
              onReady: () {
                isPaying = true;
                setState(() => _isPlayerReady = true);
                if (widget.isCurrent) {
                  _controller.play();
                }
              },
              onEnded: (metaData) {
                _controller.pause();

                if (widget.isCurrent) {
                  final parentState =
                      context.findAncestorStateOfType<_ReelsScreenState>();
                  if (parentState != null &&
                      parentState._currentPage <
                          parentState.videoIds.length - 1) {
                    // Delay the nextPage to avoid modifying listeners during dispose
                    Future.delayed(const Duration(milliseconds: 500), () {
                      parentState._pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    });
                  }
                }
              },
            ),
          ),
          // Thumbnail overlay (shown before player is ready)
          if (!_isPlayerReady)
            CachedNetworkImage(
              imageUrl:
                  'https://img.youtube.com/vi/${extractVideoId(widget.reel.youtubeLink!)}/0.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(color: Colors.black),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.black),
            ),

          // Loading indicator
          if (!_isPlayerReady)
            const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),

          // Video info overlay
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatProper(widget.reel.creationTitle), // creation title
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: _descriptionHeight,
                  child: Text(
                    formatProper(widget
                        .reel.creationDescription), // creation description
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _descriptionHeight =
                          (_descriptionHeight == Get.height * 0.08)
                              ? Get.height * 0.3
                              : Get.height * 0.08;
                    });
                  },
                  child: Text(
                    "... more",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),

          // Side action buttons
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              children: [
                _buildActionButton(
                    (widget.reel.isLikedByUser)
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    (widget.reel.isLikedByUser) ? Colors.red : Colors.white,
                    formatCount(widget.reel.likeCount), () {
                  Provider.of<ReelsProvider>(context, listen: F).toggleLike(
                      widget.reel,
                      Provider.of<UserInfoProvider>(context, listen: false)
                          .user!
                          .userId);
                }, () {
                  _showLikesBottomSheet(context, widget.reel);
                }),
                const SizedBox(height: 20),
                _buildActionButton(
                    Icons.comment, Colors.white, 'Comment', () {}, () {}),
                const SizedBox(height: 20),
                _buildActionButton(
                    Icons.share, Colors.white, 'Share', () {}, () {}),
                const SizedBox(height: 20),
                _buildActionButton(
                    Icons.more_vert, Colors.white, 'More', () {}, () {}),
              ],
            ),
          ),

          // Controls overlay
          if (_showControls && _isPlayerReady)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      isPaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                        isPaying = false;
                      } else {
                        isPaying = true;
                        _controller.play();
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          if (_showHeart)
            Center(
              child: AnimatedOpacity(
                opacity: _showHeart ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.favorite,
                    size: 100, color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, String label, onPressed, onLabelPressed) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onLabelPressed,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 8, left: 10, right: 10, top: 4),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showLikesBottomSheet(BuildContext context, ReelModel reel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LikesBottomSheet(
        reel: reel,
      ),
    );
  }

  String formatProper(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}

class LikesBottomSheet extends StatefulWidget {
  final ReelModel reel;
  const LikesBottomSheet({super.key, required this.reel});

  @override
  State<LikesBottomSheet> createState() => _LikesBottomSheetState();
}

class _LikesBottomSheetState extends State<LikesBottomSheet> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLikesDate();
    });
  }

  fetchLikesDate() async {
    setState(() {
      _isLoading = true;
    });
    final provider = Provider.of<ReelsProvider>(context, listen: false);
    await provider.fetchLikeInfo(widget.reel.creationId, true);

    setState(() {
      _isLoading = false;
    });
  }

  String query = "";

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        final filteredUsers = Provider.of<ReelsProvider>(context, listen: false)
            .reelLikes!
            .where((user) =>
                user.userName!.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${widget.reel.likeCount} Likes",
                style: AppText.heddingStyle2bBlack,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Search by name",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                },
              ),
              const SizedBox(height: 12),
              Consumer<ReelsProvider>(builder: (context, provider, child) {
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredUsers.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredUsers.length &&
                          provider.isLikeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (index == filteredUsers.length) {
                        return const SizedBox.shrink();
                      }
                      final user = filteredUsers[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: (user.profilePhoto != null)
                                ? NetworkImage(
                                    ApiConfig.baseURL + user.profilePhoto!,
                                  )
                                : null,
                            child: (user.profilePhoto == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.black45,
                                  )
                                : null,
                          ),
                          title: Text(user.userName!),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

String extractVideoId(String urlOrId) {
  final uri = Uri.tryParse(urlOrId);
  if (uri == null || !uri.isAbsolute) return urlOrId;

  if (uri.host.contains("youtube.com")) {
    if (uri.pathSegments.contains("watch")) {
      return uri.queryParameters["v"] ?? urlOrId;
    } else if (uri.pathSegments.contains("shorts") ||
        uri.pathSegments.contains("embed") ||
        uri.pathSegments.contains("v")) {
      return uri.pathSegments.last;
    }
  } else if (uri.host.contains("youtu.be")) {
    return uri.pathSegments.first;
  }

  return urlOrId;
}

String formatCount(int count) {
  if (count >= 1000000000) {
    return '${(count / 1000000000).toStringAsFixed(1).replaceAll('.0', '')}B';
  } else if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
  } else {
    return count.toString();
  }
}
