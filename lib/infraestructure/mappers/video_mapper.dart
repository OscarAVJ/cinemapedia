import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_video_response.dart';

class VideoMapper {
  static moviedbVideoToEntity(Result moviedbVideo) => Video(
      id: moviedbVideo.id,
      name: moviedbVideo.name,
      youtubeKey: moviedbVideo.key,
      publishedAt: moviedbVideo.publishedAt);
}
