import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:projecthub/view/shorts/controller/shorts_controller.dart';
import 'package:projecthub/view/shorts/model/reel_model.dart';
import 'package:projecthub/model/user_info_model.dart';

class ReelsProvider extends ChangeNotifier {
  final ReelsController _reelsController = ReelsController();
  bool isLoading = false;
  List<ReelModel>? reels = [];
  String? errorMassage;
  int reelOffset = 0;
  int reelLimit = 5;
  int likeOffset = 0;
  int likeLimit = 10;

  bool isLikeLoading = false;
  List<UserModel>? reelLikes;

  setLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  reset() {
    reelOffset = 0;
    reels = [];
    notifyListeners();
  }

  fetchReels(int userId, [bool isFirstCall = false]) async {
    setLoading(true);
    errorMassage = null;

    if (isFirstCall) {
      reset();
    }

    try {
      final newData =
          await _reelsController.fetchReels(userId, reelLimit, reelOffset);
      if (isFirstCall) {
        reels = newData;
      } else {
        reels!.addAll(newData);
      }

      reelOffset += newData.length;
    } catch (e) {
      errorMassage = e.toString();
    }
    setLoading(false);
  }

  void toggleLike(ReelModel reel, int userId, [bool confirmLike = false]) {
    if (confirmLike) {
      if (!reel.isLikedByUser) {
        reel.likeCount++;
      }
      reel.isLikedByUser = true;
      notifyListeners();
      _reelsController.addLike(reel.creationId, userId);
      return;
    }
    reel.isLikedByUser = !reel.isLikedByUser;
    if (reel.isLikedByUser) {
      reel.likeCount++;
      _reelsController.addLike(reel.creationId, userId);
    } else {
      reel.likeCount--;
      _reelsController.removeLike(reel.creationId, userId);
    }
    notifyListeners();
  }

  fetchLikeInfo(int reelId, [bool isFirstCall = false]) async {
    isLikeLoading = true;
    notifyListeners();

    if (isFirstCall) {
      reelLikes = [];
      likeOffset = 0;
    }

    try {
      final newData =
          await _reelsController.getLikeInfo(reelId, likeLimit, likeOffset);
      if (isFirstCall) {
        reelLikes = newData;
      } else {
        reelLikes!.addAll(newData);
      }

      likeOffset += newData.length;
    } catch (e) {
      log(e.toString());
    }
    isLikeLoading = false;
    notifyListeners();
  }
}
