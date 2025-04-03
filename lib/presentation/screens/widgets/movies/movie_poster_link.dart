import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;

  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        // ✅ Navigate to movie details page when tapped
        onTap: () => context.push('/movie/${movie.id}'),
        child: Column(
          children: [
            ClipRRect(
              // ✅ Adds rounded corners to the image
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                // ✅ Maintains a 2:3 vertical aspect ratio (typical for movie posters)
                aspectRatio: 2 / 3,
                child: Image.network(
                  movie.posterPath, // ✅ Movie poster URL
                  fit: BoxFit.cover, // ✅ Ensures the image covers the container

                  // ✅ Shows a loading indicator while the image is being fetched
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image fully loaded
                    }

                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null, // Shows progress percentage if available
                      ),
                    );
                  },

                  // ✅ Handles errors (e.g., broken image URLs)
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300], // ✅ Placeholder background
                      child: const Icon(Icons.broken_image,
                          size: 50,
                          color: Colors.grey), // ✅ Displays broken image icon
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
